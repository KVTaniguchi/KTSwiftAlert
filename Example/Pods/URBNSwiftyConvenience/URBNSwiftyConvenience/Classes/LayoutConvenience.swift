//
//  ConstraintConvenience.swift
//  Pods
//
//  Created by Nick DiStefano on 12/11/15.
//
//

import Foundation

public typealias InsetConstraint = (constant: CGFloat, priority: UILayoutPriority)

public struct InsetConstraints {
    public var top: InsetConstraint
    public var left: InsetConstraint
    public var right: InsetConstraint
    public var bottom: InsetConstraint
    
    public init(top: InsetConstraint = (constant: 0.0, priority: .required), left: InsetConstraint = (constant: 0.0, priority: .required), bottom: InsetConstraint = (constant: 0.0, priority: .required), right: InsetConstraint = (constant: 0.0, priority: .required)) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }
    
    public init(insets: UIEdgeInsets, horizontalPriority: UILayoutPriority, verticalPriority: UILayoutPriority) {
        self.init(top: (constant: insets.top, priority: verticalPriority),
                  left: (constant: insets.left, priority: horizontalPriority),
                  bottom: (constant: insets.bottom, priority: verticalPriority),
                  right: (constant: insets.right, priority: horizontalPriority))
    }
    
    public init(insets: UIEdgeInsets, priority: UILayoutPriority = .required) {
        self.init(insets: insets, horizontalPriority: priority, verticalPriority: priority)
    }
}

public func activateVFL(format: String, options: NSLayoutFormatOptions = [], metrics: [String : Any]? = nil, views: [String : Any]) {
    NSLayoutConstraint.activate(
        NSLayoutConstraint.constraints(
            withVisualFormat: format,
            options: options,
            metrics: metrics,
            views: views
        )
    )
}

public extension UIView {
    @available(*, unavailable, message: "use addSubviewsWithNoConstraints instead")
    public func addSubviewWithNoConstraints(_ subview: UIView) { }
    
    public func addSubviewsWithNoConstraints(_ subviews: UIView...) {
        addSubviewsWithNoConstraints(subviews)
    }
    
    public func addSubviewsWithNoConstraints(_ subviews: [UIView]) {
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
            addSubview(v)
        }
    }
    
    public func addSubviewsWithNoConstraints<T: UIView>(_ subviews: LazyMapCollection<[String: T], T>) {
        addSubviewsWithNoConstraints(Array(subviews))
    }
    
    public func wrapInView(_ view: UIView? = nil, withInsets insets: UIEdgeInsets = UIEdgeInsets.zero) -> UIView {
        var container: UIView
        if let view = view {
            container = view
        }
        else {
            container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
        }
        
        container.addSubviewsWithNoConstraints(self)

        let metrics = ["top": insets.top, "left": insets.left, "bottom": insets.bottom, "right": insets.right]
        activateVFL(format: "H:|-left-[view]-right-|", metrics: metrics, views: ["view": self])
        activateVFL(format: "V:|-top-[view]-bottom-|", metrics: metrics, views: ["view": self])
        
        return container
    }
    
    @available(iOS 9, *)
    public func wrap(in view: UIView, with insetConstraints: InsetConstraints) {
        wrap(child: self, inParent: view, with: insetConstraints)
    }
    
    @available(iOS 9, *)
    public func wrapInNewView(with insetConstraints: InsetConstraints) -> UIView {
        let view = UIView()
        wrap(child: self, inParent: view, with: insetConstraints)
        
        return view
    }
    
    @available(iOS 9, *)
    private func wrap(child: UIView, inParent parent: UIView, with insetConstraints: InsetConstraints) {
        parent.addSubviewsWithNoConstraints(child)
        
        let topAnchor = child.topAnchor.constraint(equalTo: parent.topAnchor, constant: insetConstraints.top.constant)
        topAnchor.priority = insetConstraints.top.priority
        topAnchor.isActive = true
        
        let leftAnchor = child.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: insetConstraints.left.constant)
        leftAnchor.priority = insetConstraints.left.priority
        leftAnchor.isActive = true
        
        let bottomAnchor = child.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -insetConstraints.bottom.constant)
        bottomAnchor.priority = insetConstraints.bottom.priority
        bottomAnchor.isActive = true
        
        let rightAnchor = child.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: -insetConstraints.right.constant)
        rightAnchor.priority = insetConstraints.right.priority
        rightAnchor.isActive = true
    }
}

@available(iOS 9.0, *)
public extension UIStackView {
    
    public func addArrangedSubviews(_ subviews: UIView...) {
        addArrangedSubviews(subviews)
    }
    
    public func addArrangedSubviews(_ subviews: [UIView]) {
        for v in subviews {
            addArrangedSubview(v)
        }
    }
}

// TODO: Refactor out when we move to swifty 4
//       Also we could adopt add & subtract capability similar to - https://useyourloaf.com/blog/easier-swift-layout-priorities/
@available(swift, deprecated: 4.0)
public struct ConstraintPriority: RawRepresentable {
    
    public static let defaultLow: ConstraintPriority = ConstraintPriority(UILayoutPriority.defaultLow.rawValue)
    public static let defaultHigh: ConstraintPriority = ConstraintPriority(UILayoutPriority.defaultHigh.rawValue)
    public static let required: ConstraintPriority = ConstraintPriority(UILayoutPriority.required.rawValue)
    public static let fittingSizeLevel: ConstraintPriority = ConstraintPriority(UILayoutPriority.fittingSizeLevel.rawValue)

    public var rawValue: Float

    public init(_ rawValue: Float) {
        self.rawValue = rawValue
    }
    
    public init(rawValue: Float) {
        self.rawValue = rawValue
    }
}

extension ConstraintPriority: Equatable, Hashable {
    public var hashValue: Int {
        return rawValue.hashValue
    }
    
    public static func == (lhs: ConstraintPriority, rhs: ConstraintPriority) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

public extension ConstraintPriority {
    static func +(lhs: ConstraintPriority, rhs: Float) -> ConstraintPriority {
        return ConstraintPriority(lhs.rawValue + rhs)
    }
    
    static func -(lhs: ConstraintPriority, rhs: Float) -> ConstraintPriority {
        return ConstraintPriority(lhs.rawValue - rhs)
    }
}


public extension NSLayoutConstraint {
    
    // TODO: Refactor out when we move to swifty 4
    @available(swift, deprecated: 4.0)
    public func activate(withPriority constraintPriority: ConstraintPriority) {
        self.priority = UILayoutPriority(constraintPriority.rawValue)
        isActive = true
    }
}
