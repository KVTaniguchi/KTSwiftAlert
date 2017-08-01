//
//  URBNSwiftAlertViewController.swift
//  Pods
//
//  Created by Kevin Taniguchi on 5/22/17.
//
//
import URBNSwiftyConvenience

open class AlertViewController: UIViewController {
    public var alertConfiguration = AlertConfiguration()
    public var alertStyler = AlertController.shared.alertStyler {
        didSet {
            alertConfiguration.styler = self.alertStyler
        }
    }
    
    /**
     *  Initialize with a title and / or message
     *
     *  @param title   Optional. The title text displayed in the alert
     *  @param message Optional. The message text displayed in the alert
     *
     *
     *  @return A URBNSwiftAlertViewController ready to be configurated further or displayed
     */
    
    public convenience init(title: String? = nil, message: String? = nil) {
        self.init(type: .fullStandard, title: title, message: message)
    }
    
    /**
     *  Initialize with a custom view
     *
     *  @param customView Required.  A UIView or UIView subclass.  Any actions added will generate standard URBNSwAlert Buttons
     *
     *  @return A URBNSwiftAlertViewController with a custom view ready to be configurated further or displayed
     */
    
    public convenience init(customView: UIView) {
        self.init(type: .customView, customView: customView)
    }
    
    /**
     *  Initialize with a title / message / and a AlertButtonContainer
     *
     *  @param customButtons Required.  A UIView that conforms to the AlertButtonContainer protocol
     *  @param title   Optional. The title text displayed in the alert
     *  @param message Optional. The message text displayed in the alert
     *
     *  @return A URBNSwiftAlertViewController with custom buttons ready to be configurated further or displayed
     */
    
    public convenience init(title: String? = nil, message: String? = nil, customButtons: AlertButtonContainer) {
        self.init(type: .customButton, title: title, message: message, customButtons: customButtons)
    }
    
    /**
     *  Initialize with a custom UIView and a AlertButtonContainer
     *
     *  @param customButtons Required.  A UIView that conforms to the AlertButtonContainer protocol
     *  @param customView  Required. A custom UIView
     *
     *  @return A URBNSwiftAlertViewController with a custom view and custom buttons ready to be configurated further or displayed
     */
    
    public convenience init(customView: UIView, customButtons: AlertButtonContainer) {
        self.init(type: .fullCustom, customView: customView, customButtons: customButtons)
    }
    
    private init(type: URBNSwAlertType, title: String? = nil, message: String? = nil, customView: UIView? = nil, customButtons: AlertButtonContainer? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        alertConfiguration.type = type
        alertConfiguration.title = title
        alertConfiguration.message = message
        alertConfiguration.customView = customView
        alertConfiguration.customButtons = customButtons
        
        if let customActions = customButtons?.actions {
            alertConfiguration.actions = customActions
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let ac = alertView else {
            assertionFailure("failed to unwrap an alertContainer")
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notif:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notif:)), name: .UIKeyboardWillHide, object: nil)
        
        setUpBackground()
        layout(alertContainer: ac)
        
        setVisible(isVisible: true) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.alertConfiguration.textFields.first?.becomeFirstResponder()
        }
        
        if alertConfiguration.touchOutsideToDismiss {
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAlert(sender:)))
            view.addGestureRecognizer(tap)
        }
    }
    
    var dismissingHandler: ((Bool) -> Void)?
    fileprivate var alertView: AlertView?
    fileprivate var blurImageView: UIImageView?
    fileprivate var alertController = AlertController.shared
    fileprivate var alertViewYContraint: NSLayoutConstraint?
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Layout and Animations
extension AlertViewController {
    func setUpBackground() {
        if alertStyler.blur.isEnabled {
            addBlurScreenshot()
        }
        else if let bgTintColor = alertStyler.background.tint {
            view.backgroundColor = bgTintColor
        }
    }
    
