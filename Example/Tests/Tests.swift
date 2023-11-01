import XCTest
import CoreData
import BaseCoreData


class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        CoreDataStack.shares.sqliteName = "BaseCoreData"
        CoreDataStack.shares.entity.append(DefinitionEntity.createEntityDescription())
    
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
    
}

@objc(DefinitionEntity)
final class DefinitionEntity: NSManagedObject {
    @NSManaged var key: String
    @NSManaged var type: String
    @NSManaged var updateDate: String
    @NSManaged var updateDate2: Double
    
}

class Book: NSObject {
    let title: String = ""
    let author: String? = ""
    let numberOfPages: Int = 0
}

extension DefinitionEntity: DomainConvertibleType {
    typealias DomainType = DataDefinition
    
    static func createEntityDescription() -> NSEntityDescription {
        if let types = getTypesOfProperties(ofObject: Book()) {
            for (name, type) in types {
                print("'\(name)' has type '\(type)'")
            }
        }
        
        return Table(name: String(describing: DefinitionEntity.self),
                     fields: [Field(name: "key", type: NSAttributeType.stringAttributeType),
                              Field(name: "type", type: NSAttributeType.stringAttributeType),
                              Field(name: "updateDate", type: NSAttributeType.stringAttributeType)
                             ]).entity()
    }
    
    func asDomain() -> DataDefinition {
        return DataDefinition(key: key,
                              type: type,
                              updateDate: updateDate)
    }
}

struct DataDefinition {
    var key: String
    var type: String
    var updateDate: String
}

extension DataDefinition: CoreDataRepresentable {
    typealias CoreDataType = DefinitionEntity
    
    func asCoreData(object: DefinitionEntity) {
        object.key = key
        object.type = type
        object.updateDate = updateDate
    }
}
