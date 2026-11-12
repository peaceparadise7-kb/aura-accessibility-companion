package com.aura.native_ar

/**
 * Normalized AR events matching cross-platform schema for ARCore.
 */
sealed class NormalizedAREvent(
    val eventType: String,
    val timestampMs: Long = System.currentTimeMillis(),
    val sessionId: String
) {
    fun toMap(): Map<String, Any?> = when (this) {
        is TrackingStateChanged -> mapOf(
            "eventType" to eventType,
            "timestampMs" to timestampMs,
            "sessionId" to sessionId,
            "trackingState" to state,
            "trackingReason" to reason
        )
        is PlaneDetected -> mapOf(
            "eventType" to eventType,
            "timestampMs" to timestampMs,
            "sessionId" to sessionId,
            "planeId" to planeId,
            "alignment" to alignment,
            "extentX" to extentX,
            "extentZ" to extentZ
        )
        is AnchorUpdated -> mapOf(
            "eventType" to eventType,
            "timestampMs" to timestampMs,
            "sessionId" to sessionId,
            "anchorId" to anchorId,
            "matrix4x4" to matrix4x4.toList()
        )
        is SessionError -> mapOf(
            "eventType" to eventType,
            "timestampMs" to timestampMs,
            "sessionId" to sessionId,
            "errorCode" to errorCode,
            "errorMessage" to errorMessage
        )
    }

    class TrackingStateChanged(
        sessionId: String,
        val state: String,
        val reason: String = "none"
    ) : NormalizedAREvent("tracking_state_changed", sessionId = sessionId)

    class PlaneDetected(
        sessionId: String,
        val planeId: String,
        val alignment: String,
        val extentX: Float,
        val extentZ: Float
    ) : NormalizedAREvent("plane_detected", sessionId = sessionId)

    class AnchorUpdated(
        sessionId: String,
        val anchorId: String,
        val matrix4x4: FloatArray
    ) : NormalizedAREvent("anchor_updated", sessionId = sessionId)

    class SessionError(
        sessionId: String,
        val errorCode: String,
        val errorMessage: String
    ) : NormalizedAREvent("session_error", sessionId = sessionId)
}
