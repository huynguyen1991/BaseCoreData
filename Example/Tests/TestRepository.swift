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

        print("totalDiskSpaceInBytes: \(UIDevice.current.totalDiskSpaceInMB)")
        print("freeDiskSpace: \(UIDevice.current.freeDiskSpaceInMB)")
        print("usedDiskSpace: \(UIDevice.current.usedDiskSpaceInMB)")
    }

    override func tearDownWithError() throws {
      
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            testSaveData()
        }
    }
    
    func testSaveData() {
        let repository = Repository<DataDefinition>(context: CoreDataStack.shares.context)
        let storeData = DefinitionsGatewayImplementation(repository: repository)
        let definition = DataDefinition(int16: 16, int32: 32, int64: 64, int: 10, double: 10.0, float: 10.1, bool: false, string: "string", date: Date(), data: Data(), uUID: UUID(),
                                        int16_2: 16, int32_2: 32, int64_2: 64, int_2: 10, double_2: 10.0, float_2: 10.1, bool_2: false, string_2: "string", date_2: Date(), data_2: Data(), uUID_2: UUID(), uUID_3: UUID())
        let result = storeData.add(definition: definition)

        XCTAssertTrue(result, "cannot save data")
   
    }
}


extension UIDevice {
    func MBFormatter(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useMB
        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
        formatter.includesUnit = false
        return formatter.string(fromByteCount: bytes) as String
    }
    
    //MARK: Get String Value
    var totalDiskSpaceInGB:String {
       return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }
    
    var freeDiskSpaceInGB:String {
        return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }
    
    var usedDiskSpaceInGB:String {
        return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }
    
    var totalDiskSpaceInMB:String {
        return MBFormatter(totalDiskSpaceInBytes)
    }
    
    var freeDiskSpaceInMB:String {
        return MBFormatter(freeDiskSpaceInBytes)
    }
    
    var usedDiskSpaceInMB:String {
        return MBFormatter(usedDiskSpaceInBytes)
    }
    
    //MARK: Get raw value
    var totalDiskSpaceInBytes:Int64 {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: path),
            let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value else { return 0 }
        return space
    }
    
    /*
     Total available capacity in bytes for "Important" resources, including space expected to be cleared by purging non-essential and cached resources. "Important" means something that the user or application clearly expects to be present on the local system, but is ultimately replaceable. This would include items that the user has explicitly requested via the UI, and resources that an application requires in order to provide functionality.
     Examples: A video that the user has explicitly requested to watch but has not yet finished watching or an audio file that the user has requested to download.
     This value should not be used in determining if there is room for an irreplaceable resource. In the case of irreplaceable resources, always attempt to save the resource regardless of available capacity and handle failure as gracefully as possible.
     */
    var freeDiskSpaceInBytes:Int64 {
        if #available(iOS 11.0, *) {
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
            if let space = try? URL(fileURLWithPath: path).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
                return space ?? 0
            } else {
                return 0
            }
        } else {
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: path),
            let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value {
                return freeSpace
            } else {
                return 0
            }
        }
    }
    
    var usedDiskSpaceInBytes:Int64 {
       return totalDiskSpaceInBytes - freeDiskSpaceInBytes
    }
}

