//
//  SerializedCodingKeys.swift
//  
//
//  Created by Dejan Skledar on 05/09/2020.
//

import Foundation

///
///
/// Dynamic Coding Key Object
///
///

public struct SerializedCodingKeys: CodingKey {
    public var stringValue: String
    public var intValue: Int?

    public init(key: String) {
        stringValue = key
    }
    
    public init?(stringValue: String) {
        self.stringValue = stringValue
    }

    public init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = String(intValue)
    }
}
