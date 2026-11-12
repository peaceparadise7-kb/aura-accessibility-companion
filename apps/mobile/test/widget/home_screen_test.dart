import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aura_mobile/core/constants/app_constants.dart';
import 'package:aura_mobile/core/di/service_locator.dart';
import 'package:aura_mobile/core/environment/app_environment.dart';
import 'package:aura_mobile/presentation/common_widgets/accessible_button.dart';
import 'package:aura_mobile/presentation/features/home/home_screen.dart';

void main() {
  setUp(() async {
    await sl.reset();
    await setupServiceLocator(environment: AppEnvironment.dev);
  });

  tearDown(() async {
    await sl.reset();
  });

  group('HomeScreen & Accessibility Widget Tests', () {
    testWidgets('renders title, tagline, and accessibility notices', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      expect(find.text(AppConstants.appName), findsNWidgets(2)); // AppBar and headline
      expect(find.text(AppConstants.appTagline), findsOneWidget);
      expect(find.text('Assisted Living & Safety Notice'), findsOneWidget);
      expect(find.text('Start Appliance Scanner'), findsOneWidget);
      expect(find.text('Offline Verified Profiles'), findsOneWidget);
    });

    testWidgets('AccessibleButton enforces minimum touch target size >= 48dp',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibleButton(
              label: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      final buttonFinder = find.byType(AccessibleButton);
      final size = tester.getSize(buttonFinder);

      expect(size.height, greaterThanOrEqualTo(AppConstants.minTouchTargetSize));
    });
  });
}
