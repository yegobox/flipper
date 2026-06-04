// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'flipper_app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class FlipperAppLocalizationsSw extends FlipperAppLocalizations {
  FlipperAppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get save => 'Okoa';

  @override
  String get retailPrice => 'Retail price';

  @override
  String get supplyPrice => 'Supply Price';

  @override
  String get currentSale => 'Uujuzi wa sasa';

  @override
  String get currentStock => 'Hisa ya sasa';

  @override
  String get addProduct => 'Ongeza bidhaa';

  @override
  String get tickets => 'Tiketi';

  @override
  String get charge => 'Malipo';

  @override
  String get productName => 'Jina la bidhaa';

  @override
  String get flipperSetting => 'Mipangilio';

  @override
  String get options => 'Chaguzi';

  @override
  String get saveTicket =>
      'huwezi kuokoa tikiti bila kuongeza dokezo kwa tikiti';

  @override
  String get productNotFound => 'Bidhaa haijapatikana';

  @override
  String get noPayable => 'Hakuna malipo yoyote yanayopatikana';

  @override
  String get delete => 'Futa';

  @override
  String get addTomenu => 'Menu';

  @override
  String get edit => 'Edit';

  @override
  String get addWorkSpace => 'Add WorkSpace';

  @override
  String get addMembers => 'Add Members';

  @override
  String get logOut => 'Ondoka';

  @override
  String get syncCounter => 'Sawazisha kaunta';

  @override
  String get resetTransaction => 'Weka Muamala Upya';

  @override
  String get resetTransactionQuestion => 'Weka muamala upya?';

  @override
  String get resetTransactionDescription =>
      'Hii itafuta muamala unaosubiri na bidhaa zake zote. Kitendo hiki hakiwezi kutenduliwa.';

  @override
  String get transactionResetSuccessfully =>
      'Muamala umewekwa upya kwa mafanikio';

  @override
  String errorResettingTransaction(Object error) {
    return 'Hitilafu wakati wa kuweka muamala upya: $error';
  }

  @override
  String get selectedContactHasNoPhoneNumber =>
      'Anwani iliyochaguliwa haina nambari ya simu';

  @override
  String get contactsPermissionRequired =>
      'Ruhusa ya anwani inahitajika ili kuchagua anwani';

  @override
  String get permissionRequired => 'Ruhusa Inahitajika';

  @override
  String get contactsPermissionDeniedSettings =>
      'Ruhusa ya anwani imekataliwa kabisa. Tafadhali iwezeshe kwenye mipangilio ya kifaa chako ili kutumia kipengele hiki.';

  @override
  String get cancel => 'Ghairi';

  @override
  String get openSettings => 'Fungua Mipangilio';

  @override
  String errorMessage(Object error) {
    return 'Hitilafu: $error';
  }

  @override
  String get error => 'Error';

  @override
  String get pickFromContacts => 'Chagua kutoka kwa anwani';

  @override
  String get linkDevice => 'Unganisha Kifaa';

  @override
  String get useFlipperOnOtherDevices => 'Tumia Flipper kwenye vifaa vingine';

  @override
  String get linkADevice => 'Unganisha Kifaa';

  @override
  String pinCode(Object pin) {
    return 'PIN: $pin';
  }

  @override
  String get listOfConnectedDevices => 'Orodha ya vifaa vilivyounganishwa';

  @override
  String paymentTitle(Object paymentType) {
    return 'Payment: $paymentType';
  }

  @override
  String get digitalReceipt => 'Digital Receipt';

  @override
  String get needDigitalReceipt => 'Do you need a digital receipt?';

  @override
  String get purchaseCode => 'Purchase Code';

  @override
  String get pleaseEnterPurchaseCode => 'Please enter a purchase code';

  @override
  String get submit => 'Submit';

  @override
  String get done => 'Done';

  @override
  String get receipt => 'Receipt';

  @override
  String get addNote => 'Add Note';

  @override
  String get generatingReceiptWait =>
      'Please wait we are generating the receipt';

  @override
  String get poweredBy => 'Powered By';

  @override
  String get returnToHome => 'Return to Home';

  @override
  String get personalGoals => 'Personal goals';

  @override
  String get selectBranchToManageGoals => 'Select a branch to manage goals.';

  @override
  String couldNotLoadGoals(Object error) {
    return 'Could not load goals\n$error';
  }

  @override
  String get personalGoalsEyebrow => 'PERSONAL GOALS';

  @override
  String totalReservedAcrossGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count goals',
      one: '1 goal',
    );
    return 'Total reserved across $_temp0';
  }

  @override
  String get savedThisMonth => 'Saved this month';

  @override
  String onTrackCount(Object count) {
    return '$count on track';
  }

  @override
  String get goalsProgressing => 'Goals progressing';

  @override
  String get allGoals => 'All goals';

  @override
  String get personalGoalsProfitGrowth =>
      'Flipper quietly grows each goal from your profits.';

  @override
  String get searchProducts => 'Search products…';

  @override
  String get clearSelection => 'Clear selection';

  @override
  String itemsSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items selected',
      one: '1 item selected',
    );
    return '$_temp0';
  }

  @override
  String get cannotDeleteVariantWithStockRemaining =>
      'Cannot delete variant with stock remaining.';

  @override
  String get deleteMultipleItems => 'Delete Multiple Items';

  @override
  String deleteItemsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return 'Are you sure you want to delete $_temp0? This action cannot be undone.';
  }

  @override
  String get refreshProducts => 'Refresh products';

  @override
  String get productsSyncingHint =>
      'If you just opened the app, products may still be syncing — tap refresh.';

  @override
  String get errorLoadingProducts => 'Error loading products';

  @override
  String get retry => 'Retry';

  @override
  String get noStockDataAvailable => 'No stock data available';

  @override
  String get cash => 'Cash';

  @override
  String get credit => 'Credit';

  @override
  String get momoPayerPhone => 'MoMo payer phone';

  @override
  String get momoPaymentRequestHint =>
      'We will send a payment request to this number when you tap Charge.';

  @override
  String get exact => 'Exact';
}
