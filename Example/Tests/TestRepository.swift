//
//  TestRepository.swift
//  BaseCoreData_Tests
//
//  Created by Nguyen Huu Huy on 08/11/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import XCTest
import BaseCoreData
import CwlCatchException

final class TestRepository: XCTestCase {

    override func setUpWithError() throws {
        CoreDataStack.shares.config = CoreDataStackConfig(sqliteName: "CoreDataStack",
                                                          entity: [DefinitionEntity.createEntityDescription()])
    }

    override func tearDownWithError() throws {
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
//            for _ in 1...2 {
//                testSaveDatas()
//            }
        }
    }
    
    func testSaveDatas() {
        let repository = Repository<DataDefinition>(context: CoreDataStack.shares.context)
        let storeData = DefinitionsGatewayImplementation(repository: repository)
        let definition = DataDefinition(int16: 16, int32: 32, int64: 64, int: 10, double: 10.0, float: 10.1, bool: false, string: "string", date: Date(), data: Data(), uUID: UUID(),
                                        int16_2: 16, int32_2: 32, int64_2: 64, int_2: 10, double_2: 10.0, float_2: 10.1, bool_2: false, string_2: "string", date_2: Date(), data_2: Data(), uUID_2: UUID(), uUID_4: UUID(), uUID_5: UUID(), uUID_6: UUID())
        let result = storeData.add(definition: definition)

        XCTAssertTrue(result, "cannot save data")
   
    }
}
