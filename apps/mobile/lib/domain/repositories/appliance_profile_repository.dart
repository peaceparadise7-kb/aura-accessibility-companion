import 'package:aura_mobile/core/enums/appliance_type.dart';
import 'package:aura_mobile/core/utils/result.dart';
import 'package:aura_mobile/domain/entities/appliance_profile.dart';

/// Repository interface governing retrieval and offline caching of verified appliance profiles.
abstract class ApplianceProfileRepository {
  /// Retrieves a verified profile by its unique ID.
  Future<Result<ApplianceProfile>> getProfileById(String id);

  /// Searches profiles by query text and optional category filter.
  Future<Result<List<ApplianceProfile>>> searchProfiles({
    String? query,
    ApplianceType? category,
  });

  /// Lists all locally bundled and cached profiles for offline operation.
  Future<Result<List<ApplianceProfile>>> getCachedProfiles();

  /// Persists a verified profile into local offline storage.
  Future<Result<void>> cacheProfile(ApplianceProfile profile);
}
