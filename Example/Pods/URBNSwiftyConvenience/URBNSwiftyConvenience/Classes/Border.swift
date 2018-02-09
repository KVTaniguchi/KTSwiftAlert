//
//  Border.swift
//  Pods
//
//  Created by Matt Thomas on 7/20/17.
//
//

import UIKit

/// Reuseable value type border view model that can be used to initalize a new border instance
public struct BorderStyle {
    
    public let color: UIColor
    public let pixelWidth: Int
    public let insets: UIEdgeInsets
    
    public init(color: UIColor, pixelWidth: Int = 1, insets: UIEdgeInsets = .zero) {
        self.color = color
        self.pixelWidth = pixelWidth
        self.insets = insets
    }
}

/// Represents a border with a with a width, a color, and insets
final class Border: UIView {
    
    let borderStyle: BorderStyle
    
    private var widthConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?

    private var currentScale: CGFloat {
        return UIScreen.main.scale
    }
    
    /// Creates a border with a color, width, and inset
    ///
    /// - Parameters:
    ///   - borderStyle: viewModel containing the following
    ///     - color: color for the border
    ///     - pixelWidth: the width of the border in pixels (not points)
    ///     - insets: insets for the border
    init?(borderStyle: BorderStyle?) {
        guard let borderStyle = borderStyle else {
            return nil
        }
        
        self.borderStyle = borderStyle
        super.init(frame: .zero)
        
        widthConstraint?.constant = borderStyle.pixelWidth.pixelsToPoints(forContentScaleFactor: currentScale)
        topConstraint?.constant = borderStyle.insets.top
        bottomConstraint?.constant = -borderStyle.insets.bottom
        leadingConstraint?.constant = borderStyle.insets.left
        trailingConstraint?.constant = -borderStyle.insets.right
        
        isUserInteractionEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = borderStyle.color
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Adds the current border to a view with a specific side
    ///
    /// - Parameters:
    ///   - superview: The view to add the border to
    ///   - side: The side of the view to add
    func add(to superview: UIView, side: Side) {
        superview.addSubview(self)
        
        if side != .top {
            bottomConstraint = bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -borderStyle.insets.bottom)
            bottomConstraint?.isActive = true
        }
        
        if side != .bottom {
            topConstraint = topAnchor.constraint(equalTo: superview.topAnchor, constant: borderStyle.insets.top)
            topConstraint?.isActive = true
        }
        
        if side != .leading {
            trailingConstraint = trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -borderStyle.insets.right)
            trailingConstraint?.isActive = true
        }
        
        if side != .trailing {
            leadingConstraint = leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: borderStyle.insets.left)
            leadingConstraint?.isActive = true
        }
        
        if side == .leading || side == .trailing {
            widthConstraint = widthAnchor.constraint(equalToConstant: borderStyle.pixelWidth.pixelsToPoints(forContentScaleFactor: currentScale))
            widthConstraint?.isActive = true
            setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
            setContentCompressionResistancePriority(.fittingSizeLevel, for: .vertical)
        }
        else if side == .top || side == .bottom {
            widthConstraint = heightAnchor.constraint(equalToConstant: borderStyle.pixelWidth.pixelsToPoints(forContentScaleFactor: currentScale))
            widthConstraint?.isActive = true
            setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
            setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
        }
        
        widthConstraint?.constant = borderStyle.pixelWidth.pixelsToPoints(forContentScaleFactor: currentScale)
        setNeedsUpdateConstraints()
    }
}

extension Border {
    /// The side the border appears on
    ///
    /// - leading: leading side border
    /// - trailing: trailing side border
    /// - top: top border
    /// - bottom: bottom border
    enum Side {
        case leading, trailing, top, bottom
    }
}
