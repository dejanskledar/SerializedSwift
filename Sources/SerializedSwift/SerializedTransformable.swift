//
//  SerializedTransformable.swift
//  
//
//  Created by Dejan Skledar on 08/09/2020.
//

import Foundation

@propertyWrapper
public final class SerializedTransformable<T: Transformable> {
    var key: String?
    var alternateKey: String?
    public var wrappedValue: T.To?
    
    public init(_ key: String? = nil, alternateKey: String? = nil, default defaultValue: T.To? = nil) {
        self.key = key
        self.alternateKey = alternateKey
        self.wrappedValue = defaultValue
    }
    
    public init(default defaultValue: T.To? = nil) {
        self.key = nil
        self.alternateKey = nil
        self.wrappedValue = defaultValue
    }
}

extension SerializedTransformable: EncodableProperty where T.From: Encodable {
    public func encodeValue(from container: inout EncodeContainer, propertyName: String) throws {
        let codingKey = SerializedCodingKeys(key: key ?? propertyName)
        guard let value = wrappedValue else { return }
        try container.encode(T.transformToJson(from: value), forKey: codingKey)
    }
}

extension SerializedTransformable: DecodableProperty where T.From: Decodable {
    public func decodeValue(from container: DecodeContainer, propertyName: String) throws {
        let codingKey = SerializedCodingKeys(key: key ?? propertyName)

        if let value = try? container.decodeIfPresent(T.From.self, forKey: codingKey),
            let transformedValue = T.transformFromJSON(from: value) {
            wrappedValue = transformedValue
        } else {
            guard let altKey = alternateKey else { return }
            let altCodingKey = SerializedCodingKeys(key: altKey)
            if let value = try? container.decodeIfPresent(T.From.self, forKey: altCodingKey),
                let transformedValue = T.transformFromJSON(from: value) {
                wrappedValue = transformedValue
            }
        }
    }
}
