//
//  NSManagedObjectExtension.swift
//  BaseCoreData
//
//  Created by Nguyen Huu Huy on 31/10/2023.
//

import Foundation
import CoreData

extension NSManagedObject {
    static func entityName() -> String {
        return String(describing: Self.self)
    }

}
