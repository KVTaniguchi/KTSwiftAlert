//
//  UIColorConvenience.swift
//  Pods
//
//  Created by Lloyd Sykes on 6/29/17.
//
//

import UIKit

extension CharacterSet {
    public static var hexValues: CharacterSet {
        return CharacterSet(charactersIn: "0123456789ABCDEFabcdef")
    }
}


extension UIColor {
    
    public convenience init(hexString: String) {
        let sanitized = hexString.components(separatedBy: CharacterSet.hexValues.inverted).joined()
        let count = sanitized.count
        var rgb: UInt32 = 0
        
        if (count == 6 || count == 8), Scanner(string: sanitized).scanHexInt32(&rgb) {
            if sanitized.count == 6 {
                self.init(rgb: rgb)
            }
            else {
                self.init(rgba: rgb)
            }
        }
        else {
            self.init(rgb: 0)
        }
    }

    /// Create a color from RGBA values as UInt8
    ///
    /// This allows creation of colors like:
    /// `UIColor(redInt: 0xFF, greenInt: 0x00, blueInt: 0x00, alphaInt: 0xFF)`
    ///
    /// - Parameters:
    ///   - redInt: red value between 0x00 and 0xFF
    ///   - greenInt: green value between 0x00 and 0xFF
    ///   - blueInt: blue value between 0x00 and 0xFF
    ///   - alphaInt: alpha value between 0x00 and 0xFF. Defaults to 0xFF
    ///
    /// - Notes:
    ///   - UInt8 prevents us from putting wrong values in.
    public convenience init(redInt: UInt8, greenInt: UInt8, blueInt: UInt8, alphaInt: UInt8 = 0xFF) {
        let r = (CGFloat(redInt) / 255.0)
        let g = (CGFloat(greenInt) / 255.0)
        let b = (CGFloat(blueInt) / 255.0)
        let a = (CGFloat(alphaInt) / 255.0)
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    /// Creates a color from RGB value.
    ///
    /// This allows creation of colors like:
    /// `UIColor(rgb: 0xFF0000)`
    ///
    /// - Parameter rgb: an integer representing RGB values, Hex work the best
    public convenience init(rgb: UInt32) {
        if rgb > 0xFFFFFF { // outside RGB
            self.init(white: 0.0, alpha: 1.0)
        }
        else {
            let r = UInt8((rgb & 0xFF0000) >> 16)
            let g = UInt8((rgb & 0x00FF00) >> 8)
            let b = UInt8(rgb & 0x0000FF)
            self.init(redInt: r, greenInt: g, blueInt: b)
        }
    }
    
    /// Creates a color from RGB value.
    ///
    /// This allows creation of colors like:
    /// `UIColor(rgb: 0xFF00DDFF)`
    ///
    /// - Parameter rgba: an integer representing RGB values, Hex work the best
    ///
    /// - Notes:
    ///   -  Has to be UInt32 to support 0xFFFFFFFF on 32 bit devices
    public convenience init(rgba: UInt32) {
        let r = UInt8((rgba & 0xFF000000) >> 24)
        let g = UInt8((rgba & 0x00FF0000) >> 16)
        let b = UInt8((rgba & 0x0000FF00) >> 8)
        let a = UInt8(rgba & 0x000000FF)
        self.init(redInt: r, greenInt: g, blueInt: b, alphaInt: a)
    }
    
    /// Returns a random color
    ///
    /// - Returns: random UIColor()
    public static func randomColor() -> UIColor {
        let hue: CGFloat = CGFloat(arc4random() % 256) / 256
        let saturation: CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5
        let brightness: CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
