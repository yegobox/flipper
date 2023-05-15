// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flipper_models/isar_models.dart' as _i13;
import 'package:flipper_models/remote_service.dart' as _i22;
import 'package:flipper_models/sync.dart' as _i26;
import 'package:flipper_models/sync_service.dart' as _i27;
import 'package:flipper_models/tax_api.dart' as _i29;
import 'package:flipper_models/whatsapp.dart' as _i31;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'abstractions/analytic.dart' as _i3;
import 'abstractions/dynamic_link.dart' as _i9;
import 'abstractions/location.dart' as _i11;
import 'abstractions/printer.dart' as _i19;
import 'abstractions/remote.dart' as _i21;
import 'abstractions/shareable.dart' as _i25;
import 'abstractions/storage.dart' as _i17;
import 'abstractions/system_time.dart' as _i28;
import 'abstractions/upload.dart' as _i30;
import 'app_service.dart' as _i4;
import 'billing_service.dart' as _i5;
import 'country_service.dart' as _i6;
import 'cron_service.dart' as _i8;
import 'event_interface.dart' as _i10;
import 'firebase_messaging.dart' as _i18;
import 'FirebaseCrashlyticService.dart' as _i7;
import 'force_data_service.dart' as _i12;
import 'in_app_review.dart' as _i23;
import 'keypad_service.dart' as _i14;
import 'language_service.dart' as _i16;
import 'local_notification_service.dart' as _i15;
import 'product_service.dart' as _i20;
import 'setting_service.dart' as _i24;
import 'third_party_services_module.dart'
    as _i32; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  gh.lazySingleton<_i3.Analytic>(() => thirdPartyServicesModule.appAnalytic);
  gh.lazySingleton<_i4.AppService>(() => thirdPartyServicesModule.appService);
  gh.lazySingleton<_i5.BillingService>(() => thirdPartyServicesModule.billing);
  gh.lazySingleton<_i6.Country>(() => thirdPartyServicesModule.country);
  gh.lazySingleton<_i7.Crash>(() => thirdPartyServicesModule.crash);
  gh.lazySingleton<_i8.CronService>(() => thirdPartyServicesModule.cron);
  gh.lazySingleton<_i9.DynamicLink>(() => thirdPartyServicesModule.dynamicLink);
  gh.lazySingleton<_i10.EventInterface>(() => thirdPartyServicesModule.event);
  gh.lazySingleton<_i11.FlipperLocation>(
      () => thirdPartyServicesModule.location);
  gh.lazySingleton<_i12.ForceDataEntryService>(
      () => thirdPartyServicesModule.forcedataEntry);
  await gh.factoryAsync<_i13.IsarApiInterface>(
    () => thirdPartyServicesModule.isarApi,
    preResolve: true,
  );
  gh.lazySingleton<_i14.KeyPadService>(
      () => thirdPartyServicesModule.keypadService);
  gh.lazySingleton<_i15.LNotification>(
      () => thirdPartyServicesModule.notification);
  gh.lazySingleton<_i16.Language>(
      () => thirdPartyServicesModule.languageService);
  gh.lazySingleton<_i17.LocalStorage>(() => thirdPartyServicesModule.box);
  gh.lazySingleton<_i18.Messaging>(() => thirdPartyServicesModule.messaging);
  gh.lazySingleton<_i19.Printer>(() => thirdPartyServicesModule.printService);
  gh.lazySingleton<_i20.ProductService>(
      () => thirdPartyServicesModule.productService);
  gh.lazySingleton<_i21.Remote>(() => thirdPartyServicesModule.remote);
  await gh.factoryAsync<_i22.RemoteInterface>(
    () => thirdPartyServicesModule.remoteApi,
    preResolve: true,
  );
  gh.lazySingleton<_i23.Review>(() => thirdPartyServicesModule.review);
  gh.lazySingleton<_i24.SettingsService>(
      () => thirdPartyServicesModule.settings);
  gh.lazySingleton<_i25.Shareable>(() => thirdPartyServicesModule.share);
  gh.lazySingleton<_i26.SyncApiInterface<_i27.IJsonSerializable>>(
      () => thirdPartyServicesModule.sync);
  gh.lazySingleton<_i28.SystemTime>(() => thirdPartyServicesModule.systemTime);
  gh.lazySingleton<_i29.TaxApi>(() => thirdPartyServicesModule.taxApiService);
  gh.lazySingleton<_i30.UploadT>(() => thirdPartyServicesModule.upload);
  gh.lazySingleton<_i31.WhatsApp>(() => thirdPartyServicesModule.whatsApp);
  return get;
}

class _$ThirdPartyServicesModule extends _i32.ThirdPartyServicesModule {
  @override
  _i4.AppService get appService => _i4.AppService();
  @override
  _i5.BillingService get billing => _i5.BillingService();
  @override
  _i8.CronService get cron => _i8.CronService();
  @override
  _i12.ForceDataEntryService get forcedataEntry => _i12.ForceDataEntryService();
  @override
  _i14.KeyPadService get keypadService => _i14.KeyPadService();
  @override
  _i20.ProductService get productService => _i20.ProductService();
  @override
  _i24.SettingsService get settings => _i24.SettingsService();
}
