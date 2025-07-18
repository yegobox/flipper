// services.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'locator.config.dart';

final GetIt getIt = GetIt.instance;

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
}

// Add the reset method
Future<void> resetDependencies({bool dispose = true}) async {
  await getIt.reset(dispose: dispose);
}

// New method to push a new scope
void pushNewScope() {
  getIt.pushNewScope();
}

// New method to pop the current scope
void popScope() {
  getIt.popScope();
}
