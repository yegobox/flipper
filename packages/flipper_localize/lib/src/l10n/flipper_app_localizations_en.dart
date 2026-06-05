// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'flipper_app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class FlipperAppLocalizationsEn extends FlipperAppLocalizations {
  FlipperAppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get save => 'Save';

  @override
  String get retailPrice => 'Price';

  @override
  String get supplyPrice => 'Supplier price';

  @override
  String get currentSale => 'Current Sale';

  @override
  String get currentStock => 'Current Stock';

  @override
  String get addProduct => 'Add Products';

  @override
  String get tickets => 'Tickets';

  @override
  String get charge => 'Charge';

  @override
  String get productName => 'Name of the product';

  @override
  String get flipperSetting => 'Settings';

  @override
  String get options => 'Options';

  @override
  String get saveTicket =>
      'you can not save the tickets without adding a note to ticket';

  @override
  String get productNotFound => 'Product not found';

  @override
  String get noPayable => 'No payable';

  @override
  String get delete => 'Delete';

  @override
  String get addTomenu => 'Menu';

  @override
  String get edit => 'Edit';

  @override
  String get addWorkSpace => 'Add WorkSpace';

  @override
  String get addMembers => 'Add Members';

  @override
  String get logOut => 'Log out';

  @override
  String get syncCounter => 'Sync counter';

  @override
  String get resetTransaction => 'Reset Transaction';

  @override
  String get resetTransactionQuestion => 'Reset Transaction?';

  @override
  String get resetTransactionDescription =>
      'This will delete the current pending transaction and all its items. This action cannot be undone.';

  @override
  String get transactionResetSuccessfully => 'Transaction reset successfully';

  @override
  String errorResettingTransaction(Object error) {
    return 'Error resetting transaction: $error';
  }

  @override
  String get selectedContactHasNoPhoneNumber =>
      'Selected contact has no phone number';

  @override
  String get contactsPermissionRequired =>
      'Contacts permission is required to pick a contact';

  @override
  String get permissionRequired => 'Permission Required';

  @override
  String get contactsPermissionDeniedSettings =>
      'Contacts permission has been permanently denied. Please enable it in your device settings to use this feature.';

  @override
  String get cancel => 'Cancel';

  @override
  String get openSettings => 'Open Settings';

  @override
  String errorMessage(Object error) {
    return 'Error: $error';
  }

  @override
  String get error => 'Error';

  @override
  String get pickFromContacts => 'Pick from contacts';

  @override
  String get linkDevice => 'Link Device';

  @override
  String get useFlipperOnOtherDevices => 'Use Flipper on other Devices';

  @override
  String get linkADevice => 'Link A Device';

  @override
  String pinCode(Object pin) {
    return 'PIN: $pin';
  }

  @override
  String get listOfConnectedDevices => 'List of connected Devices';

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

  @override
  String get confirm => 'Confirm';

  @override
  String get numberOfPayments => 'Number of Payments';

  @override
  String get applyDiscountCode => 'Apply Discount Code';

  @override
  String get discountCode => 'Discount Code';

  @override
  String get validatingCode => 'Validating code...';

  @override
  String get createAccount => 'Create Account';

  @override
  String get signIn => 'SIGN IN';

  @override
  String get setDeviceTimeAutomatic =>
      'Please set your device time to automatic';

  @override
  String get continueWithPhone => 'Continue with Phone';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithMicrosoft => 'Continue with Microsoft';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get or => 'OR';

  @override
  String get pinLogin => 'PIN Login';

  @override
  String get languagesTitle => 'Languages';

  @override
  String get english => 'English';

  @override
  String get kinyarwanda => 'Kinyarwanda';

  @override
  String get swahili => 'Swahili';

  @override
  String get settings => 'Settings';

  @override
  String get home => 'Home';

  @override
  String get sales => 'Sales';

  @override
  String get inventory => 'Inventory';

  @override
  String get more => 'More';

  @override
  String get scanQr => 'Scan QR';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get noUser => 'No User';

  @override
  String get pleaseLogInToContinue => 'Please log in to continue';

  @override
  String get loadingBusinesses => 'Loading businesses...';

  @override
  String get errorLoadingBusinesses => 'Error loading businesses';

  @override
  String get noBusinesses => 'No Businesses';

  @override
  String get createFirstBusiness => 'Create your first business to get started';

  @override
  String get signOut => 'Sign Out';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get sendingCode => 'Sending code...';

  @override
  String get continueAction => 'Continue';

  @override
  String get enterSixDigitCodeSentTo => 'Enter the 6-digit code sent to ';

  @override
  String get codeExpiredTapToResend => 'Code Expired - Tap to Resend';

  @override
  String get resendCode => 'Resend Code';

  @override
  String get resendCodeIn => 'Resend code in ';

  @override
  String get seconds => 'seconds';

  @override
  String get verifying => 'Verifying...';

  @override
  String get verifyCode => 'Verify Code';

  @override
  String get troubleSigningIn => 'Trouble Signing In?';

  @override
  String get troubleSigningInHelp =>
      'If you are having trouble signing in, please ensure your PIN and OTP (if applicable) are correct.\n\nFor further assistance, please contact support.';

  @override
  String get ok => 'OK';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get tinNumber => 'TIN Number';

  @override
  String get validate => 'Validate';

  @override
  String get uploadPdfWithTin => 'Upload PDF with TIN';

  @override
  String get enterTinOrUpload => 'Enter TIN number or tap the upload icon';

  @override
  String get addEmail => 'Add Email';

  @override
  String get emailAdded => 'Email added';

  @override
  String get updateSettings => 'Update Settings';

  @override
  String get invite => 'Invite';

  @override
  String get sendRequest => 'Send Request';

  @override
  String get preferences => 'Preferences';

  @override
  String get accessibility => 'Accessibility';

  @override
  String get language => 'Language';

  @override
  String get reports => 'Reports';

  @override
  String get enableReport => 'Enable Report';

  @override
  String get backups => 'BackUps';

  @override
  String get addBackup => 'Add Backup';

  @override
  String get restoreData => 'Restore Data';

  @override
  String get dataRestored => 'Data restored';

  @override
  String get errorRestoringBackup => 'Error Restoring backup';
}
