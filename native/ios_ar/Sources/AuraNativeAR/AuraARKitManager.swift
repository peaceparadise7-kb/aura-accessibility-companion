import Foundation
import ARKit

public protocol AuraARKitDelegate: AnyObject {
    func onAREvent(_ event: NormalizedAREvent)
}

public class AuraARKitManager: NSObject, ARSessionDelegate {
    public weak var delegate: AuraARKitDelegate?
    private var session: ARSession?
    private var sessionId: String = UUID().uuidString

    public override init() {
        super.init()
    }

    public func initializeSession(detectVerticalPlanes: BooleanLiteralType = true) {
        sessionId = UUID().uuidString
        session = ARSession()
        session?.delegate = self

        let configuration = ARWorldTrackingConfiguration()
        var planeDetection: ARWorldTrackingConfiguration.PlaneDetection = [.horizontal]
        if detectVerticalPlanes {
            planeDetection.insert(.vertical)
        }
        configuration.planeDetection = planeDetection
        configuration.isLightEstimationEnabled = true

        session?.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        delegate?.onAREvent(.trackingStateChanged(sessionId: sessionId, state: "initializing", reason: "none"))
    }

    public func pause() {
        session?.pause()
        delegate?.onAREvent(.trackingStateChanged(sessionId: sessionId, state: "paused", reason: "none"))
    }

    public func resume() {
        if let config = session?.configuration {
            session?.run(config)
            delegate?.onAREvent(.trackingStateChanged(sessionId: sessionId, state: "tracking", reason: "none"))
        }
    }

    // MARK: - ARSessionDelegate

    public func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        let (state, reason) = mapTrackingState(camera.trackingState)
        delegate?.onAREvent(.trackingStateChanged(sessionId: sessionId, state: state, reason: reason))
    }

    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                let alignment = planeAnchor.alignment == .vertical ? "vertical" : "horizontal"
                delegate?.onAREvent(.planeDetected(
                    sessionId: sessionId,
                    planeId: planeAnchor.identifier.uuidString,
                    alignment: alignment,
                    extentX: planeAnchor.planeExtent.width,
                    extentZ: planeAnchor.planeExtent.height
                ))
            }
        }
    }

    private func mapTrackingState(_ state: ARCamera.TrackingState) -> (String, String) {
        switch state {
        case .notAvailable:
            return ("not_tracking", "unsupported")
        case .limited(let reason):
            let reasonStr: String
            switch reason {
            case .excessiveMotion: reasonStr = "excessive_motion"
            case .insufficientFeatures: reasonStr = "insufficient_features"
            case .relocalizing: reasonStr = "relocalizing"
            default: reasonStr = "none"
            }
            return ("limited", reasonStr)
        case .normal:
            return ("tracking", "none")
        }
    }
}
