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

  /// POS catalog stock filter option: only items with stock (the default)
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get posStockFilterInStock;

  /// POS catalog stock filter option: only items with no stock
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get posStockFilterOutOfStock;

  /// POS catalog stock filter option: every item, in stock or not
  ///
  /// In en, this message translates to:
  /// **'All items'**
  String get posStockFilterAll;

  /// POS catalog empty state when the in-stock filter hides every item
  ///
  /// In en, this message translates to:
  /// **'No items in stock'**
  String get posStockFilterNoneInStock;

  /// POS catalog empty state when the out-of-stock filter finds nothing
  ///
  /// In en, this message translates to:
  /// **'No out-of-stock items'**
  String get posStockFilterNoneOutOfStock;

  /// Hint under the POS catalog stock-filter empty state
  ///
  /// In en, this message translates to:
  /// **'Search to find any item, or change the stock filter.'**
  String get posStockFilterEmptyHint;

  /// Button on the POS catalog stock-filter empty state that switches to every item
  ///
  /// In en, this message translates to:
  /// **'Show all items'**
  String get posStockFilterShowAll;

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

  /// Desktop system-status strip when the EBM/RRA tax server does not answer
  ///
  /// In en, this message translates to:
  /// **'RRA tax server unreachable — receipts can\'t be signed until it is back. Rechecking automatically.'**
  String get taxServerUnreachableStatus;

  /// Desktop system-status strip when the device has no connectivity
  ///
  /// In en, this message translates to:
  /// **'No internet connection — sales keep working offline and sync when you\'re back online.'**
  String get internetUnavailableStatus;

  /// Cart summary line for tax already included in the prices
  ///
  /// In en, this message translates to:
  /// **'Includes VAT'**
  String get includesVat;

  /// Tooltip on the sidebar button that picks which app opens at launch
  ///
  /// In en, this message translates to:
  /// **'Choose default app'**
  String get chooseDefaultApp;

  /// Keyboard hint shown next to the payment section header
  ///
  /// In en, this message translates to:
  /// **'Ctrl / ⌘ + Enter to pay'**
  String get payShortcutHint;

  /// Small label above the amount-received field
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get receivedEyebrow;

  /// Desktop empty-cart hint
  ///
  /// In en, this message translates to:
  /// **'Tap a product or scan a barcode to start a sale'**
  String get cartEmptyHint;

  /// No description provided for @scannerAlignQrCode.
  ///
  /// In en, this message translates to:
  /// **'Align QR code within frame'**
  String get scannerAlignQrCode;

  /// No description provided for @scannerInstructionSelling.
  ///
  /// In en, this message translates to:
  /// **'Scan product barcode to add to cart'**
  String get scannerInstructionSelling;

  /// No description provided for @scannerInstructionAttendance.
  ///
  /// In en, this message translates to:
  /// **'Scan attendance QR code to check in'**
  String get scannerInstructionAttendance;

  /// No description provided for @scannerInstructionLogin.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code to log in to your account'**
  String get scannerInstructionLogin;

  /// No description provided for @scannerScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scannerScanning;

  /// No description provided for @scannerStatusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get scannerStatusProcessing;

  /// No description provided for @scannerSendingLoginToDesktop.
  ///
  /// In en, this message translates to:
  /// **'Sending login to desktop...'**
  String get scannerSendingLoginToDesktop;

  /// No description provided for @scannerWaitingForDesktop.
  ///
  /// In en, this message translates to:
  /// **'Waiting for desktop'**
  String get scannerWaitingForDesktop;

  /// No description provided for @scannerLoginSentCompleting.
  ///
  /// In en, this message translates to:
  /// **'Login sent — completing on your computer...'**
  String get scannerLoginSentCompleting;

  /// No description provided for @scannerScanSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Scan Successful'**
  String get scannerScanSuccessful;

  /// No description provided for @scannerQrProcessedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'QR code processed successfully'**
  String get scannerQrProcessedSuccessfully;

  /// No description provided for @scannerLoginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login Successful'**
  String get scannerLoginSuccessful;

  /// No description provided for @scannerDesktopAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'Desktop device authenticated'**
  String get scannerDesktopAuthenticated;

  /// No description provided for @scannerLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get scannerLoginFailed;

  /// No description provided for @scannerCouldNotAuthenticateDesktop.
  ///
  /// In en, this message translates to:
  /// **'Could not authenticate desktop device'**
  String get scannerCouldNotAuthenticateDesktop;

  /// No description provided for @scannerQrCodeDetected.
  ///
  /// In en, this message translates to:
  /// **'QR Code Detected'**
  String get scannerQrCodeDetected;

  /// No description provided for @scannerProcessingRequest.
  ///
  /// In en, this message translates to:
  /// **'Processing your request...'**
  String get scannerProcessingRequest;

  /// No description provided for @scannerHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Scanner Help'**
  String get scannerHelpTitle;

  /// No description provided for @scannerHelpPositionCode.
  ///
  /// In en, this message translates to:
  /// **'Position the code within the frame'**
  String get scannerHelpPositionCode;

  /// No description provided for @scannerHelpWellLit.
  ///
  /// In en, this message translates to:
  /// **'Make sure it\'s well-lit and not blurry'**
  String get scannerHelpWellLit;

  /// No description provided for @scannerHelpUseFlash.
  ///
  /// In en, this message translates to:
  /// **'Use flash in low light'**
  String get scannerHelpUseFlash;

  /// No description provided for @scannerHelpToggleFlash.
  ///
  /// In en, this message translates to:
  /// **'Toggle the flash icon at the bottom'**
  String get scannerHelpToggleFlash;

  /// No description provided for @scannerHelpCleanLens.
  ///
  /// In en, this message translates to:
  /// **'Clean your camera lens'**
  String get scannerHelpCleanLens;

  /// No description provided for @scannerHelpBetterResults.
  ///
  /// In en, this message translates to:
  /// **'For better scanning results'**
  String get scannerHelpBetterResults;

  /// No description provided for @scannerTitleProduct.
  ///
  /// In en, this message translates to:
  /// **'Product Scanner'**
  String get scannerTitleProduct;

  /// No description provided for @scannerTitleAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance Scanner'**
  String get scannerTitleAttendance;

  /// No description provided for @scannerTitleLogin.
  ///
  /// In en, this message translates to:
  /// **'Login Scanner'**
  String get scannerTitleLogin;

  /// No description provided for @scannerTitleQr.
  ///
  /// In en, this message translates to:
  /// **'QR Scanner'**
  String get scannerTitleQr;

  /// No description provided for @scannerGalleryComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Gallery selection coming soon'**
  String get scannerGalleryComingSoon;

  /// No description provided for @scannerInvalidQrFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid QR code format'**
  String get scannerInvalidQrFormat;

  /// No description provided for @scannerLoginError.
  ///
  /// In en, this message translates to:
  /// **'Login error: {error}'**
  String scannerLoginError(String error);

  /// No description provided for @scannerDesktopNoResponse.
  ///
  /// In en, this message translates to:
  /// **'Desktop did not respond — check it is on the QR login screen'**
  String get scannerDesktopNoResponse;

  /// No description provided for @scannerDesktopSelectBusiness.
  ///
  /// In en, this message translates to:
  /// **'Desktop logged in — select your business there'**
  String get scannerDesktopSelectBusiness;

  /// No description provided for @scannerDesktopLoginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Desktop login successful'**
  String get scannerDesktopLoginSuccessful;

  /// No description provided for @scannerDesktopLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Desktop login failed'**
  String get scannerDesktopLoginFailed;

  /// No description provided for @dialogGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get dialogGotIt;

  /// No description provided for @socialsRequestEarlyAccess.
  ///
  /// In en, this message translates to:
  /// **'Request Early Access'**
  String get socialsRequestEarlyAccess;

  /// No description provided for @socialsEarlyAccessHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email, phone number and a message why you want to join!'**
  String get socialsEarlyAccessHint;

  /// No description provided for @socialsPleaseEnterMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter a message'**
  String get socialsPleaseEnterMessage;

  /// No description provided for @socialsThanksForInterest.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your interest'**
  String get socialsThanksForInterest;

  /// No description provided for @socialsThanksWeWillGetBack.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your interest, we will get back to you soon'**
  String get socialsThanksWeWillGetBack;

  /// No description provided for @socialsExpressInterest.
  ///
  /// In en, this message translates to:
  /// **'Express interest'**
  String get socialsExpressInterest;

  /// No description provided for @appInitStepFirebase.
  ///
  /// In en, this message translates to:
  /// **'Connecting services'**
  String get appInitStepFirebase;

  /// No description provided for @appInitStepLocator.
  ///
  /// In en, this message translates to:
  /// **'Preparing app'**
  String get appInitStepLocator;

  /// No description provided for @appInitStepPlatform.
  ///
  /// In en, this message translates to:
  /// **'Setting up device'**
  String get appInitStepPlatform;

  /// No description provided for @appInitStepDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Setting up diagnostics'**
  String get appInitStepDiagnostics;

  /// No description provided for @appInitStepDatabase.
  ///
  /// In en, this message translates to:
  /// **'Opening local database'**
  String get appInitStepDatabase;

  /// No description provided for @appInitStepServices.
  ///
  /// In en, this message translates to:
  /// **'Loading services'**
  String get appInitStepServices;

  /// No description provided for @appInitStepAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Starting analytics'**
  String get appInitStepAnalytics;

  /// No description provided for @appInitStepCloudStorage.
  ///
  /// In en, this message translates to:
  /// **'Connecting cloud storage'**
  String get appInitStepCloudStorage;

  /// No description provided for @appInitStepSync.
  ///
  /// In en, this message translates to:
  /// **'Preparing sync'**
  String get appInitStepSync;

  /// No description provided for @appInitStepFinishing.
  ///
  /// In en, this message translates to:
  /// **'Finishing up'**
  String get appInitStepFinishing;

  /// No description provided for @appInitStepStartup.
  ///
  /// In en, this message translates to:
  /// **'Startup'**
  String get appInitStepStartup;

  /// No description provided for @appInitFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Initialization Failed'**
  String get appInitFailedTitle;

  /// No description provided for @appInitFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'The app could not finish starting at \"{step}\". Tap Try again — it will resume from that step.'**
  String appInitFailedMessage(String step);

  /// No description provided for @appInitTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get appInitTryAgain;

  /// No description provided for @appInitCopyErrorDetails.
  ///
  /// In en, this message translates to:
  /// **'Copy error details'**
  String get appInitCopyErrorDetails;

  /// No description provided for @appInitTechnicalDetails.
  ///
  /// In en, this message translates to:
  /// **'Technical details'**
  String get appInitTechnicalDetails;

  /// No description provided for @paywallRailMobileMoney.
  ///
  /// In en, this message translates to:
  /// **'Mobile Money'**
  String get paywallRailMobileMoney;

  /// No description provided for @paywallRailCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get paywallRailCard;

  /// No description provided for @paywallRailMomoDescription.
  ///
  /// In en, this message translates to:
  /// **'Approve on your phone with MTN MoMo'**
  String get paywallRailMomoDescription;

  /// No description provided for @paywallRailCardDescription.
  ///
  /// In en, this message translates to:
  /// **'Pay by Visa or Mastercard'**
  String get paywallRailCardDescription;

  /// No description provided for @paywallCadenceDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get paywallCadenceDaily;

  /// No description provided for @paywallCadenceMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get paywallCadenceMonthly;

  /// No description provided for @paywallCadenceYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get paywallCadenceYearly;

  /// No description provided for @paywallPeriodDay.
  ///
  /// In en, this message translates to:
  /// **'/day'**
  String get paywallPeriodDay;

  /// No description provided for @paywallPeriodMonth.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get paywallPeriodMonth;

  /// No description provided for @paywallPeriodYear.
  ///
  /// In en, this message translates to:
  /// **'/year'**
  String get paywallPeriodYear;

  /// No description provided for @paywallPaidInFull.
  ///
  /// In en, this message translates to:
  /// **'Paid in full — one charge of RWF {amount}.'**
  String paywallPaidInFull(String amount);

  /// No description provided for @paywallInstallmentsEach.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 payment of RWF {amount}.} other{{count} payments of RWF {amount} each.}}'**
  String paywallInstallmentsEach(int count, String amount);

  /// No description provided for @paywallPricePerMonthBilledYearly.
  ///
  /// In en, this message translates to:
  /// **'{amount} RWF/mo · billed yearly'**
  String paywallPricePerMonthBilledYearly(String amount);

  /// No description provided for @paywallPricePerDay.
  ///
  /// In en, this message translates to:
  /// **'{amount} RWF/day'**
  String paywallPricePerDay(String amount);

  /// No description provided for @paywallPricePerMonth.
  ///
  /// In en, this message translates to:
  /// **'{amount} RWF/month'**
  String paywallPricePerMonth(String amount);

  /// No description provided for @paywallCardPayment.
  ///
  /// In en, this message translates to:
  /// **'Card Payment'**
  String get paywallCardPayment;

  /// No description provided for @paywallTestMode.
  ///
  /// In en, this message translates to:
  /// **'TEST MODE'**
  String get paywallTestMode;

  /// No description provided for @paywallCardRedirectInfo.
  ///
  /// In en, this message translates to:
  /// **'You will be taken to a secure payment page to enter your Visa or Mastercard details. Come back here once you are done — the plan activates on its own.'**
  String get paywallCardRedirectInfo;

  /// No description provided for @paywallReceiptEmail.
  ///
  /// In en, this message translates to:
  /// **'Email for the receipt'**
  String get paywallReceiptEmail;

  /// No description provided for @paywallReceiptEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Invoices and card receipts are sent here.'**
  String get paywallReceiptEmailHint;

  /// No description provided for @paywallCardDiscountApplies.
  ///
  /// In en, this message translates to:
  /// **'Your discount applies to card payments: the card is charged the discounted price now and at each renewal.'**
  String get paywallCardDiscountApplies;

  /// No description provided for @paywallCardDiscountAppliesAmount.
  ///
  /// In en, this message translates to:
  /// **'Your discount applies: the card is charged {amount} now and at each renewal.'**
  String paywallCardDiscountAppliesAmount(String amount);

  /// No description provided for @paywallDiscountMomoOnly.
  ///
  /// In en, this message translates to:
  /// **'Discount codes apply to Mobile Money payments only. Paying by card charges the full plan price.'**
  String get paywallDiscountMomoOnly;

  /// No description provided for @paywallPendingCheckout.
  ///
  /// In en, this message translates to:
  /// **'A payment page is already waiting for this plan. Open it to finish — a new one would not replace it.'**
  String get paywallPendingCheckout;

  /// No description provided for @paywallOpenPaymentPage.
  ///
  /// In en, this message translates to:
  /// **'Open payment page'**
  String get paywallOpenPaymentPage;

  /// No description provided for @paywallDiscountHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the code exactly as it appears.'**
  String get paywallDiscountHint;

  /// No description provided for @paywallNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'Need Help?'**
  String get paywallNeedHelp;

  /// No description provided for @paywallChatWithSupport.
  ///
  /// In en, this message translates to:
  /// **'Chat with support about this payment'**
  String get paywallChatWithSupport;

  /// No description provided for @paywallMomoPayment.
  ///
  /// In en, this message translates to:
  /// **'Mobile Money Payment'**
  String get paywallMomoPayment;

  /// No description provided for @paywallProcessedUsing.
  ///
  /// In en, this message translates to:
  /// **'Payment will be processed using {provider}.'**
  String paywallProcessedUsing(String provider);

  /// No description provided for @paywallUseDifferentNumber.
  ///
  /// In en, this message translates to:
  /// **'Use different phone number'**
  String get paywallUseDifferentNumber;

  /// No description provided for @paywallTryAnotherNumber.
  ///
  /// In en, this message translates to:
  /// **'Try another MTN number if the current one failed'**
  String get paywallTryAnotherNumber;

  /// No description provided for @paywallMomoNumberRule.
  ///
  /// In en, this message translates to:
  /// **'Must start with 250 78 or 250 79.'**
  String get paywallMomoNumberRule;

  /// No description provided for @paywallProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing…'**
  String get paywallProcessing;

  /// No description provided for @paywallSecurePaymentVia.
  ///
  /// In en, this message translates to:
  /// **'Secure payment via {provider}'**
  String paywallSecurePaymentVia(String provider);

  /// No description provided for @paywallHowToPay.
  ///
  /// In en, this message translates to:
  /// **'How would you like to pay?'**
  String get paywallHowToPay;

  /// No description provided for @paywallLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get paywallLoading;

  /// No description provided for @paywallPercentOff.
  ///
  /// In en, this message translates to:
  /// **'({percent}% off)'**
  String paywallPercentOff(String percent);

  /// No description provided for @paywallSplitIntoPayments.
  ///
  /// In en, this message translates to:
  /// **'Split into payments'**
  String get paywallSplitIntoPayments;

  /// No description provided for @paywallPaymentSummary.
  ///
  /// In en, this message translates to:
  /// **'Payment Summary'**
  String get paywallPaymentSummary;

  /// No description provided for @paywallTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get paywallTotal;

  /// No description provided for @paywallSubscriptionEnded.
  ///
  /// In en, this message translates to:
  /// **'This subscription has ended. Choose a plan to start again.'**
  String get paywallSubscriptionEnded;

  /// No description provided for @paywallPaymentPageNotReady.
  ///
  /// In en, this message translates to:
  /// **'The payment page is not ready yet. Try again in a moment.'**
  String get paywallPaymentPageNotReady;

  /// No description provided for @paywallCouldNotOpenPageCopyLink.
  ///
  /// In en, this message translates to:
  /// **'Could not open the payment page on this device. Copy the link, or pay with Mobile Money instead.'**
  String get paywallCouldNotOpenPageCopyLink;

  /// No description provided for @paywallCouldNotOpenPage.
  ///
  /// In en, this message translates to:
  /// **'Could not open the payment page on this device.'**
  String get paywallCouldNotOpenPage;

  /// No description provided for @paywallServiceNoResponse.
  ///
  /// In en, this message translates to:
  /// **'The payments service did not respond. Check your connection and try again.'**
  String get paywallServiceNoResponse;

  /// No description provided for @paywallServiceUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the payments service. Check your connection and try again.'**
  String get paywallServiceUnreachable;

  /// No description provided for @paywallBusinessRequiredForCard.
  ///
  /// In en, this message translates to:
  /// **'A business is required to start a card subscription.'**
  String get paywallBusinessRequiredForCard;

  /// No description provided for @paywallCardStartedNoReference.
  ///
  /// In en, this message translates to:
  /// **'The card subscription started but the connector sent no reference. Check the billing screen before trying again.'**
  String get paywallCardStartedNoReference;

  /// No description provided for @paywallNoCardUpdateLink.
  ///
  /// In en, this message translates to:
  /// **'The connector did not return a link to update the card.'**
  String get paywallNoCardUpdateLink;

  /// No description provided for @paywallNoPortalLink.
  ///
  /// In en, this message translates to:
  /// **'The connector did not return a billing portal link.'**
  String get paywallNoPortalLink;

  /// No description provided for @paywallCardNotAuthorised.
  ///
  /// In en, this message translates to:
  /// **'Card payment is not authorised on this connector.'**
  String get paywallCardNotAuthorised;

  /// No description provided for @paywallCardUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Card payment is not available right now. Use Mobile Money, or try again later.'**
  String get paywallCardUnavailable;

  /// No description provided for @paywallCouldNotAction.
  ///
  /// In en, this message translates to:
  /// **'Could not {action} (HTTP {status}).'**
  String paywallCouldNotAction(String action, String status);

  /// No description provided for @paywallUnreadableReply.
  ///
  /// In en, this message translates to:
  /// **'The billing service sent an unreadable reply (HTTP {status}).'**
  String paywallUnreadableReply(String status);

  /// No description provided for @paywallActionStartCardSubscription.
  ///
  /// In en, this message translates to:
  /// **'start a card subscription'**
  String get paywallActionStartCardSubscription;

  /// No description provided for @paywallActionReadCardSubscription.
  ///
  /// In en, this message translates to:
  /// **'read the card subscription'**
  String get paywallActionReadCardSubscription;

  /// No description provided for @paywallActionRefreshCardSubscription.
  ///
  /// In en, this message translates to:
  /// **'refresh the card subscription'**
  String get paywallActionRefreshCardSubscription;

  /// No description provided for @paywallActionGetCardLink.
  ///
  /// In en, this message translates to:
  /// **'get a new card link'**
  String get paywallActionGetCardLink;

  /// No description provided for @paywallActionOpenBillingPortal.
  ///
  /// In en, this message translates to:
  /// **'open the billing portal'**
  String get paywallActionOpenBillingPortal;

  /// No description provided for @paywallActionCancelCardSubscription.
  ///
  /// In en, this message translates to:
  /// **'cancel the card subscription'**
  String get paywallActionCancelCardSubscription;

  /// No description provided for @paywallActionStartCustomPayment.
  ///
  /// In en, this message translates to:
  /// **'start the custom payment'**
  String get paywallActionStartCustomPayment;

  /// No description provided for @paywallActionReadCustomPayment.
  ///
  /// In en, this message translates to:
  /// **'read the custom payment'**
  String get paywallActionReadCustomPayment;

  /// No description provided for @paywallActionListCustomPayments.
  ///
  /// In en, this message translates to:
  /// **'list custom payments'**
  String get paywallActionListCustomPayments;

  /// No description provided for @paywallEnterAmountAboveZero.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than zero.'**
  String get paywallEnterAmountAboveZero;

  /// No description provided for @paywallEnterValidMomoNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid Mobile Money number, e.g. 0788123456.'**
  String get paywallEnterValidMomoNumber;

  /// No description provided for @paywallPaymentNotStarted.
  ///
  /// In en, this message translates to:
  /// **'The payment could not be started (HTTP {status}).'**
  String paywallPaymentNotStarted(String status);

  /// No description provided for @paywallGatewayUnreadable.
  ///
  /// In en, this message translates to:
  /// **'The payment gateway sent an unreadable reply (HTTP {status}).'**
  String paywallGatewayUnreadable(String status);

  /// No description provided for @paywallStartedNoReference.
  ///
  /// In en, this message translates to:
  /// **'The payment started but no reference came back — check the MoMo statement before trying again.'**
  String get paywallStartedNoReference;

  /// No description provided for @paywallPreApprovalFailed.
  ///
  /// In en, this message translates to:
  /// **'Pre-approval failed (HTTP {status}).'**
  String paywallPreApprovalFailed(String status);

  /// No description provided for @paywallRequestRejected.
  ///
  /// In en, this message translates to:
  /// **'The payment request was rejected.'**
  String get paywallRequestRejected;

  /// No description provided for @paywallDeviceNotAuthorised.
  ///
  /// In en, this message translates to:
  /// **'This device is not authorised to take payments.'**
  String get paywallDeviceNotAuthorised;

  /// No description provided for @paywallServiceNotFound.
  ///
  /// In en, this message translates to:
  /// **'The payment service could not be found.'**
  String get paywallServiceNotFound;

  /// No description provided for @paywallAlreadySubmitted.
  ///
  /// In en, this message translates to:
  /// **'That payment has already been submitted.'**
  String get paywallAlreadySubmitted;

  /// No description provided for @paywallMomoUnavailableNow.
  ///
  /// In en, this message translates to:
  /// **'Mobile Money is unavailable right now. Please try again shortly.'**
  String get paywallMomoUnavailableNow;

  /// No description provided for @paywallMomoNotSetUp.
  ///
  /// In en, this message translates to:
  /// **'Mobile Money is not set up on this device yet.'**
  String get paywallMomoNotSetUp;

  /// No description provided for @paywallNotCompletedOnPhone.
  ///
  /// In en, this message translates to:
  /// **'The payment was not completed on the payer\'s phone.'**
  String get paywallNotCompletedOnPhone;

  /// No description provided for @paywallNoConfirmationYet.
  ///
  /// In en, this message translates to:
  /// **'No confirmation yet. The payment may still go through — check the MoMo statement before charging again.'**
  String get paywallNoConfirmationYet;

  /// No description provided for @paywallConsentDeclined.
  ///
  /// In en, this message translates to:
  /// **'Mobile Money consent was declined, so nothing was charged. Approve the request on your phone and try again.'**
  String get paywallConsentDeclined;

  /// No description provided for @paywallChooseBusinessFirst.
  ///
  /// In en, this message translates to:
  /// **'Choose a business first.'**
  String get paywallChooseBusinessFirst;

  /// No description provided for @paywallAmountAboveZero.
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than zero.'**
  String get paywallAmountAboveZero;

  /// No description provided for @paywallCustomerMomoRequired.
  ///
  /// In en, this message translates to:
  /// **'The customer\'s Mobile Money number is required.'**
  String get paywallCustomerMomoRequired;

  /// No description provided for @paywallStaffNotAuthorised.
  ///
  /// In en, this message translates to:
  /// **'This account is not authorised for staff payments.'**
  String get paywallStaffNotAuthorised;

  /// No description provided for @paywallAlreadyCollecting.
  ///
  /// In en, this message translates to:
  /// **'Something is already collecting from this business.'**
  String get paywallAlreadyCollecting;

  /// No description provided for @paywallStaffNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Staff payments are not configured on this connector.'**
  String get paywallStaffNotConfigured;

  /// No description provided for @accountingShiftUser.
  ///
  /// In en, this message translates to:
  /// **'User: {id}'**
  String accountingShiftUser(String id);

  /// No description provided for @accountingShiftHistory.
  ///
  /// In en, this message translates to:
  /// **'Shift History'**
  String get accountingShiftHistory;

  /// No description provided for @accountingLoadingShiftHistory.
  ///
  /// In en, this message translates to:
  /// **'Loading shift history...'**
  String get accountingLoadingShiftHistory;

  /// No description provided for @accountingNoMatchingShifts.
  ///
  /// In en, this message translates to:
  /// **'No matching shifts'**
  String get accountingNoMatchingShifts;

  /// No description provided for @accountingNoShiftsFound.
  ///
  /// In en, this message translates to:
  /// **'No shifts found'**
  String get accountingNoShiftsFound;

  /// No description provided for @accountingAdjustFiltersHint.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or search query.'**
  String get accountingAdjustFiltersHint;

  /// No description provided for @accountingNoShiftsHint.
  ///
  /// In en, this message translates to:
  /// **'Shift records will appear here once you\nstart managing your shifts.'**
  String get accountingNoShiftsHint;

  /// No description provided for @accountingClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get accountingClearFilters;

  /// No description provided for @accountingCashSalesRange.
  ///
  /// In en, this message translates to:
  /// **'CASH SALES RANGE ({currency})'**
  String accountingCashSalesRange(String currency);

  /// No description provided for @accountingFilterShifts.
  ///
  /// In en, this message translates to:
  /// **'Filter shifts'**
  String get accountingFilterShifts;

  /// No description provided for @accountingDateRange.
  ///
  /// In en, this message translates to:
  /// **'DATE RANGE'**
  String get accountingDateRange;

  /// No description provided for @accountingFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get accountingFrom;

  /// No description provided for @accountingTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get accountingTo;

  /// No description provided for @accountingStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get accountingStatusLabel;

  /// No description provided for @accountingAllShifts.
  ///
  /// In en, this message translates to:
  /// **'All shifts'**
  String get accountingAllShifts;

  /// No description provided for @accountingShiftOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get accountingShiftOpen;

  /// No description provided for @accountingShiftClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get accountingShiftClosed;

  /// No description provided for @accountingMinimum.
  ///
  /// In en, this message translates to:
  /// **'Minimum'**
  String get accountingMinimum;

  /// No description provided for @accountingMaximum.
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get accountingMaximum;

  /// No description provided for @accountingNoLimit.
  ///
  /// In en, this message translates to:
  /// **'No limit'**
  String get accountingNoLimit;

  /// No description provided for @accountingSortBy.
  ///
  /// In en, this message translates to:
  /// **'SORT BY'**
  String get accountingSortBy;

  /// No description provided for @accountingNewestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get accountingNewestFirst;

  /// No description provided for @accountingOldestFirst.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get accountingOldestFirst;

  /// No description provided for @accountingCashSalesHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Cash sales — high to low'**
  String get accountingCashSalesHighToLow;

  /// No description provided for @accountingCashSalesLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Cash sales — low to high'**
  String get accountingCashSalesLowToHigh;

  /// No description provided for @accountingClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get accountingClearAll;

  /// No description provided for @accountingApplyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get accountingApplyFilters;

  /// No description provided for @accountingDatePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'mm/dd/yyyy'**
  String get accountingDatePlaceholder;

  /// No description provided for @accountingTotalShifts.
  ///
  /// In en, this message translates to:
  /// **'TOTAL SHIFTS'**
  String get accountingTotalShifts;

  /// No description provided for @accountingTotalCashSales.
  ///
  /// In en, this message translates to:
  /// **'TOTAL CASH SALES'**
  String get accountingTotalCashSales;

  /// No description provided for @accountingOpenClosed.
  ///
  /// In en, this message translates to:
  /// **'OPEN / CLOSED'**
  String get accountingOpenClosed;

  /// No description provided for @accountingSearchShiftsHint.
  ///
  /// In en, this message translates to:
  /// **'Search by user ID or date...'**
  String get accountingSearchShiftsHint;

  /// No description provided for @accountingShowingShifts.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Showing 1 shift} other{Showing {count} shifts}}'**
  String accountingShowingShifts(int count);

  /// No description provided for @accountingStartedAt.
  ///
  /// In en, this message translates to:
  /// **'Started {time}'**
  String accountingStartedAt(String time);

  /// No description provided for @accountingCashDifference.
  ///
  /// In en, this message translates to:
  /// **'Cash difference: {amount}'**
  String accountingCashDifference(String amount);

  /// No description provided for @accountingTimePeriod.
  ///
  /// In en, this message translates to:
  /// **'TIME PERIOD'**
  String get accountingTimePeriod;

  /// No description provided for @accountingStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get accountingStartTime;

  /// No description provided for @accountingEndTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get accountingEndTime;

  /// No description provided for @accountingDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration: {duration}'**
  String accountingDuration(String duration);

  /// No description provided for @accountingInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get accountingInProgress;

  /// No description provided for @accountingFinancialSummary.
  ///
  /// In en, this message translates to:
  /// **'FINANCIAL SUMMARY'**
  String get accountingFinancialSummary;

  /// No description provided for @accountingOpeningBalance.
  ///
  /// In en, this message translates to:
  /// **'Opening Balance'**
  String get accountingOpeningBalance;

  /// No description provided for @accountingCashSales.
  ///
  /// In en, this message translates to:
  /// **'Cash Sales'**
  String get accountingCashSales;

  /// No description provided for @accountingExpectedCash.
  ///
  /// In en, this message translates to:
  /// **'Expected Cash'**
  String get accountingExpectedCash;

  /// No description provided for @accountingClosingBalance.
  ///
  /// In en, this message translates to:
  /// **'Closing Balance'**
  String get accountingClosingBalance;

  /// No description provided for @uiAdminPinMismatch.
  ///
  /// In en, this message translates to:
  /// **'PINs didn\'t match. Try again.'**
  String get uiAdminPinMismatch;

  /// No description provided for @uiAdminPinIncorrect.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Incorrect PIN. 1 attempt left.} other{Incorrect PIN. {count} attempts left.}}'**
  String uiAdminPinIncorrect(int count);

  /// No description provided for @uiAdminPinSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the PIN. Please try again.'**
  String get uiAdminPinSaveFailed;

  /// No description provided for @uiAdminPinSaved.
  ///
  /// In en, this message translates to:
  /// **'PIN saved'**
  String get uiAdminPinSaved;

  /// No description provided for @uiAdminPinEnter.
  ///
  /// In en, this message translates to:
  /// **'Enter admin PIN'**
  String get uiAdminPinEnter;

  /// No description provided for @uiAdminPinConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm your PIN'**
  String get uiAdminPinConfirm;

  /// No description provided for @uiAdminPinSetUp.
  ///
  /// In en, this message translates to:
  /// **'Set up admin PIN'**
  String get uiAdminPinSetUp;

  /// No description provided for @uiAdminPinSavedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sensitive actions now require this PIN.'**
  String get uiAdminPinSavedSubtitle;

  /// No description provided for @uiAdminPinVerifySubtitle.
  ///
  /// In en, this message translates to:
  /// **'This action is protected. Enter your 4-digit administrator PIN.'**
  String get uiAdminPinVerifySubtitle;

  /// No description provided for @uiAdminPinConfirmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the same 4 digits again to confirm.'**
  String get uiAdminPinConfirmSubtitle;

  /// No description provided for @uiAdminPinSetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a 4-digit PIN to protect edits, deletes and settings.'**
  String get uiAdminPinSetSubtitle;

  /// No description provided for @uiAdminPinDigitsSemantic.
  ///
  /// In en, this message translates to:
  /// **'PIN, {entered} of {total} digits entered'**
  String uiAdminPinDigitsSemantic(String entered, String total);

  /// No description provided for @uiAdminPinLockout.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in {seconds}s.'**
  String uiAdminPinLockout(String seconds);

  /// No description provided for @uiAdminPinStartOver.
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get uiAdminPinStartOver;

  /// No description provided for @uiMonthShortJan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get uiMonthShortJan;

  /// No description provided for @uiMonthShortFeb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get uiMonthShortFeb;

  /// No description provided for @uiMonthShortMar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get uiMonthShortMar;

  /// No description provided for @uiMonthShortApr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get uiMonthShortApr;

  /// No description provided for @uiMonthShortMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get uiMonthShortMay;

  /// No description provided for @uiMonthShortJun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get uiMonthShortJun;

  /// No description provided for @uiMonthShortJul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get uiMonthShortJul;

  /// No description provided for @uiMonthShortAug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get uiMonthShortAug;

  /// No description provided for @uiMonthShortSep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get uiMonthShortSep;

  /// No description provided for @uiMonthShortOct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get uiMonthShortOct;

  /// No description provided for @uiMonthShortNov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get uiMonthShortNov;

  /// No description provided for @uiMonthShortDec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get uiMonthShortDec;

  /// No description provided for @uiTicketResumeOrder.
  ///
  /// In en, this message translates to:
  /// **'Resume order'**
  String get uiTicketResumeOrder;

  /// No description provided for @uiTicketResuming.
  ///
  /// In en, this message translates to:
  /// **'Resuming…'**
  String get uiTicketResuming;

  /// No description provided for @uiTicketCustomerSection.
  ///
  /// In en, this message translates to:
  /// **'CUSTOMER'**
  String get uiTicketCustomerSection;

  /// No description provided for @uiTicketItemsSection.
  ///
  /// In en, this message translates to:
  /// **'ITEMS · {count}'**
  String uiTicketItemsSection(String count);

  /// No description provided for @uiTicketCouldNotLoadItems.
  ///
  /// In en, this message translates to:
  /// **'Could not load items: {error}'**
  String uiTicketCouldNotLoadItems(String error);

  /// No description provided for @uiTicketStatusSection.
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get uiTicketStatusSection;

  /// No description provided for @uiTicketResumeTicket.
  ///
  /// In en, this message translates to:
  /// **'Resume ticket'**
  String get uiTicketResumeTicket;

  /// No description provided for @uiTicketWalkIn.
  ///
  /// In en, this message translates to:
  /// **'Walk-in'**
  String get uiTicketWalkIn;

  /// No description provided for @uiTicketLoan.
  ///
  /// In en, this message translates to:
  /// **'Loan'**
  String get uiTicketLoan;

  /// No description provided for @uiTicketNoItems.
  ///
  /// In en, this message translates to:
  /// **'No items on this ticket.'**
  String get uiTicketNoItems;

  /// No description provided for @uiTicketPaymentsSection.
  ///
  /// In en, this message translates to:
  /// **'PAYMENTS · {count}'**
  String uiTicketPaymentsSection(String count);

  /// No description provided for @uiTicketTotalPaidSoFar.
  ///
  /// In en, this message translates to:
  /// **'Total paid so far'**
  String get uiTicketTotalPaidSoFar;

  /// No description provided for @uiTicketStillDue.
  ///
  /// In en, this message translates to:
  /// **'Still due'**
  String get uiTicketStillDue;

  /// No description provided for @uiTicketUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get uiTicketUnknown;

  /// No description provided for @uiTicketPaymentLine.
  ///
  /// In en, this message translates to:
  /// **'Payment {index} · {method}'**
  String uiTicketPaymentLine(String index, String method);

  /// No description provided for @uiTicketPaidBy.
  ///
  /// In en, this message translates to:
  /// **'Paid by {name}'**
  String uiTicketPaidBy(String name);

  /// No description provided for @uiTicketStatusWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get uiTicketStatusWaiting;

  /// No description provided for @uiTicketStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get uiTicketStatusInProgress;

  /// No description provided for @uiTicketStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get uiTicketStatusCompleted;

  /// No description provided for @uiTicketBadgeInProgress.
  ///
  /// In en, this message translates to:
  /// **'IN PROGRESS'**
  String get uiTicketBadgeInProgress;

  /// No description provided for @uiTicketBadgeCompleted.
  ///
  /// In en, this message translates to:
  /// **'COMPLETED'**
  String get uiTicketBadgeCompleted;

  /// No description provided for @uiTicketBadgeParked.
  ///
  /// In en, this message translates to:
  /// **'PARKED'**
  String get uiTicketBadgeParked;

  /// No description provided for @uiTicketDateNotRecorded.
  ///
  /// In en, this message translates to:
  /// **'Date not recorded'**
  String get uiTicketDateNotRecorded;

  /// No description provided for @uiTicketTodayAt.
  ///
  /// In en, this message translates to:
  /// **'Today · {time}'**
  String uiTicketTodayAt(String time);

  /// No description provided for @uiTicketYesterdayAt.
  ///
  /// In en, this message translates to:
  /// **'Yesterday · {time}'**
  String uiTicketYesterdayAt(String time);

  /// No description provided for @uiTicketParkTransaction.
  ///
  /// In en, this message translates to:
  /// **'Park transaction'**
  String get uiTicketParkTransaction;

  /// No description provided for @uiTicketParking.
  ///
  /// In en, this message translates to:
  /// **'Parking…'**
  String get uiTicketParking;

  /// No description provided for @uiTicketParkFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to park transaction: {error}'**
  String uiTicketParkFailed(String error);

  /// No description provided for @uiTicketAttachCustomer.
  ///
  /// In en, this message translates to:
  /// **'Attach customer'**
  String get uiTicketAttachCustomer;

  /// No description provided for @uiTicketSearchCustomers.
  ///
  /// In en, this message translates to:
  /// **'Search customers…'**
  String get uiTicketSearchCustomers;

  /// No description provided for @uiTicketNoCustomer.
  ///
  /// In en, this message translates to:
  /// **'No customer'**
  String get uiTicketNoCustomer;

  /// No description provided for @uiTicketName.
  ///
  /// In en, this message translates to:
  /// **'Ticket name'**
  String get uiTicketName;

  /// No description provided for @uiTicketEnterName.
  ///
  /// In en, this message translates to:
  /// **'Enter a ticket name'**
  String get uiTicketEnterName;

  /// No description provided for @uiTicketNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get uiTicketNotes;

  /// No description provided for @uiTicketOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get uiTicketOptional;

  /// No description provided for @uiTicketAddNotes.
  ///
  /// In en, this message translates to:
  /// **'Add notes'**
  String get uiTicketAddNotes;

  /// No description provided for @uiTicketPaymentDue.
  ///
  /// In en, this message translates to:
  /// **'Payment due'**
  String get uiTicketPaymentDue;

  /// No description provided for @uiTicketSendToKitchen.
  ///
  /// In en, this message translates to:
  /// **'Send to kitchen'**
  String get uiTicketSendToKitchen;

  /// No description provided for @uiTicketShowOnKds.
  ///
  /// In en, this message translates to:
  /// **'Show this ticket on the Kitchen Display'**
  String get uiTicketShowOnKds;

  /// No description provided for @uiTicketSelectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Select customer'**
  String get uiTicketSelectCustomer;

  /// No description provided for @uiTicketMarkAsLoan.
  ///
  /// In en, this message translates to:
  /// **'Mark as loan'**
  String get uiTicketMarkAsLoan;

  /// No description provided for @uiTicketTrackPaymentLater.
  ///
  /// In en, this message translates to:
  /// **'Track payment for later collection'**
  String get uiTicketTrackPaymentLater;

  /// No description provided for @uiTicketOneWeek.
  ///
  /// In en, this message translates to:
  /// **'1 week'**
  String get uiTicketOneWeek;

  /// No description provided for @uiTicketTwoWeeks.
  ///
  /// In en, this message translates to:
  /// **'2 weeks'**
  String get uiTicketTwoWeeks;

  /// No description provided for @uiTicketOneMonth.
  ///
  /// In en, this message translates to:
  /// **'1 month'**
  String get uiTicketOneMonth;

  /// No description provided for @uiTicketSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get uiTicketSelectDate;

  /// No description provided for @uiTicketDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get uiTicketDueDate;

  /// No description provided for @uiTicketHoldSale.
  ///
  /// In en, this message translates to:
  /// **'Hold this sale to finish later'**
  String get uiTicketHoldSale;

  /// No description provided for @uiWorkOrderUnknownProduct.
  ///
  /// In en, this message translates to:
  /// **'Unknown Product'**
  String get uiWorkOrderUnknownProduct;

  /// No description provided for @uiWorkOrderId.
  ///
  /// In en, this message translates to:
  /// **'ID: {id}'**
  String uiWorkOrderId(String id);

  /// No description provided for @uiWorkOrderStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get uiWorkOrderStart;

  /// No description provided for @uiWorkOrderRecordOutput.
  ///
  /// In en, this message translates to:
  /// **'Record Output'**
  String get uiWorkOrderRecordOutput;

  /// No description provided for @uiWorkOrderCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get uiWorkOrderCompleted;

  /// No description provided for @uiWorkOrderInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get uiWorkOrderInProgress;

  /// No description provided for @uiWorkOrderPlanned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get uiWorkOrderPlanned;

  /// No description provided for @uiWorkOrderActual.
  ///
  /// In en, this message translates to:
  /// **'Actual'**
  String get uiWorkOrderActual;

  /// No description provided for @uiWorkOrderVariance.
  ///
  /// In en, this message translates to:
  /// **'Variance'**
  String get uiWorkOrderVariance;

  /// No description provided for @uiWorkOrderEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Efficiency'**
  String get uiWorkOrderEfficiency;

  /// No description provided for @uiWorkOrderTargetDate.
  ///
  /// In en, this message translates to:
  /// **'Target Date'**
  String get uiWorkOrderTargetDate;

  /// No description provided for @uiWorkOrderShift.
  ///
  /// In en, this message translates to:
  /// **'Shift'**
  String get uiWorkOrderShift;

  /// No description provided for @uiWorkOrderNotApplicable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get uiWorkOrderNotApplicable;

  /// No description provided for @uiWorkOrderNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get uiWorkOrderNotes;

  /// No description provided for @uiWorkOrderTimeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get uiWorkOrderTimeline;

  /// No description provided for @uiWorkOrderCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get uiWorkOrderCreated;

  /// No description provided for @uiWorkOrderStarted.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get uiWorkOrderStarted;

  /// No description provided for @uiProduceItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get uiProduceItems;

  /// No description provided for @uiProduceSelectItem.
  ///
  /// In en, this message translates to:
  /// **'Select Item to Produce'**
  String get uiProduceSelectItem;

  /// No description provided for @uiProduceDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose an item from the list below to begin production.'**
  String get uiProduceDescription;

  /// No description provided for @uiProduceItemsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item remaining} other{{count} items remaining}}'**
  String uiProduceItemsRemaining(int count);

  /// No description provided for @uiProduceAssignedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} assigned'**
  String uiProduceAssignedCount(String count);

  /// No description provided for @uiProduceQty.
  ///
  /// In en, this message translates to:
  /// **'Qty: {qty}'**
  String uiProduceQty(String qty);

  /// No description provided for @uiProduceAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get uiProduceAssigned;

  /// No description provided for @uiProduceInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get uiProduceInProgress;

  /// No description provided for @uiProduceBackToList.
  ///
  /// In en, this message translates to:
  /// **'Back to list'**
  String get uiProduceBackToList;

  /// No description provided for @uiProduceDetails.
  ///
  /// In en, this message translates to:
  /// **'Production Details'**
  String get uiProduceDetails;

  /// No description provided for @uiPaymentModeSelect.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Mode'**
  String get uiPaymentModeSelect;

  /// No description provided for @uiPaymentModeFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get uiPaymentModeFailed;

  /// No description provided for @uiPaymentModePleaseSelect.
  ///
  /// In en, this message translates to:
  /// **'Please select a payment mode'**
  String get uiPaymentModePleaseSelect;

  /// No description provided for @uiPaymentModeSelectFinancing.
  ///
  /// In en, this message translates to:
  /// **'Select Financing Option'**
  String get uiPaymentModeSelectFinancing;

  /// No description provided for @uiPaymentModeInterest.
  ///
  /// In en, this message translates to:
  /// **'Interest: {rate}%'**
  String uiPaymentModeInterest(String rate);

  /// No description provided for @uiBackupDescription.
  ///
  /// In en, this message translates to:
  /// **'Enabling backup will save your data daily, so you won\'t have to worry about losing it.'**
  String get uiBackupDescription;

  /// No description provided for @uiTicketNoName.
  ///
  /// In en, this message translates to:
  /// **'No Name'**
  String get uiTicketNoName;

  /// No description provided for @uiTicketResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get uiTicketResume;

  /// No description provided for @uiNoteRequired.
  ///
  /// In en, this message translates to:
  /// **'Note is required'**
  String get uiNoteRequired;

  /// No description provided for @uiNotificationSemantic.
  ///
  /// In en, this message translates to:
  /// **'{message} notification'**
  String uiNotificationSemantic(String message);

  /// No description provided for @uiDeleteConfirmSemantic.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete confirmation for 1 item} other{Delete confirmation for {count} items}}'**
  String uiDeleteConfirmSemantic(int count);

  /// No description provided for @uiDeleteItemsQuestion.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete 1 item?} other{Delete {count} items?}}'**
  String uiDeleteItemsQuestion(int count);

  /// No description provided for @uiMoreItems.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{+ 1 more item} other{+ {count} more items}}'**
  String uiMoreItems(int count);

  /// No description provided for @uiRefreshStatusAfterPayment.
  ///
  /// In en, this message translates to:
  /// **'Refresh status after payment'**
  String get uiRefreshStatusAfterPayment;

  /// No description provided for @uiSubscriptionActive.
  ///
  /// In en, this message translates to:
  /// **'Subscription is active.'**
  String get uiSubscriptionActive;

  /// No description provided for @uiNoPlanOpeningSetup.
  ///
  /// In en, this message translates to:
  /// **'No plan found — opening payment setup.'**
  String get uiNoPlanOpeningSetup;

  /// No description provided for @uiPlanInactiveOpeningPayment.
  ///
  /// In en, this message translates to:
  /// **'Plan found but not active — opening payment screen.'**
  String get uiPlanInactiveOpeningPayment;

  /// No description provided for @uiCouldNotVerifyPayment.
  ///
  /// In en, this message translates to:
  /// **'Could not verify payment status.'**
  String get uiCouldNotVerifyPayment;

  /// No description provided for @uiTimerDone.
  ///
  /// In en, this message translates to:
  /// **'Done!'**
  String get uiTimerDone;

  /// No description provided for @uiTimerDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered!'**
  String get uiTimerDelivered;

  /// No description provided for @uiTimerUntilDelivered.
  ///
  /// In en, this message translates to:
  /// **'Until Delivered'**
  String get uiTimerUntilDelivered;

  /// No description provided for @uiTimerDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Day} other{{count} Days}}'**
  String uiTimerDays(int count);

  /// No description provided for @uiTimerHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Hour} other{{count} Hours}}'**
  String uiTimerHours(int count);

  /// No description provided for @uiTimerMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} MIN'**
  String uiTimerMinutes(String count);

  /// No description provided for @uiTimerSeconds.
  ///
  /// In en, this message translates to:
  /// **'{count} SEC'**
  String uiTimerSeconds(String count);

  /// No description provided for @uiEnterCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Coupon Code'**
  String get uiEnterCouponCode;

  /// No description provided for @uiShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get uiShop;

  /// No description provided for @uiShopActiveSemantic.
  ///
  /// In en, this message translates to:
  /// **'{name} active'**
  String uiShopActiveSemantic(String name);

  /// No description provided for @uiShopInactiveSemantic.
  ///
  /// In en, this message translates to:
  /// **'{name} inactive'**
  String uiShopInactiveSemantic(String name);

  /// No description provided for @uiSaveTicket.
  ///
  /// In en, this message translates to:
  /// **'Save Ticket'**
  String get uiSaveTicket;

  /// No description provided for @floSuggestTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Summarize today\'s performance'**
  String get floSuggestTodayTitle;

  /// No description provided for @floSuggestTodayDesc.
  ///
  /// In en, this message translates to:
  /// **'Revenue, profit & units at a glance'**
  String get floSuggestTodayDesc;

  /// No description provided for @floSuggestTodayQuestion.
  ///
  /// In en, this message translates to:
  /// **'Summarize today\'s business performance'**
  String get floSuggestTodayQuestion;

  /// No description provided for @floSuggestProfitTitle.
  ///
  /// In en, this message translates to:
  /// **'Most profitable products'**
  String get floSuggestProfitTitle;

  /// No description provided for @floSuggestProfitDesc.
  ///
  /// In en, this message translates to:
  /// **'Ranked by margin this week'**
  String get floSuggestProfitDesc;

  /// No description provided for @floSuggestProfitQuestion.
  ///
  /// In en, this message translates to:
  /// **'Which products are most profitable this week?'**
  String get floSuggestProfitQuestion;

  /// No description provided for @floSuggestUsersTitle.
  ///
  /// In en, this message translates to:
  /// **'How many users in MiniData?'**
  String get floSuggestUsersTitle;

  /// No description provided for @floSuggestUsersDesc.
  ///
  /// In en, this message translates to:
  /// **'Counts & recent activity'**
  String get floSuggestUsersDesc;

  /// No description provided for @floSuggestUsersQuestion.
  ///
  /// In en, this message translates to:
  /// **'How many users do we have in MiniData?'**
  String get floSuggestUsersQuestion;

  /// No description provided for @floSuggestTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'This week\'s sales trend'**
  String get floSuggestTrendTitle;

  /// No description provided for @floSuggestTrendDesc.
  ///
  /// In en, this message translates to:
  /// **'7-day revenue movement'**
  String get floSuggestTrendDesc;

  /// No description provided for @floSuggestTrendQuestion.
  ///
  /// In en, this message translates to:
  /// **'Show this week\'s sales trend'**
  String get floSuggestTrendQuestion;

  /// No description provided for @floGoodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get floGoodMorning;

  /// No description provided for @floGoodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get floGoodAfternoon;

  /// No description provided for @floGoodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get floGoodEvening;

  /// No description provided for @floGreetingShop.
  ///
  /// In en, this message translates to:
  /// **'{greeting}, {shop}.'**
  String floGreetingShop(String greeting, String shop);

  /// No description provided for @floAskMeAnything.
  ///
  /// In en, this message translates to:
  /// **'Ask me {anything} about your business.'**
  String floAskMeAnything(String anything);

  /// No description provided for @floAnything.
  ///
  /// In en, this message translates to:
  /// **'anything'**
  String get floAnything;

  /// No description provided for @floHomeIntro.
  ///
  /// In en, this message translates to:
  /// **'I read live from your connected data and answer with numbers, charts and next steps — in plain language.'**
  String get floHomeIntro;

  /// No description provided for @floTryAsking.
  ///
  /// In en, this message translates to:
  /// **'Try asking'**
  String get floTryAsking;

  /// No description provided for @floChannels.
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get floChannels;

  /// No description provided for @floMiniDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Live Supabase data — sales, users, products.'**
  String get floMiniDataDesc;

  /// No description provided for @floManage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get floManage;

  /// No description provided for @floConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get floConnect;

  /// No description provided for @floWhatsAppConnectedDesc.
  ///
  /// In en, this message translates to:
  /// **'You can chat with Flo over WhatsApp.'**
  String get floWhatsAppConnectedDesc;

  /// No description provided for @floWhatsAppSetupDesc.
  ///
  /// In en, this message translates to:
  /// **'Talk to Flo from your phone — set up in a minute.'**
  String get floWhatsAppSetupDesc;

  /// No description provided for @floLoadingBriefing.
  ///
  /// In en, this message translates to:
  /// **'Loading today\'s briefing…'**
  String get floLoadingBriefing;

  /// No description provided for @floBriefingUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Daily briefing unavailable'**
  String get floBriefingUnavailable;

  /// No description provided for @floReadingLiveSales.
  ///
  /// In en, this message translates to:
  /// **'Reading live sales from MiniData.'**
  String get floReadingLiveSales;

  /// No description provided for @floCheckDataConnection.
  ///
  /// In en, this message translates to:
  /// **'Check your data connection and try again.'**
  String get floCheckDataConnection;

  /// No description provided for @floDailyBriefing.
  ///
  /// In en, this message translates to:
  /// **'DAILY BRIEFING'**
  String get floDailyBriefing;

  /// No description provided for @floDateAuto.
  ///
  /// In en, this message translates to:
  /// **'{date} · auto'**
  String floDateAuto(String date);

  /// No description provided for @floConnected.
  ///
  /// In en, this message translates to:
  /// **'CONNECTED'**
  String get floConnected;

  /// No description provided for @floNotSetUp.
  ///
  /// In en, this message translates to:
  /// **'NOT SET UP'**
  String get floNotSetUp;

  /// No description provided for @aiWhatsappReadInboxFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not read WhatsApp messages\n{error}'**
  String aiWhatsappReadInboxFailed(String error);

  /// No description provided for @aiWhatsappSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Send failed: {error}'**
  String aiWhatsappSendFailed(String error);

  /// No description provided for @aiWhatsappAnswerCustomers.
  ///
  /// In en, this message translates to:
  /// **'Answer customers on WhatsApp'**
  String get aiWhatsappAnswerCustomers;

  /// No description provided for @aiWhatsappConnectPitch.
  ///
  /// In en, this message translates to:
  /// **'Connect your Meta WhatsApp Business account to see customer messages here and draft replies with Flo.'**
  String get aiWhatsappConnectPitch;

  /// No description provided for @aiWhatsappConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect WhatsApp'**
  String get aiWhatsappConnect;

  /// No description provided for @aiWhatsappSelectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Select a customer'**
  String get aiWhatsappSelectCustomer;

  /// No description provided for @aiWhatsappInboxSource.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp inbox · data-connector + Ditto'**
  String get aiWhatsappInboxSource;

  /// No description provided for @aiWhatsappCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers · WhatsApp'**
  String get aiWhatsappCustomers;

  /// No description provided for @floTimeNow.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get floTimeNow;

  /// No description provided for @floTimeMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'{count}m'**
  String floTimeMinutesShort(String count);

  /// No description provided for @floTimeDaysShort.
  ///
  /// In en, this message translates to:
  /// **'{count}d'**
  String floTimeDaysShort(String count);

  /// No description provided for @aiWhatsappNoMessages.
  ///
  /// In en, this message translates to:
  /// **'No WhatsApp messages yet'**
  String get aiWhatsappNoMessages;

  /// No description provided for @aiWhatsappNoMessagesHint.
  ///
  /// In en, this message translates to:
  /// **'Inbound messages load from data-connector (local Ditto is a backup). When Meta posts to the webhook they appear here within a few seconds.'**
  String get aiWhatsappNoMessagesHint;

  /// No description provided for @aiWhatsappNoThreadMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages in this thread yet'**
  String get aiWhatsappNoThreadMessages;

  /// No description provided for @aiWhatsappPdfDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not download this PDF'**
  String get aiWhatsappPdfDownloadFailed;

  /// No description provided for @aiWhatsappSavePdf.
  ///
  /// In en, this message translates to:
  /// **'Save PDF'**
  String get aiWhatsappSavePdf;

  /// No description provided for @aiWhatsappSavedFile.
  ///
  /// In en, this message translates to:
  /// **'Saved {file}'**
  String aiWhatsappSavedFile(String file);

  /// No description provided for @aiWhatsappDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download failed: {error}'**
  String aiWhatsappDownloadFailed(String error);

  /// No description provided for @aiWhatsappPdfDocument.
  ///
  /// In en, this message translates to:
  /// **'PDF document'**
  String get aiWhatsappPdfDocument;

  /// No description provided for @aiWhatsappFloSuggestedReply.
  ///
  /// In en, this message translates to:
  /// **'Flo suggested reply'**
  String get aiWhatsappFloSuggestedReply;

  /// No description provided for @aiWhatsappSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get aiWhatsappSend;

  /// No description provided for @aiWhatsappEditFirst.
  ///
  /// In en, this message translates to:
  /// **'Edit first'**
  String get aiWhatsappEditFirst;

  /// No description provided for @aiWhatsappDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get aiWhatsappDraft;

  /// No description provided for @aiWhatsappReplyHint.
  ///
  /// In en, this message translates to:
  /// **'Reply on WhatsApp…'**
  String get aiWhatsappReplyHint;

  /// No description provided for @floBusinessAi.
  ///
  /// In en, this message translates to:
  /// **'Business AI'**
  String get floBusinessAi;

  /// No description provided for @floMiniDataConnectedLive.
  ///
  /// In en, this message translates to:
  /// **'MiniData connected · live'**
  String get floMiniDataConnectedLive;

  /// No description provided for @floNewChat.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get floNewChat;

  /// No description provided for @floAskFlo.
  ///
  /// In en, this message translates to:
  /// **'Ask Flo'**
  String get floAskFlo;

  /// No description provided for @floMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get floMessages;

  /// No description provided for @floNewConversation.
  ///
  /// In en, this message translates to:
  /// **'New conversation'**
  String get floNewConversation;

  /// No description provided for @floChatWithFloAndCustomers.
  ///
  /// In en, this message translates to:
  /// **'Chat with Flo & customers'**
  String get floChatWithFloAndCustomers;

  /// No description provided for @floOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get floOn;

  /// No description provided for @floOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get floOff;

  /// No description provided for @floManageDataSources.
  ///
  /// In en, this message translates to:
  /// **'Manage data sources'**
  String get floManageDataSources;

  /// No description provided for @floQuickSummarizeToday.
  ///
  /// In en, this message translates to:
  /// **'Summarize today'**
  String get floQuickSummarizeToday;

  /// No description provided for @floQuickTopProducts.
  ///
  /// In en, this message translates to:
  /// **'Top products'**
  String get floQuickTopProducts;

  /// No description provided for @floQuickUserCount.
  ///
  /// In en, this message translates to:
  /// **'User count'**
  String get floQuickUserCount;

  /// No description provided for @floQuickSalesTrend.
  ///
  /// In en, this message translates to:
  /// **'Sales trend'**
  String get floQuickSalesTrend;

  /// No description provided for @floComposerHint.
  ///
  /// In en, this message translates to:
  /// **'Ask about sales, stock, customers or tax…'**
  String get floComposerHint;

  /// No description provided for @floStopDictating.
  ///
  /// In en, this message translates to:
  /// **'Stop dictating'**
  String get floStopDictating;

  /// No description provided for @floDictate.
  ///
  /// In en, this message translates to:
  /// **'Dictate — speak and Flo types it'**
  String get floDictate;

  /// No description provided for @floCanMakeMistakes.
  ///
  /// In en, this message translates to:
  /// **'Flo can make mistakes — check important figures. '**
  String get floCanMakeMistakes;

  /// No description provided for @floGroundedInMiniData.
  ///
  /// In en, this message translates to:
  /// **'Grounded in MiniData.'**
  String get floGroundedInMiniData;

  /// No description provided for @floStarting.
  ///
  /// In en, this message translates to:
  /// **'Starting…'**
  String get floStarting;

  /// No description provided for @floListening.
  ///
  /// In en, this message translates to:
  /// **'Listening…'**
  String get floListening;

  /// No description provided for @floModeCloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud'**
  String get floModeCloud;

  /// No description provided for @floModeOnDevice.
  ///
  /// In en, this message translates to:
  /// **'On-Device'**
  String get floModeOnDevice;

  /// No description provided for @floChooseAiMode.
  ///
  /// In en, this message translates to:
  /// **'Choose AI mode'**
  String get floChooseAiMode;

  /// No description provided for @floOnDeviceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Free · offline · private'**
  String get floOnDeviceSubtitle;

  /// No description provided for @floCloudSubtitle.
  ///
  /// In en, this message translates to:
  /// **'More capable · uses connection'**
  String get floCloudSubtitle;

  /// No description provided for @floThinkingUnderstanding.
  ///
  /// In en, this message translates to:
  /// **'Understanding question'**
  String get floThinkingUnderstanding;

  /// No description provided for @floThinkingQuerying.
  ///
  /// In en, this message translates to:
  /// **'Querying MiniData'**
  String get floThinkingQuerying;

  /// No description provided for @floThinkingComposing.
  ///
  /// In en, this message translates to:
  /// **'Composing answer'**
  String get floThinkingComposing;

  /// No description provided for @floCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied!'**
  String get floCopied;

  /// No description provided for @floCopyChart.
  ///
  /// In en, this message translates to:
  /// **'Copy chart'**
  String get floCopyChart;

  /// No description provided for @floSuggestedFollowUps.
  ///
  /// In en, this message translates to:
  /// **'SUGGESTED FOLLOW-UPS'**
  String get floSuggestedFollowUps;

  /// No description provided for @aiDataSourceEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Data Source'**
  String get aiDataSourceEdit;

  /// No description provided for @aiDataSourceConnectTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect Data Source'**
  String get aiDataSourceConnectTitle;

  /// No description provided for @aiDataSourceType.
  ///
  /// In en, this message translates to:
  /// **'Data Source Type'**
  String get aiDataSourceType;

  /// No description provided for @aiDataSourceConnectionName.
  ///
  /// In en, this message translates to:
  /// **'Connection Name'**
  String get aiDataSourceConnectionName;

  /// No description provided for @aiDataSourceConnectionNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Production Database'**
  String get aiDataSourceConnectionNameHint;

  /// No description provided for @aiDataSourceSupabaseUrl.
  ///
  /// In en, this message translates to:
  /// **'Supabase URL'**
  String get aiDataSourceSupabaseUrl;

  /// No description provided for @aiDataSourceAnonKey.
  ///
  /// In en, this message translates to:
  /// **'Anon/Public Key'**
  String get aiDataSourceAnonKey;

  /// No description provided for @aiDataSourceServiceKey.
  ///
  /// In en, this message translates to:
  /// **'Service Role Key (Optional)'**
  String get aiDataSourceServiceKey;

  /// No description provided for @aiDataSourceServiceKeyHelper.
  ///
  /// In en, this message translates to:
  /// **'Required for admin operations'**
  String get aiDataSourceServiceKeyHelper;

  /// No description provided for @aiDataSourceTestFailedCredentials.
  ///
  /// In en, this message translates to:
  /// **'Connection test failed. Please check your credentials.'**
  String get aiDataSourceTestFailedCredentials;

  /// No description provided for @aiDataSourceTestFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection test failed: {error}'**
  String aiDataSourceTestFailed(String error);

  /// No description provided for @aiDataSourceTesting.
  ///
  /// In en, this message translates to:
  /// **'Testing...'**
  String get aiDataSourceTesting;

  /// No description provided for @aiDataSourceTestConnection.
  ///
  /// In en, this message translates to:
  /// **'Test Connection'**
  String get aiDataSourceTestConnection;

  /// No description provided for @aiDataSourcePrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'When connected, the assistant can use schema and sample rows from this source in your chats. Credentials are stored only on this device.'**
  String get aiDataSourcePrivacyNote;

  /// No description provided for @aiDataSourceEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a connection name'**
  String get aiDataSourceEnterName;

  /// No description provided for @aiDataSourceEnterUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter the Supabase URL'**
  String get aiDataSourceEnterUrl;

  /// No description provided for @aiDataSourceEnterKey.
  ///
  /// In en, this message translates to:
  /// **'Please enter an Anon/Public Key or Service Role Key'**
  String get aiDataSourceEnterKey;

  /// No description provided for @aiDataSourceUpdated.
  ///
  /// In en, this message translates to:
  /// **'Data source updated successfully'**
  String get aiDataSourceUpdated;

  /// No description provided for @aiDataSourceConnected.
  ///
  /// In en, this message translates to:
  /// **'Data source connected successfully'**
  String get aiDataSourceConnected;

  /// No description provided for @aiDataSourceConnectFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect: {error}'**
  String aiDataSourceConnectFailed(String error);

  /// No description provided for @aiDataSourceConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get aiDataSourceConnecting;

  /// No description provided for @aiDataSourceUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get aiDataSourceUpdate;

  /// No description provided for @aiDataSourceConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get aiDataSourceConnect;

  /// No description provided for @aiDataSourceStatusConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get aiDataSourceStatusConnected;

  /// No description provided for @aiDataSourceStatusConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get aiDataSourceStatusConnecting;

  /// No description provided for @aiDataSourceStatusError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get aiDataSourceStatusError;

  /// No description provided for @aiDataSourceStatusDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get aiDataSourceStatusDisconnected;

  /// No description provided for @aiDataSourceTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Source'**
  String get aiDataSourceTitle;

  /// No description provided for @aiDataSourceNotFound.
  ///
  /// In en, this message translates to:
  /// **'Data source not found'**
  String get aiDataSourceNotFound;

  /// No description provided for @aiDataSourceGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get aiDataSourceGoBack;

  /// No description provided for @aiDataSourceTables.
  ///
  /// In en, this message translates to:
  /// **'Tables'**
  String get aiDataSourceTables;

  /// No description provided for @aiDataSourceUrl.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get aiDataSourceUrl;

  /// No description provided for @aiDataSourceNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get aiDataSourceNotAvailable;

  /// No description provided for @aiDataSourceLastConnected.
  ///
  /// In en, this message translates to:
  /// **'Last connected: {time}'**
  String aiDataSourceLastConnected(String time);

  /// No description provided for @aiDataSourceInformation.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get aiDataSourceInformation;

  /// No description provided for @aiDataSourceMetadataFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load metadata: {error}'**
  String aiDataSourceMetadataFailed(String error);

  /// No description provided for @aiDataSourceTotalRows.
  ///
  /// In en, this message translates to:
  /// **'Total Rows'**
  String get aiDataSourceTotalRows;

  /// No description provided for @aiDataSourceTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get aiDataSourceTypeLabel;

  /// No description provided for @aiDataSourceUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get aiDataSourceUnknown;

  /// No description provided for @aiDataSourceTablesFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load tables: {error}'**
  String aiDataSourceTablesFailed(String error);

  /// No description provided for @aiDataSourceNoTables.
  ///
  /// In en, this message translates to:
  /// **'No tables found'**
  String get aiDataSourceNoTables;

  /// No description provided for @aiDataSourceColumnsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 column} other{{count} columns}}'**
  String aiDataSourceColumnsCount(int count);

  /// No description provided for @aiDataSourceRowsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} rows'**
  String aiDataSourceRowsCount(String count);

  /// No description provided for @aiDataSourceColumns.
  ///
  /// In en, this message translates to:
  /// **'Columns'**
  String get aiDataSourceColumns;

  /// No description provided for @aiDataSourceNotNull.
  ///
  /// In en, this message translates to:
  /// **'NOT NULL'**
  String get aiDataSourceNotNull;

  /// No description provided for @aiDataSourceJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get aiDataSourceJustNow;

  /// No description provided for @aiDataSourceMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String aiDataSourceMinutesAgo(String count);

  /// No description provided for @aiDataSourceHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String aiDataSourceHoursAgo(String count);

  /// No description provided for @aiDataSourceCsvFile.
  ///
  /// In en, this message translates to:
  /// **'CSV File'**
  String get aiDataSourceCsvFile;

  /// No description provided for @aiDataSourceJsonFile.
  ///
  /// In en, this message translates to:
  /// **'JSON File'**
  String get aiDataSourceJsonFile;

  /// No description provided for @aiDataSources.
  ///
  /// In en, this message translates to:
  /// **'Data Sources'**
  String get aiDataSources;

  /// No description provided for @aiDataSourceAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Data Source'**
  String get aiDataSourceAdd;

  /// No description provided for @aiDataSourceNoneConnected.
  ///
  /// In en, this message translates to:
  /// **'No Data Sources Connected'**
  String get aiDataSourceNoneConnected;

  /// No description provided for @aiDataSourceNoneHint.
  ///
  /// In en, this message translates to:
  /// **'Connect a database so the AI can include its schema and sample rows\nwhen answering in Business or Personal chat.'**
  String get aiDataSourceNoneHint;

  /// No description provided for @aiDataSourceConnectFirst.
  ///
  /// In en, this message translates to:
  /// **'Connect Your First Data Source'**
  String get aiDataSourceConnectFirst;

  /// No description provided for @aiDataSourceActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get aiDataSourceActive;

  /// No description provided for @aiDataSourceDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get aiDataSourceDisconnect;

  /// No description provided for @aiDataSourceDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Data Source'**
  String get aiDataSourceDeleteTitle;

  /// No description provided for @aiDataSourceDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This will remove the connection and all associated data.'**
  String aiDataSourceDeleteConfirm(String name);

  /// No description provided for @aiDataSourceDeleted.
  ///
  /// In en, this message translates to:
  /// **'Data source \"{name}\" deleted'**
  String aiDataSourceDeleted(String name);

  /// No description provided for @aiWhatsappPhoneIdEmpty.
  ///
  /// In en, this message translates to:
  /// **'Phone Number ID cannot be empty'**
  String get aiWhatsappPhoneIdEmpty;

  /// No description provided for @aiWhatsappPhoneIdInvalid.
  ///
  /// In en, this message translates to:
  /// **'Phone Number ID must contain only digits and be 5-15 characters long'**
  String get aiWhatsappPhoneIdInvalid;

  /// No description provided for @aiWhatsappConnectedSuccess.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp account connected successfully'**
  String get aiWhatsappConnectedSuccess;

  /// No description provided for @aiWhatsappDisconnectedSuccess.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp account disconnected successfully'**
  String get aiWhatsappDisconnectedSuccess;

  /// No description provided for @aiWhatsappConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get aiWhatsappConnected;

  /// No description provided for @aiWhatsappNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get aiWhatsappNotConnected;

  /// No description provided for @aiWhatsappAccountActive.
  ///
  /// In en, this message translates to:
  /// **'Account active'**
  String get aiWhatsappAccountActive;

  /// No description provided for @aiWhatsappSavedToBusiness.
  ///
  /// In en, this message translates to:
  /// **'Saved to your business account — it stays connected on other devices when you sign in.'**
  String get aiWhatsappSavedToBusiness;

  /// No description provided for @aiWhatsappDisconnecting.
  ///
  /// In en, this message translates to:
  /// **'Disconnecting...'**
  String get aiWhatsappDisconnecting;

  /// No description provided for @aiWhatsappDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get aiWhatsappDisconnect;

  /// No description provided for @aiWhatsappConnectIntro.
  ///
  /// In en, this message translates to:
  /// **'Connect your WhatsApp Business account to receive and reply to customer messages.'**
  String get aiWhatsappConnectIntro;

  /// No description provided for @aiWhatsappStep1.
  ///
  /// In en, this message translates to:
  /// **'Go to your Meta Business Suite'**
  String get aiWhatsappStep1;

  /// No description provided for @aiWhatsappStep2.
  ///
  /// In en, this message translates to:
  /// **'Find your Phone Number ID in WhatsApp settings'**
  String get aiWhatsappStep2;

  /// No description provided for @aiWhatsappStep3.
  ///
  /// In en, this message translates to:
  /// **'Paste it below and connect'**
  String get aiWhatsappStep3;

  /// No description provided for @aiWhatsappPhoneIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number ID'**
  String get aiWhatsappPhoneIdLabel;

  /// No description provided for @aiWhatsappPhoneIdHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 101514826127381'**
  String get aiWhatsappPhoneIdHint;

  /// No description provided for @aiWhatsappConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get aiWhatsappConnectionError;

  /// No description provided for @aiWhatsappTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get aiWhatsappTryAgain;

  /// No description provided for @aiMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get aiMessageHint;

  /// No description provided for @aiRecordingStartFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to start recording: {error}'**
  String aiRecordingStartFailed(String error);

  /// No description provided for @aiVoiceMessageSent.
  ///
  /// In en, this message translates to:
  /// **'Voice message sent!'**
  String get aiVoiceMessageSent;

  /// No description provided for @aiAudioCorrupted.
  ///
  /// In en, this message translates to:
  /// **'Audio file is corrupted or incomplete'**
  String get aiAudioCorrupted;

  /// No description provided for @aiRecordingTooShort.
  ///
  /// In en, this message translates to:
  /// **'Recording too short (minimum 1 second)'**
  String get aiRecordingTooShort;

  /// No description provided for @aiRecordingStopFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to stop recording: {error}'**
  String aiRecordingStopFailed(String error);

  /// No description provided for @aiMicPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Microphone Permission'**
  String get aiMicPermissionTitle;

  /// No description provided for @aiMicPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Microphone access is required to record voice messages. Please enable it in your device settings.'**
  String get aiMicPermissionBody;

  /// No description provided for @aiFilePickError.
  ///
  /// In en, this message translates to:
  /// **'Error picking file: {error}'**
  String aiFilePickError(String error);

  /// No description provided for @aiSlideToCancel.
  ///
  /// In en, this message translates to:
  /// **'Slide to cancel'**
  String get aiSlideToCancel;

  /// No description provided for @aiSlideUpToLock.
  ///
  /// In en, this message translates to:
  /// **'Slide up to lock'**
  String get aiSlideUpToLock;

  /// No description provided for @aiHoldAndSlide.
  ///
  /// In en, this message translates to:
  /// **'Hold & slide to control recording'**
  String get aiHoldAndSlide;

  /// No description provided for @aiExcelAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Excel Analysis'**
  String get aiExcelAnalysis;

  /// No description provided for @aiExcelAnalystTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Excel Business Analyst'**
  String get aiExcelAnalystTitle;

  /// No description provided for @aiExcelAnalystSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Interactive Exploration & Visual Trends'**
  String get aiExcelAnalystSubtitle;

  /// No description provided for @aiModelDefaultSuffix.
  ///
  /// In en, this message translates to:
  /// **'{name} (Default)'**
  String aiModelDefaultSuffix(String name);

  /// No description provided for @aiExcelNoData.
  ///
  /// In en, this message translates to:
  /// **'No data found in Excel file'**
  String get aiExcelNoData;

  /// No description provided for @aiExcelSourceData.
  ///
  /// In en, this message translates to:
  /// **'Source Data:'**
  String get aiExcelSourceData;

  /// No description provided for @aiExcelVisualAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Visual Analysis:'**
  String get aiExcelVisualAnalysis;

  /// No description provided for @aiChartRenderError.
  ///
  /// In en, this message translates to:
  /// **'Error rendering chart: {error}'**
  String aiChartRenderError(String error);

  /// No description provided for @aiExcelAskForCharts.
  ///
  /// In en, this message translates to:
  /// **'Ask questions to generate charts'**
  String get aiExcelAskForCharts;

  /// No description provided for @aiExcelAnalystChat.
  ///
  /// In en, this message translates to:
  /// **'Analyst Chat'**
  String get aiExcelAnalystChat;

  /// No description provided for @aiExcelAskHint.
  ///
  /// In en, this message translates to:
  /// **'Ask about this data...'**
  String get aiExcelAskHint;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @aiConversations.
  ///
  /// In en, this message translates to:
  /// **'Conversations'**
  String get aiConversations;

  /// No description provided for @aiAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get aiAdd;

  /// No description provided for @aiNewConversation.
  ///
  /// In en, this message translates to:
  /// **'New Conversation'**
  String get aiNewConversation;

  /// No description provided for @aiDeleteConversation.
  ///
  /// In en, this message translates to:
  /// **'Delete Conversation'**
  String get aiDeleteConversation;

  /// No description provided for @aiDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String aiDaysAgo(String count);

  /// No description provided for @aiPurchaseCredits.
  ///
  /// In en, this message translates to:
  /// **'Purchase Credits'**
  String get aiPurchaseCredits;

  /// No description provided for @aiCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get aiCopied;

  /// No description provided for @aiProcessingExpandThinking.
  ///
  /// In en, this message translates to:
  /// **'AI is processing... Expand thinking to see details.'**
  String get aiProcessingExpandThinking;

  /// No description provided for @aiHideThinking.
  ///
  /// In en, this message translates to:
  /// **'Hide Thinking'**
  String get aiHideThinking;

  /// No description provided for @aiShowThinking.
  ///
  /// In en, this message translates to:
  /// **'Show Thinking'**
  String get aiShowThinking;

  /// No description provided for @aiWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Business AI Assistant'**
  String get aiWelcomeTitle;

  /// No description provided for @aiWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to help you with insights about your business. Try asking one of the questions below.'**
  String get aiWelcomeSubtitle;

  /// No description provided for @aiSamplePersonalBooks.
  ///
  /// In en, this message translates to:
  /// **'What are some good books on leadership?'**
  String get aiSamplePersonalBooks;

  /// No description provided for @aiSamplePersonalEmail.
  ///
  /// In en, this message translates to:
  /// **'Help me draft an email to a potential partner.'**
  String get aiSamplePersonalEmail;

  /// No description provided for @aiSamplePersonalTime.
  ///
  /// In en, this message translates to:
  /// **'Give me some tips for better time management.'**
  String get aiSamplePersonalTime;

  /// No description provided for @aiSampleBusinessSales.
  ///
  /// In en, this message translates to:
  /// **'What were my total sales last week?'**
  String get aiSampleBusinessSales;

  /// No description provided for @aiSampleBusinessTopProducts.
  ///
  /// In en, this message translates to:
  /// **'Show me a breakdown of my top-selling products this month.'**
  String get aiSampleBusinessTopProducts;

  /// No description provided for @aiSampleBusinessTax.
  ///
  /// In en, this message translates to:
  /// **'Generate a tax summary for the last quarter.'**
  String get aiSampleBusinessTax;

  /// No description provided for @aiTaxBreakdown.
  ///
  /// In en, this message translates to:
  /// **'TAX BREAKDOWN'**
  String get aiTaxBreakdown;

  /// No description provided for @aiTotalTax.
  ///
  /// In en, this message translates to:
  /// **'TOTAL TAX'**
  String get aiTotalTax;

  /// No description provided for @aiTaxSummaryReport.
  ///
  /// In en, this message translates to:
  /// **'Tax Summary Report'**
  String get aiTaxSummaryReport;

  /// No description provided for @aiCopyReport.
  ///
  /// In en, this message translates to:
  /// **'Copy Report'**
  String get aiCopyReport;

  /// No description provided for @aiInventoryVisualization.
  ///
  /// In en, this message translates to:
  /// **'Inventory Visualization'**
  String get aiInventoryVisualization;

  /// No description provided for @aiComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get aiComingSoon;

  /// No description provided for @uiTicketDue.
  ///
  /// In en, this message translates to:
  /// **'DUE'**
  String get uiTicketDue;

  /// No description provided for @uiTicketAmount.
  ///
  /// In en, this message translates to:
  /// **'AMOUNT'**
  String get uiTicketAmount;

  /// No description provided for @aiYourShop.
  ///
  /// In en, this message translates to:
  /// **'your shop'**
  String get aiYourShop;

  /// No description provided for @aiBranchIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Branch ID is required'**
  String get aiBranchIdRequired;

  /// No description provided for @aiNoResponse.
  ///
  /// In en, this message translates to:
  /// **'No response was produced. Please try again.'**
  String get aiNoResponse;

  /// No description provided for @aiWhatsappSendMessageFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send WhatsApp message: {error}'**
  String aiWhatsappSendMessageFailed(String error);

  /// No description provided for @aiChartNotFound.
  ///
  /// In en, this message translates to:
  /// **'Error: Could not find chart to copy.'**
  String get aiChartNotFound;

  /// No description provided for @aiChartImageFailed.
  ///
  /// In en, this message translates to:
  /// **'Error: Could not generate image data.'**
  String get aiChartImageFailed;

  /// No description provided for @aiChartCopied.
  ///
  /// In en, this message translates to:
  /// **'Chart copied to clipboard!'**
  String get aiChartCopied;

  /// No description provided for @aiChartCopyFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to copy chart: {error}'**
  String aiChartCopyFailed(String error);

  /// No description provided for @aiVoiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Voice input isn\'t available on this platform yet.'**
  String get aiVoiceUnavailable;

  /// No description provided for @aiVoiceStartFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not start voice input: {error}'**
  String aiVoiceStartFailed(String error);

  /// No description provided for @aiMicAccessOff.
  ///
  /// In en, this message translates to:
  /// **'Microphone access is off. Enable it for Flipper in your system settings, then try again.'**
  String get aiMicAccessOff;

  /// No description provided for @aiListenStartFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not start listening: {error}'**
  String aiListenStartFailed(String error);

  /// No description provided for @aiVoiceNeedsNetwork.
  ///
  /// In en, this message translates to:
  /// **'Voice input needs a network connection right now.'**
  String get aiVoiceNeedsNetwork;

  /// No description provided for @aiMicInUse.
  ///
  /// In en, this message translates to:
  /// **'The microphone is in use by another app.'**
  String get aiMicInUse;

  /// No description provided for @aiVoiceFailed.
  ///
  /// In en, this message translates to:
  /// **'Voice input failed ({error}).'**
  String aiVoiceFailed(String error);

  /// No description provided for @aiLocalUnavailable.
  ///
  /// In en, this message translates to:
  /// **'On-device AI is not available on this device.'**
  String get aiLocalUnavailable;

  /// No description provided for @aiLocalPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing the on-device model…'**
  String get aiLocalPreparing;

  /// No description provided for @aiLocalLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load the on-device model: {error}'**
  String aiLocalLoadFailed(String error);

  /// No description provided for @aiLocalReadingShopData.
  ///
  /// In en, this message translates to:
  /// **'Reading your shop data…'**
  String get aiLocalReadingShopData;

  /// No description provided for @aiLocalThinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking on-device…'**
  String get aiLocalThinking;

  /// No description provided for @aiLocalGenerationFailed.
  ///
  /// In en, this message translates to:
  /// **'On-device generation failed: {error}'**
  String aiLocalGenerationFailed(String error);

  /// No description provided for @floBriefingSalesComingIn.
  ///
  /// In en, this message translates to:
  /// **'Sales are coming in today.'**
  String get floBriefingSalesComingIn;

  /// No description provided for @floBriefingBody.
  ///
  /// In en, this message translates to:
  /// **'Revenue reached <b>RWF {revenue}</b> across <b>{transactions}</b> ({units} units) so far today — live from your device.'**
  String floBriefingBody(String revenue, String transactions, String units);

  /// No description provided for @floBriefingTransactions.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 transaction} other{{count} transactions}}'**
  String floBriefingTransactions(int count);

  /// No description provided for @floStatRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get floStatRevenue;

  /// No description provided for @floStatNetProfit.
  ///
  /// In en, this message translates to:
  /// **'Net profit'**
  String get floStatNetProfit;

  /// No description provided for @floStatUnitsSold.
  ///
  /// In en, this message translates to:
  /// **'Units sold'**
  String get floStatUnitsSold;

  /// No description provided for @aiWhatsappNoBusiness.
  ///
  /// In en, this message translates to:
  /// **'No business selected — cannot save WhatsApp connection'**
  String get aiWhatsappNoBusiness;

  /// No description provided for @aiWhatsappBusinessNotFound.
  ///
  /// In en, this message translates to:
  /// **'Business not found — cannot save WhatsApp connection'**
  String get aiWhatsappBusinessNotFound;

  /// PIN login error; the code in parentheses stays untranslated for support
  ///
  /// In en, this message translates to:
  /// **'The Flipper server took too long to answer. Your connection may be slow. Try again. (TIMEOUT)'**
  String get loginErrorTimeout;

  /// No description provided for @loginErrorSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session expired. Enter your PIN again. (SESSION)'**
  String get loginErrorSessionExpired;

  /// No description provided for @loginErrorPinCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'That PIN could not be checked. Try again. (PIN)'**
  String get loginErrorPinCheckFailed;

  /// No description provided for @loginErrorBadResponse.
  ///
  /// In en, this message translates to:
  /// **'The Flipper server sent an unexpected response. Try again in a minute. (BAD-RESPONSE)'**
  String get loginErrorBadResponse;

  /// No description provided for @loginErrorTls.
  ///
  /// In en, this message translates to:
  /// **'Secure connection failed. Make sure your phone\'s date and time are set automatically, then try again. (TLS)'**
  String get loginErrorTls;

  /// No description provided for @loginErrorTlsNetwork.
  ///
  /// In en, this message translates to:
  /// **'The connection to the Flipper server dropped before it was secured. Your network may be unstable. Try again, or switch between mobile data and Wi-Fi. (TLS-NET)'**
  String get loginErrorTlsNetwork;

  /// No description provided for @loginErrorDns.
  ///
  /// In en, this message translates to:
  /// **'Can\'t find the Flipper server. Your internet may be off or limited. Check mobile data or Wi-Fi. (DNS)'**
  String get loginErrorDns;

  /// No description provided for @loginErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the Flipper server. Check your internet connection and try again. (NET)'**
  String get loginErrorNetwork;

  /// No description provided for @loginErrorOfflineFirst.
  ///
  /// In en, this message translates to:
  /// **'This phone can\'t sign you in offline yet. Connect to the internet and sign in once, then offline sign-in will work. (OFFLINE-FIRST)'**
  String get loginErrorOfflineFirst;

  /// No description provided for @loginErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed. Try again. (UNKNOWN)'**
  String get loginErrorUnknown;

  /// No description provided for @loginErrorNoAccountForPin.
  ///
  /// In en, this message translates to:
  /// **'No account uses this PIN. Check the PIN and try again. (PIN-404)'**
  String get loginErrorNoAccountForPin;

  /// No description provided for @loginErrorHttp404.
  ///
  /// In en, this message translates to:
  /// **'The Flipper server could not find what the app asked for. Update the app and try again. (HTTP-404)'**
  String get loginErrorHttp404;

  /// No description provided for @loginErrorHttp429.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Wait a minute, then try again. (HTTP-429)'**
  String get loginErrorHttp429;

  /// No description provided for @loginErrorHttpRefused.
  ///
  /// In en, this message translates to:
  /// **'The Flipper server refused this request. Update the app and try again. (HTTP-{status})'**
  String loginErrorHttpRefused(String status);

  /// No description provided for @loginErrorHttpServer.
  ///
  /// In en, this message translates to:
  /// **'Flipper servers are having trouble right now. Try again in a minute. (HTTP-{status})'**
  String loginErrorHttpServer(String status);

  /// No description provided for @loginErrorHttpOther.
  ///
  /// In en, this message translates to:
  /// **'The Flipper server could not check this PIN. Try again. (HTTP-{status})'**
  String loginErrorHttpOther(String status);

  /// Fallback business name in 'Verified — opening {business}…'
  ///
  /// In en, this message translates to:
  /// **'your business'**
  String get loginYourBusiness;

  /// No description provided for @loginPinRequired.
  ///
  /// In en, this message translates to:
  /// **'PIN is required'**
  String get loginPinRequired;

  /// No description provided for @loginPinTooShort.
  ///
  /// In en, this message translates to:
  /// **'PIN must be at least 4 digits'**
  String get loginPinTooShort;

  /// No description provided for @loginPinTooLong.
  ///
  /// In en, this message translates to:
  /// **'PIN must be at most {max} digits'**
  String loginPinTooLong(String max);

  /// No description provided for @loginAuthenticatorCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Authenticator code is required'**
  String get loginAuthenticatorCodeRequired;

  /// No description provided for @loginOtpRequired.
  ///
  /// In en, this message translates to:
  /// **'OTP is required'**
  String get loginOtpRequired;

  /// No description provided for @loginAuthenticatorCodeInvalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Authenticator code must be a 6-digit number.'**
  String get loginAuthenticatorCodeInvalidFormat;

  /// No description provided for @loginOtpInvalidFormat.
  ///
  /// In en, this message translates to:
  /// **'OTP must be a 6-digit number.'**
  String get loginOtpInvalidFormat;

  /// No description provided for @loginInvalidPinReenter.
  ///
  /// In en, this message translates to:
  /// **'Invalid PIN. Please re-enter and try again.'**
  String get loginInvalidPinReenter;

  /// No description provided for @loginAuthenticatorUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not verify authenticator. Check your connection, or sign in online once so offline MFA can be cached.'**
  String get loginAuthenticatorUnavailable;

  /// No description provided for @loginAuthenticatorInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid authenticator code. Please try again.'**
  String get loginAuthenticatorInvalidCode;

  /// No description provided for @loginPinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN to manage your business securely.'**
  String get loginPinSubtitle;

  /// No description provided for @loginSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get loginSignedIn;

  /// No description provided for @loginSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSignIn;

  /// No description provided for @loginCreateAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get loginCreateAnAccount;

  /// No description provided for @loginNewToFlipperCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'New to Flipper? Create an account'**
  String get loginNewToFlipperCreateAccount;

  /// No description provided for @loginShowPin.
  ///
  /// In en, this message translates to:
  /// **'Show PIN'**
  String get loginShowPin;

  /// No description provided for @loginHidePin.
  ///
  /// In en, this message translates to:
  /// **'Hide PIN'**
  String get loginHidePin;

  /// No description provided for @loginShow.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get loginShow;

  /// No description provided for @loginHide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get loginHide;

  /// Screen-reader value for the PIN field
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 digit entered} other{{count} digits entered}}'**
  String loginPinDigitsEntered(int count);

  /// MFA method toggle: authenticator app (product term kept in rw/sw)
  ///
  /// In en, this message translates to:
  /// **'Authenticator'**
  String get loginAuthenticator;

  /// No description provided for @loginAuthenticatorCode.
  ///
  /// In en, this message translates to:
  /// **'Authenticator code'**
  String get loginAuthenticatorCode;

  /// No description provided for @loginSmsCode.
  ///
  /// In en, this message translates to:
  /// **'SMS code'**
  String get loginSmsCode;

  /// No description provided for @loginPinEntryCells.
  ///
  /// In en, this message translates to:
  /// **'PIN entry cells'**
  String get loginPinEntryCells;

  /// No description provided for @loginVerifiedOpening.
  ///
  /// In en, this message translates to:
  /// **'Verified — opening {business}…'**
  String loginVerifiedOpening(String business);

  /// No description provided for @loginShowOrHidePin.
  ///
  /// In en, this message translates to:
  /// **'Show or hide PIN'**
  String get loginShowOrHidePin;

  /// No description provided for @loginBackspace.
  ///
  /// In en, this message translates to:
  /// **'Backspace'**
  String get loginBackspace;

  /// No description provided for @loginSecuredE2e.
  ///
  /// In en, this message translates to:
  /// **'Secured with end-to-end encryption'**
  String get loginSecuredE2e;

  /// No description provided for @loginBrandHeadline.
  ///
  /// In en, this message translates to:
  /// **'Your shop, your team, your numbers — all in one place.'**
  String get loginBrandHeadline;

  /// No description provided for @loginBrandSubhead.
  ///
  /// In en, this message translates to:
  /// **'Pick up right where you left off. Today’s sales, stock, and reports are ready.'**
  String get loginBrandSubhead;

  /// Label under the '12,400+' stat on the sign-in brand panel
  ///
  /// In en, this message translates to:
  /// **'businesses'**
  String get loginStatBusinesses;

  /// No description provided for @loginStatProcessedMonthly.
  ///
  /// In en, this message translates to:
  /// **'processed monthly'**
  String get loginStatProcessedMonthly;

  /// No description provided for @loginStatUptime.
  ///
  /// In en, this message translates to:
  /// **'uptime'**
  String get loginStatUptime;

  /// No description provided for @loginRevenueThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Revenue · this week'**
  String get loginRevenueThisWeek;

  /// No description provided for @loginNewSale.
  ///
  /// In en, this message translates to:
  /// **'New sale'**
  String get loginNewSale;

  /// Illustrative sale on the sign-in/landing hero cards
  ///
  /// In en, this message translates to:
  /// **'Solar Kit · MoMo'**
  String get loginSampleSaleDetail;

  /// No description provided for @loginStreakDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String loginStreakDays(int count);

  /// No description provided for @loginSalesStreak.
  ///
  /// In en, this message translates to:
  /// **'Sales streak'**
  String get loginSalesStreak;

  /// Landing slide title; must contain loginLandingSlide1Highlight verbatim
  ///
  /// In en, this message translates to:
  /// **'Run your whole\nbusiness from one app'**
  String get loginLandingSlide1Title;

  /// Gradient-highlighted words; must appear verbatim in loginLandingSlide1Title
  ///
  /// In en, this message translates to:
  /// **'business'**
  String get loginLandingSlide1Highlight;

  /// No description provided for @loginLandingSlide1Text.
  ///
  /// In en, this message translates to:
  /// **'Sell, track stock, and manage your team - Flipper is your business in your pocket.'**
  String get loginLandingSlide1Text;

  /// Landing slide title; must contain loginLandingSlide2Highlight verbatim
  ///
  /// In en, this message translates to:
  /// **'Simple, useful reports\nthat help you grow'**
  String get loginLandingSlide2Title;

  /// Gradient-highlighted words; must appear verbatim in loginLandingSlide2Title
  ///
  /// In en, this message translates to:
  /// **'reports'**
  String get loginLandingSlide2Highlight;

  /// No description provided for @loginLandingSlide2Text.
  ///
  /// In en, this message translates to:
  /// **'See exactly what sells, what\'s running low, and where your money goes - every day.'**
  String get loginLandingSlide2Text;

  /// Landing slide title; must contain loginLandingSlide3Highlight verbatim
  ///
  /// In en, this message translates to:
  /// **'Get paid faster,\ntrack every franc'**
  String get loginLandingSlide3Title;

  /// Gradient-highlighted words; must appear verbatim in loginLandingSlide3Title
  ///
  /// In en, this message translates to:
  /// **'track every franc'**
  String get loginLandingSlide3Highlight;

  /// No description provided for @loginLandingSlide3Text.
  ///
  /// In en, this message translates to:
  /// **'Accept MoMo, cash, and card. Flipper records every sale and reconciles it for you.'**
  String get loginLandingSlide3Text;

  /// Landing slide title; must contain loginLandingSlide4Highlight verbatim
  ///
  /// In en, this message translates to:
  /// **'Grow your business,\nearn rewards'**
  String get loginLandingSlide4Title;

  /// Gradient-highlighted words; must appear verbatim in loginLandingSlide4Title
  ///
  /// In en, this message translates to:
  /// **'earn rewards'**
  String get loginLandingSlide4Highlight;

  /// No description provided for @loginLandingSlide4Text.
  ///
  /// In en, this message translates to:
  /// **'Hit daily goals, keep your streak alive, and level up from Bronze to Gold Seller.'**
  String get loginLandingSlide4Text;

  /// No description provided for @loginLandingSemantic.
  ///
  /// In en, this message translates to:
  /// **'Flipper landing'**
  String get loginLandingSemantic;

  /// No description provided for @loginNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get loginNext;

  /// No description provided for @loginSkipIntroSemantic.
  ///
  /// In en, this message translates to:
  /// **'Skip intro and create account'**
  String get loginSkipIntroSemantic;

  /// No description provided for @loginSkipIntro.
  ///
  /// In en, this message translates to:
  /// **'Skip intro - Create account'**
  String get loginSkipIntro;

  /// No description provided for @loginAlreadySellingSignIn.
  ///
  /// In en, this message translates to:
  /// **'Already selling on Flipper? Sign in'**
  String get loginAlreadySellingSignIn;

  /// No description provided for @loginDailyReport.
  ///
  /// In en, this message translates to:
  /// **'Daily report'**
  String get loginDailyReport;

  /// No description provided for @loginStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get loginStock;

  /// No description provided for @loginTax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get loginTax;

  /// No description provided for @loginGoldSeller.
  ///
  /// In en, this message translates to:
  /// **'Gold Seller'**
  String get loginGoldSeller;

  /// No description provided for @loginFinalizingAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Finalizing authentication...'**
  String get loginFinalizingAuthentication;

  /// No description provided for @loginAuthTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Authentication timed out. Please try again.'**
  String get loginAuthTimedOut;

  /// No description provided for @loginPhoneLoginNavigationFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to navigate to phone login'**
  String get loginPhoneLoginNavigationFailed;

  /// No description provided for @loginSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed'**
  String get loginSignInFailed;

  /// No description provided for @loginAuthenticationFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get loginAuthenticationFailed;

  /// No description provided for @loginUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get loginUnexpectedError;

  /// No description provided for @loginAuthDomainUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Authentication domain not authorized. Please contact support.'**
  String get loginAuthDomainUnauthorized;

  /// No description provided for @loginAccountDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get loginAccountDisabled;

  /// No description provided for @loginAccountExistsDifferentCredential.
  ///
  /// In en, this message translates to:
  /// **'An account already exists with the same email address but different sign-in credentials.'**
  String get loginAccountExistsDifferentCredential;

  /// No description provided for @loginMicrosoftFailedWithReason.
  ///
  /// In en, this message translates to:
  /// **'Microsoft login failed: {error}'**
  String loginMicrosoftFailedWithReason(String error);

  /// No description provided for @loginMicrosoftFailed.
  ///
  /// In en, this message translates to:
  /// **'Microsoft login failed. Please try again later.'**
  String get loginMicrosoftFailed;

  /// No description provided for @loginAppleAuthorizationFailed.
  ///
  /// In en, this message translates to:
  /// **'Apple authorization failed: {error}'**
  String loginAppleAuthorizationFailed(String error);

  /// No description provided for @loginAppleFailed.
  ///
  /// In en, this message translates to:
  /// **'Apple login failed: {error}'**
  String loginAppleFailed(String error);

  /// No description provided for @loginWelcomeToFlipper.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Flipper'**
  String get loginWelcomeToFlipper;

  /// No description provided for @loginHowToSignIn.
  ///
  /// In en, this message translates to:
  /// **'How would you like to sign in?'**
  String get loginHowToSignIn;

  /// No description provided for @loginLoggingIn.
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get loginLoggingIn;

  /// No description provided for @loginTryAgainOrUsePin.
  ///
  /// In en, this message translates to:
  /// **'Please try again or use PIN login'**
  String get loginTryAgainOrUsePin;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessful;

  /// No description provided for @loginQrScanned.
  ///
  /// In en, this message translates to:
  /// **'QR Code scanned! Completing login...'**
  String get loginQrScanned;

  /// No description provided for @loginFailedTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get loginFailedTryAgain;

  /// No description provided for @loginSuccessfulRedirecting.
  ///
  /// In en, this message translates to:
  /// **'Login successful! Redirecting...'**
  String get loginSuccessfulRedirecting;

  /// No description provided for @loginQrTitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to Flipper by QR Code'**
  String get loginQrTitle;

  /// No description provided for @loginQrStep1.
  ///
  /// In en, this message translates to:
  /// **'1. Open Flipper on your phone'**
  String get loginQrStep1;

  /// No description provided for @loginQrStep2.
  ///
  /// In en, this message translates to:
  /// **'2. Go to Profile Icon > LongPress on it.'**
  String get loginQrStep2;

  /// No description provided for @loginQrStep3.
  ///
  /// In en, this message translates to:
  /// **'3. Point your phone at this screen to confirm login'**
  String get loginQrStep3;

  /// No description provided for @loginDownloadApp.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have the Flipper app? Download it:'**
  String get loginDownloadApp;

  /// No description provided for @loginOpeningAppStore.
  ///
  /// In en, this message translates to:
  /// **'Opening App Store...'**
  String get loginOpeningAppStore;

  /// No description provided for @loginOpeningPlayStore.
  ///
  /// In en, this message translates to:
  /// **'Opening Play Store...'**
  String get loginOpeningPlayStore;

  /// No description provided for @loginSwitchToPin.
  ///
  /// In en, this message translates to:
  /// **'Switch to PIN login'**
  String get loginSwitchToPin;

  /// No description provided for @loginDeviceOffline.
  ///
  /// In en, this message translates to:
  /// **'Device is offline'**
  String get loginDeviceOffline;

  /// No description provided for @loginInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email'**
  String get loginInvalidEmail;

  /// No description provided for @loginGmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Gmail Email is required'**
  String get loginGmailRequired;

  /// No description provided for @loginEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get loginEnterEmail;

  /// No description provided for @loginAddEmailHint.
  ///
  /// In en, this message translates to:
  /// **'After entering your email, click on add email'**
  String get loginAddEmailHint;

  /// No description provided for @signupErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during signup'**
  String get signupErrorGeneric;

  /// No description provided for @signupOtpExpiredOrInvalid.
  ///
  /// In en, this message translates to:
  /// **'OTP expired or invalid. Please request a new code.'**
  String get signupOtpExpiredOrInvalid;

  /// No description provided for @signupResendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get signupResendOtp;

  /// No description provided for @signupNewOtpSent.
  ///
  /// In en, this message translates to:
  /// **'New OTP sent successfully!'**
  String get signupNewOtpSent;

  /// No description provided for @signupFailedToResendOtp.
  ///
  /// In en, this message translates to:
  /// **'Failed to resend OTP: {error}'**
  String signupFailedToResendOtp(String error);

  /// No description provided for @signupUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get signupUsername;

  /// No description provided for @signupUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get signupUsernameHint;

  /// No description provided for @signupFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get signupFullName;

  /// No description provided for @signupFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'First name, Last name'**
  String get signupFullNameHint;

  /// No description provided for @signupPhoneOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Phone / Email'**
  String get signupPhoneOrEmail;

  /// No description provided for @signupPhoneOrEmailHint.
  ///
  /// In en, this message translates to:
  /// **'783054874 or your@email.com'**
  String get signupPhoneOrEmailHint;

  /// No description provided for @signupOtpResent.
  ///
  /// In en, this message translates to:
  /// **'OTP resent successfully!'**
  String get signupOtpResent;

  /// No description provided for @signupResend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get signupResend;

  /// No description provided for @signupOtpSent.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully!'**
  String get signupOtpSent;

  /// No description provided for @signupFailedToSendOtp.
  ///
  /// In en, this message translates to:
  /// **'Failed to send OTP: {error}'**
  String signupFailedToSendOtp(String error);

  /// No description provided for @signupSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get signupSendCode;

  /// No description provided for @signupOtpCode.
  ///
  /// In en, this message translates to:
  /// **'OTP Code'**
  String get signupOtpCode;

  /// No description provided for @signupOtpHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit OTP'**
  String get signupOtpHint;

  /// No description provided for @signupPhoneVerified.
  ///
  /// In en, this message translates to:
  /// **'Phone number verified successfully!'**
  String get signupPhoneVerified;

  /// Signup field label for the business type / how the app will be used
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get signupUsage;

  /// No description provided for @signupCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get signupCountry;

  /// No description provided for @signupSearchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search your country'**
  String get signupSearchCountry;

  /// No description provided for @signupStepIdentity.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get signupStepIdentity;

  /// No description provided for @signupStepVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get signupStepVerify;

  /// No description provided for @signupStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String signupStepOf(String step, String total);

  /// No description provided for @signupRewardTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish setup to unlock 500 points'**
  String get signupRewardTitle;

  /// No description provided for @signupRewardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Spend points on lower fees & premium reports'**
  String get signupRewardSubtitle;

  /// No description provided for @signupStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Who are you?'**
  String get signupStep1Title;

  /// No description provided for @signupStep1Description.
  ///
  /// In en, this message translates to:
  /// **'This is how you’ll sign in and how teammates find you.'**
  String get signupStep1Description;

  /// No description provided for @signupStep2Title.
  ///
  /// In en, this message translates to:
  /// **'How do we reach you?'**
  String get signupStep2Title;

  /// No description provided for @signupStep2Description.
  ///
  /// In en, this message translates to:
  /// **'We’ll send a one-time code to verify it’s really you.'**
  String get signupStep2Description;

  /// No description provided for @signupStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your shop'**
  String get signupStep3Title;

  /// No description provided for @signupStep3Description.
  ///
  /// In en, this message translates to:
  /// **'We’ll tailor Flipper to how you sell.'**
  String get signupStep3Description;

  /// No description provided for @signupCreateAccountClaim.
  ///
  /// In en, this message translates to:
  /// **'Create account · claim 500 pts'**
  String get signupCreateAccountClaim;

  /// {terms} and {privacy} are rendered as highlighted links (signupTermsLink, signupPrivacyLink)
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to Flipper’s {terms} & {privacy}'**
  String signupTermsAgreement(String terms, String privacy);

  /// No description provided for @signupTermsLink.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get signupTermsLink;

  /// No description provided for @signupPrivacyLink.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get signupPrivacyLink;

  /// No description provided for @signupVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get signupVerificationFailed;

  /// No description provided for @signupNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name is too long'**
  String get signupNameTooLong;

  /// No description provided for @signupContactRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number or email is required'**
  String get signupContactRequired;

  /// No description provided for @signupContactInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number or email address'**
  String get signupContactInvalid;

  /// No description provided for @signupUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username/business name is required'**
  String get signupUsernameRequired;

  /// No description provided for @signupUsernameTaken.
  ///
  /// In en, this message translates to:
  /// **'That username is already taken'**
  String get signupUsernameTaken;

  /// No description provided for @signupUsernameCheckUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Name search not available'**
  String get signupUsernameCheckUnavailable;

  /// No description provided for @signupOtpMustBe6Digits.
  ///
  /// In en, this message translates to:
  /// **'OTP must be 6 digits'**
  String get signupOtpMustBe6Digits;

  /// No description provided for @signupOtpDigitsOnly.
  ///
  /// In en, this message translates to:
  /// **'OTP must contain only digits'**
  String get signupOtpDigitsOnly;

  /// No description provided for @signupValidateTin.
  ///
  /// In en, this message translates to:
  /// **'Please validate TIN'**
  String get signupValidateTin;

  /// No description provided for @signupPhoneMustBeVerified.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be verified'**
  String get signupPhoneMustBeVerified;

  /// No description provided for @signupFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get signupFieldRequired;

  /// No description provided for @signupSelectOption.
  ///
  /// In en, this message translates to:
  /// **'Please select an option'**
  String get signupSelectOption;

  /// No description provided for @signupJoinFlipper.
  ///
  /// In en, this message translates to:
  /// **'Join Flipper'**
  String get signupJoinFlipper;

  /// No description provided for @signupJourneyTagline.
  ///
  /// In en, this message translates to:
  /// **'Start your journey with us today 🚀'**
  String get signupJourneyTagline;

  /// No description provided for @signupNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get signupNoMatches;

  /// No description provided for @signupTinExtractFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not extract TIN from the provided document'**
  String get signupTinExtractFailed;

  /// No description provided for @signupTinPdfError.
  ///
  /// In en, this message translates to:
  /// **'Error processing PDF: {error}'**
  String signupTinPdfError(String error);

  /// No description provided for @signupTinValidated.
  ///
  /// In en, this message translates to:
  /// **'TIN validated: {name}'**
  String signupTinValidated(String name);

  /// No description provided for @signupTinNoData.
  ///
  /// In en, this message translates to:
  /// **'No data found for this TIN'**
  String get signupTinNoData;

  /// No description provided for @signupTinServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Service Unavailable: Validation skipped'**
  String get signupTinServiceUnavailable;

  /// No description provided for @signupTinValidationError.
  ///
  /// In en, this message translates to:
  /// **'Error validating TIN: {error}'**
  String signupTinValidationError(String error);

  /// No description provided for @phoneAuthSelectCountryTitle.
  ///
  /// In en, this message translates to:
  /// **'Select the country where your business is located'**
  String get phoneAuthSelectCountryTitle;

  /// No description provided for @phoneAuthSearchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search country...'**
  String get phoneAuthSearchCountry;

  /// No description provided for @phoneAuthAgreeSellerAgreement.
  ///
  /// In en, this message translates to:
  /// **'I agree to Flipper\'s Seller Agreement and Privacy Policy.'**
  String get phoneAuthAgreeSellerAgreement;

  /// No description provided for @phoneAuthRecaptchaNotice.
  ///
  /// In en, this message translates to:
  /// **'This app is protected by reCAPTCHA Enterprise and Google Privacy Policy and Terms of Service apply.'**
  String get phoneAuthRecaptchaNotice;

  /// No description provided for @phoneAuthEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get phoneAuthEnterPhone;

  /// No description provided for @phoneAuthInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get phoneAuthInvalidPhone;

  /// No description provided for @phoneAuthTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone Verification'**
  String get phoneAuthTitle;

  /// No description provided for @phoneAuthSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a verification code to your phone number to verify your identity.'**
  String get phoneAuthSubtitle;

  /// No description provided for @phoneAuthPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'783054874 (without leading 0)'**
  String get phoneAuthPhoneHint;

  /// {terms} and {privacy} are rendered as tappable links (phoneAuthTermsOfService, phoneAuthPrivacyPolicy)
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our {terms} and {privacy}'**
  String phoneAuthTermsAgreement(String terms, String privacy);

  /// No description provided for @phoneAuthTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get phoneAuthTermsOfService;

  /// No description provided for @phoneAuthPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get phoneAuthPrivacyPolicy;

  /// No description provided for @phoneAuthVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get phoneAuthVerificationCode;

  /// No description provided for @phoneAuthChangeNumber.
  ///
  /// In en, this message translates to:
  /// **'Change Phone Number'**
  String get phoneAuthChangeNumber;

  /// No description provided for @phoneAuthVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed: {error}'**
  String phoneAuthVerificationFailed(String error);

  /// No description provided for @phoneAuthUnknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get phoneAuthUnknownError;

  /// No description provided for @phoneAuthErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String phoneAuthErrorOccurred(String error);

  /// No description provided for @phoneAuthNewCodeSent.
  ///
  /// In en, this message translates to:
  /// **'New verification code sent'**
  String get phoneAuthNewCodeSent;

  /// No description provided for @phoneAuthEnterValidCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 6-digit code'**
  String get phoneAuthEnterValidCode;

  /// No description provided for @phoneAuthCodeExpired.
  ///
  /// In en, this message translates to:
  /// **'This verification code has expired. Please request a new one.'**
  String get phoneAuthCodeExpired;

  /// No description provided for @phoneAuthFailedToVerify.
  ///
  /// In en, this message translates to:
  /// **'Failed to verify code: {error}'**
  String phoneAuthFailedToVerify(String error);

  /// No description provided for @phoneAuthAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed: {error}'**
  String phoneAuthAuthFailed(String error);

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;
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
