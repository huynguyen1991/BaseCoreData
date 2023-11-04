//
//  SwiftReflectionTests.swift
//  BaseCoreData_Tests
//
//  Created by Nguyen Huu Huy on 03/11/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
import CoreData
import BaseCoreData

class SwiftReflectionTests: XCTestCase {
    
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
    
    func testGetTypesOfProperties() {
        guard let types = getTypesOfProperties(in: DefinitionEntity.self) else {
            assert(false, "Should be able to get types")
        }

        assert(types.count == 12, "Book should have 12 properties")

        for (propertyName, propertyType) in types {

            print("propertyName \(propertyName) -- propertyType \(propertyType)")
            switch propertyName {
            case "int16":
                assert(propertyType == Int16.self, "'int16' should be of type 'Int16'")
            case "int32":
                assert(propertyType == Int32.self, "'int32' should be of type 'Int32'")
            case "int64":
                assert(propertyType == Int.self, "'int64' should be of type 'Int64'")
            case "int":
                assert(propertyType == Int.self, "'int' should be of type 'Int'")
            case "decimal":
                assert(propertyType == Decimal.self, "'decimal' should be of type 'Decimal'")
            case "double":
                assert(propertyType == Double.self, "'double' should be of type 'Double'")
            case "float":
                assert(propertyType == Float.self, "'float' should be of type 'Float'")
            case "bool":
                assert(propertyType == Bool.self, "'bool' should be of type 'Bool'")
            case "string":
                assert(propertyType == NSString.self, "'string' should be of type 'NSString'")
            case "date":
                assert(propertyType == NSDate.self, "'date' should be of type 'NSDate'")
            case "data":
                assert(propertyType == NSData.self, "'data' should be of type 'NSData'")
            case "uUID":
                assert(propertyType == NSUUID.self, "'uUID' should be of type 'NSUUID'")
            default:
                assert(false, "should not contain any property with any other name")
            }
        }
    }
}

@objc(DefinitionEntity)
final class DefinitionEntity: NSManagedObject {
    @NSManaged var int16: Int16
    @NSManaged var int32: Int32
    @NSManaged var int64: Int64
    @NSManaged var int: Int
    @NSManaged var decimal: Decimal
    @NSManaged var double: Double
    @NSManaged var float: Float
    @NSManaged var bool: Bool
    @NSManaged var string: String
    @NSManaged var date: Date
    @NSManaged var data: Data
    @NSManaged var uUID: UUID
}

fileprivate func ==(rhs: Any, lhs: Any) -> Bool {
    let rhsType: String = "\(rhs)"
    let lhsType: String = "\(lhs)"
    let same = rhsType == lhsType
    return same
}
