enum EnvironmentType {
  dev,
  staging,
  prod,
}

class AppEnvironment {
  final EnvironmentType type;
  final String apiBaseUrl;
  final bool enableDebugLogging;
  final bool enableMockNativeSensors;

  const AppEnvironment({
    required this.type,
    required this.apiBaseUrl,
    required this.enableDebugLogging,
    this.enableMockNativeSensors = false,
  });

  static AppEnvironment get dev => const AppEnvironment(
        type: EnvironmentType.dev,
        apiBaseUrl: 'http://10.0.2.2:8000',
        enableDebugLogging: true,
        enableMockNativeSensors: true,
      );

  static AppEnvironment get staging => const AppEnvironment(
        type: EnvironmentType.staging,
        apiBaseUrl: 'https://staging-api.aura.accessibility',
        enableDebugLogging: true,
        enableMockNativeSensors: false,
      );

  static AppEnvironment get prod => const AppEnvironment(
        type: EnvironmentType.prod,
        apiBaseUrl: 'https://api.aura.accessibility',
        enableDebugLogging: false,
        enableMockNativeSensors: false,
      );
}
