// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_crashlytics/firebase_crashlytics.dart' as _i141;
import 'package:flipper_models/flipper_http_client.dart' as _i843;
import 'package:flipper_models/FlipperInterface.dart' as _i445;
import 'package:flipper_models/FlipperInterfaceCapella.dart' as _i489;
import 'package:flipper_models/Supabase.dart' as _i163;
import 'package:flipper_models/sync_service.dart' as _i211;
import 'package:flipper_models/SyncStrategy.dart' as _i500;
import 'package:flipper_models/tax_api.dart' as _i97;
import 'package:flipper_models/view_models/NotificationStream.dart' as _i457;
import 'package:flipper_models/whatsapp.dart' as _i632;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'abstractions/analytic.dart' as _i271;
import 'abstractions/dynamic_link.dart' as _i0;
import 'abstractions/location.dart' as _i299;
import 'abstractions/printer.dart' as _i289;
import 'abstractions/remote.dart' as _i172;
import 'abstractions/shareable.dart' as _i23;
import 'abstractions/storage.dart' as _i740;
import 'abstractions/system_time.dart' as _i703;
import 'abstractions/upload.dart' as _i103;
import 'app_service.dart' as _i403;
import 'billing_service.dart' as _i36;
import 'country_service.dart' as _i923;
import 'cron_service.dart' as _i1069;
import 'DeviceIdService.dart' as _i844;
import 'event_interface.dart' as _i229;
import 'firebase_messaging.dart' as _i251;
import 'FirebaseCrashlyticService.dart' as _i628;
import 'force_data_service.dart' as _i798;
import 'HttpApi.dart' as _i32;
import 'in_app_review.dart' as _i118;
import 'keypad_service.dart' as _i150;
import 'language_service.dart' as _i313;
import 'local_notification_service.dart' as _i445;
import 'PayStackService.dart' as _i918;
import 'product_service.dart' as _i777;
import 'sentry_service.dart' as _i107;
import 'services_module.dart' as _i205;
import 'setting_service.dart' as _i290;
import 'status.dart' as _i21;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final servicesModule = _$ServicesModule();
    gh.factory<_i290.SettingsService>(() => servicesModule.settingsService);
    gh.singleton<_i141.FirebaseCrashlytics>(() => servicesModule.crashlytics);
    gh.singleton<_i974.FirebaseFirestore>(() => servicesModule.firestore);
    gh.lazySingleton<_i163.SupabaseInterface>(() => servicesModule.supa);
    gh.lazySingleton<_i628.Crash>(() => servicesModule.crash);
    gh.lazySingleton<_i844.Device>(() => servicesModule.device);
    gh.lazySingleton<_i457.NotificationStream>(() => servicesModule.notie);
    gh.lazySingleton<_i103.UploadT>(() => servicesModule.upload);
    gh.lazySingleton<_i23.Shareable>(() => servicesModule.share);
    gh.lazySingleton<_i118.Review>(() => servicesModule.review);
    gh.lazySingleton<_i251.Messaging>(() => servicesModule.messaging);
    gh.lazySingleton<_i0.DynamicLink>(() => servicesModule.dynamicLink);
    gh.lazySingleton<_i289.Printer>(() => servicesModule.printService);
    gh.lazySingleton<_i271.Analytic>(() => servicesModule.appAnalytic);
    gh.lazySingleton<_i923.Country>(() => servicesModule.country);
    gh.lazySingleton<_i703.SystemTime>(() => servicesModule.systemTime);
    gh.lazySingleton<_i632.WhatsApp>(() => servicesModule.whatsApp);
    gh.lazySingleton<_i150.KeyPadService>(() => servicesModule.keypadService);
    gh.lazySingleton<_i21.Status>(() => servicesModule.status);
    gh.lazySingleton<_i229.EventInterface>(() => servicesModule.event);
    gh.lazySingleton<_i313.Language>(() => servicesModule.languageService);
    gh.lazySingleton<_i97.TaxApi>(() => servicesModule.taxApiService);
    gh.lazySingleton<_i445.LNotification>(() => servicesModule.notification);
    gh.lazySingleton<_i299.FlipperLocation>(() => servicesModule.location);
    await gh.lazySingletonAsync<_i740.LocalStorage>(
      () => servicesModule.box(),
      preResolve: true,
    );
    gh.lazySingleton<_i843.HttpClientInterface>(() => servicesModule.http());
    gh.lazySingleton<_i918.PayStackServiceInterface>(
        () => servicesModule.payStack());
    gh.lazySingleton<_i32.RealmViaHttp>(() => servicesModule.realmHttp());
    gh.lazySingleton<_i172.Remote>(() => servicesModule.remote());
    gh.lazySingleton<_i107.SentryServiceInterface>(
        () => servicesModule.sentry());
    gh.lazySingleton<_i403.AppService>(() => servicesModule.appService());
    gh.lazySingleton<_i777.ProductService>(
        () => servicesModule.productService());
    gh.lazySingleton<_i1069.CronService>(() => servicesModule.cron());
    gh.lazySingleton<_i445.SyncReaml<_i211.IJsonSerializable>>(
        () => servicesModule.syncRealm());
    gh.lazySingleton<_i798.ForceDataEntryService>(
        () => servicesModule.forcedataEntry());
    gh.lazySingleton<_i36.BillingService>(() => servicesModule.billing());
    gh.lazySingleton<_i489.FlipperInterfaceCapella>(
      () => servicesModule.provideSyncInterface(gh<_i974.FirebaseFirestore>()),
      instanceName: 'backup',
    );
    await gh.lazySingletonAsync<_i445.FlipperInterface>(
      () => servicesModule.localRealm(gh<_i740.LocalStorage>()),
      preResolve: true,
    );
    await gh.lazySingletonAsync<_i489.FlipperInterfaceCapella>(
      () => servicesModule.capella(gh<_i740.LocalStorage>()),
      instanceName: 'capella',
      preResolve: true,
    );
    gh.lazySingleton<_i500.SyncStrategy>(
      () => servicesModule.provideStrategy(
        gh<_i489.FlipperInterfaceCapella>(instanceName: 'capella'),
        gh<_i489.FlipperInterfaceCapella>(instanceName: 'backup'),
      ),
      instanceName: 'strategy',
    );
    return this;
  }
}

class _$ServicesModule extends _i205.ServicesModule {
  @override
  _i290.SettingsService get settingsService => _i290.SettingsService();

  @override
  _i150.KeyPadService get keypadService => _i150.KeyPadService();
}
