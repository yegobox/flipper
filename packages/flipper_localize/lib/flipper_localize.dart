import 'package:flutter/material.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flipper_localize/src/l10n/flipper_app_localizations.dart';

export 'src/l10n/flipper_app_localizations.dart';

class LabelOverrides extends DefaultLocalizations {
  const LabelOverrides();

  @override
  String get emailInputLabel => 'Enter your email';

  @override
  String get passwordInputLabel => 'Enter your password';
}

class FLocalization {
  const FLocalization._(this._localizations);

  final FlipperAppLocalizations _localizations;

  static FLocalization of(BuildContext context) {
    final localizations = FlipperAppLocalizations.of(context);
    return FLocalization._(localizations);
  }

  static List<String> languages() =>
      FlipperAppLocalizations.supportedLocales.map((locale) {
        return locale.languageCode;
      }).toList();

  String get supplyPrice => _localizations.supplyPrice;

  String get currentSale => _localizations.currentSale;

  String get currentStock => _localizations.currentStock;

  String get addProduct => _localizations.addProduct;

  String get tickets => _localizations.tickets;

  String get charge => _localizations.charge;

  String get flipperSetting => _localizations.flipperSetting;

  String get options => _localizations.options;

  String get saveTicket => _localizations.saveTicket;

  String get productNotFound => _localizations.productNotFound;

  String get noPayable => _localizations.noPayable;

  String get delete => _localizations.delete;

  String get addTomenu => _localizations.addTomenu;

  String get edit => _localizations.edit;

  String get addWorkSpace => _localizations.addWorkSpace;

  String get addMembers => _localizations.addMembers;

  String get retailPrice => _localizations.retailPrice;

  String get save => _localizations.save;

  String get productName => _localizations.productName;
}

class FlipperLocalizationsDelegate
    extends LocalizationsDelegate<FlipperAppLocalizations> {
  const FlipperLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      FlipperAppLocalizations.delegate.isSupported(locale);

  @override
  Future<FlipperAppLocalizations> load(Locale locale) {
    return FlipperAppLocalizations.delegate.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate old) => false;
}

class FlipperLocalizationDelegates {
  const FlipperLocalizationDelegates._();

  static const List<LocalizationsDelegate<dynamic>> delegates = [
    FlipperLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales =
      FlipperAppLocalizations.supportedLocales;
}
