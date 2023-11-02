import XCTest
import CoreData
import BaseCoreData


/// Enabling comparision of "primitive data types" such as Bool, Int etc
func ==(rhs: Any, lhs: Any) -> Bool {
    let rhsType: String = "\(rhs)"
    let lhsType: String = "\(lhs)"
    let same = rhsType == lhsType
    return same
}

func ==(rhs: NSObject.Type, lhs: Any) -> Bool {
    let rhsType: String = "\(rhs)"
    let lhsType: String = "\(lhs)"
    let same = rhsType == lhsType
    return same
}

func ==(rhs: Any, lhs: NSObject.Type) -> Bool {
    let rhsType: String = "\(rhs)"
    let lhsType: String = "\(lhs)"
    let same = rhsType == lhsType
    return same
}

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
//        CoreDataStack.shares.sqliteName = "BaseCoreData"
//        CoreDataStack.shares.entity.append(DefinitionEntity.createEntityDescription())
    
    }
    
   
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testBookClass() {
        guard let types = getTypesOfProperties(in: DefinitionEntity.self) else {
            assert(false, "Should be able to get types")
            return
        }
        assert(types.count == 4, "Book should have 5 properties")
        for (propertyName, propertyType) in types {
            switch propertyName {
            case "key":
                assert(propertyType == NSString.self, "'title' should be of type 'String'")
            case "type":
                assert(propertyType == NSString.self, "Even though 'author' has type Optional<String> it should be 'String'")
            case "updateDate":
                assert(propertyType == NSDate.self, "'released' should be of type 'NSDate'")
            case "updateDate3":
                assert(propertyType == Bool.self, "'isPocket' should be of primitive data type 'Bool'")
            default:
                assert(false, "should not contain any property with any other name")
            }
        }
    }
    
}



@objc(DefinitionEntity)
final class DefinitionEntity: NSManagedObject {
    @NSManaged var key: String
    @NSManaged var type: String
    @NSManaged var updateDate: NSDate
    @NSManaged var updateDate3: Bool
}

extension DefinitionEntity: DomainConvertibleType {
    typealias DomainType = DataDefinition
    
    static func createEntityDescription() -> NSEntityDescription {
        Helper.createEntity(in: Self.self)
        
        return Table(name: String(describing: DefinitionEntity.self),
                     fields: [Field(name: "key", type: NSAttributeType.stringAttributeType),
                              Field(name: "type", type: NSAttributeType.stringAttributeType),
                              Field(name: "updateDate", type: NSAttributeType.stringAttributeType)
                             ]).entity()
    }
    
    func asDomain() -> DataDefinition {
        return DataDefinition(key: key,
                              type: type,
                              updateDate: updateDate, updateDate3: updateDate3)
    }
}

struct DataDefinition {
    var key: String
    var type: String
    var updateDate: NSDate
    var updateDate3: Bool
}

extension DataDefinition: CoreDataRepresentable {
    typealias CoreDataType = DefinitionEntity
    
    func asCoreData(object: DefinitionEntity) {
        object.key = key
        object.type = type
        object.updateDate = updateDate
        object.updateDate3 = updateDate3
    }
}
