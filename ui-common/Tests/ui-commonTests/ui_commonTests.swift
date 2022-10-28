import XCTest
@testable import ui_common

final class ui_commonTests: XCTestCase {
    func testFlagConversion() {
        // Arrange
        let locales = ["DE", "ZA", "US", "JP"]
        let flags = ["🇩🇪", "🇿🇦", "🇺🇸", "🇯🇵"]
        
        // Act
        let converted = locales.map { $0.flag() }
        
        // Assert
        XCTAssertEqual(converted, flags)
    }
}
