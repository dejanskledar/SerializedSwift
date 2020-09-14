//
//  SerializableEncodable.swift
//  
//
//  Created by Dejan Skledar on 05/09/2020.
//

import Foundation

//
//
/// SerializableEncodable protocol to be used for Encoding only
//
//

public protocol SerializableEncodable: Encodable {}

//
//
/// Extending the SerializableEncodable with basic encoding of
/// current and all superclasses that have EncodableKey
//
//

public extension SerializableEncodable {
    
    /// Encodes all properties wrapped with `SerializableEncodable` (or `Serialized`)
    /// - Parameter encoder: The default encoder
    /// - Throws: Throws JSON Encoding error
    func encode(to encoder: Encoder) throws {
        // Get the container keyed by the SerializedCodingKeys defined by the propertyWrapper @Serialized
        var container = encoder.container(keyedBy: SerializedCodingKeys.self)
        
        // Mirror for current model
        var mirror: Mirror? = Mirror(reflecting: self)

        // Go through all mirrors (till top most superclass)
        repeat {
            // If mirror is nil (no superclassMirror was nil), break
            guard let children = mirror?.children else { break }
            
            // Try to encode each child
            for child in children {
                guard let encodableKey = child.value as? EncodableProperty else { continue }
                
                // Get the propertyName of the property. By syntax, the property name is
                // in the form: "_name". Dropping the "_" -> "name"
                let propertyName = String((child.label ?? "").dropFirst())
                
                // propertyName here is not neceserly used in the `encodeValue` method
                try encodableKey.encodeValue(from: &container, propertyName: propertyName)
            }
            mirror = mirror?.superclassMirror
        } while mirror != nil
    }
}
