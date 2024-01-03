// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flipper_models/FirestoreSync.dart' as _i32;
import 'package:flipper_models/http_client_interface.dart' as _i14;
import 'package:flipper_models/isar_models.dart' as _i15;
import 'package:flipper_models/RealmSync.dart' as _i33;
import 'package:flipper_models/remote_service.dart' as _i24;
import 'package:flipper_models/sync.dart' as _i30;
import 'package:flipper_models/sync_service.dart' as _i31;
import 'package:flipper_models/tax_api.dart' as _i35;
import 'package:flipper_models/whatsapp.dart' as _i37;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'abstractions/analytic.dart' as _i3;
import 'abstractions/dynamic_link.dart' as _i10;
import 'abstractions/location.dart' as _i12;
import 'abstractions/printer.dart' as _i21;
import 'abstractions/remote.dart' as _i23;
import 'abstractions/shareable.dart' as _i28;
import 'abstractions/storage.dart' as _i19;
import 'abstractions/system_time.dart' as _i34;
import 'abstractions/upload.dart' as _i36;
import 'app_service.dart' as _i4;
import 'billing_service.dart' as _i5;
import 'country_service.dart' as _i6;
import 'cron_service.dart' as _i8;
import 'DeviceIdService.dart' as _i9;
import 'event_interface.dart' as _i11;
import 'firebase_messaging.dart' as _i20;
import 'FirebaseCrashlyticService.dart' as _i7;
import 'force_data_service.dart' as _i13;
import 'in_app_review.dart' as _i25;
import 'keypad_service.dart' as _i16;
import 'language_service.dart' as _i18;
import 'local_notification_service.dart' as _i17;
import 'product_service.dart' as _i22;
import 'sentry_service.dart' as _i26;
import 'services_module.dart' as _i38;
import 'setting_service.dart' as _i27;
import 'status.dart' as _i29;

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
    final servicesModule = _$ServicesModule();
    gh.lazySingleton<_i3.Analytic>(() => servicesModule.appAnalytic);
    gh.lazySingleton<_i4.AppService>(() => servicesModule.appService());
    gh.lazySingleton<_i5.BillingService>(() => servicesModule.billing());
    gh.lazySingleton<_i6.Country>(() => servicesModule.country);
    gh.lazySingleton<_i7.Crash>(() => servicesModule.crash);
    gh.lazySingleton<_i8.CronService>(() => servicesModule.cron());
    gh.lazySingleton<_i9.Device>(() => servicesModule.device);
    gh.lazySingleton<_i10.DynamicLink>(() => servicesModule.dynamicLink);
    gh.lazySingleton<_i11.EventInterface>(() => servicesModule.event);
    gh.lazySingleton<_i12.FlipperLocation>(() => servicesModule.location);
    gh.lazySingleton<_i13.ForceDataEntryService>(
        () => servicesModule.forcedataEntry());
    await gh.factoryAsync<_i14.HttpClientInterface>(
      () => servicesModule.httpClient,
      preResolve: true,
    );
    await gh.lazySingletonAsync<_i15.IsarApiInterface>(
      () => servicesModule.isarApi(),
      preResolve: true,
    );
    gh.lazySingleton<_i16.KeyPadService>(() => servicesModule.keypadService);
    gh.lazySingleton<_i17.LNotification>(() => servicesModule.notification);
    gh.lazySingleton<_i18.Language>(() => servicesModule.languageService);
    await gh.lazySingletonAsync<_i19.LocalStorage>(
      () => servicesModule.box,
      preResolve: true,
    );
    gh.lazySingleton<_i20.Messaging>(() => servicesModule.messaging);
    gh.lazySingleton<_i21.Printer>(() => servicesModule.printService);
    gh.lazySingleton<_i22.ProductService>(
        () => servicesModule.productService());
    gh.lazySingleton<_i23.Remote>(() => servicesModule.remote);
    await gh.factoryAsync<_i24.RemoteInterface>(
      () => servicesModule.remoteApi,
      preResolve: true,
    );
    gh.lazySingleton<_i25.Review>(() => servicesModule.review);
    gh.lazySingleton<_i26.SentryServiceInterface>(
        () => servicesModule.sentry());
    gh.factory<_i27.SettingsService>(() => servicesModule.settingsService);
    gh.lazySingleton<_i28.Shareable>(() => servicesModule.share);
    gh.lazySingleton<_i29.Status>(() => servicesModule.status);
    gh.lazySingleton<_i30.Sync<_i31.IJsonSerializable>>(
        () => servicesModule.sync());
    gh.lazySingleton<_i32.SyncFirestore<_i31.IJsonSerializable>>(
        () => servicesModule.syncFirestore());
    gh.lazySingleton<_i33.SyncReaml<_i31.IJsonSerializable>>(
        () => servicesModule.syncRealm());
    gh.lazySingleton<_i34.SystemTime>(() => servicesModule.systemTime);
    gh.lazySingleton<_i35.TaxApi>(() => servicesModule.taxApiService);
    gh.lazySingleton<_i36.UploadT>(() => servicesModule.upload);
    gh.lazySingleton<_i37.WhatsApp>(() => servicesModule.whatsApp);
    return this;
  }
}

class _$ServicesModule extends _i38.ServicesModule {
  @override
  _i16.KeyPadService get keypadService => _i16.KeyPadService();

  @override
  _i27.SettingsService get settingsService => _i27.SettingsService();
}
