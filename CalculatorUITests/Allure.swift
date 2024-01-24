import XCTest

public protocol Allure {}

extension XCTest: Allure {}

public extension Allure {
    func testOpsId(_ value: Int) {
        let stringValue = String(value)
        label(name: "ALLURE_ID", values: stringValue)
    }

    func feature(_ value: String) {
        label(name: "feature", values: value)
    }

    func severity(_ value: String) {
        label(name: "severity", values: value)
    }

    func label(name: String, values: String) {
        XCTContext.runActivity(named: "allure.label." + name + ":" + values, block: { _ in })
    }

    func step(_ name: String, step: () -> Void) {
        XCTContext.runActivity(named: name) { _ in
            step()
        }
    }

}
