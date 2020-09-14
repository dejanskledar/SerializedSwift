//
//  SerializedDecodable.swift
//  
//
//  Created by Dejan Skledar on 05/09/2020.
//

import Foundation

//
//
/// SerializableDecodable protocol to be used for Decoding only
//
//

public protocol SerializableDecodable: Decodable {
    init()
    func decode(from decoder: Decoder) throws
}

//
//
/// Extending the SerializableDecodable with basic decoding of
/// current and all superclasses that have DecodableKey
//
//

public extension SerializableDecodable {
    
    /// Main decoding logic. Decodes all properties marked with @Serialized
    /// - Parameter decoder: The JSON Decoder
    /// - Throws: Throws JSON Decoding error if present
    func decode(from decoder: Decoder) throws {
        // Get the container keyed by the SerializedCodingKeys defined by the propertyWrapper @Serialized
        let container = try decoder.container(keyedBy: SerializedCodingKeys.self)
        
        // Mirror for current model
        var mirror: Mirror? = Mirror(reflecting: self)

        // Go through all mirrors (till top most superclass)
        repeat {
            // If mirror is nil (no superclassMirror was nil), break
            guard let children = mirror?.children else { break }
            
            // Try to decode each child
            for child in children {
                guard let decodableKey = child.value as? DecodableProperty else { continue }
                
                // Get the propertyName of the property. By syntax, the property name is
                // in the form: "_name". Dropping the "_" -> "name"
                let propertyName = String((child.label ?? "").dropFirst())
                
                try decodableKey.decodeValue(from: container, propertyName: propertyName)
            }
            mirror = mirror?.superclassMirror
        } while mirror != nil
    }

    init(from decoder: Decoder) throws {
        self.init()
        try decode(from: decoder)
    }
}
