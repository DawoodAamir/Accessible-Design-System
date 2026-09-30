import XCTest

@testable import AccessibleDesignKit

final class ValidationTests: XCTestCase {
  func testEmptyAndMalformedEmailHaveHelpfulErrors() {
    XCTAssertNotNil(FormValidation.email(" "))
    XCTAssertNotNil(FormValidation.email("alex"))
    XCTAssertNotNil(FormValidation.email("a @example.com"))
    XCTAssertNil(FormValidation.email("alex@example.com"))
  }
  func testNamesSupportNonLatinScripts() {
    XCTAssertNil(FormValidation.name("علی"))
    XCTAssertNotNil(FormValidation.name("\n "))
  }
}
