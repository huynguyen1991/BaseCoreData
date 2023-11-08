//
//  Repository.swift
//  BaseCoreData
//
//  Created by Nguyen Huu Huy on 31/10/2023.
//

import Foundation
import CoreData

public enum SaveResult {
    case update
    case addNew
    case none
}

public protocol AbstractRepository {
    associatedtype T
    func query(with predicate: NSPredicate?, limit: Int?) -> [T]
    func save(entity: T, with predicate: NSPredicate?) -> SaveResult
    func delete(entity: T, with predicate: NSPredicate?) -> Bool
    func add(entity: T) -> Bool
    func deletes() -> Bool
}

public final class Repository<T:CoreDataRepresentable>: AbstractRepository where T == T.CoreDataType.DomainType, T.CoreDataType: NSManagedObject {
    
    let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func query(with predicate: NSPredicate?, limit: Int?) -> [T] {
        do {
            let results = try allEntities(with: predicate, limit: limit)
            return Array(results).map { $0.asDomain() }
        } catch {
            return []
        }
    }
    
    public func save(entity: T, with predicate: NSPredicate?) -> SaveResult {
        var result: SaveResult = .none
        
        do {
            if let item = try allEntities(with: predicate, limit: 1).first {
                entity.asCoreData(object: item)
                result = .update
            } else {
                let entityName = String(describing: T.CoreDataType.self)
                guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return .none }
                let record = T.CoreDataType(entity: entityDescription, insertInto: context)
                entity.asCoreData(object: record)
                result = .addNew
            }
            
            do {
                try context.saveContext()
                return result
            } catch {
                return .none
            }
            
        } catch {
            return result
        }
    }
    
    public func delete(entity: T, with predicate: NSPredicate?) -> Bool {
        do {
            let results = try allEntities(with: predicate, limit: .none)
            for item in results {
                context.delete(item)
            }
            
            do {
                try context.saveContext()
                return true
            } catch {
                return false
            }
        } catch {
            return false
        }
    }
    
    public func add(entity: T) -> Bool {
        let entityName = String(describing: T.CoreDataType.self)
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return false }
        let record = T.CoreDataType(entity: entityDescription, insertInto: context)
        entity.asCoreData(object: record)
        
        do {
            try context.saveContext()
            return true
        } catch {
            return false
        }
    }
    
    public func deletes() -> Bool {
        let name = String(describing: T.CoreDataType.self)
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.saveContext()
            return true
        } catch {
            return false
        }
    }
}

extension Repository {
    private func allEntities(with predicate: NSPredicate?, limit: Int?) throws -> [T.CoreDataType] {
        let entityName = String(describing: T.CoreDataType.self)
        let request = NSFetchRequest<T.CoreDataType>(entityName: entityName)
        request.predicate = predicate
        if let verifyLimit = limit {
            request.fetchLimit = verifyLimit
        }
        return try context.fetch(request)
    }
}
