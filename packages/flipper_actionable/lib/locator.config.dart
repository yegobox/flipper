// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'api.dart' as _i3;
import 'module.dart' as _i6;
import 'service.dart' as _i4;
import 'storage.dart' as _i5;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final module = _$Module();
    await gh.lazySingletonAsync<_i3.AB>(
      () => module.api(),
      preResolve: true,
    );
    gh.factory<_i4.Service>(() => module.service);
    gh.lazySingleton<_i5.Storage>(() => module.box());
    return this;
  }
}

class _$Module extends _i6.Module {
  @override
  _i4.Service get service => _i4.Service();
}
