import XCTest

final class WorkflowTests: XCTestCase {
  override func setUpWithError() throws { continueAfterFailure = false }
  override func tearDownWithError() throws { XCUIApplication().terminate() }

  private func launch() -> XCUIApplication {
    let app = XCUIApplication()
    app.launchEnvironment["PORTFOLIO_UI_TEST"] = UUID().uuidString
    app.launch()
    return app
  }
  private func capture(_ app: XCUIApplication, _ name: String) {
    let attachment = XCTAttachment(screenshot: app.screenshot())
    attachment.name = name
    attachment.lifetime = .keepAlways
    add(attachment)
  }
  func testFormValidationAndLargeRTLLayout() {
    let app = launch()
    XCTAssertTrue(app.staticTexts["Built to include."].waitForExistence(timeout: 10))
    capture(app, "catalog")
    app.staticTexts["Forms"].tap()
    app.buttons["Save profile"].tap()
    XCTAssertTrue(app.staticTexts["Enter your name."].waitForExistence(timeout: 5))
    capture(app, "validation")
    app.navigationBars.buttons.element(boundBy: 0).tap()
    app.swipeUp()
    app.switches["Right-to-left layout"].tap()
    app.switches["Accessibility text size"].tap()
    capture(app, "large-rtl")
    XCTAssertTrue(app.switches["Accessibility text size"].exists)
  }
}
