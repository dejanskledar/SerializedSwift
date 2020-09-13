//
//  DecodableProperty.swift
//  
//
//  Created by Dejan Skledar on 05/09/2020.
//

import Foundation

public protocol DecodableProperty {
    typealias DecodeContainer = KeyedDecodingContainer<SerializedCodingKeys>
    
    func decodeValue(from container: DecodeContainer, propertyName: String) throws
}
