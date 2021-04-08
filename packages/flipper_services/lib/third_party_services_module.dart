library flipper_services;

// import 'package:flipper/shared_state_service.dart';
import 'package:flipper_services/ContactService.dart';
import 'package:flipper_services/api/http_api.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/bluethooth_service.dart';
import 'package:flipper_services/connectivity_service.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/dynamic_links_service.dart';
import 'package:flipper_services/fetch_contacts_service.dart';
import 'package:flipper_services/firestore_service.dart';
import 'package:flipper_services/flipperNavigation_service.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/mail_service.dart';
import 'package:flipper_services/navigation_service.dart';
import 'package:flipper_services/performance_service.dart';
import 'package:flipper_services/remote_config_service.dart';
import 'package:flipper_services/shared_preference_service.dart';
import 'package:flipper_services/ticket_service.dart';
// import 'package:flipper_services/shared_state_service.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';

// import 'package:stacked_services/stacked_services.dart';
// import 'package:flipper/bluethooth_service.dart';
import 'abstractions/api.dart';
import 'analytics_service.dart';
import 'api/fake_api.dart';
import 'pusher_service.dart';
import 'shared_state_service.dart';
// import 'connectivity_service.dart';

enum ApiProvider {
  Fake,
  Rest,
}

@module
abstract class ThirdPartyServicesModule {
  @lazySingleton
  NavigationService get navigationService;
  @lazySingleton
  DialogService get dialogService;
  @lazySingleton
  SnackbarService get snackbarService;
  @lazySingleton
  Api get apiService {
    // ignore: prefer_typing_uninitialized_variables
    var apiService;
    const ApiProvider choosenProvider =
        ApiProvider.Rest; // change this to change the proider
    switch (choosenProvider) {
      case ApiProvider.Fake:
        apiService = FakeApi();
        break;
        break;
      case ApiProvider.Rest:
        apiService = HttpApi();
        break;
      default:
        apiService = HttpApi();
    }
    return apiService;
  }

  @lazySingleton
  ConnectivityService get connectivityService;
  @lazySingleton
  AnalyticsService get analyticsService;
  @lazySingleton
  PerformanceService get performanceService;

  @lazySingleton
  FlipperNavigationService get flipperNavigationService;

  @lazySingleton
  DatabaseService get databaseService;

  @lazySingleton
  BlueToothService get blueToothService;

  @lazySingleton
  MailService get mailService;

  @lazySingleton
  SharedPreferenceService get sharedPreferences;

  @lazySingleton
  SharedStateService get sharedStateService;

  @lazySingleton
  FirestoreService get firestoreService;

  @lazySingleton
  PusherService get pusherService;

  @lazySingleton
  KeyPadService get keypad;

  @lazySingleton
  DynamicLinkService get link;

  @lazySingleton
  FetchContactsService get fetch;

  @lazySingleton
  ContactService get contact;

  @lazySingleton
  InAppNavigationService get inAppNav;

  @lazySingleton
  RemoteConfigService get remoteConfig;

  @lazySingleton
  AppService get app;

  @lazySingleton
  TicketService get ticket;
  // @lazySingleton
  // FetchContactsService fetchContactsService;
}
// each time you add a new service run:
// flutter packages pub run build_runner build --delete-conflicting-outputs
