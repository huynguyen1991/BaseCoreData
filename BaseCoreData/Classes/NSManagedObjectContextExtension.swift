//
//  NSManagedObjectContextExtension.swift
//  BaseCoreData
//
//  Created by Nguyen Huu Huy on 31/10/2023.
//

import Foundation
import CoreData

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
