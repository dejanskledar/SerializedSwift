//
//  SerializedCodingKeys.swift
//  
//
//  Created by Dejan Skledar on 05/09/2020.
//

import Foundation

struct SerializedCodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int?

    init(key: String) {
        stringValue = key
    }

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = String(intValue)
    }
}
