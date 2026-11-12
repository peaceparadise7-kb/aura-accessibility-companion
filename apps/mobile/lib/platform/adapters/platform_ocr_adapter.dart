import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:aura_mobile/core/errors/failures.dart';
import 'package:aura_mobile/core/logging/app_logger.dart';
import 'package:aura_mobile/core/utils/result.dart';
import 'package:aura_mobile/domain/entities/control_element.dart';
import 'package:aura_mobile/domain/services/ocr_service.dart';

/// Platform adapter implementing [OCRService].
/// Invokes native on-device OCR (Google ML Kit on Android, Vision framework on iOS).
class PlatformOCRAdapter implements OCRService {
  final MethodChannel _channel;
  final AppLogger _logger;

  PlatformOCRAdapter({
    MethodChannel? channel,
    required AppLogger logger,
  })  : _channel = channel ?? const MethodChannel('com.aura.app/ocr_service'),
        _logger = logger;

  @override
  Future<Result<List<OCRDetection>>> extractText(Uint8List imageBytes) async {
    try {
      if (imageBytes.isEmpty) {
        return const Result.ok([]);
      }

      final List<dynamic>? rawResults = await _channel.invokeMethod<List<dynamic>>(
        'extractText',
        {'imageBytes': imageBytes},
      );

      if (rawResults == null) return const Result.ok([]);

      final detections = <OCRDetection>[];
      for (final item in rawResults) {
        if (item is Map) {
          final text = item['text'] as String? ?? '';
          final left = (item['left'] as num?)?.toDouble() ?? 0.0;
          final top = (item['top'] as num?)?.toDouble() ?? 0.0;
          final right = (item['right'] as num?)?.toDouble() ?? 0.0;
          final bottom = (item['bottom'] as num?)?.toDouble() ?? 0.0;
          final confidence = (item['confidence'] as num?)?.toDouble() ?? 0.8;

          detections.add(
            OCRDetection(
              text: text,
              boundingBox: NormalizedBoundingBox(
                left: left.clamp(0.0, 1.0),
                top: top.clamp(0.0, 1.0),
                right: right.clamp(0.0, 1.0),
                bottom: bottom.clamp(0.0, 1.0),
              ),
              confidence: confidence,
            ),
          );
        }
      }

      return Result.ok(detections);
    } on MissingPluginException {
      _logger.debug('OCR native plugin unavailable. Returning empty OCR stream.');
      return const Result.ok([]);
    } catch (e, st) {
      _logger.error('OCR extraction failed', error: e, stackTrace: st);
      return Result.err(OCRFailure(message: e.toString(), cause: e));
    }
  }

  @override
  List<OCRDetection> matchLabels({
    required List<OCRDetection> detections,
    required List<String> expectedTerms,
    double threshold = 0.75,
  }) {
    final matches = <OCRDetection>[];
    for (final det in detections) {
      for (final term in expectedTerms) {
        if (det.text.toLowerCase().contains(term.toLowerCase())) {
          matches.add(det);
          break;
        }
      }
    }
    return matches;
  }
}
