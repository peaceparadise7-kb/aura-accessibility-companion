# AURA Machine Learning Pipeline

This module encompasses data collection protocols, dataset taxonomies, training routines, quantization pipelines, and on-device inference specifications for AURA.

## Core CV Objectives

1. **Appliance Body Classification**: Identify appliance category and approximate manufacturer silhouette.
2. **Control Panel Detection**: Locate the physical interactive surface (door frame, fascia, rotary dial clusters).
3. **Control Element Detection**: Detect bounding boxes for buttons, knobs, dials, LED readouts, and switches.
4. **Optical Character Recognition (OCR)**: In conjunction with platform native OCR engines (Google ML Kit / Apple Vision), parse text labels printed on the panel.
5. **Appliance Profile Matching**: Align visual detections against verified geometric profiles with zero hallucination.

## Model Invariants & Safety

- **Zero Hallucination Policy**: An unidentified or ambiguous control must NEVER be given an invented function.
- **Informational Only**: The model output is strictly descriptive for user guidance and safety alerts.
- **Offline-First Inference**: Models run on-device via ONNX Runtime Mobile or CoreML/NNAPI delegates.
- **Privacy Preservation**: No user camera frames leave the device without explicit opt-in diagnostic consent.

## Directory Layout

- `datasets/`: Dataset annotations and synthetic augmentation scripts.
- `training/`: Transfer learning and fine-tuning pipelines (YOLOv8-nano / MobileNetV4 / EfficientNet).
- `evaluation/`: Benchmarks measuring mAP50-95, latency, and memory consumption.
- `inference/`: ONNX runtime execution graphs, pre/post-processing logic.
- `models/`: Exported ONNX, INT8 quantized, and CoreML/TFLite models.
