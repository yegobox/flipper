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

  String get logOut => _localizations.logOut;

  String get syncCounter => _localizations.syncCounter;

  String get resetTransaction => _localizations.resetTransaction;

  String get resetTransactionQuestion =>
      _localizations.resetTransactionQuestion;

  String get resetTransactionDescription =>
      _localizations.resetTransactionDescription;

  String get transactionResetSuccessfully =>
      _localizations.transactionResetSuccessfully;

  String errorResettingTransaction(Object error) =>
      _localizations.errorResettingTransaction(error);

  String get selectedContactHasNoPhoneNumber =>
      _localizations.selectedContactHasNoPhoneNumber;

  String get contactsPermissionRequired =>
      _localizations.contactsPermissionRequired;

  String get permissionRequired => _localizations.permissionRequired;

  String get contactsPermissionDeniedSettings =>
      _localizations.contactsPermissionDeniedSettings;

  String get cancel => _localizations.cancel;

  String get openSettings => _localizations.openSettings;

  String errorMessage(Object error) => _localizations.errorMessage(error);

  String get error => _localizations.error;

  String get pickFromContacts => _localizations.pickFromContacts;

  String get linkDevice => _localizations.linkDevice;

  String get useFlipperOnOtherDevices =>
      _localizations.useFlipperOnOtherDevices;

  String get linkADevice => _localizations.linkADevice;

  String pinCode(Object pin) => _localizations.pinCode(pin);

  String get listOfConnectedDevices => _localizations.listOfConnectedDevices;

  String paymentTitle(Object paymentType) =>
      _localizations.paymentTitle(paymentType);

  String get digitalReceipt => _localizations.digitalReceipt;

  String get needDigitalReceipt => _localizations.needDigitalReceipt;

  String get purchaseCode => _localizations.purchaseCode;

  String get pleaseEnterPurchaseCode => _localizations.pleaseEnterPurchaseCode;

  String get submit => _localizations.submit;

  String get done => _localizations.done;

  String get receipt => _localizations.receipt;

  String get addNote => _localizations.addNote;

  String get generatingReceiptWait => _localizations.generatingReceiptWait;

  String get poweredBy => _localizations.poweredBy;

  String get returnToHome => _localizations.returnToHome;

  String get personalGoals => _localizations.personalGoals;

  String get selectBranchToManageGoals =>
      _localizations.selectBranchToManageGoals;

  String couldNotLoadGoals(Object error) =>
      _localizations.couldNotLoadGoals(error);

  String get personalGoalsEyebrow => _localizations.personalGoalsEyebrow;

  String totalReservedAcrossGoals(int count) =>
      _localizations.totalReservedAcrossGoals(count);

  String get savedThisMonth => _localizations.savedThisMonth;

  String onTrackCount(Object count) => _localizations.onTrackCount(count);

  String get goalsProgressing => _localizations.goalsProgressing;

  String get allGoals => _localizations.allGoals;

  String get personalGoalsProfitGrowth =>
      _localizations.personalGoalsProfitGrowth;

  String get searchProducts => _localizations.searchProducts;

  String get clearSelection => _localizations.clearSelection;

  String itemsSelected(int count) => _localizations.itemsSelected(count);

  String get cannotDeleteVariantWithStockRemaining =>
      _localizations.cannotDeleteVariantWithStockRemaining;

  String get deleteMultipleItems => _localizations.deleteMultipleItems;

  String deleteItemsConfirmation(int count) =>
      _localizations.deleteItemsConfirmation(count);

  String get refreshProducts => _localizations.refreshProducts;

  String get productsSyncingHint => _localizations.productsSyncingHint;

  String get errorLoadingProducts => _localizations.errorLoadingProducts;

  String get retry => _localizations.retry;

  String get noStockDataAvailable => _localizations.noStockDataAvailable;

  String get cash => _localizations.cash;

  String get credit => _localizations.credit;

  String get momoPayerPhone => _localizations.momoPayerPhone;

  String get momoPaymentRequestHint => _localizations.momoPaymentRequestHint;

  String get exact => _localizations.exact;
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
