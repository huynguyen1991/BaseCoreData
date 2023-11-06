//
//  TestTable.swift
//  BaseCoreData_Example
//
//  Created by Nguyen Huu Huy on 06/11/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
import BaseCoreData

class TestTable: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPerformanceExample() {
        self.measure() {
            
        }
    }
    
    func testEntityName() {
        let entity = Table.entityDescription(in: DefinitionEntity.self)
 
        XCTAssertEqual(entity.name, "DefinitionEntity")
    }
    
    func testEntityProperties() {
        let entity = Table.entityDescription(in: DefinitionEntity.self)
        let propertyNames = entity.properties.map({ $0.name })
        
        assert(propertyNames.count == 12, "Expected 12 properties, but got \(propertyNames.count)")
        
        XCTAssertTrue(propertyNames.contains("int16")   , "int16 is missing")
        XCTAssertTrue(propertyNames.contains("int32")   , "int32 is missing")
        XCTAssertTrue(propertyNames.contains("int64")   , "int64 is missing")
        XCTAssertTrue(propertyNames.contains("int")     , "int is missing")
        XCTAssertTrue(propertyNames.contains("decimal") , "decimal is missing")
        XCTAssertTrue(propertyNames.contains("double")  , "double is missing")
        XCTAssertTrue(propertyNames.contains("float")   , "float is missing")
        XCTAssertTrue(propertyNames.contains("bool")    , "bool is missing")
        XCTAssertTrue(propertyNames.contains("string")  , "string is missing")
        XCTAssertTrue(propertyNames.contains("date")    , "date is missing")
        XCTAssertTrue(propertyNames.contains("data")    , "data is missing")
        XCTAssertTrue(propertyNames.contains("uUID")    , "uUID is missing")
    }
}
