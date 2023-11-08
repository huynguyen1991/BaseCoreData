//
//  TestCoreDataType.swift
//  BaseCoreData_Example
//
//  Created by Nguyen Huu Huy on 06/11/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
import BaseCoreData

class TestCoreDataType: XCTestCase {
    
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
    
    func testCoreDataTypeConvet() {
        guard let types = getTypesOfProperties(in: DefinitionEntity.self) else {
            assert(false, "Should be able to get types")
        }
        
        assert(types.count == 11, "Expected 12 properties, but got \(types.count)")
      
        guard
        let int16 = types["int16"],
        let int32 = types["int32"],
        let int64 = types["int64"],
        let int = types["int"],
        let double = types["double"],
        let float = types["float"],
        let bool = types["bool"],
        let string = types["string"],
        let date = types["date"],
        let data = types["data"],
        let uUID = types["uUID"]
        else {
            assert(false, "value is nil")
        }
        
        XCTAssertTrue(int16 == Int16.self, "int16 is missing")
        XCTAssertTrue(int32 == Int32.self, "int32 is missing")
        XCTAssertTrue(int64 == Int.self, "int64 is missing")
        XCTAssertTrue(int == Int.self, "int is missing")
        XCTAssertTrue(double == Double.self, "double is missing")
        XCTAssertTrue(float == Float.self, "float is missing")
        XCTAssertTrue(bool == Bool.self, "bool is missing")
        XCTAssertTrue(string == NSString.self, "string is missing")
        XCTAssertTrue(date == NSDate.self, "date is missing")
        XCTAssertTrue(data == NSData.self, "data is missing")
        XCTAssertTrue(uUID == NSUUID.self, "uUID is missing")
        
        XCTAssertTrue(CoreDataType.convert(int16) == .integer16AttributeType.self, "'int16' should be of type 'integer16AttributeType'")
        XCTAssertTrue(CoreDataType.convert(int32) == .integer32AttributeType.self, "'int32' should be of type 'integer32AttributeType'")
        XCTAssertTrue(CoreDataType.convert(int64) == .integer64AttributeType.self, "'int64' should be of type 'integer64AttributeType'")
        XCTAssertTrue(CoreDataType.convert(int) == .integer64AttributeType.self, "'int' should be of type 'integer64AttributeType'")
        XCTAssertTrue(CoreDataType.convert(double) == .doubleAttributeType.self, "'double' should be of type 'doubleAttributeType'")
        XCTAssertTrue(CoreDataType.convert(float) == .floatAttributeType.self, "'float' should be of type 'floatAttributeType'")
        XCTAssertTrue(CoreDataType.convert(bool) == .booleanAttributeType.self, "'bool' should be of type 'booleanAttributeType'")
        XCTAssertTrue(CoreDataType.convert(string) == .stringAttributeType.self, "'string' should be of type 'stringAttributeType'")
        XCTAssertTrue(CoreDataType.convert(date) == .dateAttributeType.self, "'date' should be of type 'dateAttributeType'")
        XCTAssertTrue(CoreDataType.convert(data) == .binaryDataAttributeType.self, "'data' should be of type 'binaryDataAttributeType'")
        XCTAssertTrue(CoreDataType.convert(uUID) == .UUIDAttributeType.self, "'uUID' should be of type 'UUIDAttributeType'")
    }
}
