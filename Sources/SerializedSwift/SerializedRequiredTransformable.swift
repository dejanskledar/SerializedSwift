//
//  SerializedRequiredTransformable.swift
//  
//
//  Created by Dejan Skledar on 08/09/2020.
//

import Foundation

@propertyWrapper
public final class SerializedRequiredTransformable<T: RequiredTransformable> {
    let key: String?
    let alternateKey: String?
    var value: T.To?
    
    public var wrappedValue: T.To {
        get {
            return value!
        } set {
            value = newValue
        }
    }
    
    public init(_ key: String? = nil, alternateKey: String? = nil) {
        self.key = key
        self.alternateKey = alternateKey
        self.value = nil
    }
    
    public init() {
        self.key = nil
        self.alternateKey = nil
        self.value = nil
    }
}

extension SerializedRequiredTransformable: DecodableProperty where T.From: Decodable {
    public func decodeValue(from container: DecodeContainer, propertyName: String) throws {
        let codingKey = SerializedCodingKeys(key: key ?? propertyName)
        
        if let value = try? container.decodeIfPresent(T.From.self, forKey: codingKey) {
            self.value = T.transformFromJSON(from: value)
        } else if let altKey = alternateKey {
            let altCodingKey = SerializedCodingKeys(key: altKey)
            let value = try? container.decodeIfPresent(T.From.self, forKey: altCodingKey)
            self.value = T.transformFromJSON(from: value)
        } else {
            self.value = T.transformFromJSON(from: nil)
        }
    }
}

extension SerializedRequiredTransformable: EncodableProperty where T.From: Encodable {
    public func encodeValue(from container: inout EncodeContainer, propertyName: String) throws {
        let codingKey = SerializedCodingKeys(key: key ?? propertyName)
        try container.encode(T.transformToJson(from: value), forKey: codingKey)
    }
}
