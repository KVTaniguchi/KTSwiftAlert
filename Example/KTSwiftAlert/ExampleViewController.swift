//
//  ViewController.swift
//  URBNSwiftAlert
//
//  Created by Kevin Taniguchi on 05/23/2017.
//  Copyright (c) 2017 Kevin Taniguchi. All rights reserved.
//

import UIKit

import URBNSwiftyConvenience
import URBNSwiftAlert

class ExampleViewController: UIViewController {
    
    func showOneButtonAlert() {
        let oneBtnAlert = AlertViewController(title: wrappingTitle, message: longMessage)
        oneBtnAlert.addActions(genericDoneAction)
        oneBtnAlert.show()
    }
    
    func showTwoBtnAlert() {
        let twoBtnAlert = AlertViewController(title: wrappingTitle, message: longMessage)
        twoBtnAlert.addActions([genericCancelAction, genericDoneAction])
        twoBtnAlert.show()
    }
    
    func showCustomStyleAlert() {
        let customStyleAlert = AlertViewController(title: "Custom Styled Alert", message: "You can change fonts, colors, buttons, size, corner radius, and more.")
        let destructiveAction = AlertAction(type: .destructive, shouldDismiss: true, isEnabled: false, title: "Destruct") { (action) in
            print("destructive button pressed")
        }
        customStyleAlert.addActions([genericCancelAction, genericDoneAction, destructiveAction])
        customStyleAlert.alertStyler.alert.minMaxWidth = (min: 44, max: 250)
        customStyleAlert.alertStyler.background.color = .orange
        customStyleAlert.alertStyler.title.font = UIFont(name: "Chalkduster", size: 30) ?? UIFont.systemFont(ofSize: 12)
        customStyleAlert.alertStyler.alert.cornerRadius = 5.0
        customStyleAlert.alertStyler.alertViewShadow.color = .purple
        customStyleAlert.alertStyler.alertViewShadow.offset = CGSize(width: 5, height: 5)
        customStyleAlert.alertStyler.alertViewShadow.radius = 5.0
        customStyleAlert.alertStyler.alertViewShadow.opacity = 0.9
        customStyleAlert.alertStyler.cancelButton.titleColor = .magenta
        customStyleAlert.alertStyler.button.shadowColor = .red
        customStyleAlert.alertStyler.button.shadowOffset = CGSize(width: 10, height: 10)
        customStyleAlert.alertStyler.button.shadowRadius = 10
        customStyleAlert.alertStyler.button.shadowOpacity = 0.9
        customStyleAlert.alertStyler.button.backgroundColor = .cyan
        customStyleAlert.alertStyler.cancelButton.backgroundColor = .brown
        customStyleAlert.alertStyler.message.font = UIFont(name: "AmericanTypewriter-Bold", size: 15)
        customStyleAlert.alertStyler.button.highlightTitleColor = .green
        customStyleAlert.alertStyler.cancelButton.highlightTitleColor = .blue
        customStyleAlert.alertStyler.button.selectedTitleColor = .yellow
        customStyleAlert.show()
    }
    
    func showCustomViewAlert() {
        let customViewAlert = AlertViewController(customView: customView)
        customViewAlert.addActions(genericCancelAction, genericDoneAction)
        customViewAlert.alertConfiguration.tapInsideToDismiss = true
        customViewAlert.show()
    }
    
    func showQueuedAlerts() {
        let firstAlert = AlertViewController(title: "I'm the first alert", message: longMessage)
        firstAlert.addActions(genericDoneAction)
        firstAlert.show()
        
        let secondAlert = AlertViewController(title: "I'm the second alert", message: longMessage)
        secondAlert.alertStyler.background.color = .brown
        secondAlert.alertStyler.title.font = UIFont(name: "Chalkduster", size: 30) ?? UIFont.systemFont(ofSize: 12)
        secondAlert.addActions(genericCancelAction, genericDoneAction)
        secondAlert.show()
        
        let thirdAlert = AlertViewController(title: "I'm the third alert", message: "Short message", customButtons: ExampleCustomButtons())
        thirdAlert.show()
    }
    
