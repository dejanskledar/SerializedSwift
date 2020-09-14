//
//  File.swift
//  
//
//  Created by Dejan Skledar on 07/09/2020.
//

import Foundation

public typealias Serializable = SerializableEncodable & SerializableDecodable

@propertyWrapper
/// Property wrapper for Serializable (Encodable + Decodable) properties.
/// The Object itself must conform to Serializable (or SerializableEncodable / SerializableDecodable)
/// Default value is by default nil. Can be used directly without arguments
public final class Serialized<T> {
    var key: String?
    var alternateKey: String?
    
    private var _value: T?
    
    /// Wrapped value getter for optionals
    private func _wrappedValue<U>(_ type: U.Type) -> U? where U: ExpressibleByNilLiteral {
        return _value as? U
    }
    
    /// Wrapped value getter for non-optionals
    private func _wrappedValue<U>(_ type: U.Type) -> U {
        return _value as! U
    }
    
    public var wrappedValue: T {
        get {
            return _wrappedValue(T.self)
        } set {
            _value = newValue
        }
    }
    
    /// Defualt init for Serialized wrapper
    /// - Parameters:
    ///   - key: The JSON decoding key to be used. If `nil` (or not passed), the property name gets used for decoding
    ///   - alternateKey: The alternative JSON decoding key to be used, if the primary decoding key fails
    ///   - value: The default value to be used, if the decoding fails. If not passed, `nil` is used.
    public init(_ key: String? = nil, alternateKey: String? = nil, default value: T? = nil) {
        self.key = key
        self.alternateKey = alternateKey
        self._value = value
    }
}

/// Encodable support
extension Serialized: EncodableProperty where T: Encodable {
    
    /// Basic property encoding with the key (if present), or propertyName if key not present
    /// - Parameters:
    ///   - container: The default container
    ///   - propertyName: The Property Name to be used, if key is not present
    /// - Throws: Throws JSON encoding errorj
    public func encodeValue(from container: inout EncodeContainer, propertyName: String) throws {
        let codingKey = SerializedCodingKeys(key: key ?? propertyName)
        try container.encodeIfPresent(wrappedValue, forKey: codingKey)
    }
}

/// Decodable support
extension Serialized: DecodableProperty where T: Decodable {
    
    /// Adding the DecodableProperty support for Serialized annotated objects, where the Object conforms to Decodable
    /// - Parameters:
    ///   - container: The decoding container
    ///   - propertyName: The property name of the Wrapped property. Used if no key (or nil) is present
    /// - Throws: Doesnt throws anything; Sets the wrappedValue to nil instead (possible crash for non-optionals if no default value was set)
    public func decodeValue(from container: DecodeContainer, propertyName: String) throws {
        let codingKey = SerializedCodingKeys(key: key ?? propertyName)

        if let value = try? container.decodeIfPresent(T.self, forKey: codingKey) {
            wrappedValue = value
        } else {
            guard let altKey = alternateKey else { return }
            let altCodingKey = SerializedCodingKeys(key: altKey)
            if let value = try? container.decodeIfPresent(T.self, forKey: altCodingKey) {
                wrappedValue = value
            }
        }
    }
}
