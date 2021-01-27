// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';

import 'analytics_service.dart';
import 'abstractions/api.dart';
import 'bluethooth_service.dart';
import 'connectivity_service.dart';
import 'database_service.dart';
import 'dynamic_links_service.dart';
import 'firestore_service.dart';
import 'flipperNavigation_service.dart';
import 'api/http_api.dart';
import 'flipperServices.dart';
import 'mail_service.dart';
import 'media_service.dart';
import 'performance_service.dart';
import 'pusher_service.dart';
import 'shared_preference_service.dart';
import 'shared_state_service.dart';
import 'third_party_services_module.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  gh.lazySingleton<AnalyticsService>(
      () => thirdPartyServicesModule.analyticsService);
  gh.lazySingleton<Api>(() => thirdPartyServicesModule.apiService);
  gh.lazySingleton<BlueToothService>(
      () => thirdPartyServicesModule.blueToothService);
  gh.lazySingleton<ConnectivityService>(
      () => thirdPartyServicesModule.connectivityService);
  gh.lazySingleton<DatabaseService>(
      () => thirdPartyServicesModule.databaseService);
  gh.lazySingleton<DialogService>(() => thirdPartyServicesModule.dialogService);
  gh.lazySingleton<DynamicLinkService>(() => thirdPartyServicesModule.link);
  gh.lazySingleton<FirestoreService>(
      () => thirdPartyServicesModule.firestoreService);
  gh.lazySingleton<FlipperNavigationService>(
      () => thirdPartyServicesModule.flipperNavigationService);
  gh.lazySingleton<HttpApi>(() => HttpApi());
  gh.lazySingleton<KeyPadService>(() => thirdPartyServicesModule.keypad);
  gh.lazySingleton<MailService>(() => thirdPartyServicesModule.mailService);
  gh.lazySingleton<MediaService>(() => MediaService());
  gh.lazySingleton<NavigationService>(
      () => thirdPartyServicesModule.navigationService);
  gh.lazySingleton<PerformanceService>(
      () => thirdPartyServicesModule.performanceService);
  gh.lazySingleton<PusherService>(() => thirdPartyServicesModule.pusherService);
  gh.lazySingleton<SharedPreferenceService>(
      () => thirdPartyServicesModule.sharedPreferences);
  gh.lazySingleton<SharedStateService>(
      () => thirdPartyServicesModule.sharedStateService);
  gh.lazySingleton<SnackbarService>(
      () => thirdPartyServicesModule.snackbarService);
  return get;
}

class _$ThirdPartyServicesModule extends ThirdPartyServicesModule {
  @override
  AnalyticsService get analyticsService => AnalyticsService();
  @override
  BlueToothService get blueToothService => BlueToothService();
  @override
  ConnectivityService get connectivityService => ConnectivityService();
  @override
  DatabaseService get databaseService => DatabaseService();
  @override
  DialogService get dialogService => DialogService();
  @override
  DynamicLinkService get link => DynamicLinkService();
  @override
  FirestoreService get firestoreService => FirestoreService();
  @override
  FlipperNavigationService get flipperNavigationService =>
      FlipperNavigationService();
  @override
  KeyPadService get keypad => KeyPadService();
  @override
  MailService get mailService => MailService();
  @override
  NavigationService get navigationService => NavigationService();
  @override
  PerformanceService get performanceService => PerformanceService();
  @override
  PusherService get pusherService => PusherService();
  @override
  SharedPreferenceService get sharedPreferences => SharedPreferenceService();
  @override
  SharedStateService get sharedStateService => SharedStateService();
  @override
  SnackbarService get snackbarService => SnackbarService();
}
