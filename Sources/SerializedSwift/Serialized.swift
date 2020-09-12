//
//  File.swift
//  
//
//  Created by Dejan Skledar on 07/09/2020.
//

import Foundation

public typealias Serializable = SerializableEncodable & SerializableDecodable

// Default value is by default nil. Can be used directly without arguments
@propertyWrapper
final class Serialized<T> {
    let key: String?
    let alternateKey: String?
    var value: T?
    
    var wrappedValue: T? {
        get {
            return value
        } set {
            value = newValue
        }
    }
    
    init(_ key: String? = nil, alternateKey: String? = nil, default value: T? = nil) {
        self.key = key
        self.alternateKey = alternateKey
        self.value = value
    }
    
    init(default value: T? = nil) {
        self.key = nil
        self.alternateKey = nil
        self.value = value
    }
}

// Encodable support
extension Serialized: EncodableProperty where T: Encodable {
    func encodeValue(from container: inout EncodeContainer, propertyName: String) throws {
        let codingKey = SerializedCodingKeys(key: key ?? propertyName)
        try container.encodeIfPresent(wrappedValue, forKey: codingKey)
    }
}

// Decodable support
extension Serialized: DecodableProperty where T: Decodable {
    func decodeValue(from container: DecodeContainer, propertyName: String) throws {
        let codingKey = SerializedCodingKeys(key: key ?? propertyName)

        if let value = try? container.decodeIfPresent(T.self, forKey: codingKey) {
            wrappedValue = value
        } else {
            guard let altKey = alternateKey else { return }
            let altCodingKey = SerializedCodingKeys(key: altKey)
            wrappedValue = try? container.decodeIfPresent(T.self, forKey: altCodingKey)
        }
    }
}
