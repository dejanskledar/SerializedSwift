//
//  SerializedRequiredTransformable.swift
//  
//
//  Created by Dejan Skledar on 08/09/2020.
//

import Foundation

@propertyWrapper
///
/// Transformable Serialized Property Wrapper for properties that are transformed with the T: Transformable class.
///
public final class SerializedTransformable<T: Transformable> {
    let key: String?
    let alternateKey: String?
    public var wrappedValue: T.To?
    
    public init(_ key: String? = nil, alternateKey: String? = nil) {
        self.key = key
        self.alternateKey = alternateKey
        self.wrappedValue = nil
    }
}

// Encodable support
extension SerializedTransformable: EncodableProperty where T.From: Encodable {
    
    /// Property encoding using the Transformable object - custom transformation
    /// - Parameters:
    ///   - container: The default container
    ///   - propertyName: The Property Name to be used, if key is not present
    /// - Throws: Throws JSON encoding errorj
    public func encodeValue(from container: inout EncodeContainer, propertyName: String) throws {
        let codingKey = SerializedCodingKeys(key: key ?? propertyName)
        // Encoding the transformed value to JSON value object
        try container.encode(T.transformToJSON(value: wrappedValue), forKey: codingKey)
    }
}

// Decodable support
extension SerializedTransformable: DecodableProperty where T.From: Decodable {
    
    /// Property decoding using the Transformable object. Firstly the JSON object is decoded as per T.From type, then it is transformed to the T.To type
    /// using the `transformFromJSON` method.
    /// - Parameters:
    ///   - container: The decoding container
    ///   - propertyName: The property name of the Wrapped property. Used if no key (or nil) is present
    /// - Throws: Doesnt throws anything; Sets the wrappedValue to nil instead (possible crash for non-optionals if no default value was set)
    public func decodeValue(from container: DecodeContainer, propertyName: String) throws {
        let codingKey = SerializedCodingKeys(key: key ?? propertyName)
        
        if let value = try? container.decodeIfPresent(T.From.self, forKey: codingKey) {
            self.wrappedValue = T.transformFromJSON(value: value)
        } else if let altKey = alternateKey {
            let altCodingKey = SerializedCodingKeys(key: altKey)
            let value = try? container.decodeIfPresent(T.From.self, forKey: altCodingKey)
            self.wrappedValue = T.transformFromJSON(value: value)
        } else {
            self.wrappedValue = T.transformFromJSON(value: nil)
        }
    }
}
