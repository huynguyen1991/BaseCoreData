import XCTest
import CoreData
import BaseCoreData

class SwiftReflection: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPerformanceExample() {
        self.measure() {
            
        }
    }
    
    func testPropertyCount() {
        guard let types = getTypesOfProperties(in: DefinitionEntity.self) else {
            assert(false, "Should be able to get types")
        }
        
        assert(types.count == 12, "Expected 12 properties, but got \(types.count)")
    }
    
    func testPropertyNames() {
        guard let types = getTypesOfProperties(in: DefinitionEntity.self) else {
            assert(false, "Should be able to get types")
        }
        
        let propertyNames =  Array(types.keys)
        
        XCTAssertTrue(propertyNames.contains("int16")   , "int16 is missing")
        XCTAssertTrue(propertyNames.contains("int32")   , "int32 is missing")
        XCTAssertTrue(propertyNames.contains("int64")   , "int64 is missing")
        XCTAssertTrue(propertyNames.contains("int")     , "int is missing")
        XCTAssertTrue(propertyNames.contains("decimal") , "decimal is missing")
        XCTAssertTrue(propertyNames.contains("double")  , "double is missing")
        XCTAssertTrue(propertyNames.contains("float")   , "float is missing")
        XCTAssertTrue(propertyNames.contains("bool")    , "bool is missing")
        XCTAssertTrue(propertyNames.contains("string")  , "string is missing")
        XCTAssertTrue(propertyNames.contains("date")    , "date is missing")
        XCTAssertTrue(propertyNames.contains("data")    , "data is missing")
        XCTAssertTrue(propertyNames.contains("uUID")    , "uUID is missing")
    }
    
    func testPropertyType() {
        guard let types = getTypesOfProperties(in: DefinitionEntity.self) else {
            assert(false, "Should be able to get types")
        }
        
        XCTAssertTrue(types["int16"]! == Int16.self, "int16 is missing")
        XCTAssertTrue(types["int32"]! == Int32.self, "int32 is missing")
        XCTAssertTrue(types["int64"]! == Int.self, "int64 is missing")
        XCTAssertTrue(types["int"]! == Int.self, "int is missing")
        XCTAssertTrue(types["decimal"]! == Decimal.self, "decimal is missing")
        XCTAssertTrue(types["double"]! == Double.self, "double is missing")
        XCTAssertTrue(types["float"]! == Float.self, "float is missing")
        XCTAssertTrue(types["bool"]! == Bool.self, "bool is missing")
        XCTAssertTrue(types["string"]! == NSString.self, "string is missing")
        XCTAssertTrue(types["date"]! == NSDate.self, "date is missing")
        XCTAssertTrue(types["data"]! == NSData.self, "data is missing")
        XCTAssertTrue(types["uUID"]! == NSUUID.self, "uUID is missing")
    }
    
    
    func testCoreDataTypeConvet() {
        guard let types = getTypesOfProperties(in: DefinitionEntity.self) else {
            assert(false, "Should be able to get types")
        }
        
        assert(types.count == 12, "DefinitionEntity should have 12 properties")
        
        for (propertyName, propertyType) in types {
            print("propertyName \(propertyName) -- propertyType \(propertyType)")
            let attributeType = CoreDataType.convert(propertyType)
            switch propertyName {
            case "int16":
                assert(attributeType.self == .integer16AttributeType.self, "'int16' should be of type 'integer16AttributeType'")
            case "int32":
                assert(attributeType.self == .integer32AttributeType.self, "'int32' should be of type 'integer32AttributeType'")
            case "int64":
                assert(attributeType.self == .integer64AttributeType.self, "'int64' should be of type 'integer64AttributeType'")
            case "int":
                assert(attributeType.self == .integer64AttributeType.self, "'int' should be of type 'integer64AttributeType'")
            case "decimal":
                assert(attributeType.self == .decimalAttributeType.self, "'decimal' should be of type 'decimalAttributeType'")
            case "double":
                assert(attributeType.self == .doubleAttributeType.self, "'double' should be of type 'doubleAttributeType'")
            case "float":
                assert(attributeType.self == .floatAttributeType.self, "'float' should be of type 'floatAttributeType'")
            case "bool":
                assert(attributeType.self == .booleanAttributeType.self, "'bool' should be of type 'booleanAttributeType'")
            case "string":
                assert(attributeType.self == .stringAttributeType.self, "'string' should be of type 'stringAttributeType'")
            case "date":
                assert(attributeType.self == .dateAttributeType.self, "'date' should be of type 'dateAttributeType'")
            case "data":
                assert(attributeType.self == .binaryDataAttributeType.self, "'data' should be of type 'binaryDataAttributeType'")
            case "uUID":
                assert(attributeType.self == .UUIDAttributeType.self, "'uUID' should be of type 'UUIDAttributeType'")
            default:
                assert(false, "should not contain any property with any other name")
            }
        }
    }
}

@objc(DefinitionEntity)
final class DefinitionEntity: NSManagedObject {
    @NSManaged var int16: Int16
    @NSManaged var int32: Int32
    @NSManaged var int64: Int64
    @NSManaged var int: Int
    @NSManaged var decimal: Decimal
    @NSManaged var double: Double
    @NSManaged var float: Float
    @NSManaged var bool: Bool
    @NSManaged var string: String
    @NSManaged var date: Date
    @NSManaged var data: Data
    @NSManaged var uUID: UUID
}

//extension DefinitionEntity: DomainConvertibleType {
//    typealias DomainType = DataDefinition
//
//    static func createEntityDescription() -> NSEntityDescription {
//        Helper.createEntity(in: Self.self)
//
//        return Table(name: String(describing: DefinitionEntity.self),
//                     fields: [Field(name: "key", type: NSAttributeType.stringAttributeType),
//                              Field(name: "type", type: NSAttributeType.stringAttributeType),
//                              Field(name: "updateDate", type: NSAttributeType.stringAttributeType)
//                             ]).entity()
//    }
//
//    func asDomain() -> DataDefinition {
//        return DataDefinition(key: key,
//                              type: type,
//                              updateDate: updateDate, updateDate3: updateDate3)
//    }
//}

//struct DataDefinition {
//    var key: String
//    var type: String
//    var updateDate: NSDate
//    var updateDate3: Bool
//}

//extension DataDefinition: CoreDataRepresentable {
//    typealias CoreDataType = DefinitionEntity
//
//    func asCoreData(object: DefinitionEntity) {
//        object.key = key
//        object.type = type
//        object.updateDate = updateDate
//        object.updateDate3 = updateDate3
//    }
//}

fileprivate func ==(rhs: Any, lhs: Any) -> Bool {
    let rhsType: String = "\(rhs)"
    let lhsType: String = "\(lhs)"
    let same = rhsType == lhsType
    return same
}