    func layout(alertContainer: UIView) {
        alertContainer.alpha = 0.0
        
        view.addSubviewsWithNoConstraints(alertContainer)
        if alertConfiguration.type != .customView && alertConfiguration.type != .fullCustom {
            if let minMax = alertStyler.alert.minMaxWidth {
                alertContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: minMax.min).isActive = true
                alertContainer.widthAnchor.constraint(lessThanOrEqualToConstant: minMax.max).isActive = true
            }
            else {
                alertContainer.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - alertStyler.alert.horizontalMargin*2).isActive = true
            }
        }
        alertContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alertViewYContraint = alertContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        alertViewYContraint?.isActive = true
    }
    
    func setVisible(isVisible: Bool, completion: ((Void) -> Void)? = nil) {
        let scaler: CGFloat = 0.3
        guard let ac = alertView else {
            assertionFailure()
            return
        }
        
        if isVisible {
            ac.alpha = 0.0
            ac.transform = CGAffineTransform(scaleX: scaler, y: scaler)
        }
        
        let alpha: CGFloat = isVisible ? 1.0 : 0.0
        let endingTransform = isVisible ? CGAffineTransform.identity : CGAffineTransform(scaleX: scaler, y: scaler)
        
        let bounceAnimation = {
            ac.transform = endingTransform
        }
        
        let fadeAnimation = { [unowned self] in
            ac.alpha = alpha
            if self.alertStyler.blur.isEnabled {
                self.blurImageView?.alpha = alpha
            }
        }
        
        if alertStyler.animation.isAnimated {
            let duration = TimeInterval(alertStyler.animation.duration)
            let damping = alertStyler.animation.damping
            let initVel = isVisible ? 0 : alertStyler.animation.initialVelocity
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: initVel, options: [], animations: bounceAnimation, completion: { (complete) in
                if complete {
                    completion?()
                }
            })
            
            UIView.animate(withDuration: duration/2, animations: fadeAnimation)
        }
        else {
            fadeAnimation()
            bounceAnimation()
            completion?()
        }
    }
    
    func addBlurScreenshot(withSize size: CGSize? = nil) {
        if let screenShot = UIImage.screenShot(view: viewForScreenshot, afterScreenUpdates: true) {
            let blurredSize = size ?? viewForScreenshot.bounds.size
            
            let rect = CGRect(x: 0, y: 0, width: blurredSize.width, height: blurredSize.height)
            
            blurImageView = UIImageView(frame: rect)
            blurImageView?.image = screenShot
            let blurEffect = UIBlurEffect(style: .light)
            let blurView = UIVisualEffectView(effect: blurEffect)
            
            if let imgV = blurImageView {
                blurView.frame = imgV.bounds
                imgV.addSubview(blurView)
                imgV.wrap(in: view, with: InsetConstraints(insets: UIEdgeInsets.zero, priority: UILayoutPriorityRequired))
            }
        }
    }
    
    var viewForScreenshot: UIView {
        return alertConfiguration.presentationView ?? alertController.presentingWindow
    }
}

// MARK: Show and Dismiss
extension AlertViewController {
    public func show() {
        alertView = AlertView(configuration: alertConfiguration)
        
        if !alertConfiguration.actions.isEmpty {
            switch alertConfiguration.type {
            case .fullStandard, .customView:
                alertView?.addActions(alertConfiguration.actions)
            case .customButton, .fullCustom:
                break
            }
            
            for action in alertConfiguration.actions {
                if action.shouldDismiss {
                    action.button?.addTarget(self, action: #selector(dismissAlert(sender:)), for: .touchUpInside)
                }
            }
            
            if !alertConfiguration.isActiveAlert || alertConfiguration.tapInsideToDismiss {
                let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAlert(sender:)))
                alertView?.addGestureRecognizer(tap)
            }
        }
        
        alertController.addAlertToQueue(avc: self)
    }
    
    public func show(inView view: UIView) {
        alertConfiguration.presentationView = view
        show()
    }
    
    public func dismissAlert(sender: Any) {
        view.endEditing(true)
        
        if !alertConfiguration.isActiveAlert && alertConfiguration.type != .customButton && alertConfiguration.type != .fullCustom {
            for action in alertConfiguration.actions {
                action.completeAction()
            }
        }
        
        // tell controller to remove top controller and show next alert
        alertController.popQueueAndShowNextIfNecessary()
        
        setVisible(isVisible: false) {  [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: false, completion: nil)
            strongSelf.dismissingHandler?(sender is UITapGestureRecognizer)
        }
    }
}

// MARK: Actions and Textfields
extension AlertViewController {
    @available(*, unavailable, message: "use addActions instead")
    public func addAction(_ action: AlertAction) {}
    
    public func addActions(_ actions: AlertAction...) {
        addActions(actions)
    }
    
    public func addActions(_ actions: [AlertAction]) {
        alertConfiguration.actions += actions
        let hasActiveAction = !actions.filter{$0.type != .passive}.isEmpty
        alertConfiguration.isActiveAlert = hasActiveAction
    }
    
    public func addTextfield(configurationHandler: ((UITextField) -> Void)) {
        alertConfiguration.isActiveAlert = true
        let tf = UITextField()
        alertConfiguration.textFields.append(tf)
        configurationHandler(tf)
    }
    
    public var textField: UITextField? {
        return alertConfiguration.textFields.first
    }
    
    public func textField(atIndex index: Int) -> UITextField? {
        guard index < alertConfiguration.textFields.count else { return nil }
        return alertConfiguration.textFields[index]
    }
    
    public func showTextFieldError(message: String) {
        alertView?.show(errorMessage: message)
    }
}

// MARK: Keyboard management
extension AlertViewController {
    func keyboardWillShow(notif: Notification) {
        if let value = notif.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue, let av = alertView  {
            let kbFrame = value.cgRectValue
            let alertViewBottomYPos = av.frame.height + av.frame.origin.y
            let offSet = -(alertViewBottomYPos - kbFrame.origin.y)
            if offSet < 0 {
                alertViewYContraint?.constant = offSet - 30
            }
            
            UIView.animate(withDuration: TimeInterval(0.1) , animations: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.view.layoutIfNeeded()
            })
        }
    }
    
    func keyboardWillHide(notif: Notification) {
        alertViewYContraint?.constant = 0
        
        UIView.animate(withDuration: TimeInterval(0.1) , animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.view.layoutIfNeeded()
        })
    }
}

enum URBNSwAlertType {
    case fullCustom, customView, customButton, fullStandard
}
