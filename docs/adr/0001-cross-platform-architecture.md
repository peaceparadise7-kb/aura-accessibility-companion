# ADR 0001: Cross-Platform Mobile Architecture & Normalized Native AR Bridges

## Status
Accepted

## Date
2026-11-12

## Context
AURA is an accessibility-oriented augmented reality application targeting iOS and Android devices. It assists visually impaired and elderly users by recognizing physical household appliances and accurately mapping their controls.

Key challenges include:
- Delivering an accessible, high-contrast, accessible-first UI (WCAG AAA compliant, screen reader compatible) across both major mobile operating systems with minimal divergence.
- Interfacing with low-level platform Augmented Reality engines (Google ARCore on Android, Apple ARKit on iOS) and camera streams.
- Maintaining strict on-device performance budgets for real-time computer vision and OCR.
- Guaranteeing a zero-hallucination policy where unverified controls are never assigned speculative functions.

## Alternatives Considered
1. **Fully Native Independent Apps (Kotlin + Jetpack Compose on Android, Swift + SwiftUI on iOS)**:
   - *Pros*: Direct access to ARCore and ARKit without platform channel serialization overhead.
   - *Cons*: Doubles UI maintenance, duplicate accessibility audits, divergent business logic and verification rule discrepancies.
2. **Unity / Unreal Game Engines**:
   - *Pros*: Excellent cross-platform AR abstractions.
   - *Cons*: Poor screen reader (VoiceOver/TalkBack) accessibility integration, huge battery consumption, high bundle footprint (>150MB), non-standard mobile UI paradigms.
3. **Flutter with Feature-First Clean Architecture and Native AR Platform Bridges**:
   - *Pros*: Unified accessible UI layer with first-class `Semantics` engine; shared domain and business logic; platform adapters bridging native ARCore/ARKit normalized event streams.
   - *Cons*: Requires establishing and maintaining platform channel contracts for AR and camera frames.

## Decision
We choose **Flutter with Feature-First Clean Architecture and Normalized Native Platform Bridges**.

- The core presentation, use-case, and domain logic reside in `apps/mobile/`.
- Native AR capabilities are isolated in `native/android_ar/` (Kotlin / ARCore) and `native/ios_ar/` (Swift / ARKit).
- Both native modules conform to the `AuraAREventContract` (`shared/contracts/ar_event_contract.json`), emitting normalized events.
- On-device inference evaluates lightweight ONNX models and native OCR engines (Google ML Kit / Apple Vision) to preserve user privacy and offline availability.

## Consequences
- **Positive**: Single codebase for accessibility features, theming, profile caching, and safety invariants.
- **Positive**: High code reuse (>80%) across platforms.
- **Positive**: Screen reader semantics are easily tested and verified via Flutter widget test harnesses.
- **Mitigation**: Standardized automated tests on native packages (`swift test`, Kotlin JUnit) alongside Flutter CI validate contract serialization parity.
