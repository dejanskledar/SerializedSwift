//
//  Transformable.swift
//  
//
//  Created by Dejan Skledar on 05/09/2020.
//

import Foundation

public typealias Transformable = TransformableFromJSOn & TransformableToJSON

public protocol TransformableFromJSOn {
    associatedtype From: Any
    associatedtype To: Any
    
    static func transformFromJSON(from value: From) -> To?
}

public protocol TransformableToJSON {
    associatedtype From: Any
    associatedtype To: Any
    
    static func transformToJson(from value: To) -> From?
}
