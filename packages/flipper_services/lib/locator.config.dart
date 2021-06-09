// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:stacked_services/stacked_services.dart' as _i11;

import 'abstractions/api.dart' as _i3;
import 'abstractions/dynamic_link.dart' as _i5;
import 'abstractions/location.dart' as _i6;
import 'abstractions/platform.dart' as _i10;
import 'abstractions/remote.dart' as _i13;
import 'abstractions/share.dart' as _i15;
import 'abstractions/storage.dart' as _i9;
import 'abstractions/upload.dart' as _i16;
import 'app_service.dart' as _i4;
import 'http_api.dart' as _i7;
import 'keypad_service.dart' as _i8;
import 'product_service.dart' as _i12;
import 'setting_service.dart' as _i14;
import 'third_party_services_module.dart'
    as _i17; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  gh.lazySingleton<_i3.Api<dynamic>>(() => thirdPartyServicesModule.apiService);
  gh.lazySingleton<_i4.AppService>(() => thirdPartyServicesModule.appService);
  gh.lazySingleton<_i5.DynamicLink>(() => thirdPartyServicesModule.dynamicLink);
  gh.lazySingleton<_i6.FlipperLocation>(
      () => thirdPartyServicesModule.location);
  gh.lazySingleton<_i7.HttpApi<dynamic>>(() => _i7.HttpApi<dynamic>());
  gh.lazySingleton<_i8.KeyPadService>(
      () => thirdPartyServicesModule.keypadService);
  gh.lazySingleton<_i9.LocalStorage>(() => thirdPartyServicesModule.box);
  gh.lazySingleton<_i10.LoginStandard>(
      () => thirdPartyServicesModule.flipperFire);
  gh.lazySingleton<_i11.NavigationService>(() => thirdPartyServicesModule.nav);
  gh.lazySingleton<_i12.ProductService>(
      () => thirdPartyServicesModule.productService);
  gh.lazySingleton<_i13.Remote>(() => thirdPartyServicesModule.remote);
  gh.lazySingleton<_i14.SettingsService>(
      () => thirdPartyServicesModule.settings);
  gh.lazySingleton<_i15.Shareble>(() => thirdPartyServicesModule.share);
  gh.lazySingleton<_i16.UploadT>(() => thirdPartyServicesModule.upload);
  return get;
}

class _$ThirdPartyServicesModule extends _i17.ThirdPartyServicesModule {
  @override
  _i4.AppService get appService => _i4.AppService();
  @override
  _i8.KeyPadService get keypadService => _i8.KeyPadService();
  @override
  _i11.NavigationService get nav => _i11.NavigationService();
  @override
  _i12.ProductService get productService => _i12.ProductService();
  @override
  _i14.SettingsService get settings => _i14.SettingsService();
}
