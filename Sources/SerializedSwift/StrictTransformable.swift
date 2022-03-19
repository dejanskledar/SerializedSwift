//
//  StrictTransformable.swift
//  
//
//  Created by Leah Lundqvist on 2022-03-19.
//

import Foundation

public typealias StrictTransformable = StrictTransformableFromJSON & StrictTransformableToJSON

/// StrictTransformableFromJSON protocol for JSON Decoding
public protocol StrictTransformableFromJSON {
    associatedtype From: Any
    associatedtype To: Any
    
    static func transformFromJSON(value: From) -> To
}

// StrictTransformableToJSON for JSON Encoding
public protocol StrictTransformableToJSON {
    associatedtype From: Any
    associatedtype To: Any
    
    static func transformToJSON(value: To) -> From
}
