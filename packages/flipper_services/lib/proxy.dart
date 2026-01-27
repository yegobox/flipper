import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/Supabase.dart';
import 'package:flipper_models/flipper_http_client.dart';
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
import 'package:supabase_models/brick/repository/storage.dart';
import 'DeviceIdService.dart';
import 'abstractions/api.dart';
import 'abstractions/dynamic_link.dart';
import 'abstractions/location.dart';
import 'abstractions/shareable.dart';
import 'abstractions/upload.dart';
import 'country_service.dart';
import 'firebase_messaging.dart';
import 'locator.dart';
import 'product_service.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:flipper_web/services/ditto_service.dart';

abstract class ProxyService {
  /// A settable link to the sync strategy implementation.
  /// In production, this is initialized with the real `SyncStrategy` from `getIt`.
  /// In tests, this can be replaced with a mock `SyncStrategy`.
  static SyncStrategy get strategyLink =>
      getIt<SyncStrategy>(instanceName: 'strategy');

  /// Provides access to the current database implementation (e.g., Isar, Realm).
  static DatabaseSyncInterface get strategy => strategyLink.current;

  /// Provides access to a specific database implementation strategy.
  static DatabaseSyncInterface getStrategy([Strategy? strategy]) =>
      strategyLink.getStrategy(strategy);

  /// Sets the desired database strategy (e.g., Isar, Realm).
  static void setStrategy(Strategy strategy) =>
      strategyLink.setStrategy(strategy);

  static Crash get crash => getIt<Crash>();
  static SupabaseInterface get supa => getIt<SupabaseInterface>();
  static LocalStorage get box => getIt<LocalStorage>();
  static HttpClientInterface get http => getIt<HttpClientInterface>();
  static HttpApiInterface get ht => getIt<HttpApiInterface>();
  static Api get api => getIt<Api>();
  static TaxApi get tax => getIt<TaxApi>();
  static EventInterface get event => getIt<EventInterface>();
  static Shareable get share => getIt<Shareable>();
  static DynamicLink get dynamicLink => getIt<DynamicLink>();
  static FlipperLocation get location => getIt<FlipperLocation>();
  static AppService get app => getIt<AppService>();
  static ProductService get productService => getIt<ProductService>();
  static UploadT get upload => getIt<UploadT>();
  static KeyPadService get keypad => getIt<KeyPadService>();
  static Country get country => getIt<Country>();
  static Language get locale => getIt<Language>();
  static Remote get remoteConfig => getIt<Remote>();
  static Analytic get analytics => getIt<Analytic>();
  static SettingsService get settings => getIt<SettingsService>();
  static CronService get cron => getIt<CronService>();
  static Printer get printer => getIt<Printer>();
  static ForceDataEntryService get forceDateEntry =>
      getIt<ForceDataEntryService>();
  static LNotification get notification => getIt<LNotification>();
  static Review get review => getIt<Review>();
  static Sync get sync => getIt<Sync>();
  static SystemTime get systemTime => getIt<SystemTime>();
  static BillingService get billing => getIt<BillingService>();
  static WhatsApp get whatsApp => getIt<WhatsApp>();
  static Messaging get messaging => getIt<Messaging>();
  static Status get status => getIt<Status>();
  static SentryServiceInterface get sentry => getIt<SentryServiceInterface>();
  static Device get device => getIt<Device>();
  static NotificationStream get notie => _notie;
  static final NotificationStream _notie = NotificationStream();
  static PayStackServiceInterface get payStack =>
      getIt<PayStackServiceInterface>();
  static HttpApiInterface get httpApi => getIt<HttpApiInterface>();
  static DittoService get ditto => DittoService.instance;
}
