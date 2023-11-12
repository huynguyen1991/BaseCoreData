//
//  CoreDataStack.swift
//  BaseCoreData
//
//  Created by Nguyen Huu Huy on 31/10/2023.
//

import Foundation
import CoreData

import CwlCatchException
#if SWIFT_PACKAGE || COCOAPODS
import CwlCatchExceptionSupport
#endif

public struct CoreDataStackConfig {
    public var sqliteName: String
    public var entity: [NSEntityDescription]
    
    public init(sqliteName: String, entity: [NSEntityDescription]) {
        self.sqliteName = sqliteName
        self.entity = entity
    }
}

public final class CoreDataStack {
    
    public static let shares = CoreDataStack()
    
    public var config: CoreDataStackConfig?
    
    private lazy var applicationDocumentsDirectory: URL? = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let entity = config?.entity else { assert(false, "Entity is empty") }
        let model = NSManagedObjectModel()
        model.entities = entity
        return model
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        guard let sqliteName = config?.sqliteName else { assert(false, "sqliteName is empty") }
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        if let store = applicationDocumentsDirectory?.appendingPathComponent("\(sqliteName).sqlite") {
            try? addStore(store, coordinator: coordinator)
        }
        return coordinator
    }()
    
    public lazy var context: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }()
    
    private func addStore(_ store: URL, coordinator: NSPersistentStoreCoordinator, retry: Bool = true) throws {
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                                 NSInferMappingModelAutomaticallyOption: true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: .none, at: store, options: options)
        } catch let error as NSError {
            let errorOnMigration = error.code == NSPersistentStoreIncompatibleVersionHashError
            if errorOnMigration && retry {
                cleanStoreOnFailedMigration()
                return try addStore(store, coordinator: coordinator, retry: false)
            }
        }
    }
    
    private func cleanStoreOnFailedMigration() {
        do {
            guard let sqliteName = config?.sqliteName else { assert(false, "sqliteName is empty") }
            guard let url = applicationDocumentsDirectory else { assert(false, "documents directory is empty") }
            let filemanager = FileManager.default
            for extentions in storeExtensions() {
                let path = url.appendingPathComponent("\(sqliteName).\(extentions)")
                try filemanager.removeItem(at: path)
                print("Database Deleted!")
            }
        } catch {
            print("Error on Delete Database!!!")
        }
    }
    
    private func storeExtensions() -> [String] {
        return ["sqlite", "sqlite-shm", "sqlite-wal"]
    }
}
extension DispatchQueue {
    /// - Parameter closure: Closure to execute.
    func dispatchMainIfNeeded(_ closure: @escaping (()->())) {
        guard self === DispatchQueue.main && Thread.isMainThread else {
            DispatchQueue.main.async(execute: closure)
            return
        }

        closure()
    }
}

extension NSManagedObjectContext {
    public func saveContext () throws {
        if self.hasChanges {
            do {
                try catchExceptionAsError { [weak self] in
                    try self?.save()
                }
            } catch let error as ExceptionError {
                print(error.exception)
                throw CoreDataError(message: "Can't save data")
            }
        }
    }
}

public struct CoreDataError: Error {
    public var message: String
    
    public var localizedDescription: String {
        return message
    }
    
    public init(message: String) {
        self.message = message
    }
}
