//
//  SerializedRequiredSwiftTests.swift
//  
//
//  Created by Dejan Skledar on 07/09/2020.
//

import XCTest
@testable import SerializedSwift

final class SerializedRequiredSwiftTests: XCTestCase {
    
    func testDictionary() {
        class Foo: Serializable {
            @Serialized
            var bar: [String: String]
            
            required init() {}
        }
        
        let json = """
          {
              "bar": {
                  "abc": "123",
                  "def": "456",
                  "ghi": "789"
                }
          }
          """
        guard let data = json.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        do {
            let foo = try JSONDecoder().decode(Foo.self, from: data)
            
            XCTAssertEqual(foo.bar.count, 3)
            XCTAssertEqual(foo.bar["abc"], "123")
            XCTAssertEqual(foo.bar["ghi"], "789")
            
            let json = try JSONEncoder().encode(foo)
            let newFoo = try JSONDecoder().decode(Foo.self, from: json)
            
            XCTAssertEqual(newFoo.bar.count, 3)
            XCTAssertEqual(newFoo.bar["abc"], "123")
            XCTAssertEqual(newFoo.bar["ghi"], "789")
            
        } catch {
            XCTFail()
        }
    }
    
    func testArray() {
        class Foo: Serializable {
            @Serialized
            var foo: [String]
            
            @Serialized
            var bar: [Int]?
            
            @Serialized(default: [])
            var gor: [Int]
            
            required init() {}
        }
        
        let json = """
          {
              "foo": ["A", "B", "C"],
              "bar": [2, 5, 8, 0],
              "gor": "Wrong"
          }
          """
        
        guard let data = json.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        do {
            let object = try JSONDecoder().decode(Foo.self, from: data)
            
            XCTAssertEqual(object.foo, ["A", "B", "C"])
            XCTAssertEqual(object.bar, [2, 5, 8, 0])
            XCTAssertEqual(object.gor, [])
            
            let json = try JSONEncoder().encode(object)
            let newObject = try JSONDecoder().decode(Foo.self, from: json)
            
            XCTAssertEqual(newObject.foo, ["A", "B", "C"])
            XCTAssertEqual(newObject.bar, [2, 5, 8, 0])
            XCTAssertEqual(newObject.gor, [])
            
        } catch {
            XCTFail()
        }
    }
    
    func testNonSerializableButCodableComposition() {
        class Foo: Serializable {
            @Serialized
            var foo: String
            
            // Bar class is Codable only (Not Serializable)
            @Serialized
            var bar: Bar
            
            required init() {}
        }
        
        class Bar: Codable {
            var fooBar: String?
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
    
    static var allTests = [
        ("testBasicJSONDecode", testDictionary),
        ("testInheritance", testArray),
        ("testComposition", testNonSerializableButCodableComposition)
    ]
}
