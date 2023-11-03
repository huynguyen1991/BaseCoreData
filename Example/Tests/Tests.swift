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
}


//@objc(DefinitionEntity)
//final class DefinitionEntity: NSManagedObject {
//    @NSManaged var key: String
//    @NSManaged var type: String
//    @NSManaged var updateDate: NSDate
//    @NSManaged var updateDate3: Bool
//}
//
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
//
//struct DataDefinition {
//    var key: String
//    var type: String
//    var updateDate: NSDate
//    var updateDate3: Bool
//}
//
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
