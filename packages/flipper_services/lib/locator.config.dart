// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'abstractions/analytic.dart' as _i3;
import 'abstractions/api.dart' as _i5;
import 'abstractions/dynamic_link.dart' as _i11;
import 'abstractions/location.dart' as _i13;
import 'abstractions/printer.dart' as _i20;
import 'abstractions/remote.dart' as _i22;
import 'abstractions/share.dart' as _i25;
import 'abstractions/storage.dart' as _i18;
import 'abstractions/sync.dart' as _i26;
import 'abstractions/system_time.dart' as _i27;
import 'abstractions/upload.dart' as _i28;
import 'analytic_service.dart' as _i4;
import 'app_service.dart' as _i6;
import 'billing_service.dart' as _i7;
import 'country_service.dart' as _i8;
import 'cron_service.dart' as _i10;
import 'FirebaseCrashlyticService.dart' as _i9;
import 'firestore_api.dart' as _i12;
import 'force_data_service.dart' as _i14;
import 'in_app_review.dart' as _i23;
import 'keypad_service.dart' as _i15;
import 'language_service.dart' as _i17;
import 'local_notification_service.dart' as _i16;
import 'login_service.dart' as _i19;
import 'product_service.dart' as _i21;
import 'setting_service.dart' as _i24;
import 'third_party_services_module.dart'
    as _i29; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  gh.lazySingleton<_i3.Analytic>(() => thirdPartyServicesModule.appAnalytic);
  gh.lazySingleton<_i4.AnalyticService>(
      () => thirdPartyServicesModule.analytic);
  gh.lazySingleton<_i5.Api<dynamic>>(() => thirdPartyServicesModule.apiService);
  gh.lazySingleton<_i6.AppService>(() => thirdPartyServicesModule.appService);
  gh.lazySingleton<_i7.BillingService>(() => thirdPartyServicesModule.billing);
  gh.lazySingleton<_i8.Country>(() => thirdPartyServicesModule.country);
  gh.lazySingleton<_i9.Crash>(() => thirdPartyServicesModule.crash);
  gh.lazySingleton<_i10.CronService>(() => thirdPartyServicesModule.cron);
  gh.lazySingleton<_i11.DynamicLink>(
      () => thirdPartyServicesModule.dynamicLink);
  gh.lazySingleton<_i12.Firestore>(() => thirdPartyServicesModule.firestore);
  gh.lazySingleton<_i13.FlipperLocation>(
      () => thirdPartyServicesModule.location);
  gh.lazySingleton<_i14.ForceDataEntryService>(
      () => thirdPartyServicesModule.forcedataEntry);
  gh.lazySingleton<_i15.KeyPadService>(
      () => thirdPartyServicesModule.keypadService);
  gh.lazySingleton<_i16.LNotification>(
      () => thirdPartyServicesModule.notification);
  gh.lazySingleton<_i17.LanguageService>(
      () => thirdPartyServicesModule.languageService);
  gh.lazySingleton<_i18.LocalStorage>(() => thirdPartyServicesModule.box);
  gh.lazySingleton<_i19.LoginService>(
      () => thirdPartyServicesModule.loginService);
  gh.lazySingleton<_i20.Printer>(() => thirdPartyServicesModule.printService);
  gh.lazySingleton<_i21.ProductService>(
      () => thirdPartyServicesModule.productService);
  gh.lazySingleton<_i22.Remote>(() => thirdPartyServicesModule.remote);
  gh.lazySingleton<_i23.Review>(() => thirdPartyServicesModule.review);
  gh.lazySingleton<_i24.SettingsService>(
      () => thirdPartyServicesModule.settings);
  gh.lazySingleton<_i25.Shareble>(() => thirdPartyServicesModule.share);
  gh.lazySingleton<_i26.SyncApiInterface>(
      () => thirdPartyServicesModule.syncApi);
  gh.lazySingleton<_i27.SystemTime>(() => thirdPartyServicesModule.systemTime);
  gh.lazySingleton<_i28.UploadT>(() => thirdPartyServicesModule.upload);
  return get;
}

class _$ThirdPartyServicesModule extends _i29.ThirdPartyServicesModule {
  @override
  _i4.AnalyticService get analytic => _i4.AnalyticService();
  @override
  _i6.AppService get appService => _i6.AppService();
  @override
  _i7.BillingService get billing => _i7.BillingService();
  @override
  _i10.CronService get cron => _i10.CronService();
  @override
  _i14.ForceDataEntryService get forcedataEntry => _i14.ForceDataEntryService();
  @override
  _i15.KeyPadService get keypadService => _i15.KeyPadService();
  @override
  _i17.LanguageService get languageService => _i17.LanguageService();
  @override
  _i19.LoginService get loginService => _i19.LoginService();
  @override
  _i21.ProductService get productService => _i21.ProductService();
  @override
  _i24.SettingsService get settings => _i24.SettingsService();
}
