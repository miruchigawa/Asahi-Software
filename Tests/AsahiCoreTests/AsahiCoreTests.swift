import XCTest
@testable import AsahiCore

final class AsahiCoreTests: XCTestCase {
    func testRequestParameters() throws {
        var settings = GenerationSettings()
        settings.prompt = "Test"
        let params = settings.requestParameters
        XCTAssertEqual(params["prompt"] as? String, "Test")
        XCTAssertEqual(params["steps"] as? Int, 20)
        let override = params["override_settings"] as? [String: Any]
        XCTAssertEqual(override?["sd_model_checkpoint"] as? String, "v1-5-pruned-emaonly")
    }

    func testNumberFormatter() {
        let formatter = NumberFormatter.defaultFormatter
        XCTAssertFalse(formatter.usesGroupingSeparator)
        XCTAssertEqual(formatter.string(from: 1234.56), "1234.56")
    }
}
