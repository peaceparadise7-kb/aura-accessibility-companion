import 'package:aura_mobile/core/enums/ar_tracking_state.dart';
import 'package:aura_mobile/core/utils/result.dart';
import 'package:aura_mobile/platform/contracts/normalized_ar_event.dart';

/// Abstract service governing Augmented Reality sessions.
/// Bridges native AR engines (ARCore on Android, ARKit on iOS) with normalized events.
abstract class ARSessionService {
  /// Stream of normalized AR events across Android and iOS platforms.
  Stream<NormalizedAREvent> get eventStream;

  /// Current AR tracking state.
  ARTrackingState get currentTrackingState;

  /// Initializes AR session with required tracking capabilities (e.g. vertical planes for appliance surfaces).
  Future<Result<void>> initializeSession({bool detectVerticalPlanes = true});

  /// Pauses AR session.
  Future<Result<void>> pauseSession();

  /// Resumes AR session.
  Future<Result<void>> resumeSession();

  /// Creates a spatial anchor on a detected plane at normalized screen coordinates ([x], [y]).
  Future<Result<String>> createAnchor({
    required double screenX,
    required double screenY,
  });

  /// Removes an existing anchor.
  Future<Result<void>> removeAnchor(String anchorId);

  /// Disposes AR session and frees native buffers.
  Future<Result<void>> dispose();
}
