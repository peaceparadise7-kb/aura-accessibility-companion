import 'package:flutter_test/flutter_test.dart';
import 'package:aura_mobile/core/enums/appliance_type.dart';
import 'package:aura_mobile/core/enums/control_type.dart';
import 'package:aura_mobile/core/errors/failures.dart';
import 'package:aura_mobile/core/utils/result.dart';
import 'package:aura_mobile/domain/entities/appliance_profile.dart';
import 'package:aura_mobile/domain/entities/control_element.dart';
import 'package:aura_mobile/domain/repositories/appliance_profile_repository.dart';
import 'package:aura_mobile/domain/services/haptic_feedback_service.dart';
import 'package:aura_mobile/domain/services/text_to_speech_service.dart';
import 'package:aura_mobile/domain/usecases/announce_control_usecase.dart';
import 'package:aura_mobile/domain/usecases/get_appliance_profile_usecase.dart';

class FakeApplianceProfileRepository implements ApplianceProfileRepository {
  final Map<String, ApplianceProfile> profiles = {};

  @override
  Future<Result<ApplianceProfile>> getProfileById(String id) async {
    final profile = profiles[id];
    if (profile != null) return Result.ok(profile);
    return Result.err(ProfileNotFoundFailure(message: 'Profile $id not found'));
  }

  @override
  Future<Result<List<ApplianceProfile>>> searchProfiles(
      {String? query, ApplianceType? category}) async {
    return Result.ok(profiles.values.toList());
  }

  @override
  Future<Result<List<ApplianceProfile>>> getCachedProfiles() async {
    return Result.ok(profiles.values.toList());
  }

  @override
  Future<Result<void>> cacheProfile(ApplianceProfile profile) async {
    profiles[profile.id] = profile;
    return const Result.ok(null);
  }
}

class FakeTTS implements TextToSpeechService {
  String? lastSpokenText;

  @override
  Future<bool> get isSpeaking async => false;

  @override
  Future<Result<void>> setLanguage(String languageCode) async => const Result.ok(null);

  @override
  Future<Result<void>> speak(String text,
      {TTSQueueMode queueMode = TTSQueueMode.flush, double pitch = 1.0, double rate = 0.5}) async {
    lastSpokenText = text;
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> stop() async => const Result.ok(null);
}

class FakeHaptic implements HapticFeedbackService {
  int tickCount = 0;

  @override
  Future<Result<void>> confirm() async => const Result.ok(null);

  @override
  Future<Result<void>> tick() async {
    tickCount++;
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> vibrate(HapticFeedbackType type) async => const Result.ok(null);

  @override
  Future<Result<void>> warning() async => const Result.ok(null);
}

void main() {
  group('Domain Use Cases', () {
    late FakeApplianceProfileRepository repository;
    late GetApplianceProfileUseCase getProfileUseCase;
    late FakeTTS tts;
    late FakeHaptic haptic;
    late AnnounceControlUseCase announceUseCase;

    const testProfile = ApplianceProfile(
      id: 'test_microwave',
      name: 'Test Microwave',
      manufacturer: 'BrandX',
      modelNumber: 'MX-100',
      category: ApplianceType.microwave,
      schemaVersion: '1.0.0',
      verificationStatus: VerificationStatus.verified,
      controls: [
        ControlElement(
          id: 'btn_start',
          name: 'Start',
          type: ControlType.button,
          normalizedBoundingBox: NormalizedBoundingBox(
            left: 0.1,
            top: 0.1,
            right: 0.4,
            bottom: 0.4,
          ),
          functionDescription: 'Starts heating',
          audioCueText: 'Start button',
          safetyWarning: 'Heats immediately',
        ),
      ],
    );

    setUp(() {
      repository = FakeApplianceProfileRepository();
      repository.profiles[testProfile.id] = testProfile;
      getProfileUseCase = GetApplianceProfileUseCase(repository);

      tts = FakeTTS();
      haptic = FakeHaptic();
      announceUseCase = AnnounceControlUseCase(
        ttsService: tts,
        hapticService: haptic,
      );
    });

    test('GetApplianceProfileUseCase returns profile for valid ID', () async {
      final result = await getProfileUseCase.execute('test_microwave');

      expect(result.isOk, isTrue);
      expect(result.valueOrNull?.name, equals('Test Microwave'));
      expect(result.valueOrNull?.controls.length, equals(1));
    });

    test('GetApplianceProfileUseCase returns ProfileNotFoundFailure for missing ID', () async {
      final result = await getProfileUseCase.execute('non_existent');

      expect(result.isErr, isTrue);
      expect(result.failureOrNull, isA<ProfileNotFoundFailure>());
    });

    test('AnnounceControlUseCase invokes haptic tick and speaks audio cue with caution', () async {
      final control = testProfile.controls.first;
      final result = await announceUseCase.execute(control);

      expect(result.isOk, isTrue);
      expect(haptic.tickCount, equals(1));
      expect(tts.lastSpokenText, contains('Start button. Caution: Heats immediately'));
    });
  });
}
