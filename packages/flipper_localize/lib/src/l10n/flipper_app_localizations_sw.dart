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
}
