//
//  DomainConvertibleType.swift
//  BaseCoreData
//
//  Created by Nguyen Huu Huy on 31/10/2023.
//

import Foundation
import CoreData

public protocol DomainConvertibleType {
    associatedtype DomainType
    func asDomain() -> DomainType
    static func createEntityDescription() -> NSEntityDescription
}

public protocol CoreDataRepresentable {
    associatedtype CoreDataType: DomainConvertibleType
    func asCoreData(object: CoreDataType)
}
