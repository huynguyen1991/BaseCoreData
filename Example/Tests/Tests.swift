import XCTest
import CoreData
import BaseCoreData

class Tests: XCTestCase {
    
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
    
    func testGetTypesOfProperties() {
        guard let types = getTypesOfProperties(in: DefinitionEntity.self) else {
            assert(false, "Should be able to get types")
        }
        
        assert(types.count == 12, "Book should have 12 properties")
        
        for (propertyName, propertyType) in types {
            
            print("propertyName \(propertyName) -- propertyType \(propertyType)")
            switch propertyName {
            case "int16":
                assert(propertyType == Int16.self, "'int16' should be of type 'Int16'")
            case "int32":
                assert(propertyType == Int32.self, "'int32' should be of type 'Int32'")
            case "int64":
                assert(propertyType == Int.self, "'int64' should be of type 'Int'")
            case "int":
                assert(propertyType == Int.self, "'int' should be of type 'Int'")
            case "decimal":
                assert(propertyType == Decimal.self, "'decimal' should be of type 'Decimal'")
            case "double":
                assert(propertyType == Double.self, "'double' should be of type 'Double'")
            case "float":
                assert(propertyType == Float.self, "'float' should be of type 'Float'")
            case "bool":
                assert(propertyType == Bool.self, "'bool' should be of type 'Bool'")
            case "string":
                assert(propertyType == NSString.self, "'string' should be of type 'NSString'")
            case "date":
                assert(propertyType == NSDate.self, "'date' should be of type 'NSDate'")
            case "data":
                assert(propertyType == NSData.self, "'data' should be of type 'NSData'")
            case "uUID":
                assert(propertyType == NSUUID.self, "'uUID' should be of type 'NSUUID'")
            default:
                assert(false, "should not contain any property with any other name")
            }
        }
    }
    
    func testCoreDataTypeConvet() {
        guard let types = getTypesOfProperties(in: DefinitionEntity.self) else {
            assert(false, "Should be able to get types")
        }
        
        assert(types.count == 12, "Book should have 12 properties")
        
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