    func showInputsAlert() {
        let textFieldsAlert = AlertViewController(title: "Textfields Alert", message: "Enter some info:")
        
        textFieldsAlert.addTextfield { (textField) in
            textField.borderStyle = .line
            textField.placeholder = "Email"
        }
        
        textFieldsAlert.addTextfield { (textField) in
            textField.borderStyle = .line
            textField.placeholder = "Password"
        }
        
        textFieldsAlert.addTextfield { (textField) in
            textField.borderStyle = .line
            textField.placeholder = "Confirm"
        }
        
        let textFieldsAlertAction = AlertAction(type: .normal, title: "Done") { (action) in
            print("textfield 0 \(textFieldsAlert.textField?.text ?? "")")
            print("textfield 1 \(textFieldsAlert.textField(atIndex: 1)?.text ?? "")")
            print("textfield 2 \(textFieldsAlert.textField(atIndex: 2)?.text ?? "")")
        }
        
        textFieldsAlert.addActions(textFieldsAlertAction)
        textFieldsAlert.show()
    }
    
    func showFullCustomAlert() {
        let customButtons = ExampleCustomButtons()
        let fullCustomViewAlert = AlertViewController(customView: customView, customButtons: customButtons)
        fullCustomViewAlert.alertConfiguration.tapInsideToDismiss = true
        fullCustomViewAlert.show()
    }
    
    func showValidateInputAlert() {
        let validateAlert = AlertViewController(title: "Textfield Validation", message: "Text must be > 4")
        let validateCancelAction = AlertAction(type: .cancel, title: "Cancel") { (action) in
            print("validate action cancelled")
        }
        
        validateAlert.addTextfield { (textfield) in
            textfield.borderStyle = .line
            textfield.placeholder = "enter a string"
        }
        
        let validateDoneAction = AlertAction(type: .normal, shouldDismiss: false, isEnabled: true, title: "Done") { (action) in
            
            guard let text = validateAlert.textField?.text, text.characters.count < 5 else {
                validateAlert.dismissAlert(sender: self)
                return
            }
            validateAlert.showTextFieldError(message: "Error! You must enter more than 4 characters.  You must now cancel to close.")
            action.button?.isEnabled = false
        }
        
        validateAlert.addActions(validateCancelAction, validateDoneAction)
        validateAlert.show()
    }
    
    func showSimpleLongPassiveAlert() {
        let passiveAlert = AlertViewController(title: "Simple Passive", message: longMessage)
        passiveAlert.alertConfiguration.touchOutsideToDismiss = true
        
        let passiveAction = AlertAction(type: .passive) { (action) in
            print("long passive action")
        }
        
        passiveAlert.addActions(passiveAction)
        passiveAlert.show()
    }
    
    func showSimpleShortPassiveAlert() {
        let passiveAlert = AlertViewController(title: "Simple Passive", message: "Very short alert. Minimum 2 second duration.")
        passiveAlert.alertConfiguration.touchOutsideToDismiss = true
        passiveAlert.alertConfiguration.duration = 2.0
        passiveAlert.show()
    }
    
    func showPassiveCustomAlert() {
        let passiveCustomAlert = AlertViewController(customView: customView)
        passiveCustomAlert.alertConfiguration.duration = 5.0
        passiveCustomAlert.alertConfiguration.touchOutsideToDismiss = true
        passiveCustomAlert.show()
    }
    
    func showPassiveQueuedAlerts() {
        let firstPassiveAlert = AlertViewController(title: "First Alert", message: "Will auto dismiss in 3 seconds")
        firstPassiveAlert.alertConfiguration.touchOutsideToDismiss = true
        firstPassiveAlert.alertConfiguration.duration = 3.0
        
        let secondPassiveAlert = AlertViewController(customView: customView)
        secondPassiveAlert.alertConfiguration.touchOutsideToDismiss = true
        let secondAction = AlertAction(type: .passive) { (action) in
            print("second passive action")
        }
        secondPassiveAlert.addActions(secondAction)
        
        let thirdPassiveAlert = AlertViewController(title: "Final alert", message: "Touch to dismiss")
        thirdPassiveAlert.alertConfiguration.touchOutsideToDismiss = true
        
        firstPassiveAlert.show()
        secondPassiveAlert.show()
        thirdPassiveAlert.show()
    }
    
