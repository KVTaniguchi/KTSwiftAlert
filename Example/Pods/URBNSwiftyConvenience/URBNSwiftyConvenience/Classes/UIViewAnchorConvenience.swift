//
//  UIViewAnchorConvenience.swift
//  URBNSwiftyConvenience
//
//  Created by Ray Migneco on 11/6/17.
//

import Foundation

/// Support safe area layout guides on supported platforms
///
public extension UIView {
    var safeAreaBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11, tvOS 11, *) {
            return safeAreaLayoutGuide.bottomAnchor
        }
        else {
            return bottomAnchor
        }
    }
    
    var safeAreaCenterXAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11, tvOS 11, *) {
            return safeAreaLayoutGuide.centerXAnchor
        }
        else {
            return centerXAnchor
        }
    }
    
    var safeAreaCenterYAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11, tvOS 11, *) {
            return safeAreaLayoutGuide.centerYAnchor
        }
        else {
            return centerYAnchor
        }
    }
    
    var safeAreaHeightAnchor: NSLayoutDimension {
        if #available(iOS 11, tvOS 11, *) {
            return safeAreaLayoutGuide.heightAnchor
        }
        else {
            return heightAnchor
        }
    }
    
    var safeAreaLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11, tvOS 11, *) {
            return safeAreaLayoutGuide.leadingAnchor
        }
        else {
            return leadingAnchor
        }
    }
    
    var safeAreaLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11, tvOS 11, *) {
            return safeAreaLayoutGuide.leftAnchor
        }
        else {
            return leftAnchor
        }
    }
    
    var safeAreaRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11, tvOS 11, *) {
            return safeAreaLayoutGuide.rightAnchor
        }
        else {
            return rightAnchor
        }
    }
    
    var safeAreaTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11, tvOS 11, *) {
            return safeAreaLayoutGuide.topAnchor
        }
        else {
            return topAnchor
        }
    }
    
    var safeAreaTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11, tvOS 11, *) {
            return safeAreaLayoutGuide.trailingAnchor
        }
        else {
            return trailingAnchor
        }
    }
    
    var safeAreaWidthAnchor: NSLayoutDimension {
        if #available(iOS 11, tvOS 11, *) {
            return safeAreaLayoutGuide.widthAnchor
        }
        else {
            return widthAnchor
        }
    }
}
