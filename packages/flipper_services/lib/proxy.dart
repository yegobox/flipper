library flipper_services;

import 'package:flipper_services/ContactService.dart';
import 'package:flipper_services/analytics_service.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/bluethooth_service.dart';
import 'package:flipper_services/connectivity_service.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/dynamic_links_service.dart';
import 'package:flipper_services/fetch_contacts_service.dart';
import 'package:flipper_services/firestore_service.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/mail_service.dart';
import 'package:flipper_services/navigation_service.dart';
import 'package:flipper_services/remote_config_service.dart';
import 'package:flipper_services/shared_preference_service.dart';
import 'package:flipper_services/ticket_service.dart';
// import 'package:flipper_services/shared_state_service.dart';
import 'package:stacked_services/stacked_services.dart';

import 'abstractions/api.dart';
// import 'bluethooth_service.dart';
// import 'connectivity_service.dart';
import 'flipperNavigation_service.dart';
import 'pusher_service.dart';
import 'shared_state_service.dart';

final DialogService _dialogService = locator<DialogService>();
final NavigationService _navigationService = locator<NavigationService>();
final SnackbarService _snackbarService = locator<SnackbarService>();

final AnalyticsService _analyticsService = locator<AnalyticsService>();
final ConnectivityService _connectivityService = locator<ConnectivityService>();
final Api _apiService = locator<Api>();
final DatabaseService _databaseService = locator<DatabaseService>();
final BlueToothService _blue = locator<BlueToothService>();
final FlipperNavigationService _nav = locator<FlipperNavigationService>();
final MailService _mail = locator<MailService>();
final SharedPreferenceService _sharedPref = locator<SharedPreferenceService>();
final SharedStateService _sharedState = locator<SharedStateService>();
final FirestoreService _firestore = locator<FirestoreService>();
final PusherService _pusher = locator<PusherService>();
final KeyPadService _keypad = locator<KeyPadService>();
final DynamicLinkService _link = locator<DynamicLinkService>();
final FetchContactsService _fetch = locator<FetchContactsService>();
final ContactService _contact = locator<ContactService>();
final InAppNavigationService _inAppNav = locator<InAppNavigationService>();
final RemoteConfigService _remoteConfig = locator<RemoteConfigService>();
final AppService _app = locator<AppService>();
final TicketService _ticket = locator<TicketService>();

// this is where we load all third party plugin
// ignore: avoid_classes_with_only_static_members
abstract class ProxyService {
  static NavigationService get navigation => _navigationService;
  static DialogService get modal => _dialogService;
  static SnackbarService get toast => _snackbarService;
  static Api get api => _apiService;
  static ConnectivityService get connectivity => _connectivityService;
  static AnalyticsService get analytics => _analyticsService;
  static DatabaseService get database => _databaseService;
  static BlueToothService get blue => _blue;
  static FlipperNavigationService get nav => _nav;
  static MailService get mail => _mail;
  static SharedPreferenceService get sharedPref => _sharedPref;
  static SharedStateService get sharedState => _sharedState;
  static FirestoreService get firestore => _firestore;
  static PusherService get pusher => _pusher;
  static KeyPadService get keypad => _keypad;
  static DynamicLinkService get link => _link;
  static FetchContactsService get fetch => _fetch;
  static RemoteConfigService get remoteConfig => _remoteConfig;
  static ContactService get contacts => _contact;
  static InAppNavigationService get inAppNav => _inAppNav;
  static AppService get app => _app;
  static TicketService get ticket => _ticket;
}
