import 'package:flutter/material.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flipper_localize/src/l10n/flipper_app_localizations.dart';

export 'src/l10n/flipper_app_localizations.dart';

extension FlipperLocalizationContext on BuildContext {
  FlipperAppLocalizations get flipperL10n => FlipperAppLocalizations.of(this);
}

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

  String get confirm => _localizations.confirm;

  String get numberOfPayments => _localizations.numberOfPayments;

  String get applyDiscountCode => _localizations.applyDiscountCode;

  String get discountCode => _localizations.discountCode;

  String get validatingCode => _localizations.validatingCode;

  String get createAccount => _localizations.createAccount;

  String get signIn => _localizations.signIn;

  String get setDeviceTimeAutomatic => _localizations.setDeviceTimeAutomatic;

  String get continueWithPhone => _localizations.continueWithPhone;

  String get continueWithGoogle => _localizations.continueWithGoogle;

  String get continueWithMicrosoft => _localizations.continueWithMicrosoft;

  String get continueWithApple => _localizations.continueWithApple;

  String get or => _localizations.or;

  String get pinLogin => _localizations.pinLogin;

  String get languagesTitle => _localizations.languagesTitle;

  String get english => _localizations.english;

  String get kinyarwanda => _localizations.kinyarwanda;

  String get swahili => _localizations.swahili;

  String get settings => _localizations.settings;

  String get home => _localizations.home;

  String get sales => _localizations.sales;

  String get inventory => _localizations.inventory;

  String get more => _localizations.more;

  String get scanQr => _localizations.scanQr;

  String get dashboard => _localizations.dashboard;

  String get noUser => _localizations.noUser;

  String get pleaseLogInToContinue => _localizations.pleaseLogInToContinue;

  String get loadingBusinesses => _localizations.loadingBusinesses;

  String get errorLoadingBusinesses => _localizations.errorLoadingBusinesses;

  String get noBusinesses => _localizations.noBusinesses;

  String get createFirstBusiness => _localizations.createFirstBusiness;

  String get signOut => _localizations.signOut;

  String get phoneNumber => _localizations.phoneNumber;

  String get sendingCode => _localizations.sendingCode;

  String get continueAction => _localizations.continueAction;

  String get enterSixDigitCodeSentTo => _localizations.enterSixDigitCodeSentTo;

  String get codeExpiredTapToResend => _localizations.codeExpiredTapToResend;

  String get resendCode => _localizations.resendCode;

  String get resendCodeIn => _localizations.resendCodeIn;

  String get seconds => _localizations.seconds;

  String get verifying => _localizations.verifying;

  String get verifyCode => _localizations.verifyCode;

  String get troubleSigningIn => _localizations.troubleSigningIn;

  String get troubleSigningInHelp => _localizations.troubleSigningInHelp;

  String get ok => _localizations.ok;

  String get welcomeBack => _localizations.welcomeBack;

  String get tinNumber => _localizations.tinNumber;

  String get validate => _localizations.validate;

  String get uploadPdfWithTin => _localizations.uploadPdfWithTin;

  String get enterTinOrUpload => _localizations.enterTinOrUpload;

  String get addEmail => _localizations.addEmail;

  String get emailAdded => _localizations.emailAdded;

  String get updateSettings => _localizations.updateSettings;

  String get invite => _localizations.invite;

  String get sendRequest => _localizations.sendRequest;

  String get preferences => _localizations.preferences;

  String get accessibility => _localizations.accessibility;

  String get language => _localizations.language;

  String get reports => _localizations.reports;

  String get enableReport => _localizations.enableReport;

  String get backups => _localizations.backups;

  String get addBackup => _localizations.addBackup;

  String get restoreData => _localizations.restoreData;

  String get dataRestored => _localizations.dataRestored;

  String get errorRestoringBackup => _localizations.errorRestoringBackup;
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
