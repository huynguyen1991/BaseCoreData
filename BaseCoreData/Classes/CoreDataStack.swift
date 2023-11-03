//
//  CoreDataStack.swift
//  BaseCoreData
//
//  Created by Nguyen Huu Huy on 31/10/2023.
//

import Foundation
import CoreData

public final class CoreDataStack {
    
    public static let shares = CoreDataStack()
    
    public var entity: [NSEntityDescription] = []
    
    var sqliteName: String?
    
    func setStoreName(_ name: String) {
        sqliteName = name + ".sqlite"
    }
    
    lazy var applicationDocumentsDirectory: URL? = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let model = NSManagedObjectModel()
        model.entities = entity
        return model
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        guard let sqliteName = sqliteName else { assert(false, "storeName is empty") }
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        if let url = applicationDocumentsDirectory?.appendingPathComponent(sqliteName) {
            do {
                let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                                     NSInferMappingModelAutomaticallyOption: true]
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: .none, at: url, options: options)
            } catch {
                print("There was an error creating or loading the application's saved data.")
            }
        }
        return coordinator
    }()
    
    lazy var context: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }()
}

extension NSManagedObjectContext {
    func saveContext () throws {
        if self.persistentStoreCoordinator?.persistentStores == .none {
            throw CoreDataError(message: "Error persistent Stores")
        } else {
            if self.hasChanges {
                try self.save()
            }
        }
    }
}

struct CoreDataError: Error {
    var message: String
    
    var localizedDescription: String {
        return message
    }
}
