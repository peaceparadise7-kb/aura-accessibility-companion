# AURA Mobile Application Architecture

## 1. Architectural Style: Feature-First Clean Architecture

The mobile application (`apps/mobile`) follows Clean Architecture with a Feature-First modular decomposition. Clean boundaries separate pure business logic from UI frameworks and platform-specific sensors.

```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                      │
│   - Flutter Widgets, Screens, High-Contrast Theming         │
│   - Semantics Tree & Screen-Reader VoiceOver / TalkBack     │
└──────────────────────────────┬──────────────────────────────┘
                               │ Calls Use Cases
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                    Application Layer                        │
│   - Use Cases (RecognizeAppliance, ScanControls, Announce)  │
│   - Orchestrates domain rules and coordinates services      │
└──────────────────────────────┬──────────────────────────────┘
                               │ Operates on Entities & Repositories
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                       Domain Layer                          │
│   - Pure Dart (Zero Flutter / Platform dependencies)        │
│   - Entities (Appliance, ControlElement, ApplianceProfile)  │
│   - Service Interfaces (Camera, ARSession, OCR, TTS, etc.)  │
└──────────────────────────────▲──────────────────────────────┘
                               │ Implements Interfaces
┌──────────────────────────────┴──────────────────────────────┐
│                   Data & Platform Layers                    │
│   - Local Asset / SQLite DataSource                         │
│   - Platform Adapters (PlatformARAdapter, CameraAdapter)     │
│   - Event & Method Channels matching shared contracts       │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Core Domain Interfaces

The domain defines 9 strict interfaces:

1. `CameraService`: Controls frame rates, resolutions, and raw image stream dispatch.
2. `ARSessionService`: Manages plane detection, tracking states, raycasting, and anchor registration.
3. `ApplianceRecognitionService`: Evaluates live frames to identify appliance brand and model candidate.
4. `ControlRecognitionService`: Detects physical interactive widgets (buttons, dials, toggles).
5. `OCRService`: Extracts optical text and correlates with expected labels.
6. `ControlMappingService`: Binds live visual detections to verified profile specifications with strict non-hallucination checks.
7. `TextToSpeechService`: Speaks accessibility descriptions, queueing or interrupting audio feedback.
8. `HapticFeedbackService`: Provides distinct tactile vibration feedback for confirmation, button proximity, and safety cautions.
9. `ApplianceProfileRepository`: Supplies verified geometric profiles offline and synchronizes with catalog backend.

---

## 3. Error Handling: Functional Result Pattern

AURA enforces explicit, compile-time checked error handling using the `Result<T>` sealed class instead of unchecked exceptions.

```dart
final Result<ApplianceProfile> profileResult = await profileRepository.getProfileById('panasonic_microwave');

profileResult.fold(
  (profile) => _renderProfile(profile),
  (failure) => _announceError(failure.message),
);
```

### Hierarchy of Typed Failures:
- `Failure` (Base)
  - `CameraFailure`
  - `ARSessionFailure`
  - `RecognitionFailure`
  - `OCRFailure`
  - `StorageFailure`
  - `ProfileNotFoundFailure`
  - `NetworkFailure`
  - `AccessibilityServiceFailure`

---

## 4. Accessibility & UI Invariants

- **Minimum Touch Targets**: All interactive elements maintain a bounding box of at least 48x48dp (defaults to 56dp for primary actions).
- **High Contrast Ratios**: Dark UI with high-visibility amber (`#FFD54F`) and cyan (`#80D8FF`) exceeding WCAG AAA 7:1 contrast ratios.
- **Auditory & Tactile Parity**: Every visual cue displayed in AR or UI is paired with an equivalent screen reader announcement and tactile haptic pulse.
- **Safety Prominence**: Cautionary warnings (e.g., immediate microwave heating, heat elements) are prepended to control descriptions.
