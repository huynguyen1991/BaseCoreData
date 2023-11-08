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
        
        assert(types.count == 11, "Expected 12 properties, but got \(types.count)")
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
        XCTAssertTrue(types["double"]! == Double.self, "double is missing")
        XCTAssertTrue(types["float"]! == Float.self, "float is missing")
        XCTAssertTrue(types["bool"]! == Bool.self, "bool is missing")
        XCTAssertTrue(types["string"]! == NSString.self, "string is missing")
        XCTAssertTrue(types["date"]! == NSDate.self, "date is missing")
        XCTAssertTrue(types["data"]! == NSData.self, "data is missing")
        XCTAssertTrue(types["uUID"]! == NSUUID.self, "uUID is missing")
    }
}

internal func ==(rhs: Any, lhs: Any) -> Bool {
    let rhsType: String = "\(rhs)"
    let lhsType: String = "\(lhs)"
    let same = rhsType == lhsType
    return same
}
