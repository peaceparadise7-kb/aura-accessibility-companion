# AURA — Accessible Utility Recognition Assistant

[![Mobile CI](https://github.com/aura-accessibility/AURA/actions/workflows/flutter.yml/badge.svg)](https://github.com/aura-accessibility/AURA/actions/workflows/flutter.yml)
[![Backend CI](https://github.com/aura-accessibility/AURA/actions/workflows/backend.yml/badge.svg)](https://github.com/aura-accessibility/AURA/actions/workflows/backend.yml)
[![Validation](https://github.com/aura-accessibility/AURA/actions/workflows/validation.yml/badge.svg)](https://github.com/aura-accessibility/AURA/actions/workflows/validation.yml)

A cross-platform, accessibility-focused smartphone application that helps visually impaired users, elderly users, and individuals with accessibility needs understand and navigate physical controls on household appliances (microwaves, washing machines, dishwashers, refrigerators, air conditioners, and ovens).

---

## 1. Core Principles

- **Zero Hallucination Policy**: An unidentified or ambiguous control is NEVER assigned a guessed function. Control meanings are identified exclusively via verified appliance profiles.
- **Informational Only**: The application provides real-time multimodal guidance (AR visual highlights, text-to-speech descriptions, tactile haptic cues). It does NOT physically actuate appliances.
- **Privacy & Offline First**: Computer vision and OCR are executed entirely on-device. No domestic video feeds are sent to cloud servers.

---

## 2. Monorepo Architecture

```
AURA/
├── apps/
│   ├── mobile/             # Flutter Mobile App (Material 3, Clean Architecture)
│   └── admin_web/          # Admin Web Console (Profile authoring & curation)
├── native/
│   ├── android_ar/         # Android ARCore & CameraX native module
│   └── ios_ar/             # iOS ARKit & AVFoundation native Swift package
├── backend/
│   ├── app/                # FastAPI profile sync catalog & telemetry
│   ├── tests/              # Pytest test suite
│   └── migrations/         # Database migrations (Alembic)
├── ml/
│   ├── datasets/           # Appliance dataset annotations
│   ├── training/           # Model training pipelines
│   ├── evaluation/         # Latency, memory & mAP benchmarks
│   ├── inference/          # ONNX Runtime graph execution
│   └── models/             # Quantized on-device models
├── shared/
│   ├── contracts/          # Normalized AR event specs & OpenAPI contracts
│   └── schemas/            # JSON Schemas for appliance profiles & events
├── infrastructure/
│   ├── docker/             # Docker compose & Postgres container
│   ├── ci/                 # Validation scripts
│   └── deployment/         # Deployment manifests
└── docs/                   # Architectural specifications, ADRs & standards
```

---

## 3. Technology Stack

- **Mobile Client**: Flutter 3.38+, Dart 3.10+, Material 3 High Contrast, Feature-First Clean Architecture.
- **Android Native**: Kotlin 1.9+, Google ARCore, CameraX.
- **iOS Native**: Swift 5.9+, Apple ARKit, AVFoundation.
- **Computer Vision & OCR**: On-device ONNX Runtime INT8 models, Google ML Kit, Apple Vision framework.
- **Backend**: Python 3.12, FastAPI, PostgreSQL 16, Docker.
- **CI/CD**: GitHub Actions (Ubuntu and macOS runners).

---

## 4. Getting Started

### Prerequisites
- Flutter SDK >= 3.22 (3.38+ recommended)
- Dart SDK >= 3.3 (3.10+ recommended)
- Python >= 3.11 (3.12 recommended)
- Docker & Docker Compose (optional for backend development)

### Quick Validation
Validate shared contracts and schemas:
```bash
python infrastructure/ci/validate_schemas.py
```

### Run Mobile App
```bash
cd apps/mobile
flutter pub get
flutter test
flutter run
```

### Run Backend API
```bash
cd backend
pip install -r requirements.txt
uvicorn backend.app.main:app --reload
```

---

## 5. Documentation Directory

- [System Architecture](docs/architecture/system-architecture.md)
- [Mobile Application Architecture](docs/architecture/mobile-architecture.md)
- [Recognition & Vision Pipeline](docs/architecture/recognition-pipeline.md)
- [Platform Integration & Normalized AR Events](docs/architecture/platform-integration.md)
- [ADR 0001: Cross-Platform Mobile Architecture](docs/adr/0001-cross-platform-architecture.md)
- [Contribution Guidelines](docs/engineering/contribution-guidelines.md)
- [Coding Standards](docs/engineering/coding-standards.md)
- [Testing Strategy](docs/testing/testing-strategy.md)
