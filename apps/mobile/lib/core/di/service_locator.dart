import 'package:get_it/get_it.dart';
import 'package:aura_mobile/core/environment/app_environment.dart';
import 'package:aura_mobile/core/logging/app_logger.dart';
import 'package:aura_mobile/data/datasources/local/appliance_profile_local_datasource.dart';
import 'package:aura_mobile/data/repositories/appliance_profile_repository_impl.dart';
import 'package:aura_mobile/domain/repositories/appliance_profile_repository.dart';
import 'package:aura_mobile/domain/services/appliance_recognition_service.dart';
import 'package:aura_mobile/domain/services/ar_session_service.dart';
import 'package:aura_mobile/domain/services/camera_service.dart';
import 'package:aura_mobile/domain/services/control_mapping_service.dart';
import 'package:aura_mobile/domain/services/control_recognition_service.dart';
import 'package:aura_mobile/domain/services/haptic_feedback_service.dart';
import 'package:aura_mobile/domain/services/ocr_service.dart';
import 'package:aura_mobile/domain/services/text_to_speech_service.dart';
import 'package:aura_mobile/domain/usecases/announce_control_usecase.dart';
import 'package:aura_mobile/domain/usecases/get_appliance_profile_usecase.dart';
import 'package:aura_mobile/domain/usecases/recognize_appliance_usecase.dart';
import 'package:aura_mobile/domain/usecases/scan_controls_usecase.dart';
import 'package:aura_mobile/platform/adapters/platform_ar_adapter.dart';
import 'package:aura_mobile/platform/adapters/platform_camera_adapter.dart';
import 'package:aura_mobile/platform/adapters/platform_haptic_adapter.dart';
import 'package:aura_mobile/platform/adapters/platform_ml_recognition_adapter.dart';
import 'package:aura_mobile/platform/adapters/platform_ocr_adapter.dart';
import 'package:aura_mobile/platform/adapters/platform_tts_adapter.dart';
import 'package:aura_mobile/platform/adapters/rule_based_control_mapping_service.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator({AppEnvironment? environment}) async {
  final env = environment ?? AppEnvironment.dev;

  // 1. Core & Environment
  sl.registerSingleton<AppEnvironment>(env);
  sl.registerLazySingleton<AppLogger>(
    () => ConsoleAppLogger(
      minLevel: env.enableDebugLogging ? LogLevel.debug : LogLevel.info,
    ),
  );

  // 2. Platform Adapters & Services
  sl.registerLazySingleton<CameraService>(
    () => PlatformCameraAdapter(logger: sl<AppLogger>()),
  );
  sl.registerLazySingleton<ARSessionService>(
    () => PlatformARAdapter(logger: sl<AppLogger>()),
  );
  sl.registerLazySingleton<TextToSpeechService>(
    () => PlatformTTSAdapter(logger: sl<AppLogger>()),
  );
  sl.registerLazySingleton<HapticFeedbackService>(
    () => PlatformHapticAdapter(logger: sl<AppLogger>()),
  );

  // 3. Machine Vision & OCR Adapters
  final mlAdapter = PlatformMLRecognitionAdapter(logger: sl<AppLogger>());
  sl.registerSingleton<ApplianceRecognitionService>(mlAdapter);
  sl.registerSingleton<ControlRecognitionService>(mlAdapter);
  sl.registerLazySingleton<OCRService>(
    () => PlatformOCRAdapter(logger: sl<AppLogger>()),
  );
  sl.registerLazySingleton<ControlMappingService>(
    () => RuleBasedControlMappingService(logger: sl<AppLogger>()),
  );

  // 4. Data Layer & Repository
  sl.registerLazySingleton<ApplianceProfileLocalDataSource>(
    () => ApplianceProfileLocalDataSourceImpl(logger: sl<AppLogger>()),
  );
  sl.registerLazySingleton<ApplianceProfileRepository>(
    () => ApplianceProfileRepositoryImpl(
      localDataSource: sl<ApplianceProfileLocalDataSource>(),
      logger: sl<AppLogger>(),
    ),
  );

  // 5. Use Cases
  sl.registerFactory<GetApplianceProfileUseCase>(
    () => GetApplianceProfileUseCase(sl<ApplianceProfileRepository>()),
  );
  sl.registerFactory<RecognizeApplianceUseCase>(
    () => RecognizeApplianceUseCase(
      recognitionService: sl<ApplianceRecognitionService>(),
      profileRepository: sl<ApplianceProfileRepository>(),
    ),
  );
  sl.registerFactory<ScanControlsUseCase>(
    () => ScanControlsUseCase(
      controlRecognitionService: sl<ControlRecognitionService>(),
      ocrService: sl<OCRService>(),
      controlMappingService: sl<ControlMappingService>(),
    ),
  );
  sl.registerFactory<AnnounceControlUseCase>(
    () => AnnounceControlUseCase(
      ttsService: sl<TextToSpeechService>(),
      hapticService: sl<HapticFeedbackService>(),
    ),
  );
}