    func showFromModal() {
        let vc = ExampleViewController()
        let nav = UINavigationController(rootViewController: vc)
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closePressed))
        present(nav, animated: true, completion: nil)
    }
    
    func showFromView() {
        let customViewAlert = AlertViewController(customView: customView)
        customViewAlert.alertConfiguration.touchOutsideToDismiss = true
        customViewAlert.show(inView: presentationView)
    }
    
    func closePressed() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Example UI Components
    let presentationView = UIView()
    var exampleButtons: [[UIButton]]?
    var exampleSectionLabels: [[UILabel]]?
    var collectionView: UICollectionView?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        
        layoutExampleButtons()
    }
}

// MARK: Layout Example Buttons
extension ExampleViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func layoutExampleButtons() {
        let btnsMapper: ([String: Selector], UIColor) -> [UIButton] = { (dict, color) in
            return dict.map({ (entry) -> UIButton in
                let btn = UIButton(type: .custom)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
                btn.setTitle(entry.key, for: .normal)
                btn.addTarget(self, action: entry.value, for: .touchUpInside)
                btn.backgroundColor = color
                btn.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
                return btn
            }).sorted{$0.titleLabel?.text?.characters.count ?? 0 < $1.titleLabel?.text?.characters.count ?? 1}
        }
        
