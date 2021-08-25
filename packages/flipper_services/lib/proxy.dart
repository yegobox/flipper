import 'package:flipper_services/FirebaseCrashlyticService.dart';
import 'package:flipper_services/abstractions/analytic.dart';
import 'package:flipper_services/abstractions/platform.dart';
import 'package:flipper_services/abstractions/printer.dart';
import 'package:flipper_services/abstractions/remote.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/force_data_service.dart';
import 'package:flipper_services/in_app_review.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/firestore_api.dart';
import 'package:flipper_services/language_service.dart';
import 'package:flipper_services/local_notification_service.dart';
import 'package:flipper_services/pdf_api.dart';
import 'package:flipper_services/pdf_invoice_api.dart';
import 'package:flipper_services/cron_service.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/analytic_service.dart';
import 'package:universal_platform/universal_platform.dart';
import 'abstractions/api.dart';
import 'abstractions/dynamic_link.dart';
import 'abstractions/location.dart';
import 'abstractions/share.dart';
import 'abstractions/storage.dart';
import 'abstractions/upload.dart';
import 'locator.dart';
import 'product_service.dart';

final isWindows = UniversalPlatform.isWindows;

final Api _apiService = locator<Api>();
final DynamicLink _dynamicLink = locator<DynamicLink>();
final Shareble _share = locator<Shareble>();
final NavigationService _nav = locator<NavigationService>();
final LoginStandard _auth = locator<LoginStandard>();
final FlipperLocation _location = locator<FlipperLocation>();
// final DB<Business> _db = locator<DB<Business>>();
final LocalStorage _box = locator<LocalStorage>();
final UploadT _upload = locator<UploadT>();
final AppService _appService = locator<AppService>();
final AnalyticService _analytic = locator<AnalyticService>();
final ProductService _productService = locator<ProductService>();
final KeyPadService _keypad = locator<KeyPadService>();
final LanguageService _locale = locator<LanguageService>();
// LanguageService
final Remote _remoteConfig = locator<Remote>();
final SettingsService _settings = locator<SettingsService>();
final CronService _reportService = locator<CronService>();
final PdfInvoiceApi _pdfInvoiceApi = locator<PdfInvoiceApi>();
final PdfApi _pdfApi = locator<PdfApi>();
final Printer _printService = locator<Printer>();
//rename this to app analytics, i.e analytics for app improvments
final Analytic _analytics = locator<Analytic>();
final ForceDataEntryService _forceDataEntry = locator<ForceDataEntryService>();
final Crash _crash = locator<Crash>();
final LNotification _notification = locator<LNotification>();
final Firestore _firestore = locator<Firestore>();
final Review _review = locator<Review>();

abstract class ProxyService {
  static Api get api => _apiService;
  static Crash get crash => _crash;
  static Shareble get share => _share;
  static DynamicLink get dynamicLink => _dynamicLink;
  static NavigationService get nav => _nav;
  static FlipperLocation get location => _location;
  static LocalStorage get box => _box;
  static LoginStandard get auth => _auth;
  static AppService get appService => _appService;
  static ProductService get productService => _productService;
  static UploadT get upload => _upload;
  static KeyPadService get keypad => _keypad;
  static LanguageService get locale => _locale;
  static Remote get remoteConfig => _remoteConfig;
  static Analytic get analytics => _analytics;
  static SettingsService get settings => _settings;
  static CronService get cron => _reportService;
  static PdfInvoiceApi get pdfInvoice => _pdfInvoiceApi;
  static PdfApi get pdfApi => _pdfApi;
  static Printer get printer => _printService;
  static ForceDataEntryService get forceDateEntry => _forceDataEntry;
  static LNotification get notification => _notification;
  static Firestore get firestore => _firestore;
  static Review get review => _review;
  static AnalyticService get analytic => _analytic;
  // _analytic
}
