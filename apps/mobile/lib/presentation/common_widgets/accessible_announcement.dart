import 'package:flutter/semantics.dart';

/// Helper to trigger platform accessibility screen reader announcements.
class AccessibleAnnouncement {
  static void announce(String message, {TextDirection textDirection = TextDirection.ltr}) {
    SemanticsService.announce(message, textDirection);
  }
}
