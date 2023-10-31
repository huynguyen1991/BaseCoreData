//
//  Table.swift
//  BaseCoreData
//
//  Created by Nguyen Huu Huy on 31/10/2023.
//

import Foundation
import CoreData

public struct Table {
    let name: String
    let fields: [Field]
    
    public init(name: String, fields: [Field]) {
        self.name = name
        self.fields = fields
    }
}

extension Table {
    public func entity() -> NSEntityDescription {
        let entity = Helper.createTable(name: name)
        let attribute = Helper.createFields(fields: fields)
        
        entity.properties = attribute
        
        return entity
    }
}

public struct Field {
    let name: String
    let type: NSAttributeType
    
    public init(name: String, type: NSAttributeType) {
        self.name = name
        self.type = type
    }
}
