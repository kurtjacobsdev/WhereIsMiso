import XCTest
@testable import ui_common

final class ui_commonTests: XCTestCase {
    func testFlagConversion() {
        // Arrange
        let locales = ["DE", "ZA", "US", "JP"]
        let flags = ["π©πͺ", "πΏπ¦", "πΊπΈ", "π―π΅"]
        
        // Act
        let converted = locales.map { $0.flag() }
        
        // Assert
        XCTAssertEqual(converted, flags)
    }
}
