//
//  TestCoreDataStack.swift
//  BaseCoreData_Tests
//
//  Created by Nguyen Huu Huy on 06/11/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
import BaseCoreData

class TestCoreDataStack: XCTestCase {
    
    override func setUp() {
        super.setUp()
        CoreDataStack.shares.config = CoreDataStackConfig(sqliteName: "CoreDataStack",
                                                          entity: [DefinitionEntity.createEntityDescription()])
    }
    
    override func tearDown() {
        super.tearDown()
        CoreDataStack.shares.deleteDatabase(sqliteName: "CoreDataStack")
    }
    
    func testPerformanceExample() {
        self.measure() {
           
        }
    }
}
