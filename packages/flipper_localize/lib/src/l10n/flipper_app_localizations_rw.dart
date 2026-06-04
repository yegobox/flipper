// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'flipper_app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kinyarwanda (`rw`).
class FlipperAppLocalizationsRw extends FlipperAppLocalizations {
  FlipperAppLocalizationsRw([String locale = 'rw']) : super(locale);

  @override
  String get save => 'Bika';

  @override
  String get retailPrice => 'Igiciro';

  @override
  String get supplyPrice => 'Ikiranguzo';

  @override
  String get currentSale => 'Igurishwa ryubu';

  @override
  String get currentStock => 'Ububiko buriho';

  @override
  String get addProduct => 'Ongeramo ibicuruzwa';

  @override
  String get tickets => 'Amatike';

  @override
  String get charge => 'Kwishyuza';

  @override
  String get productName => 'Izina ry\'igicuruzwa';

  @override
  String get flipperSetting => 'Igenamiterere';

  @override
  String get options => 'Amahitamo';

  @override
  String get saveTicket => 'Ntushobora kubika itike utongeyeho inyandiko';

  @override
  String get productNotFound => 'Igicuruzwa ntikibonetse';

  @override
  String get noPayable => 'Nta byo kwishyuzwa bihari';

  @override
  String get delete => 'Siba';

  @override
  String get addTomenu => 'Menu';

  @override
  String get edit => 'Hindura';

  @override
  String get addWorkSpace => 'Ongeramo aho gukorera';

  @override
  String get addMembers => 'Ongeramo abanyamuryango';

  @override
  String get logOut => 'Sohoka';

  @override
  String get syncCounter => 'Huza kontwa';

  @override
  String get resetTransaction => 'Subizaho igurisha';

  @override
  String get resetTransactionQuestion => 'Subizaho igurisha?';

  @override
  String get resetTransactionDescription =>
      'Ibi bizasiba igurisha ritegereje n\'ibicuruzwa byaryo byose. Iki gikorwa ntigisubizwa inyuma.';

  @override
  String get transactionResetSuccessfully => 'Igurisha ryasubijweho neza';

  @override
  String errorResettingTransaction(Object error) {
    return 'Habaye ikosa mu gusubizaho igurisha: $error';
  }

  @override
  String get selectedContactHasNoPhoneNumber =>
      'Kontaki wahisemo nta nimero ya telefoni ifite';

  @override
  String get contactsPermissionRequired =>
      'Uruhushya rwo kureba kontaki rurakenewe kugira ngo uhitemo kontaki';

  @override
  String get permissionRequired => 'Uruhushya rurakenewe';

  @override
  String get contactsPermissionDeniedSettings =>
      'Uruhushya rwo kureba kontaki rwanze burundu. Rubashe mu igenamiterere ry\'igikoresho cyawe kugira ngo ukoreshe iki gikorwa.';

  @override
  String get cancel => 'Kureka';

  @override
  String get openSettings => 'Fungura igenamiterere';

  @override
  String errorMessage(Object error) {
    return 'Ikosa: $error';
  }

  @override
  String get error => 'Error';

  @override
  String get pickFromContacts => 'Hitamo muri kontaki';

  @override
  String get linkDevice => 'Huza igikoresho';

  @override
  String get useFlipperOnOtherDevices => 'Koresha Flipper ku bindi bikoresho';

  @override
  String get linkADevice => 'Huza igikoresho';

  @override
  String pinCode(Object pin) {
    return 'PIN: $pin';
  }

  @override
  String get listOfConnectedDevices => 'Urutonde rw\'ibikoresho byahujwe';

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
