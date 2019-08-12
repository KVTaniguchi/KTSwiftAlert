//
//  UIView+Additions.swift
//  WhiteLabel
//
//  Created by Matt Thomas on 7/18/17.
//
//

import UIKit

public struct SafeAreaEdges: OptionSet {
    public static let leading = SafeAreaEdges(rawValue: 1 << 0)
    public static let top = SafeAreaEdges(rawValue: 1 << 1)
    public static let trailing = SafeAreaEdges(rawValue: 1 << 2)
    public static let bottom = SafeAreaEdges(rawValue: 1 << 3)
    
    public static let all: SafeAreaEdges = [.leading, .top, .trailing, .bottom]
    public static let none: SafeAreaEdges = []
    
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}


extension UIView {
    
    /// Uses autolayout to embed a subview inside a view with constant inset constraints
    ///
    /// - Parameters:
    ///   - subview: subview to embed
    ///   - allInsets: constant padding between all edges
    ///   - useSafeArea: if true, use the safe area guides
    public func embed(subview: UIView, allInsets: CGFloat = 0, safeAreaEdges: SafeAreaEdges = .none) {
        embed(subview: subview, insets: UIEdgeInsets(top: allInsets, left: allInsets, bottom: allInsets, right: allInsets), safeAreaEdges: safeAreaEdges)
    }

    /// Uses autolayout to embed a subview inside a view with inset constraints
    ///
    /// - Parameters:
    ///   - subview: subview to embed
    ///   - insets: padding between view and superview
    ///   - useSafeArea: if true, use the safe area guides
    public func embed(subview: UIView, insets: UIEdgeInsets, safeAreaEdges: SafeAreaEdges = .none) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        
        let safeLeading = safeAreaEdges.contains(.leading) ? safeAreaLeadingAnchor : leadingAnchor
        let safeTrailing = safeAreaEdges.contains(.trailing) ? safeAreaTrailingAnchor : trailingAnchor
        let safeTop = safeAreaEdges.contains(.top) ? safeAreaTopAnchor : topAnchor
        let safeBottom = safeAreaEdges.contains(.bottom) ? safeAreaBottomAnchor : bottomAnchor
        
        subview.leadingAnchor.constraint(equalTo: safeLeading, constant: insets.left).isActive = true
        subview.trailingAnchor.constraint(equalTo: safeTrailing, constant: -insets.right).isActive = true
        subview.topAnchor.constraint(equalTo: safeTop, constant: insets.top).isActive = true
        subview.bottomAnchor.constraint(equalTo: safeBottom, constant: -insets.bottom).isActive = true
    }
}

extension Array where Element == UIView {
    
    /// Returns the largest intrinsic height for all the UIViews in an array. If one of the heights is UIViewNoIntrinsicMetric, then that will be returned
    public var maxIntrinsicHeight: CGFloat {
        // Check to see if any are UIViewNoIntrinsicMetric
        for view in self {
            if view.intrinsicContentSize.height == UIView.noIntrinsicMetric { return UIView.noIntrinsicMetric }
        }
        
        return map{ $0.intrinsicContentSize.height }.max() ?? UIView.noIntrinsicMetric
    }
}

extension UIView {
    
    /// The border at the top of the view
    public var urbn_topBorderStyle: BorderStyle? {
        set(newBorderStyle) {
            let newBorder = Border(borderStyle: newBorderStyle)
            addBorder(newBorder, side: .top, key: &UIView.AssociatedKeys.topBorder)
        }
        get {
            return (objc_getAssociatedObject(self, &UIView.AssociatedKeys.topBorder) as? Border)?.borderStyle
        }
    }
    
    /// The border at the bottom of the view
    public var urbn_bottomBorderStyle: BorderStyle? {
        set(newBorderStyle) {
            let newBorder = Border(borderStyle: newBorderStyle)
            addBorder(newBorder, side: .bottom, key: &UIView.AssociatedKeys.bottomBorder)
        }
        get {
            return (objc_getAssociatedObject(self, &UIView.AssociatedKeys.bottomBorder) as? Border)?.borderStyle
        }
    }
    
    /// The border at the leading edge of the view
    public var urbn_leadingBorderStyle: BorderStyle? {
        set(newBorderStyle) {
            let newBorder = Border(borderStyle: newBorderStyle)
            addBorder(newBorder, side: .leading, key: &UIView.AssociatedKeys.leadingBorder)
        }
        get {
            return (objc_getAssociatedObject(self, &UIView.AssociatedKeys.leadingBorder) as? Border)?.borderStyle
        }
    }
    
    /// The border at the trailing edge of the view
    public var urbn_trailingBorderStyle: BorderStyle? {
        set(newBorderStyle) {
            let newBorder = Border(borderStyle: newBorderStyle)
            addBorder(newBorder, side: .trailing, key: &UIView.AssociatedKeys.trailingBorder)
        }
        get {
            return (objc_getAssociatedObject(self, &UIView.AssociatedKeys.trailingBorder) as? Border)?.borderStyle
        }
    }
    
    /// Clears all existing borders
    public func resetBorders() {
        urbn_topBorderStyle = nil
        urbn_bottomBorderStyle = nil
        urbn_leadingBorderStyle = nil
        urbn_trailingBorderStyle = nil
    }
    
    /// Sets all the borders based on 1 border
    ///
    /// - Parameter border: border to set
    public func setBorderStyle(_ borderStyle: BorderStyle) {
        urbn_topBorderStyle = borderStyle
        urbn_bottomBorderStyle = borderStyle
        urbn_leadingBorderStyle = borderStyle
        urbn_trailingBorderStyle = borderStyle
    }
    
    // MARK:- Private
    private struct AssociatedKeys {
        static var topBorder = AssociatedKey("UIView.wl_topBorder")
        static var bottomBorder = AssociatedKey("UIView.wl_bottomBorder")
        static var leadingBorder = AssociatedKey("UIView.wl_leadingBorder")
        static var trailingBorder = AssociatedKey("UIView.wl_trailingBorder")
    }
    
    private func addBorder(_ border: Border?, side: Border.Side, key: UnsafeRawPointer) {
        // Remove Old Border
        if let oldBorder = objc_getAssociatedObject(self, key) as? Border {
            oldBorder.removeFromSuperview()
        }
        
        // Set associated object. If nil, then the current associated object will be removed
        objc_setAssociatedObject(self, key, border, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        // Add the border to the current view
        border?.add(to: self, side: side)
        
        // Alert the layout needs updating
        setNeedsLayout()
    }
}
