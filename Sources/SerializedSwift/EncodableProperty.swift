//
//  EncodableProperty.swift
//  
//
//  Created by Dejan Skledar on 05/09/2020.
//

import Foundation

///
///
/// Encodable property protocol implemented in Serialized where Wrapped Value is Encodable
///
///

public protocol EncodableProperty {
    typealias EncodeContainer = KeyedEncodingContainer<SerializedCodingKeys>

    func encodeValue(from container: inout EncodeContainer, propertyName: String) throws
}
