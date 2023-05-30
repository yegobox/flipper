library flipper_services;

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'locator.config.dart';

final GetIt locator = GetIt.instance;

const platformMobile = Environment('platformMobile');
const platformWeb = Environment('platformWeb');

@InjectableInit(
  preferRelativeImports: true,
  externalPackageModulesAfter: [
    // ExternalModule(SettingsService),
  ],
)
initDependencies({
  String? env,
  EnvironmentFilter? environmentFilter,
}) {
  return locator.init(
    environmentFilter: environmentFilter,
    environment: env,
  );
}
