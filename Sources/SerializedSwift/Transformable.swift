//
//  Transformable.swift
//  
//
//  Created by Dejan Skledar on 05/09/2020.
//

import Foundation

public typealias Transformable = TransformableFromJSON & TransformableToJSON

/// TransformableFromJSON protocol for JSON Decoding
public protocol TransformableFromJSON {
    associatedtype From: Any
    associatedtype To: Any
    
    static func transformFromJSON(value: From?) -> To?
}

// TransformableToJSON for JSON Encoding
public protocol TransformableToJSON {
    associatedtype From: Any
    associatedtype To: Any
    
    static func transformToJSON(value: To?) -> From?
}
