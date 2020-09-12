//
//  SerializedRequiredSwiftTests.swift
//  
//
//  Created by Dejan Skledar on 07/09/2020.
//

import XCTest
@testable import SerializedSwift

final class SerializedRequiredSwiftTests: XCTestCase {
    
    func testBasicJSONDecode() {
        class User: Serializable {
            @SerializedRequired
            var surname: String
            
            @SerializedRequired("home_address")
            var address: String
            
            @SerializedRequired("phone_number")
            var phoneNumber: String
            
            @SerializedRequired("token", alternateKey: "authorization")
            var token: String
            
            required init() {}
        }
        
        let json = """
          {
              "surname": "Dejan",
              "home_address": "Slovenia",
              "phone_number": "+386 30 123 456",
              "authorization": "Bearer jyQ84iajndfjdkfbn9342938jf"
          }
          """
        guard let data = json.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            
            XCTAssertEqual(user.surname, "Dejan")
            XCTAssertEqual(user.address, "Slovenia")
            XCTAssertEqual(user.phoneNumber, "+386 30 123 456")
            XCTAssertEqual(user.token, "Bearer jyQ84iajndfjdkfbn9342938jf")
            
            let json = try JSONEncoder().encode(user)
            let newUser = try JSONDecoder().decode(User.self, from: json)
            
            XCTAssertEqual(newUser.surname, "Dejan")
            XCTAssertEqual(newUser.address, "Slovenia")
            XCTAssertEqual(newUser.phoneNumber, "+386 30 123 456")
            XCTAssertEqual(newUser.token, "Bearer jyQ84iajndfjdkfbn9342938jf")
            
        } catch {
            XCTFail()
        }
    }
    
    func testInheritance() {
        class Foo: Serializable {
            @SerializedRequired
            var foo: String
            
            required init() {}
        }
        
        class Bar: Foo {
            @SerializedRequired
            var bar: String
            
            required init() {}
        }
        
        let json = """
          {
              "foo": "Foo is in superclass!",
              "bar": "Bar is in subclass!"
          }
          """
        
        guard let data = json.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        do {
            let object = try JSONDecoder().decode(Bar.self, from: data)
            
            XCTAssertEqual(object.foo, "Foo is in superclass!")
            XCTAssertEqual(object.bar, "Bar is in subclass!")
            
            let json = try JSONEncoder().encode(object)
            let newObject = try JSONDecoder().decode(Bar.self, from: json)
            
            XCTAssertEqual(newObject.foo, "Foo is in superclass!")
            XCTAssertEqual(newObject.bar, "Bar is in subclass!")
            
        } catch {
            XCTFail()
        }
    }
    
    func testComposition() {
        class Foo: Serializable {
            @SerializedRequired
            var foo: String
            
            @SerializedRequired
            var bar: Bar
            
            required init() {}
        }
        
        class Bar: Serializable {
            @SerializedRequired
            var fooBar: String
            
            required init() {}
        }
        
        let json = """
          {
              "foo": "Basic foo!",
              "bar": {
                "fooBar": "Bar for foo!"
              }
          }
          """
        
        guard let data = json.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        do {
            let object = try JSONDecoder().decode(Foo.self, from: data)
            
            XCTAssertEqual(object.foo, "Basic foo!")
            XCTAssertEqual(object.bar.fooBar, "Bar for foo!")
            
            let json = try JSONEncoder().encode(object)
            let newObject = try JSONDecoder().decode(Foo.self, from: json)
            
            XCTAssertEqual(newObject.foo, "Basic foo!")
            XCTAssertEqual(newObject.bar.fooBar, "Bar for foo!")
            
        } catch {
            XCTFail()
        }
    }
    
    func testAlternateKey() {
        class User: Serializable {
            @SerializedRequired("name", alternateKey: "full_name")
            var name: String
            
            @SerializedRequired("city", alternateKey: "town")
            var post: String
            
            required init() {}
        }
        let json = """
          {
              "full_name": "Foo Bar",
              "town": "Maribor"
          }
          """
        
        guard let data = json.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        do {
            let object = try JSONDecoder().decode(User.self, from: data)
            
            XCTAssertEqual(object.name, "Foo Bar")
            XCTAssertEqual(object.post, "Maribor")
            
            let json = try JSONEncoder().encode(object)
            let newObject = try JSONDecoder().decode(User.self, from: json)
            
            XCTAssertEqual(newObject.name, "Foo Bar")
            XCTAssertEqual(newObject.post, "Maribor")
            
        } catch {
            XCTFail()
        }
    }
    
    func testAlternateKeyAndPrimaryKeyBothPresent() {
        struct User: Serializable {
            @SerializedRequired("name", alternateKey: "full_name")
            var name: String
        }
        
        let json = """
          {
              "full_name": "Foo Bar",
              "name": "Foo"
          }
          """
        
        guard let data = json.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        do {
            let object = try JSONDecoder().decode(User.self, from: data)
            
            XCTAssertEqual(object.name, "Foo")
            
            let json = try JSONEncoder().encode(object)
            let newObject = try JSONDecoder().decode(User.self, from: json)
            
            XCTAssertEqual(newObject.name, "Foo")
            
        } catch {
            XCTFail()
        }
    }
    
    func testMissingKey_Should_Fail() {
        struct User: Serializable {
            @SerializedRequired
            var name: String
        }
        
        let json = """
          {
              "full_name": "Foo Bar"
          }
          """
        
        guard let data = json.data(using: .utf8) else {
            XCTFail()
            return
        }

        // Should not crash..
        // Will crash when accessing user?.name property
        let _ = try? JSONDecoder().decode(User.self, from: data)
    }
    
    static var allTests = [
        ("testBasicJSONDecode", testBasicJSONDecode),
        ("testInheritance", testInheritance),
        ("testComposition", testComposition),
        ("testAlternateKey", testAlternateKey),
        ("testAlternateKeyAndPrimaryKeyBothPresent", testAlternateKeyAndPrimaryKeyBothPresent),
        ("testMissingKey_Should_Fail", testMissingKey_Should_Fail)
    ]
}
