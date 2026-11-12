import 'package:flutter/services.dart';
import 'package:aura_mobile/core/errors/failures.dart';
import 'package:aura_mobile/core/logging/app_logger.dart';
import 'package:aura_mobile/core/utils/result.dart';
import 'package:aura_mobile/domain/services/haptic_feedback_service.dart';

/// Platform adapter implementing [HapticFeedbackService] using Flutter's native HapticFeedback engine.
class PlatformHapticAdapter implements HapticFeedbackService {
  final AppLogger _logger;

  PlatformHapticAdapter({required AppLogger logger}) : _logger = logger;

  @override
  Future<Result<void>> vibrate(HapticFeedbackType type) async {
    try {
      switch (type) {
        case HapticFeedbackType.lightTick:
          await HapticFeedback.selectionClick();
          break;
        case HapticFeedbackType.mediumImpact:
          await HapticFeedback.mediumImpact();
          break;
        case HapticFeedbackType.heavyImpact:
          await HapticFeedback.heavyImpact();
          break;
        case HapticFeedbackType.successConfirmation:
          await HapticFeedback.mediumImpact();
          await Future<void>.delayed(const Duration(milliseconds: 60));
          await HapticFeedback.lightImpact();
          break;
        case HapticFeedbackType.warningAlert:
          await HapticFeedback.heavyImpact();
          await Future<void>.delayed(const Duration(milliseconds: 100));
          await HapticFeedback.heavyImpact();
          break;
        case HapticFeedbackType.errorAlert:
          await HapticFeedback.heavyImpact();
          await Future<void>.delayed(const Duration(milliseconds: 80));
          await HapticFeedback.vibrate();
          break;
      }
      return const Result.ok(null);
    } catch (e) {
      _logger.warning('Haptic feedback failed: $e');
      return Result.err(AccessibilityServiceFailure(message: e.toString(), cause: e));
    }
  }

  @override
  Future<Result<void>> tick() => vibrate(HapticFeedbackType.lightTick);

  @override
  Future<Result<void>> confirm() => vibrate(HapticFeedbackType.successConfirmation);

  @override
  Future<Result<void>> warning() => vibrate(HapticFeedbackType.warningAlert);
}
