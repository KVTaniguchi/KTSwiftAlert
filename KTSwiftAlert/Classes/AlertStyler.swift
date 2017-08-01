//
//  AlertStyler.swift
//  Pods
//
//  Created by Kevin Taniguchi on 5/22/17.
//
//
import Foundation
import URBNSwiftyConvenience

public struct AlertStyler {
    
    public var blur: Blur = Blur()
    
    public var background = Background()
    
    public var alertViewShadow = AlertViewShadow()
    
    public var animation = Animation()
    
    public var button = Button()
    
    public var cancelButton = CancelButton()
    
    public var destructiveButton = DestructiveButton()
    
    public var disabledButton = DisabledButton()
    
    public var title = Title()
    
    public var message = Message()
    
    public var textField = TextField()
    
    public var alert = Alert()
    
    /**
     * The view you want to become the first responder when the alert view is finished presenting
     * The alert position will adjust for the keyboard when using this property
     */
    public var firstResponder: UIView?
}

// MARK: Container Structs
extension AlertStyler {
    public struct Alert {
        /**
         * Min (greaterThanOrEqualTo) and Max widths (lessThanOrEqualTo) for the Alert -   The alert view will use its most compressed layout values for height
         */
        
        public var minMaxWidth: (min: CGFloat, max: CGFloat)?
        
        /**
         * Margins on left and right sides of the alert, which sets the width constraint.  Used if no min/max widths are given.  The alert view will use its most compressed layout values for height
         */
        public var horizontalMargin: CGFloat = 45.0 {
            didSet {
                assert(horizontalMargin > 0, "Margin must be greater than 0")
            }
        }
        
        /**
         * Margin between sections in the alert. ie margin between the title and the message; message and the buttons, etc.
         */
        public var labelVerticalSpacing: CGFloat = 10.0
        
        /**
         * Insets of the whole standard alert view when not using custom views.
         */
        public var insets = UIEdgeInsets(top: 24, left: 16, bottom: 5, right: 16)
        
        /**
         * Corner radius of the alert view itself
         */
        public var cornerRadius: CGFloat = 0.0
    }
    
    public struct Blur {
        /**
         * Pass no to disable blurring in the background
         */
        public var isEnabled = true
    }
    
    public struct Background {
        /**
         * Background color of alert view
         */
        public var color = UIColor.white
        /**
         * Tint color of the view behind the Alert. Blur must be disabled
         */
        public var tint: UIColor?
    }
    
    public struct AlertViewShadow {
        /**
         * Opacity of the alert view's shadow
         */
        public var opacity: Float = 0.0
        /**
         * Radius of the alert view's shadow
         */
        public var radius: CGFloat = 0.0
        /**
         * Color of the alert view's shadow
         */
        public var color = UIColor.clear
        /**
         * Offset of the alert view's shadow
         */
        public var offset = CGSize.zero
    }
    
    public struct Button {
        /**
         * Height of the alert's buttons
         */
        public var height: CGFloat = 44.0
        
        /**
         * Text color of the button titles
         */
        public var titleColor = UIColor.black
        
        /**
         * Background color of the buttons for active alerts
         */
        public var backgroundColor = UIColor.gray
        
        /**
         * Background color of a highlighted button for an active alert
         */
        public var highlightBackgroundColor = UIColor.darkGray
        
        /**
         * Background color of a selected button for an active alert
         */
        public var selectedBackgroundColor = UIColor.lightGray
        
        /**
         * Button title color for a selected state
         */
        public var selectedTitleColor = UIColor.black
        
        /**
         * Button container inset constraints
         */
        public var containerInsetConstraints = InsetConstraints(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), priority: UILayoutPriorityDefaultHigh)
        
        public var spacing: CGFloat = 10.0 {
            didSet {
                assert(spacing > 0, "Button spacing must be greater than 0")
            }
        }
        
        /**
         * Corner radius of the alert's buttons
         */
        public var cornerRadius: CGFloat = 0.0
        
        /**
         * Font of the button's titles
         */
        public var font: UIFont? = UIFont.systemFont(ofSize: 12.0)
        
        /**
         * Button title color on highlight
         */
        public var highlightTitleColor = UIColor.black
        
        /**
         * UIEdgeInsets used at the external margins for the buttons of the alert's buttons
         */
        public var insetConstraints = InsetConstraints(insets: UIEdgeInsets.zero, priority: UILayoutPriorityDefaultHigh)
        
        /**
         * Width of the alert's button's border layer
         */
        public var borderWidth: CGFloat = 0.0
        
        /**
         * UIColor of the alert's button's border
         */
        public var borderColor = UIColor.clear
        
        /**
         * Opacity of the alert's button's shadows
         */
        public var shadowOpacity: Float = 0.0
        
        /**
         * Radius of the alert's button's shadows
         */
        public var shadowRadius: CGFloat = 0.0
        
        /**
         * Color of the alert's button's shadows
         */
        public var shadowColor = UIColor.clear
        
        /**
         * Offset of the alert's button's shadows
         */
        public var shadowOffset = CGSize.zero
        
        /**
         * Insets of the buttons contents
         */
        public var contentInsets = UIEdgeInsets.zero
        
