import 'dart:typed_data';
import 'package:aura_mobile/core/utils/result.dart';
import 'package:aura_mobile/domain/entities/control_element.dart';

/// Text recognition detection unit.
class OCRDetection {
  final String text;
  final NormalizedBoundingBox boundingBox;
  final double confidence;

  const OCRDetection({
    required this.text,
    required this.boundingBox,
    required this.confidence,
  });
}

/// Abstract service governing Optical Character Recognition on appliance control panels.
abstract class OCRService {
  /// Extracts text snippets and bounding boxes from a cropped image region.
  Future<Result<List<OCRDetection>>> extractText(Uint8List imageBytes);

  /// Performs fuzzy text matching between OCR detections and known profile labels.
  List<OCRDetection> matchLabels({
    required List<OCRDetection> detections,
    required List<String> expectedTerms,
    double threshold = 0.75,
  });
}
