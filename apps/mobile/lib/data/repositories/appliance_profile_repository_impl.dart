import 'package:aura_mobile/core/enums/appliance_type.dart';
import 'package:aura_mobile/core/errors/exceptions.dart';
import 'package:aura_mobile/core/errors/failures.dart';
import 'package:aura_mobile/core/logging/app_logger.dart';
import 'package:aura_mobile/core/utils/result.dart';
import 'package:aura_mobile/data/datasources/local/appliance_profile_local_datasource.dart';
import 'package:aura_mobile/domain/entities/appliance_profile.dart';
import 'package:aura_mobile/domain/repositories/appliance_profile_repository.dart';

class ApplianceProfileRepositoryImpl implements ApplianceProfileRepository {
  final ApplianceProfileLocalDataSource localDataSource;
  final AppLogger logger;

  ApplianceProfileRepositoryImpl({
    required this.localDataSource,
    required this.logger,
  });

  @override
  Future<Result<ApplianceProfile>> getProfileById(String id) async {
    try {
      final profile = await localDataSource.getProfileById(id);
      return Result.ok(profile);
    } on StorageException catch (e) {
      return Result.err(ProfileNotFoundFailure(message: e.message, cause: e));
    } catch (e, st) {
      logger.error('Failed to get profile by ID: $id', error: e, stackTrace: st);
      return Result.err(StorageFailure(message: e.toString(), cause: e));
    }
  }

  @override
  Future<Result<List<ApplianceProfile>>> searchProfiles({
    String? query,
    ApplianceType? category,
  }) async {
    try {
      final all = await localDataSource.getAllProfiles();
      final filtered = all.where((p) {
        if (category != null && p.category != category) return false;
        if (query != null && query.isNotEmpty) {
          final q = query.toLowerCase();
          final matchesName = p.name.toLowerCase().contains(q);
          final matchesBrand = p.manufacturer.toLowerCase().contains(q);
          final matchesModel = p.modelNumber.toLowerCase().contains(q);
          return matchesName || matchesBrand || matchesModel;
        }
        return true;
      }).toList();

      return Result.ok(filtered);
    } catch (e) {
      return Result.err(StorageFailure(message: e.toString(), cause: e));
    }
  }

  @override
  Future<Result<List<ApplianceProfile>>> getCachedProfiles() async {
    try {
      final profiles = await localDataSource.getAllProfiles();
      return Result.ok(profiles);
    } catch (e) {
      return Result.err(StorageFailure(message: e.toString(), cause: e));
    }
  }

  @override
  Future<Result<void>> cacheProfile(ApplianceProfile profile) async {
    try {
      await localDataSource.saveProfile(profile);
      return const Result.ok(null);
    } catch (e) {
      return Result.err(StorageFailure(message: e.toString(), cause: e));
    }
  }
}
