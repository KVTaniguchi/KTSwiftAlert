//
//  Geometry+Additions.swift
//  WhiteLabel
//
//  Created by Matt Thomas on 7/18/17.
//
//

import UIKit

extension Array where Element == CGFloat {
    
    /// Adds all the CGFloat with padding between each one. Useful for calculating UIStackView geometry with a consistent spacing.
    ///
    /// - Parameter padding: any padding between float elements
    /// - Returns: The the elements added with padding between them
    public func add(withPadding padding: CGFloat = 0.0) -> CGFloat {
        return self.reduce(0, +) + (CGFloat(self.count - 1) * padding)
    }
}

extension Int {
    
    /// Converts pixels to points __safely__
    ///
    /// - Parameter scaleFactor: scale factor of display
    /// - Returns: the number of points that pixel represents in the scale factor
    public func pixelsToPoints(forContentScaleFactor scaleFactor: CGFloat) -> CGFloat {
        return CGFloat(self) / ((scaleFactor > 1) ? scaleFactor : 1.0)
    }
}
