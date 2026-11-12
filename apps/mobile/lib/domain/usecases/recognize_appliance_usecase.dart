import 'package:aura_mobile/core/utils/result.dart';
import 'package:aura_mobile/domain/entities/appliance_profile.dart';
import 'package:aura_mobile/domain/entities/ar_frame_data.dart';
import 'package:aura_mobile/domain/repositories/appliance_profile_repository.dart';
import 'package:aura_mobile/domain/services/appliance_recognition_service.dart';

class RecognizedApplianceOutput {
  final ApplianceProfile profile;
  final double confidence;

  const RecognizedApplianceOutput({
    required this.profile,
    required this.confidence,
  });
}

class RecognizeApplianceUseCase {
  final ApplianceRecognitionService recognitionService;
  final ApplianceProfileRepository profileRepository;

  const RecognizeApplianceUseCase({
    required this.recognitionService,
    required this.profileRepository,
  });

  Future<Result<RecognizedApplianceOutput>> execute(CameraFrameData frame) async {
    final recognitionResult = await recognitionService.recognizeAppliance(frame);

    return recognitionResult.fold(
      (result) async {
        final top = result.topCandidate;
        if (top == null) {
          return const Result.err(
            ProfileNotFoundFailure(message: 'No appliance recognized in frame'),
          );
        }

        final profileRes = await profileRepository.getProfileById(top.profileId);
        return profileRes.fold(
          (profile) => Result.ok(
            RecognizedApplianceOutput(profile: profile, confidence: top.confidence),
          ),
          (failure) => Result.err(failure),
        );
      },
      (failure) => Result.err(failure),
    );
  }
}
