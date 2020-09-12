//
//  RequiredTransformable.swift
//  
//
//  Created by Dejan Skledar on 11/09/2020.
//

import Foundation

public typealias RequiredTransformable = RequiredTransformableFromJSOn & RequiredTransformableToJSON

public protocol RequiredTransformableFromJSOn {
    associatedtype From: Any
    associatedtype To: Any
    
    static func transformFromJSON(from value: From?) -> To
}

public protocol RequiredTransformableToJSON {
    associatedtype From: Any
    associatedtype To: Any
    
    static func transformToJson(from value: To?) -> From
}
