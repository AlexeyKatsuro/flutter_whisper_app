import 'package:logger/logger.dart';
import 'package:rest_client/rest_client.dart';
import 'package:voice_input_api/src/application/bloc/voice_input_bloc.dart';
import 'package:voice_input_api/src/data/datasources/permission_datasource.dart';
import 'package:voice_input_api/src/data/repositories/voice_input_repository_impl.dart';
import 'package:voice_input_api/src/domain/repositories/voice_input_repository.dart';
import 'package:voice_input_api/src/domain/usecases/check_permissions_usecase.dart';
import 'package:voice_input_api/src/domain/usecases/open_app_settings_usecase.dart';
import 'package:voice_input_api/src/domain/usecases/request_permissions_usecase.dart';

/// Container for voice input feature dependencies.
///
/// Provides dependency injection for the voice input feature,
/// including repository implementations, BLoC instances, and use cases.
class VoiceInputContainer {
  const VoiceInputContainer({
    required this.repository,
    required this.bloc,
    required this.checkPermissionsUseCase,
    required this.requestPermissionsUseCase,
    required this.openAppSettingsUseCase,
  });

  final VoiceInputRepository repository;
  final VoiceInputBloc bloc;
  final CheckPermissionsUseCase checkPermissionsUseCase;
  final RequestPermissionsUseCase requestPermissionsUseCase;
  final OpenAppSettingsUseCase openAppSettingsUseCase;

  /// Creates a new [VoiceInputContainer] with all dependencies initialized.
  ///
  /// [logger] is used for logging throughout the feature.
  /// [restClient] is used for online transcription API calls.
  static Future<VoiceInputContainer> create({
    required Logger logger,
    required RestClient restClient,
  }) async {
    // Create data sources
    final permissionDataSource = PermissionDataSourceImpl();

    // Create repository implementation with permission functionality
    final repository = VoiceInputRepositoryImpl(
      permissionDataSource: permissionDataSource,
      logger: logger,
    );

    // Create use cases
    final checkPermissionsUseCase = CheckPermissionsUseCase(repository);
    final requestPermissionsUseCase = RequestPermissionsUseCase(repository);
    final openAppSettingsUseCase = OpenAppSettingsUseCase(repository);

    // Create BLoC with use case dependencies
    final bloc = VoiceInputBloc(
      checkPermissionsUseCase: checkPermissionsUseCase,
      requestPermissionsUseCase: requestPermissionsUseCase,
      openAppSettingsUseCase: openAppSettingsUseCase,
    );

    return VoiceInputContainer(
      repository: repository,
      bloc: bloc,
      checkPermissionsUseCase: checkPermissionsUseCase,
      requestPermissionsUseCase: requestPermissionsUseCase,
      openAppSettingsUseCase: openAppSettingsUseCase,
    );
  }

  /// Disposes of all resources held by this container.
  Future<void> dispose() async {
    await bloc.close();
    await repository.cleanup();
  }
}

