import Foundation

public enum NormalizedAREvent {
    case trackingStateChanged(sessionId: String, state: String, reason: String)
    case planeDetected(sessionId: String, planeId: String, alignment: String, extentX: Float, extentZ: Float)
    case anchorUpdated(sessionId: String, anchorId: String, matrix4x4: [Float])
    case sessionError(sessionId: String, errorCode: String, errorMessage: String)

    public func toDictionary() -> [String: Any] {
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        switch self {
        case .trackingStateChanged(let sessionId, let state, let reason):
            return [
                "eventType": "tracking_state_changed",
                "timestampMs": timestamp,
                "sessionId": sessionId,
                "trackingState": state,
                "trackingReason": reason
            ]
        case .planeDetected(let sessionId, let planeId, let alignment, let extentX, let extentZ):
            return [
                "eventType": "plane_detected",
                "timestampMs": timestamp,
                "sessionId": sessionId,
                "planeId": planeId,
                "alignment": alignment,
                "extentX": extentX,
                "extentZ": extentZ
            ]
        case .anchorUpdated(let sessionId, let anchorId, let matrix):
            return [
                "eventType": "anchor_updated",
                "timestampMs": timestamp,
                "sessionId": sessionId,
                "anchorId": anchorId,
                "matrix4x4": matrix
            ]
        case .sessionError(let sessionId, let errorCode, let errorMessage):
            return [
                "eventType": "session_error",
                "timestampMs": timestamp,
                "sessionId": sessionId,
                "errorCode": errorCode,
                "errorMessage": errorMessage
            ]
        }
    }
}
