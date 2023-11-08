//
//  DefinitionsGatewayImplementation.swift
//  BaseCoreData_Tests
//
//  Created by Nguyen Huu Huy on 08/11/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import BaseCoreData

class DefinitionsGatewayImplementation<Repository> where Repository: AbstractRepository, Repository.T == DataDefinition {
    private let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }
    
    func fetch(key: String, updateDate: String) -> [DataDefinition] {
        return self.repository.query(with: .none, limit: .none)
    }
    
    func save(definition: DataDefinition) -> Bool {
        let predicate = NSPredicate(format: "int==%li", definition.int)
        let result = self.repository.save(entity: definition, with: predicate)
        return result == .addNew
    }
    
    func add(definition: DataDefinition) -> Bool {
        let result = self.repository.add(entity: definition)
        return result
    }
    
    func delete(definition: DataDefinition) -> Bool {
        let predicate = NSPredicate(format: "int==%@", definition.int)
        return self.repository.delete(entity: definition, with: predicate)
    }
    
    func deletes() -> Bool {
        return self.repository.deletes()
    }
}
