// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:flipper_models/isar_models.dart' as _i15;
import 'package:flipper_models/tax_api.dart' as _i28;
import 'package:flipper_models/whatsapp.dart' as _i30;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'abstractions/analytic.dart' as _i3;
import 'abstractions/dynamic_link.dart' as _i10;
import 'abstractions/location.dart' as _i13;
import 'abstractions/printer.dart' as _i20;
import 'abstractions/remote.dart' as _i22;
import 'abstractions/share.dart' as _i25;
import 'abstractions/storage.dart' as _i19;
import 'abstractions/sync.dart' as _i26;
import 'abstractions/system_time.dart' as _i27;
import 'abstractions/upload.dart' as _i29;
import 'analytic_service.dart' as _i4;
import 'app_service.dart' as _i5;
import 'billing_service.dart' as _i6;
import 'country_service.dart' as _i7;
import 'cron_service.dart' as _i9;
import 'event_service.dart' as _i11;
import 'FirebaseCrashlyticService.dart' as _i8;
import 'firestore_api.dart' as _i12;
import 'force_data_service.dart' as _i14;
import 'in_app_review.dart' as _i23;
import 'keypad_service.dart' as _i16;
import 'language_service.dart' as _i18;
import 'local_notification_service.dart' as _i17;
import 'product_service.dart' as _i21;
import 'setting_service.dart' as _i24;
import 'third_party_services_module.dart'
    as _i31; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  gh.lazySingleton<_i3.Analytic>(() => thirdPartyServicesModule.appAnalytic);
  gh.lazySingleton<_i4.AnalyticService>(
      () => thirdPartyServicesModule.analytic);
  gh.lazySingleton<_i5.AppService>(() => thirdPartyServicesModule.appService);
  gh.lazySingleton<_i6.BillingService>(() => thirdPartyServicesModule.billing);
  gh.lazySingleton<_i7.Country>(() => thirdPartyServicesModule.country);
  gh.lazySingleton<_i8.Crash>(() => thirdPartyServicesModule.crash);
  gh.lazySingleton<_i9.CronService>(() => thirdPartyServicesModule.cron);
  gh.lazySingleton<_i10.DynamicLink>(
      () => thirdPartyServicesModule.dynamicLink);
  gh.lazySingleton<_i11.EventService>(
      () => thirdPartyServicesModule.loginService);
  gh.lazySingleton<_i12.FlipperFirestore>(
      () => thirdPartyServicesModule.firestore);
  gh.lazySingleton<_i13.FlipperLocation>(
      () => thirdPartyServicesModule.location);
  gh.lazySingleton<_i14.ForceDataEntryService>(
      () => thirdPartyServicesModule.forcedataEntry);
  await gh.factoryAsync<_i15.IsarApiInterface>(
      () => thirdPartyServicesModule.isarApi,
      preResolve: true);
  gh.lazySingleton<_i16.KeyPadService>(
      () => thirdPartyServicesModule.keypadService);
  gh.lazySingleton<_i17.LNotification>(
      () => thirdPartyServicesModule.notification);
  gh.lazySingleton<_i18.LanguageService>(
      () => thirdPartyServicesModule.languageService);
  gh.lazySingleton<_i19.LocalStorage>(() => thirdPartyServicesModule.box);
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
  gh.lazySingleton<_i28.TaxApi>(() => thirdPartyServicesModule.taxApiService);
  gh.lazySingleton<_i29.UploadT>(() => thirdPartyServicesModule.upload);
  gh.lazySingleton<_i30.WhatsApp>(() => thirdPartyServicesModule.whatsApp);
  return get;
}

class _$ThirdPartyServicesModule extends _i31.ThirdPartyServicesModule {
  @override
  _i4.AnalyticService get analytic => _i4.AnalyticService();
  @override
  _i5.AppService get appService => _i5.AppService();
  @override
  _i6.BillingService get billing => _i6.BillingService();
  @override
  _i9.CronService get cron => _i9.CronService();
  @override
  _i11.EventService get loginService => _i11.EventService();
  @override
  _i14.ForceDataEntryService get forcedataEntry => _i14.ForceDataEntryService();
  @override
  _i16.KeyPadService get keypadService => _i16.KeyPadService();
  @override
  _i18.LanguageService get languageService => _i18.LanguageService();
  @override
  _i21.ProductService get productService => _i21.ProductService();
  @override
  _i24.SettingsService get settings => _i24.SettingsService();
}
