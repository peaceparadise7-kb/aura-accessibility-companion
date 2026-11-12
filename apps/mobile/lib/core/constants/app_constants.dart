/// Global application constants and accessibility design invariants.
abstract class AppConstants {
  static const String appName = 'AURA';
  static const String appTagline = 'Accessible Utility Recognition Assistant';
  static const String appVersion = '0.1.0';

  // Accessibility standards
  static const double minTouchTargetSize = 48.0;
  static const double largeTouchTargetSize = 56.0;
  static const double standardPadding = 16.0;
  static const double largePadding = 24.0;
  static const double minContrastRatio = 4.5;
  static const double highContrastRatio = 7.0;

  // AR & Camera processing thresholds
  static const int cameraStreamFps = 15;
  static const double minRecognitionConfidence = 0.65;
  static const double minOcrConfidence = 0.70;
  static const int ttsQueueDebounceMs = 300;
  static const int hapticTickDurationMs = 25;

  // Platform channel names
  static const String arMethodChannelName = 'com.aura.app/ar_session_control';
  static const String arEventChannelName = 'com.aura.app/ar_session_events';
  static const String cameraStreamChannelName = 'com.aura.app/camera_stream';
}
