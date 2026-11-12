import 'package:flutter/services.dart';
import 'package:aura_mobile/core/errors/failures.dart';
import 'package:aura_mobile/core/logging/app_logger.dart';
import 'package:aura_mobile/core/utils/result.dart';
import 'package:aura_mobile/domain/services/text_to_speech_service.dart';
import 'package:aura_mobile/platform/contracts/platform_channel_constants.dart';

/// Platform adapter implementing [TextToSpeechService].
class PlatformTTSAdapter implements TextToSpeechService {
  final MethodChannel _channel;
  final AppLogger _logger;
  bool _speaking = false;

  PlatformTTSAdapter({
    MethodChannel? channel,
    required AppLogger logger,
  })  : _channel = channel ?? const MethodChannel(PlatformChannelConstants.ttsMethodChannel),
        _logger = logger;

  @override
  Future<bool> get isSpeaking async {
    try {
      final res = await _channel.invokeMethod<bool>('isSpeaking');
      return res ?? _speaking;
    } on MissingPluginException {
      return _speaking;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Result<void>> speak(
    String text, {
    TTSQueueMode queueMode = TTSQueueMode.flush,
    double pitch = 1.0,
    double rate = 0.5,
  }) async {
    try {
      _logger.info('TTS Announce: "$text" (mode: ${queueMode.name})');
      _speaking = true;

      await _channel.invokeMethod<void>('speak', {
        'text': text,
        'queueMode': queueMode.name,
        'pitch': pitch,
        'rate': rate,
      });

      _speaking = false;
      return const Result.ok(null);
    } on MissingPluginException {
      // In tests/desktop development, log the announcement cleanly
      _logger.info('[Accessibility TTS Mock]: $text');
      _speaking = false;
      return const Result.ok(null);
    } catch (e) {
      _speaking = false;
      return Result.err(AccessibilityServiceFailure(message: e.toString(), cause: e));
    }
  }

  @override
  Future<Result<void>> stop() async {
    try {
      await _channel.invokeMethod<void>('stop');
      _speaking = false;
      return const Result.ok(null);
    } on MissingPluginException {
      _speaking = false;
      return const Result.ok(null);
    } catch (e) {
      return Result.err(AccessibilityServiceFailure(message: e.toString(), cause: e));
    }
  }

  @override
  Future<Result<void>> setLanguage(String languageCode) async {
    try {
      await _channel.invokeMethod<void>('setLanguage', {'language': languageCode});
      return const Result.ok(null);
    } on MissingPluginException {
      return const Result.ok(null);
    } catch (e) {
      return Result.err(AccessibilityServiceFailure(message: e.toString(), cause: e));
    }
  }
}
