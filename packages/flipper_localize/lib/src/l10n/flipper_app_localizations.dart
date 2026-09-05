import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'flipper_app_localizations_en.dart';
import 'flipper_app_localizations_fr.dart';
import 'flipper_app_localizations_rw.dart';
import 'flipper_app_localizations_sw.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of FlipperAppLocalizations
/// returned by `FlipperAppLocalizations.of(context)`.
///
/// Applications need to include `FlipperAppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/flipper_app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
///   supportedLocales: FlipperAppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the FlipperAppLocalizations.supportedLocales
/// property.
abstract class FlipperAppLocalizations {
  FlipperAppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static FlipperAppLocalizations of(BuildContext context) {
    return Localizations.of<FlipperAppLocalizations>(
      context,
      FlipperAppLocalizations,
    )!;
  }

  static const LocalizationsDelegate<FlipperAppLocalizations> delegate =
      _FlipperAppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('rw'),
    Locale('sw'),
  ];

  /// The save message
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// The price
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get retailPrice;

  /// Supplier price
  ///
  /// In en, this message translates to:
  /// **'Supplier price'**
  String get supplyPrice;

  /// Current Sale
  ///
  /// In en, this message translates to:
  /// **'Current Sale'**
  String get currentSale;

  /// Current Stock
  ///
  /// In en, this message translates to:
  /// **'Current Stock'**
  String get currentStock;

  /// Add Product
  ///
  /// In en, this message translates to:
  /// **'Add Products'**
  String get addProduct;

  /// The Tickets
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get tickets;

  /// Charge the user for the amount
  ///
  /// In en, this message translates to:
  /// **'Charge'**
  String get charge;

  /// The Name of the product
  ///
  /// In en, this message translates to:
  /// **'Name of the product'**
  String get productName;

  /// The Settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get flipperSetting;

  /// The options
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// can not save the tickets without adding a note to ticket
  ///
  /// In en, this message translates to:
  /// **'you can not save the tickets without adding a note to ticket'**
  String get saveTicket;

  /// Product not found
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get productNotFound;

  /// No payable
  ///
  /// In en, this message translates to:
  /// **'No payable'**
  String get noPayable;

  /// Delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Ongeraho kuri menu
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get addTomenu;

  /// Ongeraho kuri menu
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Add WorkSpace
  ///
  /// In en, this message translates to:
  /// **'Add WorkSpace'**
  String get addWorkSpace;

  /// Add Members
  ///
  /// In en, this message translates to:
  /// **'Add Members'**
  String get addMembers;

  /// Log out action
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// Synchronize counter action
  ///
  /// In en, this message translates to:
  /// **'Sync counter'**
  String get syncCounter;

  /// Reset transaction action
  ///
  /// In en, this message translates to:
  /// **'Reset Transaction'**
  String get resetTransaction;

  /// Reset transaction confirmation title
  ///
  /// In en, this message translates to:
  /// **'Reset Transaction?'**
  String get resetTransactionQuestion;

  /// Reset transaction confirmation description
  ///
  /// In en, this message translates to:
  /// **'This will delete the current pending transaction and all its items. This action cannot be undone.'**
  String get resetTransactionDescription;

  /// Success message after resetting a transaction
  ///
  /// In en, this message translates to:
  /// **'Transaction reset successfully'**
  String get transactionResetSuccessfully;

  /// Error message after failing to reset a transaction
  ///
  /// In en, this message translates to:
  /// **'Error resetting transaction: {error}'**
  String errorResettingTransaction(Object error);

  /// Contact picker error message
  ///
  /// In en, this message translates to:
  /// **'Selected contact has no phone number'**
  String get selectedContactHasNoPhoneNumber;

  /// Contact picker permission snackbar
  ///
  /// In en, this message translates to:
  /// **'Contacts permission is required to pick a contact'**
  String get contactsPermissionRequired;

  /// Permission dialog title
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequired;

  /// Contact picker permission denied dialog body
  ///
  /// In en, this message translates to:
  /// **'Contacts permission has been permanently denied. Please enable it in your device settings to use this feature.'**
  String get contactsPermissionDeniedSettings;

  /// Cancel action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Open device settings action
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorMessage(Object error);

  /// Generic error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Contact picker tooltip
  ///
  /// In en, this message translates to:
  /// **'Pick from contacts'**
  String get pickFromContacts;

  /// Link device screen title
  ///
  /// In en, this message translates to:
  /// **'Link Device'**
  String get linkDevice;

  /// Link device screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Use Flipper on other Devices'**
  String get useFlipperOnOtherDevices;

  /// Link a device button
  ///
  /// In en, this message translates to:
  /// **'Link A Device'**
  String get linkADevice;

  /// PIN display for linking a device
  ///
  /// In en, this message translates to:
  /// **'PIN: {pin}'**
  String pinCode(Object pin);

  /// Connected devices list title
  ///
  /// In en, this message translates to:
  /// **'List of connected Devices'**
  String get listOfConnectedDevices;

  /// Payment confirmation app bar title
  ///
  /// In en, this message translates to:
  /// **'Payment: {paymentType}'**
  String paymentTitle(Object paymentType);

  /// Digital receipt dialog title
  ///
  /// In en, this message translates to:
  /// **'Digital Receipt'**
  String get digitalReceipt;

  /// Digital receipt prompt
  ///
  /// In en, this message translates to:
  /// **'Do you need a digital receipt?'**
  String get needDigitalReceipt;

  /// Purchase code field label
  ///
  /// In en, this message translates to:
  /// **'Purchase Code'**
  String get purchaseCode;

  /// Purchase code validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a purchase code'**
  String get pleaseEnterPurchaseCode;

  /// Submit action
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// Completion status
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Receipt action
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receipt;

  /// Add note action
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// Receipt generation wait message
  ///
  /// In en, this message translates to:
  /// **'Please wait we are generating the receipt'**
  String get generatingReceiptWait;

  /// Powered by label
  ///
  /// In en, this message translates to:
  /// **'Powered By'**
  String get poweredBy;

  /// Return home action
  ///
  /// In en, this message translates to:
  /// **'Return to Home'**
  String get returnToHome;

  /// Personal goals screen title
  ///
  /// In en, this message translates to:
  /// **'Personal goals'**
  String get personalGoals;

  /// Personal goals empty branch message
  ///
  /// In en, this message translates to:
  /// **'Select a branch to manage goals.'**
  String get selectBranchToManageGoals;

  /// Personal goals load error
  ///
  /// In en, this message translates to:
  /// **'Could not load goals\n{error}'**
  String couldNotLoadGoals(Object error);

  /// Personal goals section eyebrow
  ///
  /// In en, this message translates to:
  /// **'PERSONAL GOALS'**
  String get personalGoalsEyebrow;

  /// Personal goals total reserved summary
  ///
  /// In en, this message translates to:
  /// **'Total reserved across {count, plural, =1{1 goal} other{{count} goals}}'**
  String totalReservedAcrossGoals(int count);

  /// Personal goals saved this month label
  ///
  /// In en, this message translates to:
  /// **'Saved this month'**
  String get savedThisMonth;

  /// Personal goals on track count
  ///
  /// In en, this message translates to:
  /// **'{count} on track'**
  String onTrackCount(Object count);

  /// Personal goals progressing label
  ///
  /// In en, this message translates to:
  /// **'Goals progressing'**
  String get goalsProgressing;

  /// All goals section title
  ///
  /// In en, this message translates to:
  /// **'All goals'**
  String get allGoals;

  /// Personal goals helper text
  ///
  /// In en, this message translates to:
  /// **'Flipper quietly grows each goal from your profits.'**
  String get personalGoalsProfitGrowth;

  /// Product search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search products…'**
  String get searchProducts;

  /// Clear selected products action
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get clearSelection;

  /// Selected product count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item selected} other{{count} items selected}}'**
  String itemsSelected(int count);

  /// Product delete validation error
  ///
  /// In en, this message translates to:
  /// **'Cannot delete variant with stock remaining.'**
  String get cannotDeleteVariantWithStockRemaining;

  /// Bulk delete confirmation title
  ///
  /// In en, this message translates to:
  /// **'Delete Multiple Items'**
  String get deleteMultipleItems;

  /// Bulk delete confirmation body
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count, plural, =1{1 item} other{{count} items}}? This action cannot be undone.'**
  String deleteItemsConfirmation(int count);

  /// Refresh products action
  ///
  /// In en, this message translates to:
  /// **'Refresh products'**
  String get refreshProducts;

  /// Product list empty state syncing hint
  ///
  /// In en, this message translates to:
  /// **'If you just opened the app, products may still be syncing — tap refresh.'**
  String get productsSyncingHint;

  /// Product loading error title
  ///
  /// In en, this message translates to:
  /// **'Error loading products'**
  String get errorLoadingProducts;

  /// Retry action
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No stock data empty state
  ///
  /// In en, this message translates to:
  /// **'No stock data available'**
  String get noStockDataAvailable;

  /// Cash payment method
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// Credit payment method
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get credit;

  /// Mobile money payer phone label
  ///
  /// In en, this message translates to:
  /// **'MoMo payer phone'**
  String get momoPayerPhone;

  /// Mobile money payment request helper
  ///
  /// In en, this message translates to:
  /// **'We will send a payment request to this number when you tap Charge.'**
  String get momoPaymentRequestHint;

  /// Exact cash amount shortcut
  ///
  /// In en, this message translates to:
  /// **'Exact'**
  String get exact;

  /// Confirm action
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Number of payments field label
  ///
  /// In en, this message translates to:
  /// **'Number of Payments'**
  String get numberOfPayments;

  /// Apply discount code toggle label
  ///
  /// In en, this message translates to:
  /// **'Apply Discount Code'**
  String get applyDiscountCode;

  /// Discount code field label
  ///
  /// In en, this message translates to:
  /// **'Discount Code'**
  String get discountCode;

  /// Discount code validation progress
  ///
  /// In en, this message translates to:
  /// **'Validating code...'**
  String get validatingCode;

  /// Create account action
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Sign in action
  ///
  /// In en, this message translates to:
  /// **'SIGN IN'**
  String get signIn;

  /// Warning to enable automatic device time
  ///
  /// In en, this message translates to:
  /// **'Please set your device time to automatic'**
  String get setDeviceTimeAutomatic;

  /// Phone auth button
  ///
  /// In en, this message translates to:
  /// **'Continue with Phone'**
  String get continueWithPhone;

  /// Google auth button
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// Microsoft auth button
  ///
  /// In en, this message translates to:
  /// **'Continue with Microsoft'**
  String get continueWithMicrosoft;

  /// Apple auth button
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// Authentication divider
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// PIN login action
  ///
  /// In en, this message translates to:
  /// **'PIN Login'**
  String get pinLogin;

  /// Languages settings title
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languagesTitle;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Kinyarwanda language name
  ///
  /// In en, this message translates to:
  /// **'Kinyarwanda'**
  String get kinyarwanda;

  /// Swahili language name
  ///
  /// In en, this message translates to:
  /// **'Swahili'**
  String get swahili;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Home navigation label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Sales navigation label
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales;

  /// Inventory navigation label
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// More navigation label
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// Scan QR action
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get scanQr;

  /// Dashboard navigation label
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No user empty state title
  ///
  /// In en, this message translates to:
  /// **'No User'**
  String get noUser;

  /// No user empty state subtitle
  ///
  /// In en, this message translates to:
  /// **'Please log in to continue'**
  String get pleaseLogInToContinue;

  /// Loading businesses status
  ///
  /// In en, this message translates to:
  /// **'Loading businesses...'**
  String get loadingBusinesses;

  /// Business list loading error
  ///
  /// In en, this message translates to:
  /// **'Error loading businesses'**
  String get errorLoadingBusinesses;

  /// No businesses empty state title
  ///
  /// In en, this message translates to:
  /// **'No Businesses'**
  String get noBusinesses;

  /// No businesses empty state subtitle
  ///
  /// In en, this message translates to:
  /// **'Create your first business to get started'**
  String get createFirstBusiness;

  /// Sign out action
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Phone auth sending code progress
  ///
  /// In en, this message translates to:
  /// **'Sending code...'**
  String get sendingCode;

  /// Continue action
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// OTP instruction prefix
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to '**
  String get enterSixDigitCodeSentTo;

  /// Expired OTP resend action
  ///
  /// In en, this message translates to:
  /// **'Code Expired - Tap to Resend'**
  String get codeExpiredTapToResend;

  /// Resend OTP action
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// Resend OTP countdown prefix
  ///
  /// In en, this message translates to:
  /// **'Resend code in '**
  String get resendCodeIn;

  /// Seconds unit
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get seconds;

  /// OTP verification progress
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get verifying;

  /// Verify OTP action
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// PIN login help dialog title
  ///
  /// In en, this message translates to:
  /// **'Trouble Signing In?'**
  String get troubleSigningIn;

  /// PIN login help dialog body
  ///
  /// In en, this message translates to:
  /// **'If you are having trouble signing in, please ensure your PIN and OTP (if applicable) are correct.\n\nFor further assistance, please contact support.'**
  String get troubleSigningInHelp;

  /// OK action
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Default returning user greeting
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// TIN number field label
  ///
  /// In en, this message translates to:
  /// **'TIN Number'**
  String get tinNumber;

  /// Validate action
  ///
  /// In en, this message translates to:
  /// **'Validate'**
  String get validate;

  /// Upload PDF containing TIN tooltip
  ///
  /// In en, this message translates to:
  /// **'Upload PDF with TIN'**
  String get uploadPdfWithTin;

  /// TIN field hint
  ///
  /// In en, this message translates to:
  /// **'Enter TIN number or tap the upload icon'**
  String get enterTinOrUpload;

  /// Add email action
  ///
  /// In en, this message translates to:
  /// **'Add Email'**
  String get addEmail;

  /// Email added success message
  ///
  /// In en, this message translates to:
  /// **'Email added'**
  String get emailAdded;

  /// Update settings action
  ///
  /// In en, this message translates to:
  /// **'Update Settings'**
  String get updateSettings;

  /// Invite members action
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get invite;

  /// Send invitation request action
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get sendRequest;

  /// Preferences settings title
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// Accessibility settings title
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get accessibility;

  /// Language settings label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Reports settings title
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// Enable report setting
  ///
  /// In en, this message translates to:
  /// **'Enable Report'**
  String get enableReport;

  /// Backups settings title
  ///
  /// In en, this message translates to:
  /// **'BackUps'**
  String get backups;

  /// Add backup title
  ///
  /// In en, this message translates to:
  /// **'Add Backup'**
  String get addBackup;

  /// Restore data action
  ///
  /// In en, this message translates to:
  /// **'Restore Data'**
  String get restoreData;

  /// Backup restore success message
  ///
  /// In en, this message translates to:
  /// **'Data restored'**
  String get dataRestored;

  /// Backup restore error message
  ///
  /// In en, this message translates to:
  /// **'Error Restoring backup'**
  String get errorRestoringBackup;

  /// Transaction ID copied success message
  ///
  /// In en, this message translates to:
  /// **'Transaction ID copied to clipboard'**
  String get transactionIdCopiedToClipboard;

  /// Short transaction ID label
  ///
  /// In en, this message translates to:
  /// **'Txn ID: '**
  String get transactionIdShortLabel;

  /// Invoice number label
  ///
  /// In en, this message translates to:
  /// **'Invoice No: '**
  String get invoiceNumberLabel;

  /// Save ticket tooltip
  ///
  /// In en, this message translates to:
  /// **'Park this sale as a ticket'**
  String get parkSaleAsTicket;

  /// Save current sale as ticket action
  ///
  /// In en, this message translates to:
  /// **'Save ticket'**
  String get saveTicketAction;

  /// Remaining balance label
  ///
  /// In en, this message translates to:
  /// **'Remaining Balance: '**
  String get remainingBalanceLabel;

  /// Amount to change label
  ///
  /// In en, this message translates to:
  /// **'Amount to Change: '**
  String get amountToChangeLabel;

  /// All apps launcher title
  ///
  /// In en, this message translates to:
  /// **'All apps'**
  String get allApps;

  /// All apps sell section
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// Quick sell app tile
  ///
  /// In en, this message translates to:
  /// **'Quick Sell'**
  String get quickSell;

  /// Invoices app tile
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get invoices;

  /// Pricing app tile
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get pricing;

  /// Payments app tile
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// All apps manage section
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// Purchases app tile
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get purchases;

  /// Customers app tile
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// Leads app tile
  ///
  /// In en, this message translates to:
  /// **'Leads'**
  String get leads;

  /// All apps insights section
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// Daily reports app tile
  ///
  /// In en, this message translates to:
  /// **'Daily Reports'**
  String get dailyReports;

  /// Commissions app tile
  ///
  /// In en, this message translates to:
  /// **'Commissions'**
  String get commissions;

  /// Production app tile
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get production;

  /// All apps business section
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business;

  /// Services hub app tile
  ///
  /// In en, this message translates to:
  /// **'Services hub'**
  String get servicesHub;

  /// Goals app tile
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goals;

  /// AI chat app tile
  ///
  /// In en, this message translates to:
  /// **'AI Chat'**
  String get aiChat;

  /// Fallback message when the quick selling transaction view fails to render
  ///
  /// In en, this message translates to:
  /// **'Error loading transaction view'**
  String get errorLoadingTransactionView;

  /// Customer section label
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// Payment section label
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// Delivery section label
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// Accessibility label for transaction summary
  ///
  /// In en, this message translates to:
  /// **'Transaction summary'**
  String get transactionSummary;

  /// Accessibility hint for transaction summary
  ///
  /// In en, this message translates to:
  /// **'Shows the total amount and transaction ID for the current sale'**
  String get transactionSummaryHint;

  /// Total amount label
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// Error shown when trying to delete items after partial payment
  ///
  /// In en, this message translates to:
  /// **'Cannot delete items from a transaction with partial payments'**
  String get cannotDeletePartialPaymentItems;

  /// Dialog title for deleting all cart items
  ///
  /// In en, this message translates to:
  /// **'Delete All Items'**
  String get deleteAllItems;

  /// Confirmation message for deleting all transaction items
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove all items from this transaction?'**
  String get confirmRemoveAllTransactionItems;

  /// Trailing row when a preview list is truncated
  ///
  /// In en, this message translates to:
  /// **'+{count} more'**
  String plusMoreItems(int count);

  /// Warning footnote on destructive confirmation dialogs
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get actionCannotBeUndone;

  /// Delete all action
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get deleteAll;

  /// Success notification after deleting all items
  ///
  /// In en, this message translates to:
  /// **'All items removed successfully'**
  String get allItemsRemovedSuccessfully;

  /// Error notification after failing to remove all items
  ///
  /// In en, this message translates to:
  /// **'Error removing items: {error}'**
  String errorRemovingItems(String error);

  /// Empty cart title
  ///
  /// In en, this message translates to:
  /// **'No items added'**
  String get noItemsAdded;

  /// Empty cart helper text
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to add your first item'**
  String get tapAddFirstItem;

  /// Cart item count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String cartItemCount(int count);

  /// Accessibility label for a cart item
  ///
  /// In en, this message translates to:
  /// **'Item: {itemName}'**
  String itemSemanticLabel(String itemName);

  /// Accessibility hint for a cart item
  ///
  /// In en, this message translates to:
  /// **'Quantity: {quantity}, Unit price: {unitPrice}, Subtotal: {subtotal}'**
  String cartItemSemanticHint(
    String quantity,
    String unitPrice,
    String subtotal,
  );

  /// Remove item action
  ///
  /// In en, this message translates to:
  /// **'Remove item'**
  String get removeItem;

  /// Unit price label
  ///
  /// In en, this message translates to:
  /// **'Unit Price'**
  String get unitPrice;

  /// Quantity decrement tooltip
  ///
  /// In en, this message translates to:
  /// **'Decrease quantity by 1'**
  String get decreaseQuantityByOne;

  /// Quantity increment tooltip
  ///
  /// In en, this message translates to:
  /// **'Increase quantity by 1'**
  String get increaseQuantityByOne;

  /// Subtotal label
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// Delivery date field label
  ///
  /// In en, this message translates to:
  /// **'Delivery Date'**
  String get deliveryDate;

  /// Accessibility label for payment action area
  ///
  /// In en, this message translates to:
  /// **'Transaction summary and payment actions'**
  String get transactionSummaryPaymentActions;

  /// Accessibility hint for payment action area
  ///
  /// In en, this message translates to:
  /// **'Complete sale with total amount {total}'**
  String completeSaleTotalHint(String total);

  /// Generic error label with value
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorWithValue(String error);

  /// Confirmation message before removing a cart item
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove \"{itemName}\" from this transaction?'**
  String confirmRemoveItemFromTransaction(String itemName);

  /// Remove action
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Error shown when changing item quantity after partial payment
  ///
  /// In en, this message translates to:
  /// **'Cannot modify items in a transaction with partial payments'**
  String get cannotModifyPartialPaymentItems;

  /// Error notification after failing to remove an item
  ///
  /// In en, this message translates to:
  /// **'Failed to remove item'**
  String get failedToRemoveItem;

  /// Error notification after failing to update item quantity
  ///
  /// In en, this message translates to:
  /// **'Failed to update item quantity'**
  String get failedToUpdateItemQuantity;

  /// Accessibility label for cart item list
  ///
  /// In en, this message translates to:
  /// **'Transaction items list'**
  String get transactionItemsList;

  /// Accessibility hint for cart item list
  ///
  /// In en, this message translates to:
  /// **'List of items in the current transaction with quantities and prices'**
  String get transactionItemsListHint;

  /// Delivery note field label
  ///
  /// In en, this message translates to:
  /// **'Delivery Note'**
  String get deliveryNote;

  /// Accessibility label for delivery note
  ///
  /// In en, this message translates to:
  /// **'Delivery note'**
  String get deliveryNoteSemantic;

  /// Accessibility hint for delivery note
  ///
  /// In en, this message translates to:
  /// **'Add any special instructions for delivery'**
  String get deliveryNoteHint;

  /// Delivery note text field hint
  ///
  /// In en, this message translates to:
  /// **'Enter any special instructions for delivery'**
  String get deliveryInstructionsHint;

  /// Discount field label
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// Validation error for invalid numeric input
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get pleaseEnterValidNumber;

  /// Validation error for invalid discount percentage
  ///
  /// In en, this message translates to:
  /// **'Discount must be between 0 and 100'**
  String get discountRangeError;

  /// Digital receipt toggle title
  ///
  /// In en, this message translates to:
  /// **'Digital receipt'**
  String get digitalReceiptTitle;

  /// Digital receipt toggle subtitle
  ///
  /// In en, this message translates to:
  /// **'Send receipt by SMS instead of opening a PDF'**
  String get digitalReceiptSmsSubtitle;

  /// Accessibility label for received amount field
  ///
  /// In en, this message translates to:
  /// **'Received amount in {currency}'**
  String receivedAmountInCurrency(String currency);

  /// Accessibility hint for received amount field
  ///
  /// In en, this message translates to:
  /// **'Enter the amount received from the customer'**
  String get receivedAmountHint;

  /// Received amount field hint
  ///
  /// In en, this message translates to:
  /// **'Received Amount'**
  String get receivedAmount;

  /// Validation error for empty received amount
  ///
  /// In en, this message translates to:
  /// **'Please enter received amount'**
  String get pleaseEnterReceivedAmount;

  /// Customer name field label
  ///
  /// In en, this message translates to:
  /// **'Customer name'**
  String get customerName;

  /// Accessibility hint for customer name field
  ///
  /// In en, this message translates to:
  /// **'Enter the full name of the customer'**
  String get customerNameHint;

  /// Validation error for empty customer name
  ///
  /// In en, this message translates to:
  /// **'Please enter customer name'**
  String get pleaseEnterCustomerName;

  /// Accessibility label for customer phone number field
  ///
  /// In en, this message translates to:
  /// **'Customer phone number'**
  String get customerPhoneNumber;

  /// Accessibility hint for customer phone number field
  ///
  /// In en, this message translates to:
  /// **'Enter the customer\'s phone number for contact and billing purposes'**
  String get customerPhoneNumberHint;

  /// Items section label
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// Transaction ID label
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get transactionId;

  /// Amount paid label
  ///
  /// In en, this message translates to:
  /// **'Amount Paid'**
  String get amountPaid;

  /// Remaining balance label
  ///
  /// In en, this message translates to:
  /// **'Remaining Balance'**
  String get remainingBalance;

  /// Payment button label when recording a partial payment
  ///
  /// In en, this message translates to:
  /// **'Record Payment • {amount}'**
  String recordPaymentWithAmount(String amount);

  /// Payment button label
  ///
  /// In en, this message translates to:
  /// **'Pay • {amount}'**
  String payWithAmount(String amount);

  /// Payment button label when the Ticket Review + Handover workflow is enabled and the sale will be fully paid
  ///
  /// In en, this message translates to:
  /// **'Send for Review • {amount}'**
  String sendForReviewWithAmount(String amount);

  /// Validation error when phone number is required because TIN is missing
  ///
  /// In en, this message translates to:
  /// **'Phone number is required when customer TIN is not available'**
  String get phoneRequiredWhenTinMissing;

  /// Validation error for invalid phone number
  ///
  /// In en, this message translates to:
  /// **'Invalid Number'**
  String get invalidNumber;

  /// Back navigation tooltip
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Admin management dashboard title
  ///
  /// In en, this message translates to:
  /// **'Management Dashboard'**
  String get managementDashboard;

  /// Quick actions section title
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// POS default setting title
  ///
  /// In en, this message translates to:
  /// **'POS Default'**
  String get posDefault;

  /// POS default setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Set POS as default app'**
  String get setPosAsDefaultApp;

  /// Orders default setting title
  ///
  /// In en, this message translates to:
  /// **'Orders Default'**
  String get ordersDefault;

  /// Orders default setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Set Orders as default app'**
  String get setOrdersAsDefaultApp;

  /// Account management section title
  ///
  /// In en, this message translates to:
  /// **'Account Management'**
  String get accountManagement;

  /// User management setting title
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagement;

  /// User management setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage users and permissions'**
  String get manageUsersAndPermissions;

  /// Branch management setting title
  ///
  /// In en, this message translates to:
  /// **'Branch Management'**
  String get branchManagement;

  /// Branch management setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage Branch (Locations)'**
  String get manageBranchLocations;

  /// Financial controls section title
  ///
  /// In en, this message translates to:
  /// **'Financial Controls'**
  String get financialControls;

  /// Tax settings title
  ///
  /// In en, this message translates to:
  /// **'Tax Settings'**
  String get taxSettings;

  /// Tax settings subtitle
  ///
  /// In en, this message translates to:
  /// **'Configure tax rules and rates'**
  String get configureTaxRulesAndRates;

  /// EBM settings title
  ///
  /// In en, this message translates to:
  /// **'EBM Settings'**
  String get ebmSettings;

  /// EBM settings subtitle
  ///
  /// In en, this message translates to:
  /// **'Electronic Billing Machine settings'**
  String get electronicBillingMachineSettings;

  /// SMS configuration section title
  ///
  /// In en, this message translates to:
  /// **'SMS Configuration'**
  String get smsConfiguration;

  /// SMS notification toggle title
  ///
  /// In en, this message translates to:
  /// **'Enable SMS Notifications'**
  String get enableSmsNotifications;

  /// WhatsApp notification toggle title
  ///
  /// In en, this message translates to:
  /// **'Enable WhatsApp Notifications'**
  String get enableWhatsappNotifications;

  /// WhatsApp notification toggle subtitle
  ///
  /// In en, this message translates to:
  /// **'Receive WhatsApp notifications for orders and digital receipt PDFs'**
  String get receiveWhatsappNotificationsForOrders;

  /// System settings section title
  ///
  /// In en, this message translates to:
  /// **'System Settings'**
  String get systemSettings;

  /// Debug mode setting title
  ///
  /// In en, this message translates to:
  /// **'Debug Mode'**
  String get debugMode;

  /// Debug mode setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Enable debug features'**
  String get enableDebugFeatures;

  /// Force update setting title
  ///
  /// In en, this message translates to:
  /// **'Force Update'**
  String get forceUpdate;

  /// Force update setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Force update all data'**
  String get forceUpdateAllData;

  /// Tax service setting title
  ///
  /// In en, this message translates to:
  /// **'Tax Service'**
  String get taxService;

  /// Tax service setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Toggle tax service'**
  String get toggleTaxService;

  /// Success notification after saving a discount
  ///
  /// In en, this message translates to:
  /// **'Saved discount'**
  String get savedDiscount;

  /// Create discount page title
  ///
  /// In en, this message translates to:
  /// **'Create Discount'**
  String get createDiscount;

  /// Validation error for empty name
  ///
  /// In en, this message translates to:
  /// **'Name can not be null'**
  String get nameCannotBeNull;

  /// Validation error for empty amount
  ///
  /// In en, this message translates to:
  /// **'Amount can not be null'**
  String get amountCannotBeNull;

  /// Name field label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Confirmation dialog title for saving a transaction
  ///
  /// In en, this message translates to:
  /// **'Save {transactionType} transaction'**
  String saveTransactionTitle(String transactionType);

  /// Confirmation dialog message for saving a transaction
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to save this transaction?'**
  String get confirmSaveTransaction;

  /// Warning shown when saving without category
  ///
  /// In en, this message translates to:
  /// **'A category must be selected'**
  String get categoryMustBeSelected;

  /// Logout confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogout;

  /// Logout confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get confirmLogoutMessage;

  /// Refund reason field label
  ///
  /// In en, this message translates to:
  /// **'Refund Reason'**
  String get refundReason;

  /// Refund status reason
  ///
  /// In en, this message translates to:
  /// **'Wait for Approval'**
  String get waitForApproval;

  /// Refund status reason
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// Refund status reason
  ///
  /// In en, this message translates to:
  /// **'Cancel Requested'**
  String get cancelRequested;

  /// Refund status reason
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get canceled;

  /// Refund status reason
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get refunded;

  /// Refund status reason
  ///
  /// In en, this message translates to:
  /// **'Transferred'**
  String get transferred;

  /// Admin Control tile title for the app language setting
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// Subtitle of the app language tile
  ///
  /// In en, this message translates to:
  /// **'Choose the language Flipper uses'**
  String get chooseAppLanguage;

  /// Title of the language picker sheet
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Explains the scope of the language choice
  ///
  /// In en, this message translates to:
  /// **'Applies to every screen in the app.'**
  String get languageAppliesEverywhere;

  /// Option to follow the device language instead of an explicit choice
  ///
  /// In en, this message translates to:
  /// **'Use device language'**
  String get useDeviceLanguage;

  /// Tag shown when the language follows the device
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get automatic;

  /// The French language
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// Admin Control section header
  ///
  /// In en, this message translates to:
  /// **'Account & financial'**
  String get accountAndFinancial;

  /// Admin Control section header
  ///
  /// In en, this message translates to:
  /// **'Admin profile'**
  String get adminProfile;

  /// Admin Control section header
  ///
  /// In en, this message translates to:
  /// **'SMS notifications'**
  String get smsNotifications;

  /// Close a screen or dialog
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Reload the current data
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Placeholder for the admin email field
  ///
  /// In en, this message translates to:
  /// **'e.g. admin@flipper.rw'**
  String get adminEmailHint;

  /// Label for the admin display name field
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get displayName;

  /// Tooltip for editing the admin display name
  ///
  /// In en, this message translates to:
  /// **'Edit name'**
  String get editName;

  /// Admin Control card title
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// Admin Control card subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage payment options'**
  String get managePaymentOptions;

  /// Placeholder for a phone number field
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNumber;

  /// SMS setting title
  ///
  /// In en, this message translates to:
  /// **'Enable Order Notifications'**
  String get enableOrderNotifications;

  /// SMS setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Receive SMS notifications for orders'**
  String get receiveSmsNotificationsForOrders;

  /// Debug mode subtitle
  ///
  /// In en, this message translates to:
  /// **'Enable debugging features'**
  String get enableDebuggingFeatures;

  /// Electronic Billing Machine, kept as an acronym
  ///
  /// In en, this message translates to:
  /// **'EBM'**
  String get ebm;

  /// Admin action to re-register the tax device
  ///
  /// In en, this message translates to:
  /// **'Re-initialize EBM'**
  String get reinitializeEbm;

  /// Tax service subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage tax service status'**
  String get manageTaxServiceStatus;

  /// Admin action to re-download all local data
  ///
  /// In en, this message translates to:
  /// **'Hydrate Data'**
  String get hydrateData;

  /// Hydrate data subtitle
  ///
  /// In en, this message translates to:
  /// **'Refresh all local data'**
  String get refreshAllLocalData;

  /// Admin toggle for downloading product images
  ///
  /// In en, this message translates to:
  /// **'Asset Download'**
  String get assetDownload;

  /// Asset download subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage image downloads'**
  String get manageImageDownloads;

  /// Admin toggle title
  ///
  /// In en, this message translates to:
  /// **'Auto-Add Search'**
  String get autoAddSearch;

  /// Auto-add search subtitle
  ///
  /// In en, this message translates to:
  /// **'Auto-add items when 1 match'**
  String get autoAddItemsWhenOneMatch;

  /// Admin toggle title
  ///
  /// In en, this message translates to:
  /// **'User Logging'**
  String get userLogging;

  /// User logging subtitle
  ///
  /// In en, this message translates to:
  /// **'Enable extensive user logging'**
  String get enableExtensiveUserLogging;

  /// Short admin toggle title for price/quantity adjustment
  ///
  /// In en, this message translates to:
  /// **'Price-Qty Adj'**
  String get priceQtyAdjustment;

  /// Price-quantity adjustment subtitle
  ///
  /// In en, this message translates to:
  /// **'Auto-adjust qty on price change'**
  String get autoAdjustQtyOnPriceChange;

  /// Admin toggle title for fractional pricing
  ///
  /// In en, this message translates to:
  /// **'Decimals'**
  String get decimals;

  /// Decimals subtitle
  ///
  /// In en, this message translates to:
  /// **'Enable fractional pricing'**
  String get enableFractionalPricing;

  /// Admin toggle title
  ///
  /// In en, this message translates to:
  /// **'Ticket Review + Handover'**
  String get ticketReviewAndHandover;

  /// Admin security section title
  ///
  /// In en, this message translates to:
  /// **'Administrator PIN'**
  String get administratorPin;

  /// Admin security action
  ///
  /// In en, this message translates to:
  /// **'Reset Administrator PIN'**
  String get resetAdministratorPin;

  /// Reset administrator PIN subtitle
  ///
  /// In en, this message translates to:
  /// **'Update your high-security 4-digit PIN'**
  String get updateHighSecurityPin;

  /// Title of the settings screen
  ///
  /// In en, this message translates to:
  /// **'Flipper Settings'**
  String get flipperSettingsTitle;

  /// Settings section header
  ///
  /// In en, this message translates to:
  /// **'Common'**
  String get common;

  /// Settings row showing which backend the app talks to
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get environment;

  /// Value of the environment setting
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get local;

  /// Settings section header
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Settings row for the account email
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Settings section header
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// Settings toggle for the daily report email
  ///
  /// In en, this message translates to:
  /// **'Send daily report'**
  String get sendDailyReport;

  /// Drawer setting title
  ///
  /// In en, this message translates to:
  /// **'Online Print'**
  String get onlinePrint;

  /// Online print subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage print settings'**
  String get managePrintSettings;

  /// User logging subtitle in the drawer
  ///
  /// In en, this message translates to:
  /// **'Enable extensive logging'**
  String get enableExtensiveLogging;

  /// Drawer setting title
  ///
  /// In en, this message translates to:
  /// **'Background Sync'**
  String get backgroundSync;

  /// Background sync subtitle
  ///
  /// In en, this message translates to:
  /// **'Sync data in background'**
  String get syncDataInBackground;

  /// Ends the current cashier shift
  ///
  /// In en, this message translates to:
  /// **'Close Shift'**
  String get closeShift;

  /// Begins a new cashier shift
  ///
  /// In en, this message translates to:
  /// **'Start New Shift'**
  String get startNewShift;

  /// Re-checks the business subscription status
  ///
  /// In en, this message translates to:
  /// **'Check subscription'**
  String get checkSubscription;

  /// Shown when the subscription check fails
  ///
  /// In en, this message translates to:
  /// **'Could not check subscription: {error}'**
  String couldNotCheckSubscription(String error);

  /// Title of the default app chooser
  ///
  /// In en, this message translates to:
  /// **'Choose Your Default App'**
  String get chooseYourDefaultApp;

  /// Menu entry opening account settings
  ///
  /// In en, this message translates to:
  /// **'Account settings'**
  String get accountSettings;

  /// Menu entry for signing in as someone else
  ///
  /// In en, this message translates to:
  /// **'Switch account'**
  String get switchAccount;

  /// Confirms the branch the user is entering
  ///
  /// In en, this message translates to:
  /// **'Continue to {branchName}'**
  String continueToBranch(String branchName);

  /// Starts a cashier shift
  ///
  /// In en, this message translates to:
  /// **'Open Shift'**
  String get openShift;

  /// Shown while the subscription payment check runs
  ///
  /// In en, this message translates to:
  /// **'Checking payment status…'**
  String get checkingPaymentStatus;

  /// Subtitle of the check subscription row
  ///
  /// In en, this message translates to:
  /// **'Refresh after customer pays'**
  String get refreshAfterCustomerPays;

  /// Generic word for a branch, used as a fallback when the branch name is unknown
  ///
  /// In en, this message translates to:
  /// **'branch'**
  String get branch;

  /// Inventory summary card title
  ///
  /// In en, this message translates to:
  /// **'Total Items'**
  String get totalItems;

  /// Inventory summary card title
  ///
  /// In en, this message translates to:
  /// **'Expired Items'**
  String get expiredItems;

  /// Inventory summary card title
  ///
  /// In en, this message translates to:
  /// **'Low Stock Items'**
  String get lowStockItems;

  /// Inventory summary card title
  ///
  /// In en, this message translates to:
  /// **'Pending Orders'**
  String get pendingOrders;

  /// Opens the full list
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Table column header for a record identifier
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get idLabel;

  /// Table column header
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// Table column header
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Table column header
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// Table column header
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Table column header for the expiry date
  ///
  /// In en, this message translates to:
  /// **'Expired On'**
  String get expiredOn;

  /// Table column header for row actions
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// Dialog title listing every expired item
  ///
  /// In en, this message translates to:
  /// **'All Expired Items'**
  String get allExpiredItems;

  /// Confirms leaving the checkout screen
  ///
  /// In en, this message translates to:
  /// **'Do you want to go home?'**
  String get goHomeQuestion;

  /// POS search field placeholder
  ///
  /// In en, this message translates to:
  /// **'Search products or scan…'**
  String get searchProductsOrScan;

  /// Clears the current input
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Tooltip for adding a single product
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get addProductAction;

  /// Opens help for the current screen
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// Customers screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Customer management'**
  String get customerManagement;

  /// Customer search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search customers by name or phone'**
  String get searchCustomersByNameOrPhone;

  /// Clears the search field
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// Generic add action
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Tooltip for editing a customer
  ///
  /// In en, this message translates to:
  /// **'Edit customer'**
  String get editCustomer;

  /// Tooltip for deleting a customer
  ///
  /// In en, this message translates to:
  /// **'Delete customer'**
  String get deleteCustomer;

  /// Semantic label for the customer row actions
  ///
  /// In en, this message translates to:
  /// **'Customer actions'**
  String get customerActions;

  /// Table column header for a phone number
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Taxpayer Identification Number, kept as an acronym
  ///
  /// In en, this message translates to:
  /// **'TIN'**
  String get tin;

  /// Label above the invoice number in checkout
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// Short label above the transaction identifier
  ///
  /// In en, this message translates to:
  /// **'Txn ID'**
  String get txnId;

  /// Tooltip for attaching a customer to the sale
  ///
  /// In en, this message translates to:
  /// **'Add customer'**
  String get addCustomer;

  /// Catalog sort option
  ///
  /// In en, this message translates to:
  /// **'Default sorting'**
  String get sortDefault;

  /// Catalog sort option
  ///
  /// In en, this message translates to:
  /// **'Sort by popularity'**
  String get sortByPopularity;

  /// Catalog sort option
  ///
  /// In en, this message translates to:
  /// **'Sort by average rating'**
  String get sortByAverageRating;

  /// Catalog sort option
  ///
  /// In en, this message translates to:
  /// **'Sort by latest'**
  String get sortByLatest;

  /// Catalog sort option
  ///
  /// In en, this message translates to:
  /// **'Sort by price: low to high'**
  String get sortByPriceLowToHigh;

  /// Catalog sort option
  ///
  /// In en, this message translates to:
  /// **'Sort by price: high to low'**
  String get sortByPriceHighToLow;

  /// Catalog sort option, lowest stock first
  ///
  /// In en, this message translates to:
  /// **'Sort by stock out'**
  String get sortByStockOut;

  /// Catalog sort option
  ///
  /// In en, this message translates to:
  /// **'Sort by event date: Old to New'**
  String get sortByEventDateOldToNew;

  /// Catalog sort option
  ///
  /// In en, this message translates to:
  /// **'Sort by event date: New to Old'**
  String get sortByEventDateNewToOld;

  /// Compact sort chip label
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get sortCompactLatest;

  /// Compact sort chip label
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get sortCompactDefault;

  /// Compact sort chip label
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get sortCompactPopular;

  /// Compact sort chip label
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get sortCompactRating;

  /// Compact sort chip label, paired with an arrow
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get sortCompactPrice;

  /// Compact sort chip label
  ///
  /// In en, this message translates to:
  /// **'Stock out'**
  String get sortCompactStockOut;

  /// Compact sort chip label, paired with an arrow
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get sortCompactDate;

  /// Pagination summary above the product grid
  ///
  /// In en, this message translates to:
  /// **'Showing {start}–{end} of {total} results'**
  String showingRangeOfResults(String start, String end, String total);

  /// Pagination footer
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String pageOfPages(String current, String total);

  /// Progress while the catalog loads
  ///
  /// In en, this message translates to:
  /// **'{loaded} of {total} products'**
  String loadedOfProducts(String loaded, String total);

  /// Empty catalog state
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get noProductsYet;

  /// Shown when no branch is active
  ///
  /// In en, this message translates to:
  /// **'No branch selected'**
  String get noBranchSelected;

  /// Confirms the catalog reloaded after a branch switch
  ///
  /// In en, this message translates to:
  /// **'Products refreshed for new branch'**
  String get productsRefreshedForNewBranch;

  /// Confirms a bulk delete
  ///
  /// In en, this message translates to:
  /// **'Deleted {count} items'**
  String deletedItemsCount(int count);

  /// Stock line on a product card
  ///
  /// In en, this message translates to:
  /// **'{count} in stock'**
  String inStockCount(String count);

  /// Remaining stock hint on a cart line
  ///
  /// In en, this message translates to:
  /// **'{count} left in stock'**
  String leftInStockCount(String count);

  /// Badge on a product card with little stock left
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get stockLow;

  /// Badge on a product card with no stock
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get stockOutBadge;

  /// Label of the Sale/Transfer toggle
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// Sale mode in the checkout toggle
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get sale;

  /// Stock transfer mode in the checkout toggle
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// Customer search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search Customer'**
  String get searchCustomer;

  /// Completes the sale
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// Empty cart state
  ///
  /// In en, this message translates to:
  /// **'No items yet'**
  String get noItemsYet;

  /// Empty cart hint
  ///
  /// In en, this message translates to:
  /// **'Tap a product to start a sale'**
  String get tapProductToStartSale;

  /// Cart footer total
  ///
  /// In en, this message translates to:
  /// **'Grand Total · {itemLabel}'**
  String grandTotalWithItems(String itemLabel);

  /// Marks a cart line using the unmodified price
  ///
  /// In en, this message translates to:
  /// **'Default price'**
  String get defaultPrice;

  /// Per-unit price on a cart line
  ///
  /// In en, this message translates to:
  /// **'{currency} {price} each'**
  String pricePerUnitEach(String currency, String price);

  /// Tooltip on a cart line delete button
  ///
  /// In en, this message translates to:
  /// **'Delete item'**
  String get deleteItem;

  /// Opens the cart line editor
  ///
  /// In en, this message translates to:
  /// **'Edit details'**
  String get editDetails;

  /// Quantity field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter quantity'**
  String get enterQuantity;

  /// Quantity validation error
  ///
  /// In en, this message translates to:
  /// **'Invalid quantity'**
  String get invalidQuantity;

  /// Price field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get enterPrice;

  /// Price validation error
  ///
  /// In en, this message translates to:
  /// **'Invalid price'**
  String get invalidPrice;

  /// Delete confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// Delete confirmation body for one cart line
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove \"{itemName}\"?'**
  String confirmRemoveNamedItem(String itemName);

  /// Bulk delete failure
  ///
  /// In en, this message translates to:
  /// **'Error deleting items: {error}'**
  String errorDeletingItems(String error);

  /// Single delete failure
  ///
  /// In en, this message translates to:
  /// **'Error deleting item: {error}'**
  String errorDeletingItem(String error);

  /// Single delete failure toast
  ///
  /// In en, this message translates to:
  /// **'Failed to delete item'**
  String get failedToDeleteItem;

  /// Cart line update failure
  ///
  /// In en, this message translates to:
  /// **'Failed to update item'**
  String get failedToUpdateItem;

  /// Stock keeping unit shown under a cart line
  ///
  /// In en, this message translates to:
  /// **'SKU: {sku}'**
  String skuLabel(String sku);

  /// Barcode shown under a product or cart line
  ///
  /// In en, this message translates to:
  /// **'BCD: {barcode}'**
  String bcdLabel(String barcode);

  /// Splits the payment across several methods
  ///
  /// In en, this message translates to:
  /// **'Split'**
  String get split;

  /// Tooltip on the split button
  ///
  /// In en, this message translates to:
  /// **'Split this payment across another method'**
  String get splitAcrossAnotherMethod;

  /// Shown when every payment method is already on the sale
  ///
  /// In en, this message translates to:
  /// **'All payment types are in use — remove one to add another'**
  String get allPaymentTypesInUse;

  /// Blocks adding a further payment method
  ///
  /// In en, this message translates to:
  /// **'All payment types are already added. Remove one to add another.'**
  String get allPaymentTypesAdded;

  /// Payment amount validation
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get pleaseEnterAnAmount;

  /// Label of the tendered-cash field
  ///
  /// In en, this message translates to:
  /// **'Cash received'**
  String get cashReceived;

  /// Generic amount field label
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Tooltip on a payment row remove button
  ///
  /// In en, this message translates to:
  /// **'Remove this payment'**
  String get removeThisPayment;

  /// Hint under the payments list
  ///
  /// In en, this message translates to:
  /// **'Tap Split to pay with more than one method'**
  String get tapSplitToPayWithMoreThanOneMethod;

  /// Compact hint under the payments list
  ///
  /// In en, this message translates to:
  /// **'Tap Split to add a method'**
  String get tapSplitToAddMethod;

  /// Invoice number shown in the checkout header
  ///
  /// In en, this message translates to:
  /// **'No. {number}'**
  String invoiceNumberValue(String number);

  /// Cash handed over by the customer
  ///
  /// In en, this message translates to:
  /// **'Tendered {amount}'**
  String tenderedAmount(String amount);

  /// Confirms a till collection
  ///
  /// In en, this message translates to:
  /// **'Payment collected · {total}'**
  String paymentCollectedTotal(String total);

  /// Blocks a transfer for view-only roles
  ///
  /// In en, this message translates to:
  /// **'View-only access — you cannot transfer stock.'**
  String get viewOnlyCannotTransferStock;

  /// Transfer validation
  ///
  /// In en, this message translates to:
  /// **'Select a destination branch'**
  String get selectDestinationBranch;

  /// Transfer validation
  ///
  /// In en, this message translates to:
  /// **'Current branch is missing'**
  String get currentBranchIsMissing;

  /// Transfer validation
  ///
  /// In en, this message translates to:
  /// **'Add items before transferring'**
  String get addItemsBeforeTransferring;

  /// Confirms an outgoing branch transfer
  ///
  /// In en, this message translates to:
  /// **'Transferred {count} item(s) to {branch}'**
  String transferredItemsToBranch(int count, String branch);

  /// Outgoing transfer failure toast
  ///
  /// In en, this message translates to:
  /// **'Transfer failed'**
  String get transferFailed;

  /// Cart reset failure toast
  ///
  /// In en, this message translates to:
  /// **'Failed to clear cart'**
  String get failedToClearCart;

  /// Explains the till workflow to staff without collect rights
  ///
  /// In en, this message translates to:
  /// **'Payments are collected at the till. Send this order once it\'s ready — a manager will collect payment.'**
  String get paymentsCollectedAtTill;

  /// Confirms a park-to-till
  ///
  /// In en, this message translates to:
  /// **'Sent to till — Ticket #{reference}'**
  String sentToTillTicket(String reference);

  /// Park-to-till failure
  ///
  /// In en, this message translates to:
  /// **'Failed to send to till: {error}'**
  String failedToSendToTill(String error);

  /// Banner shown while settling a colleague’s parked ticket
  ///
  /// In en, this message translates to:
  /// **'Collecting payment for #{reference} · sent by {name} · {minutes} min ago'**
  String collectingPaymentForTicket(
    String reference,
    String name,
    String minutes,
  );

  /// Shown while leaving the settling flow
  ///
  /// In en, this message translates to:
  /// **'Returning…'**
  String get returningEllipsis;

  /// Leaves the settling flow
  ///
  /// In en, this message translates to:
  /// **'Back to new sale'**
  String get backToNewSale;

  /// Payment method display name
  ///
  /// In en, this message translates to:
  /// **'Cash / Credit'**
  String get paymentCashCredit;

  /// Payment method display name
  ///
  /// In en, this message translates to:
  /// **'Bank check'**
  String get paymentBankCheck;

  /// Payment method display name
  ///
  /// In en, this message translates to:
  /// **'Debit & credit card'**
  String get paymentDebitCreditCard;

  /// Payment method display name
  ///
  /// In en, this message translates to:
  /// **'Mobile money'**
  String get paymentMobileMoney;

  /// Payment method display name, brand kept as-is
  ///
  /// In en, this message translates to:
  /// **'MTN MoMo'**
  String get paymentMtnMomo;

  /// Hint for the optional name on the MoMo/bank account that sent the money, when it differs from the customer on the sale
  ///
  /// In en, this message translates to:
  /// **'Payer name (optional)'**
  String get payerNameOptional;

  /// Label preceding the payer name on a transaction's payment line
  ///
  /// In en, this message translates to:
  /// **'Paid by'**
  String get paidBy;

  /// Payment method display name, brand kept as-is
  ///
  /// In en, this message translates to:
  /// **'Airtel Money'**
  String get paymentAirtelMoney;

  /// Payment method display name
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get paymentOther;

  /// Checkout button when ticket review is enabled
  ///
  /// In en, this message translates to:
  /// **'Send for Review'**
  String get sendForReview;

  /// Checkout button that opens the cart preview
  ///
  /// In en, this message translates to:
  /// **'Preview Cart'**
  String get previewCart;

  /// Cart preview button with the item count
  ///
  /// In en, this message translates to:
  /// **'Preview Cart ({count})'**
  String previewCartWithCount(int count);

  /// Submits an order in the ordering flow
  ///
  /// In en, this message translates to:
  /// **'Place order'**
  String get placeOrder;

  /// Bulk-remove confirmation naming the item count
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove all {count} items from this transaction?'**
  String confirmRemoveAllItemsCount(int count);
}

class _FlipperAppLocalizationsDelegate
    extends LocalizationsDelegate<FlipperAppLocalizations> {
  const _FlipperAppLocalizationsDelegate();

  @override
  Future<FlipperAppLocalizations> load(Locale locale) {
    return SynchronousFuture<FlipperAppLocalizations>(
      lookupFlipperAppLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr', 'rw', 'sw'].contains(locale.languageCode);

  @override
  bool shouldReload(_FlipperAppLocalizationsDelegate old) => false;
}

FlipperAppLocalizations lookupFlipperAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return FlipperAppLocalizationsEn();
    case 'fr':
      return FlipperAppLocalizationsFr();
    case 'rw':
      return FlipperAppLocalizationsRw();
    case 'sw':
      return FlipperAppLocalizationsSw();
  }

  throw FlutterError(
    'FlipperAppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
