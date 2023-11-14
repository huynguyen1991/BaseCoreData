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
    func query(with predicate: NSPredicate?, limit: Int?, completionHandler: @escaping ([T]) -> ())
    func save(entity: T, with predicate: NSPredicate?, completionHandler: @escaping (SaveResult) -> ())
    func delete(with predicate: NSPredicate?, completionHandler: @escaping (Bool) -> ())
    func add(entity: T, completionHandler: @escaping (Bool) -> ())
    func deletes(completionHandler: @escaping (Bool) -> ())
}

public final class Repository<T:CoreDataRepresentable>: AbstractRepository where T == T.CoreDataType.DomainType, T.CoreDataType: NSManagedObject {
    let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func query(with predicate: NSPredicate?, limit: Int?, completionHandler: @escaping ([T]) -> ()) {
        allEntities(with: predicate, limit: limit,completionHandler: { results in
            let domain = Array(results).map { $0.asDomain() }
            DispatchQueue.main.async {
                completionHandler(domain)
            }
        })
    }
    
    public func save(entity: T, with predicate: NSPredicate?, completionHandler: @escaping (SaveResult) -> ()) {
        allEntities(with: predicate, limit: 1,completionHandler: { [weak self] results in
            var result: SaveResult = .none
            
            defer {
                DispatchQueue.main.async {
                    completionHandler(result)
                }
            }
            
            guard let self = self else { return }
            
            if let item = results.first {
                entity.asCoreData(object: item)
                result = .update
            } else {
                let entityName = String(describing: T.CoreDataType.self)
                guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: self.context)
                else {
                    result = .none
                    return
                }
                let record = T.CoreDataType(entity: entityDescription, insertInto: self.context)
                entity.asCoreData(object: record)
                result = .addNew
            }
            
            do {
                try self.context.saveContext()
            } catch {
                result = .none
            }
        })
    }
    
    public func delete(with predicate: NSPredicate?, completionHandler: @escaping (Bool) -> ()) {
        allEntities(with: predicate, limit: .none, completionHandler: { [weak self] results in
            var result: Bool = true
            defer {
                DispatchQueue.main.async {
                    completionHandler(result)
                }
            }
            
            guard let self = self else { return }
            
            for item in results {
                self.context.delete(item)
            }
            
            do {
                try self.context.saveContext()
                result = true
            } catch {
                result = false
            }
        })
    }
    
    public func add(entity: T, completionHandler: @escaping (Bool) -> ()) {
        let entityName = String(describing: T.CoreDataType.self)
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context)
        else {
            DispatchQueue.main.async {
                completionHandler(false)
            }
            return
        }
        let record = T.CoreDataType(entity: entityDescription, insertInto: context)
        entity.asCoreData(object: record)
        context.perform({ [weak self] in
            var result: Bool = true
            defer {
                DispatchQueue.main.async {
                    completionHandler(result)
                }
            }
            do {
                guard let self = self else { return }
                try self.context.saveContext()
                result = true
            } catch {
                result = false
            }
        })
    }
    
    public func deletes(completionHandler: @escaping (Bool) -> ()) {
        let name = String(describing: T.CoreDataType.self)
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        context.perform({ [weak self] in
            var result: Bool = true
            defer {
                DispatchQueue.main.async {
                    completionHandler(result)
                }
            }
            
            do {
                guard let self = self else { return }
                try self.context.execute(deleteRequest)
                try self.context.saveContext()
                result = true
            } catch {
                result = false
            }
        })
    }
}

extension Repository {
    private func allEntities(with predicate: NSPredicate?, limit: Int?, completionHandler: @escaping ([T.CoreDataType]) -> ()) {
        let entityName = String(describing: T.CoreDataType.self)
        let request = NSFetchRequest<T.CoreDataType>(entityName: entityName)
        request.predicate = predicate
        if let verifyLimit = limit {
            request.fetchLimit = verifyLimit
        }

        context.perform({ [weak self] in
            do {
                guard let self = self else { return }
                let results = try self.context.fetch(request)
                completionHandler(results)
            } catch {
                completionHandler([])
            }
        })
    }
}
