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
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    override func tearDownWithError() throws {}

    // INFO: Пример теста с прикреплением скриншота к отчету
    func testAttachment() throws {
        testOpsId(29610)
        severity("major")
        step("Запуск приложения") {
            app.launch()
        }
        step("Создание скриншота") {
            attachScreenshotToReport()
        }
    }
    
    // INFO: Пример теста с выводом в консоль
    func testPrintToConsole() throws {
        testOpsId(29613)
        severity("normal")
        step("Запуск приложения") {
            app.launch()
        }
        step("Вывод дерева локаторов текущего экрана") {
            printTree()
        }
    }
    
    
    // INFO: Пример теста с открытием сайта в Safari браузере
    func testSafari() throws {
        testOpsId(29612)
        severity("critical")
        step("Запуск браузера") {
            safari.launch()
        }
        step("Открытие сайта qa.guru") {
            safari.textFields["TabBarItemTitle"].tap()
            safari.textFields["URL"].typeText("https://qa.guru")
            safari.textFields["URL"].typeText("\n") // имитация нажатия кнопки "Enter"
        }
        step("Явное ожидание на 3 секунды") {
            sleep(3)
        }
    }
    
    // INFO: Пример теста с выполнением нажатий по кнопкам и простого ассерта
    func testSum() throws {
        testOpsId(29609)
        severity("blocker")
        feature("main")
        
        let button2 = app.buttons["2"].staticTexts["2"].firstMatch
        let buttonPlus = app.buttons["+"].firstMatch
        let buttonEqual = app.buttons["="].firstMatch
        
        step("Запуск приложения") {
            app.launch()
        }
        step("Выполняем сложение: \"2 + 2\"") {
            button2.tap()
            buttonPlus.tap()
            button2.tap()
        }
        step("Нажимаем на кнопку \"=\"") {
            buttonEqual.tap()
        }
        step("Проверяем результат сложения") {
            XCTAssert(app.buttons["resultString"].staticTexts["4"].exists)
        }
    }
    
    // INFO: Пример теста который пропускается
    func testSkip() throws {
        testOpsId(29611)
        severity("trivial")
        step("Запуск приложения") {
            app.launch()
        }

        try XCTSkipIf(true, "Сервер не отвечает")
    }

}
