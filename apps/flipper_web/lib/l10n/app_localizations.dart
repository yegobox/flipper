import 'dart:async';

import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_sw.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('sw'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Flipper'**
  String get appTitle;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Dashboard page title
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language selection label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Welcome message on dashboard
  ///
  /// In en, this message translates to:
  /// **'Welcome to your Dashboard!'**
  String get welcomeToDashboard;

  /// Pricing navigation item
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get pricing;

  /// Blog navigation item
  ///
  /// In en, this message translates to:
  /// **'Blog'**
  String get blog;

  /// About navigation item
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Download navigation item
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// Help navigation item
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// Sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// Hero section main title
  ///
  /// In en, this message translates to:
  /// **'Safe home\nfor your business'**
  String get heroTitle;

  /// Hero section subtitle
  ///
  /// In en, this message translates to:
  /// **'Private by default. Works everywhere. Ready for business.'**
  String get heroSubtitle;

  /// Pricing section title
  ///
  /// In en, this message translates to:
  /// **'Simple, transparent pricing'**
  String get pricingTitle;

  /// Pricing section subtitle
  ///
  /// In en, this message translates to:
  /// **'Choose the plan that works best for you'**
  String get pricingSubtitle;

  /// Mobile plan name
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get planMobile;

  /// Mobile + Desktop plan name
  ///
  /// In en, this message translates to:
  /// **'Mobile + Desktop'**
  String get planMobileDesktop;

  /// Enterprise plan name
  ///
  /// In en, this message translates to:
  /// **'Enterprise'**
  String get planEnterprise;

  /// Mobile plan price
  ///
  /// In en, this message translates to:
  /// **'5,000'**
  String get priceMobile;

  /// Mobile + Desktop plan price
  ///
  /// In en, this message translates to:
  /// **'120,000'**
  String get priceMobileDesktop;

  /// Enterprise plan price
  ///
  /// In en, this message translates to:
  /// **'1,500,000+'**
  String get priceEnterprise;

  /// Currency per month suffix
  ///
  /// In en, this message translates to:
  /// **'RWF/month'**
  String get currencyPerMonth;

  /// Mobile plan feature
  ///
  /// In en, this message translates to:
  /// **'Mobile app access'**
  String get featureMobileAppAccess;

  /// Mobile plan feature
  ///
  /// In en, this message translates to:
  /// **'Basic business tools'**
  String get featureBasicBusinessTools;

  /// Mobile plan feature
  ///
  /// In en, this message translates to:
  /// **'Data encryption'**
  String get featureDataEncryption;

  /// Mobile plan feature
  ///
  /// In en, this message translates to:
  /// **'Single device'**
  String get featureSingleDevice;

  /// Mobile plan tax reporting feature
  ///
  /// In en, this message translates to:
  /// **'+ Tax reporting (+30,000 RWF)'**
  String get featureTaxReportingMobile;

  /// Mobile + Desktop plan feature
  ///
  /// In en, this message translates to:
  /// **'Mobile + Desktop app access'**
  String get featureMobileDesktopAppAccess;

  /// Mobile + Desktop plan feature
  ///
  /// In en, this message translates to:
  /// **'Advanced business tools'**
  String get featureAdvancedBusinessTools;

  /// Mobile + Desktop plan feature
  ///
  /// In en, this message translates to:
  /// **'Cloud sync'**
  String get featureCloudSync;

  /// Mobile + Desktop plan feature
  ///
  /// In en, this message translates to:
  /// **'Multi-device support'**
  String get featureMultiDeviceSupport;

  /// Mobile + Desktop plan tax reporting feature
  ///
  /// In en, this message translates to:
  /// **'+ Tax reporting (+30,000 RWF)'**
  String get featureTaxReportingDesktop;

  /// Enterprise plan feature
  ///
  /// In en, this message translates to:
  /// **'Full platform access'**
  String get featureFullPlatformAccess;

  /// Enterprise plan feature
  ///
  /// In en, this message translates to:
  /// **'Custom integrations'**
  String get featureCustomIntegrations;

  /// Enterprise plan feature
  ///
  /// In en, this message translates to:
  /// **'Priority support'**
  String get featurePrioritySupport;

  /// Enterprise plan feature
  ///
  /// In en, this message translates to:
  /// **'Advanced analytics'**
  String get featureAdvancedAnalytics;

  /// Enterprise plan unlimited branches feature
  ///
  /// In en, this message translates to:
  /// **'+ Unlimited branches (+600,000 RWF)'**
  String get featureUnlimitedBranches;

  /// Mobile + Desktop plan feature
  ///
  /// In en, this message translates to:
  /// **'Military-grade encryption'**
  String get featureMilitaryGradeEncryption;

  /// Mobile + Desktop plan feature
  ///
  /// In en, this message translates to:
  /// **'Multiple devices'**
  String get featureMultipleDevices;

  /// Enterprise plan feature
  ///
  /// In en, this message translates to:
  /// **'Enterprise-grade security'**
  String get featureEnterpriseGradeSecurity;

  /// Enterprise plan feature
  ///
  /// In en, this message translates to:
  /// **'24/7 dedicated support'**
  String get feature247DedicatedSupport;

  /// Enterprise plan feature
  ///
  /// In en, this message translates to:
  /// **'Unlimited users & branches'**
  String get featureUnlimitedUsersBranches;

  /// Enterprise plan extra support feature
  ///
  /// In en, this message translates to:
  /// **'+ Extra support (+800,000 RWF)'**
  String get featureExtraSupport;

  /// Enterprise plan premium tax consulting feature
  ///
  /// In en, this message translates to:
  /// **'+ Premium tax consulting (+400,000 RWF)'**
  String get featurePremiumTaxConsulting;

  /// Most popular badge text
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get mostPopular;

  /// Get started button text
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr', 'sw'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'sw':
      return AppLocalizationsSw();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
