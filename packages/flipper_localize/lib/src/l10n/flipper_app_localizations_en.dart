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

  @override
  String get transactionIdCopiedToClipboard =>
      'Transaction ID copied to clipboard';

  @override
  String get transactionIdShortLabel => 'Txn ID: ';

  @override
  String get invoiceNumberLabel => 'Invoice No: ';

  @override
  String get parkSaleAsTicket => 'Park this sale as a ticket';

  @override
  String get saveTicketAction => 'Save ticket';

  @override
  String get remainingBalanceLabel => 'Remaining Balance: ';

  @override
  String get amountToChangeLabel => 'Amount to Change: ';

  @override
  String get allApps => 'All apps';

  @override
  String get sell => 'Sell';

  @override
  String get quickSell => 'Quick Sell';

  @override
  String get invoices => 'Invoices';

  @override
  String get pricing => 'Pricing';

  @override
  String get payments => 'Payments';

  @override
  String get manage => 'Manage';

  @override
  String get purchases => 'Purchases';

  @override
  String get customers => 'Customers';

  @override
  String get leads => 'Leads';

  @override
  String get insights => 'Insights';

  @override
  String get dailyReports => 'Daily Reports';

  @override
  String get commissions => 'Commissions';

  @override
  String get production => 'Production';

  @override
  String get business => 'Business';

  @override
  String get servicesHub => 'Services hub';

  @override
  String get goals => 'Goals';

  @override
  String get aiChat => 'AI Chat';

  @override
  String get errorLoadingTransactionView => 'Error loading transaction view';

  @override
  String get customer => 'Customer';

  @override
  String get payment => 'Payment';

  @override
  String get delivery => 'Delivery';

  @override
  String get transactionSummary => 'Transaction summary';

  @override
  String get transactionSummaryHint =>
      'Shows the total amount and transaction ID for the current sale';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get cannotDeletePartialPaymentItems =>
      'Cannot delete items from a transaction with partial payments';

  @override
  String get deleteAllItems => 'Delete All Items';

  @override
  String get confirmRemoveAllTransactionItems =>
      'Are you sure you want to remove all items from this transaction?';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get allItemsRemovedSuccessfully => 'All items removed successfully';

  @override
  String errorRemovingItems(String error) {
    return 'Error removing items: $error';
  }

  @override
  String get noItemsAdded => 'No items added';

  @override
  String get tapAddFirstItem => 'Tap the + button to add your first item';

  @override
  String cartItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String itemSemanticLabel(String itemName) {
    return 'Item: $itemName';
  }

  @override
  String cartItemSemanticHint(
    String quantity,
    String unitPrice,
    String subtotal,
  ) {
    return 'Quantity: $quantity, Unit price: $unitPrice, Subtotal: $subtotal';
  }

  @override
  String get removeItem => 'Remove item';

  @override
  String get unitPrice => 'Unit Price';

  @override
  String get decreaseQuantityByOne => 'Decrease quantity by 1';

  @override
  String get increaseQuantityByOne => 'Increase quantity by 1';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get deliveryDate => 'Delivery Date';

  @override
  String get transactionSummaryPaymentActions =>
      'Transaction summary and payment actions';

  @override
  String completeSaleTotalHint(String total) {
    return 'Complete sale with total amount $total';
  }

  @override
  String errorWithValue(String error) {
    return 'Error: $error';
  }

  @override
  String confirmRemoveItemFromTransaction(String itemName) {
    return 'Are you sure you want to remove \"$itemName\" from this transaction?';
  }

  @override
  String get remove => 'Remove';

  @override
  String get cannotModifyPartialPaymentItems =>
      'Cannot modify items in a transaction with partial payments';

  @override
  String get failedToRemoveItem => 'Failed to remove item';

  @override
  String get failedToUpdateItemQuantity => 'Failed to update item quantity';

  @override
  String get transactionItemsList => 'Transaction items list';

  @override
  String get transactionItemsListHint =>
      'List of items in the current transaction with quantities and prices';

  @override
  String get deliveryNote => 'Delivery Note';

  @override
  String get deliveryNoteSemantic => 'Delivery note';

  @override
  String get deliveryNoteHint => 'Add any special instructions for delivery';

  @override
  String get deliveryInstructionsHint =>
      'Enter any special instructions for delivery';

  @override
  String get discount => 'Discount';

  @override
  String get pleaseEnterValidNumber => 'Please enter a valid number';

  @override
  String get discountRangeError => 'Discount must be between 0 and 100';

  @override
  String get digitalReceiptTitle => 'Digital receipt';

  @override
  String get digitalReceiptSmsSubtitle =>
      'Send receipt by SMS instead of opening a PDF';

  @override
  String receivedAmountInCurrency(String currency) {
    return 'Received amount in $currency';
  }

  @override
  String get receivedAmountHint =>
      'Enter the amount received from the customer';

  @override
  String get receivedAmount => 'Received Amount';

  @override
  String get pleaseEnterReceivedAmount => 'Please enter received amount';

  @override
  String get customerName => 'Customer name';

  @override
  String get customerNameHint => 'Enter the full name of the customer';

  @override
  String get pleaseEnterCustomerName => 'Please enter customer name';

  @override
  String get customerPhoneNumber => 'Customer phone number';

  @override
  String get customerPhoneNumberHint =>
      'Enter the customer\'s phone number for contact and billing purposes';

  @override
  String get items => 'Items';

  @override
  String get transactionId => 'Transaction ID';

  @override
  String get amountPaid => 'Amount Paid';

  @override
  String get remainingBalance => 'Remaining Balance';

  @override
  String recordPaymentWithAmount(String amount) {
    return 'Record Payment • $amount';
  }

  @override
  String payWithAmount(String amount) {
    return 'Pay • $amount';
  }

  @override
  String get phoneRequiredWhenTinMissing =>
      'Phone number is required when customer TIN is not available';

  @override
  String get invalidNumber => 'Invalid Number';

  @override
  String get back => 'Back';

  @override
  String get managementDashboard => 'Management Dashboard';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get posDefault => 'POS Default';

  @override
  String get setPosAsDefaultApp => 'Set POS as default app';

  @override
  String get ordersDefault => 'Orders Default';

  @override
  String get setOrdersAsDefaultApp => 'Set Orders as default app';

  @override
  String get accountManagement => 'Account Management';

  @override
  String get userManagement => 'User Management';

  @override
  String get manageUsersAndPermissions => 'Manage users and permissions';

  @override
  String get branchManagement => 'Branch Management';

  @override
  String get manageBranchLocations => 'Manage Branch (Locations)';

  @override
  String get financialControls => 'Financial Controls';

  @override
  String get taxSettings => 'Tax Settings';

  @override
  String get configureTaxRulesAndRates => 'Configure tax rules and rates';

  @override
  String get ebmSettings => 'EBM Settings';

  @override
  String get electronicBillingMachineSettings =>
      'Electronic Billing Machine settings';

  @override
  String get smsConfiguration => 'SMS Configuration';

  @override
  String get enableSmsNotifications => 'Enable SMS Notifications';

  @override
  String get systemSettings => 'System Settings';

  @override
  String get debugMode => 'Debug Mode';

  @override
  String get enableDebugFeatures => 'Enable debug features';

  @override
  String get forceUpdate => 'Force Update';

  @override
  String get forceUpdateAllData => 'Force update all data';

  @override
  String get taxService => 'Tax Service';

  @override
  String get toggleTaxService => 'Toggle tax service';

  @override
  String get savedDiscount => 'Saved discount';

  @override
  String get createDiscount => 'Create Discount';

  @override
  String get nameCannotBeNull => 'Name can not be null';

  @override
  String get amountCannotBeNull => 'Amount can not be null';

  @override
  String get name => 'Name';

  @override
  String saveTransactionTitle(String transactionType) {
    return 'Save $transactionType transaction';
  }

  @override
  String get confirmSaveTransaction =>
      'Are you sure you want to save this transaction?';

  @override
  String get categoryMustBeSelected => 'A category must be selected';

  @override
  String get confirmLogout => 'Confirm Logout';

  @override
  String get confirmLogoutMessage => 'Are you sure you want to log out?';

  @override
  String get refundReason => 'Refund Reason';

  @override
  String get waitForApproval => 'Wait for Approval';

  @override
  String get approved => 'Approved';

  @override
  String get cancelRequested => 'Cancel Requested';

  @override
  String get canceled => 'Canceled';

  @override
  String get refunded => 'Refunded';

  @override
  String get transferred => 'Transferred';
}
