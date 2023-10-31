//
//  CoreDataError.swift
//  BaseCoreData
//
//  Created by Nguyen Huu Huy on 31/10/2023.
//

import Foundation

struct CoreDataError: Error {
    var message = ""
    
    var localizedDescription: String {
        return message
    }
}
