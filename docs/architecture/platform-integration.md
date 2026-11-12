# AURA Platform Integration & Native AR Normalization

## 1. Native Platform Abstraction

To ensure long-term maintainability and strict cross-platform parity, Flutter code never interacts directly with Android SDK or iOS CocoaTouch framework classes.

Instead, the application layer communicates through **Normalized Contracts** across Flutter Platform Channels:

| Platform Function | Android Native Bridge | iOS Native Bridge | Flutter Platform Adapter |
| :--- | :--- | :--- | :--- |
| **AR Engine** | Google ARCore (`AuraARCoreManager.kt`) | Apple ARKit (`AuraARKitManager.swift`) | `PlatformARAdapter.dart` |
| **Camera Feed** | Android CameraX | AVFoundation | `PlatformCameraAdapter.dart` |
| **OCR Text Engine** | Google ML Kit Text Recognition | Apple Vision (`VNRecognizeTextRequest`) | `PlatformOCRAdapter.dart` |
| **Haptic Feedback** | Android VibrationEffect / HapticFeedback | iOS UIImpactFeedbackGenerator | `PlatformHapticAdapter.dart` |
| **Text-to-Speech** | Android TextToSpeech | iOS AVSpeechSynthesizer | `PlatformTTSAdapter.dart` |

---

## 2. Normalized AR Event Contract

Native AR engines differ significantly in their callback lifecycles, coordinate systems, and plane representations. AURA normalizes all events into the `NormalizedAREvent` schema defined in `shared/contracts/ar_event_contract.json`:

### Event Types:
1. `tracking_state_changed`: Normalized tracking state (`not_tracking`, `initializing`, `tracking`, `paused`, `limited`) and normalized degradation reasons (`excessive_motion`, `insufficient_features`, `relocalizing`).
2. `plane_detected`: Emits normalized plane ID, surface alignment (`vertical` or `horizontal`), and metric dimensions (`extentX`, `extentZ`).
3. `anchor_updated`: Emits 4x4 column-major transformation matrix mapped to world coordinates.
4. `session_error`: Normalizes native exceptions into structured error codes and messages.

---

## 3. Zero-Leak Memory Management

1. **Transient Frame Buffers**: Camera frame pointers are wrapped in native byte arrays and discarded immediately after inference without allocation on the Dart VM garbage collector heap.
2. **Subscription Lifecycle**: `PlatformARAdapter` cancels native `EventChannel` listener subscriptions on dispose, releasing ARCore session instances and ARKit session delegates cleanly.
