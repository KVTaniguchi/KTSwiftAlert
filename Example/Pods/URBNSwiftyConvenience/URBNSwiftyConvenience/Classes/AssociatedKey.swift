//
//  AssociatedKey.swift
//  Pods
//
//  Created by Matt Thomas on 7/24/17.
//
//

import Foundation

public final class AssociatedKey: CustomStringConvertible {
    public let identifier: String
    
    public init(_ id: String) {
        identifier = id
    }
    
    public var description: String {
        return "<\(type(of: self)): \(Unmanaged.passUnretained(self).toOpaque())> - identifier: \(identifier)"
    }
}
