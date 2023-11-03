//
//  Table.swift
//  BaseCoreData
//
//  Created by Nguyen Huu Huy on 31/10/2023.
//

import Foundation
import CoreData

struct Table {
    let name: String
    let fields: [Field]
    
    public init(name: String, fields: [Field]) {
        self.name = name
        self.fields = fields
    }
}

struct Field {
    let name: String
    let type: NSAttributeType
    
    public init(name: String, type: NSAttributeType) {
        self.name = name
        self.type = type
    }
}

extension Table {
    func createTable(name: String) -> NSEntityDescription {
        let entity = NSEntityDescription()
        entity.name = name
        entity.managedObjectClassName = name
        return entity
    }
    
    func createFields(fields: [Field]) -> [NSAttributeDescription] {
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
    
    func entity() -> NSEntityDescription {
        let entity = createTable(name: name)
        let attribute = createFields(fields: fields)
        
        entity.properties = attribute
        
        return entity
    }
}

extension Table {
    public static func entityDescription(in clazz: NSObject.Type) -> NSEntityDescription {
        let tableName = String(describing: clazz.self)
        var fields: [Field] = []
        if let types = getTypesOfProperties(in: clazz) {
            for (name, type) in types {
                let field = Field(name: name, type: CoreDataType.convert(type))
                fields.append(field)
            }
            
            return Table(name: tableName, fields: fields).entity()
        } else {
            assert(false, "can't create NSEntityDescription")
        }
    }
}
