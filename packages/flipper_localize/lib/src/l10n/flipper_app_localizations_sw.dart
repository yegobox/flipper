// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'flipper_app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class FlipperAppLocalizationsSw extends FlipperAppLocalizations {
  FlipperAppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get save => 'Hifadhi';

  @override
  String get retailPrice => 'Bei';

  @override
  String get supplyPrice => 'Bei ya mzabuni';

  @override
  String get currentSale => 'Mauzo ya sasa';

  @override
  String get currentStock => 'Hisa ya sasa';

  @override
  String get addProduct => 'Ongeza bidhaa';

  @override
  String get tickets => 'Tiketi';

  @override
  String get charge => 'Toza';

  @override
  String get productName => 'Jina la bidhaa';

  @override
  String get flipperSetting => 'Mipangilio';

  @override
  String get options => 'Chaguzi';

  @override
  String get saveTicket => 'Hauwezi kuhifadhi tiketi bila kuongeza dokezo';

  @override
  String get productNotFound => 'Bidhaa haijapatikana';

  @override
  String get noPayable => 'Hakuna malipo yanayohitajika';

  @override
  String get delete => 'Futa';

  @override
  String get addTomenu => 'Menyu';

  @override
  String get edit => 'Hariri';

  @override
  String get addWorkSpace => 'Ongeza eneo la kazi';

  @override
  String get addMembers => 'Ongeza wanachama';

  @override
  String get logOut => 'Toka';

  @override
  String get syncCounter => 'Sawazisha kaunta';

  @override
  String get resetTransaction => 'Weka muamala upya';

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
  String get permissionRequired => 'Ruhusa inahitajika';

  @override
  String get contactsPermissionDeniedSettings =>
      'Ruhusa ya anwani imekataliwa kabisa. Tafadhali iwezeshe kwenye mipangilio ya kifaa chako ili kutumia kipengele hiki.';

  @override
  String get cancel => 'Ghairi';

  @override
  String get openSettings => 'Fungua mipangilio';

  @override
  String errorMessage(Object error) {
    return 'Hitilafu: $error';
  }

  @override
  String get error => 'Hitilafu';

  @override
  String get pickFromContacts => 'Chagua kutoka kwa anwani';

  @override
  String get linkDevice => 'Unganisha kifaa';

  @override
  String get useFlipperOnOtherDevices => 'Tumia Flipper kwenye vifaa vingine';

  @override
  String get linkADevice => 'Unganisha kifaa';

  @override
  String pinCode(Object pin) {
    return 'PIN: $pin';
  }

  @override
  String get listOfConnectedDevices => 'Orodha ya vifaa vilivyounganishwa';

  @override
  String paymentTitle(Object paymentType) {
    return 'Malipo: $paymentType';
  }

  @override
  String get digitalReceipt => 'Risiti ya kidijitali';

  @override
  String get needDigitalReceipt => 'Unahitaji risiti ya kidijitali?';

  @override
  String get purchaseCode => 'Kodi ya ununuzi';

  @override
  String get pleaseEnterPurchaseCode => 'Tafadhali weka kodi ya ununuzi';

  @override
  String get submit => 'Tuma';

  @override
  String get done => 'Imekamilika';

  @override
  String get receipt => 'Risiti';

  @override
  String get addNote => 'Ongeza dokezo';

  @override
  String get generatingReceiptWait => 'Tafadhali subiri, tunatengeneza risiti';

  @override
  String get poweredBy => 'Inaendeshwa na';

  @override
  String get returnToHome => 'Rudi mwanzo';

  @override
  String get personalGoals => 'Malengo binafsi';

  @override
  String get selectBranchToManageGoals => 'Chagua tawi ili kusimamia malengo.';

  @override
  String couldNotLoadGoals(Object error) {
    return 'Haikuweza kupakia malengo\n$error';
  }

  @override
  String get personalGoalsEyebrow => 'MALENGO BINAFSI';

  @override
  String totalReservedAcrossGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'malengo $count',
      one: 'lengo 1',
    );
    return 'Jumla iliyowekwa akiba katika $_temp0';
  }

  @override
  String get savedThisMonth => 'Iliyowekwa akiba mwezi huu';

  @override
  String onTrackCount(Object count) {
    return '$count yanaendelea vizuri';
  }

  @override
  String get goalsProgressing => 'Malengo yanaendelea';

  @override
  String get allGoals => 'Malengo yote';

  @override
  String get personalGoalsProfitGrowth =>
      'Flipper hukuza kila lengo kimya kimya kutoka kwa faida yako.';

  @override
  String get searchProducts => 'Tafuta bidhaa…';

  @override
  String get clearSelection => 'Ondoa uteuzi';

  @override
  String itemsSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'bidhaa $count zimechaguliwa',
      one: 'bidhaa 1 imechaguliwa',
    );
    return '$_temp0';
  }

  @override
  String get cannotDeleteVariantWithStockRemaining =>
      'Haiwezi kufuta bidhaa ambayo bado ina hisa.';

  @override
  String get deleteMultipleItems => 'Futa bidhaa nyingi';

  @override
  String deleteItemsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'bidhaa $count',
      one: 'bidhaa 1',
    );
    return 'Una hakika unataka kufuta $_temp0? Kitendo hiki hakiwezi kutenduliwa.';
  }

  @override
  String get refreshProducts => 'Onyesha bidhaa upya';

  @override
  String get productsSyncingHint =>
      'Ikiwa umefungua programu hivi punde, bidhaa zinaweza kuwa bado zinasawazishwa — gusa onyesha upya.';

  @override
  String get errorLoadingProducts => 'Hitilafu wakati wa kupakia bidhaa';

  @override
  String get retry => 'Jaribu tena';

  @override
  String get noStockDataAvailable => 'Hakuna data ya hisa inayopatikana';

  @override
  String get cash => 'Fedha taslimu';

  @override
  String get credit => 'Mkopo';

  @override
  String get momoPayerPhone => 'Simu ya mlipaji wa MoMo';

  @override
  String get momoPaymentRequestHint =>
      'Tutatuma ombi la malipo kwa nambari hii utakapogusa Toza.';

  @override
  String get exact => 'Kamili';

  @override
  String get confirm => 'Thibitisha';

  @override
  String get numberOfPayments => 'Idadi ya malipo';

  @override
  String get applyDiscountCode => 'Tumia kodi ya punguzo';

  @override
  String get discountCode => 'Kodi ya punguzo';

  @override
  String get validatingCode => 'Tunathibitisha kodi...';

  @override
  String get createAccount => 'Fungua akaunti';

  @override
  String get signIn => 'INGIA';

  @override
  String get setDeviceTimeAutomatic =>
      'Tafadhali weka saa ya kifaa chako kwa hali ya kiotomatiki';

  @override
  String get continueWithPhone => 'Endelea na simu';

  @override
  String get continueWithGoogle => 'Endelea na Google';

  @override
  String get continueWithMicrosoft => 'Endelea na Microsoft';

  @override
  String get continueWithApple => 'Endelea na Apple';

  @override
  String get or => 'AU';

  @override
  String get pinLogin => 'Ingia kwa PIN';

  @override
  String get languagesTitle => 'Lugha';

  @override
  String get english => 'Kiingereza';

  @override
  String get kinyarwanda => 'Kinyarwanda';

  @override
  String get swahili => 'Kiswahili';

  @override
  String get settings => 'Mipangilio';

  @override
  String get home => 'Mwanzo';

  @override
  String get sales => 'Mauzo';

  @override
  String get inventory => 'Hisa';

  @override
  String get more => 'Zaidi';

  @override
  String get scanQr => 'Changanua QR';

  @override
  String get dashboard => 'Dashibodi';

  @override
  String get noUser => 'Hakuna mtumiaji';

  @override
  String get pleaseLogInToContinue => 'Tafadhali ingia ili kuendelea';

  @override
  String get loadingBusinesses => 'Tunapakia biashara...';

  @override
  String get errorLoadingBusinesses => 'Hitilafu wakati wa kupakia biashara';

  @override
  String get noBusinesses => 'Hakuna biashara';

  @override
  String get createFirstBusiness => 'Fungua biashara yako ya kwanza ili kuanza';

  @override
  String get signOut => 'Toka';

  @override
  String get phoneNumber => 'Nambari ya simu';

  @override
  String get sendingCode => 'Tunatuma kodi...';

  @override
  String get continueAction => 'Endelea';

  @override
  String get enterSixDigitCodeSentTo =>
      'Weka kodi ya tarakimu 6 iliyotumwa kwa ';

  @override
  String get codeExpiredTapToResend =>
      'Kodi imeisha muda - Gusa ili kutuma tena';

  @override
  String get resendCode => 'Tuma kodi tena';

  @override
  String get resendCodeIn => 'Tuma kodi tena baada ya ';

  @override
  String get seconds => 'sekunde';

  @override
  String get verifying => 'Tunathibitisha...';

  @override
  String get verifyCode => 'Thibitisha kodi';

  @override
  String get troubleSigningIn => 'Una tatizo la kuingia?';

  @override
  String get troubleSigningInHelp =>
      'Ikiwa una tatizo la kuingia, hakikisha PIN yako na OTP (ikiwa inahitajika) ni sahihi.\n\nKwa msaada zaidi, tafadhali wasiliana na timu ya usaidizi.';

  @override
  String get ok => 'Sawa';

  @override
  String get welcomeBack => 'Karibu tena';

  @override
  String get tinNumber => 'Nambari ya TIN';

  @override
  String get validate => 'Thibitisha';

  @override
  String get uploadPdfWithTin => 'Pakia PDF yenye TIN';

  @override
  String get enterTinOrUpload =>
      'Weka nambari ya TIN au gusa aikoni ya kupakia';

  @override
  String get addEmail => 'Ongeza barua pepe';

  @override
  String get emailAdded => 'Barua pepe imeongezwa';

  @override
  String get updateSettings => 'Sasisha mipangilio';

  @override
  String get invite => 'Karibisha';

  @override
  String get sendRequest => 'Tuma ombi';

  @override
  String get preferences => 'Mapendeleo';

  @override
  String get accessibility => 'Ufikivu';

  @override
  String get language => 'Lugha';

  @override
  String get reports => 'Ripoti';

  @override
  String get enableReport => 'Wezesha ripoti';

  @override
  String get backups => 'Nakala rudufu';

  @override
  String get addBackup => 'Ongeza nakala rudufu';

  @override
  String get restoreData => 'Rejesha data';

  @override
  String get dataRestored => 'Data imerejeshwa';

  @override
  String get errorRestoringBackup =>
      'Hitilafu wakati wa kurejesha nakala rudufu';

  @override
  String get transactionIdCopiedToClipboard =>
      'Kitambulisho cha muamala kimenakiliwa';

  @override
  String get transactionIdShortLabel => 'Kitambulisho: ';

  @override
  String get invoiceNumberLabel => 'Nambari ya ankara: ';

  @override
  String get parkSaleAsTicket => 'Hifadhi mauzo haya kama tiketi';

  @override
  String get saveTicketAction => 'Hifadhi tiketi';

  @override
  String get remainingBalanceLabel => 'Salio lililobaki: ';

  @override
  String get amountToChangeLabel => 'Kiasi cha kurudisha: ';

  @override
  String get allApps => 'Programu zote';

  @override
  String get sell => 'Uza';

  @override
  String get quickSell => 'Uza haraka';

  @override
  String get invoices => 'Ankara';

  @override
  String get pricing => 'Bei';

  @override
  String get payments => 'Malipo';

  @override
  String get manage => 'Simamia';

  @override
  String get purchases => 'Manunuzi';

  @override
  String get customers => 'Wateja';

  @override
  String get leads => 'Wateja watarajiwa';

  @override
  String get insights => 'Uchanganuzi';

  @override
  String get dailyReports => 'Ripoti za kila siku';

  @override
  String get commissions => 'Kamisheni';

  @override
  String get production => 'Uzalishaji';

  @override
  String get business => 'Biashara';

  @override
  String get servicesHub => 'Kituo cha huduma';

  @override
  String get goals => 'Malengo';

  @override
  String get aiChat => 'Mazungumzo ya AI';

  @override
  String get errorLoadingTransactionView =>
      'Hitilafu wakati wa kupakia muamala';

  @override
  String get customer => 'Mteja';

  @override
  String get payment => 'Malipo';

  @override
  String get delivery => 'Uwasilishaji';

  @override
  String get transactionSummary => 'Muhtasari wa muamala';

  @override
  String get transactionSummaryHint =>
      'Huonyesha kiasi jumla na kitambulisho cha muamala wa sasa';

  @override
  String get totalAmount => 'Kiasi jumla';

  @override
  String get cannotDeletePartialPaymentItems =>
      'Haiwezi kufuta bidhaa kutoka muamala wenye malipo ya sehemu';

  @override
  String get deleteAllItems => 'Futa bidhaa zote';

  @override
  String get confirmRemoveAllTransactionItems =>
      'Una hakika unataka kuondoa bidhaa zote kutoka muamala huu?';

  @override
  String plusMoreItems(int count) {
    return '+$count zaidi';
  }

  @override
  String get actionCannotBeUndone => 'Kitendo hiki hakiwezi kutenduliwa.';

  @override
  String get deleteAll => 'Futa zote';

  @override
  String get allItemsRemovedSuccessfully =>
      'Bidhaa zote zimeondolewa kwa mafanikio';

  @override
  String errorRemovingItems(String error) {
    return 'Hitilafu wakati wa kuondoa bidhaa: $error';
  }

  @override
  String get noItemsAdded => 'Hakuna bidhaa iliyoongezwa';

  @override
  String get tapAddFirstItem =>
      'Gusa kitufe cha + ili kuongeza bidhaa yako ya kwanza';

  @override
  String cartItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'bidhaa $count',
      one: 'bidhaa 1',
    );
    return '$_temp0';
  }

  @override
  String itemSemanticLabel(String itemName) {
    return 'Bidhaa: $itemName';
  }

  @override
  String cartItemSemanticHint(
    String quantity,
    String unitPrice,
    String subtotal,
  ) {
    return 'Kiasi: $quantity, Bei ya kimoja: $unitPrice, Jumla ndogo: $subtotal';
  }

  @override
  String get removeItem => 'Ondoa bidhaa';

  @override
  String get unitPrice => 'Bei ya kimoja';

  @override
  String get decreaseQuantityByOne => 'Punguza kiasi kwa 1';

  @override
  String get increaseQuantityByOne => 'Ongeza kiasi kwa 1';

  @override
  String get subtotal => 'Jumla ndogo';

  @override
  String get deliveryDate => 'Tarehe ya uwasilishaji';

  @override
  String get transactionSummaryPaymentActions =>
      'Muhtasari wa muamala na hatua za malipo';

  @override
  String completeSaleTotalHint(String total) {
    return 'Kamilisha mauzo kwa kiasi jumla $total';
  }

  @override
  String errorWithValue(String error) {
    return 'Hitilafu: $error';
  }

  @override
  String confirmRemoveItemFromTransaction(String itemName) {
    return 'Una hakika unataka kuondoa \"$itemName\" kutoka muamala huu?';
  }

  @override
  String get remove => 'Ondoa';

  @override
  String get cannotModifyPartialPaymentItems =>
      'Haiwezi kubadilisha bidhaa katika muamala wenye malipo ya sehemu';

  @override
  String get failedToRemoveItem => 'Imeshindwa kuondoa bidhaa';

  @override
  String get failedToUpdateItemQuantity =>
      'Imeshindwa kusasisha kiasi cha bidhaa';

  @override
  String get transactionItemsList => 'Orodha ya bidhaa za muamala';

  @override
  String get transactionItemsListHint =>
      'Orodha ya bidhaa katika muamala wa sasa pamoja na kiasi na bei';

  @override
  String get deliveryNote => 'Dokezo la uwasilishaji';

  @override
  String get deliveryNoteSemantic => 'Dokezo la uwasilishaji';

  @override
  String get deliveryNoteHint => 'Ongeza maelekezo maalum ya uwasilishaji';

  @override
  String get deliveryInstructionsHint =>
      'Weka maelekezo maalum ya uwasilishaji';

  @override
  String get discount => 'Punguzo';

  @override
  String get pleaseEnterValidNumber => 'Tafadhali weka nambari sahihi';

  @override
  String get discountRangeError => 'Punguzo linapaswa kuwa kati ya 0 na 100';

  @override
  String get digitalReceiptTitle => 'Risiti ya kidijitali';

  @override
  String get digitalReceiptSmsSubtitle =>
      'Tuma risiti kwa SMS badala ya kufungua PDF';

  @override
  String receivedAmountInCurrency(String currency) {
    return 'Kiasi kilichopokelewa kwa $currency';
  }

  @override
  String get receivedAmountHint =>
      'Weka kiasi kilichopokelewa kutoka kwa mteja';

  @override
  String get receivedAmount => 'Kiasi kilichopokelewa';

  @override
  String get pleaseEnterReceivedAmount =>
      'Tafadhali weka kiasi kilichopokelewa';

  @override
  String get customerName => 'Jina la mteja';

  @override
  String get customerNameHint => 'Weka jina kamili la mteja';

  @override
  String get pleaseEnterCustomerName => 'Tafadhali weka jina la mteja';

  @override
  String get customerPhoneNumber => 'Nambari ya simu ya mteja';

  @override
  String get customerPhoneNumberHint =>
      'Weka nambari ya simu ya mteja kwa mawasiliano na malipo';

  @override
  String get items => 'Bidhaa';

  @override
  String get transactionId => 'Kitambulisho cha muamala';

  @override
  String get amountPaid => 'Kiasi kilicholipwa';

  @override
  String get remainingBalance => 'Salio lililobaki';

  @override
  String recordPaymentWithAmount(String amount) {
    return 'Rekodi malipo • $amount';
  }

  @override
  String payWithAmount(String amount) {
    return 'Lipa • $amount';
  }

  @override
  String sendForReviewWithAmount(String amount) {
    return 'Tuma kwa ukaguzi • $amount';
  }

  @override
  String get phoneRequiredWhenTinMissing =>
      'Nambari ya simu inahitajika ikiwa TIN ya mteja haipatikani';

  @override
  String get invalidNumber => 'Nambari si sahihi';

  @override
  String get back => 'Rudi';

  @override
  String get managementDashboard => 'Dashibodi ya usimamizi';

  @override
  String get quickActions => 'Hatua za haraka';

  @override
  String get posDefault => 'POS chaguo-msingi';

  @override
  String get setPosAsDefaultApp => 'Weka POS kama programu chaguo-msingi';

  @override
  String get ordersDefault => 'Oda chaguo-msingi';

  @override
  String get setOrdersAsDefaultApp => 'Weka Oda kama programu chaguo-msingi';

  @override
  String get accountManagement => 'Usimamizi wa akaunti';

  @override
  String get userManagement => 'Usimamizi wa watumiaji';

  @override
  String get manageUsersAndPermissions => 'Simamia watumiaji na ruhusa';

  @override
  String get branchManagement => 'Usimamizi wa matawi';

  @override
  String get manageBranchLocations => 'Simamia matawi (maeneo)';

  @override
  String get financialControls => 'Udhibiti wa fedha';

  @override
  String get taxSettings => 'Mipangilio ya kodi';

  @override
  String get configureTaxRulesAndRates => 'Sanidi kanuni na viwango vya kodi';

  @override
  String get ebmSettings => 'Mipangilio ya EBM';

  @override
  String get electronicBillingMachineSettings =>
      'Mipangilio ya mashine ya ankara ya kielektroniki';

  @override
  String get smsConfiguration => 'Usanidi wa SMS';

  @override
  String get enableSmsNotifications => 'Wezesha arifa za SMS';

  @override
  String get enableWhatsappNotifications => 'Wezesha arifa za WhatsApp';

  @override
  String get receiveWhatsappNotificationsForOrders =>
      'Pokea arifa za WhatsApp kwa oda na risiti za PDF';

  @override
  String get systemSettings => 'Mipangilio ya mfumo';

  @override
  String get debugMode => 'Hali ya utatuzi';

  @override
  String get enableDebugFeatures => 'Wezesha vipengele vya utatuzi';

  @override
  String get forceUpdate => 'Lazimisha usasishaji';

  @override
  String get forceUpdateAllData => 'Lazimisha usasishaji wa data yote';

  @override
  String get taxService => 'Huduma ya kodi';

  @override
  String get toggleTaxService => 'Badilisha huduma ya kodi';

  @override
  String get savedDiscount => 'Punguzo lililohifadhiwa';

  @override
  String get createDiscount => 'Unda punguzo';

  @override
  String get nameCannotBeNull => 'Jina haliwezi kuwa tupu';

  @override
  String get amountCannotBeNull => 'Kiasi hakiwezi kuwa tupu';

  @override
  String get name => 'Jina';

  @override
  String saveTransactionTitle(String transactionType) {
    return 'Hifadhi muamala wa $transactionType';
  }

  @override
  String get confirmSaveTransaction =>
      'Una hakika unataka kuhifadhi muamala huu?';

  @override
  String get categoryMustBeSelected => 'Kundi linapaswa kuchaguliwa';

  @override
  String get confirmLogout => 'Thibitisha kutoka';

  @override
  String get confirmLogoutMessage => 'Una hakika unataka kutoka?';

  @override
  String get refundReason => 'Sababu ya kurejesha fedha';

  @override
  String get waitForApproval => 'Subiri idhini';

  @override
  String get approved => 'Imeidhinishwa';

  @override
  String get cancelRequested => 'Ombi la kughairi';

  @override
  String get canceled => 'Imeghairiwa';

  @override
  String get refunded => 'Fedha imerejeshwa';

  @override
  String get transferred => 'Imehamishwa';

  @override
  String get appLanguage => 'Lugha ya programu';

  @override
  String get chooseAppLanguage => 'Chagua lugha ambayo Flipper inatumia';

  @override
  String get selectLanguage => 'Chagua lugha';

  @override
  String get languageAppliesEverywhere =>
      'Inatumika kwa kila skrini ya programu.';

  @override
  String get useDeviceLanguage => 'Tumia lugha ya kifaa';

  @override
  String get automatic => 'Kiotomatiki';

  @override
  String get french => 'Kifaransa';

  @override
  String get accountAndFinancial => 'Akaunti na fedha';

  @override
  String get adminProfile => 'Wasifu wa msimamizi';

  @override
  String get smsNotifications => 'Arifa za SMS';

  @override
  String get close => 'Funga';

  @override
  String get refresh => 'Onyesha upya';

  @override
  String get adminEmailHint => 'mfano: admin@flipper.rw';

  @override
  String get displayName => 'Jina la kuonyesha';

  @override
  String get editName => 'Hariri jina';

  @override
  String get paymentMethods => 'Njia za malipo';

  @override
  String get managePaymentOptions => 'Simamia chaguzi za malipo';

  @override
  String get enterPhoneNumber => 'Weka nambari ya simu';

  @override
  String get enableOrderNotifications => 'Wezesha arifa za oda';

  @override
  String get receiveSmsNotificationsForOrders => 'Pokea arifa za SMS kwa oda';

  @override
  String get enableDebuggingFeatures => 'Wezesha vipengele vya utatuzi';

  @override
  String get ebm => 'EBM';

  @override
  String get reinitializeEbm => 'Anzisha EBM upya';

  @override
  String get manageTaxServiceStatus => 'Simamia hali ya huduma ya kodi';

  @override
  String get hydrateData => 'Pakia data';

  @override
  String get refreshAllLocalData => 'Onyesha upya data yote ya kifaa';

  @override
  String get assetDownload => 'Upakuaji wa picha';

  @override
  String get manageImageDownloads => 'Simamia upakuaji wa picha';

  @override
  String get autoAddSearch => 'Ongeza kiotomatiki';

  @override
  String get autoAddItemsWhenOneMatch =>
      'Ongeza bidhaa kiotomatiki ikiwa moja tu inalingana';

  @override
  String get userLogging => 'Kumbukumbu za watumiaji';

  @override
  String get enableExtensiveUserLogging =>
      'Wezesha kumbukumbu za kina za watumiaji';

  @override
  String get priceQtyAdjustment => 'Kurekebisha bei na kiasi';

  @override
  String get autoAdjustQtyOnPriceChange =>
      'Rekebisha kiasi kiotomatiki bei ikibadilika';

  @override
  String get decimals => 'Desimali';

  @override
  String get enableFractionalPricing => 'Wezesha bei za sehemu';

  @override
  String get ticketReviewAndHandover => 'Ukaguzi na kuhamisha tiketi';

  @override
  String get administratorPin => 'PIN ya msimamizi';

  @override
  String get resetAdministratorPin => 'Weka upya PIN ya msimamizi';

  @override
  String get updateHighSecurityPin =>
      'Sasisha PIN yako ya tarakimu 4 ya usalama wa juu';

  @override
  String get flipperSettingsTitle => 'Mipangilio ya Flipper';

  @override
  String get common => 'Ya kawaida';

  @override
  String get environment => 'Mazingira';

  @override
  String get local => 'Kifaa hiki';

  @override
  String get account => 'Akaunti';

  @override
  String get email => 'Barua pepe';

  @override
  String get security => 'Usalama';

  @override
  String get sendDailyReport => 'Tuma ripoti ya kila siku';

  @override
  String get onlinePrint => 'Uchapishaji mtandaoni';

  @override
  String get managePrintSettings => 'Simamia mipangilio ya uchapishaji';

  @override
  String get enableExtensiveLogging => 'Wezesha kumbukumbu za kina';

  @override
  String get backgroundSync => 'Usawazishaji wa nyuma';

  @override
  String get syncDataInBackground => 'Sawazisha data chinichini';

  @override
  String get closeShift => 'Funga zamu';

  @override
  String get startNewShift => 'Anzisha zamu mpya';

  @override
  String get checkSubscription => 'Angalia usajili';

  @override
  String couldNotCheckSubscription(String error) {
    return 'Haikuweza kuangalia usajili: $error';
  }

  @override
  String get chooseYourDefaultApp => 'Chagua programu yako chaguo-msingi';

  @override
  String get accountSettings => 'Mipangilio ya akaunti';

  @override
  String get switchAccount => 'Badilisha akaunti';

  @override
  String continueToBranch(String branchName) {
    return 'Endelea kwa $branchName';
  }

  @override
  String get openShift => 'Anzisha zamu';

  @override
  String get checkingPaymentStatus => 'Tunaangalia hali ya malipo…';

  @override
  String get refreshAfterCustomerPays => 'Onyesha upya baada ya mteja kulipa';

  @override
  String get branch => 'tawi';

  @override
  String get totalItems => 'Bidhaa zote';

  @override
  String get expiredItems => 'Bidhaa zilizoisha muda';

  @override
  String get lowStockItems => 'Bidhaa zenye hisa ndogo';

  @override
  String get pendingOrders => 'Oda zinazosubiri';

  @override
  String get viewAll => 'Tazama zote';

  @override
  String get idLabel => 'ID';

  @override
  String get item => 'Bidhaa';

  @override
  String get category => 'Kundi';

  @override
  String get quantity => 'Kiasi';

  @override
  String get location => 'Mahali';

  @override
  String get expiredOn => 'Iliisha muda';

  @override
  String get actions => 'Vitendo';

  @override
  String get allExpiredItems => 'Bidhaa zote zilizoisha muda';

  @override
  String get goHomeQuestion => 'Unataka kwenda mwanzo?';

  @override
  String get searchProductsOrScan => 'Tafuta bidhaa au changanua…';

  @override
  String get clear => 'Ondoa';

  @override
  String get addProductAction => 'Ongeza bidhaa';

  @override
  String get help => 'Msaada';

  @override
  String get customerManagement => 'Usimamizi wa wateja';

  @override
  String get searchCustomersByNameOrPhone => 'Tafuta wateja kwa jina au simu';

  @override
  String get clearSearch => 'Ondoa utafutaji';

  @override
  String get add => 'Ongeza';

  @override
  String get editCustomer => 'Hariri mteja';

  @override
  String get deleteCustomer => 'Futa mteja';

  @override
  String get customerActions => 'Vitendo vya mteja';

  @override
  String get phone => 'Simu';

  @override
  String get tin => 'TIN';

  @override
  String get invoice => 'Ankara';

  @override
  String get txnId => 'ID ya muamala';

  @override
  String get addCustomer => 'Ongeza mteja';

  @override
  String get sortDefault => 'Mpangilio wa kawaida';

  @override
  String get sortByPopularity => 'Panga kwa umaarufu';

  @override
  String get sortByAverageRating => 'Panga kwa wastani wa ukadiriaji';

  @override
  String get sortByLatest => 'Panga kwa vipya zaidi';

  @override
  String get sortByPriceLowToHigh => 'Panga kwa bei: chini kwenda juu';

  @override
  String get sortByPriceHighToLow => 'Panga kwa bei: juu kwenda chini';

  @override
  String get sortByStockOut => 'Panga kwa hisa iliyoisha';

  @override
  String get sortByEventDateOldToNew => 'Panga kwa tarehe: kuanzia ya zamani';

  @override
  String get sortByEventDateNewToOld => 'Panga kwa tarehe: kuanzia ya karibuni';

  @override
  String get sortCompactLatest => 'Vipya';

  @override
  String get sortCompactDefault => 'Kawaida';

  @override
  String get sortCompactPopular => 'Maarufu';

  @override
  String get sortCompactRating => 'Ukadiriaji';

  @override
  String get sortCompactPrice => 'Bei';

  @override
  String get sortCompactStockOut => 'Hisa imeisha';

  @override
  String get sortCompactDate => 'Tarehe';

  @override
  String get posStockFilterInStock => 'Zilizopo kwenye hisa';

  @override
  String get posStockFilterOutOfStock => 'Zilizoisha kwenye hisa';

  @override
  String get posStockFilterAll => 'Bidhaa zote';

  @override
  String get posStockFilterNoneInStock => 'Hakuna bidhaa kwenye hisa';

  @override
  String get posStockFilterNoneOutOfStock => 'Hakuna bidhaa zilizoisha';

  @override
  String get posStockFilterEmptyHint =>
      'Tafuta ili kupata bidhaa yoyote, au badilisha kichujio cha hisa.';

  @override
  String get posStockFilterShowAll => 'Onyesha bidhaa zote';

  @override
  String showingRangeOfResults(String start, String end, String total) {
    return 'Inaonyesha $start–$end kati ya $total';
  }

  @override
  String pageOfPages(String current, String total) {
    return 'Ukurasa $current kati ya $total';
  }

  @override
  String loadedOfProducts(String loaded, String total) {
    return 'Bidhaa $loaded kati ya $total';
  }

  @override
  String get noProductsYet => 'Hakuna bidhaa bado';

  @override
  String get noBranchSelected => 'Hakuna tawi lililochaguliwa';

  @override
  String get productsRefreshedForNewBranch =>
      'Bidhaa zimeonyeshwa upya kwa tawi jipya';

  @override
  String deletedItemsCount(int count) {
    return 'Bidhaa $count zimefutwa';
  }

  @override
  String inStockCount(String count) {
    return '$count kwenye hisa';
  }

  @override
  String leftInStockCount(String count) {
    return 'Zimebaki $count kwenye hisa';
  }

  @override
  String get stockLow => 'Chini';

  @override
  String get stockOutBadge => 'Imeisha';

  @override
  String get mode => 'Hali';

  @override
  String get sale => 'Mauzo';

  @override
  String get transfer => 'Kuhamisha';

  @override
  String get searchCustomer => 'Tafuta mteja';

  @override
  String get pay => 'Lipa';

  @override
  String get noItemsYet => 'Hakuna bidhaa bado';

  @override
  String get tapProductToStartSale => 'Gusa bidhaa ili kuanza mauzo';

  @override
  String grandTotalWithItems(String itemLabel) {
    return 'Jumla kuu · $itemLabel';
  }

  @override
  String get defaultPrice => 'Bei ya kawaida';

  @override
  String pricePerUnitEach(String currency, String price) {
    return '$currency $price kila moja';
  }

  @override
  String get deleteItem => 'Futa bidhaa';

  @override
  String get editDetails => 'Hariri maelezo';

  @override
  String get enterQuantity => 'Weka kiasi';

  @override
  String get invalidQuantity => 'Kiasi si sahihi';

  @override
  String get enterPrice => 'Weka bei';

  @override
  String get invalidPrice => 'Bei si sahihi';

  @override
  String get confirmDelete => 'Thibitisha kufuta';

  @override
  String confirmRemoveNamedItem(String itemName) {
    return 'Una hakika unataka kuondoa \"$itemName\"?';
  }

  @override
  String errorDeletingItems(String error) {
    return 'Hitilafu wakati wa kufuta bidhaa: $error';
  }

  @override
  String errorDeletingItem(String error) {
    return 'Hitilafu wakati wa kufuta bidhaa: $error';
  }

  @override
  String get failedToDeleteItem => 'Imeshindwa kufuta bidhaa';

  @override
  String get failedToUpdateItem => 'Imeshindwa kusasisha bidhaa';

  @override
  String skuLabel(String sku) {
    return 'SKU: $sku';
  }

  @override
  String bcdLabel(String barcode) {
    return 'BCD: $barcode';
  }

  @override
  String get split => 'Gawanya';

  @override
  String get splitAcrossAnotherMethod =>
      'Gawanya malipo haya kwa njia nyingine';

  @override
  String get allPaymentTypesInUse =>
      'Njia zote za malipo zinatumika — ondoa moja ili kuongeza nyingine';

  @override
  String get allPaymentTypesAdded =>
      'Njia zote za malipo zimeongezwa. Ondoa moja ili kuongeza nyingine.';

  @override
  String get pleaseEnterAnAmount => 'Tafadhali weka kiasi';

  @override
  String get cashReceived => 'Fedha zilizopokelewa';

  @override
  String get amount => 'Kiasi';

  @override
  String get removeThisPayment => 'Ondoa malipo haya';

  @override
  String get tapSplitToPayWithMoreThanOneMethod =>
      'Gusa Gawanya ili kulipa kwa njia zaidi ya moja';

  @override
  String get tapSplitToAddMethod => 'Gusa Gawanya ili kuongeza njia';

  @override
  String invoiceNumberValue(String number) {
    return 'Na. $number';
  }

  @override
  String tenderedAmount(String amount) {
    return 'Zilizotolewa $amount';
  }

  @override
  String paymentCollectedTotal(String total) {
    return 'Malipo yamekusanywa · $total';
  }

  @override
  String get viewOnlyCannotTransferStock =>
      'Ruhusa ya kutazama tu — hauwezi kuhamisha hisa.';

  @override
  String get selectDestinationBranch => 'Chagua tawi lengwa';

  @override
  String get currentBranchIsMissing => 'Tawi la sasa halipatikani';

  @override
  String get addItemsBeforeTransferring => 'Ongeza bidhaa kabla ya kuhamisha';

  @override
  String transferredItemsToBranch(int count, String branch) {
    return 'Bidhaa $count zimehamishiwa $branch';
  }

  @override
  String get transferFailed => 'Kuhamisha kumeshindwa';

  @override
  String get failedToClearCart => 'Imeshindwa kufuta kikapu';

  @override
  String get paymentsCollectedAtTill =>
      'Malipo yanakusanywa kwenye kaunta. Tuma oda hii ikiwa tayari — meneja atakusanya malipo.';

  @override
  String sentToTillTicket(String reference) {
    return 'Imetumwa kwenye kaunta — Tiketi #$reference';
  }

  @override
  String failedToSendToTill(String error) {
    return 'Imeshindwa kutuma kwenye kaunta: $error';
  }

  @override
  String collectingPaymentForTicket(
    String reference,
    String name,
    String minutes,
  ) {
    return 'Kukusanya malipo ya #$reference · imetumwa na $name · dakika $minutes zilizopita';
  }

  @override
  String get returningEllipsis => 'Tunarudi…';

  @override
  String get backToNewSale => 'Rudi kwa mauzo mapya';

  @override
  String get paymentCashCredit => 'Fedha / Mkopo';

  @override
  String get paymentBankCheck => 'Hundi ya benki';

  @override
  String get paymentDebitCreditCard => 'Kadi ya benki';

  @override
  String get paymentMobileMoney => 'Pesa ya simu';

  @override
  String get paymentMtnMomo => 'MTN MoMo';

  @override
  String get payerNameOptional => 'Jina la mlipaji (si lazima)';

  @override
  String get paidBy => 'Amelipwa na';

  @override
  String get paymentAirtelMoney => 'Airtel Money';

  @override
  String get paymentOther => 'Nyingine';

  @override
  String get sendForReview => 'Tuma kwa ukaguzi';

  @override
  String get previewCart => 'Kagua kikapu';

  @override
  String previewCartWithCount(int count) {
    return 'Kagua kikapu ($count)';
  }

  @override
  String get placeOrder => 'Weka oda';

  @override
  String confirmRemoveAllItemsCount(int count) {
    return 'Una hakika unataka kuondoa bidhaa zote $count kutoka muamala huu?';
  }

  @override
  String get taxServerUnreachableStatus =>
      'Seva ya kodi ya RRA haipatikani — risiti haziwezi kutiwa saini hadi irejee. Tunaangalia upya kiotomatiki.';

  @override
  String get internetUnavailableStatus =>
      'Hakuna muunganisho wa intaneti — mauzo yanaendelea nje ya mtandao na yatasawazishwa utakaporejea mtandaoni.';

  @override
  String get includesVat => 'Imejumuisha VAT';

  @override
  String get chooseDefaultApp => 'Chagua programu chaguo-msingi';

  @override
  String get payShortcutHint => 'Ctrl / ⌘ + Enter kulipa';

  @override
  String get receivedEyebrow => 'Imepokelewa';

  @override
  String get cartEmptyHint =>
      'Gusa bidhaa au changanua msimbopau ili kuanza mauzo';

  @override
  String get branchNotAvailable => 'Tawi halipatikani';

  @override
  String get branchSelectBranch => 'Chagua tawi';

  @override
  String get branchSwitchBranch => 'Badilisha tawi';

  @override
  String get branchUnnamed => 'Tawi lisilo na jina';

  @override
  String get compositeCost => 'Gharama';

  @override
  String notificationsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Arifa $count',
      one: 'Arifa 1',
    );
    return '$_temp0';
  }

  @override
  String get notificationsNew => 'Arifa mpya';

  @override
  String get purchaseCodeErrorTryAgain =>
      'Hitilafu imetokea. Tafadhali jaribu tena.';

  @override
  String get countryOfOriginSelect => 'Chagua nchi ya asili';

  @override
  String get countryOfOriginLoadFailed => 'Imeshindwa kupakia nchi';

  @override
  String get orderStatusPending => 'Inasubiri';

  @override
  String get menuChat => 'Mazungumzo';

  @override
  String get backupConfiguration => 'Usanidi wa nakala rudufu';

  @override
  String get backupEnableAuto => 'Wezesha nakala rudufu ya kiotomatiki';

  @override
  String get dashDismiss => 'Funga';

  @override
  String get favoritesSetProduct => 'Weka bidhaa unayopenda';

  @override
  String dashFieldRequired(String field) {
    return '$field inahitajika';
  }

  @override
  String get supplierSelect => 'Chagua msambazaji';

  @override
  String get searchProductsTransactionsHint => 'Tafuta bidhaa, miamala...';

  @override
  String get compositeItem => 'Bidhaa mchanganyiko';

  @override
  String get branchOrders => 'Oda za matawi';

  @override
  String get rowsPerPage => 'Safu kwa kila ukurasa';

  @override
  String get pleaseEnterANumber => 'Tafadhali weka nambari';

  @override
  String get ordersNoOrders => 'Hakuna oda';

  @override
  String get ordersNoneAtTheMoment => 'Huna oda yoyote kwa sasa.';

  @override
  String get ordersIncomingWillAppear => 'Oda zinazoingia zitaonekana hapa!';

  @override
  String get productTypeSelect => 'Chagua aina ya bidhaa';

  @override
  String get productTypeRawMaterial => 'Malighafi';

  @override
  String get productTypeFinishedProduct => 'Bidhaa iliyokamilika';

  @override
  String get productTypeServiceWithoutStock => 'Huduma bila hisa';

  @override
  String get compositeSkuRequired => 'SKU inahitajika';

  @override
  String get compositeBarcodeRequired => 'Msimbopau unahitajika';

  @override
  String get compositeBarcode => 'Msimbopau';

  @override
  String get tenantRefreshUserList => 'Onyesha upya orodha ya watumiaji';

  @override
  String get categorySearchHint => 'Tafuta makundi...';

  @override
  String get categoryNoneFound => 'Hakuna makundi yaliyopatikana';

  @override
  String get categoryAdd => 'Ongeza kundi';

  @override
  String get stockLevel => 'Kiwango cha hisa';

  @override
  String get stockCurrentValue => 'Thamani ya hisa ya sasa';

  @override
  String get dateSelect => 'Chagua tarehe';

  @override
  String get dateReportPeriod => 'KIPINDI CHA RIPOTI';

  @override
  String get dateApply => 'Tumia';

  @override
  String get dateApplyingRange => 'Inatumia kipindi cha tarehe…';

  @override
  String get posCompleteNow => 'Kamilisha sasa';

  @override
  String get downloadExcelSpreadsheet => 'Lahajedwali ya Excel';

  @override
  String get downloadDownloaded => 'Imepakuliwa';

  @override
  String downloadProgress(String percent) {
    return 'Inapakua: $percent%';
  }

  @override
  String downloadSavedTo(String path) {
    return 'Imepakuliwa kwenye: $path';
  }

  @override
  String get downloadClickToDownload => 'Bofya ili kupakua';

  @override
  String get orderingLoadingProducts => 'Tunapakia bidhaa...';

  @override
  String get searchProductHint => 'Tafuta';

  @override
  String get searchProductAllProducts => 'Bidhaa zote';

  @override
  String get searchProductFavorites => 'Vipendwa';

  @override
  String get refundReasonCustomerRequest => 'Ombi la mteja';

  @override
  String get refundReasonWrongItem => 'Bidhaa isiyo sahihi';

  @override
  String get refundReasonDamaged => 'Imeharibika / ina kasoro';

  @override
  String get refundReasonDuplicateCharge => 'Malipo yaliyorudiwa';

  @override
  String get taxSettingsUpdated =>
      'Mipangilio ya kodi imesasishwa kwa mafanikio';

  @override
  String get taxSettingsUpdateError =>
      'Hitilafu wakati wa kusasisha mipangilio ya kodi';

  @override
  String taxSettingsTaxType(String taxType) {
    return 'Kodi $taxType';
  }

  @override
  String get taxSettingsRequired => 'Inahitajika';

  @override
  String get taxSettingsRange => 'Lazima iwe kati ya 0 na 100';

  @override
  String get taxSettingsNoneFound => 'Hakuna mipangilio ya kodi iliyopatikana';

  @override
  String get cartQtySuffix => 'idadi';

  @override
  String cartPriceQtyEquivalent(String qty, String unitPrice) {
    return 'Sawa na vipande $qty kwa $unitPrice RWF';
  }

  @override
  String get addProductSingleTitle => 'Bidhaa moja';

  @override
  String get addProductSingleSubtitle => 'Ongeza na usanidi bidhaa moja';

  @override
  String get addProductBadgeQuick => 'HARAKA';

  @override
  String get addProductBulkTitle => 'Ongeza kwa wingi';

  @override
  String get addProductBulkSubtitle => 'Leta bidhaa nyingi kwa mara moja';

  @override
  String get addProductBadgeFast => 'KASI';

  @override
  String get addProductRoomsTitle => 'Ongeza vyumba';

  @override
  String get addProductRoomsSubtitle => 'Hoteli na malazi';

  @override
  String get addProductBadgeHotel => 'HOTELI';

  @override
  String get addProductFuelTitle => 'Sawazisha mafuta';

  @override
  String get addProductFuelSubtitle => 'Dizeli na petroli kutoka RRA';

  @override
  String get addProductBadgeFuel => 'MAFUTA';

  @override
  String get addProductChooseHow => 'Chagua jinsi ungependa kuongeza';

  @override
  String scanNoVariantsFor(String query) {
    return 'Hakuna aina zilizopatikana kwa \"$query\"';
  }

  @override
  String scanErrorSearching(String error) {
    return 'Hitilafu wakati wa kutafuta aina: $error';
  }

  @override
  String get scanNoVariantsAvailable => 'Hakuna aina zinazopatikana';

  @override
  String get scanSelectVariant => 'Chagua aina ya bidhaa';

  @override
  String get scanSearchByNameOrBarcode => 'Tafuta kwa jina au msimbopau';

  @override
  String get scanNoMatchingVariants => 'Hakuna aina zinazolingana';

  @override
  String scanRetailPrice(String price) {
    return 'Bei ya rejareja: $price';
  }

  @override
  String scanBarcode(String barcode) {
    return 'Msimbopau: $barcode';
  }

  @override
  String scanErrorShowing(String error) {
    return 'Hitilafu wakati wa kuonyesha aina: $error';
  }

  @override
  String get productCreate => 'Unda bidhaa';

  @override
  String get productLabel => 'Bidhaa';

  @override
  String get productNameHint => 'Jina la bidhaa';

  @override
  String get productPriceAndInventory => 'BEI NA HISA';

  @override
  String get productExpiryDate => 'Tarehe ya kuisha muda';

  @override
  String productExpiresAt(String date) {
    return 'Inaisha muda $date';
  }

  @override
  String get productAddVariation => 'Ongeza aina';

  @override
  String get productProvideName => 'Weka jina la bidhaa';

  @override
  String get productUnsavedDiscard =>
      'Una bidhaa ambayo haijahifadhiwa. Unataka kuiacha?';

  @override
  String get variantsTax => 'Kodi';

  @override
  String get variantsUnit => 'Kipimo';

  @override
  String get variantsClassification => 'Uainishaji';

  @override
  String get variantsExpiration => 'Kuisha muda';

  @override
  String get variantsAction => 'Kitendo';

  @override
  String get checkoutNoCustomer => 'Hakuna mteja';

  @override
  String get checkoutWalkIn => 'Mteja wa papo hapo';

  @override
  String get checkoutTotal => 'Jumla';

  @override
  String get checkoutReviewAndPay => 'Kagua na ulipe';

  @override
  String get checkoutReviewAndSend => 'Kagua na utume';

  @override
  String get checkoutCouldNotOpen =>
      'Imeshindwa kufungua malipo ya kikapu hiki. Tafadhali jaribu tena.';

  @override
  String get checkoutScan => 'Changanua';

  @override
  String get checkoutItemsNotAvailable => 'Bidhaa hazipatikani';

  @override
  String checkoutErrorLoadingItemsDetail(String error) {
    return 'Hitilafu wakati wa kupakia bidhaa: $error';
  }

  @override
  String get checkoutErrorLoadingItems => 'Hitilafu wakati wa kupakia bidhaa';

  @override
  String get checkoutStatusOpen => 'Wazi';

  @override
  String get checkoutStatusCompleted => 'Imekamilika';

  @override
  String get reportsBusinessAnalytics => 'Uchanganuzi wa biashara';

  @override
  String get reportsStockValue => 'Thamani ya hisa';

  @override
  String get reportsTotalSales => 'Jumla ya mauzo';

  @override
  String get reportsProfit => 'Faida';

  @override
  String get reportsLoading => 'Inapakia...';

  @override
  String get reportsStockPerformance => 'Utendaji wa hisa';

  @override
  String get reportsErrorLoadingChart =>
      'Hitilafu wakati wa kupakia data ya chati';

  @override
  String get reportsInsufficientData => 'Data haitoshi kwa chati';

  @override
  String get reportsDetailedMetrics => 'Vipimo vya kina';

  @override
  String get reportsErrorLoadingMetrics => 'Hitilafu wakati wa kupakia vipimo';

  @override
  String get branchesTitle => 'Matawi';

  @override
  String get branchesAddNew => 'Ongeza tawi jipya';

  @override
  String get branchesName => 'Jina la tawi';

  @override
  String get branchesNameHint => 'Weka jina la tawi';

  @override
  String get branchesLocationHint => 'Weka eneo la tawi';

  @override
  String get branchesCreate => 'Unda tawi';

  @override
  String get branchesAll => 'Matawi yote';

  @override
  String get branchesLoadFailed => 'Imeshindwa kupakia matawi';

  @override
  String get branchesNoneFound => 'Hakuna matawi yaliyopatikana';

  @override
  String get dashUnknown => 'Haijulikani';

  @override
  String get branchesDefaultBadge => 'Chaguo-msingi';

  @override
  String get branchesActiveBadge => 'Hai';

  @override
  String get branchesDelete => 'Futa tawi';

  @override
  String get branchesDefaultCannotDelete =>
      'Tawi la chaguo-msingi haliwezi kufutwa';

  @override
  String get branchesKeepOne => 'Lazima ubaki na angalau tawi moja';

  @override
  String branchesDeleteConfirm(String name) {
    return 'Una uhakika unataka kufuta $name?';
  }

  @override
  String get branchesDeleteFailed => 'Imeshindwa kufuta tawi';

  @override
  String get branchesAddError => 'Hitilafu wakati wa kuongeza tawi';

  @override
  String get branchesNameRequired => 'Jina la tawi linahitajika';

  @override
  String get branchesLocationRequired => 'Eneo linahitajika';

  @override
  String get roomAdd => 'Ongeza chumba';

  @override
  String get roomNumber => 'Nambari ya chumba';

  @override
  String get roomType => 'Aina ya chumba';

  @override
  String get roomSelect => 'Chagua';

  @override
  String get roomSelectTypeError => 'Tafadhali chagua aina ya chumba';

  @override
  String get roomPricePerNight => 'Bei kwa usiku';

  @override
  String get roomTaxCode => 'Msimbo wa kodi';

  @override
  String get roomSelectTaxCodeError => 'Tafadhali chagua msimbo wa kodi';

  @override
  String get roomTaxExemptShort => 'Imesamehewa';

  @override
  String get roomTaxStandardRate => 'Kiwango cha kawaida';

  @override
  String get roomTaxReducedRate => 'Kiwango kilichopunguzwa';

  @override
  String get roomTaxNonVat => 'Bila VAT';

  @override
  String get roomTaxExempt => 'Imesamehewa kodi';

  @override
  String get roomTaxExemptHint => 'Samehe chumba hiki VAT';

  @override
  String get roomAddedSuccess => 'Chumba kimeongezwa kwa mafanikio';

  @override
  String roomAddError(String error) {
    return 'Hitilafu wakati wa kuongeza chumba: $error';
  }

  @override
  String get roomTypeSingle => 'Ya mtu mmoja';

  @override
  String get roomTypeDouble => 'Ya watu wawili';

  @override
  String get roomTypeSuite => 'Chumba cha hadhi';

  @override
  String get roomTypeDeluxe => 'Cha kifahari';

  @override
  String get branchSwitchedRefreshing =>
      'Tawi limebadilishwa. Tunasasisha data...';

  @override
  String get branchDefault => 'Tawi la chaguo-msingi';

  @override
  String get branchLoggingOut => 'Tunakutoa...';

  @override
  String branchSwitchedTo(String branch) {
    return 'Umehamia $branch';
  }

  @override
  String branchSwitchingTo(String branch) {
    return 'Inahamia $branch…';
  }

  @override
  String get branchSwitchTitle => 'Badilisha tawi';

  @override
  String get branchActive => 'Tawi linalotumika';

  @override
  String get branchLoading => 'Tunapakia matawi…';

  @override
  String get branchNoneAvailable => 'Hakuna matawi yanayopatikana';

  @override
  String get branchSearchHint => 'Tafuta matawi…';

  @override
  String get gaugeIncorrectWidgetType => 'Aina ya wijeti si sahihi';

  @override
  String get gaugeFinancialOverview => 'Muhtasari wa fedha';

  @override
  String get gaugeReadyToTrack => 'Uko tayari kuanza kufuatilia!';

  @override
  String get gaugeTransactionsWillAppear =>
      'Miamala yako itaonekana hapa utakapoanza kuiongeza.';

  @override
  String gaugeNoRecordsFor(String period) {
    return 'Hakuna rekodi za $period';
  }

  @override
  String get gaugeTryDifferentPeriod =>
      'Jaribu kuchagua kipindi kingine au ongeza miamala.';

  @override
  String get gaugeRecentTransactions => 'Miamala ya hivi karibuni';

  @override
  String get gaugeLast30Days => 'Siku 30 zilizopita';

  @override
  String get gaugeWaitingMomo => 'INASUBIRI MOMO';

  @override
  String get gaugeLoadingTransactions => 'Tunapakia miamala...';

  @override
  String get gaugeSomethingWentWrong => 'Kuna hitilafu imetokea';

  @override
  String get gaugePeriodToday => 'Leo';

  @override
  String get gaugePeriodThisWeek => 'Wiki hii';

  @override
  String get gaugePeriodThisMonth => 'Mwezi huu';

  @override
  String get gaugePeriodThisYear => 'Mwaka huu';

  @override
  String get deliveryDriverAppTitle => 'Programu ya dereva wa usafirishaji';

  @override
  String get deliveryOnline => 'Mtandaoni';

  @override
  String get deliveryOffline => 'Nje ya mtandao';

  @override
  String get deliveryCurrentPickup => 'Uchukuaji wa sasa';

  @override
  String get deliveryConfirmPickup => 'Thibitisha uchukuaji';

  @override
  String get deliveryUpcoming => 'Usafirishaji ujao';

  @override
  String deliveryOrderNumber(String id) {
    return 'Oda #$id';
  }

  @override
  String deliveryPickupLine(String place) {
    return 'Uchukuaji: $place';
  }

  @override
  String deliveryDeliverTo(String name) {
    return 'Peleka kwa: $name';
  }

  @override
  String get deliveryYouAreOffline => 'Uko nje ya mtandao';

  @override
  String get deliveryGoOnline =>
      'Ingia mtandaoni ili uanze kupokea usafirishaji';

  @override
  String get sideMenuOverview => 'Muhtasari';

  @override
  String get sideMenuAuthenticator => 'Kithibitishaji';

  @override
  String get sideMenuKitchenDisplay => 'Skrini ya jikoni';

  @override
  String get sideMenuStockRecount => 'Kuhesabu hisa upya';

  @override
  String get sideMenuDelegations => 'Ugawaji wa majukumu';

  @override
  String get sideMenuIncomingOrders => 'Oda zinazoingia';

  @override
  String get sideMenuTransfersReport => 'Ripoti ya uhamisho';

  @override
  String get sideMenuProductionOutput => 'Matokeo ya uzalishaji';

  @override
  String get sideMenuTransactions => 'Miamala';

  @override
  String get sideMenuAnalytics => 'Uchanganuzi';

  @override
  String get sideMenuShiftHistory => 'Historia ya zamu';

  @override
  String get sideMenuAgentCommission => 'Kamisheni ya wakala';

  @override
  String get sideMenuEndShift => 'Maliza zamu';

  @override
  String get ipmPageErrorLoading => 'Hitilafu wakati wa kupakia data';

  @override
  String get ipmPageNoImports => 'Hakuna bidhaa zilizoagizwa';

  @override
  String get ipmPageNoImportsHint =>
      'Sawazisha na RRA ili kuleta bidhaa mpya zilizoagizwa.';

  @override
  String get ipmPageNoPurchases => 'Hakuna ankara za manunuzi';

  @override
  String get ipmPageNoPurchasesHint =>
      'Sawazisha na RRA au rekodi manunuzi kwa mkono.';

  @override
  String get ipmPageRetrySucceeded => 'Jaribio jipya limefaulu';

  @override
  String ipmPageRetryFailed(String error) {
    return 'Jaribio jipya limeshindwa: $error';
  }

  @override
  String get ipmPageMissingPricing =>
      'Mojawapo ya bidhaa za kuidhinisha haina bei zinazohitajika';

  @override
  String ipmPageApprovedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count zimeidhinishwa',
      one: 'Bidhaa 1 imeidhinishwa',
    );
    return '$_temp0';
  }

  @override
  String ipmPageApproveItemsFailed(String error) {
    return 'Imeshindwa kuidhinisha bidhaa: $error';
  }

  @override
  String get ipmPageSetBothPrices =>
      'Tafadhali weka bei ya rejareja na bei ya ununuzi';

  @override
  String ipmPageApprovedItem(String name) {
    return '\"$name\" imeidhinishwa';
  }

  @override
  String ipmPageApproveItemFailed(String error) {
    return 'Imeshindwa kuidhinisha bidhaa: $error';
  }

  @override
  String ipmPageRejectedItem(String name) {
    return '\"$name\" imekataliwa';
  }

  @override
  String ipmPageRejectItemFailed(String error) {
    return 'Imeshindwa kukataa bidhaa: $error';
  }

  @override
  String get importsColNo => 'Na.';

  @override
  String get importsColItemName => 'Jina la bidhaa';

  @override
  String get importsColHsCode => 'Msimbo wa HS';

  @override
  String get importsColRetailPrice => 'Bei ya rejareja';

  @override
  String get importsColSupplyPrice => 'Bei ya ununuzi';

  @override
  String get importsColStatus => 'Hali';

  @override
  String get importsColSupplier => 'Msambazaji';

  @override
  String get importsColDate => 'Tarehe';

  @override
  String get importsWait => 'Subiri';

  @override
  String get importsRejected => 'Imekataliwa';

  @override
  String get importsApprove => 'Idhinisha';

  @override
  String get importsReject => 'Kataa';

  @override
  String importsApproveError(String error) {
    return 'Hitilafu wakati wa kuidhinisha bidhaa: $error';
  }

  @override
  String importsRejectError(String error) {
    return 'Hitilafu wakati wa kukataa bidhaa: $error';
  }

  @override
  String get importsNoData =>
      'Hakuna data iliyopatikana au hitilafu ya mtandao, tafadhali jaribu tena.';

  @override
  String get importsNoMatches =>
      'Hakuna matokeo kwa kichujio kilichochaguliwa.';

  @override
  String get refundUnavailable => 'Marejesho hayapatikani';

  @override
  String refundWithAmount(String amount) {
    return 'Rejesha $amount';
  }

  @override
  String get refundReceiptCannotBeRefunded => 'Risiti hii haiwezi kurejeshwa';

  @override
  String get refundNoCopyToPrint => 'Risiti hii haina nakala ya kuchapisha';

  @override
  String get refundTransactionTitle => 'Muamala';

  @override
  String get refundCopied => 'Imenakiliwa';

  @override
  String get refundPayerDiffers => 'tofauti na mteja';

  @override
  String get refundTaxIncluded => 'Kodi imejumuishwa';

  @override
  String get refundAmountLabel => 'Kiasi cha marejesho';

  @override
  String get refundPrintCopy => 'Chapisha nakala ya risiti';

  @override
  String get refundStatusPartiallyRefunded => 'Imerejeshwa kwa sehemu';

  @override
  String get refundStatusParked => 'Imesimamishwa';

  @override
  String refundSaleSubtitle(String payment) {
    return 'Mauzo ya $payment';
  }

  @override
  String get refundPaymentCard => 'Kadi';

  @override
  String get ebmNoActiveBranch => 'Hakuna tawi linalotumika lililopatikana';

  @override
  String get ebmTinRequired => 'TIN inahitajika';

  @override
  String get ebmBhfIdRequired => 'BHF ID inahitajika';

  @override
  String get ebmDeviceSerial => 'Nambari ya mfululizo ya kifaa';

  @override
  String get ebmDeviceSerialRequired =>
      'Nambari ya mfululizo ya kifaa inahitajika';

  @override
  String get ebmProcessing => 'Inashughulikiwa...';

  @override
  String get ebmReinitialize => 'Anzisha upya';

  @override
  String ebmInitFailed(String error) {
    return 'Imeshindwa kuanzisha EBM: $error';
  }

  @override
  String get ebmInitSuccess => 'EBM imeanzishwa kwa mafanikio';

  @override
  String get ebmTaxpayerName => 'Jina la mlipakodi';

  @override
  String get searchCustomerType => 'Aina ya mteja';

  @override
  String get searchSaleType => 'Aina ya mauzo';

  @override
  String get searchAssignAgent => 'Mpangie wakala';

  @override
  String get searchAgent => 'Wakala';

  @override
  String get searchCustomerTypeShop => 'Duka';

  @override
  String get searchSaleTypeOutgoing => 'Mauzo ya kawaida';

  @override
  String get searchSaleTypeAgent => 'Mauzo ya wakala';

  @override
  String get fuelSelectBranchFirst =>
      'Chagua tawi kabla ya kusawazisha mafuta.';

  @override
  String get fuelBusinessMissing => 'Taarifa za biashara hazipo.';

  @override
  String get fuelVatRequired =>
      'VAT / EBM lazima iwezeshwe ili kusawazisha bidhaa za mafuta zinazodhibitiwa.';

  @override
  String get fuelContactingConnector => 'Inawasiliana na data-connector…';

  @override
  String get fuelFetchingCatalog => 'Inaleta orodha ya mafuta kutoka RRA…';

  @override
  String get fuelWaitingForSync => 'Inasubiri usawazishaji wa Ditto…';

  @override
  String fuelVariantsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'aina $count',
      one: 'aina 1',
    );
    return '$_temp0';
  }

  @override
  String get fuelSyncExplanation =>
      'Inaleta bidhaa za mafuta zinazodhibitiwa kutoka RRA. Usajili wa mafuta kwa mkono hauruhusiwi — tumia usawazishaji huu badala yake.';

  @override
  String get fuelProductName => 'Jina la bidhaa';

  @override
  String get fuelProductNameRequired => 'Jina la bidhaa linahitajika';

  @override
  String get fuelEnableVat =>
      'Wezesha VAT kwenye tawi hili kabla ya kusawazisha mafuta.';

  @override
  String get fuelSyncing => 'Inasawazisha…';

  @override
  String get fuelSyncFromRra => 'Sawazisha kutoka RRA';

  @override
  String get editQtyCannotBeNegative => 'Kiasi hakiwezi kuwa hasi';

  @override
  String editQtyRraFloor(String floor) {
    return 'Hisa iliyoripotiwa kwa RRA inaweza kuongezwa tu hapa. Tumia marekebisho ya hisa ili kushuka chini ya $floor.';
  }

  @override
  String get editQtyServiceNotice =>
      'Huduma hazina hisa. Kuhifadhi kunaacha aina hii kwenye 0.';

  @override
  String editQtyCannotGoBelow(String floor) {
    return 'Haiwezi kushuka chini ya $floor';
  }

  @override
  String editQtyAdds(String qty) {
    return 'Inaongeza $qty kwenye hisa ya sasa.';
  }

  @override
  String editQtyRemoves(String qty) {
    return 'Inaondoa $qty kutoka hisa ya sasa.';
  }

  @override
  String editQtyStays(String qty) {
    return 'Hisa inabaki $qty.';
  }

  @override
  String get editQtyGotIt => 'Nimeelewa';

  @override
  String get editQtyUpdateStock => 'Sasisha hisa';

  @override
  String get editQtyTitle => 'Hariri kiasi';

  @override
  String editQtyOnHand(String qty) {
    return 'Zilizopo $qty';
  }

  @override
  String get creditHubTitle => 'Kituo cha salio';

  @override
  String get creditHubAddCredits => 'Ongeza salio';

  @override
  String get creditHubUseCredits => 'Tumia salio';

  @override
  String creditHubUseAmount(int amount) {
    return 'Tumia $amount';
  }

  @override
  String get creditHubAvailable => 'Salio linalopatikana';

  @override
  String get creditHubCredits => 'Salio';

  @override
  String get creditHubQuickAdd => 'Ongeza haraka';

  @override
  String get creditHubEnterAmount => 'Weka kiasi';

  @override
  String creditHubUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Salio $count limetumika',
      one: 'Salio 1 limetumika',
    );
    return '$_temp0';
  }

  @override
  String creditHubAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Salio $count limeongezwa kwa mafanikio',
      one: 'Salio 1 limeongezwa kwa mafanikio',
    );
    return '$_temp0';
  }

  @override
  String get creditHubInvalidAmount => 'Tafadhali weka kiasi sahihi';

  @override
  String creditHubMaximum(int max) {
    return 'Upeo: $max';
  }

  @override
  String get customerFormNewBusiness => 'Biashara mpya';

  @override
  String get customerFormNewCustomer => 'Mteja mpya';

  @override
  String get customerFormNoPhone => 'Bado hakuna simu';

  @override
  String get customerFormType => 'Aina ya mteja';

  @override
  String get customerFormBusinessName => 'Jina la biashara';

  @override
  String get customerFormFullName => 'Jina kamili';

  @override
  String get customerFormBusinessNameHint => 'mf. Kigali Traders Ltd';

  @override
  String get customerFormFullNameHint => 'mf. Jean Mukamana';

  @override
  String get customerFormEmail => 'Anwani ya barua pepe';

  @override
  String get customerFormTinHint => 'Namba ya kodi kwa ankara';

  @override
  String get customerFormUpdated => 'Mteja amesasishwa kwa mafanikio!';

  @override
  String get customerFormAddedAttached => 'Mteja ameongezwa na kuunganishwa';

  @override
  String get customerFormAddFailed => 'Imeshindwa kuongeza mteja';

  @override
  String get customerFormSaveChanges => 'Hifadhi mabadiliko';

  @override
  String get customerFormAddAttach => 'Ongeza na uunganishe mteja';

  @override
  String get customerFormOptional => 'si lazima';

  @override
  String get customerFormIndividual => 'Mtu binafsi';

  @override
  String get backupNow => 'Hifadhi nakala sasa';

  @override
  String get backupCreated => 'Nakala rudufu imeundwa';

  @override
  String get syncTitle => 'Usawazishaji';

  @override
  String get syncEnable => 'Wezesha usawazishaji';

  @override
  String get qrCode => 'Msimbo wa QR';

  @override
  String get qrMode => 'Hali ya QR';

  @override
  String get qrModeEnable => 'Wezesha hali ya QR';

  @override
  String get qrModeEmailNotGmail => 'Barua pepe iliyoongezwa si ya Gmail';

  @override
  String get appChoicePosSubtitle => 'Uza na upokee malipo';

  @override
  String get appChoiceBooks => 'Hesabu';

  @override
  String get appChoiceBooksSubtitle => 'Uhasibu na leja';

  @override
  String get appChoiceInventorySubtitle => 'Hisa na bidhaa';

  @override
  String get appChoiceReportsSubtitle => 'Uchanganuzi wa mauzo na kodi';

  @override
  String get appChoiceOrders => 'Oda';

  @override
  String get appChoiceOrdersSubtitle => 'Manunuzi na uhamisho';

  @override
  String get appChoiceCustomersSubtitle => 'Anwani na mikopo';

  @override
  String get appChoiceSettingsSubtitle => 'Vifaa, kodi na wafanyakazi';

  @override
  String get appChoiceTitle => 'Chagua programu yako';

  @override
  String get appChoiceSubtitle =>
      'Chagua unapotaka kuanzia. Unaweza kubadilisha programu wakati wowote.';

  @override
  String get appChoiceKeyboardHint =>
      'Bonyeza 1–7 kufungua, mishale kusogea, Esc kufunga';

  @override
  String get posBalanceDue => 'Salio linalodaiwa';

  @override
  String get posChange => 'Chenji';

  @override
  String posTillTicketName(String reference) {
    return 'Kaunta · $reference';
  }

  @override
  String get posSentToTillNote => 'Imetumwa kwenye kaunta kwa malipo';

  @override
  String get posReturnToTillFailed =>
      'Imeshindwa kurudisha tiketi hii kwenye kaunta. Tafadhali jaribu tena.';

  @override
  String cashbookPersonalGoalNote(String goal) {
    return 'Lengo binafsi: $goal';
  }

  @override
  String get cashbookTitle => 'Daftari la fedha';

  @override
  String get cashbookRecentTransactions => 'Miamala ya hivi karibuni';

  @override
  String get cashbookFilterAll => 'Zote';

  @override
  String get cashbookCashIn => 'Pesa iliyoingia';

  @override
  String get cashbookCashOut => 'Pesa iliyotoka';

  @override
  String get cashbookTotalOut => 'Jumla iliyotoka';

  @override
  String get cashbookMomoNet => 'Salio halisi la MoMo';

  @override
  String get cashbookTotalIn => 'Jumla iliyoingia';

  @override
  String cashbookNoCashInFor(String period) {
    return 'Hakuna pesa iliyoingia kwa $period.';
  }

  @override
  String cashbookNoCashOutFor(String period) {
    return 'Hakuna pesa iliyotoka kwa $period.';
  }

  @override
  String cashbookNoMomoFor(String period) {
    return 'Hakuna miamala ya MoMo kwa $period.';
  }

  @override
  String cashbookNoTransactionsFor(String period) {
    return 'Hakuna miamala kwa $period.';
  }

  @override
  String get cashbookReceivedAs => 'Imepokelewa kama';

  @override
  String get cashbookPaidWith => 'Imelipwa kwa';

  @override
  String get cashbookCashInFor => 'Sababu ya pesa iliyoingia (si lazima)';

  @override
  String get cashbookCashOutFor => 'Sababu ya pesa iliyotoka (si lazima)';

  @override
  String get cashbookNote => 'Dokezo';

  @override
  String get cashbookOptionalNoteHint => 'Dokezo la hiari...';

  @override
  String get cashbookMoneyIn => 'Pesa inayoingia';

  @override
  String get cashbookMoneyOut => 'Pesa inayotoka';

  @override
  String get cashbookAmountPositive => 'Kiasi lazima kiwe zaidi ya sifuri';

  @override
  String get cashbookNewCategory => 'Mpya';

  @override
  String cashbookCategoriesError(String error) {
    return 'Hitilafu ya makundi: $error';
  }

  @override
  String get cashbookSaveEntry => 'Hifadhi ingizo';

  @override
  String get cashbookCashInSaved =>
      'Pesa iliyoingia imehifadhiwa kwa mafanikio';

  @override
  String get cashbookCashOutSaved =>
      'Pesa iliyotoka imehifadhiwa kwa mafanikio';

  @override
  String get variantsSelectAll => 'Chagua zote';

  @override
  String get variantsVariant => 'Aina';

  @override
  String get variantsNoDiscount => 'Hakuna punguzo';

  @override
  String variantsPercentOff(String percent) {
    return 'Punguzo la $percent%';
  }

  @override
  String variantsExpires(String date) {
    return 'Inaisha $date';
  }

  @override
  String get variantsNoExpiry => 'Hakuna tarehe ya kuisha';

  @override
  String get variantsLowStock => 'Hisa ndogo';

  @override
  String get variantsDiscountPercent => 'Punguzo %';

  @override
  String get variantsRraItemClass => 'Daraja la bidhaa la RRA';

  @override
  String get variantsSetDate => 'Weka tarehe';

  @override
  String variantsPriceLine(String price) {
    return 'Bei: $price';
  }

  @override
  String get variantsReorderAt => 'Agiza tena kwenye';

  @override
  String get variantsImage => 'Picha';

  @override
  String get variantsDeleteAllSemantic => 'Futa aina zote';

  @override
  String get variantsHideMoreDetails => 'Ficha kodi, kipimo na kuisha muda';

  @override
  String get variantsMoreDetails => 'Kodi, kipimo na kuisha muda';

  @override
  String get refundProformaNotRefundable => 'Haiwezekani kurejesha proforma';

  @override
  String get adminPhoneWithCountryCode =>
      'Weka nambari sahihi ya simu yenye msimbo wa nchi (mf. +250783054874).';

  @override
  String get adminSmsConfigFailed => 'Imeshindwa kusasisha usanidi wa SMS';

  @override
  String get adminWhatsappChannel => 'Chaneli ya WhatsApp';

  @override
  String get adminWhatsappChannelHint =>
      'Chagua jinsi risiti za kidijitali na arifa za oda zinavyotumwa.';

  @override
  String get adminOpenWaSubtitle =>
      'Kipindi cha WhatsApp cha ndani / kinachojiendesha (chaneli 1)';

  @override
  String get adminMetaSubtitle =>
      'WhatsApp rasmi ya Meta (chaneli 2). Huenda wateja wakahitaji kuchanganua QR ili kukubali kabla risiti hazijatumwa.';

  @override
  String get adminUserFallback => 'Mtumiaji';

  @override
  String get adminEnterDisplayName => 'Weka jina la kuonyesha.';

  @override
  String get adminNotSignedIn => 'Hujaingia.';

  @override
  String get adminMissingLoginKey => 'Ufunguo wa kuingia kwenye akaunti haupo.';

  @override
  String get adminNameUpdated => 'Jina limesasishwa.';

  @override
  String adminSaveNameFailed(String error) {
    return 'Imeshindwa kuhifadhi jina: $error';
  }

  @override
  String get adminPhoneSetOnce =>
      'Nambari ya simu inaweza kuwekwa mara moja tu. Wasiliana na msaada ili kuibadilisha.';

  @override
  String get adminPhoneSaved => 'Nambari ya simu imehifadhiwa.';

  @override
  String adminSavePhoneFailed(String error) {
    return 'Imeshindwa kuhifadhi simu: $error';
  }

  @override
  String get adminEmailAlreadySet =>
      'Barua pepe tayari imewekwa na haiwezi kubadilishwa hapa.';

  @override
  String get adminInvalidEmail => 'Tafadhali weka anwani sahihi ya barua pepe.';

  @override
  String get adminEmailSavedBusinessFailed =>
      'Barua pepe imehifadhiwa kwenye akaunti yako. Mipangilio ya biashara haikuweza kusasishwa.';

  @override
  String get adminEmailUpdated => 'Barua pepe imesasishwa.';

  @override
  String adminSaveEmailFailed(String error) {
    return 'Imeshindwa kuhifadhi barua pepe: $error';
  }

  @override
  String get adminLogoUpdated => 'Nembo ya risiti imesasishwa.';

  @override
  String adminLogoUpdateFailed(String error) {
    return 'Imeshindwa kusasisha nembo: $error';
  }

  @override
  String get adminLogoRemoved =>
      'Nembo ya risiti imeondolewa. Nembo chaguo-msingi itatumika.';

  @override
  String adminLogoRemoveFailed(String error) {
    return 'Imeshindwa kuondoa nembo: $error';
  }

  @override
  String get adminBadge => 'MSIMAMIZI';

  @override
  String get adminNoPhoneOnAccount => 'Hakuna simu kwenye akaunti';

  @override
  String get adminAddPhone => 'Ongeza simu';

  @override
  String get adminNoEmailSet => 'Hakuna barua pepe iliyowekwa';

  @override
  String get adminAddEmail => 'Ongeza barua pepe';

  @override
  String get adminSmsPhoneNumber => 'Nambari ya simu ya SMS';

  @override
  String get adminSmsPhoneHint =>
      'Nambari ya simu yenye msimbo wa nchi (mf. +250783054874)';

  @override
  String get adminDefaultWhatsappChannel => 'Chaneli ya WhatsApp chaguo-msingi';

  @override
  String get adminGroupSalesPricing => 'Mauzo na bei';

  @override
  String get adminGroupWorkflow => 'Mtiririko wa kazi';

  @override
  String get adminTicketReviewSubtitle =>
      'Hitaji idhini ya mkaguzi na makabidhiano ya msimamizi wa hisa kabla tiketi iliyolipwa haijakamilika';

  @override
  String get adminGroupTaxCompliance => 'Kodi na uzingatiaji';

  @override
  String get adminGroupDataSync => 'Data na usawazishaji';

  @override
  String get adminGroupDiagnostics => 'Uchunguzi';

  @override
  String get adminCrossDeviceFeatures => 'Vipengele vya vifaa vingi';

  @override
  String get adminReceiptBranding => 'Chapa ya risiti';

  @override
  String get adminReceiptLogo => 'Nembo ya risiti';

  @override
  String get adminReceiptLogoHint =>
      'Pakia PNG isiyo na mandharinyuma au JPG chini ya 200KB. Nembo inaonekana katikati ya risiti zilizochapishwa, na nembo chaguo-msingi hutumika kama hakuna iliyowekwa.';

  @override
  String get adminUploading => 'Inapakia...';

  @override
  String get adminUploadLogo => 'Pakia nembo';

  @override
  String get adminRemoveLogo => 'Ondoa nembo';

  @override
  String get adminPinSubtitle =>
      'Linda vitendo nyeti kama kufuta au kuhariri bidhaa';

  @override
  String adminSearchSettings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tafuta mipangilio $count',
      one: 'Tafuta mpangilio 1',
    );
    return '$_temp0';
  }

  @override
  String adminNoSettingMatches(String query) {
    return 'Hakuna mpangilio unaolingana na \"$query\"';
  }

  @override
  String get adminPhoneExampleHint => 'mf. +250783054874';

  @override
  String get perfUncategorised => 'Bila kundi';

  @override
  String get perfUnits => 'vipande';

  @override
  String get perfUnnamedItem => 'Bidhaa isiyo na jina';

  @override
  String get perfNoItemsTitle => 'Bado hakuna bidhaa katika tawi hili';

  @override
  String get perfNoItemsMessage =>
      'Ongeza bidhaa au rekodi manunuzi na hisa itaonekana hapa.';

  @override
  String get perfHeaderSubtitle => 'Hisa ya sasa pamoja na kasi ya mauzo';

  @override
  String perfItemsTracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count zinafuatiliwa',
      one: 'Bidhaa 1 inafuatiliwa',
    );
    return '$_temp0';
  }

  @override
  String get perfTitle => 'Dashibodi ya hisa';

  @override
  String get perfRefreshTooltip => 'Onyesha upya takwimu za hisa na mauzo';

  @override
  String get perfCoverUnderADay => 'chini ya siku moja';

  @override
  String perfCoverDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'siku $count',
      one: 'siku 1',
    );
    return '$_temp0';
  }

  @override
  String perfCoverMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'miezi $count',
      one: 'mwezi 1',
    );
    return '$_temp0';
  }

  @override
  String get perfCoverOverAYear => 'zaidi ya mwaka';

  @override
  String get perfWindowToday => 'Leo';

  @override
  String get perfWindowTodayLower => 'leo';

  @override
  String perfWindowDays(int count) {
    return 'Siku $count';
  }

  @override
  String perfWindowLastDays(int count) {
    return 'siku $count zilizopita';
  }

  @override
  String get perfNoMatchesTitle => 'Hakuna kinacholingana na vichujio hivi';

  @override
  String get perfNoMatchesMessage =>
      'Futa utafutaji au chagua kichujio kingine.';

  @override
  String get perfReadingSales => 'Inasoma mauzo…';

  @override
  String get perfMovementUnavailable =>
      'Mwenendo wa mauzo haupatikani — takwimu za hisa pekee';

  @override
  String perfCompletedSalesIn(int count, String period) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mauzo $count yaliyokamilika katika $period',
      one: 'Mauzo 1 yaliyokamilika katika $period',
    );
    return '$_temp0';
  }

  @override
  String perfUnitsAndItems(String units, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'bidhaa $count',
      one: 'bidhaa 1',
    );
    return 'Vipande $units · $_temp0';
  }

  @override
  String perfSoldInWindow(String period) {
    return 'Zilizouzwa · $period';
  }

  @override
  String perfRevenueAndProfit(String revenue, String profit) {
    return '$revenue imeingia · faida $profit';
  }

  @override
  String get perfWaitingForSalesData => 'Inasubiri data ya mauzo';

  @override
  String get perfNothingToRestock => 'hakuna cha kujaza tena';

  @override
  String get perfTapToSeeThem => 'gusa ili kuziona';

  @override
  String get perfReorderNow => 'Agiza tena sasa';

  @override
  String get perfWaitingForSellingPace => 'inasubiri kasi ya mauzo';

  @override
  String get perfEveryItemHasRunway => 'kila bidhaa ina hisa ya kutosha';

  @override
  String perfUnderDaysLeft(int days) {
    return 'hisa iliyobaki chini ya siku $days';
  }

  @override
  String get perfNoSalesInPeriod => 'Hakuna mauzo katika kipindi hiki';

  @override
  String perfBestSellerInWindow(String period) {
    return 'Inayouzwa zaidi · $period';
  }

  @override
  String get perfMeasuredFromSales => 'Imepimwa kutoka mauzo yaliyokamilika';

  @override
  String perfSoldAndRevenue(String qty, String revenue) {
    return '$qty zimeuzwa · $revenue imeingia';
  }

  @override
  String get perfPickLongerPeriod => 'Chagua kipindi kirefu au angalia kaunta';

  @override
  String get perfEverythingMoving => 'Kila kitu kinauzwa';

  @override
  String perfTiedUp(String amount) {
    return '$amount imekwama';
  }

  @override
  String get perfNotSelling => 'Haziuzwi';

  @override
  String perfEveryItemSold(String period) {
    return 'Kila bidhaa imeuzwa angalau mara moja katika $period';
  }

  @override
  String perfDeadItems(int count, String period) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count zenye hisa bila mauzo katika $period',
      one: 'Bidhaa 1 yenye hisa bila mauzo katika $period',
    );
    return '$_temp0';
  }

  @override
  String get perfCountsMatch => 'Hesabu zinalingana';

  @override
  String perfLost(String amount) {
    return '$amount imepotea';
  }

  @override
  String get perfStockLoss => 'Upotevu wa hisa';

  @override
  String get perfFromRecounts =>
      'Kutoka kuhesabu hisa upya katika kipindi hiki';

  @override
  String get perfNoShortfall =>
      'Hakuna upungufu uliopatikana katika kuhesabu upya';

  @override
  String perfUnitsMissing(String units, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'bidhaa $count',
      one: 'bidhaa 1',
    );
    return 'Vipande $units vinakosekana katika $_temp0';
  }

  @override
  String get perfNoExpiryRisk => 'Hakuna hatari ya kuisha muda';

  @override
  String perfItemsAtRisk(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count ziko hatarini',
      one: 'Bidhaa 1 iko hatarini',
    );
    return '$_temp0';
  }

  @override
  String get perfExpiryWatch => 'Ufuatiliaji wa kuisha muda';

  @override
  String perfNothingExpiring(int days) {
    return 'Hakuna kinachoisha muda katika siku $days zijazo';
  }

  @override
  String perfExpiringWithin(int days) {
    return 'Zimeisha au zitaisha muda ndani ya siku $days';
  }

  @override
  String get perfChartStockOnHand => 'Hisa iliyopo';

  @override
  String perfChartUnitsSold(String period) {
    return 'Vipande vilivyouzwa · $period';
  }

  @override
  String perfChartRevenue(String period) {
    return 'Mapato · $period';
  }

  @override
  String get perfChartDaysLeft => 'Siku za hisa zilizobaki';

  @override
  String get perfChartStockHint => 'Gusa upau ili kuchagua bidhaa.';

  @override
  String get perfChartSoldHint =>
      'Imepimwa kutoka mauzo yaliyokamilika. Gusa upau ili kuchagua.';

  @override
  String get perfChartRevenueHint =>
      'Thamani ya mauzo ya kilichotoka rafuni kweli.';

  @override
  String get perfChartCoverHint =>
      'Kwa kasi ya sasa ya mauzo — zinazoisha haraka kwanza.';

  @override
  String perfTopOf(int shown, int total) {
    return '$shown bora kati ya $total';
  }

  @override
  String perfItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'bidhaa $count',
      one: 'bidhaa 1',
    );
    return '$_temp0';
  }

  @override
  String get perfSold => 'Zilizouzwa';

  @override
  String get perfRevenue => 'Mapato';

  @override
  String get perfStock => 'Hisa';

  @override
  String get perfDaysLeft => 'Siku zilizobaki';

  @override
  String get perfNoSellingPace =>
      'Bado hakuna kasi ya mauzo — hakuna kilichouzwa katika kipindi hiki';

  @override
  String get perfNothingToChart => 'Hakuna cha kuonyesha kwenye chati';

  @override
  String perfMovementMeasuredOver(String period) {
    return 'Mwenendo umepimwa katika $period';
  }

  @override
  String get perfSellingPace => 'Kasi ya mauzo';

  @override
  String perfPerDay(String qty) {
    return '$qty/siku';
  }

  @override
  String get perfStockLeft => 'Hisa iliyobaki';

  @override
  String get perfNoSales => 'hakuna mauzo';

  @override
  String get perfSellThrough => 'Kiwango cha mauzo';

  @override
  String get perfReceivedEst => 'Zilizopokelewa (makadirio)';

  @override
  String get perfMissingAtCount => 'Zilizokosekana katika hesabu';

  @override
  String get perfFoundAtCount => 'Zilizopatikana katika hesabu';

  @override
  String get perfAlertLevel => 'Kiwango cha tahadhari';

  @override
  String get perfNotSet => 'haijawekwa';

  @override
  String get perfLastSold => 'Iliuzwa mara ya mwisho';

  @override
  String get perfExpiry => 'Kuisha muda';

  @override
  String get perfExpiredLower => 'imeisha muda';

  @override
  String perfInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'baada ya siku $count',
      one: 'baada ya siku 1',
    );
    return '$_temp0';
  }

  @override
  String get perfStockUpdated => 'Hisa imesasishwa';

  @override
  String get perfSortRunsOutSoonest => 'Zinazoisha haraka';

  @override
  String get perfSortLowestStock => 'Hisa ndogo kwanza';

  @override
  String get perfSortBestSelling => 'Zinazouzwa zaidi kwanza';

  @override
  String get perfSortHighestValue => 'Thamani kubwa kwanza';

  @override
  String get perfSortHighestStock => 'Hisa kubwa kwanza';

  @override
  String get perfSortNameAz => 'Jina A–Z';

  @override
  String get perfSearchHint => 'Tafuta bidhaa, kundi, SKU au msimbopau';

  @override
  String get perfRunningLow => 'Zinazoisha';

  @override
  String get perfExpiryRisk => 'Hatari ya kuisha muda';

  @override
  String perfShowingSummary(int shown, int total, String value) {
    return 'Inaonyesha $shown kati ya $total · $value zinazoonekana';
  }

  @override
  String perfMissingAtLastCount(String qty) {
    return '$qty zimekosekana katika hesabu ya mwisho';
  }

  @override
  String get perfExpired => 'Imeisha muda';

  @override
  String perfExpiresInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Inaisha baada ya siku $count',
      one: 'Inaisha baada ya siku 1',
    );
    return '$_temp0';
  }

  @override
  String get perfValue => 'Thamani';

  @override
  String get perfEmpty => 'tupu';

  @override
  String get perfNeedsSalesForPace =>
      'Inahitaji mauzo katika kipindi hiki ili kukokotoa kasi ya mauzo';

  @override
  String perfSellingPaceTooltip(String pace, String left) {
    return 'Inauza $pace/siku — zimebaki $left';
  }

  @override
  String perfSoldAgainstShelf(String sold, String left) {
    return '$sold zimeuzwa dhidi ya $left bado rafuni';
  }

  @override
  String perfSoldOfAvailable(String sold, String available) {
    return '$sold kati ya $available zilizopatikana katika kipindi zimeuzwa';
  }

  @override
  String get perfReorder => 'Agiza tena';

  @override
  String get perfCouldNotLoadStock => 'Imeshindwa kupakia hisa';

  @override
  String get dpaNoProductName => 'Hakuna jina la bidhaa!';

  @override
  String get dpaNoProductSaved => 'Hakuna bidhaa iliyohifadhiwa!';

  @override
  String get dpaProductSaved => 'Bidhaa imehifadhiwa kwa mafanikio!';

  @override
  String get dpaProductNotInitialized =>
      'Bidhaa haijaandaliwa. Tafadhali jaribu tena.';

  @override
  String get dpaBranchIdNotFound =>
      'Kitambulisho cha tawi hakijapatikana. Hakikisha umeingia ipasavyo.';

  @override
  String get dpaBusinessIdNotFound =>
      'Kitambulisho cha biashara hakijapatikana. Hakikisha umeingia ipasavyo.';

  @override
  String get dpaAddComponent =>
      'Tafadhali ongeza angalau kijenzi kimoja kwenye bidhaa mchanganyiko.';

  @override
  String get dpaCompositeSaved =>
      'Bidhaa mchanganyiko imehifadhiwa kwa mafanikio!';

  @override
  String get dpaInvalidProductRefSelect =>
      'Rejea ya bidhaa si sahihi. Chagua au unda bidhaa kwanza.';

  @override
  String get dpaUnexpectedReopen =>
      'Kumetokea hitilafu isiyotarajiwa, funga dirisha hili na ulifungue tena';

  @override
  String get dpaInvalidProductRef => 'Rejea ya bidhaa si sahihi';

  @override
  String get dpaUnexpectedError => 'Hitilafu isiyotarajiwa imetokea';

  @override
  String get dpaBasics => 'Msingi';

  @override
  String get dpaNameColor => 'Jina na rangi';

  @override
  String get dpaProductColor => 'Rangi ya bidhaa';

  @override
  String get dpaProductNameHint => 'mf. Fanta Orange 500ml';

  @override
  String get dpaProductNameMinLength =>
      'Jina la bidhaa lazima liwe na angalau herufi 3';

  @override
  String get dpaPricingCodes => 'Bei na misimbo';

  @override
  String get dpaPriceSkuBarcode => 'Bei, SKU, msimbopau';

  @override
  String get dpaRetailPrice => 'Bei ya rejareja';

  @override
  String get dpaRetailPriceHint => 'Anacholipa mteja';

  @override
  String get dpaPriceRequired => 'Bei inahitajika';

  @override
  String get dpaSupplyPrice => 'Bei ya ununuzi';

  @override
  String get dpaSupplyFromComponents => 'Imekokotolewa kutoka kwa vijenzi';

  @override
  String get dpaComponents => 'Vijenzi';

  @override
  String get dpaBillOfMaterials => 'Orodha ya malighafi';

  @override
  String get dpaRetailSupply => 'Rejareja na ununuzi';

  @override
  String get dpaCostPerUnit => 'Gharama yako kwa kipande';

  @override
  String get dpaInventoryCategorization => 'Hisa na uainishaji';

  @override
  String get dpaCategoryItemType => 'Kundi na aina ya bidhaa';

  @override
  String get dpaVariantsStock => 'Aina na hisa';

  @override
  String get dpaStockScan => 'Hisa na kuchanganua';

  @override
  String get dpaProductDeleted =>
      'Bidhaa hii haikuweza kupakiwa. Huenda imefutwa.';

  @override
  String get dpaProductLoadFailed =>
      'Imeshindwa kupakia bidhaa hii. Tafadhali jaribu tena.';

  @override
  String get dpaProductSavedTitle => 'Bidhaa imehifadhiwa';

  @override
  String get dpaAddedToInventory =>
      'Bidhaa yako na aina zake zimeongezwa kwenye hisa.';

  @override
  String get dpaVariants => 'Aina';

  @override
  String get dpaAddAnother => 'Ongeza bidhaa nyingine';

  @override
  String get dpaAddVariant => 'Ongeza aina';

  @override
  String get dpaEditVariant => 'Hariri aina';

  @override
  String get dpaImageUploadFailed =>
      'Imeshindwa kupakia picha. Tafadhali jaribu tena.';

  @override
  String get dpaImageSelected => 'Picha imechaguliwa';

  @override
  String get dpaAddImage => 'Ongeza picha';

  @override
  String get dpaVariantName => 'Jina la aina';

  @override
  String get dpaVariantNameHint => 'mf. Ndala, saizi 10';

  @override
  String get dpaNameRequired => 'Jina linahitajika';

  @override
  String get dpaRetailOverride => 'Bei maalum ya rejareja';

  @override
  String get dpaLeaveBlankBasePrice => 'Acha wazi ili kutumia bei ya msingi';

  @override
  String get dpaBarcode => 'Msimbopau';

  @override
  String get dpaBarcodeHint => 'SKU / msimbopau (si lazima)';

  @override
  String get dpaLeaveBlankVariantName => 'Acha wazi ili kutumia jina la aina';

  @override
  String get dpaStockQuantity => 'Kiasi cha hisa';

  @override
  String get dpaLowStockReorder => 'Hisa ndogo / agiza tena kwenye';

  @override
  String get dpaLowStockHelper =>
      'Tahadharisha kiasi kilichopo kikifika au kushuka chini ya kiwango hiki';

  @override
  String get dpaTaxStandardB => 'Kawaida B';

  @override
  String get dpaTaxStandardA => 'Kawaida A';

  @override
  String get dpaTaxNoneD => 'Hakuna (D)';

  @override
  String get dpaSaveVariantFailed =>
      'Imeshindwa kuhifadhi aina. Tafadhali jaribu tena.';

  @override
  String get dpaSaveVariant => 'Hifadhi aina';

  @override
  String get dpaProductInfo => 'Taarifa za bidhaa';

  @override
  String get dpaAdvanced => 'Kina';

  @override
  String get dpaPlusAdd => '+ Ongeza';

  @override
  String get dpaVariantsHint =>
      'Gusa aina ili kuipanua · Hariri au futa ndani · telezesha ili kufuta';

  @override
  String get dpaSaveProduct => 'Hifadhi bidhaa';

  @override
  String get dpaRraTimeout =>
      'Seva ya kodi ya RRA imechelewa kujibu. Bidhaa imehifadhiwa ndani lakini bado haijaripotiwa kikamilifu kwa RRA. Angalia seva ya kodi, kisha gusa Hifadhi tena.';

  @override
  String dpaRraReportingFailed(String error) {
    return 'Bidhaa imehifadhiwa ndani lakini kuripoti kwa RRA kumeshindwa: $error. Gusa Hifadhi tena ili kujaribu.';
  }

  @override
  String dpaSaveProductFailed(String error) {
    return 'Imeshindwa kuhifadhi bidhaa: $error';
  }

  @override
  String dpaCompositeSaveFailed(String error) {
    return 'Imeshindwa kuhifadhi bidhaa mchanganyiko: $error';
  }

  @override
  String dpaNamedProductSaved(String name) {
    return '$name imehifadhiwa!';
  }

  @override
  String dpaBaseRetailPrice(String price) {
    return 'Bei ya msingi ya rejareja: $price';
  }

  @override
  String get dpaNotVatRegistered =>
      'Tawi hili halijasajiliwa kwa VAT. \"Hakuna\" (D) pekee ndiyo inatumika.';

  @override
  String get cartNotEnoughStock => 'Huna hisa ya kutosha';

  @override
  String get cartFailedToAddItem => 'Imeshindwa kuongeza bidhaa kwenye kikapu';

  @override
  String get sellNoItemSelected => 'Hakuna bidhaa iliyochaguliwa';

  @override
  String get sellChooseOne => 'CHAGUA KIMOJA';

  @override
  String get dashYes => 'Ndiyo';

  @override
  String get dashNo => 'Hapana';

  @override
  String get dashTryAgain => 'Jaribu tena';

  @override
  String get securityEnablePasscode => 'Wezesha nambari ya siri';

  @override
  String get printingConfiguration => 'Mipangilio ya uchapishaji';

  @override
  String get printingEnableAutoPrint => 'Wezesha uchapishaji wa kiotomatiki';

  @override
  String get inventoryCart => 'Kikapu';

  @override
  String inventoryCartWithCount(String count) {
    return 'Kikapu ($count)';
  }

  @override
  String discountRowAmountOff(String amount, String currency) {
    return 'Punguzo la $amount $currency';
  }

  @override
  String get dashPendingTransactionCopied => 'Muamala unaosubiri umenakiliwa';

  @override
  String get dashUserFallback => 'Mtumiaji';

  @override
  String get dashPopupDialogOpen => 'Kidirisha kimefunguliwa';

  @override
  String get memberFieldAddMember => 'Ongeza mwanachama';

  @override
  String get orderViewTitle => 'Oda';

  @override
  String get switchBranchAble => 'Unaweza kubadilisha tawi';

  @override
  String noNetErrorCheckingConnection(String error) {
    return 'Hitilafu katika kukagua muunganisho: $error';
  }

  @override
  String get noNetTitle => 'Hakuna intaneti';

  @override
  String get noNetSubtitle =>
      'Imeshindwa kuunganisha kwenye intaneti.\nTafadhali kagua muunganisho wako wa intaneti';

  @override
  String get noNetCheckConnection => 'Kagua muunganisho';

  @override
  String get noNetGoToLogin => 'Nenda kuingia';

  @override
  String get notificationsTitle => 'Arifa';

  @override
  String get notificationsWhatsNew => 'Mapya';

  @override
  String get notificationsTakeFirstPayment => 'Pokea malipo yako ya kwanza';

  @override
  String get notificationsLearnFirstPayment =>
      'Jifunze jinsi ya kupokea malipo yako ya kwanza.';

  @override
  String get ordersDoneShopping => 'Umemaliza kununua?';

  @override
  String get ordersOrderFromSupplier => 'Agiza kutoka kwa msambazaji';

  @override
  String get ordersSelectSupplierHint =>
      'Tafuta na uchague msambazaji ili kuona bidhaa zake';

  @override
  String ordersSearchProductsFrom(String supplier) {
    return 'Tafuta bidhaa kutoka $supplier';
  }

  @override
  String get scannerNoBarcodeValue => 'Hakuna msimbopau uliogunduliwa.';

  @override
  String scannerProcessingBarcode(String barcode) {
    return 'Inachakata msimbopau: $barcode';
  }

  @override
  String scannerProductNotFoundForBarcode(String barcode) {
    return 'Hakuna bidhaa yenye msimbopau: $barcode';
  }

  @override
  String scannerErrorAddingProduct(String error) {
    return 'Hitilafu katika kuongeza bidhaa: $error';
  }

  @override
  String get subscriptionEnterCode => 'Weka msimbo wa usajili';

  @override
  String get subscriptionEnterCodeHint =>
      'Weka msimbo wa usajili uliopokea kutoka kwa wakala wetu';

  @override
  String get subscriptionSubscribe => 'Jisajili';

  @override
  String get subscriptionUpdate => 'Sasisha usajili';

  @override
  String get subscriptionEnterVoucherError => 'Tafadhali weka vocha yako';

  @override
  String get subscriptionEnterVoucher => 'Weka vocha';

  @override
  String get subscriptionActivatePro => 'Washa Flipper Pro!';

  @override
  String get subscriptionUpgradeToPro => 'Pandisha hadi Pro';

  @override
  String get saleIndicatorNoSale => 'Hakuna mauzo';

  @override
  String get tenantsBindProductHint =>
      'Unganisha bidhaa na mtumiaji aliye hapa chini ili kuuza kwa urahisi';

  @override
  String tenantsBoundTo(String name) {
    return 'Imeunganishwa na $name';
  }

  @override
  String get tenantsBind => 'Unganisha';

  @override
  String get payableSendToTill => 'Tuma kwenye kaunta →';

  @override
  String get cashbookSuggestSales => 'Mauzo';

  @override
  String get cashbookSuggestOwnerDeposit => 'Amana ya mmiliki';

  @override
  String get cashbookSuggestLoanReceived => 'Mkopo uliopokelewa';

  @override
  String get cashbookSuggestDebtRepayment => 'Malipo ya deni';

  @override
  String get cashbookSuggestRefund => 'Marejesho';

  @override
  String get cashbookSuggestCommission => 'Kamisheni';

  @override
  String get cashbookSuggestTransport => 'Usafiri';

  @override
  String get cashbookSuggestRent => 'Kodi ya pango';

  @override
  String get cashbookSuggestSalaries => 'Mishahara';

  @override
  String get cashbookSuggestUtilities => 'Huduma za maji na umeme';

  @override
  String get cashbookSuggestSupplies => 'Vifaa';

  @override
  String get cashbookSuggestAirtime => 'Muda wa maongezi';

  @override
  String get cashbookSuggestFood => 'Chakula';

  @override
  String get cashbookSuggestRepairs => 'Matengenezo';

  @override
  String get shiftStartSubtitle => 'Andaa droo ya fedha na uanze kazi';

  @override
  String get shiftDetails => 'Maelezo ya zamu';

  @override
  String shiftStartTime(String time) {
    return 'Muda wa kuanza: $time';
  }

  @override
  String shiftEndTime(String time) {
    return 'Muda wa kumaliza: $time';
  }

  @override
  String get shiftOpeningCashFloat => 'Fedha za kuanzia';

  @override
  String get shiftOpeningCashFloatHint =>
      'Weka kiasi cha fedha kilicho kwenye droo mwanzoni mwa zamu';

  @override
  String get shiftOpeningBalanceRequired => 'Salio la kuanzia linahitajika';

  @override
  String get shiftEnterValidPositiveAmount =>
      'Tafadhali weka kiasi halali chanya';

  @override
  String get shiftNotesOptional => 'Maelezo (si lazima)';

  @override
  String get shiftNotesHint => 'Ongeza maelezo yoyote kuhusu zamu hii';

  @override
  String get shiftEnterNotesHere => 'Andika maelezo hapa...';

  @override
  String get shiftStarting => 'Inaanza...';

  @override
  String get shiftStartShift => 'Anza zamu';

  @override
  String get shiftErrorNetwork =>
      'Hitilafu ya mtandao. Tafadhali kagua muunganisho wako na ujaribu tena.';

  @override
  String get shiftErrorSessionExpired =>
      'Kipindi chako kimeisha. Tafadhali ingia tena.';

  @override
  String get shiftErrorValidation =>
      'Tafadhali kagua ulichoweka na ujaribu tena.';

  @override
  String get shiftErrorUnexpected =>
      'Hitilafu isiyotarajiwa imetokea. Tafadhali jaribu tena.';

  @override
  String get shiftErrorLoadingData => 'Hitilafu katika kupakia data ya zamu';

  @override
  String get shiftSummary => 'Muhtasari wa zamu';

  @override
  String get shiftOpeningBalance => 'Salio la kuanzia';

  @override
  String get shiftCashSales => 'Mauzo ya fedha taslimu';

  @override
  String get shiftExpectedCash => 'Fedha zinazotarajiwa';

  @override
  String get shiftCashReconciliation => 'Ulinganisho wa fedha';

  @override
  String get shiftCountCashHint =>
      'Hesabu fedha zilizo kwenye droo kisha weka\nsalio la kufunga hapa chini.';

  @override
  String get shiftClosingCashBalance => 'Salio la kufunga';

  @override
  String get shiftClosingCashHint =>
      'Weka fedha halisi ulizohesabu kwenye droo';

  @override
  String get shiftRequired => 'Inahitajika';

  @override
  String get shiftInvalidAmount => 'Kiasi si sahihi';

  @override
  String get shiftPerfectBalance => 'Salio limelingana';

  @override
  String get shiftOverage => 'Ziada';

  @override
  String get shiftShortage => 'Upungufu';

  @override
  String get shiftDifference => 'Tofauti';

  @override
  String get shiftMoreCashThanExpected => 'Fedha zaidi ya inavyotarajiwa';

  @override
  String get shiftLessCashThanExpected => 'Fedha pungufu kuliko inavyotarajiwa';

  @override
  String get shiftNotes => 'Maelezo';

  @override
  String get shiftExplainShortage => 'Eleza upungufu';

  @override
  String get shiftAddAnyNotes => 'Ongeza maelezo';

  @override
  String get shiftNotesRequiredWhenDifference =>
      'Inahitajika kukiwa na tofauti';

  @override
  String get shiftExplainDifference => 'Eleza tofauti...';

  @override
  String get shiftEnterNotes => 'Andika maelezo...';

  @override
  String get shiftConfirmClosure => 'Thibitisha kufunga zamu';

  @override
  String get shiftGoBack => 'Rudi nyuma';

  @override
  String get shiftConfirmClose => 'Thibitisha kufunga';

  @override
  String get shiftInvalidClosingBalance => 'Salio la kufunga si sahihi';

  @override
  String shiftFailedToClose(String error) {
    return 'Imeshindwa kufunga zamu: $error';
  }

  @override
  String get umusadaBusinessFinancing => 'Ufadhili wa biashara';

  @override
  String get umusadaUnlockLoans => 'Fungua mikopo ya biashara';

  @override
  String get umusadaFinancingHint =>
      'Pata ufadhili kulingana na historia ya oda zako';

  @override
  String get umusadaHowItWorks => 'Jinsi inavyofanya kazi';

  @override
  String get umusadaAutoSync => 'Usawazishaji wa kiotomatiki';

  @override
  String get umusadaAutoSyncDesc =>
      'Data ya oda zako husawazishwa kwa usalama ili kujenga wasifu wako.';

  @override
  String get umusadaCreditScore => 'Alama ya mkopo';

  @override
  String get umusadaCreditScoreDesc =>
      'Umusada hutathmini historia yako ili kuweka kikomo cha mkopo.';

  @override
  String get umusadaInstantLoans => 'Mikopo ya papo hapo';

  @override
  String get umusadaInstantLoansDesc =>
      'Pata fedha haraka unapozihitaji zaidi.';

  @override
  String get umusadaJoin => 'Jiunge na Umusada';

  @override
  String get umusadaMaybeLater => 'Labda baadaye';

  @override
  String get umusadaConnecting => 'Inaunganisha…';

  @override
  String get umusadaConnectionFailed => 'Muunganisho umeshindwa';

  @override
  String get umusadaCouldNotConnect =>
      'Imeshindwa kuunganisha na Umusada. Tafadhali jaribu tena baadaye.';

  @override
  String get mfaUserNotLoggedIn => 'Mtumiaji hajaingia';

  @override
  String mfaErrorLoadingSecret(String error) {
    return 'Hitilafu katika kupakia/kuunda siri ya MFA: $error';
  }

  @override
  String get mfaSetupAuthenticator => 'Sanidi authenticator';

  @override
  String get mfaSettingUp => 'Inasanidi authenticator yako...';

  @override
  String get mfaSetupFailed => 'Usanidi umeshindwa';

  @override
  String get mfaGoBack => 'Rudi nyuma';

  @override
  String get mfaSetUpTwoFactor => 'Sanidi uthibitishaji\nwa hatua mbili';

  @override
  String get mfaScanQrHint =>
      'Changanua QR code iliyo hapa chini kwa programu yako ya authenticator\nili kulinda akaunti yako ya Flipper.';

  @override
  String get mfaStepVerify => 'Thibitisha';

  @override
  String get mfaIveSetUp => 'Nimesanidi authenticator yangu';

  @override
  String get mfaNeedHelp => 'Unahitaji msaada?';

  @override
  String get mfaHelpText =>
      'Tumia programu kama Microsoft Authenticator, Google Authenticator au Authy kuchanganua QR code na kupata misimbo ya uthibitishaji.';

  @override
  String get mfaSetupKey => 'UFUNGUO WA USANIDI';

  @override
  String get mfaCopied => 'Imenakiliwa';

  @override
  String get mfaCopy => 'Nakili';

  @override
  String get noticesTitle => 'Matangazo';

  @override
  String get noticesSubtitle => 'Pata habari za matangazo mapya';

  @override
  String get noticesLoading => 'Inapakia matangazo...';

  @override
  String get noticesUnableToLoad => 'Imeshindwa kupakia matangazo';

  @override
  String get noticesCheckConnection =>
      'Tafadhali kagua muunganisho wako na ujaribu tena';

  @override
  String get noticesEmpty => 'Hakuna matangazo bado';

  @override
  String get noticesEmptyHint => 'Matangazo mapya yataonekana hapa';

  @override
  String get noticesNoTitle => 'Hakuna kichwa';

  @override
  String get noticesNoContent => 'Hakuna maudhui';

  @override
  String get noticesNoDate => 'Hakuna tarehe';

  @override
  String get noticesReadMore => 'Soma zaidi';

  @override
  String get ribbonOrdering => 'Kuagiza';

  @override
  String get ribbonImportPurchase => 'Uagizaji na ununuzi';

  @override
  String get ribbonLocations => 'Maeneo';

  @override
  String get ribbonLocationsCaption => 'Hisa kwa kila tawi';

  @override
  String get ribbonItemsCaption => 'Vinjari na usimamie katalogi';

  @override
  String get ribbonTaxSettingsCaption => 'Seva ya EBM / RRA na VAT';

  @override
  String importPurchasePageSyncFailed(String error) {
    return 'Usawazishaji umeshindwa: $error';
  }

  @override
  String get importPurchasePageManagement => 'Usimamizi wa uagizaji na ununuzi';

  @override
  String get importPurchasePageSyncing => 'Inasawazisha…';

  @override
  String importPurchasePageSyncedAgo(String time) {
    return 'Imesawazishwa $time';
  }

  @override
  String get importPurchasePageNotSynced => 'Bado haijasawazishwa';

  @override
  String get importPurchasePageExport => 'Hamisha';

  @override
  String get importPurchasePageRecordPurchase => 'Rekodi ununuzi';

  @override
  String get importPurchasePageSyncFromRra => 'Sawazisha kutoka RRA';

  @override
  String get importPurchasePageImportFrom => 'Uagizaji kuanzia';

  @override
  String get importPurchasePagePurchaseFrom => 'Ununuzi kuanzia';

  @override
  String get infoDialogUnexpectedError => 'Hitilafu isiyotarajiwa imetokea.';

  @override
  String get infoDialogWarning => 'Onyo';

  @override
  String get infoDialogSuccess => 'Imefaulu';

  @override
  String get infoDialogInformation => 'Taarifa';

  @override
  String get infoDialogGotIt => 'Nimeelewa';

  @override
  String get infoDialogDismiss => 'Funga';

  @override
  String get keypadCashInFor => 'Pesa zinazoingia kwa';

  @override
  String get keypadCashOutFor => 'Pesa zinazotoka kwa';

  @override
  String get dataMixerCannotDelete => 'Haiwezi kufutwa au imeshafutwa.';

  @override
  String get dataMixerCouldNotDelete =>
      'Imeshindwa kufuta bidhaa hii. Tafadhali jaribu tena.';

  @override
  String get dataMixerUnknownProduct => 'Bidhaa isiyojulikana';

  @override
  String get searchToggleScanMode => 'Washa/zima hali ya kuchanganua';

  @override
  String get customAlertTitle => 'Tahadhari';

  @override
  String get imagePickerTitle => 'Chagua picha';

  @override
  String get imagePickerUseCamera => 'Tumia kamera';

  @override
  String get imagePickerUseGallery => 'Tumia matunzio';

  @override
  String get favoritesArrange => 'Panga vipendwa vyako';

  @override
  String get favoritesPressDone => 'Bonyeza \"Imekamilika\" ukimaliza';

  @override
  String get favoritesPressAndHold =>
      'Bonyeza na ushikilie popote kwenye gridi ili kuanza kuweka bidhaa';

  @override
  String get drawerCloseBusiness => 'Funga biashara';

  @override
  String get drawerOpenBusiness => 'Fungua biashara';

  @override
  String get drawerEnterAmount => 'Unahitaji kuweka kiasi';

  @override
  String get drawerNumericOnly => 'Nambari pekee zinaruhusiwa';

  @override
  String get drawerClosingBalance => 'Salio la kufunga';

  @override
  String get drawerOpenDrawer => 'Fungua droo';

  @override
  String get drawerCloseDrawer => 'Funga droo';

  @override
  String get drawerLogoutWithoutClosing => 'Toka bila kufunga droo';

  @override
  String get cashierStaffFallback => 'Mfanyakazi';

  @override
  String get paymentsSplitPayment => 'Gawanya malipo';

  @override
  String get paymentsConfirmPayment => 'Thibitisha malipo';

  @override
  String get paymentsHideDiscount => 'Ficha punguzo';

  @override
  String get paymentsAddDiscount => 'Ongeza punguzo';

  @override
  String get paymentsSendInvoice => 'Tuma ankara';

  @override
  String get paymentsEnterDiscountAmount => 'Tafadhali weka kiasi cha punguzo';

  @override
  String get paymentsDiscountExceedsTotal => 'Punguzo haliwezi kuzidi jumla';

  @override
  String get paymentsPhoneWithoutZero =>
      'Tafadhali weka nambari ya simu bila 0, mfano 783054874';

  @override
  String get paymentsEnterCashReceived => 'Tafadhali weka fedha zilizopokelewa';

  @override
  String get paymentsAmountLessThanPayable =>
      'Kiasi ni pungufu kuliko kinachopaswa kulipwa';

  @override
  String get paymentsChooseMethod => 'Unahitaji kuchagua njia ya malipo';

  @override
  String get paymentsTypeCard => 'Kadi';

  @override
  String get paymentsTypeMobile => 'Simu';

  @override
  String get paymentsTypeBank => 'Benki';

  @override
  String get paymentsTypeCheque => 'Hundi';

  @override
  String get dashNotAvailable => 'Haipo';

  @override
  String get itemsExportNone => 'Hakuna bidhaa za kuhamisha';

  @override
  String get itemsExportSaveDialogTitle => 'Hifadhi faili la Excel';

  @override
  String get itemsExportProductName => 'Jina la bidhaa';

  @override
  String get itemsExportVariantName => 'Jina la aina';

  @override
  String get itemsExportItemCode => 'Msimbo wa bidhaa';

  @override
  String get itemsExportRetailPrice => 'Bei ya rejareja';

  @override
  String get itemsExportUnit => 'Kipimo';

  @override
  String itemsExportSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count zimehamishwa',
      one: 'Bidhaa 1 imehamishwa',
    );
    return '$_temp0';
  }

  @override
  String get itemsExportIncompleteSync =>
      'Baadhi ya idadi huenda bado zinasawazishwa; hamisha tena baadaye kama jumla zinaonekana si sahihi.';

  @override
  String itemsExportFailed(String error) {
    return 'Imeshindwa kuhamisha bidhaa: $error';
  }

  @override
  String get itemsTypeRawMaterial => 'Malighafi';

  @override
  String get itemsTypeFinishedProduct => 'Bidhaa iliyokamilika';

  @override
  String get itemsTypeService => 'Huduma';

  @override
  String get itemsTypeUnknown => 'Haijulikani';

  @override
  String get itemsExportToExcel => 'Hamisha kwenda Excel';

  @override
  String get itemsSearchByName => 'Tafuta kwa jina...';

  @override
  String itemsTransactionsSyncedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Miamala $count iliyosawazishwa imepatikana',
      one: 'Muamala 1 uliosawazishwa umepatikana',
    );
    return '$_temp0';
  }

  @override
  String get itemsTransactionsSynced => 'Miamala imesawazishwa';

  @override
  String get itemsNoneFound => 'Hakuna bidhaa zilizopatikana.';

  @override
  String itemsStockValue(String quantity) {
    return 'Hisa: $quantity';
  }

  @override
  String get itemsStockLoading => 'Hisa: inapakia...';

  @override
  String get itemsStockError => 'Hisa: hitilafu';

  @override
  String itemsErrorLoading(String error) {
    return 'Hitilafu katika kupakia bidhaa: $error';
  }

  @override
  String importPurchasePageFetchedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count mpya zimepatikana kutoka RRA',
      one: 'Bidhaa 1 mpya imepatikana kutoka RRA',
    );
    return '$_temp0';
  }

  @override
  String importPurchasePageFetchedInvoices(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ankara $count mpya zimepatikana kutoka RRA',
      one: 'Ankara 1 mpya imepatikana kutoka RRA',
    );
    return '$_temp0';
  }

  @override
  String get importPurchasePageNoNewItems =>
      'Usawazishaji umekamilika — hakuna bidhaa mpya';

  @override
  String get importPurchasePageNoNewInvoices =>
      'Usawazishaji umekamilika — hakuna ankara mpya';

  @override
  String get itemsViewFromLastWeek => 'tangu wiki iliyopita';

  @override
  String itemsViewExpiredOn(String date) {
    return 'Muda uliisha: $date';
  }

  @override
  String itemsViewIdValue(String id) {
    return 'ID: $id';
  }

  @override
  String itemsViewCategoryValue(String category) {
    return 'Kundi: $category';
  }

  @override
  String itemsViewQuantityValue(String quantity) {
    return 'Idadi: $quantity';
  }

  @override
  String itemsViewLocationValue(String location) {
    return 'Mahali: $location';
  }

  @override
  String itemsViewExpiryDateValue(String date) {
    return 'Tarehe ya kuisha: $date';
  }

  @override
  String get itemsViewInventoryByCategory => 'Hisa kwa kundi';

  @override
  String get itemsViewStockLevelsTrend => 'Mwenendo wa viwango vya hisa';

  @override
  String get itemsViewRecentOrders => 'Oda za hivi karibuni';

  @override
  String itemsViewOrderLine(String id, String date) {
    return 'Oda #$id - $date';
  }

  @override
  String get itemsViewNearExpiryItems => 'Bidhaa zinazokaribia kuisha muda';

  @override
  String itemsViewUnitsAtLocation(int count, String location) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vipande $count',
      one: 'Kipande 1',
    );
    return '$_temp0 - $location';
  }

  @override
  String itemsViewDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zimebaki siku $count',
      one: 'Imebaki siku 1',
    );
    return '$_temp0';
  }

  @override
  String get itemsViewStatusDelivered => 'Imewasilishwa';

  @override
  String get itemsViewStatusInTransit => 'Njiani';

  @override
  String get itemsViewStatusProcessing => 'Inashughulikiwa';

  @override
  String get itemsViewStatusCancelled => 'Imeghairiwa';

  @override
  String get stockApprovalNoItems => 'Hakuna bidhaa kwenye ombi';

  @override
  String get stockApprovalAtLeastOne =>
      'Angalau bidhaa moja lazima iidhinishwe';

  @override
  String get stockApprovalProcessError =>
      'Hitilafu imetokea wakati wa kushughulikia ombi';

  @override
  String get stockApprovalQuantityUpdated => 'Idadi imesasishwa';

  @override
  String get stockApprovalQuantityUpdateFailed => 'Imeshindwa kusasisha idadi';

  @override
  String stockApprovalInsufficientFor(String item) {
    return 'Hisa haitoshi kwa $item';
  }

  @override
  String stockApprovalVariantNotFoundFor(String item) {
    return 'Aina ya $item haikupatikana';
  }

  @override
  String stockApprovalAdjustedToAvailable(String quantity) {
    return 'Idadi imerekebishwa kulingana na hisa iliyopo: $quantity';
  }

  @override
  String stockApprovalItemApproved(String item) {
    return '$item imeidhinishwa';
  }

  @override
  String get stockApprovalItemError =>
      'Hitilafu imetokea wakati wa kuidhinisha bidhaa';

  @override
  String get stockApprovalCancelled => 'Uidhinishaji umeghairiwa';

  @override
  String stockApprovalSmsApproved(String reference) {
    return 'Ombi lako la hisa #$reference limeidhinishwa.';
  }

  @override
  String stockApprovalSmsPartiallyApproved(String reference) {
    return 'Ombi lako la hisa #$reference limeidhinishwa kwa sehemu.';
  }

  @override
  String get stockApprovalRequestApproved => 'Ombi limeidhinishwa';

  @override
  String get stockApprovalRequestPartiallyApproved =>
      'Ombi limeidhinishwa kwa sehemu';

  @override
  String get stockApprovalFinalizeFailed =>
      'Imeshindwa kukamilisha uidhinishaji';

  @override
  String get stockApprovalProcessing => 'Inashughulikia ombi...';

  @override
  String get stockApprovalPartialTitle => 'Uidhinishaji wa sehemu';

  @override
  String get stockApprovalApprove => 'Idhinisha';

  @override
  String get stockApprovalInsufficientHint =>
      'Baadhi ya bidhaa hazina hisa ya kutosha. Tafadhali rekebisha idadi zilizoidhinishwa:';

  @override
  String get stockApprovalVariantNotFound => 'Aina haikupatikana';

  @override
  String get stockApprovalApproveQuantity => 'Idadi ya kuidhinisha';

  @override
  String get stockApprovalRequested => 'Iliyoombwa';

  @override
  String get stockApprovalAvailable => 'Inapatikana';

  @override
  String stockApprovalChipValue(String label, String value) {
    return '$label: $value';
  }

  @override
  String get stockApprovalPleaseApproveOne =>
      'Tafadhali idhinisha angalau bidhaa moja';

  @override
  String get stockApprovalProcessFailed =>
      'Imeshindwa kushughulikia uidhinishaji';

  @override
  String get exportDataTotalLabel => 'Jumla:';

  @override
  String get exportDataTotal => 'Jumla';

  @override
  String get exportDataSheetStockRecount => 'Kuhesabu hisa upya';

  @override
  String get exportDataSheetReport => 'Ripoti';

  @override
  String get exportDataSheetExpenses => 'Matumizi';

  @override
  String get exportDataSheetCashIn => 'Pesa iliyoingia';

  @override
  String get exportDataSheetPaymentMethods => 'Njia za malipo';

  @override
  String get exportDataTotalSalesLines => 'Jumla ya mauzo (mistari):';

  @override
  String get exportDataNetProfitBeforeExpenses =>
      'Jumla ya faida halisi (kabla ya matumizi):';

  @override
  String get exportDataNetProfitAfterExpenses =>
      'Faida halisi ya mwisho (baada ya matumizi):';

  @override
  String get exportDataNetProfitAfterCashIn =>
      'Faida halisi ya mwisho (baada ya pesa iliyoingia):';

  @override
  String get exportDataNetProfitAfterExpensesAndCashIn =>
      'Faida halisi ya mwisho (baada ya matumizi na pesa iliyoingia):';

  @override
  String get exportDataPaymentType => 'Aina ya malipo';

  @override
  String get exportDataSaleAmount => 'Kiasi cha mauzo';

  @override
  String get exportDataTransactionCount => 'Idadi ya miamala';

  @override
  String get exportDataPercentOfTotal => '% ya jumla';

  @override
  String get exportDataExpense => 'Matumizi';

  @override
  String get exportDataTotalExpenses => 'Jumla ya matumizi';

  @override
  String get exportDataTotalCashIn => 'Jumla ya pesa iliyoingia';

  @override
  String exportDataShareSubject(String date) {
    return 'Upakuaji wa ripoti - $date';
  }

  @override
  String get mposSaveCustomerBeforeTill =>
      'Hifadhi jina au nambari ya simu ya mteja kwenye tiketi hii kabla ya kuituma kwenye kaunta.';

  @override
  String get mposCouldNotReturnTicket =>
      'Imeshindwa kurudisha tiketi hii kwenye kaunta. Tafadhali jaribu tena.';

  @override
  String get mposCouldNotRemoveCustomer => 'Imeshindwa kumwondoa mteja';

  @override
  String get mposPaymentsAtTillSendToManager =>
      'Malipo hupokelewa kwenye kaunta. Tuma oda hii kwa meneja.';

  @override
  String get mposAddCustomerBeforeCompleting =>
      'Tafadhali ongeza mteja kwenye mauzo kabla ya kukamilisha';

  @override
  String get mposEnterValidMomoPhone =>
      'Weka nambari halali ya MoMo ili kuomba malipo';

  @override
  String get mposCustomerRequiredForCredit =>
      'Jina au simu ya mteja inahitajika kwa malipo ya mkopo.';

  @override
  String get mposErrorOccurred => 'Hitilafu imetokea';

  @override
  String mposErrorUpdatingQuantity(String error) {
    return 'Hitilafu katika kusasisha idadi: $error';
  }

  @override
  String mposErrorRemovingProduct(String error) {
    return 'Hitilafu katika kuondoa bidhaa: $error';
  }

  @override
  String mposErrorUpdatingPrice(String error) {
    return 'Hitilafu katika kusasisha bei: $error';
  }

  @override
  String get mposAddItemsToCharge => 'Ongeza bidhaa za kutoza';

  @override
  String get mposRecordPayment => 'Rekodi malipo';

  @override
  String get mposComplete => 'Kamilisha';

  @override
  String get mposCompleteNow => 'Kamilisha sasa';

  @override
  String get mposWaitingForPayment => 'Inasubiri malipo...';

  @override
  String get mposPrintingReceipt => 'Inachapisha risiti...';

  @override
  String get mposPaymentFailedRetry => 'Malipo yameshindwa. Jaribu tena?';

  @override
  String mposEnterAmountReceived(String amount) {
    return 'Weka $amount zilizopokelewa';
  }

  @override
  String get mposMobileCheckout => 'Malipo ya simu';

  @override
  String mposCheckoutSemanticValue(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count',
      one: 'Bidhaa 1',
    );
    return '$_temp0, RWF $total';
  }

  @override
  String get mposNoItemsInCart => 'Hakuna bidhaa kwenye kikapu';

  @override
  String get mposAddMoreItems => 'Ongeza bidhaa zaidi';

  @override
  String get mposPaymentMethod => 'Njia ya malipo';

  @override
  String get mposTotals => 'Jumla';

  @override
  String get loginChoicesMember => 'Mwanachama';

  @override
  String get loginChoicesOwner => 'Mmiliki';

  @override
  String loginChoicesBusinessSubtitle(String role, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Matawi $count',
      one: 'Tawi 1',
    );
    return '$role · $_temp0';
  }

  @override
  String get loginChoicesValidatingSession => 'Inathibitisha kipindi...';

  @override
  String get loginChoicesLoadingBusinesses => 'Inapakia biashara zako...';

  @override
  String get loginChoicesNoBusinessesSigningOut =>
      'Hakuna biashara iliyopatikana. Inatoka...';

  @override
  String get loginChoicesChooseBusiness => 'Chagua biashara';

  @override
  String get loginChoicesSelectBusinessHint =>
      'Chagua biashara unayotaka kusimamia.';

  @override
  String get loginChoicesChooseBranch => 'Chagua tawi';

  @override
  String get loginChoicesSelectBranchHint => 'Chagua tawi unalotaka kufikia';

  @override
  String get loginChoicesBranchFallback => 'Tawi';

  @override
  String get loginChoicesSigningOut => 'Inatoka…';

  @override
  String get loginChoicesPleaseWait => 'Tafadhali subiri kidogo';

  @override
  String get loginChoicesSignOut => 'Toka';

  @override
  String get loginChoicesAddBusiness => 'Ongeza biashara';

  @override
  String get loginChoicesNotSeeingBusiness =>
      'Huoni biashara yako? Mwombe mmiliki akualike, au ';

  @override
  String get loginChoicesAddBusinessLink => 'ongeza biashara.';

  @override
  String get loginChoicesNoBranches => 'Hakuna matawi yaliyopakiwa bado';

  @override
  String get loginChoicesNoBranchesHint =>
      'Hii inaweza kutokea kama usawazishaji bado unaendelea.\nJaribu tena baada ya muda mfupi.';

  @override
  String get loginChoicesDefaultBadge => 'CHAGUO-MSINGI';

  @override
  String get drawerMenuAdminFallback => 'Msimamizi';

  @override
  String get drawerMenuMyBusiness => 'Biashara yangu';

  @override
  String get drawerMenuQuickActions => 'VITENDO VYA HARAKA';

  @override
  String get drawerMenuYourBusinesses => 'BIASHARA ZAKO';

  @override
  String get drawerMenuManagement => 'USIMAMIZI';

  @override
  String get drawerMenuPrintDelegation => 'Ukabidhi wa uchapishaji';

  @override
  String get drawerMenuSaleMode => 'Hali ya mauzo';

  @override
  String get drawerMenuBackgroundSyncEnabled =>
      'Usawazishaji wa chinichini umewezeshwa. Ili kuuzima, nenda kwenye mipangilio.';

  @override
  String get drawerMenuBackgroundSyncDisabled =>
      'Usawazishaji wa chinichini umezimwa';

  @override
  String get drawerMenuEbmOn => 'EBM imewashwa';

  @override
  String get drawerMenuEbmOff => 'EBM imezimwa';

  @override
  String get drawerMenuCheckingEbm => 'Inakagua hali ya EBM...';

  @override
  String get drawerMenuEbmStatusError => 'Hitilafu ya hali ya EBM';

  @override
  String get drawerMenuCheckingShift => 'Inakagua hali ya zamu...';

  @override
  String get drawerMenuEndShift => 'Maliza zamu ya sasa';

  @override
  String get drawerMenuStartShift => 'Anza zamu mpya';

  @override
  String get drawerMenuUnnamedBusiness => 'Biashara isiyo na jina';

  @override
  String get drawerMenuUnnamedBranch => 'Tawi lisilo na jina';

  @override
  String drawerMenuBranchCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Matawi $count',
      one: 'Tawi 1',
    );
    return '$_temp0';
  }

  @override
  String get drawerMenuDelegationEnabled =>
      'Ukabidhi wa uchapishaji umewezeshwa';

  @override
  String get drawerMenuDelegationDisabled => 'Ukabidhi wa uchapishaji umezimwa';

  @override
  String get drawerMenuDelegationDeviceSelected =>
      'Kifaa cha ukabidhi kimechaguliwa';

  @override
  String drawerMenuErrorSelectingDevice(String error) {
    return 'Hitilafu katika kuchagua kifaa: $error';
  }

  @override
  String get drawerMenuSelectDevice => 'Chagua kifaa';

  @override
  String get drawerMenuNoDevices => 'Hakuna vifaa katika tawi hili';

  @override
  String drawerMenuPlatform(String platform) {
    return 'Jukwaa: $platform';
  }

  @override
  String drawerMenuPhone(String phone) {
    return 'Simu: $phone';
  }

  @override
  String drawerMenuErrorLoadingDevices(String error) {
    return 'Hitilafu katika kupakia vifaa: $error';
  }

  @override
  String get drawerMenuDelegate => 'Kabidhi';

  @override
  String get drawerMenuDelegateHint =>
      'Kuchapisha risiti kwenye kompyuta wakati seva ya EBM haipatikani';

  @override
  String get drawerMenuEnabled => 'Imewezeshwa';

  @override
  String get drawerMenuDisabled => 'Imezimwa';

  @override
  String get drawerMenuDelegationStep1 =>
      'Simu inakamilisha muamala lakini\ninakabidhi utengenezaji wa risiti';

  @override
  String get drawerMenuDelegationStep2 =>
      'Kompyuta inapokea muamala kupitia usawazishaji';

  @override
  String get drawerMenuDelegationStep3 =>
      'Kompyuta inatengeneza risiti na\nkuwasiliana na seva ya EBM';

  @override
  String get drawerMenuDelegationStep4 =>
      'Simu inaarifiwa uchakataji\nukikamilika';

  @override
  String get drawerMenuRequirements => 'Mahitaji';

  @override
  String get drawerMenuRequirement1 =>
      'Programu ya kompyuta lazima iwe inaendesha na ukabidhi umewezeshwa';

  @override
  String get drawerMenuRequirement2 =>
      'Vifaa vyote viwili lazima visawazishe kupitia Flipper';

  @override
  String get drawerMenuRequirement3 =>
      'Kompyuta inachakata miamala iliyokabidhiwa kila sekunde 10';

  @override
  String get customersHelpSearch => 'Tafuta wateja kwa jina au nambari ya simu';

  @override
  String get customersHelpEdit =>
      'Tumia Hariri kwenye safu ya mteja ili kusasisha taarifa zake';

  @override
  String get customersHelpTap =>
      'Gusa mteja ili kumuunganisha na mauzo ya sasa';

  @override
  String get customersHelpSwipe =>
      'Kwenye simu, telezesha safu ili kufuta, kuhariri, kuongeza au kuondoa haraka';

  @override
  String get customersHelpAdd =>
      'Ongeza mteja mpya kwa kitufe kilicho chini ya sehemu ya kutafuta';

  @override
  String get customersNoneFound => 'Hakuna wateja waliopatikana';

  @override
  String customersFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wateja $count wamepatikana',
      one: 'Mteja 1 amepatikana',
    );
    return '$_temp0';
  }

  @override
  String get customersTryDifferentSearch =>
      'Jaribu maneno mengine ya kutafuta au ongeza mteja mpya';

  @override
  String get customersAddToGetStarted => 'Ongeza mteja ili kuanza';

  @override
  String customersAddAsNew(String name) {
    return 'Ongeza \"$name\" kama mteja mpya';
  }

  @override
  String get customersAddNew => 'Ongeza mteja mpya';

  @override
  String get customersNoName => 'Hakuna jina';

  @override
  String customersTinValue(String tin) {
    return 'TIN: $tin';
  }

  @override
  String get customersRemoveFromSale => 'Ondoa kwenye mauzo';

  @override
  String get customersAddToSale => 'Ongeza kwenye mauzo';

  @override
  String customersAddedToSale(String name) {
    return 'Mteja $name ameongezwa kwenye mauzo';
  }

  @override
  String get customersFailedToAdd => 'Imeshindwa kuongeza mteja kwenye mauzo';

  @override
  String get customersRemovedFromSale => 'Mteja ameondolewa kwenye mauzo';

  @override
  String get customersFailedToRemove => 'Imeshindwa kuondoa mteja kwenye mauzo';

  @override
  String get customersDeleted => 'Mteja amefutwa';

  @override
  String customersCouldNotOpenForm(String error) {
    return 'Imeshindwa kufungua fomu ya mteja: $error';
  }

  @override
  String customersAddNamed(String name) {
    return 'Ongeza mteja \"$name\"';
  }

  @override
  String customersAddNamedToSale(String name) {
    return 'Ongeza \"$name\" kwenye mauzo';
  }

  @override
  String get customersThisCustomer => 'mteja huyu';

  @override
  String get customersDeleteTitle => 'Futa mteja?';

  @override
  String customersDeleteBody(String name) {
    return 'Ondoa $name kwenye orodha ya wateja wako. Hili haliwezi kutenduliwa.';
  }

  @override
  String get itemRowConfirmFavorite => 'Thibitisha kipendwa';

  @override
  String itemRowConfirmFavoriteBody(String product, String position) {
    return 'Unakaribia kuongeza $product kwenye nafasi ya kipendwa $position.\n\nUnakubali?';
  }

  @override
  String get itemRowUnnamedProduct => 'Bidhaa isiyo na jina';

  @override
  String get itemRowDefaultVariant => 'Aina chaguo-msingi';

  @override
  String get itemRowUnnamed => 'Bila jina';

  @override
  String itemRowStockLeft(String quantity) {
    return 'Zimebaki $quantity';
  }

  @override
  String get itemRowDecreaseQuantity => 'Punguza idadi';

  @override
  String get itemRowIncreaseQuantity => 'Ongeza idadi';

  @override
  String get itemRowNoImage => 'Hakuna picha';

  @override
  String get itemRowCannotDeleteWithStock =>
      'Haiwezekani kufuta aina yenye hisa.';

  @override
  String get txDetailExpense => 'Matumizi';

  @override
  String get txDetailIncome => 'Mapato';

  @override
  String get txDetailProducts => 'Bidhaa';

  @override
  String get txDetailTimeline => 'Mfuatano wa muamala';

  @override
  String txDetailEventCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Matukio $count',
      one: 'Tukio 1',
    );
    return '$_temp0';
  }

  @override
  String get txDetailExpenseRecorded => 'Matumizi yamerekodiwa';

  @override
  String get txDetailIncomeReceived => 'Mapato yamepokelewa';

  @override
  String get txDetailMoreActions => 'Vitendo zaidi';

  @override
  String get txDetailCreatedPrefix => 'Imeundwa ';

  @override
  String txDetailAmountRefunded(String amount) {
    return '$amount zimerejeshwa';
  }

  @override
  String get txDetailFullyRefunded => 'Mteja amerejeshewa kikamilifu';

  @override
  String txDetailRefundVia(String reason, String method) {
    return '$reason · kupitia $method';
  }

  @override
  String get txDetailMethod => 'Njia';

  @override
  String get txDetailReference => 'Kumbukumbu';

  @override
  String get txDetailNoLineItems => 'Hakuna bidhaa kwenye muamala huu.';

  @override
  String get txDetailNoTimelineEvents => 'Hakuna matukio bado.';

  @override
  String get txDetailStatusPartiallyRefunded => 'IMEREJESHWA KWA SEHEMU';

  @override
  String get txDetailStatusRefunded => 'IMEREJESHWA';

  @override
  String get txDetailStatusPending => 'INASUBIRI';

  @override
  String get txDetailStatusCompleted => 'IMEKAMILIKA';

  @override
  String get txDetailStatusParked => 'IMEHIFADHIWA';

  @override
  String get txDetailPartiallyRefunded => 'Imerejeshwa kwa sehemu';

  @override
  String get txDetailRefund => 'Marejesho';

  @override
  String get txDetailPaymentReceived => 'Malipo yamepokelewa';

  @override
  String get txDetailPaymentPending => 'Malipo yanasubiriwa';

  @override
  String get txDetailSaleCreated => 'Mauzo yameundwa';

  @override
  String txDetailPaymentLine(String method) {
    return 'Malipo: $method';
  }

  @override
  String get txListSelectDateRange => 'Chagua kipindi';

  @override
  String get txListSelectDateRangeFirst => 'Tafadhali chagua kipindi kwanza';

  @override
  String get txListNoDataToExport =>
      'Hakuna data ya kuhamisha. Tafadhali subiri data ipakie.';

  @override
  String get txListReportStillLoading =>
      'Data ya ripoti bado inapakia. Tafadhali jaribu tena baada ya muda mfupi.';

  @override
  String txListExportFailed(String error) {
    return 'Uhamishaji umeshindwa: $error';
  }

  @override
  String txListRefreshFailed(String error) {
    return 'Kuonyesha upya kumeshindwa: $error';
  }

  @override
  String txListReportFailed(String error) {
    return 'Ripoti imeshindwa: $error';
  }

  @override
  String get txListChangeDate => 'Badilisha tarehe';

  @override
  String get txListZReport => 'Ripoti Z';

  @override
  String get txListXReport => 'Ripoti X';

  @override
  String get txListSaleReport => 'Ripoti ya mauzo';

  @override
  String get txListPluReport => 'Ripoti ya PLU';

  @override
  String get txListAllStatuses => 'Hali zote';

  @override
  String get txListAllTypes => 'Aina zote';

  @override
  String get txListAllPayments => 'Malipo yote';

  @override
  String get txListByHand => 'Kwa mkono';

  @override
  String get txListSearchReceipt => 'Tafuta nambari ya risiti...';

  @override
  String get txListCashierHeading => 'KESHIA';

  @override
  String get txListAll => 'Wote';

  @override
  String get txListRefreshTooltip =>
      'Onyesha upya — pata data mpya kutoka kwa vifaa vingine au seva';

  @override
  String get txListSummarized => 'Muhtasari';

  @override
  String get txListDetailed => 'Kina';

  @override
  String get txListNoTransactions =>
      'Hakuna miamala iliyopatikana kwa kipindi kilichochaguliwa.';

  @override
  String get txListPreparingReports => 'Inaandaa ripoti zako...';

  @override
  String get txListMightTakeMoment =>
      'Hii inaweza kuchukua muda kulingana na data yako';

  @override
  String get txListSomethingWentWrong => 'Samahani! Kuna tatizo limetokea';

  @override
  String get dashViewToday => 'Leo';

  @override
  String get dashViewThisWeek => 'Wiki hii';

  @override
  String get dashViewThisMonth => 'Mwezi huu';

  @override
  String get dashViewThisYear => 'Mwaka huu';

  @override
  String get dashViewNetProfit => 'Faida halisi';

  @override
  String get dashViewGrossProfit => 'Faida ghafi';

  @override
  String get dashViewFromYegobox => 'KUTOKA YEGOBOX';

  @override
  String dashViewTodaysGoal(String count, String target) {
    return 'Lengo la leo · mauzo $count kati ya $target';
  }

  @override
  String get dashViewLogFirstSale =>
      'Rekodi mauzo yako ya kwanza ili uanze kupata';

  @override
  String get dashViewGoalReached => 'Lengo limefikiwa! ';

  @override
  String dashViewJustMoreTo(String remaining) {
    return 'Zimebaki $remaining tu kupata ';
  }

  @override
  String get dashViewPlusPoints => '+50 alama';

  @override
  String get dashViewStockValue => 'Thamani ya hisa';

  @override
  String dashViewItemsLowOnStock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count zina hisa kidogo',
      one: 'Bidhaa 1 ina hisa kidogo',
    );
    return '$_temp0';
  }

  @override
  String get dashViewFullReport => 'Ripoti kamili ›';

  @override
  String get dashViewDataIncomplete =>
      'Data huenda haijakamilika (usawazishaji wa sehemu).';

  @override
  String get dashViewUnableToLoadStock => 'Imeshindwa kupakia thamani ya hisa.';

  @override
  String get dashViewRevenue => 'Mapato';

  @override
  String get dashViewExpenses => 'Matumizi';

  @override
  String dashViewDeltaUp(String percent) {
    return 'Imepanda $percent%';
  }

  @override
  String dashViewDeltaDown(String percent) {
    return 'Imeshuka $percent%';
  }

  @override
  String get transactionsExportNotReady =>
      'Uhamishaji bado haujawa tayari. Jaribu tena baada ya muda mfupi.';

  @override
  String get transactionsNoLineItemsToExport =>
      'Hakuna bidhaa za kuhamisha kwa kipindi hiki.';

  @override
  String get transactionsFilter => 'Chuja miamala';

  @override
  String get transactionsExportDetailed => 'Hamisha ripoti ya kina (Excel)';

  @override
  String get transactionsTitle => 'Miamala';

  @override
  String transactionsNoRecordsFor(String period) {
    return 'Hakuna rekodi za $period';
  }

  @override
  String get transactionsTryDifferentPeriod =>
      'Jaribu kuchagua kipindi kingine au ongeza miamala.';

  @override
  String get transactionsLoading => 'Inapakia miamala...';

  @override
  String get transactionsSomethingWentWrong => 'Kuna tatizo limetokea';

  @override
  String previewSaleCollectAmount(String amount) {
    return 'Pokea $amount';
  }

  @override
  String previewSaleOrderAmount(String amount) {
    return 'Agiza $amount';
  }

  @override
  String get previewSaleCartEmpty => 'Kikapu chako ki tupu';

  @override
  String get previewSaleDiscounts => 'Mapunguzo';

  @override
  String get importStatusAll => 'Zote';

  @override
  String get importStatusWaiting => 'Inasubiri';

  @override
  String get importStatusRejected => 'Imekataliwa';

  @override
  String get importSaveChanges => 'Hifadhi mabadiliko';

  @override
  String get importAcceptAll => 'Kubali zote';

  @override
  String get importFilterByStatus => 'Chuja kwa hali';

  @override
  String get importEnterName => 'Weka jina';

  @override
  String get importEnterSupplyPrice => 'Weka bei ya mzabuni';

  @override
  String get importSupplyPriceRequired => 'Bei ya mzabuni inahitajika';

  @override
  String get importEnterRetailPrice => 'Weka bei ya rejareja';

  @override
  String get importRetailPriceRequired => 'Bei ya rejareja inahitajika';

  @override
  String get paymentSettingsTitle => 'Mipangilio ya malipo';

  @override
  String get paymentSettingsEnabled => 'Imewashwa';

  @override
  String get paymentSettingsDisabled => 'Imezimwa';

  @override
  String get mposWalkIn => 'Mteja wa papo hapo';

  @override
  String get mposSaleComplete => 'Mauzo yamekamilika';

  @override
  String get mposNewSale => 'Mauzo mapya';

  @override
  String get mposPrintReceipt => 'Chapisha risiti';

  @override
  String get mposTotalPaid => 'Jumla iliyolipwa';

  @override
  String get mposTendered => 'Kilichotolewa';

  @override
  String get mposChange => 'Chenji';

  @override
  String get settingsManageBusiness => 'Dhibiti mipangilio ya biashara yako';

  @override
  String get gaugeGrossProfit => 'Faida ghafi';

  @override
  String get gaugeNetProfit => 'Faida halisi';

  @override
  String get gaugeTaxAndExpenses => 'Kodi na matumizi';

  @override
  String get gaugeLoss => 'Hasara';

  @override
  String get gaugeBalanced => 'Imesawazishwa';

  @override
  String get gaugeNoTransactions => 'Hakuna miamala';

  @override
  String get dashboardGaugeGrossProfit => 'Faida ghafi';

  @override
  String get dashboardGaugeTaxExpenses => 'Kodi na matumizi';

  @override
  String get dashboardGaugeNoTransactionsYet => 'Bado hakuna miamala';

  @override
  String dashboardGaugeGrossProfitPeriod(String period) {
    return 'Faida ghafi · $period';
  }

  @override
  String dashboardGaugeNetProfitPeriod(String period) {
    return 'Faida halisi · $period';
  }

  @override
  String dashboardGaugeDeltaVs(String percent, String comparison) {
    return '$percent% dhidi ya $comparison';
  }

  @override
  String get dashboardGaugeLastPeriod => 'kipindi kilichopita';

  @override
  String get dashboardCompareYesterday => 'jana';

  @override
  String get dashboardCompareLastWeek => 'wiki iliyopita';

  @override
  String get dashboardCompareLastMonth => 'mwezi uliopita';

  @override
  String get dashboardCompareLastYear => 'mwaka uliopita';

  @override
  String get transactionTypeUnclassified => 'Haijaainishwa';

  @override
  String get mposLoadFailedTitle => 'Imeshindwa kupakia';

  @override
  String get mposLoadFailedBody => 'Kagua muunganisho wako na ujaribu tena.';

  @override
  String get dashboardAppPointOfSale => 'Mahali pa mauzo';

  @override
  String get dashboardAppCashBook => 'Daftari la fedha';

  @override
  String get dashboardAppTransactions => 'Miamala';

  @override
  String get dashboardAppContacts => 'Anwani';

  @override
  String get dashboardAppCommission => 'Kamisheni';

  @override
  String get dashboardAppSupport => 'Msaada';

  @override
  String get dashboardAppCredits => 'Salio';

  @override
  String get dashboardAppOrders => 'Oda';

  @override
  String get dashboardAppFinance => 'Fedha';

  @override
  String get dashboardAppBooks => 'Hesabu';

  @override
  String get dashboardAppStockRecount => 'Hesabu upya ya hisa';

  @override
  String get dashboardAppTransfersReport => 'Ripoti ya uhamisho';

  @override
  String get dashboardAppBranchOrders => 'Oda za matawi';

  @override
  String get dashboardQuickAccess => 'UFIKIAJI WA HARAKA';

  @override
  String get dashboardSeeAll => 'Ona zote';

  @override
  String get dashboardShortcutUnsupported =>
      'Kifaa hiki hakitumii njia za mkato zilizobandikwa.';

  @override
  String dashboardShortcutAddPrompt(String label) {
    return 'Ongeza \"$label\" kwenye skrini yako ya mwanzo utakapoombwa.';
  }

  @override
  String get dashboardShortcutLauncherUnsupported =>
      'Kizindua chako hakitumii njia za mkato zilizobandikwa.';

  @override
  String get dashboardShortcutFailed => 'Imeshindwa kuunda njia ya mkato.';

  @override
  String get dashboardAllAppsYourBusiness => 'biashara yako';

  @override
  String dashboardAllAppsEverythingIn(String name) {
    return 'Kila kitu katika $name';
  }

  @override
  String appLaunchOpening(String app) {
    return 'Inafungua $app';
  }

  @override
  String get appLaunchSyncingSlow =>
      'Inasawazisha biashara yako — hii inaweza kuchukua muda kwenye mtandao wa polepole.';

  @override
  String get cashbookCategorySheetSaveFailed =>
      'Imeshindwa kuhifadhi kundi hili. Angalia muunganisho wako ujaribu tena.';

  @override
  String get cashbookCategorySheetQuickPicks => 'CHAGUO ZA HARAKA';

  @override
  String get cashbookCategorySheetTitle => 'Kundi jipya';

  @override
  String get cashbookCategorySheetIncomeSubtitle => 'Panga pesa zinazoingia';

  @override
  String get cashbookCategorySheetExpenseSubtitle => 'Panga pesa zinazotoka';

  @override
  String get cashbookCategorySheetNameLabel => 'Jina la kundi';

  @override
  String cashbookCategorySheetExampleHint(String example) {
    return 'mf. $example';
  }

  @override
  String get cashbookCategorySheetTypeName => 'Andika jina';

  @override
  String cashbookCategorySheetAlreadyExists(String name) {
    return '\"$name\" tayari lipo. Tutalitumia.';
  }

  @override
  String get cashbookCategorySheetUseExisting => 'Tumia kundi lililopo';

  @override
  String get cashbookCategorySheetCreate => 'Unda kundi';

  @override
  String get checkoutRecoveryLeaveQuestion => 'Ondoka kwenye malipo?';

  @override
  String get checkoutRecoveryCheckout => 'Malipo';

  @override
  String get checkoutRecoverySale => 'Mauzo';

  @override
  String get checkoutRecoveryActionNeeded => 'HATUA INAHITAJIKA';

  @override
  String get checkoutRecoveryUnavailable => 'MALIPO HAYAPATIKANI';

  @override
  String get checkoutRecoveryNoBranchHeadline =>
      'Bado hakuna tawi lililochaguliwa';

  @override
  String get checkoutRecoveryLoadFailedHeadline => 'Imeshindwa kupakia malipo';

  @override
  String get checkoutRecoveryNoBranchBody =>
      'Malipo yanahitaji tawi ili kupakia bidhaa na kurekodi mauzo. Chagua tawi ili kuendelea.';

  @override
  String get checkoutRecoveryLoadFailedBody =>
      'Hitilafu imetokea wakati wa kufungua malipo. Jaribu tena au wasiliana na msaada ikiendelea.';

  @override
  String get checkoutRecoveryWhatHappened => 'Kilichotokea';

  @override
  String get checkoutRecoveryNoLocationDiagnostic =>
      'malipo hayakuweza kupata eneo la kifaa hiki.';

  @override
  String get checkoutRecoverySelectBranch => 'Chagua tawi';

  @override
  String get checkoutRecoveryChooseWhere =>
      'Chagua mahali mauzo haya yanafanyika';

  @override
  String get checkoutRecoveryStillStuck => 'Bado umekwama?';

  @override
  String get checkoutRecoveryGetHelp => 'Pata msaada';

  @override
  String get checkoutRecoveryLoading => 'Inapakia malipo…';

  @override
  String get checkoutRecoveryBranch => 'Tawi';

  @override
  String get checkoutRecoveryReady => 'Malipo yako tayari';

  @override
  String get checkoutRecoveryReadyBody =>
      'Uko tayari kupokea malipo. Bidhaa na jumla zitasawazishwa na tawi hili.';

  @override
  String get checkoutRecoveryOpenCheckout => 'Fungua malipo';

  @override
  String get checkoutRecoveryStillNoBranch =>
      'Bado hakuna tawi lililochaguliwa — chagua moja ili kuendelea.';

  @override
  String get checkoutRecoveryWhereQuestion => 'Mauzo haya yanafanyika wapi?';

  @override
  String get checkoutRecoverySetDefaultBranch =>
      'Weka kama tawi chaguo-msingi kwa kifaa hiki';

  @override
  String get checkoutRecoveryChooseBranch => 'Chagua tawi';

  @override
  String get checkoutRecoveryContinue => 'Endelea kwenye malipo';

  @override
  String get checkoutRecoveryChecking => 'Inakagua…';

  @override
  String get checkoutRecoveryTryAgain => 'Jaribu tena';

  @override
  String get checkoutRecoveryBranchLocation => 'Eneo la tawi';

  @override
  String get checkoutRecoveryHqBadge => 'MAKAO';

  @override
  String checkoutTransferToBranch(String branch) {
    return 'Hamishia $branch';
  }

  @override
  String get checkoutTransferNoItemsSelected => 'Hakuna bidhaa iliyochaguliwa';

  @override
  String get checkoutTransferToBranchLabel => 'Kwa tawi';

  @override
  String get checkoutTransferNoOtherBranches => 'Hakuna matawi mengine';

  @override
  String get checkoutTransferSelectBranch => 'Chagua tawi';

  @override
  String get checkoutTransferLoadBranchesFailed => 'Imeshindwa kupakia matawi';

  @override
  String get peersNetworkStatus => 'Hali ya mtandao';

  @override
  String get peersThisDeviceOnly =>
      'Kifaa hiki pekee — bado hakuna vifaa vingine kwenye mtandao.';

  @override
  String peersSyncedWith(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Imesawazishwa na vifaa $count kwenye mtandao.',
      one: 'Imesawazishwa na kifaa 1 kwenye mtandao.',
    );
    return '$_temp0';
  }

  @override
  String get peersLocalDevice => 'Kifaa hiki';

  @override
  String get peersOnline => 'Mtandaoni';

  @override
  String get peersConnectedPeers => 'Vifaa vilivyounganishwa';

  @override
  String get peersSyncNotInitialized => 'Huduma ya usawazishaji haijaanzishwa';

  @override
  String peersConnectedTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Imeunganishwa na vifaa $count. Gusa ili kuona maelezo.',
      one: 'Imeunganishwa na kifaa 1. Gusa ili kuona maelezo.',
    );
    return '$_temp0';
  }

  @override
  String get peersSearching => 'Inatafuta vifaa kwenye mtandao mmoja...';

  @override
  String get peersLive => 'Hai';

  @override
  String get peersNetworkCheckError => 'Hitilafu ya kukagua mtandao';

  @override
  String get peersNoOtherDevices => 'Hakuna vifaa vingine vilivyopatikana';

  @override
  String get peersOpenFlipperHint =>
      'Fungua Flipper kwenye kifaa kingine kwenye mtandao mmoja.';

  @override
  String get saleModeNormal => 'Mauzo ya kawaida';

  @override
  String get saleModeProforma => 'Proforma';

  @override
  String get saleModeTraining => 'Mafunzo';

  @override
  String get saleModeTitle => 'Hali ya mauzo';

  @override
  String get saleModeDescription =>
      'Aina ya risiti ambayo mauzo mapya hutolewa nayo. Iache kwenye Mauzo ya kawaida isipokuwa unafanya mazoezi au unatoa nukuu.';

  @override
  String get saleModeNormalSubtitle => 'Mauzo halisi ya kodi. Chaguo-msingi.';

  @override
  String get saleModeProformaSubtitle =>
      'Nukuu. Si risiti, hakuna mabadiliko ya hisa.';

  @override
  String get saleModeTrainingSubtitle =>
      'Mauzo ya mazoezi. Risiti za mafunzo haziwezi kushirikiwa wala kuchapishwa.';

  @override
  String get mposCartEmptyHint => 'Gusa bidhaa ili kuanza mauzo';

  @override
  String get mposCartReviewPay => 'Kagua na ulipe';

  @override
  String get mposCartLabel => 'Kikapu';

  @override
  String mposCartSummary(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count, RWF $total',
      one: 'Bidhaa 1, RWF $total',
    );
    return '$_temp0';
  }

  @override
  String mposCartItemsInCart(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count kwenye kikapu',
      one: 'Bidhaa 1 kwenye kikapu',
    );
    return '$_temp0';
  }

  @override
  String get mposDismiss => 'Funga';

  @override
  String get mposBackFromCheckout => 'Rudi kutoka kwenye malipo';

  @override
  String get mposScan => 'Changanua';

  @override
  String get mposRemovingCustomer => 'Inaondoa mteja…';

  @override
  String get mposAttachCustomer => 'Ambatisha mteja';

  @override
  String get mposWalkInCustomer => 'Mteja wa papo hapo';

  @override
  String get mposAttachCustomerHint => 'Gusa ili kuambatisha mteja (si lazima)';

  @override
  String get mposRemoveCustomer => 'Ondoa mteja';

  @override
  String mposCustomerAttachedToSale(String name) {
    return '$name ameambatishwa kwenye mauzo haya';
  }

  @override
  String mposCouldNotAttachCustomer(String error) {
    return 'Imeshindwa kuambatisha mteja: $error';
  }

  @override
  String get mposSearchNameOrPhone => 'Tafuta jina au simu';

  @override
  String get mposContinueAsWalkIn => 'Endelea bila mteja';

  @override
  String get mposNoCustomerOnSale => 'Hakuna mteja kwenye mauzo haya';

  @override
  String get mposAddNewCustomer => 'Ongeza mteja mpya';

  @override
  String mposItemQtyAtPrice(String qty, String price) {
    return '$qty kwa RWF $price';
  }

  @override
  String get mposDoneEditingPrice => 'Maliza kuhariri bei';

  @override
  String get mposEditPrice => 'Hariri bei';

  @override
  String mposDeleteItem(String name) {
    return 'Futa $name';
  }

  @override
  String get mposUnitPrice => 'Bei ya kimoja';

  @override
  String mposUnitPriceWithDefault(String price) {
    return 'Bei ya kimoja · ya kawaida RWF $price';
  }

  @override
  String mposUnitPriceFor(String name) {
    return 'Bei ya kimoja ya $name';
  }

  @override
  String mposResetPriceFor(String name) {
    return 'Rejesha bei ya $name';
  }

  @override
  String get mposDecreaseQuantity => 'Punguza kiasi';

  @override
  String get mposIncreaseQuantity => 'Ongeza kiasi';

  @override
  String get mposMomoPhoneNumber => 'Namba ya simu ya MoMo';

  @override
  String get mposCashReceivedAmount => 'Kiasi cha pesa taslimu kilichopokelewa';

  @override
  String mposCreditAmount(String amount) {
    return 'Kiasi cha mkopo · $amount';
  }

  @override
  String get mposCreditExplanation =>
      'Mauzo haya yanarekodiwa kwenye salio la mkopo la mteja. Ambatisha mteja kabla ya kukamilisha.';

  @override
  String mposPaymentLinesSplitHint(int count) {
    return 'Mistari $count ya malipo · tumia kugawanya katika hali ya kompyuta';
  }

  @override
  String get mposTax => 'Kodi';

  @override
  String get mposTotal => 'Jumla';

  @override
  String get mposAlreadyPaid => 'Tayari imelipwa';

  @override
  String get mposThisPayment => 'Malipo haya';

  @override
  String get mposBalanceDue => 'Salio linalodaiwa';

  @override
  String get posCartLineSubtotal => 'Jumla ndogo ya mstari';

  @override
  String get posCartEditQtyPrice => 'Hariri kiasi/bei';

  @override
  String get posCartHideDetails => 'Ficha maelezo';

  @override
  String get posCartRemoveLine => 'Ondoa mstari';

  @override
  String get posScanMode => 'Hali ya kuchanganua';

  @override
  String get posSendToTillNeedsCustomer =>
      'Hifadhi jina au namba ya simu ya mteja kwenye tiketi hii kabla ya kuituma kwenye kaunta.';

  @override
  String get posPreparingCheckout => 'Inaandaa malipo...';

  @override
  String get posShiftLoadFailed => 'Imeshindwa kupakia hali ya zamu';

  @override
  String get posShiftStartToSell => 'Anza zamu ili kuuza';

  @override
  String get posShiftStartHint =>
      'Fungua zamu ya droo ya pesa kabla ya kurekodi mauzo. Unaweza pia kufungua zamu kutoka upande wa menyu.';

  @override
  String get salesByCashierTitle => 'MAUZO KWA KILA KESHIA';

  @override
  String get salesByCashierByHand => 'Mkononi';

  @override
  String get startupTagline => 'Programu ya kimapinduzi ya biashara...';

  @override
  String get startupProgressLabel => 'Maendeleo ya kuanza';

  @override
  String get startupReady => 'Tayari';

  @override
  String get startupFinishingUp => 'Inakamilisha';

  @override
  String get startupConfirmingPlan => 'Inathibitisha mpango wako';

  @override
  String get startupSyncingData => 'Inasawazisha data yako';

  @override
  String get startupStartingServices => 'Inaanzisha huduma';

  @override
  String get startupCheckingWorkspace => 'Inakagua eneo lako la kazi';

  @override
  String get startupConnecting => 'Inaunganisha';

  @override
  String get topBarNotifications => 'Arifa';

  @override
  String get userInfoLoading => 'Inapakia...';

  @override
  String get userInfoFallbackName => 'Mtumiaji';

  @override
  String get userInfoSwitchBranch => 'Badilisha tawi';

  @override
  String get userInfoSwitchUser => 'Badilisha mtumiaji';

  @override
  String get variantDropdownBranchNotSelected =>
      'Tawi halijachaguliwa. Tafadhali chagua tawi.';

  @override
  String get variantDropdownNoVariantsHint =>
      'Hakuna aina zinazopatikana. Tafadhali unda aina kwanza.';

  @override
  String get variantDropdownNoVariants => 'Hakuna aina';

  @override
  String get variantDropdownSelect => 'Chagua aina';

  @override
  String get variantDropdownSearch => 'Tafuta aina...';

  @override
  String get variantDropdownLoadError => 'Hitilafu ya kupakia aina';

  @override
  String get variantImageSaveProductFirst => 'Hifadhi bidhaa ujaribu tena';

  @override
  String get variantImageUploadFailed =>
      'Imeshindwa kupakia picha. Tafadhali jaribu tena.';

  @override
  String get variantImageChange => 'Badilisha picha ya aina';

  @override
  String get variantImageAdd => 'Ongeza picha ya aina';

  @override
  String get waOptInScanTitle => 'Changanua ili kupokea risiti';

  @override
  String get waOptInSubtitle =>
      'Mteja lazima atume ujumbe mara moja kwa namba yako ya WhatsApp ya biashara ili tumtumie risiti ya kidijitali.';

  @override
  String get waOptInScanHint => 'Fungua WhatsApp → changanua kwa kamera';

  @override
  String get waOptInQueued =>
      'Risiti iko kwenye foleni. Mwombe mteja atume ujumbe kwa namba yako ya WhatsApp ya biashara, kisha PDF itatumwa kiotomatiki.';

  @override
  String get waOptInLinkCopied => 'Kiungo cha WhatsApp kimenakiliwa';

  @override
  String get waOptInCopy => 'Nakili';

  @override
  String waOptInReceiptPhone(String phone) {
    return 'Simu ya risiti: $phone';
  }

  @override
  String get kpiTotalSales => 'Jumla ya mauzo';

  @override
  String get kpiCollected => 'Imekusanywa';

  @override
  String get kpiOwed => 'Inadaiwa';

  @override
  String get printDelegationNoDevicesLoaded =>
      'Bado hakuna vifaa vilivyopakiwa kwa tawi hili. Hakikisha kompyuta nyingine zimeingia na ziko mtandaoni, kisha fungua skrini hii tena.';

  @override
  String get printDelegationOnlyThisDesktop =>
      'Ni kompyuta hii pekee iliyosajiliwa kwenye tawi hili. Ingia kwenye POS nyingine ya Windows, macOS au Linux ili kuikabidhi uchapishaji.';

  @override
  String get printDelegationNoDesktops =>
      'Kuna vifaa vingine kwenye tawi hili lakini hakuna kompyuta (device_name lazima iwe windows, macos au linux).';

  @override
  String get printDelegationNoOtherDesktops =>
      'Hakuna kompyuta nyingine iliyopatikana kwenye tawi hili';

  @override
  String get printDelegationDeviceNameSaved => 'Jina la kifaa limehifadhiwa';

  @override
  String printDelegationDeviceNameSaveFailed(String error) {
    return 'Imeshindwa kuhifadhi jina la kifaa: $error';
  }

  @override
  String get printDelegationDeviceSelected =>
      'Kifaa cha kukabidhi kimechaguliwa';

  @override
  String printDelegationSelectDeviceError(String error) {
    return 'Hitilafu ya kuchagua kifaa: $error';
  }

  @override
  String get printDelegationEnabled => 'Ukabidhi wa uchapishaji umewashwa';

  @override
  String get printDelegationDisabled => 'Ukabidhi wa uchapishaji umezimwa';

  @override
  String get printDelegationTitle => 'Ukabidhi wa uchapishaji';

  @override
  String get printDelegationMobileDescription =>
      'Kabidhi uchapishaji wa risiti kwa kompyuta seva ya EBM isipopatikana';

  @override
  String get printDelegationDesktopDescription =>
      'Shughulikia risiti zilizokabidhiwa na simu, au kabidhi uchapishaji kwa kompyuta nyingine';

  @override
  String get printDelegationGenericDescription =>
      'Uchakataji wa miamala kati ya vifaa';

  @override
  String get printDelegationThisDevice => 'Kifaa hiki (kinapokea ukabidhi)';

  @override
  String get printDelegationThisDeviceHint =>
      'Vifaa vingine vya POS lazima vilenge kitambulisho hiki katika mipangilio yao ya ukabidhi. Mashine hii haionekani kwenye orodha hapa chini kwa sababu huwezi kujikabidhi uchapishaji.';

  @override
  String get printDelegationDeviceIdMissing =>
      'Kitambulisho cha kifaa bado hakijasajiliwa — anzisha programu upya au ingia tena.';

  @override
  String printDelegationDeviceName(String name) {
    return 'Jina la kifaa: $name';
  }

  @override
  String get printDelegationFriendlyName =>
      'Jina rahisi (linaonekana kwa vifaa vingine)';

  @override
  String get printDelegationFriendlyNameHint => 'mf. Printa ya kaunta ya mbele';

  @override
  String get printDelegationMobileTargetHint =>
      'Chagua kompyuta ya uchapishaji hapa chini. Kwenye kompyuta hiyo, fungua Usimamizi → Ukabidhi wa uchapishaji na unakili kitambulisho kamili cha \"Kifaa hiki\" — lazima kilingane na chaguo lako hapa.';

  @override
  String get printDelegationDelegateToDesktop =>
      'Kabidhi uchapishaji kwa kompyuta nyingine';

  @override
  String printDelegationPlatform(String platform) {
    return 'Jukwaa: $platform';
  }

  @override
  String printDelegationPhone(String phone) {
    return 'Simu: $phone';
  }

  @override
  String printDelegationLoadDevicesError(String error) {
    return 'Hitilafu ya kupakia vifaa: $error';
  }

  @override
  String get printDelegationHowItWorks => 'Jinsi inavyofanya kazi';

  @override
  String get printDelegationMobileStep1 =>
      'Simu inakamilisha muamala lakini inakabidhi utengenezaji wa risiti';

  @override
  String get printDelegationMobileStep2 =>
      'Kompyuta inapokea muamala kupitia usawazishaji';

  @override
  String get printDelegationMobileStep3 =>
      'Kompyuta inatengeneza risiti na kuwasiliana na seva ya EBM';

  @override
  String get printDelegationMobileStep4 =>
      'Simu inaarifiwa uchakataji ukikamilika';

  @override
  String get printDelegationDesktopStep1 =>
      'Kompyuta inafuatilia miamala iliyokabidhiwa papo hapo';

  @override
  String get printDelegationDesktopStep2 =>
      'Inashughulikia risiti kutoka kwa simu kiotomatiki';

  @override
  String get printDelegationDesktopStep3 =>
      'Hiari: chagua kompyuta nyingine hapa chini ili kukabidhi uchapishaji wa kifaa hiki';

  @override
  String get printDelegationDesktopStep4 =>
      'Inashughulikia mawasiliano na seva ya EBM';

  @override
  String get printDelegationDesktopStep5 =>
      'Inarudisha matokeo kwa simu kupitia usawazishaji';

  @override
  String printDelegationCopiedDeviceId(String id) {
    return 'Kitambulisho cha kifaa kimenakiliwa: $id';
  }

  @override
  String get printDelegationCopyDeviceId => 'Nakili kitambulisho cha kifaa';

  @override
  String get refundReasonDuplicate => 'Malipo yaliyorudiwa';

  @override
  String get refundReasonOther => 'Nyingine';

  @override
  String get refundAlreadyRefunded => 'Tayari imerejeshwa';

  @override
  String get refundPaymentTitle => 'Rejesha malipo';

  @override
  String get refundIncomeRefunded => 'Mapato haya yamerejeshwa';

  @override
  String get refundReturnMoney => 'Mrudishie mteja pesa';

  @override
  String get refundMoreActions => 'Vitendo zaidi';

  @override
  String refundIncomeReference(String reference) {
    return 'Mapato · $reference';
  }

  @override
  String get refundShareReceipt => 'Shiriki risiti';

  @override
  String get refundShareReceiptSubtitle =>
      'Tuma kupitia WhatsApp, SMS au barua pepe';

  @override
  String get refundShareCopySubtitle =>
      'Tuma nakala ya mauzo kupitia WhatsApp, SMS au barua pepe';

  @override
  String get refundDownloadPdf => 'Pakua PDF';

  @override
  String get refundDownloadReceiptSubtitle => 'Hifadhi nakala ya risiti hii';

  @override
  String get refundDownloadCopySubtitle =>
      'Hifadhi mauzo haya kama nakala ya PDF';

  @override
  String get refundPrintSubtitle => 'Tuma kwa printa iliyounganishwa';

  @override
  String refundReturnMoneyFor(String reference) {
    return 'Rejesha pesa za $reference';
  }

  @override
  String get refundHowMuch => 'Kiasi gani?';

  @override
  String get refundFull => 'Kurejesha kamili';

  @override
  String get refundPartial => 'Sehemu';

  @override
  String get refundChooseAmount => 'Chagua kiasi';

  @override
  String refundCannotExceed(String amount) {
    return 'Haiwezi kuzidi kiasi cha awali cha $amount';
  }

  @override
  String refundUpToAvailable(String amount) {
    return 'Hadi $amount inapatikana kurejesha';
  }

  @override
  String get refundReasonLabel => 'Sababu';

  @override
  String get refundTo => 'Rejesha kupitia';

  @override
  String get refundHandBackNow => 'Mrudishie sasa';

  @override
  String get refundSendToPhone => 'Tuma kwa simu';

  @override
  String refundAmountButton(String amount) {
    return 'Rejesha $amount';
  }

  @override
  String get refundOriginalPayment => 'Malipo ya awali';

  @override
  String get refundProcessing => 'Inashughulikia urejeshaji…';

  @override
  String get refundStepValidating => 'Kuthibitisha urejeshaji';

  @override
  String get refundStepRestoringStock => 'Kurejesha hisa';

  @override
  String get refundStepSavingRecords => 'Kuhifadhi kumbukumbu';

  @override
  String get refundMethodCashLower => 'pesa taslimu';

  @override
  String get refundCompleted => 'Urejeshaji umekamilika';

  @override
  String refundDoneSuffix(String method) {
    return 'imerejeshwa kwa mteja kupitia $method.';
  }

  @override
  String get refundSheetUnavailable => 'Urejeshaji haupatikani';

  @override
  String get internetRequiredTitle => 'Muunganisho wa intaneti unahitajika';

  @override
  String get internetRequiredBody =>
      'Unahitaji kuunganishwa na intaneti ili kuendelea kutumia Flipper. Mfumo wetu unahitaji muunganisho wa intaneti kila siku 5 ili kuthibitisha akaunti yako.';

  @override
  String get internetRequiredCheck => 'Angalia muunganisho';

  @override
  String get internetRequiredHint =>
      'Ukiendelea kuona skrini hii, tafadhali angalia muunganisho wako wa intaneti ujaribu tena.';

  @override
  String get addCustomerOpening => 'Inafungua…';

  @override
  String get mposStatusPending => 'Inasubiri';

  @override
  String get mposStatusCompleted => 'Imekamilika';

  @override
  String get mposStatusPaid => 'Imelipwa';

  @override
  String get mposStatusCancelled => 'Imeghairiwa';

  @override
  String get mposStatusParked => 'Imeegeshwa';

  @override
  String get mposPriceEdited => 'imehaririwa';

  @override
  String get balancesExpenses => 'Matumizi';

  @override
  String adminChannelNumber(String number) {
    return 'Chaneli $number';
  }

  @override
  String get adminInvalidSmsPhone =>
      'Weka nambari ya simu sahihi pamoja na msimbo wa nchi (mfano: +250783054874)';

  @override
  String get adminSmsConfigUpdateFailed =>
      'Imeshindwa kusasisha usanidi wa SMS';

  @override
  String get transactionReportsTitle => 'Ripoti za miamala';

  @override
  String get productNewCategory => 'Kundi jipya';

  @override
  String get productCategoryDescription =>
      'Kundi huweka pamoja bidhaa zinazofanana.';

  @override
  String get productCategoryName => 'Jina la kundi';

  @override
  String get productCategoryNameHint =>
      'mfano: Vinywaji, Mkate, Muda wa maongezi';

  @override
  String get productCategoryNameTooShort => 'Andika angalau herufi 2.';

  @override
  String get productCategoryCreateFailed =>
      'Imeshindwa kuunda kundi. Tafadhali jaribu tena.';

  @override
  String productCategoryAlreadyExists(String name) {
    return '\"$name\" tayari lipo.';
  }

  @override
  String productCategoryUseExisting(String name) {
    return 'Tumia \"$name\"';
  }

  @override
  String get productCreateCategory => 'Unda kundi';

  @override
  String get serviceModeBarMode => 'Hali ya baa';

  @override
  String get serviceModeHotelMode => 'Hali ya hoteli';

  @override
  String get serviceModeBarCounter => 'Kaunta ya baa';

  @override
  String get serviceModeFrontDesk => 'Mapokezi';

  @override
  String get serviceModeAdminOnly =>
      'Msimamizi pekee ndiye anaweza kubadilisha hali ya huduma ya kifaa hiki.';

  @override
  String serviceModeSwitchNotSaved(String mode) {
    return 'Imeshindwa kubadili kwenda $mode: mipangilio ya tawi haikuhifadhiwa. Angalia muunganisho wako na ujaribu tena.';
  }

  @override
  String serviceModeSwitched(String mode, String hotkey) {
    return 'Kifaa hiki kimebadilika kwenda $mode · $hotkey kubadili tena';
  }

  @override
  String get serviceModeSwitchFailed =>
      'Imeshindwa kubadilisha hali ya huduma.';

  @override
  String serviceModeDeviceNowRuns(String mode) {
    return 'Kifaa hiki sasa kinaendesha $mode.';
  }

  @override
  String serviceModeDeviceFollowsBranch(String mode) {
    return 'Kifaa hiki kinafuata tena chaguo-msingi la tawi ($mode).';
  }

  @override
  String get serviceModeThisDevice => 'Kifaa hiki';

  @override
  String get serviceModeWhatTerminalOpens => 'Kile kituo hiki kinafungua';

  @override
  String get serviceModeBranchRunsBoth =>
      'Tawi hili linaendesha vyote viwili. Weka mapokezi kwenye kituo cha mapokezi na meza kwenye kaunta ya baa — kila kifaa kinabaki na chaguo lake.';

  @override
  String get serviceModePickAfterLogin =>
      'Chagua kile skrini hii inaonyesha baada ya kuingia. Vifaa vingine vya tawi hili vinabaki na chaguo lao.';

  @override
  String get serviceModePinnedOnDevice =>
      'Imebandikwa kwenye kifaa hiki pekee.';

  @override
  String get serviceModeUseBranchDefault => 'Tumia chaguo-msingi la tawi';

  @override
  String get barRoomChargePickerSubtitle =>
      'Bili inahamishiwa kwenye akaunti ya mgeni na hulipwa wakati wa kuondoka.';

  @override
  String get barRoomChargeEmptyTab =>
      'Ongeza kitu kwenye bili kabla ya kuitoza chumba.';

  @override
  String barRoomChargeMoved(String table, String target, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count',
      one: 'Bidhaa 1',
    );
    return '$table → $target · $_temp0 kwenye akaunti';
  }

  @override
  String get barTables => 'Meza';

  @override
  String barFloorOpenTapToLog(String count) {
    return '$count zimefunguliwa · gusa kuandika oda';
  }

  @override
  String barFloorOpenTapTableToLog(String count) {
    return '$count zimefunguliwa · gusa meza kuandika oda yake';
  }

  @override
  String get barOpenTab => 'Bili iliyo wazi';

  @override
  String get barTableFree => 'Wazi';

  @override
  String get barRoleServer => 'Mhudumu';

  @override
  String barCashierLogging(String role) {
    return '$role · kazini';
  }

  @override
  String get barNoTablesConfigured => 'Hakuna meza zilizowekwa';

  @override
  String barZoneOpenCount(String open, String total) {
    return '$open/$total zimefunguliwa';
  }

  @override
  String get barCouldNotLoadStaff => 'Imeshindwa kupakia wafanyakazi';

  @override
  String get barModeSharedRegister => 'Hali ya baa · Rejista ya pamoja';

  @override
  String get barWhosServing => 'Nani anahudumu?';

  @override
  String get barWhosOnRegister => 'Nani yuko kwenye rejista?';

  @override
  String get barLockHintTapAbove =>
      'Gusa jina lako hapo juu, kisha weka PIN yako';

  @override
  String get barLockHintTapLeft =>
      'Gusa jina lako upande wa kushoto, kisha weka PIN yako';

  @override
  String get barLockHintEnterPin =>
      'Weka PIN yako ya tarakimu 6 ili kuandika oda';

  @override
  String get barConfiguredByAdmin =>
      'Hali ya baa imewekwa na msimamizi kwenye kituo kikuu';

  @override
  String get barStaffFallback => 'Mfanyakazi';

  @override
  String get barSaveToTab => 'Hifadhi kwenye bili';

  @override
  String barFreshTabFor(String table) {
    return 'Bili mpya ya $table';
  }

  @override
  String get barTapProductFirstRound => 'Gusa bidhaa kuongeza raundi ya kwanza';

  @override
  String get barTapProductsFirstRound =>
      'Gusa bidhaa kuongeza raundi ya kwanza';

  @override
  String barLoggedByStaff(String count, String mine) {
    return 'Imeandikwa na wafanyakazi $count · wewe umeongeza $mine';
  }

  @override
  String barYouLoggedLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Umeandika mistari $count kwenye bili hii',
      one: 'Umeandika mstari 1 kwenye bili hii',
    );
    return '$_temp0';
  }

  @override
  String get barTabTotal => 'Jumla ya bili';

  @override
  String barTabTotalItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count',
      one: 'Bidhaa 1',
    );
    return 'Jumla ya bili · $_temp0';
  }

  @override
  String get barSettleAndClose => 'Lipa bili na funga meza';

  @override
  String get barSettleManagerPin => 'Lipa bili · PIN ya meneja';

  @override
  String get barChargeToRoom => 'Toza chumba';

  @override
  String barPriceEach(String price) {
    return '$price kila moja';
  }

  @override
  String get barHideDetails => 'Ficha maelezo';

  @override
  String get barEditPriceQty => 'Hariri bei na idadi';

  @override
  String barTableMetaOpened(String seats, String time, String elapsed) {
    return 'Viti $seats · ilifunguliwa saa $time · $elapsed';
  }

  @override
  String barTableMetaOpenedBy(
    String seats,
    String time,
    String opener,
    String elapsed,
  ) {
    return 'Viti $seats · ilifunguliwa saa $time na $opener · $elapsed';
  }

  @override
  String barOpenedAtElapsed(String time, String elapsed) {
    return 'Ilifunguliwa saa $time • $elapsed';
  }

  @override
  String get barSettleRoomChargeSubtitle =>
      'Bili inahamishiwa kwenye akaunti ya mgeni na hutozwa wakati wa kuondoka.';

  @override
  String get barSettleChooseMethod =>
      'Chagua njia na pokea malipo ili kufunga meza.';

  @override
  String get barMobileMoney => 'Pesa ya simu';

  @override
  String get barPickGuestForBill =>
      'Chagua mgeni ambaye akaunti yake itachukua bili hii.';

  @override
  String barRoomChargeNoMoney(String target) {
    return 'Hakuna pesa inayolipwa sasa: mistari hii inaongezwa kwenye $target na risiti hutolewa mgeni anapoondoka.';
  }

  @override
  String get barEnterAmountTendered => 'Weka kiasi kilichotolewa';

  @override
  String barAmountDue(String amount) {
    return '$amount inadaiwa';
  }

  @override
  String get barMomoPushNotice =>
      'Ombi la malipo litatumwa kwenye simu ya mteja.';

  @override
  String barChargeToRoomTotal(String amount) {
    return 'Toza chumba — $amount';
  }

  @override
  String barChargeRoomTotal(String room, String amount) {
    return 'Toza chumba $room — $amount';
  }

  @override
  String barConfirmPaymentTotal(String amount) {
    return 'Thibitisha malipo — $amount';
  }

  @override
  String barChargeToRoomTotalShort(String amount) {
    return 'Toza chumba · $amount';
  }

  @override
  String barChargeRoomTotalShort(String room, String amount) {
    return 'Toza chumba $room · $amount';
  }

  @override
  String barConfirmTotalShort(String amount) {
    return 'Thibitisha · $amount';
  }

  @override
  String get barRoomChargeFootnote =>
      'Meza inakuwa wazi sasa; akaunti italipwa mapokezi.';

  @override
  String get barCloseTableFootnote =>
      'Kufunga meza kunahifadhi mauzo na kuiacha wazi kwa wateja wapya.';

  @override
  String get barInvalidReceiptPhone =>
      'Weka nambari sahihi ya simu ya risiti yenye tarakimu 9.';

  @override
  String barSettledToast(String table, String amount, String method) {
    return '$table imelipwa · $amount $method';
  }

  @override
  String get barBackToTab => 'Rudi kwenye bili';

  @override
  String barSettleBillZone(String zone) {
    return 'Lipa bili · $zone';
  }

  @override
  String barSettleZone(String zone) {
    return 'Lipa · $zone';
  }

  @override
  String get barSettlingAsManager => 'Unalipisha kama meneja';

  @override
  String barTableRunningTab(String table) {
    return 'Meza $table — bili inayoendelea';
  }

  @override
  String barServerName(String name) {
    return '$name · Mhudumu';
  }

  @override
  String get barSubtotalExclVat => 'Jumla ndogo (bila VAT)';

  @override
  String get barVat18 => 'VAT 18%';

  @override
  String get barTotalDue => 'Jumla inayodaiwa';

  @override
  String get barReceiptPhoneNumber => 'Nambari ya simu ya risiti *';

  @override
  String get barReceiptPhoneRequired =>
      'Inahitajika — huchapishwa kwenye risiti ya RRA (TEL).';

  @override
  String get barInvalidMobileNumber =>
      'Weka nambari sahihi ya simu yenye tarakimu 9 (mfano 783054874).';

  @override
  String get barUnnamedProduct => 'Bidhaa isiyo na jina';

  @override
  String get barNoProductsMatch =>
      'Hakuna bidhaa inayolingana na utafutaji wako';

  @override
  String get barRoomChargeTileSubtitle => 'Mtoze mgeni anayekaa kwetu';

  @override
  String get barChoose => 'Chagua';

  @override
  String get barChange => 'Badilisha';

  @override
  String get barRunningTab => 'Bili inayoendelea';

  @override
  String barZoneItemCount(String zone, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count',
      one: 'Bidhaa 1',
    );
    return '$zone · $_temp0';
  }

  @override
  String get barBackToTables => 'Rudi kwenye meza';

  @override
  String get barRemoveStaffTitle => 'Ondoa mfanyakazi';

  @override
  String barRemoveStaffBody(String name) {
    return 'Ondoa $name kwenye timu yako? Atapoteza ufikiaji wa PIN kwa biashara hii.';
  }

  @override
  String get barThisStaffMember => 'mfanyakazi huyu';

  @override
  String get barStaffRemoved => 'Mfanyakazi ameondolewa';

  @override
  String get barStaffRemoveFailed =>
      'Imeshindwa kumwondoa mfanyakazi. Tafadhali jaribu tena.';

  @override
  String get barModeAlongsideHotel =>
      'Hali ya baa imewashwa pamoja na hali ya hoteli — chagua hapa chini kifaa hiki kinaendesha nini.';

  @override
  String get barAdminServiceMode => 'Hali ya huduma';

  @override
  String get barRequirePinTitle => 'Hitaji PIN kubadilisha keshia';

  @override
  String get barRequirePinSubtitle =>
      'Kila keshia anaingia kwa PIN yake ya tarakimu 6 kabla ya kuongeza kwenye bili.';

  @override
  String get barFloorFirstTitle => 'Fungua ramani ya meza unapoingia';

  @override
  String get barFloorFirstSubtitle =>
      'Baada ya kuingia kwa PIN, fika kwenye ramani ya meza badala ya kikapu kimoja.';

  @override
  String get barManagerSettleTitle => 'PIN ya meneja inahitajika kulipia';

  @override
  String get barManagerSettleSubtitle =>
      'PIN ya meneja pekee inaweza kupokea malipo na kufunga meza.';

  @override
  String get barAutoLogoutTitle =>
      'Toka kiotomatiki baada ya kuhifadhi kwenye bili';

  @override
  String get barAutoLogoutSubtitle =>
      'Rudi kwenye kufuli ya PIN baada ya Hifadhi kwenye bili.';

  @override
  String get barAdminFloorTables => 'Ukumbi na meza';

  @override
  String get barAdminStaffPins => 'Wafanyakazi na PIN';

  @override
  String get barNoStaffYet =>
      'Bado hakuna wafanyakazi. Ongeza watumiaji kwenye Usimamizi wa Watumiaji — wataonekana hapa na PIN zao.';

  @override
  String get barOpenPosWithBarMode => 'Fungua POS kwa hali ya baa';

  @override
  String get barTableServiceTitle => 'Huduma ya mezani (hali ya baa)';

  @override
  String barModeDescription(String hotkey) {
    return 'Hugeuza kaunta kuwa kituo cha baa cha pamoja: wafanyakazi huweka bili inayoendelea kwa kila meza, hurekodi oda kwa PIN zao wenyewe, na hupokezana kati ya keshia bila kupoteza bili. Acha imezimwa kwa mauzo ya kawaida. Kwenye kibodi, $hotkey hubadilisha Baa → Hoteli → POS bila kurudi hapa.';
  }

  @override
  String barCloseTabBeforeDeleting(String table) {
    return 'Funga bili iliyo wazi ya $table kabla ya kufuta.';
  }

  @override
  String barSaveTableFailed(String table, String error) {
    return 'Imeshindwa kuhifadhi $table: $error';
  }

  @override
  String get barDeleteTableQuestion => 'Futa meza?';

  @override
  String barRemoveTableBody(String table) {
    return 'Ondoa $table kwenye ramani ya ukumbi?';
  }

  @override
  String barCloseZoneTabsBeforeDeleting(String zone) {
    return 'Funga bili zilizo wazi katika $zone kabla ya kufuta eneo.';
  }

  @override
  String get barDeleteZoneQuestion => 'Futa eneo?';

  @override
  String barRemoveZoneBody(String zone, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'meza $count',
      one: 'meza 1',
    );
    return 'Ondoa $zone na $_temp0 zake?';
  }

  @override
  String get barDeleteZone => 'Futa eneo';

  @override
  String get barNoTablesConfiguredYet => 'Bado hakuna meza zilizowekwa.';

  @override
  String get barLoadDefaultFloorPlan => 'Pakia ramani ya kawaida ya ukumbi';

  @override
  String get barAddZone => 'Ongeza eneo';

  @override
  String barTablesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Meza $count',
      one: 'Meza 1',
    );
    return '$_temp0';
  }

  @override
  String get barAddTable => 'Ongeza meza';

  @override
  String get barDeleteTable => 'Futa meza';

  @override
  String get barSeatsLabel => 'VITI';

  @override
  String get barZoneName => 'Jina la eneo';

  @override
  String get barZoneNameHint => 'mfano: Uwanja';

  @override
  String get barSettleNeedsManagerPin =>
      'Kulipia bili kunahitaji PIN ya meneja.';

  @override
  String get barCanSettleBills => 'anaweza kulipia bili';

  @override
  String get barLogsOrders => 'anarekodi oda';

  @override
  String get barWrongPinTryAgain => 'PIN si sahihi — jaribu tena';

  @override
  String get barSelectYourName => 'Chagua jina lako';

  @override
  String get barOpenStatus => 'Wazi';

  @override
  String barSeatsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Viti $count',
      one: 'Kiti 1',
    );
    return '$_temp0';
  }

  @override
  String barOpenedAt(String time) {
    return 'Imefunguliwa saa $time';
  }

  @override
  String barOpenedAtBy(String time, String name) {
    return 'Imefunguliwa saa $time na $name';
  }

  @override
  String barElapsedOpen(String elapsed) {
    return 'wazi kwa $elapsed';
  }

  @override
  String barItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count',
      one: 'Bidhaa 1',
    );
    return '$_temp0';
  }

  @override
  String get barTapProductsToStartTab => 'Gusa bidhaa ili kuanza bili';

  @override
  String get barViewTab => 'Tazama bili';

  @override
  String get hotelAutoRoomChargeOff =>
      'Malipo ya chumba ya kiotomatiki yamezimwa — tumia + Ada ya chumba';

  @override
  String hotelRoomChargeNotPosted(String error) {
    return 'Ada ya chumba haijawekwa: $error';
  }

  @override
  String hotelRoomHeldFor(String room, String guest) {
    return 'Chumba $room kimehifadhiwa kwa $guest';
  }

  @override
  String get hotelSmsOutOfCredits =>
      'SMS haijatumwa — tawi limeishiwa na salio';

  @override
  String hotelQuotationNotSent(String reference) {
    return '$reference haikutumwa — jaribu tena';
  }

  @override
  String hotelQuotationEmailed(String reference, String email) {
    return '$reference imetumwa kwa barua pepe $email';
  }

  @override
  String hotelQuotationEmailFailed(String reference, String error) {
    return 'Imeshindikana kutuma $reference kwa barua pepe: $error';
  }

  @override
  String hotelQuotationBooked(String reference, String room) {
    return '$reference imehifadhiwa · Chumba $room kimeshikiliwa';
  }

  @override
  String hotelRoomNoLongerOnBranch(String room) {
    return 'Chumba $room hakipo tena kwenye tawi hili';
  }

  @override
  String hotelRoomCheckedOut(String room) {
    return 'Mgeni ametoka chumba $room';
  }

  @override
  String get hotelSignInWithPinToOpenDesk =>
      'Ingia kwa PIN yako ili kufungua mapokezi';

  @override
  String get hotelQuotationPdfTitle => 'NUKUU YA BEI';

  @override
  String get hotelPreparedFor => 'Imeandaliwa';

  @override
  String get hotelRoom => 'Chumba';

  @override
  String get hotelArrival => 'Kuwasili';

  @override
  String get hotelDeparture => 'Kuondoka';

  @override
  String get hotelNights => 'Usiku';

  @override
  String hotelNightsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Usiku $count',
      one: 'Usiku 1',
    );
    return '$_temp0';
  }

  @override
  String get hotelGuests => 'Wageni';

  @override
  String get hotelStay => 'Malazi';

  @override
  String hotelAdultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Watu wazima $count',
      one: 'Mtu mzima 1',
    );
    return '$_temp0';
  }

  @override
  String hotelChildrenCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Watoto $count',
      one: 'Mtoto 1',
    );
    return '$_temp0';
  }

  @override
  String hotelQuotationRoomLine(String room, String nights, String rate) {
    return 'Chumba $room — $nights × $rate';
  }

  @override
  String get hotelExtras => 'Ziada';

  @override
  String get hotelDescription => 'Maelezo';

  @override
  String get hotelTotal => 'Jumla';

  @override
  String get hotelQuotationHoldsNoRoom =>
      'Nukuu hii haishikilii chumba hadi ikubaliwe.';

  @override
  String hotelQuotationExpiredOn(String date) {
    return 'Imeisha muda $date';
  }

  @override
  String hotelQuotationValidUntil(String date) {
    return 'Halali hadi $date';
  }

  @override
  String get hotelNote => 'Kumbuka';

  @override
  String get hotelQuotationTerms =>
      'Bei ni kwa chumba kwa usiku na kulingana na upatikanaji. Nukuu haishikilii chumba hadi ikubaliwe na kuthibitishwa na mapokezi.';

  @override
  String get hotelManagerApprovedToast =>
      'Meneja ameidhinisha — gusa Kutoka ili kulipa';

  @override
  String hotelCalendarTapFreeNight(String month) {
    return 'Gusa usiku ulio wazi ili kushikilia chumba · $month';
  }

  @override
  String get hotelLegendFree => 'Wazi';

  @override
  String get hotelLegendReserved => 'Kimehifadhiwa';

  @override
  String get hotelLegendInHouse => 'Kina mgeni';

  @override
  String get hotelLegendBlocked => 'Kimezuiwa';

  @override
  String get hotelToday => 'Leo';

  @override
  String get hotelNoRoomsYet => 'Bado hakuna vyumba kwenye tawi hili.';

  @override
  String hotelFreeRoomsCount(int count) {
    return '$count wazi';
  }

  @override
  String hotelCalendarFreeTapToHold(String room) {
    return 'Wazi — gusa ili kushikilia $room';
  }

  @override
  String get hotelBlockedForMaintenance => 'Kimezuiwa kwa matengenezo';

  @override
  String get hotelTodayAtProperty => 'Leo hotelini';

  @override
  String get hotelGoodDay => 'Siku njema';

  @override
  String hotelGoodDayName(String name) {
    return 'Siku njema, $name';
  }

  @override
  String hotelOccupancySummary(int occupied, int sellable, int guests) {
    String _temp0 = intl.Intl.pluralLogic(
      guests,
      locale: localeName,
      other: 'Wageni $guests',
      one: 'Mgeni 1',
    );
    return 'Vyumba $occupied kati ya $sellable vinavyouzwa vina wageni · $_temp0 ndani';
  }

  @override
  String get hotelOccupancy => 'ya ukaaji';

  @override
  String get hotelArrivalsToday => 'Wanaowasili leo';

  @override
  String hotelInNextSevenDays(int count) {
    return '$count katika siku 7 zijazo';
  }

  @override
  String get hotelDeparturesToday => 'Wanaoondoka leo';

  @override
  String hotelOverdueCount(int count) {
    return '$count wamechelewa';
  }

  @override
  String get hotelNoneOverdue => 'hakuna aliyechelewa';

  @override
  String get hotelAvailableRooms => 'Vyumba vilivyo wazi';

  @override
  String hotelAwaitingCleaningCount(int count) {
    return '$count vinasubiri usafi';
  }

  @override
  String get hotelPendingPayments => 'Malipo yanayosubiriwa';

  @override
  String hotelOpenFoliosCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bili $count zilizo wazi',
      one: 'Bili 1 iliyo wazi',
    );
    return '$_temp0';
  }

  @override
  String get hotelRoomRevenueTonight => 'Mapato ya vyumba usiku huu';

  @override
  String get hotelContractedInHouse => 'yaliyokubaliwa kwa wageni waliopo';

  @override
  String get hotelOpenQuotations => 'Nukuu zilizo wazi';

  @override
  String hotelAmountQuoted(String amount) {
    return '$amount zimenukuliwa';
  }

  @override
  String hotelStaysPastDeparture(int count, String rooms) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ukaaji $count umepita',
      one: 'Ukaaji 1 umepita',
    );
    return '$_temp0 muda wa kuondoka — $rooms';
  }

  @override
  String hotelRoomNamed(String room) {
    return 'Chumba $room';
  }

  @override
  String get hotelOpenBoard => 'Fungua ubao';

  @override
  String get hotelArrivingToday => 'Wanawasili leo';

  @override
  String get hotelNoArrivalsToday =>
      'Hakuna wageni waliohifadhiwa kuwasili leo.';

  @override
  String get hotelDepartingToday => 'Wanaondoka leo';

  @override
  String get hotelNoDeparturesToday => 'Hakuna anayetarajiwa kuondoka leo.';

  @override
  String get hotelOverdue => 'amechelewa';

  @override
  String get hotelCharges => 'Gharama';

  @override
  String hotelItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count',
      one: 'Bidhaa 1',
    );
    return '$_temp0';
  }

  @override
  String get hotelBackToRooms => 'Rudi kwenye vyumba';

  @override
  String hotelFolioOpenedBy(String name) {
    return 'Bili · imefunguliwa na $name';
  }

  @override
  String get hotelFrontDesk => 'mapokezi';

  @override
  String get hotelNoChargesYet =>
      'Bado hakuna gharama. Weka gharama ya chumba ili kuanza bili hii.';

  @override
  String get hotelAutoRoomChargeOffHelp =>
      'Malipo ya chumba ya kiotomatiki yamezimwa kwa tawi hili.\nTumia + Gharama ya chumba hapo juu, au iwashe tena kwenye Mipangilio → Hali ya hoteli.';

  @override
  String get hotelCancelStay => 'Ghairi ukaaji';

  @override
  String get hotelSettling => 'Inalipwa…';

  @override
  String hotelCheckOutAmount(String amount) {
    return 'Toka · $amount';
  }

  @override
  String get hotelPosting => 'Inawekwa…';

  @override
  String get hotelFolioNotFound =>
      'Bili haikupatikana — fungua chumba tena ujaribu';

  @override
  String hotelCheckoutFailed(String error) {
    return 'Kutoka kumeshindwa: $error';
  }

  @override
  String get hotelFrontDeskSharedRegister => 'Mapokezi · Kaunta ya pamoja';

  @override
  String get hotelLockHintEnterPin =>
      'Weka PIN yako ya tarakimu 6 ili kufungua mapokezi';

  @override
  String get hotelWhosOnDeskEyebrow => 'NANI YUKO MAPOKEZI?';

  @override
  String get hotelWhosOnDesk => 'Nani yuko mapokezi?';

  @override
  String get hotelSignInToReception => 'Ingia mapokezi';

  @override
  String get hotelNoStaffToShow =>
      'Hakuna wafanyakazi wa kuonyesha. Ongeza watumiaji kwenye Usimamizi wa Watumiaji — wataonekana hapa na PIN zao. Ikiwa kifaa hiki hakiko mtandaoni, kiunganishe mara moja ili wafanyakazi waweze kuingia bila mtandao baadaye.';

  @override
  String get hotelConfiguredByAdmin =>
      'Hali ya hoteli imesanidiwa na msimamizi kwenye kituo kikuu';

  @override
  String get hotelQuoteNew => 'Mpya';

  @override
  String get hotelNewQuotation => 'Nukuu mpya';

  @override
  String get hotelQuotations => 'Nukuu';

  @override
  String hotelQuotationsOpenSummary(int count) {
    return '$count zilizo wazi · nukuu haishikilii chumba hadi ikubaliwe';
  }

  @override
  String get hotelNoQuotationsYet =>
      'Bado hakuna nukuu.\nUnda moja ili kumpa mgeni bei ya ukaaji kabla hajathibitisha.';

  @override
  String get hotelQuoteStatusBooked => 'Imehifadhiwa';

  @override
  String get hotelQuoteStatusExpired => 'Imeisha muda';

  @override
  String get hotelQuoteStatusDeclined => 'Imekataliwa';

  @override
  String get hotelQuoteStatusAccepted => 'Imekubaliwa';

  @override
  String get hotelQuoteStatusSent => 'Imetumwa';

  @override
  String get hotelQuoteStatusDraft => 'Rasimu';

  @override
  String hotelRoomWithType(String room, String type) {
    return 'Chumba $room · $type';
  }

  @override
  String hotelQuoteEmailedAt(String date) {
    return 'Imetumwa kwa barua pepe $date';
  }

  @override
  String hotelQuoteValidTo(String date) {
    return 'halali hadi $date';
  }

  @override
  String get hotelQuoteDocument => 'Hati';

  @override
  String get hotelQuoteEmailToGuest => 'Mtumie mgeni kwa barua pepe';

  @override
  String get hotelQuoteEmailPdfToGuest => 'Mtumie mgeni PDF kwa barua pepe';

  @override
  String get hotelQuoteAddEmailFirst => 'Ongeza barua pepe kwanza';

  @override
  String get hotelQuoteDownloadPdf => 'Pakua PDF';

  @override
  String get hotelQuotePrint => 'Chapisha';

  @override
  String get hotelQuoteOpenPrintDialog => 'Fungua dirisha la kuchapisha';

  @override
  String hotelQuotationHeader(String reference) {
    return 'NUKUU $reference';
  }

  @override
  String get hotelEmailLooksWrong => 'Barua pepe hiyo haionekani sahihi';

  @override
  String get hotelEmailThisQuotation => 'Tuma nukuu hii kwa barua pepe';

  @override
  String get hotelPdfGoesAsAttachment => 'PDF inatumwa kama kiambatisho.';

  @override
  String get hotelGuestEmail => 'Barua pepe ya mgeni';

  @override
  String get hotelEmailSavedToQuotation =>
      'Inahifadhiwa kwenye nukuu, kwa hivyo utumaji ujao hauhitaji kuandika tena.';

  @override
  String get hotelSendQuotation => 'Tuma nukuu';

  @override
  String get hotelAcceptAndHold => 'Kubali na ushikilie';

  @override
  String hotelRemoveQuotationTitle(String reference) {
    return 'Ondoa $reference?';
  }

  @override
  String hotelRemoveQuotationBody(String guest) {
    return 'Hii inafuta nukuu ya $guest. Uhifadhi wowote uliokwisha kuundwa haubadiliki.';
  }

  @override
  String get hotelPreparingQuotation => 'Inaandaa nukuu…';

  @override
  String get hotelQuotation => 'Nukuu';

  @override
  String hotelQuotationRef(String reference) {
    return 'Nukuu $reference';
  }

  @override
  String get hotelEmailUs => 'sisi';

  @override
  String hotelEmailValidUntil(String date) {
    return 'Nukuu hii ni halali hadi $date.';
  }

  @override
  String hotelEmailYourQuotation(String reference) {
    return 'Nukuu yako, $reference';
  }

  @override
  String hotelEmailHtmlIntro(
    String guest,
    String business,
    String room,
    String nights,
  ) {
    return 'Habari $guest, asante kwa kuchagua $business. Nukuu yako ya Chumba $room kwa $nights imeambatishwa kama PDF.';
  }

  @override
  String get hotelEmailHoldsNoRoom =>
      'Nukuu haishikilii chumba hadi ikubaliwe — jibu barua pepe hii au utupigie simu kuthibitisha.';

  @override
  String hotelEmailHello(String guest) {
    return 'Habari $guest,';
  }

  @override
  String hotelEmailPlainIntro(String business, String reference, String room) {
    return 'Asante kwa kuchagua $business. Nukuu yako $reference ya Chumba $room imeambatishwa kama PDF.';
  }

  @override
  String get hotelEmailPlainHoldsNoRoom =>
      'Nukuu haishikilii chumba hadi ikubaliwe — jibu au utupigie simu kuthibitisha.';

  @override
  String get hotelFrontDeskTitle => 'Mapokezi';

  @override
  String hotelBoardSubtitle(String fraction) {
    return '$fraction vina wageni · gusa chumba ili kusajili mgeni au kufungua bili yake';
  }

  @override
  String hotelOccupiedFraction(String fraction) {
    return '$fraction vina wageni';
  }

  @override
  String hotelRoleOnDuty(String role) {
    return '$role · kazini';
  }

  @override
  String get hotelReception => 'Mapokezi';

  @override
  String get hotelSettings => 'Mipangilio';

  @override
  String get hotelHandOver => 'Kabidhi zamu';

  @override
  String get hotelHandOverDesk => 'Kabidhi mapokezi';

  @override
  String hotelCouldNotLoadBoard(String error) {
    return 'Imeshindwa kupakia ubao.\n$error';
  }

  @override
  String get hotelGuestNameRequired => 'Jina la mgeni linahitajika';

  @override
  String hotelRoomMaxCapacity(String room, String capacity) {
    return 'Chumba $room: idadi ya juu ni $capacity';
  }

  @override
  String get hotelEmailInvalid => 'Barua pepe hii haionekani sahihi';

  @override
  String hotelCheckInTitle(String room) {
    return 'Kuingia · Chumba $room';
  }

  @override
  String hotelRoomTypeSleeps(String type, String capacity) {
    return '$type · watu $capacity';
  }

  @override
  String get hotelGuestName => 'Jina la mgeni';

  @override
  String get hotelGuestNameHint => 'mfano: Aline Uwase';

  @override
  String get hotelPhoneOptional => 'Simu (si lazima)';

  @override
  String get hotelEmailOptional => 'Barua pepe (si lazima)';

  @override
  String get hotelSendsConfirmationHint => 'Uthibitisho utatumwa hapa';

  @override
  String get hotelAdults => 'Watu wazima';

  @override
  String get hotelChildren => 'Watoto';

  @override
  String get hotelRatePerNightRwf => 'Bei kwa usiku (RWF)';

  @override
  String get hotelCheckInGuest => 'Sajili mgeni';

  @override
  String get hotelRoomCharge => 'Gharama ya chumba';

  @override
  String get hotelNavToday => 'Leo';

  @override
  String get hotelNavRooms => 'Vyumba';

  @override
  String get hotelNavCalendar => 'Kalenda';

  @override
  String get hotelNavQuotes => 'Nukuu';

  @override
  String get hotelDueOut => 'Anatarajiwa kuondoka';

  @override
  String get hotelRate => 'Bei';

  @override
  String hotelPriceEach(String price) {
    return '$price kila moja';
  }

  @override
  String get hotelTaxIncl => 'Kodi (imejumuishwa)';

  @override
  String get hotelFolioTotal => 'Jumla ya bili';

  @override
  String get hotelCheckOut => 'Kuondoka kwa mgeni';

  @override
  String hotelFolioTotalAmount(String amount) {
    return 'Jumla ya bili $amount';
  }

  @override
  String get hotelPaymentCard => 'Kadi';

  @override
  String get hotelChangeDue => 'Chenji ya kurudisha';

  @override
  String get hotelSettleAndRelease => 'Lipa na uachilie chumba';

  @override
  String get hotelOutOfOrder => 'Hakitumiki';

  @override
  String get hotelHkClean => 'Safi';

  @override
  String get hotelHkCleanMeaning =>
      'Tayari kuuzwa — mapokezi yanaweza kumsajili mgeni.';

  @override
  String get hotelHkDirty => 'Kinahitaji usafi';

  @override
  String get hotelHkDirtyMeaning =>
      'Hakiuzwi hadi wahudumu wa usafi wakiachilie.';

  @override
  String get hotelHkInspected => 'Kimekaguliwa';

  @override
  String get hotelHkInspectedMeaning =>
      'Kimesafishwa na kukaguliwa na msimamizi. Kinaweza kuuzwa.';

  @override
  String get hotelHkOutOfOrderMeaning =>
      'Kimezuiliwa kwa matengenezo. Hakitolewi kwa mgeni.';

  @override
  String hotelHousekeepingTitle(String room) {
    return 'Usafi · Chumba $room';
  }

  @override
  String hotelOccupiedNotice(String guest) {
    return '$guest yuko katika chumba hiki. Mtoe kwanza kabla ya kukizuia kwa matengenezo.';
  }

  @override
  String get hotelUnavailableWhileOccupied =>
      'Haipatikani wakati chumba kina mgeni.';

  @override
  String get hotelManager => 'Meneja';

  @override
  String get hotelEnterManagerPin => 'Weka PIN ya meneja yenye tarakimu 6';

  @override
  String get hotelNotManagerPin => 'Hii si PIN ya meneja';

  @override
  String get hotelManagerApproval => 'Idhini ya meneja';

  @override
  String get hotelSettleNeedsManagerPin =>
      'Kulipia bili kunahitaji PIN ya meneja.';

  @override
  String get hotelModeAlongsideBar =>
      'Hali ya Hoteli imewashwa pamoja na Hali ya Baa — chagua hapa chini kifaa hiki kitaendesha nini.';

  @override
  String get hotelHouseCheckoutTime => 'Muda wa kuondoka hotelini';

  @override
  String get hotelAdminLodging => 'Malazi';

  @override
  String get hotelAdminRoomsFloors => 'Vyumba na ghorofa';

  @override
  String get hotelAdminRatesBilling => 'Bei na malipo';

  @override
  String get hotelAdminGuestNotifications => 'Arifa kwa wageni';

  @override
  String get hotelAdminCompanyStamp => 'Muhuri wa kampuni';

  @override
  String get hotelAutoPostTitle => 'Weka gharama ya chumba wakati wa kuingia';

  @override
  String get hotelAutoPostSubtitle =>
      'Huweka usiku × bei kwenye bili mara mgeni anapochukua ufunguo.';

  @override
  String get hotelRequirePinTitle => 'Hitaji PIN kubadilisha mhudumu';

  @override
  String get hotelRequirePinSubtitle =>
      'Kaunta ya pamoja: mapokezi hufunguka kwa kufuli ya PIN na mfanyakazi yeyote anaweza kuingia.';

  @override
  String get hotelManagerCheckoutTitle => 'Meneja anahitajika kulipia bili';

  @override
  String get hotelManagerCheckoutSubtitle =>
      'Meneja pekee ndiye anaweza kupokea malipo na kuachilia chumba mgeni anapoondoka.';

  @override
  String get hotelAutoLogoutTitle => 'Rudisha mapokezi baada ya mgeni kuondoka';

  @override
  String get hotelAutoLogoutSubtitle =>
      'Hurudi kwenye kufuli ya PIN mara mgeni anapoondoka.';

  @override
  String get hotelRoomChargeProduct => 'Bidhaa ya gharama ya chumba';

  @override
  String hotelCheckoutDefaultSubtitle(String time) {
    return 'Muda wa kawaida wa kuondoka ni $time baada ya usiku wa mwisho.';
  }

  @override
  String get hotelOpenFrontDesk => 'Fungua mapokezi';

  @override
  String get hotelLoading => 'Inapakia…';

  @override
  String get hotelRoomChargeNotSet =>
      'Haijawekwa — gharama za chumba haziwezi kuwekwa hadi uchague bidhaa iliyosajiliwa.';

  @override
  String hotelRoomChargeMissing(String id) {
    return 'Bidhaa $id haipo tena kwenye tawi hili. Chagua nyingine.';
  }

  @override
  String get hotelNotifyEmailTitle => 'Mtumie mgeni uthibitisho kwa barua pepe';

  @override
  String get hotelNotifyEmailSubtitle =>
      'Bure. Hutumwa kila mgeni anapotoa barua pepe.';

  @override
  String get hotelNotifySmsTitle => 'Mtumie mgeni uthibitisho kwa SMS';

  @override
  String get hotelNotifySmsSubtitle =>
      'Hugharimu salio 30 kwa kila ujumbe. Imezimwa hadi uiwashe.';

  @override
  String get hotelNotifyReserveTitle => 'Thibitisha chumba kinapohifadhiwa';

  @override
  String get hotelNotifyReserveSubtitle =>
      'Hutumwa wakati mgeni wa baadaye anapohifadhiwa.';

  @override
  String get hotelNotifyCheckInTitle => 'Mkaribishe mgeni anapoingia';

  @override
  String get hotelNotifyCheckInSubtitle =>
      'Hutumwa mgeni anapochukua ufunguo kweli.';

  @override
  String get hotelStampTitle => 'Gonga muhuri kwenye nukuu na proforma';

  @override
  String get hotelStampUploadFirst =>
      'Pakia muhuri hapa chini, kisha washa hii.';

  @override
  String get hotelStampDrawnOn =>
      'Huwekwa kwenye ukurasa wa mwisho wa kila hati inayotolewa.';

  @override
  String get hotelNoStamp => 'Hakuna muhuri';

  @override
  String get hotelStampUnreadable => 'Haisomeki';

  @override
  String hotelStampSizeHint(String size) {
    return 'PNG au JPEG chini ya ${size}KB. PNG isiyo na mandharinyuma ni bora zaidi.';
  }

  @override
  String get hotelUpload => 'Pakia';

  @override
  String get hotelReplace => 'Badilisha';

  @override
  String get hotelStampBottomRight => 'Chini kulia';

  @override
  String get hotelStampBottomLeft => 'Chini kushoto';

  @override
  String get hotelStampBottomCentre => 'Chini katikati';

  @override
  String get hotelStampBesideTotal => 'Kando ya jumla';

  @override
  String get hotelStampPosition => 'Mahali';

  @override
  String get hotelStampWidth => 'Upana';

  @override
  String get hotelStampUpdated => 'Muhuri wa kampuni umesasishwa.';

  @override
  String get hotelStampSavedLocalOnly =>
      'Muhuri umehifadhiwa kwenye kifaa hiki pekee — vituo vingine havitautumia.';

  @override
  String hotelStampSetFailed(String error) {
    return 'Imeshindwa kuweka muhuri: $error';
  }

  @override
  String get hotelStampRemoved => 'Muhuri wa kampuni umeondolewa.';

  @override
  String get hotelStampRemovedLocalOnly =>
      'Muhuri umeondolewa kwenye kifaa hiki pekee — vituo vingine bado vinao.';

  @override
  String get hotelStampSavedDeviceOnly =>
      'Muhuri umehifadhiwa kwenye kifaa hiki pekee.';

  @override
  String get hotelModeTitle => 'Hali ya Hoteli (Mapokezi)';

  @override
  String get hotelOnBadge => 'IMEWASHWA';

  @override
  String hotelModeDescription(String hotkey) {
    return 'Hugeuza kaunta kuwa mapokezi: ubao wa vyumba kwa ghorofa, usajili wa mgeni pamoja na tarehe, bili inayoendelea kwa kila ukaaji ambayo baa na mgahawa vinaweza kuongeza, na malipo wakati wa kuondoka. Inachukua nafasi ya Hali ya Baa na mauzo ya kawaida kwenye tawi hili. Kwenye kibodi, $hotkey hubadilisha Baa → Hoteli → POS bila kurudi hapa.';
  }

  @override
  String get hotelPickRoomToQuote => 'Chagua chumba cha kunukuu';

  @override
  String get hotelEditQuotation => 'Hariri nukuu';

  @override
  String get hotelQuotationIntro =>
      'Ni ofa yenye bei. Haihifadhi chumba hadi mgeni aikubali.';

  @override
  String get hotelQuotationEmailHint => 'Mahali PDF ya nukuu inapotumwa';

  @override
  String get hotelRatePerNightShort => 'Bei / usiku';

  @override
  String get hotelValidForDays => 'Halali kwa (siku)';

  @override
  String get hotelSaveQuotation => 'Hifadhi nukuu';

  @override
  String get hotelUpdateQuotation => 'Sasisha nukuu';

  @override
  String hotelRoomsAvailableForDates(String count) {
    return 'Chumba · $count vinapatikana kwa tarehe hizi';
  }

  @override
  String hotelNoRoomFree(String count) {
    return 'Hakuna chumba cha watu $count kilicho wazi kwa tarehe hizo.';
  }

  @override
  String hotelNightsQuoted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Usiku $count umenukuliwa',
      one: 'Usiku 1 umenukuliwa',
    );
    return '$_temp0';
  }

  @override
  String get hotelDatesTaken =>
      'Tarehe hizo tayari zimechukuliwa kwa chumba hiki';

  @override
  String hotelReserveTitle(String room) {
    return 'Hifadhi · Chumba $room';
  }

  @override
  String get hotelHoldRoom => 'Hifadhi chumba';

  @override
  String hotelRoomTakenBetween(String room, String from, String to) {
    return 'Chumba $room tayari kimechukuliwa kati ya $from na $to.';
  }

  @override
  String hotelGuestsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wageni $count',
      one: 'Mgeni 1',
    );
    return '$_temp0';
  }

  @override
  String hotelRoomSemantic(String room, String type, String state) {
    return 'Chumba $room, $type, $state';
  }

  @override
  String get hotelTapToCheckIn => 'gusa ili kusajili mgeni';

  @override
  String hotelDueOutAt(String time) {
    return 'Anaondoka $time';
  }

  @override
  String hotelOutOn(String date) {
    return 'Anaondoka $date';
  }

  @override
  String get hotelAwaitingHousekeeping => 'Kinasubiri usafi';

  @override
  String hotelPerNight(String amount) {
    return '$amount / usiku';
  }

  @override
  String get hotelNoActiveBranch => 'Hakuna tawi linalotumika';

  @override
  String get hotelRoomChargeIntro =>
      'Bei ya usiku inatozwa kupitia bidhaa hii, kwa hiyo lazima iwe imesajiliwa na RRA.';

  @override
  String get hotelNoProductsFound => 'Hakuna bidhaa zilizopatikana.';

  @override
  String get hotelNotRegisteredWithRra =>
      'Haijasajiliwa na RRA — isajili kwanza';

  @override
  String hotelRoomIsState(String room, String state) {
    return 'Chumba $room: $state';
  }

  @override
  String hotelCheckInGuestQuestion(String guest) {
    return 'Msajili $guest?';
  }

  @override
  String hotelReservedArrivalBody(String room) {
    return 'Chumba $room kimehifadhiwa kwa ajili yake. Kumsajili hufungua bili na kuweka gharama ya chumba.';
  }

  @override
  String get hotelNotYet => 'Bado';

  @override
  String get hotelCheckIn => 'Sajili';

  @override
  String hotelRoomSavedNotRegistered(String room, String error) {
    return 'Chumba $room kimehifadhiwa, lakini hakijasajiliwa na RRA: $error';
  }

  @override
  String get hotelNewFloorOrWing => 'Ghorofa au sehemu mpya';

  @override
  String hotelRoomHasGuest(String room) {
    return 'Chumba $room kina mgeni au kimehifadhiwa. Mtoe kwanza.';
  }

  @override
  String hotelDeleteRoomQuestion(String room) {
    return 'Futa chumba $room?';
  }

  @override
  String get hotelDeleteRoomBody =>
      'Kitaondolewa kwenye ubao, kalenda na upatikanaji. Ukaaji uliopita na ankara zake hazitaguswa.';

  @override
  String hotelRoomStillHasGuest(String room) {
    return 'Chumba $room bado kina mgeni au kimehifadhiwa.';
  }

  @override
  String hotelDeleteFloorQuestion(String floor) {
    return 'Futa $floor?';
  }

  @override
  String hotelDeleteFloorBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Huondoa vyumba $count kwenye ghorofa hii.',
      one: 'Huondoa chumba 1 kwenye ghorofa hii.',
    );
    return '$_temp0';
  }

  @override
  String get hotelStarterPlanBody =>
      'Anza na mpango wa mfano wa vyumba 15 kwenye ghorofa tatu, kisha hariri namba, aina na bei ziendane na jengo lako.';

  @override
  String get hotelCreateStarterPlan => 'Unda mpango wa kuanzia';

  @override
  String hotelRoomsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vyumba $count',
      one: 'Chumba 1',
    );
    return '$_temp0';
  }

  @override
  String get hotelDeleteFloor => 'Futa ghorofa';

  @override
  String get hotelAddRoom => 'Ongeza chumba';

  @override
  String get hotelAddFloorOrWing => 'Ongeza ghorofa au sehemu';

  @override
  String get hotelFloorNameHint => 'mfano: Ghorofa ya pili';

  @override
  String get hotelRequired => 'Inahitajika';

  @override
  String get hotelInUse => 'Inatumika';

  @override
  String get hotelRoomNoHint => 'Na.';

  @override
  String get hotelRoomTypeHint => 'Aina';

  @override
  String get hotelRegisteredWithRra =>
      'Imesajiliwa na RRA kama huduma ya kodi ya utalii';

  @override
  String get hotelNotRegisteredTapToRegister =>
      'Haijasajiliwa na RRA — gusa ili kusajili';

  @override
  String get hotelCannotDeleteOccupied =>
      'Kina mgeni au kimehifadhiwa — hakiwezi kufutwa';

  @override
  String get hotelDeleteRoom => 'Futa chumba';

  @override
  String get hotelStateVacant => 'Wazi';

  @override
  String get hotelStateOccupied => 'Kina mgeni';

  @override
  String get hotelStateReserved => 'Kimehifadhiwa';

  @override
  String get hotelStateCleaning => 'Kinasafishwa';

  @override
  String get hotelAllFloors => 'Ghorofa zote';

  @override
  String get hotelChargeToRoom => 'Weka kwenye bili ya chumba';

  @override
  String get hotelChargeToRoomSubtitle =>
      'Chagua mgeni ambaye bili yake itabeba hesabu hii.';

  @override
  String get hotelStaySearchHint => 'Namba ya chumba, jina la mgeni au simu';

  @override
  String hotelStayOutLine(String summary, String date) {
    return '$summary · anaondoka $date';
  }

  @override
  String get hotelLookingUpGuests => 'Tunatafuta wageni…';

  @override
  String get hotelNobodyCheckedIn => 'Hakuna mgeni aliyesajiliwa';

  @override
  String get hotelReadingRooms => 'Tunasoma vyumba vya tawi hili.';

  @override
  String get hotelNoGuestsBody =>
      'Hesabu inaweza kuwekwa tu kwa mgeni aliyesajiliwa. Waliohifadhiwa huanza kupokea gharama wanapowasili.';

  @override
  String hotelNoGuestMatches(String term) {
    return 'Hakuna mgeni anayelingana na \"$term\"';
  }

  @override
  String get hotelSearchByHint =>
      'Tafuta kwa namba ya chumba, jina la mgeni au simu.';

  @override
  String get creditsHubTitle => 'Kituo cha krediti';

  @override
  String get creditsAddCredits => 'Ongeza krediti';

  @override
  String get creditsAvailable => 'Krediti zilizopo';

  @override
  String get creditsLabel => 'Krediti';

  @override
  String creditsMaximum(String max) {
    return 'Kiwango cha juu: $max';
  }

  @override
  String get creditsEnterAmount => 'Weka kiasi';

  @override
  String get creditsPayNow => 'Lipa sasa';

  @override
  String get creditsEnterValidAmount => 'Tafadhali weka kiasi sahihi';

  @override
  String get creditsEnterValidPhone => 'Tafadhali weka nambari sahihi ya simu';

  @override
  String get creditsPaymentRequestFailed =>
      'Ombi la malipo limeshindwa. Tafadhali jaribu tena.';

  @override
  String creditsErrorOccurred(String error) {
    return 'Hitilafu imetokea: $error';
  }

  @override
  String get creditsPaymentDeclined => 'Malipo yamekataliwa kwenye simu yako.';

  @override
  String get creditsPaymentSuccessful => 'Malipo yamefanikiwa';

  @override
  String get creditsPaymentInitiated => 'Malipo yameanzishwa';

  @override
  String creditsPaymentRequestSent(String phone) {
    return 'Ombi la malipo limetumwa kwa $phone.';
  }

  @override
  String get creditsApprovePayment =>
      'Tafadhali angalia simu yako na uidhinishe malipo.';

  @override
  String creditsNothingCharged(String reason) {
    return '$reason Hakuna kilichotozwa — unaweza kujaribu tena.';
  }

  @override
  String get creditsVerificationTimedOut =>
      'Muda wa kuthibitisha malipo umeisha. Tafadhali angalia krediti zako baadaye.';

  @override
  String get creditsPaymentProcessed =>
      'Malipo yako yamechakatwa kwa mafanikio!';

  @override
  String get creditsAdded => 'Krediti zako zimeongezwa kwenye akaunti yako.';

  @override
  String get creditsQuickAdd => 'Ongeza haraka';

  @override
  String get delegationStatusCompleted => 'Imekamilika';

  @override
  String get delegationStatusDelegated => 'Imekabidhiwa';

  @override
  String get delegationStatusFailed => 'Imeshindwa';

  @override
  String get delegationFilterAll => 'Zote';

  @override
  String delegationTransactionName(String id) {
    return 'Muamala $id';
  }

  @override
  String get delegationBannerTapToOpen => 'Gusa ili kufungua ukabidhi';

  @override
  String get delegationRetryQueued =>
      'Jaribio jipya limewekwa kwenye foleni. Likishindwa tena, tuma upya mauzo kutoka kifaa cha POS.';

  @override
  String get delegationRetryError =>
      'Hitilafu wakati wa kujaribu tena ukabidhi';

  @override
  String get delegationAboutTitle => 'Kuhusu ukabidhi';

  @override
  String get delegationAboutBody =>
      'Ukabidhi wa uchapishaji huruhusu vifaa vya mkononi kutuma kazi za uchapishaji kwa printa za kompyuta. Ukabidhi ulioshindwa unaweza kujaribiwa tena kutoka skrini hii.';

  @override
  String get delegationGotIt => 'Nimeelewa';

  @override
  String get delegationTitle => 'Ukabidhi wa uchapishaji';

  @override
  String delegationHeaderSubtitle(String count) {
    return 'Fuatilia na usimamie miamala iliyokabidhiwa kati ya kaunta zako — $count zinaonekana.';
  }

  @override
  String get delegationSearchHint => 'Tafuta ukabidhi, risiti, malipo…';

  @override
  String get delegationFilter => 'Chuja';

  @override
  String get delegationRetryTooltip => 'Jaribu ukabidhi tena';

  @override
  String get delegationReceiptType => 'Aina ya risiti';

  @override
  String get delegationEmptyTitle => 'Hakuna ukabidhi uliopatikana';

  @override
  String get delegationEmptyDeviceHint =>
      'Ukabidhi uliotumwa kwa kifaa hiki utaonekana hapa. Watumaji lazima walenge kitambulisho cha kifaa hiki kwenye mipangilio ya ukabidhi.';

  @override
  String get delegationEmptyFilterHint =>
      'Jaribu neno jingine la utafutaji au badilisha kichujio hapo juu ili kuona matokeo zaidi.';

  @override
  String get saleAgentAssignTitle => 'Mpe wakala';

  @override
  String get saleAgentAgentsSection => 'MAWAKALA';

  @override
  String get saleAgentSearchHint => 'Tafuta mawakala...';

  @override
  String get saleAgentNoAgentsForBusiness =>
      'Hakuna mawakala waliopatikana kwa biashara hii. Ongeza mawakala katika Usimamizi wa Watumiaji.';

  @override
  String get saleAgentNoSearchMatch =>
      'Hakuna wakala anayelingana na utafutaji wako.';

  @override
  String get saleAgentCommissionSection => 'KAMISHENI';

  @override
  String get saleAgentFixedRwf => 'Kiasi maalum (RWF)';

  @override
  String get saleAgentPercent => 'Asilimia (%)';

  @override
  String get saleAgentAmountRwf => 'Kiasi (RWF)';

  @override
  String get saleAgentRatePercent => 'Kiwango (%)';

  @override
  String saleAgentExample(String example) {
    return 'mf. $example';
  }

  @override
  String get saleAgentSelectAgent => 'Chagua wakala';

  @override
  String get saleAgentEnterValidCommission => 'Weka kamisheni sahihi';

  @override
  String get saleAgentPercentMax => 'Asilimia haiwezi kuzidi 100';

  @override
  String get saleAgentApply => 'Tumia';

  @override
  String get saleAgentNoContact => 'Hakuna mawasiliano';

  @override
  String get saleAgentBadge => 'Wakala';

  @override
  String personalGoalBannerReached(String name) {
    return 'Lengo limefikiwa: $name';
  }

  @override
  String personalGoalBannerReachedForPeriod(String period, String name) {
    return 'Lengo limefikiwa kwa $period: $name';
  }

  @override
  String personalGoalBannerTargetMet(String amount) {
    return 'Lengo la $amount limefikiwa';
  }

  @override
  String personalGoalBannerTargetMetRestart(String amount, String restart) {
    return 'Lengo la $amount limefikiwa · $restart';
  }

  @override
  String personalGoalBannerSavedTo(String amount, String name) {
    return '+$amount zimewekwa akiba kwa $name';
  }

  @override
  String personalGoalSavedOfTarget(String saved, String target) {
    return '$saved kati ya $target';
  }

  @override
  String personalGoalBannerSavedSoFar(String amount) {
    return '$amount zimewekwa akiba hadi sasa';
  }

  @override
  String personalGoalBannerOneReached(String name) {
    return '$name limefikia lengo lake';
  }

  @override
  String personalGoalBannerManyReached(int count) {
    return 'Malengo $count yamefikiwa';
  }

  @override
  String personalGoalBannerSavedAcross(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'malengo $count',
      one: 'lengo 1',
    );
    return '+$amount zimewekwa akiba katika $_temp0';
  }

  @override
  String get personalGoalBannerEyebrow => 'LENGO BINAFSI  ·  sasa';

  @override
  String get personalGoalBannerDismiss => 'Ondoa';

  @override
  String personalGoalRemoteCreditNotification(String name, String amount) {
    return '$name: +$amount zimewekwa akiba (kiotomatiki au kutoka kifaa kingine)';
  }

  @override
  String get personalGoalTopPriorityEyebrow => 'KIPAUMBELE CHA JUU';

  @override
  String get personalGoalSaved => 'Akiba';

  @override
  String get personalGoalTarget => 'Lengo';

  @override
  String get personalGoalAutoAllocation => 'Mgao wa kiotomatiki';

  @override
  String personalGoalProfitReserved(String percent) {
    return '$percent% ya faida imetengwa';
  }

  @override
  String get personalGoalAutoAllocationOptional =>
      'Si lazima — weka kwenye kuhariri';

  @override
  String get personalGoalUpdatedFromProfits => 'Imesasishwa kutoka kwa faida';

  @override
  String get personalGoalAddMoney => 'Ongeza pesa';

  @override
  String get personalGoalAddMoneyCashIn => '· Pesa inayoingia';

  @override
  String personalGoalReachedForPeriod(String period, String restart) {
    return 'Limefikiwa kwa $period · $restart';
  }

  @override
  String personalGoalLastPeriodReached(String period, String amount) {
    return '$period: $amount · limefikiwa';
  }

  @override
  String personalGoalLastPeriodProgress(String period, String progress) {
    return '$period: $progress';
  }

  @override
  String get personalGoalNewGoal => 'Lengo jipya';

  @override
  String get personalGoalNewGoalExamples => 'Vifaa, kodi ya nyumba, mafunzo…';

  @override
  String get personalGoalEditGoal => 'Hariri lengo';

  @override
  String get personalGoalEditSubtitle =>
      'Sasisha kiasi na mipangilio ya lengo hili.';

  @override
  String get personalGoalNewSubtitle =>
      'Weka jina na lengo. Unaweza kuongeza pesa wakati wowote kutoka pesa inayoingia.';

  @override
  String get personalGoalNameSection => 'JINA LA LENGO';

  @override
  String get personalGoalNameLabel => 'Unaweka akiba kwa ajili ya nini?';

  @override
  String get personalGoalNameHint => 'mfano: Akiba ya dharura, vifaa';

  @override
  String get personalGoalNameRequired => 'Weka jina la lengo';

  @override
  String get personalGoalAmountsSection => 'KIASI (RWF)';

  @override
  String get personalGoalTargetAmount => 'Kiasi kinacholengwa';

  @override
  String get personalGoalTargetRequired => 'Weka lengo zaidi ya 0';

  @override
  String get personalGoalAlreadySaved => 'Akiba iliyopo';

  @override
  String get personalGoalAlreadySavedHint => '0 — si lazima';

  @override
  String get personalGoalCannotBeNegative => 'Haiwezi kuwa hasi';

  @override
  String get personalGoalRepeatsSection => 'KURUDIA';

  @override
  String get personalGoalRepeats => 'Kurudia';

  @override
  String get personalGoalOptionalSection => 'SI LAZIMA';

  @override
  String get personalGoalAutoAllocationPercent => 'Mgao wa kiotomatiki %';

  @override
  String get personalGoalAutoAllocationHint => 'Acha wazi kama haitumiki';

  @override
  String get personalGoalPercentRange => 'Tumia 0–100';

  @override
  String get personalGoalTopPriority => 'Kipaumbele cha juu';

  @override
  String get personalGoalTopPriorityHint =>
      'Huonyeshwa kwanza kwenye dashibodi yako';

  @override
  String get personalGoalSaveChanges => 'Hifadhi mabadiliko';

  @override
  String get personalGoalCreateGoal => 'Unda lengo';

  @override
  String get agentCommissionPayoutsUnavailable =>
      'Historia ya malipo haikuweza kupakiwa. Kamisheni iliyopatikana kutoka mauzo bado inaonyeshwa. Endesha migration ya Supabase agent_commission_payouts ikiwa malipo hayahifadhiwi.';

  @override
  String get agentCommissionEyebrow => 'TIMU  ·  KAMISHENI';

  @override
  String get agentCommissionTitle => 'Kamisheni za mawakala';

  @override
  String get agentCommissionSubtitle =>
      'Fuatilia kile kila wakala wa mauzo amepata, ulicholipa, na kinachodaiwa bado.';

  @override
  String get agentCommissionSignOut => 'Toka';

  @override
  String get agentCommissionAgent => 'Wakala';

  @override
  String get agentCommissionEarnedEyebrow => 'KAMISHENI ILIYOPATIKANA';

  @override
  String agentCommissionPaidOutPct(String percent) {
    return 'Imelipwa · $percent %';
  }

  @override
  String agentCommissionBalanceDuePct(String percent) {
    return 'Salio linalodaiwa · $percent %';
  }

  @override
  String get agentCommissionPaidOutEyebrow => 'IMELIPWA';

  @override
  String get agentCommissionBalanceDueEyebrow => 'SALIO LINALODAIWA';

  @override
  String get agentCommissionAllSettled => 'Yote yamelipwa';

  @override
  String get agentCommissionRecordPayout => 'Rekodi malipo';

  @override
  String get agentCommissionAttributedSales => 'MAUZO YALIYOHUSISHWA';

  @override
  String agentCommissionPendingCount(int count) {
    return '$count zinasubiri';
  }

  @override
  String get agentCommissionExport => 'Hamisha';

  @override
  String get agentCommissionColDate => 'TAREHE';

  @override
  String get agentCommissionColReceipt => 'RISITI';

  @override
  String get agentCommissionColCashier => 'KESHIA';

  @override
  String get agentCommissionColSaleTotal => 'JUMLA YA MAUZO';

  @override
  String get agentCommissionColRate => 'KIWANGO';

  @override
  String get agentCommissionColCommission => 'KAMISHENI';

  @override
  String get agentCommissionColStatus => 'HALI';

  @override
  String get agentCommissionWalkIn => 'Mteja wa papo hapo';

  @override
  String get agentCommissionRecentPayouts => 'MALIPO YA HIVI KARIBUNI';

  @override
  String get agentCommissionCashier => 'Keshia';

  @override
  String get agentCommissionPaid => 'Imelipwa';

  @override
  String get agentCommissionPending => 'Inasubiri';

  @override
  String get agentCommissionLast7Days => 'Siku 7 zilizopita';

  @override
  String get agentCommissionAllTime => 'Muda wote';

  @override
  String get agentCommissionToday => 'Leo';

  @override
  String get agentCommissionThisWeek => 'Wiki hii';

  @override
  String get agentCommissionThisMonth => 'Mwezi huu';

  @override
  String get agentCommissionLoadFailed =>
      'Imeshindwa kupakia data ya kamisheni.';

  @override
  String get agentCommissionAgentsLoadFailed => 'Imeshindwa kupakia mawakala.';

  @override
  String get agentCommissionNoAgents =>
      'Hakuna mawakala waliopatikana. Ongeza mawakala kwanza kwenye Usimamizi wa Watumiaji.';

  @override
  String get agentCommissionNoPermission => 'Huna ruhusa ya kusimamia malipo.';

  @override
  String agentCommissionBalanceDueAmount(String amount) {
    return 'Salio linalodaiwa: $amount';
  }

  @override
  String get agentCommissionAmountRwf => 'Kiasi (RWF)';

  @override
  String get agentCommissionEnterValidAmount => 'Weka kiasi sahihi';

  @override
  String agentCommissionCannotExceedBalance(String amount) {
    return 'Haiwezi kuzidi salio ($amount)';
  }

  @override
  String get agentCommissionNoteOptional => 'Maelezo (si lazima)';

  @override
  String agentCommissionPayoutRecorded(String amount) {
    return 'Malipo ya $amount yamerekodiwa.';
  }

  @override
  String get agentCommissionPayoutFailed =>
      'Imeshindwa kurekodi malipo. Angalia muunganisho wako.';

  @override
  String get agentCommissionCommissionAgent => 'Wakala wa kamisheni';

  @override
  String get agentCommissionByOwner => 'na mmiliki';

  @override
  String agentCommissionSaleAmount(String amount) {
    return 'Mauzo $amount';
  }

  @override
  String get agentCommissionNoSalesYet => 'Bado hakuna mauzo yaliyohusishwa';

  @override
  String agentCommissionNoSalesHint(String period) {
    return 'Keshia wanapomhusisha wakala na mauzo yaliyokamilika katika Uuzaji wa Haraka, kamisheni itaonekana hapa kwa: $period.';
  }

  @override
  String get agentCommissionAmountMustBePositive =>
      'Kiasi cha malipo lazima kiwe zaidi ya sifuri.';

  @override
  String get agentCommissionNoBusinessSelected =>
      'Hakuna biashara iliyochaguliwa.';

  @override
  String get agentCommissionSignInToRecord => 'Ingia ili kurekodi malipo.';

  @override
  String get agentCommissionStorageNotSetUp =>
      'Hifadhi ya malipo bado haijawekwa. Mwombe msimamizi wako aendeshe migration ya hivi karibuni ya Supabase (agent_commission_payouts).';

  @override
  String get agentCommissionCouldNotRecord => 'Imeshindwa kurekodi malipo.';

  @override
  String get kitchenStageIncoming => 'Zinazoingia';

  @override
  String get kitchenStageInProgress => 'Inaandaliwa';

  @override
  String get kitchenStageReady => 'Tayari';

  @override
  String get kitchenStageServed => 'Imehudumiwa';

  @override
  String get kitchenServedAlreadyPaid =>
      'Imehudumiwa. Oda hii ilikuwa imeshalipwa.';

  @override
  String get kitchenServedCashierHasTicket =>
      'Imehudumiwa. Keshia ana tiketi hii wazi kwa malipo.';

  @override
  String get kitchenServedInTickets =>
      'Imehudumiwa. Iko kwenye Tiketi, tayari kwa malipo.';

  @override
  String get kitchenDisplayTitle => 'Skrini ya jikoni';

  @override
  String kitchenErrorLoadingOrders(String error) {
    return 'Hitilafu wakati wa kupakia oda: $error';
  }

  @override
  String kitchenFailedToUpdateOrder(String error) {
    return 'Imeshindwa kusasisha oda: $error';
  }

  @override
  String kitchenFailedToSetDueDate(String error) {
    return 'Imeshindwa kuweka muda wa mwisho: $error';
  }

  @override
  String get kitchenNoOrders => 'Hakuna oda';

  @override
  String kitchenOrderNumber(String number) {
    return 'Oda #$number';
  }

  @override
  String get kitchenSetDueDate => 'Weka muda wa mwisho';

  @override
  String get kitchenTicketNotFound => 'Tiketi haikupatikana — huenda imefutwa.';

  @override
  String kitchenTicketName(String name) {
    return 'Tiketi: $name';
  }

  @override
  String kitchenCustomerLine(String name) {
    return 'Mteja: $name';
  }

  @override
  String kitchenTotalLine(String amount) {
    return 'Jumla: $amount';
  }

  @override
  String get kitchenNoteLabel => 'Dokezo:';

  @override
  String get kitchenNoItemsFound => 'Hakuna bidhaa zilizopatikana';

  @override
  String get kitchenItemsLabel => 'Bidhaa:';

  @override
  String kitchenErrorLoadingItems(String error) {
    return 'Hitilafu wakati wa kupakia bidhaa: $error';
  }

  @override
  String kitchenMinutesCount(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Dakika $minutes',
      one: 'Dakika 1',
    );
    return '$_temp0';
  }

  @override
  String kitchenDueInMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Inatakiwa ndani ya dakika $minutes',
      one: 'Inatakiwa ndani ya dakika 1',
    );
    return '$_temp0';
  }

  @override
  String get kitchenSetAction => 'Weka';

  @override
  String get ticketUnknown => 'Haijulikani';

  @override
  String get ticketOverdue => 'Imechelewa';

  @override
  String ticketMinutesLeft(String minutes) {
    return 'Zimebaki dakika $minutes';
  }

  @override
  String ticketDaysHoursLeft(String days, String hours) {
    return 'Zimebaki siku $days saa $hours';
  }

  @override
  String ticketHoursMinutesLeft(String hours, String minutes) {
    return 'Zimebaki saa $hours dakika $minutes';
  }

  @override
  String get ticketWalkInCustomer => 'Mteja wa papo hapo';

  @override
  String get ticketWalkIn => 'Mteja wa papo hapo';

  @override
  String get ticketStatusWaiting => 'Inasubiri';

  @override
  String get ticketStatusInProgress => 'Inaendelea';

  @override
  String get ticketStatusPaid => 'Imelipwa';

  @override
  String get ticketStatusPendingReview => 'Inasubiri ukaguzi';

  @override
  String get ticketStatusReviewed => 'Imekaguliwa';

  @override
  String get ticketStatusPartial => 'Sehemu';

  @override
  String get ticketStatusAwaitingPayment => 'Inasubiri malipo';

  @override
  String get ticketMarkReviewedFailed =>
      'Imeshindwa kuweka tiketi kama imekaguliwa';

  @override
  String get ticketReviewedSuccess => 'Tiketi imekaguliwa';

  @override
  String get ticketReviewQueue => 'Foleni ya ukaguzi';

  @override
  String get ticketReviewQueueLoadFailed =>
      'Imeshindwa kupakia foleni ya ukaguzi';

  @override
  String get ticketReviewQueueEmpty => 'Hakuna kinachosubiri ukaguzi';

  @override
  String get ticketReviewDetails => 'Kagua maelezo';

  @override
  String ticketsWaitingToReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tiketi $count zinasubiri ukaguzi',
      one: 'Tiketi 1 inasubiri ukaguzi',
    );
    return '$_temp0';
  }

  @override
  String ticketMoreCount(String count) {
    return '+ $count zaidi';
  }

  @override
  String get ticketOpenReviewQueue => 'Fungua foleni ya ukaguzi →';

  @override
  String ticketNumberRef(String reference) {
    return 'Tiketi #$reference';
  }

  @override
  String get ticketGeneric => 'Tiketi';

  @override
  String get ticketJustNow => 'sasa hivi';

  @override
  String ticketMinutesAgo(String count) {
    return 'dakika $count zilizopita';
  }

  @override
  String ticketHoursAgo(String count) {
    return 'saa $count zilizopita';
  }

  @override
  String ticketDaysAgo(String count) {
    return 'siku $count zilizopita';
  }

  @override
  String ticketItemsSectionCount(String count) {
    return 'Bidhaa · $count';
  }

  @override
  String get ticketNote => 'Dokezo';

  @override
  String ticketCouldNotLoadItems(String error) {
    return 'Imeshindwa kupakia bidhaa: $error';
  }

  @override
  String get ticketMarking => 'Inaweka alama…';

  @override
  String get ticketMarkAsReviewed => 'Weka kama imekaguliwa';

  @override
  String get ticketReviewTicketTitle => 'Kagua tiketi';

  @override
  String get ticketNoItemsOnTicket => 'Hakuna bidhaa kwenye tiketi hii.';

  @override
  String ticketIdShort(String id) {
    return '(ID: $id)';
  }

  @override
  String get ticketNotAvailable => 'Haipo';

  @override
  String ticketSubtotalValue(String amount) {
    return 'Jumla ndogo: $amount';
  }

  @override
  String ticketDueOn(String date) {
    return 'Muda wa mwisho: $date';
  }

  @override
  String get ticketDeleteTitle => 'Futa tiketi';

  @override
  String get ticketDeleteConfirm =>
      'Una hakika unataka kufuta tiketi hii? Kitendo hiki hakiwezi kutenduliwa.';

  @override
  String get ticketLoan => 'Mkopo';

  @override
  String get ticketLayaway => 'Lipa kidogo kidogo';

  @override
  String get ticketRegular => 'Kawaida';

  @override
  String get ticketFilterAll => 'Tiketi zote';

  @override
  String get ticketsCannotDeleteReviewed =>
      'Tiketi zilizochaguliwa zimekaguliwa na haziwezi kufutwa';

  @override
  String get ticketsCannotDeleteSelected =>
      'Tiketi zilizochaguliwa haziwezi kufutwa (malipo ya sehemu au zimekaguliwa)';

  @override
  String ticketsDeletedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tiketi $count zimefutwa kwa mafanikio',
      one: 'Tiketi 1 imefutwa kwa mafanikio',
    );
    return '$_temp0';
  }

  @override
  String get ticketsDeleteSelectedFailed =>
      'Imeshindwa kufuta tiketi zilizochaguliwa';

  @override
  String get ticketAddItemsFirst =>
      'Tafadhali ongeza bidhaa kwenye muamala kabla ya kuunda tiketi';

  @override
  String get ticketCreate => 'Unda tiketi';

  @override
  String get ticketsPendingTitle => 'Tiketi zinazosubiri';

  @override
  String get ticketsMyTitle => 'Tiketi zangu';

  @override
  String get ticketsPendingSubtitle =>
      'Oda zinazosubiri kulipiwa kwenye kaunta';

  @override
  String get ticketsMySubtitle => 'Oda ulizotuma na hali ya malipo yake';

  @override
  String ticketsDeleteSelectedCount(String count) {
    return 'Futa zilizochaguliwa ($count)';
  }

  @override
  String get ticketsSelectAll => 'Chagua zote';

  @override
  String get ticketSendViaWhatsApp => 'Tuma kupitia WhatsApp';

  @override
  String ticketRefWithCustomer(String reference, String customer) {
    return 'Tiketi #$reference · $customer';
  }

  @override
  String get ticketHandoverStaffHeader => 'Wafanyakazi wa kukabidhi bidhaa';

  @override
  String get ticketHandoverStaffLoadFailed =>
      'Imeshindwa kupakia wafanyakazi wa kukabidhi.';

  @override
  String get ticketHandoverStaffEmpty =>
      'Hakuna mfanyakazi mwenye ruhusa ya Kukabidhi Bidhaa na namba ya simu iliyohifadhiwa. Ongeza simu kwenye wasifu wake na umpe ruhusa ya Kukabidhi Bidhaa.';

  @override
  String get ticketOrderFormShop => 'Duka';

  @override
  String get ticketOrderReceipt => 'Risiti ya oda';

  @override
  String get ticketCreated => 'Imeundwa';

  @override
  String get ticketDeliveryTime => 'Muda wa kuwasilisha';

  @override
  String get ticketTotal => 'Jumla';

  @override
  String get ticketBalance => 'Salio';

  @override
  String get ticketRemaining => 'Iliyobaki';

  @override
  String get ticketReviewedBy => 'Imekaguliwa na';

  @override
  String get ticketReviewedAt => 'Imekaguliwa tarehe';

  @override
  String get ticketThankYouForOrder => 'Asante kwa oda yako';

  @override
  String ticketsSkippedCannotDelete(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Tiketi $count zisizoweza kufutwa zimerukwa (malipo ya sehemu au zimekaguliwa)',
      one:
          'Tiketi 1 isiyoweza kufutwa imerukwa (malipo ya sehemu au imekaguliwa)',
    );
    return '$_temp0';
  }

  @override
  String get ticketSearchHint =>
      'Tafuta kwa mteja, simu, kitambulisho cha tiketi...';

  @override
  String get ticketsLoading => 'Tunapakia tiketi...';

  @override
  String get ticketsNoneInCategory => 'Hakuna tiketi katika kundi hili';

  @override
  String get ticketsTryAnotherFilter => 'Jaribu kichujio kingine';

  @override
  String get ticketSortNewest => 'Mpya kwanza';

  @override
  String get ticketSortOldest => 'Za zamani kwanza';

  @override
  String get ticketsLoanSection => 'Tiketi za mkopo';

  @override
  String get ticketsLayawaySection => 'Tiketi za kulipa kidogo kidogo';

  @override
  String get ticketsRegularSection => 'Tiketi za kawaida';

  @override
  String get ticketOrderResumed => 'Oda imeendelezwa kwa mafanikio';

  @override
  String get ticketStaffFallback => 'Mfanyakazi';

  @override
  String get ticketReturnToTillFailed =>
      'Imeshindwa kurudisha tiketi ya sasa kwenye kaunta. Jaribu tena.';

  @override
  String get ticketActionFailed => 'Kitendo kimeshindwa';

  @override
  String get ticketSentToKitchen => 'Imetumwa jikoni';

  @override
  String get ticketSendToKitchenFailed =>
      'Imeshindwa kutuma jikoni. Jaribu tena.';

  @override
  String get ticketSendToKitchen => 'Tuma jikoni';

  @override
  String get ticketSendAgain => 'Tuma tena';

  @override
  String get ticketServedReadyForPayment => 'Imehudumiwa · tayari kwa malipo';

  @override
  String ticketInKitchenStage(String stage) {
    return 'Jikoni · $stage';
  }

  @override
  String get ticketPrintOrderFormFailed => 'Imeshindwa kuchapisha fomu ya oda';

  @override
  String ticketOrderFormCaption(String reference, String customer) {
    return 'Fomu ya oda · Tiketi #$reference · $customer';
  }

  @override
  String ticketOrderFormSentWhatsApp(String name) {
    return 'Fomu ya oda imetumwa kwa $name kupitia WhatsApp';
  }

  @override
  String get ticketOrderFormWhatsAppFailed =>
      'Imeshindwa kutuma fomu ya oda kupitia WhatsApp';

  @override
  String get ticketHandoverRecordedReceipt =>
      'Makabidhiano yamerekodiwa — risiti imetolewa';

  @override
  String get ticketHandoverRecorded => 'Makabidhiano yamerekodiwa';

  @override
  String get ticketHandoverFinalizeFailed =>
      'Imeshindwa kukamilisha makabidhiano — risiti haikutolewa. Tafadhali jaribu tena.';

  @override
  String get ticketHasPartialPayments =>
      'Tiketi hii ina malipo ya sehemu na haiwezi kufutwa.';

  @override
  String get ticketDeleted => 'Tiketi imefutwa';

  @override
  String get ticketDeleteFailed => 'Imeshindwa kufuta tiketi';

  @override
  String get ticketDeleteFailedShort => 'Kufuta kumeshindwa';

  @override
  String get ticketsNoOpen => 'Hakuna tiketi zilizo wazi';

  @override
  String get ticketsCreateToStart => 'Unda tiketi mpya ili kuanza';

  @override
  String get ticketsNoSearchMatch =>
      'Hakuna tiketi inayolingana na utafutaji wako';

  @override
  String get ticketsTryDifferentSearch => 'Jaribu neno lingine la utafutaji';

  @override
  String get ticketSomethingWentWrong => 'Kuna kitu kimeharibika';

  @override
  String get ticketTryAgain => 'Jaribu tena';

  @override
  String get ticketCompleteHandoverTitle => 'Kamilisha makabidhiano?';

  @override
  String get ticketHandoverIssueReceiptBody =>
      'Toa risiti na uweke tiketi hii kama imekamilika.';

  @override
  String get ticketHandoverConfirmLeftStock =>
      'Thibitisha kwamba bidhaa imetoka kwenye hisa kweli.';

  @override
  String get ticketHandoverStockDeductedInfo =>
      'Hisa itapunguzwa na risiti ya kodi itatolewa sasa.';

  @override
  String get ticketHandoverRecordsInfo =>
      'Hii inarekodi kwamba bidhaa zimekabidhiwa kwa mteja.';

  @override
  String get ticketDeleteQuestion => 'Futa tiketi?';

  @override
  String get ticketDeleteRemovesHistory =>
      'Hii inaondoa mauzo yaliyohifadhiwa na historia ya tiketi iliyo kwenye kifaa hiki.';

  @override
  String get ticketActionCannotBeUndone => 'Kitendo hiki hakiwezi kutenduliwa.';

  @override
  String ticketCreatedOn(String date) {
    return 'Imeundwa $date';
  }

  @override
  String get ticketRecordHandover => 'Rekodi makabidhiano';

  @override
  String get ticketCollecting => 'Inakusanya…';

  @override
  String get ticketCollect => 'Kusanya →';

  @override
  String get ticketCompleting => 'Inakamilisha…';

  @override
  String get ticketComplete => 'Kamilisha →';

  @override
  String get ticketResumeOrder => 'Endeleza oda';

  @override
  String get ticketPrint => 'Chapisha';

  @override
  String get ticketSent => 'Imetumwa';

  @override
  String get ticketWhatsAppNotConfigured =>
      'Kutuma kwa WhatsApp hakujawekwa: URL ya data connector (Ebm.dataConnectorUrl) haipo.';

  @override
  String configCurrencyName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'RWF': 'Faranga ya Rwanda',
      'KES': 'Shilingi ya Kenya',
      'UGX': 'Shilingi ya Uganda',
      'TZS': 'Shilingi ya Tanzania',
      'ETB': 'Birr ya Ethiopia',
      'NGN': 'Naira ya Nigeria',
      'ZAR': 'Randi ya Afrika Kusini',
      'GHS': 'Sedi ya Ghana',
      'MAD': 'Dirham ya Morocco',
      'EGP': 'Pauni ya Misri',
      'DZD': 'Dinari ya Algeria',
      'XOF': 'Faranga ya CFA BCEAO',
      'XAF': 'Faranga ya CFA BEAC',
      'MUR': 'Rupia ya Morisi',
      'BWP': 'Pula ya Botswana',
      'NAD': 'Dola ya Namibia',
      'USD': 'Dola ya Marekani',
      'EUR': 'Yuro',
      'GBP': 'Pauni ya Uingereza',
      'JPY': 'Yeni ya Japani',
      'CNY': 'Yuan ya China',
      'CAD': 'Dola ya Kanada',
      'AUD': 'Dola ya Australia',
      'CHF': 'Faranga ya Uswisi',
      'NZD': 'Dola ya New Zealand',
      'HKD': 'Dola ya Hong Kong',
      'SEK': 'Krona ya Uswidi',
      'NOK': 'Krone ya Norwe',
      'DKK': 'Krone ya Denmark',
      'AED': 'Dirham ya Falme za Kiarabu',
      'SAR': 'Riyal ya Saudia',
      'QAR': 'Riyal ya Qatar',
      'KWD': 'Dinari ya Kuwait',
      'BHD': 'Dinari ya Bahrain',
      'OMR': 'Rial ya Oman',
      'ILS': 'Shekeli ya Israeli',
      'JOD': 'Dinari ya Jordan',
      'INR': 'Rupia ya India',
      'PKR': 'Rupia ya Pakistani',
      'BDT': 'Taka ya Bangladesh',
      'SGD': 'Dola ya Singapore',
      'MYR': 'Ringgit ya Malaysia',
      'IDR': 'Rupia ya Indonesia',
      'PHP': 'Peso ya Ufilipino',
      'THB': 'Baht ya Thailand',
      'VND': 'Dong ya Vietnam',
      'KRW': 'Won ya Korea Kusini',
      'TWD': 'Dola Mpya ya Taiwan',
      'LKR': 'Rupia ya Sri Lanka',
      'NPR': 'Rupia ya Nepal',
      'BRL': 'Real ya Brazil',
      'MXN': 'Peso ya Mexico',
      'ARS': 'Peso ya Argentina',
      'COP': 'Peso ya Kolombia',
      'CLP': 'Peso ya Chile',
      'PEN': 'Sol ya Peru',
      'UYU': 'Peso ya Uruguay',
      'BOB': 'Boliviano ya Bolivia',
      'VES': 'Bolívar ya Venezuela',
      'RUB': 'Rubli ya Urusi',
      'PLN': 'Zloty ya Poland',
      'CZK': 'Koruna ya Czech',
      'HUF': 'Forint ya Hungaria',
      'RON': 'Leu ya Romania',
      'BGN': 'Lev ya Bulgaria',
      'TRY': 'Lira ya Uturuki',
      'UAH': 'Hryvnia ya Ukraine',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get configNeedHelp => 'Unahitaji msaada?';

  @override
  String get configContactSupportToAddEbm =>
      'Wasiliana na timu ya usaidizi ili kuongeza EBM kwenye Flipper';

  @override
  String get configContactSupport => 'Wasiliana na usaidizi';

  @override
  String get configEnterValidUrl => 'Tafadhali weka URL sahihi';

  @override
  String get configEnterUrlWithScheme =>
      'Tafadhali weka URL sahihi yenye mpango (mf. http:// au https://)';

  @override
  String get configBranchIdRequired => 'Kitambulisho cha tawi kinahitajika';

  @override
  String get configMrcRequired => 'MRC inahitajika';

  @override
  String get configMrcLength => 'MRC lazima iwe na herufi 11 kamili';

  @override
  String get configNoChangesToSave => 'Hakuna mabadiliko ya kuhifadhi';

  @override
  String get configSaveFailed =>
      'Imeshindwa kuhifadhi usanidi wa kodi. Angalia muunganisho wako kisha ujaribu tena.';

  @override
  String get configTaxConfigSaved => 'Usanidi wa kodi umehifadhiwa';

  @override
  String get configGeneral => 'Jumla';

  @override
  String get configTaxConfiguration => 'Usanidi wa kodi';

  @override
  String get configSaveAppliesTo =>
      'Kuhifadhi kunahusu URL ya EBM / kodi, URL ya data connector, msimbo wa tawi na MRC.';

  @override
  String get configTaxServerUrl => 'URL ya seva ya EBM / kodi';

  @override
  String get configDataConnectorUrl => 'URL ya data connector';

  @override
  String get configDataConnectorHelper =>
      'Usajili wa bidhaa nyingi kwa RRA hutumia huduma hii; URL ya kodi ya RRA husanidiwa kwenye data-connector.';

  @override
  String get configBranchCodeBhfId => 'Msimbo wa tawi (bhfId)';

  @override
  String get configBranchCode => 'Msimbo wa tawi';

  @override
  String get configEnterEbmUrl => 'Weka URL ya EBM';

  @override
  String get configSystemConfiguration => 'Usanidi wa mfumo';

  @override
  String get configSystemConfigSubtitle =>
      'Simamia tabia ya POS, sarafu na muunganisho wa kodi.';

  @override
  String get configTrainingMode => 'Hali ya mafunzo';

  @override
  String get configProformaMode => 'Hali ya proforma';

  @override
  String get configPrintA4 => 'Chapisha A4';

  @override
  String get configExportAsPdf => 'Hamisha kama PDF';

  @override
  String get configSystemCurrency => 'Sarafu ya mfumo';

  @override
  String get configVatEnabled => 'VAT imewezeshwa';

  @override
  String get configVatControlledByEbm => 'Inadhibitiwa na usanidi wa EBM';

  @override
  String get configVatStatusControlledByEbm =>
      'Hali ya VAT inadhibitiwa na usanidi wa EBM';

  @override
  String get configLoading => 'Inapakia...';

  @override
  String get configErrorLoadingVat => 'Hitilafu wakati wa kupakia hali ya VAT';

  @override
  String configErrorWithDetails(String error) {
    return 'Hitilafu: $error';
  }

  @override
  String get configTourismTaxRegistered => 'Imesajiliwa kwa kodi ya utalii';

  @override
  String get configTourismTaxHint =>
      'Wezesha tu ikiwa RRA imesajili tawi hili kwa kodi ya utalii. Vinginevyo vyumba husajiliwa kama huduma za kawaida.';

  @override
  String get configVersionNotAvailable => 'Toleo halipatikani';

  @override
  String configVersion(String version) {
    return 'Toleo $version';
  }

  @override
  String get configSaving => 'Inahifadhi…';

  @override
  String get configSaved => 'Imehifadhiwa';

  @override
  String get configSaveConfiguration => 'Hifadhi usanidi';

  @override
  String get leadsFilterAll => 'Zote';

  @override
  String get leadsStatusNew => 'Mpya';

  @override
  String get leadsStatusContacted => 'Amewasiliana';

  @override
  String get leadsStatusQuoted => 'Amepewa bei';

  @override
  String get leadsStatusConverted => 'Amenunua';

  @override
  String get leadsStatusLost => 'Amepotea';

  @override
  String get leadsHeatHot => 'Moto';

  @override
  String get leadsHeatWarm => 'Vuguvugu';

  @override
  String get leadsHeatCold => 'Baridi';

  @override
  String get leadsHotLead => 'Mteja moto';

  @override
  String get leadsWarmLead => 'Mteja vuguvugu';

  @override
  String get leadsColdLead => 'Mteja baridi';

  @override
  String get leadsSourceWalkIn => 'Wa dukani';

  @override
  String get leadsSubtitle =>
      'Fuatilia wateja, maulizo na thamani inayotarajiwa';

  @override
  String leadsEmailsNeedReview(String count) {
    return 'Barua pepe $count zinahitaji kukaguliwa';
  }

  @override
  String get leadsFilter => 'Chuja';

  @override
  String get leadsAddLead => 'Ongeza mteja mtarajiwa';

  @override
  String get leadsStatTotalLeads => 'Jumla ya wateja watarajiwa';

  @override
  String get leadsStatAllSources => 'Vyanzo vyote';

  @override
  String get leadsStatPipelineValue => 'Thamani inayotarajiwa';

  @override
  String get leadsStatActiveLeads => 'Wateja watarajiwa hai';

  @override
  String get leadsStatCompletedSales => 'Mauzo yaliyokamilika';

  @override
  String get leadsStatFromGmail => 'Kutoka Gmail';

  @override
  String get leadsStatEmailEnquiries => 'Maulizo ya barua pepe';

  @override
  String get leadsStatConversionRate => 'Kiwango cha ubadilishaji';

  @override
  String get leadsStatThisMonth => 'Mwezi huu';

  @override
  String get leadsAllLeads => 'Wateja watarajiwa wote';

  @override
  String get leadsUnableToLoad => 'Imeshindwa kupakia wateja watarajiwa.';

  @override
  String get leadsSearchHint => 'Tafuta jina, barua pepe, bidhaa…';

  @override
  String get leadsNoLeadsYet => 'Hakuna wateja watarajiwa bado.';

  @override
  String get leadsColSource => 'Chanzo';

  @override
  String get leadsColInterestedIn => 'Anavutiwa na';

  @override
  String get leadsColValue => 'Thamani';

  @override
  String get leadsColStage => 'Hatua';

  @override
  String get leadsColHeat => 'Hamu';

  @override
  String get leadsColDate => 'Tarehe';

  @override
  String get leadsPipeline => 'Mfululizo wa mauzo';

  @override
  String get leadsPerformance => 'Utendaji';

  @override
  String get leadsConversionRateThisMonth =>
      'Kiwango cha ubadilishaji mwezi huu';

  @override
  String get leadsAvgTimeToConvert => 'Wastani wa muda wa kubadilisha';

  @override
  String leadsDaysCount(String days) {
    return 'Siku $days';
  }

  @override
  String get leadsEmailReviewComingSoon =>
      'Ukaguzi wa wateja kutoka barua pepe unakuja hivi karibuni.';

  @override
  String get leadsGmailAiFlagged =>
      'Gmail - AI imewatambua hawa kama wateja watarajiwa.';

  @override
  String leadsPendingCount(String count) {
    return '$count zinasubiri';
  }

  @override
  String get leadsGmailIngestionLater =>
      'Uingizaji kutoka Gmail utawezeshwa baadaye. Kwa sasa, ongeza wateja watarajiwa wewe mwenyewe.';

  @override
  String get leadsFilterLeads => 'Chuja wateja watarajiwa';

  @override
  String get leadsContactDetails => 'Maelezo ya mawasiliano';

  @override
  String get leadsEstValue => 'Thamani ya makadirio';

  @override
  String get leadsNotes => 'Maelezo';

  @override
  String get leadsAiExtractedItems => 'Bidhaa zinazovutia zilizotolewa na AI';

  @override
  String leadsMatchPercent(String percent) {
    return 'Inalingana $percent%';
  }

  @override
  String get leadsActivityTimeline => 'Mfuatano wa shughuli';

  @override
  String get leadsCreatedFromGmail =>
      'Mteja mtarajiwa ameundwa — kutoka barua pepe ya Gmail';

  @override
  String get leadsCreatedManual =>
      'Mteja mtarajiwa ameundwa — kuingizwa kwa mkono';

  @override
  String get leadsTimelineAuto => 'Kiotomatiki';

  @override
  String get leadsTimelinePending => 'Inasubiri';

  @override
  String leadsAiExtractedProducts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'bidhaa $count',
      one: 'bidhaa 1',
    );
    return 'AI imetoa $_temp0 zinazovutia';
  }

  @override
  String get leadsProformaDraftReady =>
      'Rasimu ya proforma iko tayari kukaguliwa';

  @override
  String get leadsReviewProforma => 'Kagua proforma';

  @override
  String get leadsConverting => 'Inabadilisha…';

  @override
  String get leadsConvertToSale => 'Badilisha kuwa mauzo';

  @override
  String leadsConvertFailed(String error) {
    return 'Imeshindwa kubadilisha mteja mtarajiwa. $error';
  }

  @override
  String get leadsFullNameRequired => 'Jina kamili *';

  @override
  String get leadsFullNameHint => 'Jina kamili';

  @override
  String get leadsEmailAddress => 'Anwani ya barua pepe';

  @override
  String get leadsNotesOptional => 'Maelezo (si lazima)';

  @override
  String get leadsNotesHint => 'Waliomba nini?';

  @override
  String get leadsSaveLead => 'Hifadhi mteja mtarajiwa';

  @override
  String get leadsProductsInterestedRequired => 'Bidhaa anazovutiwa nazo *';

  @override
  String get leadsBrowseCatalogue => 'Vinjari katalogi';

  @override
  String get leadsTypeProductHint => 'Au andika jina la bidhaa, SKU, BCD…';

  @override
  String get leadsAddLeadSubtitle => 'Rekodi mteja mpya au ulizo kwa mkono';

  @override
  String get leadsWalkInCustomer => 'Mteja wa dukani';

  @override
  String get leadsPhoneReferral => 'Simu / Rufaa';

  @override
  String get leadsEstimatedValue => 'Thamani ya makadirio';

  @override
  String get leadsLeadHeat => 'Kiwango cha hamu';

  @override
  String leadsSaveFailed(String error) {
    return 'Imeshindwa kuhifadhi mteja mtarajiwa. $error';
  }

  @override
  String get leadsPickFromCatalogue => 'Chagua kutoka katalogi';

  @override
  String get leadsSearchCatalogHint => 'Tafuta jina, SKU, BCD…';

  @override
  String get leadsNoItemsFound => 'Hakuna bidhaa zilizopatikana';

  @override
  String get leadsProformaNewItem => 'Bidhaa mpya';

  @override
  String get leadsProforma => 'Proforma';

  @override
  String get leadsProformaInvoice => 'Ankara ya proforma';

  @override
  String leadsProformaSubtitle(String name) {
    return 'Mteja mtarajiwa: $name · Rasimu ya AI — kagua kabla ya kutuma';
  }

  @override
  String get leadsSend => 'Tuma';

  @override
  String get leadsSending => 'Inatuma…';

  @override
  String get leadsDownloadPdf => 'Pakua PDF';

  @override
  String get leadsProformaAiBannerNarrow =>
      'AI imeandaa rasimu kutoka barua pepe. Gusa bei au kiasi chochote kubadilisha. Kagua mistari yote kabla ya kutuma.';

  @override
  String get leadsProformaAiBanner =>
      'AI imeandaa proforma hii kutoka barua pepe ya mteja';

  @override
  String get leadsAllFieldsEditable => 'Sehemu zote zinaharirika';

  @override
  String get leadsDraft => 'Rasimu';

  @override
  String get leadsDraftNotSent => 'Rasimu — haijatumwa';

  @override
  String get leadsBillTo => 'Mlipaji';

  @override
  String get leadsIssueDate => 'Tarehe ya kutolewa';

  @override
  String get leadsValidUntil => 'Halali hadi';

  @override
  String get leadsLeadSource => 'Chanzo cha mteja';

  @override
  String get leadsGmailEnquiry => 'Ulizo la Gmail';

  @override
  String get leadsManualEntry => 'Kuingizwa kwa mkono';

  @override
  String get leadsAiMatchedItems => 'AI imelinganisha bidhaa na katalogi';

  @override
  String get leadsColItem => 'Bidhaa';

  @override
  String get leadsColPrice => 'Bei';

  @override
  String get leadsColTotal => 'Jumla';

  @override
  String get leadsColDescription => 'Maelezo';

  @override
  String get leadsColUnitPrice => 'Bei ya kimoja';

  @override
  String get leadsColQty => 'Idadi';

  @override
  String get leadsAddProductHint => 'Ongeza bidhaa...';

  @override
  String get leadsAddShort => '+ Ongeza';

  @override
  String get leadsSearchProductToAddLine => '+ Tafuta bidhaa kuongeza mstari…';

  @override
  String get leadsAddLine => 'Ongeza mstari';

  @override
  String get leadsVat18 => 'VAT 18%';

  @override
  String get leadsGrandTotal => 'Jumla kuu';

  @override
  String get leadsTermsShort => 'Halali siku 7. Malipo wakati wa kuwasilisha.';

  @override
  String get leadsTermsLong =>
      'Proforma hii ni halali kwa siku 7. Malipo wakati wa kuwasilisha. Tunapokea uhamisho wa benki au pesa kwa simu.';

  @override
  String get leadsNotesTerms => 'Maelezo / Masharti';

  @override
  String get leadsSummary => 'Muhtasari';

  @override
  String get leadsLines => 'Mistari';

  @override
  String leadsLinesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mistari $count',
      one: 'Mstari 1',
    );
    return '$_temp0';
  }

  @override
  String get leadsStatus => 'Hali';

  @override
  String get leadsHistory => 'Historia';

  @override
  String get leadsHistoryAiDrafted => 'AI imeandaa kutoka barua pepe ya Gmail';

  @override
  String get leadsHistoryLeadCreated =>
      'Mteja mtarajiwa ameundwa, proforma imetengenezwa';

  @override
  String get leadsHistoryAwaitingReview => 'Inasubiri ukaguzi wa mtumiaji';

  @override
  String get leadsToday => 'Leo';

  @override
  String get leadsNow => 'Sasa';

  @override
  String get leadsNoContactProvided => 'Hakuna mawasiliano yaliyotolewa';

  @override
  String get leadsPdfSaved => 'PDF ya proforma imehifadhiwa.';

  @override
  String leadsPdfExportFailed(String error) {
    return 'Imeshindwa kuhamisha PDF: $error';
  }

  @override
  String get leadsPdfReadyToShare => 'PDF ya proforma iko tayari kushirikiwa.';

  @override
  String leadsSendPrepareFailed(String error) {
    return 'Imeshindwa kuandaa kutuma: $error';
  }

  @override
  String get leadsConvertedToSale =>
      'Mteja mtarajiwa amebadilishwa kuwa mauzo.';

  @override
  String leadsConvertFailedShort(String error) {
    return 'Imeshindwa kubadilisha: $error';
  }

  @override
  String get gigsNegotiable => 'Bei ya maelewano';

  @override
  String gigsDurationHoursMinutes(String hours, String minutes) {
    return 'Saa $hours dakika $minutes';
  }

  @override
  String gigsDurationMinutes(String minutes) {
    return 'Dakika $minutes';
  }

  @override
  String get gigsStatusAwaitingProviderResponse =>
      'Inasubiri jibu la mtoa huduma';

  @override
  String get gigsStatusAcceptWindowExpired => 'Muda wa kukubali umeisha';

  @override
  String get gigsStatusAwaitingPayment => 'Inasubiri malipo';

  @override
  String get gigsStatusPaymentWindowExpired => 'Muda wa kulipa umeisha';

  @override
  String get gigsStatusPaidReadyToStart => 'Imelipwa - Tayari kuanza';

  @override
  String get gigsStatusRequested => 'Imeombwa';

  @override
  String get gigsStatusPendingPayment => 'Malipo yanasubiriwa';

  @override
  String get gigsStatusPaid => 'Imelipwa';

  @override
  String get gigsStatusInProgress => 'Inaendelea';

  @override
  String get gigsStatusCompleted => 'Imekamilika';

  @override
  String get gigsStatusDeclined => 'Imekataliwa';

  @override
  String get gigsStatusDeclinedByProvider => 'Imekataliwa na mtoa huduma';

  @override
  String get gigsStatusExpired => 'Muda umeisha';

  @override
  String get gigsStatusCancelled => 'Imeghairiwa';

  @override
  String get gigsStatusAccepted => 'Imekubaliwa';

  @override
  String get gigsCategoryHomeServices => 'Huduma za nyumbani';

  @override
  String get gigsCategoryBeautyWellness => 'Urembo na ustawi';

  @override
  String get gigsCategoryDeliveryTransport => 'Usafirishaji na uwasilishaji';

  @override
  String get gigsCategoryTechSupport => 'Msaada wa kiufundi';

  @override
  String get gigsCategoryEvents => 'Matukio';

  @override
  String get gigsCategoryLessons => 'Masomo na mafunzo';

  @override
  String get gigsCategoryHealthcare => 'Huduma za afya';

  @override
  String get gigsCategoryOther => 'Nyingine';

  @override
  String get gigsErrSignInToRequest => 'Ingia ili kuomba huduma.';

  @override
  String get gigsErrRequestSelf => 'Huwezi kujiomba huduma mwenyewe.';

  @override
  String get gigsErrMinAmount => 'Weka kiasi cha angalau 100 RWF.';

  @override
  String get gigsErrSendRequest => 'Imeshindwa kutuma ombi lako.';

  @override
  String get gigsErrSendRequestConnection =>
      'Imeshindwa kutuma ombi lako. Angalia muunganisho wako kisha ujaribu tena.';

  @override
  String get gigsErrSignInToPay => 'Ingia ili kukamilisha malipo.';

  @override
  String get gigsErrValidAmount => 'Weka kiasi sahihi.';

  @override
  String get gigsErrRequestNotFound => 'Ombi halikupatikana.';

  @override
  String get gigsErrNotAwaitingPayment => 'Ombi hili halisubiri malipo.';

  @override
  String get gigsErrPaymentWindowEnded =>
      'Muda wa kulipa umeisha. Wasiliana na mtoa huduma ili kutuma ombi jipya.';

  @override
  String get gigsErrConfirmPayment =>
      'Imeshindwa kuthibitisha malipo. Huenda tayari yamerekodiwa.';

  @override
  String get gigsErrSavePayment => 'Imeshindwa kuhifadhi malipo.';

  @override
  String get gigsErrSavePaymentConnection =>
      'Imeshindwa kuhifadhi malipo. Angalia muunganisho wako.';

  @override
  String get gigsErrSignInToRespond => 'Ingia ili kujibu maombi.';

  @override
  String get gigsErrCannotAccept =>
      'Ombi hili haliwezi kukubaliwa tena. Huenda muda wake umeisha au tayari limeshughulikiwa.';

  @override
  String get gigsErrAccept => 'Imeshindwa kukubali ombi.';

  @override
  String get gigsErrAcceptConnection =>
      'Imeshindwa kukubali ombi. Angalia muunganisho wako kisha ujaribu tena.';

  @override
  String get gigsErrSignInToDispatch => 'Ingia ili kutuma malipo.';

  @override
  String get gigsErrPayoutReference => 'Weka kumbukumbu ya malipo.';

  @override
  String get gigsErrUpdatePayout => 'Imeshindwa kusasisha hali ya malipo.';

  @override
  String get gigsErrSignInToMessage => 'Ingia ili kutuma ujumbe.';

  @override
  String get gigsErrEmptyMessage => 'Ujumbe hauwezi kuwa tupu.';

  @override
  String get gigsErrRequestClosed => 'Ombi hili limefungwa.';

  @override
  String get gigsErrSendMessage => 'Imeshindwa kutuma ujumbe.';

  @override
  String get gigsErrSignInToUpdate => 'Ingia ili kusasisha ombi hili.';

  @override
  String get gigsErrOnlyPaidToStart =>
      'Maombi yaliyolipwa na hayajaanza tu ndiyo yanaweza kuhamishiwa kwenye yanayoendelea.';

  @override
  String get gigsErrUpdateStatus => 'Imeshindwa kusasisha hali.';

  @override
  String get gigsErrMarkComplete =>
      'Imeshindwa kuweka kuwa imekamilika. Huenda tayari imekamilika.';

  @override
  String get gigsErrSignInToReview => 'Ingia ili kuacha maoni.';

  @override
  String get gigsErrPickRating => 'Chagua ukadiriaji kuanzia 1 hadi 5.';

  @override
  String get gigsErrShortComment => 'Tafadhali ongeza maoni mafupi.';

  @override
  String get gigsErrOnlyCompletedReview =>
      'Kazi zilizokamilika tu ndizo zinaweza kutolewa maoni.';

  @override
  String get gigsErrAlreadyReviewed => 'Tayari umeacha maoni.';

  @override
  String get gigsErrSaveReviewRetry =>
      'Imeshindwa kuhifadhi maoni. Jaribu tena.';

  @override
  String get gigsErrSaveReview => 'Imeshindwa kuhifadhi maoni.';

  @override
  String get gigsAdminMetricsTitle => 'Takwimu za kituo cha huduma';

  @override
  String get gigsPayouts => 'Malipo kwa watoa huduma';

  @override
  String get gigsPendingDispatch => 'Yanasubiri kutumwa';

  @override
  String get gigsDispatched => 'Yametumwa';

  @override
  String get gigsPendingTotalRwf => 'Jumla inayosubiriwa (RWF)';

  @override
  String get gigsRequestsByStatus => 'Maombi kwa hali';

  @override
  String get gigsMetrics => 'Takwimu';

  @override
  String get gigsProvider => 'Mtoa huduma';

  @override
  String gigsProviderShortId(String suffix) {
    return 'Mtoa huduma · …$suffix';
  }

  @override
  String gigsCustomerShortId(String suffix) {
    return 'Mteja · …$suffix';
  }

  @override
  String get gigsPayoutReference => 'Kumbukumbu ya malipo';

  @override
  String get gigsPayoutReferenceHint => 'Kumbukumbu ya MTN / leja';

  @override
  String get gigsMarkDispatched => 'Weka kuwa yametumwa';

  @override
  String get gigsMarkedDispatched => 'Imewekwa kuwa imetumwa.';

  @override
  String get gigsDispatchPayouts => 'Tuma malipo';

  @override
  String get gigsNoPayoutsPending => 'Hakuna malipo yanayosubiri';

  @override
  String get gigsNoPayoutsPendingHint =>
      'Kazi zikishalipwa zitaonekana hapa hadi malipo yatumwe.';

  @override
  String gigsPayoutAmountLine(String amount, String status, String date) {
    return 'Kiasi: $amount RWF · $status\nImetumwa $date';
  }

  @override
  String get gigsWaitingForProvider => 'Inamsubiri mtoa huduma';

  @override
  String get gigsPayNow => 'Lipa sasa';

  @override
  String get gigsPaymentWindowEnded => 'Muda wa kulipa umekwisha';

  @override
  String get gigsPaymentRecordedCanStart =>
      'Malipo yamerekodiwa. Mtoa huduma anaweza kuanza kazi.';

  @override
  String get gigsMyRequests => 'Maombi yangu';

  @override
  String get gigsNoRequestsYet => 'Hakuna maombi bado';

  @override
  String get gigsMyRequestsEmptyHint =>
      'Ukimwomba mtu huduma kupitia Tafuta watoa huduma, itaonekana hapa. Akikubali, unaweza kulipa kwa MTN ndani ya muda ulioonyeshwa.';

  @override
  String get gigsAgreedAmount => 'Kiasi kilichokubaliwa';

  @override
  String get gigsSent => 'Imetumwa';

  @override
  String gigsPayBy(String date) {
    return 'Lipa kabla ya $date';
  }

  @override
  String gigsDidNotPayBefore(String date) {
    return 'Hukulipa kabla ya $date';
  }

  @override
  String gigsPaidAmountSettled(String amount, String settled) {
    return 'Imelipwa $amount RWF · MTN imelipa $settled RWF';
  }

  @override
  String gigsPaidAmount(String amount) {
    return 'Imelipwa $amount RWF';
  }

  @override
  String get gigsPayWithMtn => 'Lipa kwa MTN';

  @override
  String gigsRequestFrom(String name) {
    return 'Ombi kutoka kwa $name';
  }

  @override
  String gigsRequestTo(String name) {
    return 'Ombi kwa $name';
  }

  @override
  String get gigsNotifications => 'Arifa';

  @override
  String get gigsNoActivityYet => 'Hakuna shughuli bado';

  @override
  String get gigsActivityEmptyHint =>
      'Ukituma au kupokea maombi ya huduma, taarifa mpya zitaonekana hapa. Vuta chini ili kuonyesha upya.';

  @override
  String gigsUpdatedAt(String date) {
    return 'Imesasishwa $date';
  }

  @override
  String get gigsPaymentRecorded => 'Malipo yamerekodiwa.';

  @override
  String get gigsMarkedInProgress => 'Imewekwa kuwa inaendelea.';

  @override
  String get gigsJobMarkedComplete =>
      'Kazi imewekwa kuwa imekamilika. Mteja anaweza kutoa maoni.';

  @override
  String get gigsRateYourExperience => 'Kadiria uzoefu wako';

  @override
  String get gigsComment => 'Maoni';

  @override
  String get gigsThanksForReview => 'Asante kwa maoni yako.';

  @override
  String get gigsRequestDetails => 'Maelezo ya ombi';

  @override
  String get gigsMessages => 'Jumbe';

  @override
  String get gigsNoMessagesYet =>
      'Hakuna jumbe bado. Panga muda na mahali hapa.';

  @override
  String get gigsTypeMessageHint => 'Andika ujumbe…';

  @override
  String get gigsStartJob => 'Anza kazi';

  @override
  String get gigsMarkJobComplete => 'Weka kazi kuwa imekamilika';

  @override
  String get gigsLeaveReview => 'Acha maoni';

  @override
  String get gigsYourReview => 'Maoni yako';

  @override
  String get gigsAdvancedFilters => 'Vichujio vya kina';

  @override
  String gigsMinRating(String rating) {
    return 'Ukadiriaji wa wastani wa chini: $rating';
  }

  @override
  String get gigsVerifiedOnly => 'Watoa huduma waliothibitishwa tu';

  @override
  String get gigsAvailableForBooking => 'Anapatikana kwa kuhifadhiwa';

  @override
  String get gigsMaxBasePrice => 'Bei ya msingi ya juu (RWF), si lazima';

  @override
  String get gigsCategory => 'Kategoria';

  @override
  String get gigsAllCategories => 'Kategoria zote';

  @override
  String get gigsApplyFilters => 'Tumia vichujio';

  @override
  String get gigsFindProvider => 'Tafuta mtoa huduma';

  @override
  String get gigsNoProvidersYet => 'Hakuna watoa huduma bado';

  @override
  String get gigsNoProvidersHint =>
      'Watu wakitoa huduma zao hapa, utawaona kwenye orodha hii na unaweza kutuma ombi.\n\nVuta chini ili kuonyesha upya. Ikiwa wewe mwenyewe umesajiliwa kama mtoa huduma, wasifu wako hauonyeshwi kwenye orodha hii.';

  @override
  String get gigsSearchHint => 'Tafuta jina, eneo au huduma…';

  @override
  String get gigsBrowseByService => 'Vinjari kwa huduma';

  @override
  String get gigsAll => 'Zote';

  @override
  String get gigsNoMatches => 'Hakuna zinazolingana';

  @override
  String get gigsNoMatchesHint =>
      'Jaribu maneno mengine, chagua huduma nyingine, au ondoa vichujio.';

  @override
  String get gigsClearSearchFilters => 'Ondoa utafutaji na vichujio';

  @override
  String get gigsErrUpdateAvailability =>
      'Imeshindwa kusasisha upatikanaji kwenye seva.';

  @override
  String get gigsVisibleToCustomers => 'Wateja wanakuona.';

  @override
  String get gigsMarkedUnavailable => 'Umewekwa kuwa haupatikani.';

  @override
  String get gigsProviderDashboard => 'Dashibodi ya mtoa huduma';

  @override
  String get gigsAcceptNewRequests => 'Kubali maombi mapya';

  @override
  String get gigsAcceptNewRequestsHint =>
      'Ikizimwa, wateja bado wanaweza kufungua wasifu wako lakini hawawezi kukuhifadhi.';

  @override
  String get gigsRecordedPayments => 'Malipo yaliyorekodiwa (RWF)';

  @override
  String gigsFundedJobs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kazi $count zilizolipwa kwenye data ya kituo',
      one: 'Kazi 1 iliyolipwa kwenye data ya kituo',
    );
    return '$_temp0';
  }

  @override
  String get gigsOpenRequests => 'Maombi yaliyo wazi';

  @override
  String get gigsAwaitingResponseOrPayment => 'Yanasubiri jibu au malipo';

  @override
  String get gigsActiveJobs => 'Kazi zinazoendelea';

  @override
  String get gigsPaidOrInProgress => 'Zimelipwa au zinaendelea';

  @override
  String get gigsPayoutsHandledNote =>
      'Malipo na ada za jukwaa hushughulikiwa kupitia mifumo yako ya MTN na leja iliyopo.';

  @override
  String get gigsRequestSentTrack =>
      'Ombi limetumwa. Lifuatilie kwenye Maombi yangu.';

  @override
  String get gigsPricing => 'Bei';

  @override
  String gigsFromPrice(String price) {
    return 'Kuanzia $price';
  }

  @override
  String get gigsAvailability => 'Upatikanaji';

  @override
  String get gigsPortfolio => 'Kazi za awali';

  @override
  String get gigsReviews => 'Maoni';

  @override
  String get gigsRequestThisProvider => 'Omba mtoa huduma huyu';

  @override
  String get gigsUnavailableNow => 'Hapatikani kwa sasa';

  @override
  String get gigsVerified => 'Amethibitishwa';

  @override
  String get gigsBackgroundChecked => 'Historia imekaguliwa';

  @override
  String get gigsStandardProfile => 'Wasifu wa kawaida wa mtoa huduma';

  @override
  String gigsReviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maoni $count',
      one: 'Maoni 1',
    );
    return '$_temp0';
  }

  @override
  String gigsJobsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kazi $count',
      one: 'Kazi 1',
    );
    return '$_temp0';
  }

  @override
  String get gigsAcceptedCustomerCanPay =>
      'Imekubaliwa. Mteja anaweza kulipa kwenye Kituo cha huduma → Maombi yangu (dakika 5).';

  @override
  String get gigsErrAcceptRetry => 'Imeshindwa kukubali. Jaribu tena.';

  @override
  String get gigsDeclineRequestTitle => 'Kataa ombi?';

  @override
  String get gigsDeclineRequestBody => 'Mteja ataona kuwa umekataa ombi hili.';

  @override
  String get gigsDecline => 'Kataa';

  @override
  String get gigsAccept => 'Kubali';

  @override
  String get gigsRequestDeclined => 'Ombi limekataliwa.';

  @override
  String get gigsErrDeclineRetry => 'Imeshindwa kukataa. Jaribu tena.';

  @override
  String get gigsAwaitingYourResponse => 'Inasubiri jibu lako';

  @override
  String get gigsWaitingForCustomerPayment => 'Inasubiri malipo ya mteja';

  @override
  String get gigsIncomingRequests => 'Maombi yanayoingia';

  @override
  String get gigsInboxEmptyHint =>
      'Mtu akikuomba huduma kupitia Kituo cha huduma, ombi lake litaonekana hapa. Utakuwa na muda mfupi wa kukubali au kukataa.';

  @override
  String get gigsAcceptDeadlinePassed => 'Muda wa kukubali umepita';

  @override
  String gigsCustomerBudget(String amount) {
    return 'Bajeti ya mteja: $amount RWF';
  }

  @override
  String gigsReceivedAt(String date) {
    return 'Imepokelewa $date';
  }

  @override
  String gigsRespondBy(String date) {
    return 'Jibu kabla ya $date';
  }

  @override
  String gigsPaymentDueBy(String date) {
    return 'Malipo kabla ya $date';
  }

  @override
  String get gigsErrSignInToRegister =>
      'Unahitaji kuingia ili kujisajili kama mtoa huduma.';

  @override
  String get gigsErrAddService => 'Ongeza angalau huduma moja unayoweza kutoa.';

  @override
  String get gigsProfileSaved => 'Wasifu wa mtoa huduma umehifadhiwa.';

  @override
  String gigsSaveOnlineFailed(String error) {
    return 'Imeshindwa kuhifadhi mtandaoni: $error';
  }

  @override
  String get gigsSavedOnDevice =>
      'Imehifadhiwa kwenye kifaa hiki. Itasawazishwa seva ikipatikana.';

  @override
  String get gigsYourProviderProfile => 'Wasifu wako wa mtoa huduma';

  @override
  String get gigsBecomeProvider => 'Kuwa mtoa huduma';

  @override
  String get gigsRegistrationIntro =>
      'Waambie wateja unachotoa. Unaweza kubadilisha hili wakati wowote.';

  @override
  String get gigsErrNameMin => 'Weka jina (angalau herufi 2).';

  @override
  String get gigsContactPhone => 'Simu ya mawasiliano';

  @override
  String get gigsErrPhoneHelps => 'Simu husaidia wateja kukufikia.';

  @override
  String get gigsAboutYou => 'Kuhusu wewe';

  @override
  String get gigsErrBioMin => 'Ongeza wasifu mfupi (angalau herufi 12).';

  @override
  String get gigsServicesYouProvide => 'Huduma unazotoa';

  @override
  String get gigsServicesHint =>
      'Moja kwa kila mstari (mf. mabomba, usafi wa nyumba, uwasilishaji).';

  @override
  String get gigsServices => 'Huduma';

  @override
  String get gigsServiceAreaOptional => 'Eneo la huduma (si lazima)';

  @override
  String get gigsServiceAreaHint => 'Mtaa, jiji au umbali';

  @override
  String get gigsCategoriesOptional => 'Kategoria (si lazima)';

  @override
  String get gigsCategoriesHint => 'Husaidia wateja kuchuja orodha.';

  @override
  String get gigsSaveChanges => 'Hifadhi mabadiliko';

  @override
  String get gigsSubmitRegistration => 'Tuma usajili';

  @override
  String get gigsHowProvidersTitle => 'Watoa huduma';

  @override
  String get gigsHowProvidersBody =>
      'Wafanyakazi hujisajili na kuorodhesha huduma wanazoweza kufanyia wengine.';

  @override
  String get gigsHowRatingsTitle => 'Ukadiriaji';

  @override
  String get gigsHowRatingsBody =>
      'Tunatoa na kusasisha ukadiriaji kutokana na uthibitisho wetu na maoni ya wateja.';

  @override
  String get gigsHowRequestsTitle => 'Maombi';

  @override
  String get gigsHowRequestsBody =>
      'Wateja hutuma ombi la huduma kwa mtoa huduma waliyemchagua. Mtoa huduma lazima akubali au akatae ndani ya dakika 30.';

  @override
  String get gigsHowRequestsHighlight => 'Dakika 30 kukubali';

  @override
  String get gigsHowPaymentTitle => 'Muda wa malipo';

  @override
  String get gigsHowPaymentBody =>
      'Baada ya kukubaliwa, mteja hukamilisha malipo ndani ya dakika 5 ili kazi ithibitishwe na kulipiwa.';

  @override
  String get gigsHowPaymentHighlight => 'Dakika 5 kulipa';

  @override
  String get gigsHowExecutionTitle => 'Utekelezaji';

  @override
  String get gigsHowExecutionBody =>
      'Baada ya malipo, mfanyakazi anaweza kuwasiliana na mteja na kutoa huduma.';

  @override
  String get gigsHowEscrowTitle => 'Amana na malipo';

  @override
  String get gigsHowEscrowBody =>
      'Tunakusanya fedha kupitia MTN (na API maalum za malipo). Pesa hutolewa pande zote mbili zikithibitisha kukamilika; leja hufuatilia salio, kamisheni na nani anadai nini.';

  @override
  String get gigsHowItWorksTitle => 'Jinsi Kituo cha huduma kinavyofanya kazi';

  @override
  String get gigsHowItWorks => 'Jinsi inavyofanya kazi';

  @override
  String get gigsAdminTools => 'Zana za msimamizi';

  @override
  String get gigsHubTagline =>
      'Tafuta watu wa kufanya kazi, au toa ujuzi wako—malipo hubaki kwenye jukwaa.';

  @override
  String get gigsFindProviders => 'Tafuta watoa huduma';

  @override
  String get gigsYourActivity => 'Shughuli zako';

  @override
  String get gigsProviderTools => 'Zana za mtoa huduma';

  @override
  String get gigsEarnOnHub => 'Pata kipato kwenye Kituo cha huduma';

  @override
  String get gigsEarnOnHubBody =>
      'Sajili huduma unazotoa ili wateja wakupate na kukuhifadhi.';

  @override
  String get gigsNoServicesListed => 'Hakuna huduma zilizoorodheshwa bado';

  @override
  String gigsMoreCount(String count) {
    return '+$count zaidi';
  }

  @override
  String get gigsTapToEditProfile => 'Gusa ili kuhariri wasifu';

  @override
  String get gigsEnterMomoNumberFull =>
      'Weka nambari ya MTN MoMo ya kutozwa (pochi ya simu, si barua pepe).';

  @override
  String get gigsPaymentDeclinedDefault => 'Malipo yamekataliwa.';

  @override
  String get gigsNothingChargedTryAgain =>
      'Hakuna kilichotozwa — unaweza kujaribu tena.';

  @override
  String get gigsPaymentNotConfirmed =>
      'Malipo bado hayajathibitishwa. Idhinisha ombi la MTN kwenye simu yako. Ikiwa pesa zimetoka kwenye akaunti yako, wasiliana na usaidizi kwa ombi hili badala ya kulipa tena.';

  @override
  String get gigsMoneyLeftContactSupport =>
      'Ikiwa pesa zimetoka kwenye pochi yako, wasiliana na usaidizi kwa ombi hili.';

  @override
  String get gigsPaymentSentNotUpdated =>
      'Huenda malipo yametumwa lakini hatukuweza kusasisha ombi.';

  @override
  String gigsPayProvider(String name) {
    return 'Mlipe $name';
  }

  @override
  String get gigsPaySheetIntro =>
      'Tunatuma ombi la MTN MoMo kwa nambari iliyo hapa chini. Liidhinishe kwenye simu yako; tunasubiri hadi dakika 5 kwa uthibitisho kabla ya kuweka ombi hili kuwa limelipwa.';

  @override
  String get gigsPaySheetEmailNote =>
      'Ikiwa uliingia kwa barua pepe (au hatuna pochi ya simu iliyohifadhiwa), weka nambari ya MTN MoMo inayopaswa kutozwa. Lazima iwe laini ya pesa kwa simu—si barua pepe.';

  @override
  String get gigsAmountRwf => 'Kiasi (RWF)';

  @override
  String get gigsMinimum100Rwf => 'Angalau 100 RWF';

  @override
  String get gigsMomoNumberLabel => 'Nambari ya MTN MoMo ya kutozwa';

  @override
  String get gigsMomoNumberHelper =>
      'Tumia nambari ya pochi ambayo MTN itaituma ombi, si barua pepe ya kuingia';

  @override
  String get gigsErrEnterMomoNumber => 'Weka nambari ya MTN MoMo ya kutozwa';

  @override
  String get gigsErrMobileNotEmail => 'Weka nambari ya simu, si barua pepe';

  @override
  String get gigsErrValidMobile =>
      'Weka nambari sahihi ya simu (tarakimu tu, 9–15)';

  @override
  String get gigsWaitingForPayment => 'Inasubiri malipo…';

  @override
  String get gigsSendPaymentRequest => 'Tuma ombi la malipo';

  @override
  String get gigsChooseService => 'Chagua huduma unayohitaji.';

  @override
  String get gigsSomethingWentWrong =>
      'Hitilafu imetokea. Tafadhali jaribu tena.';

  @override
  String get gigsWhichService => 'Unahitaji huduma gani?';

  @override
  String get gigsAmountYouWillPay => 'Kiasi utakacholipa (RWF)';

  @override
  String get gigsDescribeNeed => 'Eleza unachohitaji';

  @override
  String get gigsDescribeNeedExample =>
      'Mfano: Rekebisha bomba la jikoni linalovuja wikendi hii. Ninapatikana Jumamosi asubuhi.';

  @override
  String get gigsErrMoreDetail =>
      'Tafadhali ongeza maelezo zaidi (angalau herufi 20).';

  @override
  String get gigsProviderHas30Min =>
      'Mtoa huduma ana dakika 30 za kukubali. Baada ya hapo, unaweza kutuma ombi jipya.';

  @override
  String get gigsSendRequest => 'Tuma ombi';

  @override
  String get gigsTimelineRequestSent => 'Ombi limetumwa';

  @override
  String get gigsTimelineProviderAccepted => 'Mtoa huduma amekubali';

  @override
  String get gigsTimelinePaymentReceived => 'Malipo yamepokelewa';

  @override
  String get gigsTimelineWorkInProgress => 'Kazi inaendelea';

  @override
  String get gigsTimelineReviewSubmitted => 'Maoni yametumwa';

  @override
  String get gigsOrderTimeline => 'Mfuatano wa ombi';

  @override
  String get gigsErrCannotDecline =>
      'Ombi hili haliwezi kukataliwa tena. Huenda muda wake umeisha au tayari limeshughulikiwa.';

  @override
  String get gigsErrDecline => 'Imeshindwa kukataa ombi.';

  @override
  String get gigsErrDeclineConnection =>
      'Imeshindwa kukataa ombi. Angalia muunganisho wako kisha ujaribu tena.';

  @override
  String get productEditorCategorySwitchTo => 'Badilisha kwenda';

  @override
  String get productEditorCategoryPickYours => 'Au chagua moja kati ya yako';

  @override
  String get productEditorCategorySearchToChange =>
      'Tafuta ili kubadilisha kundi…';

  @override
  String get productEditorCategorySearch => 'Tafuta makundi…';

  @override
  String get productEditorCategoryNoneYet => 'Bado huna makundi';

  @override
  String productEditorCategoryNoMatch(String query) {
    return 'Hakuna kinacholingana na \"$query\"';
  }

  @override
  String productEditorCategoryMoreHidden(int count) {
    return 'Zaidi $count — endelea kuandika ili kupunguza';
  }

  @override
  String productEditorCategoryCreateNamed(String name) {
    return 'Unda \"$name\"';
  }

  @override
  String get productEditorCategoryFiledUnder => 'Imewekwa chini ya';

  @override
  String get productEditorCategoryRemove => 'Ondoa kundi';

  @override
  String get productEditorCategoryNoneChosen =>
      'Bado hujachagua kundi — tafuta hapo juu au unda jipya.';

  @override
  String get productEditorCategoryCreateNew => 'Unda kundi jipya';

  @override
  String get productEditorCategoryNew => 'Jipya';

  @override
  String get productEditorCompositeItem => 'Bidhaa mchanganyiko';

  @override
  String get productEditorCompositeHint =>
      'Imetengenezwa kwa bidhaa nyingine — bei ni jumla ya vipengele vyake';

  @override
  String get productEditorColorSelectShade => 'Chagua kivuli cha rangi';

  @override
  String get productEditorColorShades => 'VIVULI';

  @override
  String productEditorColorHueShade(String hue, int number) {
    return '$hue · kivuli $number';
  }

  @override
  String get productEditorColorSwatchHint =>
      'Hutumika kama rangi ya bidhaa kwenye POS na ripoti';

  @override
  String get productEditorColorChoose => 'Chagua rangi';

  @override
  String get productEditorHueRed => 'Nyekundu';

  @override
  String get productEditorHueOrange => 'Machungwa';

  @override
  String get productEditorHueAmber => 'Kaharabu';

  @override
  String get productEditorHueGreen => 'Kijani';

  @override
  String get productEditorHueTeal => 'Kijani-bluu';

  @override
  String get productEditorHueBlue => 'Bluu';

  @override
  String get productEditorHueIndigo => 'Nili';

  @override
  String get productEditorHueViolet => 'Zambarau';

  @override
  String get productEditorHueSlate => 'Kijivu cha bluu';

  @override
  String get productEditorReadyToSave => 'Tayari kuhifadhi';

  @override
  String productEditorSectionsComplete(String done, String total) {
    return 'Sehemu $done kati ya $total zimekamilika';
  }

  @override
  String get productEditorSaveProduct => 'Hifadhi bidhaa';

  @override
  String get productEditorUntitledProduct => 'Bidhaa isiyo na jina';

  @override
  String get productEditorBreadcrumbNewProduct => 'HISA · BIDHAA MPYA';

  @override
  String get productEditorBreadcrumbEditProduct => 'HISA · HARIRI BIDHAA';

  @override
  String get productEditorBreadcrumbNewComposite => 'HISA · MCHANGANYIKO MPYA';

  @override
  String get productEditorBreadcrumbEditComposite =>
      'HISA · HARIRI MCHANGANYIKO';

  @override
  String get productEditorOptional => 'si lazima';

  @override
  String get productEditorItemTypeFinished =>
      'Bidhaa iliyokamilika — tayari kuuzwa';

  @override
  String get productEditorItemTypeRawMaterial =>
      'Malighafi — hutumika kutengeneza bidhaa nyingine';

  @override
  String get productEditorItemTypeService =>
      'Huduma — hakuna cha kuweka kwenye hisa';

  @override
  String get productEditorCategoryHint =>
      'Huweka bidhaa hii kwenye kundi katika ripoti na skrini ya mauzo.';

  @override
  String get productEditorItemType => 'Aina ya bidhaa';

  @override
  String get productEditorItemTypeLocked =>
      'Imefungwa — haiwezi kubadilishwa baada ya bidhaa kuundwa.';

  @override
  String get productEditorItemTypeHint =>
      'Bidhaa nyingi za dukani ni bidhaa zilizokamilika.';

  @override
  String get productEditorPackagingUnit => 'Kipimo cha kifurushi';

  @override
  String get productEditorCountryOfOrigin => 'Nchi ya asili';

  @override
  String get productEditorNoCountryList =>
      'Orodha ya nchi bado haipatikani — bidhaa mpya huhifadhiwa kama RW.';

  @override
  String get productEditorCountryDefaultRw => 'RW (chaguo-msingi)';

  @override
  String get productEditorCountriesLoadFailed => 'Imeshindwa kupakia nchi';

  @override
  String get productEditorOriginNotSet => 'asili haijawekwa';

  @override
  String get productEditorTaxDetailsTitle =>
      'Kifurushi na asili (kwa ripoti ya kodi)';

  @override
  String get productEditorTapToHide => 'Gusa ili kuficha';

  @override
  String get productEditorProfitPerUnit => 'Faida kwa kila kipimo';

  @override
  String get productEditorMargin => 'Kiwango cha faida';

  @override
  String get productEditorSupplyFromComponents =>
      'Bei ya ununuzi imekokotolewa kutoka kwa vipengele';

  @override
  String get productEditorNoVariantsExisting => 'Bidhaa hii haina aina';

  @override
  String get productEditorNoVariantsYet => 'Bado hakuna aina';

  @override
  String get productEditorNoVariantsHint =>
      'Changanua msimbopau au andika jina hapo juu ili kuongeza';

  @override
  String get productEditorSectionsHeading => 'SEHEMU';

  @override
  String get productEditorScanHint => 'Changanua au andika jina la aina…';

  @override
  String get productEditorScanWithCamera => 'Changanua kwa kamera';

  @override
  String get productEditorAddVariant => 'Ongeza aina';

  @override
  String get productEditorScanTipPress => 'Bonyeza';

  @override
  String get productEditorScanTipEnterKey => 'Enter';

  @override
  String get productEditorScanTipOrTapAdd => 'au gusa Ongeza aina';

  @override
  String get productEntryAddNewProduct => 'Ongeza bidhaa mpya';

  @override
  String get productEntryEditProduct => 'Hariri bidhaa';

  @override
  String get productEntryNameRequired => 'Jina la bidhaa linahitajika';

  @override
  String get productEntryNameTooShort =>
      'Jina la bidhaa lazima liwe na angalau herufi 3';

  @override
  String get productEntryProductName => 'Jina la bidhaa';

  @override
  String get productEntryProductNameHint => 'mf. Kahawa ya Arabika';

  @override
  String get productEntryInventoryTitle => 'Hisa na makundi';

  @override
  String get productEntryPackagingUnit => 'Kipimo cha kifurushi';

  @override
  String get productEntryPriceRequired => 'Bei inahitajika';

  @override
  String get productEntryRetailPrice => 'Bei ya rejareja';

  @override
  String get productEntrySupplyPrice => 'Bei ya ununuzi';

  @override
  String get productEntryQuickScan => 'Changanua haraka';

  @override
  String get productEntryScanLabel => 'Changanua au andika jina la aina';

  @override
  String get productionOutputLoadingSku => 'Inapakia...';

  @override
  String get inventoryDashboardTotalItems => 'Jumla ya bidhaa';

  @override
  String get inventoryDashboardExpiredItems => 'Bidhaa zilizoisha muda';

  @override
  String get inventoryDashboardLowStockItems => 'Bidhaa zenye hisa ndogo';

  @override
  String get inventoryDashboardPendingOrders => 'Oda zinazosubiri';

  @override
  String get inventoryDashboardFromLastWeek => 'tangu wiki iliyopita';

  @override
  String get inventoryDashboardTrendEstimate =>
      'Mwenendo huu unategemea makadirio';

  @override
  String inventoryDashboardIdValue(String id) {
    return 'ID: $id';
  }

  @override
  String inventoryDashboardCategoryValue(String category) {
    return 'Kundi: $category';
  }

  @override
  String inventoryDashboardQuantityValue(String quantity) {
    return 'Kiasi: $quantity';
  }

  @override
  String inventoryDashboardLocationValue(String location) {
    return 'Mahali: $location';
  }

  @override
  String inventoryDashboardExpiryDateValue(String date) {
    return 'Tarehe ya kuisha muda: $date';
  }

  @override
  String inventoryDashboardExpiredLoadError(String error) {
    return 'Hitilafu kupakia bidhaa zilizoisha muda: $error';
  }

  @override
  String inventoryDashboardNearExpiryLoadError(String error) {
    return 'Hitilafu kupakia bidhaa zinazokaribia kuisha muda: $error';
  }

  @override
  String get inventoryDashboardViewAll => 'Tazama zote';

  @override
  String get inventoryDashboardExpiredOn => 'Iliisha muda tarehe';

  @override
  String get inventoryDashboardAllExpiredItems => 'Bidhaa zote zilizoisha muda';

  @override
  String inventoryDashboardExpiredOnDate(String date) {
    return 'Iliisha muda: $date';
  }

  @override
  String get inventoryDashboardNearExpiryItems =>
      'Bidhaa zinazokaribia kuisha muda';

  @override
  String inventoryDashboardUnitsAtLocation(int count, String location) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vipimo $count - $location',
      one: 'Kipimo 1 - $location',
    );
    return '$_temp0';
  }

  @override
  String inventoryDashboardDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zimebaki siku $count',
      one: 'Imebaki siku 1',
    );
    return '$_temp0';
  }

  @override
  String get inventoryDashboardByCategory => 'Hisa kwa kundi';

  @override
  String get inventoryDashboardStockLevelsTrend =>
      'Mwenendo wa viwango vya hisa';

  @override
  String get inventoryDashboardRecentOrders => 'Oda za hivi karibuni';

  @override
  String inventoryDashboardOrderLine(String id, String date) {
    return 'Oda #$id - $date';
  }

  @override
  String get inventoryDashboardStatusDelivered => 'Imewasilishwa';

  @override
  String get inventoryDashboardStatusInTransit => 'Njiani';

  @override
  String get inventoryDashboardStatusProcessing => 'Inashughulikiwa';

  @override
  String get inventoryDashboardStatusCancelled => 'Imeghairiwa';

  @override
  String get inventoryDashboardRunningLow =>
      'Zinakaribia kuisha (utabiri wa siku 7)';

  @override
  String inventoryDashboardStockValue(String stock) {
    return 'Hisa: $stock';
  }

  @override
  String inventoryDashboardDailyUsage(String usage) {
    return 'Matumizi ya kila siku: $usage';
  }

  @override
  String get inventoryDashboardReplenish => 'Jaza tena';

  @override
  String get inventoryDashboardUnknownLocation => 'Haijulikani';

  @override
  String inventoryDashboardBranchFallback(String id) {
    return 'Tawi $id';
  }

  @override
  String get inventoryDashboardUncategorized => 'Bila kundi';

  @override
  String stockValueItemsNeedRestock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count zinahitaji kujazwa tena',
      one: 'Bidhaa 1 inahitaji kujazwa tena',
    );
    return '$_temp0';
  }

  @override
  String get stockValueViewAllArrow => 'Tazama zote →';

  @override
  String get stockValueStatusCritical => 'Hatari';

  @override
  String get stockValueStatusLow => 'Chini';

  @override
  String get stockValueStatusOk => 'Sawa';

  @override
  String get stockValueTitleMobile => 'Thamani za hisa';

  @override
  String get stockValueTitle => 'Thamani ya hisa';

  @override
  String stockValueProductsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count',
      one: 'Bidhaa 1',
    );
    return '$_temp0';
  }

  @override
  String get stockValueLoadError => 'Imeshindwa kupakia ripoti ya hisa.';

  @override
  String get stockValueTotalValueCaps => 'THAMANI YOTE';

  @override
  String stockValueRwfItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'RWF · bidhaa $count',
      one: 'RWF · bidhaa 1',
    );
    return '$_temp0';
  }

  @override
  String get stockValueNeedsRestockCaps => 'ZINAHITAJI KUJAZWA';

  @override
  String get stockValueCriticalOrLow => 'hatari au chini';

  @override
  String get stockValuePartialSync =>
      'Data huenda haijakamilika (usawazishaji wa sehemu).';

  @override
  String get stockValueLowCriticalCaps => 'BIDHAA CHINI NA HATARI';

  @override
  String get stockValueNoLowStock =>
      'Hakuna bidhaa zenye hisa ndogo kwenye data ya ndani.';

  @override
  String get stockValueByCategoryCaps => 'THAMANI KWA KUNDI';

  @override
  String get stockValueNoCategoryBreakdown =>
      'Hakuna mgawanyo wa makundi unaopatikana.';

  @override
  String get stockValueLoadingProducts => 'Inapakia bidhaa…';

  @override
  String get stockValueRestockHint =>
      'Tumia hisa au pokea bidhaa ili kujaza tena.';

  @override
  String get stockValueNoRowsToExport =>
      'Hakuna safu za kuhamisha kwa kichujio hiki.';

  @override
  String get stockValueCsvProduct => 'Bidhaa';

  @override
  String get stockValueCsvUnitPrice => 'Bei ya kipimo';

  @override
  String get stockValueCsvStock => 'Hisa';

  @override
  String get stockValueCsvLineValue => 'Thamani ya safu';

  @override
  String get stockValueCsvStatus => 'Hali';

  @override
  String stockValueCopiedCsvRows(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Safu $count zimenakiliwa kama CSV.',
      one: 'Safu 1 imenakiliwa kama CSV.',
    );
    return '$_temp0';
  }

  @override
  String stockValueDesktopSubtitle(int products, int categories, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      products,
      locale: localeName,
      other: 'Bidhaa $products',
      one: 'Bidhaa 1',
    );
    String _temp1 = intl.Intl.pluralLogic(
      categories,
      locale: localeName,
      other: 'makundi $categories',
      one: 'kundi 1',
    );
    return '$_temp0 katika $_temp1 · Imesasishwa leo saa $time';
  }

  @override
  String get stockValueSearchHint => 'Tafuta bidhaa au BCD...';

  @override
  String get stockValueExport => 'Hamisha';

  @override
  String get stockValueRestockOrder => '+ Oda ya kujaza hisa';

  @override
  String get stockValueTotalStockValue => 'Jumla ya thamani ya hisa';

  @override
  String get stockValueAtRetailSupply => 'Kwa bei ya rejareja/ununuzi';

  @override
  String get stockValueHealthyStock => 'Hisa nzuri';

  @override
  String get stockValueWellStocked => 'bidhaa zenye hisa ya kutosha';

  @override
  String stockValuePercentOfCatalogue(String percent) {
    return '$percent% ya katalogi';
  }

  @override
  String get stockValueCriticalLow => 'Hatari / chini';

  @override
  String get stockValueNeedRestocking => 'zinahitaji kujazwa';

  @override
  String get stockValueReviewAlerts => 'kagua tahadhari →';

  @override
  String get stockValueHighestValueItem => 'Bidhaa yenye thamani kubwa zaidi';

  @override
  String get stockValueNoValueOnHand => 'Hakuna thamani iliyopo';

  @override
  String stockValueTopItemDetail(String value, String units) {
    return '$value · vipimo $units';
  }

  @override
  String stockValuePercentOfTotal(String percent) {
    return '$percent% ya thamani yote';
  }

  @override
  String get stockValueAllProducts => 'Bidhaa zote';

  @override
  String get stockValueFilterAll => 'Zote';

  @override
  String get stockValueNoProductsMatch =>
      'Hakuna bidhaa zinazolingana na utafutaji au kichujio.';

  @override
  String get stockValueColProduct => 'BIDHAA';

  @override
  String get stockValueColCategory => 'KUNDI';

  @override
  String get stockValueColUnitPrice => 'BEI YA KIPIMO';

  @override
  String get stockValueColStock => 'HISA';

  @override
  String get stockValueColValue => 'THAMANI';

  @override
  String get stockValueColStatus => 'HALI';

  @override
  String get stockValueNoCategoryData => 'Hakuna data ya makundi.';

  @override
  String get stockValueByCategory => 'Thamani kwa kundi';

  @override
  String get stockValueRestockAlerts => 'Tahadhari za kujaza hisa';

  @override
  String get stockValueNoRestockAlerts => 'Hakuna tahadhari za kujaza hisa.';

  @override
  String stockValueUnitsMin(String units, String min) {
    return 'Vipimo $units, chini: $min';
  }

  @override
  String get stockValueSalesLoadError => 'Imeshindwa kupakia data ya mauzo.';

  @override
  String stockValueInStock(String count) {
    return '$count kwenye hisa';
  }

  @override
  String stockValuePerUnit(String price) {
    return '$price / kipimo';
  }

  @override
  String get stockValueStockValueCaps => 'THAMANI YA HISA';

  @override
  String stockValueUnitsTimesPrice(String units, String price) {
    return 'Vipimo $units × $price';
  }

  @override
  String get stockValueTotalSalesCaps => 'JUMLA YA MAUZO';

  @override
  String stockValueUnitsSoldPeriod(String units) {
    return 'Vipimo $units vimeuzwa (kipindi)';
  }

  @override
  String get stockValueProfitCaps => 'FAIDA';

  @override
  String stockValueMarginEst(String percent) {
    return 'Faida $percent% (makadirio)';
  }

  @override
  String get stockValueStockPerformance => 'Utendaji wa hisa';

  @override
  String stockValueRangeDays(int days) {
    return 'Siku $days';
  }

  @override
  String get stockValueNoSalesVolume => 'Hakuna mauzo katika kipindi hiki.';

  @override
  String get stockValueSalesVolume => 'Kiasi cha mauzo';

  @override
  String get stockValueDetailedMetrics => 'Vipimo vya kina';

  @override
  String get stockValueTurnoverCaps => 'MZUNGUKO WA HISA';

  @override
  String get stockValueTurnoverFooter =>
      'Ikilinganishwa na hisa iliyopo katika kipindi hiki.';

  @override
  String get stockValueGrossMarginCaps => 'FAIDA GHAFI';

  @override
  String get stockValueGrossMarginFooter =>
      'Imekadiriwa kutoka bei ya rejareja dhidi ya ununuzi kwa vipimo vilivyouzwa.';

  @override
  String get stockValueAvgTransactionCaps => 'WASTANI WA MUAMALA';

  @override
  String get stockValueAvgTransactionFooter =>
      'Mapato / miamala tofauti katika kipindi.';

  @override
  String get stockValueUnitsSoldCaps => 'VIPIMO VILIVYOUZWA';

  @override
  String get stockValueUnitsSoldFooter =>
      'Jumla ya vipimo katika kipindi kilichochaguliwa.';

  @override
  String get stockValueDeleteUnavailable =>
      'Kufuta bidhaa kwenye hisa hakupatikani hapa.';

  @override
  String get stockValueEditProduct => 'Hariri bidhaa';

  @override
  String get stockValueCopiedSummary => 'Muhtasari umenakiliwa.';

  @override
  String get tenantMgmtCommissionAgentMigrationRequired =>
      'Mawakala wa kamisheni pekee wanahitaji usasishaji wa hifadhidata. Tumia migration supabase/migrations/20260518120000_agent_allow_business_login.sql (mf. supabase db push), au washa \"Ruhusu kuingia kwenye biashara hii\" kisha ujaribu tena.';

  @override
  String get tenantMgmtNoBusinessSelected => 'Hakuna biashara iliyochaguliwa';

  @override
  String get tenantMgmtAgentBranchNameRequired =>
      'Tafadhali weka jina la tawi la wakala';

  @override
  String get tenantMgmtBranchNotInBusiness =>
      'Tawi lililochaguliwa si la biashara hii. Badilisha biashara au tawi kisha ujaribu tena.';

  @override
  String tenantMgmtUserLookupFailed(String details) {
    return 'Imeshindwa kupata mtumiaji kwa simu/barua pepe hii: $details';
  }

  @override
  String get tenantMgmtSavePermissionsSupabaseError =>
      'Imeshindwa kuhifadhi ruhusa (hitilafu ya Supabase).';

  @override
  String tenantMgmtSavePermissionsOrphanHint(String error) {
    return '$error Akaunti ya kuingia huenda tayari ipo bila kuunganishwa na biashara hii — fungua Usimamizi wa watumiaji na umwongeze mtumiaji huyu tena ili kukamilisha.';
  }

  @override
  String tenantMgmtSavePermissionsFailed(String error) {
    return 'Imeshindwa kuhifadhi ruhusa: $error';
  }

  @override
  String tenantMgmtPinGenerationFailed(String details) {
    return 'Imeshindwa kutengeneza PIN kwa mtumiaji mpya: $details';
  }

  @override
  String get tenantMgmtOrphanUser =>
      'Mtumiaji ameundwa lakini hajaunganishwa na biashara hii. Fungua tena Usimamizi wa watumiaji uhifadhi, au endesha migration ya supabase 20260519150000_repair_orphan_users_with_pins.sql.';

  @override
  String get tenantMgmtCreated => 'Mtumiaji ameundwa kwa mafanikio';

  @override
  String get tenantMgmtPermissionsSaved =>
      'Ruhusa zimehifadhiwa. Watumiaji walio mtandaoni husasishwa moja kwa moja; walio nje ya mtandao wataona mabadiliko watakapoingia tena.';

  @override
  String get tenantMgmtPermissionsSavedSelf =>
      'Ruhusa zimehifadhiwa. Menyu zako zimesasishwa.';

  @override
  String tenantMgmtUnexpectedError(String error) {
    return 'Hitilafu isiyotarajiwa imetokea: $error';
  }

  @override
  String get tenantMgmtAdminCannotDelete => 'Wasimamizi hawawezi kufutwa.';

  @override
  String get tenantMgmtDeleted => 'Mtumiaji amefutwa kwa mafanikio';

  @override
  String get tenantMgmtDeleteFailed =>
      'Hitilafu katika kufuta mtumiaji. Tafadhali jaribu tena.';

  @override
  String get tenantMgmtDeleteTitle => 'Futa mtumiaji';

  @override
  String get tenantMgmtDeleteConfirm =>
      'Una uhakika unataka kumfuta mtumiaji huyu?';

  @override
  String get tenantMgmtEnterPhoneOrEmail => 'Weka nambari au barua pepe sahihi';

  @override
  String get tenantMgmtPhoneNeedsCountryCode =>
      'Nambari ya simu inapaswa kuwa na msimbo wa nchi pamoja na alama +';

  @override
  String get tenantMgmtInvalidPhone => 'Nambari ya simu si sahihi';

  @override
  String get tenantMgmtInvalidPhoneFormat =>
      'Muundo wa nambari ya simu si sahihi';

  @override
  String get tenantMgmtModulePermissions => 'RUHUSA ZA MODULI';

  @override
  String get tenantMgmtColModule => 'MODULI';

  @override
  String get tenantMgmtColAccessLevel => 'KIWANGO CHA RUHUSA';

  @override
  String get tenantMgmtColActive => 'HAI';

  @override
  String get tenantMgmtFeatureInventory => 'Hisa';

  @override
  String get tenantMgmtFeatureSettings => 'Mipangilio';

  @override
  String get tenantMgmtFeatureReports => 'Ripoti';

  @override
  String get tenantMgmtFeatureTransactions => 'Miamala';

  @override
  String get tenantMgmtFeatureTickets => 'Tiketi';

  @override
  String get tenantMgmtFeatureOrders => 'Oda';

  @override
  String get tenantMgmtFeatureLeads => 'Wateja watarajiwa';

  @override
  String get tenantMgmtFeatureAddProduct => 'Ongeza bidhaa';

  @override
  String get tenantMgmtFeatureSales => 'Mauzo';

  @override
  String get tenantMgmtFeatureDriver => 'Dereva';

  @override
  String get tenantMgmtFeatureStock => 'Hisa';

  @override
  String get tenantMgmtFeatureShiftHistory => 'Historia ya zamu';

  @override
  String get tenantMgmtFeatureTicketReview => 'Ukaguzi wa tiketi';

  @override
  String get tenantMgmtFeatureStockHandover => 'Makabidhiano ya hisa';

  @override
  String get tenantMgmtFeatureHideStockQuantity => 'Ficha kiasi cha hisa';

  @override
  String get tenantMgmtAccessNone => 'Hakuna ruhusa';

  @override
  String get tenantMgmtAccessRead => 'Kusoma';

  @override
  String get tenantMgmtAccessWrite => 'Kuandika';

  @override
  String get tenantMgmtAccessAdmin => 'Msimamizi';

  @override
  String get tenantMgmtRoleUser => 'Mtumiaji';

  @override
  String get tenantMgmtRoleAdmin => 'Msimamizi';

  @override
  String get tenantMgmtRoleAgent => 'Wakala';

  @override
  String get tenantMgmtRoleCashier => 'Keshia';

  @override
  String get tenantMgmtRoleDriver => 'Dereva';

  @override
  String get tenantMgmtRoleViewer => 'Mtazamaji';

  @override
  String get tenantMgmtRoleReviewer => 'Mkaguzi';

  @override
  String get tenantMgmtRoleStockManager => 'Msimamizi wa hisa';

  @override
  String get tenantMgmtCurrentUsers => 'WATUMIAJI WA SASA';

  @override
  String get tenantMgmtSearchUsers => 'Tafuta watumiaji...';

  @override
  String get tenantMgmtNoUsers => 'Bado hakuna watumiaji.';

  @override
  String get tenantMgmtNoUsersMatch =>
      'Hakuna mtumiaji anayelingana na utafutaji wako.';

  @override
  String get tenantMgmtNoContact => 'Hakuna mawasiliano';

  @override
  String get tenantMgmtNoBranches => 'Hakuna matawi yanayopatikana';

  @override
  String get tenantMgmtUnnamedBranch => 'Tawi lisilo na jina';

  @override
  String get tenantMgmtSelectBranch => 'Chagua tawi';

  @override
  String tenantMgmtErrorValue(String error) {
    return 'Hitilafu: $error';
  }

  @override
  String get tenantMgmtUserTypeCaps => 'AINA YA MTUMIAJI';

  @override
  String get tenantMgmtEditUser => 'Hariri mtumiaji';

  @override
  String get tenantMgmtAddNewUser => 'Ongeza mtumiaji mpya';

  @override
  String get tenantMgmtFullNameCaps => 'JINA KAMILI';

  @override
  String get tenantMgmtEnterName => 'Tafadhali weka jina';

  @override
  String get tenantMgmtPhoneEmailCaps => 'SIMU / BARUA PEPE';

  @override
  String get tenantMgmtAgentBranchNameCaps => 'JINA LA TAWI (WAKALA)';

  @override
  String get tenantMgmtEnterBranchName => 'Tafadhali weka jina la tawi';

  @override
  String get tenantMgmtBranchNameTooShort => 'Jina la tawi ni fupi mno';

  @override
  String get tenantMgmtUpdateUser => 'Sasisha mtumiaji';

  @override
  String get tenantMgmtAddUser => '+ Ongeza mtumiaji';

  @override
  String get tenantMgmtAllowBusinessLogin =>
      'Ruhusu kuingia kwenye biashara hii';

  @override
  String get tenantMgmtAllowBusinessLoginHint =>
      'Imezimwa kwa chaguo-msingi: wakala hupokea PIN lakini huona kamisheni yake tu kwa biashara hii. Washa ili kumpa ufikiaji kamili kulingana na ruhusa za moduli hapa chini.';

  @override
  String get tenantMgmtCommissionOnlyHint =>
      'Ruhusa za moduli hazitumiki katika hali ya kamisheni pekee. Wakala ataingia kwa PIN yake na kuona kamisheni yake tu kwa biashara hii.';

  @override
  String stockValueUnitsValue(String units) {
    return 'Vipimo $units';
  }

  @override
  String stockValueMinValue(String min) {
    return 'chini: $min';
  }

  @override
  String stockValueItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count',
      one: 'Bidhaa 1',
    );
    return '$_temp0';
  }

  @override
  String get dailyReportRecipientsInvalidEmail =>
      'Weka anwani sahihi ya barua pepe.';

  @override
  String get dailyReportRecipientsNoBusiness =>
      'Hakuna biashara iliyochaguliwa.';

  @override
  String get dailyReportRecipientsNotSetUpRunMigration =>
      'Wapokeaji wa ripoti ya kila siku bado hawajawekwa. Muombe msimamizi wako aendeshe migration ya hivi punde ya Supabase (business_report_recipients).';

  @override
  String get dailyReportRecipientsDuplicate =>
      'Barua pepe hiyo tayari iko kwenye orodha ya ripoti ya kila siku.';

  @override
  String get dailyReportRecipientsCouldNotAdd =>
      'Imeshindwa kuongeza mpokeaji.';

  @override
  String get dailyReportRecipientsNotSetUp =>
      'Wapokeaji wa ripoti ya kila siku bado hawajawekwa.';

  @override
  String get dailyReportRecipientsCouldNotRemove =>
      'Imeshindwa kumwondoa mpokeaji.';

  @override
  String dailyReportRecipientsLoadFailed(String error) {
    return 'Imeshindwa kupakia wapokeaji wa ripoti ya kila siku: $error';
  }

  @override
  String get dailyReportRecipientsEnterEmail => 'Weka anwani ya barua pepe.';

  @override
  String get dailyReportRecipientsAdded => 'Mpokeaji ameongezwa.';

  @override
  String dailyReportRecipientsAddFailed(String error) {
    return 'Imeshindwa kuongeza mpokeaji: $error';
  }

  @override
  String get dailyReportRecipientsRemoved => 'Mpokeaji ameondolewa.';

  @override
  String dailyReportRecipientsRemoveFailed(String error) {
    return 'Imeshindwa kumwondoa mpokeaji: $error';
  }

  @override
  String get dailyReportRecipientsEmailHint => 'mf. accountant@example.com';

  @override
  String get dailyReportRecipientsLabelHint => 'Lebo (si lazima)';

  @override
  String get dailyReportRecipientsSave => 'Hifadhi mpokeaji';

  @override
  String get dailyReportRecipientsAddTitle => 'Ongeza mpokeaji';

  @override
  String get dailyReportRecipientsTitle => 'Wapokeaji wa ripoti ya kila siku';

  @override
  String get dailyReportRecipientsSubtitle =>
      'Barua pepe ya mmiliki iliyo hapo juu hupokea ripoti ya kina ya miamala ya kila siku. Ongeza anwani zaidi ili zipokee ripoti hiyo hiyo.';

  @override
  String get dailyReportRecipientsEmpty => 'Bado hakuna wapokeaji wa ziada.';

  @override
  String transfersReportPdfExportFailed(String error) {
    return 'Kuhamisha PDF kumeshindwa: $error';
  }

  @override
  String get transfersReportAllDates => 'Tarehe zote';

  @override
  String transfersReportLoadFailed(String error) {
    return 'Imeshindwa kupakia uhamisho: $error';
  }

  @override
  String get transfersReportSelectDestination => 'Chagua mahali pa kupelekwa';

  @override
  String get transfersReportSelectDestinationBody =>
      'Chagua tawi la kupokea ili kupakia uhamisho wa eneo hilo.';

  @override
  String transfersReportCountTo(int count, String branch) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uhamisho $count',
      one: 'Uhamisho 1',
    );
    return '$_temp0 kwenda $branch';
  }

  @override
  String get transfersReportNoTransfers => 'Hakuna uhamisho';

  @override
  String get transfersReportNoTransfersBody =>
      'Hakuna uhamisho unaolingana na kichujio hiki katika kipindi kilichochaguliwa.';

  @override
  String get transfersReportTitle => 'Ripoti ya uhamisho';

  @override
  String get transfersReportSubtitle =>
      'Uhamisho wa bidhaa uliopokelewa na tawi husika';

  @override
  String get transfersReportExportPdf => 'Hamisha PDF';

  @override
  String get transfersReportBranchesLoadFailed => 'Imeshindwa kupakia matawi';

  @override
  String get transfersReportToBranch => 'Tawi la kupokea';

  @override
  String get transfersReportFilterAll => 'Zote';

  @override
  String get transfersReportStatusPending => 'Inasubiri';

  @override
  String get transfersReportStatusProcessing => 'Inashughulikiwa';

  @override
  String get transfersReportStatusPartiallyApproved =>
      'Imeidhinishwa kwa sehemu';

  @override
  String get transfersReportStatusRejected => 'Imekataliwa';

  @override
  String get transfersReportStatusFulfilled => 'Imekamilishwa';

  @override
  String get transfersReportStatusVoided => 'Imebatilishwa';

  @override
  String transfersReportItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count',
      one: 'Bidhaa 1',
    );
    return '$_temp0';
  }

  @override
  String get transfersReportNoLineItems => 'Hakuna bidhaa zilizojumuishwa';

  @override
  String get transfersReportStatusAndDelivery => 'Hali na uwasilishaji';

  @override
  String get transfersReportStatus => 'Hali';

  @override
  String get transfersReportReceivedOn => 'Imepokelewa tarehe';

  @override
  String get transfersReportViewPdf => 'Tazama PDF';

  @override
  String get transfersReportDownload => 'Pakua';

  @override
  String get transfersReportFromLabel => 'Kutoka:';

  @override
  String get transfersReportToLabel => 'Kwenda:';

  @override
  String transfersReportQty(String qty) {
    return 'Kiasi: $qty';
  }

  @override
  String get transfersReportPdfStockTransferSubject => 'Uhamisho wa bidhaa';

  @override
  String get transfersReportPdfSaveDialog => 'Hifadhi PDF ya uhamisho';

  @override
  String transfersReportPdfTitleTo(String branch) {
    return 'Uhamisho wa bidhaa kwenda $branch';
  }

  @override
  String transfersReportPdfTransferCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uhamisho $count',
      one: 'Uhamisho 1',
    );
    return '$_temp0';
  }

  @override
  String transfersReportPdfUnitCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vipimo $count',
      one: 'Kipimo 1',
    );
    return '$_temp0';
  }

  @override
  String get transfersReportPdfNoTransfers =>
      'Hakuna uhamisho katika kipindi hiki.';

  @override
  String get transfersReportColDate => 'Tarehe';

  @override
  String get transfersReportColFrom => 'Kutoka';

  @override
  String get transfersReportColProduct => 'Bidhaa';

  @override
  String get transfersReportColQty => 'Kiasi';

  @override
  String get transfersReportColRequested => 'Iliyoombwa';

  @override
  String transfersReportPdfTransferFrom(String id, String branch) {
    return 'Uhamisho $id · kutoka $branch';
  }

  @override
  String transfersReportPdfFooter(String date, String page, String pages) {
    return 'Imetengenezwa $date · ukurasa $page/$pages';
  }

  @override
  String transfersReportPdfSingleTitle(String id) {
    return 'Uhamisho wa bidhaa $id';
  }

  @override
  String transfersReportPdfApprovedBy(String name) {
    return 'Imeidhinishwa na: $name';
  }

  @override
  String get dailyReportFilesRangeAllTime => 'Wakati wote';

  @override
  String get dailyReportFilesRangeLast7Days => 'Siku 7 zilizopita';

  @override
  String get dailyReportFilesRangeLast30Days => 'Siku 30 zilizopita';

  @override
  String get dailyReportFilesRangeLast90Days => 'Siku 90 zilizopita';

  @override
  String get dailyReportFilesRangeThisMonth => 'Mwezi huu';

  @override
  String get dailyReportFilesRangeLastMonth => 'Mwezi uliopita';

  @override
  String get dailyReportFilesSortNewest => 'Mpya kwanza';

  @override
  String get dailyReportFilesSortOldest => 'Za zamani kwanza';

  @override
  String get dailyReportFilesSortNameAsc => 'Jina A–Z';

  @override
  String get dailyReportFilesSortNameDesc => 'Jina Z–A';

  @override
  String get dailyReportFilesTypeAll => 'Zote';

  @override
  String get dailyReportFilesTypeTransactions => 'Miamala';

  @override
  String get dailyReportFilesTypeMerged => 'Zilizounganishwa';

  @override
  String get dailyReportFilesShareUnsupportedWeb =>
      'Kushiriki hakutumiki kwenye kivinjari.';

  @override
  String get dailyReportFilesShareSubjectOne => 'Ripoti ya kila siku';

  @override
  String get dailyReportFilesNoActiveBranch => 'Hakuna tawi linalotumika.';

  @override
  String get dailyReportFilesNoStorageKey =>
      'Faili hii bado haina ufunguo wa hifadhi.';

  @override
  String dailyReportFilesSaved(String name) {
    return '$name imehifadhiwa';
  }

  @override
  String get dailyReportFilesReportFallback => 'ripoti';

  @override
  String dailyReportFilesDownloaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faili $count zimepakuliwa',
      one: 'Faili 1 imepakuliwa',
    );
    return '$_temp0';
  }

  @override
  String dailyReportFilesShared(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faili $count zimeshirikiwa',
      one: 'Faili 1 imeshirikiwa',
    );
    return '$_temp0';
  }

  @override
  String get dailyReportFilesAlreadyArchived =>
      'Faili zilizochaguliwa tayari zimehifadhiwa kwenye kumbukumbu.';

  @override
  String get dailyReportFilesSelectedNoStorageKey =>
      'Faili zilizochaguliwa bado hazina ufunguo wa hifadhi.';

  @override
  String get dailyReportFilesNoneArchived =>
      'Hakuna faili iliyoweza kuhifadhiwa kwenye kumbukumbu.';

  @override
  String dailyReportFilesArchived(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faili $count zimehifadhiwa kwenye kumbukumbu',
      one: 'Faili 1 imehifadhiwa kwenye kumbukumbu',
    );
    return '$_temp0';
  }

  @override
  String dailyReportFilesArchivedSkipped(String summary, String skipped) {
    return '$summary ($skipped zimerukwa — bado hazina ufunguo wa hifadhi)';
  }

  @override
  String get dailyReportFilesMergeNeedsKeys =>
      'Kila ripoti iliyochaguliwa lazima iwe na ufunguo wa hifadhi kabla ya kuunganisha.';

  @override
  String dailyReportFilesMerged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Ripoti $count zimeunganishwa. Kitabu kipya kimeongezwa kwenye orodha.',
      one: 'Ripoti 1 imeunganishwa. Kitabu kipya kimeongezwa kwenye orodha.',
    );
    return '$_temp0';
  }

  @override
  String get dailyReportFilesCurrentBranch => 'Tawi la sasa';

  @override
  String get dailyReportFilesNoBranch => 'Hakuna tawi';

  @override
  String get dailyReportFilesNoBranchSelectedBody =>
      'Chagua tawi ili kuona faili za Excel za kila siku.';

  @override
  String get dailyReportFilesLoadFailed => 'Imeshindwa kupakia ripoti';

  @override
  String get dailyReportFilesCheckConnection =>
      'Angalia muunganisho wako kisha ujaribu tena.';

  @override
  String get dailyReportFilesEmptyTitle => 'Bado hakuna ripoti za kila siku';

  @override
  String get dailyReportFilesNoMatches => 'Hakuna zinazolingana';

  @override
  String get dailyReportFilesEmptyBody =>
      'Ripoti za tawi hili zikitengenezwa, zitaonekana hapa ili uzipakue.';

  @override
  String get dailyReportFilesNoMatchesFiltered =>
      'Jaribu utafutaji mwingine, kipindi kingine au aina nyingine.';

  @override
  String get dailyReportFilesNoMatchesSearch =>
      'Jaribu jina lingine la ripoti, tarehe au ID nyingine.';

  @override
  String get dailyReportFilesClearFilters => 'Futa vichujio';

  @override
  String dailyReportFilesSubtitle(String branch) {
    return 'Faili za Excel zilizotengenezwa kwa $branch. Chagua faili kadhaa ili uzipakue pamoja.';
  }

  @override
  String get dailyReportFilesKpiFiles => 'Faili';

  @override
  String get dailyReportFilesKpiNoneYet => 'bado hakuna';

  @override
  String get dailyReportFilesKpiAvailable => 'zinapatikana';

  @override
  String get dailyReportFilesKpiReportDays => 'Siku za ripoti';

  @override
  String dailyReportFilesKpiDaysGrouped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'siku zilizopangwa pamoja',
      one: 'siku iliyopangwa pamoja',
    );
    return '$_temp0';
  }

  @override
  String get dailyReportFilesKpiReadyFiles => 'Faili zilizo tayari';

  @override
  String get dailyReportFilesKpiWithStorageKeys => 'zenye ufunguo wa hifadhi';

  @override
  String get dailyReportFilesKpiLastGenerated => 'Iliyotengenezwa mwisho';

  @override
  String get dailyReportFilesKpiNoExports => 'Hakuna faili zilizotolewa';

  @override
  String get dailyReportFilesToday => 'Leo';

  @override
  String get dailyReportFilesYesterday => 'Jana';

  @override
  String dailyReportFilesSelectedCount(String count) {
    return '$count zimechaguliwa';
  }

  @override
  String dailyReportFilesFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faili $count',
      one: 'Faili 1',
    );
    return '$_temp0';
  }

  @override
  String get dailyReportFilesAutoSync => 'Husawazishwa kila dakika 5';

  @override
  String get dailyReportFilesSearchHint =>
      'Tafuta kwa jina la ripoti, tarehe au ID...';

  @override
  String get dailyReportFilesFocusSearch => 'Nenda kwenye utafutaji (⌘K)';

  @override
  String get dailyReportFilesTypeLabel => 'Aina:';

  @override
  String get dailyReportFilesSortLabel => 'Panga:';

  @override
  String get dailyReportFilesGroupByDay => 'Panga kwa siku';

  @override
  String get dailyReportFilesFlatList => 'Orodha ya kawaida';

  @override
  String get dailyReportFilesUnknownDate => 'Tarehe haijulikani';

  @override
  String get dailyReportFilesNoReportDay => 'Hakuna siku ya ripoti';

  @override
  String get dailyReportFilesPreview => 'Hakiki';

  @override
  String get dailyReportFilesDownload => 'Pakua';

  @override
  String get dailyReportFilesMoreActions => 'Vitendo zaidi';

  @override
  String get dailyReportFilesShare => 'Shiriki';

  @override
  String get dailyReportFilesArchive => 'Hifadhi kumbukumbu';

  @override
  String get dailyReportFilesNameDailyTransactions => 'Miamala ya kila siku';

  @override
  String get dailyReportFilesNameSalesSummary => 'Muhtasari wa mauzo';

  @override
  String get dailyReportFilesNamePaymentsBreakdown => 'Mchanganuo wa malipo';

  @override
  String get dailyReportFilesNameStockMovement => 'Mwenendo wa bidhaa';

  @override
  String dailyReportFilesMergedRange(String start, String end) {
    return '$start - $end (imeunganishwa)';
  }

  @override
  String dailyReportFilesMergedDay(String day) {
    return '$day (imeunganishwa)';
  }

  @override
  String get dailyReportFilesMergedWorkbook => 'Kitabu kilichounganishwa';

  @override
  String get dailyReportFilesNew => 'Mpya';

  @override
  String get dailyReportFilesReady => 'Tayari';

  @override
  String get dailyReportFilesPending => 'Inasubiri';

  @override
  String get dailyReportFilesReportFile => 'Faili ya ripoti';

  @override
  String get dailyReportFilesClosePreview => 'Funga hakiki';

  @override
  String get dailyReportFilesPreviewLoadFailed =>
      'Imeshindwa kupakia hakiki ya kitabu.';

  @override
  String dailyReportFilesFirstRows(String shown, String total) {
    return 'Safu $shown za kwanza kati ya $total';
  }

  @override
  String get dailyReportFilesRawFilename => 'Jina halisi la faili';

  @override
  String get dailyReportFilesStatFileId => 'ID ya faili';

  @override
  String get dailyReportFilesStatRows => 'Safu';

  @override
  String get dailyReportFilesStatSize => 'Ukubwa';

  @override
  String get dailyReportFilesStatStatus => 'Hali';

  @override
  String get dailyReportFilesStatSheet => 'Laha';

  @override
  String get dailyReportFilesStatFormat => 'Muundo';

  @override
  String get dailyReportFilesColTime => 'Saa';

  @override
  String get dailyReportFilesColReceipt => 'Na. ya risiti';

  @override
  String get dailyReportFilesColCashier => 'Keshia';

  @override
  String get dailyReportFilesColTax => 'Kodi';

  @override
  String get dailyReportFilesColTotal => 'Jumla';

  @override
  String get dailyReportFilesMerge => 'Unganisha';

  @override
  String get dailyReportFilesMergeIntoOne => 'Unganisha kuwa kitabu kimoja';

  @override
  String dailyReportFilesFilesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'faili zimechaguliwa',
      one: 'faili imechaguliwa',
    );
    return '$_temp0';
  }

  @override
  String get importPurchaseStatusPending => 'Inasubiri';

  @override
  String get importPurchaseStatusRejected => 'Imekataliwa';

  @override
  String get importPurchaseStatusProcessing => 'Inashughulikiwa';

  @override
  String get importPurchaseStatusWaiting => 'Inasubiri';

  @override
  String get importPurchaseStatusDeclined => 'Imekataliwa';

  @override
  String get importPurchaseFilterAll => 'Zote';

  @override
  String get importPurchaseFilterByStatus => 'Chuja kwa hali';

  @override
  String get importPurchaseItemCodeCopied => 'Msimbo wa bidhaa umenakiliwa';

  @override
  String get importPurchaseMapLineTitle => 'Unganisha mstari wa ununuzi';

  @override
  String get importPurchaseRraItemCode => 'Msimbo wa bidhaa wa RRA';

  @override
  String get importPurchaseCreateNewVariant => 'Unda aina mpya';

  @override
  String get importPurchaseCreateNewVariantDesc =>
      'Inaunda bidhaa kwenye katalogi sasa na kuunganisha mstari huu wa ununuzi nayo.';

  @override
  String get importPurchaseMapExistingVariant => 'Unganisha na aina iliyopo';

  @override
  String get importPurchaseMapExistingVariantDesc =>
      'Inaongeza kiasi hiki kwa aina uliyo nayo tayari kwenye hisa.';

  @override
  String get importPurchaseExistingVariant => 'Aina iliyopo';

  @override
  String get importPurchaseSelectVariantEllipsis => 'Chagua aina…';

  @override
  String get importPurchaseSupplyPrice => 'Bei ya kununua';

  @override
  String get importPurchaseRetailPrice => 'Bei ya kuuza';

  @override
  String get importPurchaseCreating => 'Inaunda…';

  @override
  String get importPurchaseSaveMapping => 'Hifadhi uunganisho';

  @override
  String get importPurchaseNoPurchaseInvoices => 'Hakuna ankara za ununuzi';

  @override
  String get importPurchaseNoPurchaseInvoicesHint =>
      'Hakuna kinacholingana na kichujio hiki. Rekodi ununuzi au badilisha kichujio.';

  @override
  String importPurchasePagerRange(String range, String total) {
    return '$range kati ya $total';
  }

  @override
  String importPurchaseSupplierHeader(String name, String count) {
    return 'Msambazaji: $name ($count)';
  }

  @override
  String importPurchaseInvoiceHeader(String number) {
    return 'Ankara: $number';
  }

  @override
  String get importPurchaseProcessing => 'Inashughulikiwa…';

  @override
  String get importPurchaseAcceptAll => 'Kubali zote';

  @override
  String get importPurchaseDeclineAll => 'Kataa zote';

  @override
  String get importPurchaseColNo => 'Na.';

  @override
  String get importPurchaseColQty => 'Idadi';

  @override
  String get importPurchaseColSupply => 'Kununua';

  @override
  String get importPurchaseColRetail => 'Kuuza';

  @override
  String get importPurchaseColMapping => 'Uunganisho';

  @override
  String importPurchaseMappedTapToChange(String label) {
    return 'Imeunganishwa · $label — gusa kubadilisha';
  }

  @override
  String get importPurchaseTapToMapLine => 'Gusa kuunganisha mstari huu';

  @override
  String get importPurchaseRetryFailedJob => 'Jaribu tena kazi iliyoshindwa';

  @override
  String get importPurchaseNoImportedItems => 'Hakuna bidhaa zilizoagizwa';

  @override
  String get importPurchaseNoImportedItemsHint =>
      'Hakuna kinacholingana na kichujio hiki. Badilisha kichujio au agiza kundi jipya.';

  @override
  String get importPurchaseSelectRowToEdit =>
      'Chagua mstari hapa chini kuhariri jina, bei na aina yake';

  @override
  String get importPurchaseEditing => 'Inahariri';

  @override
  String get importPurchaseItemName => 'Jina la bidhaa';

  @override
  String get importPurchaseEnterName => 'Weka jina';

  @override
  String get importPurchaseEnterSupplyPrice => 'Weka bei ya kununua';

  @override
  String get importPurchaseEnterRetailPrice => 'Weka bei ya kuuza';

  @override
  String get importPurchaseVariant => 'Aina';

  @override
  String get importPurchaseSaveChanges => 'Hifadhi mabadiliko';

  @override
  String get importPurchaseHsCode => 'Msimbo wa HS';

  @override
  String get importPurchaseColStatus => 'Hali';

  @override
  String get importPurchaseSupplier => 'Msambazaji';

  @override
  String get importPurchaseDate => 'Tarehe';

  @override
  String importPurchaseVariantTag(String name) {
    return 'Aina · $name';
  }

  @override
  String get importPurchaseNoVariantAssigned => 'Hakuna aina iliyowekwa';

  @override
  String get importPurchaseEditItem => 'Hariri bidhaa';

  @override
  String get importPurchaseMapVariant => 'Unganisha aina';

  @override
  String get importPurchaseNewVariant => 'Aina mpya';

  @override
  String get importPurchaseTabImport => 'Uagizaji';

  @override
  String get importPurchasePurchase => 'Ununuzi';

  @override
  String get importPurchaseImports => 'Uagizaji';

  @override
  String get importPurchaseSelectVariant => 'Chagua aina';

  @override
  String get importPurchaseSearchVariants => 'Tafuta aina…';

  @override
  String get importPurchaseFailedToLoadVariants => 'Imeshindwa kupakia aina';

  @override
  String get importPurchaseNameRequired => 'Jina linahitajika';

  @override
  String get importPurchaseSetBothPrices =>
      'Tafadhali weka bei ya kuuza na bei ya kununua';

  @override
  String get importPurchaseSelectExistingVariant => 'Chagua aina iliyopo';

  @override
  String get importPurchaseMappedToExisting => 'Imeunganishwa na aina iliyopo';

  @override
  String importPurchaseCreatedVariantWithCode(String code) {
    return 'Aina imeundwa · $code';
  }

  @override
  String get importPurchaseCreatedVariant => 'Aina imeundwa';

  @override
  String importPurchaseCouldNotCreateVariant(String error) {
    return 'Imeshindwa kuunda aina: $error';
  }

  @override
  String importPurchaseLinesNeedMapping(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mistari $count bado inahitaji kuunganishwa',
      one: 'Mstari 1 bado unahitaji kuunganishwa',
    );
    return '$_temp0';
  }

  @override
  String get importPurchasePurchaseAccepted => 'Ununuzi umekubaliwa';

  @override
  String get importPurchasePurchaseDeclined => 'Ununuzi umekataliwa';

  @override
  String importPurchaseCouldNotAccept(String error) {
    return 'Imeshindwa kukubali ununuzi: $error';
  }

  @override
  String importPurchaseCouldNotDecline(String error) {
    return 'Imeshindwa kukataa ununuzi: $error';
  }

  @override
  String importPurchaseApprovedItem(String name) {
    return '\"$name\" imeidhinishwa';
  }

  @override
  String importPurchaseRejectedItem(String name) {
    return '\"$name\" imekataliwa';
  }

  @override
  String get importPurchaseRetrySucceeded => 'Kujaribu tena kumefaulu';

  @override
  String importPurchaseCouldNotUpdateItem(String name, String error) {
    return 'Imeshindwa kusasisha \"$name\": $error';
  }

  @override
  String importPurchaseItemsNeedPrices(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Bidhaa $count zinahitaji bei ya kununua na ya kuuza, au kuunganishwa na mojawapo ya bidhaa zako',
      one:
          'Bidhaa 1 inahitaji bei ya kununua na ya kuuza, au kuunganishwa na mojawapo ya bidhaa zako',
    );
    return '$_temp0';
  }

  @override
  String importPurchaseApproveItemsTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Idhinisha bidhaa $count?',
      one: 'Idhinisha bidhaa 1?',
    );
    return '$_temp0';
  }

  @override
  String get importPurchaseApproveAllBody =>
      'Kiasi chake kinaongezwa kwenye hisa yako na kuripotiwa kwa RRA.';

  @override
  String get importPurchaseApproveAll => 'Idhinisha zote';

  @override
  String importPurchaseApprovedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count zimeidhinishwa',
      one: 'Bidhaa 1 imeidhinishwa',
    );
    return '$_temp0';
  }

  @override
  String importPurchaseCouldNotApproveAll(String error) {
    return 'Imeshindwa kuidhinisha zote: $error';
  }

  @override
  String get importPurchaseCouldNotLoadImports => 'Imeshindwa kupakia uagizaji';

  @override
  String get importPurchaseNoImportsWaiting => 'Hakuna uagizaji unaosubiri';

  @override
  String get importPurchaseNoImportsHere => 'Hakuna uagizaji hapa';

  @override
  String get importPurchaseFetchCustomsHint =>
      'Gusa ⟳ kuleta matamko yako ya forodha kutoka RRA.';

  @override
  String importPurchaseApproveAllWaiting(int count) {
    return 'Idhinisha zote $count zinazosubiri';
  }

  @override
  String importPurchaseFromOrigin(String origin) {
    return 'kutoka $origin';
  }

  @override
  String importPurchaseCostSellsAt(String cost, String price) {
    return 'Gharama $cost · inauzwa $price';
  }

  @override
  String get importPurchaseSetPricesBeforeApproving =>
      'Weka bei kabla ya kuidhinisha';

  @override
  String get importPurchaseWorking => 'Inafanya kazi…';

  @override
  String get importPurchaseFailedTapToRetry =>
      'Imeshindwa · gusa kujaribu tena';

  @override
  String importPurchaseAddsTo(String name) {
    return 'Inaongezwa kwa $name';
  }

  @override
  String get importPurchaseNewProduct => 'Bidhaa mpya';

  @override
  String get importPurchaseEnterBothPrices =>
      'Weka bei zote mbili, au unganisha bidhaa unayouza';

  @override
  String get importPurchaseOrigin => 'Asili';

  @override
  String get importPurchaseDeclaration => 'Tamko';

  @override
  String get importPurchaseNameInYourShop => 'Jina dukani kwako';

  @override
  String get importPurchaseCreateAsNewProduct => 'Unda kama bidhaa mpya';

  @override
  String get importPurchaseLinkProductHint =>
      'Au gusa kuongeza hisa hii kwa bidhaa unayouza';

  @override
  String get importPurchaseStockAddedToProduct =>
      'Hisa itaongezwa kwa bidhaa hii';

  @override
  String get importPurchaseUnlink => 'Tenganisha';

  @override
  String get importPurchaseRetryWithPrevious =>
      'Jaribu tena kwa thamani za awali';

  @override
  String get importPurchaseReject => 'Kataa';

  @override
  String get importPurchaseApprove => 'Idhinisha';

  @override
  String get importPurchaseSaveForLater => 'Hifadhi kwa baadaye';

  @override
  String get importPurchaseSearchYourProducts => 'Tafuta bidhaa zako';

  @override
  String get importPurchaseTypeProductName => 'Andika jina la bidhaa';

  @override
  String get importPurchaseNoProductMatches => 'Hakuna bidhaa inayolingana';

  @override
  String importPurchaseSellsAt(String price) {
    return 'Inauzwa $price';
  }

  @override
  String importPurchaseSyncFailed(String error) {
    return 'Usawazishaji umeshindwa: $error';
  }

  @override
  String get importPurchaseRecordPurchase => 'Rekodi ununuzi';

  @override
  String get importPurchaseRecordPurchaseSubtitle =>
      'Rekodi ankara ya msambazaji na bidhaa zake';

  @override
  String get importPurchaseFetchingInvoices => 'Inaleta ankara kutoka RRA…';

  @override
  String importPurchaseSyncedWithRra(String time) {
    return 'Imesawazishwa na RRA $time';
  }

  @override
  String get importPurchasePullToRefreshHint =>
      'Vuta chini kuonyesha upya · gusa ⟳ kuleta kutoka RRA';

  @override
  String get importPurchaseFetchFromRra => 'Leta kutoka RRA';

  @override
  String get importPurchaseCouldNotLoadPurchases =>
      'Imeshindwa kupakia manunuzi';

  @override
  String get importPurchaseNothingWaiting =>
      'Hakuna kinachosubiri kuidhinishwa';

  @override
  String get importPurchaseNoPurchasesHere => 'Hakuna manunuzi hapa';

  @override
  String get importPurchaseNoPurchasesHint =>
      'Rekodi ununuzi, au leta ankara za wasambazaji wako kutoka RRA.';

  @override
  String get importPurchaseRecorded => 'Imerekodiwa';

  @override
  String get importPurchaseFromRra => 'Kutoka RRA';

  @override
  String get importPurchaseOnCredit => 'Kwa mkopo';

  @override
  String importPurchaseItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count',
      one: 'Bidhaa 1',
    );
    return '$_temp0';
  }

  @override
  String importPurchaseCardMeta(String number, String time, String items) {
    return 'Ankara $number · $time · $items';
  }

  @override
  String get importPurchaseDeclineTitle => 'Kataa ununuzi huu?';

  @override
  String importPurchaseDeclineBody(String number, String supplier) {
    return 'Ankara $number kutoka $supplier haitaongezwa kwenye hisa yako.';
  }

  @override
  String get importPurchaseDecline => 'Kataa';

  @override
  String get importPurchaseNotFound => 'Ununuzi haupatikani';

  @override
  String get importPurchaseNotFoundHint => 'Huenda umehamia hali nyingine.';

  @override
  String importPurchaseInclVat(String amount) {
    return 'pamoja na VAT $amount';
  }

  @override
  String get importPurchasePaidWith => 'Imelipwa kwa';

  @override
  String get importPurchaseSupplierTin => 'TIN ya msambazaji';

  @override
  String importPurchaseItemsHeader(String count) {
    return 'Bidhaa · $count';
  }

  @override
  String get importPurchaseMatchItemsHint =>
      'Unganisha kila bidhaa ya msambazaji na mojawapo ya zako kabla ya kukubali, ili hisa iende kwenye bidhaa sahihi.';

  @override
  String importPurchaseAcceptWithMatch(int count) {
    return 'Kubali ($count za kuunganisha)';
  }

  @override
  String get importPurchaseAccept => 'Kubali';

  @override
  String get importPurchaseMatchedChange => 'Imeunganishwa · badilisha';

  @override
  String get importPurchaseMatchToMyItem => 'Unganisha na bidhaa yangu';

  @override
  String bulkProductProductCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count',
      one: 'Bidhaa 1',
    );
    return '$_temp0';
  }

  @override
  String get bulkProductRegisterViaServer => 'Sajili kupitia seva (RRA kwanza)';

  @override
  String get bulkProductRegisterViaServerHint =>
      'Katalogi inaundwa kwenye Ditto tu baada ya RRA kufaulu. Zima ili kutumia mtiririko wa awali kwenye kifaa.';

  @override
  String get bulkProductSaveAll => 'Hifadhi zote';

  @override
  String get bulkProductLoadingAllRows =>
      'Inapakia mistari yote ya lahajedwali (kuhifadhi kumezimwa hadi ikamilike)…';

  @override
  String get bulkProductParsingSpreadsheet => 'Inachambua lahajedwali…';

  @override
  String bulkProductProgressCount(
    String percent,
    String current,
    String total,
  ) {
    return '$percent · $current kati ya $total';
  }

  @override
  String get bulkProductSaving => 'Inahifadhi…';

  @override
  String bulkProductRowsMissingName(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mistari $count haina jina',
      one: 'Mstari 1 hauna jina',
    );
    return '$_temp0';
  }

  @override
  String bulkProductDuplicateBarcodes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Misimbopau $count inayojirudia',
      one: 'Msimbopau 1 unaojirudia',
    );
    return '$_temp0';
  }

  @override
  String get bulkProductSavingProducts => 'Inahifadhi bidhaa';

  @override
  String bulkProductCurrentOfTotal(String current, String total) {
    return '$current kati ya $total';
  }

  @override
  String get bulkProductPleaseWait => 'Tafadhali subiri…';

  @override
  String get bulkProductHideSaveContinues => 'Ficha · kuhifadhi kunaendelea';

  @override
  String get bulkProductProgressStaysOnBar =>
      'Maendeleo yanabaki kwenye upau ulio juu ya jedwali.';

  @override
  String bulkProductLargeImportBanner(String count) {
    return 'Uingizaji mkubwa: unaweza kuhariri bei na chaguo kwa kila ukurasa (bidhaa $count). Tumia mishale chini ya jedwali kupakia mistari 20 inayofuata au iliyotangulia.';
  }

  @override
  String get bulkProductColBarcode => 'Msimbopau';

  @override
  String get bulkProductColSupplyPrice => 'Bei ya kununua';

  @override
  String get bulkProductColItemClass => 'Daraja la bidhaa';

  @override
  String get bulkProductColTax => 'Kodi';

  @override
  String get bulkProductColType => 'Aina';

  @override
  String bulkProductPageStatus(
    String page,
    String pages,
    String start,
    String end,
    String total,
    String visible,
  ) {
    return 'Ukurasa $page kati ya $pages — inahariri mistari $start–$end kati ya $total ($visible kwenye skrini)';
  }

  @override
  String get bulkProductPreviousPage => 'Ukurasa uliotangulia';

  @override
  String get bulkProductNextPage => 'Ukurasa unaofuata';

  @override
  String bulkProductShowingRows(String count) {
    return 'Inaonyesha mistari $count';
  }

  @override
  String get bulkProductRemoveRow => 'Ondoa mstari';

  @override
  String get bulkProductNoDataToSave => 'Hakuna data ya kuhifadhi';

  @override
  String bulkProductLoadingFullSpreadsheet(String count) {
    return 'Inapakia lahajedwali kamili (mistari ~$count)…';
  }

  @override
  String get bulkProductCouldNotLoadSpreadsheet =>
      'Imeshindwa kupakia lahajedwali. Tumia \"Badilisha\" kuchagua faili nyingine.';

  @override
  String get bulkProductUploadToPreview =>
      'Pakia faili ya Excel kuhakiki bidhaa';

  @override
  String get bulkProductNoRowsInFile =>
      'Hakuna mistari kwenye faili — pakia lahajedwali nyingine au ongeza mistari kwenye Excel.';

  @override
  String bulkProductLargeImportLoading(String count) {
    return 'Uingizaji mkubwa (bidhaa ~$count, inapakia faili kamili…) — Kuhifadhi kumezimwa hadi upakiaji ukamilike.';
  }

  @override
  String bulkProductLargeImportTitle(String count) {
    return 'Uingizaji mkubwa (bidhaa $count)';
  }

  @override
  String get bulkProductPreviewLoadingHint =>
      'Inaonyesha hakikisho la haraka wakati mistari yote inapakiwa. Kuondoa mistari kumezimwa hadi faili kamili iwe tayari.';

  @override
  String get bulkProductPreviewReadyHint =>
      'Unaweza kuondoa mistari kwenye hakikisho hapa chini. Faili kamili ikiwa tayari, utapata jedwali linalohaririwa kama la uingizaji mdogo, bidhaa 20 kwa kila ukurasa.';

  @override
  String bulkProductPreviewFirstOf(String count, String total) {
    return 'Hakikisho ($count za kwanza kati ya $total)';
  }

  @override
  String get bulkProductNoName => '(hakuna jina)';

  @override
  String bulkProductBarcodePrice(String barcode, String price) {
    return 'Msimbopau: $barcode · Bei: $price';
  }

  @override
  String get bulkProductAvailableAfterLoad =>
      'Itapatikana baada ya faili kamili kupakiwa';

  @override
  String get bulkProductDropExcelHere => 'Dondosha faili yako ya Excel hapa';

  @override
  String get bulkProductClickToBrowse => 'au bofya kuvinjari faili zako';

  @override
  String bulkProductProductsLoaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count zimepakiwa',
      one: 'Bidhaa 1 imepakiwa',
    );
    return '$_temp0';
  }

  @override
  String get bulkProductChange => 'Badilisha';

  @override
  String get bulkProductSupportedFormats =>
      'Zinazokubalika: .xlsx, .xls (hifadhi WPS kama Excel .xlsx)';

  @override
  String get bulkProductDownloadTemplate => 'Pakua kiolezo';

  @override
  String get bulkProductTypeRawMaterial => 'Malighafi';

  @override
  String get bulkProductTypeFinishedProduct => 'Bidhaa iliyokamilika';

  @override
  String get bulkProductTypeService => 'Huduma bila hisa';

  @override
  String get bulkProductLoading => 'Inapakia…';

  @override
  String get bulkProductSelectCategory => 'Chagua kategoria';

  @override
  String get bulkProductSearchCategory => 'Tafuta kategoria';

  @override
  String get bulkProductAddNewCategory => 'Ongeza kategoria mpya';

  @override
  String get bulkProductSaveComplete => 'Uhifadhi wa jumla umekamilika';

  @override
  String get bulkProductSaveFailed => 'Uhifadhi wa jumla umeshindwa';

  @override
  String get bulkProductStatTotal => 'Jumla';

  @override
  String get bulkProductStatSucceeded => 'Zimefaulu';

  @override
  String get bulkProductStatFailed => 'Zimeshindwa';

  @override
  String get bulkProductTaxRegistrationSkipped =>
      'Usajili wa kodi umerukwa kwa tawi hili.';

  @override
  String bulkProductJobId(String id) {
    return 'Kazi $id';
  }

  @override
  String get bulkProductStay => 'Baki';

  @override
  String get stockRecountTitle => 'Hesabu upya ya hisa';

  @override
  String get stockRecountNew => 'Hesabu mpya';

  @override
  String get stockRecountStatusAll => 'Zote';

  @override
  String get stockRecountStatusDraft => 'Rasimu';

  @override
  String get stockRecountStatusSubmitted => 'Imewasilishwa';

  @override
  String get stockRecountStatusSynced => 'Imesawazishwa';

  @override
  String get stockRecountBalanced => 'Imesawazika';

  @override
  String stockRecountNetValue(String value) {
    return '$value jumla';
  }

  @override
  String get stockRecountExporting => 'Inahamisha…';

  @override
  String get stockRecountExportPdf => 'Hamisha PDF';

  @override
  String stockRecountStartFailed(String error) {
    return 'Imeshindwa kuanza hesabu: $error';
  }

  @override
  String get stockRecountDeleteTitle => 'Futa hesabu?';

  @override
  String get stockRecountDeleteMessage =>
      'Futa rasimu hii ya hesabu? Hatua hii haiwezi kutenduliwa.';

  @override
  String get stockRecountDeleted => 'Hesabu imefutwa';

  @override
  String stockRecountDeleteFailed(String error) {
    return 'Kufuta kumeshindwa: $error';
  }

  @override
  String stockRecountExportFailed(String error) {
    return 'Kuhamisha kumeshindwa: $error';
  }

  @override
  String get stockRecountSearchHint => 'Tafuta kifaa, dokezo au bidhaa…';

  @override
  String get stockRecountClearFilters => 'Futa vichujio';

  @override
  String get stockRecountStartNew => 'Anza hesabu mpya';

  @override
  String get stockRecountFilter => 'Chuja';

  @override
  String get stockRecountNothingMatches => 'Hakuna kinacholingana';

  @override
  String get stockRecountNoRecountsYet => 'Hakuna hesabu bado';

  @override
  String get stockRecountNothingMatchesHint =>
      'Jaribu neno au kichujio kingine ili kupata hesabu unayotafuta.';

  @override
  String get stockRecountEmptyHint =>
      'Anza hesabu mpya kuhesabu hisa halisi na kulinganisha na rekodi za mfumo.';

  @override
  String get stockRecountUnknownDevice => 'Kifaa kisichojulikana';

  @override
  String stockRecountItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count',
      one: 'Bidhaa 1',
    );
    return '$_temp0';
  }

  @override
  String stockRecountShortCount(String count) {
    return '$count pungufu';
  }

  @override
  String stockRecountMatchingCount(String count) {
    return '$count zinazolingana';
  }

  @override
  String stockRecountSurplusCount(String count) {
    return '$count ziada';
  }

  @override
  String get stockRecountDeleteDraft => 'Futa rasimu';

  @override
  String stockRecountAlreadyInCount(String name) {
    return '$name tayari iko kwenye hesabu hii';
  }

  @override
  String stockRecountAddedToCount(String name) {
    return '$name imeongezwa kwenye hesabu';
  }

  @override
  String stockRecountAddItemFailed(String error) {
    return 'Imeshindwa kuongeza bidhaa: $error';
  }

  @override
  String stockRecountUpdateFailed(String error) {
    return 'Kusasisha kumeshindwa: $error';
  }

  @override
  String get stockRecountItemRemoved => 'Bidhaa imeondolewa';

  @override
  String stockRecountRemoveFailed(String error) {
    return 'Kuondoa kumeshindwa: $error';
  }

  @override
  String get stockRecountUnknownBarcode => 'Msimbopau usiojulikana';

  @override
  String stockRecountScanned(String name) {
    return '$name imeskaniwa — rekebisha idadi ikihitajika';
  }

  @override
  String get stockRecountSubmitTitle => 'Wasilisha hesabu?';

  @override
  String get stockRecountSubmitMessage =>
      'Hii itasasisha viwango vya hisa kulingana na idadi ulizohesabu.';

  @override
  String get stockRecountSubmitted => 'Hesabu imewasilishwa ✓';

  @override
  String stockRecountSubmitFailed(String error) {
    return 'Kuwasilisha kumeshindwa: $error';
  }

  @override
  String get stockRecountInfo =>
      'Hesabu hisa halisi, linganisha tofauti, kisha wasilisha ili kusawazisha hisa.';

  @override
  String stockRecountLoadFailed(String error) {
    return 'Imeshindwa kupakia hesabu: $error';
  }

  @override
  String get stockRecountNotFound => 'Hesabu haikupatikana';

  @override
  String get stockRecountCountedItems => 'Bidhaa zilizohesabiwa';

  @override
  String stockRecountItemsNet(int count, String net) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count',
      one: 'Bidhaa 1',
    );
    return '$_temp0 · jumla $net';
  }

  @override
  String stockRecountNetItems(String net, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'bidhaa $count',
      one: 'bidhaa 1',
    );
    return '$net · $_temp0';
  }

  @override
  String get stockRecountDevice => 'Kifaa';

  @override
  String stockRecountCreatedAt(String date) {
    return 'Imeundwa $date';
  }

  @override
  String get stockRecountNoteHint => 'Ongeza dokezo kwa hesabu hii…';

  @override
  String get stockRecountNoNote => 'Hakuna dokezo';

  @override
  String get stockRecountItemsCounted => 'Bidhaa zilizohesabiwa';

  @override
  String get stockRecountMatching => 'Zinazolingana';

  @override
  String get stockRecountSurplus => 'Ziada';

  @override
  String get stockRecountShort => 'Pungufu';

  @override
  String get stockRecountAddProduct => 'Ongeza bidhaa ya kuhesabu';

  @override
  String get stockRecountProductSearchHint =>
      'Tafuta jina la bidhaa, SKU au msimbopau…';

  @override
  String stockRecountNoProductMatches(String query) {
    return 'Hakuna bidhaa inayolingana na \"$query\".';
  }

  @override
  String get stockRecountAdded => 'Imeongezwa';

  @override
  String get stockRecountInSystem => 'kwenye mfumo';

  @override
  String stockRecountStagedLine(String sku, String qty) {
    return 'SKU $sku · $qty kwenye mfumo';
  }

  @override
  String stockRecountItemLine(String sku, String time) {
    return 'SKU $sku · imehesabiwa $time';
  }

  @override
  String stockRecountShrinkageNote(String qty) {
    return 'Umehesabu $qty pungufu kuliko mfumo unavyoonyesha — hii itarekodiwa kama upotevu.';
  }

  @override
  String stockRecountSurplusNote(String qty) {
    return 'Umehesabu $qty zaidi kuliko mfumo unavyoonyesha — ziada itarekodiwa.';
  }

  @override
  String get stockRecountSystem => 'Mfumo';

  @override
  String get stockRecountCounted => 'Imehesabiwa';

  @override
  String get stockRecountVariance => 'Tofauti';

  @override
  String get stockRecountEmptyItemsHint =>
      'Tafuta bidhaa hapo juu au skani msimbopau, kisha weka idadi uliyohesabu.';

  @override
  String get stockRecountNoCountedItems =>
      'Hesabu hii haina bidhaa zilizohesabiwa.';

  @override
  String get stockRecountNetVariance => 'Tofauti halisi';

  @override
  String get stockRecountTotal => 'Jumla ya hesabu';

  @override
  String get stockRecountConfirmShortagesTitle =>
      'Thibitisha upungufu kabla ya kuwasilisha';

  @override
  String stockRecountConfirmShortagesBody(int count, String net) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count zimehesabiwa',
      one: 'Bidhaa 1 imehesabiwa',
    );
    return '$_temp0 chini ya mfumo — kurekodi hii kutawasilisha tofauti halisi ya $net. Ongeza sababu…';
  }

  @override
  String get stockRecountShortageReasonHint =>
      'Sababu ya upungufu (mf. bidhaa zilizoharibika, zilizooza, wizi)…';

  @override
  String get stockRecountKeepEditing => 'Endelea kuhariri';

  @override
  String get stockRecountConfirmSubmit => 'Thibitisha na uwasilishe';

  @override
  String get stockRecountPointCamera => 'Elekeza kamera kwenye msimbopau';

  @override
  String get stockRecountPdfSubject => 'Ripoti ya hesabu upya ya hisa';

  @override
  String get stockRecountPdfSaveTitle => 'Hifadhi PDF ya hesabu ya hisa';

  @override
  String stockRecountPdfReportNumber(String id) {
    return 'Ripoti #$id';
  }

  @override
  String get stockRecountPdfNote => 'Dokezo:';

  @override
  String stockRecountPdfCountedByName(String name) {
    return 'Imehesabiwa na — $name';
  }

  @override
  String get stockRecountPdfApprovedBy => 'Imeidhinishwa na';

  @override
  String get stockRecountPdfFooter =>
      'Imetolewa na Flipper · Hesabu upya ya hisa';

  @override
  String get stockRecountCountedBy => 'Imehesabiwa na';

  @override
  String get stockRecountCreated => 'Imeundwa';

  @override
  String get stockRecountGenerated => 'Imetolewa';

  @override
  String get stockRecountProduct => 'Bidhaa';

  @override
  String stockRecountPdfTotals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'bidhaa $count',
      one: 'bidhaa 1',
    );
    return 'Jumla · $_temp0';
  }

  @override
  String get stockRecountFallbackAgent => 'Wakala';

  @override
  String get stockRecountFallbackBranch => 'Tawi';

  @override
  String get productionOutputTitle => 'Matokeo ya uzalishaji';

  @override
  String get productionOutputNew => 'Mpya';

  @override
  String get productionOutputNewOrder => 'Agizo jipya';

  @override
  String get productionOutputWorkOrders => 'Maagizo ya kazi';

  @override
  String productionOutputItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vipengee $count',
      one: 'Kipengee 1',
    );
    return '$_temp0';
  }

  @override
  String get productionOutputLoadFailed => 'Imeshindwa kupakia maagizo ya kazi';

  @override
  String get productionOutputCheckConnection =>
      'Angalia muunganisho wako kisha ujaribu tena.';

  @override
  String get productionOutputNoWorkOrdersYet => 'Bado hakuna maagizo ya kazi';

  @override
  String get productionOutputNoWorkOrdersHint =>
      'Unda agizo la kazi ili kuanza kufuatilia matokeo ya uzalishaji.';

  @override
  String get productionOutputNewWorkOrder => 'Agizo jipya la kazi';

  @override
  String get productionOutputUnknownProduct => 'Bidhaa isiyojulikana';

  @override
  String get productionOutputUnknown => 'Haijulikani';

  @override
  String get productionOutputPlanned => 'Iliyopangwa';

  @override
  String get productionOutputActual => 'Halisi';

  @override
  String get productionOutputVariance => 'Tofauti';

  @override
  String get productionOutputRecord => 'Rekodi';

  @override
  String get productionOutputComplete => 'Kamilisha';

  @override
  String get productionOutputStart => 'Anza';

  @override
  String get productionOutputRecordFailed =>
      'Imeshindwa kurekodi matokeo. Tafadhali jaribu tena.';

  @override
  String get productionOutputCompleteFailed =>
      'Imeshindwa kukamilisha agizo hili la kazi. Tafadhali jaribu tena.';

  @override
  String get productionOutputStartFailed =>
      'Imeshindwa kuanza agizo hili la kazi. Tafadhali jaribu tena.';

  @override
  String get productionOutputCompleteTitle => 'Kamilisha agizo la kazi?';

  @override
  String productionOutputCompleteMessage(String name) {
    return 'Weka \"$name\" kuwa imekamilika?';
  }

  @override
  String get productionOutputStartTitle => 'Anza agizo la kazi?';

  @override
  String productionOutputStartMessage(String name) {
    return 'Anza uzalishaji wa \"$name\"?';
  }

  @override
  String get productionOutputRecordOutput => 'Rekodi matokeo';

  @override
  String productionOutputProductLabel(String name) {
    return 'Bidhaa: $name';
  }

  @override
  String productionOutputTargetLabel(String quantity) {
    return 'Lengo: $quantity';
  }

  @override
  String get productionOutputActualQuantity => 'Kiasi halisi';

  @override
  String get productionOutputReasonMachine => 'Mashine';

  @override
  String get productionOutputReasonMachineDesc =>
      'Mashine kusimama au kuharibika';

  @override
  String get productionOutputReasonMaterial => 'Malighafi';

  @override
  String get productionOutputReasonMaterialDesc =>
      'Uhaba wa malighafi au matatizo ya ubora';

  @override
  String get productionOutputReasonLabor => 'Wafanyakazi';

  @override
  String get productionOutputReasonLaborDesc => 'Uhaba wa wafanyakazi au ujuzi';

  @override
  String get productionOutputReasonQuality => 'Ubora';

  @override
  String get productionOutputReasonQualityDesc =>
      'Kukataliwa na udhibiti wa ubora';

  @override
  String get productionOutputReasonPlanning => 'Mipango';

  @override
  String get productionOutputReasonPlanningDesc =>
      'Matatizo ya mipango au ratiba';

  @override
  String get productionOutputReasonOther => 'Nyingine';

  @override
  String get productionOutputReasonOtherDesc => 'Sababu nyingine';

  @override
  String get productionOutputStatusPlanned => 'Imepangwa';

  @override
  String get productionOutputStatusInProgress => 'Inaendelea';

  @override
  String get productionOutputStatusCompleted => 'Imekamilika';

  @override
  String get productionOutputStatusCancelled => 'Imeghairiwa';

  @override
  String get productionOutputRatingExcellent => 'Bora sana';

  @override
  String get productionOutputRatingGood => 'Nzuri';

  @override
  String get productionOutputRatingFair => 'Wastani';

  @override
  String get productionOutputRatingPoor => 'Duni';

  @override
  String get productionOutputVarianceReason => 'Sababu ya tofauti';

  @override
  String get productionOutputVarianceReasonHint =>
      'Chagua sababu kuu ya tofauti ya uzalishaji';

  @override
  String get productionOutputAdditionalNotes => 'Maelezo ya ziada';

  @override
  String get productionOutputVarianceNotesHint => 'Toa maelezo kuhusu tofauti…';

  @override
  String get productionOutputEditWorkOrder => 'Hariri agizo la kazi';

  @override
  String get productionOutputCreateWorkOrder => 'Unda agizo la kazi';

  @override
  String get productionOutputUpdateWorkOrder => 'Sasisha agizo la kazi';

  @override
  String get productionOutputFormSubtitle => 'Panga uzalishaji wa bidhaa zako';

  @override
  String get productionOutputProductMaterialRequired => 'Bidhaa/Malighafi *';

  @override
  String get productionOutputSearchProduct => 'Tafuta bidhaa';

  @override
  String get productionOutputSelectProduct => 'Tafadhali chagua bidhaa';

  @override
  String get productionOutputNoProductsFound => 'Hakuna bidhaa zilizopatikana';

  @override
  String get productionOutputNoProductsHint =>
      'Jaribu jina lingine la bidhaa au SKU';

  @override
  String get productionOutputNotAvailable => 'Hakuna';

  @override
  String get productionOutputPlannedQuantityRequired => 'Kiasi kilichopangwa *';

  @override
  String get productionOutputUnits => 'vipande';

  @override
  String get productionOutputRequired => 'Inahitajika';

  @override
  String get productionOutputTargetDateRequired => 'Tarehe lengwa *';

  @override
  String get productionOutputTargetDate => 'Tarehe lengwa';

  @override
  String get productionOutputShiftOptional => 'Zamu (si lazima)';

  @override
  String get productionOutputShiftMorning => 'Asubuhi';

  @override
  String get productionOutputShiftAfternoon => 'Mchana';

  @override
  String get productionOutputShiftNight => 'Usiku';

  @override
  String get productionOutputNotes => 'Maelezo';

  @override
  String get productionOutputNotesHint => 'Maelekezo au maoni ya ziada…';

  @override
  String get productionOutputSaveFailed =>
      'Imeshindwa kuhifadhi agizo la kazi. Tafadhali jaribu tena.';

  @override
  String get productionOutputChartTitle =>
      'Matokeo yaliyopangwa dhidi ya halisi';

  @override
  String productionOutputLastDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Siku $count zilizopita',
      one: 'Siku iliyopita',
    );
    return '$_temp0';
  }

  @override
  String get productionOutputVariancePercent => 'Tofauti %';

  @override
  String get productionOutputNoDataAvailable => 'Hakuna data inayopatikana';

  @override
  String get productionOutputDayMon => 'Jtt';

  @override
  String get productionOutputDayTue => 'Jnn';

  @override
  String get productionOutputDayWed => 'Jtn';

  @override
  String get productionOutputDayThu => 'Alh';

  @override
  String get productionOutputDayFri => 'Iju';

  @override
  String get productionOutputDaySat => 'Jms';

  @override
  String get productionOutputDaySun => 'Jpl';

  @override
  String get productionOutputEfficiencyRate => 'Kiwango cha ufanisi';

  @override
  String get productionOutputCompletion => 'Ukamilishaji';

  @override
  String get productionOutputCompletionRate => 'Kiwango cha ukamilishaji';

  @override
  String productionOutputCompletedOfTotal(String completed, String total) {
    return '$completed kati ya $total';
  }

  @override
  String get productionOutputVarianceReasons => 'Sababu za tofauti';

  @override
  String get productionOutputNoData => 'Hakuna data';

  @override
  String get productionOutputOverview => 'Muhtasari wa uzalishaji';

  @override
  String get productionOutputOrders => 'Maagizo';

  @override
  String get productionOutputStatusFilterLabel => 'Hali:';

  @override
  String get productionOutputFilterAll => 'Zote';

  @override
  String get productionOutputProduct => 'Bidhaa';

  @override
  String get productionOutputStatus => 'Hali';

  @override
  String get productionOutputNoWorkOrdersFound =>
      'Hakuna maagizo ya kazi yaliyopatikana';

  @override
  String get productionOutputTableEmptyHint =>
      'Unda agizo la kazi ili kuanza kufuatilia uzalishaji';

  @override
  String get incomingOrdersIncoming => 'Zinazoingia';

  @override
  String get incomingOrdersOutgoing => 'Zinazotoka';

  @override
  String get incomingOrdersBranchNotFound => 'Tawi halikupatikana';

  @override
  String get incomingOrdersBranchLoadFailed =>
      'Imeshindwa kupakia tawi linalotumika';

  @override
  String get incomingOrdersReceivedOrders => 'Oda zilizopokelewa';

  @override
  String get incomingOrdersSentOrders => 'Oda zilizotumwa';

  @override
  String get incomingOrdersErrorLoadingBranch => 'Hitilafu kupakia tawi';

  @override
  String get incomingOrdersErrorLoadingRequests => 'Hitilafu kupakia maombi';

  @override
  String get incomingOrdersTitle => 'Usimamizi wa oda';

  @override
  String get incomingOrdersSubtitle =>
      'Fuatilia na usimamie oda zinazoingia na zinazotoka';

  @override
  String get incomingOrdersPendingRequests => 'Maombi yanayosubiri';

  @override
  String incomingOrdersNoRequests(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'pending': 'Hakuna maombi yanayosubiri',
      'approved': 'Hakuna maombi yaliyoidhinishwa',
      'processing': 'Hakuna maombi yanayozalishwa',
      'voided': 'Hakuna maombi yaliyobatilishwa',
      'rejected': 'Hakuna maombi yaliyokataliwa',
      'other': 'Hakuna maombi',
    });
    return '$_temp0';
  }

  @override
  String get incomingOrdersNothingToShow => 'Hakuna cha kuonyesha kwa sasa.';

  @override
  String get incomingOrdersTryAgain => 'Jaribu tena';

  @override
  String incomingOrdersSelectedCount(int count) {
    return '$count zimechaguliwa';
  }

  @override
  String get incomingOrdersNoApprovePermission =>
      'Huna ruhusa la kuidhinisha oda';

  @override
  String get incomingOrdersApprove => 'Idhinisha';

  @override
  String get incomingOrdersReject => 'Kataa';

  @override
  String get incomingOrdersItemsHeading => 'BIDHAA';

  @override
  String get incomingOrdersNoItems => 'Hakuna bidhaa katika ombi hili';

  @override
  String incomingOrdersErrorLoadingItems(String error) {
    return 'Hitilafu kupakia bidhaa: $error';
  }

  @override
  String incomingOrdersUpdateItemFailed(String error) {
    return 'Imeshindwa kusasisha bidhaa: $error';
  }

  @override
  String get incomingOrdersUpdateQtyLabel => 'Sasisha kiasi:';

  @override
  String get incomingOrdersRequestedLabel => 'Iliyoombwa:';

  @override
  String get incomingOrdersApprovedLabel => 'Iliyoidhinishwa:';

  @override
  String get incomingOrdersUpdate => 'Sasisha';

  @override
  String get incomingOrdersStatusDeliveryHeading => 'HALI NA UWASILISHAJI';

  @override
  String get incomingOrdersStatus => 'Hali';

  @override
  String get incomingOrdersRequestedOn => 'Iliombwa tarehe';

  @override
  String get incomingOrdersStatusPending => 'Inasubiri';

  @override
  String get incomingOrdersStatusProcessing => 'Inashughulikiwa';

  @override
  String get incomingOrdersStatusPartiallyApproved =>
      'Imeidhinishwa kwa sehemu';

  @override
  String get incomingOrdersStatusRejected => 'Imekataliwa';

  @override
  String get incomingOrdersStatusFulfilled => 'Imetimizwa';

  @override
  String get incomingOrdersStatusVoided => 'Imebatilishwa';

  @override
  String get incomingOrdersOrderNoteHeading => 'MAELEZO YA ODA';

  @override
  String get incomingOrdersProduce => 'Zalisha';

  @override
  String get incomingOrdersVoid => 'Batilisha';

  @override
  String get incomingOrdersFinishProduction => 'Maliza uzalishaji';

  @override
  String get incomingOrdersInProduction => 'Inazalishwa';

  @override
  String get incomingOrdersApproveRequest => 'Idhinisha ombi';

  @override
  String get incomingOrdersApproveAllConfirm =>
      'Una uhakika unataka kuidhinisha bidhaa zote katika ombi hili?';

  @override
  String get incomingOrdersApproveAll => 'Idhinisha zote';

  @override
  String get incomingOrdersVoidRequest => 'Batilisha ombi';

  @override
  String get incomingOrdersVoidConfirm =>
      'Una uhakika unataka kubatilisha ombi hili?';

  @override
  String incomingOrdersDeclinedSms(String reference) {
    return 'Ombi lako la bidhaa #$reference limekataliwa.';
  }

  @override
  String get incomingOrdersVoidSuccess => 'Ombi limebatilishwa kikamilifu';

  @override
  String incomingOrdersVoidFailed(String error) {
    return 'Imeshindwa kubatilisha ombi: $error';
  }

  @override
  String get incomingOrdersProductionFinished =>
      'Uzalishaji umewekwa kuwa umekamilika. Tayari kwa kuidhinishwa.';

  @override
  String get incomingOrdersFinishProductionFailed =>
      'Imeshindwa kumaliza uzalishaji';

  @override
  String get incomingOrdersUnknown => 'Haijulikani';

  @override
  String get incomingOrdersFromLabel => 'Kutoka:';

  @override
  String get incomingOrdersToLabel => 'Kwa:';

  @override
  String incomingOrdersRequestFrom(String branch) {
    return 'Ombi kutoka $branch';
  }

  @override
  String incomingOrdersLineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '(bidhaa $count)',
      one: '(bidhaa 1)',
    );
    return '$_temp0';
  }

  @override
  String incomingOrdersQtyItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bidhaa $count',
      one: 'Bidhaa 1',
    );
    return '$_temp0';
  }

  @override
  String incomingOrdersQtyRatio(int requested, String approved) {
    String _temp0 = intl.Intl.pluralLogic(
      requested,
      locale: localeName,
      other: '$requested',
      one: '1',
    );
    return 'Bidhaa $approved/$_temp0';
  }

  @override
  String get failedPaymentCardEmailRequired =>
      'Barua pepe inahitajika kwa risiti ya kadi';

  @override
  String get failedPaymentEnterValidEmail => 'Weka barua pepe halali';

  @override
  String get failedPaymentPhoneMustStartWith250 =>
      'Nambari ya simu lazima ianze na 250';

  @override
  String get failedPaymentPhoneMustBe12Digits =>
      'Nambari ya simu lazima iwe na tarakimu 12';

  @override
  String get failedPaymentPhoneCannotExceed12Digits =>
      'Nambari ya simu haiwezi kuzidi tarakimu 12';

  @override
  String get failedPaymentInvalidMtnPrefix =>
      'Kianzio cha nambari ya MTN si sahihi (lazima kianze na 78 au 79)';

  @override
  String get failedPaymentLoadingTookTooLong =>
      'Upakiaji umechukua muda mrefu. Angalia muunganisho wako, onyesha upya ukurasa, au jaribu tena.';

  @override
  String failedPaymentErrorLoadingPlanDetails(String error) {
    return 'Hitilafu katika kupakia maelezo ya mpango: $error';
  }

  @override
  String get failedPaymentFailedTryAgain =>
      'Malipo yameshindikana, jaribu tena';

  @override
  String get failedPaymentFailedToValidateCode =>
      'Imeshindwa kuthibitisha msimbo';

  @override
  String get failedPaymentLoadingDetails => 'Inapakia maelezo ya malipo…';

  @override
  String get failedPaymentIssueTitle => 'Tatizo la Malipo';

  @override
  String get failedPaymentCompleteOnCardPage =>
      'Kamilisha Malipo kwenye Ukurasa wa Kadi';

  @override
  String get failedPaymentCompleteOnPhone =>
      'Kamilisha Malipo kwenye Simu Yako';

  @override
  String get failedPaymentCardWaitingBody =>
      'Weka maelezo ya kadi yako kwenye ukurasa uliofunguka.\nSkrini hii itajisasisha yenyewe malipo yakikamilika.';

  @override
  String get failedPaymentMomoWaitingBody =>
      'Ombi la malipo limetumwa kwa MTN Mobile Money yako.\nFungua simu yako na uidhinishe muamala.';

  @override
  String get failedPaymentReopenPage => 'Fungua tena ukurasa wa malipo';

  @override
  String get failedPaymentNotNowBackToOptions =>
      'Si sasa — rudi kwenye chaguo za malipo';

  @override
  String get failedPaymentNeedsAttention => 'Malipo Yanahitaji Uangalizi';

  @override
  String get failedPaymentNeedsAttentionBody =>
      'Usijali, hili hutokea mara kwa mara.\nTukusaidie haraka.';

  @override
  String get failedPaymentSwitchOrUpgradePlan => 'Badilisha au pandisha mpango';

  @override
  String get failedPaymentTapToCollapse => 'Gusa ili kukunja';

  @override
  String get failedPaymentChooseDifferentPlan =>
      'Chagua mpango mwingine kabla ya kujaribu tena';

  @override
  String get failedPaymentPlanStillActive =>
      'Mpango wako bado unatumika. Unaweza kuupandisha au kubadilisha mipango hapa chini. Mpango mpya utaanza mzunguko wako ujao wa malipo.';

  @override
  String get failedPaymentEnterpriseServices => 'Huduma za Biashara Kubwa';

  @override
  String get failedPaymentAdditionalServices => 'Huduma za Ziada';

  @override
  String get failedPaymentNewPlanTotal => 'Jumla ya mpango mpya';

  @override
  String get failedPaymentCouldNotOpenPage =>
      'Imeshindwa kufungua ukurasa wa malipo kwenye kifaa hiki. Jaribu Mobile Money, au maliza malipo kwenye simu au kompyuta yenye kivinjari.';

  @override
  String get failedPaymentSubscriptionEnded =>
      'Usajili huu umeisha. Chagua mpango hapo juu ili kuanza tena.';

  @override
  String get failedPaymentPageNotReady =>
      'Ukurasa wa malipo bado haujawa tayari. Jaribu tena baada ya muda mfupi.';

  @override
  String get failedPaymentCouldNotOpenCardPage =>
      'Imeshindwa kufungua ukurasa wa malipo ya kadi kwenye kifaa hiki. Tumia kiungo hapa chini, au lipa kwa Mobile Money.';

  @override
  String failedPaymentCardNotStartedWithError(String error) {
    return 'Malipo ya kadi hayakuweza kuanzishwa: $error';
  }

  @override
  String get failedPaymentCardNotStarted =>
      'Malipo ya kadi hayakuweza kuanzishwa.';

  @override
  String get failedPaymentCardNotThrough =>
      'Malipo ya kadi hayajapita. Jaribu tena, au tumia Mobile Money.';

  @override
  String get failedPaymentPayByCard => 'Lipa kwa kadi';

  @override
  String get failedPaymentTryAgain => 'Jaribu Tena';

  @override
  String get failedPaymentOpening => 'Inafungua…';

  @override
  String get failedPaymentRetrying => 'Inajaribu tena…';

  @override
  String get failedPaymentTimeout =>
      'Muda wa malipo umeisha. Tafadhali jaribu tena.';

  @override
  String get failedPaymentNothingChargedApprove =>
      'Hakuna kilichotozwa. Idhinisha ombi la Mobile Money kwenye simu yako, kisha jaribu tena.';

  @override
  String failedPaymentFailedWithError(String error) {
    return 'Malipo yameshindikana: $error';
  }

  @override
  String get failedPaymentFailedTryAgainShort =>
      'Malipo yameshindikana. Jaribu tena.';

  @override
  String get failedPaymentFailedAgainTryDifferent =>
      'Malipo yameshindikana tena. Jaribu nambari nyingine ya MTN au mpango mwingine.';

  @override
  String get failedPaymentMaxSkipReached =>
      'Kikomo cha kuruka kimefikiwa. Tafadhali kamilisha malipo ili kuendelea.';

  @override
  String failedPaymentSkipsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Unaweza kuruka mara $count zaidi',
      one: 'Unaweza kuruka mara 1 zaidi',
    );
    return '$_temp0';
  }

  @override
  String get failedPaymentSkipForNow => 'Ruka kwa Sasa';

  @override
  String get failedPaymentSkipLimitReached => 'Kikomo cha Kuruka Kimefikiwa';

  @override
  String get failedPaymentTotal => 'Jumla';

  @override
  String get failedPaymentPlan => 'Mpango';

  @override
  String get dashboardNotApplicable => 'Haipo';

  @override
  String failedPaymentDiscountWithCode(String code) {
    return 'Punguzo ($code)';
  }

  @override
  String get failedPaymentBilling => 'Malipo';

  @override
  String get failedPaymentAdditionalDevices => 'Vifaa vya Ziada';

  @override
  String get failedPaymentEnterMtnNumber =>
      'Tafadhali weka nambari yako ya simu ya MTN.';

  @override
  String get failedPaymentPhoneRequiredForMomo =>
      'Nambari ya simu inahitajika kwa MTN Mobile Money. Tafadhali washa \"Tumia nambari tofauti ya simu\" na uweke nambari yako ya MTN.';

  @override
  String failedPaymentReasonNothingCharged(String reason) {
    return '$reason Hakuna kilichotozwa — jaribu tena.';
  }

  @override
  String get failedPaymentDeclinedNothingCharged =>
      'Malipo yamekataliwa. Hakuna kilichotozwa — jaribu tena.';

  @override
  String paymentFinalizeListenerError(String error) {
    return 'Hitilafu katika kuandaa ufuatiliaji: $error';
  }

  @override
  String get paymentFinalizeSubscriptionEnded =>
      'Usajili huu umeisha. Chagua mpango ili kuanza tena.';

  @override
  String get paymentFinalizeReusedCheckout =>
      'Tayari ulikuwa na ukurasa wa malipo wazi kwa mpango huu — tumeufungua tena badala ya kuanzisha usajili wa pili.';

  @override
  String get paymentFinalizeNotSeenYet =>
      'Bado hatujaona malipo. Yamalize kwenye ukurasa wa malipo, kisha gusa \"Nimelipa\".';

  @override
  String get paymentFinalizeDidNotGoThrough =>
      'Malipo hayo hayakupita. Chagua mpango ili kuanza tena.';

  @override
  String get paymentFinalizeNotArrivedYet =>
      'Malipo bado hayajafika. Inaweza kuchukua muda kidogo baada ya kumaliza kwenye ukurasa wa malipo.';

  @override
  String paymentFinalizeCouldNotCheck(String error) {
    return 'Imeshindwa kuangalia malipo kwa sasa: $error';
  }

  @override
  String get paymentFinalizeWaitingForCard => 'Inasubiri malipo yako ya kadi';

  @override
  String get paymentFinalizeFinishOnPage =>
      'Maliza malipo kwenye ukurasa uliofunguka. Skrini hii itajisasisha yenyewe malipo yakipita.';

  @override
  String get paymentFinalizeCompletePayment => 'Kamilisha Malipo';

  @override
  String get paymentFinalizeCardPayment => 'Malipo ya Kadi';

  @override
  String get paymentFinalizeMomoPayment => 'Malipo ya MTN Mobile Money';

  @override
  String get paymentFinalizeProcessedByCard =>
      'Malipo yatachakatwa kwa kadi kwenye ukurasa salama wa malipo';

  @override
  String get paymentFinalizeProcessedByMomo =>
      'Malipo yatachakatwa kwa kutumia MTN Mobile Money';

  @override
  String get paymentFinalizePlanSummary => 'Muhtasari wa Mpango';

  @override
  String get paymentFinalizeUseDifferentPhone =>
      'Tumia nambari tofauti ya simu';

  @override
  String get paymentFinalizeSpecifyDifferentNumber =>
      'Taja nambari nyingine kwa malipo';

  @override
  String get paymentFinalizeMtnPhoneNumber => 'Nambari ya Simu ya MTN';

  @override
  String get paymentFinalizeMtnPhoneHelper =>
      'Lazima ianze na 250 78 au 250 79';

  @override
  String get paymentFinalizeIHavePaid => 'Nimelipa — angalia sasa';

  @override
  String get paymentFinalizeContinueToPage =>
      'Endelea kwenye ukurasa wa malipo';

  @override
  String get paymentFinalizeUseDifferentMethod =>
      'Tumia njia nyingine ya malipo';

  @override
  String paymentFinalizeApproveMomo(String message) {
    return '$message Idhinisha ombi la Mobile Money kwenye simu yako, kisha jaribu tena.';
  }

  @override
  String paymentFinalizeFailedToInitiate(String error) {
    return 'Imeshindwa kuanzisha malipo: $error';
  }

  @override
  String get paymentPlanNoPlansAvailable =>
      'Hakuna mipango ya usajili inayopatikana.';

  @override
  String get paymentPlanCouldNotLoadPlans =>
      'Imeshindwa kupakia mipango ya usajili. Tafadhali jaribu tena.';

  @override
  String get paymentPlanErrorOccurred =>
      'Hitilafu imetokea. Tafadhali jaribu tena.';

  @override
  String get paymentPlanSelectTitle => 'Chagua mpango unaokufaa';

  @override
  String paymentPlanSelectSubtitle(String percent) {
    return 'Badilisha mipango wakati wowote. Malipo ya kila mwaka yanakuokolea $percent%.';
  }

  @override
  String get paymentPlanProceedToPayment => 'Endelea na Malipo';

  @override
  String get paymentPlanSettingUp => 'Inaandaa mpango wako…';

  @override
  String get paymentPlanLoadingPlans => 'Inapakia mipango…';

  @override
  String get paymentPlanTitle => 'Mpango wa Malipo';

  @override
  String get manualPurchasePaidExceedsTotal =>
      'Kiasi kilicholipwa sasa hakiwezi kuzidi jumla ya ununuzi.';

  @override
  String get manualPurchaseRequiredFields =>
      'Msambazaji, nambari ya ankara ya tarakimu na angalau mstari mmoja wenye idadi zaidi ya sifuri vinahitajika.';

  @override
  String get manualPurchaseTaxVat18 => 'VAT 18%';

  @override
  String get manualPurchaseTaxExempt => 'Imesamehewa';

  @override
  String get manualPurchaseTaxZeroRated => 'Kiwango sifuri';

  @override
  String get manualPurchaseTaxNonVat => 'Bila VAT';

  @override
  String get manualPurchasePaySupplierBy => 'Mlipe msambazaji kabla ya';

  @override
  String get manualPurchaseRecordPurchase => 'Rekodi ununuzi';

  @override
  String get manualPurchaseSupplier => 'Msambazaji';

  @override
  String get manualPurchaseChooseSupplier => 'Chagua msambazaji';

  @override
  String get manualPurchaseTinOptional => 'TIN (si lazima)';

  @override
  String get manualPurchaseTinMustBe9Digits => 'TIN lazima iwe na tarakimu 9';

  @override
  String get manualPurchaseInvoiceNumber => 'Nambari ya ankara';

  @override
  String get manualPurchaseNextInvoiceHint =>
      'Nambari inayofuata baada ya ankara yako ya mwisho';

  @override
  String get manualPurchaseEnterInvoiceNumber => 'Weka nambari ya ankara';

  @override
  String get manualPurchasePurchaseDate => 'Tarehe ya ununuzi';

  @override
  String get manualPurchaseHowDidYouPay => 'Ulilipaje?';

  @override
  String get manualPurchasePaidNow => 'Kilicholipwa sasa';

  @override
  String get manualPurchaseItemsEmptyHint =>
      'Ongeza ulichonunua kutoka kwenye katalogi yako, au andika bidhaa mpya.';

  @override
  String get manualPurchaseFromCatalog => 'Kutoka katalogi';

  @override
  String get manualPurchaseNewItem => 'Bidhaa mpya';

  @override
  String get manualPurchaseYouWillOwe => 'Utadaiwa na msambazaji huyu';

  @override
  String get manualPurchaseUnnamedItem => 'Bidhaa isiyo na jina';

  @override
  String get manualPurchaseSummary => 'Muhtasari';

  @override
  String get manualPurchaseTaxableVat18 => 'Inayotozwa kodi (VAT 18%)';

  @override
  String get manualPurchaseVatIncluded => 'VAT imejumuishwa';

  @override
  String get manualPurchaseExemptZeroRated => 'Imesamehewa / kiwango sifuri';

  @override
  String get manualPurchaseSaveAsWaiting => 'Hifadhi ikisubiri';

  @override
  String manualPurchaseApproveWithTotal(String total) {
    return 'Idhinisha · $total';
  }

  @override
  String get manualPurchaseSaveAndApprove => 'Hifadhi na uidhinishe';

  @override
  String get manualPurchaseSearchSuppliers => 'Tafuta wasambazaji';

  @override
  String get manualPurchaseNewSupplier => 'Msambazaji mpya';

  @override
  String manualPurchaseAddNamed(String name) {
    return 'Ongeza \"$name\"';
  }

  @override
  String get manualPurchaseNewSupplierHint =>
      'Hifadhi msambazaji ambaye hujawahi kumtumia';

  @override
  String get manualPurchaseNoSuppliersYet => 'Bado hakuna wasambazaji';

  @override
  String manualPurchaseNoSupplierMatches(String query) {
    return 'Hakuna msambazaji anayelingana na \"$query\"';
  }

  @override
  String manualPurchaseTinValue(String tin) {
    return 'TIN $tin';
  }

  @override
  String get manualPurchaseFromYourInvoices => 'Kutoka kwenye ankara zako';

  @override
  String get manualPurchaseSearchCatalog => 'Tafuta kwenye katalogi yako';

  @override
  String get manualPurchaseTypeProductName => 'Andika jina la bidhaa';

  @override
  String manualPurchaseNoProductMatches(String query) {
    return 'Hakuna bidhaa inayolingana na \"$query\"';
  }

  @override
  String manualPurchaseCostValue(String amount) {
    return 'Gharama $amount';
  }

  @override
  String get manualPurchaseEditItem => 'Hariri bidhaa';

  @override
  String get manualPurchaseItemName => 'Jina la bidhaa';

  @override
  String get manualPurchaseEnterItemName => 'Weka jina la bidhaa';

  @override
  String get manualPurchaseMoreThanZero => 'Zaidi ya 0';

  @override
  String get manualPurchaseUnitCost => 'Gharama ya kipande';

  @override
  String get manualPurchaseTax => 'Kodi';

  @override
  String get manualPurchaseLineTotal => 'Jumla ya mstari';

  @override
  String get manualPurchaseAddItem => 'Ongeza bidhaa';

  @override
  String get manualPurchaseSupplierRequired => 'Msambazaji anahitajika';

  @override
  String get manualPurchaseSupplierTin => 'TIN ya msambazaji';

  @override
  String get manualPurchaseOptionalSuffix => '(si lazima)';

  @override
  String manualPurchaseExampleValue(String example) {
    return 'mf. $example';
  }

  @override
  String get manualPurchaseInvoiceNo => 'Na. ya ankara';

  @override
  String get manualPurchaseNumericInvoiceRequired =>
      'Nambari ya ankara ya tarakimu inahitajika';

  @override
  String get manualPurchasePaymentType => 'Aina ya malipo';

  @override
  String get manualPurchaseNoneFullCredit => '(hakuna — mkopo wote)';

  @override
  String get manualPurchaseYouWillOweLabel => 'Utadaiwa';

  @override
  String get manualPurchaseLineItems => 'Bidhaa';

  @override
  String get manualPurchaseAddFromCatalog => 'Ongeza kutoka katalogi';

  @override
  String get manualPurchaseSearchCatalogEllipsis => 'Tafuta katalogi…';

  @override
  String manualPurchaseSupplyAndTax(String price, String tax) {
    return 'Bei ya kununua: $price · Kodi: $tax';
  }

  @override
  String get manualPurchaseNoItemsHint =>
      'Bado hakuna bidhaa — ongeza kutoka katalogi yako au unda mstari mpya.';

  @override
  String get manualPurchaseQty => 'Idadi';

  @override
  String get manualPurchaseTaxable => 'Inayotozwa kodi';

  @override
  String get manualPurchaseExemptZero => 'Imesamehewa / sifuri';

  @override
  String get manualPurchaseRequired => 'Inahitajika';

  @override
  String get manualPurchaseNewBadge => 'mpya';

  @override
  String get manualPurchaseDuplicateInvoice => 'Ankara inayojirudia';

  @override
  String get manualPurchaseDuplicateInvoiceBody =>
      'Ununuzi wenye nambari hii ya ankara tayari upo kwa tawi hili. Hifadhi hata hivyo?';

  @override
  String get manualPurchaseSaveAnyway => 'Hifadhi hata hivyo';

  @override
  String get manualPurchaseRecordedApproved =>
      'Ununuzi umerekodiwa na kuidhinishwa';

  @override
  String manualPurchaseApprovalFailed(String error) {
    return 'Ununuzi umehifadhiwa ukisubiri. Uidhinishaji umeshindikana: $error';
  }

  @override
  String get manualPurchaseSavedAsWaiting => 'Ununuzi umehifadhiwa ukisubiri';

  @override
  String get manualPurchaseNewSupplierSubtitle =>
      'Inaundwa bila kuondoka kwenye ununuzi huu';

  @override
  String get manualPurchaseSupplierName => 'Jina la msambazaji';

  @override
  String get manualPurchasePhoneOptional => 'Simu (si lazima)';

  @override
  String get manualPurchaseCreateAndSelect => 'Unda na uchague';

  @override
  String get manualPurchaseNoMatchingSuppliers =>
      'Hakuna wasambazaji wanaolingana';

  @override
  String get manualPurchaseCreateNewSupplier => 'Unda msambazaji mpya';

  @override
  String get manualPurchaseSearchOrEnterSupplier =>
      'Tafuta au weka jina la msambazaji';

  @override
  String get manualPurchaseBackToImport => 'Rudi kwenye Uagizaji na Ununuzi';

  @override
  String get manualPurchasePageSubtitle =>
      'Rekodi ankara ya msambazaji na bidhaa zake';

  @override
  String get reportStatusParked => 'Imesimamishwa';

  @override
  String get reportStatusCompleted => 'Imekamilika';

  @override
  String get reportStatusCancelled => 'Imeghairiwa';

  @override
  String get reportStatusPending => 'Inasubiri';

  @override
  String get reportView => 'Tazama';

  @override
  String get reportPrint => 'Chapisha';

  @override
  String get reportReceiptNo => 'Na. ya risiti';

  @override
  String get reportCashier => 'Keshia';

  @override
  String get reportType => 'Aina';

  @override
  String get reportStatus => 'Hali';

  @override
  String get reportSaleTotal => 'Jumla ya mauzo';

  @override
  String get reportByHand => 'Mkononi';

  @override
  String get reportBalanceDue => 'Salio linalodaiwa';

  @override
  String get reportItemCode => 'Msimbo wa Bidhaa';

  @override
  String get reportBarcode => 'Msimbopau';

  @override
  String get reportTaxRate => 'Kiwango cha Kodi';

  @override
  String get reportProfitMade => 'Faida iliyopatikana';

  @override
  String get reportSupplyAmount => 'Kiasi cha ugavi';

  @override
  String get reportTaxPayable => 'Kodi inayolipwa';

  @override
  String get reportNetProfit => 'Faida Halisi';

  @override
  String get reportTotalSales => 'Jumla ya Mauzo';

  @override
  String get reportPeriodByHand => 'Kipindi — Mkononi';

  @override
  String get reportPeriodCredit => 'Kipindi — Mkopo';

  @override
  String reportStockCountUpdated(String product) {
    return 'Hesabu ya stoku imesasishwa kwa $product';
  }

  @override
  String reportStockCountUpdateFailed(String error) {
    return 'Imeshindwa kusasisha hesabu ya stoku: $error';
  }

  @override
  String get reportDismiss => 'Ondoa';

  @override
  String get reportTotalStockUnits => 'Jumla ya stoku (vipande):';

  @override
  String get reportTotalSalesLines => 'Jumla ya mauzo (mistari):';

  @override
  String get reportTotalSalesLabel => 'Jumla ya mauzo:';

  @override
  String reportTransactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Miamala $count',
      one: 'Muamala 1',
    );
    return '$_temp0';
  }

  @override
  String get reportTitleReport => 'Ripoti';

  @override
  String get reportTitleStockRecount => 'Kuhesabu Upya Stoku';

  @override
  String get reportTotalGrossProfit => 'Jumla ya Faida Ghafi';

  @override
  String get reportClosingBalance => 'Salio la kufunga';

  @override
  String reportStockRecountFor(String item) {
    return 'Kuhesabu Upya Stoku #$item';
  }

  @override
  String get reportNewCount => 'Hesabu Mpya';

  @override
  String get reportPleaseEnterNumber => 'Tafadhali weka nambari';

  @override
  String get reportSummarized => 'Muhtasari';

  @override
  String get reportDetailed => 'Kwa kina';

  @override
  String get reportZReport => 'Ripoti Z';

  @override
  String get reportXReport => 'Ripoti X';

  @override
  String get reportSaleReport => 'Ripoti ya Mauzo';

  @override
  String get reportPluReport => 'Ripoti ya PLU';

  @override
  String get reportGrossProfit => 'Faida Ghafi';

  @override
  String get reportStartDate => 'Tarehe ya Kuanza';

  @override
  String get reportEndDate => 'Tarehe ya Mwisho';

  @override
  String get reportTaxAmount => 'Kiasi cha Kodi';

  @override
  String get reportPaymentType => 'Aina ya Malipo';

  @override
  String get reportSaleAmount => 'Kiasi cha mauzo';

  @override
  String get reportTransactionCount => 'Idadi ya Miamala';

  @override
  String get reportPercentOfTotal => '% ya Jumla';

  @override
  String get reportExpense => 'Gharama';

  @override
  String get reportTotalExpenses => 'Jumla ya Gharama';

  @override
  String reportLabelWithColon(String label) {
    return '$label:';
  }

  @override
  String get reportSavePdfFile => 'Hifadhi faili la PDF';

  @override
  String reportDownloadSubject(String date) {
    return 'Upakuaji wa Ripoti - $date';
  }

  @override
  String get reportBusinessFallback => 'Biashara';

  @override
  String get reportPoweredByFlipper => 'Inaendeshwa na Flipper';

  @override
  String reportGeneratedAt(String date) {
    return 'Imetolewa: $date';
  }

  @override
  String get reportUnknownExpense => 'Gharama Isiyojulikana';

  @override
  String get reportPdfExportNeedsGrid =>
      'Kuhamisha PDF kunahitaji skrini kamili ya ripoti yenye jedwali. Zima uhamishaji wa PDF kwenye mipangilio ili kuhamisha Excel kutoka hapa, au tumia Ripoti kwenye kompyuta.';

  @override
  String get reportDate => 'Tarehe';

  @override
  String get reportPaymentMethod => 'Njia ya Malipo';

  @override
  String get reportWalkInCustomer => 'Mteja wa Papo hapo';

  @override
  String get reportStatusUnknown => 'Haijulikani';

  @override
  String get reportImportsReport => 'Ripoti ya Uagizaji';

  @override
  String get reportPurchasesReport => 'Ripoti ya Ununuzi';

  @override
  String reportDateValue(String date) {
    return 'Tarehe: $date';
  }

  @override
  String get reportRequestDate => 'Tarehe ya Ombi';

  @override
  String get reportDeclarationNumber => 'Nambari ya Tamko';

  @override
  String get reportQuantityUnitCode => 'Msimbo wa Kipimo cha Idadi';

  @override
  String get reportAgentName => 'Jina la wakala';

  @override
  String get reportInvoiceForeignAmount =>
      'Kiasi cha Ankara\nkwa Fedha za Kigeni';

  @override
  String get reportForeignCurrency => 'Fedha\nza Kigeni';

  @override
  String get reportSalesReport => 'Ripoti ya Mauzo';

  @override
  String reportPeriodRange(String end, String start) {
    return 'Kipindi cha Ripoti: $start - $end';
  }

  @override
  String get reportTotalRevenue => 'Jumla ya Mapato';

  @override
  String get reportTotalVat => 'Jumla ya VAT';

  @override
  String get reportTotalTransactions => 'Jumla ya Miamala';

  @override
  String get reportAvgTransaction => 'Wastani wa Muamala';

  @override
  String get reportBuyerTin => 'TIN ya Mnunuzi';

  @override
  String get reportBuyerName => 'Jina la Mnunuzi';

  @override
  String get reportReceiptNumberShort => 'Risiti #';

  @override
  String get reportItemsDetails => 'Maelezo ya Bidhaa';

  @override
  String get reportIndividual => 'Mtu binafsi';

  @override
  String reportSaleItemLine(
    String name,
    String price,
    String qty,
    String total,
  ) {
    return '$name\n  Idadi: $qty × $price\n  Jumla: $total';
  }

  @override
  String get reportStandard => 'Kawaida';

  @override
  String get branchTransferSelectDifferentBranch =>
      'Chagua tawi lingine la kupokea';

  @override
  String branchTransferItemMissingVariant(String name) {
    return 'Bidhaa $name haina aina ya bidhaa';
  }

  @override
  String get branchTransferCreatedNotLoaded =>
      'Uhamisho umeundwa lakini haukuweza kupakiwa';

  @override
  String get branchTransferApprovalIncomplete =>
      'Uhamisho umeundwa lakini uidhinishaji haukukamilika; bado unasubiri ukaguzi';

  @override
  String branchTransferSmsReceived(int count, String requestId) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Uhamisho wa stoku: bidhaa $count zimepokelewa kutoka tawi lingine (#$requestId).',
      one:
          'Uhamisho wa stoku: bidhaa 1 imepokelewa kutoka tawi lingine (#$requestId).',
    );
    return '$_temp0';
  }

  @override
  String get pdfPreparingDocument => 'Inaandaa hati…';

  @override
  String get pdfDocument => 'Hati';

  @override
  String pdfReadyToSaveOrShare(String label) {
    return '$label iko tayari kuhifadhiwa au kushirikiwa.';
  }

  @override
  String pdfSaveLabelPdf(String label) {
    return 'Hifadhi PDF: $label';
  }

  @override
  String pdfSavedTo(String file, String label) {
    return '$label imehifadhiwa kwenye $file.';
  }

  @override
  String pdfSavedOnDevice(String label) {
    return '$label imehifadhiwa kwenye kifaa hiki.';
  }

  @override
  String pdfReadyChooseWhere(String label) {
    return '$label iko tayari — chagua mahali pa kuihifadhi.';
  }

  @override
  String get pdfSomethingWentWrong =>
      'Kuna hitilafu imetokea. Tafadhali jaribu tena.';

  @override
  String get receiptActionsPreparing => 'Inaandaa risiti…';

  @override
  String receiptActionsShareSubject(String reference) {
    return 'Risiti · $reference';
  }

  @override
  String get receiptActionsThankYou => 'Asante kwa ununuzi wako.';

  @override
  String get receiptActionsBuildFailed =>
      'Imeshindwa kuandaa risiti ya mauzo haya. Angalia muunganisho wako kisha jaribu tena.';

  @override
  String get receiptActionsTrainingBlocked =>
      'Risiti za mafunzo haziwezi kushirikiwa wala kuchapishwa.';

  @override
  String get saleReceiptExpenseRecord => 'Rekodi ya gharama';

  @override
  String get saleReceiptSaleReceipt => 'Risiti ya mauzo';

  @override
  String get saleReceiptNoLineItems =>
      'Hakuna bidhaa zilizorekodiwa kwa muamala huu.';

  @override
  String saleReceiptCopyFooter(String date) {
    return 'Nakala ya mteja iliyotolewa kutoka kumbukumbu za Flipper tarehe $date. Hati hii si risiti ya kodi ya EBM.';
  }

  @override
  String saleReceiptCopyFooterWithEbm(String date) {
    return 'Nakala ya mteja iliyotolewa kutoka kumbukumbu za Flipper tarehe $date, pamoja na maelezo ya EBM ya mauzo haya yaliyonakiliwa hapo juu. Hati hii si risiti iliyosainiwa na EBM.';
  }

  @override
  String get saleReceiptCustomerCopy => 'Nakala ya mteja';

  @override
  String get saleReceiptReference => 'Kumbukumbu';

  @override
  String get saleReceiptCustomerTin => 'TIN ya mteja';

  @override
  String get saleReceiptChange => 'Chenji';

  @override
  String saleReceiptRefundedVia(String amount, String method) {
    return 'Imerejeshwa: $amount kupitia $method';
  }

  @override
  String saleReceiptReason(String reason) {
    return 'Sababu: $reason';
  }

  @override
  String get saleReceiptCard => 'Kadi';

  @override
  String get refundTransactionAlreadyRefunded =>
      'Muamala huu tayari umerejeshwa';

  @override
  String get refundCannotRefundProforma =>
      'Haiwezekani kurejesha risiti ya proforma';

  @override
  String get refundOnlyCompleted =>
      'Miamala iliyokamilika pekee ndiyo inaweza kurejeshwa';

  @override
  String get refundCreditNotFullyPaid =>
      'Mauzo ya mkopo au yaliyolipwa kwa sehemu hayawezi kurejeshwa hadi yalipwe kikamilifu';

  @override
  String get refundEnterPurchaseCodeTitle => 'Weka Msimbo wa Ununuzi';

  @override
  String get refundEnterPurchaseCodeHint => 'Weka msimbo wa ununuzi';

  @override
  String get refundNoLineItems => 'Hakuna bidhaa za kurejesha kwa muamala huu';

  @override
  String get refundAmountMustBePositive =>
      'Kiasi cha kurejesha lazima kiwe zaidi ya sifuri';

  @override
  String get refundAmountExceedsOriginal =>
      'Kiasi cha kurejesha hakiwezi kuzidi malipo ya awali';

  @override
  String get refundPartialVatUnsupported =>
      'Marejesho ya sehemu kwa EBM/VAT bado hayatumiki. Tumia marejesho kamili.';

  @override
  String get refundPurchaseCodeRequired => 'Msimbo wa ununuzi unahitajika';

  @override
  String get refundCannotRefundReceiptType =>
      'Haiwezekani kurejesha aina hii ya risiti';

  @override
  String get shiftSignOutAnyway => 'Toka hata hivyo';

  @override
  String get shiftCheckingYourShift => 'Inakagua zamu yako…';

  @override
  String get shiftCannotCloseShift => 'Haiwezekani kufunga zamu';

  @override
  String get shiftBelongsToAnotherUserSwitch =>
      'Zamu iliyo wazi ni ya mtumiaji mwingine. Muombe wakala huyo afunge zamu yake kwanza, kisha jaribu kubadilisha tena.';

  @override
  String get shiftBelongsToAnotherUserTitle => 'Zamu ni ya mtumiaji mwingine';

  @override
  String get shiftBelongsToAnotherUserSignOut =>
      'Zamu iliyo wazi ilianzishwa na wakala mwingine, hivyo haiwezi kufungwa kutoka hapa.\n\nBado unaweza kutoka. Zamu itabaki wazi ili wakala huyo aifunge.';

  @override
  String get shiftCloseToSwitchUser => 'Funga zamu ili kubadilisha mtumiaji';

  @override
  String get shiftCloseToSignOut => 'Funga zamu ili kutoka';

  @override
  String get shiftCouldNotCloseShift => 'Imeshindwa kufunga zamu';

  @override
  String shiftCouldNotCloseSignOutAnyway(String error) {
    return 'Zamu haikuweza kufungwa:\n\n$error\n\nUnaweza kutoka hata hivyo. Zamu itabaki wazi na inaweza kufungwa utakapoingia tena.';
  }

  @override
  String get shiftClosedTakingToLogin =>
      'Zamu imefungwa. Tunakupeleka kwenye skrini ya kuingia…';

  @override
  String get shiftSignOut => 'Toka';

  @override
  String get shiftNoOpenShiftContinue =>
      'Huna zamu iliyo wazi. Endelea kwenye skrini ya kuingia?';

  @override
  String get shiftSigningOut => 'Inatoka…';

  @override
  String shiftTakingTooLongRetry(String error) {
    return 'Hii inachukua muda mrefu. Angalia muunganisho wako kisha jaribu tena.\n\n$error';
  }

  @override
  String get shiftTakingTooLongSignOutAnyway =>
      'Kukagua zamu yako kunachukua muda mrefu — huenda uko nje ya mtandao.\n\nUnaweza kutoka hata hivyo. Zamu yoyote iliyo wazi itabaki wazi na inaweza kufungwa utakapoingia tena.';

  @override
  String shiftCheckFailedRetry(String error) {
    return 'Tafadhali jaribu tena. Tatizo likiendelea, angalia muunganisho wako.\n\n$error';
  }

  @override
  String shiftCheckFailedSignOutAnyway(String error) {
    return 'Zamu yako haikuweza kukaguliwa:\n\n$error\n\nUnaweza kutoka hata hivyo. Zamu yoyote iliyo wazi itabaki wazi na inaweza kufungwa utakapoingia tena.';
  }

  @override
  String get shiftCouldNotVerify => 'Imeshindwa kuthibitisha zamu';

  @override
  String endOfShiftTodaysShift(String day) {
    return 'Zamu ya leo · $day';
  }

  @override
  String get endOfShiftTitle => 'Mwisho wa zamu';

  @override
  String get endOfShiftNoOpenShift => 'Hakuna zamu iliyo wazi';

  @override
  String get endOfShiftCollected => 'Kilichokusanywa zamu hii';

  @override
  String get endOfShiftCashDrawer => 'Droo ya pesa';

  @override
  String get endOfShiftSalesCompleted => 'Mauzo yaliyokamilika';

  @override
  String get endOfShiftItemsSold => 'Bidhaa zilizouzwa';

  @override
  String get endOfShiftCloseAndSignOut => 'Funga zamu na utoke';

  @override
  String get endOfShiftSwitchBranch => 'Badilisha tawi';

  @override
  String get endOfShiftStaySignedIn => 'Endelea kuingia';

  @override
  String get endOfShiftSalesSaved =>
      'Mauzo yako yamehifadhiwa — droo itasawazishwa wakati wa kufunga.';

  @override
  String get endOfShiftAgent => 'Wakala';

  @override
  String get endOfShiftBranch => 'Tawi';

  @override
  String get signOutSigningYouOut => 'Tunakutoa…';

  @override
  String get logoutLoggingOut => 'Inatoka...';

  @override
  String get posSwitchCouldNotLoadStaff => 'Imeshindwa kupakia wafanyakazi';

  @override
  String get posSwitchNoOtherStaff =>
      'Hakuna wafanyakazi wengine wa kubadilishia.';

  @override
  String get posSwitchUserTitle => 'Badilisha Mtumiaji';

  @override
  String get posSwitchUserSubtitle => 'Chagua mfanyakazi na uweke PIN yake';

  @override
  String get posSwitchTapNameLeft =>
      'Gusa jina upande wa kushoto, kisha weka PIN yake';

  @override
  String get posSwitchTapNameAbove => 'Gusa jina hapo juu, kisha weka PIN yake';

  @override
  String get posSwitchEnterPin => 'Weka PIN ya tarakimu 6 ili kubadilisha';

  @override
  String get posSwitchWhosNext => 'Nani anafuata?';

  @override
  String get posSwitchSelectStaff => 'Chagua mfanyakazi';

  @override
  String get posSwitchStaff => 'Mfanyakazi';

  @override
  String get posSwitchCannotSwitchUser => 'Haiwezekani kubadilisha mtumiaji';

  @override
  String get posSwitchNoLinkedAccount =>
      'Mfanyakazi huyu hana akaunti ya mtumiaji iliyounganishwa.';

  @override
  String get posSwitchPinMismatch =>
      'PIN hailingani na mfanyakazi aliyechaguliwa.';

  @override
  String get posSwitchPinUnresolved =>
      'Imeshindwa kuthibitisha PIN ya mfanyakazi aliyechaguliwa.';

  @override
  String get posSwitchMissingContext =>
      'Haiwezekani kubadilisha mtumiaji bila biashara/tawi. Toka kisha ingia tena, kisha jaribu tena Kubadilisha Mtumiaji.';

  @override
  String get posSwitchCouldNotSwitch => 'Imeshindwa kubadilisha mtumiaji';

  @override
  String get posSwitchRefreshStaff => 'Onyesha upya orodha ya wafanyakazi';

  @override
  String get posSwitchSharedRegister => 'POS · Rejista ya pamoja';

  @override
  String get posSwitchNoStaffAvailable => 'Hakuna wafanyakazi wanaopatikana.';

  @override
  String get posSwitchTapYourNameLeft =>
      'Gusa jina lako upande wa kushoto, kisha weka PIN yako';

  @override
  String get posSwitchTapYourNameAbove =>
      'Gusa jina lako hapo juu, kisha weka PIN yako';

  @override
  String get posSwitchEnterYourPin =>
      'Weka PIN yako ya tarakimu 6 ili kufungua POS';

  @override
  String get posSwitchWhosServing => 'Nani anahudumia?';

  @override
  String get posSwitchWhosOnRegister => 'Nani yuko kwenye rejista?';

  @override
  String posSwitchOpeningPosFor(String name) {
    return 'Inafungua POS kwa $name…';
  }

  @override
  String get posSwitchOpeningPos => 'Inafungua POS…';

  @override
  String get orderingNoSupplierSelected => 'Hakuna msambazaji aliyechaguliwa';

  @override
  String get orderingSelectSupplierHint =>
      'Chagua msambazaji kutoka utafutaji hapo juu\nili kuona bidhaa zinazopatikana';

  @override
  String get orderingNewOrder => 'Oda Mpya';

  @override
  String get orderingPointOfSale => 'Mahali pa Mauzo';

  @override
  String get orderingTransactionHistory => 'Historia ya Miamala';

  @override
  String get orderingMoreOptions => 'Chaguo Zaidi';

  @override
  String get orderingAllProducts => 'Bidhaa zote';

  @override
  String get orderingUncategorised => 'Bila kategoria';

  @override
  String get orderingCategories => 'Kategoria';

  @override
  String get orderingLoading => 'Inapakia…';

  @override
  String get orderingFilter => 'Kichujio';

  @override
  String get orderingInStockOnly => 'Zilizo kwenye stoku pekee';

  @override
  String get orderingShowRetailMargin => 'Onyesha faida ya rejareja';

  @override
  String get orderingHidingOutOfStock =>
      'Inaficha bidhaa ambazo msambazaji hana.';

  @override
  String get orderingOutOfStockShown =>
      'Bidhaa zilizoisha bado zinaonekana, zikiwa na alama nyekundu.';

  @override
  String get orderingLastOrder => 'Oda ya mwisho';

  @override
  String get orderingNoPreviousOrder =>
      'Hakuna oda ya awali kwa msambazaji huyu.';

  @override
  String orderingLineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mistari $count',
      one: 'Mstari 1',
    );
    return '$_temp0';
  }

  @override
  String get orderingAwaitingApproval => 'inasubiri idhini';

  @override
  String get orderingApprovedLower => 'imeidhinishwa';

  @override
  String get orderingPartlyApproved => 'imeidhinishwa kwa sehemu';

  @override
  String get orderingEmpty => 'tupu';

  @override
  String orderingUnitCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vipande $count',
      one: 'Kipande 1',
    );
    return '$_temp0';
  }

  @override
  String get orderingThisOrder => 'Oda hii';

  @override
  String get orderingClearAll => 'Futa zote';

  @override
  String get orderingNoLinesYet => 'Bado hakuna mistari';

  @override
  String get orderingEmptyHintBefore => 'Tafuta bidhaa kisha bonyeza';

  @override
  String get orderingEmptyHintAfter => '— inayolingana zaidi itaonekana hapa.';

  @override
  String get orderingRemoveLine => 'Ondoa mstari';

  @override
  String orderingCostDeltaVsLast(String delta) {
    return '$delta% dhidi ya ya mwisho';
  }

  @override
  String orderingOnlyAvailable(String count) {
    return 'zinapatikana $count tu';
  }

  @override
  String get orderingOneLess => 'Agiza moja pungufu';

  @override
  String get orderingOneMore => 'Agiza moja zaidi';

  @override
  String orderingVatRate(String rate) {
    return 'VAT $rate%';
  }

  @override
  String get orderingPayWith => 'Lipa kwa';

  @override
  String get orderingSendingOrder => 'Inatuma oda…';

  @override
  String get orderingAddProductToContinue => 'Ongeza bidhaa ili kuendelea';

  @override
  String get orderingChoosePayment => 'Chagua jinsi unavyolipa';

  @override
  String orderingPlaceOrderTotal(String total) {
    return 'Weka oda · $total';
  }

  @override
  String get orderingLoadingPaymentOptions => 'Inapakia chaguo za malipo…';

  @override
  String get orderingPaymentOptionsUnavailable =>
      'Chaguo za malipo hazipatikani — oda itatumwa bila chaguo.';

  @override
  String get orderingNoPaymentOption =>
      'Hakuna chaguo la malipo lililowekwa kwa biashara hii — oda itatumwa bila chaguo.';

  @override
  String get orderingDeliveryNoteOptional =>
      'Maelezo ya uwasilishaji (si lazima)';

  @override
  String orderingOrderSentTo(String supplier) {
    return 'Oda imetumwa kwa $supplier';
  }

  @override
  String get orderingPlacedHint =>
      'Wanapokea SMS sasa; utaiona chini ya Oda zinazoingia ikishakubaliwa.';

  @override
  String get orderingStartAnotherOrder => 'Anza oda nyingine';

  @override
  String get orderingSearchProductsHint => 'Tafuta bidhaa, SKU au msimbopau…';

  @override
  String get orderingColProduct => 'Bidhaa';

  @override
  String get orderingColTheirStock => 'Stoku yao';

  @override
  String get orderingColRetailMargin => 'Rejareja · faida';

  @override
  String get orderingColOrderQty => 'Idadi ya oda';

  @override
  String get orderingStockNone => 'hakuna';

  @override
  String get orderingSupplierNoProducts =>
      'Msambazaji huyu hana bidhaa za kuagiza';

  @override
  String get orderingSupplierNoProductsHint =>
      'Hakuna kitu kwenye katalogi yao kilichoshirikiwa na tawi lako bado.';

  @override
  String get orderingNothingMatchesFilters =>
      'Hakuna kinacholingana na vichujio hivi';

  @override
  String orderingNothingMatchesQuery(String query) {
    return 'Hakuna kinacholingana na “$query”';
  }

  @override
  String get orderingNothingMatchesHint =>
      'Jaribu neno fupi zaidi, au ondoa kichujio cha zilizo kwenye stoku.';

  @override
  String get orderingCouldNotLoadCatalogue => 'Imeshindwa kupakia katalogi hii';

  @override
  String get orderingPickerTitle => 'Unaagiza kutoka kwa msambazaji gani?';

  @override
  String get orderingPickerBody =>
      'Chagua tawi unalonunua kutoka. Katalogi yao, gharama yako ya mwisho na stoku walizonazo zitapakiwa moja kwa moja kwenye oda.';

  @override
  String get orderingSearchSuppliersHint => 'Tafuta wasambazaji kwa jina…';

  @override
  String get orderingNotOnList => 'Hayupo kwenye orodha?';

  @override
  String get orderingCouldNotLoadSuppliers => 'Imeshindwa kupakia wasambazaji';

  @override
  String get orderingNoOtherBranch => 'Hakuna tawi lingine la kuagiza kutoka';

  @override
  String get orderingNoOtherBranchHint =>
      'Ongeza tawi, au tafuta msambazaji kwa jina.';

  @override
  String get orderingFrequentSuppliers =>
      'Wasambazaji unaoagiza kutoka mara nyingi';

  @override
  String get orderingBranchesYouCanOrderFrom =>
      'Matawi unayoweza kuagiza kutoka';

  @override
  String get orderingOtherBranchesYouCanOrderFrom =>
      'Matawi mengine unayoweza kuagiza kutoka';

  @override
  String orderingNoSupplierMatches(String query) {
    return 'Hakuna msambazaji anayelingana na “$query”';
  }

  @override
  String get orderingNoSupplierMatchesHint =>
      'Angalia tahajia, au waongeze kama tawi jipya.';

  @override
  String get orderingOnThisDevice => 'Kwenye kifaa hiki';

  @override
  String get orderingFoundByNameSearch => 'Wamepatikana kwa utafutaji wa jina';

  @override
  String get orderingUnnamedBranch => 'Tawi lisilo na jina';

  @override
  String get orderingAddNewSupplier => 'Ongeza msambazaji mpya';

  @override
  String get orderingThisBranch => 'Tawi hili';

  @override
  String get orderingNewPurchaseOrder => 'Oda mpya ya ununuzi';

  @override
  String get orderingShortcutSearch => 'tafuta';

  @override
  String get orderingShortcutAddTopMatch => 'ongeza inayolingana zaidi';

  @override
  String get orderingChangeSupplier => 'Badilisha msambazaji';

  @override
  String get orderingChoosePaymentBeforeSending =>
      'Chagua jinsi unavyolipa kabla ya kutuma oda.';

  @override
  String get orderingTheSupplier => 'msambazaji';

  @override
  String get orderingSearchSuppliersEllipsis => 'Tafuta wasambazaji...';

  @override
  String get orderingUnknownSupplier => 'Msambazaji Asiyejulikana';

  @override
  String get orderingNoSuppliersFound => 'Hakuna wasambazaji waliopatikana';

  @override
  String get orderingTryDifferentSearch => 'Jaribu neno lingine la utafutaji';

  @override
  String get orderingSelectSupplierFirst =>
      'Tafadhali chagua msambazaji kwanza.';

  @override
  String get orderingSupplierInvalidId =>
      'Msambazaji aliyechaguliwa ana kitambulisho batili. Tafadhali chagua msambazaji mwingine.';

  @override
  String get orderingCannotOrderFromYourself =>
      'Huwezi kuagiza kutoka kwako mwenyewe.';

  @override
  String get orderingCartIsEmpty => 'Kikapu ni tupu';

  @override
  String orderingSmsNewOrder(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Oda mpya ya bidhaa $count, jumla: $total',
      one: 'Oda mpya ya bidhaa 1, jumla: $total',
    );
    return '$_temp0';
  }

  @override
  String get orderingPlacedTitle => 'Oda Imewekwa';

  @override
  String get orderingPlacedDescription =>
      'Oda yako imeshughulikiwa na kuthibitishwa.';

  @override
  String get orderingPlacedSnack => 'Oda imewekwa';

  @override
  String get orderingCartEmptyAddProduct =>
      'Kikapu ni tupu — ongeza bidhaa kabla ya kuagiza.';

  @override
  String get createCategoryTitle => 'Unda Kategoria';

  @override
  String get createCategoryEnterName => 'Weka Jina la Kategoria';

  @override
  String get createCategoryNameHint => 'Jina la Kategoria';

  @override
  String get createLoadingEllipsis => 'Inapakia...';

  @override
  String get createSelectCategory => 'Chagua Kategoria';

  @override
  String get createAddVariation => 'Ongeza Aina';

  @override
  String get createEnterProductName => 'Weka jina la bidhaa';

  @override
  String get createNameRequired => 'Jina linahitajika';

  @override
  String get createRetailPrice => 'Bei ya Rejareja';

  @override
  String get createEnterRetailPrice => 'Weka bei ya rejareja';

  @override
  String get createRetailPriceRequired => 'Bei ya rejareja inahitajika';

  @override
  String get createShouldBeNumber => 'Inapaswa kuwa nambari';

  @override
  String get createCostPrice => 'Bei ya Gharama';

  @override
  String get createEnterCostPrice => 'Weka bei ya gharama';

  @override
  String get createCostPriceRequired => 'Bei ya gharama inahitajika';

  @override
  String get createEnterSku => 'Weka SKU';

  @override
  String get createTaxExempted => 'Imesamehewa Kodi';

  @override
  String get createFillRequiredFields => 'Jaza sehemu zote zinazohitajika';

  @override
  String get photosPickColor => 'Chagua rangi';

  @override
  String get photosSelectColorShade => 'Chagua kivuli cha rangi';

  @override
  String get photosSelectedColorShades =>
      'Rangi iliyochaguliwa na vivuli vyake';

  @override
  String get photosPickColorInstead => 'Chagua rangi badala yake';

  @override
  String get photosSavedLocally =>
      'Picha imehifadhiwa kwenye kifaa. Itapakiwa ukiwa mtandaoni.';

  @override
  String get photosAddImageOffline => 'Ongeza Picha (Nje ya mtandao)';

  @override
  String get photosAddImage => 'Ongeza Picha';

  @override
  String get photosClickToChange => 'Bofya kubadilisha picha';

  @override
  String get photosUploadImage => 'Pakia Picha';

  @override
  String get colorTileColors => 'Rangi';

  @override
  String get colorTileNewItem => 'Bidhaa Mpya';

  @override
  String get colorTileChooseLabelColor => 'Chagua rangi ya lebo';

  @override
  String get colorTilePhotoLabel => 'Lebo ya picha';

  @override
  String get colorTileTakePhoto => 'Piga Picha';

  @override
  String get categoriesSearchHint => 'Tafuta kategoria...';

  @override
  String get categoriesCreateNew => 'Unda kategoria mpya';

  @override
  String get categoriesAll => 'Kategoria zote';

  @override
  String get categoriesNoneFound => 'Hakuna kategoria zilizopatikana';

  @override
  String get unitsUnitType => 'Aina ya Kipimo';

  @override
  String get unitsNoneAvailable => 'Hakuna vipimo vinavyopatikana';

  @override
  String get unitsSelectUnit => 'Chagua Kipimo';

  @override
  String get receiveStockTitle => 'Pokea stoku';

  @override
  String get receiveStockButton => 'Pokea Stoku';

  @override
  String get receiveStockEnterValue => 'Tafadhali weka kiasi cha stoku';

  @override
  String get receiveStockAddStock => 'Ongeza Stoku';

  @override
  String get receiveStockTrackingHint =>
      'Ufuatiliaji wa stoku utawashwa kwa bidhaa zenye idadi ya stoku. Kuuzima, tembelea Dashibodi yako ya Flipper';

  @override
  String get purchaseStatusWaiting => 'Inasubiri';

  @override
  String get purchaseStatusDeclined => 'Imekataliwa';

  @override
  String get purchaseColumnNo => 'Na.';

  @override
  String get purchaseSupplyPrice => 'Bei ya Ugavi';

  @override
  String get purchaseAssignVariant => 'Unganisha Aina';

  @override
  String get purchaseSearchVariants => 'Tafuta aina...';

  @override
  String get cartPaymentsAtTillSendToManager =>
      'Malipo hukusanywa kwenye kaunta. Tuma oda hii kwa meneja.';

  @override
  String get cartTransactionNotFound => 'Muamala wa kukamilisha haukupatikana.';

  @override
  String cartSplitEnterAmountFor(String indices) {
    return 'weka kiasi kwa malipo $indices';
  }

  @override
  String cartSplitFixInvalidAmountFor(String indices) {
    return 'rekebisha kiasi batili kwa malipo $indices';
  }

  @override
  String cartSplitAmountAboveZeroFor(String indices) {
    return 'kila njia inahitaji kiasi zaidi ya sifuri (malipo $indices)';
  }

  @override
  String cartSplitMultipleMethodsInUse(String details) {
    return 'Njia nyingi za malipo zinatumika: $details.';
  }

  @override
  String get cartCreditNeedsCustomer =>
      'Jina au simu ya mteja inahitajika kwa malipo ya mkopo.';

  @override
  String get cartUnsavedOneItem =>
      'Bidhaa moja haikuweza kuhifadhiwa kwenye mauzo haya. Iondoe kwenye kikapu kisha uiongeze tena.';

  @override
  String cartUnsavedNamed(String name) {
    return '$name haikuweza kuhifadhiwa kwenye mauzo haya. Iondoe kwenye kikapu kisha uiongeze tena.';
  }

  @override
  String cartUnsavedTwo(String first, String second) {
    return '$first na $second hazikuweza kuhifadhiwa kwenye mauzo haya. Ziondoe kwenye kikapu kisha uziongeze tena.';
  }

  @override
  String cartUnsavedMany(String count, String first, String second) {
    return '$first, $second na nyingine $count hazikuweza kuhifadhiwa kwenye mauzo haya. Ziondoe kwenye kikapu kisha uziongeze tena.';
  }

  @override
  String get cartAddItemsBeforeReview =>
      'Ongeza bidhaa kwenye kikapu kabla ya kutuma kwa ukaguzi.';

  @override
  String get cartPaymentParkedAsLoan =>
      'Malipo yamerekodiwa. Muamala umewekwa kama mkopo.';

  @override
  String get cartSentForReview => 'Imetumwa kwa ukaguzi';

  @override
  String get cartPaymentSuccessful => 'Malipo Yamefanikiwa';

  @override
  String get cartPaymentConfirmationTimeout =>
      'Muda wa kuthibitisha malipo umeisha. Tafadhali jaribu tena.';

  @override
  String get errorUnableToSaveData =>
      'Imeshindwa kuhifadhi data. Tafadhali anzisha upya programu kisha jaribu tena.';

  @override
  String get errorDatabaseBusy =>
      'Hifadhidata ina shughuli. Tafadhali subiri kidogo kisha jaribu tena.';

  @override
  String get errorNoInternet =>
      'Hakuna muunganisho wa intaneti. Tafadhali angalia mtandao wako kisha jaribu tena.';

  @override
  String get errorSessionExpired => 'Kipindi kimeisha. Tafadhali ingia tena.';

  @override
  String get errorNoPermission => 'Huna ruhusa ya kufanya kitendo hiki.';

  @override
  String get errorRequestTimedOut =>
      'Muda wa ombi umeisha. Tafadhali jaribu tena.';

  @override
  String get errorPermissionDenied =>
      'Ruhusa imekataliwa. Tafadhali angalia ruhusa za programu kwenye mipangilio.';

  @override
  String get errorServerUnavailable =>
      'Seva haipatikani kwa muda. Tafadhali jaribu tena baadaye.';

  @override
  String get errorNotFound => 'Rasilimali iliyoombwa haikupatikana.';

  @override
  String get errorCheckInput =>
      'Tafadhali angalia ulichoweka kisha jaribu tena.';

  @override
  String get errorSyncUnavailable =>
      'Usawazishaji haupatikani kwa muda. Mabadiliko yako yatasawazishwa muunganisho ukirejea.';

  @override
  String get errorGenericContactSupport =>
      'Kuna hitilafu. Tafadhali jaribu tena au wasiliana na msaada tatizo likiendelea.';

  @override
  String get pickImageNoFileSelected => 'Hakuna faili lililochaguliwa.';

  @override
  String get pickImageReadFailed =>
      'Imeshindwa kusoma faili lililochaguliwa. Tafadhali jaribu tena.';

  @override
  String get pickImageNoData =>
      'Faili hilo halina data. Tafadhali chagua lingine.';

  @override
  String pickImageTooLarge(String kb) {
    return 'Tafadhali chagua picha iliyo chini ya ${kb}KB.';
  }

  @override
  String get pickImageNotReadable =>
      'Faili hilo si PNG au JPEG inayosomeka. Tafadhali chagua lingine.';

  @override
  String get posCartViewOnlyCannotAdd =>
      'Ruhusa ya kutazama tu — huwezi kuongeza bidhaa kwenye mauzo.';

  @override
  String get posCartNoActiveCart =>
      'Hakuna kikapu cha mauzo kinachotumika. Jaribu tena.';

  @override
  String get imageSourceGallery => 'Matunzio';

  @override
  String get imageSourceCamera => 'Kamera';

  @override
  String get imageSourceBrowseFiles => 'Vinjari faili';

  @override
  String get stockItemUnavailable => 'Bidhaa haipatikani';

  @override
  String get stockItemsUnavailable => 'Bidhaa hazipatikani';

  @override
  String stockNotEnoughSingle(String name) {
    return 'Hatuna $name ya kutosha kwenye stoku kukamilisha oda yako.';
  }

  @override
  String get stockRequestedQuantity => 'Idadi Iliyoombwa:';

  @override
  String get stockNotEnoughMultiple =>
      'Hatuna bidhaa hizi za kutosha kwenye stoku:';

  @override
  String stockRequestedValue(String qty) {
    return 'Iliyoombwa: $qty';
  }

  @override
  String get stockReduceOrRemoveItem =>
      'Unaweza kupunguza idadi au kuondoa bidhaa hii ili kuendelea.';

  @override
  String get stockAdjustOrRemoveItems =>
      'Unaweza kurekebisha idadi au kuondoa bidhaa hizi ili kuendelea.';

  @override
  String get stockGotIt => 'Nimeelewa';

  @override
  String get ticketCompleteEnterCustomerName =>
      'Tafadhali weka jina la mteja kabla ya kukamilisha.';

  @override
  String get ticketCompletePhoneRequiredNoTin =>
      'Nambari ya simu ya mteja inahitajika wakati hakuna TIN iliyohifadhiwa.';

  @override
  String get ticketCompleteDone => 'Tiketi imekamilika';

  @override
  String get ticketCompleteFailed => 'Imeshindwa kukamilisha tiketi';

  @override
  String get ticketCompleteInProgress => 'Inakamilisha tiketi…';

  @override
  String get hrWeekdayMonday => 'Jumatatu';

  @override
  String get hrWeekdayShortMon => 'Jtt';

  @override
  String get hrWeekdayTuesday => 'Jumanne';

  @override
  String get hrWeekdayShortTue => 'Jnn';

  @override
  String get hrWeekdayWednesday => 'Jumatano';

  @override
  String get hrWeekdayShortWed => 'Jtn';

  @override
  String get hrWeekdayThursday => 'Alhamisi';

  @override
  String get hrWeekdayShortThu => 'Alh';

  @override
  String get hrWeekdayFriday => 'Ijumaa';

  @override
  String get hrWeekdayShortFri => 'Ijm';

  @override
  String get hrWeekdaySaturday => 'Jumamosi';

  @override
  String get hrWeekdayShortSat => 'Jms';

  @override
  String get hrWeekdaySunday => 'Jumapili';

  @override
  String get hrWeekdayShortSun => 'Jpl';

  @override
  String get hrMonthJanuary => 'Januari';

  @override
  String get hrMonthShortJan => 'Jan';

  @override
  String get hrMonthFebruary => 'Februari';

  @override
  String get hrMonthShortFeb => 'Feb';

  @override
  String get hrMonthMarch => 'Machi';

  @override
  String get hrMonthShortMar => 'Mac';

  @override
  String get hrMonthApril => 'Aprili';

  @override
  String get hrMonthShortApr => 'Apr';

  @override
  String get hrMonthMay => 'Mei';

  @override
  String get hrMonthShortMay => 'Mei';

  @override
  String get hrMonthJune => 'Juni';

  @override
  String get hrMonthShortJun => 'Jun';

  @override
  String get hrMonthJuly => 'Julai';

  @override
  String get hrMonthShortJul => 'Jul';

  @override
  String get hrMonthAugust => 'Agosti';

  @override
  String get hrMonthShortAug => 'Ago';

  @override
  String get hrMonthSeptember => 'Septemba';

  @override
  String get hrMonthShortSep => 'Sep';

  @override
  String get hrMonthOctober => 'Oktoba';

  @override
  String get hrMonthShortOct => 'Okt';

  @override
  String get hrMonthNovember => 'Novemba';

  @override
  String get hrMonthShortNov => 'Nov';

  @override
  String get hrMonthDecember => 'Desemba';

  @override
  String get hrMonthShortDec => 'Des';

  @override
  String hrLongDate(String weekday, String day, String month) {
    return '$weekday, $day $month';
  }

  @override
  String hrDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Siku $count',
      one: 'Siku 1',
    );
    return '$_temp0';
  }

  @override
  String hrDaysFractional(String days) {
    return 'Siku $days';
  }

  @override
  String hrDurationMinutes(String minutes) {
    return 'dk $minutes';
  }

  @override
  String hrDurationHours(String hours) {
    return 'saa $hours';
  }

  @override
  String hrDurationHoursMinutes(String hours, String minutes) {
    return 'saa $hours dk $minutes';
  }

  @override
  String get hrGoodMorning => 'Habari za asubuhi';

  @override
  String get hrGoodAfternoon => 'Habari za mchana';

  @override
  String get hrGoodEvening => 'Habari za jioni';

  @override
  String hrGreetingWithName(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get hrAddAPerson => 'Ongeza mtu';

  @override
  String get hrApprovals => 'Idhini';

  @override
  String hrReviewRequests(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kagua maombi $count',
      one: 'Kagua ombi 1',
    );
    return '$_temp0';
  }

  @override
  String get hrAttendanceBoard => 'Ubao wa mahudhurio';

  @override
  String get hrHeadcount => 'Idadi ya wafanyakazi';

  @override
  String hrActiveCount(String count) {
    return '$count hai';
  }

  @override
  String get hrOnLeave => 'Likizoni';

  @override
  String get hrWaitingOnYou => 'Vinakusubiri';

  @override
  String get hrNeedsADecision => 'Inahitaji uamuzi';

  @override
  String get hrAllClear => 'Hakuna kinachosubiri';

  @override
  String get hrNewThisMonth => 'Wapya mwezi huu';

  @override
  String get hrMonthlyPayroll => 'Mishahara ya mwezi';

  @override
  String get hrEstimated => 'Makadirio';

  @override
  String get hrNeedsYourDecision => 'Inahitaji uamuzi wako';

  @override
  String get hrNeedsYourDecisionSubtitle =>
      'Maombi ya likizo ambayo bado hayajajibiwa';

  @override
  String get hrOpenQueue => 'Fungua foleni';

  @override
  String get hrCouldNotLoadApprovalsQueue =>
      'Imeshindwa kupakia foleni ya idhini.';

  @override
  String get hrTryAgain => 'Jaribu tena';

  @override
  String get hrNothingWaitingOnYou =>
      'Hakuna kinachokusubiri. Maombi yote yameamuliwa.';

  @override
  String hrMoreWaiting(String count) {
    return '$count zaidi zinasubiri';
  }

  @override
  String hrEmployeeWithId(String id) {
    return 'Mfanyakazi $id';
  }

  @override
  String get hrOutToday => 'Hawapo leo';

  @override
  String get hrRoster => 'Orodha';

  @override
  String get hrEveryoneIsInToday => 'Kila mtu yupo leo.';

  @override
  String get hrJoinedThisMonth => 'Waliojiunga mwezi huu';

  @override
  String get hrNobodyNewThisMonth => 'Hakuna mpya mwezi huu.';

  @override
  String get hrEmploymentFullTime => 'Muda wote';

  @override
  String get hrEmploymentPartTime => 'Muda mfupi';

  @override
  String get hrEmploymentContract => 'Mkataba';

  @override
  String get hrEmploymentIntern => 'Mwanafunzi wa mafunzo';

  @override
  String get hrEmploymentCasual => 'Kibarua';

  @override
  String get hrStatusActive => 'Hai';

  @override
  String get hrStatusSuspended => 'Amesimamishwa';

  @override
  String get hrStatusTerminated => 'Ameachishwa';

  @override
  String get hrPayMonthly => 'Kila mwezi';

  @override
  String get hrPayWeekly => 'Kila wiki';

  @override
  String get hrPayDaily => 'Kila siku';

  @override
  String get hrPayHourly => 'Kwa saa';

  @override
  String get hrPaymentBankTransfer => 'Uhamisho wa benki';

  @override
  String get hrAttendanceNotIn => 'Hayupo';

  @override
  String get hrAttendanceClockedIn => 'Ameingia';

  @override
  String get hrAttendanceClockedOut => 'Ametoka';

  @override
  String get hrAttendanceSourceSelf => 'Mwenyewe';

  @override
  String get hrAttendanceSourceManager => 'Imerekodiwa na meneja';

  @override
  String get hrLeaveStatusPending => 'Inasubiri';

  @override
  String get hrLeaveStatusRejected => 'Imekataliwa';

  @override
  String get hrLeaveStatusCancelled => 'Imeghairiwa';

  @override
  String get hrLeaveTypeAnnual => 'Likizo ya mwaka';

  @override
  String get hrLeaveTypeSick => 'Likizo ya ugonjwa';

  @override
  String get hrLeaveTypeMaternity => 'Likizo ya uzazi';

  @override
  String get hrLeaveTypePaternity => 'Likizo ya baba';

  @override
  String get hrLeaveTypeCompassionate => 'Likizo ya dharura ya kifamilia';

  @override
  String get hrLeaveTypeUnpaid => 'Likizo bila malipo';

  @override
  String hrPersonAddedToRoster(String name) {
    return '$name ameongezwa kwenye orodha.';
  }

  @override
  String hrSavedChangesTo(String name) {
    return 'Mabadiliko ya $name yamehifadhiwa.';
  }

  @override
  String hrInviteSentNotLinked(String message) {
    return 'Mwaliko umetumwa, lakini haujaunganishwa. $message';
  }

  @override
  String hrPersonIsNowStatus(String name, String status) {
    return '$name sasa ni $status.';
  }

  @override
  String hrTerminatePersonTitle(String name) {
    return 'Kumwachisha kazi $name?';
  }

  @override
  String hrTerminatePersonBody(String date) {
    return 'Siku yake ya mwisho itarekodiwa kama $date. Rekodi itabaki kwa historia ya mishahara lakini ataondolewa kwenye orodha.';
  }

  @override
  String get hrTerminate => 'Achisha kazi';

  @override
  String get hrAccessDiagnostic => 'Uchunguzi wa ufikiaji';

  @override
  String hrDiagnosticFailed(String error) {
    return 'Uchunguzi umeshindwa: $error';
  }

  @override
  String get hrPeople => 'Watu';

  @override
  String get hrEveryoneOnThisBranch => 'Kila mtu katika tawi hili';

  @override
  String hrEveryoneAtBranch(String branch) {
    return 'Kila mtu katika $branch';
  }

  @override
  String get hrAddPerson => 'Ongeza mtu';

  @override
  String get hrSearchPeopleHint => 'Tafuta jina, cheo, simu…';

  @override
  String get hrStatus => 'Hali';

  @override
  String get hrEmployed => 'Walioajiriwa';

  @override
  String get hrDepartment => 'Idara';

  @override
  String get hrAllDepartments => 'Idara zote';

  @override
  String get hrSortBy => 'Panga kwa';

  @override
  String get hrReportsTo => 'Anaripoti kwa';

  @override
  String get hrContact => 'Mawasiliano';

  @override
  String get hrTenure => 'Muda kazini';

  @override
  String get hrBasePay => 'Mshahara wa msingi';

  @override
  String hrReportsToName(String name) {
    return 'Anaripoti kwa $name';
  }

  @override
  String get hrResendHrInvite => 'Tuma tena mwaliko wa HR';

  @override
  String get hrInviteToHr => 'Alika kwenye HR';

  @override
  String get hrMarkActive => 'Weka hai';

  @override
  String get hrMarkOnLeave => 'Weka likizoni';

  @override
  String get hrSuspend => 'Simamisha';

  @override
  String get hrNoOneOnBranchYet => 'Bado hakuna mtu katika tawi hili';

  @override
  String get hrNoOneOnBranchYetMessage =>
      'Ongeza mtu wa kwanza ili kuanza kufuatilia mahudhurio, likizo na mishahara.';

  @override
  String get hrNoOneMatchesFilters => 'Hakuna anayelingana na vichujio hivi';

  @override
  String get hrClearFilters => 'Futa vichujio';

  @override
  String get hrWhyWasThisDenied => 'Kwa nini imekataliwa?';

  @override
  String hrTenureStarts(String date) {
    return 'Anaanza $date';
  }

  @override
  String hrTenureDays(String days) {
    return 'siku $days';
  }

  @override
  String hrTenureMonths(String months) {
    return 'miezi $months';
  }

  @override
  String hrTenureYears(String years) {
    return 'miaka $years';
  }

  @override
  String hrTenureYearsMonths(String years, String months) {
    return 'miaka $years miezi $months';
  }

  @override
  String get hrSortNameAsc => 'Jina (A–Z)';

  @override
  String get hrSortNameDesc => 'Jina (Z–A)';

  @override
  String get hrSortNewestHire => 'Aliyeajiriwa karibuni';

  @override
  String get hrSortLongestServing => 'Aliyehudumu muda mrefu';

  @override
  String get hrSortHighestPaid => 'Analipwa zaidi';

  @override
  String get hrEditPerson => 'Hariri mtu';

  @override
  String get hrSectionIdentity => 'Utambulisho';

  @override
  String get hrFirstName => 'Jina la kwanza';

  @override
  String get hrLastName => 'Jina la ukoo';

  @override
  String get hrEmailOptional => 'Barua pepe (si lazima)';

  @override
  String get hrNationalIdOptional => 'Kitambulisho cha taifa (si lazima)';

  @override
  String get hrRssbNumberOptional => 'Namba ya RSSB (si lazima)';

  @override
  String get hrSectionRole => 'Cheo';

  @override
  String get hrJobTitle => 'Cheo cha kazi';

  @override
  String get hrDepartmentOptional => 'Idara (si lazima)';

  @override
  String get hrEmploymentType => 'Aina ya ajira';

  @override
  String get hrStartDate => 'Tarehe ya kuanza';

  @override
  String get hrLastDayOptional => 'Siku ya mwisho (si lazima)';

  @override
  String get hrSectionPay => 'Malipo';

  @override
  String hrBasePayWithCurrency(String currency) {
    return 'Mshahara wa msingi ($currency)';
  }

  @override
  String get hrPayFrequency => 'Mzunguko wa malipo';

  @override
  String get hrAnnualLeaveDays => 'Siku za likizo ya mwaka';

  @override
  String hrAnnualLeaveDaysHelper(String days) {
    return 'Acha wazi kwa kiwango cha chini cha kisheria cha siku $days za kazi';
  }

  @override
  String get hrMobileMoneyNumber => 'Namba ya pesa kwa simu';

  @override
  String get hrMobileMoneyNumberHelper =>
      'Acha wazi ili kulipa namba ya mawasiliano iliyo juu';

  @override
  String get hrBank => 'Benki';

  @override
  String get hrAccountNumber => 'Namba ya akaunti';

  @override
  String get hrSectionNotes => 'Maelezo';

  @override
  String get hrNotesOptional => 'Maelezo (si lazima)';

  @override
  String get hrSaveChanges => 'Hifadhi mabadiliko';

  @override
  String get hrManagerNotOnRoster =>
      'Meneja wake wa sasa hayupo kwenye orodha ya tawi hili. Chagua mtu hapa ili kubadilisha.';

  @override
  String get hrManagerNobodyToChoose =>
      'Bado hakuna wa kuchagua — maombi ya likizo yanaenda kwa anayesimamia biashara.';

  @override
  String get hrManagerHelper =>
      'Maombi yake ya likizo yataenda kwa mtu huyu. Ukiacha wazi, yataenda kwa anayesimamia biashara.';

  @override
  String get hrNoManager => 'Hakuna meneja';

  @override
  String get hrFirstNameRequired => 'Jina la kwanza linahitajika';

  @override
  String get hrLastNameRequired => 'Jina la ukoo linahitajika';

  @override
  String get hrJobTitleRequired => 'Cheo cha kazi kinahitajika';

  @override
  String get hrPhoneNumberRequired => 'Namba ya simu inahitajika';

  @override
  String get hrEnterValidPhoneNumber => 'Weka namba sahihi ya simu';

  @override
  String get hrEnterValidEmail => 'Weka barua pepe sahihi';

  @override
  String hrNationalIdLength(String min, String max) {
    return 'Kitambulisho cha taifa kina herufi $min hadi $max';
  }

  @override
  String get hrStartDateTooFarAhead =>
      'Tarehe ya kuanza haiwezi kuzidi mwaka mmoja mbele';

  @override
  String get hrLastDayRequiredToTerminate =>
      'Siku ya mwisho inahitajika ili kuachisha kazi';

  @override
  String get hrLastDayBeforeStart =>
      'Siku ya mwisho haiwezi kuwa kabla ya tarehe ya kuanza';

  @override
  String get hrCannotReportToSelf => 'Mtu hawezi kuripoti kwake mwenyewe';

  @override
  String get hrPayCannotBeNegative => 'Malipo hayawezi kuwa hasi';

  @override
  String get hrLeaveDaysCannotBeNegative => 'Siku za likizo haziwezi kuwa hasi';

  @override
  String get hrLeaveDaysTooMany =>
      'Hiyo ni zaidi ya mwaka wa kazi — weka siku, si saa';

  @override
  String get hrMobileMoneyNumberRequired =>
      'Namba ya pesa kwa simu inahitajika';

  @override
  String get hrEnterValidMobileMoneyNumber =>
      'Weka namba sahihi ya pesa kwa simu';

  @override
  String get hrBankNameRequired => 'Jina la benki linahitajika';

  @override
  String get hrAccountNumberRequired => 'Namba ya akaunti inahitajika';

  @override
  String get hrPickFirstDayOfLeave => 'Chagua siku ya kwanza ya likizo.';

  @override
  String get hrPickLastDayOfLeave => 'Chagua siku ya mwisho ya likizo.';

  @override
  String get hrLastDayBeforeFirstDay =>
      'Siku ya mwisho haiwezi kuwa kabla ya siku ya kwanza.';

  @override
  String get hrLeaveTooFarAhead =>
      'Likizo haiwezi kuombwa zaidi ya mwaka mmoja mbele. Angalia mwaka wa tarehe hizi.';

  @override
  String get hrLeaveCannotStartInPast =>
      'Likizo haiwezi kuanza wakati uliopita.';

  @override
  String hrLeaveBackdatedTooFar(String days) {
    return 'Hii ilianza zaidi ya siku $days zilizopita. Muombe msimamizi wa orodha airekodi.';
  }

  @override
  String hrLeaveReasonRequired(String leaveType) {
    return 'Eleza kwa ufupi kwa nini unahitaji $leaveType.';
  }

  @override
  String get hrPickAtLeastOneDay => 'Chagua angalau siku moja.';

  @override
  String get hrPeriodAllWeekend =>
      'Kipindi hicho ni wikendi tu — chagua angalau siku moja ya kazi.';

  @override
  String hrLeaveOverlaps(String start, String end, String status) {
    return 'Hii inaingiliana na likizo uliyonayo kuanzia $start hadi $end ($status).';
  }

  @override
  String hrNoLeaveLeft(String leaveType, String year) {
    return 'Hakuna $leaveType iliyobaki kwa $year.';
  }

  @override
  String hrOnlyLeaveLeft(
    String left,
    String leaveType,
    String year,
    String requested,
  ) {
    return 'Zimebaki $left tu za $leaveType kwa $year; ombi hili linaomba $requested.';
  }

  @override
  String get hrRequestLeave => 'Omba likizo';

  @override
  String hrLeaveForName(String name) {
    return 'Likizo ya $name';
  }

  @override
  String get hrLeaveTypeField => 'Aina';

  @override
  String get hrFirstDay => 'Siku ya kwanza';

  @override
  String get hrLastDay => 'Siku ya mwisho';

  @override
  String get hrNoteOptional => 'Maelezo (si lazima)';

  @override
  String get hrReason => 'Sababu';

  @override
  String get hrSending => 'Inatuma…';

  @override
  String get hrSendRequest => 'Tuma ombi';

  @override
  String hrLeaveCostCalendarDays(String days) {
    return '$days (siku za kalenda)';
  }

  @override
  String hrLeaveCostWorkingDays(String days) {
    return '$days (siku za kazi)';
  }

  @override
  String get hrUnpaidLeaveNoLimit =>
      'likizo bila malipo haina kikomo cha mwaka';

  @override
  String hrMoreThanYouHaveLeft(String days) {
    return '$days zaidi ya ulizobaki nazo';
  }

  @override
  String hrLeftAfterThis(String days) {
    return '$days zitabaki baada ya hili';
  }

  @override
  String get hrLeaveTakenNoLimit => 'zimechukuliwa · hakuna kikomo cha mwaka';

  @override
  String hrLeaveLeftOf(String days) {
    return 'zimebaki kati ya $days';
  }

  @override
  String hrLeaveAwaitingApproval(String days) {
    return '$days zinasubiri idhini';
  }

  @override
  String get hrLeaveRequestSent =>
      'Ombi la likizo limetumwa. Utaliona hapa likishaamuliwa.';

  @override
  String get hrWithdrawRequestTitle => 'Ondoa ombi hili?';

  @override
  String hrWithdrawRequestBody(String start, String end) {
    return 'Likizo yako kuanzia $start hadi $end itaghairiwa na siku zitarudi kwenye salio lako.';
  }

  @override
  String get hrKeepIt => 'Iache';

  @override
  String get hrWithdraw => 'Ondoa';

  @override
  String get hrRequestWithdrawn => 'Ombi limeondolewa.';

  @override
  String get hrCouldNotLoadYourRecord => 'Imeshindwa kupakia rekodi yako';

  @override
  String get hrCouldNotLoadYourLeave => 'Imeshindwa kupakia likizo zako';

  @override
  String get hrMyLeave => 'Likizo zangu';

  @override
  String hrBalancesFor(String name, String year) {
    return '$name · salio za $year';
  }

  @override
  String hrRequestsGoTo(String name) {
    return 'Maombi yanaenda kwa $name';
  }

  @override
  String get hrEmploymentEndedNotice =>
      'Ajira yako imeisha, hivyo hakuna likizo mpya inayoweza kuombwa. Historia yako inabaki hapa.';

  @override
  String get hrRequests => 'Maombi';

  @override
  String get hrNoLeaveBookedYet =>
      'Bado hakuna likizo iliyoombwa. Salio zilizo juu ndizo ulizonazo mwaka huu.';

  @override
  String get hrNoEmployeeRecordTitle =>
      'Hakuna rekodi ya mfanyakazi kwa akaunti hii';

  @override
  String get hrNoEmployeeRecordLeaveBody =>
      'Likizo huombwa kwa mtu aliye kwenye orodha ya tawi, na kuingia huku bado hakuhusiani na mtu yeyote. Muombe msimamizi wa orodha yako akualike kutoka ukurasa wa Watu — hilo ndilo linaunganisha rekodi yako na akaunti hii. Ikiwa tayari amefanya hivyo, hakikisha namba ya simu kwenye rekodi yako ndiyo uliyotumia kuingia.';

  @override
  String get hrLeaveApproved => 'Likizo imeidhinishwa.';

  @override
  String get hrLeaveRejected => 'Likizo imekataliwa.';

  @override
  String get hrLeave => 'Likizo';

  @override
  String get hrWithTheirManager => 'Kwa meneja wao';

  @override
  String get hrWithTheirManagerCaption =>
      'Meneja wao bado hajajibu. Kuamua hapa ni kuamua badala yake.';

  @override
  String get hrDecided => 'Zimeamuliwa';

  @override
  String get hrNothingWaitingOnYouShort => 'Hakuna kinachokusubiri';

  @override
  String hrRequestsWaitingOnYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maombi $count yanakusubiri',
      one: 'Ombi 1 linakusubiri',
    );
    return '$_temp0';
  }

  @override
  String hrWithAnotherManager(String count) {
    return '$count kwa meneja mwingine';
  }

  @override
  String get hrYourTeam => 'Timu yako';

  @override
  String get hrApproveThisLeave => 'Idhinisha likizo hii?';

  @override
  String get hrRejectThisLeave => 'Kataa likizo hii?';

  @override
  String get hrRejectReasonLabel => 'Kwa nini? (ataona)';

  @override
  String get hrApprove => 'Idhinisha';

  @override
  String get hrReject => 'Kataa';

  @override
  String get hrOnlyTheirManagerCanAnswer =>
      'Ni meneja wao pekee anayeweza kujibu hili.';

  @override
  String get hrNoLeaveRequestsYet => 'Bado hakuna maombi ya likizo';

  @override
  String get hrNoLeaveRequestsOwnerHint =>
      'Alika watu kutoka ukurasa wa Watu ili waombe likizo wenyewe. Weka meneja wa kila mtu na maombi yake yataenda kwa meneja huyo; wasio na meneja yataletwa hapa.';

  @override
  String get hrNoLeaveRequestsManagerHint =>
      'Maombi ya wanaoripoti kwako yataonekana hapa ili uyaidhinishe.';

  @override
  String get hrErrorLoadPeopleOnBranch =>
      'Imeshindwa kupakia watu wa tawi hili.';

  @override
  String get hrErrorLoadPersonRecord =>
      'Imeshindwa kupakia rekodi ya mtu huyu.';

  @override
  String hrErrorAddPerson(String name) {
    return 'Imeshindwa kuongeza $name.';
  }

  @override
  String hrErrorSavePerson(String name) {
    return 'Imeshindwa kuhifadhi mabadiliko ya $name.';
  }

  @override
  String get hrErrorLinkAccount =>
      'Mwaliko umetumwa, lakini rekodi hii haikuweza kuunganishwa na akaunti mpya. Likizo zake hazitafanya kazi hadi iunganishwe.';

  @override
  String hrErrorChangeStatus(String status) {
    return 'Imeshindwa kubadilisha mtu huyu kuwa $status.';
  }

  @override
  String get hrThisPerson => 'mtu huyu';

  @override
  String get hrErrorLoadYourLeave => 'Imeshindwa kupakia likizo zako.';

  @override
  String get hrErrorLoadBranchLeave =>
      'Imeshindwa kupakia likizo za tawi hili.';

  @override
  String get hrErrorLoadTeamLeave => 'Imeshindwa kupakia likizo za timu yako.';

  @override
  String get hrErrorSendLeaveRequest =>
      'Imeshindwa kutuma ombi hili la likizo.';

  @override
  String get hrErrorWithdrawRequest =>
      'Imeshindwa kuondoa ombi hili. Huenda tayari limeamuliwa.';

  @override
  String get hrErrorApproveAlreadyDecided =>
      'Imeshindwa kuidhinisha ombi hili: tayari limeamuliwa au limeondolewa. Onyesha upya kuona hali yake.';

  @override
  String get hrErrorRejectAlreadyDecided =>
      'Imeshindwa kukataa ombi hili: tayari limeamuliwa au limeondolewa. Onyesha upya kuona hali yake.';

  @override
  String get hrErrorApproveRequest => 'Imeshindwa kuidhinisha ombi hili.';

  @override
  String get hrErrorRejectRequest => 'Imeshindwa kukataa ombi hili.';

  @override
  String get hrErrorLoadDayAttendance =>
      'Imeshindwa kupakia mahudhurio ya siku hii.';

  @override
  String get hrErrorLoadTimesheet => 'Imeshindwa kupakia jedwali hili la saa.';

  @override
  String get hrErrorCheckClockedIn => 'Imeshindwa kuthibitisha kama umeingia.';

  @override
  String get hrErrorCorrectEntry => 'Imeshindwa kusahihisha ingizo hili.';

  @override
  String get hrErrorServerReturnedNothing =>
      'Seva imekubali tukio lakini haijarudisha chochote cha kuonyesha.';

  @override
  String get hrErrorClockInNotAllowed => 'Huruhusiwi kumwingiza mtu huyu.';

  @override
  String get hrErrorClockOutNotAllowed => 'Huruhusiwi kumtoa mtu huyu.';

  @override
  String get hrErrorClockIn => 'Imeshindwa kuingia.';

  @override
  String get hrErrorClockOut => 'Imeshindwa kutoka.';

  @override
  String get hrErrorLoadYourTeam => 'Imeshindwa kupakia timu yako.';

  @override
  String hrErrorResolveAccess(String error) {
    return 'Imeshindwa kubaini unachoruhusiwa kufikia: $error';
  }

  @override
  String get hrRoleStaffLabel => 'Mfanyakazi — huomba likizo yake';

  @override
  String get hrRoleManagerLabel => 'Meneja — orodha na idhini';

  @override
  String get hrRoleStaff => 'Mfanyakazi';

  @override
  String get hrRoleManager => 'Meneja';

  @override
  String hrInviteTitle(String name) {
    return 'Alika $name kwenye HR';
  }

  @override
  String get hrInviteNoContact =>
      'Rekodi hii haina namba ya simu wala barua pepe, hivyo hakuna pa kutuma mwaliko. Ongeza kimoja kwanza.';

  @override
  String hrInviteWillGetPin(String contact) {
    return 'Atapata PIN ya kuingia kwenye hr.useflipper.com, itakayothibitishwa kwa msimbo uliotumwa kwa $contact.';
  }

  @override
  String get hrInviteEmailNoPhone =>
      'Rekodi hii ina barua pepe lakini haina namba ya simu. Kuingia kunahitaji msimbo kwa SMS, hivyo ongeza namba ya simu kabla ya kualika.';

  @override
  String get hrInviteAlreadyHasAccount =>
      'Tayari ana akaunti. Kumwalika tena kunatoa PIN mpya na kusasisha anachoweza kufanya — hakuundi mtu wa pili.';

  @override
  String hrInviteDirectReports(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Watu $count wanaripoti kwake, hivyo ataidhinisha likizo zao kwa jukumu lolote utakalochagua. Jukumu la meneja linaongeza orodha na mishahara ya wote.',
      one:
          'Mtu 1 anaripoti kwake, hivyo ataidhinisha likizo yake kwa jukumu lolote utakalochagua. Jukumu la meneja linaongeza orodha na mishahara ya wote.',
    );
    return '$_temp0';
  }

  @override
  String get hrInviteWhatCanTheyDo => 'Anaweza kufanya nini?';

  @override
  String get hrSendInvite => 'Tuma mwaliko';

  @override
  String get hrRoleStaffDescription =>
      'Anaona rekodi yake, anaomba likizo na kuangalia salio lake — pamoja na kuidhinisha likizo za wanaoripoti kwake.';

  @override
  String get hrRoleManagerDescription =>
      'Yote yaliyo juu, pamoja na orodha ya tawi, mishahara na kuidhinisha likizo za biashara nzima.';

  @override
  String get hrInviteSent => 'Mwaliko umetumwa';

  @override
  String hrInviteCanNowSignIn(String name, String role) {
    return '$name sasa anaweza kuingia kwenye hr.useflipper.com kama $role.';
  }

  @override
  String get hrCopyPin => 'Nakili PIN';

  @override
  String get hrPinCopied => 'PIN imenakiliwa.';

  @override
  String hrInvitePinHelp(String phone) {
    return 'Kuingia kunaomba PIN hii, kisha msimbo uliotumwa kwa $phone. Mpatie PIN sasa — haitaonyeshwa tena, na iliyopotea hubadilishwa kwa kumwalika tena.';
  }

  @override
  String get hrInviteNeedsContact =>
      'Namba ya simu au barua pepe inahitajika kabla ya kumwalika mtu huyu.';

  @override
  String hrInviteErrorAccount(String contact) {
    return 'Imeshindwa kupata au kuunda akaunti ya Flipper kwa $contact.';
  }

  @override
  String hrInviteErrorNoAccountId(String contact) {
    return 'Flipper imejibu bila kitambulisho cha akaunti kwa $contact.';
  }

  @override
  String get hrInviteErrorNoMembershipId =>
      'Uanachama umeundwa lakini Flipper haijarudisha kitambulisho chake.';

  @override
  String hrInviteErrorGrantAccess(String name, String error) {
    return 'Imeshindwa kumpa $name ufikiaji wa biashara hii: $error';
  }

  @override
  String hrInviteErrorCreatePin(String name) {
    return 'Imeshindwa kuunda PIN ya kuingia kwa $name.';
  }

  @override
  String get hrInviteErrorNoPin => 'PIN imeombwa lakini Flipper haijairudisha.';

  @override
  String get hrInviteErrorNoMembership =>
      'Akaunti imeundwa lakini haina uanachama wa biashara hii, hivyo kuingia hakutafika popote. Jaribu kumwalika mtu huyu tena.';

  @override
  String hrInviteErrorConfirmMembership(String error) {
    return 'Imeshindwa kuthibitisha uanachama mpya: $error';
  }

  @override
  String get hrInviteErrorTimeout =>
      'Flipper haijajibu kwa wakati — angalia muunganisho na ujaribu tena.';

  @override
  String get hrInviteErrorNotJson =>
      'Flipper imejibu kwa kitu ambacho si JSON:';

  @override
  String get hrEnterValidMomoNumber =>
      'Weka namba sahihi ya MTN au Airtel, mfano 0788123456.';

  @override
  String get hrMomoUnreadableReply =>
      'Lango la malipo limetuma jibu lisilosomeka.';

  @override
  String get hrMomoNoReference =>
      'Malipo yameanza lakini hakuna kumbukumbu iliyorudi — angalia taarifa yako ya Mobile Money kabla ya kujaribu tena.';

  @override
  String get hrMomoMissingReference => 'Kumbukumbu ya malipo haipo.';

  @override
  String get hrMomoRejectedInvalid =>
      'Ombi la malipo limekataliwa kuwa si sahihi.';

  @override
  String get hrMomoNotAuthorised => 'Akaunti hii haijaruhusiwa kupokea malipo.';

  @override
  String get hrMomoServiceNotFound => 'Huduma ya malipo haikupatikana.';

  @override
  String get hrMomoAlreadySubmitted => 'Malipo hayo tayari yamewasilishwa.';

  @override
  String get hrMomoUnavailable =>
      'Mobile Money haipatikani kwa sasa. Tafadhali jaribu tena baada ya muda mfupi.';

  @override
  String hrMomoCouldNotStart(String status) {
    return 'Malipo hayakuweza kuanza (HTTP $status).';
  }

  @override
  String get hrErrorCheckSubscription =>
      'Imeshindwa kuangalia usajili wa biashara hii.';

  @override
  String get hrErrorLoadPlanPrice => 'Imeshindwa kupakia bei ya mpango huu.';

  @override
  String get hrErrorStartSubscription => 'Imeshindwa kuanzisha usajili.';

  @override
  String get hrErrorSkipPayment => 'Imeshindwa kuruka malipo haya.';

  @override
  String get hrPreparingSubscription => 'Inaandaa usajili wako…';

  @override
  String hrErrorStartSubscriptionWith(String error) {
    return 'Imeshindwa kuanzisha usajili: $error';
  }

  @override
  String get hrSubscriptionAlreadyActive => 'Usajili huu tayari uko hai.';

  @override
  String get hrSendingRequestToPhone => 'Inatuma ombi kwenye simu yako…';

  @override
  String hrPaymentCouldNotStartWith(String error) {
    return 'Malipo hayakuweza kuanza: $error';
  }

  @override
  String get hrApproveMomoOnPhone =>
      'Idhinisha ombi la Mobile Money kwenye simu yako.';

  @override
  String get hrPaymentReceivedActive =>
      'Malipo yamepokelewa. Usajili wako uko hai.';

  @override
  String get hrPaymentNotCompleted => 'Malipo hayakukamilika kwenye simu yako.';

  @override
  String get hrPaymentNoVerdictYet =>
      'Bado hatujapata jibu kutoka Mobile Money. Ikiwa uliidhinisha ombi, itafunguka hivi karibuni — angalia tena baada ya muda.';

  @override
  String get hrSubscriptionEnded => 'Usajili wako umeisha';

  @override
  String get hrThisNeedsSubscription => 'Hiki kinahitaji usajili';

  @override
  String hrFeatureNeedsSubscription(String feature) {
    return '$feature kinahitaji usajili';
  }

  @override
  String get hrSubscriptionEndedBody =>
      'Hakuna kilichofutwa — orodha, likizo na mahudhurio bado vipo. Huisha usajili ili kuvifungua tena.';

  @override
  String get hrSubscriptionPitch =>
      'Flipper HR ni sehemu ya usajili wa Flipper. Lipia biashara mara moja na orodha, likizo na mahudhurio vitafunguka kwa wote.';

  @override
  String get hrPaymentOnItsWay =>
      'Malipo tayari yako njiani. Ikiwa uliyaidhinisha kwenye simu yako, itafunguka mara Mobile Money itakapothibitisha.';

  @override
  String get hrRenewNow => 'Huisha sasa';

  @override
  String get hrSeeThePlan => 'Angalia mpango';

  @override
  String get hrSubscriptionCheckFailedOpen =>
      'Imeshindwa kuangalia usajili wa biashara hii, hivyo imeachwa wazi kwa sasa.';

  @override
  String get hrTestPricingOn =>
      'Bei za majaribio zimewashwa kwa mradi huu, hivyo usajili unatozwa kiasi kilichopunguzwa.';

  @override
  String hrSkipEndsSoon(String used, String max) {
    return 'Unatumia ufikiaji wa bure bila kulipa (umetumia $used kati ya $max). Unaisha hivi karibuni.';
  }

  @override
  String hrSkipEndsToday(String used, String max) {
    return 'Unatumia ufikiaji wa bure bila kulipa (umetumia $used kati ya $max). Unaisha leo.';
  }

  @override
  String hrSkipEndsInDays(int days, String used, String max) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other:
          'Unatumia ufikiaji wa bure bila kulipa (umetumia $used kati ya $max). Unaisha baada ya siku $days.',
      one:
          'Unatumia ufikiaji wa bure bila kulipa (umetumia $used kati ya $max). Unaisha baada ya siku 1.',
    );
    return '$_temp0';
  }

  @override
  String get hrPayNow => 'Lipa sasa';

  @override
  String get hrSubscriptionEndsToday => 'Usajili wako unaisha leo.';

  @override
  String get hrSubscriptionEndsTomorrow => 'Usajili wako unaisha kesho.';

  @override
  String hrSubscriptionEndsInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Usajili wako unaisha baada ya siku $days.',
      one: 'Usajili wako unaisha baada ya siku 1.',
    );
    return '$_temp0';
  }

  @override
  String get hrRenew => 'Huisha';

  @override
  String get hrFeatureDashboard => 'Dashibodi';

  @override
  String get hrFeatureRoster => 'Orodha ya wafanyakazi';

  @override
  String get hrFeatureAttendanceBoard => 'Ubao wa mahudhurio';

  @override
  String hrErrorSkipPaymentWith(String error) {
    return 'Imeshindwa kuruka malipo haya: $error';
  }

  @override
  String get hrSkipping => 'Inaruka…';

  @override
  String hrSkipForNow(String count) {
    return 'Ruka kwa sasa (zimebaki $count)';
  }

  @override
  String get hrSubscribePickBusiness =>
      'Chagua biashara unayoilipia, kisha mpango na bei yake vitaonekana hapa.';

  @override
  String get hrChooseABusiness => 'Chagua biashara';

  @override
  String hrCouldNotLoadPlan(String error) {
    return 'Imeshindwa kupakia mpango: $error';
  }

  @override
  String get hrRenewYourSubscription => 'Huisha usajili wako';

  @override
  String get hrSubscribeToFlipper => 'Jisajili kwa Flipper';

  @override
  String get hrPeriodYearly => 'Kila mwaka';

  @override
  String hrTestPricingNormally(String amount, String period) {
    return 'Bei za majaribio zimewashwa — kawaida ni $amount $period.';
  }

  @override
  String get hrWhatBusinessIsUsing => 'Kinachotumiwa na biashara hii';

  @override
  String get hrUsagePosUsers => 'Watumiaji wa POS';

  @override
  String get hrUsageBranches => 'Matawi';

  @override
  String get hrUsageHrEmployees => 'Wafanyakazi wa HR';

  @override
  String hrUsageUnlimited(String used) {
    return '$used · bila kikomo';
  }

  @override
  String hrUsageOf(String used, String cap) {
    return '$used kati ya $cap';
  }

  @override
  String get hrMomoNumberLabel => 'Namba ya Mobile Money';

  @override
  String get hrPaymentReceived => 'Malipo yamepokelewa.';

  @override
  String get hrOpenFlipperHr => 'Fungua Flipper HR';

  @override
  String get hrPreparing => 'Inaandaa…';

  @override
  String get hrWaitingForApproval => 'Inasubiri idhini yako…';

  @override
  String hrPayWithMomo(String amount) {
    return 'Lipa $amount kwa Mobile Money';
  }

  @override
  String hrMomoPromptNote(String amount) {
    return 'Utapokea ombi la Mobile Money kwenye namba hii. Kuliidhinisha kutatoza $amount.';
  }

  @override
  String get hrPerYear => 'kwa mwaka';

  @override
  String get hrPerMonth => 'kwa mwezi';

  @override
  String get hrExpandMenu => 'Panua menyu';

  @override
  String get hrCollapseMenu => 'Kunja menyu';

  @override
  String get hrSearchPeople => 'Tafuta watu…';

  @override
  String get hrSwitchBusinessOrBranch => 'Badilisha biashara au tawi';

  @override
  String get hrSigningOut => 'Inatoka…';

  @override
  String get hrNavYou => 'Wewe';

  @override
  String get hrAttendance => 'Mahudhurio';

  @override
  String get hrMyTime => 'Muda wangu';

  @override
  String get hrPickBranchToContinue => 'Chagua tawi ili kuendelea';

  @override
  String get hrPickBranchBody =>
      'Rekodi za HR ni za tawi, hivyo chagua unalofanyia kazi.';

  @override
  String get hrChooseBusinessOrBranch => 'Chagua biashara au tawi';

  @override
  String hrCouldNotCheckSession(String error) {
    return 'Imeshindwa kuthibitisha kipindi chako: $error';
  }

  @override
  String hrCouldNotLoadBusinesses(String error) {
    return 'Imeshindwa kupakia biashara zako: $error';
  }

  @override
  String get hrBackToSignIn => 'Rudi kuingia';

  @override
  String get hrBrandTagline =>
      'Timu yako, muda wako, watu wako — vyote mahali pamoja.';

  @override
  String get hrBrandSubtitle =>
      'Mahudhurio, mishahara na likizo viko tayari mara unapoingia.';

  @override
  String get hrBrandStatEmployees => 'wafanyakazi wanaosimamiwa';

  @override
  String get hrBrandStatPayroll => 'mishahara inayoshughulikiwa kila mwezi';

  @override
  String get hrBrandStatUptime => 'muda wa upatikanaji';

  @override
  String get hrBrandPayrollThisMonth => 'Mishahara · mwezi huu';

  @override
  String get hrBrandNewHire => 'Mwajiriwa mpya';

  @override
  String get hrBrandDayOne => 'Siku 1';

  @override
  String get hrBrandAttendanceStreak => 'Mfululizo wa mahudhurio';

  @override
  String get hrClockedInToast => 'Umeingia.';

  @override
  String hrClockedOutToast(String worked) {
    return 'Umetoka — $worked leo.';
  }

  @override
  String hrYourHoursForLastDays(String days) {
    return 'Saa zako za siku $days zilizopita.';
  }

  @override
  String get hrNoRecordNoHours =>
      'Bado huna rekodi ya mfanyakazi kwenye akaunti hii, hivyo hakuna saa za kufuatilia. Muombe msimamizi wa HR akuongeze.';

  @override
  String get hrRecentDays => 'Siku za karibuni';

  @override
  String hrClockedInAt(String time) {
    return 'Umeingia saa $time';
  }

  @override
  String get hrNotClockedInToday => 'Hujaingia leo';

  @override
  String hrLastOutAt(String time) {
    return 'Ulitoka mara ya mwisho saa $time';
  }

  @override
  String get hrClockOut => 'Toka';

  @override
  String get hrClockIn => 'Ingia';

  @override
  String hrWorkedInDays(String worked, String days) {
    return '$worked kwa siku $days';
  }

  @override
  String get hrToday => 'Leo';

  @override
  String get hrOvernight => 'usiku kucha';

  @override
  String get hrNoHours => 'Hakuna saa';

  @override
  String hrSessionUntilNow(String start) {
    return '$start – sasa';
  }

  @override
  String hrBreakDuration(String duration) {
    return '$duration za mapumziko';
  }

  @override
  String hrPersonClockedIn(String name) {
    return '$name ameingia.';
  }

  @override
  String hrPersonClockedOut(String name) {
    return '$name ametoka.';
  }

  @override
  String get hrAttendanceNoOneOnBranch =>
      'Bado hakuna mtu katika tawi hili. Ongeza watu kwanza, kisha saa zao zinaweza kurekodiwa hapa.';

  @override
  String get hrOnRoster => 'Kwenye orodha';

  @override
  String get hrRecorded => 'Imerekodiwa';

  @override
  String get hrHours => 'Saa';

  @override
  String get hrChangeDay => 'Badilisha siku';

  @override
  String get hrNoHoursToday => 'Hakuna saa leo';

  @override
  String hrInAt(String time) {
    return 'Aliingia $time';
  }

  @override
  String hrOutAt(String time) {
    return 'alitoka $time';
  }

  @override
  String hrSessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vipindi $count',
      one: 'Kipindi 1',
    );
    return '$_temp0';
  }

  @override
  String get authSignIn => 'Ingia';

  @override
  String get authToContinueToAccount => 'ili kuendelea kwenye akaunti yako';

  @override
  String get authEnterYourEmail => 'Weka barua pepe yako';

  @override
  String get authPleaseEnterEmail => 'Tafadhali weka barua pepe yako';

  @override
  String get authPleaseEnterValidEmail => 'Tafadhali weka barua pepe sahihi';

  @override
  String get authPassword => 'Nenosiri';

  @override
  String get authEnterYourPassword => 'Weka nenosiri lako';

  @override
  String get authPleaseEnterPassword => 'Tafadhali weka nenosiri lako';

  @override
  String get authPasswordMinLength =>
      'Nenosiri lazima liwe na angalau herufi 6';

  @override
  String get authKeepMeSignedIn => 'Endelea kuniweka ndani';

  @override
  String get authForgotPassword => 'Umesahau nenosiri?';

  @override
  String get authNoAccountPrompt => 'Huna akaunti?';

  @override
  String get authCreateOne => 'Fungua moja';

  @override
  String get authCreateYourAccount => 'Fungua akaunti yako';

  @override
  String get authSignupSubtitle =>
      'Anza na mchakato ule ule salama wa kujisajili, sasa umeboreshwa kwa usanidi wa haraka kwenye simu.';

  @override
  String get authFullName => 'Jina kamili';

  @override
  String get authEnterFullName => 'Weka jina lako kamili';

  @override
  String get authPleaseEnterName => 'Tafadhali weka jina lako';

  @override
  String get authHidePassword => 'Ficha nenosiri';

  @override
  String get authShowPassword => 'Onyesha nenosiri';

  @override
  String get authConfirmPassword => 'Thibitisha nenosiri';

  @override
  String get authConfirmYourPassword => 'Thibitisha nenosiri lako';

  @override
  String get authPleaseConfirmPassword => 'Tafadhali thibitisha nenosiri lako';

  @override
  String get authPasswordsDoNotMatch => 'Manenosiri hayalingani';

  @override
  String get authCreateAccountButton => 'Fungua akaunti';

  @override
  String get authAlreadyHaveAccount => 'Tayari una akaunti? Ingia';

  @override
  String get authBusinessSetup => 'Usanidi wa biashara';

  @override
  String get authAuthenticator => 'Kithibitishaji';

  @override
  String get authAddAccount => 'Ongeza akaunti';

  @override
  String get authSomethingWentWrong => 'Kuna hitilafu imetokea';

  @override
  String get authUnexpectedErrorTryAgain =>
      'Hitilafu isiyotarajiwa imetokea. Tafadhali jaribu tena.';

  @override
  String get authTryAgain => 'Jaribu tena';

  @override
  String get authNoAccountsAdded => 'Hakuna akaunti iliyoongezwa';

  @override
  String get authAddFirstAccountHint =>
      'Ongeza akaunti yako ya kwanza ili kuanza kutoa misimbo ya uthibitishaji';

  @override
  String get authCodeCopied => 'Msimbo umenakiliwa';

  @override
  String get authInvalidQrCode => 'Msimbo wa QR si sahihi';

  @override
  String get authAccountAdded => 'Akaunti imeongezwa';

  @override
  String authFailedToAddAccount(String error) {
    return 'Imeshindwa kuongeza akaunti: $error';
  }

  @override
  String get personalReadyForAdventure => 'Uko tayari kwa safari?';

  @override
  String personalDayStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Siku $count mfululizo!',
      one: 'Siku 1 mfululizo!',
    );
    return '$_temp0';
  }

  @override
  String get personalTodaysProgress => 'Maendeleo ya leo';

  @override
  String personalCompletedOf(String done, String total) {
    return '$done/$total zimekamilika';
  }

  @override
  String get personalXpProgress => 'Maendeleo ya XP';

  @override
  String personalXpToday(String xp) {
    return '+$xp XP leo';
  }

  @override
  String get personalFindChallenges => 'Tafuta changamoto';

  @override
  String get personalViewRewards => 'Tazama zawadi';

  @override
  String get personalLeaderboard => 'Ubao wa viongozi';

  @override
  String get personalRecentAchievements => 'Mafanikio ya karibuni';

  @override
  String get personalOpeningAchievements => 'Inafungua mafanikio yote!';

  @override
  String get personalViewAll => 'Tazama yote';

  @override
  String get personalAchievementFirstSteps => 'Hatua za kwanza';

  @override
  String get personalAchievementExplorer => 'Mvumbuzi';

  @override
  String get personalAchievementStreakMaster => 'Bingwa wa mfululizo';

  @override
  String get personalAchievementSocialStar => 'Nyota wa kijamii';

  @override
  String get personalHowToLevelUp => 'Jinsi ya kupanda kiwango';

  @override
  String get personalDiscoverQuests => 'Gundua changamoto zilizofichwa';

  @override
  String get personalDiscoverQuestsBody =>
      'Tembelea biashara za karibu ili kufungua changamoto za siri na kupata XP ya ziada!';

  @override
  String get personalDailyChallenges => 'Kamilisha changamoto za kila siku';

  @override
  String get personalDailyChallengesBody =>
      'Dumisha mfululizo wako na upande kwenye ubao wa viongozi pamoja na marafiki!';

  @override
  String get personalTeamUp => 'Shirikiana na marafiki';

  @override
  String get personalTeamUpBody =>
      'Ungana kwa changamoto za kikundi na upate bonasi za kuzidisha!';

  @override
  String get personalAdventureBegins => 'Safari ianze! 🚀';

  @override
  String get personalStartAdventure => 'Anza safari yako!';

  @override
  String get personalSyncingAdventures => 'Inasawazisha na safari za karibu...';

  @override
  String get personalLoggingOut => 'Inatoka...';

  @override
  String get personalLoggedOut => 'Umetoka kikamilifu!';

  @override
  String personalLogoutFailed(String error) {
    return 'Kutoka kumeshindwa: $error';
  }

  @override
  String get personalCouldNotDetermineLocation =>
      'Imeshindwa kubaini mahali ulipo.';

  @override
  String get personalBusinessIdNotFound =>
      'Kitambulisho cha biashara hakikupatikana. Tafadhali ingia tena.';

  @override
  String get personalFailedToFetchChallenges => 'Imeshindwa kupata changamoto';

  @override
  String get personalFailedToFetchChallengesRetry =>
      'Imeshindwa kupata changamoto. Tafadhali jaribu tena.';

  @override
  String get personalYourRewards => 'Zawadi zako';

  @override
  String get personalRewardFreeCoffee => 'Kahawa bure';

  @override
  String get personalRewardFreeCoffeeBody =>
      'Pata kahawa bure kutoka mikahawa washirika wetu.';

  @override
  String get personalRewardDiscount => 'Punguzo la 10%';

  @override
  String get personalRewardDiscountBody =>
      'Furahia punguzo la 10% kwenye ununuzi wako ujao.';

  @override
  String get personalRewardEarlyAccess => 'Ufikiaji wa mapema';

  @override
  String get personalRewardEarlyAccessBody =>
      'Pata ufikiaji wa mapema wa vipengele vipya.';

  @override
  String get personalChallengeDiscovered => 'Changamoto imegunduliwa!';

  @override
  String get personalRewardAvailable => 'Zawadi inapatikana!';

  @override
  String get personalLater => 'Baadaye';

  @override
  String get personalClaimReward => 'Dai zawadi';

  @override
  String get personalFailedToClaimReward =>
      'Imeshindwa kudai zawadi. Tafadhali jaribu tena.';

  @override
  String get personalRewardClaimed => 'Zawadi imedaiwa kikamilifu!';

  @override
  String personalErrorLoadingRewards(String error) {
    return 'Hitilafu kupakia zawadi: $error';
  }

  @override
  String get personalChallengeClaimed => 'Changamoto imedaiwa';

  @override
  String personalClaimedOn(String date) {
    return 'Imedaiwa tarehe $date';
  }

  @override
  String personalBusinessLabel(String business) {
    return 'Biashara: $business';
  }

  @override
  String personalRewardLabel(String reward) {
    return 'Zawadi: $reward';
  }

  @override
  String get personalSpecialReward => 'Zawadi maalum';

  @override
  String get personalClaim => 'Dai';

  @override
  String get personalNoChallengesNearby =>
      'Hakuna changamoto karibu. Jaribu kuzunguka!';

  @override
  String get personalTapToDiscover => 'Gusa ili kugundua changamoto za karibu';

  @override
  String get personalTapToSearchAgain => 'Gusa ili kutafuta tena';

  @override
  String get personalSearchingChallenges => 'Inatafuta changamoto za karibu...';

  @override
  String get personalChallengesFound => 'Changamoto zimepatikana!';

  @override
  String personalNearbyRewards(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zawadi $count karibu',
      one: 'Zawadi 1 karibu',
    );
    return '$_temp0';
  }

  @override
  String get personalChallengeClaimedToast =>
      'Changamoto imedaiwa kikamilifu! 🎉';

  @override
  String personalFailedToClaimChallenge(String error) {
    return 'Imeshindwa kudai changamoto: $error';
  }

  @override
  String get manualPurchaseSellPrice => 'Bei ya kuuza';

  @override
  String get cashbookSelectDates => 'Chagua tarehe';

  @override
  String get cashbookSaveCashIn => 'Hifadhi pesa zilizoingia';

  @override
  String get cashbookSaveCashOut => 'Hifadhi pesa zilizotoka';

  @override
  String get cashbookNewEntry => 'Mpya';

  @override
  String get cashbookEnterValidAmount => 'Tafadhali weka kiasi sahihi';

  @override
  String get cashbookToday => 'Leo';

  @override
  String get cashbookYesterday => 'Jana';

  @override
  String get cashbookListNoMovements => 'Bado hakuna miamala ya pesa';

  @override
  String cashbookListNoFilterEntries(String filter) {
    return 'Hakuna maingizo ya $filter';
  }

  @override
  String get cashbookListEmptyHint =>
      'Rekodi pesa zinazoingia au kutoka kwa vitufe vilivyo hapa chini.';

  @override
  String cashbookListNothingMatches(String period) {
    return 'Hakuna kinacholingana na kichujio hiki kwa $period.';
  }

  @override
  String get cashbookViewAll => 'Tazama zote';

  @override
  String get cashbookMoneyInLabel => 'Pesa zilizoingia';

  @override
  String get cashbookMoneyOutLabel => 'Pesa zilizotoka';

  @override
  String get manualPurchaseSellingPriceOptional => 'Bei ya kuuza (si lazima)';

  @override
  String get txDetailCategory => 'Aina';

  @override
  String get txDetailNote => 'Maelezo';

  @override
  String get manualPurchaseSellAtCostHelper =>
      'Acha tupu ili kuuza kwa bei ya gharama';

  @override
  String get scannerAlignQrCode => 'Weka msimbo wa QR ndani ya fremu';

  @override
  String get scannerInstructionSelling =>
      'Changanua msimbopau wa bidhaa ili kuiongeza kwenye kikapu';

  @override
  String get scannerInstructionAttendance =>
      'Changanua msimbo wa QR wa mahudhurio ili kujiandikisha';

  @override
  String get scannerInstructionLogin =>
      'Changanua msimbo wa QR ili kuingia kwenye akaunti yako';

  @override
  String get scannerScanning => 'Inachanganua...';

  @override
  String get scannerStatusProcessing => 'Inashughulikia';

  @override
  String get scannerSendingLoginToDesktop =>
      'Inatuma kuingia kwenye kompyuta...';

  @override
  String get scannerWaitingForDesktop => 'Inasubiri kompyuta';

  @override
  String get scannerLoginSentCompleting =>
      'Kuingia kumetumwa — kunakamilika kwenye kompyuta yako...';

  @override
  String get scannerScanSuccessful => 'Uchanganuzi umefaulu';

  @override
  String get scannerQrProcessedSuccessfully => 'Msimbo wa QR umeshughulikiwa';

  @override
  String get scannerLoginSuccessful => 'Umeingia kikamilifu';

  @override
  String get scannerDesktopAuthenticated => 'Kompyuta imethibitishwa';

  @override
  String get scannerLoginFailed => 'Kuingia kumeshindikana';

  @override
  String get scannerCouldNotAuthenticateDesktop =>
      'Imeshindwa kuthibitisha kompyuta';

  @override
  String get scannerQrCodeDetected => 'Msimbo wa QR umegunduliwa';

  @override
  String get scannerProcessingRequest => 'Tunashughulikia ombi lako...';

  @override
  String get scannerHelpTitle => 'Msaada wa kichanganuzi';

  @override
  String get scannerHelpPositionCode => 'Weka msimbo ndani ya fremu';

  @override
  String get scannerHelpWellLit =>
      'Hakikisha kuna mwanga wa kutosha na hauna ukungu';

  @override
  String get scannerHelpUseFlash => 'Tumia mwako kwenye mwanga hafifu';

  @override
  String get scannerHelpToggleFlash => 'Gusa aikoni ya mwako iliyo chini';

  @override
  String get scannerHelpCleanLens => 'Safisha lenzi ya kamera yako';

  @override
  String get scannerHelpBetterResults => 'Kwa matokeo bora ya uchanganuzi';

  @override
  String get scannerTitleProduct => 'Kichanganuzi cha bidhaa';

  @override
  String get scannerTitleAttendance => 'Kichanganuzi cha mahudhurio';

  @override
  String get scannerTitleLogin => 'Kichanganuzi cha kuingia';

  @override
  String get scannerTitleQr => 'Kichanganuzi cha QR';

  @override
  String get scannerGalleryComingSoon =>
      'Kuchagua kutoka matunzio kunakuja hivi karibuni';

  @override
  String get scannerInvalidQrFormat => 'Muundo wa msimbo wa QR si sahihi';

  @override
  String scannerLoginError(String error) {
    return 'Hitilafu ya kuingia: $error';
  }

  @override
  String get scannerDesktopNoResponse =>
      'Kompyuta haikujibu — hakikisha iko kwenye skrini ya kuingia kwa QR';

  @override
  String get scannerDesktopSelectBusiness =>
      'Kompyuta imeingia — chagua biashara yako huko';

  @override
  String get scannerDesktopLoginSuccessful =>
      'Kuingia kwenye kompyuta kumefaulu';

  @override
  String get scannerDesktopLoginFailed =>
      'Kuingia kwenye kompyuta kumeshindikana';

  @override
  String get dialogGotIt => 'Nimeelewa';

  @override
  String get socialsRequestEarlyAccess => 'Omba ufikiaji wa mapema';

  @override
  String get socialsEarlyAccessHint =>
      'Weka barua pepe yako, nambari ya simu na ujumbe wa kwa nini unataka kujiunga!';

  @override
  String get socialsPleaseEnterMessage => 'Tafadhali weka ujumbe';

  @override
  String get socialsThanksForInterest => 'Asante kwa kuonyesha nia';

  @override
  String get socialsThanksWeWillGetBack =>
      'Asante kwa kuonyesha nia, tutawasiliana nawe hivi karibuni';

  @override
  String get socialsExpressInterest => 'Onyesha nia';

  @override
  String get appInitStepFirebase => 'Inaunganisha huduma';

  @override
  String get appInitStepLocator => 'Inaandaa programu';

  @override
  String get appInitStepPlatform => 'Inaweka mipangilio ya kifaa';

  @override
  String get appInitStepDiagnostics => 'Inaweka uchunguzi';

  @override
  String get appInitStepDatabase => 'Inafungua hifadhidata ya ndani';

  @override
  String get appInitStepServices => 'Inapakia huduma';

  @override
  String get appInitStepAnalytics => 'Inaanzisha takwimu';

  @override
  String get appInitStepCloudStorage => 'Inaunganisha hifadhi ya wingu';

  @override
  String get appInitStepSync => 'Inaandaa usawazishaji';

  @override
  String get appInitStepFinishing => 'Inakamilisha';

  @override
  String get appInitStepStartup => 'Kuanzisha';

  @override
  String get appInitFailedTitle => 'Kuanzisha kumeshindikana';

  @override
  String appInitFailedMessage(String step) {
    return 'Programu imeshindwa kumaliza kuanza katika hatua \"$step\". Gusa Jaribu tena — itaendelea kutoka hatua hiyo.';
  }

  @override
  String get appInitTryAgain => 'Jaribu tena';

  @override
  String get appInitCopyErrorDetails => 'Nakili maelezo ya hitilafu';

  @override
  String get appInitTechnicalDetails => 'Maelezo ya kiufundi';

  @override
  String get paywallRailMobileMoney => 'Pesa kwa simu';

  @override
  String get paywallRailCard => 'Kadi';

  @override
  String get paywallRailMomoDescription =>
      'Idhinisha kwenye simu yako kwa MTN MoMo';

  @override
  String get paywallRailCardDescription => 'Lipa kwa Visa au Mastercard';

  @override
  String get paywallCadenceDaily => 'Kila siku';

  @override
  String get paywallCadenceMonthly => 'Kila mwezi';

  @override
  String get paywallCadenceYearly => 'Kila mwaka';

  @override
  String get paywallPeriodDay => '/siku';

  @override
  String get paywallPeriodMonth => '/mwezi';

  @override
  String get paywallPeriodYear => '/mwaka';

  @override
  String paywallPaidInFull(String amount) {
    return 'Malipo kamili — makato moja ya RWF $amount.';
  }

  @override
  String paywallInstallmentsEach(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Malipo $count ya RWF $amount kila moja.',
      one: 'Malipo 1 ya RWF $amount.',
    );
    return '$_temp0';
  }

  @override
  String paywallPricePerMonthBilledYearly(String amount) {
    return '$amount RWF/mwezi · hulipwa kila mwaka';
  }

  @override
  String paywallPricePerDay(String amount) {
    return '$amount RWF/siku';
  }

  @override
  String paywallPricePerMonth(String amount) {
    return '$amount RWF/mwezi';
  }

  @override
  String get paywallCardPayment => 'Malipo kwa kadi';

  @override
  String get paywallTestMode => 'HALI YA MAJARIBIO';

  @override
  String get paywallCardRedirectInfo =>
      'Utapelekwa kwenye ukurasa salama wa malipo ili kuweka maelezo ya Visa au Mastercard yako. Rudi hapa ukimaliza — mpango utaanza wenyewe.';

  @override
  String get paywallReceiptEmail => 'Barua pepe ya risiti';

  @override
  String get paywallReceiptEmailHint =>
      'Ankara na risiti za kadi hutumwa hapa.';

  @override
  String get paywallCardDiscountApplies =>
      'Punguzo lako linatumika kwa malipo ya kadi: kadi inatozwa bei iliyopunguzwa sasa na kila inaposasishwa.';

  @override
  String paywallCardDiscountAppliesAmount(String amount) {
    return 'Punguzo lako linatumika: kadi inatozwa $amount sasa na kila inaposasishwa.';
  }

  @override
  String get paywallDiscountMomoOnly =>
      'Misimbo ya punguzo inatumika kwa malipo ya pesa kwa simu pekee. Kulipa kwa kadi hutoza bei kamili ya mpango.';

  @override
  String get paywallPendingCheckout =>
      'Ukurasa wa malipo tayari unasubiri mpango huu. Ufungue ili kumaliza — mpya haitaubadilisha.';

  @override
  String get paywallOpenPaymentPage => 'Fungua ukurasa wa malipo';

  @override
  String get paywallDiscountHint => 'Weka msimbo kama unavyoonekana hasa.';

  @override
  String get paywallNeedHelp => 'Unahitaji msaada?';

  @override
  String get paywallChatWithSupport =>
      'Ongea na huduma kwa wateja kuhusu malipo haya';

  @override
  String get paywallMomoPayment => 'Malipo kwa pesa kwa simu';

  @override
  String paywallProcessedUsing(String provider) {
    return 'Malipo yatashughulikiwa kwa kutumia $provider.';
  }

  @override
  String get paywallUseDifferentNumber => 'Tumia nambari nyingine ya simu';

  @override
  String get paywallTryAnotherNumber =>
      'Jaribu nambari nyingine ya MTN ikiwa hii imeshindikana';

  @override
  String get paywallMomoNumberRule => 'Lazima ianze na 250 78 au 250 79.';

  @override
  String get paywallProcessing => 'Inashughulikia…';

  @override
  String paywallSecurePaymentVia(String provider) {
    return 'Malipo salama kupitia $provider';
  }

  @override
  String get paywallHowToPay => 'Ungependa kulipa vipi?';

  @override
  String get paywallLoading => 'Inapakia…';

  @override
  String paywallPercentOff(String percent) {
    return '(punguzo $percent%)';
  }

  @override
  String get paywallSplitIntoPayments => 'Gawanya katika malipo';

  @override
  String get paywallPaymentSummary => 'Muhtasari wa malipo';

  @override
  String get paywallTotal => 'Jumla';

  @override
  String get paywallSubscriptionEnded =>
      'Usajili huu umeisha. Chagua mpango ili kuanza tena.';

  @override
  String get paywallPaymentPageNotReady =>
      'Ukurasa wa malipo bado haujawa tayari. Jaribu tena baada ya muda mfupi.';

  @override
  String get paywallCouldNotOpenPageCopyLink =>
      'Imeshindwa kufungua ukurasa wa malipo kwenye kifaa hiki. Nakili kiungo, au lipa kwa pesa kwa simu badala yake.';

  @override
  String get paywallCouldNotOpenPage =>
      'Imeshindwa kufungua ukurasa wa malipo kwenye kifaa hiki.';

  @override
  String get paywallServiceNoResponse =>
      'Huduma ya malipo haikujibu. Angalia muunganisho wako na ujaribu tena.';

  @override
  String get paywallServiceUnreachable =>
      'Imeshindwa kufikia huduma ya malipo. Angalia muunganisho wako na ujaribu tena.';

  @override
  String get paywallBusinessRequiredForCard =>
      'Biashara inahitajika ili kuanzisha usajili wa kadi.';

  @override
  String get paywallCardStartedNoReference =>
      'Usajili wa kadi umeanza lakini hakuna kumbukumbu iliyotumwa. Angalia skrini ya malipo kabla ya kujaribu tena.';

  @override
  String get paywallNoCardUpdateLink =>
      'Hakuna kiungo cha kusasisha kadi kilichorudishwa.';

  @override
  String get paywallNoPortalLink =>
      'Hakuna kiungo cha tovuti ya malipo kilichorudishwa.';

  @override
  String get paywallCardNotAuthorised =>
      'Malipo kwa kadi hayaruhusiwi kwenye huduma hii.';

  @override
  String get paywallCardUnavailable =>
      'Malipo kwa kadi hayapatikani kwa sasa. Tumia pesa kwa simu, au jaribu tena baadaye.';

  @override
  String paywallCouldNotAction(String action, String status) {
    return 'Imeshindwa $action (HTTP $status).';
  }

  @override
  String paywallUnreadableReply(String status) {
    return 'Huduma ya malipo imetuma jibu lisilosomeka (HTTP $status).';
  }

  @override
  String get paywallActionStartCardSubscription => 'kuanzisha usajili wa kadi';

  @override
  String get paywallActionReadCardSubscription => 'kusoma usajili wa kadi';

  @override
  String get paywallActionRefreshCardSubscription =>
      'kuonyesha upya usajili wa kadi';

  @override
  String get paywallActionGetCardLink => 'kupata kiungo kipya cha kadi';

  @override
  String get paywallActionOpenBillingPortal => 'kufungua tovuti ya malipo';

  @override
  String get paywallActionCancelCardSubscription => 'kughairi usajili wa kadi';

  @override
  String get paywallActionStartCustomPayment => 'kuanzisha malipo maalum';

  @override
  String get paywallActionReadCustomPayment => 'kusoma malipo maalum';

  @override
  String get paywallActionListCustomPayments => 'kuorodhesha malipo maalum';

  @override
  String get paywallEnterAmountAboveZero => 'Weka kiasi kikubwa kuliko sifuri.';

  @override
  String get paywallEnterValidMomoNumber =>
      'Weka nambari sahihi ya pesa kwa simu, mfano 0788123456.';

  @override
  String paywallPaymentNotStarted(String status) {
    return 'Malipo hayakuweza kuanzishwa (HTTP $status).';
  }

  @override
  String paywallGatewayUnreadable(String status) {
    return 'Lango la malipo limetuma jibu lisilosomeka (HTTP $status).';
  }

  @override
  String get paywallStartedNoReference =>
      'Malipo yameanza lakini hakuna kumbukumbu iliyorudi — angalia taarifa ya MoMo kabla ya kujaribu tena.';

  @override
  String paywallPreApprovalFailed(String status) {
    return 'Idhini ya awali imeshindikana (HTTP $status).';
  }

  @override
  String get paywallRequestRejected => 'Ombi la malipo limekataliwa.';

  @override
  String get paywallDeviceNotAuthorised =>
      'Kifaa hiki hakiruhusiwi kupokea malipo.';

  @override
  String get paywallServiceNotFound => 'Huduma ya malipo haikupatikana.';

  @override
  String get paywallAlreadySubmitted => 'Malipo hayo tayari yamewasilishwa.';

  @override
  String get paywallMomoUnavailableNow =>
      'Pesa kwa simu haipatikani kwa sasa. Tafadhali jaribu tena baada ya muda mfupi.';

  @override
  String get paywallMomoNotSetUp =>
      'Pesa kwa simu bado haijawekwa kwenye kifaa hiki.';

  @override
  String get paywallNotCompletedOnPhone =>
      'Malipo hayakukamilishwa kwenye simu ya mlipaji.';

  @override
  String get paywallNoConfirmationYet =>
      'Bado hakuna uthibitisho. Malipo yanaweza bado kupita — angalia taarifa ya MoMo kabla ya kutoza tena.';

  @override
  String get paywallConsentDeclined =>
      'Idhini ya pesa kwa simu imekataliwa, kwa hivyo hakuna kilichotozwa. Idhinisha ombi kwenye simu yako na ujaribu tena.';

  @override
  String get paywallChooseBusinessFirst => 'Chagua biashara kwanza.';

  @override
  String get paywallAmountAboveZero =>
      'Kiasi lazima kiwe kikubwa kuliko sifuri.';

  @override
  String get paywallCustomerMomoRequired =>
      'Nambari ya pesa kwa simu ya mteja inahitajika.';

  @override
  String get paywallStaffNotAuthorised =>
      'Akaunti hii hairuhusiwi kwa malipo ya wafanyakazi.';

  @override
  String get paywallAlreadyCollecting =>
      'Tayari kuna malipo yanayokusanywa kutoka kwa biashara hii.';

  @override
  String get paywallStaffNotConfigured =>
      'Malipo ya wafanyakazi hayajawekwa kwenye huduma hii.';

  @override
  String accountingShiftUser(String id) {
    return 'Mtumiaji: $id';
  }

  @override
  String get accountingShiftHistory => 'Historia ya zamu';

  @override
  String get accountingLoadingShiftHistory => 'Inapakia historia ya zamu...';

  @override
  String get accountingNoMatchingShifts => 'Hakuna zamu zinazolingana';

  @override
  String get accountingNoShiftsFound => 'Hakuna zamu zilizopatikana';

  @override
  String get accountingAdjustFiltersHint =>
      'Jaribu kubadilisha vichujio au utafutaji wako.';

  @override
  String get accountingNoShiftsHint =>
      'Rekodi za zamu zitaonekana hapa utakapoanza\nkusimamia zamu zako.';

  @override
  String get accountingClearFilters => 'Futa vichujio';

  @override
  String accountingCashSalesRange(String currency) {
    return 'KIWANGO CHA MAUZO YA TASLIMU ($currency)';
  }

  @override
  String get accountingFilterShifts => 'Chuja zamu';

  @override
  String get accountingDateRange => 'KIPINDI CHA TAREHE';

  @override
  String get accountingFrom => 'Kuanzia';

  @override
  String get accountingTo => 'Hadi';

  @override
  String get accountingStatusLabel => 'HALI';

  @override
  String get accountingAllShifts => 'Zamu zote';

  @override
  String get accountingShiftOpen => 'Wazi';

  @override
  String get accountingShiftClosed => 'Imefungwa';

  @override
  String get accountingMinimum => 'Kiwango cha chini';

  @override
  String get accountingMaximum => 'Kiwango cha juu';

  @override
  String get accountingNoLimit => 'Bila kikomo';

  @override
  String get accountingSortBy => 'PANGA KWA';

  @override
  String get accountingNewestFirst => 'Mpya kwanza';

  @override
  String get accountingOldestFirst => 'Za zamani kwanza';

  @override
  String get accountingCashSalesHighToLow =>
      'Mauzo ya taslimu — juu hadi chini';

  @override
  String get accountingCashSalesLowToHigh =>
      'Mauzo ya taslimu — chini hadi juu';

  @override
  String get accountingClearAll => 'Futa yote';

  @override
  String get accountingApplyFilters => 'Tumia vichujio';

  @override
  String get accountingDatePlaceholder => 'mm/ss/mmmm';

  @override
  String get accountingTotalShifts => 'JUMLA YA ZAMU';

  @override
  String get accountingTotalCashSales => 'JUMLA YA MAUZO YA TASLIMU';

  @override
  String get accountingOpenClosed => 'WAZI / IMEFUNGWA';

  @override
  String get accountingSearchShiftsHint =>
      'Tafuta kwa kitambulisho cha mtumiaji au tarehe...';

  @override
  String accountingShowingShifts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Inaonyesha zamu $count',
      one: 'Inaonyesha zamu 1',
    );
    return '$_temp0';
  }

  @override
  String accountingStartedAt(String time) {
    return 'Ilianza $time';
  }

  @override
  String accountingCashDifference(String amount) {
    return 'Tofauti ya taslimu: $amount';
  }

  @override
  String get accountingTimePeriod => 'KIPINDI';

  @override
  String get accountingStartTime => 'Muda wa kuanza';

  @override
  String get accountingEndTime => 'Muda wa kumaliza';

  @override
  String accountingDuration(String duration) {
    return 'Muda: $duration';
  }

  @override
  String get accountingInProgress => 'Inaendelea';

  @override
  String get accountingFinancialSummary => 'MUHTASARI WA FEDHA';

  @override
  String get accountingOpeningBalance => 'Salio la kufungua';

  @override
  String get accountingCashSales => 'Mauzo ya taslimu';

  @override
  String get accountingExpectedCash => 'Taslimu inayotarajiwa';

  @override
  String get accountingClosingBalance => 'Salio la kufunga';

  @override
  String get uiAdminPinMismatch => 'PIN hazilingani. Jaribu tena.';

  @override
  String uiAdminPinIncorrect(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'PIN si sahihi. Yamebaki majaribio $count.',
      one: 'PIN si sahihi. Imebaki jaribio 1.',
    );
    return '$_temp0';
  }

  @override
  String get uiAdminPinSaveFailed =>
      'Imeshindwa kuhifadhi PIN. Tafadhali jaribu tena.';

  @override
  String get uiAdminPinSaved => 'PIN imehifadhiwa';

  @override
  String get uiAdminPinEnter => 'Weka PIN ya msimamizi';

  @override
  String get uiAdminPinConfirm => 'Thibitisha PIN yako';

  @override
  String get uiAdminPinSetUp => 'Weka PIN ya msimamizi';

  @override
  String get uiAdminPinSavedSubtitle =>
      'Vitendo nyeti sasa vinahitaji PIN hii.';

  @override
  String get uiAdminPinVerifySubtitle =>
      'Kitendo hiki kinalindwa. Weka PIN yako ya msimamizi ya tarakimu 4.';

  @override
  String get uiAdminPinConfirmSubtitle =>
      'Weka tarakimu 4 zilezile tena ili kuthibitisha.';

  @override
  String get uiAdminPinSetSubtitle =>
      'Chagua PIN ya tarakimu 4 kulinda uhariri, ufutaji na mipangilio.';

  @override
  String uiAdminPinDigitsSemantic(String entered, String total) {
    return 'PIN, tarakimu $entered kati ya $total zimewekwa';
  }

  @override
  String uiAdminPinLockout(String seconds) {
    return 'Majaribio mengi mno. Jaribu tena baada ya sekunde $seconds.';
  }

  @override
  String get uiAdminPinStartOver => 'Anza upya';

  @override
  String get uiMonthShortJan => 'Jan';

  @override
  String get uiMonthShortFeb => 'Feb';

  @override
  String get uiMonthShortMar => 'Mac';

  @override
  String get uiMonthShortApr => 'Apr';

  @override
  String get uiMonthShortMay => 'Mei';

  @override
  String get uiMonthShortJun => 'Jun';

  @override
  String get uiMonthShortJul => 'Jul';

  @override
  String get uiMonthShortAug => 'Ago';

  @override
  String get uiMonthShortSep => 'Sep';

  @override
  String get uiMonthShortOct => 'Okt';

  @override
  String get uiMonthShortNov => 'Nov';

  @override
  String get uiMonthShortDec => 'Des';

  @override
  String get uiTicketResumeOrder => 'Endelea na oda';

  @override
  String get uiTicketResuming => 'Inaendelea…';

  @override
  String get uiTicketCustomerSection => 'MTEJA';

  @override
  String uiTicketItemsSection(String count) {
    return 'BIDHAA · $count';
  }

  @override
  String uiTicketCouldNotLoadItems(String error) {
    return 'Imeshindwa kupakia bidhaa: $error';
  }

  @override
  String get uiTicketStatusSection => 'HALI';

  @override
  String get uiTicketResumeTicket => 'Endelea na tiketi';

  @override
  String get uiTicketWalkIn => 'Mteja wa papo hapo';

  @override
  String get uiTicketLoan => 'Mkopo';

  @override
  String get uiTicketNoItems => 'Hakuna bidhaa kwenye tiketi hii.';

  @override
  String uiTicketPaymentsSection(String count) {
    return 'MALIPO · $count';
  }

  @override
  String get uiTicketTotalPaidSoFar => 'Jumla iliyolipwa hadi sasa';

  @override
  String get uiTicketStillDue => 'Bado inadaiwa';

  @override
  String get uiTicketUnknown => 'Haijulikani';

  @override
  String uiTicketPaymentLine(String index, String method) {
    return 'Malipo $index · $method';
  }

  @override
  String uiTicketPaidBy(String name) {
    return 'Imelipwa na $name';
  }

  @override
  String get uiTicketStatusWaiting => 'Inasubiri';

  @override
  String get uiTicketStatusInProgress => 'Inaendelea';

  @override
  String get uiTicketStatusCompleted => 'Imekamilika';

  @override
  String get uiTicketBadgeInProgress => 'INAENDELEA';

  @override
  String get uiTicketBadgeCompleted => 'IMEKAMILIKA';

  @override
  String get uiTicketBadgeParked => 'IMESIMAMISHWA';

  @override
  String get uiTicketDateNotRecorded => 'Tarehe haijarekodiwa';

  @override
  String uiTicketTodayAt(String time) {
    return 'Leo · $time';
  }

  @override
  String uiTicketYesterdayAt(String time) {
    return 'Jana · $time';
  }

  @override
  String get uiTicketParkTransaction => 'Simamisha muamala';

  @override
  String get uiTicketParking => 'Inasimamisha…';

  @override
  String uiTicketParkFailed(String error) {
    return 'Imeshindwa kusimamisha muamala: $error';
  }

  @override
  String get uiTicketAttachCustomer => 'Ambatisha mteja';

  @override
  String get uiTicketSearchCustomers => 'Tafuta wateja…';

  @override
  String get uiTicketNoCustomer => 'Hakuna mteja';

  @override
  String get uiTicketName => 'Jina la tiketi';

  @override
  String get uiTicketEnterName => 'Weka jina la tiketi';

  @override
  String get uiTicketNotes => 'Maelezo';

  @override
  String get uiTicketOptional => 'Si lazima';

  @override
  String get uiTicketAddNotes => 'Ongeza maelezo';

  @override
  String get uiTicketPaymentDue => 'Malipo yanadaiwa';

  @override
  String get uiTicketSendToKitchen => 'Tuma jikoni';

  @override
  String get uiTicketShowOnKds => 'Onyesha tiketi hii kwenye skrini ya jikoni';

  @override
  String get uiTicketSelectCustomer => 'Chagua mteja';

  @override
  String get uiTicketMarkAsLoan => 'Weka kama mkopo';

  @override
  String get uiTicketTrackPaymentLater =>
      'Fuatilia malipo ya kukusanywa baadaye';

  @override
  String get uiTicketOneWeek => 'Wiki 1';

  @override
  String get uiTicketTwoWeeks => 'Wiki 2';

  @override
  String get uiTicketOneMonth => 'Mwezi 1';

  @override
  String get uiTicketSelectDate => 'Chagua tarehe';

  @override
  String get uiTicketDueDate => 'Tarehe ya mwisho';

  @override
  String get uiTicketHoldSale => 'Hifadhi mauzo haya ili kumaliza baadaye';

  @override
  String get uiWorkOrderUnknownProduct => 'Bidhaa isiyojulikana';

  @override
  String uiWorkOrderId(String id) {
    return 'Kitambulisho: $id';
  }

  @override
  String get uiWorkOrderStart => 'Anza';

  @override
  String get uiWorkOrderRecordOutput => 'Rekodi uzalishaji';

  @override
  String get uiWorkOrderCompleted => 'Imekamilika';

  @override
  String get uiWorkOrderInProgress => 'Inaendelea';

  @override
  String get uiWorkOrderPlanned => 'Imepangwa';

  @override
  String get uiWorkOrderActual => 'Halisi';

  @override
  String get uiWorkOrderVariance => 'Tofauti';

  @override
  String get uiWorkOrderEfficiency => 'Ufanisi';

  @override
  String get uiWorkOrderTargetDate => 'Tarehe lengwa';

  @override
  String get uiWorkOrderShift => 'Zamu';

  @override
  String get uiWorkOrderNotApplicable => 'Haipo';

  @override
  String get uiWorkOrderNotes => 'Maelezo';

  @override
  String get uiWorkOrderTimeline => 'Mfuatano wa matukio';

  @override
  String get uiWorkOrderCreated => 'Imeundwa';

  @override
  String get uiWorkOrderStarted => 'Imeanza';

  @override
  String get uiProduceItems => 'Bidhaa';

  @override
  String get uiProduceSelectItem => 'Chagua bidhaa ya kuzalisha';

  @override
  String get uiProduceDescription =>
      'Chagua bidhaa kutoka orodha hapa chini ili kuanza uzalishaji.';

  @override
  String uiProduceItemsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zimebaki bidhaa $count',
      one: 'Imebaki bidhaa 1',
    );
    return '$_temp0';
  }

  @override
  String uiProduceAssignedCount(String count) {
    return '$count zimegawiwa';
  }

  @override
  String uiProduceQty(String qty) {
    return 'Idadi: $qty';
  }

  @override
  String get uiProduceAssigned => 'Imegawiwa';

  @override
  String get uiProduceInProgress => 'Inaendelea';

  @override
  String get uiProduceBackToList => 'Rudi kwenye orodha';

  @override
  String get uiProduceDetails => 'Maelezo ya uzalishaji';

  @override
  String get uiPaymentModeSelect => 'Chagua njia ya malipo';

  @override
  String get uiPaymentModeFailed => 'Malipo yameshindikana';

  @override
  String get uiPaymentModePleaseSelect => 'Tafadhali chagua njia ya malipo';

  @override
  String get uiPaymentModeSelectFinancing => 'Chagua chaguo la ufadhili';

  @override
  String uiPaymentModeInterest(String rate) {
    return 'Riba: $rate%';
  }

  @override
  String get uiBackupDescription =>
      'Kuwasha nakala rudufu kutahifadhi data yako kila siku, hutakuwa na wasiwasi wa kuipoteza.';

  @override
  String get uiTicketNoName => 'Bila jina';

  @override
  String get uiTicketResume => 'Endelea';

  @override
  String get uiNoteRequired => 'Maelezo yanahitajika';

  @override
  String uiNotificationSemantic(String message) {
    return 'Arifa: $message';
  }

  @override
  String uiDeleteConfirmSemantic(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uthibitisho wa kufuta bidhaa $count',
      one: 'Uthibitisho wa kufuta bidhaa 1',
    );
    return '$_temp0';
  }

  @override
  String uiDeleteItemsQuestion(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Futa bidhaa $count?',
      one: 'Futa bidhaa 1?',
    );
    return '$_temp0';
  }

  @override
  String uiMoreItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+ bidhaa $count zaidi',
      one: '+ bidhaa 1 zaidi',
    );
    return '$_temp0';
  }

  @override
  String get uiRefreshStatusAfterPayment => 'Onyesha upya hali baada ya malipo';

  @override
  String get uiSubscriptionActive => 'Usajili uko hai.';

  @override
  String get uiNoPlanOpeningSetup =>
      'Hakuna mpango uliopatikana — inafungua mipangilio ya malipo.';

  @override
  String get uiPlanInactiveOpeningPayment =>
      'Mpango umepatikana lakini hauko hai — inafungua skrini ya malipo.';

  @override
  String get uiCouldNotVerifyPayment =>
      'Imeshindwa kuthibitisha hali ya malipo.';

  @override
  String get uiTimerDone => 'Imekamilika!';

  @override
  String get uiTimerDelivered => 'Imefikishwa!';

  @override
  String get uiTimerUntilDelivered => 'Hadi ifikishwe';

  @override
  String uiTimerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Siku $count',
      one: 'Siku 1',
    );
    return '$_temp0';
  }

  @override
  String uiTimerHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Saa $count',
      one: 'Saa 1',
    );
    return '$_temp0';
  }

  @override
  String uiTimerMinutes(String count) {
    return 'DAKIKA $count';
  }

  @override
  String uiTimerSeconds(String count) {
    return 'SEKUNDE $count';
  }

  @override
  String get uiEnterCouponCode => 'Weka msimbo wa kuponi';

  @override
  String get uiShop => 'Duka';

  @override
  String uiShopActiveSemantic(String name) {
    return '$name hai';
  }

  @override
  String uiShopInactiveSemantic(String name) {
    return '$name haiko hai';
  }

  @override
  String get uiSaveTicket => 'Hifadhi tiketi';

  @override
  String get floSuggestTodayTitle => 'Fupisha utendaji wa leo';

  @override
  String get floSuggestTodayDesc => 'Mapato, faida na vipimo kwa mtazamo mmoja';

  @override
  String get floSuggestTodayQuestion =>
      'Fupisha utendaji wa biashara yangu leo';

  @override
  String get floSuggestProfitTitle => 'Bidhaa zenye faida zaidi';

  @override
  String get floSuggestProfitDesc => 'Zimepangwa kwa faida wiki hii';

  @override
  String get floSuggestProfitQuestion =>
      'Ni bidhaa zipi zenye faida zaidi wiki hii?';

  @override
  String get floSuggestUsersTitle => 'Watumiaji wangapi katika MiniData?';

  @override
  String get floSuggestUsersDesc => 'Idadi na shughuli za hivi karibuni';

  @override
  String get floSuggestUsersQuestion =>
      'Tuna watumiaji wangapi katika MiniData?';

  @override
  String get floSuggestTrendTitle => 'Mwenendo wa mauzo wiki hii';

  @override
  String get floSuggestTrendDesc => 'Mwenendo wa mapato wa siku 7';

  @override
  String get floSuggestTrendQuestion => 'Nionyeshe mwenendo wa mauzo wiki hii';

  @override
  String get floGoodMorning => 'Habari za asubuhi';

  @override
  String get floGoodAfternoon => 'Habari za mchana';

  @override
  String get floGoodEvening => 'Habari za jioni';

  @override
  String floGreetingShop(String greeting, String shop) {
    return '$greeting, $shop.';
  }

  @override
  String floAskMeAnything(String anything) {
    return 'Niulize $anything kuhusu biashara yako.';
  }

  @override
  String get floAnything => 'chochote';

  @override
  String get floHomeIntro =>
      'Nasoma data yako iliyounganishwa moja kwa moja na kujibu kwa takwimu, chati na hatua zinazofuata — kwa lugha rahisi.';

  @override
  String get floTryAsking => 'Jaribu kuuliza';

  @override
  String get floChannels => 'Njia';

  @override
  String get floMiniDataDesc =>
      'Data ya Supabase moja kwa moja — mauzo, watumiaji, bidhaa.';

  @override
  String get floManage => 'Simamia';

  @override
  String get floConnect => 'Unganisha';

  @override
  String get floWhatsAppConnectedDesc =>
      'Unaweza kuzungumza na Flo kupitia WhatsApp.';

  @override
  String get floWhatsAppSetupDesc =>
      'Ongea na Flo kutoka simu yako — weka ndani ya dakika moja.';

  @override
  String get floLoadingBriefing => 'Inapakia muhtasari wa leo…';

  @override
  String get floBriefingUnavailable => 'Muhtasari wa kila siku haupatikani';

  @override
  String get floReadingLiveSales =>
      'Inasoma mauzo ya moja kwa moja kutoka MiniData.';

  @override
  String get floCheckDataConnection =>
      'Angalia muunganisho wa data yako na ujaribu tena.';

  @override
  String get floDailyBriefing => 'MUHTASARI WA SIKU';

  @override
  String floDateAuto(String date) {
    return '$date · otomatiki';
  }

  @override
  String get floConnected => 'IMEUNGANISHWA';

  @override
  String get floNotSetUp => 'HAIJAWEKWA';

  @override
  String aiWhatsappReadInboxFailed(String error) {
    return 'Imeshindwa kusoma ujumbe wa WhatsApp\n$error';
  }

  @override
  String aiWhatsappSendFailed(String error) {
    return 'Kutuma kumeshindikana: $error';
  }

  @override
  String get aiWhatsappAnswerCustomers => 'Jibu wateja kwenye WhatsApp';

  @override
  String get aiWhatsappConnectPitch =>
      'Unganisha akaunti yako ya Meta WhatsApp Business ili kuona ujumbe wa wateja hapa na kuandaa majibu kwa Flo.';

  @override
  String get aiWhatsappConnect => 'Unganisha WhatsApp';

  @override
  String get aiWhatsappSelectCustomer => 'Chagua mteja';

  @override
  String get aiWhatsappInboxSource =>
      'Kikasha cha WhatsApp · data-connector + Ditto';

  @override
  String get aiWhatsappCustomers => 'Wateja · WhatsApp';

  @override
  String get floTimeNow => 'sasa';

  @override
  String floTimeMinutesShort(String count) {
    return 'dak $count';
  }

  @override
  String floTimeDaysShort(String count) {
    return 'siku $count';
  }

  @override
  String get aiWhatsappNoMessages => 'Bado hakuna ujumbe wa WhatsApp';

  @override
  String get aiWhatsappNoMessagesHint =>
      'Ujumbe unaoingia hupakiwa kutoka data-connector (Ditto ya ndani ni hifadhi ya akiba). Meta inapoutuma kwa webhook, huonekana hapa ndani ya sekunde chache.';

  @override
  String get aiWhatsappNoThreadMessages =>
      'Bado hakuna ujumbe katika mazungumzo haya';

  @override
  String get aiWhatsappPdfDownloadFailed => 'Imeshindwa kupakua PDF hii';

  @override
  String get aiWhatsappSavePdf => 'Hifadhi PDF';

  @override
  String aiWhatsappSavedFile(String file) {
    return '$file imehifadhiwa';
  }

  @override
  String aiWhatsappDownloadFailed(String error) {
    return 'Upakuaji umeshindikana: $error';
  }

  @override
  String get aiWhatsappPdfDocument => 'Hati ya PDF';

  @override
  String get aiWhatsappFloSuggestedReply => 'Jibu lililopendekezwa na Flo';

  @override
  String get aiWhatsappSend => 'Tuma';

  @override
  String get aiWhatsappEditFirst => 'Hariri kwanza';

  @override
  String get aiWhatsappDraft => 'Andaa';

  @override
  String get aiWhatsappReplyHint => 'Jibu kwenye WhatsApp…';

  @override
  String get floBusinessAi => 'AI ya biashara';

  @override
  String get floMiniDataConnectedLive =>
      'MiniData imeunganishwa · moja kwa moja';

  @override
  String get floNewChat => 'Mazungumzo mapya';

  @override
  String get floAskFlo => 'Muulize Flo';

  @override
  String get floMessages => 'Ujumbe';

  @override
  String get floNewConversation => 'Mazungumzo mapya';

  @override
  String get floChatWithFloAndCustomers => 'Zungumza na Flo na wateja';

  @override
  String get floOn => 'Imewashwa';

  @override
  String get floOff => 'Imezimwa';

  @override
  String get floManageDataSources => 'Simamia vyanzo vya data';

  @override
  String get floQuickSummarizeToday => 'Fupisha leo';

  @override
  String get floQuickTopProducts => 'Bidhaa bora';

  @override
  String get floQuickUserCount => 'Idadi ya watumiaji';

  @override
  String get floQuickSalesTrend => 'Mwenendo wa mauzo';

  @override
  String get floComposerHint => 'Uliza kuhusu mauzo, hisa, wateja au kodi…';

  @override
  String get floStopDictating => 'Acha kuamuru kwa sauti';

  @override
  String get floDictate => 'Amuru kwa sauti — ongea na Flo ataandika';

  @override
  String get floCanMakeMistakes =>
      'Flo anaweza kukosea — hakiki takwimu muhimu. ';

  @override
  String get floGroundedInMiniData => 'Imetegemea MiniData.';

  @override
  String get floStarting => 'Inaanza…';

  @override
  String get floListening => 'Inasikiliza…';

  @override
  String get floModeCloud => 'Wingu';

  @override
  String get floModeOnDevice => 'Kwenye kifaa';

  @override
  String get floChooseAiMode => 'Chagua hali ya AI';

  @override
  String get floOnDeviceSubtitle => 'Bure · nje ya mtandao · faragha';

  @override
  String get floCloudSubtitle => 'Ina uwezo zaidi · hutumia muunganisho';

  @override
  String get floThinkingUnderstanding => 'Kuelewa swali';

  @override
  String get floThinkingQuerying => 'Inauliza MiniData';

  @override
  String get floThinkingComposing => 'Inatunga jibu';

  @override
  String get floCopied => 'Imenakiliwa!';

  @override
  String get floCopyChart => 'Nakili chati';

  @override
  String get floSuggestedFollowUps => 'MASWALI YANAYOPENDEKEZWA';

  @override
  String get aiDataSourceEdit => 'Hariri chanzo cha data';

  @override
  String get aiDataSourceConnectTitle => 'Unganisha chanzo cha data';

  @override
  String get aiDataSourceType => 'Aina ya chanzo cha data';

  @override
  String get aiDataSourceConnectionName => 'Jina la muunganisho';

  @override
  String get aiDataSourceConnectionNameHint =>
      'mfano: Hifadhidata ya uzalishaji';

  @override
  String get aiDataSourceSupabaseUrl => 'URL ya Supabase';

  @override
  String get aiDataSourceAnonKey => 'Ufunguo wa umma (Anon)';

  @override
  String get aiDataSourceServiceKey => 'Ufunguo wa Service Role (si lazima)';

  @override
  String get aiDataSourceServiceKeyHelper =>
      'Inahitajika kwa shughuli za msimamizi';

  @override
  String get aiDataSourceTestFailedCredentials =>
      'Jaribio la muunganisho limeshindikana. Tafadhali hakiki vitambulisho vyako.';

  @override
  String aiDataSourceTestFailed(String error) {
    return 'Jaribio la muunganisho limeshindikana: $error';
  }

  @override
  String get aiDataSourceTesting => 'Inajaribu...';

  @override
  String get aiDataSourceTestConnection => 'Jaribu muunganisho';

  @override
  String get aiDataSourcePrivacyNote =>
      'Ikiunganishwa, msaidizi anaweza kutumia muundo na mifano ya safu kutoka chanzo hiki katika mazungumzo yako. Vitambulisho huhifadhiwa kwenye kifaa hiki pekee.';

  @override
  String get aiDataSourceEnterName => 'Tafadhali weka jina la muunganisho';

  @override
  String get aiDataSourceEnterUrl => 'Tafadhali weka URL ya Supabase';

  @override
  String get aiDataSourceEnterKey =>
      'Tafadhali weka ufunguo wa umma au wa Service Role';

  @override
  String get aiDataSourceUpdated => 'Chanzo cha data kimesasishwa';

  @override
  String get aiDataSourceConnected => 'Chanzo cha data kimeunganishwa';

  @override
  String aiDataSourceConnectFailed(String error) {
    return 'Imeshindwa kuunganisha: $error';
  }

  @override
  String get aiDataSourceConnecting => 'Inaunganisha...';

  @override
  String get aiDataSourceUpdate => 'Sasisha';

  @override
  String get aiDataSourceConnect => 'Unganisha';

  @override
  String get aiDataSourceStatusConnected => 'Imeunganishwa';

  @override
  String get aiDataSourceStatusConnecting => 'Inaunganisha';

  @override
  String get aiDataSourceStatusError => 'Hitilafu';

  @override
  String get aiDataSourceStatusDisconnected => 'Imetenganishwa';

  @override
  String get aiDataSourceTitle => 'Chanzo cha data';

  @override
  String get aiDataSourceNotFound => 'Chanzo cha data hakijapatikana';

  @override
  String get aiDataSourceGoBack => 'Rudi nyuma';

  @override
  String get aiDataSourceTables => 'Majedwali';

  @override
  String get aiDataSourceUrl => 'URL';

  @override
  String get aiDataSourceNotAvailable => 'Haipo';

  @override
  String aiDataSourceLastConnected(String time) {
    return 'Iliunganishwa mwisho: $time';
  }

  @override
  String get aiDataSourceInformation => 'Taarifa';

  @override
  String aiDataSourceMetadataFailed(String error) {
    return 'Imeshindwa kupakia metadata: $error';
  }

  @override
  String get aiDataSourceTotalRows => 'Jumla ya safu';

  @override
  String get aiDataSourceTypeLabel => 'Aina';

  @override
  String get aiDataSourceUnknown => 'Haijulikani';

  @override
  String aiDataSourceTablesFailed(String error) {
    return 'Imeshindwa kupakia majedwali: $error';
  }

  @override
  String get aiDataSourceNoTables => 'Hakuna majedwali yaliyopatikana';

  @override
  String aiDataSourceColumnsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Safu wima $count',
      one: 'Safu wima 1',
    );
    return '$_temp0';
  }

  @override
  String aiDataSourceRowsCount(String count) {
    return 'Safu $count';
  }

  @override
  String get aiDataSourceColumns => 'Safu wima';

  @override
  String get aiDataSourceNotNull => 'SI TUPU';

  @override
  String get aiDataSourceJustNow => 'Sasa hivi';

  @override
  String aiDataSourceMinutesAgo(String count) {
    return 'dak $count zilizopita';
  }

  @override
  String aiDataSourceHoursAgo(String count) {
    return 'saa $count zilizopita';
  }

  @override
  String get aiDataSourceCsvFile => 'Faili ya CSV';

  @override
  String get aiDataSourceJsonFile => 'Faili ya JSON';

  @override
  String get aiDataSources => 'Vyanzo vya data';

  @override
  String get aiDataSourceAdd => 'Ongeza chanzo cha data';

  @override
  String get aiDataSourceNoneConnected =>
      'Hakuna vyanzo vya data vilivyounganishwa';

  @override
  String get aiDataSourceNoneHint =>
      'Unganisha hifadhidata ili AI iweze kujumuisha muundo wake na mifano ya safu\ninapojibu katika mazungumzo ya Biashara au Binafsi.';

  @override
  String get aiDataSourceConnectFirst =>
      'Unganisha chanzo chako cha kwanza cha data';

  @override
  String get aiDataSourceActive => 'Hai';

  @override
  String get aiDataSourceDisconnect => 'Tenganisha';

  @override
  String get aiDataSourceDeleteTitle => 'Futa chanzo cha data';

  @override
  String aiDataSourceDeleteConfirm(String name) {
    return 'Una uhakika unataka kufuta \"$name\"? Hii itaondoa muunganisho na data zote zinazohusiana.';
  }

  @override
  String aiDataSourceDeleted(String name) {
    return 'Chanzo cha data \"$name\" kimefutwa';
  }

  @override
  String get aiWhatsappPhoneIdEmpty =>
      'Kitambulisho cha nambari ya simu hakiwezi kuwa tupu';

  @override
  String get aiWhatsappPhoneIdInvalid =>
      'Kitambulisho cha nambari ya simu lazima kiwe tarakimu pekee, urefu wa 5 hadi 15';

  @override
  String get aiWhatsappConnectedSuccess => 'Akaunti ya WhatsApp imeunganishwa';

  @override
  String get aiWhatsappDisconnectedSuccess =>
      'Akaunti ya WhatsApp imetenganishwa';

  @override
  String get aiWhatsappConnected => 'Imeunganishwa';

  @override
  String get aiWhatsappNotConnected => 'Haijaunganishwa';

  @override
  String get aiWhatsappAccountActive => 'Akaunti iko hai';

  @override
  String get aiWhatsappSavedToBusiness =>
      'Imehifadhiwa kwenye akaunti ya biashara yako — inabaki imeunganishwa kwenye vifaa vingine ukiingia.';

  @override
  String get aiWhatsappDisconnecting => 'Inatenganisha...';

  @override
  String get aiWhatsappDisconnect => 'Tenganisha';

  @override
  String get aiWhatsappConnectIntro =>
      'Unganisha akaunti yako ya WhatsApp Business ili kupokea na kujibu ujumbe wa wateja.';

  @override
  String get aiWhatsappStep1 => 'Nenda kwenye Meta Business Suite yako';

  @override
  String get aiWhatsappStep2 =>
      'Tafuta kitambulisho cha nambari yako ya simu katika mipangilio ya WhatsApp';

  @override
  String get aiWhatsappStep3 => 'Ibandike hapa chini kisha uunganishe';

  @override
  String get aiWhatsappPhoneIdLabel => 'Kitambulisho cha nambari ya simu';

  @override
  String get aiWhatsappPhoneIdHint => 'mfano: 101514826127381';

  @override
  String get aiWhatsappConnectionError => 'Hitilafu ya muunganisho';

  @override
  String get aiWhatsappTryAgain => 'Jaribu tena';

  @override
  String get aiMessageHint => 'Ujumbe';

  @override
  String aiRecordingStartFailed(String error) {
    return 'Imeshindwa kuanza kurekodi: $error';
  }

  @override
  String get aiVoiceMessageSent => 'Ujumbe wa sauti umetumwa!';

  @override
  String get aiAudioCorrupted => 'Faili ya sauti imeharibika au haijakamilika';

  @override
  String get aiRecordingTooShort => 'Rekodi ni fupi mno (angalau sekunde 1)';

  @override
  String aiRecordingStopFailed(String error) {
    return 'Imeshindwa kusimamisha kurekodi: $error';
  }

  @override
  String get aiMicPermissionTitle => 'Ruhusa ya maikrofoni';

  @override
  String get aiMicPermissionBody =>
      'Ufikiaji wa maikrofoni unahitajika kurekodi ujumbe wa sauti. Tafadhali iwashe katika mipangilio ya kifaa chako.';

  @override
  String aiFilePickError(String error) {
    return 'Hitilafu ya kuchagua faili: $error';
  }

  @override
  String get aiSlideToCancel => 'Telezesha ili kughairi';

  @override
  String get aiSlideUpToLock => 'Telezesha juu ili kufunga';

  @override
  String get aiHoldAndSlide => 'Shikilia na telezesha kudhibiti kurekodi';

  @override
  String get aiExcelAnalysis => 'Uchambuzi wa Excel';

  @override
  String get aiExcelAnalystTitle => 'Mchambuzi wa biashara wa Excel wa AI';

  @override
  String get aiExcelAnalystSubtitle =>
      'Uchunguzi shirikishi na mienendo ya picha';

  @override
  String aiModelDefaultSuffix(String name) {
    return '$name (chaguo-msingi)';
  }

  @override
  String get aiExcelNoData => 'Hakuna data iliyopatikana kwenye faili ya Excel';

  @override
  String get aiExcelSourceData => 'Data ya chanzo:';

  @override
  String get aiExcelVisualAnalysis => 'Uchambuzi wa picha:';

  @override
  String aiChartRenderError(String error) {
    return 'Hitilafu ya kuonyesha chati: $error';
  }

  @override
  String get aiExcelAskForCharts => 'Uliza maswali ili kutengeneza chati';

  @override
  String get aiExcelAnalystChat => 'Mazungumzo na mchambuzi';

  @override
  String get aiExcelAskHint => 'Uliza kuhusu data hii...';

  @override
  String get aiAssistant => 'Msaidizi wa AI';

  @override
  String get aiConversations => 'Mazungumzo';

  @override
  String get aiAdd => 'Ongeza';

  @override
  String get aiNewConversation => 'Mazungumzo mapya';

  @override
  String get aiDeleteConversation => 'Futa mazungumzo';

  @override
  String aiDaysAgo(String count) {
    return 'siku $count zilizopita';
  }

  @override
  String get aiPurchaseCredits => 'Nunua salio';

  @override
  String get aiCopied => 'Imenakiliwa';

  @override
  String get aiProcessingExpandThinking =>
      'AI inashughulikia... Panua fikra kuona maelezo.';

  @override
  String get aiHideThinking => 'Ficha fikra';

  @override
  String get aiShowThinking => 'Onyesha fikra';

  @override
  String get aiWelcomeTitle => 'Msaidizi wako wa AI wa biashara';

  @override
  String get aiWelcomeSubtitle =>
      'Niko tayari kukusaidia kuelewa biashara yako. Jaribu kuuliza moja ya maswali hapa chini.';

  @override
  String get aiSamplePersonalBooks => 'Ni vitabu gani vizuri kuhusu uongozi?';

  @override
  String get aiSamplePersonalEmail =>
      'Nisaidie kuandaa barua pepe kwa mshirika mtarajiwa.';

  @override
  String get aiSamplePersonalTime => 'Nipe vidokezo vya kusimamia muda vizuri.';

  @override
  String get aiSampleBusinessSales =>
      'Jumla ya mauzo yangu wiki iliyopita ilikuwa kiasi gani?';

  @override
  String get aiSampleBusinessTopProducts =>
      'Nionyeshe mgawanyo wa bidhaa zangu zinazouzwa zaidi mwezi huu.';

  @override
  String get aiSampleBusinessTax =>
      'Tengeneza muhtasari wa kodi wa robo iliyopita.';

  @override
  String get aiTaxBreakdown => 'MGAWANYO WA KODI';

  @override
  String get aiTotalTax => 'JUMLA YA KODI';

  @override
  String get aiTaxSummaryReport => 'Ripoti ya muhtasari wa kodi';

  @override
  String get aiCopyReport => 'Nakili ripoti';

  @override
  String get aiInventoryVisualization => 'Taswira ya hisa';

  @override
  String get aiComingSoon => 'Inakuja hivi karibuni';

  @override
  String get uiTicketDue => 'INADAIWA';

  @override
  String get uiTicketAmount => 'KIASI';

  @override
  String get aiYourShop => 'duka lako';

  @override
  String get aiBranchIdRequired => 'Kitambulisho cha tawi kinahitajika';

  @override
  String get aiNoResponse => 'Hakuna jibu lililotolewa. Tafadhali jaribu tena.';

  @override
  String aiWhatsappSendMessageFailed(String error) {
    return 'Imeshindwa kutuma ujumbe wa WhatsApp: $error';
  }

  @override
  String get aiChartNotFound => 'Hitilafu: chati ya kunakili haikupatikana.';

  @override
  String get aiChartImageFailed => 'Hitilafu: imeshindwa kutengeneza picha.';

  @override
  String get aiChartCopied => 'Chati imenakiliwa!';

  @override
  String aiChartCopyFailed(String error) {
    return 'Imeshindwa kunakili chati: $error';
  }

  @override
  String get aiVoiceUnavailable =>
      'Kuingiza kwa sauti bado hakupatikani kwenye jukwaa hili.';

  @override
  String aiVoiceStartFailed(String error) {
    return 'Imeshindwa kuanzisha kuingiza kwa sauti: $error';
  }

  @override
  String get aiMicAccessOff =>
      'Ufikiaji wa maikrofoni umezimwa. Uwashe kwa Flipper katika mipangilio ya mfumo, kisha ujaribu tena.';

  @override
  String aiListenStartFailed(String error) {
    return 'Imeshindwa kuanza kusikiliza: $error';
  }

  @override
  String get aiVoiceNeedsNetwork =>
      'Kuingiza kwa sauti kunahitaji muunganisho wa mtandao kwa sasa.';

  @override
  String get aiMicInUse => 'Maikrofoni inatumiwa na programu nyingine.';

  @override
  String aiVoiceFailed(String error) {
    return 'Kuingiza kwa sauti kumeshindikana ($error).';
  }

  @override
  String get aiLocalUnavailable =>
      'AI ya kwenye kifaa haipatikani kwenye kifaa hiki.';

  @override
  String get aiLocalPreparing => 'Inaandaa modeli ya kwenye kifaa…';

  @override
  String aiLocalLoadFailed(String error) {
    return 'Imeshindwa kupakia modeli ya kwenye kifaa: $error';
  }

  @override
  String get aiLocalReadingShopData => 'Inasoma data ya duka lako…';

  @override
  String get aiLocalThinking => 'Inafikiri kwenye kifaa…';

  @override
  String aiLocalGenerationFailed(String error) {
    return 'Uzalishaji wa kwenye kifaa umeshindikana: $error';
  }

  @override
  String get floBriefingSalesComingIn => 'Mauzo yanaingia leo.';

  @override
  String floBriefingBody(String revenue, String transactions, String units) {
    return 'Mapato yamefikia <b>RWF $revenue</b> katika <b>$transactions</b> (vipimo $units) hadi sasa leo — moja kwa moja kutoka kifaa chako.';
  }

  @override
  String floBriefingTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'miamala $count',
      one: 'muamala 1',
    );
    return '$_temp0';
  }

  @override
  String get floStatRevenue => 'Mapato';

  @override
  String get floStatNetProfit => 'Faida halisi';

  @override
  String get floStatUnitsSold => 'Vipimo vilivyouzwa';

  @override
  String get aiWhatsappNoBusiness =>
      'Hakuna biashara iliyochaguliwa — haiwezi kuhifadhi muunganisho wa WhatsApp';

  @override
  String get aiWhatsappBusinessNotFound =>
      'Biashara haikupatikana — haiwezi kuhifadhi muunganisho wa WhatsApp';

  @override
  String get loginErrorTimeout =>
      'Seva ya Flipper imechukua muda mrefu kujibu. Huenda muunganisho wako ni wa polepole. Jaribu tena. (TIMEOUT)';

  @override
  String get loginErrorSessionExpired =>
      'Muda wa kipindi chako umeisha. Weka PIN yako tena. (SESSION)';

  @override
  String get loginErrorPinCheckFailed =>
      'PIN hiyo haikuweza kukaguliwa. Jaribu tena. (PIN)';

  @override
  String get loginErrorBadResponse =>
      'Seva ya Flipper imetuma jibu lisilotarajiwa. Jaribu tena baada ya dakika moja. (BAD-RESPONSE)';

  @override
  String get loginErrorTls =>
      'Muunganisho salama umeshindwa. Hakikisha tarehe na saa ya simu yako zimewekwa kiotomatiki, kisha jaribu tena. (TLS)';

  @override
  String get loginErrorTlsNetwork =>
      'Muunganisho na seva ya Flipper ulikatika kabla ya kulindwa. Huenda mtandao wako si thabiti. Jaribu tena, au badilisha kati ya data ya simu na Wi-Fi. (TLS-NET)';

  @override
  String get loginErrorDns =>
      'Seva ya Flipper haipatikani. Huenda intaneti yako imezimwa au ina kikomo. Angalia data ya simu au Wi-Fi. (DNS)';

  @override
  String get loginErrorNetwork =>
      'Imeshindwa kufikia seva ya Flipper. Angalia muunganisho wako wa intaneti kisha jaribu tena. (NET)';

  @override
  String get loginErrorOfflineFirst =>
      'Simu hii bado haiwezi kukuingiza bila mtandao. Unganisha intaneti na uingie mara moja, kisha kuingia bila mtandao kutafanya kazi. (OFFLINE-FIRST)';

  @override
  String get loginErrorUnknown => 'Kuingia kumeshindwa. Jaribu tena. (UNKNOWN)';

  @override
  String get loginErrorNoAccountForPin =>
      'Hakuna akaunti inayotumia PIN hii. Angalia PIN kisha jaribu tena. (PIN-404)';

  @override
  String get loginErrorHttp404 =>
      'Seva ya Flipper haikupata kile programu iliomba. Sasisha programu kisha jaribu tena. (HTTP-404)';

  @override
  String get loginErrorHttp429 =>
      'Majaribio mengi mno. Subiri dakika moja, kisha jaribu tena. (HTTP-429)';

  @override
  String loginErrorHttpRefused(String status) {
    return 'Seva ya Flipper imekataa ombi hili. Sasisha programu kisha jaribu tena. (HTTP-$status)';
  }

  @override
  String loginErrorHttpServer(String status) {
    return 'Seva za Flipper zina tatizo kwa sasa. Jaribu tena baada ya dakika moja. (HTTP-$status)';
  }

  @override
  String loginErrorHttpOther(String status) {
    return 'Seva ya Flipper haikuweza kukagua PIN hii. Jaribu tena. (HTTP-$status)';
  }

  @override
  String get loginYourBusiness => 'biashara yako';

  @override
  String get loginPinRequired => 'PIN inahitajika';

  @override
  String get loginPinTooShort => 'PIN lazima iwe na angalau tarakimu 4';

  @override
  String loginPinTooLong(String max) {
    return 'PIN isizidi tarakimu $max';
  }

  @override
  String get loginAuthenticatorCodeRequired =>
      'Kodi ya Authenticator inahitajika';

  @override
  String get loginOtpRequired => 'OTP inahitajika';

  @override
  String get loginAuthenticatorCodeInvalidFormat =>
      'Kodi ya Authenticator lazima iwe na tarakimu 6.';

  @override
  String get loginOtpInvalidFormat => 'OTP lazima iwe na tarakimu 6.';

  @override
  String get loginInvalidPinReenter =>
      'PIN si sahihi. Tafadhali iweke tena ujaribu.';

  @override
  String get loginAuthenticatorUnavailable =>
      'Imeshindwa kufikia seva ili kupakia Authenticator yako kwenye kifaa hiki. Angalia muunganisho wako kisha ujaribu tena.';

  @override
  String get loginAuthenticatorNotEnrolled =>
      'Hakuna Authenticator iliyowekwa kwa akaunti hii. Ingia kwa SMS, kisha uweke moja kwenye Mipangilio.';

  @override
  String get loginAuthenticatorInvalidCode =>
      'Kodi ya Authenticator si sahihi. Tafadhali jaribu tena.';

  @override
  String get loginPinSubtitle =>
      'Weka PIN yako ili kusimamia biashara yako kwa usalama.';

  @override
  String get loginSignedIn => 'Umeingia';

  @override
  String get loginSignIn => 'Ingia';

  @override
  String get loginCreateAnAccount => 'Fungua akaunti';

  @override
  String get loginNewToFlipperCreateAccount =>
      'Mgeni kwenye Flipper? Fungua akaunti';

  @override
  String get loginShowPin => 'Onyesha PIN';

  @override
  String get loginHidePin => 'Ficha PIN';

  @override
  String get loginShow => 'Onyesha';

  @override
  String get loginHide => 'Ficha';

  @override
  String loginPinDigitsEntered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tarakimu $count zimewekwa',
      one: 'Tarakimu 1 imewekwa',
    );
    return '$_temp0';
  }

  @override
  String get loginAuthenticator => 'Authenticator';

  @override
  String get loginAuthenticatorCode => 'Kodi ya Authenticator';

  @override
  String get loginSmsCode => 'Kodi ya SMS';

  @override
  String get loginPinEntryCells => 'Visanduku vya kuweka PIN';

  @override
  String loginVerifiedOpening(String business) {
    return 'Imethibitishwa — inafungua $business…';
  }

  @override
  String get loginShowOrHidePin => 'Onyesha au ficha PIN';

  @override
  String get loginBackspace => 'Futa';

  @override
  String get loginSecuredE2e =>
      'Imelindwa kwa usimbaji fiche wa mwanzo hadi mwisho';

  @override
  String get loginBrandHeadline =>
      'Duka lako, timu yako, takwimu zako — vyote mahali pamoja.';

  @override
  String get loginBrandSubhead =>
      'Endelea pale ulipoishia. Mauzo, hisa na ripoti za leo ziko tayari.';

  @override
  String get loginStatBusinesses => 'biashara';

  @override
  String get loginStatProcessedMonthly => 'huchakatwa kila mwezi';

  @override
  String get loginStatUptime => 'upatikanaji';

  @override
  String get loginRevenueThisWeek => 'Mapato · wiki hii';

  @override
  String get loginNewSale => 'Mauzo mapya';

  @override
  String get loginSampleSaleDetail => 'Kifaa cha sola · MoMo';

  @override
  String loginStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Siku $count',
      one: 'Siku 1',
    );
    return '$_temp0';
  }

  @override
  String get loginSalesStreak => 'Mfululizo wa mauzo';

  @override
  String get loginLandingSlide1Title =>
      'Endesha biashara\nyako yote kwa programu moja';

  @override
  String get loginLandingSlide1Highlight => 'biashara';

  @override
  String get loginLandingSlide1Text =>
      'Uza, fuatilia hisa na simamia timu yako - Flipper ni biashara yako mfukoni mwako.';

  @override
  String get loginLandingSlide2Title =>
      'Ripoti rahisi na muhimu\nzinazokusaidia kukua';

  @override
  String get loginLandingSlide2Highlight => 'Ripoti';

  @override
  String get loginLandingSlide2Text =>
      'Ona hasa kinachouzwa, kinachokaribia kuisha, na pesa zako zinakokwenda - kila siku.';

  @override
  String get loginLandingSlide3Title => 'Lipwa haraka,\nfuatilia kila faranga';

  @override
  String get loginLandingSlide3Highlight => 'fuatilia kila faranga';

  @override
  String get loginLandingSlide3Text =>
      'Pokea MoMo, pesa taslimu na kadi. Flipper hurekodi kila mauzo na kukupatanishia hesabu.';

  @override
  String get loginLandingSlide4Title => 'Kuza biashara yako,\npata zawadi';

  @override
  String get loginLandingSlide4Highlight => 'pata zawadi';

  @override
  String get loginLandingSlide4Text =>
      'Fikia malengo ya kila siku, dumisha mfululizo wako, na upande daraja kutoka Muuzaji wa Shaba hadi Muuzaji wa Dhahabu.';

  @override
  String get loginLandingSemantic => 'Ukurasa wa mwanzo wa Flipper';

  @override
  String get loginNext => 'Inayofuata';

  @override
  String get loginSkipIntroSemantic => 'Ruka utangulizi na ufungue akaunti';

  @override
  String get loginSkipIntro => 'Ruka utangulizi - Fungua akaunti';

  @override
  String get loginAlreadySellingSignIn => 'Tayari unauza kwenye Flipper? Ingia';

  @override
  String get loginDailyReport => 'Ripoti ya kila siku';

  @override
  String get loginStock => 'Hisa';

  @override
  String get loginTax => 'Kodi';

  @override
  String get loginGoldSeller => 'Muuzaji wa Dhahabu';

  @override
  String get loginFinalizingAuthentication => 'Tunakamilisha uthibitishaji...';

  @override
  String get loginAuthTimedOut =>
      'Muda wa uthibitishaji umeisha. Tafadhali jaribu tena.';

  @override
  String get loginPhoneLoginNavigationFailed =>
      'Imeshindwa kufungua kuingia kwa simu';

  @override
  String get loginSignInFailed => 'Kuingia kumeshindwa';

  @override
  String get loginAuthenticationFailed => 'Uthibitishaji umeshindwa';

  @override
  String get loginUnexpectedError => 'Hitilafu isiyotarajiwa imetokea';

  @override
  String get loginAuthDomainUnauthorized =>
      'Kikoa cha uthibitishaji hakijaidhinishwa. Tafadhali wasiliana na huduma kwa wateja.';

  @override
  String get loginAccountDisabled => 'Akaunti hii imezimwa.';

  @override
  String get loginAccountExistsDifferentCredential =>
      'Tayari kuna akaunti yenye barua pepe hii lakini yenye njia tofauti ya kuingia.';

  @override
  String loginMicrosoftFailedWithReason(String error) {
    return 'Kuingia kwa Microsoft kumeshindwa: $error';
  }

  @override
  String get loginMicrosoftFailed =>
      'Kuingia kwa Microsoft kumeshindwa. Tafadhali jaribu tena baadaye.';

  @override
  String loginAppleAuthorizationFailed(String error) {
    return 'Idhini ya Apple imeshindwa: $error';
  }

  @override
  String loginAppleFailed(String error) {
    return 'Kuingia kwa Apple kumeshindwa: $error';
  }

  @override
  String get loginWelcomeToFlipper => 'Karibu kwenye Flipper';

  @override
  String get loginHowToSignIn => 'Ungependa kuingia vipi?';

  @override
  String get loginLoggingIn => 'Inaingia...';

  @override
  String get loginTryAgainOrUsePin => 'Tafadhali jaribu tena au ingia kwa PIN';

  @override
  String get loginSuccessful => 'Umeingia!';

  @override
  String get loginQrScanned =>
      'Msimbo wa QR umechanganuliwa! Inakamilisha kuingia...';

  @override
  String get loginFailedTryAgain =>
      'Kuingia kumeshindwa. Tafadhali jaribu tena.';

  @override
  String get loginSuccessfulRedirecting => 'Umeingia! Inakuelekeza...';

  @override
  String get loginQrTitle => 'Ingia kwenye Flipper kwa msimbo wa QR';

  @override
  String get loginQrStep1 => '1. Fungua Flipper kwenye simu yako';

  @override
  String get loginQrStep2 =>
      '2. Nenda kwenye ikoni ya Wasifu > ibonyeze kwa muda mrefu.';

  @override
  String get loginQrStep3 =>
      '3. Elekeza simu yako kwenye skrini hii ili kuthibitisha kuingia';

  @override
  String get loginDownloadApp => 'Huna programu ya Flipper? Ipakue:';

  @override
  String get loginOpeningAppStore => 'Inafungua App Store...';

  @override
  String get loginOpeningPlayStore => 'Inafungua Play Store...';

  @override
  String get loginSwitchToPin => 'Badili kuingia kwa PIN';

  @override
  String get loginDeviceOffline => 'Kifaa hakiko mtandaoni';

  @override
  String get loginInvalidEmail => 'Barua pepe si sahihi';

  @override
  String get loginGmailRequired => 'Barua pepe ya Gmail inahitajika';

  @override
  String get loginEnterEmail => 'Weka barua pepe';

  @override
  String get loginAddEmailHint =>
      'Baada ya kuweka barua pepe yako, bofya Ongeza barua pepe';

  @override
  String get signupErrorGeneric => 'Hitilafu imetokea wakati wa kujisajili';

  @override
  String get signupOtpExpiredOrInvalid =>
      'OTP imeisha muda au si sahihi. Tafadhali omba kodi mpya.';

  @override
  String get signupResendOtp => 'Tuma OTP tena';

  @override
  String get signupNewOtpSent => 'OTP mpya imetumwa!';

  @override
  String signupFailedToResendOtp(String error) {
    return 'Imeshindwa kutuma OTP tena: $error';
  }

  @override
  String get signupUsername => 'Jina la mtumiaji';

  @override
  String get signupUsernameHint => 'Weka jina lako la mtumiaji';

  @override
  String get signupFullName => 'Jina kamili';

  @override
  String get signupFullNameHint => 'Jina la kwanza, Jina la mwisho';

  @override
  String get signupPhoneOrEmail => 'Simu / Barua pepe';

  @override
  String get signupPhoneOrEmailHint => '783054874 au your@email.com';

  @override
  String get signupOtpResent => 'OTP imetumwa tena!';

  @override
  String get signupResend => 'Tuma tena';

  @override
  String get signupOtpSent => 'OTP imetumwa!';

  @override
  String signupFailedToSendOtp(String error) {
    return 'Imeshindwa kutuma OTP: $error';
  }

  @override
  String get signupSendCode => 'Tuma kodi';

  @override
  String get signupOtpCode => 'Kodi ya OTP';

  @override
  String get signupOtpHint => 'Weka OTP ya tarakimu 6';

  @override
  String get signupPhoneVerified => 'Nambari ya simu imethibitishwa!';

  @override
  String get signupUsage => 'Matumizi';

  @override
  String get signupCountry => 'Nchi';

  @override
  String get signupSearchCountry => 'Tafuta nchi yako';

  @override
  String get signupStepIdentity => 'Utambulisho';

  @override
  String get signupStepVerify => 'Uthibitisho';

  @override
  String signupStepOf(String step, String total) {
    return 'Hatua $step kati ya $total';
  }

  @override
  String get signupRewardTitle => 'Maliza usanidi ili kufungua pointi 500';

  @override
  String get signupRewardSubtitle =>
      'Tumia pointi kupata ada nafuu na ripoti za hali ya juu';

  @override
  String get signupStep1Title => 'Wewe ni nani?';

  @override
  String get signupStep1Description =>
      'Hivi ndivyo utakavyoingia na jinsi wenzako watakavyokupata.';

  @override
  String get signupStep2Title => 'Tukufikie vipi?';

  @override
  String get signupStep2Description =>
      'Tutakutumia kodi ya mara moja kuthibitisha kuwa ni wewe kweli.';

  @override
  String get signupStep3Title => 'Tuambie kuhusu duka lako';

  @override
  String get signupStep3Description =>
      'Tutaifanya Flipper ilingane na jinsi unavyouza.';

  @override
  String get signupCreateAccountClaim => 'Fungua akaunti · pata pointi 500';

  @override
  String signupTermsAgreement(String terms, String privacy) {
    return 'Kwa kuendelea unakubali $terms na $privacy za Flipper';
  }

  @override
  String get signupTermsLink => 'Masharti';

  @override
  String get signupPrivacyLink => 'Sera ya Faragha';

  @override
  String get signupVerificationFailed => 'Uthibitishaji umeshindwa';

  @override
  String get signupNameTooLong => 'Jina ni refu mno';

  @override
  String get signupContactRequired =>
      'Nambari ya simu au barua pepe inahitajika';

  @override
  String get signupContactInvalid =>
      'Tafadhali weka nambari ya simu au barua pepe sahihi';

  @override
  String get signupUsernameRequired =>
      'Jina la mtumiaji au la biashara linahitajika';

  @override
  String get signupUsernameTaken =>
      'Jina hilo la mtumiaji tayari limechukuliwa';

  @override
  String get signupUsernameCheckUnavailable => 'Utafutaji wa jina haupatikani';

  @override
  String get signupOtpMustBe6Digits => 'OTP lazima iwe tarakimu 6';

  @override
  String get signupOtpDigitsOnly => 'OTP lazima iwe na tarakimu pekee';

  @override
  String get signupValidateTin => 'Tafadhali thibitisha TIN';

  @override
  String get signupPhoneMustBeVerified => 'Nambari ya simu lazima ithibitishwe';

  @override
  String get signupFieldRequired => 'Sehemu hii inahitajika.';

  @override
  String get signupSelectOption => 'Tafadhali chagua chaguo';

  @override
  String get signupJoinFlipper => 'Jiunge na Flipper';

  @override
  String get signupJourneyTagline => 'Anza safari yako nasi leo 🚀';

  @override
  String get signupNoMatches => 'Hakuna yanayolingana';

  @override
  String get signupTinExtractFailed =>
      'Imeshindwa kupata TIN kutoka kwenye hati uliyotoa';

  @override
  String signupTinPdfError(String error) {
    return 'Hitilafu katika kuchakata PDF: $error';
  }

  @override
  String signupTinValidated(String name) {
    return 'TIN imethibitishwa: $name';
  }

  @override
  String get signupTinNoData => 'Hakuna data iliyopatikana kwa TIN hii';

  @override
  String get signupTinServiceUnavailable =>
      'Huduma haipatikani: uthibitishaji umerukwa';

  @override
  String signupTinValidationError(String error) {
    return 'Hitilafu katika kuthibitisha TIN: $error';
  }

  @override
  String get phoneAuthSelectCountryTitle =>
      'Chagua nchi ambapo biashara yako iko';

  @override
  String get phoneAuthSearchCountry => 'Tafuta nchi...';

  @override
  String get phoneAuthAgreeSellerAgreement =>
      'Ninakubali Mkataba wa Muuzaji na Sera ya Faragha ya Flipper.';

  @override
  String get phoneAuthRecaptchaNotice =>
      'Programu hii inalindwa na reCAPTCHA Enterprise, na Sera ya Faragha na Masharti ya Huduma ya Google yanatumika.';

  @override
  String get phoneAuthEnterPhone => 'Tafadhali weka nambari yako ya simu';

  @override
  String get phoneAuthInvalidPhone => 'Tafadhali weka nambari ya simu sahihi';

  @override
  String get phoneAuthTitle => 'Uthibitishaji wa simu';

  @override
  String get phoneAuthSubtitle =>
      'Tutatuma kodi ya uthibitisho kwa nambari yako ya simu ili kuthibitisha utambulisho wako.';

  @override
  String get phoneAuthPhoneHint => '783054874 (bila 0 mwanzoni)';

  @override
  String phoneAuthTermsAgreement(String terms, String privacy) {
    return 'Kwa kuendelea, unakubali $terms na $privacy yetu';
  }

  @override
  String get phoneAuthTermsOfService => 'Masharti ya Huduma';

  @override
  String get phoneAuthPrivacyPolicy => 'Sera ya Faragha';

  @override
  String get phoneAuthVerificationCode => 'Kodi ya uthibitisho';

  @override
  String get phoneAuthChangeNumber => 'Badilisha nambari ya simu';

  @override
  String phoneAuthVerificationFailed(String error) {
    return 'Uthibitishaji umeshindwa: $error';
  }

  @override
  String get phoneAuthUnknownError => 'Hitilafu isiyojulikana imetokea';

  @override
  String phoneAuthErrorOccurred(String error) {
    return 'Hitilafu imetokea: $error';
  }

  @override
  String get phoneAuthNewCodeSent => 'Kodi mpya ya uthibitisho imetumwa';

  @override
  String get phoneAuthEnterValidCode =>
      'Tafadhali weka kodi sahihi ya tarakimu 6';

  @override
  String get phoneAuthCodeExpired =>
      'Kodi hii ya uthibitisho imeisha muda. Tafadhali omba mpya.';

  @override
  String phoneAuthFailedToVerify(String error) {
    return 'Imeshindwa kuthibitisha kodi: $error';
  }

  @override
  String phoneAuthAuthFailed(String error) {
    return 'Uthibitishaji umeshindwa: $error';
  }

  @override
  String get loginFailed => 'Kuingia kumeshindikana';

  @override
  String get webPricingTitle => 'Bei rahisi na wazi';

  @override
  String get webPlanMobile => 'Simu';

  @override
  String get webPlanMobileDesktop => 'Simu + Kompyuta';

  @override
  String get webPlanEnterprise => 'Biashara Kubwa';

  @override
  String get webCurrencyPerMonth => 'RWF / mwezi';

  @override
  String get webFeatureMobileAppAccess => 'Ufikiaji wa programu ya simu';

  @override
  String get webFeatureBasicBusinessTools => 'Zana za msingi za biashara';

  @override
  String get webFeatureDataEncryption => 'Usimbaji fiche wa data';

  @override
  String get webFeatureSingleDevice => 'Kifaa kimoja';

  @override
  String get webFeatureTaxReportingAddon =>
      '+ Uwasilishaji wa kodi (+30,000 RWF)';

  @override
  String get webFeatureMobileDesktopAppAccess =>
      'Ufikiaji wa programu ya simu na kompyuta';

  @override
  String get webFeatureAdvancedBusinessTools => 'Zana za kisasa za biashara';

  @override
  String get webFeatureMilitaryGradeEncryption =>
      'Usimbaji fiche wa kiwango cha kijeshi';

  @override
  String get webFeaturePrioritySupport => 'Msaada wa kipaumbele';

  @override
  String get webFeatureMultipleDevices => 'Vifaa vingi';

  @override
  String get webFeatureAdvancedAnalytics => 'Uchanganuzi wa kina';

  @override
  String get webFeatureFullPlatformAccess => 'Ufikiaji kamili wa jukwaa';

  @override
  String get webFeatureEnterpriseGradeSecurity =>
      'Usalama wa kiwango cha kampuni';

  @override
  String get webFeature247DedicatedSupport => 'Msaada maalum 24/7';

  @override
  String get webFeatureUnlimitedUsersBranches =>
      'Watumiaji na matawi bila kikomo';

  @override
  String get webFeatureCustomIntegrations => 'Miunganisho maalum';

  @override
  String get webFeaturePremiumTaxConsulting =>
      '+ Ushauri maalum wa kodi (+400,000 RWF)';

  @override
  String get webGetStarted => 'Anza';

  @override
  String get booksReceivables => 'Madeni ya wateja';

  @override
  String get booksBills => 'Bili';

  @override
  String get booksSuppliers => 'Wasambazaji';

  @override
  String get booksPayables => 'Madeni ya wasambazaji';

  @override
  String get booksJournalEntries => 'Maingizo ya jarida';

  @override
  String get booksGeneralLedger => 'Leja kuu';

  @override
  String get booksRecurring => 'Zinazojirudia';

  @override
  String get booksBankReconciliation => 'Usuluhishi wa benki';

  @override
  String get booksFinancialStatements => 'Taarifa za fedha';

  @override
  String get booksTrialBalance => 'Mizani ya majaribio';

  @override
  String get booksTaxVat => 'Kodi na VAT';

  @override
  String get booksChartOfAccounts => 'Orodha ya akaunti';

  @override
  String get booksPeriodClose => 'Kufunga kipindi';

  @override
  String get booksAuditTrail => 'Kumbukumbu za ukaguzi';

  @override
  String get booksUsersRoles => 'Watumiaji na majukumu';

  @override
  String get booksOverview => 'Muhtasari';

  @override
  String get booksDaybook => 'Daftari la kila siku';

  @override
  String get booksSetup => 'Usanidi';

  @override
  String get booksCompliance => 'Uzingatiaji';

  @override
  String booksClosingBalance(String amount) {
    return 'Salio la mwisho $amount';
  }

  @override
  String booksAccountPostingHistory(String currency) {
    return 'Historia ya maingizo kwa kila akaunti · $currency';
  }

  @override
  String get booksReadingStatement => 'Inasoma taarifa…';

  @override
  String get booksStatementImported => 'Taarifa imeingizwa';

  @override
  String booksStatementLinesLoaded(int count, String source) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mistari $count imepakiwa',
      one: 'Mstari 1 umepakiwa',
    );
    return '$source · $_temp0';
  }

  @override
  String get booksImportFailed => 'Uingizaji umeshindwa';

  @override
  String get booksMatchDifferentAccountTitle =>
      'Linganisha kwenye akaunti nyingine?';

  @override
  String booksMatchDifferentAccountBody(
    String account,
    String amount,
    String bankCode,
    String code,
  ) {
    return 'Ingizo hili linahamisha $amount kwenye $account ($code), si Benki ($bankCode). Linganisha hata hivyo?';
  }

  @override
  String get booksMatch => 'Linganisha';

  @override
  String get booksBankLineMatched => 'Mstari wa benki umelinganishwa';

  @override
  String get booksBankCatSaleIncome => 'Mauzo / mapato';

  @override
  String get booksBankCatSaleIncomeHint => 'Pesa uliyopata';

  @override
  String get booksBankCatCustomerPaid => 'Mteja alilipa deni';

  @override
  String get booksBankCatCustomerPaidHint => 'Alikuwa anadaiwa nawe';

  @override
  String get booksBankCatOwnerAdded => 'Mmiliki aliongeza pesa';

  @override
  String get booksBankCatOwnerAddedHint => 'Mtaji uliouweka';

  @override
  String get booksBankCatLoanReceived => 'Mkopo uliopokea';

  @override
  String get booksBankCatLoanReceivedHint => 'Pesa uliyokopa';

  @override
  String get booksBankCatFromCash => 'Uhamisho kutoka fedha taslimu';

  @override
  String get booksBankCatFromCashHint =>
      'Imehamishwa kutoka sanduku lako la fedha';

  @override
  String get booksBankCatFromMomo => 'Uhamisho kutoka Mobile Money';

  @override
  String get booksBankCatFromMomoHint => 'Imehamishwa kutoka MoMo';

  @override
  String get booksBankCatOtherIncome => 'Mapato mengine';

  @override
  String get booksBankCatOtherIncomeHint => 'Chochote kingine kilichopokelewa';

  @override
  String get booksBankCatBankFee => 'Ada / gharama ya benki';

  @override
  String get booksBankCatBankFeeHint => 'Gharama zilizokatwa na benki';

  @override
  String get booksBankCatPaidSupplier => 'Kumlipa msambazaji / kununua bidhaa';

  @override
  String get booksBankCatPaidSupplierHint => 'Hisa au bidhaa';

  @override
  String get booksBankCatRent => 'Kodi ya pango';

  @override
  String get booksBankCatRentHint => 'Kodi ya duka au ofisi';

  @override
  String get booksBankCatSalaries => 'Mishahara';

  @override
  String get booksBankCatSalariesHint => 'Malipo ya wafanyakazi';

  @override
  String get booksBankCatUtilities => 'Huduma za msingi';

  @override
  String get booksBankCatUtilitiesHint => 'Umeme, maji, intaneti';

  @override
  String get booksBankCatTransport => 'Usafiri / mafuta';

  @override
  String get booksBankCatTransportHint => 'Safari na usafirishaji';

  @override
  String get booksBankCatLoanRepayment => 'Kulipa mkopo';

  @override
  String get booksBankCatLoanRepaymentHint => 'Ulirejesha mkopo';

  @override
  String get booksBankCatOwnerWithdrew => 'Mmiliki alitoa pesa';

  @override
  String get booksBankCatOwnerWithdrewHint => 'Utoaji wa binafsi';

  @override
  String get booksBankCatToCash => 'Uhamisho kwenda fedha taslimu';

  @override
  String get booksBankCatToCashHint => 'Imehamishiwa sanduku lako la fedha';

  @override
  String get booksBankCatToMomo => 'Uhamisho kwenda Mobile Money';

  @override
  String get booksBankCatToMomoHint => 'Imehamishiwa MoMo';

  @override
  String get booksBankCatOtherExpense => 'Matumizi mengine';

  @override
  String get booksBankCatOtherExpenseHint => 'Chochote kingine ulicholipa';

  @override
  String get booksEntryCreatedMatched => 'Ingizo limeundwa na kulinganishwa';

  @override
  String booksEntryCreatedMatchedDetail(
    String amount,
    String category,
    String ref,
  ) {
    return '$category — $amount kwenye Benki ($ref)';
  }

  @override
  String get booksCouldNotCreateEntry => 'Imeshindwa kuunda ingizo';

  @override
  String get booksWhereMoneyFrom => 'Pesa hizi zilitoka wapi?';

  @override
  String get booksWhatPaymentFor => 'Malipo haya yalikuwa ya nini?';

  @override
  String get booksPickClosestMatch =>
      'Chagua kinacholingana zaidi — tutakirekodi ipasavyo kwa ajili yako.';

  @override
  String get booksMatchBankLine => 'Linganisha mstari wa benki';

  @override
  String get booksBank => 'Benki';

  @override
  String booksBankRecSubtitle(String bank, String currency, String period) {
    return 'Benki · $bank · taarifa ya $period · $currency';
  }

  @override
  String get booksImportStatement => 'Ingiza taarifa';

  @override
  String get booksReconciled => 'Imesuluhishwa';

  @override
  String get booksFinishReconciliation => 'Maliza usuluhishi';

  @override
  String get booksReconciliationComplete => 'Usuluhishi umekamilika';

  @override
  String booksLinesMatchedOfTotal(String matched, String total) {
    return 'Mistari $matched kati ya $total imelinganishwa';
  }

  @override
  String get booksStatementBalance => 'Salio la taarifa';

  @override
  String get booksFromImportedStatement => 'kutoka taarifa iliyoingizwa';

  @override
  String get booksMatched => 'Zimelinganishwa';

  @override
  String get booksNoLinesYet => 'bado hakuna mistari';

  @override
  String booksOfTotal(String total) {
    return 'kati ya $total';
  }

  @override
  String get booksNeedsAttention => 'Inahitaji umakini';

  @override
  String get booksStatementLines => 'Mistari ya taarifa';

  @override
  String get booksMatchEachLine =>
      'Linganisha kila mstari wa benki na ingizo la jarida';

  @override
  String get booksNoStatementLines =>
      'Bado hakuna mistari ya taarifa ya benki. Ingiza taarifa ili kuanza.';

  @override
  String booksVatSubtitle(String period, String rate) {
    return 'VAT ya $rate% (kiwango cha kawaida Rwanda) · kipindi $period';
  }

  @override
  String get booksFileWithRra => 'Wasilisha kwa RRA';

  @override
  String get booksVatReturnSubmitted => 'Ritani ya VAT imewasilishwa';

  @override
  String booksRraAckRef(String ref) {
    return 'Uthibitisho wa RRA · kumb. $ref';
  }

  @override
  String get booksOutputVatOnSales => 'VAT ya mauzo';

  @override
  String get booksInputVatReclaimable => 'VAT ya manunuzi (inayorejeshwa)';

  @override
  String get booksNetVatPayable => 'VAT halisi inayolipwa';

  @override
  String booksDueDate(String date) {
    return 'Tarehe ya mwisho $date';
  }

  @override
  String get booksVatReturnSummary => 'Muhtasari wa ritani ya VAT';

  @override
  String get booksDraft => 'Rasimu';

  @override
  String get booksTotalSalesVatInclusive => 'Jumla ya mauzo (pamoja na VAT)';

  @override
  String get booksOutputVatCollected => 'VAT ya mauzo iliyokusanywa';

  @override
  String get booksInputVatOnPurchases => 'VAT ya manunuzi';

  @override
  String get booksNetVatDueToRra => 'VAT halisi inayodaiwa na RRA';

  @override
  String get booksPrint => 'Chapisha';

  @override
  String get booksPreparingPrintLayout => 'Inaandaa mpangilio wa kuchapisha';

  @override
  String get booksGeneratingPdf => 'Inatengeneza PDF';

  @override
  String booksStatementPack(String currency) {
    return 'Kifurushi cha taarifa · $currency';
  }

  @override
  String get booksIncomeStatement => 'Taarifa ya mapato';

  @override
  String get booksBalanceSheet => 'Mizania';

  @override
  String get booksCashFlow => 'Mtiririko wa fedha';

  @override
  String get booksNetRevenue => 'Mapato halisi';

  @override
  String get booksCogs => 'Gharama ya bidhaa zilizouzwa';

  @override
  String get booksGrossProfit => 'Faida ghafi';

  @override
  String get booksOperatingExpenses => 'Gharama za uendeshaji';

  @override
  String get booksTotalAssets => 'Jumla ya mali';

  @override
  String get booksTotalLiabilities => 'Jumla ya madeni';

  @override
  String get booksTotalEquity => 'Jumla ya mtaji';

  @override
  String get booksLiabilitiesPlusEquity => 'Madeni + mtaji';

  @override
  String get booksOperatingActivities => 'Shughuli za uendeshaji';

  @override
  String get booksInvestingActivities => 'Shughuli za uwekezaji';

  @override
  String get booksFinancingActivities => 'Shughuli za ufadhili';

  @override
  String get booksNetChangeInCash => 'Mabadiliko halisi ya fedha';

  @override
  String get booksBalancedAssetsEqual =>
      'Imesawazishwa — mali ni sawa na madeni pamoja na mtaji';

  @override
  String booksAsOfPeriod(String currency, String period) {
    return 'Hadi $period · $currency';
  }

  @override
  String get booksInBalance => 'Imesawazishwa';

  @override
  String get booksOutOfBalance => 'Haijasawazishwa';

  @override
  String get booksNoAccountsYet => 'Bado hakuna akaunti zilizopakiwa.';

  @override
  String get booksTotals => 'Jumla';

  @override
  String get booksAssets => 'Mali';

  @override
  String get booksLiabilities => 'Madeni';

  @override
  String get booksEquity => 'Mtaji';

  @override
  String get booksIncome => 'Mapato';

  @override
  String get booksExpenses => 'Matumizi';

  @override
  String booksCoaSubtitle(String count) {
    return 'Akaunti $count · muundo wa leja wenye nambari';
  }

  @override
  String get booksFilterByType => 'Chuja kwa aina';

  @override
  String get booksAllTypes => 'Aina zote';

  @override
  String get booksFilter => 'Chuja';

  @override
  String get booksAddAccount => 'Ongeza akaunti';

  @override
  String get booksNetIncome => 'Mapato halisi';

  @override
  String get booksNetLoss => 'Hasara halisi';

  @override
  String get booksOpenOnWiderScreen =>
      'Fungua kwenye skrini pana kwa nafasi ya kazi ya kompyuta';

  @override
  String get booksFreqMonthly => 'Kila mwezi';

  @override
  String get booksFreqWeekly => 'Kila wiki';

  @override
  String get booksFreqQuarterly => 'Kila robo mwaka';

  @override
  String get booksFreqYearly => 'Kila mwaka';

  @override
  String get booksRoleOwner => 'Mmiliki';

  @override
  String get booksRoleOwnerDesc =>
      'Ufikiaji kamili — kuidhinisha, kuingiza, kuwasilisha kodi, kusimamia timu';

  @override
  String get booksRoleBookkeeper => 'Mtunza hesabu';

  @override
  String get booksRoleBookkeeperDesc =>
      'Kuunda na kuhariri maingizo, ankara na bili; hawezi kuidhinisha wala kuwasilisha';

  @override
  String get booksRoleCashier => 'Keshia';

  @override
  String get booksRoleCashierDesc =>
      'Kurekodi mauzo na risiti kutoka POS pekee';

  @override
  String get booksRoleViewer => 'Mtazamaji';

  @override
  String get booksRoleViewerDesc =>
      'Ufikiaji wa kusoma tu kwa ripoti na taarifa';

  @override
  String get booksCapViewReports => 'Kuona ripoti na taarifa';

  @override
  String get booksCapCreateInvoicesBills => 'Kuunda ankara na bili';

  @override
  String get booksCapRecordPayments => 'Kurekodi malipo na risiti';

  @override
  String get booksCapPostJournal => 'Kuingiza na kuhariri maingizo ya jarida';

  @override
  String get booksCapApproveEntries => 'Kuidhinisha maingizo';

  @override
  String get booksCapFileVat => 'Kuwasilisha VAT kwa RRA';

  @override
  String get booksCapClosePeriods => 'Kufunga vipindi na kusimamia timu';

  @override
  String get booksRecurringEntries => 'Maingizo yanayojirudia';

  @override
  String booksRecurringSubtitle(String currency) {
    return 'Kodi, mishahara na maingizo mengine yanayojirudia hujiingiza yenyewe · $currency';
  }

  @override
  String get booksNewSchedule => 'Ratiba mpya';

  @override
  String get booksActiveSchedules => 'Ratiba zinazotumika';

  @override
  String booksCountOfTotal(String count, String total) {
    return '$count kati ya $total';
  }

  @override
  String get booksMonthlyCommitted => 'Ahadi ya kila mwezi';

  @override
  String get booksNextRun => 'Utekelezaji ujao';

  @override
  String get booksNoRecurringYet =>
      'Bado hakuna ratiba zinazojirudia. Unda moja ili kuingiza kodi, mishahara au maingizo mengine yanayojirudia.';

  @override
  String get booksSchedule => 'Ratiba';

  @override
  String get booksFrequency => 'Marudio';

  @override
  String get booksPostsTo => 'Inaingizwa kwenye';

  @override
  String get booksStatus => 'Hali';

  @override
  String get booksPaused => '— imesitishwa —';

  @override
  String get booksRunNow => 'Endesha sasa';

  @override
  String get booksScheduleResumed => 'Ratiba imeendelea';

  @override
  String get booksSchedulePaused => 'Ratiba imesitishwa';

  @override
  String get booksEntryPosted => 'Ingizo limeingizwa';

  @override
  String get booksAlreadyPostedThisPeriod => 'Tayari imeingizwa kipindi hiki';

  @override
  String get booksCouldNotPostEntry => 'Imeshindwa kuingiza ingizo';

  @override
  String get booksScheduleCreated => 'Ratiba imeundwa';

  @override
  String get booksScheduleUpdated => 'Ratiba imesasishwa';

  @override
  String booksPeriodCloseSubtitle(String currency, String period) {
    return 'Funga $period hesabu zikishakamilika · $currency';
  }

  @override
  String booksPeriodLocked(String period) {
    return '$period imefungwa';
  }

  @override
  String get booksReopenPeriod => 'Fungua kipindi tena';

  @override
  String get booksCouldNotReopenPeriod => 'Imeshindwa kufungua kipindi tena';

  @override
  String get booksPeriodReopened => 'Kipindi kimefunguliwa tena';

  @override
  String booksPeriodPostableAgain(String period) {
    return '$period inaweza kuingizwa tena';
  }

  @override
  String get booksClosePeriod => 'Funga kipindi';

  @override
  String get booksCouldNotClosePeriod => 'Imeshindwa kufunga kipindi';

  @override
  String get booksPeriodClosed => 'Kipindi kimefungwa';

  @override
  String booksPeriodLockedReadOnly(String period) {
    return '$period imefungwa · maingizo sasa ni ya kusoma tu';
  }

  @override
  String get booksCloseChecklist => 'Orodha ya kufunga';

  @override
  String booksStepsComplete(String done, String total) {
    return 'Hatua $done kati ya $total zimekamilika';
  }

  @override
  String get booksReview => 'Kagua';

  @override
  String get booksWhatClosingDoes => 'Kufunga hufanya nini';

  @override
  String get booksCloseNoteLocks =>
      'Hufunga kipindi. Maingizo yaliyoingizwa yanakuwa ya kusoma tu — hakuna kuhariri bila kufungua tena.';

  @override
  String get booksCloseNoteRollsForward =>
      'Husogeza mbele. Mapato halisi huhamishiwa kwenye mapato yaliyobakizwa na salio huendelea mwezi ujao.';

  @override
  String get booksCloseNoteAuditPoint =>
      'Huunda kituo cha ukaguzi. Picha ya hali hurekodiwa kwenye kumbukumbu za ukaguzi pamoja na jina lako na muda.';

  @override
  String get booksAllChecksPassed => 'Ukaguzi wote umepita — tayari kufunga.';

  @override
  String get booksFinishChecklist =>
      'Maliza kila hatua ya orodha ili kuwezesha kufunga.';

  @override
  String get booksAuditSubtitle =>
      'Kila mabadiliko, aliyeyafanya na lini · haibadiliki';

  @override
  String get booksAllUsers => 'Watumiaji wote';

  @override
  String get booksExport => 'Hamisha';

  @override
  String get booksExportingAuditLog => 'Inahamisha kumbukumbu za ukaguzi';

  @override
  String booksEventsCsv(String count) {
    return 'Matukio $count · CSV';
  }

  @override
  String get booksNoAuditEvents => 'Bado hakuna matukio ya ukaguzi.';

  @override
  String get booksRolesSubtitle =>
      'Dhibiti nani anaweza kuona na kubadilisha hesabu';

  @override
  String get booksInviteTeammate => 'Mkaribishe mwenzako';

  @override
  String get booksInviteSent => 'Mwaliko umetumwa';

  @override
  String get booksInvitationsComingSoon =>
      'Mialiko ya timu inakuja hivi karibuni';

  @override
  String booksTeamCount(String count) {
    return 'Timu ($count)';
  }

  @override
  String get booksOnlyYouHaveAccess =>
      'Ni wewe tu una ufikiaji. Karibisha wenzako mshirikiane.';

  @override
  String get booksYou => 'Wewe';

  @override
  String get booksRoles => 'Majukumu';

  @override
  String get booksCapability => 'Uwezo';

  @override
  String get booksActiveNow => 'Yuko hai sasa';

  @override
  String get booksRoleSystem => 'Mfumo';

  @override
  String get booksTaskAllPosted => 'Maingizo yote ya jarida yameingizwa';

  @override
  String booksTaskPendingApproval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maingizo $count bado yanasubiri idhini',
      one: 'Ingizo 1 bado linasubiri idhini',
    );
    return '$_temp0';
  }

  @override
  String get booksTaskNoPending => 'Hakuna maingizo yanayosubiri';

  @override
  String get booksTaskBankReconciled => 'Akaunti za benki zimesuluhishwa';

  @override
  String booksTaskLinesUnmatched(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mistari $count haijalinganishwa',
      one: 'Mstari 1 haujalinganishwa',
    );
    return '$_temp0';
  }

  @override
  String get booksTaskAllLinesMatched => 'Mistari yote imelinganishwa';

  @override
  String get booksTaskReceivablesReviewed => 'Madeni ya wateja yamekaguliwa';

  @override
  String get booksTaskNoOpenReceivables =>
      'Hakuna madeni ya wateja yaliyo wazi';

  @override
  String booksTaskAgingOverdue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Umri umethibitishwa · ankara $count zimechelewa',
      one: 'Umri umethibitishwa · ankara 1 imechelewa',
    );
    return '$_temp0';
  }

  @override
  String booksTaskAgingBalances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Umri umethibitishwa · salio $count',
      one: 'Umri umethibitishwa · salio 1',
    );
    return '$_temp0';
  }

  @override
  String get booksTaskPayablesReviewed => 'Madeni ya wasambazaji yamekaguliwa';

  @override
  String get booksTaskNoOpenPayables =>
      'Hakuna madeni ya wasambazaji yaliyo wazi';

  @override
  String get booksTaskAllBillsEntered => 'Bili zote za wasambazaji zimeingizwa';

  @override
  String get booksTaskVatPrepared => 'Ritani ya VAT imeandaliwa';

  @override
  String get booksTaskNoVatActivity => 'Hakuna shughuli za VAT katika kipindi';

  @override
  String booksTaskVatNetPayable(String amount, String date) {
    return 'Halisi inayolipwa $amount · tarehe ya mwisho $date';
  }

  @override
  String get booksTaskDepreciationPosted => 'Uchakavu umeingizwa';

  @override
  String get booksTaskDepreciationMaybePending =>
      'Maingizo yanayosubiri yanaweza kujumuisha uchakavu';

  @override
  String get booksTaskDepreciationUpToDate => 'Uchakavu uko sawa';

  @override
  String get booksStatusSent => 'Imetumwa';

  @override
  String get booksStatusPartPaid => 'Imelipwa sehemu';

  @override
  String get booksStatusPaid => 'Imelipwa';

  @override
  String get booksStatusOverdue => 'Imechelewa';

  @override
  String get booksSignOutTitle => 'Kutoka?';

  @override
  String get booksSignOutBody =>
      'Inamaliza kipindi chako na kufuta usawazishaji wa Ditto kwa kichupo hiki. Chagua “Onyesha upya kutoka wingu” kama unahitaji tu kupakia upya data ya Books.';

  @override
  String get booksRefreshFromCloud => 'Onyesha upya kutoka wingu';

  @override
  String get booksResyncDitto => 'Sawazisha upya data ya Ditto';

  @override
  String get booksSupplier => 'Msambazaji';

  @override
  String get booksAgingCurrent => 'Ya sasa';

  @override
  String get booksAging1to30 => 'Siku 1–30';

  @override
  String get booksAging31to60 => 'Siku 31–60';

  @override
  String get booksAging60plus => 'Siku 60+';

  @override
  String get booksMoneyIn => 'Pesa zinazoingia';

  @override
  String get booksMoneyOut => 'Pesa zinazotoka';

  @override
  String get booksAccountsReceivable => 'Akaunti zinazodaiwa';

  @override
  String get booksAccountsPayable => 'Akaunti zinazolipwa';

  @override
  String booksArSubtitle(String currency) {
    return 'Wateja wanachokudai · kwa umri · $currency';
  }

  @override
  String booksApSubtitle(String currency) {
    return 'Unachodaiwa na wasambazaji · kwa umri · $currency';
  }

  @override
  String get booksSendReminders => 'Tuma vikumbusho';

  @override
  String get booksSchedulePayment => 'Panga malipo';

  @override
  String get booksRemindersSent => 'Vikumbusho vimetumwa';

  @override
  String get booksPaymentScheduled => 'Malipo yamepangwa';

  @override
  String booksEmailedCustomers(String count) {
    return 'Wateja $count wenye salio wazi wametumiwa barua pepe';
  }

  @override
  String booksQueuedSupplierPayments(String count) {
    return 'Malipo $count ya wasambazaji yamepangwa foleni';
  }

  @override
  String get booksNewInvoice => 'Ankara mpya';

  @override
  String get booksNewBill => 'Bili mpya';

  @override
  String get booksAgingSummary => 'Muhtasari wa umri';

  @override
  String get booksReference => 'Kumbukumbu';

  @override
  String get booksTotal => 'Jumla';

  @override
  String get booksStatementOfAccount => 'Taarifa ya akaunti';

  @override
  String booksOutstanding(String amount, String name) {
    return '$name · $amount inayodaiwa';
  }

  @override
  String booksJournalSubtitle(String currency) {
    return 'Kila muamala kama ingizo mbili zilizosawazishwa · $currency';
  }

  @override
  String get booksFilterBySource => 'Chuja kwa chanzo';

  @override
  String get booksAllSources => 'Vyanzo vyote';

  @override
  String get booksRecordExpense => 'Rekodi matumizi';

  @override
  String get booksNewJournalEntry => 'Ingizo jipya la jarida';

  @override
  String get booksFilterAll => 'Zote';

  @override
  String get booksFilterPosted => 'Zilizoingizwa';

  @override
  String get booksFilterPending => 'Zinazosubiri';

  @override
  String get booksFilterDrafts => 'Rasimu';

  @override
  String booksEntriesAwaitingApproval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maingizo $count yanasubiri idhini',
      one: 'Ingizo 1 linasubiri idhini',
    );
    return '$_temp0';
  }

  @override
  String get booksNoEntriesMatchFilter =>
      'Hakuna maingizo yanayolingana na kichujio hiki.';

  @override
  String get booksDrAbbr => 'Debiti';

  @override
  String get booksCrAbbr => 'Krediti';

  @override
  String get booksFinancialOverview => 'Muhtasari wa fedha';

  @override
  String get booksAtAGlance => 'Hesabu kwa haraka';

  @override
  String booksDashSubtitleEntity(
    String currency,
    String entity,
    String period,
  ) {
    return '$entity · kipindi cha fedha $period · kiasi chote kwa $currency';
  }

  @override
  String booksDashSubtitle(String currency, String period) {
    return 'Kipindi cha fedha $period · kiasi chote kwa $currency';
  }

  @override
  String get booksGeneralLedgerLines => 'Mistari ya leja kuu';

  @override
  String get booksExportingExcel => 'Inahamisha kwenda Excel';

  @override
  String get booksExportingCsv => 'Inahamisha CSV';

  @override
  String get booksExcelWorkbook => 'Kitabu cha Excel (.xlsx)';

  @override
  String get booksPdfReport => 'Ripoti ya PDF';

  @override
  String get booksCsvRawLedger => 'CSV (leja ghafi)';

  @override
  String get booksVsPriorPeriod => 'ikilinganishwa na kipindi kilichopita';

  @override
  String get booksCashAndBank => 'Fedha taslimu na benki';

  @override
  String booksAcrossAccounts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'katika akaunti $count',
      one: 'katika akaunti 1',
    );
    return '$_temp0';
  }

  @override
  String get booksReceivable => 'Inayodaiwa';

  @override
  String booksOverdue60(String amount) {
    return '$amount zimechelewa siku 60+';
  }

  @override
  String get booksNoOverdue60 => 'hakuna zilizochelewa siku 60+';

  @override
  String get booksPayable => 'Inayolipwa';

  @override
  String get booksNoOpenBills => 'hakuna bili zilizo wazi';

  @override
  String booksOpenBills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bili $count zilizo wazi',
      one: 'Bili 1 iliyo wazi',
    );
    return '$_temp0';
  }

  @override
  String get booksRevenueVsExpenses => 'Mapato dhidi ya matumizi';

  @override
  String get booksTrailing6Months => 'Miezi 6 iliyopita';

  @override
  String get booksWhereMoneyWent => 'Pesa zilikokwenda';

  @override
  String get booksOpexBreakdown => 'Mgawanyo wa gharama za uendeshaji';

  @override
  String get booksOpexShort => 'uendeshaji';

  @override
  String get booksRecentJournalEntries => 'Maingizo ya hivi karibuni';

  @override
  String get booksNoJournalEntriesYet => 'Bado hakuna maingizo ya jarida.';

  @override
  String get booksProfitLoss => 'Faida na hasara';

  @override
  String booksDocAlreadyExists(String id) {
    return '$id tayari ipo';
  }

  @override
  String get booksUseAnotherNumber => 'Tumia nambari nyingine';

  @override
  String get booksBillSaved => 'Bili imehifadhiwa';

  @override
  String get booksDraftSaved => 'Rasimu imehifadhiwa';

  @override
  String get booksInvoiceSentPosted => 'Ankara imetumwa na kuingizwa';

  @override
  String get booksBillRecordedPosted => 'Bili imerekodiwa na kuingizwa';

  @override
  String get booksPaymentRecorded => 'Malipo yamerekodiwa';

  @override
  String booksInvoicesSubtitle(String currency) {
    return 'Watoze wateja wako ankara na ulipwe · $currency';
  }

  @override
  String booksBillsSubtitle(String currency) {
    return 'Fuatilia unachodaiwa na wasambazaji wako · $currency';
  }

  @override
  String get booksPdfSummary => 'Muhtasari wa PDF';

  @override
  String booksInvoicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ankara $count',
      one: 'Ankara 1',
    );
    return '$_temp0';
  }

  @override
  String booksBillsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bili $count',
      one: 'Bili 1',
    );
    return '$_temp0';
  }

  @override
  String get booksOutstandingLabel => 'Inayodaiwa';

  @override
  String get booksOwedToSuppliers => 'Deni kwa wasambazaji';

  @override
  String get booksDrafts => 'Rasimu';

  @override
  String get booksNoInvoicesYet =>
      'Bado hakuna ankara. Unda ankara ili kuanza.';

  @override
  String get booksNoBillsYet => 'Bado hakuna bili. Rekodi bili ili kuanza.';

  @override
  String booksNoInvoicesInTab(String tab) {
    return 'Hakuna ankara katika “$tab”.';
  }

  @override
  String booksNoBillsInTab(String tab) {
    return 'Hakuna bili katika “$tab”.';
  }

  @override
  String get booksBill => 'Bili';

  @override
  String get booksDue => 'Tarehe ya mwisho';

  @override
  String get booksOpenPreview => 'Fungua na uhakiki';

  @override
  String get booksRecordPayment => 'Rekodi malipo';

  @override
  String get booksPayThisBill => 'Lipa bili hii';

  @override
  String get booksSendReminder => 'Tuma kikumbusho';

  @override
  String get booksReminderSent => 'Kikumbusho kimetumwa';

  @override
  String get booksDeleted => 'Imefutwa';

  @override
  String get booksCustomerAdded => 'Mteja ameongezwa';

  @override
  String get booksSupplierAdded => 'Msambazaji ameongezwa';

  @override
  String booksCustomersSubtitle(String count) {
    return 'Watu na biashara unaowauzia · rekodi $count';
  }

  @override
  String booksSuppliersSubtitle(String count) {
    return 'Wauzaji unaonunua kutoka kwao · rekodi $count';
  }

  @override
  String get booksSearchCustomers => 'Tafuta wateja…';

  @override
  String get booksSearchSuppliers => 'Tafuta wasambazaji…';

  @override
  String get booksNewCustomer => 'Mteja mpya';

  @override
  String get booksNewSupplier => 'Msambazaji mpya';

  @override
  String get booksTotalCustomers => 'Jumla ya wateja';

  @override
  String get booksTotalSuppliers => 'Jumla ya wasambazaji';

  @override
  String get booksWithOpenBalance => 'Wenye salio wazi';

  @override
  String get booksWithBillsDue => 'Wenye bili zinazodaiwa';

  @override
  String get booksTotalReceivable => 'Jumla inayodaiwa';

  @override
  String get booksTotalPayable => 'Jumla inayolipwa';

  @override
  String get booksNoCustomersYet => 'Bado hakuna wateja.';

  @override
  String get booksNoSuppliersYet => 'Bado hakuna wasambazaji.';

  @override
  String booksNoMatchesFor(String query) {
    return 'Hakuna kinacholingana na “$query”.';
  }

  @override
  String get booksContact => 'Mawasiliano';

  @override
  String get booksTerms => 'Masharti';

  @override
  String get booksOwesYou => 'Anakudai';

  @override
  String get booksYouOwe => 'Unadaiwa';

  @override
  String get booksViewRecord => 'Tazama rekodi';

  @override
  String get booksSendStatement => 'Tuma taarifa';

  @override
  String get booksCallContact => 'Piga simu';

  @override
  String get booksStatementSent => 'Taarifa imetumwa';

  @override
  String get booksNoPhoneOnFile => 'Hakuna nambari ya simu iliyohifadhiwa';

  @override
  String booksDeleteNamed(String name) {
    return 'Futa $name?';
  }

  @override
  String get booksDeleteSharedContactBody =>
      'Mawasiliano haya yanashirikiwa na programu ya POS. Kuyafuta kunaondoa rekodi ya mteja kila mahali; mauzo ya awali yanabaki na nakala yake lakini yanapoteza kiungo. Futa hata hivyo?';

  @override
  String get booksDeleteEverywhere => 'Futa kila mahali';

  @override
  String booksCustomerSince(String date) {
    return 'Mteja tangu $date';
  }

  @override
  String booksSupplierSince(String date) {
    return 'Msambazaji tangu $date';
  }

  @override
  String get booksOutstandingBalance => 'Salio linalodaiwa';

  @override
  String get booksAmountPayable => 'Kiasi kinacholipwa';

  @override
  String get booksLifetimeBilled => 'Jumla iliyotozwa';

  @override
  String get booksLifetimePurchased => 'Jumla iliyonunuliwa';

  @override
  String get booksContactDetails => 'MAELEZO YA MAWASILIANO';

  @override
  String get booksPrimaryContact => 'Mtu mkuu wa mawasiliano';

  @override
  String booksInvoicesHeader(String count) {
    return 'ANKARA ($count)';
  }

  @override
  String booksBillsHeader(String count) {
    return 'BILI ($count)';
  }

  @override
  String get booksNoDocumentsYet => 'Bado hakuna nyaraka.';

  @override
  String get booksAddCustomerToContacts =>
      'Ongeza mteja kwenye mawasiliano yako';

  @override
  String get booksAddSupplierToContacts =>
      'Ongeza msambazaji kwenye mawasiliano yako';

  @override
  String get booksBusinessCustomerName => 'Jina la biashara / mteja';

  @override
  String get booksSupplierName => 'Jina la msambazaji';

  @override
  String get booksExampleBusinessName => 'mf. Karake Retail Group';

  @override
  String get booksFullName => 'Jina kamili';

  @override
  String get booksEmailPlaceholder => 'jina@email.rw';

  @override
  String get booksTaxId => 'Nambari ya kodi';

  @override
  String get booksPaymentTerms => 'Masharti ya malipo';

  @override
  String get booksAddSupplier => 'Ongeza msambazaji';

  @override
  String booksNetDays(String days) {
    return 'Siku $days';
  }

  @override
  String booksNewInvoiceTitle(String id) {
    return 'Ankara mpya · $id';
  }

  @override
  String booksEditInvoiceTitle(String id) {
    return 'Hariri ankara · $id';
  }

  @override
  String booksNewBillTitle(String id) {
    return 'Bili mpya · $id';
  }

  @override
  String booksEditBillTitle(String id) {
    return 'Hariri bili · $id';
  }

  @override
  String get booksInvoiceEditorSubtitle =>
      'Mtoze mteja ankara — Flipper huingiza mauzo na VAT kiotomatiki.';

  @override
  String get booksBillEditorSubtitle =>
      'Rekodi bili ya msambazaji — Flipper huingiza matumizi na VAT ya manunuzi.';

  @override
  String get booksSelectCustomer => 'Chagua mteja…';

  @override
  String get booksSelectSupplier => 'Chagua msambazaji…';

  @override
  String get booksIssueDate => 'Tarehe ya kutolewa';

  @override
  String get booksBillDate => 'Tarehe ya bili';

  @override
  String get booksDueDateLabel => 'Tarehe ya mwisho';

  @override
  String get booksLineItems => 'Vipengee';

  @override
  String get booksAddLine => 'Ongeza mstari';

  @override
  String get booksInvoiceWillPost => 'Ankara hii itaingizwa hivi';

  @override
  String get booksBillWillPost => 'Bili hii itaingizwa hivi';

  @override
  String get booksSaveDraft => 'Hifadhi rasimu';

  @override
  String get booksSaveAndSend => 'Hifadhi na utume';

  @override
  String get booksDownloadPdfOnly => 'Pakua PDF pekee';

  @override
  String get booksApproveInPurchases => 'Idhinisha katika Manunuzi';

  @override
  String get booksRecordBill => 'Rekodi bili';

  @override
  String booksNewScheduleTitle(String id) {
    return 'Ratiba mpya · $id';
  }

  @override
  String booksEditScheduleTitle(String id) {
    return 'Hariri ratiba · $id';
  }

  @override
  String get booksScheduleEditorSubtitle =>
      'Maingizo yanayojirudia hujiingiza yenyewe kwa jarida lililosawazishwa.';

  @override
  String get booksScheduleName => 'Jina la ratiba';

  @override
  String get booksScheduleNameHint => 'mf. Kodi ya kila mwezi';

  @override
  String get booksDay => 'Siku';

  @override
  String get booksDayHint => 'mf. 1';

  @override
  String get booksDebitAccountLabel => 'Akaunti ya debiti (matumizi / mali)';

  @override
  String get booksCreditAccountLabel => 'Akaunti ya krediti (chanzo cha fedha)';

  @override
  String get booksSelectAccount => 'Chagua akaunti…';

  @override
  String get booksAccountsMustDiffer =>
      'Akaunti za debiti na krediti lazima ziwe tofauti.';

  @override
  String get booksActive => 'Inatumika';

  @override
  String get booksPausedLabel => 'Imesitishwa';

  @override
  String get booksSaveSchedule => 'Hifadhi ratiba';

  @override
  String get booksPaymentFailed => 'Malipo yameshindwa';

  @override
  String booksInvoicePaidMessage(String amount, String who) {
    return '$who amelipa $amount. Ankara imewekwa kama imelipwa.';
  }

  @override
  String booksBillPartPaidMessage(String amount, String balance, String who) {
    return 'Umelipa $amount kwa $who. Bado unadaiwa $balance.';
  }

  @override
  String booksBillSettledMessage(String amount, String who) {
    return 'Umelipa $amount kwa $who. Bili imelipwa kikamilifu.';
  }

  @override
  String get booksPayBill => 'Lipa bili';

  @override
  String booksAmountDue(String amount, String id, String who) {
    return '$id · $who · $amount inayodaiwa';
  }

  @override
  String get booksDepositTo => 'Weka kwenye';

  @override
  String get booksPayFrom => 'Lipa kutoka';

  @override
  String get booksAmountReceived => 'Kiasi kilichopokelewa';

  @override
  String get booksPostsAs => 'Inaingizwa kama';

  @override
  String get booksBusinessFallback => 'Biashara';

  @override
  String get booksInvoiceUpper => 'ANKARA';

  @override
  String get booksBillUpper => 'BILI';

  @override
  String get booksBillTo => 'Itozwe kwa';

  @override
  String get booksFrom => 'Kutoka';

  @override
  String get booksIssued => 'Imetolewa';

  @override
  String get booksDescription => 'Maelezo';

  @override
  String get booksQty => 'Idadi';

  @override
  String get booksItemOrService => 'Bidhaa au huduma';

  @override
  String get booksItemOrServiceHint => 'Bidhaa au huduma…';

  @override
  String booksBalancedEquation(String amount, String total) {
    return 'Imesawazishwa · $total = $amount';
  }

  @override
  String get booksVat18 => 'VAT (18%)';

  @override
  String get booksPillPosted => 'imeingizwa';

  @override
  String get booksPillPending => 'inasubiri';

  @override
  String get booksPillDraft => 'rasimu';

  @override
  String get booksTypeAsset => 'Mali';

  @override
  String get booksTypeLiability => 'Deni';

  @override
  String get booksTypeEquity => 'Mtaji';

  @override
  String get booksTypeIncome => 'Mapato';

  @override
  String get booksTypeExpense => 'Matumizi';

  @override
  String get booksCodeInUse => 'Msimbo tayari unatumika';

  @override
  String get booksPickDifferentCode => 'Chagua msimbo mwingine wa akaunti';

  @override
  String get booksAccountCreated => 'Akaunti imeundwa';

  @override
  String get booksCouldNotCreateAccount => 'Imeshindwa kuunda akaunti';

  @override
  String get booksNewAccount => 'Akaunti mpya';

  @override
  String get booksAddLineToCoa => 'Ongeza mstari kwenye orodha ya akaunti';

  @override
  String get booksAccountType => 'Aina ya akaunti';

  @override
  String get booksCode => 'Msimbo';

  @override
  String get booksCodeHint => 'mf. 6060';

  @override
  String get booksCategoryHint => 'mf. Gharama za uendeshaji';

  @override
  String get booksAccountName => 'Jina la akaunti';

  @override
  String get booksAccountNameHint => 'mf. Vifaa vya ofisi';

  @override
  String get booksCreating => 'Inaunda…';

  @override
  String get booksCreateAccount => 'Unda akaunti';

  @override
  String get booksDrShort => 'Db';

  @override
  String get booksCrShort => 'Kr';

  @override
  String booksEntryMeta(String date, String ref, String source) {
    return '$date · $ref · kupitia $source';
  }

  @override
  String booksBalancedDrCr(String cr, String dr) {
    return 'Imesawazishwa · $dr = $cr';
  }

  @override
  String get booksApprovedPosted => 'Imeidhinishwa na kuingizwa';

  @override
  String get booksSentBackToDrafts => 'Imerudishwa kwenye rasimu';

  @override
  String get booksReject => 'Kataa';

  @override
  String get booksApprove => 'Idhinisha';

  @override
  String get booksSubmittedForApproval => 'Imewasilishwa kwa idhini';

  @override
  String get booksSubmittedForApprovalBody =>
      'Debiti ni sawa na krediti. Kagua na uidhinishe kutoka kichupo cha Idhini ili kuingiza kwenye leja.';

  @override
  String get booksRecordExpenseSubtitle =>
      'Chagua kundi na jinsi ulivyolipa — Flipper huingiza ingizo lililosawazishwa.';

  @override
  String get booksExpenseCategory => 'Kundi la matumizi';

  @override
  String get booksAddExpenseAccount => '+ Ongeza akaunti ya matumizi';

  @override
  String get booksPaidVia => 'Imelipwa kupitia';

  @override
  String get booksMemoDescription => 'Kumbukumbu / maelezo';

  @override
  String get booksExpenseMemoHint => 'Matumizi haya yalikuwa ya nini?';

  @override
  String get booksSubmitForApproval => 'Wasilisha kwa idhini';

  @override
  String get booksJournalPreview => 'Onyesho la jarida';

  @override
  String booksBalancedAmount(String amount) {
    return 'Imesawazishwa · $amount';
  }

  @override
  String get booksTplRecordSale => 'Rekodi mauzo';

  @override
  String get booksTplPayExpense => 'Lipa matumizi';

  @override
  String get booksTplReceivePayment => 'Pokea malipo';

  @override
  String get booksTplPayBill => 'Lipa bili';

  @override
  String booksDraftKeptInDrafts(String ref) {
    return '$ref imehifadhiwa kwenye Rasimu';
  }

  @override
  String get booksCouldNotSaveEntry => 'Imeshindwa kuhifadhi ingizo';

  @override
  String get booksQuickStart => 'Anza haraka';

  @override
  String get booksEntryMemoHint => 'Ingizo hili ni la nini?';

  @override
  String get booksLines => 'Mistari';

  @override
  String booksDebitCreditHint(String into, String out) {
    return 'Kila ingizo lina pande mbili. Pesa $into kwenye akaunti ni debiti; pesa $out ni krediti. Lazima ziwe na jumla sawa.';
  }

  @override
  String get booksMoneyIntoWord => 'zinazoingia';

  @override
  String get booksMoneyOutWord => 'zinazotoka';

  @override
  String get booksComposerSubtitle =>
      'Chagua akaunti na uweke kiasi — Flipper huhakikisha vinasawazishwa.';

  @override
  String get booksAccountUpper => 'AKAUNTI';

  @override
  String get booksDebitUpper => 'DEBITI';

  @override
  String get booksCreditUpper => 'KREDITI';

  @override
  String get booksBalanced => 'Imesawazishwa';

  @override
  String get booksEnterAmounts => 'Weka kiasi';

  @override
  String booksOffBy(String amount) {
    return 'Tofauti ya $amount';
  }

  @override
  String get booksTotalDebits => 'Jumla ya debiti';

  @override
  String get booksTotalCredits => 'Jumla ya krediti';

  @override
  String get booksSearchAccounts => 'Tafuta akaunti…';

  @override
  String get booksDataRefreshed =>
      'Data ya Books imeonyeshwa upya kutoka wingu';

  @override
  String booksActionFailed(String error) {
    return 'Kitendo kimeshindwa: $error';
  }

  @override
  String get booksAllCaughtUp => 'Kila kitu kiko sawa';

  @override
  String get booksNotificationsMarkedRead => 'Arifa zimewekwa kama zimesomwa';

  @override
  String get booksSearchPlaceholder => 'Tafuta maingizo, akaunti, ankara…';

  @override
  String get booksFiscalPeriod => 'Kipindi cha fedha';

  @override
  String get booksPeriodChanged => 'Kipindi kimebadilishwa';

  @override
  String booksFiscalPeriodYear(String year) {
    return 'Kipindi cha fedha $year';
  }

  @override
  String get booksNotifications => 'Arifa';

  @override
  String get booksMarkAllRead => 'Weka zote kama zimesomwa';

  @override
  String get booksEntriesAwaitingApprovalTitle =>
      'Maingizo ya jarida yanayosubiri idhini';

  @override
  String get booksReviewPendingPostings => 'Kagua maingizo mawili yanayosubiri';

  @override
  String get booksNoNewNotifications => 'Hakuna arifa mpya';

  @override
  String get booksNoPendingEntries => 'Hakuna maingizo ya jarida yanayosubiri';

  @override
  String get booksTabSnapshot => 'Muhtasari';

  @override
  String get booksTabApprovals => 'Idhini';

  @override
  String booksCouldNotRestoreBusiness(String error) {
    return 'Imeshindwa kurejesha muktadha wa biashara: $error';
  }

  @override
  String get webHomeNavPlatform => 'Jukwaa';

  @override
  String get webHomeNavFeatures => 'Vipengele';

  @override
  String get webHomeLogIn => 'Ingia';

  @override
  String get webHomeStartFree => 'Anza bure';

  @override
  String get webHomeHeroLine1 => 'Uhasibu';

  @override
  String get webHomeHeroLine2Lead => 'unaojiendesha';

  @override
  String get webHomeHeroLine2Accent => 'wenyewe.';

  @override
  String get webHomeHeroBody =>
      'Flipper Books ni uhasibu wa kisasa kwa biashara zinazokua. Kila mauzo kutoka Flipper POS yanaingia moja kwa moja kwenye leja yako — na Flow AI hupanga, kusuluhisha na kuwasilisha yaliyobaki. Wewe unaendesha biashara yako tu.';

  @override
  String get webHomeSeeHowItWorks => 'Tazama jinsi inavyofanya kazi';

  @override
  String get webHomeCheckEbmReady => 'Tayari kwa RRA / EBM';

  @override
  String get webHomeCheckOffline => 'Inafanya kazi bila mtandao';

  @override
  String get webHomeCheckRwf => 'Imejengwa kwa RWF';

  @override
  String get webHomeTrustTagline =>
      'Imejengwa kwa biashara kila mahali — na jinsi pesa zinavyosonga kwa kweli.';

  @override
  String get webHomeTrustTaxIntegration => 'muunganisho wa kodi';

  @override
  String get webHomeTrustBusinesses => 'biashara';

  @override
  String get webHomeTrustMomoBank => 'Usawazishaji wa MoMo na benki';

  @override
  String get webHomeTrustRealtimeLedger => 'Leja ya wakati halisi';

  @override
  String get webHomeSuiteEyebrow => 'Jukwaa moja';

  @override
  String get webHomeSuiteTitle =>
      'Programu tatu. Leja moja. Hakuna kuingiza mara mbili.';

  @override
  String get webHomeSuiteBody =>
      'Flipper POS, Books na Flow si miunganisho iliyobandikwa pamoja — ni mfumo mmoja. Pesa hupita mara moja, na hesabu zako hubaki zimefungwa.';

  @override
  String get webHomeLoopSellOnPos => 'Uza kwenye POS →';

  @override
  String get webHomeLoopPostsToBooks => 'inaingia kwenye Books';

  @override
  String get webHomeLoopFlowReconciles => 'Flow inasuluhisha';

  @override
  String get webHomeLoopTail =>
      '→ unaona faida kwa wakati halisi. Mzunguko mmoja, otomatiki kabisa.';

  @override
  String get webHomePosRole => 'Uza';

  @override
  String get webHomePosTagline => 'Kaunta ya mbele';

  @override
  String get webHomePosBody =>
      'Rekodi mauzo kwenye simu au kompyuta, changanua bidhaa, pokea fedha taslimu au MoMo. Inafanya kazi mara tu unapofungua duka — mtandaoni au bila mtandao.';

  @override
  String get webHomeBooksRole => 'Hesabu';

  @override
  String get webHomeBooksTagline => 'Chanzo cha ukweli';

  @override
  String get webHomeBooksBody =>
      'Kila mauzo huingia kama ingizo lililosawazishwa. Faida na hasara, mtiririko wa fedha, madeni na kodi tayari kwa EBM kwa wakati halisi — bila lahajedwali, bila haraka ya mwisho wa mwezi.';

  @override
  String get webHomeFlowRole => 'Endesha otomatiki';

  @override
  String get webHomeFlowTagline => 'Mtunza hesabu wa AI';

  @override
  String get webHomeFlowBody =>
      'Flow hufuatilia mtiririko wote — kupanga, kusuluhisha, kuashiria hitilafu na kuandaa kodi. Kazi iliyomchukua mhasibu wiki moja inafanyika kwa wakati halisi.';

  @override
  String get webHomeMeetFlow => 'Kutana na Flow AI';

  @override
  String get webHomeFlowHeadlineLead => 'Hesabu zako, zinazotunzwa na';

  @override
  String get webHomeFlowHeadlineAccent => 'mtunza hesabu wa AI.';

  @override
  String get webHomeFlowLead =>
      'Flow hugeuza miamala ghafi kuwa uhasibu safi ulio tayari kwa ukaguzi — na hukuuliza tu inapohitaji uamuzi kweli. Lala bila usumbufu wa kazi za uhasibu.';

  @override
  String get webHomeFlowAutoCat => 'Upangaji otomatiki';

  @override
  String get webHomeFlowAutoCatBody =>
      'Kila mauzo, matumizi na uhamisho huwekwa kwenye akaunti sahihi papo hapo.';

  @override
  String get webHomeFlowRecon => 'Usuluhishi wa benki na MoMo';

  @override
  String get webHomeFlowReconBody =>
      'Flow hulinganisha leja yako na taarifa kiotomatiki na kuonyesha tu tofauti halisi.';

  @override
  String get webHomeFlowTax => 'Kodi na VAT, zimeandaliwa';

  @override
  String get webHomeFlowTaxBody =>
      'Mawasilisho tayari kwa EBM yanaandaliwa kutoka leja yako, ili tarehe za mwisho za RRA zisiwe hofu tena.';

  @override
  String get webHomeFlowAnomaly => 'Arifa za hitilafu';

  @override
  String get webHomeFlowAnomalyBody =>
      'Maingizo yaliyorudiwa, kushuka kwa faida na matumizi yasiyo ya kawaida huashiriwa kabla hayajawa tatizo.';

  @override
  String get webHomeExploreFlow => 'Gundua Flow AI';

  @override
  String get webHomeWatchingLedger => 'Inafuatilia leja yako';

  @override
  String get webHomeChatUser1 =>
      'Mauzo mapya ya RWF 12,000 yameingia kwenye POS, yamelipwa kwa MoMo. Yarekodi.';

  @override
  String get webHomeChatBot1 =>
      'Imekamilika — nimeingiza ingizo lililosawazishwa na kulisuluhisha na akaunti yako ya MTN MoMo. Hili ndilo ingizo:';

  @override
  String get webHomeChatUser2 =>
      'Kuna chochote ninachopaswa kuangalia wiki hii?';

  @override
  String get webHomeChatBot2 =>
      'VAT ya Mei iko tayari kuwasilishwa (RWF 318,400) na msambazaji mmoja alilipwa mara mbili — nimeiashiria kwenye Madeni.';

  @override
  String get webHomeCapMultiBranch => 'Matawi mengi';

  @override
  String get webHomeCapStatementsBody =>
      'Taarifa ya mapato, mizania na mtiririko wa fedha vinatengenezwa moja kwa moja kutoka leja kuu yako.';

  @override
  String get webHomeCapBankRecBody =>
      'Linganisha mistari ya leja na taarifa za benki na MoMo kwa mara moja, tofauti zikionyeshwa kwako.';

  @override
  String get webHomeCapArAp => 'Madeni ya wateja na wasambazaji';

  @override
  String get webHomeCapArApBody =>
      'Fuatilia nani anakudai na unachodaiwa, kwa makundi ya umri na vikumbusho otomatiki.';

  @override
  String get webHomeCapTaxBody =>
      'Muunganisho wa EBM 2.1 na VAT inayokokotolewa kila mara — mawasilisho yanaandaliwa kabla ya tarehe ya mwisho.';

  @override
  String get webHomeCapCoaBody =>
      'Muundo wa leja wenye nambari, rafiki kwa ukaguzi, unaoendana na jinsi biashara yako ilivyopangwa.';

  @override
  String get webHomeCapMultiBranchBody =>
      'Unganisha kila duka kwenye seti moja ya hesabu, kisha chunguza tawi lolote peke yake.';

  @override
  String get webHomeInsideBooks => 'NDANI YA BOOKS';

  @override
  String get webHomeCapTitle => 'Kila anachofanya mhasibu — kimejengwa ndani.';

  @override
  String get webHomeCapBody =>
      'Uhasibu wa pande mbili ulio makini kwa mkaguzi wako na rahisi kuuendesha mwenyewe.';

  @override
  String get webHomePricingEyebrow => 'BEI';

  @override
  String get webHomePricingBody =>
      'Chagua mpango unaokufaa zaidi. Kila mpango unajumuisha Flipper yote — POS, Books na Flow.';

  @override
  String get webHomeContactSales => 'Wasiliana na mauzo';

  @override
  String get webHomeBandTitle => 'Duka lako, hesabu zako, mahali pamoja.';

  @override
  String get webHomeBandBody =>
      'Anza kuuza kwenye Flipper leo na uache Flow itunze hesabu zako — kiotomatiki, kwa wakati halisi. Endelea pale ulipoishia.';

  @override
  String get webHomeTalkToSales => 'Ongea na mauzo';

  @override
  String get webHomeStatProcessedMonthly => 'huchakatwa kila mwezi';

  @override
  String get webHomeStatUptime => 'muda wa kufanya kazi';

  @override
  String get webHomeRevenueThisWeek => 'Mapato · wiki hii';

  @override
  String get webHomeNewSale => 'Mauzo mapya';

  @override
  String webHomeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Siku $count',
      one: 'Siku 1',
    );
    return '$_temp0';
  }

  @override
  String get webHomeSalesStreak => 'Mfululizo wa mauzo';

  @override
  String get webHomeFooterTagline =>
      'Jukwaa la biashara lililounganishwa kwa Afrika — mauzo, uhasibu na mtunza hesabu wa AI, mahali pamoja.';

  @override
  String get webHomeCopyright =>
      '© 2026 Flipper. Imetengenezwa kwa biashara kila mahali.';

  @override
  String get webHomePrivacy => 'Faragha';

  @override
  String get webHomeTerms => 'Masharti';

  @override
  String get webHomeFooterPlatform => 'JUKWAA';

  @override
  String get webHomeFooterCompany => 'KAMPUNI';

  @override
  String get webHomeFooterSupport => 'MSAADA';

  @override
  String get webHomeAbout => 'Kuhusu';

  @override
  String get webHomeBlog => 'Blogu';

  @override
  String get webHomeCareers => 'Ajira';

  @override
  String get webHomeContact => 'Wasiliana';

  @override
  String get webHomeHelpCenter => 'Kituo cha msaada';

  @override
  String get webHomeDownload => 'Pakua';

  @override
  String get webHomeStatus => 'Hali ya mfumo';

  @override
  String get webHomeCommunity => 'Jumuiya';

  @override
  String get webHomePoweredBy => 'Flipper Books · inaendeshwa na';

  @override
  String get webHomeMostPopular => 'Maarufu zaidi';

  @override
  String get webHomeSwitchToLight => 'Badilisha kwenda hali ya mwanga';

  @override
  String get webHomeSwitchToDark => 'Badilisha kwenda hali ya giza';

  @override
  String get webHomeLightMode => 'Hali ya mwanga';

  @override
  String get webHomeDarkMode => 'Hali ya giza';

  @override
  String get webHomeMockFinancialOverview => 'MUHTASARI WA FEDHA';

  @override
  String get webHomeMockCashOnHand => 'Fedha zilizopo';

  @override
  String get webHomeMockRevenueTrend => 'Mwenendo wa mapato';

  @override
  String get webHomeMockLast8Months => 'Miezi 8 iliyopita';

  @override
  String get webHomeMockCostOfSales => 'Gharama ya mauzo';

  @override
  String get webHomeMockOperatingExp => 'Gharama za uendeshaji';

  @override
  String get webHomeMockAutoPosted => 'IMEINGIZWA KIOTOMATIKI';

  @override
  String webHomeMockToast(String account, String pos) {
    return 'Mauzo mapya kwenye $pos — yamepangwa kwenye $account na kusuluhishwa na MoMo.';
  }

  @override
  String get webHomeMockSalesRevenue => 'Mapato ya mauzo';

  @override
  String get webHomeMockBalancedSuffix => '· imesawazishwa';

  @override
  String get webHomeMockPending => '● INASUBIRI';

  @override
  String get webHomeMockSearchOrScan => 'Tafuta au changanua…';

  @override
  String webHomeMockLeft(String count) {
    return '$count zimebaki';
  }

  @override
  String get webAppsFinance => 'Fedha';

  @override
  String get webAppsSell => 'Kuuza';

  @override
  String get webAppsEverything => 'Kila kitu katika biashara yako';

  @override
  String webAppsComingSoon(String app) {
    return '$app — inakuja hivi karibuni';
  }

  @override
  String get webBillingInvalidMomo =>
      'Weka nambari sahihi ya Mobile Money, mf. 0788123456.';

  @override
  String get webBillingPreparing => 'Tunaandaa usajili wako…';

  @override
  String webBillingCouldNotSave(String error) {
    return 'Imeshindwa kuhifadhi usajili: $error';
  }

  @override
  String get webBillingNoPlanIdCharge =>
      'Usajili huu bado hauna kitambulisho cha mpango, hivyo hauwezi kutozwa kwa usalama. Pakia upya na ujaribu tena.';

  @override
  String get webBillingNoPlanIdPay =>
      'Usajili huu bado hauna kitambulisho cha mpango, hivyo hauwezi kulipwa kwa usalama. Pakia upya na ujaribu tena.';

  @override
  String get webBillingSendingRequest => 'Tunatuma ombi kwenye simu yako…';

  @override
  String get webBillingApproveOnPhone =>
      'Idhinisha ombi la Mobile Money kwenye simu yako.';

  @override
  String webBillingCouldNotStart(String error) {
    return 'Malipo hayakuweza kuanzishwa: $error';
  }

  @override
  String get webBillingConsentDeclined =>
      'Idhini ya Mobile Money ilikataliwa, hivyo hakuna kilichotozwa.';

  @override
  String get webBillingCouldNotStartPlain => 'Malipo hayakuweza kuanzishwa.';

  @override
  String get webBillingNoReference =>
      'Lango lilikubali malipo lakini halikurudisha kumbukumbu ya kuyafuatilia. Angalia simu yako, kisha ujaribu tena.';

  @override
  String get webBillingPaymentReceived =>
      'Malipo yamepokelewa. Usajili wako uko hai.';

  @override
  String get webBillingNotCompletedOnPhone =>
      'Malipo hayakukamilika kwenye simu yako.';

  @override
  String get webBillingMomoNoVerdict =>
      'Bado hatujapata jibu kutoka Mobile Money. Ikiwa uliidhinisha ombi, Books itafunguka hivi karibuni — angalia tena baada ya muda mfupi.';

  @override
  String get webBillingCardNeedsEmail =>
      'Malipo ya kadi yanahitaji anwani ya barua pepe kwa risiti.';

  @override
  String get webBillingOpeningPaymentPage => 'Tunafungua ukurasa wa malipo…';

  @override
  String webBillingCardCouldNotStart(String error) {
    return 'Malipo ya kadi hayakuweza kuanzishwa: $error';
  }

  @override
  String get webBillingAlreadyActive => 'Usajili huu tayari uko hai.';

  @override
  String get webBillingCouldNotOpenCardPage =>
      'Imeshindwa kufungua ukurasa wa malipo ya kadi kwenye kivinjari hiki.';

  @override
  String get webBillingSubscriptionEnded =>
      'Usajili huu umekwisha. Chagua mpango ili kuanza tena.';

  @override
  String get webBillingFinishOnOpenedPage =>
      'Kamilisha malipo kwenye ukurasa uliofunguka sasa hivi. Books itafunguka hapa mara kadi itakapotozwa.';

  @override
  String get webBillingCheckingCard => 'Tunakagua malipo yako ya kadi…';

  @override
  String webBillingCouldNotCheckCard(String error) {
    return 'Imeshindwa kukagua malipo ya kadi: $error';
  }

  @override
  String get webBillingCardDeclined =>
      'Kadi imekataliwa. Fungua ukurasa wa malipo tena ili kutumia kadi nyingine.';

  @override
  String get webBillingCardNoVerdict =>
      'Bado hatujapata taarifa kuhusu malipo ya kadi. Ikiwa uliyakamilisha, Books itafunguka hivi karibuni — angalia tena baada ya muda mfupi.';

  @override
  String get webBillingCheckingSubscription => 'Tunakagua usajili wako…';

  @override
  String get webBillingEnded => 'Usajili wako umekwisha';

  @override
  String get webBillingNeedsSubscription => 'Flipper Books inahitaji usajili';

  @override
  String get webBillingEndedBody =>
      'Hakuna kilichofutwa — hesabu zako, mauzo na hisa bado vipo. Fanya upya usajili ili kuvifungua tena.';

  @override
  String get webBillingNeedsBody =>
      'Usajili mmoja unahusu biashara hii kwenye wavuti, simu na programu ya kompyuta. Lipa mara moja na Flipper itafunguka kila mahali unapoitumia.';

  @override
  String get webBillingAwaitingSettlement =>
      'Malipo tayari yako njiani. Ikiwa uliyaidhinisha kwenye simu yako, hii itafunguka mara Mobile Money itakapoyathibitisha.';

  @override
  String get webBillingRenewNow => 'Fanya upya sasa';

  @override
  String get webBillingChoosePlan => 'Chagua mpango';

  @override
  String get webBillingSwitchBusiness => 'Badilisha biashara';

  @override
  String get webBillingLoadingBusiness => 'Tunapakia biashara yako…';

  @override
  String get webBillingPickBusiness =>
      'Chagua biashara unayoilipia, kisha mipango na bei zake zitaonekana hapa.';

  @override
  String get webBillingChooseBusiness => 'Chagua biashara';

  @override
  String get webBillingRenewTitle => 'Fanya upya usajili wako';

  @override
  String get webBillingSubscribe => 'Jisajili';

  @override
  String get webBillingTestBadge => 'JARIBIO';

  @override
  String get webBillingOneMoment => 'Subiri kidogo…';

  @override
  String get webBillingIntroSubtitle =>
      'Usajili mmoja unafungua biashara hii kwenye wavuti, simu na programu ya kompyuta.';

  @override
  String get webBillingActiveReady =>
      'Usajili wako uko hai. Books iko tayari kufunguliwa.';

  @override
  String get webBillingLoadingPlans => 'Tunapakia mipango…';

  @override
  String webBillingCouldNotLoadPlans(String error) {
    return 'Imeshindwa kupakia mipango: $error';
  }

  @override
  String get webBillingTryAgain => 'Jaribu tena';

  @override
  String get webBillingNoPlans => 'Hakuna mipango inayouzwa kwa sasa.';

  @override
  String get webBillingPlan => 'Mpango';

  @override
  String get webBillingAddons => 'Nyongeza';

  @override
  String get webBillingPayWith => 'Lipa kwa';

  @override
  String get webBillingContinueToCard => 'Endelea na malipo ya kadi';

  @override
  String webBillingPayAmount(String amount) {
    return 'Lipa $amount RWF';
  }

  @override
  String get webBillingWaitingApproval => 'Tunasubiri idhini yako…';

  @override
  String get webBillingWaitingCard => 'Tunasubiri malipo ya kadi…';

  @override
  String get webBillingPreparingShort => 'Tunaandaa…';

  @override
  String get webBillingCheckAgain => 'Angalia tena';

  @override
  String get webBillingStartOver => 'Anza upya';

  @override
  String get webBillingOpenBooks => 'Fungua Books';

  @override
  String get webPayNotAuthorised =>
      'Akaunti hii haijaidhinishwa kwa malipo ya wafanyakazi.';

  @override
  String get webPayEnterAmount => 'Weka kiasi kilichokubaliwa kwa RWF.';

  @override
  String get webPayStarting => 'Tunaanzisha malipo…';

  @override
  String webPayCouldNotStart(String error) {
    return 'Imeshindwa kuanzisha malipo: $error';
  }

  @override
  String get webPayNoPaymentYetCard =>
      'Bado hakuna malipo. Tuma kiungo tena au angalia kumbukumbu baadaye — malipo yatakayofanywa baada ya hili kufungwa bado yanahesabiwa.';

  @override
  String get webPayNoApprovalYet =>
      'Bado haijaidhinishwa. Mteja bado anaweza kuidhinisha; angalia kumbukumbu baadaye au anza upya.';

  @override
  String get webPayPaidActive =>
      'Imelipwa. Mpango uko hai na bei iliyojadiliwa sasa ndiyo bei yake ya kujirudia.';

  @override
  String get webPayDidNotGoThrough => 'Malipo hayakufanikiwa.';

  @override
  String get webPayLinkExpired =>
      'Kiungo cha malipo kiliisha muda kabla ya kulipwa.';

  @override
  String get webPayAskCustomerApprove =>
      'Mwombe mteja aidhinishe ombi la Mobile Money kwenye simu yake.';

  @override
  String get webPaySendLink =>
      'Mtumie mteja kiungo cha malipo na usubiri alipe.';

  @override
  String get webPayWaitingSettle => 'Tunasubiri malipo yakamilike…';

  @override
  String get webPayTitle => 'Malipo maalum';

  @override
  String get webPayCheckingAccess => 'Tunakagua ruhusa…';

  @override
  String webPayCouldNotCheckAccess(String error) {
    return 'Imeshindwa kukagua ruhusa ya mfanyakazi: $error';
  }

  @override
  String get webPayStaffOnlyBody =>
      'Ukurasa huu ni wa wafanyakazi wa malipo. Mwombe msimamizi akuongeze kwenye orodha ya wafanyakazi wa malipo.';

  @override
  String get webPayPerYear => '/mwaka';

  @override
  String get webPayPerMonth => '/mwezi';

  @override
  String get webPayNegotiatedPrice => 'Bei iliyojadiliwa';

  @override
  String get webPayNegotiatedBody =>
      'Toza kiasi kilichokubaliwa na mteja. Kinakuwa bei yake ya kujirudia, na alichokuwa akilipia awali kinasimama.';

  @override
  String webPaySignedInAs(String name) {
    return 'Umeingia kama $name.';
  }

  @override
  String get webPaySearchHint =>
      'Tafuta kwa jina, simu, barua pepe au kitambulisho';

  @override
  String get webPayAgreedAmount => 'Kiasi kilichokubaliwa';

  @override
  String get webPayAmountHint => 'Kiasi kwa RWF kwa kila kipindi';

  @override
  String get webPayCustomerPaysWith => 'Mteja analipa kwa';

  @override
  String get webPayLinkCopied => 'Kiungo kimenakiliwa';

  @override
  String get webPayNoteHint => 'Dokezo la kumbukumbu (si lazima)';

  @override
  String get webPayNotSelected => 'Haijachaguliwa';

  @override
  String get webPayBillingPeriod => 'Kipindi cha malipo';

  @override
  String get webPayPaysWith => 'Analipa kwa';

  @override
  String get webPayCard => 'Kadi';

  @override
  String get webPayPricePerPeriod => 'Bei kwa kila kipindi';

  @override
  String get webPayChargedNow => 'Inatozwa sasa, kisha kila kipindi';

  @override
  String get webPayCreateCardLink => 'Unda kiungo cha malipo ya kadi';

  @override
  String webPayChargeByMomo(String amount) {
    return 'Toza $amount RWF kwa Mobile Money';
  }

  @override
  String get webPayWaitingCustomerApproval => 'Tunasubiri idhini ya mteja…';

  @override
  String get webPayStartingShort => 'Inaanza…';

  @override
  String get webPayConfirmTitle => 'Kutoza biashara hii?';

  @override
  String webPayConfirmSummary(String amount, String cadence, String rail) {
    return '$amount RWF · $cadence · $rail';
  }

  @override
  String get webPayConfirmBodyMomo =>
      'Hii inakuwa bei yake ya kujirudia. Usajili wowote wa kadi uliopo unaghairiwa mara moja.';

  @override
  String get webPayConfirmBodyCard =>
      'Hii inakuwa bei yake ya kujirudia. Usajili wowote wa kadi uliopo unaghairiwa mara moja, na idhini yake ya Mobile Money inafutwa.';

  @override
  String get webPayCharge => 'Toza';

  @override
  String get webPayStaffOnly => 'Wafanyakazi pekee';

  @override
  String get webPayBackToBooks => 'Rudi kwenye Books';

  @override
  String get webPaySearching => 'Inatafuta…';

  @override
  String webPaySearchFailed(String error) {
    return 'Utafutaji umeshindwa: $error';
  }

  @override
  String webPayNoBusinessMatches(String query) {
    return 'Hakuna biashara inayolingana na “$query”.';
  }

  @override
  String get webPayChange => 'Badilisha';

  @override
  String get webPayCopyLink => 'Nakili kiungo';

  @override
  String get webPayOpen => 'Fungua';

  @override
  String webPayExistingPayment(String id, String status) {
    return 'Malipo yaliyopo $id yako $status';
  }

  @override
  String webPayLinkSuffix(String link) {
    return 'kiungo: $link';
  }

  @override
  String get webPayReference => 'Kumbukumbu';

  @override
  String get webPayRail => 'Njia';

  @override
  String get webPayPaidThrough => 'Imelipwa hadi';

  @override
  String get webPayMomoCharge => 'Malipo ya MoMo';

  @override
  String get webPayMtnTransaction => 'Muamala wa MTN';

  @override
  String get webPayDodoSubscription => 'Usajili wa Dodo';

  @override
  String get webPayDodoPayment => 'Malipo ya Dodo';

  @override
  String get webPayCancelledCardSub => 'Usajili wa kadi ulioghairiwa';

  @override
  String get webPayRevokedMandate => 'Idhini ya MoMo iliyofutwa';

  @override
  String get webPayPaid => 'Imelipwa';

  @override
  String get webPaySettledBody =>
      'Kiasi kilichojadiliwa sasa ni bei ya kujirudia ya biashara hii. Hifadhi kumbukumbu iliyo hapa chini kwa msaada.';

  @override
  String get webPayCopyAllIds => 'Nakili vitambulisho vyote';

  @override
  String get webPayCopied => 'Imenakiliwa';

  @override
  String get webPayNewPayment => 'Malipo mapya';

  @override
  String get webPinTooShort => 'PIN lazima iwe na angalau tarakimu 4';

  @override
  String get webPinInvalid => 'PIN si sahihi. Tafadhali jaribu tena.';

  @override
  String get webPinOtpRequired => 'OTP inahitajika';

  @override
  String get webPinAuthCodeRequired => 'Msimbo wa authenticator unahitajika';

  @override
  String get webPinOtpInvalid => 'OTP si sahihi. Tafadhali jaribu tena.';

  @override
  String get webPinAuthCodeInvalid =>
      'Msimbo wa authenticator si sahihi. Tafadhali jaribu tena.';

  @override
  String get webPinTroubleTitle => 'Una tatizo la kuingia?';

  @override
  String get webPinTroubleBody =>
      'Ikiwa umesahau PIN yako, wasiliana na msimamizi wa akaunti yako au msaada wa Flipper.';

  @override
  String get webPinVerifyIdentity => 'Thibitisha utambulisho wako';

  @override
  String get webPinEnterSmsCode => 'Weka msimbo tuliokutumia ili kuendelea.';

  @override
  String get webPinEnterAuthCode =>
      'Weka msimbo kutoka programu yako ya authenticator ili kuendelea.';

  @override
  String get webPinEnterPinSubtitle =>
      'Weka PIN yako ili kusimamia biashara yako kwa usalama.';

  @override
  String get webPinSignedIn => 'Umeingia ✓';

  @override
  String get webPinVerifying => 'Tunathibitisha…';

  @override
  String get webPinVerify => 'Thibitisha';

  @override
  String get webPinSignIn => 'Ingia';

  @override
  String get webPinNoAccountSignUp => 'Huna akaunti? Jisajili';

  @override
  String get webPinHide => 'Ficha';

  @override
  String get webPinShow => 'Onyesha';

  @override
  String get webPinAuthenticator => 'Authenticator';

  @override
  String get webPinSmsEmail => 'SMS / Barua pepe';

  @override
  String get webPinAuthenticatorCode => 'Msimbo wa Authenticator';

  @override
  String get webPinSmsEmailCode => 'Msimbo wa SMS / Barua pepe';

  @override
  String get webSignupTypeRetailer => 'Mfanyabiashara wa Flipper';

  @override
  String get webSignupTypeIndividual => 'Mtu binafsi';

  @override
  String get webSignupTypeEnterprise => 'Kampuni';

  @override
  String get webSignupUsernameCheckError =>
      'Hitilafu katika kukagua jina la mtumiaji';

  @override
  String get webSignupNoTinData => 'Hakuna data iliyopatikana kwa TIN hii';

  @override
  String get webSignupEnterContactFirst =>
      'Weka kwanza nambari ya simu au barua pepe.';

  @override
  String get webSignupFailedToSendCode => 'Imeshindwa kutuma msimbo.';

  @override
  String get webSignupWrongCode =>
      'Msimbo huo si sahihi. Tafadhali jaribu tena.';

  @override
  String get webSignupCouldNotCheckCode => 'Imeshindwa kukagua msimbo huo.';

  @override
  String get webSignupUsernameRequired => 'Jina la mtumiaji linahitajika';

  @override
  String get webSignupUsernameTooShort =>
      'Jina la mtumiaji lazima liwe na angalau herufi 4';

  @override
  String get webSignupEnterFullName => 'Tafadhali weka jina lako kamili';

  @override
  String get webSignupSelectBusinessType => 'Tafadhali chagua aina ya biashara';

  @override
  String get webSignupInvalidTin =>
      'Tafadhali weka nambari sahihi ya TIN (angalau herufi 9)';

  @override
  String get webSignupSelectCountry => 'Tafadhali chagua nchi';

  @override
  String webSignupEnterCodeSentTo(String contact) {
    return 'Weka msimbo tuliotuma kwa $contact ili kuendelea.';
  }

  @override
  String webSignupVerifyFirst(String contact) {
    return 'Thibitisha $contact kwanza — gusa “Tuma msimbo”.';
  }

  @override
  String get webSignupUsernameTaken =>
      'Jina la mtumiaji halipatikani. Tafadhali chagua jingine.';

  @override
  String get webSignupUsernameCheckRetry =>
      'Hitilafu katika kukagua jina la mtumiaji. Tafadhali jaribu tena.';

  @override
  String get webSignupFillRequired =>
      'Tafadhali jaza sehemu zote zinazohitajika ipasavyo';

  @override
  String get webSignupNetworkError =>
      'Hitilafu ya mtandao. Tafadhali angalia muunganisho wako na ujaribu tena.';

  @override
  String get webSignupTimeout =>
      'Ombi limechukua muda mrefu. Tafadhali jaribu tena baadaye.';

  @override
  String webSignupFailedCreate(String error) {
    return 'Imeshindwa kuunda akaunti: $error';
  }

  @override
  String get webSignupDismiss => 'Funga';

  @override
  String get webSignupBusinessSetup => 'Kuweka biashara';

  @override
  String get webSignupSubtitle =>
      'Weka akaunti yako ya biashara ya Flipper ili kuanza.';

  @override
  String get webSignupUsername => 'Jina la mtumiaji';

  @override
  String get webSignupFullName => 'Jina kamili';

  @override
  String get webSignupFullNameHint => 'Weka jina lako kamili';

  @override
  String get webSignupFullNameRequired => 'Jina kamili linahitajika';

  @override
  String get webSignupPhoneEmail => 'Simu / Barua pepe';

  @override
  String get webSignupUsage => 'Matumizi';

  @override
  String get webSignupUsageHint => 'Jinsi unavyokusudia kutumia Flipper';

  @override
  String webSignupTinBusiness(String name) {
    return 'Biashara: $name';
  }

  @override
  String get webSignupTinUnavailable =>
      'Utafutaji wa TIN haupatikani — uthibitishaji umerukwa.';

  @override
  String get webSignupCountry => 'Nchi';

  @override
  String get webSignupAlreadyHaveAccount => 'Tayari una akaunti? Ingia';

  @override
  String get webSignupChooseDifferentUsername =>
      'Tafadhali chagua jina jingine la mtumiaji. Hili la sasa halipatikani au halijathibitishwa.';

  @override
  String get webSignupAccountCreated => 'Akaunti imeundwa kwa mafanikio!';

  @override
  String get webSignupFailedTryAgain =>
      'Imeshindwa kuunda akaunti. Tafadhali jaribu tena.';

  @override
  String get webSignupUsernameNotAvailable => 'Jina la mtumiaji halipatikani';

  @override
  String get webSignupUsernameHint => 'Weka jina lako la mtumiaji';

  @override
  String get webSignupContactRequired =>
      'Nambari ya simu au barua pepe inahitajika';

  @override
  String get webSignupInvalidEmail => 'Tafadhali weka barua pepe sahihi';

  @override
  String get webSignupInvalidPhone => 'Tafadhali weka nambari sahihi ya simu';

  @override
  String get webSignupContactHint => '783054874 au barua@pepe.com';

  @override
  String get webSignupResend => 'Tuma tena';

  @override
  String get webSignupSendCode => 'Tuma msimbo';

  @override
  String webSignupContactVerified(String contact) {
    return '$contact imethibitishwa.';
  }

  @override
  String get webSignupVerificationCode => 'Msimbo wa uthibitisho';

  @override
  String get webSignupEnter6Digit => 'Weka msimbo wa tarakimu 6';

  @override
  String webSignupCodeSentHint(String contact) {
    return 'Tumetuma msimbo kwa $contact.';
  }

  @override
  String webSignupCodeSentTo(String contact) {
    return 'Msimbo umetumwa kwa $contact';
  }

  @override
  String get webSignupEnterTin => 'Weka nambari ya TIN';

  @override
  String get webSignupTinRequired => 'Nambari ya TIN inahitajika';

  @override
  String get webSignupTinTooShort =>
      'Nambari ya TIN lazima iwe na angalau tarakimu 9';

  @override
  String get webSignupPickCountryFromList =>
      'Tafadhali chagua nchi kutoka kwenye orodha';

  @override
  String get webSignupSearchCountry => 'Tafuta nchi yako';

  @override
  String get webSignupCreateYourAccount => 'Fungua akaunti yako';

  @override
  String get webAuthSecuredE2e =>
      'Imelindwa kwa usimbaji fiche wa mwisho hadi mwisho';

  @override
  String webAuthVerifiedOpening(String target) {
    return 'Imethibitishwa — inafungua $target…';
  }

  @override
  String get webAuthYourBusiness => 'biashara yako';

  @override
  String get webAuthBrandTitle =>
      'Duka lako, timu yako, takwimu zako — mahali pamoja.';

  @override
  String get webAuthBrandBody =>
      'Endelea pale ulipoishia. Mauzo, hisa na ripoti za leo ziko tayari.';

  @override
  String webAuthErrorCheckingPrefs(String error) {
    return 'Hitilafu katika kukagua mapendeleo: $error';
  }

  @override
  String get webBizNoBusinesses => 'Hakuna biashara zinazopatikana';

  @override
  String get webBizChooseBusiness => 'Chagua biashara';

  @override
  String get webBizChooseBusinessSubtitle =>
      'Chagua biashara unayotaka kusimamia.';

  @override
  String get webBizNotSeeing =>
      'Huioni biashara yako? Mwombe mmiliki akualike.';

  @override
  String get webBizChooseBranch => 'Chagua tawi';

  @override
  String get webBizChooseBranchSubtitle => 'Chagua tawi unalotaka kuingia';

  @override
  String get webBizCouldNotSet =>
      'Imeshindwa kuweka biashara. Tafadhali jaribu tena.';

  @override
  String get webBizProfileLoadFailed =>
      'Imeshindwa kupakia wasifu wako. Hii inaweza kutokea ikiwa mtandao haupatikani au kipindi chako kimeisha.';

  @override
  String get webBizBackToLogin => 'Rudi kwenye kuingia';

  @override
  String get webBizUser => 'Mtumiaji';

  @override
  String webBizOwnerBranches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mmiliki · matawi $count',
      one: 'Mmiliki · tawi 1',
    );
    return '$_temp0';
  }

  @override
  String webBizMemberBranches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mwanachama · matawi $count',
      one: 'Mwanachama · tawi 1',
    );
    return '$_temp0';
  }

  @override
  String get webBizSigningOut => 'Tunatoka…';

  @override
  String get webBizDefault => 'CHAGUO-MSINGI';

  @override
  String get webBizAddBusiness => 'Ongeza biashara';

  @override
  String get webAuthPinNotFound => 'PIN haikupatikana';

  @override
  String get webAuthAccessDenied =>
      'Ufikiaji umekataliwa — kagua uthibitishaji';

  @override
  String webAuthInvalidPinCode(String code) {
    return 'PIN si sahihi ($code)';
  }

  @override
  String get webAuthNetworkFailed =>
      'Muunganisho wa mtandao umeshindwa. Angalia intaneti yako.';

  @override
  String get webAuthTimedOut =>
      'Ombi limechukua muda mrefu. Tafadhali jaribu tena.';

  @override
  String get webAuthOtpNotFound => 'OTP haikupatikana';

  @override
  String get webAuthInvalidOtp => 'OTP si sahihi';

  @override
  String get webAuthTotpNotFound => 'Msimbo wa authenticator haukupatikana';

  @override
  String get webAuthInvalidTotp => 'Msimbo wa authenticator si sahihi';

  @override
  String webSignupRegistrationFailedStatus(String code) {
    return 'Usajili umeshindwa, msimbo wa hali: $code';
  }

  @override
  String get webSignupNetworkConnect =>
      'Hitilafu ya mtandao: imeshindwa kuunganisha na seva. Tafadhali angalia intaneti yako.';

  @override
  String get webSignupServerSlow =>
      'Ombi limechukua muda mrefu. Seva inachelewa kujibu. Tafadhali jaribu tena baadaye.';

  @override
  String get webSignupNetworkIncomplete =>
      'Hitilafu ya mtandao: imeshindwa kukamilisha ombi. Tafadhali jaribu tena baadaye.';

  @override
  String webSignupRegistrationFailed(String error) {
    return 'Usajili umeshindwa: $error';
  }

  @override
  String get webSignupNetworkSendCode =>
      'Hitilafu ya mtandao wakati wa kutuma msimbo. Tafadhali jaribu tena.';

  @override
  String get webSignupContactExists => 'Mawasiliano haya tayari yapo';

  @override
  String get webSignupSendOtpFailed => 'Imeshindwa kutuma OTP ya usajili';

  @override
  String get webSignupNetworkCheckCode =>
      'Hitilafu ya mtandao wakati wa kukagua msimbo. Tafadhali jaribu tena.';

  @override
  String get tillHardwareTitle => 'Printa na skrini ya mteja';

  @override
  String get tillHardwareSubtitle =>
      'Vifaa vya kituo hiki cha malipo pekee. Havishirikiwi na vifaa vingine.';

  @override
  String get receiptPrinterLabel => 'Printa ya risiti';

  @override
  String get receiptPrinterAuto =>
      'Risiti huchapishwa hapa kiotomatiki baada ya kila mauzo.';

  @override
  String get receiptPrinterAutomatic => 'Chagua kiotomatiki';

  @override
  String receiptPrinterNotPaper(String name) {
    return '$name (si printa ya karatasi)';
  }

  @override
  String get receiptPrinterNoneFound =>
      'Windows haionyeshi printa yoyote. Sakinisha programu ya printa, kisha fungua ukurasa huu tena.';

  @override
  String get receiptPrinterTest => 'Chapisha jaribio';

  @override
  String receiptPrinterTestSent(String printer) {
    return 'Ukurasa wa jaribio umetumwa kwa $printer';
  }

  @override
  String receiptPrinterTestFailed(String printer, String error) {
    return '$printer haikupokea ukurasa wa jaribio: $error';
  }

  @override
  String get customerDisplayLabel => 'Skrini ya mteja';

  @override
  String get customerDisplayHint =>
      'Huonyesha jumla, kisha chenji, kwenye skrini ndogo nyuma ya kituo cha malipo.';

  @override
  String get customerDisplayOff => 'Imezimwa';

  @override
  String get customerDisplaySerial => 'Kwenye mlango wa COM';

  @override
  String get customerDisplayPort => 'Mlango';

  @override
  String get customerDisplayBaud => 'Kasi (baud)';

  @override
  String get customerDisplayNoPorts =>
      'Kituo hiki hakionyeshi mlango wowote wa COM.';

  @override
  String get customerDisplayWindowsOnly =>
      'Skrini za mteja zinatumika kwenye vituo vya malipo vya Windows.';

  @override
  String get customerDisplayTest => 'Jaribu skrini';

  @override
  String get customerDisplayTestSent =>
      'Sehemu zote (8.8.8.8.8.8.8.8) sasa zinapaswa kuwaka kwenye skrini ya nyuma.';

  @override
  String get customerDisplayFind => 'Tafuta kiotomatiki';

  @override
  String customerDisplayFindPrompt(String port, String baud) {
    return 'Inajaribu $port kwa baud $baud. Je, skrini ya nyuma inaonyesha 8.8.8.8.8.8.8.8?';
  }

  @override
  String get customerDisplayFindYes => 'Ndiyo';

  @override
  String get customerDisplayFindNo => 'Hapana, jaribu inayofuata';

  @override
  String customerDisplayFound(String port, String baud) {
    return 'Skrini ya mteja imewekwa kwenye $port kwa baud $baud';
  }

  @override
  String get customerDisplayNotFound =>
      'Hakuna mpangilio ulioiwasha skrini. Kagua kebo yake, au chagua mlango na kasi wewe mwenyewe.';

  @override
  String get builtinPrinterLabel => 'Printa ya risiti iliyojengewa ndani';

  @override
  String get builtinPrinterHint =>
      'Printa ya mm 58 ya mashine hii, inatumika moja kwa moja — hakuna programu ya printa ya Windows inayohitajika. Printa za USB na parallel hupatikana kwenye risiti ya kwanza; printa iliyo kwenye mlango wa COM hutafutwa tu wakati Windows haina printa. Vinginevyo tumia Tafuta au Tafuta printa hapa chini.';

  @override
  String builtinPrinterUsing(String printer) {
    return 'Inatumia $printer';
  }

  @override
  String get builtinPrinterNotFound => 'Bado haijapatikana.';

  @override
  String get builtinPrinterOff =>
      'Imezimwa. Risiti zinatumia printa ya Windows hapo juu.';

  @override
  String get builtinPrinterSearch => 'Tafuta';

  @override
  String get builtinPrinterSearching => 'Inatafuta…';

  @override
  String get builtinPrinterFind => 'Tafuta printa';

  @override
  String get builtinPrinterTurnOff => 'Zima';

  @override
  String get builtinPrinterTurnOn => 'Washa';

  @override
  String builtinPrinterFound(String printer) {
    return 'Printa iliyojengewa ndani imepatikana: $printer';
  }

  @override
  String get builtinPrinterNoneAnswered =>
      'Hakuna printa iliyojengewa ndani iliyojibu. Angalia karatasi na umeme, kisha jaribu Tafuta printa.';

  @override
  String builtinPrinterFindPrompt(String printer) {
    return 'Mstari wa majaribio umetumwa kwa $printer. Je, umechapishwa?';
  }

  @override
  String get builtinPrinterTestSent =>
      'Ukurasa wa majaribio umetumwa kwa printa iliyojengewa ndani';

  @override
  String get builtinPrinterQrLabel => 'Msimbo wa QR wa risiti';

  @override
  String get builtinPrinterQrImage =>
      'Picha (inafanya kazi kwenye kila printa)';

  @override
  String get builtinPrinterQrNative => 'Ya printa (ikiwa QR B imechapishwa)';

  @override
  String get builtinPrinterWindowsOnly =>
      'Printa zilizojengewa ndani zinatumika kwenye mashine za Windows.';

  @override
  String get branchLocationPinOnMap => 'Weka alama kwenye ramani (si lazima)';

  @override
  String get branchLocationPickerTitle => 'Mahali pa tawi';

  @override
  String get branchLocationUseCurrent => 'Tumia mahali nilipo sasa';

  @override
  String get branchLocationSet => 'Weka mahali';

  @override
  String get branchLocationClear => 'Ondoa alama';

  @override
  String get branchLocationMissing => 'Bado hakuna mahali kwenye ramani';

  @override
  String get branchLocationUnavailable =>
      'Imeshindwa kupata mahali ulipo. Hakikisha eneo limewashwa na Flipper imeruhusiwa.';

  @override
  String get branchLocationSaved => 'Mahali pa tawi pamehifadhiwa';

  @override
  String get branchLocationSaveFailed => 'Imeshindwa kuhifadhi mahali pa tawi';

  @override
  String branchLocationPromptTitle(String branch) {
    return '$branch iko wapi?';
  }

  @override
  String branchLocationPromptBody(String branch) {
    return 'Je, uko $branch sasa hivi? Flipper inaweza kuhifadhi mahali hapa kama mahali pa tawi. Fanya hivi ukiwa tawini tu.';
  }

  @override
  String get branchLocationSave => 'Hifadhi mahali';

  @override
  String get branchLocationNotNow => 'Si sasa';

  @override
  String get branchLocationServiceOff =>
      'Eneo limezimwa kwenye kifaa hiki. Liwashe, kisha ujaribu tena.';

  @override
  String get branchLocationDenied =>
      'Flipper haikuruhusiwa kutumia eneo lako. Iruhusu ukiulizwa ili kuhifadhi mahali pa tawi.';

  @override
  String get branchLocationBlocked =>
      'Ufikiaji wa eneo umezuiwa kwa Flipper. Fungua mipangilio, ruhusu eneo, kisha ujaribu tena.';

  @override
  String get branchLocationOpenSettings => 'Fungua mipangilio';

  @override
  String get branchLocationPickerHint =>
      'Buruta ramani ili alama ikae juu ya tawi.';

  @override
  String get branchLocationSearchHint => 'Tafuta anwani au mahali';

  @override
  String get branchLocationNoResults =>
      'Hakuna mahali palipopatikana. Jaribu mtaa, eneo au alama maarufu.';

  @override
  String get branchLocationFindingAddress => 'Inatafuta anwani…';

  @override
  String get branchLocationNoAddress => 'Hakuna anwani ya mtaa hapa';

  @override
  String branchLocationAccuracy(String meters) {
    return 'Usahihi wa takriban mita $meters';
  }

  @override
  String get branchLocationZoomIn => 'Kuza';

  @override
  String get branchLocationZoomOut => 'Punguza';

  @override
  String get branchLocationDragInstead =>
      'Bado unaweza kuburuta ramani kuweka alama.';

  @override
  String get purchasePaySupplier => 'Mlipe msambazaji';

  @override
  String purchaseOwedToSupplier(String amount) {
    return 'Deni kwa msambazaji: $amount';
  }

  @override
  String get purchasePaidFrom => 'Imelipwa kutoka';

  @override
  String get purchasePaidFromBank => 'Benki';

  @override
  String get purchasePaidFromMomo => 'Pesa kwa simu';

  @override
  String purchasePayAmountTooHigh(String amount) {
    return 'Weka kiasi kisichozidi $amount';
  }

  @override
  String purchaseSupplierPaid(String amount) {
    return 'Msambazaji amelipwa. Deni lililobaki: $amount';
  }

  @override
  String get purchaseSupplierPaidInFull => 'Msambazaji amelipwa yote';

  @override
  String purchasePaySupplierFailed(String error) {
    return 'Malipo yameshindwa: $error';
  }

  @override
  String get purchasePaidInFull => 'Imelipwa yote';

  @override
  String get purchaseSearchHint => 'Tafuta msambazaji, ankara, TIN au bidhaa';

  @override
  String purchaseOwesAmount(String amount) {
    return 'Deni: $amount';
  }

  @override
  String purchaseSearchNoMatch(String query) {
    return 'Hakuna manunuzi yanayolingana na “$query”';
  }

  @override
  String get hrAndPayroll => 'Rasilimali watu na mishahara';

  @override
  String get hrBackToFlipper => 'Rudi kwenye Flipper';

  @override
  String get hrNeedsInternet =>
      'HR inahitaji muunganisho wa intaneti. Unganisha kisha ujaribu tena.';

  @override
  String get hrTaxPrimary => 'Ajira kuu';

  @override
  String get hrTaxSecondary => 'Mwajiri wa pili (30% sawa)';

  @override
  String get hrTaxCasual => 'Kibarua (15%)';

  @override
  String get hrPayStatusUnpaid => 'Haijalipwa';

  @override
  String get hrPayStatusPartlyPaid => 'Imelipwa sehemu';

  @override
  String get hrPayStatusPaid => 'Imelipwa';

  @override
  String get hrPayStatusVoid => 'Imebatilishwa';

  @override
  String get hrPayKindSalary => 'Mshahara';

  @override
  String get hrPayKindAdvance => 'Malipo ya awali';

  @override
  String get hrPayKindReimbursement => 'Marejesho';

  @override
  String get hrPayKindOther => 'Nyingine';

  @override
  String get hrAdvanceStatusOpen => 'Inadaiwa';

  @override
  String get hrAdvanceStatusRecovered => 'Imerejeshwa';

  @override
  String get hrAdvanceStatusWrittenOff => 'Imesamehewa';

  @override
  String get hrPayErrorLoad => 'Imeshindwa kupakia kumbukumbu za malipo.';

  @override
  String get hrPayErrorSave =>
      'Imeshindwa kuhifadhi kumbukumbu hiyo ya malipo.';

  @override
  String get hrPayroll => 'Mishahara';

  @override
  String get hrMyPay => 'Malipo yangu';

  @override
  String get hrPayslip => 'Hati ya malipo';

  @override
  String get hrPayslips => 'Hati za malipo';

  @override
  String get hrPayAdvances => 'Malipo ya awali';

  @override
  String get hrPayRequests => 'Maombi';

  @override
  String get hrPayReturns => 'Ritani';

  @override
  String get hrPayHistory => 'Historia';

  @override
  String get hrPaySummary => 'Muhtasari';

  @override
  String get hrPayEmployee => 'Mfanyakazi';

  @override
  String get hrNationalId => 'Kitambulisho cha taifa';

  @override
  String get hrRssbNumber => 'Namba ya RSSB';

  @override
  String get hrPayPay => 'Lipa';

  @override
  String get hrPayPaySomeone => 'Mlipe mtu';

  @override
  String hrPayPayFor(String period) {
    return 'Lipa $period';
  }

  @override
  String get hrPayChoosePerson => 'Unamlipa nani?';

  @override
  String get hrPayRecord => 'Rekodi malipo';

  @override
  String get hrPayVoid => 'Batilisha';

  @override
  String get hrPayShareSlip => 'Shiriki hati';

  @override
  String get hrPayBackToPayroll => 'Rudi kwa mishahara';

  @override
  String get hrPayReason => 'Sababu';

  @override
  String get hrPaySaveUnpaid => 'Hifadhi hati, lipa baadaye';

  @override
  String hrPayConfirmAmount(String amount) {
    return 'Lipa $amount';
  }

  @override
  String hrPayRemaining(String amount) {
    return 'Lipa $amount iliyobaki';
  }

  @override
  String get hrPayRemainingTitle => 'Lipa kilichobaki';

  @override
  String get hrPayDueNow => 'Inadaiwa sasa';

  @override
  String get hrPayPeopleToPay => 'watu wa kulipa';

  @override
  String get hrPayPaidThisMonth => 'Imelipwa mwezi huu';

  @override
  String hrPayUnpaidOnSlips(String amount) {
    return '$amount bado kwenye hati';
  }

  @override
  String get hrPayAdvancesOwed => 'Malipo ya awali yanayodaiwa';

  @override
  String get hrPayCostThisMonth => 'Gharama ya mishahara mwezi huu';

  @override
  String hrPayPayslipCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hati $count',
      one: 'Hati 1',
    );
    return '$_temp0';
  }

  @override
  String get hrPayDueToday => 'Inadaiwa leo';

  @override
  String hrPayDueOn(String date) {
    return 'Inadaiwa $date';
  }

  @override
  String hrPayNextOn(String date) {
    return 'Malipo yajayo $date';
  }

  @override
  String hrPayOverdueSince(String date) {
    return 'Imechelewa tangu $date';
  }

  @override
  String hrPayDueFor(String period) {
    return 'Inadaiwa kwa $period';
  }

  @override
  String hrPayOwesBack(String amount) {
    return 'Anadaiwa $amount';
  }

  @override
  String hrPayLastPaid(String amount, String date) {
    return 'Alilipwa mwisho $amount tarehe $date';
  }

  @override
  String get hrPayNextPayDay => 'Siku ya malipo ijayo';

  @override
  String get hrPayLastPayment => 'Malipo ya mwisho';

  @override
  String get hrPayLatestNet => 'Malipo halisi ya mwisho';

  @override
  String hrPayPersonTitle(String name) {
    return 'Mlipe $name';
  }

  @override
  String get hrPayPeriodAlreadyPaid =>
      'Kipindi hiki tayari kina hati. Chagua kipindi kingine au fungua hati ulipe kilichobaki.';

  @override
  String hrPayPeriodHasPayslip(String status, String amount) {
    return 'Tayari kwenye hati ($status, halisi $amount).';
  }

  @override
  String hrPayAlreadyPaidThisPeriod(String amount) {
    return 'Kilichokwisha tolewa kipindi hiki: $amount';
  }

  @override
  String get hrPayNothingEarned =>
      'Hakuna kilichopatikana kipindi hiki. Weka siku au saa zilizofanywa, au bonasi.';

  @override
  String hrPayRecoverMoreThanOwed(String amount) {
    return 'Huwezi kurejesha zaidi ya $amount inayodaiwa kwenye malipo ya awali.';
  }

  @override
  String hrPayRecoveryOverHalf(String amount) {
    return 'Sheria inaruhusu kukata hadi $amount kwenye malipo haya (nusu ya mshahara baada ya kodi na RSSB).';
  }

  @override
  String get hrPayNetNegative => 'Makato ni zaidi ya malipo. Punguza makato.';

  @override
  String get hrPayEnterAmount => 'Weka kiasi.';

  @override
  String hrPayMoreThanNet(String amount) {
    return 'Hiyo ni zaidi ya $amount inayodaiwa.';
  }

  @override
  String get hrPayEarnings => 'Mapato';

  @override
  String get hrPayDeductions => 'Makato';

  @override
  String get hrPayDaysWorked => 'Siku zilizofanywa';

  @override
  String get hrPayHoursWorked => 'Saa zilizofanywa';

  @override
  String hrPayRateHelper(String rate) {
    return 'Kwa $rate kila moja. Imejazwa kutoka mahudhurio.';
  }

  @override
  String get hrPayBasePay => 'Mshahara wa msingi';

  @override
  String get hrPayAllowances => 'Posho';

  @override
  String get hrPayBonus => 'Bonasi au saa za ziada';

  @override
  String get hrPayGross => 'Mshahara ghafi';

  @override
  String get hrPayPaye => 'PAYE (kodi ya mapato)';

  @override
  String hrPayPension(String percent) {
    return 'Pensheni RSSB ($percent%)';
  }

  @override
  String get hrPayPensionPlain => 'Pensheni RSSB';

  @override
  String get hrPayMaternity => 'Likizo ya uzazi';

  @override
  String get hrPayCbhi => 'CBHI (Mutuelle)';

  @override
  String get hrPayOtherDeductions => 'Makato mengine';

  @override
  String get hrPayAdvancesToRecover => 'Malipo ya awali ya kurejesha';

  @override
  String hrPayAdvanceOf(String amount, String date) {
    return 'Malipo ya awali $amount ya $date';
  }

  @override
  String hrPayStillOwed(String amount) {
    return '$amount bado inadaiwa';
  }

  @override
  String hrPayRecoveryLimit(String amount) {
    return 'Hadi $amount inaweza kurejeshwa kutoka malipo haya.';
  }

  @override
  String get hrPayNetPay => 'Malipo halisi';

  @override
  String hrPayEmployerCost(String amount) {
    return 'Inagharimu biashara $amount pamoja na michango ya mwajiri';
  }

  @override
  String get hrPayPayment => 'Malipo';

  @override
  String get hrPayRecordPaymentNow => 'Ninalipa sasa';

  @override
  String get hrPayRecordPaymentHint =>
      'Zima ili kuhifadhi hati na kulipa baadaye.';

  @override
  String hrPaySendTo(String account) {
    return 'Tuma kwa $account';
  }

  @override
  String get hrPayAmountPaidNow => 'Kiasi kilicholipwa sasa';

  @override
  String get hrPayPartialHint =>
      'Lipa sehemu sasa na iliyobaki baadaye ukihitaji.';

  @override
  String get hrPayReference => 'Kumbukumbu (hiari)';

  @override
  String get hrPayReferenceHint => 'Namba ya muamala wa MoMo au ya benki';

  @override
  String get hrPayNote => 'Maelezo (hiari)';

  @override
  String hrPayRatesFootnote(String version) {
    return 'Viwango vya kisheria $version: PAYE (Sheria 027/2022), pensheni RSSB (Amri 086/01 ya 2024), uzazi, ajali kazini na CBHI.';
  }

  @override
  String hrPayPaidToast(String name, String period) {
    return '$name amelipwa kwa $period';
  }

  @override
  String get hrPayRecordedToast => 'Malipo yamerekodiwa';

  @override
  String hrPayslipFor(String period) {
    return 'Hati · $period';
  }

  @override
  String get hrPayAdvanceRecovered => 'Malipo ya awali yaliyorejeshwa';

  @override
  String hrPayAdvanceRecoveredAmount(String amount) {
    return '$amount ya malipo ya awali imerejeshwa';
  }

  @override
  String get hrPayEmployerContributions => 'Michango ya mwajiri';

  @override
  String get hrPayOccupationalHazards => 'Ajali kazini';

  @override
  String get hrPayPaymentsMade => 'Malipo yaliyofanywa';

  @override
  String get hrPayNothingPaidYet => 'Hakuna kilicholipwa kwenye hati hii bado.';

  @override
  String hrPayStillToPay(String amount) {
    return '$amount bado kulipwa';
  }

  @override
  String hrPayVoidedBecause(String reason) {
    return 'Imebatilishwa: $reason';
  }

  @override
  String get hrPayVoidPayslipTitle => 'Batilisha hati hii?';

  @override
  String get hrPayVoidPayslipMessage =>
      'Kipindi kinakuwa hakijalipwa na malipo ya awali yaliyorejeshwa yanadaiwa tena. Hakuna kinachofutwa.';

  @override
  String get hrPayVoidPayslipWithPayments =>
      'Malipo yaliyorekodiwa nayo yanabatilishwa. Kipindi kinakuwa hakijalipwa na malipo ya awali yanadaiwa tena.';

  @override
  String get hrPayVoidPaymentTitle => 'Batilisha malipo haya?';

  @override
  String hrPayVoidPaymentMessage(String amount) {
    return '$amount hazitahesabiwa kama zimelipwa. Hakuna kinachofutwa.';
  }

  @override
  String hrPayslipFooter(String version) {
    return 'Imehesabiwa kwa viwango vya kisheria vya Rwanda $version. Imetolewa na Flipper HR.';
  }

  @override
  String hrPayPaidKind(String kind) {
    return 'Imelipwa · $kind';
  }

  @override
  String hrPayAdvanceGivenOn(String date) {
    return 'Malipo ya awali yalitolewa $date';
  }

  @override
  String get hrPayNoHistory =>
      'Hakuna malipo bado. Hati, malipo na malipo ya awali yataonekana hapa.';

  @override
  String get hrPayPersonNotFound =>
      'Mtu huyu hayupo kwenye tawi lililochaguliwa.';

  @override
  String get hrPayNoRecordTitle => 'Hakuna rekodi ya mfanyakazi bado';

  @override
  String get hrPayNoRecordBody =>
      'Hati zako zitaonekana hapa mwajiri wako akikuongeza kwenye timu yake katika Flipper HR.';

  @override
  String get hrPayNobodyYet => 'Hakuna wa kulipa bado';

  @override
  String get hrPayNobodyYetBody =>
      'Ongeza timu yako na mishahara yao, na siku zao za malipo zitaonekana hapa.';

  @override
  String get hrPayNoPayslips =>
      'Hakuna hati bado. Mlipe mtu na hati yake itaonekana hapa.';

  @override
  String get hrPayNoAdvances =>
      'Hakuna malipo ya awali. Pesa iliyotolewa kabla ya siku ya malipo inafuatiliwa hapa hadi irejeshwe.';

  @override
  String get hrPayNoRequests =>
      'Hakuna maombi ya malipo ya awali. Mtu akiomba kwenye programu, yanafika hapa.';

  @override
  String get hrPayNoPayslipsThisMonth => 'Hakuna hati inayoishia mwezi huu.';

  @override
  String hrPayReturnsDeadline(String date) {
    return 'Tangaza na ulipe PAYE na michango ya RSSB kabla ya $date.';
  }

  @override
  String get hrPayReturnsRra => 'Kwa RRA';

  @override
  String get hrPayReturnsRssb => 'Kwa RSSB';

  @override
  String get hrPayPensionBothSides => 'Pensheni (mfanyakazi + mwajiri)';

  @override
  String get hrPayMaternityBothSides => 'Uzazi (mfanyakazi + mwajiri)';

  @override
  String get hrPayRssbTotal => 'Jumla kwa RSSB';

  @override
  String get hrPayTotalCost => 'Gharama yote kwa biashara';

  @override
  String get hrPayReturnsCopy => 'Nakili kwa ajili ya kutangaza';

  @override
  String get hrPayReturnsCopied => 'Imenakiliwa. Ibandike kwenye lahajedwali.';

  @override
  String get hrAdvanceGive => 'Toa malipo ya awali';

  @override
  String get hrAdvanceRequest => 'Omba malipo ya awali';

  @override
  String hrAdvanceGiveTitle(String name) {
    return 'Malipo ya awali kwa $name';
  }

  @override
  String get hrAdvanceGiveSubtitle =>
      'Pesa iliyotolewa kabla ya siku ya malipo, inarejeshwa kwenye hati zijazo.';

  @override
  String get hrAdvanceRequestTitle => 'Omba malipo ya awali';

  @override
  String get hrAdvanceRequestSubtitle =>
      'Meneja wako anaamua, na inarejeshwa kwenye malipo yako yajayo.';

  @override
  String get hrAdvanceAmount => 'Kiasi';

  @override
  String get hrAdvanceReason => 'Sababu (hiari)';

  @override
  String get hrAdvanceReasonHint => 'mfano: ada ya shule, kodi';

  @override
  String get hrAdvanceRecovery => 'Kuirejesha';

  @override
  String get hrAdvanceRecoverNextPay => 'Yote kutoka malipo yajayo';

  @override
  String get hrAdvanceRecoverNextPayHint =>
      'Kamwe zaidi ya nusu ya malipo hayo; iliyobaki inahamia inayofuata.';

  @override
  String get hrAdvanceRecoverInstallments => 'Kwa awamu';

  @override
  String get hrAdvancePerPayslip => 'Kiasi kwa kila hati';

  @override
  String hrAdvanceInstallmentCount(String count) {
    return 'Takriban hati $count';
  }

  @override
  String hrAdvanceInstallmentOf(String amount) {
    return '$amount kwa kila hati';
  }

  @override
  String get hrAdvanceEnterInstallment =>
      'Weka kiasi cha kurejesha kwa kila hati.';

  @override
  String hrAdvanceAlreadyOwed(String amount) {
    return 'Tayari anadaiwa $amount kutoka malipo ya awali ya awali.';
  }

  @override
  String hrAdvanceOverHalf(String amount) {
    return 'Zaidi ya hati moja inavyoweza kurejesha: hadi $amount kwa kila hati, itachukua malipo kadhaa.';
  }

  @override
  String hrAdvanceGiveAmount(String amount) {
    return 'Toa $amount';
  }

  @override
  String get hrAdvanceSendRequest => 'Tuma ombi';

  @override
  String get hrAdvanceRecordedToast => 'Malipo ya awali yamerekodiwa';

  @override
  String get hrAdvanceRequestedToast => 'Ombi limetumwa kwa meneja wako';

  @override
  String hrAdvanceRequestPending(String amount) {
    return 'Ombi lako la $amount linasubiri uamuzi.';
  }

  @override
  String get hrAdvanceCancelRequest => 'Ghairi ombi';

  @override
  String get hrAdvanceApproveAndGive => 'Idhinisha na utoe';

  @override
  String get hrAdvanceDecline => 'Kataa';

  @override
  String get hrAdvanceDeclineTitle => 'Kataa ombi hili?';

  @override
  String get hrAdvanceDeclineMessage => 'Sema kwa nini, ili ajue.';

  @override
  String hrAdvanceApprovedToast(String amount, String name) {
    return 'Umetoa $amount kwa $name';
  }

  @override
  String hrAdvanceProgress(String recovered, String owed) {
    return '$recovered imerejeshwa · $owed imebaki';
  }

  @override
  String get hrAdvanceWriteOff => 'Samehe';

  @override
  String get hrAdvanceWriteOffTitle => 'Samehe malipo haya ya awali?';

  @override
  String hrAdvanceWriteOffMessage(String amount) {
    return '$amount inayodaiwa haitarejeshwa kutoka malipo.';
  }

  @override
  String get hrAdvanceVoidTitle => 'Batilisha malipo haya ya awali?';

  @override
  String get hrAdvanceVoidMessage =>
      'Tumia hii ikiwa ilirekodiwa kimakosa. Pesa iliyotolewa nayo inabatilishwa.';

  @override
  String hrAllowancesWithCurrency(String currency) {
    return 'Posho za mwezi ($currency)';
  }

  @override
  String get hrAllowancesHelper =>
      'Usafiri, makazi… hulipwa kila mwezi juu ya mshahara wa msingi. Hutozwa kodi.';

  @override
  String get hrPayDayOfMonth => 'Siku ya malipo';

  @override
  String get hrPayDayHelper => 'Siku ya mwezi (1–31). Tupu: siku ya mwisho.';

  @override
  String get hrTaxCategory => 'Kodi ya mapato';

  @override
  String get hrTaxCategoryHelper => 'Jinsi PAYE inavyohesabiwa kwa mtu huyu.';

  @override
  String get hrRssbEnrolled => 'Amesajiliwa RSSB';

  @override
  String get hrRssbEnrolledHelper =>
      'Kata pensheni na uzazi na ongeza sehemu ya mwajiri.';

  @override
  String hrPayPeopleDue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lipa watu $count',
      one: 'Lipa mtu 1',
    );
    return '$_temp0';
  }

  @override
  String dailyGoalPlusPoints(int points) {
    return '+$points pointi';
  }

  @override
  String dailyGoalPoints(int points) {
    return '$points pointi';
  }

  @override
  String dailyGoalStreakShort(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Mfululizo wa siku $days',
      one: 'Mfululizo wa siku 1',
    );
    return '$_temp0';
  }

  @override
  String dailyGoalBestStreak(int days) {
    return 'Bora: siku $days';
  }

  @override
  String dailyGoalPointsToday(int points) {
    return '+$points leo';
  }

  @override
  String get dailyGoalChipSale => 'Mauzo';

  @override
  String get dailyGoalChipExpense => 'Matumizi';

  @override
  String get dailyGoalChipStock => 'Hesabu';

  @override
  String get dailyGoalChipGoal => 'Lengo';

  @override
  String get dailyGoalMissionSale => 'Rekodi mauzo';

  @override
  String get dailyGoalMissionExpense => 'Rekodi matumizi';

  @override
  String get dailyGoalMissionStock => 'Sasisha hesabu ya bidhaa';

  @override
  String get dailyGoalMissionGoal => 'Fikia lengo la mauzo la leo';

  @override
  String get dailyGoalSheetTitle => 'Lengo la leo';

  @override
  String get dailyGoalMissionsHeading => 'Kazi za leo';

  @override
  String dailyGoalStreakRule(int days, int points) {
    return 'Fikia lengo siku $days mfululizo upate pointi $points za ziada.';
  }

  @override
  String get dailyGoalThisWeek => 'Wiki hii';

  @override
  String get dailyGoalWeekEmpty => 'Wiki yako itaonekana hapa kuanzia kesho.';

  @override
  String get dailyGoalSettingsHeading => 'Mipangilio ya lengo';

  @override
  String dailyGoalTarget(int count) {
    return 'Lengo la kila siku: mauzo $count';
  }

  @override
  String get dailyGoalTargetAuto =>
      'Inabadilika kulingana na siku zako za karibuni';

  @override
  String get dailyGoalTargetCustom => 'Lengo lako mwenyewe';

  @override
  String get dailyGoalUseAutomatic => 'Tumia otomatiki';

  @override
  String get dailyGoalReminders => 'Vikumbusho vya kila siku';

  @override
  String get dailyGoalRemindersHint =>
      'Kikumbusho ikiwa hakuna mauzo kufikia saa 4 asubuhi na muhtasari jioni. Si zaidi ya 2 kwa siku.';

  @override
  String get dailyGoalOwnerOnly =>
      'Mmiliki au msimamizi pekee ndiye anaweza kubadilisha haya.';

  @override
  String get dailyGoalDoIt => 'Fanya';

  @override
  String get dailyGoalDone => 'Imekamilika';

  @override
  String get booksExportColItem => 'Kipengele';

  @override
  String get booksExportColAmount => 'Kiasi';

  @override
  String get booksExportColDate => 'Tarehe';

  @override
  String get booksExportColEntry => 'Ingizo';

  @override
  String get booksExportColMemo => 'Maelezo';

  @override
  String get booksExportColSource => 'Chanzo';

  @override
  String get booksExportColDebit => 'Debiti';

  @override
  String get booksExportColCredit => 'Krediti';

  @override
  String get booksExportColMonth => 'Mwezi';

  @override
  String get booksExportColRevenue => 'Mapato';

  @override
  String get booksExportColNet => 'Halisi';

  @override
  String get booksExportSheetTrend => 'Mwenendo';

  @override
  String get booksExportSheetJournal => 'Jarida';

  @override
  String get booksExportReady => 'Usafirishaji uko tayari';

  @override
  String booksExportGeneratedAt(String date) {
    return 'Imetolewa $date';
  }

  @override
  String booksExportPageOf(String page, String total) {
    return 'Ukurasa $page wa $total';
  }
}
