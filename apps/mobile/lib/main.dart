import 'package:flutter/material.dart';
import 'package:aura_mobile/core/di/service_locator.dart';
import 'package:aura_mobile/core/environment/app_environment.dart';
import 'package:aura_mobile/presentation/app/aura_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection with dev environment configuration
  await setupServiceLocator(environment: AppEnvironment.dev);

  runApp(const AuraApp());
}
