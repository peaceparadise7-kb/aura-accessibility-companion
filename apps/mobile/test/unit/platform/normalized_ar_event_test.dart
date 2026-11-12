import 'package:flutter_test/flutter_test.dart';
import 'package:aura_mobile/core/enums/ar_tracking_state.dart';
import 'package:aura_mobile/platform/contracts/normalized_ar_event.dart';

void main() {
  group('Normalized AR Events', () {
    test('ARTrackingStateChangedEvent encapsulates tracking state and reason', () {
      const event = ARTrackingStateChangedEvent(
        timestampMs: 1700000000000,
        sessionId: 'session_123',
        state: ARTrackingState.limited,
        reason: ARTrackingReason.excessiveMotion,
      );

      expect(event.timestampMs, equals(1700000000000));
      expect(event.sessionId, equals('session_123'));
      expect(event.state, equals(ARTrackingState.limited));
      expect(event.reason, equals(ARTrackingReason.excessiveMotion));
      expect(event.state.isReady, isFalse);
    });

    test('ARPlaneDetectedEvent encapsulates plane boundaries and orientation', () {
      const event = ARPlaneDetectedEvent(
        timestampMs: 1700000001000,
        sessionId: 'session_123',
        planeId: 'plane_microwave_panel',
        alignment: 'vertical',
        extentX: 0.45,
        extentZ: 0.30,
      );

      expect(event.planeId, equals('plane_microwave_panel'));
      expect(event.alignment, equals('vertical'));
      expect(event.extentX, equals(0.45));
    });

    test('ARAnchorUpdatedEvent stores 4x4 transform matrix', () {
      final matrix = List<double>.generate(16, (i) => i.toDouble());
      final event = ARAnchorUpdatedEvent(
        timestampMs: 1700000002000,
        sessionId: 'session_123',
        anchorId: 'anchor_power_button',
        matrix4x4: matrix,
      );

      expect(event.anchorId, equals('anchor_power_button'));
      expect(event.matrix4x4.length, equals(16));
    });
  });
}
