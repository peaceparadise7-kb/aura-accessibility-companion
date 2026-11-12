import 'package:flutter/material.dart';
import 'package:aura_mobile/core/constants/app_constants.dart';
import 'package:aura_mobile/core/di/service_locator.dart';
import 'package:aura_mobile/domain/entities/appliance_profile.dart';
import 'package:aura_mobile/domain/entities/control_element.dart';
import 'package:aura_mobile/domain/repositories/appliance_profile_repository.dart';
import 'package:aura_mobile/domain/services/ar_session_service.dart';
import 'package:aura_mobile/domain/services/camera_service.dart';
import 'package:aura_mobile/domain/usecases/announce_control_usecase.dart';
import 'package:aura_mobile/presentation/common_widgets/accessible_button.dart';

class ARScannerScreen extends StatefulWidget {
  const ARScannerScreen({super.key});

  @override
  State<ARScannerScreen> createState() => _ARScannerScreenState();
}

class _ARScannerScreenState extends State<ARScannerScreen> {
  final CameraService _cameraService = sl<CameraService>();
  final ARSessionService _arService = sl<ARSessionService>();
  final AnnounceControlUseCase _announceControl = sl<AnnounceControlUseCase>();
  final ApplianceProfileRepository _profileRepo = sl<ApplianceProfileRepository>();

  ApplianceProfile? _activeProfile;
  bool _isInitializing = true;
  String _statusMessage = 'Initializing AR session and camera...';

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await _cameraService.initialize();
    await _arService.initializeSession(detectVerticalPlanes: true);

    // Load default verified profile for demonstration
    final profileRes = await _profileRepo.getProfileById('panasonic_nn_sd372s_microwave');
    if (mounted) {
      setState(() {
        _isInitializing = false;
        _activeProfile = profileRes.valueOrNull;
        _statusMessage = _activeProfile != null
            ? 'Recognized ${_activeProfile!.name}. Point camera at control panel.'
            : 'Point camera at an appliance to begin recognition.';
      });
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _arService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Appliance Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, size: 28.0),
            tooltip: 'Appliance details',
            onPressed: () {
              if (_activeProfile != null) {
                _announceControl.execute(
                  ControlElement(
                    id: 'info',
                    name: _activeProfile!.name,
                    type: _activeProfile!.controls.first.type,
                    normalizedBoundingBox: const NormalizedBoundingBox(
                      left: 0,
                      top: 0,
                      right: 1,
                      bottom: 1,
                    ),
                    functionDescription: 'Appliance: ${_activeProfile!.name}',
                    audioCueText:
                        'Active profile: ${_activeProfile!.name}. Category: ${_activeProfile!.category.displayName}. Total controls verified: ${_activeProfile!.controls.length}.',
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // AR Status Bar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.standardPadding,
                vertical: 12.0,
              ),
              color: theme.colorScheme.surface,
              child: Semantics(
                liveRegion: true,
                child: Text(
                  _statusMessage,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Camera / AR Viewport Placeholder
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(AppConstants.standardPadding),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 2.0,
                  ),
                ),
                child: Center(
                  child: _isInitializing
                      ? const CircularProgressIndicator()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.view_in_ar,
                              size: 64.0,
                              color: Colors.white70,
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              'AR Camera Active',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Tracking: ${_arService.currentTrackingState.description}',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                ),
              ),
            ),

            // Accessible Controls List (Fallback and Screen-Reader direct navigation)
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.standardPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detected & Verified Controls',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8.0),
                    Expanded(
                      child: _activeProfile == null
                          ? const Center(child: Text('No verified controls in view'))
                          : ListView.separated(
                              itemCount: _activeProfile!.controls.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 8.0),
                              itemBuilder: (context, index) {
                                final ctrl = _activeProfile!.controls[index];
                                return Card(
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 4.0,
                                    ),
                                    title: Text(
                                      ctrl.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(ctrl.functionDescription),
                                    trailing: const Icon(Icons.volume_up, size: 28.0),
                                    onTap: () {
                                      _announceControl.execute(ctrl);
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer Action
            Padding(
              padding: const EdgeInsets.all(AppConstants.standardPadding),
              child: AccessibleButton(
                label: 'Repeat Guidance',
                icon: Icons.replay,
                isPrimary: false,
                onPressed: () {
                  if (_activeProfile != null) {
                    sl<AnnounceControlUseCase>().execute(
                      _activeProfile!.controls.first,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
