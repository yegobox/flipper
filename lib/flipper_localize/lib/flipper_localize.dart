import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'dart:async';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';

class LabelOverrides extends DefaultLocalizations {
  const LabelOverrides();

  @override
  String get emailInputLabel => 'Enter your email';

  @override
  String get passwordInputLabel => 'Enter your password';
}

// TODOrefactor this codes to make more sense
class FLocalization {
  FLocalization(this.locale);

  final Locale locale;

  static FLocalization of(BuildContext context) {
    final myLocalizations =
        Localizations.of<FLocalization>(context, FLocalization);
    return myLocalizations ?? FLocalization(Locale("en"));
  }

  static const _productName = <String, Map<String, String>>{
    'en': {
      'productName': 'Name of the product',
    },
    'es': {
      'productName': 'Name of the product',
    },
  };
  static const _save = <String, Map<String, String>>{
    'en': {
      'save': 'Save',
    },
    'es': {
      'save': 'Save',
    },
  };
  static const _retailPrice = <String, Map<String, String>>{
    'en': {
      'retailPrice': 'Price',
    },
    'es': {
      'retailPrice': 'Price',
    },
  };
  static const _supplyPrice = <String, Map<String, String>>{
    'en': {
      'supplyPrice': 'Supplier Price',
    },
    'es': {
      'supplyPrice': 'Supplier Price',
    },
  };
  static const _currentSale = <String, Map<String, String>>{
    'en': {
      'currentSale': 'Current Sale',
    },
    'es': {
      'currentSale': 'Current Sale',
    },
  };

  static const _currentStock = <String, Map<String, String>>{
    'en': {
      'currentStock': 'Current Stock',
    },
    'es': {
      'currentStock': 'Current Stock',
    },
  };
  static const _addProduct = <String, Map<String, String>>{
    'en': {
      'addProduct': 'Add Product',
    },
    'es': {
      'addProduct': 'Add Product',
    },
  };
  static const _ticket = <String, Map<String, String>>{
    'en': {
      'tickets': 'Tickets',
    },
    'es': {
      'tickets': 'Tickets',
    },
  };
  static const _charge = <String, Map<String, String>>{
    'en': {
      'charge': 'Charge',
    },
    'es': {
      'charge': 'Charge',
    },
  };
  static const _flipperSetting = <String, Map<String, String>>{
    'en': {
      'flipperSetting': 'Setting',
    },
    'es': {
      'flipperSetting': 'Setting',
    },
  };
  static const _options = <String, Map<String, String>>{
    'en': {
      'options': 'Options',
    },
    'es': {
      'options': 'Options',
    },
  };
  static const _saveTicket = <String, Map<String, String>>{
    'en': {
      'saveTicket': 'Save Ticket',
    },
    'es': {
      'saveTicket': 'Save Ticket',
    },
  };

  static const _noPayable = <String, Map<String, String>>{
    'en': {
      'noPayable': 'No payable',
    },
    'es': {
      'noPayable': 'No payable',
    },
  };
  static const _delete = <String, Map<String, String>>{
    'en': {
      'delete': 'Delete',
    },
    'es': {
      'delete': 'Delete',
    },
  };
  static const _addTomenu = <String, Map<String, String>>{
    'en': {
      'addTomenu': 'Menu',
    },
    'es': {
      'addTomenu': 'Menu',
    },
  };
  static const _edit = <String, Map<String, String>>{
    'en': {
      'edit': 'Edit',
    },
    'es': {
      'edit': 'Edit',
    },
  };
  static const _addWorkSpace = <String, Map<String, String>>{
    'en': {
      'addWorkSpace': 'Add WorkSpace',
    },
    'es': {
      'addWorkSpace': 'Add WorkSpace',
    },
  };
  static const _addMembers = <String, Map<String, String>>{
    'en': {
      'addMembers': 'Add Members',
    },
    'es': {
      'addMembers': 'Add Members',
    },
  };
  static List<String> languages() => _productName.keys.toList();

  String get supplyPrice => _supplyPrice[locale.languageCode]!['supplyPrice']!;

  String get currentSale => _currentSale[locale.languageCode]!['currentSale']!;

  String get currentStock =>
      _currentStock[locale.languageCode]!['currentStock']!;

  String get addProduct => _addProduct[locale.languageCode]!['addProduct']!;

  String get tickets => _ticket[locale.languageCode]!['tickets']!;

  String get charge => _charge[locale.languageCode]!['charge']!;

  String get flipperSetting =>
      _flipperSetting[locale.languageCode]!['flipperSetting']!;

  String get options => _options[locale.languageCode]!['options']!;

  String get saveTicket => _saveTicket[locale.languageCode]!['saveTicket']!;

  String get noPayable => _noPayable[locale.languageCode]!['noPayable']!;

  String get delete => _delete[locale.languageCode]!['delete']!;

  String get addTomenu => _addTomenu[locale.languageCode]!['addTomenu']!;

  String get edit => _edit[locale.languageCode]!['edit']!;

  String get addWorkSpace =>
      _addWorkSpace[locale.languageCode]!['addWorkSpace']!;

  String get addMembers => _addMembers[locale.languageCode]!['addMembers']!;

  String get retailPrice => _retailPrice[locale.languageCode]!['retailPrice']!;

  String get save => _save[locale.languageCode]!['save']!;

  String get productName => _productName[locale.languageCode]!['productName']!;
}

class FlipperLocalizationsDelegate
    extends LocalizationsDelegate<FLocalization> {
  const FlipperLocalizationsDelegate();

  // @override
  // bool isSupported(Locale locale) =>
  //     FLocalization.languages().contains(locale.languageCode);
  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<FLocalization> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<FLocalization>(FLocalization(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate old) => false;
}
