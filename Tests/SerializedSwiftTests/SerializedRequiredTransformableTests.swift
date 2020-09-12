//
//  SerializedRequiredTransformableTests.swift
//  
//
//  Created by Dejan Skledar on 11/09/2020.
//

import Foundation
import XCTest
@testable import SerializedSwift

final class SerializedRequiredTransformableTests: XCTestCase {
    
    func testRequiredTransformable() {
        
        //
        // Custom transforming
        //
        class StringToNumberRequired: RequiredTransformable {
            static func transformFromJSON(from value: String?) -> Int {
                return Int(value ?? "") ?? -1
            }
            
            static func transformToJson(from value: Int?) -> String {
                return value?.description ?? ""
            }
        }
        
        class User: Serializable {
            @SerializedRequiredTransformable<StringToNumberRequired>("height")
            var height: Int
            
            @SerializedRequiredTransformable<StringToNumberRequired>("age")
            var age: Int
            
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
            XCTAssertEqual(user.height, -1)
            
            let json = try JSONEncoder().encode(user)
            let newUser = try JSONDecoder().decode(User.self, from: json)
            
            XCTAssertEqual(newUser.age, 18)
            XCTAssertEqual(newUser.height, -1)
            
        } catch {
            XCTFail()
        }
    }
    
    static var allTests = [
        ("testRequiredTransformable", testRequiredTransformable)
    ]
}