        /**
         *  Layout axis for buttons (for 3+ always vertical always used)
         */
        public var layoutAxis = UILayoutConstraintAxis.horizontal
    }
    
    public struct CancelButton {
        /**
         * Text color of cancel button title
         */
        public var titleColor = UIColor.black
        /**
         * Background color of the cancel button for an active alert
         */
        public var backgroundColor = UIColor.gray
        
        /**
         * Background color of a highlighted button for a cancel action
         */
        public var highlightBackgroundColor = UIColor.darkGray
        
        /**
         * Text color of cancel button title when highlighted
         */
        public var highlightTitleColor = UIColor.black
    }
    
    public struct DestructiveButton {
        /**
         * Text color of destructive button colors
         */
        public var titleColor = UIColor.red
        
        /**
         * Text color of destructive button title when highlighted
         */
        public var highlightTitleColor = UIColor.red
        
        /**
         * Background color of the denial button for an active alert (at position 0)
         */
        public var backgroundColor = UIColor.gray
        
        /**
         * Background color of a highlighted button for a destructive action
         */
        public var highlightBackgroundColor = UIColor.darkGray
    }
    
    public struct DisabledButton {
        /**
         * Text color of a disabled button
         */
        public var titleColor = UIColor.lightGray
        /**
         * Background color of a disabled button for an active alert
         */
        public var backgroundColor = UIColor.darkGray
        /**
         * Alpha value of a disabled button
         */
        public var alpha: CGFloat = 1.0
    }
    
    
    public struct Animation {
        /**
         * Bool for using an animation to present alert view
         */
        public var isAnimated: Bool = true
        
        /**
         * Duration of the presenting and dismissing of the alert view
         */
        public var duration: CGFloat = 0.6
        
        /**
         * Spring damping for the presenting and dismissing of the alert view
         */
        public var damping: CGFloat = 0.6
        
        /**
         * Spring initial velocity for the presenting and dismissing of the alert view
         */
        public var initialVelocity: CGFloat = -10.0
    }
    
    public struct Title {
        /**
         * Font of the alert's title
         */
        public var font: UIFont? = UIFont.systemFont(ofSize: 14)
        
        /**
         * Text color of the alert's title
         */
        public var color = UIColor.black
        
        /**
         * Background color of the alert's title
         */
        public var backgroundColor = UIColor.clear
        
        /**
         * Alignment of the titles's message
         */
        public var alignment = NSTextAlignment.center
        
        /**
         *  Layout Margins for the alert title
         */
        public var insetConstraints = InsetConstraints(insets: UIEdgeInsets.zero, priority: UILayoutPriorityDefaultHigh)
    }
    
    public struct Message {
        /**
         * Font of the alert's message
         */
        public var font: UIFont? = UIFont.systemFont(ofSize: 12.0)
        
        /**
         * Text color of the alert's message
         */
        public var color = UIColor.black
        
        /**
         * Background color of the alert's message
         */
        public var backgroundColor = UIColor.clear
        
        /**
         * Alignment of the alert's message
         */
        public var alignment = NSTextAlignment.center
        
        /**
         *  Layout Margins for the alert message
         */
        public var insetConstraints = InsetConstraints(insets: UIEdgeInsets.zero, priority: UILayoutPriorityDefaultHigh)
    }
    
    public struct TextField {
        /**
         * Max input length for the text field when enabled
         */
        public var maxLength = Int.max
        
        /**
         * Text color of the error label text
         */
        public var errorMessageColor = UIColor.red
        
        /**
         * Text font of the error label text
         */
        public var errorMessageFont: UIFont? = UIFont.systemFont(ofSize: 12.0)
        
        /**
         *  Text Insets for input text fields on alerts
         */
        public var edgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        /**
         *  Vertical margin between textfields
         */
        public var verticalMargin: CGFloat = 5.0
    }
}

// MARK: Standard Button Styling
extension AlertStyler {
    /**
     *  Returns the correct button title color for given an actionType
     *
     *  @param actionType Action type associated with the button
     *
     *  @return
     */
    public func buttonTitleColor(actionType: AlertAction.ActionType, isEnabled: Bool) -> UIColor {
        if !isEnabled {
            return disabledButton.titleColor
        }
        
        switch actionType {
        case .cancel:
            return cancelButton.titleColor
        case .destructive:
            return destructiveButton.titleColor
        case .normal, .custom, .passive:
            return button.titleColor
        }
    }
    
    /**
     *  Returns the correct button highlight title color for given an actionType
     *
     *  @param actionType Action type associated with the button
     *
     *  @return
     */
    public func buttonHighlightTitleColor(actionType: AlertAction.ActionType, isEnabled: Bool) -> UIColor {
        if !isEnabled {
            return disabledButton.titleColor
        }
        
        switch actionType {
        case .cancel:
            return cancelButton.highlightTitleColor
        case .destructive:
            return destructiveButton.highlightTitleColor
        case .normal, .custom, .passive:
            return button.highlightTitleColor
        }
    }
    
    /**
     *  Returns the correct button background color for given an actionType
     *
     *  @param actionType Action type associated with the button
     *
     *  @return
     */
    public func buttonBackgroundColor(actionType: AlertAction.ActionType, isEnabled: Bool) -> UIColor {
        if !isEnabled {
            return disabledButton.backgroundColor
        }
        
        switch actionType {
        case .cancel:
            return cancelButton.backgroundColor
        case .destructive:
            return destructiveButton.backgroundColor
        case .normal, .custom, .passive:
            return button.backgroundColor
        }
    }
}
