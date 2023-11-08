//
//  DefinitionEntity.swift
//  BaseCoreData_Example
//
//  Created by Nguyen Huu Huy on 06/11/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import CoreData
import BaseCoreData

@objc(DefinitionEntity)
public final class DefinitionEntity: NSManagedObject {
    @NSManaged var int16: Int16
    @NSManaged var int32: Int32
    @NSManaged var int64: Int64
    @NSManaged var int: Int
    @NSManaged var double: Double
    @NSManaged var float: Float
    @NSManaged var bool: Bool
    @NSManaged var string: String
    @NSManaged var date: Date
    @NSManaged var data: Data
    @NSManaged var uUID: UUID
    
    @NSManaged var int16_2: Int16
    @NSManaged var int32_2: Int32
    @NSManaged var int64_2: Int64
    @NSManaged var int_2: Int
    @NSManaged var double_2: Double
    @NSManaged var float_2: Float
    @NSManaged var bool_2: Bool
    @NSManaged var string_2: String
    @NSManaged var date_2: Date
    @NSManaged var data_2: Data
    @NSManaged var uUID_2: UUID
}

extension DefinitionEntity: DomainConvertibleType {
    public typealias DomainType = DataDefinition
    
    public func asDomain() -> DataDefinition {
        return DataDefinition(int16: int16,
                              int32: int32,
                              int64: int64,
                              int: int,
                              double: double,
                              float: float,
                              bool: bool,
                              string: string,
                              date: date,
                              data: data,
                              uUID: uUID,
                              int16_2: int16_2,
                              int32_2: int32_2,
                              int64_2: int64_2,
                              int_2: int_2,
                              double_2: double_2,
                              float_2: float_2,
                              bool_2: bool_2,
                              string_2: string_2,
                              date_2: date_2,
                              data_2: data_2,
                              uUID_2: uUID_2)
    }
    
    public static func createEntityDescription() -> NSEntityDescription {
        return Table.entityDescription(in: DefinitionEntity.self)
    }
}

public struct DataDefinition {
    var int16: Int16
    var int32: Int32
    var int64: Int64
    var int: Int
    var double: Double
    var float: Float
    var bool: Bool
    var string: String
    var date: Date
    var data: Data
    var uUID: UUID
    
    var int16_2: Int16
    var int32_2: Int32
    var int64_2: Int64
    var int_2: Int
    var double_2: Double
    var float_2: Float
    var bool_2: Bool
    var string_2: String
    var date_2: Date
    var data_2: Data
    var uUID_2: UUID
}

extension DataDefinition: CoreDataRepresentable {
    public typealias CoreDataType = DefinitionEntity

    public func asCoreData(object: DefinitionEntity) {
        object.int16 = int16
        object.int32 = int32
        object.int64 = int64
        object.int = int
        object.double = double
        object.float = float
        object.bool = bool
        object.string = string
        object.date = date
        object.data = data
        object.uUID = uUID
        
        object.int16_2 = int16_2
        object.int32_2 = int32_2
        object.int64_2 = int64_2
        object.int_2 = int_2
        object.double_2 = double_2
        object.float_2 = float_2
        object.bool_2 = bool_2
        object.string_2 = string_2
        object.date_2 = date_2
        object.data_2 = data_2
        object.uUID_2 = uUID_2
    }
}
