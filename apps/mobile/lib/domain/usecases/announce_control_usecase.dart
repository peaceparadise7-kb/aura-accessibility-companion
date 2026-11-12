import 'package:aura_mobile/core/utils/result.dart';
import 'package:aura_mobile/domain/entities/control_element.dart';
import 'package:aura_mobile/domain/services/haptic_feedback_service.dart';
import 'package:aura_mobile/domain/services/text_to_speech_service.dart';

class AnnounceControlUseCase {
  final TextToSpeechService ttsService;
  final HapticFeedbackService hapticService;

  const AnnounceControlUseCase({
    required this.ttsService,
    required this.hapticService,
  });

  Future<Result<void>> execute(ControlElement control) async {
    // 1. Trigger tactile confirmation
    await hapticService.tick();

    // 2. Announce audio cue
    final buffer = StringBuffer(control.audioCueText);
    if (control.safetyWarning != null) {
      buffer.write('. Caution: ${control.safetyWarning}');
    }

    return ttsService.speak(
      buffer.toString(),
      queueMode: TTSQueueMode.flush,
    );
  }
}
