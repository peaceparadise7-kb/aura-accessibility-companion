import 'package:flutter/material.dart';
import 'package:aura_mobile/core/constants/app_constants.dart';
import 'package:aura_mobile/core/di/service_locator.dart';
import 'package:aura_mobile/domain/services/text_to_speech_service.dart';
import 'package:aura_mobile/presentation/common_widgets/accessible_button.dart';
import 'package:aura_mobile/presentation/features/ar_scanner/ar_scanner_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AURA'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up, size: 28.0),
            tooltip: 'Announce page instructions',
            onPressed: () {
              sl<TextToSpeechService>().speak(
                'AURA Home Screen. Press Start Appliance Scanner to identify buttons and controls on household appliances.',
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                child: Text(
                  AppConstants.appName,
                  style: theme.textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                AppConstants.appTagline,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.standardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assisted Living & Safety Notice',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'AURA provides audio, haptic, and visual guidance to help identify physical buttons, dials, and switches. It is informational only and does not physically operate appliances.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              AccessibleButton(
                label: 'Start Appliance Scanner',
                semanticHint: 'Opens camera and AR recognition mode to scan appliance controls',
                icon: Icons.camera_alt,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ARScannerScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16.0),
              AccessibleButton(
                label: 'Offline Verified Profiles',
                semanticHint: 'View list of pre-verified household appliance profiles',
                icon: Icons.inventory_2,
                isPrimary: false,
                onPressed: () {
                  sl<TextToSpeechService>().speak(
                    'Offline Profiles catalog: Microwave, Washing Machine, Dishwasher, Refrigerator.',
                  );
                },
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
