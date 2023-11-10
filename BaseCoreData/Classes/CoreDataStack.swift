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
    
    public func deleteDatabase(sqliteName : String) {
        do {
            let filemanager = FileManager.default
            if let destinationPath = applicationDocumentsDirectory?.appendingPathComponent("\(sqliteName).sqlite") {
                try filemanager.removeItem(at: destinationPath)
            }
            print("Database Deleted!")
        } catch {
            print("Error on Delete Database!!!")
        }
    }
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let entity = config?.entity else { assert(false, "Entity is empty") }
        let model = NSManagedObjectModel()
        model.entities = entity
        return model
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        guard let sqliteName = config?.sqliteName else { assert(false, "sqliteName is empty") }
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        if let url = applicationDocumentsDirectory?.appendingPathComponent("\(sqliteName).sqlite") {
            do {
                print("applicationDocumentsDirectory \(applicationDocumentsDirectory!)")
                let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                                     NSInferMappingModelAutomaticallyOption: true]
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: .none, at: url, options: options)
            } catch {
                print("There was an error creating or loading the application's saved data.")
            }
        }
        return coordinator
    }()
    
    public lazy var context: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }()
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
                print(error.errorUserInfo)
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
