package com.aura.native_ar

import org.junit.Test
import kotlin.test.assertEquals
import kotlin.test.assertNotNull

class NormalizedAREventTest {

    @Test
    fun testTrackingStateChangedSerialization() {
        val event = NormalizedAREvent.TrackingStateChanged(
            sessionId = "session_android_1",
            state = "tracking",
            reason = "none"
        )

        val map = event.toMap()
        assertEquals("tracking_state_changed", map["eventType"])
        assertEquals("session_android_1", map["sessionId"])
        assertEquals("tracking", map["trackingState"])
        assertEquals("none", map["trackingReason"])
        assertNotNull(map["timestampMs"])
    }

    @Test
    fun testPlaneDetectedSerialization() {
        val event = NormalizedAREvent.PlaneDetected(
            sessionId = "session_android_1",
            planeId = "plane_front_panel",
            alignment = "vertical",
            extentX = 0.5f,
            extentZ = 0.3f
        )

        val map = event.toMap()
        assertEquals("plane_detected", map["eventType"])
        assertEquals("plane_front_panel", map["planeId"])
        assertEquals("vertical", map["alignment"])
        assertEquals(0.5f, map["extentX"])
        assertEquals(0.3f, map["extentZ"])
    }
}
