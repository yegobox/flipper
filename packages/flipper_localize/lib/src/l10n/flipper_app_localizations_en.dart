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
  String get branchNotAvailable => 'Branch not available';

  @override
  String get branchSelectBranch => 'Select branch';

  @override
  String get branchSwitchBranch => 'Switch branch';

  @override
  String get branchUnnamed => 'Unnamed branch';

  @override
  String get compositeCost => 'Cost';

  @override
  String notificationsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Notifications',
      one: '1 Notification',
    );
    return '$_temp0';
  }

  @override
  String get notificationsNew => 'New Notification';

  @override
  String get purchaseCodeErrorTryAgain =>
      'An error occurred. Please try again.';

  @override
  String get countryOfOriginSelect => 'Select Country of Origin';

  @override
  String get countryOfOriginLoadFailed => 'Failed to load countries';

  @override
  String get orderStatusPending => 'Pending';

  @override
  String get menuChat => 'Chat';

  @override
  String get backupConfiguration => 'BackUp Configuration';

  @override
  String get backupEnableAuto => 'Enable Auto Backup';

  @override
  String get dashDismiss => 'Dismiss';

  @override
  String get favoritesSetProduct => 'Set Favorite Product';

  @override
  String dashFieldRequired(String field) {
    return '$field is required';
  }

  @override
  String get supplierSelect => 'Select Supplier';

  @override
  String get searchProductsTransactionsHint =>
      'Search products, transactions...';

  @override
  String get compositeItem => 'Composite Item';

  @override
  String get branchOrders => 'Branch Orders';

  @override
  String get rowsPerPage => 'Rows Per Page';

  @override
  String get pleaseEnterANumber => 'Please enter a number';

  @override
  String get ordersNoOrders => 'No Orders';

  @override
  String get ordersNoneAtTheMoment =>
      'You don\'t have any orders at the moment.';

  @override
  String get ordersIncomingWillAppear => 'Incoming orders will appear here!';

  @override
  String get productTypeSelect => 'Select Product Type';

  @override
  String get productTypeRawMaterial => 'Raw Material';

  @override
  String get productTypeFinishedProduct => 'Finished Product';

  @override
  String get productTypeServiceWithoutStock => 'Service without stock';

  @override
  String get compositeSkuRequired => 'SKU is required';

  @override
  String get compositeBarcodeRequired => 'Bar code is required';

  @override
  String get compositeBarcode => 'Bar Code';

  @override
  String get tenantRefreshUserList => 'Refresh user list';

  @override
  String get categorySearchHint => 'Search categories...';

  @override
  String get categoryNoneFound => 'No categories found';

  @override
  String get categoryAdd => 'Add Category';

  @override
  String get stockLevel => 'Stock Level';

  @override
  String get stockCurrentValue => 'Current Stock Value';

  @override
  String get dateSelect => 'Select Date';

  @override
  String get dateReportPeriod => 'REPORT PERIOD';

  @override
  String get dateApply => 'Apply';

  @override
  String get dateApplyingRange => 'Applying date range…';

  @override
  String get posCompleteNow => 'Complete Now';

  @override
  String get downloadExcelSpreadsheet => 'Excel Spreadsheet';

  @override
  String get downloadDownloaded => 'Downloaded';

  @override
  String downloadProgress(String percent) {
    return 'Downloading: $percent%';
  }

  @override
  String downloadSavedTo(String path) {
    return 'Downloaded to: $path';
  }

  @override
  String get downloadClickToDownload => 'Click to download';

  @override
  String get orderingLoadingProducts => 'Loading products...';

  @override
  String get searchProductHint => 'Search';

  @override
  String get searchProductAllProducts => 'All Products';

  @override
  String get searchProductFavorites => 'Favorites';

  @override
  String get refundReasonCustomerRequest => 'Customer request';

  @override
  String get refundReasonWrongItem => 'Wrong item';

  @override
  String get refundReasonDamaged => 'Damaged / faulty';

  @override
  String get refundReasonDuplicateCharge => 'Duplicate charge';

  @override
  String get taxSettingsUpdated => 'Tax settings updated successfully';

  @override
  String get taxSettingsUpdateError => 'Error updating tax settings';

  @override
  String taxSettingsTaxType(String taxType) {
    return '$taxType Tax';
  }

  @override
  String get taxSettingsRequired => 'Required';

  @override
  String get taxSettingsRange => 'Must be 0-100';

  @override
  String get taxSettingsNoneFound => 'No tax configurations found';

  @override
  String get cartQtySuffix => 'qty';

  @override
  String cartPriceQtyEquivalent(String qty, String unitPrice) {
    return 'Equivalent to $qty units at $unitPrice RWF';
  }

  @override
  String get addProductSingleTitle => 'Single Product';

  @override
  String get addProductSingleSubtitle => 'Add and configure one item';

  @override
  String get addProductBadgeQuick => 'QUICK';

  @override
  String get addProductBulkTitle => 'Bulk Add';

  @override
  String get addProductBulkSubtitle => 'Import multiple products at once';

  @override
  String get addProductBadgeFast => 'FAST';

  @override
  String get addProductRoomsTitle => 'Add Rooms';

  @override
  String get addProductRoomsSubtitle => 'Hotel & accommodation';

  @override
  String get addProductBadgeHotel => 'HOTEL';

  @override
  String get addProductFuelTitle => 'Sync Fuel';

  @override
  String get addProductFuelSubtitle => 'Diesel & gasoline from RRA';

  @override
  String get addProductBadgeFuel => 'FUEL';

  @override
  String get addProductChooseHow => 'Choose how you\'d like to add';

  @override
  String scanNoVariantsFor(String query) {
    return 'No variants found for \"$query\"';
  }

  @override
  String scanErrorSearching(String error) {
    return 'Error searching for variants: $error';
  }

  @override
  String get scanNoVariantsAvailable => 'No variants available';

  @override
  String get scanSelectVariant => 'Select Product Variant';

  @override
  String get scanSearchByNameOrBarcode => 'Search by name or barcode';

  @override
  String get scanNoMatchingVariants => 'No matching variants found';

  @override
  String scanRetailPrice(String price) {
    return 'Retail Price: $price';
  }

  @override
  String scanBarcode(String barcode) {
    return 'Barcode: $barcode';
  }

  @override
  String scanErrorShowing(String error) {
    return 'Error showing variants: $error';
  }

  @override
  String get productCreate => 'Create Product';

  @override
  String get productLabel => 'Product';

  @override
  String get productNameHint => 'Product Name';

  @override
  String get productPriceAndInventory => 'PRICE AND INVENTORY';

  @override
  String get productExpiryDate => 'Expiry Date';

  @override
  String productExpiresAt(String date) {
    return 'Expires at $date';
  }

  @override
  String get productAddVariation => 'Add Variation';

  @override
  String get productProvideName => 'Provide name for the product';

  @override
  String get productUnsavedDiscard =>
      'You have unsaved product, do you want to discard?';

  @override
  String get variantsTax => 'Tax';

  @override
  String get variantsUnit => 'Unit';

  @override
  String get variantsClassification => 'Classification';

  @override
  String get variantsExpiration => 'Expiration';

  @override
  String get variantsAction => 'Action';

  @override
  String get checkoutNoCustomer => 'No customer';

  @override
  String get checkoutWalkIn => 'Walk-in';

  @override
  String get checkoutTotal => 'Total';

  @override
  String get checkoutReviewAndPay => 'Review & Pay';

  @override
  String get checkoutReviewAndSend => 'Review & Send';

  @override
  String get checkoutCouldNotOpen =>
      'Could not open checkout for this cart. Please try again.';

  @override
  String get checkoutScan => 'Scan';

  @override
  String get checkoutItemsNotAvailable => 'Items not available';

  @override
  String checkoutErrorLoadingItemsDetail(String error) {
    return 'Error loading items: $error';
  }

  @override
  String get checkoutErrorLoadingItems => 'Error loading Items';

  @override
  String get checkoutStatusOpen => 'Open';

  @override
  String get checkoutStatusCompleted => 'Completed';

  @override
  String get reportsBusinessAnalytics => 'Business Analytics';

  @override
  String get reportsStockValue => 'Stock Value';

  @override
  String get reportsTotalSales => 'Total Sales';

  @override
  String get reportsProfit => 'Profit';

  @override
  String get reportsLoading => 'Loading...';

  @override
  String get reportsStockPerformance => 'Stock Performance';

  @override
  String get reportsErrorLoadingChart => 'Error loading chart data';

  @override
  String get reportsInsufficientData => 'Insufficient data for chart';

  @override
  String get reportsDetailedMetrics => 'Detailed Metrics';

  @override
  String get reportsErrorLoadingMetrics => 'Error loading metrics';

  @override
  String get branchesTitle => 'Branches';

  @override
  String get branchesAddNew => 'Add New Branch';

  @override
  String get branchesName => 'Branch Name';

  @override
  String get branchesNameHint => 'Enter branch name';

  @override
  String get branchesLocationHint => 'Enter branch location';

  @override
  String get branchesCreate => 'Create Branch';

  @override
  String get branchesAll => 'All Branches';

  @override
  String get branchesLoadFailed => 'Could not load branches';

  @override
  String get branchesNoneFound => 'No branches found';

  @override
  String get dashUnknown => 'Unknown';

  @override
  String get branchesDefaultBadge => 'Default';

  @override
  String get branchesActiveBadge => 'Active';

  @override
  String get branchesDelete => 'Delete Branch';

  @override
  String get branchesDefaultCannotDelete =>
      'The default branch cannot be deleted';

  @override
  String get branchesKeepOne => 'You must keep at least one branch';

  @override
  String branchesDeleteConfirm(String name) {
    return 'Are you sure you want to delete $name?';
  }

  @override
  String get branchesDeleteFailed => 'Could not delete branch';

  @override
  String get branchesAddError => 'Error adding branch';

  @override
  String get branchesNameRequired => 'Branch name is required';

  @override
  String get branchesLocationRequired => 'Location is required';

  @override
  String get roomAdd => 'Add Room';

  @override
  String get roomNumber => 'Room No.';

  @override
  String get roomType => 'Room Type';

  @override
  String get roomSelect => 'Select';

  @override
  String get roomSelectTypeError => 'Please select a room type';

  @override
  String get roomPricePerNight => 'Price Per Night';

  @override
  String get roomTaxCode => 'Tax Code';

  @override
  String get roomSelectTaxCodeError => 'Please select a tax code';

  @override
  String get roomTaxExemptShort => 'Exempt';

  @override
  String get roomTaxStandardRate => 'Standard Rate';

  @override
  String get roomTaxReducedRate => 'Reduced Rate';

  @override
  String get roomTaxNonVat => 'Non-VAT';

  @override
  String get roomTaxExempt => 'Tax Exempt';

  @override
  String get roomTaxExemptHint => 'Exempt this room from VAT';

  @override
  String get roomAddedSuccess => 'Room added successfully';

  @override
  String roomAddError(String error) {
    return 'Error adding room: $error';
  }

  @override
  String get roomTypeSingle => 'Single';

  @override
  String get roomTypeDouble => 'Double';

  @override
  String get roomTypeSuite => 'Suite';

  @override
  String get roomTypeDeluxe => 'Deluxe';

  @override
  String get branchSwitchedRefreshing => 'Branch switched. Refreshing data...';

  @override
  String get branchDefault => 'Default Branch';

  @override
  String get branchLoggingOut => 'We are logging you out...';

  @override
  String branchSwitchedTo(String branch) {
    return 'Switched to $branch';
  }

  @override
  String branchSwitchingTo(String branch) {
    return 'Switching to $branch…';
  }

  @override
  String get branchSwitchTitle => 'Switch Branch';

  @override
  String get branchActive => 'Active branch';

  @override
  String get branchLoading => 'Loading branches…';

  @override
  String get branchNoneAvailable => 'No branches available';

  @override
  String get branchSearchHint => 'Search branches…';

  @override
  String get gaugeIncorrectWidgetType => 'Incorrect widget type';

  @override
  String get gaugeFinancialOverview => 'Financial Overview';

  @override
  String get gaugeReadyToTrack => 'Ready to start tracking!';

  @override
  String get gaugeTransactionsWillAppear =>
      'Your transactions will appear here once you start adding them.';

  @override
  String gaugeNoRecordsFor(String period) {
    return 'No records for $period';
  }

  @override
  String get gaugeTryDifferentPeriod =>
      'Try selecting a different time period or add some transactions.';

  @override
  String get gaugeRecentTransactions => 'Recent Transactions';

  @override
  String get gaugeLast30Days => 'Last 30 days';

  @override
  String get gaugeWaitingMomo => 'WAITING MOMO';

  @override
  String get gaugeLoadingTransactions => 'Loading transactions...';

  @override
  String get gaugeSomethingWentWrong => 'Something went wrong';

  @override
  String get gaugePeriodToday => 'Today';

  @override
  String get gaugePeriodThisWeek => 'This Week';

  @override
  String get gaugePeriodThisMonth => 'This Month';

  @override
  String get gaugePeriodThisYear => 'This Year';

  @override
  String get deliveryDriverAppTitle => 'Delivery Driver App';

  @override
  String get deliveryOnline => 'Online';

  @override
  String get deliveryOffline => 'Offline';

  @override
  String get deliveryCurrentPickup => 'Current Pickup';

  @override
  String get deliveryConfirmPickup => 'Confirm Pickup';

  @override
  String get deliveryUpcoming => 'Upcoming Deliveries';

  @override
  String deliveryOrderNumber(String id) {
    return 'Order #$id';
  }

  @override
  String deliveryPickupLine(String place) {
    return 'Pickup: $place';
  }

  @override
  String deliveryDeliverTo(String name) {
    return 'Deliver to: $name';
  }

  @override
  String get deliveryYouAreOffline => 'You are offline';

  @override
  String get deliveryGoOnline => 'Go online to start receiving deliveries';

  @override
  String get sideMenuOverview => 'Overview';

  @override
  String get sideMenuAuthenticator => 'Authenticator';

  @override
  String get sideMenuKitchenDisplay => 'Kitchen Display';

  @override
  String get sideMenuStockRecount => 'Stock Recount';

  @override
  String get sideMenuDelegations => 'Delegations';

  @override
  String get sideMenuIncomingOrders => 'Incoming Orders';

  @override
  String get sideMenuTransfersReport => 'Transfers Report';

  @override
  String get sideMenuProductionOutput => 'Production Output';

  @override
  String get sideMenuTransactions => 'Transactions';

  @override
  String get sideMenuAnalytics => 'Analytics';

  @override
  String get sideMenuShiftHistory => 'Shift History';

  @override
  String get sideMenuAgentCommission => 'Agent commission';

  @override
  String get sideMenuEndShift => 'End shift';

  @override
  String get ipmPageErrorLoading => 'Error loading data';

  @override
  String get ipmPageNoImports => 'No imported items';

  @override
  String get ipmPageNoImportsHint => 'Sync from RRA to fetch new import items.';

  @override
  String get ipmPageNoPurchases => 'No purchase invoices';

  @override
  String get ipmPageNoPurchasesHint =>
      'Sync from RRA or record a purchase manually.';

  @override
  String get ipmPageRetrySucceeded => 'Retry succeeded';

  @override
  String ipmPageRetryFailed(String error) {
    return 'Retry failed: $error';
  }

  @override
  String get ipmPageMissingPricing =>
      'One of the items to approve is missing required pricing';

  @override
  String ipmPageApprovedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Approved $count items',
      one: 'Approved 1 item',
    );
    return '$_temp0';
  }

  @override
  String ipmPageApproveItemsFailed(String error) {
    return 'Could not approve items: $error';
  }

  @override
  String get ipmPageSetBothPrices => 'Please set both retail and supply prices';

  @override
  String ipmPageApprovedItem(String name) {
    return 'Approved \"$name\"';
  }

  @override
  String ipmPageApproveItemFailed(String error) {
    return 'Could not approve item: $error';
  }

  @override
  String ipmPageRejectedItem(String name) {
    return 'Rejected \"$name\"';
  }

  @override
  String ipmPageRejectItemFailed(String error) {
    return 'Could not reject item: $error';
  }

  @override
  String get importsColNo => 'No.';

  @override
  String get importsColItemName => 'Item Name';

  @override
  String get importsColHsCode => 'HS Code';

  @override
  String get importsColRetailPrice => 'Retail Price';

  @override
  String get importsColSupplyPrice => 'Supply Price';

  @override
  String get importsColStatus => 'Status';

  @override
  String get importsColSupplier => 'Supplier';

  @override
  String get importsColDate => 'Date';

  @override
  String get importsWait => 'Wait';

  @override
  String get importsRejected => 'Rejected';

  @override
  String get importsApprove => 'Approve';

  @override
  String get importsReject => 'Reject';

  @override
  String importsApproveError(String error) {
    return 'Error approving item: $error';
  }

  @override
  String importsRejectError(String error) {
    return 'Error rejecting item: $error';
  }

  @override
  String get importsNoData =>
      'No Data Found or Network error please try again.';

  @override
  String get importsNoMatches => 'No matches found for the selected filter.';

  @override
  String get refundUnavailable => 'Refund unavailable';

  @override
  String refundWithAmount(String amount) {
    return 'Refund $amount';
  }

  @override
  String get refundReceiptCannotBeRefunded => 'This receipt cannot be refunded';

  @override
  String get refundNoCopyToPrint =>
      'This receipt does not have a copy to print';

  @override
  String get refundTransactionTitle => 'Transaction';

  @override
  String get refundCopied => 'Copied';

  @override
  String get refundPayerDiffers => 'differs from customer';

  @override
  String get refundTaxIncluded => 'Tax included';

  @override
  String get refundAmountLabel => 'Refund amount';

  @override
  String get refundPrintCopy => 'Print copy receipt';

  @override
  String get refundStatusPartiallyRefunded => 'Partially refunded';

  @override
  String get refundStatusParked => 'Parked';

  @override
  String refundSaleSubtitle(String payment) {
    return '$payment sale';
  }

  @override
  String get refundPaymentCard => 'Card';

  @override
  String get ebmNoActiveBranch => 'No active branch found';

  @override
  String get ebmTinRequired => 'TIN is required';

  @override
  String get ebmBhfIdRequired => 'BHF ID is required';

  @override
  String get ebmDeviceSerial => 'Device Serial Number';

  @override
  String get ebmDeviceSerialRequired => 'Device Serial Number is required';

  @override
  String get ebmProcessing => 'Processing...';

  @override
  String get ebmReinitialize => 'Re-initialize';

  @override
  String ebmInitFailed(String error) {
    return 'Failed to initialize EBM: $error';
  }

  @override
  String get ebmInitSuccess => 'EBM Initialized Successfully';

  @override
  String get ebmTaxpayerName => 'Taxpayer Name';

  @override
  String get searchCustomerType => 'Customer Type';

  @override
  String get searchSaleType => 'Sale Type';

  @override
  String get searchAssignAgent => 'Assign agent';

  @override
  String get searchAgent => 'Agent';

  @override
  String get searchCustomerTypeShop => 'Shop';

  @override
  String get searchSaleTypeOutgoing => 'Outgoing sale';

  @override
  String get searchSaleTypeAgent => 'Agent Sale';

  @override
  String get fuelSelectBranchFirst => 'Select a branch before syncing fuel.';

  @override
  String get fuelBusinessMissing => 'Business context is missing.';

  @override
  String get fuelVatRequired =>
      'VAT / EBM must be enabled to sync regulated fuel products.';

  @override
  String get fuelContactingConnector => 'Contacting data-connector…';

  @override
  String get fuelFetchingCatalog => 'Fetching fuel catalog from RRA…';

  @override
  String get fuelWaitingForSync => 'Waiting for Ditto sync…';

  @override
  String fuelVariantsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count variants',
      one: '1 variant',
    );
    return '$_temp0';
  }

  @override
  String get fuelSyncExplanation =>
      'Imports regulated fuel products from RRA. Manual fuel registration is not allowed — use this sync instead.';

  @override
  String get fuelProductName => 'Product name';

  @override
  String get fuelProductNameRequired => 'Product name is required';

  @override
  String get fuelEnableVat => 'Enable VAT on this branch before syncing fuel.';

  @override
  String get fuelSyncing => 'Syncing…';

  @override
  String get fuelSyncFromRra => 'Sync from RRA';

  @override
  String get editQtyCannotBeNegative => 'Quantity cannot be negative';

  @override
  String editQtyRraFloor(String floor) {
    return 'Stock reported to RRA can only be increased here. Use a stock adjustment to go below $floor.';
  }

  @override
  String get editQtyServiceNotice =>
      'Services do not carry stock. Saving keeps this variant at 0.';

  @override
  String editQtyCannotGoBelow(String floor) {
    return 'Cannot go below $floor';
  }

  @override
  String editQtyAdds(String qty) {
    return 'Adds $qty to current stock.';
  }

  @override
  String editQtyRemoves(String qty) {
    return 'Removes $qty from current stock.';
  }

  @override
  String editQtyStays(String qty) {
    return 'Stock stays at $qty.';
  }

  @override
  String get editQtyGotIt => 'Got it';

  @override
  String get editQtyUpdateStock => 'Update stock';

  @override
  String get editQtyTitle => 'Edit quantity';

  @override
  String editQtyOnHand(String qty) {
    return 'On hand $qty';
  }

  @override
  String get creditHubTitle => 'Credit Hub';

  @override
  String get creditHubAddCredits => 'Add Credits';

  @override
  String get creditHubUseCredits => 'Use Credits';

  @override
  String creditHubUseAmount(int amount) {
    return 'Use $amount';
  }

  @override
  String get creditHubAvailable => 'Available Credits';

  @override
  String get creditHubCredits => 'Credits';

  @override
  String get creditHubQuickAdd => 'Quick Add';

  @override
  String get creditHubEnterAmount => 'Enter amount';

  @override
  String creditHubUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Used $count credits',
      one: 'Used 1 credit',
    );
    return '$_temp0';
  }

  @override
  String creditHubAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count credits added successfully',
      one: '1 credit added successfully',
    );
    return '$_temp0';
  }

  @override
  String get creditHubInvalidAmount => 'Please enter a valid amount';

  @override
  String creditHubMaximum(int max) {
    return 'Maximum: $max';
  }

  @override
  String get customerFormNewBusiness => 'New business';

  @override
  String get customerFormNewCustomer => 'New customer';

  @override
  String get customerFormNoPhone => 'No phone yet';

  @override
  String get customerFormType => 'Customer type';

  @override
  String get customerFormBusinessName => 'Business name';

  @override
  String get customerFormFullName => 'Full name';

  @override
  String get customerFormBusinessNameHint => 'e.g. Kigali Traders Ltd';

  @override
  String get customerFormFullNameHint => 'e.g. Jean Mukamana';

  @override
  String get customerFormEmail => 'Email address';

  @override
  String get customerFormTinHint => 'Tax ID for invoices';

  @override
  String get customerFormUpdated => 'Customer updated successfully!';

  @override
  String get customerFormAddedAttached => 'Customer added and attached';

  @override
  String get customerFormAddFailed => 'Failed to add customer';

  @override
  String get customerFormSaveChanges => 'Save changes';

  @override
  String get customerFormAddAttach => 'Add & attach customer';

  @override
  String get customerFormOptional => 'optional';

  @override
  String get customerFormIndividual => 'Individual';

  @override
  String get backupNow => 'Backup now';

  @override
  String get backupCreated => 'Backup created';

  @override
  String get syncTitle => 'Sync';

  @override
  String get syncEnable => 'Enable Sync';

  @override
  String get qrCode => 'QR Code';

  @override
  String get qrMode => 'QR Mode';

  @override
  String get qrModeEnable => 'Enable QR Mode';

  @override
  String get qrModeEmailNotGmail => 'Added email is not gmail';

  @override
  String get appChoicePosSubtitle => 'Sell and take payments';

  @override
  String get appChoiceBooks => 'Books';

  @override
  String get appChoiceBooksSubtitle => 'Accounting and ledgers';

  @override
  String get appChoiceInventorySubtitle => 'Stock and products';

  @override
  String get appChoiceReportsSubtitle => 'Sales and tax analytics';

  @override
  String get appChoiceOrders => 'Orders';

  @override
  String get appChoiceOrdersSubtitle => 'Purchases and transfers';

  @override
  String get appChoiceCustomersSubtitle => 'Contacts and credit';

  @override
  String get appChoiceSettingsSubtitle => 'Devices, tax and staff';

  @override
  String get appChoiceTitle => 'Choose your app';

  @override
  String get appChoiceSubtitle =>
      'Pick where you want to start. You can switch apps any time.';

  @override
  String get appChoiceKeyboardHint =>
      'Press 1–7 to open, arrows to move, Esc to close';

  @override
  String get posBalanceDue => 'Balance due';

  @override
  String get posChange => 'Change';

  @override
  String posTillTicketName(String reference) {
    return 'Till · $reference';
  }

  @override
  String get posSentToTillNote => 'Sent to till for payment';

  @override
  String get posReturnToTillFailed =>
      'Could not return this ticket to the till. Please try again.';

  @override
  String cashbookPersonalGoalNote(String goal) {
    return 'Personal goal: $goal';
  }

  @override
  String get cashbookTitle => 'Cash Book';

  @override
  String get cashbookRecentTransactions => 'Recent transactions';

  @override
  String get cashbookFilterAll => 'All';

  @override
  String get cashbookCashIn => 'Cash in';

  @override
  String get cashbookCashOut => 'Cash out';

  @override
  String get cashbookTotalOut => 'Total out';

  @override
  String get cashbookMomoNet => 'MoMo net';

  @override
  String get cashbookTotalIn => 'Total in';

  @override
  String cashbookNoCashInFor(String period) {
    return 'No cash in transactions for $period.';
  }

  @override
  String cashbookNoCashOutFor(String period) {
    return 'No cash out transactions for $period.';
  }

  @override
  String cashbookNoMomoFor(String period) {
    return 'No MoMo transactions for $period.';
  }

  @override
  String cashbookNoTransactionsFor(String period) {
    return 'No transactions for $period.';
  }

  @override
  String get cashbookReceivedAs => 'Received as';

  @override
  String get cashbookPaidWith => 'Paid with';

  @override
  String get cashbookCashInFor => 'Cash in for (optional)';

  @override
  String get cashbookCashOutFor => 'Cash out for (optional)';

  @override
  String get cashbookNote => 'Note';

  @override
  String get cashbookOptionalNoteHint => 'Optional note...';

  @override
  String get cashbookMoneyIn => 'Money coming in';

  @override
  String get cashbookMoneyOut => 'Money going out';

  @override
  String get cashbookAmountPositive => 'Amount must be greater than zero';

  @override
  String get cashbookNewCategory => 'New';

  @override
  String cashbookCategoriesError(String error) {
    return 'Categories error: $error';
  }

  @override
  String get cashbookSaveEntry => 'Save Entry';

  @override
  String get cashbookCashInSaved => 'Cash in transaction saved successfully';

  @override
  String get cashbookCashOutSaved => 'Cash out transaction saved successfully';

  @override
  String get variantsSelectAll => 'Select all';

  @override
  String get variantsVariant => 'Variant';

  @override
  String get variantsNoDiscount => 'No discount';

  @override
  String variantsPercentOff(String percent) {
    return '$percent% off';
  }

  @override
  String variantsExpires(String date) {
    return 'Expires $date';
  }

  @override
  String get variantsNoExpiry => 'No expiry date';

  @override
  String get variantsLowStock => 'Low stock';

  @override
  String get variantsDiscountPercent => 'Discount %';

  @override
  String get variantsRraItemClass => 'RRA item class';

  @override
  String get variantsSetDate => 'Set date';

  @override
  String variantsPriceLine(String price) {
    return 'Price: $price';
  }

  @override
  String get variantsReorderAt => 'Reorder at';

  @override
  String get variantsImage => 'Image';

  @override
  String get variantsDeleteAllSemantic => 'Delete all variants';

  @override
  String get variantsHideMoreDetails => 'Hide tax, unit & expiry';

  @override
  String get variantsMoreDetails => 'Tax, unit & expiry';

  @override
  String get refundProformaNotRefundable => 'Can not refund a proforma';

  @override
  String get adminPhoneWithCountryCode =>
      'Enter a valid phone number with country code (e.g. +250783054874).';

  @override
  String get adminSmsConfigFailed => 'Failed to update SMS configuration';

  @override
  String get adminWhatsappChannel => 'WhatsApp channel';

  @override
  String get adminWhatsappChannelHint =>
      'Choose how digital receipts and order notifications are sent.';

  @override
  String get adminOpenWaSubtitle =>
      'Local / self-hosted WhatsApp session (channel 1)';

  @override
  String get adminMetaSubtitle =>
      'Official Meta WhatsApp (channel 2). Customers may need to scan a QR to opt in before receipts can send.';

  @override
  String get adminUserFallback => 'User';

  @override
  String get adminEnterDisplayName => 'Enter a display name.';

  @override
  String get adminNotSignedIn => 'Not signed in.';

  @override
  String get adminMissingLoginKey => 'Missing account login key.';

  @override
  String get adminNameUpdated => 'Name updated.';

  @override
  String adminSaveNameFailed(String error) {
    return 'Could not save name: $error';
  }

  @override
  String get adminPhoneSetOnce =>
      'Phone number can only be set once. Contact support to change it.';

  @override
  String get adminPhoneSaved => 'Phone number saved.';

  @override
  String adminSavePhoneFailed(String error) {
    return 'Could not save phone: $error';
  }

  @override
  String get adminEmailAlreadySet =>
      'Email is already set and cannot be changed here.';

  @override
  String get adminInvalidEmail => 'Please enter a valid email address.';

  @override
  String get adminEmailSavedBusinessFailed =>
      'Email saved on your account. Business settings could not be updated.';

  @override
  String get adminEmailUpdated => 'Email updated.';

  @override
  String adminSaveEmailFailed(String error) {
    return 'Could not save email: $error';
  }

  @override
  String get adminLogoUpdated => 'Receipt logo updated.';

  @override
  String adminLogoUpdateFailed(String error) {
    return 'Failed to update logo: $error';
  }

  @override
  String get adminLogoRemoved =>
      'Receipt logo removed. Default logo will be used.';

  @override
  String adminLogoRemoveFailed(String error) {
    return 'Failed to remove logo: $error';
  }

  @override
  String get adminBadge => 'ADMIN';

  @override
  String get adminNoPhoneOnAccount => 'No phone on account';

  @override
  String get adminAddPhone => 'Add phone';

  @override
  String get adminNoEmailSet => 'No email set';

  @override
  String get adminAddEmail => 'Add email';

  @override
  String get adminSmsPhoneNumber => 'SMS Phone Number';

  @override
  String get adminSmsPhoneHint =>
      'Phone number with country code (e.g. +250783054874)';

  @override
  String get adminDefaultWhatsappChannel => 'Default WhatsApp channel';

  @override
  String get adminGroupSalesPricing => 'Sales & pricing';

  @override
  String get adminGroupWorkflow => 'Workflow';

  @override
  String get adminTicketReviewSubtitle =>
      'Require reviewer sign-off and stock-manager handover before a paid ticket is fully completed';

  @override
  String get adminGroupTaxCompliance => 'Tax & compliance';

  @override
  String get adminGroupDataSync => 'Data & sync';

  @override
  String get adminGroupDiagnostics => 'Diagnostics';

  @override
  String get adminCrossDeviceFeatures => 'Cross-device features';

  @override
  String get adminReceiptBranding => 'Receipt branding';

  @override
  String get adminReceiptLogo => 'Receipt Logo';

  @override
  String get adminReceiptLogoHint =>
      'Upload a transparent PNG or JPG under 200KB. The logo appears at the center of printed receipts and falls back to the default if none is provided.';

  @override
  String get adminUploading => 'Uploading...';

  @override
  String get adminUploadLogo => 'Upload Logo';

  @override
  String get adminRemoveLogo => 'Remove logo';

  @override
  String get adminPinSubtitle =>
      'Secure sensitive actions like deleting or editing products';

  @override
  String adminSearchSettings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Search $count settings',
      one: 'Search 1 setting',
    );
    return '$_temp0';
  }

  @override
  String adminNoSettingMatches(String query) {
    return 'No setting matches \"$query\"';
  }

  @override
  String get adminPhoneExampleHint => 'e.g. +250783054874';

  @override
  String get perfUncategorised => 'Uncategorised';

  @override
  String get perfUnits => 'units';

  @override
  String get perfUnnamedItem => 'Unnamed item';

  @override
  String get perfNoItemsTitle => 'No items in this branch yet';

  @override
  String get perfNoItemsMessage =>
      'Add products or record a purchase and stock will show up here.';

  @override
  String get perfHeaderSubtitle => 'Live stock joined to selling pace';

  @override
  String perfItemsTracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items tracked',
      one: '1 item tracked',
    );
    return '$_temp0';
  }

  @override
  String get perfTitle => 'Inventory Dashboard';

  @override
  String get perfRefreshTooltip => 'Refresh stock and sales figures';

  @override
  String get perfCoverUnderADay => 'under a day';

  @override
  String perfCoverDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String perfCoverMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '1 month',
    );
    return '$_temp0';
  }

  @override
  String get perfCoverOverAYear => 'over a year';

  @override
  String get perfWindowToday => 'Today';

  @override
  String get perfWindowTodayLower => 'today';

  @override
  String perfWindowDays(int count) {
    return '$count days';
  }

  @override
  String perfWindowLastDays(int count) {
    return 'the last $count days';
  }

  @override
  String get perfNoMatchesTitle => 'Nothing matches these filters';

  @override
  String get perfNoMatchesMessage =>
      'Clear the search or pick a different filter.';

  @override
  String get perfReadingSales => 'Reading sales…';

  @override
  String get perfMovementUnavailable =>
      'Sales movement unavailable — stock figures only';

  @override
  String perfCompletedSalesIn(int count, String period) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count completed sales in $period',
      one: '1 completed sale in $period',
    );
    return '$_temp0';
  }

  @override
  String perfUnitsAndItems(String units, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$units units · $_temp0';
  }

  @override
  String perfSoldInWindow(String period) {
    return 'Sold · $period';
  }

  @override
  String perfRevenueAndProfit(String revenue, String profit) {
    return '$revenue in · $profit profit';
  }

  @override
  String get perfWaitingForSalesData => 'Waiting for sales data';

  @override
  String get perfNothingToRestock => 'nothing to restock';

  @override
  String get perfTapToSeeThem => 'tap to see them';

  @override
  String get perfReorderNow => 'Reorder now';

  @override
  String get perfWaitingForSellingPace => 'waiting for selling pace';

  @override
  String get perfEveryItemHasRunway => 'every item has runway';

  @override
  String perfUnderDaysLeft(int days) {
    return 'under $days days of stock left';
  }

  @override
  String get perfNoSalesInPeriod => 'No sales in this period';

  @override
  String perfBestSellerInWindow(String period) {
    return 'Best seller · $period';
  }

  @override
  String get perfMeasuredFromSales => 'Measured from completed sales';

  @override
  String perfSoldAndRevenue(String qty, String revenue) {
    return '$qty sold · $revenue in';
  }

  @override
  String get perfPickLongerPeriod => 'Pick a longer period or check the till';

  @override
  String get perfEverythingMoving => 'Everything is moving';

  @override
  String perfTiedUp(String amount) {
    return '$amount tied up';
  }

  @override
  String get perfNotSelling => 'Not selling';

  @override
  String perfEveryItemSold(String period) {
    return 'Every item sold at least once in $period';
  }

  @override
  String perfDeadItems(int count, String period) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items with stock and no sales in $period',
      one: '1 item with stock and no sales in $period',
    );
    return '$_temp0';
  }

  @override
  String get perfCountsMatch => 'Counts match';

  @override
  String perfLost(String amount) {
    return '$amount lost';
  }

  @override
  String get perfStockLoss => 'Stock loss';

  @override
  String get perfFromRecounts => 'From stock recounts in this period';

  @override
  String get perfNoShortfall => 'No shortfall found in recounts';

  @override
  String perfUnitsMissing(String units, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$units units missing across $_temp0';
  }

  @override
  String get perfNoExpiryRisk => 'No expiry risk';

  @override
  String perfItemsAtRisk(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items at risk',
      one: '1 item at risk',
    );
    return '$_temp0';
  }

  @override
  String get perfExpiryWatch => 'Expiry watch';

  @override
  String perfNothingExpiring(int days) {
    return 'Nothing expiring in the next $days days';
  }

  @override
  String perfExpiringWithin(int days) {
    return 'Expired or expiring within $days days';
  }

  @override
  String get perfChartStockOnHand => 'Stock on hand';

  @override
  String perfChartUnitsSold(String period) {
    return 'Units sold · $period';
  }

  @override
  String perfChartRevenue(String period) {
    return 'Revenue · $period';
  }

  @override
  String get perfChartDaysLeft => 'Days of stock left';

  @override
  String get perfChartStockHint => 'Tap a bar to select the item.';

  @override
  String get perfChartSoldHint =>
      'Measured from completed sales. Tap a bar to select.';

  @override
  String get perfChartRevenueHint =>
      'Selling value of what actually left the shelf.';

  @override
  String get perfChartCoverHint =>
      'At the current selling pace — shortest runway first.';

  @override
  String perfTopOf(int shown, int total) {
    return 'top $shown of $total';
  }

  @override
  String perfItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get perfSold => 'Sold';

  @override
  String get perfRevenue => 'Revenue';

  @override
  String get perfStock => 'Stock';

  @override
  String get perfDaysLeft => 'Days left';

  @override
  String get perfNoSellingPace =>
      'No selling pace yet — nothing sold in this period';

  @override
  String get perfNothingToChart => 'Nothing to chart';

  @override
  String perfMovementMeasuredOver(String period) {
    return 'Movement measured over $period';
  }

  @override
  String get perfSellingPace => 'Selling pace';

  @override
  String perfPerDay(String qty) {
    return '$qty/day';
  }

  @override
  String get perfStockLeft => 'Stock left';

  @override
  String get perfNoSales => 'no sales';

  @override
  String get perfSellThrough => 'Sell-through';

  @override
  String get perfReceivedEst => 'Received (est.)';

  @override
  String get perfMissingAtCount => 'Missing at count';

  @override
  String get perfFoundAtCount => 'Found at count';

  @override
  String get perfAlertLevel => 'Alert level';

  @override
  String get perfNotSet => 'not set';

  @override
  String get perfLastSold => 'Last sold';

  @override
  String get perfExpiry => 'Expiry';

  @override
  String get perfExpiredLower => 'expired';

  @override
  String perfInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count days',
      one: 'in 1 day',
    );
    return '$_temp0';
  }

  @override
  String get perfStockUpdated => 'Stock updated';

  @override
  String get perfSortRunsOutSoonest => 'Runs out soonest';

  @override
  String get perfSortLowestStock => 'Lowest stock first';

  @override
  String get perfSortBestSelling => 'Best selling first';

  @override
  String get perfSortHighestValue => 'Highest value first';

  @override
  String get perfSortHighestStock => 'Highest stock first';

  @override
  String get perfSortNameAz => 'Name A–Z';

  @override
  String get perfSearchHint => 'Search item, category, SKU or barcode';

  @override
  String get perfRunningLow => 'Running low';

  @override
  String get perfExpiryRisk => 'Expiry risk';

  @override
  String perfShowingSummary(int shown, int total, String value) {
    return 'Showing $shown of $total items · $value in view';
  }

  @override
  String perfMissingAtLastCount(String qty) {
    return '$qty missing at the last stock count';
  }

  @override
  String get perfExpired => 'Expired';

  @override
  String perfExpiresInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Expires in $count days',
      one: 'Expires in 1 day',
    );
    return '$_temp0';
  }

  @override
  String get perfValue => 'Value';

  @override
  String get perfEmpty => 'empty';

  @override
  String get perfNeedsSalesForPace =>
      'Needs sales in this period to work out a selling pace';

  @override
  String perfSellingPaceTooltip(String pace, String left) {
    return 'Selling $pace/day — $left left';
  }

  @override
  String perfSoldAgainstShelf(String sold, String left) {
    return '$sold sold against $left still on the shelf';
  }

  @override
  String perfSoldOfAvailable(String sold, String available) {
    return '$sold of $available available in the period have sold';
  }

  @override
  String get perfReorder => 'Reorder';

  @override
  String get perfCouldNotLoadStock => 'Could not load stock';

  @override
  String get dpaNoProductName => 'No product name!';

  @override
  String get dpaNoProductSaved => 'No product saved!';

  @override
  String get dpaProductSaved => 'Product saved successfully!';

  @override
  String get dpaProductNotInitialized =>
      'Product not initialized. Please try again.';

  @override
  String get dpaBranchIdNotFound =>
      'Branch ID not found. Please ensure you\'re logged in properly.';

  @override
  String get dpaBusinessIdNotFound =>
      'Business ID not found. Please ensure you\'re logged in properly.';

  @override
  String get dpaAddComponent =>
      'Please add at least one component to the composite product.';

  @override
  String get dpaCompositeSaved => 'Composite product saved successfully!';

  @override
  String get dpaInvalidProductRefSelect =>
      'Invalid product reference. Please select or create a product first.';

  @override
  String get dpaUnexpectedReopen =>
      'We faced unexpected error, close this window and open again';

  @override
  String get dpaInvalidProductRef => 'Invalid product reference';

  @override
  String get dpaUnexpectedError => 'An unexpected error occurred';

  @override
  String get dpaBasics => 'Basics';

  @override
  String get dpaNameColor => 'Name & color';

  @override
  String get dpaProductColor => 'Product color';

  @override
  String get dpaProductNameHint => 'e.g. Fanta Orange 500ml';

  @override
  String get dpaProductNameMinLength =>
      'Product name must be at least 3 characters long';

  @override
  String get dpaPricingCodes => 'Pricing & codes';

  @override
  String get dpaPriceSkuBarcode => 'Price, SKU, barcode';

  @override
  String get dpaRetailPrice => 'Retail price';

  @override
  String get dpaRetailPriceHint => 'What the customer pays';

  @override
  String get dpaPriceRequired => 'Price is required';

  @override
  String get dpaSupplyPrice => 'Supply price';

  @override
  String get dpaSupplyFromComponents => 'Calculated from components';

  @override
  String get dpaComponents => 'Components';

  @override
  String get dpaBillOfMaterials => 'Bill of materials';

  @override
  String get dpaRetailSupply => 'Retail & supply';

  @override
  String get dpaCostPerUnit => 'Your cost per unit';

  @override
  String get dpaInventoryCategorization => 'Inventory & categorization';

  @override
  String get dpaCategoryItemType => 'Category & item type';

  @override
  String get dpaVariantsStock => 'Variants & stock';

  @override
  String get dpaStockScan => 'Stock & scan';

  @override
  String get dpaProductDeleted =>
      'This product could not be loaded. It may have been deleted.';

  @override
  String get dpaProductLoadFailed =>
      'Could not load this product. Please try again.';

  @override
  String get dpaProductSavedTitle => 'Product saved';

  @override
  String get dpaAddedToInventory =>
      'Your product and variants have been added to inventory.';

  @override
  String get dpaVariants => 'Variants';

  @override
  String get dpaAddAnother => 'Add another product';

  @override
  String get dpaAddVariant => 'Add variant';

  @override
  String get dpaEditVariant => 'Edit variant';

  @override
  String get dpaImageUploadFailed =>
      'Could not upload image. Please try again.';

  @override
  String get dpaImageSelected => 'Image selected';

  @override
  String get dpaAddImage => 'Add image';

  @override
  String get dpaVariantName => 'Variant name';

  @override
  String get dpaVariantNameHint => 'e.g. Sandals, Size 10';

  @override
  String get dpaNameRequired => 'Name is required';

  @override
  String get dpaRetailOverride => 'Retail price override';

  @override
  String get dpaLeaveBlankBasePrice => 'Leave blank to use base retail price';

  @override
  String get dpaBarcode => 'Barcode';

  @override
  String get dpaBarcodeHint => 'SKU / barcode (optional)';

  @override
  String get dpaLeaveBlankVariantName => 'Leave blank to use the variant name';

  @override
  String get dpaStockQuantity => 'Stock quantity';

  @override
  String get dpaLowStockReorder => 'Low stock / reorder at';

  @override
  String get dpaLowStockHelper =>
      'Alert when on-hand quantity is at or below this level';

  @override
  String get dpaTaxStandardB => 'Standard B';

  @override
  String get dpaTaxStandardA => 'Standard A';

  @override
  String get dpaTaxNoneD => 'None (D)';

  @override
  String get dpaSaveVariantFailed =>
      'Could not save variant. Please try again.';

  @override
  String get dpaSaveVariant => 'Save variant';

  @override
  String get dpaProductInfo => 'Product info';

  @override
  String get dpaAdvanced => 'Advanced';

  @override
  String get dpaPlusAdd => '+ Add';

  @override
  String get dpaVariantsHint =>
      'Tap a variant to expand · Edit or delete inside · swipe to delete';

  @override
  String get dpaSaveProduct => 'Save product';

  @override
  String get dpaRraTimeout =>
      'RRA tax server timed out. The product is saved locally but not fully reported to RRA yet. Check the tax server, then tap Save again.';

  @override
  String dpaRraReportingFailed(String error) {
    return 'Product saved locally but RRA reporting failed: $error. Tap Save again to retry.';
  }

  @override
  String dpaSaveProductFailed(String error) {
    return 'Could not save product: $error';
  }

  @override
  String dpaCompositeSaveFailed(String error) {
    return 'Failed to save composite product: $error';
  }

  @override
  String dpaNamedProductSaved(String name) {
    return '$name saved!';
  }

  @override
  String dpaBaseRetailPrice(String price) {
    return 'Base retail price: $price';
  }

  @override
  String get dpaNotVatRegistered =>
      'This branch is not VAT-registered. Only \"None\" (D) applies.';

  @override
  String get cartNotEnoughStock => 'You do not have enough stock';

  @override
  String get cartFailedToAddItem => 'Failed to add item to cart';

  @override
  String get sellNoItemSelected => 'No item selected';

  @override
  String get sellChooseOne => 'CHOOSE ONE';

  @override
  String get dashYes => 'Yes';

  @override
  String get dashNo => 'No';

  @override
  String get dashTryAgain => 'Try again';

  @override
  String get securityEnablePasscode => 'Enable Passcode';

  @override
  String get printingConfiguration => 'Printing Configuration';

  @override
  String get printingEnableAutoPrint => 'Enable Auto Print';

  @override
  String get inventoryCart => 'Cart';

  @override
  String inventoryCartWithCount(String count) {
    return 'Cart ($count)';
  }

  @override
  String discountRowAmountOff(String amount, String currency) {
    return '$amount $currency off';
  }

  @override
  String get dashPendingTransactionCopied =>
      'Pending transaction copied to clipboard';

  @override
  String get dashUserFallback => 'User';

  @override
  String get dashPopupDialogOpen => 'Popup dialog open';

  @override
  String get memberFieldAddMember => 'Add member';

  @override
  String get orderViewTitle => 'Order';

  @override
  String get switchBranchAble => 'Able to switch branch';

  @override
  String noNetErrorCheckingConnection(String error) {
    return 'Error checking connection: $error';
  }

  @override
  String get noNetTitle => 'No internet';

  @override
  String get noNetSubtitle =>
      'Can\'t connect to the internet.\nPlease check your internet connection';

  @override
  String get noNetCheckConnection => 'Check Connection';

  @override
  String get noNetGoToLogin => 'Go to Login';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsWhatsNew => 'What\'s new';

  @override
  String get notificationsTakeFirstPayment => 'Take your first payment';

  @override
  String get notificationsLearnFirstPayment =>
      'Learn how to take your first payment.';

  @override
  String get ordersDoneShopping => 'Done shopping?';

  @override
  String get ordersOrderFromSupplier => 'Order from Supplier';

  @override
  String get ordersSelectSupplierHint =>
      'Search and select a supplier to view their products';

  @override
  String ordersSearchProductsFrom(String supplier) {
    return 'Search products from $supplier';
  }

  @override
  String get scannerNoBarcodeValue => 'No barcode value detected.';

  @override
  String scannerProcessingBarcode(String barcode) {
    return 'Processing barcode: $barcode';
  }

  @override
  String scannerProductNotFoundForBarcode(String barcode) {
    return 'Product not found for barcode: $barcode';
  }

  @override
  String scannerErrorAddingProduct(String error) {
    return 'Error adding product: $error';
  }

  @override
  String get subscriptionEnterCode => 'Enter subscription code';

  @override
  String get subscriptionEnterCodeHint =>
      'Enter subscription code you receive from our agent';

  @override
  String get subscriptionSubscribe => 'Subscribe';

  @override
  String get subscriptionUpdate => 'Update subscription';

  @override
  String get subscriptionEnterVoucherError => 'Please enter your voucher';

  @override
  String get subscriptionEnterVoucher => 'Enter Voucher';

  @override
  String get subscriptionActivatePro => 'Activate Flipper Pro!';

  @override
  String get subscriptionUpgradeToPro => 'Upgrade to Pro';

  @override
  String get saleIndicatorNoSale => 'No Sale';

  @override
  String get tenantsBindProductHint =>
      'Bind the product to a tenant below for easy selling';

  @override
  String tenantsBoundTo(String name) {
    return 'Bound to $name';
  }

  @override
  String get tenantsBind => 'Bind';

  @override
  String get payableSendToTill => 'Send to Till →';

  @override
  String get cashbookSuggestSales => 'Sales';

  @override
  String get cashbookSuggestOwnerDeposit => 'Owner deposit';

  @override
  String get cashbookSuggestLoanReceived => 'Loan received';

  @override
  String get cashbookSuggestDebtRepayment => 'Debt repayment';

  @override
  String get cashbookSuggestRefund => 'Refund';

  @override
  String get cashbookSuggestCommission => 'Commission';

  @override
  String get cashbookSuggestTransport => 'Transport';

  @override
  String get cashbookSuggestRent => 'Rent';

  @override
  String get cashbookSuggestSalaries => 'Salaries';

  @override
  String get cashbookSuggestUtilities => 'Utilities';

  @override
  String get cashbookSuggestSupplies => 'Supplies';

  @override
  String get cashbookSuggestAirtime => 'Airtime';

  @override
  String get cashbookSuggestFood => 'Food';

  @override
  String get cashbookSuggestRepairs => 'Repairs';

  @override
  String get shiftStartSubtitle =>
      'Initialize your cash drawer and begin operations';

  @override
  String get shiftDetails => 'Shift Details';

  @override
  String shiftStartTime(String time) {
    return 'Start time: $time';
  }

  @override
  String shiftEndTime(String time) {
    return 'End time: $time';
  }

  @override
  String get shiftOpeningCashFloat => 'Opening Cash Float';

  @override
  String get shiftOpeningCashFloatHint =>
      'Enter the amount of cash in your drawer at the start of the shift';

  @override
  String get shiftOpeningBalanceRequired => 'Opening balance is required';

  @override
  String get shiftEnterValidPositiveAmount =>
      'Please enter a valid positive amount';

  @override
  String get shiftNotesOptional => 'Notes (Optional)';

  @override
  String get shiftNotesHint => 'Add any additional notes about this shift';

  @override
  String get shiftEnterNotesHere => 'Enter notes here...';

  @override
  String get shiftStarting => 'Starting...';

  @override
  String get shiftStartShift => 'Start Shift';

  @override
  String get shiftErrorNetwork =>
      'Network error. Please check your connection and try again.';

  @override
  String get shiftErrorSessionExpired =>
      'Your session has expired. Please log in again.';

  @override
  String get shiftErrorValidation => 'Please check your input and try again.';

  @override
  String get shiftErrorUnexpected =>
      'An unexpected error occurred. Please try again.';

  @override
  String get shiftErrorLoadingData => 'Error loading shift data';

  @override
  String get shiftSummary => 'Shift Summary';

  @override
  String get shiftOpeningBalance => 'Opening Balance';

  @override
  String get shiftCashSales => 'Cash Sales';

  @override
  String get shiftExpectedCash => 'Expected Cash';

  @override
  String get shiftCashReconciliation => 'Cash Reconciliation';

  @override
  String get shiftCountCashHint =>
      'Count the physical cash in the drawer and enter the\nclosing balance below.';

  @override
  String get shiftClosingCashBalance => 'Closing Cash Balance';

  @override
  String get shiftClosingCashHint => 'Enter actual cash counted in the drawer';

  @override
  String get shiftRequired => 'Required';

  @override
  String get shiftInvalidAmount => 'Invalid amount';

  @override
  String get shiftPerfectBalance => 'Perfect Balance';

  @override
  String get shiftOverage => 'Overage';

  @override
  String get shiftShortage => 'Shortage';

  @override
  String get shiftDifference => 'Difference';

  @override
  String get shiftMoreCashThanExpected => 'More cash than expected';

  @override
  String get shiftLessCashThanExpected => 'Less cash than expected';

  @override
  String get shiftNotes => 'Notes';

  @override
  String get shiftExplainShortage => 'Explain the shortage';

  @override
  String get shiftAddAnyNotes => 'Add any notes';

  @override
  String get shiftNotesRequiredWhenDifference =>
      'Required when difference exists';

  @override
  String get shiftExplainDifference => 'Explain the difference...';

  @override
  String get shiftEnterNotes => 'Enter notes...';

  @override
  String get shiftConfirmClosure => 'Confirm Shift Closure';

  @override
  String get shiftGoBack => 'Go Back';

  @override
  String get shiftConfirmClose => 'Confirm Close';

  @override
  String get shiftInvalidClosingBalance => 'Invalid closing balance';

  @override
  String shiftFailedToClose(String error) {
    return 'Failed to close shift: $error';
  }

  @override
  String get umusadaBusinessFinancing => 'Business Financing';

  @override
  String get umusadaUnlockLoans => 'Unlock Business Loans';

  @override
  String get umusadaFinancingHint =>
      'Get financing based on your order history';

  @override
  String get umusadaHowItWorks => 'How it works';

  @override
  String get umusadaAutoSync => 'Auto Sync';

  @override
  String get umusadaAutoSyncDesc =>
      'Your order data syncs securely to build your profile.';

  @override
  String get umusadaCreditScore => 'Credit Score';

  @override
  String get umusadaCreditScoreDesc =>
      'Umusada evaluates your history to set a loan limit.';

  @override
  String get umusadaInstantLoans => 'Instant Loans';

  @override
  String get umusadaInstantLoansDesc =>
      'Access funds quickly when you need them most.';

  @override
  String get umusadaJoin => 'Join Umusada';

  @override
  String get umusadaMaybeLater => 'Maybe later';

  @override
  String get umusadaConnecting => 'Connecting…';

  @override
  String get umusadaConnectionFailed => 'Connection Failed';

  @override
  String get umusadaCouldNotConnect =>
      'Could not connect to Umusada. Please try again later.';

  @override
  String get mfaUserNotLoggedIn => 'User not logged in';

  @override
  String mfaErrorLoadingSecret(String error) {
    return 'Error loading/generating MFA secret: $error';
  }

  @override
  String get mfaSetupAuthenticator => 'Setup authenticator';

  @override
  String get mfaSettingUp => 'Setting up your authenticator...';

  @override
  String get mfaSetupFailed => 'Setup failed';

  @override
  String get mfaGoBack => 'Go back';

  @override
  String get mfaSetUpTwoFactor => 'Set up two-factor\nauthentication';

  @override
  String get mfaScanQrHint =>
      'Scan the QR code below with your authenticator\napp to protect your Flipper account.';

  @override
  String get mfaStepVerify => 'Verify';

  @override
  String get mfaIveSetUp => 'I\'ve set up my authenticator';

  @override
  String get mfaNeedHelp => 'Need help?';

  @override
  String get mfaHelpText =>
      'Use apps like Microsoft Authenticator, Google Authenticator, or Authy to scan the QR code and generate verification codes.';

  @override
  String get mfaSetupKey => 'SETUP KEY';

  @override
  String get mfaCopied => 'Copied';

  @override
  String get mfaCopy => 'Copy';

  @override
  String get noticesTitle => 'Notices';

  @override
  String get noticesSubtitle => 'Stay updated with latest announcements';

  @override
  String get noticesLoading => 'Loading notices...';

  @override
  String get noticesUnableToLoad => 'Unable to load notices';

  @override
  String get noticesCheckConnection =>
      'Please check your connection and try again';

  @override
  String get noticesEmpty => 'No notices yet';

  @override
  String get noticesEmptyHint =>
      'New notices and announcements will appear here';

  @override
  String get noticesNoTitle => 'No Title';

  @override
  String get noticesNoContent => 'No content available';

  @override
  String get noticesNoDate => 'No date';

  @override
  String get noticesReadMore => 'Read more';

  @override
  String get ribbonOrdering => 'Ordering';

  @override
  String get ribbonImportPurchase => 'Import & Purchase';

  @override
  String get ribbonLocations => 'Locations';

  @override
  String get ribbonLocationsCaption => 'Inventory by branch';

  @override
  String get ribbonItemsCaption => 'Browse and manage catalog';

  @override
  String get ribbonTaxSettingsCaption => 'EBM / RRA server and VAT';

  @override
  String importPurchasePageSyncFailed(String error) {
    return 'Sync failed: $error';
  }

  @override
  String get importPurchasePageManagement => 'Import & Purchase Management';

  @override
  String get importPurchasePageSyncing => 'Syncing…';

  @override
  String importPurchasePageSyncedAgo(String time) {
    return 'Synced $time';
  }

  @override
  String get importPurchasePageNotSynced => 'Not synced yet';

  @override
  String get importPurchasePageExport => 'Export';

  @override
  String get importPurchasePageRecordPurchase => 'Record Purchase';

  @override
  String get importPurchasePageSyncFromRra => 'Sync from RRA';

  @override
  String get importPurchasePageImportFrom => 'Import from';

  @override
  String get importPurchasePagePurchaseFrom => 'Purchase from';

  @override
  String get infoDialogUnexpectedError => 'An unexpected error occurred.';

  @override
  String get infoDialogWarning => 'Warning';

  @override
  String get infoDialogSuccess => 'Success';

  @override
  String get infoDialogInformation => 'Information';

  @override
  String get infoDialogGotIt => 'Got It';

  @override
  String get infoDialogDismiss => 'Dismiss';

  @override
  String get keypadCashInFor => 'Cash in for';

  @override
  String get keypadCashOutFor => 'Cash out for';

  @override
  String get dataMixerCannotDelete => 'Can\'t be deleted or has been deleted.';

  @override
  String get dataMixerCouldNotDelete =>
      'Could not delete this item. Please try again.';

  @override
  String get dataMixerUnknownProduct => 'Unknown Product';

  @override
  String get searchToggleScanMode => 'Toggle Scan Mode';

  @override
  String get customAlertTitle => 'Alert';

  @override
  String get imagePickerTitle => 'Pick an image';

  @override
  String get imagePickerUseCamera => 'Use Camera';

  @override
  String get imagePickerUseGallery => 'Use Gallery';

  @override
  String get favoritesArrange => 'Arrange your favorites';

  @override
  String get favoritesPressDone => 'Press \"Done\" when you are finished';

  @override
  String get favoritesPressAndHold =>
      'Press and hold anywhere in the grid to begin setting items';

  @override
  String get drawerCloseBusiness => 'Close a Business';

  @override
  String get drawerOpenBusiness => 'Open Business';

  @override
  String get drawerEnterAmount => 'You need to enter the amount';

  @override
  String get drawerNumericOnly => 'Only numeric values are allowed';

  @override
  String get drawerClosingBalance => 'Closing balance';

  @override
  String get drawerOpenDrawer => 'Open Drawer';

  @override
  String get drawerCloseDrawer => 'Close Drawer';

  @override
  String get drawerLogoutWithoutClosing => 'Logout without closing drawer';

  @override
  String get cashierStaffFallback => 'Staff';

  @override
  String get paymentsSplitPayment => 'Split payment';

  @override
  String get paymentsConfirmPayment => 'Confirm Payment';

  @override
  String get paymentsHideDiscount => 'Hide Discount';

  @override
  String get paymentsAddDiscount => 'Add Discount';

  @override
  String get paymentsSendInvoice => 'Send Invoice';

  @override
  String get paymentsEnterDiscountAmount => 'Please enter discount amount';

  @override
  String get paymentsDiscountExceedsTotal =>
      'Discount cannot exceed the total amount';

  @override
  String get paymentsPhoneWithoutZero =>
      'Please enter Phone number without 0 e.g 783054874';

  @override
  String get paymentsEnterCashReceived => 'Please enter Cash Received';

  @override
  String get paymentsAmountLessThanPayable =>
      'Amount is less than amount payable';

  @override
  String get paymentsChooseMethod => 'You need to choose a payment method';

  @override
  String get paymentsTypeCard => 'Card';

  @override
  String get paymentsTypeMobile => 'Mobile';

  @override
  String get paymentsTypeBank => 'Bank';

  @override
  String get paymentsTypeCheque => 'Cheque';

  @override
  String get dashNotAvailable => 'N/A';

  @override
  String get itemsExportNone => 'No items to export';

  @override
  String get itemsExportSaveDialogTitle => 'Save Excel file';

  @override
  String get itemsExportProductName => 'Product Name';

  @override
  String get itemsExportVariantName => 'Variant Name';

  @override
  String get itemsExportItemCode => 'Item Code';

  @override
  String get itemsExportRetailPrice => 'Retail Price';

  @override
  String get itemsExportUnit => 'Unit';

  @override
  String itemsExportSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Successfully exported $count items',
      one: 'Successfully exported 1 item',
    );
    return '$_temp0';
  }

  @override
  String get itemsExportIncompleteSync =>
      'Some quantities may still be catching up from sync; re-export later if totals look wrong.';

  @override
  String itemsExportFailed(String error) {
    return 'Failed to export items: $error';
  }

  @override
  String get itemsTypeRawMaterial => 'Raw Material';

  @override
  String get itemsTypeFinishedProduct => 'Finished Product';

  @override
  String get itemsTypeService => 'Service';

  @override
  String get itemsTypeUnknown => 'Unknown';

  @override
  String get itemsExportToExcel => 'Export to Excel';

  @override
  String get itemsSearchByName => 'Search by name...';

  @override
  String itemsTransactionsSyncedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Found $count transactions synced',
      one: 'Found 1 transaction synced',
    );
    return '$_temp0';
  }

  @override
  String get itemsTransactionsSynced => 'Transactions synced successfully';

  @override
  String get itemsNoneFound => 'No items found.';

  @override
  String itemsStockValue(String quantity) {
    return 'Stock: $quantity';
  }

  @override
  String get itemsStockLoading => 'Stock: loading...';

  @override
  String get itemsStockError => 'Stock: error';

  @override
  String itemsErrorLoading(String error) {
    return 'Error loading items: $error';
  }

  @override
  String importPurchasePageFetchedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fetched $count new items from RRA',
      one: 'Fetched 1 new item from RRA',
    );
    return '$_temp0';
  }

  @override
  String importPurchasePageFetchedInvoices(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fetched $count new invoices from RRA',
      one: 'Fetched 1 new invoice from RRA',
    );
    return '$_temp0';
  }

  @override
  String get importPurchasePageNoNewItems => 'Sync complete — no new items';

  @override
  String get importPurchasePageNoNewInvoices =>
      'Sync complete — no new invoices';

  @override
  String get itemsViewFromLastWeek => 'from last week';

  @override
  String itemsViewExpiredOn(String date) {
    return 'Expired on: $date';
  }

  @override
  String itemsViewIdValue(String id) {
    return 'ID: $id';
  }

  @override
  String itemsViewCategoryValue(String category) {
    return 'Category: $category';
  }

  @override
  String itemsViewQuantityValue(String quantity) {
    return 'Quantity: $quantity';
  }

  @override
  String itemsViewLocationValue(String location) {
    return 'Location: $location';
  }

  @override
  String itemsViewExpiryDateValue(String date) {
    return 'Expiry Date: $date';
  }

  @override
  String get itemsViewInventoryByCategory => 'Inventory by Category';

  @override
  String get itemsViewStockLevelsTrend => 'Stock Levels Trend';

  @override
  String get itemsViewRecentOrders => 'Recent Orders';

  @override
  String itemsViewOrderLine(String id, String date) {
    return 'Order #$id - $date';
  }

  @override
  String get itemsViewNearExpiryItems => 'Near Expiry Items';

  @override
  String itemsViewUnitsAtLocation(int count, String location) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count units',
      one: '1 unit',
    );
    return '$_temp0 - $location';
  }

  @override
  String itemsViewDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days left',
      one: '1 day left',
    );
    return '$_temp0';
  }

  @override
  String get itemsViewStatusDelivered => 'Delivered';

  @override
  String get itemsViewStatusInTransit => 'In Transit';

  @override
  String get itemsViewStatusProcessing => 'Processing';

  @override
  String get itemsViewStatusCancelled => 'Cancelled';

  @override
  String get stockApprovalNoItems => 'No items found in request';

  @override
  String get stockApprovalAtLeastOne => 'At least one item must be approved';

  @override
  String get stockApprovalProcessError =>
      'An error occurred while processing the request';

  @override
  String get stockApprovalQuantityUpdated => 'Quantity updated successfully';

  @override
  String get stockApprovalQuantityUpdateFailed => 'Failed to update quantity';

  @override
  String stockApprovalInsufficientFor(String item) {
    return 'Insufficient stock for $item';
  }

  @override
  String stockApprovalVariantNotFoundFor(String item) {
    return 'Variant not found for $item';
  }

  @override
  String stockApprovalAdjustedToAvailable(String quantity) {
    return 'Quantity adjusted to available stock: $quantity';
  }

  @override
  String stockApprovalItemApproved(String item) {
    return '$item has been approved';
  }

  @override
  String get stockApprovalItemError =>
      'An error occurred while approving the item';

  @override
  String get stockApprovalCancelled => 'Approval cancelled';

  @override
  String stockApprovalSmsApproved(String reference) {
    return 'Your stock request #$reference has been approved.';
  }

  @override
  String stockApprovalSmsPartiallyApproved(String reference) {
    return 'Your stock request #$reference has been partially approved.';
  }

  @override
  String get stockApprovalRequestApproved => 'Request approved successfully';

  @override
  String get stockApprovalRequestPartiallyApproved =>
      'Request partially approved successfully';

  @override
  String get stockApprovalFinalizeFailed => 'Failed to finalize approval';

  @override
  String get stockApprovalProcessing => 'Processing Request...';

  @override
  String get stockApprovalPartialTitle => 'Partial Approval';

  @override
  String get stockApprovalApprove => 'Approve';

  @override
  String get stockApprovalInsufficientHint =>
      'Some items have insufficient stock. Please adjust the approved quantities:';

  @override
  String get stockApprovalVariantNotFound => 'Variant not found';

  @override
  String get stockApprovalApproveQuantity => 'Approve Quantity';

  @override
  String get stockApprovalRequested => 'Requested';

  @override
  String get stockApprovalAvailable => 'Available';

  @override
  String stockApprovalChipValue(String label, String value) {
    return '$label: $value';
  }

  @override
  String get stockApprovalPleaseApproveOne =>
      'Please approve at least one item';

  @override
  String get stockApprovalProcessFailed => 'Failed to process approval';

  @override
  String get exportDataTotalLabel => 'Total:';

  @override
  String get exportDataTotal => 'Total';

  @override
  String get exportDataSheetStockRecount => 'Stock Recount';

  @override
  String get exportDataSheetReport => 'Report';

  @override
  String get exportDataSheetExpenses => 'Expenses';

  @override
  String get exportDataSheetCashIn => 'Cash In';

  @override
  String get exportDataSheetPaymentMethods => 'Payment Methods';

  @override
  String get exportDataTotalSalesLines => 'Total Sales (lines):';

  @override
  String get exportDataNetProfitBeforeExpenses =>
      'Total Net Profit (Before Expenses):';

  @override
  String get exportDataNetProfitAfterExpenses =>
      'Final Net Profit (After Expenses):';

  @override
  String get exportDataNetProfitAfterCashIn =>
      'Final Net Profit (After Cash In):';

  @override
  String get exportDataNetProfitAfterExpensesAndCashIn =>
      'Final Net Profit (After Expenses & Cash In):';

  @override
  String get exportDataPaymentType => 'Payment Type';

  @override
  String get exportDataSaleAmount => 'Sale amount';

  @override
  String get exportDataTransactionCount => 'Transaction Count';

  @override
  String get exportDataPercentOfTotal => '% of Total';

  @override
  String get exportDataExpense => 'Expense';

  @override
  String get exportDataTotalExpenses => 'Total Expenses';

  @override
  String get exportDataTotalCashIn => 'Total Cash In';

  @override
  String exportDataShareSubject(String date) {
    return 'Report Download - $date';
  }

  @override
  String get mposSaveCustomerBeforeTill =>
      'Save a customer name or phone number on this ticket before sending it to the till.';

  @override
  String get mposCouldNotReturnTicket =>
      'Could not return this ticket to the till. Please try again.';

  @override
  String get mposCouldNotRemoveCustomer => 'Could not remove customer';

  @override
  String get mposPaymentsAtTillSendToManager =>
      'Payments are collected at the till. Send this order to a manager.';

  @override
  String get mposAddCustomerBeforeCompleting =>
      'Please add a customer to the sale before completing';

  @override
  String get mposEnterValidMomoPhone =>
      'Enter a valid MoMo phone number to request payment';

  @override
  String get mposCustomerRequiredForCredit =>
      'A customer name or phone is required for credit/loan payments.';

  @override
  String get mposErrorOccurred => 'Error occurred';

  @override
  String mposErrorUpdatingQuantity(String error) {
    return 'Error updating quantity: $error';
  }

  @override
  String mposErrorRemovingProduct(String error) {
    return 'Error removing product: $error';
  }

  @override
  String mposErrorUpdatingPrice(String error) {
    return 'Error updating price: $error';
  }

  @override
  String get mposAddItemsToCharge => 'Add items to charge';

  @override
  String get mposRecordPayment => 'Record Payment';

  @override
  String get mposComplete => 'Complete';

  @override
  String get mposCompleteNow => 'Complete Now';

  @override
  String get mposWaitingForPayment => 'Waiting for payment...';

  @override
  String get mposPrintingReceipt => 'Printing receipt...';

  @override
  String get mposPaymentFailedRetry => 'Payment Failed. Retry?';

  @override
  String mposEnterAmountReceived(String amount) {
    return 'Enter $amount received';
  }

  @override
  String get mposMobileCheckout => 'Mobile checkout';

  @override
  String mposCheckoutSemanticValue(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0, RWF $total';
  }

  @override
  String get mposNoItemsInCart => 'No items in cart';

  @override
  String get mposAddMoreItems => 'Add more items';

  @override
  String get mposPaymentMethod => 'Payment method';

  @override
  String get mposTotals => 'Totals';

  @override
  String get loginChoicesMember => 'Member';

  @override
  String get loginChoicesOwner => 'Owner';

  @override
  String loginChoicesBusinessSubtitle(String role, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count branches',
      one: '1 branch',
    );
    return '$role · $_temp0';
  }

  @override
  String get loginChoicesValidatingSession => 'Validating session...';

  @override
  String get loginChoicesLoadingBusinesses => 'Loading your businesses...';

  @override
  String get loginChoicesNoBusinessesSigningOut =>
      'No businesses found. Signing out...';

  @override
  String get loginChoicesChooseBusiness => 'Choose a business';

  @override
  String get loginChoicesSelectBusinessHint =>
      'Select the business you want to manage.';

  @override
  String get loginChoicesChooseBranch => 'Choose a branch';

  @override
  String get loginChoicesSelectBranchHint =>
      'Select the branch you want to access';

  @override
  String get loginChoicesBranchFallback => 'Branch';

  @override
  String get loginChoicesSigningOut => 'Signing out…';

  @override
  String get loginChoicesPleaseWait => 'Please wait a moment';

  @override
  String get loginChoicesSignOut => 'Sign out';

  @override
  String get loginChoicesAddBusiness => 'Add a business';

  @override
  String get loginChoicesNotSeeingBusiness =>
      'Not seeing your business? Ask the owner to invite you, or ';

  @override
  String get loginChoicesAddBusinessLink => 'add a business.';

  @override
  String get loginChoicesNoBranches => 'No branches loaded yet';

  @override
  String get loginChoicesNoBranchesHint =>
      'This can happen if sync is still catching up.\nTry again in a moment.';

  @override
  String get loginChoicesDefaultBadge => 'DEFAULT';

  @override
  String get drawerMenuAdminFallback => 'Admin';

  @override
  String get drawerMenuMyBusiness => 'My Business';

  @override
  String get drawerMenuQuickActions => 'QUICK ACTIONS';

  @override
  String get drawerMenuYourBusinesses => 'YOUR BUSINESSES';

  @override
  String get drawerMenuManagement => 'MANAGEMENT';

  @override
  String get drawerMenuPrintDelegation => 'Print Delegation';

  @override
  String get drawerMenuSaleMode => 'Sale mode';

  @override
  String get drawerMenuBackgroundSyncEnabled =>
      'Background Sync Enabled, to disable it, go to settings and disable it';

  @override
  String get drawerMenuBackgroundSyncDisabled => 'Background Sync Disabled';

  @override
  String get drawerMenuEbmOn => 'EBM On';

  @override
  String get drawerMenuEbmOff => 'EBM Off';

  @override
  String get drawerMenuCheckingEbm => 'Checking EBM status...';

  @override
  String get drawerMenuEbmStatusError => 'EBM Status Error';

  @override
  String get drawerMenuCheckingShift => 'Checking shift status...';

  @override
  String get drawerMenuEndShift => 'End current shift';

  @override
  String get drawerMenuStartShift => 'Start new shift';

  @override
  String get drawerMenuUnnamedBusiness => 'Unnamed Business';

  @override
  String get drawerMenuUnnamedBranch => 'Unnamed Branch';

  @override
  String drawerMenuBranchCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count branches',
      one: '1 branch',
    );
    return '$_temp0';
  }

  @override
  String get drawerMenuDelegationEnabled => 'Print Delegation enabled';

  @override
  String get drawerMenuDelegationDisabled => 'Print Delegation disabled';

  @override
  String get drawerMenuDelegationDeviceSelected => 'Delegation device selected';

  @override
  String drawerMenuErrorSelectingDevice(String error) {
    return 'Error selecting device: $error';
  }

  @override
  String get drawerMenuSelectDevice => 'Select Device';

  @override
  String get drawerMenuNoDevices => 'No devices available in this branch';

  @override
  String drawerMenuPlatform(String platform) {
    return 'Platform: $platform';
  }

  @override
  String drawerMenuPhone(String phone) {
    return 'Phone: $phone';
  }

  @override
  String drawerMenuErrorLoadingDevices(String error) {
    return 'Error loading devices: $error';
  }

  @override
  String get drawerMenuDelegate => 'Delegate';

  @override
  String get drawerMenuDelegateHint =>
      'Receipt printing to desktop when EBM server is unavailable';

  @override
  String get drawerMenuEnabled => 'Enabled';

  @override
  String get drawerMenuDisabled => 'Disabled';

  @override
  String get drawerMenuDelegationStep1 =>
      'Mobile completes the transaction but\ndelegates receipt generation';

  @override
  String get drawerMenuDelegationStep2 =>
      'Desktop picks up the transaction via sync';

  @override
  String get drawerMenuDelegationStep3 =>
      'Desktop generates the receipt and\ncommunicates with EBM server';

  @override
  String get drawerMenuDelegationStep4 =>
      'Mobile is notified when processing is\ncomplete';

  @override
  String get drawerMenuRequirements => 'Requirements';

  @override
  String get drawerMenuRequirement1 =>
      'Desktop app must be running with delegation enabled';

  @override
  String get drawerMenuRequirement2 =>
      'Both devices must be syncing via flipper sync';

  @override
  String get drawerMenuRequirement3 =>
      'Desktop processes delegated transactions every 10 seconds';

  @override
  String get customersHelpSearch => 'Search customers by name or phone number';

  @override
  String get customersHelpEdit =>
      'Use Edit on a customer row to update their details';

  @override
  String get customersHelpTap =>
      'Tap a customer to attach them to the current sale';

  @override
  String get customersHelpSwipe =>
      'On phone, swipe a row for quick delete, edit, add, or remove';

  @override
  String get customersHelpAdd =>
      'Add a new customer with the button below the search field';

  @override
  String get customersNoneFound => 'No customers found';

  @override
  String customersFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count customers found',
      one: '1 customer found',
    );
    return '$_temp0';
  }

  @override
  String get customersTryDifferentSearch =>
      'Try different search terms or add a new customer';

  @override
  String get customersAddToGetStarted => 'Add a customer to get started';

  @override
  String customersAddAsNew(String name) {
    return 'Add \"$name\" as new customer';
  }

  @override
  String get customersAddNew => 'Add new customer';

  @override
  String get customersNoName => 'No Name';

  @override
  String customersTinValue(String tin) {
    return 'TIN: $tin';
  }

  @override
  String get customersRemoveFromSale => 'Remove from sale';

  @override
  String get customersAddToSale => 'Add to sale';

  @override
  String customersAddedToSale(String name) {
    return 'Customer $name added to sale';
  }

  @override
  String get customersFailedToAdd => 'Failed to add customer to sale';

  @override
  String get customersRemovedFromSale => 'Customer removed from sale';

  @override
  String get customersFailedToRemove => 'Failed to remove customer from sale';

  @override
  String get customersDeleted => 'Customer deleted';

  @override
  String customersCouldNotOpenForm(String error) {
    return 'Could not open customer form: $error';
  }

  @override
  String customersAddNamed(String name) {
    return 'Add customer \"$name\"';
  }

  @override
  String customersAddNamedToSale(String name) {
    return 'Add \"$name\" to sale';
  }

  @override
  String get customersThisCustomer => 'this customer';

  @override
  String get customersDeleteTitle => 'Delete customer?';

  @override
  String customersDeleteBody(String name) {
    return 'Remove $name from your customer list. This cannot be undone.';
  }

  @override
  String get itemRowConfirmFavorite => 'Confirm Favorite';

  @override
  String itemRowConfirmFavoriteBody(String product, String position) {
    return 'You are about to add $product to favorite position $position.\n\nDo you approve?';
  }

  @override
  String get itemRowUnnamedProduct => 'Unnamed Product';

  @override
  String get itemRowDefaultVariant => 'Default Variant';

  @override
  String get itemRowUnnamed => 'Unnamed';

  @override
  String itemRowStockLeft(String quantity) {
    return '$quantity left';
  }

  @override
  String get itemRowDecreaseQuantity => 'Decrease quantity';

  @override
  String get itemRowIncreaseQuantity => 'Increase quantity';

  @override
  String get itemRowNoImage => 'No Image';

  @override
  String get itemRowCannotDeleteWithStock =>
      'Cannot delete a variant with stock.';

  @override
  String get txDetailExpense => 'Expense';

  @override
  String get txDetailIncome => 'Income';

  @override
  String get txDetailProducts => 'Products';

  @override
  String get txDetailTimeline => 'Transaction Timeline';

  @override
  String txDetailEventCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count events',
      one: '1 event',
    );
    return '$_temp0';
  }

  @override
  String get txDetailExpenseRecorded => 'Expense recorded';

  @override
  String get txDetailIncomeReceived => 'Income received';

  @override
  String get txDetailMoreActions => 'More Actions';

  @override
  String get txDetailCreatedPrefix => 'Created ';

  @override
  String txDetailAmountRefunded(String amount) {
    return '$amount refunded';
  }

  @override
  String get txDetailFullyRefunded => 'Fully refunded to customer';

  @override
  String txDetailRefundVia(String reason, String method) {
    return '$reason · via $method';
  }

  @override
  String get txDetailMethod => 'Method';

  @override
  String get txDetailReference => 'Reference';

  @override
  String get txDetailNoLineItems => 'No line items for this transaction.';

  @override
  String get txDetailNoTimelineEvents => 'No timeline events yet.';

  @override
  String get txDetailStatusPartiallyRefunded => 'PARTIALLY REFUNDED';

  @override
  String get txDetailStatusRefunded => 'REFUNDED';

  @override
  String get txDetailStatusPending => 'PENDING';

  @override
  String get txDetailStatusCompleted => 'COMPLETED';

  @override
  String get txDetailStatusParked => 'PARKED';

  @override
  String get txDetailPartiallyRefunded => 'Partially refunded';

  @override
  String get txDetailRefund => 'Refund';

  @override
  String get txDetailPaymentReceived => 'Payment received';

  @override
  String get txDetailPaymentPending => 'Payment pending';

  @override
  String get txDetailSaleCreated => 'Sale created';

  @override
  String txDetailPaymentLine(String method) {
    return 'Payment: $method';
  }

  @override
  String get txListSelectDateRange => 'Select a date range';

  @override
  String get txListSelectDateRangeFirst => 'Please select a date range first';

  @override
  String get txListNoDataToExport =>
      'No data to export. Please wait for data to load.';

  @override
  String get txListReportStillLoading =>
      'Report data is still loading. Please try again in a moment.';

  @override
  String txListExportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String txListRefreshFailed(String error) {
    return 'Refresh failed: $error';
  }

  @override
  String txListReportFailed(String error) {
    return 'Report failed: $error';
  }

  @override
  String get txListChangeDate => 'Change Date';

  @override
  String get txListZReport => 'Z Report';

  @override
  String get txListXReport => 'X Report';

  @override
  String get txListSaleReport => 'Sale Report';

  @override
  String get txListPluReport => 'PLU Report';

  @override
  String get txListAllStatuses => 'All statuses';

  @override
  String get txListAllTypes => 'All types';

  @override
  String get txListAllPayments => 'All payments';

  @override
  String get txListByHand => 'By hand';

  @override
  String get txListSearchReceipt => 'Search receipt number...';

  @override
  String get txListCashierHeading => 'CASHIER';

  @override
  String get txListAll => 'All';

  @override
  String get txListRefreshTooltip =>
      'Refresh — pull fresh data from mesh peers or the server';

  @override
  String get txListSummarized => 'Summarized';

  @override
  String get txListDetailed => 'Detailed';

  @override
  String get txListNoTransactions =>
      'No transactions found for the selected period.';

  @override
  String get txListPreparingReports => 'Preparing your reports...';

  @override
  String get txListMightTakeMoment =>
      'This might take a moment depending on your data';

  @override
  String get txListSomethingWentWrong => 'Oops! Something went wrong';

  @override
  String get dashViewToday => 'Today';

  @override
  String get dashViewThisWeek => 'This Week';

  @override
  String get dashViewThisMonth => 'This Month';

  @override
  String get dashViewThisYear => 'This Year';

  @override
  String get dashViewNetProfit => 'Net Profit';

  @override
  String get dashViewGrossProfit => 'Gross Profit';

  @override
  String get dashViewFromYegobox => 'FROM YEGOBOX';

  @override
  String dashViewTodaysGoal(String count, String target) {
    return 'Today\'s goal · $count of $target sales';
  }

  @override
  String get dashViewLogFirstSale => 'Log your first sale to start earning';

  @override
  String get dashViewGoalReached => 'Goal reached! ';

  @override
  String dashViewJustMoreTo(String remaining) {
    return 'Just $remaining more to ';
  }

  @override
  String get dashViewPlusPoints => '+50 pts';

  @override
  String get dashViewStockValue => 'Stock value';

  @override
  String dashViewItemsLowOnStock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items low on stock',
      one: '1 item low on stock',
    );
    return '$_temp0';
  }

  @override
  String get dashViewFullReport => 'Full report ›';

  @override
  String get dashViewDataIncomplete => 'Data may be incomplete (partial sync).';

  @override
  String get dashViewUnableToLoadStock => 'Unable to load stock value.';

  @override
  String get dashViewRevenue => 'Revenue';

  @override
  String get dashViewExpenses => 'Expenses';

  @override
  String dashViewDeltaUp(String percent) {
    return '$percent% up';
  }

  @override
  String dashViewDeltaDown(String percent) {
    return '$percent% down';
  }

  @override
  String get transactionsExportNotReady =>
      'Export is not ready yet. Try again in a moment.';

  @override
  String get transactionsNoLineItemsToExport =>
      'No line items to export for this period.';

  @override
  String get transactionsFilter => 'Filter Transactions';

  @override
  String get transactionsExportDetailed => 'Export detailed report (Excel)';

  @override
  String get transactionsTitle => 'Transactions';

  @override
  String transactionsNoRecordsFor(String period) {
    return 'No records for $period';
  }

  @override
  String get transactionsTryDifferentPeriod =>
      'Try selecting a different time period or add some transactions.';

  @override
  String get transactionsLoading => 'Loading transactions...';

  @override
  String get transactionsSomethingWentWrong => 'Something went wrong';

  @override
  String previewSaleCollectAmount(String amount) {
    return 'Collect $amount';
  }

  @override
  String previewSaleOrderAmount(String amount) {
    return 'Order $amount';
  }

  @override
  String get previewSaleCartEmpty => 'Your cart is empty';

  @override
  String get previewSaleDiscounts => 'Discounts';

  @override
  String get importStatusAll => 'All';

  @override
  String get importStatusWaiting => 'Waiting';

  @override
  String get importStatusRejected => 'Rejected';

  @override
  String get importSaveChanges => 'Save Changes';

  @override
  String get importAcceptAll => 'Accept All';

  @override
  String get importFilterByStatus => 'Filter by Status';

  @override
  String get importEnterName => 'Enter a name';

  @override
  String get importEnterSupplyPrice => 'Enter supply price';

  @override
  String get importSupplyPriceRequired => 'Supply price is required';

  @override
  String get importEnterRetailPrice => 'Enter retail price';

  @override
  String get importRetailPriceRequired => 'Retail price is required';

  @override
  String get paymentSettingsTitle => 'Payment Settings';

  @override
  String get paymentSettingsEnabled => 'Enabled';

  @override
  String get paymentSettingsDisabled => 'Disabled';

  @override
  String get mposWalkIn => 'Walk-in';

  @override
  String get mposSaleComplete => 'Sale complete';

  @override
  String get mposNewSale => 'New sale';

  @override
  String get mposPrintReceipt => 'Print receipt';

  @override
  String get mposTotalPaid => 'Total paid';

  @override
  String get mposTendered => 'Tendered';

  @override
  String get mposChange => 'Change';

  @override
  String get settingsManageBusiness => 'Manage your business settings';

  @override
  String get gaugeGrossProfit => 'Gross Profit';

  @override
  String get gaugeNetProfit => 'Net Profit';

  @override
  String get gaugeTaxAndExpenses => 'Tax & Expenses';

  @override
  String get gaugeLoss => 'Loss';

  @override
  String get gaugeBalanced => 'Balanced';

  @override
  String get gaugeNoTransactions => 'No transactions';

  @override
  String get dashboardGaugeGrossProfit => 'Gross profit';

  @override
  String get dashboardGaugeTaxExpenses => 'Tax & expenses';

  @override
  String get dashboardGaugeNoTransactionsYet => 'No transactions yet';

  @override
  String dashboardGaugeGrossProfitPeriod(String period) {
    return 'Gross profit · $period';
  }

  @override
  String dashboardGaugeNetProfitPeriod(String period) {
    return 'Net profit · $period';
  }

  @override
  String dashboardGaugeDeltaVs(String percent, String comparison) {
    return '$percent% vs $comparison';
  }

  @override
  String get dashboardGaugeLastPeriod => 'last period';

  @override
  String get dashboardCompareYesterday => 'yesterday';

  @override
  String get dashboardCompareLastWeek => 'last week';

  @override
  String get dashboardCompareLastMonth => 'last month';

  @override
  String get dashboardCompareLastYear => 'last year';

  @override
  String get transactionTypeUnclassified => 'Unclassified';

  @override
  String get mposLoadFailedTitle => 'Couldn\'t load this';

  @override
  String get mposLoadFailedBody => 'Check your connection, then try again.';

  @override
  String get dashboardAppPointOfSale => 'Point of Sale';

  @override
  String get dashboardAppCashBook => 'Cash Book';

  @override
  String get dashboardAppTransactions => 'Transactions';

  @override
  String get dashboardAppContacts => 'Contacts';

  @override
  String get dashboardAppCommission => 'Commission';

  @override
  String get dashboardAppSupport => 'Support';

  @override
  String get dashboardAppCredits => 'Credits';

  @override
  String get dashboardAppOrders => 'Orders';

  @override
  String get dashboardAppFinance => 'Finance';

  @override
  String get dashboardAppBooks => 'Books';

  @override
  String get dashboardAppStockRecount => 'Stock Recount';

  @override
  String get dashboardAppTransfersReport => 'Transfers Report';

  @override
  String get dashboardAppBranchOrders => 'Branch Orders';

  @override
  String get dashboardQuickAccess => 'QUICK ACCESS';

  @override
  String get dashboardSeeAll => 'See all';

  @override
  String get dashboardShortcutUnsupported =>
      'Pinned shortcuts are not supported on this device.';

  @override
  String dashboardShortcutAddPrompt(String label) {
    return 'Add \"$label\" to your home screen when prompted.';
  }

  @override
  String get dashboardShortcutLauncherUnsupported =>
      'Your launcher does not support pinned shortcuts.';

  @override
  String get dashboardShortcutFailed => 'Could not create shortcut.';

  @override
  String get dashboardAllAppsYourBusiness => 'your business';

  @override
  String dashboardAllAppsEverythingIn(String name) {
    return 'Everything in $name';
  }

  @override
  String appLaunchOpening(String app) {
    return 'Opening $app';
  }

  @override
  String get appLaunchSyncingSlow =>
      'Syncing your business — this can take a moment on a slow connection.';

  @override
  String get cashbookCategorySheetSaveFailed =>
      'Couldn\'t save this category. Check your connection and try again.';

  @override
  String get cashbookCategorySheetQuickPicks => 'QUICK PICKS';

  @override
  String get cashbookCategorySheetTitle => 'New category';

  @override
  String get cashbookCategorySheetIncomeSubtitle => 'Group money coming in';

  @override
  String get cashbookCategorySheetExpenseSubtitle => 'Group money going out';

  @override
  String get cashbookCategorySheetNameLabel => 'Category name';

  @override
  String cashbookCategorySheetExampleHint(String example) {
    return 'e.g. $example';
  }

  @override
  String get cashbookCategorySheetTypeName => 'Type a name';

  @override
  String cashbookCategorySheetAlreadyExists(String name) {
    return '\"$name\" already exists. We\'ll use it.';
  }

  @override
  String get cashbookCategorySheetUseExisting => 'Use existing category';

  @override
  String get cashbookCategorySheetCreate => 'Create category';

  @override
  String get checkoutRecoveryLeaveQuestion => 'Leave checkout?';

  @override
  String get checkoutRecoveryCheckout => 'Checkout';

  @override
  String get checkoutRecoverySale => 'Sale';

  @override
  String get checkoutRecoveryActionNeeded => 'ACTION NEEDED';

  @override
  String get checkoutRecoveryUnavailable => 'CHECKOUT UNAVAILABLE';

  @override
  String get checkoutRecoveryNoBranchHeadline => 'No branch selected yet';

  @override
  String get checkoutRecoveryLoadFailedHeadline => 'Couldn\'t load checkout';

  @override
  String get checkoutRecoveryNoBranchBody =>
      'Checkout needs a branch to load products and record the sale. Pick a branch to continue.';

  @override
  String get checkoutRecoveryLoadFailedBody =>
      'Something went wrong while opening checkout. Try again or contact support if this keeps happening.';

  @override
  String get checkoutRecoveryWhatHappened => 'What happened';

  @override
  String get checkoutRecoveryNoLocationDiagnostic =>
      'checkout couldn\'t resolve a location for this device.';

  @override
  String get checkoutRecoverySelectBranch => 'Select a branch';

  @override
  String get checkoutRecoveryChooseWhere => 'Choose where this sale happens';

  @override
  String get checkoutRecoveryStillStuck => 'Still stuck?';

  @override
  String get checkoutRecoveryGetHelp => 'Get help';

  @override
  String get checkoutRecoveryLoading => 'Loading checkout…';

  @override
  String get checkoutRecoveryBranch => 'Branch';

  @override
  String get checkoutRecoveryReady => 'Checkout ready';

  @override
  String get checkoutRecoveryReadyBody =>
      'You\'re all set to take payments. Items and totals will sync to this branch.';

  @override
  String get checkoutRecoveryOpenCheckout => 'Open checkout';

  @override
  String get checkoutRecoveryStillNoBranch =>
      'Still no branch selected — pick one to continue.';

  @override
  String get checkoutRecoveryWhereQuestion =>
      'Where is this sale taking place?';

  @override
  String get checkoutRecoverySetDefaultBranch =>
      'Set as default branch for this device';

  @override
  String get checkoutRecoveryChooseBranch => 'Choose a branch';

  @override
  String get checkoutRecoveryContinue => 'Continue to checkout';

  @override
  String get checkoutRecoveryChecking => 'Checking…';

  @override
  String get checkoutRecoveryTryAgain => 'Try again';

  @override
  String get checkoutRecoveryBranchLocation => 'Branch location';

  @override
  String get checkoutRecoveryHqBadge => 'HQ';

  @override
  String checkoutTransferToBranch(String branch) {
    return 'Transfer to $branch';
  }

  @override
  String get checkoutTransferNoItemsSelected => 'No items selected';

  @override
  String get checkoutTransferToBranchLabel => 'To branch';

  @override
  String get checkoutTransferNoOtherBranches => 'No other branches';

  @override
  String get checkoutTransferSelectBranch => 'Select branch';

  @override
  String get checkoutTransferLoadBranchesFailed => 'Failed to load branches';

  @override
  String get peersNetworkStatus => 'Network Status';

  @override
  String get peersThisDeviceOnly =>
      'This device only — no peers on the mesh yet.';

  @override
  String peersSyncedWith(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Synced with $count peers on the mesh.',
      one: 'Synced with 1 peer on the mesh.',
    );
    return '$_temp0';
  }

  @override
  String get peersLocalDevice => 'Local device';

  @override
  String get peersOnline => 'Online';

  @override
  String get peersConnectedPeers => 'Connected peers';

  @override
  String get peersSyncNotInitialized => 'Sync Service not initialized';

  @override
  String peersConnectedTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Connected to $count devices. Tap to see details.',
      one: 'Connected to 1 device. Tap to see details.',
    );
    return '$_temp0';
  }

  @override
  String get peersSearching => 'Searching for devices on same network...';

  @override
  String get peersLive => 'Live';

  @override
  String get peersNetworkCheckError => 'Network check error';

  @override
  String get peersNoOtherDevices => 'No other devices found';

  @override
  String get peersOpenFlipperHint =>
      'Open Flipper on another device on the same network.';

  @override
  String get saleModeNormal => 'Normal sale';

  @override
  String get saleModeProforma => 'Proforma';

  @override
  String get saleModeTraining => 'Training';

  @override
  String get saleModeTitle => 'Sale mode';

  @override
  String get saleModeDescription =>
      'The receipt type new sales are issued under. Leave this on Normal sale unless you are practising or quoting.';

  @override
  String get saleModeNormalSubtitle => 'Real, fiscal sales. The default.';

  @override
  String get saleModeProformaSubtitle =>
      'Quotes. Not a receipt, no stock movement.';

  @override
  String get saleModeTrainingSubtitle =>
      'Practice sales. Training receipts cannot be shared or printed.';

  @override
  String get mposCartEmptyHint => 'Tap a product to start a sale';

  @override
  String get mposCartReviewPay => 'Review & Pay';

  @override
  String get mposCartLabel => 'Cart';

  @override
  String mposCartSummary(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items, RWF $total',
      one: '1 item, RWF $total',
    );
    return '$_temp0';
  }

  @override
  String mposCartItemsInCart(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items in cart',
      one: '1 item in cart',
    );
    return '$_temp0';
  }

  @override
  String get mposDismiss => 'Dismiss';

  @override
  String get mposBackFromCheckout => 'Back from checkout';

  @override
  String get mposScan => 'Scan';

  @override
  String get mposRemovingCustomer => 'Removing customer…';

  @override
  String get mposAttachCustomer => 'Attach customer';

  @override
  String get mposWalkInCustomer => 'Walk-in customer';

  @override
  String get mposAttachCustomerHint => 'Tap to attach a customer (optional)';

  @override
  String get mposRemoveCustomer => 'Remove customer';

  @override
  String mposCustomerAttachedToSale(String name) {
    return '$name attached to this sale';
  }

  @override
  String mposCouldNotAttachCustomer(String error) {
    return 'Could not attach customer: $error';
  }

  @override
  String get mposSearchNameOrPhone => 'Search name or phone';

  @override
  String get mposContinueAsWalkIn => 'Continue as walk-in';

  @override
  String get mposNoCustomerOnSale => 'No customer on this sale';

  @override
  String get mposAddNewCustomer => 'Add new customer';

  @override
  String mposItemQtyAtPrice(String qty, String price) {
    return '$qty at RWF $price';
  }

  @override
  String get mposDoneEditingPrice => 'Done editing price';

  @override
  String get mposEditPrice => 'Edit price';

  @override
  String mposDeleteItem(String name) {
    return 'Delete $name';
  }

  @override
  String get mposUnitPrice => 'Unit price';

  @override
  String mposUnitPriceWithDefault(String price) {
    return 'Unit price · default RWF $price';
  }

  @override
  String mposUnitPriceFor(String name) {
    return 'Unit price for $name';
  }

  @override
  String mposResetPriceFor(String name) {
    return 'Reset price for $name';
  }

  @override
  String get mposDecreaseQuantity => 'Decrease quantity';

  @override
  String get mposIncreaseQuantity => 'Increase quantity';

  @override
  String get mposMomoPhoneNumber => 'MoMo phone number';

  @override
  String get mposCashReceivedAmount => 'Cash received amount';

  @override
  String mposCreditAmount(String amount) {
    return 'Credit amount · $amount';
  }

  @override
  String get mposCreditExplanation =>
      'This sale is recorded on the customer\'s credit balance. Attach a customer before completing.';

  @override
  String mposPaymentLinesSplitHint(int count) {
    return '$count payment lines · use split in desktop mode';
  }

  @override
  String get mposTax => 'Tax';

  @override
  String get mposTotal => 'Total';

  @override
  String get mposAlreadyPaid => 'Already paid';

  @override
  String get mposThisPayment => 'This payment';

  @override
  String get mposBalanceDue => 'Balance due';

  @override
  String get posCartLineSubtotal => 'Line subtotal';

  @override
  String get posCartEditQtyPrice => 'Edit qty/price';

  @override
  String get posCartHideDetails => 'Hide details';

  @override
  String get posCartRemoveLine => 'Remove line';

  @override
  String get posScanMode => 'Scan mode';

  @override
  String get posSendToTillNeedsCustomer =>
      'Save a customer name or phone number on this ticket before sending it to the till.';

  @override
  String get posPreparingCheckout => 'Preparing checkout...';

  @override
  String get posShiftLoadFailed => 'Could not load shift status';

  @override
  String get posShiftStartToSell => 'Start a shift to sell';

  @override
  String get posShiftStartHint =>
      'Open your cash drawer shift before ringing up sales. You can also open a shift from the sidebar.';

  @override
  String get salesByCashierTitle => 'SALES BY CASHIER';

  @override
  String get salesByCashierByHand => 'By hand';

  @override
  String get startupTagline => 'A revolutionary business software...';

  @override
  String get startupProgressLabel => 'Startup progress';

  @override
  String get startupReady => 'Ready';

  @override
  String get startupFinishingUp => 'Finishing up';

  @override
  String get startupConfirmingPlan => 'Confirming your plan';

  @override
  String get startupSyncingData => 'Syncing your data';

  @override
  String get startupStartingServices => 'Starting services';

  @override
  String get startupCheckingWorkspace => 'Checking your workspace';

  @override
  String get startupConnecting => 'Connecting';

  @override
  String get topBarNotifications => 'Notifications';

  @override
  String get userInfoLoading => 'Loading...';

  @override
  String get userInfoFallbackName => 'User';

  @override
  String get userInfoSwitchBranch => 'Switch Branch';

  @override
  String get userInfoSwitchUser => 'Switch User';

  @override
  String get variantDropdownBranchNotSelected =>
      'Branch not selected. Please select a branch.';

  @override
  String get variantDropdownNoVariantsHint =>
      'No variants available to select. Please create variants first.';

  @override
  String get variantDropdownNoVariants => 'No variants';

  @override
  String get variantDropdownSelect => 'Select Variant';

  @override
  String get variantDropdownSearch => 'Search variants...';

  @override
  String get variantDropdownLoadError => 'Error loading variants';

  @override
  String get variantImageSaveProductFirst => 'Save the product and try again';

  @override
  String get variantImageUploadFailed =>
      'Could not upload image. Please try again.';

  @override
  String get variantImageChange => 'Change variant image';

  @override
  String get variantImageAdd => 'Add variant image';

  @override
  String get waOptInScanTitle => 'Scan to receive receipt';

  @override
  String get waOptInSubtitle =>
      'Customer must message your WhatsApp business number once so we can send their digital receipt.';

  @override
  String get waOptInScanHint => 'Open WhatsApp → scan with the camera';

  @override
  String get waOptInQueued =>
      'Receipt is queued. Ask the customer to message your WhatsApp business number, then the PDF will send automatically.';

  @override
  String get waOptInLinkCopied => 'WhatsApp link copied';

  @override
  String get waOptInCopy => 'Copy';

  @override
  String waOptInReceiptPhone(String phone) {
    return 'Receipt phone: $phone';
  }

  @override
  String get kpiTotalSales => 'Total Sales';

  @override
  String get kpiCollected => 'Collected';

  @override
  String get kpiOwed => 'Owed';

  @override
  String get printDelegationNoDevicesLoaded =>
      'No devices loaded for this branch yet. Check that other desktops are logged in and online, then reopen this screen.';

  @override
  String get printDelegationOnlyThisDesktop =>
      'Only this desktop is registered in this branch. Log in on another Windows, macOS, or Linux POS to delegate printing to it.';

  @override
  String get printDelegationNoDesktops =>
      'Other devices exist in this branch but none are desktops (device_name must be windows, macos, or linux).';

  @override
  String get printDelegationNoOtherDesktops =>
      'No other desktop devices found in this branch';

  @override
  String get printDelegationDeviceNameSaved => 'Device name saved';

  @override
  String printDelegationDeviceNameSaveFailed(String error) {
    return 'Could not save device name: $error';
  }

  @override
  String get printDelegationDeviceSelected => 'Delegation device selected';

  @override
  String printDelegationSelectDeviceError(String error) {
    return 'Error selecting device: $error';
  }

  @override
  String get printDelegationEnabled => 'Print Delegation enabled';

  @override
  String get printDelegationDisabled => 'Print Delegation disabled';

  @override
  String get printDelegationTitle => 'Print Delegation';

  @override
  String get printDelegationMobileDescription =>
      'Delegate receipt printing to desktop when EBM server is unavailable';

  @override
  String get printDelegationDesktopDescription =>
      'Process receipts delegated from mobile devices, or delegate printing to another desktop';

  @override
  String get printDelegationGenericDescription =>
      'Cross-device transaction processing';

  @override
  String get printDelegationThisDevice =>
      'This device (receives delegations here)';

  @override
  String get printDelegationThisDeviceHint =>
      'Other POS devices must target this ID in their delegation settings. This machine does not appear in the list below because you cannot delegate printing to yourself.';

  @override
  String get printDelegationDeviceIdMissing =>
      'Device ID not registered yet — restart the app or log in again.';

  @override
  String printDelegationDeviceName(String name) {
    return 'Device name: $name';
  }

  @override
  String get printDelegationFriendlyName =>
      'Friendly name (visible to other devices)';

  @override
  String get printDelegationFriendlyNameHint => 'e.g. Front counter printer';

  @override
  String get printDelegationMobileTargetHint =>
      'Select the printer desktop below. On that desktop, open Management → Print Delegation and copy the full \"This device\" ID — it must match your selection here.';

  @override
  String get printDelegationDelegateToDesktop =>
      'Delegate printing to another desktop';

  @override
  String printDelegationPlatform(String platform) {
    return 'Platform: $platform';
  }

  @override
  String printDelegationPhone(String phone) {
    return 'Phone: $phone';
  }

  @override
  String printDelegationLoadDevicesError(String error) {
    return 'Error loading devices: $error';
  }

  @override
  String get printDelegationHowItWorks => 'How it works';

  @override
  String get printDelegationMobileStep1 =>
      'Mobile completes transaction but delegates receipt generation';

  @override
  String get printDelegationMobileStep2 =>
      'Desktop picks up the transaction via sync';

  @override
  String get printDelegationMobileStep3 =>
      'Desktop generates receipt and communicates with EBM server';

  @override
  String get printDelegationMobileStep4 =>
      'Mobile is notified when processing is complete';

  @override
  String get printDelegationDesktopStep1 =>
      'Desktop monitors for delegated transactions in real-time';

  @override
  String get printDelegationDesktopStep2 =>
      'Automatically processes receipts from mobile devices';

  @override
  String get printDelegationDesktopStep3 =>
      'Optionally pick another desktop below to delegate this device\'s own printing to';

  @override
  String get printDelegationDesktopStep4 => 'Handles EBM server communication';

  @override
  String get printDelegationDesktopStep5 =>
      'Syncs results back to mobile via sync';

  @override
  String printDelegationCopiedDeviceId(String id) {
    return 'Copied device ID: $id';
  }

  @override
  String get printDelegationCopyDeviceId => 'Copy device ID';

  @override
  String get refundReasonDuplicate => 'Duplicate charge';

  @override
  String get refundReasonOther => 'Other';

  @override
  String get refundAlreadyRefunded => 'Already refunded';

  @override
  String get refundPaymentTitle => 'Refund payment';

  @override
  String get refundIncomeRefunded => 'This income has been refunded';

  @override
  String get refundReturnMoney => 'Return money to the customer';

  @override
  String get refundMoreActions => 'More actions';

  @override
  String refundIncomeReference(String reference) {
    return 'Income · $reference';
  }

  @override
  String get refundShareReceipt => 'Share receipt';

  @override
  String get refundShareReceiptSubtitle => 'Send via WhatsApp, SMS or email';

  @override
  String get refundShareCopySubtitle =>
      'Send a sale copy via WhatsApp, SMS or email';

  @override
  String get refundDownloadPdf => 'Download PDF';

  @override
  String get refundDownloadReceiptSubtitle => 'Save a copy of this receipt';

  @override
  String get refundDownloadCopySubtitle => 'Save this sale as a PDF copy';

  @override
  String get refundPrintSubtitle => 'Send to a connected printer';

  @override
  String refundReturnMoneyFor(String reference) {
    return 'Return money for $reference';
  }

  @override
  String get refundHowMuch => 'How much?';

  @override
  String get refundFull => 'Full refund';

  @override
  String get refundPartial => 'Partial';

  @override
  String get refundChooseAmount => 'Choose amount';

  @override
  String refundCannotExceed(String amount) {
    return 'Can\'t exceed the original $amount';
  }

  @override
  String refundUpToAvailable(String amount) {
    return 'Up to $amount available to refund';
  }

  @override
  String get refundReasonLabel => 'Reason';

  @override
  String get refundTo => 'Refund to';

  @override
  String get refundHandBackNow => 'Hand back now';

  @override
  String get refundSendToPhone => 'Send to phone';

  @override
  String refundAmountButton(String amount) {
    return 'Refund $amount';
  }

  @override
  String get refundOriginalPayment => 'Original payment';

  @override
  String get refundProcessing => 'Processing refund…';

  @override
  String get refundStepValidating => 'Validating refund';

  @override
  String get refundStepRestoringStock => 'Restoring stock';

  @override
  String get refundStepSavingRecords => 'Saving records';

  @override
  String get refundMethodCashLower => 'cash';

  @override
  String get refundCompleted => 'Refund completed';

  @override
  String refundDoneSuffix(String method) {
    return 'was refunded to the customer via $method.';
  }

  @override
  String get refundSheetUnavailable => 'Refund unavailable';

  @override
  String get internetRequiredTitle => 'Internet Connection Required';

  @override
  String get internetRequiredBody =>
      'You need to connect to the internet to continue using Flipper. Our system requires an internet connection every 5 days to verify your account.';

  @override
  String get internetRequiredCheck => 'Check Connection';

  @override
  String get internetRequiredHint =>
      'If you continue to see this screen, please check your internet connection and try again.';

  @override
  String get addCustomerOpening => 'Opening…';

  @override
  String get mposStatusPending => 'Pending';

  @override
  String get mposStatusCompleted => 'Completed';

  @override
  String get mposStatusPaid => 'Paid';

  @override
  String get mposStatusCancelled => 'Cancelled';

  @override
  String get mposStatusParked => 'Parked';

  @override
  String get mposPriceEdited => 'edited';

  @override
  String get balancesExpenses => 'Expenses';

  @override
  String adminChannelNumber(String number) {
    return 'Channel $number';
  }

  @override
  String get adminInvalidSmsPhone =>
      'Please enter a valid phone number with country code (e.g., +250783054874)';

  @override
  String get adminSmsConfigUpdateFailed => 'Failed to update SMS configuration';

  @override
  String get transactionReportsTitle => 'Transaction Reports';

  @override
  String get productNewCategory => 'New category';

  @override
  String get productCategoryDescription =>
      'A category groups similar products together.';

  @override
  String get productCategoryName => 'Category name';

  @override
  String get productCategoryNameHint => 'e.g. Drinks, Bread, Airtime';

  @override
  String get productCategoryNameTooShort => 'Type at least 2 characters.';

  @override
  String get productCategoryCreateFailed =>
      'Could not create the category. Please try again.';

  @override
  String productCategoryAlreadyExists(String name) {
    return '\"$name\" already exists.';
  }

  @override
  String productCategoryUseExisting(String name) {
    return 'Use \"$name\"';
  }

  @override
  String get productCreateCategory => 'Create category';

  @override
  String get serviceModeBarMode => 'Bar Mode';

  @override
  String get serviceModeHotelMode => 'Hotel Mode';

  @override
  String get serviceModeBarCounter => 'Bar counter';

  @override
  String get serviceModeFrontDesk => 'Front desk';

  @override
  String get serviceModeAdminOnly =>
      'Only an admin can switch this device\'s service mode.';

  @override
  String serviceModeSwitchNotSaved(String mode) {
    return 'Could not switch to $mode: the branch settings did not save. Check your connection and try again.';
  }

  @override
  String serviceModeSwitched(String mode, String hotkey) {
    return 'This device switched to $mode · $hotkey to cycle';
  }

  @override
  String get serviceModeSwitchFailed => 'Could not switch service mode.';

  @override
  String serviceModeDeviceNowRuns(String mode) {
    return 'This device now runs $mode.';
  }

  @override
  String serviceModeDeviceFollowsBranch(String mode) {
    return 'This device follows the branch default again ($mode).';
  }

  @override
  String get serviceModeThisDevice => 'This device';

  @override
  String get serviceModeWhatTerminalOpens => 'What this terminal opens';

  @override
  String get serviceModeBranchRunsBoth =>
      'This branch runs both. Put the front desk on the desk terminal and the table floor on the bar counter — each device keeps its own choice.';

  @override
  String get serviceModePickAfterLogin =>
      'Pick what this screen shows after login. Other devices on this branch keep their own choice.';

  @override
  String get serviceModePinnedOnDevice => 'Pinned on this device only.';

  @override
  String get serviceModeUseBranchDefault => 'Use branch default';

  @override
  String get barRoomChargePickerSubtitle =>
      'The tab moves onto the guest folio and is paid at check-out.';

  @override
  String get barRoomChargeEmptyTab =>
      'Add something to the tab before charging a room.';

  @override
  String barRoomChargeMoved(String table, String target, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$table → $target · $_temp0 on the folio';
  }

  @override
  String get barTables => 'Tables';

  @override
  String barFloorOpenTapToLog(String count) {
    return '$count open · tap to log an order';
  }

  @override
  String barFloorOpenTapTableToLog(String count) {
    return '$count open · tap a table to log its order';
  }

  @override
  String get barOpenTab => 'Open tab';

  @override
  String get barTableFree => 'Free';

  @override
  String get barRoleServer => 'Server';

  @override
  String barCashierLogging(String role) {
    return '$role · logging';
  }

  @override
  String get barNoTablesConfigured => 'No tables configured';

  @override
  String barZoneOpenCount(String open, String total) {
    return '$open/$total open';
  }

  @override
  String get barCouldNotLoadStaff => 'Could not load staff';

  @override
  String get barModeSharedRegister => 'Bar mode · Shared register';

  @override
  String get barWhosServing => 'Who\'s serving?';

  @override
  String get barWhosOnRegister => 'Who\'s on the register?';

  @override
  String get barLockHintTapAbove => 'Tap your name above, then enter your PIN';

  @override
  String get barLockHintTapLeft =>
      'Tap your name on the left, then enter your PIN';

  @override
  String get barLockHintEnterPin => 'Enter your 6-digit PIN to log orders';

  @override
  String get barConfiguredByAdmin =>
      'Bar mode configured by admin on the main terminal';

  @override
  String get barStaffFallback => 'Staff';

  @override
  String get barSaveToTab => 'Save to tab';

  @override
  String barFreshTabFor(String table) {
    return 'Fresh tab for $table';
  }

  @override
  String get barTapProductFirstRound => 'Tap a product to add the first round';

  @override
  String get barTapProductsFirstRound => 'Tap products to add the first round';

  @override
  String barLoggedByStaff(String count, String mine) {
    return 'Logged by $count staff · you added $mine';
  }

  @override
  String barYouLoggedLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You\'ve logged $count lines on this tab',
      one: 'You\'ve logged 1 line on this tab',
    );
    return '$_temp0';
  }

  @override
  String get barTabTotal => 'Tab total';

  @override
  String barTabTotalItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return 'Tab total · $_temp0';
  }

  @override
  String get barSettleAndClose => 'Settle bill & close table';

  @override
  String get barSettleManagerPin => 'Settle bill · manager PIN';

  @override
  String get barChargeToRoom => 'Charge to room';

  @override
  String barPriceEach(String price) {
    return '$price each';
  }

  @override
  String get barHideDetails => 'Hide details';

  @override
  String get barEditPriceQty => 'Edit price & quantity';

  @override
  String barTableMetaOpened(String seats, String time, String elapsed) {
    return '$seats seats · opened $time · $elapsed';
  }

  @override
  String barTableMetaOpenedBy(
    String seats,
    String time,
    String opener,
    String elapsed,
  ) {
    return '$seats seats · opened $time by $opener · $elapsed';
  }

  @override
  String barOpenedAtElapsed(String time, String elapsed) {
    return 'Opened $time • $elapsed';
  }

  @override
  String get barSettleRoomChargeSubtitle =>
      'The tab moves onto the guest folio and is invoiced at check-out.';

  @override
  String get barSettleChooseMethod =>
      'Choose method and take payment to close the table.';

  @override
  String get barMobileMoney => 'Mobile Money';

  @override
  String get barPickGuestForBill =>
      'Pick the guest whose folio picks up this bill.';

  @override
  String barRoomChargeNoMoney(String target) {
    return 'No money changes hands now: these lines join $target and are receipted when the guest checks out.';
  }

  @override
  String get barEnterAmountTendered => 'Enter amount tendered';

  @override
  String barAmountDue(String amount) {
    return '$amount due';
  }

  @override
  String get barMomoPushNotice =>
      'A push request will be sent to the guest device.';

  @override
  String barChargeToRoomTotal(String amount) {
    return 'Charge to room — $amount';
  }

  @override
  String barChargeRoomTotal(String room, String amount) {
    return 'Charge Room $room — $amount';
  }

  @override
  String barConfirmPaymentTotal(String amount) {
    return 'Confirm payment — $amount';
  }

  @override
  String barChargeToRoomTotalShort(String amount) {
    return 'Charge to room · $amount';
  }

  @override
  String barChargeRoomTotalShort(String room, String amount) {
    return 'Charge Room $room · $amount';
  }

  @override
  String barConfirmTotalShort(String amount) {
    return 'Confirm · $amount';
  }

  @override
  String get barRoomChargeFootnote =>
      'The table frees up now; the folio is settled at the front desk.';

  @override
  String get barCloseTableFootnote =>
      'Closing the table saves the sale and frees it for new guests.';

  @override
  String get barInvalidReceiptPhone =>
      'Enter a valid 9-digit receipt phone number.';

  @override
  String barSettledToast(String table, String amount, String method) {
    return '$table settled · $amount $method';
  }

  @override
  String get barBackToTab => 'Back to tab';

  @override
  String barSettleBillZone(String zone) {
    return 'Settle bill · $zone';
  }

  @override
  String barSettleZone(String zone) {
    return 'Settle · $zone';
  }

  @override
  String get barSettlingAsManager => 'Settling as manager';

  @override
  String barTableRunningTab(String table) {
    return 'Table $table — running tab';
  }

  @override
  String barServerName(String name) {
    return '$name · Server';
  }

  @override
  String get barSubtotalExclVat => 'Subtotal (excl. VAT)';

  @override
  String get barVat18 => 'VAT 18%';

  @override
  String get barTotalDue => 'Total due';

  @override
  String get barReceiptPhoneNumber => 'Receipt phone number *';

  @override
  String get barReceiptPhoneRequired =>
      'Required — printed on the RRA receipt (TEL).';

  @override
  String get barInvalidMobileNumber =>
      'Enter a valid 9-digit mobile number (e.g. 783054874).';

  @override
  String get barUnnamedProduct => 'Unnamed Product';

  @override
  String get barNoProductsMatch => 'No products match your search';

  @override
  String get barRoomChargeTileSubtitle => 'Bill a guest staying with us';

  @override
  String get barChoose => 'Choose';

  @override
  String get barChange => 'Change';

  @override
  String get barRunningTab => 'Running tab';

  @override
  String barZoneItemCount(String zone, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$zone · $_temp0';
  }

  @override
  String get barBackToTables => 'Back to tables';

  @override
  String get barRemoveStaffTitle => 'Remove staff member';

  @override
  String barRemoveStaffBody(String name) {
    return 'Remove $name from your team? They will lose PIN access for this business.';
  }

  @override
  String get barThisStaffMember => 'this staff member';

  @override
  String get barStaffRemoved => 'Staff member removed';

  @override
  String get barStaffRemoveFailed =>
      'Could not remove staff member. Please try again.';

  @override
  String get barModeAlongsideHotel =>
      'Bar Mode on alongside Hotel Mode — pick what this device runs below.';

  @override
  String get barAdminServiceMode => 'Service Mode';

  @override
  String get barRequirePinTitle => 'Require PIN to switch cashier';

  @override
  String get barRequirePinSubtitle =>
      'Each cashier logs in with their 6-digit PIN before adding to a tab.';

  @override
  String get barFloorFirstTitle => 'Open the table floor on login';

  @override
  String get barFloorFirstSubtitle =>
      'After PIN login, land on the table floor instead of a single cart.';

  @override
  String get barManagerSettleTitle => 'Manager PIN required to settle';

  @override
  String get barManagerSettleSubtitle =>
      'Only a manager PIN can take payment and close a table.';

  @override
  String get barAutoLogoutTitle => 'Auto-logout after saving to a tab';

  @override
  String get barAutoLogoutSubtitle =>
      'Return to the PIN lock after Save to tab.';

  @override
  String get barAdminFloorTables => 'Floor & tables';

  @override
  String get barAdminStaffPins => 'Staff & PINs';

  @override
  String get barNoStaffYet =>
      'No staff yet. Add users in User Management — they appear here with their PINs.';

  @override
  String get barOpenPosWithBarMode => 'Open POS with Bar Mode';

  @override
  String get barTableServiceTitle => 'Table Service (Bar Mode)';

  @override
  String barModeDescription(String hotkey) {
    return 'Turns the register into a shared bar terminal: staff keep a running tab per table, log rounds under their own PIN, and hand off between cashiers without losing the bill. Leave off for standard retail checkout. On a keyboard, $hotkey cycles Bar → Hotel → POS without coming back here.';
  }

  @override
  String barCloseTabBeforeDeleting(String table) {
    return 'Close the open tab on $table before deleting.';
  }

  @override
  String barSaveTableFailed(String table, String error) {
    return 'Could not save $table: $error';
  }

  @override
  String get barDeleteTableQuestion => 'Delete table?';

  @override
  String barRemoveTableBody(String table) {
    return 'Remove $table from the floor plan?';
  }

  @override
  String barCloseZoneTabsBeforeDeleting(String zone) {
    return 'Close open tabs in $zone before deleting the zone.';
  }

  @override
  String get barDeleteZoneQuestion => 'Delete zone?';

  @override
  String barRemoveZoneBody(String zone, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tables',
      one: '1 table',
    );
    return 'Remove $zone and its $_temp0?';
  }

  @override
  String get barDeleteZone => 'Delete zone';

  @override
  String get barNoTablesConfiguredYet => 'No tables configured yet.';

  @override
  String get barLoadDefaultFloorPlan => 'Load default floor plan';

  @override
  String get barAddZone => 'Add zone';

  @override
  String barTablesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tables',
      one: '1 table',
    );
    return '$_temp0';
  }

  @override
  String get barAddTable => 'Add table';

  @override
  String get barDeleteTable => 'Delete table';

  @override
  String get barSeatsLabel => 'SEATS';

  @override
  String get barZoneName => 'Zone name';

  @override
  String get barZoneNameHint => 'e.g. Patio';

  @override
  String get barSettleNeedsManagerPin => 'Settling a bill needs a manager PIN.';

  @override
  String get barCanSettleBills => 'can settle bills';

  @override
  String get barLogsOrders => 'logs orders';

  @override
  String get barWrongPinTryAgain => 'Wrong PIN — try again';

  @override
  String get barSelectYourName => 'Select your name';

  @override
  String get barOpenStatus => 'Open';

  @override
  String barSeatsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seats',
      one: '1 seat',
    );
    return '$_temp0';
  }

  @override
  String barOpenedAt(String time) {
    return 'Opened $time';
  }

  @override
  String barOpenedAtBy(String time, String name) {
    return 'Opened $time by $name';
  }

  @override
  String barElapsedOpen(String elapsed) {
    return '$elapsed open';
  }

  @override
  String barItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get barTapProductsToStartTab => 'Tap products to start a tab';

  @override
  String get barViewTab => 'View tab';

  @override
  String get hotelAutoRoomChargeOff =>
      'Auto room charge is off — use + Room charge';

  @override
  String hotelRoomChargeNotPosted(String error) {
    return 'Room charge not posted: $error';
  }

  @override
  String hotelRoomHeldFor(String room, String guest) {
    return 'Room $room held for $guest';
  }

  @override
  String get hotelSmsOutOfCredits => 'SMS not sent — branch is out of credits';

  @override
  String hotelQuotationNotSent(String reference) {
    return '$reference was not sent — try again';
  }

  @override
  String hotelQuotationEmailed(String reference, String email) {
    return '$reference emailed to $email';
  }

  @override
  String hotelQuotationEmailFailed(String reference, String error) {
    return 'Could not email $reference: $error';
  }

  @override
  String hotelQuotationBooked(String reference, String room) {
    return '$reference booked · Room $room held';
  }

  @override
  String hotelRoomNoLongerOnBranch(String room) {
    return 'Room $room is no longer on this branch';
  }

  @override
  String hotelRoomCheckedOut(String room) {
    return 'Room $room checked out';
  }

  @override
  String get hotelSignInWithPinToOpenDesk =>
      'Sign in with your PIN to open the desk';

  @override
  String get hotelQuotationPdfTitle => 'QUOTATION';

  @override
  String get hotelPreparedFor => 'Prepared for';

  @override
  String get hotelRoom => 'Room';

  @override
  String get hotelArrival => 'Arrival';

  @override
  String get hotelDeparture => 'Departure';

  @override
  String get hotelNights => 'Nights';

  @override
  String hotelNightsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nights',
      one: '1 night',
    );
    return '$_temp0';
  }

  @override
  String get hotelGuests => 'Guests';

  @override
  String get hotelStay => 'Stay';

  @override
  String hotelAdultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count adults',
      one: '1 adult',
    );
    return '$_temp0';
  }

  @override
  String hotelChildrenCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count children',
      one: '1 child',
    );
    return '$_temp0';
  }

  @override
  String hotelQuotationRoomLine(String room, String nights, String rate) {
    return 'Room $room — $nights × $rate';
  }

  @override
  String get hotelExtras => 'Extras';

  @override
  String get hotelDescription => 'Description';

  @override
  String get hotelTotal => 'Total';

  @override
  String get hotelQuotationHoldsNoRoom =>
      'This quotation holds no room until it is accepted.';

  @override
  String hotelQuotationExpiredOn(String date) {
    return 'Expired $date';
  }

  @override
  String hotelQuotationValidUntil(String date) {
    return 'Valid until $date';
  }

  @override
  String get hotelNote => 'Note';

  @override
  String get hotelQuotationTerms =>
      'Rates are per room per night and subject to availability. A quotation holds no room until it is accepted and confirmed by the front desk.';

  @override
  String get hotelManagerApprovedToast =>
      'Manager approved — tap Check out to settle';

  @override
  String hotelCalendarTapFreeNight(String month) {
    return 'Tap a free night to hold the room · $month';
  }

  @override
  String get hotelLegendFree => 'Free';

  @override
  String get hotelLegendReserved => 'Reserved';

  @override
  String get hotelLegendInHouse => 'In house';

  @override
  String get hotelLegendBlocked => 'Blocked';

  @override
  String get hotelToday => 'Today';

  @override
  String get hotelNoRoomsYet => 'No rooms on this branch yet.';

  @override
  String hotelFreeRoomsCount(int count) {
    return '$count free';
  }

  @override
  String hotelCalendarFreeTapToHold(String room) {
    return 'Free — tap to hold $room';
  }

  @override
  String get hotelBlockedForMaintenance => 'Blocked for maintenance';

  @override
  String get hotelTodayAtProperty => 'Today at the property';

  @override
  String get hotelGoodDay => 'Good day';

  @override
  String hotelGoodDayName(String name) {
    return 'Good day, $name';
  }

  @override
  String hotelOccupancySummary(int occupied, int sellable, int guests) {
    String _temp0 = intl.Intl.pluralLogic(
      guests,
      locale: localeName,
      other: '$guests guests',
      one: '1 guest',
    );
    return '$occupied of $sellable sellable rooms occupied · $_temp0 in house';
  }

  @override
  String get hotelOccupancy => 'occupancy';

  @override
  String get hotelArrivalsToday => 'Arrivals today';

  @override
  String hotelInNextSevenDays(int count) {
    return '$count in the next 7 days';
  }

  @override
  String get hotelDeparturesToday => 'Departures today';

  @override
  String hotelOverdueCount(int count) {
    return '$count overdue';
  }

  @override
  String get hotelNoneOverdue => 'none overdue';

  @override
  String get hotelAvailableRooms => 'Available rooms';

  @override
  String hotelAwaitingCleaningCount(int count) {
    return '$count awaiting cleaning';
  }

  @override
  String get hotelPendingPayments => 'Pending payments';

  @override
  String hotelOpenFoliosCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count open folios',
      one: '1 open folio',
    );
    return '$_temp0';
  }

  @override
  String get hotelRoomRevenueTonight => 'Room revenue tonight';

  @override
  String get hotelContractedInHouse => 'contracted for in-house stays';

  @override
  String get hotelOpenQuotations => 'Open quotations';

  @override
  String hotelAmountQuoted(String amount) {
    return '$amount quoted';
  }

  @override
  String hotelStaysPastDeparture(int count, String rooms) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stays',
      one: '1 stay',
    );
    return '$_temp0 past departure — $rooms';
  }

  @override
  String hotelRoomNamed(String room) {
    return 'Room $room';
  }

  @override
  String get hotelOpenBoard => 'Open board';

  @override
  String get hotelArrivingToday => 'Arriving today';

  @override
  String get hotelNoArrivalsToday => 'No arrivals booked for today.';

  @override
  String get hotelDepartingToday => 'Departing today';

  @override
  String get hotelNoDeparturesToday => 'Nobody is due to leave today.';

  @override
  String get hotelOverdue => 'overdue';

  @override
  String get hotelCharges => 'Charges';

  @override
  String hotelItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get hotelBackToRooms => 'Back to rooms';

  @override
  String hotelFolioOpenedBy(String name) {
    return 'Folio · opened by $name';
  }

  @override
  String get hotelFrontDesk => 'front desk';

  @override
  String get hotelNoChargesYet =>
      'No charges yet. Post the room charge to start this folio.';

  @override
  String get hotelAutoRoomChargeOffHelp =>
      'Automatic room charge is off for this branch.\nUse + Room charge above, or turn it back on in Settings → Hotel Mode.';

  @override
  String get hotelCancelStay => 'Cancel stay';

  @override
  String get hotelSettling => 'Settling…';

  @override
  String hotelCheckOutAmount(String amount) {
    return 'Check out · $amount';
  }

  @override
  String get hotelPosting => 'Posting…';

  @override
  String get hotelFolioNotFound =>
      'Folio not found — reopen the room and retry';

  @override
  String hotelCheckoutFailed(String error) {
    return 'Checkout failed: $error';
  }

  @override
  String get hotelFrontDeskSharedRegister => 'Front desk · Shared register';

  @override
  String get hotelLockHintEnterPin => 'Enter your 6-digit PIN to open the desk';

  @override
  String get hotelWhosOnDeskEyebrow => 'WHO\'S ON THE DESK?';

  @override
  String get hotelWhosOnDesk => 'Who\'s on the desk?';

  @override
  String get hotelSignInToReception => 'Sign in to reception';

  @override
  String get hotelNoStaffToShow =>
      'No staff to show. Add users in User Management — they appear here with their PINs. If this device is offline, connect once so staff can sign in offline afterwards.';

  @override
  String get hotelConfiguredByAdmin =>
      'Hotel mode configured by admin on the main terminal';

  @override
  String get hotelQuoteNew => 'New';

  @override
  String get hotelNewQuotation => 'New quotation';

  @override
  String get hotelQuotations => 'Quotations';

  @override
  String hotelQuotationsOpenSummary(int count) {
    return '$count open · a quotation holds no room until it is accepted';
  }

  @override
  String get hotelNoQuotationsYet =>
      'No quotations yet.\nCreate one to price a stay for a guest before they commit.';

  @override
  String get hotelQuoteStatusBooked => 'Booked';

  @override
  String get hotelQuoteStatusExpired => 'Expired';

  @override
  String get hotelQuoteStatusDeclined => 'Declined';

  @override
  String get hotelQuoteStatusAccepted => 'Accepted';

  @override
  String get hotelQuoteStatusSent => 'Sent';

  @override
  String get hotelQuoteStatusDraft => 'Draft';

  @override
  String hotelRoomWithType(String room, String type) {
    return 'Room $room · $type';
  }

  @override
  String hotelQuoteEmailedAt(String date) {
    return 'Emailed $date';
  }

  @override
  String hotelQuoteValidTo(String date) {
    return 'valid to $date';
  }

  @override
  String get hotelQuoteDocument => 'Document';

  @override
  String get hotelQuoteEmailToGuest => 'Email to guest';

  @override
  String get hotelQuoteEmailPdfToGuest => 'Email PDF to guest';

  @override
  String get hotelQuoteAddEmailFirst => 'Add an email address first';

  @override
  String get hotelQuoteDownloadPdf => 'Download PDF';

  @override
  String get hotelQuotePrint => 'Print';

  @override
  String get hotelQuoteOpenPrintDialog => 'Open the print dialog';

  @override
  String hotelQuotationHeader(String reference) {
    return 'QUOTATION $reference';
  }

  @override
  String get hotelEmailLooksWrong => 'That email does not look right';

  @override
  String get hotelEmailThisQuotation => 'Email this quotation';

  @override
  String get hotelPdfGoesAsAttachment => 'The PDF goes out as an attachment.';

  @override
  String get hotelGuestEmail => 'Guest email';

  @override
  String get hotelEmailSavedToQuotation =>
      'Saved to the quotation, so the next send needs no retyping.';

  @override
  String get hotelSendQuotation => 'Send quotation';

  @override
  String get hotelAcceptAndHold => 'Accept & hold';

  @override
  String hotelRemoveQuotationTitle(String reference) {
    return 'Remove $reference?';
  }

  @override
  String hotelRemoveQuotationBody(String guest) {
    return 'This deletes the quotation for $guest. Any reservation it already created is untouched.';
  }

  @override
  String get hotelPreparingQuotation => 'Preparing quotation…';

  @override
  String get hotelQuotation => 'Quotation';

  @override
  String hotelQuotationRef(String reference) {
    return 'Quotation $reference';
  }

  @override
  String get hotelEmailUs => 'us';

  @override
  String hotelEmailValidUntil(String date) {
    return 'This quotation is valid until $date.';
  }

  @override
  String hotelEmailYourQuotation(String reference) {
    return 'Your quotation, $reference';
  }

  @override
  String hotelEmailHtmlIntro(
    String guest,
    String business,
    String room,
    String nights,
  ) {
    return 'Hello $guest, thank you for considering $business. Your quotation for Room $room over $nights is attached as a PDF.';
  }

  @override
  String get hotelEmailHoldsNoRoom =>
      'A quotation holds no room until it is accepted — reply to this email or call us to confirm.';

  @override
  String hotelEmailHello(String guest) {
    return 'Hello $guest,';
  }

  @override
  String hotelEmailPlainIntro(String business, String reference, String room) {
    return 'Thank you for considering $business. Your quotation $reference for Room $room is attached as a PDF.';
  }

  @override
  String get hotelEmailPlainHoldsNoRoom =>
      'A quotation holds no room until it is accepted — reply or call us to confirm.';

  @override
  String get hotelFrontDeskTitle => 'Front Desk';

  @override
  String hotelBoardSubtitle(String fraction) {
    return '$fraction occupied · tap a room to check in or open its folio';
  }

  @override
  String hotelOccupiedFraction(String fraction) {
    return '$fraction occupied';
  }

  @override
  String hotelRoleOnDuty(String role) {
    return '$role · on duty';
  }

  @override
  String get hotelReception => 'Reception';

  @override
  String get hotelSettings => 'Settings';

  @override
  String get hotelHandOver => 'Hand over';

  @override
  String get hotelHandOverDesk => 'Hand over the desk';

  @override
  String hotelCouldNotLoadBoard(String error) {
    return 'Could not load the board.\n$error';
  }

  @override
  String get hotelGuestNameRequired => 'Guest name is required';

  @override
  String hotelRoomMaxCapacity(String room, String capacity) {
    return 'Room $room sleeps $capacity';
  }

  @override
  String get hotelEmailInvalid => 'That email does not look right';

  @override
  String hotelCheckInTitle(String room) {
    return 'Check in · Room $room';
  }

  @override
  String hotelRoomTypeSleeps(String type, String capacity) {
    return '$type · sleeps $capacity';
  }

  @override
  String get hotelGuestName => 'Guest name';

  @override
  String get hotelGuestNameHint => 'e.g. Aline Uwase';

  @override
  String get hotelPhoneOptional => 'Phone (optional)';

  @override
  String get hotelEmailOptional => 'Email (optional)';

  @override
  String get hotelSendsConfirmationHint => 'Sends the confirmation';

  @override
  String get hotelAdults => 'Adults';

  @override
  String get hotelChildren => 'Children';

  @override
  String get hotelRatePerNightRwf => 'Rate per night (RWF)';

  @override
  String get hotelCheckInGuest => 'Check in guest';

  @override
  String get hotelRoomCharge => 'Room charge';

  @override
  String get hotelNavToday => 'Today';

  @override
  String get hotelNavRooms => 'Rooms';

  @override
  String get hotelNavCalendar => 'Calendar';

  @override
  String get hotelNavQuotes => 'Quotes';

  @override
  String get hotelDueOut => 'Due out';

  @override
  String get hotelRate => 'Rate';

  @override
  String hotelPriceEach(String price) {
    return '$price each';
  }

  @override
  String get hotelTaxIncl => 'Tax (incl.)';

  @override
  String get hotelFolioTotal => 'Folio total';

  @override
  String get hotelCheckOut => 'Check out';

  @override
  String hotelFolioTotalAmount(String amount) {
    return 'Folio total $amount';
  }

  @override
  String get hotelPaymentCard => 'Card';

  @override
  String get hotelChangeDue => 'Change due';

  @override
  String get hotelSettleAndRelease => 'Settle & release room';

  @override
  String get hotelOutOfOrder => 'Out of order';

  @override
  String get hotelHkClean => 'Clean';

  @override
  String get hotelHkCleanMeaning =>
      'Ready to sell — the desk can check a guest in.';

  @override
  String get hotelHkDirty => 'Needs cleaning';

  @override
  String get hotelHkDirtyMeaning =>
      'Held back from sale until housekeeping releases it.';

  @override
  String get hotelHkInspected => 'Inspected';

  @override
  String get hotelHkInspectedMeaning =>
      'Cleaned and checked by a supervisor. Sellable.';

  @override
  String get hotelHkOutOfOrderMeaning =>
      'Blocked for maintenance. Never offered to a guest.';

  @override
  String hotelHousekeepingTitle(String room) {
    return 'Housekeeping · Room $room';
  }

  @override
  String hotelOccupiedNotice(String guest) {
    return '$guest is in this room. Check them out before blocking it for maintenance.';
  }

  @override
  String get hotelUnavailableWhileOccupied =>
      'Unavailable while the room is occupied.';

  @override
  String get hotelManager => 'Manager';

  @override
  String get hotelEnterManagerPin => 'Enter manager 6-digit PIN';

  @override
  String get hotelNotManagerPin => 'Not a manager PIN';

  @override
  String get hotelManagerApproval => 'Manager approval';

  @override
  String get hotelSettleNeedsManagerPin =>
      'Settling a folio needs a manager PIN.';

  @override
  String get hotelModeAlongsideBar =>
      'Hotel Mode on alongside Bar Mode — pick what this device runs below.';

  @override
  String get hotelHouseCheckoutTime => 'House checkout time';

  @override
  String get hotelAdminLodging => 'Lodging';

  @override
  String get hotelAdminRoomsFloors => 'Rooms & floors';

  @override
  String get hotelAdminRatesBilling => 'Rates & billing';

  @override
  String get hotelAdminGuestNotifications => 'Guest notifications';

  @override
  String get hotelAdminCompanyStamp => 'Company stamp';

  @override
  String get hotelAutoPostTitle => 'Post the room charge at check-in';

  @override
  String get hotelAutoPostSubtitle =>
      'Bills nights × rate to the folio as soon as the guest takes the key.';

  @override
  String get hotelRequirePinTitle => 'Require PIN to switch clerk';

  @override
  String get hotelRequirePinSubtitle =>
      'Shared register: the desk opens on a PIN lock and any staff member can sign in.';

  @override
  String get hotelManagerCheckoutTitle => 'Manager required to settle a folio';

  @override
  String get hotelManagerCheckoutSubtitle =>
      'Only a manager can take payment and release the room at checkout.';

  @override
  String get hotelAutoLogoutTitle => 'Hand the desk back after checkout';

  @override
  String get hotelAutoLogoutSubtitle =>
      'Returns to the PIN lock once a guest is checked out.';

  @override
  String get hotelRoomChargeProduct => 'Room charge product';

  @override
  String hotelCheckoutDefaultSubtitle(String time) {
    return 'Departure defaults to $time on the last night.';
  }

  @override
  String get hotelOpenFrontDesk => 'Open the front desk';

  @override
  String get hotelLoading => 'Loading…';

  @override
  String get hotelRoomChargeNotSet =>
      'Not set — room charges cannot be posted until you pick a registered product.';

  @override
  String hotelRoomChargeMissing(String id) {
    return 'Product $id is no longer on this branch. Pick another.';
  }

  @override
  String get hotelNotifyEmailTitle => 'Email the guest a confirmation';

  @override
  String get hotelNotifyEmailSubtitle =>
      'Free. Sent whenever the guest gave an email address.';

  @override
  String get hotelNotifySmsTitle => 'Text the guest a confirmation';

  @override
  String get hotelNotifySmsSubtitle =>
      'Costs 30 credits per message. Off until you turn it on.';

  @override
  String get hotelNotifyReserveTitle => 'Confirm when a room is held';

  @override
  String get hotelNotifyReserveSubtitle =>
      'Sent at the moment a future arrival is booked in.';

  @override
  String get hotelNotifyCheckInTitle => 'Welcome the guest at check-in';

  @override
  String get hotelNotifyCheckInSubtitle =>
      'Sent when the guest actually takes the key.';

  @override
  String get hotelStampTitle => 'Stamp quotations and proformas';

  @override
  String get hotelStampUploadFirst =>
      'Upload a stamp below, then turn this on.';

  @override
  String get hotelStampDrawnOn =>
      'Drawn on the last page of every generated document.';

  @override
  String get hotelNoStamp => 'No stamp';

  @override
  String get hotelStampUnreadable => 'Unreadable';

  @override
  String hotelStampSizeHint(String size) {
    return 'PNG or JPEG under ${size}KB. A transparent PNG looks best.';
  }

  @override
  String get hotelUpload => 'Upload';

  @override
  String get hotelReplace => 'Replace';

  @override
  String get hotelStampBottomRight => 'Bottom right';

  @override
  String get hotelStampBottomLeft => 'Bottom left';

  @override
  String get hotelStampBottomCentre => 'Bottom centre';

  @override
  String get hotelStampBesideTotal => 'Beside the total';

  @override
  String get hotelStampPosition => 'Position';

  @override
  String get hotelStampWidth => 'Width';

  @override
  String get hotelStampUpdated => 'Company stamp updated.';

  @override
  String get hotelStampSavedLocalOnly =>
      'Stamp saved on this device only — other terminals will not use it.';

  @override
  String hotelStampSetFailed(String error) {
    return 'Failed to set stamp: $error';
  }

  @override
  String get hotelStampRemoved => 'Company stamp removed.';

  @override
  String get hotelStampRemovedLocalOnly =>
      'Stamp removed on this device only — other terminals still have it.';

  @override
  String get hotelStampSavedDeviceOnly => 'Stamp saved on this device only.';

  @override
  String get hotelModeTitle => 'Hotel Mode (Front Desk)';

  @override
  String get hotelOnBadge => 'ON';

  @override
  String hotelModeDescription(String hotkey) {
    return 'Turns the register into a front desk: a board of rooms by floor, check-in with guest and dates, a running folio per stay that the bar and restaurant can charge to, and settlement at checkout. Replaces Bar Mode and standard retail checkout on this branch. On a keyboard, $hotkey cycles Bar → Hotel → POS without coming back here.';
  }

  @override
  String get hotelPickRoomToQuote => 'Pick a room to quote';

  @override
  String get hotelEditQuotation => 'Edit quotation';

  @override
  String get hotelQuotationIntro =>
      'A priced offer. It holds no room until the guest accepts it.';

  @override
  String get hotelQuotationEmailHint => 'Where the quotation PDF is sent';

  @override
  String get hotelRatePerNightShort => 'Rate / night';

  @override
  String get hotelValidForDays => 'Valid for (days)';

  @override
  String get hotelSaveQuotation => 'Save quotation';

  @override
  String get hotelUpdateQuotation => 'Update quotation';

  @override
  String hotelRoomsAvailableForDates(String count) {
    return 'Room · $count available for these dates';
  }

  @override
  String hotelNoRoomFree(String count) {
    return 'Nothing sleeping $count is free for those dates.';
  }

  @override
  String hotelNightsQuoted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nights quoted',
      one: '1 night quoted',
    );
    return '$_temp0';
  }

  @override
  String get hotelDatesTaken => 'Those dates are already taken for this room';

  @override
  String hotelReserveTitle(String room) {
    return 'Reserve · Room $room';
  }

  @override
  String get hotelHoldRoom => 'Hold the room';

  @override
  String hotelRoomTakenBetween(String room, String from, String to) {
    return 'Room $room is already taken between $from and $to.';
  }

  @override
  String hotelGuestsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count guests',
      one: '1 guest',
    );
    return '$_temp0';
  }

  @override
  String hotelRoomSemantic(String room, String type, String state) {
    return 'Room $room, $type, $state';
  }

  @override
  String get hotelTapToCheckIn => 'tap to check in';

  @override
  String hotelDueOutAt(String time) {
    return 'Due out $time';
  }

  @override
  String hotelOutOn(String date) {
    return 'Out $date';
  }

  @override
  String get hotelAwaitingHousekeeping => 'Awaiting housekeeping';

  @override
  String hotelPerNight(String amount) {
    return '$amount / night';
  }

  @override
  String get hotelNoActiveBranch => 'No active branch';

  @override
  String get hotelRoomChargeIntro =>
      'The nightly rate is billed against this product, so it must be registered with RRA.';

  @override
  String get hotelNoProductsFound => 'No products found.';

  @override
  String get hotelNotRegisteredWithRra =>
      'Not registered with RRA — register it first';

  @override
  String hotelRoomIsState(String room, String state) {
    return 'Room $room is $state';
  }

  @override
  String hotelCheckInGuestQuestion(String guest) {
    return 'Check in $guest?';
  }

  @override
  String hotelReservedArrivalBody(String room) {
    return 'Room $room is reserved for them. Checking in opens the folio and posts the room charge.';
  }

  @override
  String get hotelNotYet => 'Not yet';

  @override
  String get hotelCheckIn => 'Check in';

  @override
  String hotelRoomSavedNotRegistered(String room, String error) {
    return 'Room $room saved, but not registered with RRA: $error';
  }

  @override
  String get hotelNewFloorOrWing => 'New floor or wing';

  @override
  String hotelRoomHasGuest(String room) {
    return 'Room $room has a guest or a booking. Check them out first.';
  }

  @override
  String hotelDeleteRoomQuestion(String room) {
    return 'Delete room $room?';
  }

  @override
  String get hotelDeleteRoomBody =>
      'It disappears from the board, the calendar and availability. Past stays and their invoices are untouched.';

  @override
  String hotelRoomStillHasGuest(String room) {
    return 'Room $room still has a guest or a booking.';
  }

  @override
  String hotelDeleteFloorQuestion(String floor) {
    return 'Delete $floor?';
  }

  @override
  String hotelDeleteFloorBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Removes $count rooms on this floor.',
      one: 'Removes 1 room on this floor.',
    );
    return '$_temp0';
  }

  @override
  String get hotelStarterPlanBody =>
      'Start from a sample plan of 15 rooms across three floors, then edit the numbers, types and rates to match the property.';

  @override
  String get hotelCreateStarterPlan => 'Create a starter plan';

  @override
  String hotelRoomsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rooms',
      one: '1 room',
    );
    return '$_temp0';
  }

  @override
  String get hotelDeleteFloor => 'Delete floor';

  @override
  String get hotelAddRoom => 'Add room';

  @override
  String get hotelAddFloorOrWing => 'Add a floor or wing';

  @override
  String get hotelFloorNameHint => 'e.g. Second Floor';

  @override
  String get hotelRequired => 'Required';

  @override
  String get hotelInUse => 'In use';

  @override
  String get hotelRoomNoHint => 'No.';

  @override
  String get hotelRoomTypeHint => 'Type';

  @override
  String get hotelRegisteredWithRra =>
      'Registered with RRA as a tourism-tax service';

  @override
  String get hotelNotRegisteredTapToRegister =>
      'Not registered with RRA — tap to register';

  @override
  String get hotelCannotDeleteOccupied => 'Occupied or booked — cannot delete';

  @override
  String get hotelDeleteRoom => 'Delete room';

  @override
  String get hotelStateVacant => 'Vacant';

  @override
  String get hotelStateOccupied => 'Occupied';

  @override
  String get hotelStateReserved => 'Reserved';

  @override
  String get hotelStateCleaning => 'Cleaning';

  @override
  String get hotelAllFloors => 'All floors';

  @override
  String get hotelChargeToRoom => 'Charge to room';

  @override
  String get hotelChargeToRoomSubtitle =>
      'Pick the guest whose folio picks up this bill.';

  @override
  String get hotelStaySearchHint => 'Room number, guest name or phone';

  @override
  String hotelStayOutLine(String summary, String date) {
    return '$summary · out $date';
  }

  @override
  String get hotelLookingUpGuests => 'Looking up guests…';

  @override
  String get hotelNobodyCheckedIn => 'Nobody is checked in';

  @override
  String get hotelReadingRooms => 'Reading the rooms from this branch.';

  @override
  String get hotelNoGuestsBody =>
      'A tab can only be charged to a guest who has checked in. Reservations pick up charges once they arrive.';

  @override
  String hotelNoGuestMatches(String term) {
    return 'No guest matches \"$term\"';
  }

  @override
  String get hotelSearchByHint => 'Search by room number, guest name or phone.';

  @override
  String get creditsHubTitle => 'Credit Hub';

  @override
  String get creditsAddCredits => 'Add Credits';

  @override
  String get creditsAvailable => 'Available Credits';

  @override
  String get creditsLabel => 'Credits';

  @override
  String creditsMaximum(String max) {
    return 'Maximum: $max';
  }

  @override
  String get creditsEnterAmount => 'Enter amount';

  @override
  String get creditsPayNow => 'Pay Now';

  @override
  String get creditsEnterValidAmount => 'Please enter a valid amount';

  @override
  String get creditsEnterValidPhone => 'Please enter a valid phone number';

  @override
  String get creditsPaymentRequestFailed =>
      'Payment request failed. Please try again.';

  @override
  String creditsErrorOccurred(String error) {
    return 'An error occurred: $error';
  }

  @override
  String get creditsPaymentDeclined =>
      'The payment was declined on your phone.';

  @override
  String get creditsPaymentSuccessful => 'Payment Successful';

  @override
  String get creditsPaymentInitiated => 'Payment Initiated';

  @override
  String creditsPaymentRequestSent(String phone) {
    return 'A payment request has been sent to $phone.';
  }

  @override
  String get creditsApprovePayment =>
      'Please check your phone and approve the payment.';

  @override
  String creditsNothingCharged(String reason) {
    return '$reason Nothing was charged — you can try again.';
  }

  @override
  String get creditsVerificationTimedOut =>
      'Payment verification timed out. Please check your credits later.';

  @override
  String get creditsPaymentProcessed =>
      'Your payment has been successfully processed!';

  @override
  String get creditsAdded => 'Your credits have been added to your account.';

  @override
  String get creditsQuickAdd => 'Quick Add';

  @override
  String get delegationStatusCompleted => 'Completed';

  @override
  String get delegationStatusDelegated => 'Delegated';

  @override
  String get delegationStatusFailed => 'Failed';

  @override
  String get delegationFilterAll => 'All';

  @override
  String delegationTransactionName(String id) {
    return 'Transaction $id';
  }

  @override
  String get delegationBannerTapToOpen => 'Tap to open Delegations';

  @override
  String get delegationRetryQueued =>
      'Retry queued. If it fails again, re-send the sale from the POS device.';

  @override
  String get delegationRetryError => 'Error retrying delegation';

  @override
  String get delegationAboutTitle => 'About Delegations';

  @override
  String get delegationAboutBody =>
      'Print Delegation allows mobile devices to send print jobs to desktop printers. Failed delegations can be retried from this screen.';

  @override
  String get delegationGotIt => 'Got it';

  @override
  String get delegationTitle => 'Print Delegation';

  @override
  String delegationHeaderSubtitle(String count) {
    return 'Track and manage transactions delegated across your tills — $count in view.';
  }

  @override
  String get delegationSearchHint => 'Search delegations, receipt, payment…';

  @override
  String get delegationFilter => 'Filter';

  @override
  String get delegationRetryTooltip => 'Retry delegation';

  @override
  String get delegationReceiptType => 'Receipt Type';

  @override
  String get delegationEmptyTitle => 'No delegations found';

  @override
  String get delegationEmptyDeviceHint =>
      'Delegations sent to this device will appear here. Senders must target this device ID in delegation settings.';

  @override
  String get delegationEmptyFilterHint =>
      'Try a different search term or switch the filter above to see more results.';

  @override
  String get saleAgentAssignTitle => 'Assign agent';

  @override
  String get saleAgentAgentsSection => 'AGENTS';

  @override
  String get saleAgentSearchHint => 'Search agents...';

  @override
  String get saleAgentNoAgentsForBusiness =>
      'No agents found for this business. Add agents in User Management.';

  @override
  String get saleAgentNoSearchMatch => 'No agents match your search.';

  @override
  String get saleAgentCommissionSection => 'COMMISSION';

  @override
  String get saleAgentFixedRwf => 'Fixed (RWF)';

  @override
  String get saleAgentPercent => 'Percent (%)';

  @override
  String get saleAgentAmountRwf => 'Amount (RWF)';

  @override
  String get saleAgentRatePercent => 'Rate (%)';

  @override
  String saleAgentExample(String example) {
    return 'e.g. $example';
  }

  @override
  String get saleAgentSelectAgent => 'Select an agent';

  @override
  String get saleAgentEnterValidCommission => 'Enter a valid commission';

  @override
  String get saleAgentPercentMax => 'Percent cannot exceed 100';

  @override
  String get saleAgentApply => 'Apply';

  @override
  String get saleAgentNoContact => 'No contact';

  @override
  String get saleAgentBadge => 'Agent';

  @override
  String personalGoalBannerReached(String name) {
    return 'Goal reached: $name';
  }

  @override
  String personalGoalBannerReachedForPeriod(String period, String name) {
    return 'Goal reached for $period: $name';
  }

  @override
  String personalGoalBannerTargetMet(String amount) {
    return 'Target of $amount met';
  }

  @override
  String personalGoalBannerTargetMetRestart(String amount, String restart) {
    return 'Target of $amount met · $restart';
  }

  @override
  String personalGoalBannerSavedTo(String amount, String name) {
    return '+$amount saved to $name';
  }

  @override
  String personalGoalSavedOfTarget(String saved, String target) {
    return '$saved of $target';
  }

  @override
  String personalGoalBannerSavedSoFar(String amount) {
    return '$amount saved so far';
  }

  @override
  String personalGoalBannerOneReached(String name) {
    return '$name reached its target';
  }

  @override
  String personalGoalBannerManyReached(int count) {
    return '$count goals reached their target';
  }

  @override
  String personalGoalBannerSavedAcross(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count goals',
      one: '1 goal',
    );
    return '+$amount saved across $_temp0';
  }

  @override
  String get personalGoalBannerEyebrow => 'PERSONAL GOAL  ·  now';

  @override
  String get personalGoalBannerDismiss => 'Dismiss';

  @override
  String personalGoalRemoteCreditNotification(String name, String amount) {
    return '$name: +$amount saved (auto or synced from another device)';
  }

  @override
  String get personalGoalTopPriorityEyebrow => 'TOP PRIORITY';

  @override
  String get personalGoalSaved => 'Saved';

  @override
  String get personalGoalTarget => 'Target';

  @override
  String get personalGoalAutoAllocation => 'Auto allocation';

  @override
  String personalGoalProfitReserved(String percent) {
    return '$percent% of profit reserved';
  }

  @override
  String get personalGoalAutoAllocationOptional => 'Optional — set in edit';

  @override
  String get personalGoalUpdatedFromProfits => 'Updated from profits';

  @override
  String get personalGoalAddMoney => 'Add money';

  @override
  String get personalGoalAddMoneyCashIn => '· Cash in';

  @override
  String personalGoalReachedForPeriod(String period, String restart) {
    return 'Reached for $period · $restart';
  }

  @override
  String personalGoalLastPeriodReached(String period, String amount) {
    return '$period: $amount · reached';
  }

  @override
  String personalGoalLastPeriodProgress(String period, String progress) {
    return '$period: $progress';
  }

  @override
  String get personalGoalNewGoal => 'New goal';

  @override
  String get personalGoalNewGoalExamples => 'Equipment, rent, training…';

  @override
  String get personalGoalEditGoal => 'Edit goal';

  @override
  String get personalGoalEditSubtitle =>
      'Update amounts and settings for this goal.';

  @override
  String get personalGoalNewSubtitle =>
      'Set a name and target. You can add money anytime from cash in.';

  @override
  String get personalGoalNameSection => 'GOAL NAME';

  @override
  String get personalGoalNameLabel => 'What are you saving for?';

  @override
  String get personalGoalNameHint => 'e.g. Emergency fund, equipment';

  @override
  String get personalGoalNameRequired => 'Enter a goal name';

  @override
  String get personalGoalAmountsSection => 'AMOUNTS (RWF)';

  @override
  String get personalGoalTargetAmount => 'Target amount';

  @override
  String get personalGoalTargetRequired => 'Enter a target greater than 0';

  @override
  String get personalGoalAlreadySaved => 'Already saved';

  @override
  String get personalGoalAlreadySavedHint => '0 — optional';

  @override
  String get personalGoalCannotBeNegative => 'Cannot be negative';

  @override
  String get personalGoalRepeatsSection => 'REPEATS';

  @override
  String get personalGoalRepeats => 'Repeats';

  @override
  String get personalGoalOptionalSection => 'OPTIONAL';

  @override
  String get personalGoalAutoAllocationPercent => 'Auto allocation %';

  @override
  String get personalGoalAutoAllocationHint => 'Leave empty if not used';

  @override
  String get personalGoalPercentRange => 'Use 0–100';

  @override
  String get personalGoalTopPriority => 'Top priority';

  @override
  String get personalGoalTopPriorityHint => 'Shown first on your dashboard';

  @override
  String get personalGoalSaveChanges => 'Save changes';

  @override
  String get personalGoalCreateGoal => 'Create goal';

  @override
  String get agentCommissionPayoutsUnavailable =>
      'Payout history could not be loaded. Earned commission from sales is still shown. Run Supabase migration agent_commission_payouts if payouts fail to save.';

  @override
  String get agentCommissionEyebrow => 'TEAM  ·  COMMISSIONS';

  @override
  String get agentCommissionTitle => 'Agent commissions';

  @override
  String get agentCommissionSubtitle =>
      'Track what each sales agent has earned, what you’ve paid, and what’s still owed.';

  @override
  String get agentCommissionSignOut => 'Sign out';

  @override
  String get agentCommissionAgent => 'Agent';

  @override
  String get agentCommissionEarnedEyebrow => 'COMMISSION EARNED';

  @override
  String agentCommissionPaidOutPct(String percent) {
    return 'Paid out · $percent %';
  }

  @override
  String agentCommissionBalanceDuePct(String percent) {
    return 'Balance due · $percent %';
  }

  @override
  String get agentCommissionPaidOutEyebrow => 'PAID OUT';

  @override
  String get agentCommissionBalanceDueEyebrow => 'BALANCE DUE';

  @override
  String get agentCommissionAllSettled => 'All settled';

  @override
  String get agentCommissionRecordPayout => 'Record payout';

  @override
  String get agentCommissionAttributedSales => 'ATTRIBUTED SALES';

  @override
  String agentCommissionPendingCount(int count) {
    return '$count pending';
  }

  @override
  String get agentCommissionExport => 'Export';

  @override
  String get agentCommissionColDate => 'DATE';

  @override
  String get agentCommissionColReceipt => 'RECEIPT';

  @override
  String get agentCommissionColCashier => 'CASHIER';

  @override
  String get agentCommissionColSaleTotal => 'SALE TOTAL';

  @override
  String get agentCommissionColRate => 'RATE';

  @override
  String get agentCommissionColCommission => 'COMMISSION';

  @override
  String get agentCommissionColStatus => 'STATUS';

  @override
  String get agentCommissionWalkIn => 'Walk-in';

  @override
  String get agentCommissionRecentPayouts => 'RECENT PAYOUTS';

  @override
  String get agentCommissionCashier => 'Cashier';

  @override
  String get agentCommissionPaid => 'Paid';

  @override
  String get agentCommissionPending => 'Pending';

  @override
  String get agentCommissionLast7Days => 'Last 7 days';

  @override
  String get agentCommissionAllTime => 'All time';

  @override
  String get agentCommissionToday => 'Today';

  @override
  String get agentCommissionThisWeek => 'This week';

  @override
  String get agentCommissionThisMonth => 'This month';

  @override
  String get agentCommissionLoadFailed => 'Could not load commission data.';

  @override
  String get agentCommissionAgentsLoadFailed => 'Could not load agents.';

  @override
  String get agentCommissionNoAgents =>
      'No agents found. Add agents in User Management first.';

  @override
  String get agentCommissionNoPermission =>
      'You do not have permission to manage payouts.';

  @override
  String agentCommissionBalanceDueAmount(String amount) {
    return 'Balance due: $amount';
  }

  @override
  String get agentCommissionAmountRwf => 'Amount (RWF)';

  @override
  String get agentCommissionEnterValidAmount => 'Enter a valid amount';

  @override
  String agentCommissionCannotExceedBalance(String amount) {
    return 'Cannot exceed balance ($amount)';
  }

  @override
  String get agentCommissionNoteOptional => 'Note (optional)';

  @override
  String agentCommissionPayoutRecorded(String amount) {
    return 'Payout of $amount recorded.';
  }

  @override
  String get agentCommissionPayoutFailed =>
      'Could not record payout. Check your connection.';

  @override
  String get agentCommissionCommissionAgent => 'Commission agent';

  @override
  String get agentCommissionByOwner => 'by Owner';

  @override
  String agentCommissionSaleAmount(String amount) {
    return 'Sale $amount';
  }

  @override
  String get agentCommissionNoSalesYet => 'No attributed sales yet';

  @override
  String agentCommissionNoSalesHint(String period) {
    return 'When cashiers assign an agent on a completed sale in Quick Selling, commission will appear here for $period.';
  }

  @override
  String get agentCommissionAmountMustBePositive =>
      'Payout amount must be greater than zero.';

  @override
  String get agentCommissionNoBusinessSelected => 'No business selected.';

  @override
  String get agentCommissionSignInToRecord => 'Sign in to record a payout.';

  @override
  String get agentCommissionStorageNotSetUp =>
      'Payout storage is not set up yet. Ask your admin to run the latest Supabase migration (agent_commission_payouts).';

  @override
  String get agentCommissionCouldNotRecord => 'Could not record payout.';

  @override
  String get kitchenStageIncoming => 'Incoming';

  @override
  String get kitchenStageInProgress => 'In Progress';

  @override
  String get kitchenStageReady => 'Ready';

  @override
  String get kitchenStageServed => 'Served';

  @override
  String get kitchenServedAlreadyPaid => 'Served. This order was already paid.';

  @override
  String get kitchenServedCashierHasTicket =>
      'Served. The cashier has this ticket open for payment.';

  @override
  String get kitchenServedInTickets =>
      'Served. It is in Tickets, ready for payment.';

  @override
  String get kitchenDisplayTitle => 'Kitchen Display';

  @override
  String kitchenErrorLoadingOrders(String error) {
    return 'Error loading orders: $error';
  }

  @override
  String kitchenFailedToUpdateOrder(String error) {
    return 'Failed to update order: $error';
  }

  @override
  String kitchenFailedToSetDueDate(String error) {
    return 'Failed to set due date: $error';
  }

  @override
  String get kitchenNoOrders => 'No orders';

  @override
  String kitchenOrderNumber(String number) {
    return 'Order #$number';
  }

  @override
  String get kitchenSetDueDate => 'Set Due Date';

  @override
  String get kitchenTicketNotFound =>
      'Ticket not found — it may have been deleted.';

  @override
  String kitchenTicketName(String name) {
    return 'Ticket: $name';
  }

  @override
  String kitchenCustomerLine(String name) {
    return 'Customer: $name';
  }

  @override
  String kitchenTotalLine(String amount) {
    return 'Total: $amount';
  }

  @override
  String get kitchenNoteLabel => 'Note:';

  @override
  String get kitchenNoItemsFound => 'No items found';

  @override
  String get kitchenItemsLabel => 'Items:';

  @override
  String kitchenErrorLoadingItems(String error) {
    return 'Error loading items: $error';
  }

  @override
  String kitchenMinutesCount(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String kitchenDueInMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Due in $minutes minutes',
      one: 'Due in 1 minute',
    );
    return '$_temp0';
  }

  @override
  String get kitchenSetAction => 'Set';

  @override
  String get ticketUnknown => 'Unknown';

  @override
  String get ticketOverdue => 'Overdue';

  @override
  String ticketMinutesLeft(String minutes) {
    return '$minutes min left';
  }

  @override
  String ticketDaysHoursLeft(String days, String hours) {
    return '${days}d ${hours}h left';
  }

  @override
  String ticketHoursMinutesLeft(String hours, String minutes) {
    return '${hours}h ${minutes}m left';
  }

  @override
  String get ticketWalkInCustomer => 'Walk-in Customer';

  @override
  String get ticketWalkIn => 'Walk-in';

  @override
  String get ticketStatusWaiting => 'Waiting';

  @override
  String get ticketStatusInProgress => 'In Progress';

  @override
  String get ticketStatusPaid => 'Paid';

  @override
  String get ticketStatusPendingReview => 'Pending Review';

  @override
  String get ticketStatusReviewed => 'Reviewed';

  @override
  String get ticketStatusPartial => 'Partial';

  @override
  String get ticketStatusAwaitingPayment => 'Awaiting payment';

  @override
  String get ticketMarkReviewedFailed => 'Failed to mark ticket as reviewed';

  @override
  String get ticketReviewedSuccess => 'Ticket reviewed';

  @override
  String get ticketReviewQueue => 'Review Queue';

  @override
  String get ticketReviewQueueLoadFailed => 'Could not load the review queue';

  @override
  String get ticketReviewQueueEmpty => 'Nothing waiting for review';

  @override
  String get ticketReviewDetails => 'Review details';

  @override
  String ticketsWaitingToReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tickets waiting to review',
      one: '1 ticket waiting to review',
    );
    return '$_temp0';
  }

  @override
  String ticketMoreCount(String count) {
    return '+ $count more';
  }

  @override
  String get ticketOpenReviewQueue => 'Open review queue →';

  @override
  String ticketNumberRef(String reference) {
    return 'Ticket #$reference';
  }

  @override
  String get ticketGeneric => 'Ticket';

  @override
  String get ticketJustNow => 'just now';

  @override
  String ticketMinutesAgo(String count) {
    return '${count}m ago';
  }

  @override
  String ticketHoursAgo(String count) {
    return '${count}h ago';
  }

  @override
  String ticketDaysAgo(String count) {
    return '${count}d ago';
  }

  @override
  String ticketItemsSectionCount(String count) {
    return 'Items · $count';
  }

  @override
  String get ticketNote => 'Note';

  @override
  String ticketCouldNotLoadItems(String error) {
    return 'Could not load items: $error';
  }

  @override
  String get ticketMarking => 'Marking…';

  @override
  String get ticketMarkAsReviewed => 'Mark as reviewed';

  @override
  String get ticketReviewTicketTitle => 'Review ticket';

  @override
  String get ticketNoItemsOnTicket => 'No items on this ticket.';

  @override
  String ticketIdShort(String id) {
    return '(ID: $id)';
  }

  @override
  String get ticketNotAvailable => 'N/A';

  @override
  String ticketSubtotalValue(String amount) {
    return 'Subtotal: $amount';
  }

  @override
  String ticketDueOn(String date) {
    return 'Due: $date';
  }

  @override
  String get ticketDeleteTitle => 'Delete Ticket';

  @override
  String get ticketDeleteConfirm =>
      'Are you sure you want to delete this ticket? This action cannot be undone.';

  @override
  String get ticketLoan => 'Loan';

  @override
  String get ticketLayaway => 'Layaway';

  @override
  String get ticketRegular => 'Regular';

  @override
  String get ticketFilterAll => 'All tickets';

  @override
  String get ticketsCannotDeleteReviewed =>
      'Selected tickets have been reviewed and cannot be deleted';

  @override
  String get ticketsCannotDeleteSelected =>
      'Selected tickets cannot be deleted (partial payments or reviewed)';

  @override
  String ticketsDeletedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tickets deleted successfully',
      one: '1 ticket deleted successfully',
    );
    return '$_temp0';
  }

  @override
  String get ticketsDeleteSelectedFailed => 'Failed to delete selected tickets';

  @override
  String get ticketAddItemsFirst =>
      'Please add items to the transaction before creating a ticket';

  @override
  String get ticketCreate => 'Create Ticket';

  @override
  String get ticketsPendingTitle => 'Pending Tickets';

  @override
  String get ticketsMyTitle => 'My Tickets';

  @override
  String get ticketsPendingSubtitle =>
      'Orders waiting to be collected at the till';

  @override
  String get ticketsMySubtitle =>
      'Orders you\'ve sent, and their payment status';

  @override
  String ticketsDeleteSelectedCount(String count) {
    return 'Delete Selected ($count)';
  }

  @override
  String get ticketsSelectAll => 'Select All';

  @override
  String get ticketSendViaWhatsApp => 'Send via WhatsApp';

  @override
  String ticketRefWithCustomer(String reference, String customer) {
    return 'Ticket #$reference · $customer';
  }

  @override
  String get ticketHandoverStaffHeader => 'Stock handover staff';

  @override
  String get ticketHandoverStaffLoadFailed => 'Could not load handover staff.';

  @override
  String get ticketHandoverStaffEmpty =>
      'No staff with Stock Handover access and a phone number on file. Add a phone on their tenant profile and grant Stock Handover access.';

  @override
  String get ticketOrderFormShop => 'Shop';

  @override
  String get ticketOrderReceipt => 'Order receipt';

  @override
  String get ticketCreated => 'Created';

  @override
  String get ticketDeliveryTime => 'Delivery time';

  @override
  String get ticketTotal => 'Total';

  @override
  String get ticketBalance => 'Balance';

  @override
  String get ticketRemaining => 'Remaining';

  @override
  String get ticketReviewedBy => 'Reviewed by';

  @override
  String get ticketReviewedAt => 'Reviewed at';

  @override
  String get ticketThankYouForOrder => 'Thank you for your order';

  @override
  String ticketsSkippedCannotDelete(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Skipped $count tickets that cannot be deleted (partial payments or reviewed)',
      one:
          'Skipped 1 ticket that cannot be deleted (partial payments or reviewed)',
    );
    return '$_temp0';
  }

  @override
  String get ticketSearchHint => 'Search by customer, phone, ticket ID...';

  @override
  String get ticketsLoading => 'Loading tickets...';

  @override
  String get ticketsNoneInCategory => 'No tickets in this category';

  @override
  String get ticketsTryAnotherFilter => 'Try another filter';

  @override
  String get ticketSortNewest => 'Newest first';

  @override
  String get ticketSortOldest => 'Oldest first';

  @override
  String get ticketsLoanSection => 'Loan tickets';

  @override
  String get ticketsLayawaySection => 'Layaway tickets';

  @override
  String get ticketsRegularSection => 'Regular tickets';

  @override
  String get ticketOrderResumed => 'Order resumed successfully';

  @override
  String get ticketStaffFallback => 'Staff';

  @override
  String get ticketReturnToTillFailed =>
      'Could not return the current ticket to the till. Try again.';

  @override
  String get ticketActionFailed => 'Action Failed';

  @override
  String get ticketSentToKitchen => 'Sent to kitchen';

  @override
  String get ticketSendToKitchenFailed =>
      'Could not send to kitchen. Try again.';

  @override
  String get ticketSendToKitchen => 'Send to kitchen';

  @override
  String get ticketSendAgain => 'Send again';

  @override
  String get ticketServedReadyForPayment => 'Served · ready for payment';

  @override
  String ticketInKitchenStage(String stage) {
    return 'In kitchen · $stage';
  }

  @override
  String get ticketPrintOrderFormFailed => 'Failed to print order form';

  @override
  String ticketOrderFormCaption(String reference, String customer) {
    return 'Order form · Ticket #$reference · $customer';
  }

  @override
  String ticketOrderFormSentWhatsApp(String name) {
    return 'Order form sent to $name on WhatsApp';
  }

  @override
  String get ticketOrderFormWhatsAppFailed =>
      'Failed to send order form on WhatsApp';

  @override
  String get ticketHandoverRecordedReceipt =>
      'Handover recorded — receipt issued';

  @override
  String get ticketHandoverRecorded => 'Handover recorded';

  @override
  String get ticketHandoverFinalizeFailed =>
      'Failed to finalize handover — the receipt was not issued. Please try again.';

  @override
  String get ticketHasPartialPayments =>
      'This ticket has partial payments and cannot be deleted.';

  @override
  String get ticketDeleted => 'Ticket deleted';

  @override
  String get ticketDeleteFailed => 'Failed to delete ticket';

  @override
  String get ticketDeleteFailedShort => 'Delete failed';

  @override
  String get ticketsNoOpen => 'No open tickets';

  @override
  String get ticketsCreateToStart => 'Create a new ticket to get started';

  @override
  String get ticketsNoSearchMatch => 'No tickets match your search';

  @override
  String get ticketsTryDifferentSearch => 'Try a different search term';

  @override
  String get ticketSomethingWentWrong => 'Something went wrong';

  @override
  String get ticketTryAgain => 'Try Again';

  @override
  String get ticketCompleteHandoverTitle => 'Complete handover?';

  @override
  String get ticketHandoverIssueReceiptBody =>
      'Issue the receipt and mark this ticket as completed.';

  @override
  String get ticketHandoverConfirmLeftStock =>
      'Confirm the item has physically left stock.';

  @override
  String get ticketHandoverStockDeductedInfo =>
      'Stock will be deducted and the fiscal receipt will be issued now.';

  @override
  String get ticketHandoverRecordsInfo =>
      'This records that the goods were handed to the customer.';

  @override
  String get ticketDeleteQuestion => 'Delete ticket?';

  @override
  String get ticketDeleteRemovesHistory =>
      'This removes the parked sale and its local ticket history.';

  @override
  String get ticketActionCannotBeUndone => 'This action cannot be undone.';

  @override
  String ticketCreatedOn(String date) {
    return 'Created $date';
  }

  @override
  String get ticketRecordHandover => 'Record handover';

  @override
  String get ticketCollecting => 'Collecting…';

  @override
  String get ticketCollect => 'Collect →';

  @override
  String get ticketCompleting => 'Completing…';

  @override
  String get ticketComplete => 'Complete →';

  @override
  String get ticketResumeOrder => 'Resume Order';

  @override
  String get ticketPrint => 'Print';

  @override
  String get ticketSent => 'Sent';

  @override
  String get ticketWhatsAppNotConfigured =>
      'WhatsApp sending is not set up: the data connector URL (Ebm.dataConnectorUrl) is missing.';

  @override
  String configCurrencyName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'RWF': 'Rwandan Franc',
      'KES': 'Kenyan Shilling',
      'UGX': 'Ugandan Shilling',
      'TZS': 'Tanzanian Shilling',
      'ETB': 'Ethiopian Birr',
      'NGN': 'Nigerian Naira',
      'ZAR': 'South African Rand',
      'GHS': 'Ghanaian Cedi',
      'MAD': 'Moroccan Dirham',
      'EGP': 'Egyptian Pound',
      'DZD': 'Algerian Dinar',
      'XOF': 'CFA Franc BCEAO',
      'XAF': 'CFA Franc BEAC',
      'MUR': 'Mauritian Rupee',
      'BWP': 'Botswanan Pula',
      'NAD': 'Namibian Dollar',
      'USD': 'US Dollar',
      'EUR': 'Euro',
      'GBP': 'British Pound',
      'JPY': 'Japanese Yen',
      'CNY': 'Chinese Yuan',
      'CAD': 'Canadian Dollar',
      'AUD': 'Australian Dollar',
      'CHF': 'Swiss Franc',
      'NZD': 'New Zealand Dollar',
      'HKD': 'Hong Kong Dollar',
      'SEK': 'Swedish Krona',
      'NOK': 'Norwegian Krone',
      'DKK': 'Danish Krone',
      'AED': 'UAE Dirham',
      'SAR': 'Saudi Riyal',
      'QAR': 'Qatari Riyal',
      'KWD': 'Kuwaiti Dinar',
      'BHD': 'Bahraini Dinar',
      'OMR': 'Omani Rial',
      'ILS': 'Israeli Shekel',
      'JOD': 'Jordanian Dinar',
      'INR': 'Indian Rupee',
      'PKR': 'Pakistani Rupee',
      'BDT': 'Bangladeshi Taka',
      'SGD': 'Singapore Dollar',
      'MYR': 'Malaysian Ringgit',
      'IDR': 'Indonesian Rupiah',
      'PHP': 'Philippine Peso',
      'THB': 'Thai Baht',
      'VND': 'Vietnamese Dong',
      'KRW': 'South Korean Won',
      'TWD': 'New Taiwan Dollar',
      'LKR': 'Sri Lankan Rupee',
      'NPR': 'Nepalese Rupee',
      'BRL': 'Brazilian Real',
      'MXN': 'Mexican Peso',
      'ARS': 'Argentine Peso',
      'COP': 'Colombian Peso',
      'CLP': 'Chilean Peso',
      'PEN': 'Peruvian Sol',
      'UYU': 'Uruguayan Peso',
      'BOB': 'Bolivian Boliviano',
      'VES': 'Venezuelan Bolívar',
      'RUB': 'Russian Ruble',
      'PLN': 'Polish Złoty',
      'CZK': 'Czech Koruna',
      'HUF': 'Hungarian Forint',
      'RON': 'Romanian Leu',
      'BGN': 'Bulgarian Lev',
      'TRY': 'Turkish Lira',
      'UAH': 'Ukrainian Hryvnia',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get configNeedHelp => 'Need Help?';

  @override
  String get configContactSupportToAddEbm =>
      'Contact support to add EBM to Flipper';

  @override
  String get configContactSupport => 'Contact Support';

  @override
  String get configEnterValidUrl => 'Please enter a valid URL';

  @override
  String get configEnterUrlWithScheme =>
      'Please enter a valid URL with a scheme (e.g., http:// or https://)';

  @override
  String get configBranchIdRequired => 'Branch ID is required';

  @override
  String get configMrcRequired => 'MRC is required';

  @override
  String get configMrcLength => 'MRC must be exactly 11 characters';

  @override
  String get configNoChangesToSave => 'No changes to save';

  @override
  String get configSaveFailed =>
      'Could not save tax configuration. Check your connection and try again.';

  @override
  String get configTaxConfigSaved => 'Tax configuration saved';

  @override
  String get configGeneral => 'General';

  @override
  String get configTaxConfiguration => 'Tax Configuration';

  @override
  String get configSaveAppliesTo =>
      'Save applies to EBM / tax URL, data connector URL, branch code, and MRC.';

  @override
  String get configTaxServerUrl => 'EBM / Tax server URL';

  @override
  String get configDataConnectorUrl => 'Data connector URL';

  @override
  String get configDataConnectorHelper =>
      'Bulk product RRA uses this service; RRA tax URL is configured on data-connector.';

  @override
  String get configBranchCodeBhfId => 'Branch code (bhfId)';

  @override
  String get configBranchCode => 'Branch Code';

  @override
  String get configEnterEbmUrl => 'Enter EBM URL';

  @override
  String get configSystemConfiguration => 'System Configuration';

  @override
  String get configSystemConfigSubtitle =>
      'Manage POS behaviour, currency and tax integration.';

  @override
  String get configTrainingMode => 'Training Mode';

  @override
  String get configProformaMode => 'Proforma Mode';

  @override
  String get configPrintA4 => 'Print A4';

  @override
  String get configExportAsPdf => 'Export as PDF';

  @override
  String get configSystemCurrency => 'System Currency';

  @override
  String get configVatEnabled => 'VAT Enabled';

  @override
  String get configVatControlledByEbm => 'Controlled by EBM configuration';

  @override
  String get configVatStatusControlledByEbm =>
      'VAT status is controlled by EBM configuration';

  @override
  String get configLoading => 'Loading...';

  @override
  String get configErrorLoadingVat => 'Error loading VAT status';

  @override
  String configErrorWithDetails(String error) {
    return 'Error: $error';
  }

  @override
  String get configTourismTaxRegistered => 'Tourism tax registered';

  @override
  String get configTourismTaxHint =>
      'Enable only if RRA registered this branch for tourism tax. Rooms register as plain services otherwise.';

  @override
  String get configVersionNotAvailable => 'Version not available';

  @override
  String configVersion(String version) {
    return 'Version $version';
  }

  @override
  String get configSaving => 'Saving…';

  @override
  String get configSaved => 'Saved';

  @override
  String get configSaveConfiguration => 'Save configuration';

  @override
  String get leadsFilterAll => 'All';

  @override
  String get leadsStatusNew => 'New';

  @override
  String get leadsStatusContacted => 'Contacted';

  @override
  String get leadsStatusQuoted => 'Quoted';

  @override
  String get leadsStatusConverted => 'Converted';

  @override
  String get leadsStatusLost => 'Lost';

  @override
  String get leadsHeatHot => 'Hot';

  @override
  String get leadsHeatWarm => 'Warm';

  @override
  String get leadsHeatCold => 'Cold';

  @override
  String get leadsHotLead => 'Hot lead';

  @override
  String get leadsWarmLead => 'Warm lead';

  @override
  String get leadsColdLead => 'Cold lead';

  @override
  String get leadsSourceWalkIn => 'Walk-in';

  @override
  String get leadsSubtitle => 'Track customers, enquiries and pipeline value';

  @override
  String leadsEmailsNeedReview(String count) {
    return '$count emails need review';
  }

  @override
  String get leadsFilter => 'Filter';

  @override
  String get leadsAddLead => 'Add lead';

  @override
  String get leadsStatTotalLeads => 'Total leads';

  @override
  String get leadsStatAllSources => 'All sources';

  @override
  String get leadsStatPipelineValue => 'Pipeline value';

  @override
  String get leadsStatActiveLeads => 'Active leads';

  @override
  String get leadsStatCompletedSales => 'Completed sales';

  @override
  String get leadsStatFromGmail => 'From Gmail';

  @override
  String get leadsStatEmailEnquiries => 'Email enquiries';

  @override
  String get leadsStatConversionRate => 'Conversion rate';

  @override
  String get leadsStatThisMonth => 'This month';

  @override
  String get leadsAllLeads => 'All Leads';

  @override
  String get leadsUnableToLoad => 'Unable to load leads.';

  @override
  String get leadsSearchHint => 'Search name, email, product…';

  @override
  String get leadsNoLeadsYet => 'No leads yet.';

  @override
  String get leadsColSource => 'Source';

  @override
  String get leadsColInterestedIn => 'Interested in';

  @override
  String get leadsColValue => 'Value';

  @override
  String get leadsColStage => 'Stage';

  @override
  String get leadsColHeat => 'Heat';

  @override
  String get leadsColDate => 'Date';

  @override
  String get leadsPipeline => 'Pipeline';

  @override
  String get leadsPerformance => 'Performance';

  @override
  String get leadsConversionRateThisMonth => 'Conversion rate this month';

  @override
  String get leadsAvgTimeToConvert => 'Avg. time to convert';

  @override
  String leadsDaysCount(String days) {
    return '$days days';
  }

  @override
  String get leadsEmailReviewComingSoon => 'Email lead review is coming soon.';

  @override
  String get leadsGmailAiFlagged =>
      'Gmail - AI flagged these as potential leads.';

  @override
  String leadsPendingCount(String count) {
    return '$count pending';
  }

  @override
  String get leadsGmailIngestionLater =>
      'Gmail ingestion will be enabled later. For now, add leads manually.';

  @override
  String get leadsFilterLeads => 'Filter leads';

  @override
  String get leadsContactDetails => 'Contact details';

  @override
  String get leadsEstValue => 'Est. value';

  @override
  String get leadsNotes => 'Notes';

  @override
  String get leadsAiExtractedItems => 'AI extracted items of interest';

  @override
  String leadsMatchPercent(String percent) {
    return '$percent% match';
  }

  @override
  String get leadsActivityTimeline => 'Activity timeline';

  @override
  String get leadsCreatedFromGmail => 'Lead created — from Gmail email';

  @override
  String get leadsCreatedManual => 'Lead created — manual entry';

  @override
  String get leadsTimelineAuto => 'Auto';

  @override
  String get leadsTimelinePending => 'Pending';

  @override
  String leadsAiExtractedProducts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
    );
    return 'AI extracted $_temp0 of interest';
  }

  @override
  String get leadsProformaDraftReady => 'Proforma draft ready for review';

  @override
  String get leadsReviewProforma => 'Review proforma';

  @override
  String get leadsConverting => 'Converting…';

  @override
  String get leadsConvertToSale => 'Convert to sale';

  @override
  String leadsConvertFailed(String error) {
    return 'Failed to convert lead. $error';
  }

  @override
  String get leadsFullNameRequired => 'Full name *';

  @override
  String get leadsFullNameHint => 'Full name';

  @override
  String get leadsEmailAddress => 'Email address';

  @override
  String get leadsNotesOptional => 'Notes (optional)';

  @override
  String get leadsNotesHint => 'What did they ask for?';

  @override
  String get leadsSaveLead => 'Save lead';

  @override
  String get leadsProductsInterestedRequired => 'Products interested in *';

  @override
  String get leadsBrowseCatalogue => 'Browse catalogue';

  @override
  String get leadsTypeProductHint => 'Or type product name, SKU, BCD…';

  @override
  String get leadsAddLeadSubtitle =>
      'Record a new customer or enquiry manually';

  @override
  String get leadsWalkInCustomer => 'Walk-in customer';

  @override
  String get leadsPhoneReferral => 'Phone / Referral';

  @override
  String get leadsEstimatedValue => 'Estimated value';

  @override
  String get leadsLeadHeat => 'Lead heat';

  @override
  String leadsSaveFailed(String error) {
    return 'Failed to save lead. $error';
  }

  @override
  String get leadsPickFromCatalogue => 'Pick from catalogue';

  @override
  String get leadsSearchCatalogHint => 'Search name, SKU, BCD…';

  @override
  String get leadsNoItemsFound => 'No items found';

  @override
  String get leadsProformaNewItem => 'New item';

  @override
  String get leadsProforma => 'Proforma';

  @override
  String get leadsProformaInvoice => 'Proforma Invoice';

  @override
  String leadsProformaSubtitle(String name) {
    return 'Lead: $name · AI draft — review before sending';
  }

  @override
  String get leadsSend => 'Send';

  @override
  String get leadsSending => 'Sending…';

  @override
  String get leadsDownloadPdf => 'Download PDF';

  @override
  String get leadsProformaAiBannerNarrow =>
      'AI drafted from email. Tap any price or quantity to edit. Review all lines before sending.';

  @override
  String get leadsProformaAiBanner =>
      'AI drafted this proforma from the customer’s email';

  @override
  String get leadsAllFieldsEditable => 'All fields editable';

  @override
  String get leadsDraft => 'Draft';

  @override
  String get leadsDraftNotSent => 'Draft — not sent';

  @override
  String get leadsBillTo => 'Bill to';

  @override
  String get leadsIssueDate => 'Issue date';

  @override
  String get leadsValidUntil => 'Valid until';

  @override
  String get leadsLeadSource => 'Lead source';

  @override
  String get leadsGmailEnquiry => 'Gmail enquiry';

  @override
  String get leadsManualEntry => 'Manual entry';

  @override
  String get leadsAiMatchedItems => 'AI matched items to catalogue';

  @override
  String get leadsColItem => 'Item';

  @override
  String get leadsColPrice => 'Price';

  @override
  String get leadsColTotal => 'Total';

  @override
  String get leadsColDescription => 'Description';

  @override
  String get leadsColUnitPrice => 'Unit price';

  @override
  String get leadsColQty => 'Qty';

  @override
  String get leadsAddProductHint => 'Add product...';

  @override
  String get leadsAddShort => '+ Add';

  @override
  String get leadsSearchProductToAddLine => '+ Search product to add a line…';

  @override
  String get leadsAddLine => 'Add line';

  @override
  String get leadsVat18 => 'VAT 18%';

  @override
  String get leadsGrandTotal => 'Grand Total';

  @override
  String get leadsTermsShort => 'Valid 7 days. Payment due on delivery.';

  @override
  String get leadsTermsLong =>
      'This proforma is valid for 7 days. Payment due upon delivery. Bank transfer or mobile money accepted.';

  @override
  String get leadsNotesTerms => 'Notes / Terms';

  @override
  String get leadsSummary => 'Summary';

  @override
  String get leadsLines => 'Lines';

  @override
  String leadsLinesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lines',
      one: '1 line',
    );
    return '$_temp0';
  }

  @override
  String get leadsStatus => 'Status';

  @override
  String get leadsHistory => 'History';

  @override
  String get leadsHistoryAiDrafted => 'AI drafted from Gmail email';

  @override
  String get leadsHistoryLeadCreated => 'Lead created, proforma generated';

  @override
  String get leadsHistoryAwaitingReview => 'Awaiting user review';

  @override
  String get leadsToday => 'Today';

  @override
  String get leadsNow => 'Now';

  @override
  String get leadsNoContactProvided => 'No contact provided';

  @override
  String get leadsPdfSaved => 'Proforma PDF saved.';

  @override
  String leadsPdfExportFailed(String error) {
    return 'Failed to export PDF: $error';
  }

  @override
  String get leadsPdfReadyToShare => 'Proforma PDF ready to share.';

  @override
  String leadsSendPrepareFailed(String error) {
    return 'Failed to prepare send: $error';
  }

  @override
  String get leadsConvertedToSale => 'Lead converted to sale.';

  @override
  String leadsConvertFailedShort(String error) {
    return 'Failed to convert: $error';
  }

  @override
  String get gigsNegotiable => 'Negotiable';

  @override
  String gigsDurationHoursMinutes(String hours, String minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String gigsDurationMinutes(String minutes) {
    return '${minutes}m';
  }

  @override
  String get gigsStatusAwaitingProviderResponse => 'Awaiting provider response';

  @override
  String get gigsStatusAcceptWindowExpired => 'Accept window expired';

  @override
  String get gigsStatusAwaitingPayment => 'Awaiting payment';

  @override
  String get gigsStatusPaymentWindowExpired => 'Payment window expired';

  @override
  String get gigsStatusPaidReadyToStart => 'Paid - Ready to start';

  @override
  String get gigsStatusRequested => 'Requested';

  @override
  String get gigsStatusPendingPayment => 'Pending payment';

  @override
  String get gigsStatusPaid => 'Paid';

  @override
  String get gigsStatusInProgress => 'In progress';

  @override
  String get gigsStatusCompleted => 'Completed';

  @override
  String get gigsStatusDeclined => 'Declined';

  @override
  String get gigsStatusDeclinedByProvider => 'Declined by provider';

  @override
  String get gigsStatusExpired => 'Expired';

  @override
  String get gigsStatusCancelled => 'Cancelled';

  @override
  String get gigsStatusAccepted => 'Accepted';

  @override
  String get gigsCategoryHomeServices => 'Home Services';

  @override
  String get gigsCategoryBeautyWellness => 'Beauty & Wellness';

  @override
  String get gigsCategoryDeliveryTransport => 'Delivery & Transport';

  @override
  String get gigsCategoryTechSupport => 'Tech Support';

  @override
  String get gigsCategoryEvents => 'Events';

  @override
  String get gigsCategoryLessons => 'Lessons & Training';

  @override
  String get gigsCategoryHealthcare => 'Healthcare';

  @override
  String get gigsCategoryOther => 'Other';

  @override
  String get gigsErrSignInToRequest => 'Sign in to request a service.';

  @override
  String get gigsErrRequestSelf =>
      'You cannot request a service from yourself.';

  @override
  String get gigsErrMinAmount => 'Enter an amount of at least 100 RWF.';

  @override
  String get gigsErrSendRequest => 'Could not send your request.';

  @override
  String get gigsErrSendRequestConnection =>
      'Could not send your request. Check your connection and try again.';

  @override
  String get gigsErrSignInToPay => 'Sign in to complete payment.';

  @override
  String get gigsErrValidAmount => 'Enter a valid amount.';

  @override
  String get gigsErrRequestNotFound => 'Request not found.';

  @override
  String get gigsErrNotAwaitingPayment =>
      'This request is not waiting for payment.';

  @override
  String get gigsErrPaymentWindowEnded =>
      'The payment window has ended. Contact the provider to send a new request.';

  @override
  String get gigsErrConfirmPayment =>
      'Could not confirm payment. It may have already been recorded.';

  @override
  String get gigsErrSavePayment => 'Could not save payment.';

  @override
  String get gigsErrSavePaymentConnection =>
      'Could not save payment. Check your connection.';

  @override
  String get gigsErrSignInToRespond => 'Sign in to respond to requests.';

  @override
  String get gigsErrCannotAccept =>
      'This request can no longer be accepted. It may have expired or already been handled.';

  @override
  String get gigsErrAccept => 'Could not accept the request.';

  @override
  String get gigsErrAcceptConnection =>
      'Could not accept the request. Check your connection and try again.';

  @override
  String get gigsErrSignInToDispatch => 'Sign in to dispatch payouts.';

  @override
  String get gigsErrPayoutReference => 'Enter a payout reference.';

  @override
  String get gigsErrUpdatePayout => 'Could not update payout status.';

  @override
  String get gigsErrSignInToMessage => 'Sign in to send a message.';

  @override
  String get gigsErrEmptyMessage => 'Message cannot be empty.';

  @override
  String get gigsErrRequestClosed => 'This request is closed.';

  @override
  String get gigsErrSendMessage => 'Could not send message.';

  @override
  String get gigsErrSignInToUpdate => 'Sign in to update this request.';

  @override
  String get gigsErrOnlyPaidToStart =>
      'Only paid requests that have not started can be moved to in progress.';

  @override
  String get gigsErrUpdateStatus => 'Could not update status.';

  @override
  String get gigsErrMarkComplete =>
      'Could not mark complete. It may already be finished.';

  @override
  String get gigsErrSignInToReview => 'Sign in to leave a review.';

  @override
  String get gigsErrPickRating => 'Pick a rating from 1 to 5.';

  @override
  String get gigsErrShortComment => 'Please add a short comment.';

  @override
  String get gigsErrOnlyCompletedReview =>
      'Only completed jobs can be reviewed.';

  @override
  String get gigsErrAlreadyReviewed => 'You already left a review.';

  @override
  String get gigsErrSaveReviewRetry => 'Could not save review. Try again.';

  @override
  String get gigsErrSaveReview => 'Could not save review.';

  @override
  String get gigsAdminMetricsTitle => 'Services hub metrics';

  @override
  String get gigsPayouts => 'Payouts';

  @override
  String get gigsPendingDispatch => 'Pending dispatch';

  @override
  String get gigsDispatched => 'Dispatched';

  @override
  String get gigsPendingTotalRwf => 'Pending total (RWF)';

  @override
  String get gigsRequestsByStatus => 'Requests by status';

  @override
  String get gigsMetrics => 'Metrics';

  @override
  String get gigsProvider => 'Provider';

  @override
  String gigsProviderShortId(String suffix) {
    return 'Provider · …$suffix';
  }

  @override
  String gigsCustomerShortId(String suffix) {
    return 'Customer · …$suffix';
  }

  @override
  String get gigsPayoutReference => 'Payout reference';

  @override
  String get gigsPayoutReferenceHint => 'MTN / ledger reference';

  @override
  String get gigsMarkDispatched => 'Mark dispatched';

  @override
  String get gigsMarkedDispatched => 'Marked dispatched.';

  @override
  String get gigsDispatchPayouts => 'Dispatch payouts';

  @override
  String get gigsNoPayoutsPending => 'No payouts pending';

  @override
  String get gigsNoPayoutsPendingHint =>
      'When jobs are funded, they will appear here until dispatched.';

  @override
  String gigsPayoutAmountLine(String amount, String status, String date) {
    return 'Amount: $amount RWF · $status\nSent $date';
  }

  @override
  String get gigsWaitingForProvider => 'Waiting for provider';

  @override
  String get gigsPayNow => 'Pay now';

  @override
  String get gigsPaymentWindowEnded => 'Payment window ended';

  @override
  String get gigsPaymentRecordedCanStart =>
      'Payment recorded. The provider can start the job.';

  @override
  String get gigsMyRequests => 'My requests';

  @override
  String get gigsNoRequestsYet => 'No requests yet';

  @override
  String get gigsMyRequestsEmptyHint =>
      'When you ask someone for a service from Find providers, it will appear here. After they accept, you can pay with MTN within the time shown.';

  @override
  String get gigsAgreedAmount => 'Agreed amount';

  @override
  String get gigsSent => 'Sent';

  @override
  String gigsPayBy(String date) {
    return 'Pay by $date';
  }

  @override
  String gigsDidNotPayBefore(String date) {
    return 'You did not pay before $date';
  }

  @override
  String gigsPaidAmountSettled(String amount, String settled) {
    return 'Paid $amount RWF · MTN settled $settled RWF';
  }

  @override
  String gigsPaidAmount(String amount) {
    return 'Paid $amount RWF';
  }

  @override
  String get gigsPayWithMtn => 'Pay with MTN';

  @override
  String gigsRequestFrom(String name) {
    return 'Request from $name';
  }

  @override
  String gigsRequestTo(String name) {
    return 'Request to $name';
  }

  @override
  String get gigsNotifications => 'Notifications';

  @override
  String get gigsNoActivityYet => 'No activity yet';

  @override
  String get gigsActivityEmptyHint =>
      'When you send or receive service requests, updates appear here. Pull down to refresh.';

  @override
  String gigsUpdatedAt(String date) {
    return 'Updated $date';
  }

  @override
  String get gigsPaymentRecorded => 'Payment recorded.';

  @override
  String get gigsMarkedInProgress => 'Marked as in progress.';

  @override
  String get gigsJobMarkedComplete =>
      'Job marked complete. Customer can review.';

  @override
  String get gigsRateYourExperience => 'Rate your experience';

  @override
  String get gigsComment => 'Comment';

  @override
  String get gigsThanksForReview => 'Thanks for your review.';

  @override
  String get gigsRequestDetails => 'Request details';

  @override
  String get gigsMessages => 'Messages';

  @override
  String get gigsNoMessagesYet =>
      'No messages yet. Coordinate time and location here.';

  @override
  String get gigsTypeMessageHint => 'Type a message…';

  @override
  String get gigsStartJob => 'Start job';

  @override
  String get gigsMarkJobComplete => 'Mark job complete';

  @override
  String get gigsLeaveReview => 'Leave a review';

  @override
  String get gigsYourReview => 'Your review';

  @override
  String get gigsAdvancedFilters => 'Advanced filters';

  @override
  String gigsMinRating(String rating) {
    return 'Minimum average rating: $rating';
  }

  @override
  String get gigsVerifiedOnly => 'Verified providers only';

  @override
  String get gigsAvailableForBooking => 'Available for booking';

  @override
  String get gigsMaxBasePrice => 'Max base price (RWF), optional';

  @override
  String get gigsCategory => 'Category';

  @override
  String get gigsAllCategories => 'All categories';

  @override
  String get gigsApplyFilters => 'Apply filters';

  @override
  String get gigsFindProvider => 'Find a provider';

  @override
  String get gigsNoProvidersYet => 'No providers yet';

  @override
  String get gigsNoProvidersHint =>
      'When people offer their services here, you will see them in this list and can send a request.\n\nPull down to refresh. If you are registered as a provider yourself, your profile is not shown in this list.';

  @override
  String get gigsSearchHint => 'Search name, area, or service…';

  @override
  String get gigsBrowseByService => 'Browse by service';

  @override
  String get gigsAll => 'All';

  @override
  String get gigsNoMatches => 'No matches';

  @override
  String get gigsNoMatchesHint =>
      'Try different keywords, pick another service, or clear your filters.';

  @override
  String get gigsClearSearchFilters => 'Clear search & filters';

  @override
  String get gigsErrUpdateAvailability =>
      'Could not update availability on the server.';

  @override
  String get gigsVisibleToCustomers => 'You are visible to customers.';

  @override
  String get gigsMarkedUnavailable => 'You are marked unavailable.';

  @override
  String get gigsProviderDashboard => 'Provider dashboard';

  @override
  String get gigsAcceptNewRequests => 'Accept new requests';

  @override
  String get gigsAcceptNewRequestsHint =>
      'When off, customers can still open your profile but booking is disabled.';

  @override
  String get gigsRecordedPayments => 'Recorded payments (RWF)';

  @override
  String gigsFundedJobs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count funded jobs in hub data',
      one: '1 funded job in hub data',
    );
    return '$_temp0';
  }

  @override
  String get gigsOpenRequests => 'Open requests';

  @override
  String get gigsAwaitingResponseOrPayment => 'Awaiting response or payment';

  @override
  String get gigsActiveJobs => 'Active jobs';

  @override
  String get gigsPaidOrInProgress => 'Paid or in progress';

  @override
  String get gigsPayoutsHandledNote =>
      'Payouts and platform fees are handled by your existing MTN and ledger flows.';

  @override
  String get gigsRequestSentTrack =>
      'Request sent. Track it under My requests.';

  @override
  String get gigsPricing => 'Pricing';

  @override
  String gigsFromPrice(String price) {
    return 'From $price';
  }

  @override
  String get gigsAvailability => 'Availability';

  @override
  String get gigsPortfolio => 'Portfolio';

  @override
  String get gigsReviews => 'Reviews';

  @override
  String get gigsRequestThisProvider => 'Request this provider';

  @override
  String get gigsUnavailableNow => 'Unavailable right now';

  @override
  String get gigsVerified => 'Verified';

  @override
  String get gigsBackgroundChecked => 'Background checked';

  @override
  String get gigsStandardProfile => 'Standard provider profile';

  @override
  String gigsReviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
    );
    return '$_temp0';
  }

  @override
  String gigsJobsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jobs',
      one: '1 job',
    );
    return '$_temp0';
  }

  @override
  String get gigsAcceptedCustomerCanPay =>
      'Accepted. The customer can pay under Services hub → My requests (5 min).';

  @override
  String get gigsErrAcceptRetry => 'Could not accept. Try again.';

  @override
  String get gigsDeclineRequestTitle => 'Decline request?';

  @override
  String get gigsDeclineRequestBody =>
      'The customer will see that you declined this request.';

  @override
  String get gigsDecline => 'Decline';

  @override
  String get gigsAccept => 'Accept';

  @override
  String get gigsRequestDeclined => 'Request declined.';

  @override
  String get gigsErrDeclineRetry => 'Could not decline. Try again.';

  @override
  String get gigsAwaitingYourResponse => 'Awaiting your response';

  @override
  String get gigsWaitingForCustomerPayment => 'Waiting for customer payment';

  @override
  String get gigsIncomingRequests => 'Incoming requests';

  @override
  String get gigsInboxEmptyHint =>
      'When someone asks you for a service through Services hub, their request will show up here. You will have a limited time to accept or decline.';

  @override
  String get gigsAcceptDeadlinePassed => 'Accept deadline passed';

  @override
  String gigsCustomerBudget(String amount) {
    return 'Customer budget: $amount RWF';
  }

  @override
  String gigsReceivedAt(String date) {
    return 'Received $date';
  }

  @override
  String gigsRespondBy(String date) {
    return 'Respond by $date';
  }

  @override
  String gigsPaymentDueBy(String date) {
    return 'Payment due by $date';
  }

  @override
  String get gigsErrSignInToRegister =>
      'You need to be signed in to register as a provider.';

  @override
  String get gigsErrAddService => 'Add at least one service you can provide.';

  @override
  String get gigsProfileSaved => 'Provider profile saved.';

  @override
  String gigsSaveOnlineFailed(String error) {
    return 'Could not save online: $error';
  }

  @override
  String get gigsSavedOnDevice =>
      'Saved on this device. Will sync when the server is available.';

  @override
  String get gigsYourProviderProfile => 'Your provider profile';

  @override
  String get gigsBecomeProvider => 'Become a provider';

  @override
  String get gigsRegistrationIntro =>
      'Tell customers what you offer. You can update this anytime.';

  @override
  String get gigsErrNameMin => 'Enter a name (at least 2 characters).';

  @override
  String get gigsContactPhone => 'Contact phone';

  @override
  String get gigsErrPhoneHelps => 'Phone helps customers reach you.';

  @override
  String get gigsAboutYou => 'About you';

  @override
  String get gigsErrBioMin => 'Add a short bio (at least 12 characters).';

  @override
  String get gigsServicesYouProvide => 'Services you provide';

  @override
  String get gigsServicesHint =>
      'One per line (e.g. plumbing, home cleaning, delivery).';

  @override
  String get gigsServices => 'Services';

  @override
  String get gigsServiceAreaOptional => 'Service area (optional)';

  @override
  String get gigsServiceAreaHint => 'Neighborhood, city, or radius';

  @override
  String get gigsCategoriesOptional => 'Categories (optional)';

  @override
  String get gigsCategoriesHint => 'Helps customers filter the directory.';

  @override
  String get gigsSaveChanges => 'Save changes';

  @override
  String get gigsSubmitRegistration => 'Submit registration';

  @override
  String get gigsHowProvidersTitle => 'Providers';

  @override
  String get gigsHowProvidersBody =>
      'Workers register and list the services they can perform for others.';

  @override
  String get gigsHowRatingsTitle => 'Ratings';

  @override
  String get gigsHowRatingsBody =>
      'We assign and update ratings from our verification and client feedback.';

  @override
  String get gigsHowRequestsTitle => 'Requests';

  @override
  String get gigsHowRequestsBody =>
      'Customers send a service request to a chosen provider. The provider must accept or decline within 30 minutes.';

  @override
  String get gigsHowRequestsHighlight => '30 min to accept';

  @override
  String get gigsHowPaymentTitle => 'Payment window';

  @override
  String get gigsHowPaymentBody =>
      'After acceptance, the customer completes payment within 5 minutes so the job is confirmed and funded.';

  @override
  String get gigsHowPaymentHighlight => '5 min to pay';

  @override
  String get gigsHowExecutionTitle => 'Execution';

  @override
  String get gigsHowExecutionBody =>
      'Once paid, the worker can contact the customer and perform the service.';

  @override
  String get gigsHowEscrowTitle => 'Escrow & payout';

  @override
  String get gigsHowEscrowBody =>
      'We collect funds via MTN (and dedicated charge APIs). Money is released after both sides confirm completion; ledgers track balances, commission, and who is owed what.';

  @override
  String get gigsHowItWorksTitle => 'How Services hub works';

  @override
  String get gigsHowItWorks => 'How it works';

  @override
  String get gigsAdminTools => 'Admin tools';

  @override
  String get gigsHubTagline =>
      'Find people for jobs, or offer your skills—payments stay on the platform.';

  @override
  String get gigsFindProviders => 'Find providers';

  @override
  String get gigsYourActivity => 'Your activity';

  @override
  String get gigsProviderTools => 'Provider tools';

  @override
  String get gigsEarnOnHub => 'Earn on Services hub';

  @override
  String get gigsEarnOnHubBody =>
      'Register the services you offer so customers can find and book you.';

  @override
  String get gigsNoServicesListed => 'No services listed yet';

  @override
  String gigsMoreCount(String count) {
    return '+$count more';
  }

  @override
  String get gigsTapToEditProfile => 'Tap to edit profile';

  @override
  String get gigsEnterMomoNumberFull =>
      'Enter the MTN MoMo number to charge (mobile wallet, not email).';

  @override
  String get gigsPaymentDeclinedDefault => 'The payment was declined.';

  @override
  String get gigsNothingChargedTryAgain =>
      'Nothing was charged — you can try again.';

  @override
  String get gigsPaymentNotConfirmed =>
      'Payment was not confirmed yet. Approve the MTN prompt on your phone. If money left your account, contact support with this request rather than paying again.';

  @override
  String get gigsMoneyLeftContactSupport =>
      'If money left your wallet, contact support with this request.';

  @override
  String get gigsPaymentSentNotUpdated =>
      'Payment may have been sent but we could not update the request.';

  @override
  String gigsPayProvider(String name) {
    return 'Pay $name';
  }

  @override
  String get gigsPaySheetIntro =>
      'We send an MTN MoMo prompt to the number below. Approve it on your phone; we wait up to 5 minutes for confirmation before marking this request paid.';

  @override
  String get gigsPaySheetEmailNote =>
      'If you signed in with email (or we do not have a mobile wallet on file), enter the MTN MoMo number that should be charged. This must be a mobile money line—not an email.';

  @override
  String get gigsAmountRwf => 'Amount (RWF)';

  @override
  String get gigsMinimum100Rwf => 'Minimum 100 RWF';

  @override
  String get gigsMomoNumberLabel => 'MTN MoMo number to charge';

  @override
  String get gigsMomoNumberHelper =>
      'Use the wallet number MTN will prompt, not your login email';

  @override
  String get gigsErrEnterMomoNumber => 'Enter the MTN MoMo number to charge';

  @override
  String get gigsErrMobileNotEmail => 'Enter a mobile number, not an email';

  @override
  String get gigsErrValidMobile =>
      'Enter a valid mobile number (digits only, 9–15)';

  @override
  String get gigsWaitingForPayment => 'Waiting for payment…';

  @override
  String get gigsSendPaymentRequest => 'Send payment request';

  @override
  String get gigsChooseService => 'Choose which service you need.';

  @override
  String get gigsSomethingWentWrong =>
      'Something went wrong. Please try again.';

  @override
  String get gigsWhichService => 'Which service do you need?';

  @override
  String get gigsAmountYouWillPay => 'Amount you will pay (RWF)';

  @override
  String get gigsDescribeNeed => 'Describe what you need';

  @override
  String get gigsDescribeNeedExample =>
      'Example: Fix a leaking kitchen tap this weekend. I am available Saturday morning.';

  @override
  String get gigsErrMoreDetail =>
      'Please add a bit more detail (at least 20 characters).';

  @override
  String get gigsProviderHas30Min =>
      'The provider has 30 minutes to accept. After that, you can send a new request.';

  @override
  String get gigsSendRequest => 'Send request';

  @override
  String get gigsTimelineRequestSent => 'Request sent';

  @override
  String get gigsTimelineProviderAccepted => 'Provider accepted';

  @override
  String get gigsTimelinePaymentReceived => 'Payment received';

  @override
  String get gigsTimelineWorkInProgress => 'Work in progress';

  @override
  String get gigsTimelineReviewSubmitted => 'Review submitted';

  @override
  String get gigsOrderTimeline => 'Order timeline';

  @override
  String get gigsErrCannotDecline =>
      'This request can no longer be declined. It may have expired or already been handled.';

  @override
  String get gigsErrDecline => 'Could not decline the request.';

  @override
  String get gigsErrDeclineConnection =>
      'Could not decline the request. Check your connection and try again.';

  @override
  String get productEditorCategorySwitchTo => 'Switch to';

  @override
  String get productEditorCategoryPickYours => 'Or pick one of yours';

  @override
  String get productEditorCategorySearchToChange =>
      'Search to change category…';

  @override
  String get productEditorCategorySearch => 'Search categories…';

  @override
  String get productEditorCategoryNoneYet => 'You have no categories yet';

  @override
  String productEditorCategoryNoMatch(String query) {
    return 'Nothing matches \"$query\"';
  }

  @override
  String productEditorCategoryMoreHidden(int count) {
    return '$count more — keep typing to narrow it down';
  }

  @override
  String productEditorCategoryCreateNamed(String name) {
    return 'Create \"$name\"';
  }

  @override
  String get productEditorCategoryFiledUnder => 'Filed under';

  @override
  String get productEditorCategoryRemove => 'Remove category';

  @override
  String get productEditorCategoryNoneChosen =>
      'No category chosen yet — search above or create a new one.';

  @override
  String get productEditorCategoryCreateNew => 'Create a new category';

  @override
  String get productEditorCategoryNew => 'New';

  @override
  String get productEditorCompositeItem => 'Composite item';

  @override
  String get productEditorCompositeHint =>
      'Built from other products — price is the sum of its components';

  @override
  String get productEditorColorSelectShade => 'Select color shade';

  @override
  String get productEditorColorShades => 'SHADES';

  @override
  String productEditorColorHueShade(String hue, int number) {
    return '$hue · shade $number';
  }

  @override
  String get productEditorColorSwatchHint =>
      'Used as the product\'s swatch across POS & reports';

  @override
  String get productEditorColorChoose => 'Choose color';

  @override
  String get productEditorHueRed => 'Red';

  @override
  String get productEditorHueOrange => 'Orange';

  @override
  String get productEditorHueAmber => 'Amber';

  @override
  String get productEditorHueGreen => 'Green';

  @override
  String get productEditorHueTeal => 'Teal';

  @override
  String get productEditorHueBlue => 'Blue';

  @override
  String get productEditorHueIndigo => 'Indigo';

  @override
  String get productEditorHueViolet => 'Violet';

  @override
  String get productEditorHueSlate => 'Slate';

  @override
  String get productEditorReadyToSave => 'Ready to save';

  @override
  String productEditorSectionsComplete(String done, String total) {
    return '$done of $total sections complete';
  }

  @override
  String get productEditorSaveProduct => 'Save product';

  @override
  String get productEditorUntitledProduct => 'Untitled product';

  @override
  String get productEditorBreadcrumbNewProduct => 'INVENTORY · NEW PRODUCT';

  @override
  String get productEditorBreadcrumbEditProduct => 'INVENTORY · EDIT PRODUCT';

  @override
  String get productEditorBreadcrumbNewComposite => 'INVENTORY · NEW COMPOSITE';

  @override
  String get productEditorBreadcrumbEditComposite =>
      'INVENTORY · EDIT COMPOSITE';

  @override
  String get productEditorOptional => 'optional';

  @override
  String get productEditorItemTypeFinished =>
      'Finished product — ready to sell';

  @override
  String get productEditorItemTypeRawMaterial =>
      'Raw material — used to make other products';

  @override
  String get productEditorItemTypeService =>
      'Service — nothing to keep in stock';

  @override
  String get productEditorCategoryHint =>
      'Groups this product in reports and on the sell screen.';

  @override
  String get productEditorItemType => 'Item type';

  @override
  String get productEditorItemTypeLocked =>
      'Locked — this cannot change after the product is created.';

  @override
  String get productEditorItemTypeHint =>
      'Most shop items are a finished product.';

  @override
  String get productEditorPackagingUnit => 'Packaging unit';

  @override
  String get productEditorCountryOfOrigin => 'Country of origin';

  @override
  String get productEditorNoCountryList =>
      'No country list available yet — new products are saved as RW.';

  @override
  String get productEditorCountryDefaultRw => 'RW (default)';

  @override
  String get productEditorCountriesLoadFailed => 'Could not load countries';

  @override
  String get productEditorOriginNotSet => 'origin not set';

  @override
  String get productEditorTaxDetailsTitle =>
      'Packaging & origin (for tax reporting)';

  @override
  String get productEditorTapToHide => 'Tap to hide';

  @override
  String get productEditorProfitPerUnit => 'Profit per unit';

  @override
  String get productEditorMargin => 'Margin';

  @override
  String get productEditorSupplyFromComponents =>
      'Supply price calculated from components';

  @override
  String get productEditorNoVariantsExisting => 'This product has no variants';

  @override
  String get productEditorNoVariantsYet => 'No variants yet';

  @override
  String get productEditorNoVariantsHint =>
      'Scan a barcode or type a name above to add one';

  @override
  String get productEditorSectionsHeading => 'SECTIONS';

  @override
  String get productEditorScanHint => 'Scan or type variant name…';

  @override
  String get productEditorScanWithCamera => 'Scan with camera';

  @override
  String get productEditorAddVariant => 'Add variant';

  @override
  String get productEditorScanTipPress => 'Press';

  @override
  String get productEditorScanTipEnterKey => 'Enter';

  @override
  String get productEditorScanTipOrTapAdd => 'or tap Add variant';

  @override
  String get productEntryAddNewProduct => 'Add New Product';

  @override
  String get productEntryEditProduct => 'Edit Product';

  @override
  String get productEntryNameRequired => 'Product name is required';

  @override
  String get productEntryNameTooShort =>
      'Product name must be at least 3 characters long';

  @override
  String get productEntryProductName => 'Product Name';

  @override
  String get productEntryProductNameHint => 'e.g. Arabica Coffee';

  @override
  String get productEntryInventoryTitle => 'Inventory & Categorization';

  @override
  String get productEntryPackagingUnit => 'Packaging Unit';

  @override
  String get productEntryPriceRequired => 'Price is required';

  @override
  String get productEntryRetailPrice => 'Retail price';

  @override
  String get productEntrySupplyPrice => 'Supply price';

  @override
  String get productEntryQuickScan => 'Quick Scan';

  @override
  String get productEntryScanLabel => 'Scan or Type Variant Name';

  @override
  String get productionOutputLoadingSku => 'Loading...';

  @override
  String get inventoryDashboardTotalItems => 'Total Items';

  @override
  String get inventoryDashboardExpiredItems => 'Expired Items';

  @override
  String get inventoryDashboardLowStockItems => 'Low Stock Items';

  @override
  String get inventoryDashboardPendingOrders => 'Pending Orders';

  @override
  String get inventoryDashboardFromLastWeek => 'from last week';

  @override
  String get inventoryDashboardTrendEstimate =>
      'This trend is based on an estimate';

  @override
  String inventoryDashboardIdValue(String id) {
    return 'ID: $id';
  }

  @override
  String inventoryDashboardCategoryValue(String category) {
    return 'Category: $category';
  }

  @override
  String inventoryDashboardQuantityValue(String quantity) {
    return 'Quantity: $quantity';
  }

  @override
  String inventoryDashboardLocationValue(String location) {
    return 'Location: $location';
  }

  @override
  String inventoryDashboardExpiryDateValue(String date) {
    return 'Expiry Date: $date';
  }

  @override
  String inventoryDashboardExpiredLoadError(String error) {
    return 'Error loading expired items: $error';
  }

  @override
  String inventoryDashboardNearExpiryLoadError(String error) {
    return 'Error loading near expiry items: $error';
  }

  @override
  String get inventoryDashboardViewAll => 'View All';

  @override
  String get inventoryDashboardExpiredOn => 'Expired On';

  @override
  String get inventoryDashboardAllExpiredItems => 'All Expired Items';

  @override
  String inventoryDashboardExpiredOnDate(String date) {
    return 'Expired on: $date';
  }

  @override
  String get inventoryDashboardNearExpiryItems => 'Near Expiry Items';

  @override
  String inventoryDashboardUnitsAtLocation(int count, String location) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count units - $location',
      one: '1 unit - $location',
    );
    return '$_temp0';
  }

  @override
  String inventoryDashboardDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days left',
      one: '1 day left',
    );
    return '$_temp0';
  }

  @override
  String get inventoryDashboardByCategory => 'Inventory by Category';

  @override
  String get inventoryDashboardStockLevelsTrend => 'Stock Levels Trend';

  @override
  String get inventoryDashboardRecentOrders => 'Recent Orders';

  @override
  String inventoryDashboardOrderLine(String id, String date) {
    return 'Order #$id - $date';
  }

  @override
  String get inventoryDashboardStatusDelivered => 'Delivered';

  @override
  String get inventoryDashboardStatusInTransit => 'In Transit';

  @override
  String get inventoryDashboardStatusProcessing => 'Processing';

  @override
  String get inventoryDashboardStatusCancelled => 'Cancelled';

  @override
  String get inventoryDashboardRunningLow => 'Running Low (7-Day Forecast)';

  @override
  String inventoryDashboardStockValue(String stock) {
    return 'Stock: $stock';
  }

  @override
  String inventoryDashboardDailyUsage(String usage) {
    return 'Daily Usage: $usage';
  }

  @override
  String get inventoryDashboardReplenish => 'Replenish';

  @override
  String get inventoryDashboardUnknownLocation => 'Unknown';

  @override
  String inventoryDashboardBranchFallback(String id) {
    return 'Branch $id';
  }

  @override
  String get inventoryDashboardUncategorized => 'Uncategorized';

  @override
  String stockValueItemsNeedRestock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items need restocking attention',
      one: '1 item needs restocking attention',
    );
    return '$_temp0';
  }

  @override
  String get stockValueViewAllArrow => 'View all →';

  @override
  String get stockValueStatusCritical => 'Critical';

  @override
  String get stockValueStatusLow => 'Low';

  @override
  String get stockValueStatusOk => 'OK';

  @override
  String get stockValueTitleMobile => 'Stock Values';

  @override
  String get stockValueTitle => 'Stock Value';

  @override
  String stockValueProductsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
    );
    return '$_temp0';
  }

  @override
  String get stockValueLoadError => 'Unable to load stock report.';

  @override
  String get stockValueTotalValueCaps => 'TOTAL VALUE';

  @override
  String stockValueRwfItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'RWF · $count items',
      one: 'RWF · 1 item',
    );
    return '$_temp0';
  }

  @override
  String get stockValueNeedsRestockCaps => 'NEEDS RESTOCK';

  @override
  String get stockValueCriticalOrLow => 'critical or low';

  @override
  String get stockValuePartialSync => 'Data may be incomplete (partial sync).';

  @override
  String get stockValueLowCriticalCaps => 'LOW & CRITICAL ITEMS';

  @override
  String get stockValueNoLowStock => 'No low-stock items in local data.';

  @override
  String get stockValueByCategoryCaps => 'VALUE BY CATEGORY';

  @override
  String get stockValueNoCategoryBreakdown =>
      'No category breakdown available.';

  @override
  String get stockValueLoadingProducts => 'Loading products…';

  @override
  String get stockValueRestockHint =>
      'Use inventory or receive stock to restock items.';

  @override
  String get stockValueNoRowsToExport =>
      'No rows to export for the current filter.';

  @override
  String get stockValueCsvProduct => 'Product';

  @override
  String get stockValueCsvUnitPrice => 'Unit price';

  @override
  String get stockValueCsvStock => 'Stock';

  @override
  String get stockValueCsvLineValue => 'Line value';

  @override
  String get stockValueCsvStatus => 'Status';

  @override
  String stockValueCopiedCsvRows(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Copied $count rows as CSV to clipboard.',
      one: 'Copied 1 row as CSV to clipboard.',
    );
    return '$_temp0';
  }

  @override
  String stockValueDesktopSubtitle(int products, int categories, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      products,
      locale: localeName,
      other: '$products products',
      one: '1 product',
    );
    String _temp1 = intl.Intl.pluralLogic(
      categories,
      locale: localeName,
      other: '$categories categories',
      one: '1 category',
    );
    return '$_temp0 across $_temp1 · Last updated today at $time';
  }

  @override
  String get stockValueSearchHint => 'Search product or BCD...';

  @override
  String get stockValueExport => 'Export';

  @override
  String get stockValueRestockOrder => '+ Restock order';

  @override
  String get stockValueTotalStockValue => 'Total stock value';

  @override
  String get stockValueAtRetailSupply => 'At retail/supply value';

  @override
  String get stockValueHealthyStock => 'Healthy stock';

  @override
  String get stockValueWellStocked => 'products well stocked';

  @override
  String stockValuePercentOfCatalogue(String percent) {
    return '$percent% of catalogue';
  }

  @override
  String get stockValueCriticalLow => 'Critical / low';

  @override
  String get stockValueNeedRestocking => 'need restocking';

  @override
  String get stockValueReviewAlerts => 'review alerts →';

  @override
  String get stockValueHighestValueItem => 'Highest value item';

  @override
  String get stockValueNoValueOnHand => 'No value on hand';

  @override
  String stockValueTopItemDetail(String value, String units) {
    return '$value · $units units';
  }

  @override
  String stockValuePercentOfTotal(String percent) {
    return '$percent% of total value';
  }

  @override
  String get stockValueAllProducts => 'All products';

  @override
  String get stockValueFilterAll => 'All';

  @override
  String get stockValueNoProductsMatch =>
      'No products match the current search or filter.';

  @override
  String get stockValueColProduct => 'PRODUCT';

  @override
  String get stockValueColCategory => 'CATEGORY';

  @override
  String get stockValueColUnitPrice => 'UNIT PRICE';

  @override
  String get stockValueColStock => 'STOCK';

  @override
  String get stockValueColValue => 'VALUE';

  @override
  String get stockValueColStatus => 'STATUS';

  @override
  String get stockValueNoCategoryData => 'No category data.';

  @override
  String get stockValueByCategory => 'Value by category';

  @override
  String get stockValueRestockAlerts => 'Restock alerts';

  @override
  String get stockValueNoRestockAlerts => 'No restock alerts.';

  @override
  String stockValueUnitsMin(String units, String min) {
    return '$units units, min: $min';
  }

  @override
  String get stockValueSalesLoadError => 'Could not load sales data.';

  @override
  String stockValueInStock(String count) {
    return '$count in stock';
  }

  @override
  String stockValuePerUnit(String price) {
    return '$price / unit';
  }

  @override
  String get stockValueStockValueCaps => 'STOCK VALUE';

  @override
  String stockValueUnitsTimesPrice(String units, String price) {
    return '$units units × $price';
  }

  @override
  String get stockValueTotalSalesCaps => 'TOTAL SALES';

  @override
  String stockValueUnitsSoldPeriod(String units) {
    return '$units units sold (period)';
  }

  @override
  String get stockValueProfitCaps => 'PROFIT';

  @override
  String stockValueMarginEst(String percent) {
    return '$percent% margin (est.)';
  }

  @override
  String get stockValueStockPerformance => 'Stock Performance';

  @override
  String stockValueRangeDays(int days) {
    return '${days}D';
  }

  @override
  String get stockValueNoSalesVolume => 'No sales volume in this period.';

  @override
  String get stockValueSalesVolume => 'Sales volume';

  @override
  String get stockValueDetailedMetrics => 'Detailed metrics';

  @override
  String get stockValueTurnoverCaps => 'INVENTORY TURNOVER';

  @override
  String get stockValueTurnoverFooter =>
      'Relative to on-hand stock in this period.';

  @override
  String get stockValueGrossMarginCaps => 'GROSS MARGIN';

  @override
  String get stockValueGrossMarginFooter =>
      'Estimated from retail vs supply on sold units.';

  @override
  String get stockValueAvgTransactionCaps => 'AVG. TRANSACTION';

  @override
  String get stockValueAvgTransactionFooter =>
      'Revenue / distinct transactions in range.';

  @override
  String get stockValueUnitsSoldCaps => 'UNITS SOLD';

  @override
  String get stockValueUnitsSoldFooter => 'Total units in the selected range.';

  @override
  String get stockValueDeleteUnavailable =>
      'Delete product from inventory is not available here.';

  @override
  String get stockValueEditProduct => 'Edit product';

  @override
  String get stockValueCopiedSummary => 'Copied summary to clipboard.';

  @override
  String get tenantMgmtCommissionAgentMigrationRequired =>
      'Commission-only agents need a database update. Apply migration supabase/migrations/20260518120000_agent_allow_business_login.sql (e.g. supabase db push), or turn on \"Allow login on this business\" and try again.';

  @override
  String get tenantMgmtNoBusinessSelected => 'No business selected';

  @override
  String get tenantMgmtAgentBranchNameRequired =>
      'Please enter a branch name for Agent';

  @override
  String get tenantMgmtBranchNotInBusiness =>
      'Selected branch does not belong to current business. Please switch business/branch and try again.';

  @override
  String tenantMgmtUserLookupFailed(String details) {
    return 'Failed to find user with provided phone/email: $details';
  }

  @override
  String get tenantMgmtSavePermissionsSupabaseError =>
      'Failed to save permissions (Supabase error).';

  @override
  String tenantMgmtSavePermissionsOrphanHint(String error) {
    return '$error The login account may already exist without a tenant for this business — open User Management and add this user again to finish setup.';
  }

  @override
  String tenantMgmtSavePermissionsFailed(String error) {
    return 'Failed to save permissions: $error';
  }

  @override
  String tenantMgmtPinGenerationFailed(String details) {
    return 'Failed to generate pin for the new tenant: $details';
  }

  @override
  String get tenantMgmtOrphanUser =>
      'User was created but has no tenant for this business. Re-open User Management and save again, or run supabase migration 20260519150000_repair_orphan_users_with_pins.sql.';

  @override
  String get tenantMgmtCreated => 'Tenant Created Successfully';

  @override
  String get tenantMgmtPermissionsSaved =>
      'Permissions saved. Online users refresh Ditto user_access automatically; offline users pick up changes on next sign-in.';

  @override
  String get tenantMgmtPermissionsSavedSelf =>
      'Permissions saved. Your menus have been refreshed.';

  @override
  String tenantMgmtUnexpectedError(String error) {
    return 'An unexpected error occurred: $error';
  }

  @override
  String get tenantMgmtAdminCannotDelete => 'Admin users cannot be deleted.';

  @override
  String get tenantMgmtDeleted => 'Tenant deleted successfully';

  @override
  String get tenantMgmtDeleteFailed =>
      'Error deleting tenant. Please try again.';

  @override
  String get tenantMgmtDeleteTitle => 'Delete Tenant';

  @override
  String get tenantMgmtDeleteConfirm =>
      'Are you sure you want to delete this tenant?';

  @override
  String get tenantMgmtEnterPhoneOrEmail =>
      'Enter valid number or email address';

  @override
  String get tenantMgmtPhoneNeedsCountryCode =>
      'Phone number should contain country code with + sign';

  @override
  String get tenantMgmtInvalidPhone => 'Invalid phone number';

  @override
  String get tenantMgmtInvalidPhoneFormat => 'Invalid phone number format';

  @override
  String get tenantMgmtModulePermissions => 'MODULE PERMISSIONS';

  @override
  String get tenantMgmtColModule => 'MODULE';

  @override
  String get tenantMgmtColAccessLevel => 'ACCESS LEVEL';

  @override
  String get tenantMgmtColActive => 'ACTIVE';

  @override
  String get tenantMgmtFeatureInventory => 'Inventory';

  @override
  String get tenantMgmtFeatureSettings => 'Settings';

  @override
  String get tenantMgmtFeatureReports => 'Reports';

  @override
  String get tenantMgmtFeatureTransactions => 'Transactions';

  @override
  String get tenantMgmtFeatureTickets => 'Tickets';

  @override
  String get tenantMgmtFeatureOrders => 'Orders';

  @override
  String get tenantMgmtFeatureLeads => 'Leads';

  @override
  String get tenantMgmtFeatureAddProduct => 'Add Product';

  @override
  String get tenantMgmtFeatureSales => 'Sales';

  @override
  String get tenantMgmtFeatureDriver => 'Driver';

  @override
  String get tenantMgmtFeatureStock => 'Stock';

  @override
  String get tenantMgmtFeatureShiftHistory => 'Shift History';

  @override
  String get tenantMgmtFeatureTicketReview => 'Ticket Review';

  @override
  String get tenantMgmtFeatureStockHandover => 'Stock Handover';

  @override
  String get tenantMgmtFeatureHideStockQuantity => 'Hide Stock Quantity';

  @override
  String get tenantMgmtAccessNone => 'No Access';

  @override
  String get tenantMgmtAccessRead => 'Read';

  @override
  String get tenantMgmtAccessWrite => 'Write';

  @override
  String get tenantMgmtAccessAdmin => 'Admin';

  @override
  String get tenantMgmtRoleUser => 'User';

  @override
  String get tenantMgmtRoleAdmin => 'Admin';

  @override
  String get tenantMgmtRoleAgent => 'Agent';

  @override
  String get tenantMgmtRoleCashier => 'Cashier';

  @override
  String get tenantMgmtRoleDriver => 'Driver';

  @override
  String get tenantMgmtRoleViewer => 'Viewer';

  @override
  String get tenantMgmtRoleReviewer => 'Reviewer';

  @override
  String get tenantMgmtRoleStockManager => 'Stock Manager';

  @override
  String get tenantMgmtCurrentUsers => 'CURRENT USERS';

  @override
  String get tenantMgmtSearchUsers => 'Search users...';

  @override
  String get tenantMgmtNoUsers => 'No users yet.';

  @override
  String get tenantMgmtNoUsersMatch => 'No users match your search.';

  @override
  String get tenantMgmtNoContact => 'No contact';

  @override
  String get tenantMgmtNoBranches => 'No branches available';

  @override
  String get tenantMgmtUnnamedBranch => 'Unnamed Branch';

  @override
  String get tenantMgmtSelectBranch => 'Select Branch';

  @override
  String tenantMgmtErrorValue(String error) {
    return 'Error: $error';
  }

  @override
  String get tenantMgmtUserTypeCaps => 'USER TYPE';

  @override
  String get tenantMgmtEditUser => 'Edit User';

  @override
  String get tenantMgmtAddNewUser => 'Add New User';

  @override
  String get tenantMgmtFullNameCaps => 'FULL NAME';

  @override
  String get tenantMgmtEnterName => 'Please enter a name';

  @override
  String get tenantMgmtPhoneEmailCaps => 'PHONE / EMAIL';

  @override
  String get tenantMgmtAgentBranchNameCaps => 'BRANCH NAME (AGENT)';

  @override
  String get tenantMgmtEnterBranchName => 'Please enter a branch name';

  @override
  String get tenantMgmtBranchNameTooShort => 'Branch name is too short';

  @override
  String get tenantMgmtUpdateUser => 'Update User';

  @override
  String get tenantMgmtAddUser => '+ Add User';

  @override
  String get tenantMgmtAllowBusinessLogin => 'Allow login on this business';

  @override
  String get tenantMgmtAllowBusinessLoginHint =>
      'Off by default: agent receives a PIN but only sees commission for this business. Turn on to grant full dashboard access per module permissions below.';

  @override
  String get tenantMgmtCommissionOnlyHint =>
      'Module permissions are not used in commission-only mode. The agent will sign in with their PIN and only see their commission for this business.';

  @override
  String stockValueUnitsValue(String units) {
    return '$units units';
  }

  @override
  String stockValueMinValue(String min) {
    return 'min: $min';
  }

  @override
  String stockValueItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get dailyReportRecipientsInvalidEmail =>
      'Enter a valid email address.';

  @override
  String get dailyReportRecipientsNoBusiness => 'No business selected.';

  @override
  String get dailyReportRecipientsNotSetUpRunMigration =>
      'Daily report recipients are not set up yet. Ask your admin to run the latest Supabase migration (business_report_recipients).';

  @override
  String get dailyReportRecipientsDuplicate =>
      'That email is already on the daily report list.';

  @override
  String get dailyReportRecipientsCouldNotAdd => 'Could not add recipient.';

  @override
  String get dailyReportRecipientsNotSetUp =>
      'Daily report recipients are not set up yet.';

  @override
  String get dailyReportRecipientsCouldNotRemove =>
      'Could not remove recipient.';

  @override
  String dailyReportRecipientsLoadFailed(String error) {
    return 'Could not load daily report recipients: $error';
  }

  @override
  String get dailyReportRecipientsEnterEmail => 'Enter an email address.';

  @override
  String get dailyReportRecipientsAdded => 'Recipient added.';

  @override
  String dailyReportRecipientsAddFailed(String error) {
    return 'Could not add recipient: $error';
  }

  @override
  String get dailyReportRecipientsRemoved => 'Recipient removed.';

  @override
  String dailyReportRecipientsRemoveFailed(String error) {
    return 'Could not remove recipient: $error';
  }

  @override
  String get dailyReportRecipientsEmailHint => 'e.g. accountant@example.com';

  @override
  String get dailyReportRecipientsLabelHint => 'Label (optional)';

  @override
  String get dailyReportRecipientsSave => 'Save recipient';

  @override
  String get dailyReportRecipientsAddTitle => 'Add recipient';

  @override
  String get dailyReportRecipientsTitle => 'Daily report recipients';

  @override
  String get dailyReportRecipientsSubtitle =>
      'The owner email above receives the daily detailed transactions report. Add more addresses to receive the same report.';

  @override
  String get dailyReportRecipientsEmpty => 'No additional recipients yet.';

  @override
  String transfersReportPdfExportFailed(String error) {
    return 'PDF export failed: $error';
  }

  @override
  String get transfersReportAllDates => 'All dates';

  @override
  String transfersReportLoadFailed(String error) {
    return 'Failed to load transfers: $error';
  }

  @override
  String get transfersReportSelectDestination => 'Select a destination';

  @override
  String get transfersReportSelectDestinationBody =>
      'Choose a To branch to load transfers for that location.';

  @override
  String transfersReportCountTo(int count, String branch) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transfers',
      one: '1 transfer',
    );
    return '$_temp0 to $branch';
  }

  @override
  String get transfersReportNoTransfers => 'No transfers';

  @override
  String get transfersReportNoTransfersBody =>
      'No transfers match this filter for the selected date range.';

  @override
  String get transfersReportTitle => 'Transfers report';

  @override
  String get transfersReportSubtitle =>
      'Stock transfers received by a destination branch';

  @override
  String get transfersReportExportPdf => 'Export PDF';

  @override
  String get transfersReportBranchesLoadFailed => 'Failed to load branches';

  @override
  String get transfersReportToBranch => 'To branch';

  @override
  String get transfersReportFilterAll => 'All';

  @override
  String get transfersReportStatusPending => 'Pending';

  @override
  String get transfersReportStatusProcessing => 'Processing';

  @override
  String get transfersReportStatusPartiallyApproved => 'Partially approved';

  @override
  String get transfersReportStatusRejected => 'Rejected';

  @override
  String get transfersReportStatusFulfilled => 'Fulfilled';

  @override
  String get transfersReportStatusVoided => 'Voided';

  @override
  String transfersReportItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get transfersReportNoLineItems => 'No line items embedded';

  @override
  String get transfersReportStatusAndDelivery => 'Status & delivery';

  @override
  String get transfersReportStatus => 'Status';

  @override
  String get transfersReportReceivedOn => 'Received on';

  @override
  String get transfersReportViewPdf => 'View PDF';

  @override
  String get transfersReportDownload => 'Download';

  @override
  String get transfersReportFromLabel => 'From:';

  @override
  String get transfersReportToLabel => 'To:';

  @override
  String transfersReportQty(String qty) {
    return 'Qty: $qty';
  }

  @override
  String get transfersReportPdfStockTransferSubject => 'Stock transfer';

  @override
  String get transfersReportPdfSaveDialog => 'Save Transfers PDF';

  @override
  String transfersReportPdfTitleTo(String branch) {
    return 'Stock transfers to $branch';
  }

  @override
  String transfersReportPdfTransferCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transfers',
      one: '1 transfer',
    );
    return '$_temp0';
  }

  @override
  String transfersReportPdfUnitCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count units',
      one: '1 unit',
    );
    return '$_temp0';
  }

  @override
  String get transfersReportPdfNoTransfers => 'No transfers in this range.';

  @override
  String get transfersReportColDate => 'Date';

  @override
  String get transfersReportColFrom => 'From';

  @override
  String get transfersReportColProduct => 'Product';

  @override
  String get transfersReportColQty => 'Qty';

  @override
  String get transfersReportColRequested => 'Requested';

  @override
  String transfersReportPdfTransferFrom(String id, String branch) {
    return 'Transfer $id · from $branch';
  }

  @override
  String transfersReportPdfFooter(String date, String page, String pages) {
    return 'Generated $date · page $page/$pages';
  }

  @override
  String transfersReportPdfSingleTitle(String id) {
    return 'Stock transfer $id';
  }

  @override
  String transfersReportPdfApprovedBy(String name) {
    return 'Approved by: $name';
  }

  @override
  String get dailyReportFilesRangeAllTime => 'All time';

  @override
  String get dailyReportFilesRangeLast7Days => 'Last 7 days';

  @override
  String get dailyReportFilesRangeLast30Days => 'Last 30 days';

  @override
  String get dailyReportFilesRangeLast90Days => 'Last 90 days';

  @override
  String get dailyReportFilesRangeThisMonth => 'This month';

  @override
  String get dailyReportFilesRangeLastMonth => 'Last month';

  @override
  String get dailyReportFilesSortNewest => 'Newest first';

  @override
  String get dailyReportFilesSortOldest => 'Oldest first';

  @override
  String get dailyReportFilesSortNameAsc => 'Name A–Z';

  @override
  String get dailyReportFilesSortNameDesc => 'Name Z–A';

  @override
  String get dailyReportFilesTypeAll => 'All';

  @override
  String get dailyReportFilesTypeTransactions => 'Transactions';

  @override
  String get dailyReportFilesTypeMerged => 'Merged';

  @override
  String get dailyReportFilesShareUnsupportedWeb =>
      'Sharing is not supported in the browser.';

  @override
  String get dailyReportFilesShareSubjectOne => 'Daily report';

  @override
  String get dailyReportFilesNoActiveBranch => 'No active branch.';

  @override
  String get dailyReportFilesNoStorageKey =>
      'This file has no storage key yet.';

  @override
  String dailyReportFilesSaved(String name) {
    return 'Saved $name';
  }

  @override
  String get dailyReportFilesReportFallback => 'report';

  @override
  String dailyReportFilesDownloaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Downloaded $count files',
      one: 'Downloaded 1 file',
    );
    return '$_temp0';
  }

  @override
  String dailyReportFilesShared(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Shared $count files',
      one: 'Shared 1 file',
    );
    return '$_temp0';
  }

  @override
  String get dailyReportFilesAlreadyArchived =>
      'Selected files are already archived.';

  @override
  String get dailyReportFilesSelectedNoStorageKey =>
      'Selected files have no storage key yet.';

  @override
  String get dailyReportFilesNoneArchived => 'No files could be archived.';

  @override
  String dailyReportFilesArchived(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Archived $count files',
      one: 'Archived 1 file',
    );
    return '$_temp0';
  }

  @override
  String dailyReportFilesArchivedSkipped(String summary, String skipped) {
    return '$summary ($skipped skipped — no storage key yet)';
  }

  @override
  String get dailyReportFilesMergeNeedsKeys =>
      'Every selected report must have a storage key before merging.';

  @override
  String dailyReportFilesMerged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Merged $count reports. New workbook added to the list.',
      one: 'Merged 1 report. New workbook added to the list.',
    );
    return '$_temp0';
  }

  @override
  String get dailyReportFilesCurrentBranch => 'Current branch';

  @override
  String get dailyReportFilesNoBranch => 'No branch';

  @override
  String get dailyReportFilesNoBranchSelectedBody =>
      'Select a branch to see the daily Excel exports.';

  @override
  String get dailyReportFilesLoadFailed => 'Could not load reports';

  @override
  String get dailyReportFilesCheckConnection =>
      'Check your connection and try again.';

  @override
  String get dailyReportFilesEmptyTitle => 'No daily reports yet';

  @override
  String get dailyReportFilesNoMatches => 'No matches';

  @override
  String get dailyReportFilesEmptyBody =>
      'When reports are generated for this branch, they will appear here for download.';

  @override
  String get dailyReportFilesNoMatchesFiltered =>
      'Try a different search, date range, or type filter.';

  @override
  String get dailyReportFilesNoMatchesSearch =>
      'Try a different report name, date, or ID.';

  @override
  String get dailyReportFilesClearFilters => 'Clear filters';

  @override
  String dailyReportFilesSubtitle(String branch) {
    return 'Excel exports generated for $branch. Select multiple files to download together.';
  }

  @override
  String get dailyReportFilesKpiFiles => 'Files';

  @override
  String get dailyReportFilesKpiNoneYet => 'none yet';

  @override
  String get dailyReportFilesKpiAvailable => 'available';

  @override
  String get dailyReportFilesKpiReportDays => 'Report days';

  @override
  String dailyReportFilesKpiDaysGrouped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days grouped',
      one: 'day grouped',
    );
    return '$_temp0';
  }

  @override
  String get dailyReportFilesKpiReadyFiles => 'Ready files';

  @override
  String get dailyReportFilesKpiWithStorageKeys => 'with storage keys';

  @override
  String get dailyReportFilesKpiLastGenerated => 'Last generated';

  @override
  String get dailyReportFilesKpiNoExports => 'No exports';

  @override
  String get dailyReportFilesToday => 'Today';

  @override
  String get dailyReportFilesYesterday => 'Yesterday';

  @override
  String dailyReportFilesSelectedCount(String count) {
    return '$count selected';
  }

  @override
  String dailyReportFilesFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files',
      one: '1 file',
    );
    return '$_temp0';
  }

  @override
  String get dailyReportFilesAutoSync => 'Auto-syncs every 5 min';

  @override
  String get dailyReportFilesSearchHint =>
      'Search by report name, date, or ID...';

  @override
  String get dailyReportFilesFocusSearch => 'Focus search (⌘K)';

  @override
  String get dailyReportFilesTypeLabel => 'Type:';

  @override
  String get dailyReportFilesSortLabel => 'Sort:';

  @override
  String get dailyReportFilesGroupByDay => 'Group by day';

  @override
  String get dailyReportFilesFlatList => 'Flat list';

  @override
  String get dailyReportFilesUnknownDate => 'Unknown date';

  @override
  String get dailyReportFilesNoReportDay => 'No report day';

  @override
  String get dailyReportFilesPreview => 'Preview';

  @override
  String get dailyReportFilesDownload => 'Download';

  @override
  String get dailyReportFilesMoreActions => 'More actions';

  @override
  String get dailyReportFilesShare => 'Share';

  @override
  String get dailyReportFilesArchive => 'Archive';

  @override
  String get dailyReportFilesNameDailyTransactions => 'Daily Transactions';

  @override
  String get dailyReportFilesNameSalesSummary => 'Sales Summary';

  @override
  String get dailyReportFilesNamePaymentsBreakdown => 'Payments Breakdown';

  @override
  String get dailyReportFilesNameStockMovement => 'Stock Movement';

  @override
  String dailyReportFilesMergedRange(String start, String end) {
    return '$start - $end (merged)';
  }

  @override
  String dailyReportFilesMergedDay(String day) {
    return '$day (merged)';
  }

  @override
  String get dailyReportFilesMergedWorkbook => 'Merged workbook';

  @override
  String get dailyReportFilesNew => 'New';

  @override
  String get dailyReportFilesReady => 'Ready';

  @override
  String get dailyReportFilesPending => 'Pending';

  @override
  String get dailyReportFilesReportFile => 'Report file';

  @override
  String get dailyReportFilesClosePreview => 'Close preview';

  @override
  String get dailyReportFilesPreviewLoadFailed =>
      'Could not load workbook preview.';

  @override
  String dailyReportFilesFirstRows(String shown, String total) {
    return 'First $shown of $total rows';
  }

  @override
  String get dailyReportFilesRawFilename => 'Raw filename';

  @override
  String get dailyReportFilesStatFileId => 'File ID';

  @override
  String get dailyReportFilesStatRows => 'Rows';

  @override
  String get dailyReportFilesStatSize => 'Size';

  @override
  String get dailyReportFilesStatStatus => 'Status';

  @override
  String get dailyReportFilesStatSheet => 'Sheet';

  @override
  String get dailyReportFilesStatFormat => 'Format';

  @override
  String get dailyReportFilesColTime => 'Time';

  @override
  String get dailyReportFilesColReceipt => 'Receipt #';

  @override
  String get dailyReportFilesColCashier => 'Cashier';

  @override
  String get dailyReportFilesColTax => 'Tax';

  @override
  String get dailyReportFilesColTotal => 'Total';

  @override
  String get dailyReportFilesMerge => 'Merge';

  @override
  String get dailyReportFilesMergeIntoOne => 'Merge into one workbook';

  @override
  String dailyReportFilesFilesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'files selected',
      one: 'file selected',
    );
    return '$_temp0';
  }

  @override
  String get importPurchaseStatusPending => 'Pending';

  @override
  String get importPurchaseStatusRejected => 'Rejected';

  @override
  String get importPurchaseStatusProcessing => 'Processing';

  @override
  String get importPurchaseStatusWaiting => 'Waiting';

  @override
  String get importPurchaseStatusDeclined => 'Declined';

  @override
  String get importPurchaseFilterAll => 'All';

  @override
  String get importPurchaseFilterByStatus => 'Filter by Status';

  @override
  String get importPurchaseItemCodeCopied => 'Item code copied';

  @override
  String get importPurchaseMapLineTitle => 'Map purchase line';

  @override
  String get importPurchaseRraItemCode => 'RRA item code';

  @override
  String get importPurchaseCreateNewVariant => 'Create new variant';

  @override
  String get importPurchaseCreateNewVariantDesc =>
      'Creates a catalog item now and maps this purchase line to it.';

  @override
  String get importPurchaseMapExistingVariant => 'Map to existing variant';

  @override
  String get importPurchaseMapExistingVariantDesc =>
      'Adds this quantity to a variant you already stock.';

  @override
  String get importPurchaseExistingVariant => 'Existing variant';

  @override
  String get importPurchaseSelectVariantEllipsis => 'Select a variant…';

  @override
  String get importPurchaseSupplyPrice => 'Supply price';

  @override
  String get importPurchaseRetailPrice => 'Retail price';

  @override
  String get importPurchaseCreating => 'Creating…';

  @override
  String get importPurchaseSaveMapping => 'Save mapping';

  @override
  String get importPurchaseNoPurchaseInvoices => 'No purchase invoices';

  @override
  String get importPurchaseNoPurchaseInvoicesHint =>
      'Nothing matches this status filter. Record a purchase or change the filter.';

  @override
  String importPurchasePagerRange(String range, String total) {
    return '$range of $total';
  }

  @override
  String importPurchaseSupplierHeader(String name, String count) {
    return 'Supplier: $name ($count)';
  }

  @override
  String importPurchaseInvoiceHeader(String number) {
    return 'Invoice: $number';
  }

  @override
  String get importPurchaseProcessing => 'Processing…';

  @override
  String get importPurchaseAcceptAll => 'Accept All';

  @override
  String get importPurchaseDeclineAll => 'Decline All';

  @override
  String get importPurchaseColNo => 'No.';

  @override
  String get importPurchaseColQty => 'Qty';

  @override
  String get importPurchaseColSupply => 'Supply';

  @override
  String get importPurchaseColRetail => 'Retail';

  @override
  String get importPurchaseColMapping => 'Mapping';

  @override
  String importPurchaseMappedTapToChange(String label) {
    return 'Mapped · $label — tap to change';
  }

  @override
  String get importPurchaseTapToMapLine => 'Tap to map this line';

  @override
  String get importPurchaseRetryFailedJob => 'Retry failed job';

  @override
  String get importPurchaseNoImportedItems => 'No imported items';

  @override
  String get importPurchaseNoImportedItemsHint =>
      'Nothing matches this status filter. Switch the filter or import a new batch.';

  @override
  String get importPurchaseSelectRowToEdit =>
      'Select a row below to edit its name, prices & variant';

  @override
  String get importPurchaseEditing => 'Editing';

  @override
  String get importPurchaseItemName => 'Item name';

  @override
  String get importPurchaseEnterName => 'Enter a name';

  @override
  String get importPurchaseEnterSupplyPrice => 'Enter supply price';

  @override
  String get importPurchaseEnterRetailPrice => 'Enter retail price';

  @override
  String get importPurchaseVariant => 'Variant';

  @override
  String get importPurchaseSaveChanges => 'Save Changes';

  @override
  String get importPurchaseHsCode => 'HS code';

  @override
  String get importPurchaseColStatus => 'Status';

  @override
  String get importPurchaseSupplier => 'Supplier';

  @override
  String get importPurchaseDate => 'Date';

  @override
  String importPurchaseVariantTag(String name) {
    return 'Variant · $name';
  }

  @override
  String get importPurchaseNoVariantAssigned => 'No variant assigned';

  @override
  String get importPurchaseEditItem => 'Edit item';

  @override
  String get importPurchaseMapVariant => 'Map variant';

  @override
  String get importPurchaseNewVariant => 'New variant';

  @override
  String get importPurchaseTabImport => 'Import';

  @override
  String get importPurchasePurchase => 'Purchase';

  @override
  String get importPurchaseImports => 'Imports';

  @override
  String get importPurchaseSelectVariant => 'Select Variant';

  @override
  String get importPurchaseSearchVariants => 'Search variants…';

  @override
  String get importPurchaseFailedToLoadVariants => 'Failed to load variants';

  @override
  String get importPurchaseNameRequired => 'Name is required';

  @override
  String get importPurchaseSetBothPrices =>
      'Please set both retail and supply prices';

  @override
  String get importPurchaseSelectExistingVariant =>
      'Select an existing variant';

  @override
  String get importPurchaseMappedToExisting => 'Mapped to existing variant';

  @override
  String importPurchaseCreatedVariantWithCode(String code) {
    return 'Created variant · $code';
  }

  @override
  String get importPurchaseCreatedVariant => 'Created variant';

  @override
  String importPurchaseCouldNotCreateVariant(String error) {
    return 'Could not create variant: $error';
  }

  @override
  String importPurchaseLinesNeedMapping(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lines still need mapping',
      one: '1 line still needs mapping',
    );
    return '$_temp0';
  }

  @override
  String get importPurchasePurchaseAccepted => 'Purchase accepted';

  @override
  String get importPurchasePurchaseDeclined => 'Purchase declined';

  @override
  String importPurchaseCouldNotAccept(String error) {
    return 'Could not accept purchase: $error';
  }

  @override
  String importPurchaseCouldNotDecline(String error) {
    return 'Could not decline purchase: $error';
  }

  @override
  String importPurchaseApprovedItem(String name) {
    return 'Approved \"$name\"';
  }

  @override
  String importPurchaseRejectedItem(String name) {
    return 'Rejected \"$name\"';
  }

  @override
  String get importPurchaseRetrySucceeded => 'Retry succeeded';

  @override
  String importPurchaseCouldNotUpdateItem(String name, String error) {
    return 'Could not update \"$name\": $error';
  }

  @override
  String importPurchaseItemsNeedPrices(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count items need a supply and retail price, or a link to one of your products',
      one:
          '1 item needs a supply and retail price, or a link to one of your products',
    );
    return '$_temp0';
  }

  @override
  String importPurchaseApproveItemsTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Approve $count items?',
      one: 'Approve 1 item?',
    );
    return '$_temp0';
  }

  @override
  String get importPurchaseApproveAllBody =>
      'Their quantities are added to your stock and reported to RRA.';

  @override
  String get importPurchaseApproveAll => 'Approve all';

  @override
  String importPurchaseApprovedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Approved $count items',
      one: 'Approved 1 item',
    );
    return '$_temp0';
  }

  @override
  String importPurchaseCouldNotApproveAll(String error) {
    return 'Could not approve all: $error';
  }

  @override
  String get importPurchaseCouldNotLoadImports => 'Could not load imports';

  @override
  String get importPurchaseNoImportsWaiting => 'No imports waiting';

  @override
  String get importPurchaseNoImportsHere => 'No imports here';

  @override
  String get importPurchaseFetchCustomsHint =>
      'Tap ⟳ to fetch your customs declarations from RRA.';

  @override
  String importPurchaseApproveAllWaiting(int count) {
    return 'Approve all $count waiting';
  }

  @override
  String importPurchaseFromOrigin(String origin) {
    return 'from $origin';
  }

  @override
  String importPurchaseCostSellsAt(String cost, String price) {
    return 'Cost $cost · sells at $price';
  }

  @override
  String get importPurchaseSetPricesBeforeApproving =>
      'Set prices before approving';

  @override
  String get importPurchaseWorking => 'Working…';

  @override
  String get importPurchaseFailedTapToRetry => 'Failed · tap to retry';

  @override
  String importPurchaseAddsTo(String name) {
    return 'Adds to $name';
  }

  @override
  String get importPurchaseNewProduct => 'New product';

  @override
  String get importPurchaseEnterBothPrices =>
      'Enter both prices, or link a product you sell';

  @override
  String get importPurchaseOrigin => 'Origin';

  @override
  String get importPurchaseDeclaration => 'Declaration';

  @override
  String get importPurchaseNameInYourShop => 'Name in your shop';

  @override
  String get importPurchaseCreateAsNewProduct => 'Create as a new product';

  @override
  String get importPurchaseLinkProductHint =>
      'Or tap to add this stock to a product you sell';

  @override
  String get importPurchaseStockAddedToProduct =>
      'Stock will be added to this product';

  @override
  String get importPurchaseUnlink => 'Unlink';

  @override
  String get importPurchaseRetryWithPrevious => 'Retry with previous values';

  @override
  String get importPurchaseReject => 'Reject';

  @override
  String get importPurchaseApprove => 'Approve';

  @override
  String get importPurchaseSaveForLater => 'Save for later';

  @override
  String get importPurchaseSearchYourProducts => 'Search your products';

  @override
  String get importPurchaseTypeProductName => 'Type a product name';

  @override
  String get importPurchaseNoProductMatches => 'No product matches';

  @override
  String importPurchaseSellsAt(String price) {
    return 'Sells at $price';
  }

  @override
  String importPurchaseSyncFailed(String error) {
    return 'Sync failed: $error';
  }

  @override
  String get importPurchaseRecordPurchase => 'Record purchase';

  @override
  String get importPurchaseRecordPurchaseSubtitle =>
      'Capture a supplier invoice and its line items';

  @override
  String get importPurchaseFetchingInvoices => 'Fetching invoices from RRA…';

  @override
  String importPurchaseSyncedWithRra(String time) {
    return 'Synced with RRA $time';
  }

  @override
  String get importPurchasePullToRefreshHint =>
      'Pull down to refresh · tap ⟳ to fetch from RRA';

  @override
  String get importPurchaseFetchFromRra => 'Fetch from RRA';

  @override
  String get importPurchaseCouldNotLoadPurchases => 'Could not load purchases';

  @override
  String get importPurchaseNothingWaiting => 'Nothing waiting for approval';

  @override
  String get importPurchaseNoPurchasesHere => 'No purchases here';

  @override
  String get importPurchaseNoPurchasesHint =>
      'Record a purchase, or fetch your supplier invoices from RRA.';

  @override
  String get importPurchaseRecorded => 'Recorded';

  @override
  String get importPurchaseFromRra => 'From RRA';

  @override
  String get importPurchaseOnCredit => 'On credit';

  @override
  String importPurchaseItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String importPurchaseCardMeta(String number, String time, String items) {
    return 'Invoice $number · $time · $items';
  }

  @override
  String get importPurchaseDeclineTitle => 'Decline this purchase?';

  @override
  String importPurchaseDeclineBody(String number, String supplier) {
    return 'Invoice $number from $supplier will not be added to your stock.';
  }

  @override
  String get importPurchaseDecline => 'Decline';

  @override
  String get importPurchaseNotFound => 'Purchase not found';

  @override
  String get importPurchaseNotFoundHint =>
      'It may have moved to another status.';

  @override
  String importPurchaseInclVat(String amount) {
    return 'incl. VAT $amount';
  }

  @override
  String get importPurchasePaidWith => 'Paid with';

  @override
  String get importPurchaseSupplierTin => 'Supplier TIN';

  @override
  String importPurchaseItemsHeader(String count) {
    return 'Items · $count';
  }

  @override
  String get importPurchaseMatchItemsHint =>
      'Match each supplier item to one of yours before accepting, so stock lands on the right product.';

  @override
  String importPurchaseAcceptWithMatch(int count) {
    return 'Accept ($count to match)';
  }

  @override
  String get importPurchaseAccept => 'Accept';

  @override
  String get importPurchaseMatchedChange => 'Matched · change';

  @override
  String get importPurchaseMatchToMyItem => 'Match to my item';

  @override
  String bulkProductProductCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
    );
    return '$_temp0';
  }

  @override
  String get bulkProductRegisterViaServer => 'Register via server (RRA first)';

  @override
  String get bulkProductRegisterViaServerHint =>
      'Catalog is created in Ditto only after RRA succeeds. Turn off to use the previous on-device flow.';

  @override
  String get bulkProductSaveAll => 'Save All';

  @override
  String get bulkProductLoadingAllRows =>
      'Loading all rows from spreadsheet (save disabled until done)…';

  @override
  String get bulkProductParsingSpreadsheet => 'Parsing spreadsheet…';

  @override
  String bulkProductProgressCount(
    String percent,
    String current,
    String total,
  ) {
    return '$percent · $current of $total';
  }

  @override
  String get bulkProductSaving => 'Saving…';

  @override
  String bulkProductRowsMissingName(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rows missing a name',
      one: '1 row missing a name',
    );
    return '$_temp0';
  }

  @override
  String bulkProductDuplicateBarcodes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count duplicate barcodes',
      one: '1 duplicate barcode',
    );
    return '$_temp0';
  }

  @override
  String get bulkProductSavingProducts => 'Saving products';

  @override
  String bulkProductCurrentOfTotal(String current, String total) {
    return '$current of $total';
  }

  @override
  String get bulkProductPleaseWait => 'Please wait…';

  @override
  String get bulkProductHideSaveContinues => 'Hide · save continues';

  @override
  String get bulkProductProgressStaysOnBar =>
      'Progress stays on the bar above the grid.';

  @override
  String bulkProductLargeImportBanner(String count) {
    return 'Large import: you can edit prices and options for each page ($count products). Use the arrows below the grid to load the next or previous 20 rows.';
  }

  @override
  String get bulkProductColBarcode => 'Barcode';

  @override
  String get bulkProductColSupplyPrice => 'Supply Price';

  @override
  String get bulkProductColItemClass => 'Item Class';

  @override
  String get bulkProductColTax => 'Tax';

  @override
  String get bulkProductColType => 'Type';

  @override
  String bulkProductPageStatus(
    String page,
    String pages,
    String start,
    String end,
    String total,
    String visible,
  ) {
    return 'Page $page of $pages — editing rows $start–$end of $total ($visible on screen)';
  }

  @override
  String get bulkProductPreviousPage => 'Previous page';

  @override
  String get bulkProductNextPage => 'Next page';

  @override
  String bulkProductShowingRows(String count) {
    return 'Showing $count rows';
  }

  @override
  String get bulkProductRemoveRow => 'Remove row';

  @override
  String get bulkProductNoDataToSave => 'No data to save';

  @override
  String bulkProductLoadingFullSpreadsheet(String count) {
    return 'Loading full spreadsheet (~$count rows)…';
  }

  @override
  String get bulkProductCouldNotLoadSpreadsheet =>
      'Could not load spreadsheet. Use Change to pick another file.';

  @override
  String get bulkProductUploadToPreview =>
      'Upload an Excel file to preview products';

  @override
  String get bulkProductNoRowsInFile =>
      'No rows in file — upload another spreadsheet or add rows in Excel.';

  @override
  String bulkProductLargeImportLoading(String count) {
    return 'Large import (~$count products, loading full file…) — Save stays disabled until loading finishes.';
  }

  @override
  String bulkProductLargeImportTitle(String count) {
    return 'Large import ($count products)';
  }

  @override
  String get bulkProductPreviewLoadingHint =>
      'Showing a quick preview while all rows load. Row removal is disabled until the full file is ready.';

  @override
  String get bulkProductPreviewReadyHint =>
      'You can remove rows from the preview below. When the full file is ready, you will get the same editable grid as small imports, 20 products per page.';

  @override
  String bulkProductPreviewFirstOf(String count, String total) {
    return 'Preview (first $count of $total)';
  }

  @override
  String get bulkProductNoName => '(no name)';

  @override
  String bulkProductBarcodePrice(String barcode, String price) {
    return 'Barcode: $barcode · Price: $price';
  }

  @override
  String get bulkProductAvailableAfterLoad =>
      'Available after the full file loads';

  @override
  String get bulkProductDropExcelHere => 'Drop your Excel file here';

  @override
  String get bulkProductClickToBrowse => 'or click to browse your files';

  @override
  String bulkProductProductsLoaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products loaded',
      one: '1 product loaded',
    );
    return '$_temp0';
  }

  @override
  String get bulkProductChange => 'Change';

  @override
  String get bulkProductSupportedFormats =>
      'Supported: .xlsx, .xls (save WPS as Excel .xlsx)';

  @override
  String get bulkProductDownloadTemplate => 'Download Template';

  @override
  String get bulkProductTypeRawMaterial => 'Raw Material';

  @override
  String get bulkProductTypeFinishedProduct => 'Finished Product';

  @override
  String get bulkProductTypeService => 'Service without stock';

  @override
  String get bulkProductLoading => 'Loading…';

  @override
  String get bulkProductSelectCategory => 'Select Category';

  @override
  String get bulkProductSearchCategory => 'Search category';

  @override
  String get bulkProductAddNewCategory => 'Add New Category';

  @override
  String get bulkProductSaveComplete => 'Bulk save complete';

  @override
  String get bulkProductSaveFailed => 'Bulk save failed';

  @override
  String get bulkProductStatTotal => 'Total';

  @override
  String get bulkProductStatSucceeded => 'Succeeded';

  @override
  String get bulkProductStatFailed => 'Failed';

  @override
  String get bulkProductTaxRegistrationSkipped =>
      'Tax registration was skipped for this branch.';

  @override
  String bulkProductJobId(String id) {
    return 'Job $id';
  }

  @override
  String get bulkProductStay => 'Stay';

  @override
  String get stockRecountTitle => 'Stock Recount';

  @override
  String get stockRecountNew => 'New recount';

  @override
  String get stockRecountStatusAll => 'All';

  @override
  String get stockRecountStatusDraft => 'Draft';

  @override
  String get stockRecountStatusSubmitted => 'Submitted';

  @override
  String get stockRecountStatusSynced => 'Synced';

  @override
  String get stockRecountBalanced => 'Balanced';

  @override
  String stockRecountNetValue(String value) {
    return '$value net';
  }

  @override
  String get stockRecountExporting => 'Exporting…';

  @override
  String get stockRecountExportPdf => 'Export PDF';

  @override
  String stockRecountStartFailed(String error) {
    return 'Could not start recount: $error';
  }

  @override
  String get stockRecountDeleteTitle => 'Delete recount?';

  @override
  String get stockRecountDeleteMessage =>
      'Delete this draft recount? This cannot be undone.';

  @override
  String get stockRecountDeleted => 'Recount deleted';

  @override
  String stockRecountDeleteFailed(String error) {
    return 'Delete failed: $error';
  }

  @override
  String stockRecountExportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get stockRecountSearchHint => 'Search device, note, or product…';

  @override
  String get stockRecountClearFilters => 'Clear filters';

  @override
  String get stockRecountStartNew => 'Start new recount';

  @override
  String get stockRecountFilter => 'Filter';

  @override
  String get stockRecountNothingMatches => 'Nothing matches';

  @override
  String get stockRecountNoRecountsYet => 'No recounts yet';

  @override
  String get stockRecountNothingMatchesHint =>
      'Try a different search term or filter to find the recount you’re after.';

  @override
  String get stockRecountEmptyHint =>
      'Start a new recount session to count physical stock against your system records.';

  @override
  String get stockRecountUnknownDevice => 'Unknown device';

  @override
  String stockRecountItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String stockRecountShortCount(String count) {
    return '$count short';
  }

  @override
  String stockRecountMatchingCount(String count) {
    return '$count matching';
  }

  @override
  String stockRecountSurplusCount(String count) {
    return '$count surplus';
  }

  @override
  String get stockRecountDeleteDraft => 'Delete draft';

  @override
  String stockRecountAlreadyInCount(String name) {
    return '$name is already in this count';
  }

  @override
  String stockRecountAddedToCount(String name) {
    return '$name added to the count';
  }

  @override
  String stockRecountAddItemFailed(String error) {
    return 'Could not add item: $error';
  }

  @override
  String stockRecountUpdateFailed(String error) {
    return 'Update failed: $error';
  }

  @override
  String get stockRecountItemRemoved => 'Item removed';

  @override
  String stockRecountRemoveFailed(String error) {
    return 'Remove failed: $error';
  }

  @override
  String get stockRecountUnknownBarcode => 'Unknown barcode';

  @override
  String stockRecountScanned(String name) {
    return 'Scanned $name — adjust the count if needed';
  }

  @override
  String get stockRecountSubmitTitle => 'Submit recount?';

  @override
  String get stockRecountSubmitMessage =>
      'This updates stock levels from your counted quantities.';

  @override
  String get stockRecountSubmitted => 'Recount submitted ✓';

  @override
  String stockRecountSubmitFailed(String error) {
    return 'Submit failed: $error';
  }

  @override
  String get stockRecountInfo =>
      'Count physical stock, compare variance, then submit to sync inventory.';

  @override
  String stockRecountLoadFailed(String error) {
    return 'Could not load recount: $error';
  }

  @override
  String get stockRecountNotFound => 'Recount not found';

  @override
  String get stockRecountCountedItems => 'Counted items';

  @override
  String stockRecountItemsNet(int count, String net) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0 · net $net';
  }

  @override
  String stockRecountNetItems(String net, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$net · $_temp0';
  }

  @override
  String get stockRecountDevice => 'Device';

  @override
  String stockRecountCreatedAt(String date) {
    return 'Created $date';
  }

  @override
  String get stockRecountNoteHint => 'Add a note for this recount session…';

  @override
  String get stockRecountNoNote => 'No note';

  @override
  String get stockRecountItemsCounted => 'Items counted';

  @override
  String get stockRecountMatching => 'Matching';

  @override
  String get stockRecountSurplus => 'Surplus';

  @override
  String get stockRecountShort => 'Short';

  @override
  String get stockRecountAddProduct => 'Add a product to count';

  @override
  String get stockRecountProductSearchHint =>
      'Search product name, SKU or barcode…';

  @override
  String stockRecountNoProductMatches(String query) {
    return 'No product matches \"$query\".';
  }

  @override
  String get stockRecountAdded => 'Added';

  @override
  String get stockRecountInSystem => 'in system';

  @override
  String stockRecountStagedLine(String sku, String qty) {
    return 'SKU $sku · $qty in system';
  }

  @override
  String stockRecountItemLine(String sku, String time) {
    return 'SKU $sku · counted $time';
  }

  @override
  String stockRecountShrinkageNote(String qty) {
    return 'Counted $qty fewer than the system shows — this will be recorded as shrinkage.';
  }

  @override
  String stockRecountSurplusNote(String qty) {
    return 'Counted $qty more than the system shows — a surplus will be recorded.';
  }

  @override
  String get stockRecountSystem => 'System';

  @override
  String get stockRecountCounted => 'Counted';

  @override
  String get stockRecountVariance => 'Variance';

  @override
  String get stockRecountEmptyItemsHint =>
      'Search for a product above, or scan a barcode, then enter the quantity you physically counted.';

  @override
  String get stockRecountNoCountedItems => 'This recount has no counted items.';

  @override
  String get stockRecountNetVariance => 'Net variance';

  @override
  String get stockRecountTotal => 'Recount total';

  @override
  String get stockRecountConfirmShortagesTitle =>
      'Confirm shortages before submitting';

  @override
  String stockRecountConfirmShortagesBody(int count, String net) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items counted',
      one: '1 item counted',
    );
    return '$_temp0 lower than the system — recording this submits a net variance of $net. Add a reason…';
  }

  @override
  String get stockRecountShortageReasonHint =>
      'Reason for shortage (e.g. damaged units, spoilage, theft)…';

  @override
  String get stockRecountKeepEditing => 'Keep editing';

  @override
  String get stockRecountConfirmSubmit => 'Confirm & submit';

  @override
  String get stockRecountPointCamera => 'Point camera at barcode';

  @override
  String get stockRecountPdfSubject => 'Stock Recount Report';

  @override
  String get stockRecountPdfSaveTitle => 'Save Stock Recount PDF';

  @override
  String stockRecountPdfReportNumber(String id) {
    return 'Report #$id';
  }

  @override
  String get stockRecountPdfNote => 'Note:';

  @override
  String stockRecountPdfCountedByName(String name) {
    return 'Counted by — $name';
  }

  @override
  String get stockRecountPdfApprovedBy => 'Approved by';

  @override
  String get stockRecountPdfFooter => 'Generated by Flipper · Stock Recount';

  @override
  String get stockRecountCountedBy => 'Counted by';

  @override
  String get stockRecountCreated => 'Created';

  @override
  String get stockRecountGenerated => 'Generated';

  @override
  String get stockRecountProduct => 'Product';

  @override
  String stockRecountPdfTotals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return 'Totals · $_temp0';
  }

  @override
  String get stockRecountFallbackAgent => 'Agent';

  @override
  String get stockRecountFallbackBranch => 'Branch';

  @override
  String get productionOutputTitle => 'Production Output';

  @override
  String get productionOutputNew => 'New';

  @override
  String get productionOutputNewOrder => 'New Order';

  @override
  String get productionOutputWorkOrders => 'Work Orders';

  @override
  String productionOutputItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get productionOutputLoadFailed => 'Couldn\'t load work orders';

  @override
  String get productionOutputCheckConnection =>
      'Check your connection and try again.';

  @override
  String get productionOutputNoWorkOrdersYet => 'No work orders yet';

  @override
  String get productionOutputNoWorkOrdersHint =>
      'Create a work order to start tracking production output.';

  @override
  String get productionOutputNewWorkOrder => 'New Work Order';

  @override
  String get productionOutputUnknownProduct => 'Unknown Product';

  @override
  String get productionOutputUnknown => 'Unknown';

  @override
  String get productionOutputPlanned => 'Planned';

  @override
  String get productionOutputActual => 'Actual';

  @override
  String get productionOutputVariance => 'Variance';

  @override
  String get productionOutputRecord => 'Record';

  @override
  String get productionOutputComplete => 'Complete';

  @override
  String get productionOutputStart => 'Start';

  @override
  String get productionOutputRecordFailed =>
      'Could not record output. Please try again.';

  @override
  String get productionOutputCompleteFailed =>
      'Could not complete this work order. Please try again.';

  @override
  String get productionOutputStartFailed =>
      'Could not start this work order. Please try again.';

  @override
  String get productionOutputCompleteTitle => 'Complete Work Order?';

  @override
  String productionOutputCompleteMessage(String name) {
    return 'Mark \"$name\" as completed?';
  }

  @override
  String get productionOutputStartTitle => 'Start Work Order?';

  @override
  String productionOutputStartMessage(String name) {
    return 'Begin production for \"$name\"?';
  }

  @override
  String get productionOutputRecordOutput => 'Record Output';

  @override
  String productionOutputProductLabel(String name) {
    return 'Product: $name';
  }

  @override
  String productionOutputTargetLabel(String quantity) {
    return 'Target: $quantity';
  }

  @override
  String get productionOutputActualQuantity => 'Actual Quantity';

  @override
  String get productionOutputReasonMachine => 'Machine';

  @override
  String get productionOutputReasonMachineDesc =>
      'Machine downtime or malfunction';

  @override
  String get productionOutputReasonMaterial => 'Material';

  @override
  String get productionOutputReasonMaterialDesc =>
      'Material shortage or quality issues';

  @override
  String get productionOutputReasonLabor => 'Labor';

  @override
  String get productionOutputReasonLaborDesc =>
      'Labor shortage or skill issues';

  @override
  String get productionOutputReasonQuality => 'Quality';

  @override
  String get productionOutputReasonQualityDesc => 'Quality control rejection';

  @override
  String get productionOutputReasonPlanning => 'Planning';

  @override
  String get productionOutputReasonPlanningDesc =>
      'Planning or scheduling issues';

  @override
  String get productionOutputReasonOther => 'Other';

  @override
  String get productionOutputReasonOtherDesc => 'Other reasons';

  @override
  String get productionOutputStatusPlanned => 'Planned';

  @override
  String get productionOutputStatusInProgress => 'In Progress';

  @override
  String get productionOutputStatusCompleted => 'Completed';

  @override
  String get productionOutputStatusCancelled => 'Cancelled';

  @override
  String get productionOutputRatingExcellent => 'Excellent';

  @override
  String get productionOutputRatingGood => 'Good';

  @override
  String get productionOutputRatingFair => 'Fair';

  @override
  String get productionOutputRatingPoor => 'Poor';

  @override
  String get productionOutputVarianceReason => 'Variance Reason';

  @override
  String get productionOutputVarianceReasonHint =>
      'Select the primary reason for production variance';

  @override
  String get productionOutputAdditionalNotes => 'Additional Notes';

  @override
  String get productionOutputVarianceNotesHint =>
      'Provide details about the variance...';

  @override
  String get productionOutputEditWorkOrder => 'Edit Work Order';

  @override
  String get productionOutputCreateWorkOrder => 'Create Work Order';

  @override
  String get productionOutputUpdateWorkOrder => 'Update Work Order';

  @override
  String get productionOutputFormSubtitle =>
      'Plan production output for your products';

  @override
  String get productionOutputProductMaterialRequired => 'Product/Material *';

  @override
  String get productionOutputSearchProduct => 'Search product';

  @override
  String get productionOutputSelectProduct => 'Please select a product';

  @override
  String get productionOutputNoProductsFound => 'No products found';

  @override
  String get productionOutputNoProductsHint =>
      'Try a different product name or SKU';

  @override
  String get productionOutputNotAvailable => 'N/A';

  @override
  String get productionOutputPlannedQuantityRequired => 'Planned Quantity *';

  @override
  String get productionOutputUnits => 'units';

  @override
  String get productionOutputRequired => 'Required';

  @override
  String get productionOutputTargetDateRequired => 'Target Date *';

  @override
  String get productionOutputTargetDate => 'Target Date';

  @override
  String get productionOutputShiftOptional => 'Shift (Optional)';

  @override
  String get productionOutputShiftMorning => 'Morning';

  @override
  String get productionOutputShiftAfternoon => 'Afternoon';

  @override
  String get productionOutputShiftNight => 'Night';

  @override
  String get productionOutputNotes => 'Notes';

  @override
  String get productionOutputNotesHint =>
      'Additional instructions or comments...';

  @override
  String get productionOutputSaveFailed =>
      'Could not save the work order. Please try again.';

  @override
  String get productionOutputChartTitle => 'Planned vs Actual Output';

  @override
  String productionOutputLastDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Last $count days',
      one: 'Last day',
    );
    return '$_temp0';
  }

  @override
  String get productionOutputVariancePercent => 'Variance %';

  @override
  String get productionOutputNoDataAvailable => 'No data available';

  @override
  String get productionOutputDayMon => 'Mon';

  @override
  String get productionOutputDayTue => 'Tue';

  @override
  String get productionOutputDayWed => 'Wed';

  @override
  String get productionOutputDayThu => 'Thu';

  @override
  String get productionOutputDayFri => 'Fri';

  @override
  String get productionOutputDaySat => 'Sat';

  @override
  String get productionOutputDaySun => 'Sun';

  @override
  String get productionOutputEfficiencyRate => 'Efficiency Rate';

  @override
  String get productionOutputCompletion => 'Completion';

  @override
  String get productionOutputCompletionRate => 'Completion Rate';

  @override
  String productionOutputCompletedOfTotal(String completed, String total) {
    return '$completed of $total';
  }

  @override
  String get productionOutputVarianceReasons => 'Variance Reasons';

  @override
  String get productionOutputNoData => 'No data';

  @override
  String get productionOutputOverview => 'Production Overview';

  @override
  String get productionOutputOrders => 'Orders';

  @override
  String get productionOutputStatusFilterLabel => 'Status:';

  @override
  String get productionOutputFilterAll => 'All';

  @override
  String get productionOutputProduct => 'Product';

  @override
  String get productionOutputStatus => 'Status';

  @override
  String get productionOutputNoWorkOrdersFound => 'No work orders found';

  @override
  String get productionOutputTableEmptyHint =>
      'Create a work order to start tracking production';

  @override
  String get incomingOrdersIncoming => 'Incoming';

  @override
  String get incomingOrdersOutgoing => 'Outgoing';

  @override
  String get incomingOrdersBranchNotFound => 'Branch not found';

  @override
  String get incomingOrdersBranchLoadFailed => 'Could not load active branch';

  @override
  String get incomingOrdersReceivedOrders => 'Received Orders';

  @override
  String get incomingOrdersSentOrders => 'Sent Orders';

  @override
  String get incomingOrdersErrorLoadingBranch => 'Error loading branch';

  @override
  String get incomingOrdersErrorLoadingRequests => 'Error loading requests';

  @override
  String get incomingOrdersTitle => 'Orders Management';

  @override
  String get incomingOrdersSubtitle =>
      'Track and manage incoming and outgoing orders';

  @override
  String get incomingOrdersPendingRequests => 'Pending Requests';

  @override
  String incomingOrdersNoRequests(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'pending': 'No pending requests',
      'approved': 'No approved requests',
      'processing': 'No requests in production',
      'voided': 'No voided requests',
      'rejected': 'No rejected requests',
      'other': 'No requests',
    });
    return '$_temp0';
  }

  @override
  String get incomingOrdersNothingToShow => 'Nothing to show here right now.';

  @override
  String get incomingOrdersTryAgain => 'Try Again';

  @override
  String incomingOrdersSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get incomingOrdersNoApprovePermission =>
      'You do not have permission to approve orders';

  @override
  String get incomingOrdersApprove => 'Approve';

  @override
  String get incomingOrdersReject => 'Reject';

  @override
  String get incomingOrdersItemsHeading => 'ITEMS';

  @override
  String get incomingOrdersNoItems => 'No items in this request';

  @override
  String incomingOrdersErrorLoadingItems(String error) {
    return 'Error loading items: $error';
  }

  @override
  String incomingOrdersUpdateItemFailed(String error) {
    return 'Failed to update item: $error';
  }

  @override
  String get incomingOrdersUpdateQtyLabel => 'Update Qty:';

  @override
  String get incomingOrdersRequestedLabel => 'Requested:';

  @override
  String get incomingOrdersApprovedLabel => 'Approved:';

  @override
  String get incomingOrdersUpdate => 'Update';

  @override
  String get incomingOrdersStatusDeliveryHeading => 'STATUS & DELIVERY';

  @override
  String get incomingOrdersStatus => 'Status';

  @override
  String get incomingOrdersRequestedOn => 'Requested On';

  @override
  String get incomingOrdersStatusPending => 'Pending';

  @override
  String get incomingOrdersStatusProcessing => 'Processing';

  @override
  String get incomingOrdersStatusPartiallyApproved => 'Partially Approved';

  @override
  String get incomingOrdersStatusRejected => 'Rejected';

  @override
  String get incomingOrdersStatusFulfilled => 'Fulfilled';

  @override
  String get incomingOrdersStatusVoided => 'Voided';

  @override
  String get incomingOrdersOrderNoteHeading => 'ORDER NOTE';

  @override
  String get incomingOrdersProduce => 'Produce';

  @override
  String get incomingOrdersVoid => 'Void';

  @override
  String get incomingOrdersFinishProduction => 'Finish Production';

  @override
  String get incomingOrdersInProduction => 'In Production';

  @override
  String get incomingOrdersApproveRequest => 'Approve Request';

  @override
  String get incomingOrdersApproveAllConfirm =>
      'Are you sure you want to approve all items in this request?';

  @override
  String get incomingOrdersApproveAll => 'Approve All';

  @override
  String get incomingOrdersVoidRequest => 'Void Request';

  @override
  String get incomingOrdersVoidConfirm =>
      'Are you sure you want to void this request?';

  @override
  String incomingOrdersDeclinedSms(String reference) {
    return 'Your stock request #$reference has been declined.';
  }

  @override
  String get incomingOrdersVoidSuccess => 'Request voided successfully';

  @override
  String incomingOrdersVoidFailed(String error) {
    return 'Failed to void request: $error';
  }

  @override
  String get incomingOrdersProductionFinished =>
      'Production marked as finished. Ready for approval.';

  @override
  String get incomingOrdersFinishProductionFailed =>
      'Failed to finish production';

  @override
  String get incomingOrdersUnknown => 'Unknown';

  @override
  String get incomingOrdersFromLabel => 'From:';

  @override
  String get incomingOrdersToLabel => 'To:';

  @override
  String incomingOrdersRequestFrom(String branch) {
    return 'Request From $branch';
  }

  @override
  String incomingOrdersLineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '($count items)',
      one: '(1 item)',
    );
    return '$_temp0';
  }

  @override
  String incomingOrdersQtyItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Items',
      one: '1 Item',
    );
    return '$_temp0';
  }

  @override
  String incomingOrdersQtyRatio(int requested, String approved) {
    String _temp0 = intl.Intl.pluralLogic(
      requested,
      locale: localeName,
      other: '$requested Items',
      one: '1 Item',
    );
    return '$approved/$_temp0';
  }

  @override
  String get failedPaymentCardEmailRequired =>
      'An email is required for the card receipt';

  @override
  String get failedPaymentEnterValidEmail => 'Enter a valid email address';

  @override
  String get failedPaymentPhoneMustStartWith250 =>
      'Phone number must start with 250';

  @override
  String get failedPaymentPhoneMustBe12Digits =>
      'Phone number must be 12 digits';

  @override
  String get failedPaymentPhoneCannotExceed12Digits =>
      'Phone number cannot exceed 12 digits';

  @override
  String get failedPaymentInvalidMtnPrefix =>
      'Invalid MTN number prefix (must start with 78 or 79)';

  @override
  String get failedPaymentLoadingTookTooLong =>
      'Loading took too long. Check your connection, refresh the page, or try again.';

  @override
  String failedPaymentErrorLoadingPlanDetails(String error) {
    return 'Error loading plan details: $error';
  }

  @override
  String get failedPaymentFailedTryAgain => 'Payment failed, try again';

  @override
  String get failedPaymentFailedToValidateCode => 'Failed to validate code';

  @override
  String get failedPaymentLoadingDetails => 'Loading payment details…';

  @override
  String get failedPaymentIssueTitle => 'Payment Issue';

  @override
  String get failedPaymentCompleteOnCardPage =>
      'Complete Payment on the Card Page';

  @override
  String get failedPaymentCompleteOnPhone => 'Complete Payment on Your Phone';

  @override
  String get failedPaymentCardWaitingBody =>
      'Enter your card details on the page that opened.\nThis screen updates on its own once the payment goes through.';

  @override
  String get failedPaymentMomoWaitingBody =>
      'A payment request has been sent to your MTN Mobile Money.\nOpen your phone and approve the transaction.';

  @override
  String get failedPaymentReopenPage => 'Reopen payment page';

  @override
  String get failedPaymentNotNowBackToOptions =>
      'Not now — back to payment options';

  @override
  String get failedPaymentNeedsAttention => 'Payment Needs Attention';

  @override
  String get failedPaymentNeedsAttentionBody =>
      'Don\'t worry, this happens sometimes.\nLet\'s get you sorted out quickly.';

  @override
  String get failedPaymentSwitchOrUpgradePlan => 'Switch or upgrade plan';

  @override
  String get failedPaymentTapToCollapse => 'Tap to collapse';

  @override
  String get failedPaymentChooseDifferentPlan =>
      'Choose a different plan before retrying';

  @override
  String get failedPaymentPlanStillActive =>
      'Your plan is still active. You can upgrade or switch plans below. The new plan will apply from your next billing cycle.';

  @override
  String get failedPaymentEnterpriseServices => 'Enterprise Services';

  @override
  String get failedPaymentAdditionalServices => 'Additional Services';

  @override
  String get failedPaymentNewPlanTotal => 'New plan total';

  @override
  String get failedPaymentCouldNotOpenPage =>
      'Could not open the payment page on this device. Try Mobile Money, or finish the payment on a phone or computer with a browser.';

  @override
  String get failedPaymentSubscriptionEnded =>
      'This subscription has ended. Pick a plan above to start again.';

  @override
  String get failedPaymentPageNotReady =>
      'The payment page is not ready yet. Try again in a moment.';

  @override
  String get failedPaymentCouldNotOpenCardPage =>
      'Could not open the card payment page on this device. Use the link below, or pay with Mobile Money.';

  @override
  String failedPaymentCardNotStartedWithError(String error) {
    return 'Card payment could not be started: $error';
  }

  @override
  String get failedPaymentCardNotStarted =>
      'Card payment could not be started.';

  @override
  String get failedPaymentCardNotThrough =>
      'The card payment has not come through. Try again, or use Mobile Money.';

  @override
  String get failedPaymentPayByCard => 'Pay by card';

  @override
  String get failedPaymentTryAgain => 'Try Again';

  @override
  String get failedPaymentOpening => 'Opening…';

  @override
  String get failedPaymentRetrying => 'Retrying…';

  @override
  String get failedPaymentTimeout => 'Payment timeout. Please try again.';

  @override
  String get failedPaymentNothingChargedApprove =>
      'Nothing was charged. Approve the Mobile Money request on your phone, then try again.';

  @override
  String failedPaymentFailedWithError(String error) {
    return 'Payment failed: $error';
  }

  @override
  String get failedPaymentFailedTryAgainShort => 'Payment failed. Try again.';

  @override
  String get failedPaymentFailedAgainTryDifferent =>
      'Payment failed again. Try a different MTN number or plan.';

  @override
  String get failedPaymentMaxSkipReached =>
      'Maximum skip limit reached. Please complete payment to continue.';

  @override
  String failedPaymentSkipsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You can skip $count more times',
      one: 'You can skip 1 more time',
    );
    return '$_temp0';
  }

  @override
  String get failedPaymentSkipForNow => 'Skip for Now';

  @override
  String get failedPaymentSkipLimitReached => 'Skip Limit Reached';

  @override
  String get failedPaymentTotal => 'Total';

  @override
  String get failedPaymentPlan => 'Plan';

  @override
  String get dashboardNotApplicable => 'N/A';

  @override
  String failedPaymentDiscountWithCode(String code) {
    return 'Discount ($code)';
  }

  @override
  String get failedPaymentBilling => 'Billing';

  @override
  String get failedPaymentAdditionalDevices => 'Additional Devices';

  @override
  String get failedPaymentEnterMtnNumber =>
      'Please enter your MTN phone number.';

  @override
  String get failedPaymentPhoneRequiredForMomo =>
      'Phone number is required for MTN Mobile Money. Please enable \"Use different phone number\" and enter your MTN number.';

  @override
  String failedPaymentReasonNothingCharged(String reason) {
    return '$reason Nothing was charged — try again.';
  }

  @override
  String get failedPaymentDeclinedNothingCharged =>
      'The payment was declined. Nothing was charged — try again.';

  @override
  String paymentFinalizeListenerError(String error) {
    return 'Error setting up listener: $error';
  }

  @override
  String get paymentFinalizeSubscriptionEnded =>
      'This subscription has ended. Choose a plan to start again.';

  @override
  String get paymentFinalizeReusedCheckout =>
      'You already had a payment page open for this plan — we reopened it rather than starting a second subscription.';

  @override
  String get paymentFinalizeNotSeenYet =>
      'We have not seen the payment yet. Finish it on the payment page, then tap \"I have paid\".';

  @override
  String get paymentFinalizeDidNotGoThrough =>
      'That payment did not go through. Choose a plan to start again.';

  @override
  String get paymentFinalizeNotArrivedYet =>
      'The payment has not arrived yet. It can take a moment after you finish on the payment page.';

  @override
  String paymentFinalizeCouldNotCheck(String error) {
    return 'Could not check the payment just now: $error';
  }

  @override
  String get paymentFinalizeWaitingForCard => 'Waiting for your card payment';

  @override
  String get paymentFinalizeFinishOnPage =>
      'Finish the payment on the page that opened. This screen updates on its own once it goes through.';

  @override
  String get paymentFinalizeCompletePayment => 'Complete Payment';

  @override
  String get paymentFinalizeCardPayment => 'Card Payment';

  @override
  String get paymentFinalizeMomoPayment => 'MTN Mobile Money Payment';

  @override
  String get paymentFinalizeProcessedByCard =>
      'Payment will be processed by card on a secure payment page';

  @override
  String get paymentFinalizeProcessedByMomo =>
      'Payment will be processed using MTN Mobile Money';

  @override
  String get paymentFinalizePlanSummary => 'Plan Summary';

  @override
  String get paymentFinalizeUseDifferentPhone => 'Use different phone number';

  @override
  String get paymentFinalizeSpecifyDifferentNumber =>
      'Specify a different number for payment';

  @override
  String get paymentFinalizeMtnPhoneNumber => 'MTN Phone Number';

  @override
  String get paymentFinalizeMtnPhoneHelper =>
      'Must start with 250 78 or 250 79';

  @override
  String get paymentFinalizeIHavePaid => 'I have paid — check now';

  @override
  String get paymentFinalizeContinueToPage => 'Continue to payment page';

  @override
  String get paymentFinalizeUseDifferentMethod =>
      'Use a different payment method';

  @override
  String paymentFinalizeApproveMomo(String message) {
    return '$message Approve the Mobile Money request on your phone, then try again.';
  }

  @override
  String paymentFinalizeFailedToInitiate(String error) {
    return 'Failed to initiate payment: $error';
  }

  @override
  String get paymentPlanNoPlansAvailable =>
      'No subscription plans are available.';

  @override
  String get paymentPlanCouldNotLoadPlans =>
      'Could not load subscription plans. Please try again.';

  @override
  String get paymentPlanErrorOccurred => 'An error occurred. Please try again.';

  @override
  String get paymentPlanSelectTitle => 'Select the plan that works for you';

  @override
  String paymentPlanSelectSubtitle(String percent) {
    return 'Switch between plans anytime. Yearly billing saves you $percent%.';
  }

  @override
  String get paymentPlanProceedToPayment => 'Proceed to Payment';

  @override
  String get paymentPlanSettingUp => 'Setting up your plan…';

  @override
  String get paymentPlanLoadingPlans => 'Loading plans…';

  @override
  String get paymentPlanTitle => 'Payment Plan';

  @override
  String get manualPurchasePaidExceedsTotal =>
      'The amount paid now cannot be more than the purchase total.';

  @override
  String get manualPurchaseRequiredFields =>
      'Supplier, a numeric invoice number and at least one line with quantity above zero are required.';

  @override
  String get manualPurchaseTaxVat18 => 'VAT 18%';

  @override
  String get manualPurchaseTaxExempt => 'Exempt';

  @override
  String get manualPurchaseTaxZeroRated => 'Zero-rated';

  @override
  String get manualPurchaseTaxNonVat => 'Non-VAT';

  @override
  String get manualPurchasePaySupplierBy => 'Pay supplier by';

  @override
  String get manualPurchaseRecordPurchase => 'Record purchase';

  @override
  String get manualPurchaseSupplier => 'Supplier';

  @override
  String get manualPurchaseChooseSupplier => 'Choose supplier';

  @override
  String get manualPurchaseTinOptional => 'TIN (optional)';

  @override
  String get manualPurchaseTinMustBe9Digits => 'TIN must be 9 digits';

  @override
  String get manualPurchaseInvoiceNumber => 'Invoice number';

  @override
  String get manualPurchaseNextInvoiceHint =>
      'Next number after your last invoice';

  @override
  String get manualPurchaseEnterInvoiceNumber => 'Enter the invoice number';

  @override
  String get manualPurchasePurchaseDate => 'Purchase date';

  @override
  String get manualPurchaseHowDidYouPay => 'How did you pay?';

  @override
  String get manualPurchasePaidNow => 'Paid now';

  @override
  String get manualPurchaseItemsEmptyHint =>
      'Add what you bought from your catalog, or type a new item.';

  @override
  String get manualPurchaseFromCatalog => 'From catalog';

  @override
  String get manualPurchaseNewItem => 'New item';

  @override
  String get manualPurchaseYouWillOwe => 'You will owe this supplier';

  @override
  String get manualPurchaseUnnamedItem => 'Unnamed item';

  @override
  String get manualPurchaseSummary => 'Summary';

  @override
  String get manualPurchaseTaxableVat18 => 'Taxable (VAT 18%)';

  @override
  String get manualPurchaseVatIncluded => 'VAT included';

  @override
  String get manualPurchaseExemptZeroRated => 'Exempt / zero-rated';

  @override
  String get manualPurchaseSaveAsWaiting => 'Save as waiting';

  @override
  String manualPurchaseApproveWithTotal(String total) {
    return 'Approve · $total';
  }

  @override
  String get manualPurchaseSaveAndApprove => 'Save & approve';

  @override
  String get manualPurchaseSearchSuppliers => 'Search suppliers';

  @override
  String get manualPurchaseNewSupplier => 'New supplier';

  @override
  String manualPurchaseAddNamed(String name) {
    return 'Add \"$name\"';
  }

  @override
  String get manualPurchaseNewSupplierHint =>
      'Save a supplier you have not used before';

  @override
  String get manualPurchaseNoSuppliersYet => 'No suppliers yet';

  @override
  String manualPurchaseNoSupplierMatches(String query) {
    return 'No supplier matches \"$query\"';
  }

  @override
  String manualPurchaseTinValue(String tin) {
    return 'TIN $tin';
  }

  @override
  String get manualPurchaseFromYourInvoices => 'From your invoices';

  @override
  String get manualPurchaseSearchCatalog => 'Search your catalog';

  @override
  String get manualPurchaseTypeProductName => 'Type a product name';

  @override
  String manualPurchaseNoProductMatches(String query) {
    return 'No product matches \"$query\"';
  }

  @override
  String manualPurchaseCostValue(String amount) {
    return 'Cost $amount';
  }

  @override
  String get manualPurchaseEditItem => 'Edit item';

  @override
  String get manualPurchaseItemName => 'Item name';

  @override
  String get manualPurchaseEnterItemName => 'Enter the item name';

  @override
  String get manualPurchaseMoreThanZero => 'More than 0';

  @override
  String get manualPurchaseUnitCost => 'Unit cost';

  @override
  String get manualPurchaseTax => 'Tax';

  @override
  String get manualPurchaseLineTotal => 'Line total';

  @override
  String get manualPurchaseAddItem => 'Add item';

  @override
  String get manualPurchaseSupplierRequired => 'Supplier is required';

  @override
  String get manualPurchaseSupplierTin => 'Supplier TIN';

  @override
  String get manualPurchaseOptionalSuffix => '(optional)';

  @override
  String manualPurchaseExampleValue(String example) {
    return 'e.g. $example';
  }

  @override
  String get manualPurchaseInvoiceNo => 'Invoice No.';

  @override
  String get manualPurchaseNumericInvoiceRequired =>
      'Numeric invoice number is required';

  @override
  String get manualPurchasePaymentType => 'Payment type';

  @override
  String get manualPurchaseNoneFullCredit => '(none — full credit)';

  @override
  String get manualPurchaseYouWillOweLabel => 'You will owe';

  @override
  String get manualPurchaseLineItems => 'Line items';

  @override
  String get manualPurchaseAddFromCatalog => 'Add from catalog';

  @override
  String get manualPurchaseSearchCatalogEllipsis => 'Search catalog…';

  @override
  String manualPurchaseSupplyAndTax(String price, String tax) {
    return 'Supply: $price · Tax: $tax';
  }

  @override
  String get manualPurchaseNoItemsHint =>
      'No items yet — add from your catalog or create a new line.';

  @override
  String get manualPurchaseQty => 'Qty';

  @override
  String get manualPurchaseTaxable => 'Taxable';

  @override
  String get manualPurchaseExemptZero => 'Exempt / zero';

  @override
  String get manualPurchaseRequired => 'Required';

  @override
  String get manualPurchaseNewBadge => 'new';

  @override
  String get manualPurchaseDuplicateInvoice => 'Duplicate invoice';

  @override
  String get manualPurchaseDuplicateInvoiceBody =>
      'A purchase with this invoice number already exists for this branch. Save anyway?';

  @override
  String get manualPurchaseSaveAnyway => 'Save anyway';

  @override
  String get manualPurchaseRecordedApproved => 'Purchase recorded and approved';

  @override
  String manualPurchaseApprovalFailed(String error) {
    return 'Purchase saved as waiting. Approval failed: $error';
  }

  @override
  String get manualPurchaseSavedAsWaiting => 'Purchase saved as waiting';

  @override
  String get manualPurchaseNewSupplierSubtitle =>
      'Created without leaving this purchase';

  @override
  String get manualPurchaseSupplierName => 'Supplier name';

  @override
  String get manualPurchasePhoneOptional => 'Phone (optional)';

  @override
  String get manualPurchaseCreateAndSelect => 'Create & select';

  @override
  String get manualPurchaseNoMatchingSuppliers => 'No matching suppliers';

  @override
  String get manualPurchaseCreateNewSupplier => 'Create a new supplier';

  @override
  String get manualPurchaseSearchOrEnterSupplier =>
      'Search or enter supplier name';

  @override
  String get manualPurchaseBackToImport => 'Back to Import & Purchase';

  @override
  String get manualPurchasePageSubtitle =>
      'Capture a supplier invoice and its line items';

  @override
  String get reportStatusParked => 'Parked';

  @override
  String get reportStatusCompleted => 'Completed';

  @override
  String get reportStatusCancelled => 'Cancelled';

  @override
  String get reportStatusPending => 'Pending';

  @override
  String get reportView => 'View';

  @override
  String get reportPrint => 'Print';

  @override
  String get reportReceiptNo => 'Receipt No.';

  @override
  String get reportCashier => 'Cashier';

  @override
  String get reportType => 'Type';

  @override
  String get reportStatus => 'Status';

  @override
  String get reportSaleTotal => 'Sale total';

  @override
  String get reportByHand => 'By hand';

  @override
  String get reportBalanceDue => 'Balance due';

  @override
  String get reportItemCode => 'Item Code';

  @override
  String get reportBarcode => 'Barcode';

  @override
  String get reportTaxRate => 'Tax Rate';

  @override
  String get reportProfitMade => 'Profit made';

  @override
  String get reportSupplyAmount => 'Supply amount';

  @override
  String get reportTaxPayable => 'Tax payable';

  @override
  String get reportNetProfit => 'Net Profit';

  @override
  String get reportTotalSales => 'Total Sales';

  @override
  String get reportPeriodByHand => 'Period — By Hand';

  @override
  String get reportPeriodCredit => 'Period — Credit';

  @override
  String reportStockCountUpdated(String product) {
    return 'Stock count updated successfully for $product';
  }

  @override
  String reportStockCountUpdateFailed(String error) {
    return 'Failed to update stock count: $error';
  }

  @override
  String get reportDismiss => 'Dismiss';

  @override
  String get reportTotalStockUnits => 'Total stock (units):';

  @override
  String get reportTotalSalesLines => 'Total sales (lines):';

  @override
  String get reportTotalSalesLabel => 'Total sales:';

  @override
  String reportTransactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
    );
    return '$_temp0';
  }

  @override
  String get reportTitleReport => 'Report';

  @override
  String get reportTitleStockRecount => 'Stock Recount';

  @override
  String get reportTotalGrossProfit => 'Total Gross Profit';

  @override
  String get reportClosingBalance => 'Closing balance';

  @override
  String reportStockRecountFor(String item) {
    return 'Stock Recount #$item';
  }

  @override
  String get reportNewCount => 'New Count';

  @override
  String get reportPleaseEnterNumber => 'Please enter a number';

  @override
  String get reportSummarized => 'Summarized';

  @override
  String get reportDetailed => 'Detailed';

  @override
  String get reportZReport => 'Z Report';

  @override
  String get reportXReport => 'X Report';

  @override
  String get reportSaleReport => 'Sale Report';

  @override
  String get reportPluReport => 'PLU Report';

  @override
  String get reportGrossProfit => 'Gross Profit';

  @override
  String get reportStartDate => 'Start Date';

  @override
  String get reportEndDate => 'End Date';

  @override
  String get reportTaxAmount => 'Tax Amount';

  @override
  String get reportPaymentType => 'Payment Type';

  @override
  String get reportSaleAmount => 'Sale amount';

  @override
  String get reportTransactionCount => 'Transaction Count';

  @override
  String get reportPercentOfTotal => '% of Total';

  @override
  String get reportExpense => 'Expense';

  @override
  String get reportTotalExpenses => 'Total Expenses';

  @override
  String reportLabelWithColon(String label) {
    return '$label:';
  }

  @override
  String get reportSavePdfFile => 'Save PDF file';

  @override
  String reportDownloadSubject(String date) {
    return 'Report Download - $date';
  }

  @override
  String get reportBusinessFallback => 'Business';

  @override
  String get reportPoweredByFlipper => 'Powered by Flipper';

  @override
  String reportGeneratedAt(String date) {
    return 'Generated: $date';
  }

  @override
  String get reportUnknownExpense => 'Unknown Expense';

  @override
  String get reportPdfExportNeedsGrid =>
      'PDF export needs the full report screen with a data grid. Disable PDF export in settings to export Excel from here, or use Reports on desktop.';

  @override
  String get reportDate => 'Date';

  @override
  String get reportPaymentMethod => 'Payment Method';

  @override
  String get reportWalkInCustomer => 'Walk-in Customer';

  @override
  String get reportStatusUnknown => 'Unknown';

  @override
  String get reportImportsReport => 'Imports Report';

  @override
  String get reportPurchasesReport => 'Purchases Report';

  @override
  String reportDateValue(String date) {
    return 'Date: $date';
  }

  @override
  String get reportRequestDate => 'Request Date';

  @override
  String get reportDeclarationNumber => 'Declaration Number';

  @override
  String get reportQuantityUnitCode => 'Quantity Unit Code';

  @override
  String get reportAgentName => 'Agent name';

  @override
  String get reportInvoiceForeignAmount => 'Invoice Foreign\nCurrency Amount';

  @override
  String get reportForeignCurrency => 'Foreign\nCurrency';

  @override
  String get reportSalesReport => 'Sales Report';

  @override
  String reportPeriodRange(String end, String start) {
    return 'Report Period: $start - $end';
  }

  @override
  String get reportTotalRevenue => 'Total Revenue';

  @override
  String get reportTotalVat => 'Total VAT';

  @override
  String get reportTotalTransactions => 'Total Transactions';

  @override
  String get reportAvgTransaction => 'Avg. Transaction';

  @override
  String get reportBuyerTin => 'Buyer TIN';

  @override
  String get reportBuyerName => 'Buyer Name';

  @override
  String get reportReceiptNumberShort => 'Receipt #';

  @override
  String get reportItemsDetails => 'Items Details';

  @override
  String get reportIndividual => 'Individual';

  @override
  String reportSaleItemLine(
    String name,
    String price,
    String qty,
    String total,
  ) {
    return '$name\n  Qty: $qty × $price\n  Total: $total';
  }

  @override
  String get reportStandard => 'Standard';

  @override
  String get branchTransferSelectDifferentBranch =>
      'Select a different destination branch';

  @override
  String branchTransferItemMissingVariant(String name) {
    return 'Item $name is missing a product variant';
  }

  @override
  String get branchTransferCreatedNotLoaded =>
      'Transfer was created but could not be loaded';

  @override
  String get branchTransferApprovalIncomplete =>
      'Transfer was created but approval did not complete; it remains pending for review';

  @override
  String branchTransferSmsReceived(int count, String requestId) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Stock transfer: $count items received from another branch (#$requestId).',
      one: 'Stock transfer: 1 item received from another branch (#$requestId).',
    );
    return '$_temp0';
  }

  @override
  String get pdfPreparingDocument => 'Preparing document…';

  @override
  String get pdfDocument => 'Document';

  @override
  String pdfReadyToSaveOrShare(String label) {
    return '$label ready to save or share.';
  }

  @override
  String pdfSaveLabelPdf(String label) {
    return 'Save $label PDF';
  }

  @override
  String pdfSavedTo(String file, String label) {
    return '$label saved to $file.';
  }

  @override
  String pdfSavedOnDevice(String label) {
    return '$label saved on this device.';
  }

  @override
  String pdfReadyChooseWhere(String label) {
    return '$label ready — choose where to save it.';
  }

  @override
  String get pdfSomethingWentWrong => 'Something went wrong. Please try again.';

  @override
  String get receiptActionsPreparing => 'Preparing receipt…';

  @override
  String receiptActionsShareSubject(String reference) {
    return 'Receipt · $reference';
  }

  @override
  String get receiptActionsThankYou => 'Thank you for your purchase.';

  @override
  String get receiptActionsBuildFailed =>
      'Could not prepare a receipt for this sale. Check your connection and try again.';

  @override
  String get receiptActionsTrainingBlocked =>
      'Training receipts cannot be shared or printed.';

  @override
  String get saleReceiptExpenseRecord => 'Expense record';

  @override
  String get saleReceiptSaleReceipt => 'Sale receipt';

  @override
  String get saleReceiptNoLineItems =>
      'No line items were recorded for this transaction.';

  @override
  String saleReceiptCopyFooter(String date) {
    return 'Customer copy generated from Flipper records on $date. This document is not an EBM fiscal receipt.';
  }

  @override
  String saleReceiptCopyFooterWithEbm(String date) {
    return 'Customer copy generated from Flipper records on $date, with the EBM details recorded for this sale copied above. This document is not the EBM-signed receipt.';
  }

  @override
  String get saleReceiptCustomerCopy => 'Customer copy';

  @override
  String get saleReceiptReference => 'Reference';

  @override
  String get saleReceiptCustomerTin => 'Customer TIN';

  @override
  String get saleReceiptChange => 'Change';

  @override
  String saleReceiptRefundedVia(String amount, String method) {
    return 'Refunded: $amount via $method';
  }

  @override
  String saleReceiptReason(String reason) {
    return 'Reason: $reason';
  }

  @override
  String get saleReceiptCard => 'Card';

  @override
  String get refundTransactionAlreadyRefunded =>
      'This transaction is already refunded';

  @override
  String get refundCannotRefundProforma => 'Cannot refund a proforma receipt';

  @override
  String get refundOnlyCompleted =>
      'Only completed transactions can be refunded';

  @override
  String get refundCreditNotFullyPaid =>
      'Credit or partially paid sales cannot be refunded until fully paid';

  @override
  String get refundEnterPurchaseCodeTitle => 'Enter Purchase Code';

  @override
  String get refundEnterPurchaseCodeHint => 'Enter purchase code';

  @override
  String get refundNoLineItems =>
      'No line items to refund for this transaction';

  @override
  String get refundAmountMustBePositive =>
      'Refund amount must be greater than zero';

  @override
  String get refundAmountExceedsOriginal =>
      'Refund amount cannot exceed the original payment';

  @override
  String get refundPartialVatUnsupported =>
      'Partial refunds with EBM/VAT are not supported yet. Use a full refund.';

  @override
  String get refundPurchaseCodeRequired => 'Purchase code is required';

  @override
  String get refundCannotRefundReceiptType => 'Cannot refund this receipt type';

  @override
  String get shiftSignOutAnyway => 'Sign out anyway';

  @override
  String get shiftCheckingYourShift => 'Checking your shift…';

  @override
  String get shiftCannotCloseShift => 'Cannot close shift';

  @override
  String get shiftBelongsToAnotherUserSwitch =>
      'The open shift belongs to another user. Ask that agent to close their shift first, then try switching again.';

  @override
  String get shiftBelongsToAnotherUserTitle => 'Shift belongs to another user';

  @override
  String get shiftBelongsToAnotherUserSignOut =>
      'The open shift was started by another agent, so it cannot be closed from here.\n\nYou can still sign out. The shift stays open for that agent to close.';

  @override
  String get shiftCloseToSwitchUser => 'Close shift to switch user';

  @override
  String get shiftCloseToSignOut => 'Close shift to sign out';

  @override
  String get shiftCouldNotCloseShift => 'Could not close shift';

  @override
  String shiftCouldNotCloseSignOutAnyway(String error) {
    return 'The shift could not be closed:\n\n$error\n\nYou can sign out anyway. The shift stays open and can be closed the next time you sign in.';
  }

  @override
  String get shiftClosedTakingToLogin =>
      'Shift closed successfully. Taking you to the login screen…';

  @override
  String get shiftSignOut => 'Sign out';

  @override
  String get shiftNoOpenShiftContinue =>
      'You do not have an open shift. Continue to the login screen?';

  @override
  String get shiftSigningOut => 'Signing out…';

  @override
  String shiftTakingTooLongRetry(String error) {
    return 'This is taking too long. Check your connection and try again.\n\n$error';
  }

  @override
  String get shiftTakingTooLongSignOutAnyway =>
      'Checking your shift is taking too long — you may be offline.\n\nYou can sign out anyway. Any open shift stays open and can be closed the next time you sign in.';

  @override
  String shiftCheckFailedRetry(String error) {
    return 'Please try again. If the problem continues, check your connection.\n\n$error';
  }

  @override
  String shiftCheckFailedSignOutAnyway(String error) {
    return 'Your shift could not be checked:\n\n$error\n\nYou can sign out anyway. Any open shift stays open and can be closed the next time you sign in.';
  }

  @override
  String get shiftCouldNotVerify => 'Could not verify shift';

  @override
  String endOfShiftTodaysShift(String day) {
    return 'Today\'s shift · $day';
  }

  @override
  String get endOfShiftTitle => 'End of shift';

  @override
  String get endOfShiftNoOpenShift => 'No open shift';

  @override
  String get endOfShiftCollected => 'Collected this shift';

  @override
  String get endOfShiftCashDrawer => 'Cash drawer';

  @override
  String get endOfShiftSalesCompleted => 'Sales completed';

  @override
  String get endOfShiftItemsSold => 'Items sold';

  @override
  String get endOfShiftCloseAndSignOut => 'Close shift & sign out';

  @override
  String get endOfShiftSwitchBranch => 'Switch branch';

  @override
  String get endOfShiftStaySignedIn => 'Stay signed in';

  @override
  String get endOfShiftSalesSaved =>
      'Your sales are saved — the drawer will be reconciled on close.';

  @override
  String get endOfShiftAgent => 'Agent';

  @override
  String get endOfShiftBranch => 'Branch';

  @override
  String get signOutSigningYouOut => 'Signing you out…';

  @override
  String get logoutLoggingOut => 'Logging out...';

  @override
  String get posSwitchCouldNotLoadStaff => 'Could not load staff';

  @override
  String get posSwitchNoOtherStaff =>
      'No other staff members available to switch to.';

  @override
  String get posSwitchUserTitle => 'Switch User';

  @override
  String get posSwitchUserSubtitle =>
      'Select a staff member and enter their PIN';

  @override
  String get posSwitchTapNameLeft =>
      'Tap a name on the left, then enter their PIN';

  @override
  String get posSwitchTapNameAbove => 'Tap a name above, then enter their PIN';

  @override
  String get posSwitchEnterPin => 'Enter the 6-digit PIN to switch';

  @override
  String get posSwitchWhosNext => 'Who\'s next?';

  @override
  String get posSwitchSelectStaff => 'Select staff';

  @override
  String get posSwitchStaff => 'Staff';

  @override
  String get posSwitchCannotSwitchUser => 'Cannot switch user';

  @override
  String get posSwitchNoLinkedAccount =>
      'This staff member has no linked user account.';

  @override
  String get posSwitchPinMismatch =>
      'PIN does not match the selected staff member.';

  @override
  String get posSwitchPinUnresolved =>
      'Could not resolve PIN for the selected staff member.';

  @override
  String get posSwitchMissingContext =>
      'Cannot switch user without business/branch context. Sign out and sign in again, then retry Switch User.';

  @override
  String get posSwitchCouldNotSwitch => 'Could not switch user';

  @override
  String get posSwitchRefreshStaff => 'Refresh staff list';

  @override
  String get posSwitchSharedRegister => 'POS · Shared register';

  @override
  String get posSwitchNoStaffAvailable => 'No staff members available.';

  @override
  String get posSwitchTapYourNameLeft =>
      'Tap your name on the left, then enter your PIN';

  @override
  String get posSwitchTapYourNameAbove =>
      'Tap your name above, then enter your PIN';

  @override
  String get posSwitchEnterYourPin => 'Enter your 6-digit PIN to open POS';

  @override
  String get posSwitchWhosServing => 'Who\'s serving?';

  @override
  String get posSwitchWhosOnRegister => 'Who\'s on the register?';

  @override
  String posSwitchOpeningPosFor(String name) {
    return 'Opening POS for $name…';
  }

  @override
  String get posSwitchOpeningPos => 'Opening POS…';

  @override
  String get orderingNoSupplierSelected => 'No supplier selected';

  @override
  String get orderingSelectSupplierHint =>
      'Select a supplier from the search above\nto view available products';

  @override
  String get orderingNewOrder => 'New Order';

  @override
  String get orderingPointOfSale => 'Point of Sale';

  @override
  String get orderingTransactionHistory => 'Transaction History';

  @override
  String get orderingMoreOptions => 'More Options';

  @override
  String get orderingAllProducts => 'All products';

  @override
  String get orderingUncategorised => 'Uncategorised';

  @override
  String get orderingCategories => 'Categories';

  @override
  String get orderingLoading => 'Loading…';

  @override
  String get orderingFilter => 'Filter';

  @override
  String get orderingInStockOnly => 'In stock only';

  @override
  String get orderingShowRetailMargin => 'Show retail margin';

  @override
  String get orderingHidingOutOfStock =>
      'Hiding items the supplier has none of.';

  @override
  String get orderingOutOfStockShown =>
      'Out-of-stock items still show, marked red.';

  @override
  String get orderingLastOrder => 'Last order';

  @override
  String get orderingNoPreviousOrder => 'No previous order with this supplier.';

  @override
  String orderingLineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lines',
      one: '1 line',
    );
    return '$_temp0';
  }

  @override
  String get orderingAwaitingApproval => 'awaiting approval';

  @override
  String get orderingApprovedLower => 'approved';

  @override
  String get orderingPartlyApproved => 'partly approved';

  @override
  String get orderingEmpty => 'empty';

  @override
  String orderingUnitCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count units',
      one: '1 unit',
    );
    return '$_temp0';
  }

  @override
  String get orderingThisOrder => 'This order';

  @override
  String get orderingClearAll => 'Clear all';

  @override
  String get orderingNoLinesYet => 'No lines yet';

  @override
  String get orderingEmptyHintBefore => 'Search a product and press';

  @override
  String get orderingEmptyHintAfter => '— the top match lands here.';

  @override
  String get orderingRemoveLine => 'Remove line';

  @override
  String orderingCostDeltaVsLast(String delta) {
    return '$delta% vs last';
  }

  @override
  String orderingOnlyAvailable(String count) {
    return 'only $count available';
  }

  @override
  String get orderingOneLess => 'Order one less';

  @override
  String get orderingOneMore => 'Order one more';

  @override
  String orderingVatRate(String rate) {
    return 'VAT $rate%';
  }

  @override
  String get orderingPayWith => 'Pay with';

  @override
  String get orderingSendingOrder => 'Sending order…';

  @override
  String get orderingAddProductToContinue => 'Add a product to continue';

  @override
  String get orderingChoosePayment => 'Choose how you are paying';

  @override
  String orderingPlaceOrderTotal(String total) {
    return 'Place order · $total';
  }

  @override
  String get orderingLoadingPaymentOptions => 'Loading payment options…';

  @override
  String get orderingPaymentOptionsUnavailable =>
      'Payment options unavailable — the order will be sent without one.';

  @override
  String get orderingNoPaymentOption =>
      'No payment option set up for this business — the order will be sent without one.';

  @override
  String get orderingDeliveryNoteOptional => 'Delivery note (optional)';

  @override
  String orderingOrderSentTo(String supplier) {
    return 'Order sent to $supplier';
  }

  @override
  String get orderingPlacedHint =>
      'They get an SMS now; you will see it under Incoming orders once accepted.';

  @override
  String get orderingStartAnotherOrder => 'Start another order';

  @override
  String get orderingSearchProductsHint => 'Search products, SKU or barcode…';

  @override
  String get orderingColProduct => 'Product';

  @override
  String get orderingColTheirStock => 'Their stock';

  @override
  String get orderingColRetailMargin => 'Retail · margin';

  @override
  String get orderingColOrderQty => 'Order qty';

  @override
  String get orderingStockNone => 'none';

  @override
  String get orderingSupplierNoProducts =>
      'This supplier has no products to order';

  @override
  String get orderingSupplierNoProductsHint =>
      'Nothing in their catalogue is shared with your branch yet.';

  @override
  String get orderingNothingMatchesFilters => 'Nothing matches these filters';

  @override
  String orderingNothingMatchesQuery(String query) {
    return 'Nothing matches “$query”';
  }

  @override
  String get orderingNothingMatchesHint =>
      'Try a shorter word, or clear the in-stock filter.';

  @override
  String get orderingCouldNotLoadCatalogue => 'Could not load this catalogue';

  @override
  String get orderingPickerTitle => 'Which supplier are you ordering from?';

  @override
  String get orderingPickerBody =>
      'Pick a branch you buy from. Their catalogue, your last cost and their stock on hand load straight into the order.';

  @override
  String get orderingSearchSuppliersHint => 'Search suppliers by name…';

  @override
  String get orderingNotOnList => 'Not on the list?';

  @override
  String get orderingCouldNotLoadSuppliers => 'Could not load suppliers';

  @override
  String get orderingNoOtherBranch => 'No other branch to order from';

  @override
  String get orderingNoOtherBranchHint =>
      'Add a branch, or search for a supplier by name.';

  @override
  String get orderingFrequentSuppliers => 'Suppliers you order from most';

  @override
  String get orderingBranchesYouCanOrderFrom => 'Branches you can order from';

  @override
  String get orderingOtherBranchesYouCanOrderFrom =>
      'Other branches you can order from';

  @override
  String orderingNoSupplierMatches(String query) {
    return 'No supplier matches “$query”';
  }

  @override
  String get orderingNoSupplierMatchesHint =>
      'Check the spelling, or add them as a new branch.';

  @override
  String get orderingOnThisDevice => 'On this device';

  @override
  String get orderingFoundByNameSearch => 'Found by name search';

  @override
  String get orderingUnnamedBranch => 'Unnamed branch';

  @override
  String get orderingAddNewSupplier => 'Add a new supplier';

  @override
  String get orderingThisBranch => 'This branch';

  @override
  String get orderingNewPurchaseOrder => 'New purchase order';

  @override
  String get orderingShortcutSearch => 'search';

  @override
  String get orderingShortcutAddTopMatch => 'add top match';

  @override
  String get orderingChangeSupplier => 'Change supplier';

  @override
  String get orderingChoosePaymentBeforeSending =>
      'Choose how you are paying before sending the order.';

  @override
  String get orderingTheSupplier => 'the supplier';

  @override
  String get orderingSearchSuppliersEllipsis => 'Search suppliers...';

  @override
  String get orderingUnknownSupplier => 'Unknown Supplier';

  @override
  String get orderingNoSuppliersFound => 'No suppliers found';

  @override
  String get orderingTryDifferentSearch => 'Try a different search term';

  @override
  String get orderingSelectSupplierFirst => 'Please select a supplier first.';

  @override
  String get orderingSupplierInvalidId =>
      'Selected supplier has invalid ID. Please select a different supplier.';

  @override
  String get orderingCannotOrderFromYourself =>
      'You can not order from yourself.';

  @override
  String get orderingCartIsEmpty => 'The cart is empty';

  @override
  String orderingSmsNewOrder(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'New order with $count items, total: $total',
      one: 'New order with 1 item, total: $total',
    );
    return '$_temp0';
  }

  @override
  String get orderingPlacedTitle => 'Order Placed Successfully';

  @override
  String get orderingPlacedDescription =>
      'Your order has been processed and confirmed.';

  @override
  String get orderingPlacedSnack => 'Order placed successfully';

  @override
  String get orderingCartEmptyAddProduct =>
      'The cart is empty — add a product before ordering.';

  @override
  String get createCategoryTitle => 'Create Category';

  @override
  String get createCategoryEnterName => 'Enter Category Name';

  @override
  String get createCategoryNameHint => 'Category Name';

  @override
  String get createLoadingEllipsis => 'Loading...';

  @override
  String get createSelectCategory => 'Select Category';

  @override
  String get createAddVariation => 'Add Variation';

  @override
  String get createEnterProductName => 'Enter product name';

  @override
  String get createNameRequired => 'Name required';

  @override
  String get createRetailPrice => 'Retail Price';

  @override
  String get createEnterRetailPrice => 'Enter retail price';

  @override
  String get createRetailPriceRequired => 'Retail price required';

  @override
  String get createShouldBeNumber => 'Should be a number';

  @override
  String get createCostPrice => 'Cost Price';

  @override
  String get createEnterCostPrice => 'Enter cost price';

  @override
  String get createCostPriceRequired => 'Cost price required';

  @override
  String get createEnterSku => 'Enter SKU';

  @override
  String get createTaxExempted => 'Tax Exempted';

  @override
  String get createFillRequiredFields => 'Fill all required fields';

  @override
  String get photosPickColor => 'Pick a color';

  @override
  String get photosSelectColorShade => 'Select color shade';

  @override
  String get photosSelectedColorShades => 'Selected color and its shades';

  @override
  String get photosPickColorInstead => 'Pick a color instead';

  @override
  String get photosSavedLocally =>
      'Image saved locally. Will be uploaded when online.';

  @override
  String get photosAddImageOffline => 'Add Image (Offline)';

  @override
  String get photosAddImage => 'Add Image';

  @override
  String get photosClickToChange => 'Click to change image';

  @override
  String get photosUploadImage => 'Upload Image';

  @override
  String get colorTileColors => 'Colors';

  @override
  String get colorTileNewItem => 'New Item';

  @override
  String get colorTileChooseLabelColor => 'Choose label color';

  @override
  String get colorTilePhotoLabel => 'Photo label';

  @override
  String get colorTileTakePhoto => 'Take Photo';

  @override
  String get categoriesSearchHint => 'Search categories...';

  @override
  String get categoriesCreateNew => 'Create new category';

  @override
  String get categoriesAll => 'All categories';

  @override
  String get categoriesNoneFound => 'No categories found';

  @override
  String get unitsUnitType => 'Unit Type';

  @override
  String get unitsNoneAvailable => 'No units available';

  @override
  String get unitsSelectUnit => 'Select Unit';

  @override
  String get receiveStockTitle => 'Receive stock';

  @override
  String get receiveStockButton => 'Receive Stock';

  @override
  String get receiveStockEnterValue => 'Please enter stock value';

  @override
  String get receiveStockAddStock => 'Add Stock';

  @override
  String get receiveStockTrackingHint =>
      'Inventory tracking will be enabled by default for items with stock count. To turn tracking off, visit your Flipper Dashboard';

  @override
  String get purchaseStatusWaiting => 'Waiting';

  @override
  String get purchaseStatusDeclined => 'Declined';

  @override
  String get purchaseColumnNo => 'No.';

  @override
  String get purchaseSupplyPrice => 'Supply Price';

  @override
  String get purchaseAssignVariant => 'Assign Variant';

  @override
  String get purchaseSearchVariants => 'Search variants...';

  @override
  String get cartPaymentsAtTillSendToManager =>
      'Payments are collected at the till. Send this order to a manager.';

  @override
  String get cartTransactionNotFound => 'Transaction not found for completion.';

  @override
  String cartSplitEnterAmountFor(String indices) {
    return 'enter an amount for payment $indices';
  }

  @override
  String cartSplitFixInvalidAmountFor(String indices) {
    return 'fix invalid amount for payment $indices';
  }

  @override
  String cartSplitAmountAboveZeroFor(String indices) {
    return 'each method needs an amount above zero (payment $indices)';
  }

  @override
  String cartSplitMultipleMethodsInUse(String details) {
    return 'Multiple payment methods are in use: $details.';
  }

  @override
  String get cartCreditNeedsCustomer =>
      'A customer name or phone is required for credit/loan payments.';

  @override
  String get cartUnsavedOneItem =>
      'One item could not be saved to this sale. Remove it from the cart and add it again.';

  @override
  String cartUnsavedNamed(String name) {
    return '$name could not be saved to this sale. Remove it from the cart and add it again.';
  }

  @override
  String cartUnsavedTwo(String first, String second) {
    return '$first and $second could not be saved to this sale. Remove them from the cart and add them again.';
  }

  @override
  String cartUnsavedMany(String count, String first, String second) {
    return '$first, $second and $count more could not be saved to this sale. Remove them from the cart and add them again.';
  }

  @override
  String get cartAddItemsBeforeReview =>
      'Add items to the cart before sending for review.';

  @override
  String get cartPaymentParkedAsLoan =>
      'Payment recorded. Transaction parked as loan.';

  @override
  String get cartSentForReview => 'Sent for review';

  @override
  String get cartPaymentSuccessful => 'Payment Successful';

  @override
  String get cartPaymentConfirmationTimeout =>
      'Payment confirmation timeout. Please try again.';

  @override
  String get errorUnableToSaveData =>
      'Unable to save data. Please restart the app and try again.';

  @override
  String get errorDatabaseBusy =>
      'Database is busy. Please wait a moment and try again.';

  @override
  String get errorNoInternet =>
      'No internet connection. Please check your network and try again.';

  @override
  String get errorSessionExpired => 'Session expired. Please log in again.';

  @override
  String get errorNoPermission =>
      'You don\'t have permission to perform this action.';

  @override
  String get errorRequestTimedOut => 'Request timed out. Please try again.';

  @override
  String get errorPermissionDenied =>
      'Permission denied. Please check app permissions in settings.';

  @override
  String get errorServerUnavailable =>
      'Server is temporarily unavailable. Please try again later.';

  @override
  String get errorNotFound => 'The requested resource was not found.';

  @override
  String get errorCheckInput => 'Please check your input and try again.';

  @override
  String get errorSyncUnavailable =>
      'Sync temporarily unavailable. Your changes will sync when connection is restored.';

  @override
  String get errorGenericContactSupport =>
      'Something went wrong. Please try again or contact support if the problem persists.';

  @override
  String get pickImageNoFileSelected => 'No file selected.';

  @override
  String get pickImageReadFailed =>
      'Failed to read the selected file. Please try again.';

  @override
  String get pickImageNoData => 'That file has no data. Please pick another.';

  @override
  String pickImageTooLarge(String kb) {
    return 'Please choose an image under ${kb}KB.';
  }

  @override
  String get pickImageNotReadable =>
      'That file is not a readable PNG or JPEG. Please pick another.';

  @override
  String get posCartViewOnlyCannotAdd =>
      'View-only access — you cannot add items to a sale.';

  @override
  String get posCartNoActiveCart => 'No active sale cart. Try again.';

  @override
  String get imageSourceGallery => 'Gallery';

  @override
  String get imageSourceCamera => 'Camera';

  @override
  String get imageSourceBrowseFiles => 'Browse files';

  @override
  String get stockItemUnavailable => 'Item unavailable';

  @override
  String get stockItemsUnavailable => 'Items unavailable';

  @override
  String stockNotEnoughSingle(String name) {
    return 'We don\'t have enough $name in stock to complete your order.';
  }

  @override
  String get stockRequestedQuantity => 'Requested Quantity:';

  @override
  String get stockNotEnoughMultiple =>
      'We don\'t have enough of these items in stock:';

  @override
  String stockRequestedValue(String qty) {
    return 'Requested: $qty';
  }

  @override
  String get stockReduceOrRemoveItem =>
      'You can reduce the quantity or remove this item to continue.';

  @override
  String get stockAdjustOrRemoveItems =>
      'You can adjust quantities or remove these items to continue.';

  @override
  String get stockGotIt => 'Got it';

  @override
  String get ticketCompleteEnterCustomerName =>
      'Please enter a customer name before completing.';

  @override
  String get ticketCompletePhoneRequiredNoTin =>
      'A customer phone number is required when no TIN is on file.';

  @override
  String get ticketCompleteDone => 'Ticket completed';

  @override
  String get ticketCompleteFailed => 'Failed to complete ticket';

  @override
  String get ticketCompleteInProgress => 'Completing ticket…';

  @override
  String get hrWeekdayMonday => 'Monday';

  @override
  String get hrWeekdayShortMon => 'Mon';

  @override
  String get hrWeekdayTuesday => 'Tuesday';

  @override
  String get hrWeekdayShortTue => 'Tue';

  @override
  String get hrWeekdayWednesday => 'Wednesday';

  @override
  String get hrWeekdayShortWed => 'Wed';

  @override
  String get hrWeekdayThursday => 'Thursday';

  @override
  String get hrWeekdayShortThu => 'Thu';

  @override
  String get hrWeekdayFriday => 'Friday';

  @override
  String get hrWeekdayShortFri => 'Fri';

  @override
  String get hrWeekdaySaturday => 'Saturday';

  @override
  String get hrWeekdayShortSat => 'Sat';

  @override
  String get hrWeekdaySunday => 'Sunday';

  @override
  String get hrWeekdayShortSun => 'Sun';

  @override
  String get hrMonthJanuary => 'January';

  @override
  String get hrMonthShortJan => 'Jan';

  @override
  String get hrMonthFebruary => 'February';

  @override
  String get hrMonthShortFeb => 'Feb';

  @override
  String get hrMonthMarch => 'March';

  @override
  String get hrMonthShortMar => 'Mar';

  @override
  String get hrMonthApril => 'April';

  @override
  String get hrMonthShortApr => 'Apr';

  @override
  String get hrMonthMay => 'May';

  @override
  String get hrMonthShortMay => 'May';

  @override
  String get hrMonthJune => 'June';

  @override
  String get hrMonthShortJun => 'Jun';

  @override
  String get hrMonthJuly => 'July';

  @override
  String get hrMonthShortJul => 'Jul';

  @override
  String get hrMonthAugust => 'August';

  @override
  String get hrMonthShortAug => 'Aug';

  @override
  String get hrMonthSeptember => 'September';

  @override
  String get hrMonthShortSep => 'Sep';

  @override
  String get hrMonthOctober => 'October';

  @override
  String get hrMonthShortOct => 'Oct';

  @override
  String get hrMonthNovember => 'November';

  @override
  String get hrMonthShortNov => 'Nov';

  @override
  String get hrMonthDecember => 'December';

  @override
  String get hrMonthShortDec => 'Dec';

  @override
  String hrLongDate(String weekday, String day, String month) {
    return '$weekday, $day $month';
  }

  @override
  String hrDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String hrDaysFractional(String days) {
    return '$days days';
  }

  @override
  String hrDurationMinutes(String minutes) {
    return '${minutes}m';
  }

  @override
  String hrDurationHours(String hours) {
    return '${hours}h';
  }

  @override
  String hrDurationHoursMinutes(String hours, String minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get hrGoodMorning => 'Good morning';

  @override
  String get hrGoodAfternoon => 'Good afternoon';

  @override
  String get hrGoodEvening => 'Good evening';

  @override
  String hrGreetingWithName(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get hrAddAPerson => 'Add a person';

  @override
  String get hrApprovals => 'Approvals';

  @override
  String hrReviewRequests(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Review $count requests',
      one: 'Review 1 request',
    );
    return '$_temp0';
  }

  @override
  String get hrAttendanceBoard => 'Attendance board';

  @override
  String get hrHeadcount => 'Headcount';

  @override
  String hrActiveCount(String count) {
    return '$count active';
  }

  @override
  String get hrOnLeave => 'On leave';

  @override
  String get hrWaitingOnYou => 'Waiting on you';

  @override
  String get hrNeedsADecision => 'Needs a decision';

  @override
  String get hrAllClear => 'All clear';

  @override
  String get hrNewThisMonth => 'New this month';

  @override
  String get hrMonthlyPayroll => 'Monthly payroll';

  @override
  String get hrEstimated => 'Estimated';

  @override
  String get hrNeedsYourDecision => 'Needs your decision';

  @override
  String get hrNeedsYourDecisionSubtitle =>
      'Leave requests nobody has answered yet';

  @override
  String get hrOpenQueue => 'Open queue';

  @override
  String get hrCouldNotLoadApprovalsQueue =>
      'Could not load the approvals queue.';

  @override
  String get hrTryAgain => 'Try again';

  @override
  String get hrNothingWaitingOnYou =>
      'Nothing is waiting on you. Every request has been decided.';

  @override
  String hrMoreWaiting(String count) {
    return '$count more waiting';
  }

  @override
  String hrEmployeeWithId(String id) {
    return 'Employee $id';
  }

  @override
  String get hrOutToday => 'Out today';

  @override
  String get hrRoster => 'Roster';

  @override
  String get hrEveryoneIsInToday => 'Everyone is in today.';

  @override
  String get hrJoinedThisMonth => 'Joined this month';

  @override
  String get hrNobodyNewThisMonth => 'Nobody new this month.';

  @override
  String get hrEmploymentFullTime => 'Full time';

  @override
  String get hrEmploymentPartTime => 'Part time';

  @override
  String get hrEmploymentContract => 'Contract';

  @override
  String get hrEmploymentIntern => 'Intern';

  @override
  String get hrEmploymentCasual => 'Casual';

  @override
  String get hrStatusActive => 'Active';

  @override
  String get hrStatusSuspended => 'Suspended';

  @override
  String get hrStatusTerminated => 'Terminated';

  @override
  String get hrPayMonthly => 'Monthly';

  @override
  String get hrPayWeekly => 'Weekly';

  @override
  String get hrPayDaily => 'Daily';

  @override
  String get hrPayHourly => 'Hourly';

  @override
  String get hrPaymentBankTransfer => 'Bank transfer';

  @override
  String get hrAttendanceNotIn => 'Not in';

  @override
  String get hrAttendanceClockedIn => 'Clocked in';

  @override
  String get hrAttendanceClockedOut => 'Clocked out';

  @override
  String get hrAttendanceSourceSelf => 'Self';

  @override
  String get hrAttendanceSourceManager => 'Recorded by manager';

  @override
  String get hrLeaveStatusPending => 'Pending';

  @override
  String get hrLeaveStatusRejected => 'Rejected';

  @override
  String get hrLeaveStatusCancelled => 'Cancelled';

  @override
  String get hrLeaveTypeAnnual => 'Annual leave';

  @override
  String get hrLeaveTypeSick => 'Sick leave';

  @override
  String get hrLeaveTypeMaternity => 'Maternity leave';

  @override
  String get hrLeaveTypePaternity => 'Paternity leave';

  @override
  String get hrLeaveTypeCompassionate => 'Compassionate leave';

  @override
  String get hrLeaveTypeUnpaid => 'Unpaid leave';

  @override
  String hrPersonAddedToRoster(String name) {
    return '$name was added to the roster.';
  }

  @override
  String hrSavedChangesTo(String name) {
    return 'Saved changes to $name.';
  }

  @override
  String hrInviteSentNotLinked(String message) {
    return 'Invite sent, but not linked. $message';
  }

  @override
  String hrPersonIsNowStatus(String name, String status) {
    return '$name is now $status.';
  }

  @override
  String hrTerminatePersonTitle(String name) {
    return 'Terminate $name?';
  }

  @override
  String hrTerminatePersonBody(String date) {
    return 'Their last day will be recorded as $date. The record stays for payroll history but they leave the roster.';
  }

  @override
  String get hrTerminate => 'Terminate';

  @override
  String get hrAccessDiagnostic => 'Access diagnostic';

  @override
  String hrDiagnosticFailed(String error) {
    return 'Diagnostic failed: $error';
  }

  @override
  String get hrPeople => 'People';

  @override
  String get hrEveryoneOnThisBranch => 'Everyone on this branch';

  @override
  String hrEveryoneAtBranch(String branch) {
    return 'Everyone at $branch';
  }

  @override
  String get hrAddPerson => 'Add person';

  @override
  String get hrSearchPeopleHint => 'Search name, role, phone…';

  @override
  String get hrStatus => 'Status';

  @override
  String get hrEmployed => 'Employed';

  @override
  String get hrDepartment => 'Department';

  @override
  String get hrAllDepartments => 'All departments';

  @override
  String get hrSortBy => 'Sort by';

  @override
  String get hrReportsTo => 'Reports to';

  @override
  String get hrContact => 'Contact';

  @override
  String get hrTenure => 'Tenure';

  @override
  String get hrBasePay => 'Base pay';

  @override
  String hrReportsToName(String name) {
    return 'Reports to $name';
  }

  @override
  String get hrResendHrInvite => 'Re-send HR invite';

  @override
  String get hrInviteToHr => 'Invite to HR';

  @override
  String get hrMarkActive => 'Mark active';

  @override
  String get hrMarkOnLeave => 'Mark on leave';

  @override
  String get hrSuspend => 'Suspend';

  @override
  String get hrNoOneOnBranchYet => 'No one on this branch yet';

  @override
  String get hrNoOneOnBranchYetMessage =>
      'Add your first person to start tracking attendance, leave and payroll.';

  @override
  String get hrNoOneMatchesFilters => 'No one matches these filters';

  @override
  String get hrClearFilters => 'Clear filters';

  @override
  String get hrWhyWasThisDenied => 'Why was this denied?';

  @override
  String hrTenureStarts(String date) {
    return 'Starts $date';
  }

  @override
  String hrTenureDays(String days) {
    return '$days d';
  }

  @override
  String hrTenureMonths(String months) {
    return '$months mo';
  }

  @override
  String hrTenureYears(String years) {
    return '$years yr';
  }

  @override
  String hrTenureYearsMonths(String years, String months) {
    return '$years yr $months mo';
  }

  @override
  String get hrSortNameAsc => 'Name (A–Z)';

  @override
  String get hrSortNameDesc => 'Name (Z–A)';

  @override
  String get hrSortNewestHire => 'Newest hire';

  @override
  String get hrSortLongestServing => 'Longest serving';

  @override
  String get hrSortHighestPaid => 'Highest paid';

  @override
  String get hrEditPerson => 'Edit person';

  @override
  String get hrSectionIdentity => 'Identity';

  @override
  String get hrFirstName => 'First name';

  @override
  String get hrLastName => 'Last name';

  @override
  String get hrEmailOptional => 'Email (optional)';

  @override
  String get hrNationalIdOptional => 'National ID (optional)';

  @override
  String get hrRssbNumberOptional => 'RSSB number (optional)';

  @override
  String get hrSectionRole => 'Role';

  @override
  String get hrJobTitle => 'Job title';

  @override
  String get hrDepartmentOptional => 'Department (optional)';

  @override
  String get hrEmploymentType => 'Employment type';

  @override
  String get hrStartDate => 'Start date';

  @override
  String get hrLastDayOptional => 'Last day (optional)';

  @override
  String get hrSectionPay => 'Pay';

  @override
  String hrBasePayWithCurrency(String currency) {
    return 'Base pay ($currency)';
  }

  @override
  String get hrPayFrequency => 'Pay frequency';

  @override
  String get hrAnnualLeaveDays => 'Annual leave days';

  @override
  String hrAnnualLeaveDaysHelper(String days) {
    return 'Leave blank for the legal minimum of $days working days';
  }

  @override
  String get hrMobileMoneyNumber => 'Mobile money number';

  @override
  String get hrMobileMoneyNumberHelper =>
      'Leave blank to pay the contact number above';

  @override
  String get hrBank => 'Bank';

  @override
  String get hrAccountNumber => 'Account number';

  @override
  String get hrSectionNotes => 'Notes';

  @override
  String get hrNotesOptional => 'Notes (optional)';

  @override
  String get hrSaveChanges => 'Save changes';

  @override
  String get hrManagerNotOnRoster =>
      'Their current manager is not on this branch\'s roster. Pick someone here to change it.';

  @override
  String get hrManagerNobodyToChoose =>
      'Nobody to choose yet — leave requests go to whoever manages the business.';

  @override
  String get hrManagerHelper =>
      'Their leave requests go to this person. Leave it unset and they go to whoever manages the business.';

  @override
  String get hrNoManager => 'No manager';

  @override
  String get hrFirstNameRequired => 'First name is required';

  @override
  String get hrLastNameRequired => 'Last name is required';

  @override
  String get hrJobTitleRequired => 'Job title is required';

  @override
  String get hrPhoneNumberRequired => 'Phone number is required';

  @override
  String get hrEnterValidPhoneNumber => 'Enter a valid phone number';

  @override
  String get hrEnterValidEmail => 'Enter a valid email address';

  @override
  String hrNationalIdLength(String min, String max) {
    return 'A national ID is $min to $max characters';
  }

  @override
  String get hrStartDateTooFarAhead =>
      'Start date cannot be more than a year ahead';

  @override
  String get hrLastDayRequiredToTerminate =>
      'A last day is required to terminate';

  @override
  String get hrLastDayBeforeStart => 'Last day cannot be before the start date';

  @override
  String get hrCannotReportToSelf => 'Someone cannot report to themselves';

  @override
  String get hrPayCannotBeNegative => 'Pay cannot be negative';

  @override
  String get hrLeaveDaysCannotBeNegative => 'Leave days cannot be negative';

  @override
  String get hrLeaveDaysTooMany =>
      'That is more than a working year — enter days, not hours';

  @override
  String get hrMobileMoneyNumberRequired => 'Mobile money number is required';

  @override
  String get hrEnterValidMobileMoneyNumber =>
      'Enter a valid mobile money number';

  @override
  String get hrBankNameRequired => 'Bank name is required';

  @override
  String get hrAccountNumberRequired => 'Account number is required';

  @override
  String get hrPickFirstDayOfLeave => 'Pick the first day of leave.';

  @override
  String get hrPickLastDayOfLeave => 'Pick the last day of leave.';

  @override
  String get hrLastDayBeforeFirstDay =>
      'The last day cannot be before the first day.';

  @override
  String get hrLeaveTooFarAhead =>
      'Leave cannot be booked more than a year ahead. Check the year on these dates.';

  @override
  String get hrLeaveCannotStartInPast => 'Leave cannot start in the past.';

  @override
  String hrLeaveBackdatedTooFar(String days) {
    return 'This started more than $days days ago. Ask whoever manages the roster to record it instead.';
  }

  @override
  String hrLeaveReasonRequired(String leaveType) {
    return 'Say briefly why you need $leaveType.';
  }

  @override
  String get hrPickAtLeastOneDay => 'Pick at least one day.';

  @override
  String get hrPeriodAllWeekend =>
      'That period is all weekend — pick at least one working day.';

  @override
  String hrLeaveOverlaps(String start, String end, String status) {
    return 'This overlaps leave you already have from $start to $end ($status).';
  }

  @override
  String hrNoLeaveLeft(String leaveType, String year) {
    return 'No $leaveType left for $year.';
  }

  @override
  String hrOnlyLeaveLeft(
    String left,
    String leaveType,
    String year,
    String requested,
  ) {
    return 'Only $left of $leaveType left for $year; this asks for $requested.';
  }

  @override
  String get hrRequestLeave => 'Request leave';

  @override
  String hrLeaveForName(String name) {
    return 'Leave for $name';
  }

  @override
  String get hrLeaveTypeField => 'Type';

  @override
  String get hrFirstDay => 'First day';

  @override
  String get hrLastDay => 'Last day';

  @override
  String get hrNoteOptional => 'Note (optional)';

  @override
  String get hrReason => 'Reason';

  @override
  String get hrSending => 'Sending…';

  @override
  String get hrSendRequest => 'Send request';

  @override
  String hrLeaveCostCalendarDays(String days) {
    return '$days (calendar days)';
  }

  @override
  String hrLeaveCostWorkingDays(String days) {
    return '$days (working days)';
  }

  @override
  String get hrUnpaidLeaveNoLimit => 'unpaid leave has no yearly limit';

  @override
  String hrMoreThanYouHaveLeft(String days) {
    return '$days more than you have left';
  }

  @override
  String hrLeftAfterThis(String days) {
    return '$days left after this';
  }

  @override
  String get hrLeaveTakenNoLimit => 'taken · no yearly limit';

  @override
  String hrLeaveLeftOf(String days) {
    return 'left of $days';
  }

  @override
  String hrLeaveAwaitingApproval(String days) {
    return '$days awaiting approval';
  }

  @override
  String get hrLeaveRequestSent =>
      'Leave request sent. You will see it here once it is decided.';

  @override
  String get hrWithdrawRequestTitle => 'Withdraw this request?';

  @override
  String hrWithdrawRequestBody(String start, String end) {
    return 'Your leave from $start to $end will be cancelled and the days go back to your balance.';
  }

  @override
  String get hrKeepIt => 'Keep it';

  @override
  String get hrWithdraw => 'Withdraw';

  @override
  String get hrRequestWithdrawn => 'Request withdrawn.';

  @override
  String get hrCouldNotLoadYourRecord => 'Could not load your record';

  @override
  String get hrCouldNotLoadYourLeave => 'Could not load your leave';

  @override
  String get hrMyLeave => 'My leave';

  @override
  String hrBalancesFor(String name, String year) {
    return '$name · balances for $year';
  }

  @override
  String hrRequestsGoTo(String name) {
    return 'Requests go to $name';
  }

  @override
  String get hrEmploymentEndedNotice =>
      'Your employment has ended, so no new leave can be booked. Your history stays here.';

  @override
  String get hrRequests => 'Requests';

  @override
  String get hrNoLeaveBookedYet =>
      'No leave booked yet. Your balances above are what you have to spend this year.';

  @override
  String get hrNoEmployeeRecordTitle => 'No employee record for this account';

  @override
  String get hrNoEmployeeRecordLeaveBody =>
      'Leave is booked against a person on a branch roster, and this sign-in does not resolve to one yet. Ask whoever manages your roster to invite you from the People page — that is what links your record to this account. If they already did, check that the phone number on your record is the one you signed in with.';

  @override
  String get hrLeaveApproved => 'Leave approved.';

  @override
  String get hrLeaveRejected => 'Leave rejected.';

  @override
  String get hrLeave => 'Leave';

  @override
  String get hrWithTheirManager => 'With their manager';

  @override
  String get hrWithTheirManagerCaption =>
      'Their own manager has not answered yet. Deciding one of these answers it over their head.';

  @override
  String get hrDecided => 'Decided';

  @override
  String get hrNothingWaitingOnYouShort => 'Nothing waiting on you';

  @override
  String hrRequestsWaitingOnYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count requests waiting on you',
      one: '1 request waiting on you',
    );
    return '$_temp0';
  }

  @override
  String hrWithAnotherManager(String count) {
    return '$count with another manager';
  }

  @override
  String get hrYourTeam => 'Your team';

  @override
  String get hrApproveThisLeave => 'Approve this leave?';

  @override
  String get hrRejectThisLeave => 'Reject this leave?';

  @override
  String get hrRejectReasonLabel => 'Why? (shown to them)';

  @override
  String get hrApprove => 'Approve';

  @override
  String get hrReject => 'Reject';

  @override
  String get hrOnlyTheirManagerCanAnswer =>
      'Only their manager can answer this one.';

  @override
  String get hrNoLeaveRequestsYet => 'No leave requests yet';

  @override
  String get hrNoLeaveRequestsOwnerHint =>
      'Invite people from the People page and they can book their own leave. Set who each person reports to and their requests go to that manager; anyone with no manager lands here.';

  @override
  String get hrNoLeaveRequestsManagerHint =>
      'Requests from anyone who reports to you will appear here for you to approve.';

  @override
  String get hrErrorLoadPeopleOnBranch =>
      'Could not load the people on this branch.';

  @override
  String get hrErrorLoadPersonRecord => 'Could not load this person\'s record.';

  @override
  String hrErrorAddPerson(String name) {
    return 'Could not add $name.';
  }

  @override
  String hrErrorSavePerson(String name) {
    return 'Could not save changes to $name.';
  }

  @override
  String get hrErrorLinkAccount =>
      'The invite was sent, but this record could not be linked to the new account. Their leave will not resolve until it is.';

  @override
  String hrErrorChangeStatus(String status) {
    return 'Could not change this person to $status.';
  }

  @override
  String get hrThisPerson => 'this person';

  @override
  String get hrErrorLoadYourLeave => 'Could not load your leave.';

  @override
  String get hrErrorLoadBranchLeave => 'Could not load leave for this branch.';

  @override
  String get hrErrorLoadTeamLeave => 'Could not load leave for your team.';

  @override
  String get hrErrorSendLeaveRequest => 'Could not send this leave request.';

  @override
  String get hrErrorWithdrawRequest =>
      'Could not withdraw this request. It may already have been decided.';

  @override
  String get hrErrorApproveAlreadyDecided =>
      'Could not approve this request: it has already been decided or withdrawn. Refresh to see where it stands.';

  @override
  String get hrErrorRejectAlreadyDecided =>
      'Could not reject this request: it has already been decided or withdrawn. Refresh to see where it stands.';

  @override
  String get hrErrorApproveRequest => 'Could not approve this request.';

  @override
  String get hrErrorRejectRequest => 'Could not reject this request.';

  @override
  String get hrErrorLoadDayAttendance =>
      'Could not load attendance for this day.';

  @override
  String get hrErrorLoadTimesheet => 'Could not load this timesheet.';

  @override
  String get hrErrorCheckClockedIn =>
      'Could not check whether you are clocked in.';

  @override
  String get hrErrorCorrectEntry => 'Could not correct this entry.';

  @override
  String get hrErrorServerReturnedNothing =>
      'The server accepted the punch but returned nothing to show.';

  @override
  String get hrErrorClockInNotAllowed =>
      'You are not allowed to clock in for this person.';

  @override
  String get hrErrorClockOutNotAllowed =>
      'You are not allowed to clock out for this person.';

  @override
  String get hrErrorClockIn => 'Could not clock in.';

  @override
  String get hrErrorClockOut => 'Could not clock out.';

  @override
  String get hrErrorLoadYourTeam => 'Could not load your team.';

  @override
  String hrErrorResolveAccess(String error) {
    return 'Could not work out what you have access to: $error';
  }

  @override
  String get hrRoleStaffLabel => 'Staff — books own leave';

  @override
  String get hrRoleManagerLabel => 'Manager — roster and approvals';

  @override
  String get hrRoleStaff => 'Staff';

  @override
  String get hrRoleManager => 'Manager';

  @override
  String hrInviteTitle(String name) {
    return 'Invite $name to HR';
  }

  @override
  String get hrInviteNoContact =>
      'This record has no phone number or email, so there is nowhere to send an invite. Add one first.';

  @override
  String hrInviteWillGetPin(String contact) {
    return 'They will get a PIN to sign in at hr.useflipper.com with, confirmed by a code sent to $contact.';
  }

  @override
  String get hrInviteEmailNoPhone =>
      'This record has an email but no phone number. Signing in needs a code sent by SMS, so add a phone number before inviting.';

  @override
  String get hrInviteAlreadyHasAccount =>
      'They already have an account. Inviting again issues a fresh PIN and updates what they can do — it does not create a second person.';

  @override
  String hrInviteDirectReports(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count people report to them, so they will approve that leave whichever role you pick. The roster and everyone else\'s pay is what the manager role adds.',
      one:
          '1 person reports to them, so they will approve that leave whichever role you pick. The roster and everyone else\'s pay is what the manager role adds.',
    );
    return '$_temp0';
  }

  @override
  String get hrInviteWhatCanTheyDo => 'What can they do?';

  @override
  String get hrSendInvite => 'Send invite';

  @override
  String get hrRoleStaffDescription =>
      'Sees their own record, books leave and checks their balance — plus approves leave for anyone who reports to them.';

  @override
  String get hrRoleManagerDescription =>
      'Everything above, plus the branch roster, pay, and approving leave for the whole business.';

  @override
  String get hrInviteSent => 'Invite sent';

  @override
  String hrInviteCanNowSignIn(String name, String role) {
    return '$name can now sign in at hr.useflipper.com as $role.';
  }

  @override
  String get hrCopyPin => 'Copy PIN';

  @override
  String get hrPinCopied => 'PIN copied.';

  @override
  String hrInvitePinHelp(String phone) {
    return 'Signing in asks for this PIN, then a code sent to $phone. Pass the PIN on now — it is not shown again, and a lost one is replaced by inviting them a second time.';
  }

  @override
  String get hrInviteNeedsContact =>
      'A phone number or email is needed before this person can be invited.';

  @override
  String hrInviteErrorAccount(String contact) {
    return 'Could not find or create a Flipper account for $contact.';
  }

  @override
  String hrInviteErrorNoAccountId(String contact) {
    return 'Flipper answered without an account id for $contact.';
  }

  @override
  String get hrInviteErrorNoMembershipId =>
      'The membership was created but Flipper did not return its id.';

  @override
  String hrInviteErrorGrantAccess(String name, String error) {
    return 'Could not give $name access to this business: $error';
  }

  @override
  String hrInviteErrorCreatePin(String name) {
    return 'Could not create a sign-in PIN for $name.';
  }

  @override
  String get hrInviteErrorNoPin =>
      'The PIN was requested but Flipper did not return one.';

  @override
  String get hrInviteErrorNoMembership =>
      'The account was created but has no membership for this business, so signing in would land nowhere. Try inviting this person again.';

  @override
  String hrInviteErrorConfirmMembership(String error) {
    return 'Could not confirm the new membership: $error';
  }

  @override
  String get hrInviteErrorTimeout =>
      'Flipper did not answer in time — check the connection and try again.';

  @override
  String get hrInviteErrorNotJson =>
      'Flipper answered with something that is not JSON:';

  @override
  String get hrEnterValidMomoNumber =>
      'Enter a valid MTN or Airtel number, e.g. 0788123456.';

  @override
  String get hrMomoUnreadableReply =>
      'The payment gateway sent an unreadable reply.';

  @override
  String get hrMomoNoReference =>
      'The payment started but no reference came back — check your Mobile Money statement before trying again.';

  @override
  String get hrMomoMissingReference => 'Missing payment reference.';

  @override
  String get hrMomoRejectedInvalid =>
      'The payment request was rejected as invalid.';

  @override
  String get hrMomoNotAuthorised =>
      'This account is not authorised to take payments.';

  @override
  String get hrMomoServiceNotFound => 'The payment service could not be found.';

  @override
  String get hrMomoAlreadySubmitted =>
      'That payment has already been submitted.';

  @override
  String get hrMomoUnavailable =>
      'Mobile Money is unavailable right now. Please try again shortly.';

  @override
  String hrMomoCouldNotStart(String status) {
    return 'The payment could not be started (HTTP $status).';
  }

  @override
  String get hrErrorCheckSubscription =>
      'Could not check this business\'s subscription.';

  @override
  String get hrErrorLoadPlanPrice => 'Could not load the price of this plan.';

  @override
  String get hrErrorStartSubscription => 'Could not start the subscription.';

  @override
  String get hrErrorSkipPayment => 'Could not skip this payment.';

  @override
  String get hrPreparingSubscription => 'Preparing your subscription…';

  @override
  String hrErrorStartSubscriptionWith(String error) {
    return 'Could not start the subscription: $error';
  }

  @override
  String get hrSubscriptionAlreadyActive =>
      'This subscription is already active.';

  @override
  String get hrSendingRequestToPhone => 'Sending the request to your phone…';

  @override
  String hrPaymentCouldNotStartWith(String error) {
    return 'The payment could not be started: $error';
  }

  @override
  String get hrApproveMomoOnPhone =>
      'Approve the Mobile Money request on your phone.';

  @override
  String get hrPaymentReceivedActive =>
      'Payment received. Your subscription is active.';

  @override
  String get hrPaymentNotCompleted =>
      'The payment was not completed on your phone.';

  @override
  String get hrPaymentNoVerdictYet =>
      'We have not had a verdict from Mobile Money yet. If you approved the request, it will unlock shortly — check again in a moment.';

  @override
  String get hrSubscriptionEnded => 'Your subscription has ended';

  @override
  String get hrThisNeedsSubscription => 'This needs a subscription';

  @override
  String hrFeatureNeedsSubscription(String feature) {
    return '$feature needs a subscription';
  }

  @override
  String get hrSubscriptionEndedBody =>
      'Nothing has been deleted — the roster, leave and attendance records are all still here. Renew the subscription to open them again.';

  @override
  String get hrSubscriptionPitch =>
      'Flipper HR is part of the Flipper subscription. Pay for the business once and the roster, leave and attendance open for everyone on it.';

  @override
  String get hrPaymentOnItsWay =>
      'A payment is already on its way. If you approved it on your phone, this unlocks as soon as Mobile Money confirms it.';

  @override
  String get hrRenewNow => 'Renew now';

  @override
  String get hrSeeThePlan => 'See the plan';

  @override
  String get hrSubscriptionCheckFailedOpen =>
      'Could not check this business\'s subscription, so it is being left open for now.';

  @override
  String get hrTestPricingOn =>
      'Test pricing is switched on for this project, so subscriptions are charged at a reduced amount.';

  @override
  String hrSkipEndsSoon(String used, String max) {
    return 'You\'re using free access without paying ($used of $max skips used). It ends soon.';
  }

  @override
  String hrSkipEndsToday(String used, String max) {
    return 'You\'re using free access without paying ($used of $max skips used). It ends today.';
  }

  @override
  String hrSkipEndsInDays(int days, String used, String max) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other:
          'You\'re using free access without paying ($used of $max skips used). It ends in $days days.',
      one:
          'You\'re using free access without paying ($used of $max skips used). It ends in 1 day.',
    );
    return '$_temp0';
  }

  @override
  String get hrPayNow => 'Pay now';

  @override
  String get hrSubscriptionEndsToday => 'Your subscription ends today.';

  @override
  String get hrSubscriptionEndsTomorrow => 'Your subscription ends tomorrow.';

  @override
  String hrSubscriptionEndsInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Your subscription ends in $days days.',
      one: 'Your subscription ends in 1 day.',
    );
    return '$_temp0';
  }

  @override
  String get hrRenew => 'Renew';

  @override
  String get hrFeatureDashboard => 'The dashboard';

  @override
  String get hrFeatureRoster => 'The roster';

  @override
  String get hrFeatureAttendanceBoard => 'The attendance board';

  @override
  String hrErrorSkipPaymentWith(String error) {
    return 'Could not skip this payment: $error';
  }

  @override
  String get hrSkipping => 'Skipping…';

  @override
  String hrSkipForNow(String count) {
    return 'Skip for now ($count left)';
  }

  @override
  String get hrSubscribePickBusiness =>
      'Pick the business you are paying for, then the plan and its price appear here.';

  @override
  String get hrChooseABusiness => 'Choose a business';

  @override
  String hrCouldNotLoadPlan(String error) {
    return 'Could not load the plan: $error';
  }

  @override
  String get hrRenewYourSubscription => 'Renew your subscription';

  @override
  String get hrSubscribeToFlipper => 'Subscribe to Flipper';

  @override
  String get hrPeriodYearly => 'Yearly';

  @override
  String hrTestPricingNormally(String amount, String period) {
    return 'Test pricing is on — normally $amount $period.';
  }

  @override
  String get hrWhatBusinessIsUsing => 'What this business is using';

  @override
  String get hrUsagePosUsers => 'POS users';

  @override
  String get hrUsageBranches => 'Branches';

  @override
  String get hrUsageHrEmployees => 'HR employees';

  @override
  String hrUsageUnlimited(String used) {
    return '$used · unlimited';
  }

  @override
  String hrUsageOf(String used, String cap) {
    return '$used of $cap';
  }

  @override
  String get hrMomoNumberLabel => 'Mobile Money number';

  @override
  String get hrPaymentReceived => 'Payment received.';

  @override
  String get hrOpenFlipperHr => 'Open Flipper HR';

  @override
  String get hrPreparing => 'Preparing…';

  @override
  String get hrWaitingForApproval => 'Waiting for your approval…';

  @override
  String hrPayWithMomo(String amount) {
    return 'Pay $amount with Mobile Money';
  }

  @override
  String hrMomoPromptNote(String amount) {
    return 'You will get a Mobile Money prompt on this number. Approving it charges $amount.';
  }

  @override
  String get hrPerYear => 'per year';

  @override
  String get hrPerMonth => 'per month';

  @override
  String get hrExpandMenu => 'Expand the menu';

  @override
  String get hrCollapseMenu => 'Collapse the menu';

  @override
  String get hrSearchPeople => 'Search people…';

  @override
  String get hrSwitchBusinessOrBranch => 'Switch business or branch';

  @override
  String get hrSigningOut => 'Signing out…';

  @override
  String get hrNavYou => 'You';

  @override
  String get hrAttendance => 'Attendance';

  @override
  String get hrMyTime => 'My time';

  @override
  String get hrPickBranchToContinue => 'Pick a branch to continue';

  @override
  String get hrPickBranchBody =>
      'HR records belong to a branch, so choose the one you are working on.';

  @override
  String get hrChooseBusinessOrBranch => 'Choose business or branch';

  @override
  String hrCouldNotCheckSession(String error) {
    return 'Could not check your session: $error';
  }

  @override
  String hrCouldNotLoadBusinesses(String error) {
    return 'Could not load your businesses: $error';
  }

  @override
  String get hrBackToSignIn => 'Back to sign in';

  @override
  String get hrBrandTagline =>
      'Your team, your time, your people — all in one place.';

  @override
  String get hrBrandSubtitle =>
      'Attendance, payroll, and leave are ready the moment you sign in.';

  @override
  String get hrBrandStatEmployees => 'employees managed';

  @override
  String get hrBrandStatPayroll => 'payroll processed monthly';

  @override
  String get hrBrandStatUptime => 'uptime';

  @override
  String get hrBrandPayrollThisMonth => 'Payroll · this month';

  @override
  String get hrBrandNewHire => 'New hire';

  @override
  String get hrBrandDayOne => 'Day 1';

  @override
  String get hrBrandAttendanceStreak => 'Attendance streak';

  @override
  String get hrClockedInToast => 'Clocked in.';

  @override
  String hrClockedOutToast(String worked) {
    return 'Clocked out — $worked today.';
  }

  @override
  String hrYourHoursForLastDays(String days) {
    return 'Your hours for the last $days days.';
  }

  @override
  String get hrNoRecordNoHours =>
      'You do not have an employee record on this account yet, so there are no hours to track. Ask whoever manages HR to add you.';

  @override
  String get hrRecentDays => 'Recent days';

  @override
  String hrClockedInAt(String time) {
    return 'Clocked in at $time';
  }

  @override
  String get hrNotClockedInToday => 'Not clocked in today';

  @override
  String hrLastOutAt(String time) {
    return 'Last out at $time';
  }

  @override
  String get hrClockOut => 'Clock out';

  @override
  String get hrClockIn => 'Clock in';

  @override
  String hrWorkedInDays(String worked, String days) {
    return '$worked in $days days';
  }

  @override
  String get hrToday => 'Today';

  @override
  String get hrOvernight => 'overnight';

  @override
  String get hrNoHours => 'No hours';

  @override
  String hrSessionUntilNow(String start) {
    return '$start – now';
  }

  @override
  String hrBreakDuration(String duration) {
    return '$duration break';
  }

  @override
  String hrPersonClockedIn(String name) {
    return '$name is clocked in.';
  }

  @override
  String hrPersonClockedOut(String name) {
    return '$name is clocked out.';
  }

  @override
  String get hrAttendanceNoOneOnBranch =>
      'No one is on this branch yet. Add people first, then their hours can be recorded here.';

  @override
  String get hrOnRoster => 'On roster';

  @override
  String get hrRecorded => 'Recorded';

  @override
  String get hrHours => 'Hours';

  @override
  String get hrChangeDay => 'Change day';

  @override
  String get hrNoHoursToday => 'No hours today';

  @override
  String hrInAt(String time) {
    return 'In $time';
  }

  @override
  String hrOutAt(String time) {
    return 'out $time';
  }

  @override
  String hrSessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions',
      one: '1 session',
    );
    return '$_temp0';
  }

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authToContinueToAccount => 'to continue to your account';

  @override
  String get authEnterYourEmail => 'Enter your email';

  @override
  String get authPleaseEnterEmail => 'Please enter your email';

  @override
  String get authPleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get authPassword => 'Password';

  @override
  String get authEnterYourPassword => 'Enter your password';

  @override
  String get authPleaseEnterPassword => 'Please enter your password';

  @override
  String get authPasswordMinLength => 'Password must be at least 6 characters';

  @override
  String get authKeepMeSignedIn => 'Keep me signed in';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authNoAccountPrompt => 'Don\'t have an account?';

  @override
  String get authCreateOne => 'Create one';

  @override
  String get authCreateYourAccount => 'Create your account';

  @override
  String get authSignupSubtitle =>
      'Start with the same secure signup flow, now tuned for a faster mobile setup.';

  @override
  String get authFullName => 'Full name';

  @override
  String get authEnterFullName => 'Enter your full name';

  @override
  String get authPleaseEnterName => 'Please enter your name';

  @override
  String get authHidePassword => 'Hide password';

  @override
  String get authShowPassword => 'Show password';

  @override
  String get authConfirmPassword => 'Confirm password';

  @override
  String get authConfirmYourPassword => 'Confirm your password';

  @override
  String get authPleaseConfirmPassword => 'Please confirm your password';

  @override
  String get authPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get authCreateAccountButton => 'Create account';

  @override
  String get authAlreadyHaveAccount => 'Already have an account? Sign in';

  @override
  String get authBusinessSetup => 'Business setup';

  @override
  String get authAuthenticator => 'Authenticator';

  @override
  String get authAddAccount => 'Add account';

  @override
  String get authSomethingWentWrong => 'Something went wrong';

  @override
  String get authUnexpectedErrorTryAgain =>
      'An unexpected error occurred. Please try again.';

  @override
  String get authTryAgain => 'Try again';

  @override
  String get authNoAccountsAdded => 'No accounts added';

  @override
  String get authAddFirstAccountHint =>
      'Add your first account to start generating verification codes';

  @override
  String get authCodeCopied => 'Code copied to clipboard';

  @override
  String get authInvalidQrCode => 'Invalid QR code';

  @override
  String get authAccountAdded => 'Account added successfully';

  @override
  String authFailedToAddAccount(String error) {
    return 'Failed to add account: $error';
  }

  @override
  String get personalReadyForAdventure => 'Ready for adventure?';

  @override
  String personalDayStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count day streak!',
      one: '1 day streak!',
    );
    return '$_temp0';
  }

  @override
  String get personalTodaysProgress => 'Today\'s Progress';

  @override
  String personalCompletedOf(String done, String total) {
    return '$done/$total completed';
  }

  @override
  String get personalXpProgress => 'XP Progress';

  @override
  String personalXpToday(String xp) {
    return '+$xp XP today';
  }

  @override
  String get personalFindChallenges => 'Find challenges';

  @override
  String get personalViewRewards => 'View rewards';

  @override
  String get personalLeaderboard => 'Leaderboard';

  @override
  String get personalRecentAchievements => 'Recent Achievements';

  @override
  String get personalOpeningAchievements => 'Opening all achievements!';

  @override
  String get personalViewAll => 'View all';

  @override
  String get personalAchievementFirstSteps => 'First Steps';

  @override
  String get personalAchievementExplorer => 'Explorer';

  @override
  String get personalAchievementStreakMaster => 'Streak Master';

  @override
  String get personalAchievementSocialStar => 'Social Star';

  @override
  String get personalHowToLevelUp => 'How to Level Up';

  @override
  String get personalDiscoverQuests => 'Discover Hidden Quests';

  @override
  String get personalDiscoverQuestsBody =>
      'Visit local businesses to unlock secret challenges and earn bonus XP!';

  @override
  String get personalDailyChallenges => 'Complete Daily Challenges';

  @override
  String get personalDailyChallengesBody =>
      'Maintain your streak and climb the leaderboard with friends!';

  @override
  String get personalTeamUp => 'Team Up with Friends';

  @override
  String get personalTeamUpBody =>
      'Join forces for group challenges and earn multiplier bonuses!';

  @override
  String get personalAdventureBegins => 'Let the adventure begin! 🚀';

  @override
  String get personalStartAdventure => 'Start Your Adventure!';

  @override
  String get personalSyncingAdventures => 'Syncing with nearby adventures...';

  @override
  String get personalLoggingOut => 'Logging out...';

  @override
  String get personalLoggedOut => 'Successfully logged out!';

  @override
  String personalLogoutFailed(String error) {
    return 'Logout failed: $error';
  }

  @override
  String get personalCouldNotDetermineLocation =>
      'Could not determine your location.';

  @override
  String get personalBusinessIdNotFound =>
      'Business ID not found. Please login again.';

  @override
  String get personalFailedToFetchChallenges => 'Failed to fetch challenges';

  @override
  String get personalFailedToFetchChallengesRetry =>
      'Failed to fetch challenges. Please try again.';

  @override
  String get personalYourRewards => 'Your Rewards';

  @override
  String get personalRewardFreeCoffee => 'Free Coffee';

  @override
  String get personalRewardFreeCoffeeBody =>
      'Get a free coffee from our partner cafes.';

  @override
  String get personalRewardDiscount => '10% Discount';

  @override
  String get personalRewardDiscountBody =>
      'Enjoy a 10% discount on your next purchase.';

  @override
  String get personalRewardEarlyAccess => 'Early Access';

  @override
  String get personalRewardEarlyAccessBody =>
      'Get early access to new features.';

  @override
  String get personalChallengeDiscovered => 'Challenge Discovered!';

  @override
  String get personalRewardAvailable => 'Reward Available!';

  @override
  String get personalLater => 'Later';

  @override
  String get personalClaimReward => 'Claim Reward';

  @override
  String get personalFailedToClaimReward =>
      'Failed to claim reward. Please try again.';

  @override
  String get personalRewardClaimed => 'Reward claimed successfully!';

  @override
  String personalErrorLoadingRewards(String error) {
    return 'Error loading rewards: $error';
  }

  @override
  String get personalChallengeClaimed => 'Challenge Claimed';

  @override
  String personalClaimedOn(String date) {
    return 'Claimed on $date';
  }

  @override
  String personalBusinessLabel(String business) {
    return 'Business: $business';
  }

  @override
  String personalRewardLabel(String reward) {
    return 'Reward: $reward';
  }

  @override
  String get personalSpecialReward => 'Special reward';

  @override
  String get personalClaim => 'Claim';

  @override
  String get personalNoChallengesNearby =>
      'No challenges found nearby. Try moving around!';

  @override
  String get personalTapToDiscover => 'Tap to discover challenges nearby';

  @override
  String get personalTapToSearchAgain => 'Tap to search again';

  @override
  String get personalSearchingChallenges =>
      'Searching for nearby challenges...';

  @override
  String get personalChallengesFound => 'Challenges Found!';

  @override
  String personalNearbyRewards(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nearby rewards',
      one: '1 nearby reward',
    );
    return '$_temp0';
  }

  @override
  String get personalChallengeClaimedToast =>
      'Challenge claimed successfully! 🎉';

  @override
  String personalFailedToClaimChallenge(String error) {
    return 'Failed to claim challenge: $error';
  }

  @override
  String get manualPurchaseSellPrice => 'Sell price';

  @override
  String get cashbookSelectDates => 'Select dates';

  @override
  String get cashbookSaveCashIn => 'Save cash in';

  @override
  String get cashbookSaveCashOut => 'Save cash out';

  @override
  String get cashbookNewEntry => 'New';

  @override
  String get cashbookEnterValidAmount => 'Please enter a valid amount';

  @override
  String get cashbookToday => 'Today';

  @override
  String get cashbookYesterday => 'Yesterday';

  @override
  String get cashbookListNoMovements => 'No cash movements yet';

  @override
  String cashbookListNoFilterEntries(String filter) {
    return 'No $filter entries';
  }

  @override
  String get cashbookListEmptyHint =>
      'Record money coming in or going out with the buttons below.';

  @override
  String cashbookListNothingMatches(String period) {
    return 'Nothing matches this filter for $period.';
  }

  @override
  String get cashbookViewAll => 'View all';

  @override
  String get cashbookMoneyInLabel => 'Money in';

  @override
  String get cashbookMoneyOutLabel => 'Money out';

  @override
  String get manualPurchaseSellingPriceOptional => 'Selling price (optional)';

  @override
  String get txDetailCategory => 'Category';

  @override
  String get txDetailNote => 'Note';

  @override
  String get manualPurchaseSellAtCostHelper => 'Leave empty to sell at cost';

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

  @override
  String get webPricingTitle => 'Simple, transparent pricing';

  @override
  String get webPlanMobile => 'Mobile';

  @override
  String get webPlanMobileDesktop => 'Mobile + Desktop';

  @override
  String get webPlanEnterprise => 'Enterprise';

  @override
  String get webCurrencyPerMonth => 'RWF / month';

  @override
  String get webFeatureMobileAppAccess => 'Mobile app access';

  @override
  String get webFeatureBasicBusinessTools => 'Basic business tools';

  @override
  String get webFeatureDataEncryption => 'Data encryption';

  @override
  String get webFeatureSingleDevice => 'Single device';

  @override
  String get webFeatureTaxReportingAddon => '+ Tax reporting (+30,000 RWF)';

  @override
  String get webFeatureMobileDesktopAppAccess => 'Mobile + Desktop app access';

  @override
  String get webFeatureAdvancedBusinessTools => 'Advanced business tools';

  @override
  String get webFeatureMilitaryGradeEncryption => 'Military-grade encryption';

  @override
  String get webFeaturePrioritySupport => 'Priority support';

  @override
  String get webFeatureMultipleDevices => 'Multiple devices';

  @override
  String get webFeatureAdvancedAnalytics => 'Advanced analytics';

  @override
  String get webFeatureFullPlatformAccess => 'Full platform access';

  @override
  String get webFeatureEnterpriseGradeSecurity => 'Enterprise-grade security';

  @override
  String get webFeature247DedicatedSupport => '24/7 dedicated support';

  @override
  String get webFeatureUnlimitedUsersBranches => 'Unlimited users & branches';

  @override
  String get webFeatureCustomIntegrations => 'Custom integrations';

  @override
  String get webFeaturePremiumTaxConsulting =>
      '+ Premium tax consulting (+400,000 RWF)';

  @override
  String get webGetStarted => 'Get started';

  @override
  String get booksReceivables => 'Receivables';

  @override
  String get booksBills => 'Bills';

  @override
  String get booksSuppliers => 'Suppliers';

  @override
  String get booksPayables => 'Payables';

  @override
  String get booksJournalEntries => 'Journal entries';

  @override
  String get booksGeneralLedger => 'General ledger';

  @override
  String get booksRecurring => 'Recurring';

  @override
  String get booksBankReconciliation => 'Bank reconciliation';

  @override
  String get booksFinancialStatements => 'Financial statements';

  @override
  String get booksTrialBalance => 'Trial balance';

  @override
  String get booksTaxVat => 'Tax & VAT';

  @override
  String get booksChartOfAccounts => 'Chart of accounts';

  @override
  String get booksPeriodClose => 'Period close';

  @override
  String get booksAuditTrail => 'Audit trail';

  @override
  String get booksUsersRoles => 'Users & roles';

  @override
  String get booksOverview => 'Overview';

  @override
  String get booksDaybook => 'Daybook';

  @override
  String get booksSetup => 'Setup';

  @override
  String get booksCompliance => 'Compliance';

  @override
  String booksClosingBalance(String amount) {
    return 'Closing $amount';
  }

  @override
  String booksAccountPostingHistory(String currency) {
    return 'Account-level posting history · $currency';
  }

  @override
  String get booksReadingStatement => 'Reading statement…';

  @override
  String get booksStatementImported => 'Statement imported';

  @override
  String booksStatementLinesLoaded(int count, String source) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lines loaded',
      one: '1 line loaded',
    );
    return '$source · $_temp0';
  }

  @override
  String get booksImportFailed => 'Import failed';

  @override
  String get booksMatchDifferentAccountTitle => 'Match on a different account?';

  @override
  String booksMatchDifferentAccountBody(
    String account,
    String amount,
    String bankCode,
    String code,
  ) {
    return 'This journal entry moves $amount on $account ($code), not Bank ($bankCode). Match anyway?';
  }

  @override
  String get booksMatch => 'Match';

  @override
  String get booksBankLineMatched => 'Bank line matched';

  @override
  String get booksBankCatSaleIncome => 'A sale / income';

  @override
  String get booksBankCatSaleIncomeHint => 'Money you earned';

  @override
  String get booksBankCatCustomerPaid => 'A customer paid a debt';

  @override
  String get booksBankCatCustomerPaidHint => 'They owed you before';

  @override
  String get booksBankCatOwnerAdded => 'Owner added money';

  @override
  String get booksBankCatOwnerAddedHint => 'Capital you put in';

  @override
  String get booksBankCatLoanReceived => 'A loan you received';

  @override
  String get booksBankCatLoanReceivedHint => 'Borrowed money';

  @override
  String get booksBankCatFromCash => 'Transfer from cash';

  @override
  String get booksBankCatFromCashHint => 'Moved from your cash box';

  @override
  String get booksBankCatFromMomo => 'Transfer from Mobile Money';

  @override
  String get booksBankCatFromMomoHint => 'Moved from MoMo';

  @override
  String get booksBankCatOtherIncome => 'Other income';

  @override
  String get booksBankCatOtherIncomeHint => 'Anything else received';

  @override
  String get booksBankCatBankFee => 'Bank fee / charge';

  @override
  String get booksBankCatBankFeeHint => 'Charges the bank took';

  @override
  String get booksBankCatPaidSupplier => 'Paid a supplier / bought stock';

  @override
  String get booksBankCatPaidSupplierHint => 'Inventory or goods';

  @override
  String get booksBankCatRent => 'Rent';

  @override
  String get booksBankCatRentHint => 'Shop or office rent';

  @override
  String get booksBankCatSalaries => 'Salaries / wages';

  @override
  String get booksBankCatSalariesHint => 'Paid staff';

  @override
  String get booksBankCatUtilities => 'Utilities';

  @override
  String get booksBankCatUtilitiesHint => 'Electricity, water, internet';

  @override
  String get booksBankCatTransport => 'Transport / fuel';

  @override
  String get booksBankCatTransportHint => 'Travel & delivery';

  @override
  String get booksBankCatLoanRepayment => 'Loan repayment';

  @override
  String get booksBankCatLoanRepaymentHint => 'Paid back a loan';

  @override
  String get booksBankCatOwnerWithdrew => 'Owner took money out';

  @override
  String get booksBankCatOwnerWithdrewHint => 'Personal withdrawal';

  @override
  String get booksBankCatToCash => 'Transfer to cash';

  @override
  String get booksBankCatToCashHint => 'Moved to your cash box';

  @override
  String get booksBankCatToMomo => 'Transfer to Mobile Money';

  @override
  String get booksBankCatToMomoHint => 'Moved to MoMo';

  @override
  String get booksBankCatOtherExpense => 'Other expense';

  @override
  String get booksBankCatOtherExpenseHint => 'Anything else you paid';

  @override
  String get booksEntryCreatedMatched => 'Entry created & matched';

  @override
  String booksEntryCreatedMatchedDetail(
    String amount,
    String category,
    String ref,
  ) {
    return '$category — $amount on Bank ($ref)';
  }

  @override
  String get booksCouldNotCreateEntry => 'Could not create entry';

  @override
  String get booksWhereMoneyFrom => 'Where did this money come from?';

  @override
  String get booksWhatPaymentFor => 'What was this payment for?';

  @override
  String get booksPickClosestMatch =>
      'Pick the closest match — we\'ll record it correctly for you.';

  @override
  String get booksMatchBankLine => 'Match bank line';

  @override
  String get booksBank => 'Bank';

  @override
  String booksBankRecSubtitle(String bank, String currency, String period) {
    return 'Bank · $bank · statement $period · $currency';
  }

  @override
  String get booksImportStatement => 'Import statement';

  @override
  String get booksReconciled => 'Reconciled';

  @override
  String get booksFinishReconciliation => 'Finish reconciliation';

  @override
  String get booksReconciliationComplete => 'Reconciliation complete';

  @override
  String booksLinesMatchedOfTotal(String matched, String total) {
    return '$matched of $total lines matched';
  }

  @override
  String get booksStatementBalance => 'Statement balance';

  @override
  String get booksFromImportedStatement => 'from imported statement';

  @override
  String get booksMatched => 'Matched';

  @override
  String get booksNoLinesYet => 'no lines yet';

  @override
  String booksOfTotal(String total) {
    return 'of $total';
  }

  @override
  String get booksNeedsAttention => 'Needs attention';

  @override
  String get booksStatementLines => 'Statement lines';

  @override
  String get booksMatchEachLine => 'Match each bank line to a journal entry';

  @override
  String get booksNoStatementLines =>
      'No bank statement lines yet. Import a statement to begin.';

  @override
  String booksVatSubtitle(String period, String rate) {
    return 'VAT at $rate% (Rwanda standard) · period $period';
  }

  @override
  String get booksFileWithRra => 'File with RRA';

  @override
  String get booksVatReturnSubmitted => 'VAT return submitted';

  @override
  String booksRraAckRef(String ref) {
    return 'RRA ack · ref $ref';
  }

  @override
  String get booksOutputVatOnSales => 'Output VAT (on sales)';

  @override
  String get booksInputVatReclaimable => 'Input VAT (reclaimable)';

  @override
  String get booksNetVatPayable => 'Net VAT payable';

  @override
  String booksDueDate(String date) {
    return 'Due $date';
  }

  @override
  String get booksVatReturnSummary => 'VAT return summary';

  @override
  String get booksDraft => 'Draft';

  @override
  String get booksTotalSalesVatInclusive => 'Total sales (VAT-inclusive)';

  @override
  String get booksOutputVatCollected => 'Output VAT collected';

  @override
  String get booksInputVatOnPurchases => 'Input VAT on purchases';

  @override
  String get booksNetVatDueToRra => 'Net VAT due to RRA';

  @override
  String get booksPrint => 'Print';

  @override
  String get booksPreparingPrintLayout => 'Preparing print layout';

  @override
  String get booksGeneratingPdf => 'Generating PDF';

  @override
  String booksStatementPack(String currency) {
    return 'Statement pack · $currency';
  }

  @override
  String get booksIncomeStatement => 'Income statement';

  @override
  String get booksBalanceSheet => 'Balance sheet';

  @override
  String get booksCashFlow => 'Cash flow';

  @override
  String get booksNetRevenue => 'Net revenue';

  @override
  String get booksCogs => 'Cost of goods sold';

  @override
  String get booksGrossProfit => 'Gross profit';

  @override
  String get booksOperatingExpenses => 'Operating expenses';

  @override
  String get booksTotalAssets => 'Total assets';

  @override
  String get booksTotalLiabilities => 'Total liabilities';

  @override
  String get booksTotalEquity => 'Total equity';

  @override
  String get booksLiabilitiesPlusEquity => 'Liabilities + equity';

  @override
  String get booksOperatingActivities => 'Operating activities';

  @override
  String get booksInvestingActivities => 'Investing activities';

  @override
  String get booksFinancingActivities => 'Financing activities';

  @override
  String get booksNetChangeInCash => 'Net change in cash';

  @override
  String get booksBalancedAssetsEqual =>
      'Balanced — assets equal liabilities plus equity';

  @override
  String booksAsOfPeriod(String currency, String period) {
    return 'As of $period · $currency';
  }

  @override
  String get booksInBalance => 'In balance';

  @override
  String get booksOutOfBalance => 'Out of balance';

  @override
  String get booksNoAccountsYet => 'No accounts loaded yet.';

  @override
  String get booksTotals => 'Totals';

  @override
  String get booksAssets => 'Assets';

  @override
  String get booksLiabilities => 'Liabilities';

  @override
  String get booksEquity => 'Equity';

  @override
  String get booksIncome => 'Income';

  @override
  String get booksExpenses => 'Expenses';

  @override
  String booksCoaSubtitle(String count) {
    return '$count accounts · numbered ledger structure';
  }

  @override
  String get booksFilterByType => 'Filter by type';

  @override
  String get booksAllTypes => 'All types';

  @override
  String get booksFilter => 'Filter';

  @override
  String get booksAddAccount => 'Add account';

  @override
  String get booksNetIncome => 'Net income';

  @override
  String get booksNetLoss => 'Net loss';

  @override
  String get booksOpenOnWiderScreen =>
      'Open on a wider screen for the desktop workspace';

  @override
  String get booksFreqMonthly => 'Monthly';

  @override
  String get booksFreqWeekly => 'Weekly';

  @override
  String get booksFreqQuarterly => 'Quarterly';

  @override
  String get booksFreqYearly => 'Yearly';

  @override
  String get booksRoleOwner => 'Owner';

  @override
  String get booksRoleOwnerDesc =>
      'Full access — approve, post, file taxes, manage team';

  @override
  String get booksRoleBookkeeper => 'Bookkeeper';

  @override
  String get booksRoleBookkeeperDesc =>
      'Create & edit entries, invoices and bills; cannot approve or file';

  @override
  String get booksRoleCashier => 'Cashier';

  @override
  String get booksRoleCashierDesc => 'Record sales and receipts from POS only';

  @override
  String get booksRoleViewer => 'Viewer';

  @override
  String get booksRoleViewerDesc =>
      'Read-only access to reports and statements';

  @override
  String get booksCapViewReports => 'View reports & statements';

  @override
  String get booksCapCreateInvoicesBills => 'Create invoices & bills';

  @override
  String get booksCapRecordPayments => 'Record payments & receipts';

  @override
  String get booksCapPostJournal => 'Post & edit journal entries';

  @override
  String get booksCapApproveEntries => 'Approve entries';

  @override
  String get booksCapFileVat => 'File VAT with RRA';

  @override
  String get booksCapClosePeriods => 'Close periods & manage team';

  @override
  String get booksRecurringEntries => 'Recurring entries';

  @override
  String booksRecurringSubtitle(String currency) {
    return 'Rent, salaries and other repeating entries post themselves · $currency';
  }

  @override
  String get booksNewSchedule => 'New schedule';

  @override
  String get booksActiveSchedules => 'Active schedules';

  @override
  String booksCountOfTotal(String count, String total) {
    return '$count of $total';
  }

  @override
  String get booksMonthlyCommitted => 'Monthly committed';

  @override
  String get booksNextRun => 'Next run';

  @override
  String get booksNoRecurringYet =>
      'No recurring schedules yet. Create one to post rent, salaries or other repeating entries.';

  @override
  String get booksSchedule => 'Schedule';

  @override
  String get booksFrequency => 'Frequency';

  @override
  String get booksPostsTo => 'Posts to';

  @override
  String get booksStatus => 'Status';

  @override
  String get booksPaused => '— paused —';

  @override
  String get booksRunNow => 'Run now';

  @override
  String get booksScheduleResumed => 'Schedule resumed';

  @override
  String get booksSchedulePaused => 'Schedule paused';

  @override
  String get booksEntryPosted => 'Entry posted';

  @override
  String get booksAlreadyPostedThisPeriod => 'Already posted this period';

  @override
  String get booksCouldNotPostEntry => 'Could not post entry';

  @override
  String get booksScheduleCreated => 'Schedule created';

  @override
  String get booksScheduleUpdated => 'Schedule updated';

  @override
  String booksPeriodCloseSubtitle(String currency, String period) {
    return 'Lock $period once the books are final · $currency';
  }

  @override
  String booksPeriodLocked(String period) {
    return '$period locked';
  }

  @override
  String get booksReopenPeriod => 'Reopen period';

  @override
  String get booksCouldNotReopenPeriod => 'Could not reopen the period';

  @override
  String get booksPeriodReopened => 'Period reopened';

  @override
  String booksPeriodPostableAgain(String period) {
    return '$period is postable again';
  }

  @override
  String get booksClosePeriod => 'Close period';

  @override
  String get booksCouldNotClosePeriod => 'Could not close the period';

  @override
  String get booksPeriodClosed => 'Period closed';

  @override
  String booksPeriodLockedReadOnly(String period) {
    return '$period locked · entries are now read-only';
  }

  @override
  String get booksCloseChecklist => 'Close checklist';

  @override
  String booksStepsComplete(String done, String total) {
    return '$done of $total steps complete';
  }

  @override
  String get booksReview => 'Review';

  @override
  String get booksWhatClosingDoes => 'What closing does';

  @override
  String get booksCloseNoteLocks =>
      'Locks the period. Posted entries become read-only — no edits without re-opening.';

  @override
  String get booksCloseNoteRollsForward =>
      'Rolls forward. Net income is moved into retained earnings and balances carry into the next month.';

  @override
  String get booksCloseNoteAuditPoint =>
      'Creates an audit point. A snapshot is logged in the audit trail with your name and time.';

  @override
  String get booksAllChecksPassed => 'All checks passed — ready to close.';

  @override
  String get booksFinishChecklist =>
      'Finish every checklist step to enable closing.';

  @override
  String get booksAuditSubtitle =>
      'Every change, who made it, and when · immutable';

  @override
  String get booksAllUsers => 'All users';

  @override
  String get booksExport => 'Export';

  @override
  String get booksExportingAuditLog => 'Exporting audit log';

  @override
  String booksEventsCsv(String count) {
    return '$count events · CSV';
  }

  @override
  String get booksNoAuditEvents => 'No audit events yet.';

  @override
  String get booksRolesSubtitle => 'Control who can see and change the books';

  @override
  String get booksInviteTeammate => 'Invite teammate';

  @override
  String get booksInviteSent => 'Invite sent';

  @override
  String get booksInvitationsComingSoon => 'Team invitations coming soon';

  @override
  String booksTeamCount(String count) {
    return 'Team ($count)';
  }

  @override
  String get booksOnlyYouHaveAccess =>
      'Only you have access. Invite teammates to collaborate.';

  @override
  String get booksYou => 'You';

  @override
  String get booksRoles => 'Roles';

  @override
  String get booksCapability => 'Capability';

  @override
  String get booksActiveNow => 'Active now';

  @override
  String get booksRoleSystem => 'System';

  @override
  String get booksTaskAllPosted => 'All journal entries posted';

  @override
  String booksTaskPendingApproval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries still pending approval',
      one: '1 entry still pending approval',
    );
    return '$_temp0';
  }

  @override
  String get booksTaskNoPending => 'No pending entries';

  @override
  String get booksTaskBankReconciled => 'Bank accounts reconciled';

  @override
  String booksTaskLinesUnmatched(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count statement lines unmatched',
      one: '1 statement line unmatched',
    );
    return '$_temp0';
  }

  @override
  String get booksTaskAllLinesMatched => 'All lines matched';

  @override
  String get booksTaskReceivablesReviewed => 'Receivables reviewed';

  @override
  String get booksTaskNoOpenReceivables => 'No open receivables';

  @override
  String booksTaskAgingOverdue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aging confirmed · $count overdue invoices',
      one: 'Aging confirmed · 1 overdue invoice',
    );
    return '$_temp0';
  }

  @override
  String booksTaskAgingBalances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aging confirmed · $count balances',
      one: 'Aging confirmed · 1 balance',
    );
    return '$_temp0';
  }

  @override
  String get booksTaskPayablesReviewed => 'Payables reviewed';

  @override
  String get booksTaskNoOpenPayables => 'No open payables';

  @override
  String get booksTaskAllBillsEntered => 'All supplier bills entered';

  @override
  String get booksTaskVatPrepared => 'VAT return prepared';

  @override
  String get booksTaskNoVatActivity => 'No VAT activity in period';

  @override
  String booksTaskVatNetPayable(String amount, String date) {
    return 'Net payable $amount · due $date';
  }

  @override
  String get booksTaskDepreciationPosted => 'Depreciation posted';

  @override
  String get booksTaskDepreciationMaybePending =>
      'Pending entries may include depreciation';

  @override
  String get booksTaskDepreciationUpToDate => 'Depreciation up to date';

  @override
  String get booksStatusSent => 'Sent';

  @override
  String get booksStatusPartPaid => 'Part paid';

  @override
  String get booksStatusPaid => 'Paid';

  @override
  String get booksStatusOverdue => 'Overdue';

  @override
  String get booksSignOutTitle => 'Sign out?';

  @override
  String get booksSignOutBody =>
      'Ends your session and clears Ditto sync for this tab. Choose “Refresh from cloud” if you only need to reload Books data.';

  @override
  String get booksRefreshFromCloud => 'Refresh from cloud';

  @override
  String get booksResyncDitto => 'Re-sync Ditto data';

  @override
  String get booksSupplier => 'Supplier';

  @override
  String get booksAgingCurrent => 'Current';

  @override
  String get booksAging1to30 => '1–30 days';

  @override
  String get booksAging31to60 => '31–60 days';

  @override
  String get booksAging60plus => '60+ days';

  @override
  String get booksMoneyIn => 'Money in';

  @override
  String get booksMoneyOut => 'Money out';

  @override
  String get booksAccountsReceivable => 'Accounts receivable';

  @override
  String get booksAccountsPayable => 'Accounts payable';

  @override
  String booksArSubtitle(String currency) {
    return 'What customers owe you · aged · $currency';
  }

  @override
  String booksApSubtitle(String currency) {
    return 'What you owe suppliers · aged · $currency';
  }

  @override
  String get booksSendReminders => 'Send reminders';

  @override
  String get booksSchedulePayment => 'Schedule payment';

  @override
  String get booksRemindersSent => 'Reminders sent';

  @override
  String get booksPaymentScheduled => 'Payment scheduled';

  @override
  String booksEmailedCustomers(String count) {
    return 'Emailed $count customers with open balances';
  }

  @override
  String booksQueuedSupplierPayments(String count) {
    return 'Queued $count supplier payments';
  }

  @override
  String get booksNewInvoice => 'New invoice';

  @override
  String get booksNewBill => 'New bill';

  @override
  String get booksAgingSummary => 'Aging summary';

  @override
  String get booksReference => 'Reference';

  @override
  String get booksTotal => 'Total';

  @override
  String get booksStatementOfAccount => 'Statement of account';

  @override
  String booksOutstanding(String amount, String name) {
    return '$name · $amount outstanding';
  }

  @override
  String booksJournalSubtitle(String currency) {
    return 'Every transaction as a balanced double entry · $currency';
  }

  @override
  String get booksFilterBySource => 'Filter by source';

  @override
  String get booksAllSources => 'All sources';

  @override
  String get booksRecordExpense => 'Record expense';

  @override
  String get booksNewJournalEntry => 'New journal entry';

  @override
  String get booksFilterAll => 'All';

  @override
  String get booksFilterPosted => 'Posted';

  @override
  String get booksFilterPending => 'Pending';

  @override
  String get booksFilterDrafts => 'Drafts';

  @override
  String booksEntriesAwaitingApproval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries awaiting approval',
      one: '1 entry awaiting approval',
    );
    return '$_temp0';
  }

  @override
  String get booksNoEntriesMatchFilter => 'No entries match this filter.';

  @override
  String get booksDrAbbr => 'Dr';

  @override
  String get booksCrAbbr => 'Cr';

  @override
  String get booksFinancialOverview => 'Financial overview';

  @override
  String get booksAtAGlance => 'Books at a glance';

  @override
  String booksDashSubtitleEntity(
    String currency,
    String entity,
    String period,
  ) {
    return '$entity · fiscal period $period · all amounts in $currency';
  }

  @override
  String booksDashSubtitle(String currency, String period) {
    return 'Fiscal period $period · all amounts in $currency';
  }

  @override
  String get booksGeneralLedgerLines => 'General ledger lines';

  @override
  String get booksExportingExcel => 'Exporting to Excel';

  @override
  String get booksExportingCsv => 'Exporting CSV';

  @override
  String get booksExcelWorkbook => 'Excel workbook (.xlsx)';

  @override
  String get booksPdfReport => 'PDF report';

  @override
  String get booksCsvRawLedger => 'CSV (raw ledger)';

  @override
  String get booksVsPriorPeriod => 'vs prior period';

  @override
  String get booksCashAndBank => 'Cash & bank';

  @override
  String booksAcrossAccounts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'across $count accounts',
      one: 'across 1 account',
    );
    return '$_temp0';
  }

  @override
  String get booksReceivable => 'Receivable';

  @override
  String booksOverdue60(String amount) {
    return '$amount overdue 60+';
  }

  @override
  String get booksNoOverdue60 => 'no overdue 60+';

  @override
  String get booksPayable => 'Payable';

  @override
  String get booksNoOpenBills => 'no open bills';

  @override
  String booksOpenBills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count open bills',
      one: '1 open bill',
    );
    return '$_temp0';
  }

  @override
  String get booksRevenueVsExpenses => 'Revenue vs expenses';

  @override
  String get booksTrailing6Months => 'Trailing 6 months';

  @override
  String get booksWhereMoneyWent => 'Where money went';

  @override
  String get booksOpexBreakdown => 'Operating expenses breakdown';

  @override
  String get booksOpexShort => 'opex';

  @override
  String get booksRecentJournalEntries => 'Recent journal entries';

  @override
  String get booksNoJournalEntriesYet => 'No journal entries yet.';

  @override
  String get booksProfitLoss => 'Profit & loss';

  @override
  String booksDocAlreadyExists(String id) {
    return '$id already exists';
  }

  @override
  String get booksUseAnotherNumber => 'Use another number';

  @override
  String get booksBillSaved => 'Bill saved';

  @override
  String get booksDraftSaved => 'Draft saved';

  @override
  String get booksInvoiceSentPosted => 'Invoice sent & posted';

  @override
  String get booksBillRecordedPosted => 'Bill recorded & posted';

  @override
  String get booksPaymentRecorded => 'Payment recorded';

  @override
  String booksInvoicesSubtitle(String currency) {
    return 'Bill your customers and get paid · $currency';
  }

  @override
  String booksBillsSubtitle(String currency) {
    return 'Track what you owe your suppliers · $currency';
  }

  @override
  String get booksPdfSummary => 'PDF summary';

  @override
  String booksInvoicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count invoices',
      one: '1 invoice',
    );
    return '$_temp0';
  }

  @override
  String booksBillsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bills',
      one: '1 bill',
    );
    return '$_temp0';
  }

  @override
  String get booksOutstandingLabel => 'Outstanding';

  @override
  String get booksOwedToSuppliers => 'Owed to suppliers';

  @override
  String get booksDrafts => 'Drafts';

  @override
  String get booksNoInvoicesYet =>
      'No invoices yet. Create an invoice to get started.';

  @override
  String get booksNoBillsYet => 'No bills yet. Record a bill to get started.';

  @override
  String booksNoInvoicesInTab(String tab) {
    return 'No invoices in “$tab”.';
  }

  @override
  String booksNoBillsInTab(String tab) {
    return 'No bills in “$tab”.';
  }

  @override
  String get booksBill => 'Bill';

  @override
  String get booksDue => 'Due';

  @override
  String get booksOpenPreview => 'Open & preview';

  @override
  String get booksRecordPayment => 'Record payment';

  @override
  String get booksPayThisBill => 'Pay this bill';

  @override
  String get booksSendReminder => 'Send reminder';

  @override
  String get booksReminderSent => 'Reminder sent';

  @override
  String get booksDeleted => 'Deleted';

  @override
  String get booksCustomerAdded => 'Customer added';

  @override
  String get booksSupplierAdded => 'Supplier added';

  @override
  String booksCustomersSubtitle(String count) {
    return 'People and businesses you sell to · $count records';
  }

  @override
  String booksSuppliersSubtitle(String count) {
    return 'Vendors you buy from · $count records';
  }

  @override
  String get booksSearchCustomers => 'Search customers…';

  @override
  String get booksSearchSuppliers => 'Search suppliers…';

  @override
  String get booksNewCustomer => 'New customer';

  @override
  String get booksNewSupplier => 'New supplier';

  @override
  String get booksTotalCustomers => 'Total customers';

  @override
  String get booksTotalSuppliers => 'Total suppliers';

  @override
  String get booksWithOpenBalance => 'With open balance';

  @override
  String get booksWithBillsDue => 'With bills due';

  @override
  String get booksTotalReceivable => 'Total receivable';

  @override
  String get booksTotalPayable => 'Total payable';

  @override
  String get booksNoCustomersYet => 'No customers yet.';

  @override
  String get booksNoSuppliersYet => 'No suppliers yet.';

  @override
  String booksNoMatchesFor(String query) {
    return 'No matches for “$query”.';
  }

  @override
  String get booksContact => 'Contact';

  @override
  String get booksTerms => 'Terms';

  @override
  String get booksOwesYou => 'Owes you';

  @override
  String get booksYouOwe => 'You owe';

  @override
  String get booksViewRecord => 'View record';

  @override
  String get booksSendStatement => 'Send statement';

  @override
  String get booksCallContact => 'Call contact';

  @override
  String get booksStatementSent => 'Statement sent';

  @override
  String get booksNoPhoneOnFile => 'No phone on file';

  @override
  String booksDeleteNamed(String name) {
    return 'Delete $name?';
  }

  @override
  String get booksDeleteSharedContactBody =>
      'This contact is shared with the POS app. Deleting it removes the customer record everywhere; past sales keep their snapshot but lose the link. Delete anyway?';

  @override
  String get booksDeleteEverywhere => 'Delete everywhere';

  @override
  String booksCustomerSince(String date) {
    return 'Customer since $date';
  }

  @override
  String booksSupplierSince(String date) {
    return 'Supplier since $date';
  }

  @override
  String get booksOutstandingBalance => 'Outstanding balance';

  @override
  String get booksAmountPayable => 'Amount payable';

  @override
  String get booksLifetimeBilled => 'Lifetime billed';

  @override
  String get booksLifetimePurchased => 'Lifetime purchased';

  @override
  String get booksContactDetails => 'CONTACT DETAILS';

  @override
  String get booksPrimaryContact => 'Primary contact';

  @override
  String booksInvoicesHeader(String count) {
    return 'INVOICES ($count)';
  }

  @override
  String booksBillsHeader(String count) {
    return 'BILLS ($count)';
  }

  @override
  String get booksNoDocumentsYet => 'No documents yet.';

  @override
  String get booksAddCustomerToContacts => 'Add a customer to your contacts';

  @override
  String get booksAddSupplierToContacts => 'Add a supplier to your contacts';

  @override
  String get booksBusinessCustomerName => 'Business / customer name';

  @override
  String get booksSupplierName => 'Supplier name';

  @override
  String get booksExampleBusinessName => 'e.g. Karake Retail Group';

  @override
  String get booksFullName => 'Full name';

  @override
  String get booksEmailPlaceholder => 'name@email.rw';

  @override
  String get booksTaxId => 'Tax ID';

  @override
  String get booksPaymentTerms => 'Payment terms';

  @override
  String get booksAddSupplier => 'Add supplier';

  @override
  String booksNetDays(String days) {
    return 'Net $days';
  }

  @override
  String booksNewInvoiceTitle(String id) {
    return 'New invoice · $id';
  }

  @override
  String booksEditInvoiceTitle(String id) {
    return 'Edit invoice · $id';
  }

  @override
  String booksNewBillTitle(String id) {
    return 'New bill · $id';
  }

  @override
  String booksEditBillTitle(String id) {
    return 'Edit bill · $id';
  }

  @override
  String get booksInvoiceEditorSubtitle =>
      'Bill a customer — Flipper posts the sale and VAT automatically.';

  @override
  String get booksBillEditorSubtitle =>
      'Record a supplier bill — Flipper posts the expense and input VAT.';

  @override
  String get booksSelectCustomer => 'Select customer…';

  @override
  String get booksSelectSupplier => 'Select supplier…';

  @override
  String get booksIssueDate => 'Issue date';

  @override
  String get booksBillDate => 'Bill date';

  @override
  String get booksDueDateLabel => 'Due date';

  @override
  String get booksLineItems => 'Line items';

  @override
  String get booksAddLine => 'Add line';

  @override
  String get booksInvoiceWillPost => 'This invoice will post';

  @override
  String get booksBillWillPost => 'This bill will post';

  @override
  String get booksSaveDraft => 'Save draft';

  @override
  String get booksSaveAndSend => 'Save & send';

  @override
  String get booksDownloadPdfOnly => 'Download PDF only';

  @override
  String get booksApproveInPurchases => 'Approve in Purchases';

  @override
  String get booksRecordBill => 'Record bill';

  @override
  String booksNewScheduleTitle(String id) {
    return 'New schedule · $id';
  }

  @override
  String booksEditScheduleTitle(String id) {
    return 'Edit schedule · $id';
  }

  @override
  String get booksScheduleEditorSubtitle =>
      'Repeating entries post themselves with a balanced journal.';

  @override
  String get booksScheduleName => 'Schedule name';

  @override
  String get booksScheduleNameHint => 'e.g. Monthly rent';

  @override
  String get booksDay => 'Day';

  @override
  String get booksDayHint => 'e.g. 1st';

  @override
  String get booksDebitAccountLabel => 'Debit account (expense / asset)';

  @override
  String get booksCreditAccountLabel => 'Credit account (funding source)';

  @override
  String get booksSelectAccount => 'Select account…';

  @override
  String get booksAccountsMustDiffer =>
      'Debit and credit accounts must differ.';

  @override
  String get booksActive => 'Active';

  @override
  String get booksPausedLabel => 'Paused';

  @override
  String get booksSaveSchedule => 'Save schedule';

  @override
  String get booksPaymentFailed => 'Payment failed';

  @override
  String booksInvoicePaidMessage(String amount, String who) {
    return '$who paid $amount. The invoice is marked paid.';
  }

  @override
  String booksBillPartPaidMessage(String amount, String balance, String who) {
    return 'Paid $amount to $who. $balance is still owed.';
  }

  @override
  String booksBillSettledMessage(String amount, String who) {
    return 'Paid $amount to $who. The bill is settled.';
  }

  @override
  String get booksPayBill => 'Pay bill';

  @override
  String booksAmountDue(String amount, String id, String who) {
    return '$id · $who · $amount due';
  }

  @override
  String get booksDepositTo => 'Deposit to';

  @override
  String get booksPayFrom => 'Pay from';

  @override
  String get booksAmountReceived => 'Amount received';

  @override
  String get booksPostsAs => 'Posts as';

  @override
  String get booksBusinessFallback => 'Business';

  @override
  String get booksInvoiceUpper => 'INVOICE';

  @override
  String get booksBillUpper => 'BILL';

  @override
  String get booksBillTo => 'Bill to';

  @override
  String get booksFrom => 'From';

  @override
  String get booksIssued => 'Issued';

  @override
  String get booksDescription => 'Description';

  @override
  String get booksQty => 'Qty';

  @override
  String get booksItemOrService => 'Item or service';

  @override
  String get booksItemOrServiceHint => 'Item or service…';

  @override
  String booksBalancedEquation(String amount, String total) {
    return 'Balanced · $total = $amount';
  }

  @override
  String get booksVat18 => 'VAT (18%)';

  @override
  String get booksPillPosted => 'posted';

  @override
  String get booksPillPending => 'pending';

  @override
  String get booksPillDraft => 'draft';

  @override
  String get booksTypeAsset => 'Asset';

  @override
  String get booksTypeLiability => 'Liability';

  @override
  String get booksTypeEquity => 'Equity';

  @override
  String get booksTypeIncome => 'Income';

  @override
  String get booksTypeExpense => 'Expense';

  @override
  String get booksCodeInUse => 'Code already in use';

  @override
  String get booksPickDifferentCode => 'Pick a different account code';

  @override
  String get booksAccountCreated => 'Account created';

  @override
  String get booksCouldNotCreateAccount => 'Could not create account';

  @override
  String get booksNewAccount => 'New account';

  @override
  String get booksAddLineToCoa => 'Add a line to the chart of accounts';

  @override
  String get booksAccountType => 'Account type';

  @override
  String get booksCode => 'Code';

  @override
  String get booksCodeHint => 'e.g. 6060';

  @override
  String get booksCategoryHint => 'e.g. Operating expenses';

  @override
  String get booksAccountName => 'Account name';

  @override
  String get booksAccountNameHint => 'e.g. Office supplies';

  @override
  String get booksCreating => 'Creating…';

  @override
  String get booksCreateAccount => 'Create account';

  @override
  String get booksDrShort => 'Dr';

  @override
  String get booksCrShort => 'Cr';

  @override
  String booksEntryMeta(String date, String ref, String source) {
    return '$date · $ref · via $source';
  }

  @override
  String booksBalancedDrCr(String cr, String dr) {
    return 'Balanced · $dr = $cr';
  }

  @override
  String get booksApprovedPosted => 'Approved & posted';

  @override
  String get booksSentBackToDrafts => 'Sent back to drafts';

  @override
  String get booksReject => 'Reject';

  @override
  String get booksApprove => 'Approve';

  @override
  String get booksSubmittedForApproval => 'Submitted for approval';

  @override
  String get booksSubmittedForApprovalBody =>
      'Debits equal credits. Review and approve from the Approvals tab to post to the ledger.';

  @override
  String get booksRecordExpenseSubtitle =>
      'Pick a category and how you paid — Flipper posts a balanced entry.';

  @override
  String get booksExpenseCategory => 'Expense category';

  @override
  String get booksAddExpenseAccount => '+ Add expense account';

  @override
  String get booksPaidVia => 'Paid via';

  @override
  String get booksMemoDescription => 'Memo / description';

  @override
  String get booksExpenseMemoHint => 'What was this expense for?';

  @override
  String get booksSubmitForApproval => 'Submit for approval';

  @override
  String get booksJournalPreview => 'Journal preview';

  @override
  String booksBalancedAmount(String amount) {
    return 'Balanced · $amount';
  }

  @override
  String get booksTplRecordSale => 'Record a sale';

  @override
  String get booksTplPayExpense => 'Pay an expense';

  @override
  String get booksTplReceivePayment => 'Receive payment';

  @override
  String get booksTplPayBill => 'Pay a bill';

  @override
  String booksDraftKeptInDrafts(String ref) {
    return '$ref kept in Drafts';
  }

  @override
  String get booksCouldNotSaveEntry => 'Could not save entry';

  @override
  String get booksQuickStart => 'Quick start';

  @override
  String get booksEntryMemoHint => 'What is this entry for?';

  @override
  String get booksLines => 'Lines';

  @override
  String booksDebitCreditHint(String into, String out) {
    return 'Every entry has two sides. Money $into an account is a debit; money $out is a credit. They must add up to the same total.';
  }

  @override
  String get booksMoneyIntoWord => 'into';

  @override
  String get booksMoneyOutWord => 'out';

  @override
  String get booksComposerSubtitle =>
      'Pick the accounts and enter amounts — Flipper keeps it balanced.';

  @override
  String get booksAccountUpper => 'ACCOUNT';

  @override
  String get booksDebitUpper => 'DEBIT';

  @override
  String get booksCreditUpper => 'CREDIT';

  @override
  String get booksBalanced => 'Balanced';

  @override
  String get booksEnterAmounts => 'Enter amounts';

  @override
  String booksOffBy(String amount) {
    return 'Off by $amount';
  }

  @override
  String get booksTotalDebits => 'Total debits';

  @override
  String get booksTotalCredits => 'Total credits';

  @override
  String get booksSearchAccounts => 'Search accounts…';

  @override
  String get booksDataRefreshed => 'Books data refreshed from cloud';

  @override
  String booksActionFailed(String error) {
    return 'Action failed: $error';
  }

  @override
  String get booksAllCaughtUp => 'All caught up';

  @override
  String get booksNotificationsMarkedRead => 'Notifications marked read';

  @override
  String get booksSearchPlaceholder => 'Search entries, accounts, invoices…';

  @override
  String get booksFiscalPeriod => 'Fiscal period';

  @override
  String get booksPeriodChanged => 'Period changed';

  @override
  String booksFiscalPeriodYear(String year) {
    return 'Fiscal period $year';
  }

  @override
  String get booksNotifications => 'Notifications';

  @override
  String get booksMarkAllRead => 'Mark all read';

  @override
  String get booksEntriesAwaitingApprovalTitle =>
      'Journal entries awaiting approval';

  @override
  String get booksReviewPendingPostings =>
      'Review pending double-entry postings';

  @override
  String get booksNoNewNotifications => 'No new notifications';

  @override
  String get booksNoPendingEntries => 'No pending journal entries';

  @override
  String get booksTabSnapshot => 'Snapshot';

  @override
  String get booksTabApprovals => 'Approvals';

  @override
  String booksCouldNotRestoreBusiness(String error) {
    return 'Could not restore business context: $error';
  }

  @override
  String get webHomeNavPlatform => 'Platform';

  @override
  String get webHomeNavFeatures => 'Features';

  @override
  String get webHomeLogIn => 'Log in';

  @override
  String get webHomeStartFree => 'Start free';

  @override
  String get webHomeHeroLine1 => 'Accounting';

  @override
  String get webHomeHeroLine2Lead => 'that';

  @override
  String get webHomeHeroLine2Accent => 'does itself.';

  @override
  String get webHomeHeroBody =>
      'Flipper Books is modern accounting for growing businesses. Every sale from Flipper POS posts straight to your ledger — and Flow AI categorizes, reconciles, and files the rest. You just run your business.';

  @override
  String get webHomeSeeHowItWorks => 'See how it works';

  @override
  String get webHomeCheckEbmReady => 'RRA / EBM-ready';

  @override
  String get webHomeCheckOffline => 'Works offline';

  @override
  String get webHomeCheckRwf => 'RWF-native';

  @override
  String get webHomeTrustTagline =>
      'Built for businesses everywhere — and the way money actually moves.';

  @override
  String get webHomeTrustTaxIntegration => 'tax integration';

  @override
  String get webHomeTrustBusinesses => 'businesses';

  @override
  String get webHomeTrustMomoBank => 'MoMo & bank sync';

  @override
  String get webHomeTrustRealtimeLedger => 'Real-time ledger';

  @override
  String get webHomeSuiteEyebrow => 'One platform';

  @override
  String get webHomeSuiteTitle => 'Three apps. One ledger. Zero double-entry.';

  @override
  String get webHomeSuiteBody =>
      'Flipper POS, Books, and Flow aren\'t integrations bolted together — they\'re one system. Money moves through it once, and your books stay closed.';

  @override
  String get webHomeLoopSellOnPos => 'Sell on POS →';

  @override
  String get webHomeLoopPostsToBooks => 'posts to Books';

  @override
  String get webHomeLoopFlowReconciles => 'Flow reconciles';

  @override
  String get webHomeLoopTail =>
      '→ you see profit in real time. One loop, fully automatic.';

  @override
  String get webHomePosRole => 'Sell';

  @override
  String get webHomePosTagline => 'The front counter';

  @override
  String get webHomePosBody =>
      'Ring up sales on mobile or desktop, scan stock, take cash or MoMo. Works the second you open the shop — online or off.';

  @override
  String get webHomeBooksRole => 'Account';

  @override
  String get webHomeBooksTagline => 'The source of truth';

  @override
  String get webHomeBooksBody =>
      'Every sale lands as a balanced journal entry. Real-time P&L, cash flow, receivables and EBM-ready tax — no spreadsheets, no month-end scramble.';

  @override
  String get webHomeFlowRole => 'Automate';

  @override
  String get webHomeFlowTagline => 'The AI bookkeeper';

  @override
  String get webHomeFlowBody =>
      'Flow watches the whole flow — categorizing, reconciling, flagging anomalies and prepping tax. The work that used to take an accountant a week happens in real time.';

  @override
  String get webHomeMeetFlow => 'Meet Flow AI';

  @override
  String get webHomeFlowHeadlineLead => 'Your books, kept by an';

  @override
  String get webHomeFlowHeadlineAccent => 'AI bookkeeper.';

  @override
  String get webHomeFlowLead =>
      'Flow turns raw transactions into clean, audit-ready accounting — and asks you only when it genuinely needs a decision. Sleep free from the hassle of accounting tasks.';

  @override
  String get webHomeFlowAutoCat => 'Auto-categorization';

  @override
  String get webHomeFlowAutoCatBody =>
      'Each sale, expense and transfer is coded to the right account the instant it happens.';

  @override
  String get webHomeFlowRecon => 'Bank & MoMo reconciliation';

  @override
  String get webHomeFlowReconBody =>
      'Flow matches your ledger to statements automatically and surfaces only true exceptions.';

  @override
  String get webHomeFlowTax => 'Tax & VAT, prepared';

  @override
  String get webHomeFlowTaxBody =>
      'EBM-ready filings drafted from your live ledger, so RRA deadlines stop being a panic.';

  @override
  String get webHomeFlowAnomaly => 'Anomaly alerts';

  @override
  String get webHomeFlowAnomalyBody =>
      'Duplicate entries, margin dips and unusual spend get flagged before they become a problem.';

  @override
  String get webHomeExploreFlow => 'Explore Flow AI';

  @override
  String get webHomeWatchingLedger => 'Watching your ledger';

  @override
  String get webHomeChatUser1 =>
      'A new sale came in on POS for RWF 12,000, paid by MoMo. Book it.';

  @override
  String get webHomeChatBot1 =>
      'Done — posted a balanced entry and reconciled it to your MTN MoMo account. Here\'s the journal entry:';

  @override
  String get webHomeChatUser2 => 'Anything I should look at this week?';

  @override
  String get webHomeChatBot2 =>
      'VAT for May is ready to file (RWF 318,400) and one supplier was charged twice — I\'ve flagged it in Payables.';

  @override
  String get webHomeCapMultiBranch => 'Multi-branch';

  @override
  String get webHomeCapStatementsBody =>
      'Income statement, balance sheet and cash flow generated live from your general ledger.';

  @override
  String get webHomeCapBankRecBody =>
      'Match ledger lines to bank and MoMo statements in one pass, with exceptions surfaced for you.';

  @override
  String get webHomeCapArAp => 'Receivables & payables';

  @override
  String get webHomeCapArApBody =>
      'Track who owes you and what you owe, with aging buckets and gentle automatic reminders.';

  @override
  String get webHomeCapTaxBody =>
      'EBM 2.1 integration and VAT computed continuously — filings drafted before the deadline.';

  @override
  String get webHomeCapCoaBody =>
      'A numbered, audit-friendly ledger structure that adapts to how your business is organized.';

  @override
  String get webHomeCapMultiBranchBody =>
      'Consolidate every shop into one set of books, then drill into any branch on its own.';

  @override
  String get webHomeInsideBooks => 'INSIDE BOOKS';

  @override
  String get webHomeCapTitle => 'Everything an accountant does — built in.';

  @override
  String get webHomeCapBody =>
      'Double-entry accounting that\'s serious enough for your auditor and simple enough to run yourself.';

  @override
  String get webHomePricingEyebrow => 'PRICING';

  @override
  String get webHomePricingBody =>
      'Choose the plan that works best for you. Every plan includes the full Flipper suite — POS, Books and Flow.';

  @override
  String get webHomeContactSales => 'Contact sales';

  @override
  String get webHomeBandTitle => 'Your shop, your books, all in one place.';

  @override
  String get webHomeBandBody =>
      'Start selling on Flipper today and let Flow keep your books — automatically, in real time. Pick up right where you left off.';

  @override
  String get webHomeTalkToSales => 'Talk to sales';

  @override
  String get webHomeStatProcessedMonthly => 'processed monthly';

  @override
  String get webHomeStatUptime => 'uptime';

  @override
  String get webHomeRevenueThisWeek => 'Revenue · this week';

  @override
  String get webHomeNewSale => 'New sale';

  @override
  String webHomeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get webHomeSalesStreak => 'Sales streak';

  @override
  String get webHomeFooterTagline =>
      'The connected business platform for Africa — point of sale, accounting and an AI bookkeeper, in one place.';

  @override
  String get webHomeCopyright =>
      '© 2026 Flipper. Made for business everywhere.';

  @override
  String get webHomePrivacy => 'Privacy';

  @override
  String get webHomeTerms => 'Terms';

  @override
  String get webHomeFooterPlatform => 'PLATFORM';

  @override
  String get webHomeFooterCompany => 'COMPANY';

  @override
  String get webHomeFooterSupport => 'SUPPORT';

  @override
  String get webHomeAbout => 'About';

  @override
  String get webHomeBlog => 'Blog';

  @override
  String get webHomeCareers => 'Careers';

  @override
  String get webHomeContact => 'Contact';

  @override
  String get webHomeHelpCenter => 'Help center';

  @override
  String get webHomeDownload => 'Download';

  @override
  String get webHomeStatus => 'Status';

  @override
  String get webHomeCommunity => 'Community';

  @override
  String get webHomePoweredBy => 'Flipper Books · powered by';

  @override
  String get webHomeMostPopular => 'Most Popular';

  @override
  String get webHomeSwitchToLight => 'Switch to light mode';

  @override
  String get webHomeSwitchToDark => 'Switch to dark mode';

  @override
  String get webHomeLightMode => 'Light mode';

  @override
  String get webHomeDarkMode => 'Dark mode';

  @override
  String get webHomeMockFinancialOverview => 'FINANCIAL OVERVIEW';

  @override
  String get webHomeMockCashOnHand => 'Cash on hand';

  @override
  String get webHomeMockRevenueTrend => 'Revenue trend';

  @override
  String get webHomeMockLast8Months => 'Last 8 months';

  @override
  String get webHomeMockCostOfSales => 'Cost of sales';

  @override
  String get webHomeMockOperatingExp => 'Operating exp.';

  @override
  String get webHomeMockAutoPosted => 'AUTO-POSTED';

  @override
  String webHomeMockToast(String account, String pos) {
    return 'New sale on $pos — categorized to $account and reconciled to MoMo.';
  }

  @override
  String get webHomeMockSalesRevenue => 'Sales Revenue';

  @override
  String get webHomeMockBalancedSuffix => '· balanced';

  @override
  String get webHomeMockPending => '● PENDING';

  @override
  String get webHomeMockSearchOrScan => 'Search or scan…';

  @override
  String webHomeMockLeft(String count) {
    return '$count left';
  }

  @override
  String get webAppsFinance => 'Finance';

  @override
  String get webAppsSell => 'Sell';

  @override
  String get webAppsEverything => 'Everything in your business';

  @override
  String webAppsComingSoon(String app) {
    return '$app — coming soon';
  }

  @override
  String get webBillingInvalidMomo =>
      'Enter a valid Mobile Money number, e.g. 0788123456.';

  @override
  String get webBillingPreparing => 'Preparing your subscription…';

  @override
  String webBillingCouldNotSave(String error) {
    return 'Could not save the subscription: $error';
  }

  @override
  String get webBillingNoPlanIdCharge =>
      'This subscription has no plan id yet, so it cannot be charged safely. Reload and try again.';

  @override
  String get webBillingNoPlanIdPay =>
      'This subscription has no plan id yet, so it cannot be paid safely. Reload and try again.';

  @override
  String get webBillingSendingRequest => 'Sending the request to your phone…';

  @override
  String get webBillingApproveOnPhone =>
      'Approve the Mobile Money request on your phone.';

  @override
  String webBillingCouldNotStart(String error) {
    return 'The payment could not be started: $error';
  }

  @override
  String get webBillingConsentDeclined =>
      'Mobile Money consent was declined, so nothing was charged.';

  @override
  String get webBillingCouldNotStartPlain =>
      'The payment could not be started.';

  @override
  String get webBillingNoReference =>
      'The gateway accepted the payment but returned no reference to track it. Check your phone, then try again.';

  @override
  String get webBillingPaymentReceived =>
      'Payment received. Your subscription is active.';

  @override
  String get webBillingNotCompletedOnPhone =>
      'The payment was not completed on your phone.';

  @override
  String get webBillingMomoNoVerdict =>
      'We have not had a verdict from Mobile Money yet. If you approved the request, Books will open shortly — check again in a moment.';

  @override
  String get webBillingCardNeedsEmail =>
      'Card payment needs an email address for the receipt.';

  @override
  String get webBillingOpeningPaymentPage => 'Opening the payment page…';

  @override
  String webBillingCardCouldNotStart(String error) {
    return 'The card payment could not be started: $error';
  }

  @override
  String get webBillingAlreadyActive => 'This subscription is already active.';

  @override
  String get webBillingCouldNotOpenCardPage =>
      'Could not open the card payment page in this browser.';

  @override
  String get webBillingSubscriptionEnded =>
      'This subscription has ended. Choose a plan to start again.';

  @override
  String get webBillingFinishOnOpenedPage =>
      'Finish the payment on the page that just opened. Books unlocks here as soon as the card is charged.';

  @override
  String get webBillingCheckingCard => 'Checking on your card payment…';

  @override
  String webBillingCouldNotCheckCard(String error) {
    return 'Could not check the card payment: $error';
  }

  @override
  String get webBillingCardDeclined =>
      'The card was declined. Open the payment page again to use a different card.';

  @override
  String get webBillingCardNoVerdict =>
      'We have not heard back about the card payment yet. If you completed it, Books will open shortly — check again in a moment.';

  @override
  String get webBillingCheckingSubscription => 'Checking your subscription…';

  @override
  String get webBillingEnded => 'Your subscription has ended';

  @override
  String get webBillingNeedsSubscription =>
      'Flipper Books needs a subscription';

  @override
  String get webBillingEndedBody =>
      'Nothing has been deleted — your books, sales and stock are all still here. Renew the subscription to open them again.';

  @override
  String get webBillingNeedsBody =>
      'One subscription covers this business on the web, the phone and the desktop app. Pay once and Flipper opens everywhere you use it.';

  @override
  String get webBillingAwaitingSettlement =>
      'A payment is already on its way. If you approved it on your phone, this unlocks as soon as Mobile Money confirms it.';

  @override
  String get webBillingRenewNow => 'Renew now';

  @override
  String get webBillingChoosePlan => 'Choose a plan';

  @override
  String get webBillingSwitchBusiness => 'Switch business';

  @override
  String get webBillingLoadingBusiness => 'Loading your business…';

  @override
  String get webBillingPickBusiness =>
      'Pick the business you are paying for, then the plans and their prices appear here.';

  @override
  String get webBillingChooseBusiness => 'Choose a business';

  @override
  String get webBillingRenewTitle => 'Renew your subscription';

  @override
  String get webBillingSubscribe => 'Subscribe';

  @override
  String get webBillingTestBadge => 'TEST';

  @override
  String get webBillingOneMoment => 'One moment…';

  @override
  String get webBillingIntroSubtitle =>
      'One subscription opens this business on the web, the phone and the desktop app.';

  @override
  String get webBillingActiveReady =>
      'Your subscription is active. Books is ready to open.';

  @override
  String get webBillingLoadingPlans => 'Loading plans…';

  @override
  String webBillingCouldNotLoadPlans(String error) {
    return 'Could not load the plans: $error';
  }

  @override
  String get webBillingTryAgain => 'Try again';

  @override
  String get webBillingNoPlans => 'No plans are on sale right now.';

  @override
  String get webBillingPlan => 'Plan';

  @override
  String get webBillingAddons => 'Add-ons';

  @override
  String get webBillingPayWith => 'Pay with';

  @override
  String get webBillingContinueToCard => 'Continue to card payment';

  @override
  String webBillingPayAmount(String amount) {
    return 'Pay $amount RWF';
  }

  @override
  String get webBillingWaitingApproval => 'Waiting for your approval…';

  @override
  String get webBillingWaitingCard => 'Waiting for the card payment…';

  @override
  String get webBillingPreparingShort => 'Preparing…';

  @override
  String get webBillingCheckAgain => 'Check again';

  @override
  String get webBillingStartOver => 'Start over';

  @override
  String get webBillingOpenBooks => 'Open Books';

  @override
  String get webPayNotAuthorised =>
      'This account is not authorised for staff payments.';

  @override
  String get webPayEnterAmount => 'Enter the agreed amount in RWF.';

  @override
  String get webPayStarting => 'Starting the payment…';

  @override
  String webPayCouldNotStart(String error) {
    return 'Could not start the payment: $error';
  }

  @override
  String get webPayNoPaymentYetCard =>
      'No payment yet. Send the link again or check the reference later — a payment made after this closes still counts.';

  @override
  String get webPayNoApprovalYet =>
      'No approval yet. The customer may still approve; check the reference later or start again.';

  @override
  String get webPayPaidActive =>
      'Paid. The plan is active and the negotiated price is now its recurring price.';

  @override
  String get webPayDidNotGoThrough => 'The payment did not go through.';

  @override
  String get webPayLinkExpired =>
      'The payment link expired before it was paid.';

  @override
  String get webPayAskCustomerApprove =>
      'Ask the customer to approve the Mobile Money request on their phone.';

  @override
  String get webPaySendLink =>
      'Send the customer the payment link and wait for them to pay.';

  @override
  String get webPayWaitingSettle => 'Waiting for the payment to settle…';

  @override
  String get webPayTitle => 'Custom payment';

  @override
  String get webPayCheckingAccess => 'Checking access…';

  @override
  String webPayCouldNotCheckAccess(String error) {
    return 'Could not check staff access: $error';
  }

  @override
  String get webPayStaffOnlyBody =>
      'This page is for billing staff. Ask an administrator to add you to the billing staff list.';

  @override
  String get webPayPerYear => '/year';

  @override
  String get webPayPerMonth => '/month';

  @override
  String get webPayNegotiatedPrice => 'Negotiated price';

  @override
  String get webPayNegotiatedBody =>
      'Charge the amount agreed with the customer. It becomes their recurring price, and whatever they were on before stops billing.';

  @override
  String webPaySignedInAs(String name) {
    return 'Signed in as $name.';
  }

  @override
  String get webPaySearchHint => 'Search by name, phone, email or id';

  @override
  String get webPayAgreedAmount => 'Agreed amount';

  @override
  String get webPayAmountHint => 'Amount in RWF per period';

  @override
  String get webPayCustomerPaysWith => 'Customer pays with';

  @override
  String get webPayLinkCopied => 'Link copied';

  @override
  String get webPayNoteHint => 'Note for the record (optional)';

  @override
  String get webPayNotSelected => 'Not selected';

  @override
  String get webPayBillingPeriod => 'Billing period';

  @override
  String get webPayPaysWith => 'Pays with';

  @override
  String get webPayCard => 'Card';

  @override
  String get webPayPricePerPeriod => 'Price per period';

  @override
  String get webPayChargedNow => 'Charged now, then every period';

  @override
  String get webPayCreateCardLink => 'Create card payment link';

  @override
  String webPayChargeByMomo(String amount) {
    return 'Charge $amount RWF by Mobile Money';
  }

  @override
  String get webPayWaitingCustomerApproval =>
      'Waiting for the customer\'s approval…';

  @override
  String get webPayStartingShort => 'Starting…';

  @override
  String get webPayConfirmTitle => 'Charge this business?';

  @override
  String webPayConfirmSummary(String amount, String cadence, String rail) {
    return '$amount RWF · $cadence · $rail';
  }

  @override
  String get webPayConfirmBodyMomo =>
      'This becomes their recurring price. Any existing card subscription is cancelled immediately.';

  @override
  String get webPayConfirmBodyCard =>
      'This becomes their recurring price. Any existing card subscription is cancelled immediately, and their Mobile Money mandate is revoked.';

  @override
  String get webPayCharge => 'Charge';

  @override
  String get webPayStaffOnly => 'Staff only';

  @override
  String get webPayBackToBooks => 'Back to Books';

  @override
  String get webPaySearching => 'Searching…';

  @override
  String webPaySearchFailed(String error) {
    return 'Search failed: $error';
  }

  @override
  String webPayNoBusinessMatches(String query) {
    return 'No business matches “$query”.';
  }

  @override
  String get webPayChange => 'Change';

  @override
  String get webPayCopyLink => 'Copy link';

  @override
  String get webPayOpen => 'Open';

  @override
  String webPayExistingPayment(String id, String status) {
    return 'Existing payment $id is $status';
  }

  @override
  String webPayLinkSuffix(String link) {
    return 'link: $link';
  }

  @override
  String get webPayReference => 'Reference';

  @override
  String get webPayRail => 'Rail';

  @override
  String get webPayPaidThrough => 'Paid through';

  @override
  String get webPayMomoCharge => 'MoMo charge';

  @override
  String get webPayMtnTransaction => 'MTN transaction';

  @override
  String get webPayDodoSubscription => 'Dodo subscription';

  @override
  String get webPayDodoPayment => 'Dodo payment';

  @override
  String get webPayCancelledCardSub => 'Cancelled card sub';

  @override
  String get webPayRevokedMandate => 'Revoked MoMo mandate';

  @override
  String get webPayPaid => 'Paid';

  @override
  String get webPaySettledBody =>
      'The negotiated amount is now this business\'s recurring price. Keep the reference below for support.';

  @override
  String get webPayCopyAllIds => 'Copy all ids';

  @override
  String get webPayCopied => 'Copied';

  @override
  String get webPayNewPayment => 'New payment';

  @override
  String get webPinTooShort => 'PIN must be at least 4 digits';

  @override
  String get webPinInvalid => 'Invalid PIN. Please try again.';

  @override
  String get webPinOtpRequired => 'OTP is required';

  @override
  String get webPinAuthCodeRequired => 'Authenticator code is required';

  @override
  String get webPinOtpInvalid => 'Invalid OTP. Please try again.';

  @override
  String get webPinAuthCodeInvalid =>
      'Invalid authenticator code. Please try again.';

  @override
  String get webPinTroubleTitle => 'Trouble signing in?';

  @override
  String get webPinTroubleBody =>
      'If you have forgotten your PIN, contact your account administrator or reach out to Flipper support.';

  @override
  String get webPinVerifyIdentity => 'Verify your identity';

  @override
  String get webPinEnterSmsCode => 'Enter the code we sent you to continue.';

  @override
  String get webPinEnterAuthCode =>
      'Enter the code from your authenticator app to continue.';

  @override
  String get webPinEnterPinSubtitle =>
      'Enter your PIN to manage your business securely.';

  @override
  String get webPinSignedIn => 'Signed in ✓';

  @override
  String get webPinVerifying => 'Verifying…';

  @override
  String get webPinVerify => 'Verify';

  @override
  String get webPinSignIn => 'Sign in';

  @override
  String get webPinNoAccountSignUp => 'Don\'t have an account? Sign up';

  @override
  String get webPinHide => 'Hide';

  @override
  String get webPinShow => 'Show';

  @override
  String get webPinAuthenticator => 'Authenticator';

  @override
  String get webPinSmsEmail => 'SMS / Email';

  @override
  String get webPinAuthenticatorCode => 'Authenticator Code';

  @override
  String get webPinSmsEmailCode => 'SMS / Email Code';

  @override
  String get webSignupTypeRetailer => 'Flipper Retailer';

  @override
  String get webSignupTypeIndividual => 'Individual';

  @override
  String get webSignupTypeEnterprise => 'Enterprise';

  @override
  String get webSignupUsernameCheckError =>
      'Error checking username availability';

  @override
  String get webSignupNoTinData => 'No data found for this TIN';

  @override
  String get webSignupEnterContactFirst =>
      'Enter a phone number or email first.';

  @override
  String get webSignupFailedToSendCode => 'Failed to send the code.';

  @override
  String get webSignupWrongCode => 'That code is not right. Please try again.';

  @override
  String get webSignupCouldNotCheckCode => 'Could not check that code.';

  @override
  String get webSignupUsernameRequired => 'Username is required';

  @override
  String get webSignupUsernameTooShort =>
      'Username must be at least 4 characters';

  @override
  String get webSignupEnterFullName => 'Please enter your full name';

  @override
  String get webSignupSelectBusinessType => 'Please select a business type';

  @override
  String get webSignupInvalidTin =>
      'Please enter a valid TIN number (at least 9 characters)';

  @override
  String get webSignupSelectCountry => 'Please select a country';

  @override
  String webSignupEnterCodeSentTo(String contact) {
    return 'Enter the code we sent to $contact to continue.';
  }

  @override
  String webSignupVerifyFirst(String contact) {
    return 'Verify $contact first — tap “Send code”.';
  }

  @override
  String get webSignupUsernameTaken =>
      'Username is not available. Please choose another one.';

  @override
  String get webSignupUsernameCheckRetry =>
      'Error checking username availability. Please try again.';

  @override
  String get webSignupFillRequired =>
      'Please fill in all required fields correctly';

  @override
  String get webSignupNetworkError =>
      'Network error. Please check your connection and try again.';

  @override
  String get webSignupTimeout => 'Request timed out. Please try again later.';

  @override
  String webSignupFailedCreate(String error) {
    return 'Failed to create account: $error';
  }

  @override
  String get webSignupDismiss => 'Dismiss';

  @override
  String get webSignupBusinessSetup => 'Business setup';

  @override
  String get webSignupSubtitle =>
      'Set up your Flipper business account to get started.';

  @override
  String get webSignupUsername => 'Username';

  @override
  String get webSignupFullName => 'Full name';

  @override
  String get webSignupFullNameHint => 'Enter your full name';

  @override
  String get webSignupFullNameRequired => 'Full name is required';

  @override
  String get webSignupPhoneEmail => 'Phone / Email';

  @override
  String get webSignupUsage => 'Usage';

  @override
  String get webSignupUsageHint => 'How you intend to use Flipper';

  @override
  String webSignupTinBusiness(String name) {
    return 'Business: $name';
  }

  @override
  String get webSignupTinUnavailable =>
      'TIN lookup unavailable — validation skipped.';

  @override
  String get webSignupCountry => 'Country';

  @override
  String get webSignupAlreadyHaveAccount => 'Already have an account? Sign in';

  @override
  String get webSignupChooseDifferentUsername =>
      'Please choose a different username. The current one is not available or has not been verified.';

  @override
  String get webSignupAccountCreated => 'Account created successfully!';

  @override
  String get webSignupFailedTryAgain =>
      'Failed to create account. Please try again.';

  @override
  String get webSignupUsernameNotAvailable => 'Username is not available';

  @override
  String get webSignupUsernameHint => 'Enter your username';

  @override
  String get webSignupContactRequired => 'Phone number or email is required';

  @override
  String get webSignupInvalidEmail => 'Please enter a valid email address';

  @override
  String get webSignupInvalidPhone => 'Please enter a valid phone number';

  @override
  String get webSignupContactHint => '783054874 or your@email.com';

  @override
  String get webSignupResend => 'Resend';

  @override
  String get webSignupSendCode => 'Send code';

  @override
  String webSignupContactVerified(String contact) {
    return '$contact verified.';
  }

  @override
  String get webSignupVerificationCode => 'Verification code';

  @override
  String get webSignupEnter6Digit => 'Enter the 6-digit code';

  @override
  String webSignupCodeSentHint(String contact) {
    return 'We sent a code to $contact.';
  }

  @override
  String webSignupCodeSentTo(String contact) {
    return 'Code sent to $contact';
  }

  @override
  String get webSignupEnterTin => 'Enter TIN number';

  @override
  String get webSignupTinRequired => 'TIN number is required';

  @override
  String get webSignupTinTooShort => 'TIN number must be at least 9 digits';

  @override
  String get webSignupPickCountryFromList =>
      'Please pick a country from the list';

  @override
  String get webSignupSearchCountry => 'Search your country';

  @override
  String get webSignupCreateYourAccount => 'Create your account';

  @override
  String get webAuthSecuredE2e => 'Secured with end-to-end encryption';

  @override
  String webAuthVerifiedOpening(String target) {
    return 'Verified — opening $target…';
  }

  @override
  String get webAuthYourBusiness => 'your business';

  @override
  String get webAuthBrandTitle =>
      'Your shop, your team, your numbers — all in one place.';

  @override
  String get webAuthBrandBody =>
      'Pick up right where you left off. Today\'s sales, stock, and reports are ready.';

  @override
  String webAuthErrorCheckingPrefs(String error) {
    return 'Error checking preferences: $error';
  }

  @override
  String get webBizNoBusinesses => 'No businesses available';

  @override
  String get webBizChooseBusiness => 'Choose a business';

  @override
  String get webBizChooseBusinessSubtitle =>
      'Select the business you want to manage.';

  @override
  String get webBizNotSeeing =>
      'Not seeing your business? Ask the owner to invite you.';

  @override
  String get webBizChooseBranch => 'Choose a branch';

  @override
  String get webBizChooseBranchSubtitle =>
      'Select the branch you want to access';

  @override
  String get webBizCouldNotSet => 'Could not set business. Please try again.';

  @override
  String get webBizProfileLoadFailed =>
      'Could not load your profile. This may happen if the network is unavailable or your session has expired.';

  @override
  String get webBizBackToLogin => 'Back to login';

  @override
  String get webBizUser => 'User';

  @override
  String webBizOwnerBranches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Owner · $count branches',
      one: 'Owner · 1 branch',
    );
    return '$_temp0';
  }

  @override
  String webBizMemberBranches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Member · $count branches',
      one: 'Member · 1 branch',
    );
    return '$_temp0';
  }

  @override
  String get webBizSigningOut => 'Signing out…';

  @override
  String get webBizDefault => 'DEFAULT';

  @override
  String get webBizAddBusiness => 'Add a business';

  @override
  String get webAuthPinNotFound => 'PIN not found';

  @override
  String get webAuthAccessDenied => 'Access denied — check authentication';

  @override
  String webAuthInvalidPinCode(String code) {
    return 'Invalid PIN ($code)';
  }

  @override
  String get webAuthNetworkFailed =>
      'Network connection failed. Check your internet connection.';

  @override
  String get webAuthTimedOut => 'Request timed out. Please try again.';

  @override
  String get webAuthOtpNotFound => 'OTP not found';

  @override
  String get webAuthInvalidOtp => 'Invalid OTP';

  @override
  String get webAuthTotpNotFound => 'Authenticator code not found';

  @override
  String get webAuthInvalidTotp => 'Invalid authenticator code';

  @override
  String webSignupRegistrationFailedStatus(String code) {
    return 'Registration failed with status code: $code';
  }

  @override
  String get webSignupNetworkConnect =>
      'Network error: Unable to connect to server. Please check your internet connection.';

  @override
  String get webSignupServerSlow =>
      'Request timed out. The server is taking too long to respond. Please try again later.';

  @override
  String get webSignupNetworkIncomplete =>
      'Network error: Unable to complete the request. Please try again later.';

  @override
  String webSignupRegistrationFailed(String error) {
    return 'Registration failed: $error';
  }

  @override
  String get webSignupNetworkSendCode =>
      'Network error while sending the code. Please try again.';

  @override
  String get webSignupContactExists => 'Contact already exists';

  @override
  String get webSignupSendOtpFailed => 'Failed to send OTP for signup';

  @override
  String get webSignupNetworkCheckCode =>
      'Network error while checking the code. Please try again.';

  @override
  String get tillHardwareTitle => 'Printer & customer display';

  @override
  String get tillHardwareSubtitle =>
      'Hardware on this till only. Not shared with other devices.';

  @override
  String get receiptPrinterLabel => 'Receipt printer';

  @override
  String get receiptPrinterAuto =>
      'Receipts print here automatically after every sale.';

  @override
  String get receiptPrinterAutomatic => 'Choose automatically';

  @override
  String receiptPrinterNotPaper(String name) {
    return '$name (not a paper printer)';
  }

  @override
  String get receiptPrinterNoneFound =>
      'Windows reports no printers. Install the printer driver, then reopen this page.';

  @override
  String get receiptPrinterTest => 'Test print';

  @override
  String receiptPrinterTestSent(String printer) {
    return 'Test page sent to $printer';
  }

  @override
  String receiptPrinterTestFailed(String printer, String error) {
    return '$printer did not accept the test page: $error';
  }

  @override
  String get customerDisplayLabel => 'Customer display';

  @override
  String get customerDisplayHint =>
      'Shows the total, then the change, on the small display on the back of the till.';

  @override
  String get customerDisplayOff => 'Off';

  @override
  String get customerDisplaySerial => 'On a COM port';

  @override
  String get customerDisplayPort => 'Port';

  @override
  String get customerDisplayBaud => 'Speed (baud)';

  @override
  String get customerDisplayNoPorts => 'This till reports no COM ports.';

  @override
  String get customerDisplayWindowsOnly =>
      'Customer displays are supported on Windows tills.';

  @override
  String get customerDisplayTest => 'Test display';

  @override
  String get customerDisplayTestSent =>
      'Every segment (8.8.8.8.8.8.8.8) should now be lit on the back display.';

  @override
  String get customerDisplayFind => 'Find automatically';

  @override
  String customerDisplayFindPrompt(String port, String baud) {
    return 'Trying $port at $baud baud. Does the back display show 8.8.8.8.8.8.8.8?';
  }

  @override
  String get customerDisplayFindYes => 'Yes, it does';

  @override
  String get customerDisplayFindNo => 'No, try next';

  @override
  String customerDisplayFound(String port, String baud) {
    return 'Customer display set to $port at $baud baud';
  }

  @override
  String get customerDisplayNotFound =>
      'No setting lit the display. Check its cable, or pick the port and speed by hand.';

  @override
  String get builtinPrinterLabel => 'Built-in receipt printer';

  @override
  String get builtinPrinterHint =>
      'The till\'s own 58 mm printer, used directly — no Windows driver needed. USB and parallel printers are found on the first receipt; a printer on a COM port is searched for only when Windows has no printer. Otherwise use Search or Find printer below.';

  @override
  String builtinPrinterUsing(String printer) {
    return 'Using $printer';
  }

  @override
  String get builtinPrinterNotFound => 'Not found yet.';

  @override
  String get builtinPrinterOff =>
      'Off. Receipts use the Windows printer above.';

  @override
  String get builtinPrinterSearch => 'Search';

  @override
  String get builtinPrinterSearching => 'Searching…';

  @override
  String get builtinPrinterFind => 'Find printer';

  @override
  String get builtinPrinterTurnOff => 'Turn off';

  @override
  String get builtinPrinterTurnOn => 'Turn on';

  @override
  String builtinPrinterFound(String printer) {
    return 'Built-in printer found: $printer';
  }

  @override
  String get builtinPrinterNoneAnswered =>
      'No built-in printer answered. Check paper and power, then try Find printer.';

  @override
  String builtinPrinterFindPrompt(String printer) {
    return 'A test line was sent to $printer. Did it print?';
  }

  @override
  String get builtinPrinterTestSent => 'Test page sent to the built-in printer';

  @override
  String get builtinPrinterQrLabel => 'Receipt QR code';

  @override
  String get builtinPrinterQrImage => 'Image (works on every printer)';

  @override
  String get builtinPrinterQrNative => 'Printer\'s own (if QR B printed)';

  @override
  String get builtinPrinterWindowsOnly =>
      'Built-in printers are supported on Windows tills.';

  @override
  String get branchLocationPinOnMap => 'Pin location on map (optional)';

  @override
  String get branchLocationPickerTitle => 'Branch location';

  @override
  String get branchLocationUseCurrent => 'Use my current location';

  @override
  String get branchLocationSet => 'Set location';

  @override
  String get branchLocationClear => 'Remove pin';

  @override
  String get branchLocationMissing => 'No map location yet';

  @override
  String get branchLocationUnavailable =>
      'Couldn\'t get your location. Check that location is on and allowed for Flipper.';

  @override
  String get branchLocationSaved => 'Branch location saved';

  @override
  String get branchLocationSaveFailed => 'Couldn\'t save the branch location';

  @override
  String branchLocationPromptTitle(String branch) {
    return 'Where is $branch?';
  }

  @override
  String branchLocationPromptBody(String branch) {
    return 'Are you at $branch right now? Flipper can save this spot as the branch location. Only do this while you are at the branch.';
  }

  @override
  String get branchLocationSave => 'Save location';

  @override
  String get branchLocationNotNow => 'Not now';

  @override
  String get branchLocationServiceOff =>
      'Location is turned off on this device. Turn it on, then try again.';

  @override
  String get branchLocationDenied =>
      'Flipper wasn\'t allowed to use your location. Allow it when asked to save the branch location.';

  @override
  String get branchLocationBlocked =>
      'Location access is blocked for Flipper. Open settings, allow location, then try again.';

  @override
  String get branchLocationOpenSettings => 'Open settings';

  @override
  String get branchLocationPickerHint =>
      'Drag the map so the pin sits on the branch.';

  @override
  String get branchLocationSearchHint => 'Search address or place';

  @override
  String get branchLocationNoResults =>
      'No places found. Try a street, area or landmark.';

  @override
  String get branchLocationFindingAddress => 'Finding address…';

  @override
  String get branchLocationNoAddress => 'No street address here';

  @override
  String branchLocationAccuracy(String meters) {
    return 'Accurate to about $meters m';
  }

  @override
  String get branchLocationZoomIn => 'Zoom in';

  @override
  String get branchLocationZoomOut => 'Zoom out';

  @override
  String get branchLocationDragInstead =>
      'You can still drag the map to place the pin.';

  @override
  String get purchasePaySupplier => 'Pay supplier';

  @override
  String purchaseOwedToSupplier(String amount) {
    return 'Owed to supplier: $amount';
  }

  @override
  String get purchasePaidFrom => 'Paid from';

  @override
  String get purchasePaidFromBank => 'Bank';

  @override
  String get purchasePaidFromMomo => 'Mobile money';

  @override
  String purchasePayAmountTooHigh(String amount) {
    return 'Enter an amount up to $amount';
  }

  @override
  String purchaseSupplierPaid(String amount) {
    return 'Supplier paid. Still owed: $amount';
  }

  @override
  String get purchaseSupplierPaidInFull => 'Supplier paid in full';

  @override
  String purchasePaySupplierFailed(String error) {
    return 'Payment failed: $error';
  }

  @override
  String get purchasePaidInFull => 'Paid in full';

  @override
  String get purchaseSearchHint => 'Search supplier, invoice, TIN or item';

  @override
  String purchaseOwesAmount(String amount) {
    return 'Owes $amount';
  }

  @override
  String purchaseSearchNoMatch(String query) {
    return 'No purchases match “$query”';
  }

  @override
  String get hrAndPayroll => 'HR & Payroll';

  @override
  String get hrBackToFlipper => 'Back to Flipper';

  @override
  String get hrNeedsInternet =>
      'HR needs an internet connection. Connect and try again.';

  @override
  String get hrTaxPrimary => 'Main employment';

  @override
  String get hrTaxSecondary => 'Second employer (30% flat)';

  @override
  String get hrTaxCasual => 'Casual labourer (15%)';

  @override
  String get hrPayStatusUnpaid => 'Unpaid';

  @override
  String get hrPayStatusPartlyPaid => 'Partly paid';

  @override
  String get hrPayStatusPaid => 'Paid';

  @override
  String get hrPayStatusVoid => 'Void';

  @override
  String get hrPayKindSalary => 'Salary';

  @override
  String get hrPayKindAdvance => 'Advance';

  @override
  String get hrPayKindReimbursement => 'Reimbursement';

  @override
  String get hrPayKindOther => 'Other';

  @override
  String get hrAdvanceStatusOpen => 'Owed';

  @override
  String get hrAdvanceStatusRecovered => 'Recovered';

  @override
  String get hrAdvanceStatusWrittenOff => 'Written off';

  @override
  String get hrPayErrorLoad => 'Could not load pay records.';

  @override
  String get hrPayErrorSave => 'Could not save that pay record.';

  @override
  String get hrPayroll => 'Payroll';

  @override
  String get hrMyPay => 'My pay';

  @override
  String get hrPayslip => 'Payslip';

  @override
  String get hrPayslips => 'Payslips';

  @override
  String get hrPayAdvances => 'Advances';

  @override
  String get hrPayRequests => 'Requests';

  @override
  String get hrPayReturns => 'Returns';

  @override
  String get hrPayHistory => 'History';

  @override
  String get hrPaySummary => 'Summary';

  @override
  String get hrPayEmployee => 'Employee';

  @override
  String get hrNationalId => 'National ID';

  @override
  String get hrRssbNumber => 'RSSB number';

  @override
  String get hrPayPay => 'Pay';

  @override
  String get hrPayPaySomeone => 'Pay someone';

  @override
  String hrPayPayFor(String period) {
    return 'Pay $period';
  }

  @override
  String get hrPayChoosePerson => 'Who are you paying?';

  @override
  String get hrPayRecord => 'Record payment';

  @override
  String get hrPayVoid => 'Void';

  @override
  String get hrPayShareSlip => 'Share payslip';

  @override
  String get hrPayBackToPayroll => 'Back to payroll';

  @override
  String get hrPayReason => 'Reason';

  @override
  String get hrPaySaveUnpaid => 'Save payslip, pay later';

  @override
  String hrPayConfirmAmount(String amount) {
    return 'Pay $amount';
  }

  @override
  String hrPayRemaining(String amount) {
    return 'Pay $amount left';
  }

  @override
  String get hrPayRemainingTitle => 'Pay what is left';

  @override
  String get hrPayDueNow => 'Due now';

  @override
  String get hrPayPeopleToPay => 'people to pay';

  @override
  String get hrPayPaidThisMonth => 'Paid this month';

  @override
  String hrPayUnpaidOnSlips(String amount) {
    return '$amount still on payslips';
  }

  @override
  String get hrPayAdvancesOwed => 'Advances owed';

  @override
  String get hrPayCostThisMonth => 'Payroll cost this month';

  @override
  String hrPayPayslipCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count payslips',
      one: '1 payslip',
    );
    return '$_temp0';
  }

  @override
  String get hrPayDueToday => 'Due today';

  @override
  String hrPayDueOn(String date) {
    return 'Due $date';
  }

  @override
  String hrPayNextOn(String date) {
    return 'Next pay $date';
  }

  @override
  String hrPayOverdueSince(String date) {
    return 'Overdue since $date';
  }

  @override
  String hrPayDueFor(String period) {
    return 'Due for $period';
  }

  @override
  String hrPayOwesBack(String amount) {
    return 'Owes $amount';
  }

  @override
  String hrPayLastPaid(String amount, String date) {
    return 'Last paid $amount on $date';
  }

  @override
  String get hrPayNextPayDay => 'Next pay day';

  @override
  String get hrPayLastPayment => 'Last payment';

  @override
  String get hrPayLatestNet => 'Latest net pay';

  @override
  String hrPayPersonTitle(String name) {
    return 'Pay $name';
  }

  @override
  String get hrPayPeriodAlreadyPaid =>
      'This period already has a payslip. Pick another period, or open the payslip to pay what is left.';

  @override
  String hrPayPeriodHasPayslip(String status, String amount) {
    return 'Already on a payslip ($status, net $amount).';
  }

  @override
  String hrPayAlreadyPaidThisPeriod(String amount) {
    return 'Already handed over in this period: $amount';
  }

  @override
  String get hrPayNothingEarned =>
      'Nothing was earned in this period. Enter the days or hours worked, or a bonus.';

  @override
  String hrPayRecoverMoreThanOwed(String amount) {
    return 'You cannot take back more than the $amount still owed on an advance.';
  }

  @override
  String hrPayRecoveryOverHalf(String amount) {
    return 'The law allows at most $amount to be withheld from this pay (half of pay after tax and RSSB).';
  }

  @override
  String get hrPayNetNegative =>
      'Deductions are larger than pay. Lower the advance recovery or other deductions.';

  @override
  String get hrPayEnterAmount => 'Enter an amount.';

  @override
  String hrPayMoreThanNet(String amount) {
    return 'That is more than the $amount due.';
  }

  @override
  String get hrPayEarnings => 'Earnings';

  @override
  String get hrPayDeductions => 'Deductions';

  @override
  String get hrPayDaysWorked => 'Days worked';

  @override
  String get hrPayHoursWorked => 'Hours worked';

  @override
  String hrPayRateHelper(String rate) {
    return 'At $rate each. Pre-filled from attendance.';
  }

  @override
  String get hrPayBasePay => 'Base pay';

  @override
  String get hrPayAllowances => 'Allowances';

  @override
  String get hrPayBonus => 'Bonus or overtime';

  @override
  String get hrPayGross => 'Gross pay';

  @override
  String get hrPayPaye => 'PAYE (income tax)';

  @override
  String hrPayPension(String percent) {
    return 'RSSB pension ($percent%)';
  }

  @override
  String get hrPayPensionPlain => 'RSSB pension';

  @override
  String get hrPayMaternity => 'Maternity leave';

  @override
  String get hrPayCbhi => 'CBHI (Mutuelle)';

  @override
  String get hrPayOtherDeductions => 'Other deductions';

  @override
  String get hrPayAdvancesToRecover => 'Advances to take back';

  @override
  String hrPayAdvanceOf(String amount, String date) {
    return 'Advance of $amount on $date';
  }

  @override
  String hrPayStillOwed(String amount) {
    return '$amount still owed';
  }

  @override
  String hrPayRecoveryLimit(String amount) {
    return 'At most $amount may be taken back from this pay.';
  }

  @override
  String get hrPayNetPay => 'Net pay';

  @override
  String hrPayEmployerCost(String amount) {
    return 'Costs the business $amount with employer contributions';
  }

  @override
  String get hrPayPayment => 'Payment';

  @override
  String get hrPayRecordPaymentNow => 'I am paying now';

  @override
  String get hrPayRecordPaymentHint =>
      'Turn off to save the payslip and pay later.';

  @override
  String hrPaySendTo(String account) {
    return 'Send to $account';
  }

  @override
  String get hrPayAmountPaidNow => 'Amount paid now';

  @override
  String get hrPayPartialHint =>
      'Pay part now and the rest later if you need to.';

  @override
  String get hrPayReference => 'Reference (optional)';

  @override
  String get hrPayReferenceHint => 'MoMo transaction ID or bank reference';

  @override
  String get hrPayNote => 'Note (optional)';

  @override
  String hrPayRatesFootnote(String version) {
    return 'Statutory rates $version: PAYE (Law 027/2022), RSSB pension (Order 086/01 of 2024), maternity, occupational hazards and CBHI.';
  }

  @override
  String hrPayPaidToast(String name, String period) {
    return 'Paid $name for $period';
  }

  @override
  String get hrPayRecordedToast => 'Payment recorded';

  @override
  String hrPayslipFor(String period) {
    return 'Payslip · $period';
  }

  @override
  String get hrPayAdvanceRecovered => 'Advance taken back';

  @override
  String hrPayAdvanceRecoveredAmount(String amount) {
    return '$amount advance taken back';
  }

  @override
  String get hrPayEmployerContributions => 'Employer contributions';

  @override
  String get hrPayOccupationalHazards => 'Occupational hazards';

  @override
  String get hrPayPaymentsMade => 'Payments made';

  @override
  String get hrPayNothingPaidYet =>
      'Nothing has been paid on this payslip yet.';

  @override
  String hrPayStillToPay(String amount) {
    return '$amount still to pay';
  }

  @override
  String hrPayVoidedBecause(String reason) {
    return 'Voided: $reason';
  }

  @override
  String get hrPayVoidPayslipTitle => 'Void this payslip?';

  @override
  String get hrPayVoidPayslipMessage =>
      'The period becomes unpaid again and any advance it took back is owed again. Nothing is deleted.';

  @override
  String get hrPayVoidPayslipWithPayments =>
      'The payments recorded against it are voided too. The period becomes unpaid again and any advance it took back is owed again.';

  @override
  String get hrPayVoidPaymentTitle => 'Void this payment?';

  @override
  String hrPayVoidPaymentMessage(String amount) {
    return 'The $amount will no longer count as paid. Nothing is deleted.';
  }

  @override
  String hrPayslipFooter(String version) {
    return 'Computed with Rwanda statutory rates $version. Generated by Flipper HR.';
  }

  @override
  String hrPayPaidKind(String kind) {
    return 'Paid · $kind';
  }

  @override
  String hrPayAdvanceGivenOn(String date) {
    return 'Advance given $date';
  }

  @override
  String get hrPayNoHistory =>
      'No payments yet. Payslips, payments and advances will appear here.';

  @override
  String get hrPayPersonNotFound =>
      'This person is not on the selected branch.';

  @override
  String get hrPayNoRecordTitle => 'No employee record yet';

  @override
  String get hrPayNoRecordBody =>
      'Your payslips appear here once your employer adds you to their team in Flipper HR.';

  @override
  String get hrPayNobodyYet => 'Nobody to pay yet';

  @override
  String get hrPayNobodyYetBody =>
      'Add your team with their salary, and their pay days show up here.';

  @override
  String get hrPayNoPayslips =>
      'No payslips yet. Pay someone and their payslip appears here.';

  @override
  String get hrPayNoAdvances =>
      'No advances. Money given ahead of pay day is tracked here until it is taken back.';

  @override
  String get hrPayNoRequests =>
      'No advance requests. When someone asks for an advance in the app, it lands here.';

  @override
  String get hrPayNoPayslipsThisMonth => 'No payslips end in this month.';

  @override
  String hrPayReturnsDeadline(String date) {
    return 'Declare and pay PAYE and RSSB contributions by $date.';
  }

  @override
  String get hrPayReturnsRra => 'To RRA';

  @override
  String get hrPayReturnsRssb => 'To RSSB';

  @override
  String get hrPayPensionBothSides => 'Pension (employee + employer)';

  @override
  String get hrPayMaternityBothSides => 'Maternity (employee + employer)';

  @override
  String get hrPayRssbTotal => 'Total to RSSB';

  @override
  String get hrPayTotalCost => 'Total cost to the business';

  @override
  String get hrPayReturnsCopy => 'Copy for filing';

  @override
  String get hrPayReturnsCopied => 'Copied. Paste it into a spreadsheet.';

  @override
  String get hrAdvanceGive => 'Give advance';

  @override
  String get hrAdvanceRequest => 'Ask for an advance';

  @override
  String hrAdvanceGiveTitle(String name) {
    return 'Advance for $name';
  }

  @override
  String get hrAdvanceGiveSubtitle =>
      'Money given before pay day. It is taken back from their next payslips.';

  @override
  String get hrAdvanceRequestTitle => 'Ask for an advance';

  @override
  String get hrAdvanceRequestSubtitle =>
      'Your manager decides, and it is taken back from your next pay.';

  @override
  String get hrAdvanceAmount => 'Amount';

  @override
  String get hrAdvanceReason => 'Reason (optional)';

  @override
  String get hrAdvanceReasonHint => 'e.g. school fees, rent';

  @override
  String get hrAdvanceRecovery => 'Taking it back';

  @override
  String get hrAdvanceRecoverNextPay => 'All of it from the next pay';

  @override
  String get hrAdvanceRecoverNextPayHint =>
      'Never more than half of that pay; anything left carries over.';

  @override
  String get hrAdvanceRecoverInstallments => 'In instalments';

  @override
  String get hrAdvancePerPayslip => 'Amount per payslip';

  @override
  String hrAdvanceInstallmentCount(String count) {
    return 'About $count payslips';
  }

  @override
  String hrAdvanceInstallmentOf(String amount) {
    return '$amount per payslip';
  }

  @override
  String get hrAdvanceEnterInstallment =>
      'Enter how much to take back on each payslip.';

  @override
  String hrAdvanceAlreadyOwed(String amount) {
    return 'Already owes $amount from earlier advances.';
  }

  @override
  String hrAdvanceOverHalf(String amount) {
    return 'More than one payslip can take back: at most $amount per payslip is allowed, so this will take several pay days to recover.';
  }

  @override
  String hrAdvanceGiveAmount(String amount) {
    return 'Give $amount';
  }

  @override
  String get hrAdvanceSendRequest => 'Send request';

  @override
  String get hrAdvanceRecordedToast => 'Advance recorded';

  @override
  String get hrAdvanceRequestedToast => 'Request sent to your manager';

  @override
  String hrAdvanceRequestPending(String amount) {
    return 'Your request for $amount is waiting for a decision.';
  }

  @override
  String get hrAdvanceCancelRequest => 'Cancel request';

  @override
  String get hrAdvanceApproveAndGive => 'Approve and give';

  @override
  String get hrAdvanceDecline => 'Decline';

  @override
  String get hrAdvanceDeclineTitle => 'Decline this request?';

  @override
  String get hrAdvanceDeclineMessage => 'Say why, so they know.';

  @override
  String hrAdvanceApprovedToast(String amount, String name) {
    return 'Gave $amount to $name';
  }

  @override
  String hrAdvanceProgress(String recovered, String owed) {
    return '$recovered taken back · $owed to go';
  }

  @override
  String get hrAdvanceWriteOff => 'Write off';

  @override
  String get hrAdvanceWriteOffTitle => 'Write off this advance?';

  @override
  String hrAdvanceWriteOffMessage(String amount) {
    return 'The $amount still owed will not be taken back from pay.';
  }

  @override
  String get hrAdvanceVoidTitle => 'Void this advance?';

  @override
  String get hrAdvanceVoidMessage =>
      'Use this when it was recorded by mistake. The money handed over is voided too.';

  @override
  String hrAllowancesWithCurrency(String currency) {
    return 'Monthly allowances ($currency)';
  }

  @override
  String get hrAllowancesHelper =>
      'Transport, housing… paid every month on top of base pay. Taxed.';

  @override
  String get hrPayDayOfMonth => 'Pay day';

  @override
  String get hrPayDayHelper => 'Day of the month (1–31). Blank: last day.';

  @override
  String get hrTaxCategory => 'Income tax';

  @override
  String get hrTaxCategoryHelper => 'How PAYE is worked out for this person.';

  @override
  String get hrRssbEnrolled => 'Registered with RSSB';

  @override
  String get hrRssbEnrolledHelper =>
      'Deduct pension and maternity contributions and add the employer\'s share.';

  @override
  String hrPayPeopleDue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pay $count people',
      one: 'Pay 1 person',
    );
    return '$_temp0';
  }

  @override
  String dailyGoalPlusPoints(int points) {
    return '+$points pts';
  }

  @override
  String dailyGoalPoints(int points) {
    return '$points pts';
  }

  @override
  String dailyGoalStreakShort(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days-day streak',
      one: '1-day streak',
    );
    return '$_temp0';
  }

  @override
  String dailyGoalBestStreak(int days) {
    return 'Best: $days days';
  }

  @override
  String dailyGoalPointsToday(int points) {
    return '+$points today';
  }

  @override
  String get dailyGoalChipSale => 'Sale';

  @override
  String get dailyGoalChipExpense => 'Expense';

  @override
  String get dailyGoalChipStock => 'Stock';

  @override
  String get dailyGoalChipGoal => 'Goal';

  @override
  String get dailyGoalMissionSale => 'Record a sale';

  @override
  String get dailyGoalMissionExpense => 'Record an expense';

  @override
  String get dailyGoalMissionStock => 'Update your stock';

  @override
  String get dailyGoalMissionGoal => 'Reach today\'s sales goal';

  @override
  String get dailyGoalSheetTitle => 'Today\'s goal';

  @override
  String get dailyGoalMissionsHeading => 'Today\'s missions';

  @override
  String dailyGoalStreakRule(int days, int points) {
    return 'Reach the goal $days days in a row for +$points bonus points.';
  }

  @override
  String get dailyGoalThisWeek => 'This week';

  @override
  String get dailyGoalWeekEmpty => 'Your week shows here from tomorrow.';

  @override
  String get dailyGoalSettingsHeading => 'Goal settings';

  @override
  String dailyGoalTarget(int count) {
    return 'Daily target: $count sales';
  }

  @override
  String get dailyGoalTargetAuto => 'Adapts to your recent days';

  @override
  String get dailyGoalTargetCustom => 'Your own target';

  @override
  String get dailyGoalUseAutomatic => 'Use automatic';

  @override
  String get dailyGoalReminders => 'Daily reminders';

  @override
  String get dailyGoalRemindersHint =>
      'A nudge if no sale is recorded by 10:00 and a recap in the evening. At most 2 a day.';

  @override
  String get dailyGoalOwnerOnly =>
      'Only the owner or an admin can change these.';

  @override
  String get dailyGoalDoIt => 'Do it';

  @override
  String get dailyGoalDone => 'Done';

  @override
  String get booksExportColItem => 'Item';

  @override
  String get booksExportColAmount => 'Amount';

  @override
  String get booksExportColDate => 'Date';

  @override
  String get booksExportColEntry => 'Entry';

  @override
  String get booksExportColMemo => 'Memo';

  @override
  String get booksExportColSource => 'Source';

  @override
  String get booksExportColDebit => 'Debit';

  @override
  String get booksExportColCredit => 'Credit';

  @override
  String get booksExportColMonth => 'Month';

  @override
  String get booksExportColRevenue => 'Revenue';

  @override
  String get booksExportColNet => 'Net';

  @override
  String get booksExportSheetTrend => 'Trend';

  @override
  String get booksExportSheetJournal => 'Journal';

  @override
  String get booksExportReady => 'Export ready';

  @override
  String booksExportGeneratedAt(String date) {
    return 'Generated $date';
  }

  @override
  String booksExportPageOf(String page, String total) {
    return 'Page $page of $total';
  }
}
