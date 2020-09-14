//
//  SerializedTransformableSwiftTests.swift
//  
//
//  Created by Dejan Skledar on 07/09/2020.
//

import Foundation
import XCTest
@testable import SerializedSwift

final class SerializedTransformableSwiftTests: XCTestCase {
    
    //
    // Custom transforming
    //
    class StringToNumber: Transformable {
        static func transformFromJSON(value: String?) -> Int? {
            return Int(value ?? "")
        }
        
        static func transformToJSON(value: Int?) -> String? {
            return value?.description
        }
    }
    
    func testTransformable() {

        class User: Serializable {
            @SerializedTransformable<StringToNumber>("height")
            var height: Int?
            
            @SerializedTransformable<StringToNumber>("age")
            var age: Int?
            
            required init() {}
        }
        
        let json = """
          {
              "age": "18",
              "height": "asd"
          }
          """
        guard let data = json.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            
            XCTAssertEqual(user.age, 18)
            XCTAssertEqual(user.height, nil)
            
            let json = try JSONEncoder().encode(user)
            let newUser = try JSONDecoder().decode(User.self, from: json)
            
            XCTAssertEqual(newUser.age, 18)
            XCTAssertEqual(newUser.height, nil)
            
        } catch {
            XCTFail()
        }
    }
    
    
    func testOptionalTransformable() {

        class User: Serializable {
            @SerializedTransformable<StringToNumber>("age")
            var age: Int?
            
            @SerializedTransformable<StringToNumber>("weight")
            var weight: Int?
            
            @SerializedTransformable<StringToNumber>("height")
            var height: Int?
            
            required init() {}
        }
        
        let json = """
          {
              "age": "22",
              "weight": "80",
              "height": "asd"
          }
          """
        guard let data = json.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            
            XCTAssertEqual(user.age, 22)
            XCTAssertEqual(user.height, nil)
            
            let json = try JSONEncoder().encode(user)
            let newUser = try JSONDecoder().decode(User.self, from: json)
            
            XCTAssertEqual(newUser.age, 22)
            XCTAssertEqual(user.height, nil)
            
        } catch {
            XCTFail()
        }
    }
    
    static var allTests = [
        ("testTransformable", testTransformable)
    ]
}
