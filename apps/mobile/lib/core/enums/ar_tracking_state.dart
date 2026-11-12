/// Normalized tracking states across ARCore and ARKit.
enum ARTrackingState {
  notTracking('Not Tracking'),
  initializing('Initializing AR Session'),
  tracking('Active Tracking'),
  paused('Session Paused'),
  limited('Tracking Quality Limited');

  final String description;
  const ARTrackingState(this.description);

  bool get isReady => this == ARTrackingState.tracking;
}

/// Reason explaining why AR tracking may be limited or degraded.
enum ARTrackingReason {
  none,
  excessiveMotion,
  insufficientFeatures,
  relocalizing,
  unsupported;

  static ARTrackingReason fromString(String? val) {
    return switch (val?.toLowerCase()) {
      'excessive_motion' => ARTrackingReason.excessiveMotion,
      'insufficient_features' => ARTrackingReason.insufficientFeatures,
      'relocalizing' => ARTrackingReason.relocalizing,
      'unsupported' => ARTrackingReason.unsupported,
      _ => ARTrackingReason.none,
    };
  }
}
