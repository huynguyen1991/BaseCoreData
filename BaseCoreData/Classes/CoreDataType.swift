//
//  CoreDataType.swift
//  BaseCoreData
//
//  Created by Nguyen Huu Huy on 03/11/2023.
//

import Foundation
import CoreData

public struct CoreDataType {
    public static func convert(_ propertyType: Any) -> NSAttributeType {
        if propertyType == Int16.self {
            return NSAttributeType.integer16AttributeType
        } else if propertyType == Int32.self {
            return NSAttributeType.integer32AttributeType
        } else if propertyType == Int.self {
            return NSAttributeType.integer64AttributeType
        } else if propertyType == Double.self {
            return NSAttributeType.doubleAttributeType
        } else if propertyType == Float.self {
            return NSAttributeType.floatAttributeType
        } else if propertyType == NSString.self {
            return NSAttributeType.stringAttributeType
        } else if propertyType == Bool.self {
            return NSAttributeType.booleanAttributeType
        } else if propertyType == NSDate.self {
            return NSAttributeType.dateAttributeType
        } else if propertyType == NSData.self {
            return NSAttributeType.binaryDataAttributeType
        } else if propertyType == NSUUID.self {
            return NSAttributeType.UUIDAttributeType
        } else {
            assert(false, "Property Type is not suport")
        }
    }
}

fileprivate func ==(rhs: Any, lhs: Any) -> Bool {
    let rhsType: String = "\(rhs)".withoutOptional
    let lhsType: String = "\(lhs)".withoutOptional
    let same = rhsType == lhsType
    return same
}

fileprivate extension String {
    ///E.g Extracts "NSDate" from the string "Optional(NSDate)"
    var withoutOptional: String {
        guard self.contains("Optional(") && self.contains(")") else { return self }
        let afterOpeningParenthesis = self.components(separatedBy: "(")[1]
        let wihtoutOptional = afterOpeningParenthesis.components(separatedBy: ")")[0]
        return wihtoutOptional
    }
}
