import 'package:aura_mobile/core/utils/result.dart';
import 'package:aura_mobile/domain/entities/appliance_profile.dart';
import 'package:aura_mobile/domain/repositories/appliance_profile_repository.dart';

class GetApplianceProfileUseCase {
  final ApplianceProfileRepository repository;

  const GetApplianceProfileUseCase(this.repository);

  Future<Result<ApplianceProfile>> execute(String profileId) {
    return repository.getProfileById(profileId);
  }
}
