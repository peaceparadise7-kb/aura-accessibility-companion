import 'package:flutter/material.dart';
import 'package:aura_mobile/core/constants/app_constants.dart';
import 'package:aura_mobile/core/theme/app_theme.dart';
import 'package:aura_mobile/presentation/features/home/home_screen.dart';

class AuraApp extends StatelessWidget {
  const AuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.highContrastDarkTheme,
      home: const HomeScreen(),
    );
  }
}
