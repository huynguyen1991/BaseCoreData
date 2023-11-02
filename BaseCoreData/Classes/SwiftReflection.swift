//
//  SwiftReflection.swift
//  SwiftReflection
//
//  Created by Cyon Alexander (Ext. Netlight) on 01/09/16.
//  Copyright © 2016 com.cyon. All rights reserved.
//

import Foundation
import ObjectiveC.runtime


/*
 Please note that the class you are inspecting have to inherit from NSObject.

 This tool can find the name and type of properties of type NSObject, e.g. NSString (or just "String" with Swift 3 syntax), NSDate (or just "NSDate" with Swift 3 syntax), NSNumber etc.
 It also works with optionals and implicit optionals for said types, e.g. String?, String!, Date!, Date? etc...

 This tool can also find name and type of "value type" such as Bool, Int, Int32, _HOWEVER_ it does not work if said value type is an optional, e.g. Int? <--- DOES NOT WORK
 */


public func getTypesOfProperties(in clazz: NSObject.Type, includeSuperclass: Bool = false, excludeReadOnlyProperties: Bool = false) -> Dictionary<String, Any>? {
    let types: Dictionary<String, Any> = [:]
    return getTypesOfProperties(in: clazz, types: types, includeSuperclass: includeSuperclass)
}

public func getTypesOfProperties(in clazz: NSObject.Type, types: Dictionary<String, Any>, includeSuperclass: Bool, excludeReadOnlyProperties: Bool = false) -> Dictionary<String, Any>? {
    var count = UInt32()
    guard let properties = class_copyPropertyList(clazz, &count) else { return nil }
    var types = types
    for i in 0..<Int(count) {
        let property: objc_property_t = properties[i]
        guard let name = getNameOf(property: property)
            else { continue }
        let isReadOnlyProperty = isReadOnly(property: property)
        if excludeReadOnlyProperties && isReadOnlyProperty { continue }
        let type = getTypeOf(property: property)
        types[name] = type
    }
    free(properties)
    
    if includeSuperclass, let superclazz = clazz.superclass() as? NSObject.Type, superclazz != NSObject.self {
        return getTypesOfProperties(in: superclazz, types: types, includeSuperclass: true)
    } else {
        return types
    }
}

fileprivate func ==(rhs: Any, lhs: Any) -> Bool {
    let rhsType: String = "\(rhs)".withoutOptional
    let lhsType: String = "\(lhs)".withoutOptional
    let same = rhsType == lhsType
    return same
}

fileprivate func ==(rhs: NSObject.Type, lhs: Any) -> Bool {
    let rhsType: String = "\(rhs)".withoutOptional
    let lhsType: String = "\(lhs)".withoutOptional
    let same = rhsType == lhsType
    return same
}

fileprivate func ==(rhs: Any, lhs: NSObject.Type) -> Bool {
    let rhsType: String = "\(rhs)".withoutOptional
    let lhsType: String = "\(lhs)".withoutOptional
    let same = rhsType == lhsType
    return same
}

struct Unknown {}

fileprivate func removeBrackets(_ className: String) -> String {
    guard className.contains("<") && className.contains(">") else { return className }
    let removed = className.chopPrefix().chopSuffix()
    return removed
}

fileprivate func getTypeOf(property: objc_property_t) -> Any {
    guard let item = property_getAttributes(property), let attributesAsNSString: NSString = NSString(utf8String: item) else { return Any.self }
    let attributes = attributesAsNSString as String
    let slices = attributes.components(separatedBy: "\"")
    guard slices.count > 1 else { return valueType(withAttributes: attributes) }
    let objectClassNameRaw = slices[1]
    let objectClassName = removeBrackets(objectClassNameRaw)
    
    guard let objectClass = NSClassFromString(objectClassName) else {
        if let nsObjectProtocol = NSProtocolFromString(objectClassName) {
            return nsObjectProtocol
        }
        print("Failed to retrieve type from: `\(objectClassName)`")
        return Unknown.self
    }
    return objectClass
}

fileprivate func isReadOnly(property: objc_property_t) -> Bool {
    guard let item = property_getAttributes(property), let attributesAsNSString: NSString = NSString(utf8String: item) else { return false }
    let attributes = attributesAsNSString as String
    return attributes.contains(",R,")
}


fileprivate func valueType(withAttributes attributes: String) -> Any {
    guard let letter = attributes.substring(from: 1, to: 2), let type = valueTypesMap[letter] else { return Any.self }
    return type
}

fileprivate func getNameOf(property: objc_property_t) -> String? {
    guard
        let name: NSString = NSString(utf8String: property_getName(property))
    else { return nil }
    return name as String
}

fileprivate let valueTypesMap: Dictionary<String, Any> = [
    "c" : Int8.self,
    "s" : Int16.self,
    "i" : Int32.self,
    "q" : Int.self,
    "S" : UInt16.self,
    "I" : UInt32.self,
    "Q" : UInt.self,
    "B" : Bool.self,
    "d" : Double.self,
    "f" : Float.self,
    "{" : Decimal.self
]

private extension String {
    func substring(from fromIndex: Int, to toIndex: Int) -> String? {
        let substring = self[self.index(self.startIndex, offsetBy: fromIndex)..<self.index(self.startIndex, offsetBy: toIndex)]
        return String(substring)
    }

    /// Extracts "NSDate" from the string "Optional(NSDate)"
    var withoutOptional: String {
        guard self.contains("Optional(") && self.contains(")") else { return self }
        let afterOpeningParenthesis = self.components(separatedBy: "(")[1]
        let wihtoutOptional = afterOpeningParenthesis.components(separatedBy: ")")[0]
        return wihtoutOptional
    }
    
    func chopPrefix(_ count: Int = 1) -> String {
        let index = index(startIndex, offsetBy: count)
        return String(prefix(upTo: index))
    }
    
    func chopSuffix(_ count: Int = 1) -> String {
        let index = index(endIndex, offsetBy: -count)
        return String(suffix(from: index))
    }
}
