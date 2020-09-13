//
//  File.swift
//  
//
//  Created by Dejan Skledar on 07/09/2020.
//

import Foundation

// Default value is optional, but will result in a CRASH if JSON key is missing,
// and no default value is present
// Crash can occur when accessing the property in the wrapperValue getter
// Use with care
@propertyWrapper
public final class SerializedRequired<T> {
    let key: String?
    let alternateKey: String?
    var value: T?
    
    public var wrappedValue: T {
        get {
            return value!
        } set {
            value = newValue
        }
    }
    
    public init(_ key: String? = nil, alternateKey: String? = nil, default value: T? = nil) {
        self.key = key
        self.alternateKey = alternateKey
        self.value = value
    }
    
    public init(default value: T? = nil) {
        self.key = nil
        self.alternateKey = nil
        self.value = value
    }
}

// Encodable support
extension SerializedRequired: EncodableProperty where T: Encodable {
    public func encodeValue(from container: inout EncodeContainer, propertyName: String) throws {
        let codingKey = SerializedCodingKeys(key: key ?? propertyName)
        try container.encode(wrappedValue, forKey: codingKey)
    }
}

// Decodable support
extension SerializedRequired: DecodableProperty where T: Decodable {
    public func decodeValue(from container: DecodeContainer, propertyName: String) throws {
        let codingKey = SerializedCodingKeys(key: key ?? propertyName)
        
        if let value = try? container.decodeIfPresent(T.self, forKey: codingKey) {
            self.value = value
        } else if let altKey = alternateKey {
            let altCodingKey = SerializedCodingKeys(key: altKey)
            value = try? container.decodeIfPresent(T.self, forKey: altCodingKey)
        }
    }
}
