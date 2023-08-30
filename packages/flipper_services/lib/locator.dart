library flipper_services;

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
