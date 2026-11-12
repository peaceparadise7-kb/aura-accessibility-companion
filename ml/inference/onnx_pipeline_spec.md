# On-Device ONNX Inference Specification

## 1. Architecture

```
Camera Frame (RGB 1280x720)
       │
       ▼
Preprocessing (Letterbox to 640x640, Normalized [0, 1])
       │
       ▼
Appliance & Panel Detector (ONNX Model: aura_panel_v1_int8.onnx)
       ├── Appliance Category Classification
       └── Panel Bounding Box [x1, y1, x2, y2]
       │
       ▼
Panel Crop & Homography Rectification
       │
       ├── Control Element Detection (buttons, dials, displays)
       └── Platform Native OCR (Apple Vision / ML Kit)
       │
       ▼
Geometric & Semantic Alignment against ApplianceProfileRepository
       │
       ▼
Normalized AREvent Output to Presentation Layer
```

## 2. Model Performance Budgets

| Metric | Target Budget | Hard Maximum |
| :--- | :--- | :--- |
| **Model Size (Quantized)** | <= 15 MB | 25 MB |
| **Inference Latency (Mobile NPU/GPU)** | <= 35 ms | 60 ms |
| **Frame Rate** | 15 FPS continuous | 10 FPS fallback |
| **Peak RAM Consumption** | <= 120 MB | 200 MB |
| **mAP@50 (Controls)** | >= 0.88 | 0.82 |
| **mAP@50:95 (Controls)** | >= 0.65 | 0.58 |
