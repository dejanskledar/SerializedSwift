# SerializedSwift

[![Swift Package Manager](https://img.shields.io/badge/swift%20package%20manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
![Platforms](https://img.shields.io/static/v1?label=Platforms&message=iOS%20|%20macOS%20|%20tvOS%20|%20watchOS%20|%20Linux&color=brightgreen)

## A GSON inspired JSON decoding strategy in Swift using @propertyWrappers.

**Features:**
- No need to write own `init(from decoder: Decoder)`
- No need to write own CodingKeys subclass
- Works with inheritance and composition out of the box
- Custom Transformer classes
- Alternative coding keys
- Default values if JSON key is missing

## Installation

### Codoapods
// TODO

### Swift Package manager
If you are using SPM for your dependency manager, add this to the dependencies in your `Package.swift` file:
```
dependencies: [
    .package(url: "https://github.com/dejanskledar/SerializableSwift.git")
]
````

## Requirements

- iOS 10.0+ / macOS 10.12+ / tvOS 10.0+ / watchOS 3.0+
- Xcode 11+
- Swift 5.1+

## Usage
```swift
class User: Serializable {

    @Serialized
    var name: String?
    
    @Serialized("globalId")
    var id: String?
    
    @Serialized(alternateKey: "mobileNumber")
    var phoneNumber: String?
    
    @SerializedRequired(default: 0)
    var score: Int
    
    required init() {}
}
```

### Works with inheritance
No additional decoding logic needed
```swift
class PowerUser: User {
    @Serialized
    var powerName: String?

    @SerializedRequired(default: 0)
    var credit: Int
}
```

### Works with composition
No additional decoding logic needed
```swift
class ChatRoom: Serializable {
    @Serialized
    var admin: PowerUser?

    @SerializedRequired(default: [])
    var users: [User]
}
```

### Custom transformer classes
You can create own custom Transformable classes, for custom transformation logic.
```swift
class DateTransformer: Transformable {
    static func transformFromJSON(from value: String) -> Date? {
        let formatter = DateFormatter()
        return formatter.date(from: value)
    }
    
    static func transformToJson(from value: Date) -> String? {
        let formatter = DateFormatter()
        return formatter.string(from: value)
    }
}

struct User: Serializable {
    @SerializedTransformable<DateTransformer>
    var birthDate: Date?
}
```

**`RequiredTransformable`** for non-optional properties:


## Features
###  `Serializable`
   - typealias-ed from `SerializableEncodable` & `SerializableDecodable`
   - Custom decoding and encoding using propertyWrappers (listed below)
   - Use this protocol for your classes and structures in the combination with the property wrappers belos
   
### `Serialized`
- Standard serialization propertyWrappers
- Used for wrapping an optional property.
- Custom decoding Key
- By default using the propertyName as a Decoding Key
- Alternative Decoding Key support
- Optional Default value (if the key is missing). By default, the Default value is `nil`

```swift
@Serialized("primaryKey", alternativeKey: "backupKey", default: "")
var key: String?
```

### `SerializedRequired`
- Similar to `Serialized`, but for wrapping a non-optional property.
- Will crash while accessing the property, if the key was missing in the JSON, and no `default` value was set

```swift
@SerializedRequired("primaryKey", alternativeKey: "backupKey", default: "")
var key: String
```

### `SerializedTransformable`
- Custom transforming property wrapper
- Create own Transformable classes

```swift
 class DateTransformer: Transformable {
     static func transformFromJSON(from value: String) -> Date? {
         let formatter = DateFormatter()
         return formatter.date(from: value)
     }
     
     static func transformToJson(from value: Date) -> String? {
         let formatter = DateFormatter()
         return formatter.string(from: value)
     }
 }

 // Usage of `SerializedTransformable`
 struct User: Serializable {
     @SerializedTransformable<DateTransformer>
     var birthDate: Date?
 } 
```

### `SerializedRequiredTransformable`
- Similar to `SerializedTransformable` but working with non-optionals

```swift
 class DateTransformer: RequiredTransformable {
     static func transformFromJSON(from value: String?) -> Date {
         let formatter = DateFormatter()
         return formatter.date(from: value)
     }
     
     static func transformToJson(from value: Date?) -> String {
         let formatter = DateFormatter()
         return formatter.string(from: value)
     }
 }

 // Usage of `SerializedRequiredTransformable` with non-optional Date
 struct User: Serializable {
     @SerializedRequiredTransformable<DateTransformer>
     var birthDate: Date
 } 
```

### Contribute

This is only a tip of the iceberg of what can one achieve using Property Wrappers and how se can improve Decoding and Encoding JSON in Swift. Feel free to colaborate. 
