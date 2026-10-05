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
  String plusMoreItems(int count) {
    return '+$count more';
  }

  @override
  String get actionCannotBeUndone => 'This action cannot be undone.';

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
  String sendForReviewWithAmount(String amount) {
    return 'Send for Review • $amount';
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
  String get enableWhatsappNotifications => 'Enable WhatsApp Notifications';

  @override
  String get receiveWhatsappNotificationsForOrders =>
      'Receive WhatsApp notifications for orders and digital receipt PDFs';

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

  @override
  String get appLanguage => 'App Language';

  @override
  String get chooseAppLanguage => 'Choose the language Flipper uses';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageAppliesEverywhere => 'Applies to every screen in the app.';

  @override
  String get useDeviceLanguage => 'Use device language';

  @override
  String get automatic => 'Automatic';

  @override
  String get french => 'French';

  @override
  String get accountAndFinancial => 'Account & financial';

  @override
  String get adminProfile => 'Admin profile';

  @override
  String get smsNotifications => 'SMS notifications';

  @override
  String get close => 'Close';

  @override
  String get refresh => 'Refresh';

  @override
  String get adminEmailHint => 'e.g. admin@flipper.rw';

  @override
  String get displayName => 'Display name';

  @override
  String get editName => 'Edit name';

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get managePaymentOptions => 'Manage payment options';

  @override
  String get enterPhoneNumber => 'Enter phone number';

  @override
  String get enableOrderNotifications => 'Enable Order Notifications';

  @override
  String get receiveSmsNotificationsForOrders =>
      'Receive SMS notifications for orders';

  @override
  String get enableDebuggingFeatures => 'Enable debugging features';

  @override
  String get ebm => 'EBM';

  @override
  String get reinitializeEbm => 'Re-initialize EBM';

  @override
  String get manageTaxServiceStatus => 'Manage tax service status';

  @override
  String get hydrateData => 'Hydrate Data';

  @override
  String get refreshAllLocalData => 'Refresh all local data';

  @override
  String get assetDownload => 'Asset Download';

  @override
  String get manageImageDownloads => 'Manage image downloads';

  @override
  String get autoAddSearch => 'Auto-Add Search';

  @override
  String get autoAddItemsWhenOneMatch => 'Auto-add items when 1 match';

  @override
  String get userLogging => 'User Logging';

  @override
  String get enableExtensiveUserLogging => 'Enable extensive user logging';

  @override
  String get priceQtyAdjustment => 'Price-Qty Adj';

  @override
  String get autoAdjustQtyOnPriceChange => 'Auto-adjust qty on price change';

  @override
  String get decimals => 'Decimals';

  @override
  String get enableFractionalPricing => 'Enable fractional pricing';

  @override
  String get ticketReviewAndHandover => 'Ticket Review + Handover';

  @override
  String get administratorPin => 'Administrator PIN';

  @override
  String get resetAdministratorPin => 'Reset Administrator PIN';

  @override
  String get updateHighSecurityPin => 'Update your high-security 4-digit PIN';

  @override
  String get flipperSettingsTitle => 'Flipper Settings';

  @override
  String get common => 'Common';

  @override
  String get environment => 'Environment';

  @override
  String get local => 'Local';

  @override
  String get account => 'Account';

  @override
  String get email => 'Email';

  @override
  String get security => 'Security';

  @override
  String get sendDailyReport => 'Send daily report';

  @override
  String get onlinePrint => 'Online Print';

  @override
  String get managePrintSettings => 'Manage print settings';

  @override
  String get enableExtensiveLogging => 'Enable extensive logging';

  @override
  String get backgroundSync => 'Background Sync';

  @override
  String get syncDataInBackground => 'Sync data in background';

  @override
  String get closeShift => 'Close Shift';

  @override
  String get startNewShift => 'Start New Shift';

  @override
  String get checkSubscription => 'Check subscription';

  @override
  String couldNotCheckSubscription(String error) {
    return 'Could not check subscription: $error';
  }

  @override
  String get chooseYourDefaultApp => 'Choose Your Default App';

  @override
  String get accountSettings => 'Account settings';

  @override
  String get switchAccount => 'Switch account';

  @override
  String continueToBranch(String branchName) {
    return 'Continue to $branchName';
  }

  @override
  String get openShift => 'Open Shift';

  @override
  String get checkingPaymentStatus => 'Checking payment status…';

  @override
  String get refreshAfterCustomerPays => 'Refresh after customer pays';

  @override
  String get branch => 'branch';

  @override
  String get totalItems => 'Total Items';

  @override
  String get expiredItems => 'Expired Items';

  @override
  String get lowStockItems => 'Low Stock Items';

  @override
  String get pendingOrders => 'Pending Orders';

  @override
  String get viewAll => 'View All';

  @override
  String get idLabel => 'ID';

  @override
  String get item => 'Item';

  @override
  String get category => 'Category';

  @override
  String get quantity => 'Quantity';

  @override
  String get location => 'Location';

  @override
  String get expiredOn => 'Expired On';

  @override
  String get actions => 'Actions';

  @override
  String get allExpiredItems => 'All Expired Items';

  @override
  String get goHomeQuestion => 'Do you want to go home?';

  @override
  String get searchProductsOrScan => 'Search products or scan…';

  @override
  String get clear => 'Clear';

  @override
  String get addProductAction => 'Add product';

  @override
  String get help => 'Help';

  @override
  String get customerManagement => 'Customer management';

  @override
  String get searchCustomersByNameOrPhone =>
      'Search customers by name or phone';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get add => 'Add';

  @override
  String get editCustomer => 'Edit customer';

  @override
  String get deleteCustomer => 'Delete customer';

  @override
  String get customerActions => 'Customer actions';

  @override
  String get phone => 'Phone';

  @override
  String get tin => 'TIN';

  @override
  String get invoice => 'Invoice';

  @override
  String get txnId => 'Txn ID';

  @override
  String get addCustomer => 'Add customer';

  @override
  String get sortDefault => 'Default sorting';

  @override
  String get sortByPopularity => 'Sort by popularity';

  @override
  String get sortByAverageRating => 'Sort by average rating';

  @override
  String get sortByLatest => 'Sort by latest';

  @override
  String get sortByPriceLowToHigh => 'Sort by price: low to high';

  @override
  String get sortByPriceHighToLow => 'Sort by price: high to low';

  @override
  String get sortByStockOut => 'Sort by stock out';

  @override
  String get sortByEventDateOldToNew => 'Sort by event date: Old to New';

  @override
  String get sortByEventDateNewToOld => 'Sort by event date: New to Old';

  @override
  String get sortCompactLatest => 'Latest';

  @override
  String get sortCompactDefault => 'Default';

  @override
  String get sortCompactPopular => 'Popular';

  @override
  String get sortCompactRating => 'Rating';

  @override
  String get sortCompactPrice => 'Price';

  @override
  String get sortCompactStockOut => 'Stock out';

  @override
  String get sortCompactDate => 'Date';

  @override
  String get posStockFilterInStock => 'In stock';

  @override
  String get posStockFilterOutOfStock => 'Out of stock';

  @override
  String get posStockFilterAll => 'All items';

  @override
  String get posStockFilterNoneInStock => 'No items in stock';

  @override
  String get posStockFilterNoneOutOfStock => 'No out-of-stock items';

  @override
  String get posStockFilterEmptyHint =>
      'Search to find any item, or change the stock filter.';

  @override
  String get posStockFilterShowAll => 'Show all items';

  @override
  String showingRangeOfResults(String start, String end, String total) {
    return 'Showing $start–$end of $total results';
  }

  @override
  String pageOfPages(String current, String total) {
    return 'Page $current of $total';
  }

  @override
  String loadedOfProducts(String loaded, String total) {
    return '$loaded of $total products';
  }

  @override
  String get noProductsYet => 'No products yet';

  @override
  String get noBranchSelected => 'No branch selected';

  @override
  String get productsRefreshedForNewBranch =>
      'Products refreshed for new branch';

  @override
  String deletedItemsCount(int count) {
    return 'Deleted $count items';
  }

  @override
  String inStockCount(String count) {
    return '$count in stock';
  }

  @override
  String leftInStockCount(String count) {
    return '$count left in stock';
  }

  @override
  String get stockLow => 'Low';

  @override
  String get stockOutBadge => 'Out';

  @override
  String get mode => 'Mode';

  @override
  String get sale => 'Sale';

  @override
  String get transfer => 'Transfer';

  @override
  String get searchCustomer => 'Search Customer';

  @override
  String get pay => 'Pay';

  @override
  String get noItemsYet => 'No items yet';

  @override
  String get tapProductToStartSale => 'Tap a product to start a sale';

  @override
  String grandTotalWithItems(String itemLabel) {
    return 'Grand Total · $itemLabel';
  }

  @override
  String get defaultPrice => 'Default price';

  @override
  String pricePerUnitEach(String currency, String price) {
    return '$currency $price each';
  }

  @override
  String get deleteItem => 'Delete item';

  @override
  String get editDetails => 'Edit details';

  @override
  String get enterQuantity => 'Enter quantity';

  @override
  String get invalidQuantity => 'Invalid quantity';

  @override
  String get enterPrice => 'Enter price';

  @override
  String get invalidPrice => 'Invalid price';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String confirmRemoveNamedItem(String itemName) {
    return 'Are you sure you want to remove \"$itemName\"?';
  }

  @override
  String errorDeletingItems(String error) {
    return 'Error deleting items: $error';
  }

  @override
  String errorDeletingItem(String error) {
    return 'Error deleting item: $error';
  }

  @override
  String get failedToDeleteItem => 'Failed to delete item';

  @override
  String get failedToUpdateItem => 'Failed to update item';

  @override
  String skuLabel(String sku) {
    return 'SKU: $sku';
  }

  @override
  String bcdLabel(String barcode) {
    return 'BCD: $barcode';
  }

  @override
  String get split => 'Split';

  @override
  String get splitAcrossAnotherMethod =>
      'Split this payment across another method';

  @override
  String get allPaymentTypesInUse =>
      'All payment types are in use — remove one to add another';

  @override
  String get allPaymentTypesAdded =>
      'All payment types are already added. Remove one to add another.';

  @override
  String get pleaseEnterAnAmount => 'Please enter an amount';

  @override
  String get cashReceived => 'Cash received';

  @override
  String get amount => 'Amount';

  @override
  String get removeThisPayment => 'Remove this payment';

  @override
  String get tapSplitToPayWithMoreThanOneMethod =>
      'Tap Split to pay with more than one method';

  @override
  String get tapSplitToAddMethod => 'Tap Split to add a method';

  @override
  String invoiceNumberValue(String number) {
    return 'No. $number';
  }

  @override
  String tenderedAmount(String amount) {
    return 'Tendered $amount';
  }

  @override
  String paymentCollectedTotal(String total) {
    return 'Payment collected · $total';
  }

  @override
  String get viewOnlyCannotTransferStock =>
      'View-only access — you cannot transfer stock.';

  @override
  String get selectDestinationBranch => 'Select a destination branch';

  @override
  String get currentBranchIsMissing => 'Current branch is missing';

  @override
  String get addItemsBeforeTransferring => 'Add items before transferring';

  @override
  String transferredItemsToBranch(int count, String branch) {
    return 'Transferred $count item(s) to $branch';
  }

  @override
  String get transferFailed => 'Transfer failed';

  @override
  String get failedToClearCart => 'Failed to clear cart';

  @override
  String get paymentsCollectedAtTill =>
      'Payments are collected at the till. Send this order once it\'s ready — a manager will collect payment.';

  @override
  String sentToTillTicket(String reference) {
    return 'Sent to till — Ticket #$reference';
  }

  @override
  String failedToSendToTill(String error) {
    return 'Failed to send to till: $error';
  }

  @override
  String collectingPaymentForTicket(
    String reference,
    String name,
    String minutes,
  ) {
    return 'Collecting payment for #$reference · sent by $name · $minutes min ago';
  }

  @override
  String get returningEllipsis => 'Returning…';

  @override
  String get backToNewSale => 'Back to new sale';

  @override
  String get paymentCashCredit => 'Cash / Credit';

  @override
  String get paymentBankCheck => 'Bank check';

  @override
  String get paymentDebitCreditCard => 'Debit & credit card';

  @override
  String get paymentMobileMoney => 'Mobile money';

  @override
  String get paymentMtnMomo => 'MTN MoMo';

  @override
  String get payerNameOptional => 'Payer name (optional)';

  @override
  String get paidBy => 'Paid by';

  @override
  String get paymentAirtelMoney => 'Airtel Money';

  @override
  String get paymentOther => 'Other';

  @override
  String get sendForReview => 'Send for Review';

  @override
  String get previewCart => 'Preview Cart';

  @override
  String previewCartWithCount(int count) {
    return 'Preview Cart ($count)';
  }

  @override
  String get placeOrder => 'Place order';

  @override
  String confirmRemoveAllItemsCount(int count) {
    return 'Are you sure you want to remove all $count items from this transaction?';
  }

  @override
  String get taxServerUnreachableStatus =>
      'RRA tax server unreachable — receipts can\'t be signed until it is back. Rechecking automatically.';

  @override
  String get internetUnavailableStatus =>
      'No internet connection — sales keep working offline and sync when you\'re back online.';

  @override
  String get includesVat => 'Includes VAT';

  @override
  String get chooseDefaultApp => 'Choose default app';

  @override
  String get payShortcutHint => 'Ctrl / ⌘ + Enter to pay';

  @override
  String get receivedEyebrow => 'Received';

  @override
  String get cartEmptyHint => 'Tap a product or scan a barcode to start a sale';

  @override
  String get scannerAlignQrCode => 'Align QR code within frame';

  @override
  String get scannerInstructionSelling => 'Scan product barcode to add to cart';

  @override
  String get scannerInstructionAttendance =>
      'Scan attendance QR code to check in';

  @override
  String get scannerInstructionLogin =>
      'Scan QR code to log in to your account';

  @override
  String get scannerScanning => 'Scanning...';

  @override
  String get scannerStatusProcessing => 'Processing';

  @override
  String get scannerSendingLoginToDesktop => 'Sending login to desktop...';

  @override
  String get scannerWaitingForDesktop => 'Waiting for desktop';

  @override
  String get scannerLoginSentCompleting =>
      'Login sent — completing on your computer...';

  @override
  String get scannerScanSuccessful => 'Scan Successful';

  @override
  String get scannerQrProcessedSuccessfully => 'QR code processed successfully';

  @override
  String get scannerLoginSuccessful => 'Login Successful';

  @override
  String get scannerDesktopAuthenticated => 'Desktop device authenticated';

  @override
  String get scannerLoginFailed => 'Login Failed';

  @override
  String get scannerCouldNotAuthenticateDesktop =>
      'Could not authenticate desktop device';

  @override
  String get scannerQrCodeDetected => 'QR Code Detected';

  @override
  String get scannerProcessingRequest => 'Processing your request...';

  @override
  String get scannerHelpTitle => 'Scanner Help';

  @override
  String get scannerHelpPositionCode => 'Position the code within the frame';

  @override
  String get scannerHelpWellLit => 'Make sure it\'s well-lit and not blurry';

  @override
  String get scannerHelpUseFlash => 'Use flash in low light';

  @override
  String get scannerHelpToggleFlash => 'Toggle the flash icon at the bottom';

  @override
  String get scannerHelpCleanLens => 'Clean your camera lens';

  @override
  String get scannerHelpBetterResults => 'For better scanning results';

  @override
  String get scannerTitleProduct => 'Product Scanner';

  @override
  String get scannerTitleAttendance => 'Attendance Scanner';

  @override
  String get scannerTitleLogin => 'Login Scanner';

  @override
  String get scannerTitleQr => 'QR Scanner';

  @override
  String get scannerGalleryComingSoon => 'Gallery selection coming soon';

  @override
  String get scannerInvalidQrFormat => 'Invalid QR code format';

  @override
  String scannerLoginError(String error) {
    return 'Login error: $error';
  }

  @override
  String get scannerDesktopNoResponse =>
      'Desktop did not respond — check it is on the QR login screen';

  @override
  String get scannerDesktopSelectBusiness =>
      'Desktop logged in — select your business there';

  @override
  String get scannerDesktopLoginSuccessful => 'Desktop login successful';

  @override
  String get scannerDesktopLoginFailed => 'Desktop login failed';

  @override
  String get dialogGotIt => 'Got it';

  @override
  String get socialsRequestEarlyAccess => 'Request Early Access';

  @override
  String get socialsEarlyAccessHint =>
      'Enter your email, phone number and a message why you want to join!';

  @override
  String get socialsPleaseEnterMessage => 'Please enter a message';

  @override
  String get socialsThanksForInterest => 'Thank you for your interest';

  @override
  String get socialsThanksWeWillGetBack =>
      'Thank you for your interest, we will get back to you soon';

  @override
  String get socialsExpressInterest => 'Express interest';

  @override
  String get appInitStepFirebase => 'Connecting services';

  @override
  String get appInitStepLocator => 'Preparing app';

  @override
  String get appInitStepPlatform => 'Setting up device';

  @override
  String get appInitStepDiagnostics => 'Setting up diagnostics';

  @override
  String get appInitStepDatabase => 'Opening local database';

  @override
  String get appInitStepServices => 'Loading services';

  @override
  String get appInitStepAnalytics => 'Starting analytics';

  @override
  String get appInitStepCloudStorage => 'Connecting cloud storage';

  @override
  String get appInitStepSync => 'Preparing sync';

  @override
  String get appInitStepFinishing => 'Finishing up';

  @override
  String get appInitStepStartup => 'Startup';

  @override
  String get appInitFailedTitle => 'Initialization Failed';

  @override
  String appInitFailedMessage(String step) {
    return 'The app could not finish starting at \"$step\". Tap Try again — it will resume from that step.';
  }

  @override
  String get appInitTryAgain => 'Try again';

  @override
  String get appInitCopyErrorDetails => 'Copy error details';

  @override
  String get appInitTechnicalDetails => 'Technical details';

  @override
  String get paywallRailMobileMoney => 'Mobile Money';

  @override
  String get paywallRailCard => 'Card';

  @override
  String get paywallRailMomoDescription =>
      'Approve on your phone with MTN MoMo';

  @override
  String get paywallRailCardDescription => 'Pay by Visa or Mastercard';

  @override
  String get paywallCadenceDaily => 'Daily';

  @override
  String get paywallCadenceMonthly => 'Monthly';

  @override
  String get paywallCadenceYearly => 'Yearly';

  @override
  String get paywallPeriodDay => '/day';

  @override
  String get paywallPeriodMonth => '/month';

  @override
  String get paywallPeriodYear => '/year';

  @override
  String paywallPaidInFull(String amount) {
    return 'Paid in full — one charge of RWF $amount.';
  }

  @override
  String paywallInstallmentsEach(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count payments of RWF $amount each.',
      one: '1 payment of RWF $amount.',
    );
    return '$_temp0';
  }

  @override
  String paywallPricePerMonthBilledYearly(String amount) {
    return '$amount RWF/mo · billed yearly';
  }

  @override
  String paywallPricePerDay(String amount) {
    return '$amount RWF/day';
  }

  @override
  String paywallPricePerMonth(String amount) {
    return '$amount RWF/month';
  }

  @override
  String get paywallCardPayment => 'Card Payment';

  @override
  String get paywallTestMode => 'TEST MODE';

  @override
  String get paywallCardRedirectInfo =>
      'You will be taken to a secure payment page to enter your Visa or Mastercard details. Come back here once you are done — the plan activates on its own.';

  @override
  String get paywallReceiptEmail => 'Email for the receipt';

  @override
  String get paywallReceiptEmailHint =>
      'Invoices and card receipts are sent here.';

  @override
  String get paywallCardDiscountApplies =>
      'Your discount applies to card payments: the card is charged the discounted price now and at each renewal.';

  @override
  String paywallCardDiscountAppliesAmount(String amount) {
    return 'Your discount applies: the card is charged $amount now and at each renewal.';
  }

  @override
  String get paywallDiscountMomoOnly =>
      'Discount codes apply to Mobile Money payments only. Paying by card charges the full plan price.';

  @override
  String get paywallPendingCheckout =>
      'A payment page is already waiting for this plan. Open it to finish — a new one would not replace it.';

  @override
  String get paywallOpenPaymentPage => 'Open payment page';

  @override
  String get paywallDiscountHint => 'Enter the code exactly as it appears.';

  @override
  String get paywallNeedHelp => 'Need Help?';

  @override
  String get paywallChatWithSupport => 'Chat with support about this payment';

  @override
  String get paywallMomoPayment => 'Mobile Money Payment';

  @override
  String paywallProcessedUsing(String provider) {
    return 'Payment will be processed using $provider.';
  }

  @override
  String get paywallUseDifferentNumber => 'Use different phone number';

  @override
  String get paywallTryAnotherNumber =>
      'Try another MTN number if the current one failed';

  @override
  String get paywallMomoNumberRule => 'Must start with 250 78 or 250 79.';

  @override
  String get paywallProcessing => 'Processing…';

  @override
  String paywallSecurePaymentVia(String provider) {
    return 'Secure payment via $provider';
  }

  @override
  String get paywallHowToPay => 'How would you like to pay?';

  @override
  String get paywallLoading => 'Loading…';

  @override
  String paywallPercentOff(String percent) {
    return '($percent% off)';
  }

  @override
  String get paywallSplitIntoPayments => 'Split into payments';

  @override
  String get paywallPaymentSummary => 'Payment Summary';

  @override
  String get paywallTotal => 'Total';

  @override
  String get paywallSubscriptionEnded =>
      'This subscription has ended. Choose a plan to start again.';

  @override
  String get paywallPaymentPageNotReady =>
      'The payment page is not ready yet. Try again in a moment.';

  @override
  String get paywallCouldNotOpenPageCopyLink =>
      'Could not open the payment page on this device. Copy the link, or pay with Mobile Money instead.';

  @override
  String get paywallCouldNotOpenPage =>
      'Could not open the payment page on this device.';

  @override
  String get paywallServiceNoResponse =>
      'The payments service did not respond. Check your connection and try again.';

  @override
  String get paywallServiceUnreachable =>
      'Could not reach the payments service. Check your connection and try again.';

  @override
  String get paywallBusinessRequiredForCard =>
      'A business is required to start a card subscription.';

  @override
  String get paywallCardStartedNoReference =>
      'The card subscription started but the connector sent no reference. Check the billing screen before trying again.';

  @override
  String get paywallNoCardUpdateLink =>
      'The connector did not return a link to update the card.';

  @override
  String get paywallNoPortalLink =>
      'The connector did not return a billing portal link.';

  @override
  String get paywallCardNotAuthorised =>
      'Card payment is not authorised on this connector.';

  @override
  String get paywallCardUnavailable =>
      'Card payment is not available right now. Use Mobile Money, or try again later.';

  @override
  String paywallCouldNotAction(String action, String status) {
    return 'Could not $action (HTTP $status).';
  }

  @override
  String paywallUnreadableReply(String status) {
    return 'The billing service sent an unreadable reply (HTTP $status).';
  }

  @override
  String get paywallActionStartCardSubscription => 'start a card subscription';

  @override
  String get paywallActionReadCardSubscription => 'read the card subscription';

  @override
  String get paywallActionRefreshCardSubscription =>
      'refresh the card subscription';

  @override
  String get paywallActionGetCardLink => 'get a new card link';

  @override
  String get paywallActionOpenBillingPortal => 'open the billing portal';

  @override
  String get paywallActionCancelCardSubscription =>
      'cancel the card subscription';

  @override
  String get paywallActionStartCustomPayment => 'start the custom payment';

  @override
  String get paywallActionReadCustomPayment => 'read the custom payment';

  @override
  String get paywallActionListCustomPayments => 'list custom payments';

  @override
  String get paywallEnterAmountAboveZero =>
      'Enter an amount greater than zero.';

  @override
  String get paywallEnterValidMomoNumber =>
      'Enter a valid Mobile Money number, e.g. 0788123456.';

  @override
  String paywallPaymentNotStarted(String status) {
    return 'The payment could not be started (HTTP $status).';
  }

  @override
  String paywallGatewayUnreadable(String status) {
    return 'The payment gateway sent an unreadable reply (HTTP $status).';
  }

  @override
  String get paywallStartedNoReference =>
      'The payment started but no reference came back — check the MoMo statement before trying again.';

  @override
  String paywallPreApprovalFailed(String status) {
    return 'Pre-approval failed (HTTP $status).';
  }

  @override
  String get paywallRequestRejected => 'The payment request was rejected.';

  @override
  String get paywallDeviceNotAuthorised =>
      'This device is not authorised to take payments.';

  @override
  String get paywallServiceNotFound =>
      'The payment service could not be found.';

  @override
  String get paywallAlreadySubmitted =>
      'That payment has already been submitted.';

  @override
  String get paywallMomoUnavailableNow =>
      'Mobile Money is unavailable right now. Please try again shortly.';

  @override
  String get paywallMomoNotSetUp =>
      'Mobile Money is not set up on this device yet.';

  @override
  String get paywallNotCompletedOnPhone =>
      'The payment was not completed on the payer\'s phone.';

  @override
  String get paywallNoConfirmationYet =>
      'No confirmation yet. The payment may still go through — check the MoMo statement before charging again.';

  @override
  String get paywallConsentDeclined =>
      'Mobile Money consent was declined, so nothing was charged. Approve the request on your phone and try again.';

  @override
  String get paywallChooseBusinessFirst => 'Choose a business first.';

  @override
  String get paywallAmountAboveZero => 'Amount must be greater than zero.';

  @override
  String get paywallCustomerMomoRequired =>
      'The customer\'s Mobile Money number is required.';

  @override
  String get paywallStaffNotAuthorised =>
      'This account is not authorised for staff payments.';

  @override
  String get paywallAlreadyCollecting =>
      'Something is already collecting from this business.';

  @override
  String get paywallStaffNotConfigured =>
      'Staff payments are not configured on this connector.';

  @override
  String accountingShiftUser(String id) {
    return 'User: $id';
  }

  @override
  String get accountingShiftHistory => 'Shift History';

  @override
  String get accountingLoadingShiftHistory => 'Loading shift history...';

  @override
  String get accountingNoMatchingShifts => 'No matching shifts';

  @override
  String get accountingNoShiftsFound => 'No shifts found';

  @override
  String get accountingAdjustFiltersHint =>
      'Try adjusting your filters or search query.';

  @override
  String get accountingNoShiftsHint =>
      'Shift records will appear here once you\nstart managing your shifts.';

  @override
  String get accountingClearFilters => 'Clear Filters';

  @override
  String accountingCashSalesRange(String currency) {
    return 'CASH SALES RANGE ($currency)';
  }

  @override
  String get accountingFilterShifts => 'Filter shifts';

  @override
  String get accountingDateRange => 'DATE RANGE';

  @override
  String get accountingFrom => 'From';

  @override
  String get accountingTo => 'To';

  @override
  String get accountingStatusLabel => 'STATUS';

  @override
  String get accountingAllShifts => 'All shifts';

  @override
  String get accountingShiftOpen => 'Open';

  @override
  String get accountingShiftClosed => 'Closed';

  @override
  String get accountingMinimum => 'Minimum';

  @override
  String get accountingMaximum => 'Maximum';

  @override
  String get accountingNoLimit => 'No limit';

  @override
  String get accountingSortBy => 'SORT BY';

  @override
  String get accountingNewestFirst => 'Newest first';

  @override
  String get accountingOldestFirst => 'Oldest first';

  @override
  String get accountingCashSalesHighToLow => 'Cash sales — high to low';

  @override
  String get accountingCashSalesLowToHigh => 'Cash sales — low to high';

  @override
  String get accountingClearAll => 'Clear all';

  @override
  String get accountingApplyFilters => 'Apply filters';

  @override
  String get accountingDatePlaceholder => 'mm/dd/yyyy';

  @override
  String get accountingTotalShifts => 'TOTAL SHIFTS';

  @override
  String get accountingTotalCashSales => 'TOTAL CASH SALES';

  @override
  String get accountingOpenClosed => 'OPEN / CLOSED';

  @override
  String get accountingSearchShiftsHint => 'Search by user ID or date...';

  @override
  String accountingShowingShifts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Showing $count shifts',
      one: 'Showing 1 shift',
    );
    return '$_temp0';
  }

  @override
  String accountingStartedAt(String time) {
    return 'Started $time';
  }

  @override
  String accountingCashDifference(String amount) {
    return 'Cash difference: $amount';
  }

  @override
  String get accountingTimePeriod => 'TIME PERIOD';

  @override
  String get accountingStartTime => 'Start Time';

  @override
  String get accountingEndTime => 'End Time';

  @override
  String accountingDuration(String duration) {
    return 'Duration: $duration';
  }

  @override
  String get accountingInProgress => 'In Progress';

  @override
  String get accountingFinancialSummary => 'FINANCIAL SUMMARY';

  @override
  String get accountingOpeningBalance => 'Opening Balance';

  @override
  String get accountingCashSales => 'Cash Sales';

  @override
  String get accountingExpectedCash => 'Expected Cash';

  @override
  String get accountingClosingBalance => 'Closing Balance';

  @override
  String get uiAdminPinMismatch => 'PINs didn\'t match. Try again.';

  @override
  String uiAdminPinIncorrect(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Incorrect PIN. $count attempts left.',
      one: 'Incorrect PIN. 1 attempt left.',
    );
    return '$_temp0';
  }

  @override
  String get uiAdminPinSaveFailed =>
      'Couldn\'t save the PIN. Please try again.';

  @override
  String get uiAdminPinSaved => 'PIN saved';

  @override
  String get uiAdminPinEnter => 'Enter admin PIN';

  @override
  String get uiAdminPinConfirm => 'Confirm your PIN';

  @override
  String get uiAdminPinSetUp => 'Set up admin PIN';

  @override
  String get uiAdminPinSavedSubtitle =>
      'Sensitive actions now require this PIN.';

  @override
  String get uiAdminPinVerifySubtitle =>
      'This action is protected. Enter your 4-digit administrator PIN.';

  @override
  String get uiAdminPinConfirmSubtitle =>
      'Enter the same 4 digits again to confirm.';

  @override
  String get uiAdminPinSetSubtitle =>
      'Choose a 4-digit PIN to protect edits, deletes and settings.';

  @override
  String uiAdminPinDigitsSemantic(String entered, String total) {
    return 'PIN, $entered of $total digits entered';
  }

  @override
  String uiAdminPinLockout(String seconds) {
    return 'Too many attempts. Try again in ${seconds}s.';
  }

  @override
  String get uiAdminPinStartOver => 'Start over';

  @override
  String get uiMonthShortJan => 'Jan';

  @override
  String get uiMonthShortFeb => 'Feb';

  @override
  String get uiMonthShortMar => 'Mar';

  @override
  String get uiMonthShortApr => 'Apr';

  @override
  String get uiMonthShortMay => 'May';

  @override
  String get uiMonthShortJun => 'Jun';

  @override
  String get uiMonthShortJul => 'Jul';

  @override
  String get uiMonthShortAug => 'Aug';

  @override
  String get uiMonthShortSep => 'Sep';

  @override
  String get uiMonthShortOct => 'Oct';

  @override
  String get uiMonthShortNov => 'Nov';

  @override
  String get uiMonthShortDec => 'Dec';

  @override
  String get uiTicketResumeOrder => 'Resume order';

  @override
  String get uiTicketResuming => 'Resuming…';

  @override
  String get uiTicketCustomerSection => 'CUSTOMER';

  @override
  String uiTicketItemsSection(String count) {
    return 'ITEMS · $count';
  }

  @override
  String uiTicketCouldNotLoadItems(String error) {
    return 'Could not load items: $error';
  }

  @override
  String get uiTicketStatusSection => 'STATUS';

  @override
  String get uiTicketResumeTicket => 'Resume ticket';

  @override
  String get uiTicketWalkIn => 'Walk-in';

  @override
  String get uiTicketLoan => 'Loan';

  @override
  String get uiTicketNoItems => 'No items on this ticket.';

  @override
  String uiTicketPaymentsSection(String count) {
    return 'PAYMENTS · $count';
  }

  @override
  String get uiTicketTotalPaidSoFar => 'Total paid so far';

  @override
  String get uiTicketStillDue => 'Still due';

  @override
  String get uiTicketUnknown => 'Unknown';

  @override
  String uiTicketPaymentLine(String index, String method) {
    return 'Payment $index · $method';
  }

  @override
  String uiTicketPaidBy(String name) {
    return 'Paid by $name';
  }

  @override
  String get uiTicketStatusWaiting => 'Waiting';

  @override
  String get uiTicketStatusInProgress => 'In Progress';

  @override
  String get uiTicketStatusCompleted => 'Completed';

  @override
  String get uiTicketBadgeInProgress => 'IN PROGRESS';

  @override
  String get uiTicketBadgeCompleted => 'COMPLETED';

  @override
  String get uiTicketBadgeParked => 'PARKED';

  @override
  String get uiTicketDateNotRecorded => 'Date not recorded';

  @override
  String uiTicketTodayAt(String time) {
    return 'Today · $time';
  }

  @override
  String uiTicketYesterdayAt(String time) {
    return 'Yesterday · $time';
  }

  @override
  String get uiTicketParkTransaction => 'Park transaction';

  @override
  String get uiTicketParking => 'Parking…';

  @override
  String uiTicketParkFailed(String error) {
    return 'Failed to park transaction: $error';
  }

  @override
  String get uiTicketAttachCustomer => 'Attach customer';

  @override
  String get uiTicketSearchCustomers => 'Search customers…';

  @override
  String get uiTicketNoCustomer => 'No customer';

  @override
  String get uiTicketName => 'Ticket name';

  @override
  String get uiTicketEnterName => 'Enter a ticket name';

  @override
  String get uiTicketNotes => 'Notes';

  @override
  String get uiTicketOptional => 'Optional';

  @override
  String get uiTicketAddNotes => 'Add notes';

  @override
  String get uiTicketPaymentDue => 'Payment due';

  @override
  String get uiTicketSendToKitchen => 'Send to kitchen';

  @override
  String get uiTicketShowOnKds => 'Show this ticket on the Kitchen Display';

  @override
  String get uiTicketSelectCustomer => 'Select customer';

  @override
  String get uiTicketMarkAsLoan => 'Mark as loan';

  @override
  String get uiTicketTrackPaymentLater => 'Track payment for later collection';

  @override
  String get uiTicketOneWeek => '1 week';

  @override
  String get uiTicketTwoWeeks => '2 weeks';

  @override
  String get uiTicketOneMonth => '1 month';

  @override
  String get uiTicketSelectDate => 'Select date';

  @override
  String get uiTicketDueDate => 'Due date';

  @override
  String get uiTicketHoldSale => 'Hold this sale to finish later';

  @override
  String get uiWorkOrderUnknownProduct => 'Unknown Product';

  @override
  String uiWorkOrderId(String id) {
    return 'ID: $id';
  }

  @override
  String get uiWorkOrderStart => 'Start';

  @override
  String get uiWorkOrderRecordOutput => 'Record Output';

  @override
  String get uiWorkOrderCompleted => 'Completed';

  @override
  String get uiWorkOrderInProgress => 'In Progress';

  @override
  String get uiWorkOrderPlanned => 'Planned';

  @override
  String get uiWorkOrderActual => 'Actual';

  @override
  String get uiWorkOrderVariance => 'Variance';

  @override
  String get uiWorkOrderEfficiency => 'Efficiency';

  @override
  String get uiWorkOrderTargetDate => 'Target Date';

  @override
  String get uiWorkOrderShift => 'Shift';

  @override
  String get uiWorkOrderNotApplicable => 'N/A';

  @override
  String get uiWorkOrderNotes => 'Notes';

  @override
  String get uiWorkOrderTimeline => 'Timeline';

  @override
  String get uiWorkOrderCreated => 'Created';

  @override
  String get uiWorkOrderStarted => 'Started';

  @override
  String get uiProduceItems => 'Items';

  @override
  String get uiProduceSelectItem => 'Select Item to Produce';

  @override
  String get uiProduceDescription =>
      'Choose an item from the list below to begin production.';

  @override
  String uiProduceItemsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items remaining',
      one: '1 item remaining',
    );
    return '$_temp0';
  }

  @override
  String uiProduceAssignedCount(String count) {
    return '$count assigned';
  }

  @override
  String uiProduceQty(String qty) {
    return 'Qty: $qty';
  }

  @override
  String get uiProduceAssigned => 'Assigned';

  @override
  String get uiProduceInProgress => 'In Progress';

  @override
  String get uiProduceBackToList => 'Back to list';

  @override
  String get uiProduceDetails => 'Production Details';

  @override
  String get uiPaymentModeSelect => 'Select Payment Mode';

  @override
  String get uiPaymentModeFailed => 'Payment failed';

  @override
  String get uiPaymentModePleaseSelect => 'Please select a payment mode';

  @override
  String get uiPaymentModeSelectFinancing => 'Select Financing Option';

  @override
  String uiPaymentModeInterest(String rate) {
    return 'Interest: $rate%';
  }

  @override
  String get uiBackupDescription =>
      'Enabling backup will save your data daily, so you won\'t have to worry about losing it.';

  @override
  String get uiTicketNoName => 'No Name';

  @override
  String get uiTicketResume => 'Resume';

  @override
  String get uiNoteRequired => 'Note is required';

  @override
  String uiNotificationSemantic(String message) {
    return '$message notification';
  }

  @override
  String uiDeleteConfirmSemantic(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Delete confirmation for $count items',
      one: 'Delete confirmation for 1 item',
    );
    return '$_temp0';
  }

  @override
  String uiDeleteItemsQuestion(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Delete $count items?',
      one: 'Delete 1 item?',
    );
    return '$_temp0';
  }

  @override
  String uiMoreItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+ $count more items',
      one: '+ 1 more item',
    );
    return '$_temp0';
  }

  @override
  String get uiRefreshStatusAfterPayment => 'Refresh status after payment';

  @override
  String get uiSubscriptionActive => 'Subscription is active.';

  @override
  String get uiNoPlanOpeningSetup => 'No plan found — opening payment setup.';

  @override
  String get uiPlanInactiveOpeningPayment =>
      'Plan found but not active — opening payment screen.';

  @override
  String get uiCouldNotVerifyPayment => 'Could not verify payment status.';

  @override
  String get uiTimerDone => 'Done!';

  @override
  String get uiTimerDelivered => 'Delivered!';

  @override
  String get uiTimerUntilDelivered => 'Until Delivered';

  @override
  String uiTimerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Days',
      one: '1 Day',
    );
    return '$_temp0';
  }

  @override
  String uiTimerHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Hours',
      one: '1 Hour',
    );
    return '$_temp0';
  }

  @override
  String uiTimerMinutes(String count) {
    return '$count MIN';
  }

  @override
  String uiTimerSeconds(String count) {
    return '$count SEC';
  }

  @override
  String get uiEnterCouponCode => 'Enter Coupon Code';

  @override
  String get uiShop => 'Shop';

  @override
  String uiShopActiveSemantic(String name) {
    return '$name active';
  }

  @override
  String uiShopInactiveSemantic(String name) {
    return '$name inactive';
  }

  @override
  String get uiSaveTicket => 'Save Ticket';

  @override
  String get floSuggestTodayTitle => 'Summarize today\'s performance';

  @override
  String get floSuggestTodayDesc => 'Revenue, profit & units at a glance';

  @override
  String get floSuggestTodayQuestion =>
      'Summarize today\'s business performance';

  @override
  String get floSuggestProfitTitle => 'Most profitable products';

  @override
  String get floSuggestProfitDesc => 'Ranked by margin this week';

  @override
  String get floSuggestProfitQuestion =>
      'Which products are most profitable this week?';

  @override
  String get floSuggestUsersTitle => 'How many users in MiniData?';

  @override
  String get floSuggestUsersDesc => 'Counts & recent activity';

  @override
  String get floSuggestUsersQuestion =>
      'How many users do we have in MiniData?';

  @override
  String get floSuggestTrendTitle => 'This week\'s sales trend';

  @override
  String get floSuggestTrendDesc => '7-day revenue movement';

  @override
  String get floSuggestTrendQuestion => 'Show this week\'s sales trend';

  @override
  String get floGoodMorning => 'Good morning';

  @override
  String get floGoodAfternoon => 'Good afternoon';

  @override
  String get floGoodEvening => 'Good evening';

  @override
  String floGreetingShop(String greeting, String shop) {
    return '$greeting, $shop.';
  }

  @override
  String floAskMeAnything(String anything) {
    return 'Ask me $anything about your business.';
  }

  @override
  String get floAnything => 'anything';

  @override
  String get floHomeIntro =>
      'I read live from your connected data and answer with numbers, charts and next steps — in plain language.';

  @override
  String get floTryAsking => 'Try asking';

  @override
  String get floChannels => 'Channels';

  @override
  String get floMiniDataDesc => 'Live Supabase data — sales, users, products.';

  @override
  String get floManage => 'Manage';

  @override
  String get floConnect => 'Connect';

  @override
  String get floWhatsAppConnectedDesc => 'You can chat with Flo over WhatsApp.';

  @override
  String get floWhatsAppSetupDesc =>
      'Talk to Flo from your phone — set up in a minute.';

  @override
  String get floLoadingBriefing => 'Loading today\'s briefing…';

  @override
  String get floBriefingUnavailable => 'Daily briefing unavailable';

  @override
  String get floReadingLiveSales => 'Reading live sales from MiniData.';

  @override
  String get floCheckDataConnection =>
      'Check your data connection and try again.';

  @override
  String get floDailyBriefing => 'DAILY BRIEFING';

  @override
  String floDateAuto(String date) {
    return '$date · auto';
  }

  @override
  String get floConnected => 'CONNECTED';

  @override
  String get floNotSetUp => 'NOT SET UP';

  @override
  String aiWhatsappReadInboxFailed(String error) {
    return 'Could not read WhatsApp messages\n$error';
  }

  @override
  String aiWhatsappSendFailed(String error) {
    return 'Send failed: $error';
  }

  @override
  String get aiWhatsappAnswerCustomers => 'Answer customers on WhatsApp';

  @override
  String get aiWhatsappConnectPitch =>
      'Connect your Meta WhatsApp Business account to see customer messages here and draft replies with Flo.';

  @override
  String get aiWhatsappConnect => 'Connect WhatsApp';

  @override
  String get aiWhatsappSelectCustomer => 'Select a customer';

  @override
  String get aiWhatsappInboxSource => 'WhatsApp inbox · data-connector + Ditto';

  @override
  String get aiWhatsappCustomers => 'Customers · WhatsApp';

  @override
  String get floTimeNow => 'now';

  @override
  String floTimeMinutesShort(String count) {
    return '${count}m';
  }

  @override
  String floTimeDaysShort(String count) {
    return '${count}d';
  }

  @override
  String get aiWhatsappNoMessages => 'No WhatsApp messages yet';

  @override
  String get aiWhatsappNoMessagesHint =>
      'Inbound messages load from data-connector (local Ditto is a backup). When Meta posts to the webhook they appear here within a few seconds.';

  @override
  String get aiWhatsappNoThreadMessages => 'No messages in this thread yet';

  @override
  String get aiWhatsappPdfDownloadFailed => 'Could not download this PDF';

  @override
  String get aiWhatsappSavePdf => 'Save PDF';

  @override
  String aiWhatsappSavedFile(String file) {
    return 'Saved $file';
  }

  @override
  String aiWhatsappDownloadFailed(String error) {
    return 'Download failed: $error';
  }

  @override
  String get aiWhatsappPdfDocument => 'PDF document';

  @override
  String get aiWhatsappFloSuggestedReply => 'Flo suggested reply';

  @override
  String get aiWhatsappSend => 'Send';

  @override
  String get aiWhatsappEditFirst => 'Edit first';

  @override
  String get aiWhatsappDraft => 'Draft';

  @override
  String get aiWhatsappReplyHint => 'Reply on WhatsApp…';

  @override
  String get floBusinessAi => 'Business AI';

  @override
  String get floMiniDataConnectedLive => 'MiniData connected · live';

  @override
  String get floNewChat => 'New chat';

  @override
  String get floAskFlo => 'Ask Flo';

  @override
  String get floMessages => 'Messages';

  @override
  String get floNewConversation => 'New conversation';

  @override
  String get floChatWithFloAndCustomers => 'Chat with Flo & customers';

  @override
  String get floOn => 'On';

  @override
  String get floOff => 'Off';

  @override
  String get floManageDataSources => 'Manage data sources';

  @override
  String get floQuickSummarizeToday => 'Summarize today';

  @override
  String get floQuickTopProducts => 'Top products';

  @override
  String get floQuickUserCount => 'User count';

  @override
  String get floQuickSalesTrend => 'Sales trend';

  @override
  String get floComposerHint => 'Ask about sales, stock, customers or tax…';

  @override
  String get floStopDictating => 'Stop dictating';

  @override
  String get floDictate => 'Dictate — speak and Flo types it';

  @override
  String get floCanMakeMistakes =>
      'Flo can make mistakes — check important figures. ';

  @override
  String get floGroundedInMiniData => 'Grounded in MiniData.';

  @override
  String get floStarting => 'Starting…';

  @override
  String get floListening => 'Listening…';

  @override
  String get floModeCloud => 'Cloud';

  @override
  String get floModeOnDevice => 'On-Device';

  @override
  String get floChooseAiMode => 'Choose AI mode';

  @override
  String get floOnDeviceSubtitle => 'Free · offline · private';

  @override
  String get floCloudSubtitle => 'More capable · uses connection';

  @override
  String get floThinkingUnderstanding => 'Understanding question';

  @override
  String get floThinkingQuerying => 'Querying MiniData';

  @override
  String get floThinkingComposing => 'Composing answer';

  @override
  String get floCopied => 'Copied!';

  @override
  String get floCopyChart => 'Copy chart';

  @override
  String get floSuggestedFollowUps => 'SUGGESTED FOLLOW-UPS';

  @override
  String get aiDataSourceEdit => 'Edit Data Source';

  @override
  String get aiDataSourceConnectTitle => 'Connect Data Source';

  @override
  String get aiDataSourceType => 'Data Source Type';

  @override
  String get aiDataSourceConnectionName => 'Connection Name';

  @override
  String get aiDataSourceConnectionNameHint => 'e.g., Production Database';

  @override
  String get aiDataSourceSupabaseUrl => 'Supabase URL';

  @override
  String get aiDataSourceAnonKey => 'Anon/Public Key';

  @override
  String get aiDataSourceServiceKey => 'Service Role Key (Optional)';

  @override
  String get aiDataSourceServiceKeyHelper => 'Required for admin operations';

  @override
  String get aiDataSourceTestFailedCredentials =>
      'Connection test failed. Please check your credentials.';

  @override
  String aiDataSourceTestFailed(String error) {
    return 'Connection test failed: $error';
  }

  @override
  String get aiDataSourceTesting => 'Testing...';

  @override
  String get aiDataSourceTestConnection => 'Test Connection';

  @override
  String get aiDataSourcePrivacyNote =>
      'When connected, the assistant can use schema and sample rows from this source in your chats. Credentials are stored only on this device.';

  @override
  String get aiDataSourceEnterName => 'Please enter a connection name';

  @override
  String get aiDataSourceEnterUrl => 'Please enter the Supabase URL';

  @override
  String get aiDataSourceEnterKey =>
      'Please enter an Anon/Public Key or Service Role Key';

  @override
  String get aiDataSourceUpdated => 'Data source updated successfully';

  @override
  String get aiDataSourceConnected => 'Data source connected successfully';

  @override
  String aiDataSourceConnectFailed(String error) {
    return 'Failed to connect: $error';
  }

  @override
  String get aiDataSourceConnecting => 'Connecting...';

  @override
  String get aiDataSourceUpdate => 'Update';

  @override
  String get aiDataSourceConnect => 'Connect';

  @override
  String get aiDataSourceStatusConnected => 'Connected';

  @override
  String get aiDataSourceStatusConnecting => 'Connecting';

  @override
  String get aiDataSourceStatusError => 'Error';

  @override
  String get aiDataSourceStatusDisconnected => 'Disconnected';

  @override
  String get aiDataSourceTitle => 'Data Source';

  @override
  String get aiDataSourceNotFound => 'Data source not found';

  @override
  String get aiDataSourceGoBack => 'Go Back';

  @override
  String get aiDataSourceTables => 'Tables';

  @override
  String get aiDataSourceUrl => 'URL';

  @override
  String get aiDataSourceNotAvailable => 'N/A';

  @override
  String aiDataSourceLastConnected(String time) {
    return 'Last connected: $time';
  }

  @override
  String get aiDataSourceInformation => 'Information';

  @override
  String aiDataSourceMetadataFailed(String error) {
    return 'Failed to load metadata: $error';
  }

  @override
  String get aiDataSourceTotalRows => 'Total Rows';

  @override
  String get aiDataSourceTypeLabel => 'Type';

  @override
  String get aiDataSourceUnknown => 'Unknown';

  @override
  String aiDataSourceTablesFailed(String error) {
    return 'Failed to load tables: $error';
  }

  @override
  String get aiDataSourceNoTables => 'No tables found';

  @override
  String aiDataSourceColumnsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count columns',
      one: '1 column',
    );
    return '$_temp0';
  }

  @override
  String aiDataSourceRowsCount(String count) {
    return '$count rows';
  }

  @override
  String get aiDataSourceColumns => 'Columns';

  @override
  String get aiDataSourceNotNull => 'NOT NULL';

  @override
  String get aiDataSourceJustNow => 'Just now';

  @override
  String aiDataSourceMinutesAgo(String count) {
    return '${count}m ago';
  }

  @override
  String aiDataSourceHoursAgo(String count) {
    return '${count}h ago';
  }

  @override
  String get aiDataSourceCsvFile => 'CSV File';

  @override
  String get aiDataSourceJsonFile => 'JSON File';

  @override
  String get aiDataSources => 'Data Sources';

  @override
  String get aiDataSourceAdd => 'Add Data Source';

  @override
  String get aiDataSourceNoneConnected => 'No Data Sources Connected';

  @override
  String get aiDataSourceNoneHint =>
      'Connect a database so the AI can include its schema and sample rows\nwhen answering in Business or Personal chat.';

  @override
  String get aiDataSourceConnectFirst => 'Connect Your First Data Source';

  @override
  String get aiDataSourceActive => 'Active';

  @override
  String get aiDataSourceDisconnect => 'Disconnect';

  @override
  String get aiDataSourceDeleteTitle => 'Delete Data Source';

  @override
  String aiDataSourceDeleteConfirm(String name) {
    return 'Are you sure you want to delete \"$name\"? This will remove the connection and all associated data.';
  }

  @override
  String aiDataSourceDeleted(String name) {
    return 'Data source \"$name\" deleted';
  }

  @override
  String get aiWhatsappPhoneIdEmpty => 'Phone Number ID cannot be empty';

  @override
  String get aiWhatsappPhoneIdInvalid =>
      'Phone Number ID must contain only digits and be 5-15 characters long';

  @override
  String get aiWhatsappConnectedSuccess =>
      'WhatsApp account connected successfully';

  @override
  String get aiWhatsappDisconnectedSuccess =>
      'WhatsApp account disconnected successfully';

  @override
  String get aiWhatsappConnected => 'Connected';

  @override
  String get aiWhatsappNotConnected => 'Not connected';

  @override
  String get aiWhatsappAccountActive => 'Account active';

  @override
  String get aiWhatsappSavedToBusiness =>
      'Saved to your business account — it stays connected on other devices when you sign in.';

  @override
  String get aiWhatsappDisconnecting => 'Disconnecting...';

  @override
  String get aiWhatsappDisconnect => 'Disconnect';

  @override
  String get aiWhatsappConnectIntro =>
      'Connect your WhatsApp Business account to receive and reply to customer messages.';

  @override
  String get aiWhatsappStep1 => 'Go to your Meta Business Suite';

  @override
  String get aiWhatsappStep2 =>
      'Find your Phone Number ID in WhatsApp settings';

  @override
  String get aiWhatsappStep3 => 'Paste it below and connect';

  @override
  String get aiWhatsappPhoneIdLabel => 'Phone Number ID';

  @override
  String get aiWhatsappPhoneIdHint => 'e.g., 101514826127381';

  @override
  String get aiWhatsappConnectionError => 'Connection Error';

  @override
  String get aiWhatsappTryAgain => 'Try Again';

  @override
  String get aiMessageHint => 'Message';

  @override
  String aiRecordingStartFailed(String error) {
    return 'Failed to start recording: $error';
  }

  @override
  String get aiVoiceMessageSent => 'Voice message sent!';

  @override
  String get aiAudioCorrupted => 'Audio file is corrupted or incomplete';

  @override
  String get aiRecordingTooShort => 'Recording too short (minimum 1 second)';

  @override
  String aiRecordingStopFailed(String error) {
    return 'Failed to stop recording: $error';
  }

  @override
  String get aiMicPermissionTitle => 'Microphone Permission';

  @override
  String get aiMicPermissionBody =>
      'Microphone access is required to record voice messages. Please enable it in your device settings.';

  @override
  String aiFilePickError(String error) {
    return 'Error picking file: $error';
  }

  @override
  String get aiSlideToCancel => 'Slide to cancel';

  @override
  String get aiSlideUpToLock => 'Slide up to lock';

  @override
  String get aiHoldAndSlide => 'Hold & slide to control recording';

  @override
  String get aiExcelAnalysis => 'Excel Analysis';

  @override
  String get aiExcelAnalystTitle => 'AI Excel Business Analyst';

  @override
  String get aiExcelAnalystSubtitle =>
      'Interactive Exploration & Visual Trends';

  @override
  String aiModelDefaultSuffix(String name) {
    return '$name (Default)';
  }

  @override
  String get aiExcelNoData => 'No data found in Excel file';

  @override
  String get aiExcelSourceData => 'Source Data:';

  @override
  String get aiExcelVisualAnalysis => 'Visual Analysis:';

  @override
  String aiChartRenderError(String error) {
    return 'Error rendering chart: $error';
  }

  @override
  String get aiExcelAskForCharts => 'Ask questions to generate charts';

  @override
  String get aiExcelAnalystChat => 'Analyst Chat';

  @override
  String get aiExcelAskHint => 'Ask about this data...';

  @override
  String get aiAssistant => 'AI Assistant';

  @override
  String get aiConversations => 'Conversations';

  @override
  String get aiAdd => 'Add';

  @override
  String get aiNewConversation => 'New Conversation';

  @override
  String get aiDeleteConversation => 'Delete Conversation';

  @override
  String aiDaysAgo(String count) {
    return '${count}d ago';
  }

  @override
  String get aiPurchaseCredits => 'Purchase Credits';

  @override
  String get aiCopied => 'Copied';

  @override
  String get aiProcessingExpandThinking =>
      'AI is processing... Expand thinking to see details.';

  @override
  String get aiHideThinking => 'Hide Thinking';

  @override
  String get aiShowThinking => 'Show Thinking';

  @override
  String get aiWelcomeTitle => 'Your Business AI Assistant';

  @override
  String get aiWelcomeSubtitle =>
      'Ready to help you with insights about your business. Try asking one of the questions below.';

  @override
  String get aiSamplePersonalBooks => 'What are some good books on leadership?';

  @override
  String get aiSamplePersonalEmail =>
      'Help me draft an email to a potential partner.';

  @override
  String get aiSamplePersonalTime =>
      'Give me some tips for better time management.';

  @override
  String get aiSampleBusinessSales => 'What were my total sales last week?';

  @override
  String get aiSampleBusinessTopProducts =>
      'Show me a breakdown of my top-selling products this month.';

  @override
  String get aiSampleBusinessTax =>
      'Generate a tax summary for the last quarter.';

  @override
  String get aiTaxBreakdown => 'TAX BREAKDOWN';

  @override
  String get aiTotalTax => 'TOTAL TAX';

  @override
  String get aiTaxSummaryReport => 'Tax Summary Report';

  @override
  String get aiCopyReport => 'Copy Report';

  @override
  String get aiInventoryVisualization => 'Inventory Visualization';

  @override
  String get aiComingSoon => 'Coming Soon';

  @override
  String get uiTicketDue => 'DUE';

  @override
  String get uiTicketAmount => 'AMOUNT';

  @override
  String get aiYourShop => 'your shop';

  @override
  String get aiBranchIdRequired => 'Branch ID is required';

  @override
  String get aiNoResponse => 'No response was produced. Please try again.';

  @override
  String aiWhatsappSendMessageFailed(String error) {
    return 'Failed to send WhatsApp message: $error';
  }

  @override
  String get aiChartNotFound => 'Error: Could not find chart to copy.';

  @override
  String get aiChartImageFailed => 'Error: Could not generate image data.';

  @override
  String get aiChartCopied => 'Chart copied to clipboard!';

  @override
  String aiChartCopyFailed(String error) {
    return 'Failed to copy chart: $error';
  }

  @override
  String get aiVoiceUnavailable =>
      'Voice input isn\'t available on this platform yet.';

  @override
  String aiVoiceStartFailed(String error) {
    return 'Could not start voice input: $error';
  }

  @override
  String get aiMicAccessOff =>
      'Microphone access is off. Enable it for Flipper in your system settings, then try again.';

  @override
  String aiListenStartFailed(String error) {
    return 'Could not start listening: $error';
  }

  @override
  String get aiVoiceNeedsNetwork =>
      'Voice input needs a network connection right now.';

  @override
  String get aiMicInUse => 'The microphone is in use by another app.';

  @override
  String aiVoiceFailed(String error) {
    return 'Voice input failed ($error).';
  }

  @override
  String get aiLocalUnavailable =>
      'On-device AI is not available on this device.';

  @override
  String get aiLocalPreparing => 'Preparing the on-device model…';

  @override
  String aiLocalLoadFailed(String error) {
    return 'Could not load the on-device model: $error';
  }

  @override
  String get aiLocalReadingShopData => 'Reading your shop data…';

  @override
  String get aiLocalThinking => 'Thinking on-device…';

  @override
  String aiLocalGenerationFailed(String error) {
    return 'On-device generation failed: $error';
  }

  @override
  String get floBriefingSalesComingIn => 'Sales are coming in today.';

  @override
  String floBriefingBody(String revenue, String transactions, String units) {
    return 'Revenue reached <b>RWF $revenue</b> across <b>$transactions</b> ($units units) so far today — live from your device.';
  }

  @override
  String floBriefingTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
    );
    return '$_temp0';
  }

  @override
  String get floStatRevenue => 'Revenue';

  @override
  String get floStatNetProfit => 'Net profit';

  @override
  String get floStatUnitsSold => 'Units sold';

  @override
  String get aiWhatsappNoBusiness =>
      'No business selected — cannot save WhatsApp connection';

  @override
  String get aiWhatsappBusinessNotFound =>
      'Business not found — cannot save WhatsApp connection';

  @override
  String get loginErrorTimeout =>
      'The Flipper server took too long to answer. Your connection may be slow. Try again. (TIMEOUT)';

  @override
  String get loginErrorSessionExpired =>
      'Your session expired. Enter your PIN again. (SESSION)';

  @override
  String get loginErrorPinCheckFailed =>
      'That PIN could not be checked. Try again. (PIN)';

  @override
  String get loginErrorBadResponse =>
      'The Flipper server sent an unexpected response. Try again in a minute. (BAD-RESPONSE)';

  @override
  String get loginErrorTls =>
      'Secure connection failed. Make sure your phone\'s date and time are set automatically, then try again. (TLS)';

  @override
  String get loginErrorTlsNetwork =>
      'The connection to the Flipper server dropped before it was secured. Your network may be unstable. Try again, or switch between mobile data and Wi-Fi. (TLS-NET)';

  @override
  String get loginErrorDns =>
      'Can\'t find the Flipper server. Your internet may be off or limited. Check mobile data or Wi-Fi. (DNS)';

  @override
  String get loginErrorNetwork =>
      'Couldn\'t reach the Flipper server. Check your internet connection and try again. (NET)';

  @override
  String get loginErrorOfflineFirst =>
      'This phone can\'t sign you in offline yet. Connect to the internet and sign in once, then offline sign-in will work. (OFFLINE-FIRST)';

  @override
  String get loginErrorUnknown => 'Sign-in failed. Try again. (UNKNOWN)';

  @override
  String get loginErrorNoAccountForPin =>
      'No account uses this PIN. Check the PIN and try again. (PIN-404)';

  @override
  String get loginErrorHttp404 =>
      'The Flipper server could not find what the app asked for. Update the app and try again. (HTTP-404)';

  @override
  String get loginErrorHttp429 =>
      'Too many attempts. Wait a minute, then try again. (HTTP-429)';

  @override
  String loginErrorHttpRefused(String status) {
    return 'The Flipper server refused this request. Update the app and try again. (HTTP-$status)';
  }

  @override
  String loginErrorHttpServer(String status) {
    return 'Flipper servers are having trouble right now. Try again in a minute. (HTTP-$status)';
  }

  @override
  String loginErrorHttpOther(String status) {
    return 'The Flipper server could not check this PIN. Try again. (HTTP-$status)';
  }

  @override
  String get loginYourBusiness => 'your business';

  @override
  String get loginPinRequired => 'PIN is required';

  @override
  String get loginPinTooShort => 'PIN must be at least 4 digits';

  @override
  String loginPinTooLong(String max) {
    return 'PIN must be at most $max digits';
  }

  @override
  String get loginAuthenticatorCodeRequired => 'Authenticator code is required';

  @override
  String get loginOtpRequired => 'OTP is required';

  @override
  String get loginAuthenticatorCodeInvalidFormat =>
      'Authenticator code must be a 6-digit number.';

  @override
  String get loginOtpInvalidFormat => 'OTP must be a 6-digit number.';

  @override
  String get loginInvalidPinReenter =>
      'Invalid PIN. Please re-enter and try again.';

  @override
  String get loginAuthenticatorUnavailable =>
      'Could not reach the server to load your authenticator on this device. Check your connection and try again.';

  @override
  String get loginAuthenticatorNotEnrolled =>
      'No authenticator is set up for this account. Sign in with SMS, then set one up under Settings.';

  @override
  String get loginAuthenticatorInvalidCode =>
      'Invalid authenticator code. Please try again.';

  @override
  String get loginPinSubtitle =>
      'Enter your PIN to manage your business securely.';

  @override
  String get loginSignedIn => 'Signed in';

  @override
  String get loginSignIn => 'Sign in';

  @override
  String get loginCreateAnAccount => 'Create an account';

  @override
  String get loginNewToFlipperCreateAccount =>
      'New to Flipper? Create an account';

  @override
  String get loginShowPin => 'Show PIN';

  @override
  String get loginHidePin => 'Hide PIN';

  @override
  String get loginShow => 'Show';

  @override
  String get loginHide => 'Hide';

  @override
  String loginPinDigitsEntered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count digits entered',
      one: '1 digit entered',
    );
    return '$_temp0';
  }

  @override
  String get loginAuthenticator => 'Authenticator';

  @override
  String get loginAuthenticatorCode => 'Authenticator code';

  @override
  String get loginSmsCode => 'SMS code';

  @override
  String get loginPinEntryCells => 'PIN entry cells';

  @override
  String loginVerifiedOpening(String business) {
    return 'Verified — opening $business…';
  }

  @override
  String get loginShowOrHidePin => 'Show or hide PIN';

  @override
  String get loginBackspace => 'Backspace';

  @override
  String get loginSecuredE2e => 'Secured with end-to-end encryption';

  @override
  String get loginBrandHeadline =>
      'Your shop, your team, your numbers — all in one place.';

  @override
  String get loginBrandSubhead =>
      'Pick up right where you left off. Today’s sales, stock, and reports are ready.';

  @override
  String get loginStatBusinesses => 'businesses';

  @override
  String get loginStatProcessedMonthly => 'processed monthly';

  @override
  String get loginStatUptime => 'uptime';

  @override
  String get loginRevenueThisWeek => 'Revenue · this week';

  @override
  String get loginNewSale => 'New sale';

  @override
  String get loginSampleSaleDetail => 'Solar Kit · MoMo';

  @override
  String loginStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get loginSalesStreak => 'Sales streak';

  @override
  String get loginLandingSlide1Title => 'Run your whole\nbusiness from one app';

  @override
  String get loginLandingSlide1Highlight => 'business';

  @override
  String get loginLandingSlide1Text =>
      'Sell, track stock, and manage your team - Flipper is your business in your pocket.';

  @override
  String get loginLandingSlide2Title =>
      'Simple, useful reports\nthat help you grow';

  @override
  String get loginLandingSlide2Highlight => 'reports';

  @override
  String get loginLandingSlide2Text =>
      'See exactly what sells, what\'s running low, and where your money goes - every day.';

  @override
  String get loginLandingSlide3Title => 'Get paid faster,\ntrack every franc';

  @override
  String get loginLandingSlide3Highlight => 'track every franc';

  @override
  String get loginLandingSlide3Text =>
      'Accept MoMo, cash, and card. Flipper records every sale and reconciles it for you.';

  @override
  String get loginLandingSlide4Title => 'Grow your business,\nearn rewards';

  @override
  String get loginLandingSlide4Highlight => 'earn rewards';

  @override
  String get loginLandingSlide4Text =>
      'Hit daily goals, keep your streak alive, and level up from Bronze to Gold Seller.';

  @override
  String get loginLandingSemantic => 'Flipper landing';

  @override
  String get loginNext => 'Next';

  @override
  String get loginSkipIntroSemantic => 'Skip intro and create account';

  @override
  String get loginSkipIntro => 'Skip intro - Create account';

  @override
  String get loginAlreadySellingSignIn => 'Already selling on Flipper? Sign in';

  @override
  String get loginDailyReport => 'Daily report';

  @override
  String get loginStock => 'Stock';

  @override
  String get loginTax => 'Tax';

  @override
  String get loginGoldSeller => 'Gold Seller';

  @override
  String get loginFinalizingAuthentication => 'Finalizing authentication...';

  @override
  String get loginAuthTimedOut => 'Authentication timed out. Please try again.';

  @override
  String get loginPhoneLoginNavigationFailed =>
      'Failed to navigate to phone login';

  @override
  String get loginSignInFailed => 'Sign in failed';

  @override
  String get loginAuthenticationFailed => 'Authentication failed';

  @override
  String get loginUnexpectedError => 'An unexpected error occurred';

  @override
  String get loginAuthDomainUnauthorized =>
      'Authentication domain not authorized. Please contact support.';

  @override
  String get loginAccountDisabled => 'This account has been disabled.';

  @override
  String get loginAccountExistsDifferentCredential =>
      'An account already exists with the same email address but different sign-in credentials.';

  @override
  String loginMicrosoftFailedWithReason(String error) {
    return 'Microsoft login failed: $error';
  }

  @override
  String get loginMicrosoftFailed =>
      'Microsoft login failed. Please try again later.';

  @override
  String loginAppleAuthorizationFailed(String error) {
    return 'Apple authorization failed: $error';
  }

  @override
  String loginAppleFailed(String error) {
    return 'Apple login failed: $error';
  }

  @override
  String get loginWelcomeToFlipper => 'Welcome to Flipper';

  @override
  String get loginHowToSignIn => 'How would you like to sign in?';

  @override
  String get loginLoggingIn => 'Logging in...';

  @override
  String get loginTryAgainOrUsePin => 'Please try again or use PIN login';

  @override
  String get loginSuccessful => 'Login successful!';

  @override
  String get loginQrScanned => 'QR Code scanned! Completing login...';

  @override
  String get loginFailedTryAgain => 'Login failed. Please try again.';

  @override
  String get loginSuccessfulRedirecting => 'Login successful! Redirecting...';

  @override
  String get loginQrTitle => 'Log in to Flipper by QR Code';

  @override
  String get loginQrStep1 => '1. Open Flipper on your phone';

  @override
  String get loginQrStep2 => '2. Go to Profile Icon > LongPress on it.';

  @override
  String get loginQrStep3 =>
      '3. Point your phone at this screen to confirm login';

  @override
  String get loginDownloadApp => 'Don\'t have the Flipper app? Download it:';

  @override
  String get loginOpeningAppStore => 'Opening App Store...';

  @override
  String get loginOpeningPlayStore => 'Opening Play Store...';

  @override
  String get loginSwitchToPin => 'Switch to PIN login';

  @override
  String get loginDeviceOffline => 'Device is offline';

  @override
  String get loginInvalidEmail => 'Invalid Email';

  @override
  String get loginGmailRequired => 'Gmail Email is required';

  @override
  String get loginEnterEmail => 'Enter Email';

  @override
  String get loginAddEmailHint =>
      'After entering your email, click on add email';

  @override
  String get signupErrorGeneric => 'An error occurred during signup';

  @override
  String get signupOtpExpiredOrInvalid =>
      'OTP expired or invalid. Please request a new code.';

  @override
  String get signupResendOtp => 'Resend OTP';

  @override
  String get signupNewOtpSent => 'New OTP sent successfully!';

  @override
  String signupFailedToResendOtp(String error) {
    return 'Failed to resend OTP: $error';
  }

  @override
  String get signupUsername => 'Username';

  @override
  String get signupUsernameHint => 'Enter your username';

  @override
  String get signupFullName => 'Full Name';

  @override
  String get signupFullNameHint => 'First name, Last name';

  @override
  String get signupPhoneOrEmail => 'Phone / Email';

  @override
  String get signupPhoneOrEmailHint => '783054874 or your@email.com';

  @override
  String get signupOtpResent => 'OTP resent successfully!';

  @override
  String get signupResend => 'Resend';

  @override
  String get signupOtpSent => 'OTP sent successfully!';

  @override
  String signupFailedToSendOtp(String error) {
    return 'Failed to send OTP: $error';
  }

  @override
  String get signupSendCode => 'Send Code';

  @override
  String get signupOtpCode => 'OTP Code';

  @override
  String get signupOtpHint => 'Enter the 6-digit OTP';

  @override
  String get signupPhoneVerified => 'Phone number verified successfully!';

  @override
  String get signupUsage => 'Usage';

  @override
  String get signupCountry => 'Country';

  @override
  String get signupSearchCountry => 'Search your country';

  @override
  String get signupStepIdentity => 'Identity';

  @override
  String get signupStepVerify => 'Verify';

  @override
  String signupStepOf(String step, String total) {
    return 'Step $step of $total';
  }

  @override
  String get signupRewardTitle => 'Finish setup to unlock 500 points';

  @override
  String get signupRewardSubtitle =>
      'Spend points on lower fees & premium reports';

  @override
  String get signupStep1Title => 'Who are you?';

  @override
  String get signupStep1Description =>
      'This is how you’ll sign in and how teammates find you.';

  @override
  String get signupStep2Title => 'How do we reach you?';

  @override
  String get signupStep2Description =>
      'We’ll send a one-time code to verify it’s really you.';

  @override
  String get signupStep3Title => 'Tell us about your shop';

  @override
  String get signupStep3Description => 'We’ll tailor Flipper to how you sell.';

  @override
  String get signupCreateAccountClaim => 'Create account · claim 500 pts';

  @override
  String signupTermsAgreement(String terms, String privacy) {
    return 'By continuing you agree to Flipper’s $terms & $privacy';
  }

  @override
  String get signupTermsLink => 'Terms';

  @override
  String get signupPrivacyLink => 'Privacy';

  @override
  String get signupVerificationFailed => 'Verification failed';

  @override
  String get signupNameTooLong => 'Name is too long';

  @override
  String get signupContactRequired => 'Phone number or email is required';

  @override
  String get signupContactInvalid =>
      'Please enter a valid phone number or email address';

  @override
  String get signupUsernameRequired => 'Username/business name is required';

  @override
  String get signupUsernameTaken => 'That username is already taken';

  @override
  String get signupUsernameCheckUnavailable => 'Name search not available';

  @override
  String get signupOtpMustBe6Digits => 'OTP must be 6 digits';

  @override
  String get signupOtpDigitsOnly => 'OTP must contain only digits';

  @override
  String get signupValidateTin => 'Please validate TIN';

  @override
  String get signupPhoneMustBeVerified => 'Phone number must be verified';

  @override
  String get signupFieldRequired => 'This field is required.';

  @override
  String get signupSelectOption => 'Please select an option';

  @override
  String get signupJoinFlipper => 'Join Flipper';

  @override
  String get signupJourneyTagline => 'Start your journey with us today 🚀';

  @override
  String get signupNoMatches => 'No matches';

  @override
  String get signupTinExtractFailed =>
      'Could not extract TIN from the provided document';

  @override
  String signupTinPdfError(String error) {
    return 'Error processing PDF: $error';
  }

  @override
  String signupTinValidated(String name) {
    return 'TIN validated: $name';
  }

  @override
  String get signupTinNoData => 'No data found for this TIN';

  @override
  String get signupTinServiceUnavailable =>
      'Service Unavailable: Validation skipped';

  @override
  String signupTinValidationError(String error) {
    return 'Error validating TIN: $error';
  }

  @override
  String get phoneAuthSelectCountryTitle =>
      'Select the country where your business is located';

  @override
  String get phoneAuthSearchCountry => 'Search country...';

  @override
  String get phoneAuthAgreeSellerAgreement =>
      'I agree to Flipper\'s Seller Agreement and Privacy Policy.';

  @override
  String get phoneAuthRecaptchaNotice =>
      'This app is protected by reCAPTCHA Enterprise and Google Privacy Policy and Terms of Service apply.';

  @override
  String get phoneAuthEnterPhone => 'Please enter your phone number';

  @override
  String get phoneAuthInvalidPhone => 'Please enter a valid phone number';

  @override
  String get phoneAuthTitle => 'Phone Verification';

  @override
  String get phoneAuthSubtitle =>
      'We\'ll send a verification code to your phone number to verify your identity.';

  @override
  String get phoneAuthPhoneHint => '783054874 (without leading 0)';

  @override
  String phoneAuthTermsAgreement(String terms, String privacy) {
    return 'By continuing, you agree to our $terms and $privacy';
  }

  @override
  String get phoneAuthTermsOfService => 'Terms of Service';

  @override
  String get phoneAuthPrivacyPolicy => 'Privacy Policy';

  @override
  String get phoneAuthVerificationCode => 'Verification Code';

  @override
  String get phoneAuthChangeNumber => 'Change Phone Number';

  @override
  String phoneAuthVerificationFailed(String error) {
    return 'Verification failed: $error';
  }

  @override
  String get phoneAuthUnknownError => 'An unknown error occurred';

  @override
  String phoneAuthErrorOccurred(String error) {
    return 'An error occurred: $error';
  }

  @override
  String get phoneAuthNewCodeSent => 'New verification code sent';

  @override
  String get phoneAuthEnterValidCode => 'Please enter a valid 6-digit code';

  @override
  String get phoneAuthCodeExpired =>
      'This verification code has expired. Please request a new one.';

  @override
  String phoneAuthFailedToVerify(String error) {
    return 'Failed to verify code: $error';
  }

  @override
  String phoneAuthAuthFailed(String error) {
    return 'Authentication failed: $error';
  }

  @override
  String get loginFailed => 'Login failed';
}
