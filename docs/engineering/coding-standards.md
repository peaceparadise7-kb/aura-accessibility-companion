# AURA Coding Standards & Engineering Invariants

## 1. Dart & Flutter Standards

- **Strict Type Inference & Casts**: All code in `apps/mobile/` must compile with `strict-casts: true`, `strict-inference: true`, and `strict-raw-types: true`.
- **Pure Domain Layer**: Files in `lib/domain/` must have ZERO imports from `package:flutter/` (except foundational data types like `Uint8List`). No widget or render objects in domain.
- **Result Monad Over Exceptions**: Business logic functions in repositories and services must return `Result<T>` instead of throwing untyped runtime exceptions.
- **Accessibility Invariants**:
  - All interactive buttons must have a minimum touch target size of 48x48dp.
  - All text must scale cleanly with system dynamic text sizes (up to 200%).
  - Contrast ratios for UI controls and text must achieve WCAG AAA compliance (>= 7:1 against dark backgrounds).
  - Every visual state transition must be reflected in `SemanticsService.announce` or TTS output.

---

## 2. Kotlin Standards (Android Native)

- Kotlin 1.9+ with coroutines for asynchronous operations.
- Data classes must implement clean mapping to `Map<String, Any?>` matching the shared normalized event schema.
- Strict nullability: avoid `!!` force-unwraps; handle AR session lifecycle changes defensively.

---

## 3. Swift Standards (iOS Native)

- Swift 5.9+ with strict concurrency readiness.
- Native structs/enums must implement clean dictionary conversion conforming to `shared/contracts/ar_event_contract.json`.
- Zero force-unwraps (`!`) in production AR session handling.

---

## 4. Python Standards (Backend & ML)

- Python 3.12+ with strict type hints (`typing`, `pydantic`).
- Code formatted with `ruff` with 100-character line lengths.
- Clean separation between API routing, data access models, and validation schemas.
