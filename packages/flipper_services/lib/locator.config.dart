// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flipper_models/FirestoreSync.dart' as _i32;
import 'package:flipper_models/LocalRealm.dart' as _i28;
import 'package:flipper_models/realmInterface.dart' as _i27;
import 'package:flipper_models/sync_service.dart' as _i33;
import 'package:flipper_models/tax_api.dart' as _i21;
import 'package:flipper_models/view_models/NotificationStream.dart' as _i5;
import 'package:flipper_models/whatsapp.dart' as _i16;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'abstractions/analytic.dart' as _i13;
import 'abstractions/dynamic_link.dart' as _i11;
import 'abstractions/location.dart' as _i23;
import 'abstractions/printer.dart' as _i12;
import 'abstractions/remote.dart' as _i24;
import 'abstractions/shareable.dart' as _i7;
import 'abstractions/storage.dart' as _i26;
import 'abstractions/system_time.dart' as _i15;
import 'abstractions/upload.dart' as _i6;
import 'app_service.dart' as _i29;
import 'billing_service.dart' as _i35;
import 'country_service.dart' as _i14;
import 'cron_service.dart' as _i31;
import 'DeviceIdService.dart' as _i4;
import 'event_interface.dart' as _i19;
import 'firebase_messaging.dart' as _i9;
import 'FirebaseCrashlyticService.dart' as _i10;
import 'force_data_service.dart' as _i34;
import 'in_app_review.dart' as _i8;
import 'keypad_service.dart' as _i17;
import 'language_service.dart' as _i20;
import 'local_notification_service.dart' as _i22;
import 'product_service.dart' as _i30;
import 'sentry_service.dart' as _i25;
import 'services_module.dart' as _i36;
import 'setting_service.dart' as _i3;
import 'status.dart' as _i18;

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
    gh.lazySingleton<_i4.Device>(() => servicesModule.device);
    gh.lazySingleton<_i5.NotificationStream>(() => servicesModule.notie);
    gh.lazySingleton<_i6.UploadT>(() => servicesModule.upload);
    gh.lazySingleton<_i7.Shareable>(() => servicesModule.share);
    gh.lazySingleton<_i8.Review>(() => servicesModule.review);
    gh.lazySingleton<_i9.Messaging>(() => servicesModule.messaging);
    gh.lazySingleton<_i10.Crash>(() => servicesModule.crash);
    gh.lazySingleton<_i11.DynamicLink>(() => servicesModule.dynamicLink);
    gh.lazySingleton<_i12.Printer>(() => servicesModule.printService);
    gh.lazySingleton<_i13.Analytic>(() => servicesModule.appAnalytic);
    gh.lazySingleton<_i14.Country>(() => servicesModule.country);
    gh.lazySingleton<_i15.SystemTime>(() => servicesModule.systemTime);
    gh.lazySingleton<_i16.WhatsApp>(() => servicesModule.whatsApp);
    gh.lazySingleton<_i17.KeyPadService>(() => servicesModule.keypadService);
    gh.lazySingleton<_i18.Status>(() => servicesModule.status);
    gh.lazySingleton<_i19.EventInterface>(() => servicesModule.event);
    gh.lazySingleton<_i20.Language>(() => servicesModule.languageService);
    gh.lazySingleton<_i21.TaxApi>(() => servicesModule.taxApiService);
    gh.lazySingleton<_i22.LNotification>(() => servicesModule.notification);
    gh.lazySingleton<_i23.FlipperLocation>(() => servicesModule.location);
    gh.lazySingleton<_i24.Remote>(() => servicesModule.remote());
    gh.lazySingleton<_i25.SentryServiceInterface>(
        () => servicesModule.sentry());
    await gh.lazySingletonAsync<_i26.LocalStorage>(
      () => servicesModule.box(),
      preResolve: true,
    );
    await gh.lazySingletonAsync<_i27.RealmApiInterface>(
      () => servicesModule.realmApi(),
      preResolve: true,
    );
    await gh.lazySingletonAsync<_i28.LocalRealmInterface>(
      () => servicesModule.localRealm(),
      preResolve: true,
    );
    gh.lazySingleton<_i29.AppService>(() => servicesModule.appService());
    gh.lazySingleton<_i30.ProductService>(
        () => servicesModule.productService());
    gh.lazySingleton<_i31.CronService>(() => servicesModule.cron());
    gh.lazySingleton<_i32.SyncFirestore<_i33.IJsonSerializable>>(
        () => servicesModule.syncFirestore());
    gh.lazySingleton<_i27.SyncReaml<_i33.IJsonSerializable>>(
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
  _i17.KeyPadService get keypadService => _i17.KeyPadService();
}
