import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'flipper_app_localizations_en.dart';
import 'flipper_app_localizations_fr.dart';
import 'flipper_app_localizations_rw.dart';
import 'flipper_app_localizations_sw.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of FlipperAppLocalizations
/// returned by `FlipperAppLocalizations.of(context)`.
///
/// Applications need to include `FlipperAppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/flipper_app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
///   supportedLocales: FlipperAppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the FlipperAppLocalizations.supportedLocales
/// property.
abstract class FlipperAppLocalizations {
  FlipperAppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static FlipperAppLocalizations of(BuildContext context) {
    return Localizations.of<FlipperAppLocalizations>(
      context,
      FlipperAppLocalizations,
    )!;
  }

  static const LocalizationsDelegate<FlipperAppLocalizations> delegate =
      _FlipperAppLocalizationsDelegate();

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
    Locale('rw'),
    Locale('sw'),
  ];

  /// The save message
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// The price
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get retailPrice;

  /// Supplier price
  ///
  /// In en, this message translates to:
  /// **'Supplier price'**
  String get supplyPrice;

  /// Current Sale
  ///
  /// In en, this message translates to:
  /// **'Current Sale'**
  String get currentSale;

  /// Current Stock
  ///
  /// In en, this message translates to:
  /// **'Current Stock'**
  String get currentStock;

  /// Add Product
  ///
  /// In en, this message translates to:
  /// **'Add Products'**
  String get addProduct;

  /// The Tickets
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get tickets;

  /// Charge the user for the amount
  ///
  /// In en, this message translates to:
  /// **'Charge'**
  String get charge;

  /// The Name of the product
  ///
  /// In en, this message translates to:
  /// **'Name of the product'**
  String get productName;

  /// The Settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get flipperSetting;

  /// The options
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// can not save the tickets without adding a note to ticket
  ///
  /// In en, this message translates to:
  /// **'you can not save the tickets without adding a note to ticket'**
  String get saveTicket;

  /// Product not found
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get productNotFound;

  /// No payable
  ///
  /// In en, this message translates to:
  /// **'No payable'**
  String get noPayable;

  /// Delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Ongeraho kuri menu
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get addTomenu;

  /// Ongeraho kuri menu
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Add WorkSpace
  ///
  /// In en, this message translates to:
  /// **'Add WorkSpace'**
  String get addWorkSpace;

  /// Add Members
  ///
  /// In en, this message translates to:
  /// **'Add Members'**
  String get addMembers;
}

class _FlipperAppLocalizationsDelegate
    extends LocalizationsDelegate<FlipperAppLocalizations> {
  const _FlipperAppLocalizationsDelegate();

  @override
  Future<FlipperAppLocalizations> load(Locale locale) {
    return SynchronousFuture<FlipperAppLocalizations>(
      lookupFlipperAppLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr', 'rw', 'sw'].contains(locale.languageCode);

  @override
  bool shouldReload(_FlipperAppLocalizationsDelegate old) => false;
}

FlipperAppLocalizations lookupFlipperAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return FlipperAppLocalizationsEn();
    case 'fr':
      return FlipperAppLocalizationsFr();
    case 'rw':
      return FlipperAppLocalizationsRw();
    case 'sw':
      return FlipperAppLocalizationsSw();
  }

  throw FlutterError(
    'FlipperAppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
