//
//  AlertView.swift
//  Pods
//
//  Created by Kevin Taniguchi on 5/22/17.
//
//
import Foundation
import URBNSwiftyConvenience

class AlertView: UIView {
    fileprivate lazy var titleLabel = UILabel()
    fileprivate lazy var messageView = UITextView()
    fileprivate lazy var textFieldErrorLabel = UILabel()
    fileprivate let stackView = UIStackView()
    fileprivate lazy var buttonsSV = UIStackView()
    fileprivate lazy var buttonActions = [AlertAction]()
    var configuration: AlertConfiguration
    
    init(configuration: AlertConfiguration) {
        self.configuration = configuration
        
        super.init(frame: CGRect.zero)
        
        backgroundColor = configuration.styler.background.color
        layer.cornerRadius = configuration.styler.alert.cornerRadius
        layer.shadowRadius = configuration.styler.alertViewShadow.radius
        layer.shadowOpacity = configuration.styler.alertViewShadow.opacity
        layer.shadowOffset = configuration.styler.alertViewShadow.offset
        layer.shadowColor = configuration.styler.alertViewShadow.color.cgColor
        
        stackView.axis = .vertical
        
        var insets: UIEdgeInsets
        var spacing: CGFloat
        
        switch configuration.type {
        case .fullStandard:
            addStandardComponents()
            addButtons()
            insets = configuration.styler.alert.insets
            spacing = configuration.styler.alert.labelVerticalSpacing
        case .customButton:
            addStandardComponents()
            addCustomButtons()
            insets = configuration.styler.alert.insets
            spacing = configuration.styler.alert.labelVerticalSpacing
        case .customView:
            addCustomView()
            addButtons()
            insets = UIEdgeInsets.zero
            spacing = 0.0
        case .fullCustom:
            addCustomView()
            addCustomButtons()
            insets = UIEdgeInsets.zero
            spacing = 0.0
        }
        
        stackView.spacing = spacing
        
        stackView.wrap(in: self, with: InsetConstraints(insets: insets, priority: UILayoutPriorityDefaultHigh))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup and add UI
extension AlertView {
    func addStandardComponents() {
        if let title = configuration.title, !title.isEmpty {
            titleLabel.backgroundColor = configuration.styler.title.backgroundColor
            titleLabel.textAlignment = configuration.styler.title.alignment
            titleLabel.font = configuration.styler.title.font
            titleLabel.numberOfLines = 2
            titleLabel.lineBreakMode = .byWordWrapping
            titleLabel.textColor = configuration.styler.title.color
            titleLabel.text = title
            stackView.addArrangedSubview(titleLabel.wrapInNewView(with: configuration.styler.title.insetConstraints))
        }
        
        if let message = configuration.message, !message.isEmpty {
            messageView.backgroundColor = configuration.styler.message.backgroundColor
            messageView.textAlignment = configuration.styler.message.alignment
            messageView.font = configuration.styler.message.font
            messageView.textColor = configuration.styler.message.color
            messageView.isEditable = false
            messageView.text = message
            
            let buttonH = configuration.customButtons?.containerViewHeight ?? configuration.styler.button.height
            let maxTextViewH = UIScreen.main.bounds.height - titleLabel.intrinsicContentSize.height - 150.0 - (configuration.styler.alert.insets.top) * 2 - buttonH
            let maxWidth = UIScreen.main.bounds.width - (configuration.styler.alert.insets.left + configuration.styler.alert.insets.right) - configuration.styler.alert.horizontalMargin*2
            let messageSize = messageView.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
            let maxHeight = messageSize.height > maxTextViewH ? maxTextViewH : messageSize.height
            
            messageView.heightAnchor.constraint(equalToConstant: maxHeight).isActive = true
            stackView.addArrangedSubview(messageView.wrapInNewView(with: configuration.styler.message.insetConstraints))
        }
        
        if !configuration.textFields.isEmpty {
            let textFieldsSV = UIStackView(arrangedSubviews: configuration.textFields)
            textFieldsSV.axis = .vertical
            textFieldsSV.spacing = configuration.styler.textField.verticalMargin
            for tf in configuration.textFields {
                tf.returnKeyType = .done
                tf.delegate = self
            }
            
            stackView.addArrangedSubview(textFieldsSV)
            
            textFieldErrorLabel.numberOfLines = 0
            textFieldErrorLabel.lineBreakMode = .byWordWrapping
            textFieldErrorLabel.textColor = configuration.styler.textField.errorMessageColor
            textFieldErrorLabel.font = configuration.styler.textField.errorMessageFont
            stackView.addArrangedSubview(textFieldErrorLabel)
            textFieldErrorLabel.isHidden = true
        }
    }
    
    func addButtons() {
        buttonsSV.axis = configuration.actions.count < 3 ? configuration.styler.button.layoutAxis : .vertical
        buttonsSV.distribution = .fillEqually
        buttonsSV.spacing = configuration.styler.button.spacing
        stackView.addArrangedSubview(buttonsSV.wrapInNewView(with: configuration.styler.button.containerInsetConstraints))
    }
    
    func addCustomView() {
        if let customView = configuration.customView {
            stackView.addArrangedSubview(customView)
        }
    }
    
    func addCustomButtons() {
        if let customButtons = configuration.customButtons as? UIView {
            stackView.addArrangedSubview(customButtons)
        }
    }
}

extension AlertView: AlertButtonContainer {
    
    var actions: [AlertAction] {
        return buttonActions
    }
    
    public func show(errorMessage: String) {
        textFieldErrorLabel.isHidden = false
        textFieldErrorLabel.text = errorMessage
    }
    
    public func addActions(_ actions: [AlertAction]) {
        for action in actions {
            if action.type != .passive {
                let button = AlertButton(styler: configuration.styler, action: action)
                button.heightAnchor.constraint(equalToConstant: configuration.styler.button.height).isActive = true
                buttonsSV.addArrangedSubview(button)
                action.add(button: button)
            }
        }
    }
}

extension AlertView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charCount = textField.text?.characters.count ?? 0
        if let charCount = textField.text?.characters.count, range.length + range.location > charCount {
            return false
        }
        
        let newLength = charCount + string.characters.count - range.length
        
        return newLength < configuration.styler.textField.maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
