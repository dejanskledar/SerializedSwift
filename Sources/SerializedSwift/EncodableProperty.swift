//
//  EncodableProperty.swift
//  
//
//  Created by Dejan Skledar on 05/09/2020.
//

import Foundation

public protocol EncodableProperty {
    typealias EncodeContainer = KeyedEncodingContainer<SerializedCodingKeys>

    func encodeValue(from container: inout EncodeContainer, propertyName: String) throws
}
