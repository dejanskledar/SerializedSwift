//
//  EncodableProperty.swift
//  
//
//  Created by Dejan Skledar on 05/09/2020.
//

import Foundation

protocol EncodableProperty {
    typealias EncodeContainer = KeyedEncodingContainer<SerializedCodingKeys>

    func encodeValue(from container: inout EncodeContainer, propertyName: String) throws
}
