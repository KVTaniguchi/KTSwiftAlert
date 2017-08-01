//
//  AlertAction.swift
//  Pods
//
//  Created by Kevin Taniguchi on 5/23/17.
//
//
import Foundation

public class AlertAction: NSObject {
    public enum ActionType {
        case normal, destructive, cancel, passive, custom
    }
    
    let type: ActionType
    let shouldDismiss: Bool
    let isEnabled: Bool
    let completion: ((AlertAction) -> Void)?
    public var button: UIButton?
    var title: String?
    
    var isButton: Bool {
        return type != .passive
    }
    
    /**
     * Init an action with custom button, action type, dismissable and enabled bool, and completion handler
     * Used for creating connecting a custom button to an action
     * @param type  Required.  Type of action.
     * @param shouldDismiss Default true.  On completion, the action will dismiss the alert.
     * @param isEnabled Default true.  Action is enabled
     * @param completion Optional.  Closure that takes in the action as a param and completes when the selector of the target fires.
     */
    public convenience init(customButton: UIButton, shouldDismiss: Bool = true, isEnabled: Bool = true, completion: ((AlertAction) -> Void)? = nil) {
        self.init(type: .custom, shouldDismiss: shouldDismiss, isEnabled: isEnabled, completion: completion)
        
        add(button: customButton)
    }
    
    /**
     * Init an action with a title, action type, dismissable and enabled bool, and completion handler
     * Used for creating a standard URBNSwiftAlert button or passive action
     * @param title Optional.  The button title
     * @param type  Required.  Type of action.
     * @param shouldDismiss Default true.  On completion, the action will dismiss the alert.
     * @param isEnabled Default true.  Action is enabled
     * @param completion Optional.  Closure that takes in the action as a param and completes when the selector of the target fires.
     */
    public init(type: AlertAction.ActionType, shouldDismiss: Bool = true, isEnabled: Bool = true, title: String? = nil, completion: ((AlertAction) -> Void)? = nil) {
        self.type = type
        self.shouldDismiss = shouldDismiss
        self.isEnabled = isEnabled
        self.completion = completion
        
        super.init()
        
        self.title = title
    }
    
    func add(button: UIButton) {
        button.addTarget(self, action: #selector(completeAction), for: .touchUpInside)
        self.button = button
    }
    
    /**
     * Enables / Disables the Button in the alert (non custom only)
     */
    public func set(isEnabled: Bool) {
        button?.isEnabled = isEnabled
    }
    
    @objc func completeAction() {
        completion?(self)
    }
}