        let allActiveExampleButtons = btnsMapper(["1 Button": #selector(ExampleViewController.showOneButtonAlert),
                                                  "2 Buttons": #selector(ExampleViewController.showTwoBtnAlert),
                                                  "Custom Style": #selector(ExampleViewController.showCustomStyleAlert),
                                                  "Custom View": #selector(ExampleViewController.showCustomViewAlert),
                                                  "Queued Alerts ": #selector(ExampleViewController.showQueuedAlerts),
                                                  "Text Field Inputs": #selector(ExampleViewController.showInputsAlert),
                                                  "All Custom Views": #selector(ExampleViewController.showFullCustomAlert),
                                                  "Text Field Validate": #selector(ExampleViewController.showValidateInputAlert)], .blue)
        
        let allPassiveExampleButtons = btnsMapper(["Simple Long": #selector(ExampleViewController.showSimpleLongPassiveAlert),
                                                   "Simple Short": #selector(ExampleViewController.showSimpleShortPassiveAlert),
                                                   "Custom View": #selector(ExampleViewController.showPassiveCustomAlert),
                                                   "Queued Alerts": #selector(ExampleViewController.showPassiveQueuedAlerts)], .brown)
        
        let modalButton = btnsMapper(["From Modal": #selector(ExampleViewController.showFromModal) ], .magenta)
        
        
        
        let activeAlertsLabel = UILabel()
        activeAlertsLabel.text = "Active Alerts"
        
        let passiveAlertsLabel = UILabel()
        passiveAlertsLabel.text = "Passive Alerts"
        
        let modalLabel = UILabel()
        modalLabel.text = "Modal VC"
        
        exampleSectionLabels = [[activeAlertsLabel], [passiveAlertsLabel], [modalLabel]]
        
        presentationView.backgroundColor = UIColor.darkGray
        presentationView.heightAnchor.constraint(equalToConstant: view.frame.height/3).isActive = true
        presentationView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        if let presentFromViewBtn = btnsMapper(["Show in View": #selector(ExampleViewController.showFromView)], .green).first {
            presentationView.addSubviewsWithNoConstraints(presentFromViewBtn)
            presentFromViewBtn.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
            presentFromViewBtn.centerXAnchor.constraint(equalTo: presentationView.centerXAnchor).isActive = true
            presentFromViewBtn.centerYAnchor.constraint(equalTo: presentationView.centerYAnchor).isActive = true
        }
        
        exampleButtons = [allActiveExampleButtons, allPassiveExampleButtons, modalButton]
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 40.0)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView?.backgroundColor = UIColor.lightGray
        
        if let cv = collectionView {
            let sv = UIStackView(arrangedSubviews: [cv, presentationView])
            sv.axis = .vertical
            sv.wrap(in: view, with: InsetConstraints(insets: UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0) , priority: UILayoutPriorityDefaultHigh))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = indexPath.section >= 2 ? view.frame.width : view.frame.width/2 - 1
        return CGSize(width: itemWidth, height: 44.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
        if let label = exampleSectionLabels?[indexPath.section][indexPath.row] {
            label.backgroundColor = .white
            label.textAlignment = .center
            label.wrap(in: view, with: InsetConstraints(insets: UIEdgeInsets.zero, priority: UILayoutPriorityDefaultHigh))
        }
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let button = exampleButtons?[indexPath.section][indexPath.row] {
            button.wrap(in: cell, with: InsetConstraints(insets: UIEdgeInsets.zero, priority: UILayoutPriorityDefaultHigh))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let btns = exampleButtons?[section] else { return 0 }
        return btns.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let btns = exampleButtons else { return 0 }
        return btns.count
    }
}

// MARK: Convenience Objects
extension ExampleViewController {
    var genericCancelAction: AlertAction {
        return AlertAction(type: .cancel, title: "Cancel", completion: { (action) in
            print("Cancel pressed")
        })
    }
    
    var genericDoneAction: AlertAction {
        return AlertAction(type: .normal, title: "Done") { (action) in
            print("Done pressed")
        }
    }
    
    var wrappingTitle: String {
        return "The Title of my message can be up to 2 lines long.  It wraps and centers."
    }
    
    var longMessage: String {
        return "And the message that is a bunch of text that will turn scrollable once the text view runs out of space.\nAnd the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text."
    }
    
    var customView: UIView {
        let customView = UIView()
        customView.backgroundColor = .green
        let iv = UIImageView(image: UIImage(named: "IMG_7016"))
        iv.widthAnchor.constraint(equalToConstant: 100).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 100).isActive = true
        iv.contentMode = .scaleAspectFit
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Cat In Box, you can tap inside to dismiss."
        let sv = UIStackView(arrangedSubviews: [iv, label])
        sv.spacing = 20
        sv.wrap(in: customView, with: InsetConstraints(insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), priority: UILayoutPriorityDefaultHigh))
        
        return customView
    }
}

// MARK: Custom Buttons
class ExampleCustomButtons: UIView, AlertButtonContainer {
    var actions: [AlertAction] {
        let firstAction = AlertAction(customButton: cancelButton) { (action) in
            print("custom Cancel button pressed")
        }
        
        let secondAction = AlertAction(customButton: confirmButton) { (action) in
            print("custom Confirm button pressed")
        }
        
        return [firstAction, secondAction]
    }
    
    let cancelButton: UIButton
    let confirmButton: UIButton
    
    override init(frame: CGRect) {
        cancelButton = UIButton(type: .custom)
        cancelButton.backgroundColor = .cyan
        cancelButton.setImage(UIImage(named: "ExampleCancel"), for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.imageView?.contentMode = .scaleAspectFit
        confirmButton = UIButton(type: .custom)
        confirmButton.setTitle("Done", for: .normal)
        confirmButton.imageView?.contentMode = .scaleAspectFit
        confirmButton.backgroundColor = .purple
        
        let customTopDivider = UIView()
        customTopDivider.backgroundColor = .orange
        customTopDivider.heightAnchor.constraint(equalToConstant: 5.0).isActive = true
        let customButtonDivider = UIView()
        customButtonDivider.backgroundColor = .magenta
        
        let buttonsContainer = UIView()
        let buttons = ["cancelButton": cancelButton, "customButtonDivider": customButtonDivider, "confirmButton": confirmButton]
        buttonsContainer.addSubviewsWithNoConstraints(cancelButton, customButtonDivider, confirmButton)
        activateVFL(format: "H:|[cancelButton][customButtonDivider(5)][confirmButton(cancelButton)]|", options:[.alignAllTop, .alignAllBottom], views: buttons)
        activateVFL(format: "V:|[cancelButton(44)]|", views: buttons)
        
        let sv = UIStackView(arrangedSubviews: [customTopDivider, buttonsContainer])
        sv.axis = .vertical
        
        super.init(frame: frame)
        
        sv.wrap(in: self, with: InsetConstraints(insets: UIEdgeInsets.zero, priority: UILayoutPriorityDefaultHigh))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
