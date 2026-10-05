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
      'Imeshindwa kuthibitisha Authenticator. Angalia muunganisho wako, au ingia mtandaoni mara moja ili MFA ifanye kazi bila mtandao.';

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
}
