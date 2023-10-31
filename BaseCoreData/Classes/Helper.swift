//
//  Helper.swift
//  BaseCoreData
//
//  Created by Nguyen Huu Huy on 31/10/2023.
//

import Foundation
import CoreData

public struct Helper {
    public static func createTable(name: String) -> NSEntityDescription {
        let entity = NSEntityDescription()
        entity.name = name
        entity.managedObjectClassName = name
        return entity
    }
    
    public static func createFields(fields: [Field]) -> [NSAttributeDescription] {
        var array = [NSAttributeDescription]()
        for item in fields {
            let attribute = NSAttributeDescription()
            attribute.name = item.name
            attribute.attributeType = item.type
            attribute.isOptional = true
            array.append(attribute)
        }
        
        return array
    }
}