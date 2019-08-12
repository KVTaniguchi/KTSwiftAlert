//
//  Operators.swift
//  Pods-URBNSwiftyConvenience_Example
//
//  Created by Matt Thomas on 7/6/18.
//

import Foundation

// MARK: - Conditional Assignment
infix operator ?=

/**
 Conditionally set the LHS if the RHS exists. This is useful for dictiona
 
 - Parameters:
   - left: The type being assigned
   - right: An optiona type to assign

 - Example: *Conditional `Dictionary` assignment.*\
   ```
   myDict["foo"] ?= optionalVar // Will only set myDict["foo"] if `optionalVar` is set
   ```
 */
public func ?=<T>(left: inout T, right: T?) {
    if let right = right {
        left = right
    }
}
