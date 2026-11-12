# AURA Recognition & Vision Pipeline

## 1. Overview

The AURA recognition pipeline identifies physical appliances and maps their controls in real time using a hybrid edge-inference strategy.

The pipeline combines:
1. **Geometric Priors**: Pre-verified appliance profiles containing known relative control bounding boxes and dimensions.
2. **On-Device Object Detection**: Fast, quantized models (ONNX Runtime) detecting appliance fascia and button clusters.
3. **High-Accuracy OCR**: Native platform text recognition (Google ML Kit on Android, Apple Vision framework on iOS) reading silkscreened text.
4. **Spatial SLAM Tracking**: ARCore/ARKit plane anchors stabilizing 3D holographic overlays on the physical appliance surface.

---

## 2. Pipeline Execution Steps

```
Step 1: Frame Acquisition
  └─ CameraX (Android) / AVFoundation (iOS) delivers YUV/RGB frames at 15 FPS.

Step 2: Appliance Classification
  └─ Global scene inference determines appliance category (Microwave, Oven, etc.).
  └─ Candidate profile matched against local database (e.g. Panasonic NN-SD372S).

Step 3: Control Panel Localization & Planar Alignment
  └─ Native AR SLAM detects vertical plane aligned with appliance face.
  └─ Calculates 4x4 homography transform to rectify perspective skew.

Step 4: Control Element Detection & OCR Extraction
  └─ Extracts button candidate bounding boxes.
  └─ Extracts printed text strings near or inside detected boxes.

Step 5: Constrained Verification & Mapping
  └─ RuleBasedControlMappingService computes Intersection-over-Union (IoU) with verified profile.
  └─ Performs fuzzy keyword matching against known labels.
  └─ SAFETY CHECK: If candidate does not meet >= 0.65 spatial match or OCR keyword match,
     it remains UNVERIFIED. The pipeline NEVER guesses an unverified button.

Step 6: Multimodal Accessibility Rendering
  └─ AR layer anchors high-contrast bounding box and label in 3D world coordinates.
  └─ TTS announces label and safety warnings as camera centers on the control.
  └─ Haptic engine produces tactile click tick when cursor intersects control zone.
```

---

## 3. Zero-Hallucination Invariant

```
                 Detected Physical Control Candidate
                                │
                                ▼
            Spatial match with Profile Bounding Box >= 0.65?
                           ├── YES ──► Check OCR keyword match
                           └── NO
                                │
                                ▼
                   OCR keyword explicitly matches?
                           ├── YES ──► Mark as VERIFIED MappedControl
                           └── NO
                                │
                                ▼
                      MARK AS UNVERIFIED
               (Do not assign speculative function)
```
