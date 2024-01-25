import XCTest

final class CalculatorUITests: XCTestCase {

    let app = XCUIApplication(bundleIdentifier: "QAGuru.Calculator")
    let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func printTree() {
      print(app.debugDescription)
    }

    func attachScreenshotToReport() {
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    func testSum() throws {
        app.launch()
        let button2 = app/*@START_MENU_TOKEN@*/.staticTexts["2"]/*[[".buttons[\"2\"].staticTexts[\"2\"]",".staticTexts[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        button2.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["+"]/*[[".buttons[\"+\"].staticTexts[\"+\"]",".staticTexts[\"+\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        button2.tap()
        app.buttons["="].tap()
        XCTAssert(app.buttons["resultString"].staticTexts["4"].exists)
    }

    func testMinus() throws {
        app.launch()

        app/*@START_MENU_TOKEN@*/.staticTexts["2"]/*[[".buttons[\"2\"].staticTexts[\"2\"]",".staticTexts[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.staticTexts["-"].tap()
        app.staticTexts["5"].tap()
        app.buttons["="].tap()
        XCTAssert(app.buttons["resultString"].staticTexts["-3"].exists)
    }

    func testDelete() throws {
        app.launch()

        app.staticTexts["2"].tap()
        app.staticTexts["9"].tap()
        app.buttons["backspace"].tap()
        app.staticTexts["+"].tap()
        app.staticTexts["3"].tap()
        app.buttons["="].tap()
        XCTAssert(app.buttons["resultString"].staticTexts["5"].exists)
    }

    func testEqualsTwice() throws {
        app.launch()

        app.staticTexts["2"].tap()
        app.staticTexts["x"].tap()
        app.staticTexts["3"].tap()
        app.buttons["="].tap()
        XCTAssert(app.buttons["resultString"].staticTexts["6"].exists)

        app.staticTexts["x"].tap()
        app.staticTexts["4"].tap()
        app.buttons["="].tap()
        XCTAssert(app.buttons["resultString"].staticTexts["24"].exists)
    }

    func testClear() throws {
        app.launch()

        app/*@START_MENU_TOKEN@*/.staticTexts["2"]/*[[".buttons[\"2\"].staticTexts[\"2\"]",".staticTexts[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.staticTexts["+"].tap()
        app.staticTexts["3"].tap()
        app.buttons["="].tap()
        app.buttons["AC"].tap()
        XCTAssert(app.buttons["resultString"].staticTexts["0"].exists)
    }

    func testError() throws {
        app.launch()

        app.staticTexts["%"].tap()

        XCTAssert(app.staticTexts["Ошибка"].exists)
        XCTAssert(app.staticTexts["Введите знак процента после числа!"].exists)

        app.buttons["OK"].tap()

        XCTAssertFalse(app.staticTexts["Ошибка"].exists)
    }
    
    func testSkip() throws {
        app.launch()
        let deviceName = ProcessInfo.processInfo.environment["DEVICE"]

        try XCTSkipIf(deviceName != "iPhone 15", "Test should run on iPhone 15 only.")
        
        app/*@START_MENU_TOKEN@*/.staticTexts["2"]/*[[".buttons[\"2\"].staticTexts[\"2\"]",".staticTexts[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["AC"].tap()
        XCTAssert(app.buttons["resultString"].staticTexts["0"].exists)
    }
    
    func testErrorHandling() throws {
        app.launch()
        let deviceName = ProcessInfo.processInfo.environment["DEVICE"]
        
        guard deviceName != "iPhone 15" else {
            throw CalcError.notSupportedDevice
        }

        app/*@START_MENU_TOKEN@*/.staticTexts["2"]/*[[".buttons[\"2\"].staticTexts[\"2\"]",".staticTexts[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["AC"].tap()
        XCTAssert(app.buttons["resultString"].staticTexts["0"].exists)
    }
    
    func testWait() throws {
        app.launch()

        app/*@START_MENU_TOKEN@*/.staticTexts["2"]/*[[".buttons[\"2\"].staticTexts[\"2\"]",".staticTexts[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["AC"].tap()
        
        XCTAssert(app.buttons["resultString"].staticTexts["0"]
            .waitForExistence(timeout: 2))
    }
}

enum CalcError: Error {
    case notSupportedDevice
    case someOtherError
}
