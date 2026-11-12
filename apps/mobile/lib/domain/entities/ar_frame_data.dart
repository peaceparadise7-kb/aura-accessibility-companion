import 'dart:typed_data';
import 'package:equatable/equatable.dart';

/// Normalized camera image frame captured for computer vision analysis.
class CameraFrameData extends Equatable {
  final Uint8List bytes;
  final int width;
  final int height;
  final int rotationDegrees;
  final int timestampMs;

  const CameraFrameData({
    required this.bytes,
    required this.width,
    required this.height,
    required this.rotationDegrees,
    required this.timestampMs,
  });

  @override
  List<Object?> get props => [width, height, rotationDegrees, timestampMs];
}
