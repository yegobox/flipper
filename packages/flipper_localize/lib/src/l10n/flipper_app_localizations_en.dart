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
}
