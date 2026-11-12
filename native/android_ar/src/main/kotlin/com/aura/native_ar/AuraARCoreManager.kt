package com.aura.native_ar

import android.content.Context
import com.google.ar.core.Config
import com.google.ar.core.Session
import com.google.ar.core.TrackingState
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.asSharedFlow
import java.util.UUID

/**
 * Manages native Google ARCore sessions and emits normalized cross-platform events.
 */
class AuraARCoreManager(private val context: Context) {
    private var arSession: Session? = null
    private var sessionId: String = UUID.randomUUID().toString()

    private val _events = MutableSharedFlow<NormalizedAREvent>(extraBufferCapacity = 64)
    val events: SharedFlow<NormalizedAREvent> = _events.asSharedFlow()

    fun initializeSession(detectVerticalPlanes: Boolean): Boolean {
        return try {
            sessionId = UUID.randomUUID().toString()
            val session = Session(context)
            val config = Config(session).apply {
                planeFindingMode = if (detectVerticalPlanes) {
                    Config.PlaneFindingMode.HORIZONTAL_AND_VERTICAL
                } else {
                    Config.PlaneFindingMode.HORIZONTAL_ONLY
                }
                focusMode = Config.FocusMode.AUTO
                updateMode = Config.UpdateMode.LATEST_CAMERA_IMAGE
            }
            session.configure(config)
            arSession = session

            _events.tryEmit(
                NormalizedAREvent.TrackingStateChanged(
                    sessionId = sessionId,
                    state = "initializing"
                )
            )
            true
        } catch (e: Exception) {
            _events.tryEmit(
                NormalizedAREvent.SessionError(
                    sessionId = sessionId,
                    errorCode = "INIT_FAILED",
                    errorMessage = e.message ?: "ARCore initialization failed"
                )
            )
            false
        }
    }

    fun pause() {
        arSession?.pause()
        _events.tryEmit(
            NormalizedAREvent.TrackingStateChanged(
                sessionId = sessionId,
                state = "paused"
            )
        )
    }

    fun resume() {
        arSession?.resume()
        _events.tryEmit(
            NormalizedAREvent.TrackingStateChanged(
                sessionId = sessionId,
                state = "tracking"
            )
        )
    }

    fun dispose() {
        arSession?.close()
        arSession = null
        _events.tryEmit(
            NormalizedAREvent.TrackingStateChanged(
                sessionId = sessionId,
                state = "not_tracking"
            )
        )
    }
}
