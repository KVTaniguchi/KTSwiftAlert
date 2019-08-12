//
//  UIViewController+Extensions.swift
//  Pods-URBNSwiftyConvenience_Example
//
//  Created by Bao Tran on 9/26/18.
//

import Foundation

public extension UIViewController {
    public func embedChildViewController(_ childViewController: UIViewController, insets: UIEdgeInsets = .zero,  safeAreaEdges: SafeAreaEdges = .none) {
        addChild(childViewController)
        view.embed(subview: childViewController.view, insets: insets, safeAreaEdges: safeAreaEdges)
        childViewController.didMove(toParent: self)
    }

    public func removeViewAndViewControllerFromParent() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
