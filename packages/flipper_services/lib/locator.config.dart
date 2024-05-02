// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flipper_models/FirestoreSync.dart' as _i32;
import 'package:flipper_models/http_client_interface.dart' as _i4;
import 'package:flipper_models/realmInterface.dart' as _i28;
import 'package:flipper_models/sync_service.dart' as _i33;
import 'package:flipper_models/tax_api.dart' as _i23;
import 'package:flipper_models/view_models/NotificationStream.dart' as _i6;
import 'package:flipper_models/whatsapp.dart' as _i18;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'abstractions/analytic.dart' as _i15;
import 'abstractions/dynamic_link.dart' as _i12;
import 'abstractions/location.dart' as _i25;
import 'abstractions/printer.dart' as _i14;
import 'abstractions/remote.dart' as _i13;
import 'abstractions/shareable.dart' as _i8;
import 'abstractions/storage.dart' as _i27;
import 'abstractions/system_time.dart' as _i17;
import 'abstractions/upload.dart' as _i7;
import 'app_service.dart' as _i29;
import 'billing_service.dart' as _i35;
import 'country_service.dart' as _i16;
import 'cron_service.dart' as _i31;
import 'DeviceIdService.dart' as _i5;
import 'event_interface.dart' as _i21;
import 'firebase_messaging.dart' as _i10;
import 'FirebaseCrashlyticService.dart' as _i11;
import 'force_data_service.dart' as _i34;
import 'in_app_review.dart' as _i9;
import 'keypad_service.dart' as _i19;
import 'language_service.dart' as _i22;
import 'local_notification_service.dart' as _i24;
import 'product_service.dart' as _i30;
import 'sentry_service.dart' as _i26;
import 'services_module.dart' as _i36;
import 'setting_service.dart' as _i3;
import 'status.dart' as _i20;

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
    gh.factory<_i3.SettingsService>(() => servicesModule.settingsService);
    await gh.factoryAsync<_i4.HttpClientInterface>(
      () => servicesModule.httpClient(),
      preResolve: true,
    );
    gh.lazySingleton<_i5.Device>(() => servicesModule.device);
    gh.lazySingleton<_i6.NotificationStream>(() => servicesModule.notie);
    gh.lazySingleton<_i7.UploadT>(() => servicesModule.upload);
    gh.lazySingleton<_i8.Shareable>(() => servicesModule.share);
    gh.lazySingleton<_i9.Review>(() => servicesModule.review);
    gh.lazySingleton<_i10.Messaging>(() => servicesModule.messaging);
    gh.lazySingleton<_i11.Crash>(() => servicesModule.crash);
    gh.lazySingleton<_i12.DynamicLink>(() => servicesModule.dynamicLink);
    gh.lazySingleton<_i13.Remote>(() => servicesModule.remote);
    gh.lazySingleton<_i14.Printer>(() => servicesModule.printService);
    gh.lazySingleton<_i15.Analytic>(() => servicesModule.appAnalytic);
    gh.lazySingleton<_i16.Country>(() => servicesModule.country);
    gh.lazySingleton<_i17.SystemTime>(() => servicesModule.systemTime);
    gh.lazySingleton<_i18.WhatsApp>(() => servicesModule.whatsApp);
    gh.lazySingleton<_i19.KeyPadService>(() => servicesModule.keypadService);
    gh.lazySingleton<_i20.Status>(() => servicesModule.status);
    gh.lazySingleton<_i21.EventInterface>(() => servicesModule.event);
    gh.lazySingleton<_i22.Language>(() => servicesModule.languageService);
    gh.lazySingleton<_i23.TaxApi>(() => servicesModule.taxApiService);
    gh.lazySingleton<_i24.LNotification>(() => servicesModule.notification);
    gh.lazySingleton<_i25.FlipperLocation>(() => servicesModule.location);
    gh.lazySingleton<_i26.SentryServiceInterface>(
        () => servicesModule.sentry());
    await gh.lazySingletonAsync<_i27.LocalStorage>(
      () => servicesModule.box(),
      preResolve: true,
    );
    await gh.lazySingletonAsync<_i28.RealmApiInterface>(
      () => servicesModule.realmApi(),
      preResolve: true,
    );
    gh.lazySingleton<_i29.AppService>(() => servicesModule.appService());
    gh.lazySingleton<_i30.ProductService>(
        () => servicesModule.productService());
    gh.lazySingleton<_i31.CronService>(() => servicesModule.cron());
    gh.lazySingleton<_i32.SyncFirestore<_i33.IJsonSerializable>>(
        () => servicesModule.syncFirestore());
    gh.lazySingleton<_i28.SyncReaml<_i33.IJsonSerializable>>(
        () => servicesModule.syncRealm());
    gh.lazySingleton<_i34.ForceDataEntryService>(
        () => servicesModule.forcedataEntry());
    gh.lazySingleton<_i35.BillingService>(() => servicesModule.billing());
    return this;
  }
}

class _$ServicesModule extends _i36.ServicesModule {
  @override
  _i3.SettingsService get settingsService => _i3.SettingsService();

  @override
  _i19.KeyPadService get keypadService => _i19.KeyPadService();
}
