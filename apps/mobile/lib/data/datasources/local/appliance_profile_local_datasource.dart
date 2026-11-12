import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:aura_mobile/core/errors/exceptions.dart';
import 'package:aura_mobile/core/logging/app_logger.dart';
import 'package:aura_mobile/data/models/appliance_profile_model.dart';
import 'package:aura_mobile/domain/entities/appliance_profile.dart';

abstract class ApplianceProfileLocalDataSource {
  Future<ApplianceProfile> getProfileById(String id);
  Future<List<ApplianceProfile>> getAllProfiles();
  Future<void> saveProfile(ApplianceProfile profile);
}

class ApplianceProfileLocalDataSourceImpl implements ApplianceProfileLocalDataSource {
  final AssetBundle _assetBundle;
  final AppLogger _logger;
  final Map<String, ApplianceProfile> _memoryCache = {};

  ApplianceProfileLocalDataSourceImpl({
    AssetBundle? assetBundle,
    required AppLogger logger,
  })  : _assetBundle = assetBundle ?? rootBundle,
        _logger = logger;

  @override
  Future<ApplianceProfile> getProfileById(String id) async {
    if (_memoryCache.containsKey(id)) {
      return _memoryCache[id]!;
    }

    try {
      // Attempt to load from bundled assets
      final jsonString =
          await _assetBundle.loadString('assets/profiles/microwave_sample.json');
      final Map<String, dynamic> jsonMap =
          jsonDecode(jsonString) as Map<String, dynamic>;
      final profile = ApplianceProfileModel.fromJson(jsonMap);

      _memoryCache[profile.id] = profile;

      if (profile.id == id) {
        return profile;
      }
    } catch (e) {
      _logger.warning('Failed to load bundled profile for $id: $e');
    }

    throw StorageException('Profile $id not found in local offline storage');
  }

  @override
  Future<List<ApplianceProfile>> getAllProfiles() async {
    if (_memoryCache.isEmpty) {
      try {
        final jsonString =
            await _assetBundle.loadString('assets/profiles/microwave_sample.json');
        final Map<String, dynamic> jsonMap =
            jsonDecode(jsonString) as Map<String, dynamic>;
        final profile = ApplianceProfileModel.fromJson(jsonMap);
        _memoryCache[profile.id] = profile;
      } catch (e) {
        _logger.warning('Could not load bundled asset profiles: $e');
      }
    }
    return _memoryCache.values.toList();
  }

  @override
  Future<void> saveProfile(ApplianceProfile profile) async {
    _memoryCache[profile.id] = profile;
  }
}
