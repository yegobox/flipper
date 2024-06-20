// services.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'locator.config.dart';

final GetIt getIt = GetIt.instance;
bool _dependenciesInitialized = false;

@InjectableInit(
  preferRelativeImports: true,
  externalPackageModulesAfter: [
    // ExternalModule(AwesomePackageModule),
  ],
)
Future<void> initDependencies({
  String? env,
  EnvironmentFilter? environmentFilter,
}) async {
  await getIt.init(
    environmentFilter: environmentFilter,
    environment: env,
  );
  _dependenciesInitialized = true; // Set flag after initialization
}

// Add the reset method
Future<void> resetDependencies({bool dispose = true}) async {
  await getIt.reset(dispose: dispose);
  _dependenciesInitialized = false; // Reset flag after reset
}

// Getter to access _dependenciesInitialized
bool get areDependenciesInitialized => _dependenciesInitialized;
