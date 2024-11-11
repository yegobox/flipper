import 'package:flipper_models/FlipperInterfaceCapella.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/Supabase.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/FlipperInterface.dart';
import 'package:flipper_models/view_models/NotificationStream.dart';
import 'package:flipper_models/whatsapp.dart';
import 'package:flipper_services/FirebaseCrashlyticService.dart';
import 'package:flipper_services/HttpApi.dart';
import 'package:flipper_services/PayStackService.dart';

import 'package:flipper_services/abstractions/analytic.dart';
import 'package:flipper_services/abstractions/printer.dart';
import 'package:flipper_services/abstractions/remote.dart';
import 'package:flipper_models/sync.dart';
import 'package:flipper_services/abstractions/system_time.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/billing_service.dart';
import 'package:flipper_services/event_interface.dart';
import 'package:flipper_services/force_data_service.dart';
import 'package:flipper_services/in_app_review.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/language_service.dart';
import 'package:flipper_services/local_notification_service.dart';
import 'package:flipper_services/cron_service.dart';
import 'package:flipper_services/sentry_service.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_services/status.dart';
import 'DeviceIdService.dart';
import 'abstractions/api.dart';
import 'abstractions/dynamic_link.dart';
import 'abstractions/location.dart';
import 'abstractions/shareable.dart';
import 'abstractions/storage.dart';
import 'abstractions/upload.dart';
import 'country_service.dart';
import 'firebase_messaging.dart';
import 'locator.dart';
import 'product_service.dart';
import 'package:flipper_models/tax_api.dart';

final Api _apiService = getIt<Api>();
final DynamicLink _dynamicLink = getIt<DynamicLink>();
final Shareable _share = getIt<Shareable>();
final FlipperLocation _location = getIt<FlipperLocation>();
final LocalStorage _box = getIt<LocalStorage>();
final UploadT _upload = getIt<UploadT>();
final AppService _app = getIt<AppService>();
final ProductService _productService = getIt<ProductService>();
final KeyPadService _keypad = getIt<KeyPadService>();
final Language _locale = getIt<Language>();
// RemoteService
final Remote _remoteConfig = getIt<Remote>();
final Country _country = getIt<Country>();
final SettingsService _settings = getIt<SettingsService>();
final CronService _reportService = getIt<CronService>();
final Printer _printService = getIt<Printer>();
final Analytic _analytics = getIt<Analytic>();
final ForceDataEntryService _forceDataEntry = getIt<ForceDataEntryService>();

final LNotification _notification = getIt<LNotification>();
final Review _review = getIt<Review>();
final Sync _syncApi = getIt<Sync>();
final SystemTime _systemTime = getIt<SystemTime>();
final EventInterface _event = getIt<EventInterface>();
final BillingService _billingService = getIt<BillingService>();

final TaxApi _tax = getIt<TaxApi>();
final WhatsApp _whatsApp = getIt<WhatsApp>();
final Messaging _messaging = getIt<Messaging>();
final Status _status = getIt<Status>();
final SentryServiceInterface _sentry = getIt<SentryServiceInterface>();
final Device _device = getIt<Device>();

final PayStackServiceInterface _payStack = getIt<PayStackServiceInterface>();
final HttpClientInterface _http = getIt<HttpClientInterface>();
final RealmViaHttp _ht = getIt<RealmViaHttp>();
final RealmViaHttp _realmHttp = getIt<RealmViaHttp>();

final SupabaseInterface _supa = getIt<SupabaseInterface>();
final Crash _crash = getIt<Crash>();

final FlipperInterface _localRealm = getIt<FlipperInterface>();

abstract class ProxyService {
  static final FlipperInterfaceCapella _capela =
      getIt<FlipperInterfaceCapella>(instanceName: 'capella');

  static final FlipperInterfaceCapella _synchronize =
      getIt<FlipperInterfaceCapella>(instanceName: 'backup');

  static final SyncStrategy _strategy =
      getIt<SyncStrategy>(instanceName: 'strategy');

  static FlipperInterfaceCapella get backUp => _synchronize;
  static FlipperInterfaceCapella get capela => _capela;
  static FlipperInterface get local => _localRealm;

  static FlipperInterfaceCapella get strategy => _strategy.current;
  static void setStrategy(Strategy strategy) => _strategy.setStrategy(strategy);


  static Crash get crash => _crash;
  static SupabaseInterface get supa => _supa;

  static LocalStorage get box => _box;
  static HttpClientInterface get http => _http;
  static RealmViaHttp get ht => _ht;
  static Api get api => _apiService;
  static TaxApi get tax => _tax;

  static EventInterface get event => _event;

  static Shareable get share => _share;
  static DynamicLink get dynamicLink => _dynamicLink;
  static FlipperLocation get location => _location;

  static AppService get app => _app;
  static ProductService get productService => _productService;
  static UploadT get upload => _upload;
  static KeyPadService get keypad => _keypad;
  static Country get country => _country;
  static Language get locale => _locale;
  static Remote get remoteConfig => _remoteConfig;
  static Analytic get analytics => _analytics;
  static SettingsService get settings => _settings;
  static CronService get cron => _reportService;
  static Printer get printer => _printService;
  static ForceDataEntryService get forceDateEntry => _forceDataEntry;
  static LNotification get notification => _notification;
  static Review get review => _review;
  static Sync get sync => _syncApi;
  static SystemTime get systemTime => _systemTime;
  static BillingService get billing => _billingService;
  static WhatsApp get whatsApp => _whatsApp;
  static Messaging get messaging => _messaging;
  static Status get status => _status;
  static SentryServiceInterface get sentry => _sentry;
  static Device get device => _device;
  static NotificationStream get notie => NotificationStream();

  static PayStackServiceInterface get payStack => _payStack;
  static RealmViaHttp get realmHttp => _realmHttp;
}
