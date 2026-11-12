import 'package:aura_mobile/core/utils/result.dart';

enum TTSQueueMode {
  flush, // Immediately interrupts ongoing speech
  enqueue, // Queues after current speech finishes
}

/// Abstract service governing accessible text-to-speech feedback.
abstract class TextToSpeechService {
  /// Speaks [text] with the given [queueMode], [pitch], and speech [rate].
  Future<Result<void>> speak(
    String text, {
    TTSQueueMode queueMode = TTSQueueMode.flush,
    double pitch = 1.0,
    double rate = 0.5,
  });

  /// Immediately stops any ongoing speech output.
  Future<Result<void>> stop();

  /// Returns whether speech output is currently active.
  Future<bool> get isSpeaking;

  /// Sets speech synthesis language (e.g. 'en-US', 'es-ES').
  Future<Result<void>> setLanguage(String languageCode);
}
