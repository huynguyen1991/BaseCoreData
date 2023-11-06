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
    @NSManaged var decimal: Decimal
    @NSManaged var double: Double
    @NSManaged var float: Float
    @NSManaged var bool: Bool
    @NSManaged var string: String
    @NSManaged var date: Date
    @NSManaged var data: Data
    @NSManaged var uUID: UUID
}

extension DefinitionEntity: DomainConvertibleType {
    public typealias DomainType = DataDefinition
    
    public func asDomain() -> DataDefinition {
        return DataDefinition(int16: int16,
                              int32: int32,
                              int64: int64,
                              int: int,
                              decimal: decimal,
                              double: double,
                              float: float,
                              bool: bool,
                              string: string,
                              date: date,
                              data: data,
                              uUID: uUID)
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
    var decimal: Decimal
    var double: Double
    var float: Float
    var bool: Bool
    var string: String
    var date: Date
    var data: Data
    var uUID: UUID
}

extension DataDefinition: CoreDataRepresentable {
    public typealias CoreDataType = DefinitionEntity

    public func asCoreData(object: DefinitionEntity) {
        object.int16 = int16
        object.int32 = int32
        object.int64 = int64
        object.int = int
        object.decimal = decimal
        object.double = double
        object.float = float
        object.bool = bool
        object.string = string
        object.date = date
        object.data = data
        object.uUID = uUID
    }
}
