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

abstract class ProxyService {
  /// A settable link to the sync strategy implementation.
  /// In production, this is initialized with the real `SyncStrategy` from `getIt`.
  /// In tests, this can be replaced with a mock `SyncStrategy`.
  static SyncStrategy strategyLink =
      getIt<SyncStrategy>(instanceName: 'strategy');

  /// Provides access to the current database implementation (e.g., Isar, Realm).
  static DatabaseSyncInterface get strategy => strategyLink.current;

  /// Sets the desired database strategy (e.g., Isar, Realm).
  static void setStrategy(Strategy strategy) =>
      strategyLink.setStrategy(strategy);

  static Crash crash = getIt<Crash>();
  static SupabaseInterface supa = getIt<SupabaseInterface>();
  static LocalStorage box = getIt<LocalStorage>();
  static HttpClientInterface http = getIt<HttpClientInterface>();
  static HttpApiInterface ht = getIt<HttpApiInterface>();
  static Api api = getIt<Api>();
  static TaxApi tax = getIt<TaxApi>();
  static EventInterface event = getIt<EventInterface>();
  static Shareable share = getIt<Shareable>();
  static DynamicLink dynamicLink = getIt<DynamicLink>();
  static FlipperLocation location = getIt<FlipperLocation>();
  static AppService app = getIt<AppService>();
  static ProductService productService = getIt<ProductService>();
  static UploadT upload = getIt<UploadT>();
  static KeyPadService keypad = getIt<KeyPadService>();
  static Country country = getIt<Country>();
  static Language locale = getIt<Language>();
  static Remote remoteConfig = getIt<Remote>();
  static Analytic analytics = getIt<Analytic>();
  static SettingsService settings = getIt<SettingsService>();
  static CronService cron = getIt<CronService>();
  static Printer printer = getIt<Printer>();
  static ForceDataEntryService forceDateEntry = getIt<ForceDataEntryService>();
  static LNotification notification = getIt<LNotification>();
  static Review review = getIt<Review>();
  static Sync sync = getIt<Sync>();
  static SystemTime systemTime = getIt<SystemTime>();
  static BillingService billing = getIt<BillingService>();
  static WhatsApp whatsApp = getIt<WhatsApp>();
  static Messaging messaging = getIt<Messaging>();
  static Status status = getIt<Status>();
  static SentryServiceInterface sentry = getIt<SentryServiceInterface>();
  static Device device = getIt<Device>();
  static NotificationStream notie = NotificationStream();
  static PayStackServiceInterface payStack = getIt<PayStackServiceInterface>();
  static HttpApiInterface httpApi = getIt<HttpApiInterface>();
}
