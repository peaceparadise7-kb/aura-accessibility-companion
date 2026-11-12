import 'package:aura_mobile/core/utils/result.dart';

enum HapticFeedbackType {
  lightTick,
  mediumImpact,
  heavyImpact,
  successConfirmation,
  warningAlert,
  errorAlert,
}

/// Abstract service governing tactile accessibility feedback.
abstract class HapticFeedbackService {
  /// Triggers a specific haptic vibration pattern.
  Future<Result<void>> vibrate(HapticFeedbackType type);

  /// Quick feedback when user crosses or hovers over a button boundary.
  Future<Result<void>> tick();

  /// Feedback when a control or appliance is successfully locked on.
  Future<Result<void>> confirm();

  /// Distinctive warning feedback when a safety caution is encountered.
  Future<Result<void>> warning();
}
