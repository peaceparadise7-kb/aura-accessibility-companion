# AURA System Architecture

## 1. Executive Summary

AURA (**Accessible Utility Recognition Assistant**) is a cross-platform, accessibility-first mobile application designed to assist visually impaired and elderly individuals in identifying and operating physical controls on household appliances (microwaves, washing machines, ovens, dishwashers, air conditioners).

The core technical philosophy of AURA is built around three uncompromising tenets:
1. **Safety & Zero Hallucination**: The application must NEVER invent, assume, or guess the function of an unidentified control. Controls are only labeled when verified against authenticated appliance profiles.
2. **Informational Non-Actuation**: The application is strictly descriptive and informational; it does not physically or electronically actuate appliances.
3. **Offline-First Privacy**: Vision and OCR inference occur directly on the device, ensuring camera video feeds are processed locally without leaking private domestic video to cloud endpoints.

---

## 2. Monorepo Structure & Module Boundaries

The repository is structured as a scalable monorepo separating mobile, native AR platform bridges, backend catalog, ML pipelines, and contracts:

```
AURA/
├── apps/
│   ├── mobile/             # Flutter cross-platform mobile client (iOS & Android)
│   └── admin_web/          # Web dashboard for appliance profile authoring & verification
├── native/
│   ├── android_ar/         # ARCore & CameraX native Android module
│   └── ios_ar/             # ARKit & AVFoundation native Swift package
├── backend/
│   ├── app/                # FastAPI catalog & sync backend
│   ├── tests/              # Pytest test suite
│   └── migrations/         # Database migrations (Alembic)
├── ml/
│   ├── datasets/           # Control-panel dataset annotations & schemas
│   ├── training/           # Model training & fine-tuning pipelines
│   ├── evaluation/         # Latency, memory, and mAP evaluation benchmarks
│   ├── inference/          # ONNX runtime optimization and execution graphs
│   └── models/             # INT8 quantized and platform-delegated models
├── shared/
│   ├── contracts/          # Normalized AR event specs & OpenAPI specs
│   └── schemas/            # JSON Schemas for appliance profiles & AR events
├── infrastructure/
│   ├── docker/             # Docker compose and container definitions
│   ├── ci/                 # Validation scripts
│   └── deployment/         # Production deployment manifests
└── docs/
    ├── architecture/       # Architectural specifications
    ├── adr/                # Architecture Decision Records
    ├── api/                # API contracts and sync docs
    ├── testing/            # Multi-tier testing strategy
    └── engineering/        # Contribution & coding standards
```

---

## 3. High-Level System Flow

```
                      ┌──────────────────────────────────────┐
                      │          Physical Appliance          │
                      │   (Buttons, Dials, Displays, Text)   │
                      └──────────────────┬───────────────────┘
                                         │
                                         ▼
                      ┌──────────────────────────────────────┐
                      │    Device Camera & Native AR Core    │
                      │    (CameraX / AVFoundation, SLAM)    │
                      └──────────────────┬───────────────────┘
                                         │
                                         ▼
                      ┌──────────────────────────────────────┐
                      │    Normalized Event Bridge           │
                      │   (com.aura.app/ar_session_events)   │
                      └──────────────────┬───────────────────┘
                                         │
                                         ▼
                      ┌──────────────────────────────────────┐
                      │       Flutter Domain & ML Engine     │
                      │   - Appliance Category Detection     │
                      │   - Panel Localization               │
                      │   - On-Device OCR                    │
                      │   - Geometric Profile Matching       │
                      └──────────────────┬───────────────────┘
                                         │
                                         ▼
                      ┌──────────────────────────────────────┐
                      │     Multimodal Accessibility Output   │
                      │   - High Contrast Material 3 AR HUD  │
                      │   - Real-time Text-to-Speech (TTS)   │
                      │   - Directional Haptic Feedback      │
                      └──────────────────────────────────────┘
```

---

## 4. Invariants & Security Boundaries

1. **Camera Frame Isolation**: Raw frame memory is processed in transient volatile buffers. No camera frames are stored to persistent disk or transmitted across network connections during standard recognition.
2. **Profile Verification Integrity**: Only profiles bearing `verification_status: "verified"` signed by certified accessibility and QA engineers are bundled into offline client storage.
3. **Decoupled Platform Abstraction**: Flutter presentation code never directly references native platform APIs. Communication is strictly negotiated across `MethodChannel` and `EventChannel` contracts defined in `shared/contracts/`.
