import XCTest
@testable import AuraNativeAR

final class NormalizedAREventTests: XCTestCase {

    func testTrackingStateChangedDictionary() {
        let event = NormalizedAREvent.trackingStateChanged(
            sessionId: "session_ios_1",
            state: "tracking",
            reason: "none"
        )
        let dict = event.toDictionary()

        XCTAssertEqual(dict["eventType"] as? String, "tracking_state_changed")
        XCTAssertEqual(dict["sessionId"] as? String, "session_ios_1")
        XCTAssertEqual(dict["trackingState"] as? String, "tracking")
        XCTAssertEqual(dict["trackingReason"] as? String, "none")
        XCTAssertNotNil(dict["timestampMs"])
    }

    func testPlaneDetectedDictionary() {
        let event = NormalizedAREvent.planeDetected(
            sessionId: "session_ios_1",
            planeId: "plane_panel_1",
            alignment: "vertical",
            extentX: 0.6,
            extentZ: 0.4
        )
        let dict = event.toDictionary()

        XCTAssertEqual(dict["eventType"] as? String, "plane_detected")
        XCTAssertEqual(dict["planeId"] as? String, "plane_panel_1")
        XCTAssertEqual(dict["alignment"] as? String, "vertical")
        XCTAssertEqual(dict["extentX"] as? Float, 0.6)
    }
}
