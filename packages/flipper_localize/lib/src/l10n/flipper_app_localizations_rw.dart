// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'flipper_app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kinyarwanda (`rw`).
class FlipperAppLocalizationsRw extends FlipperAppLocalizations {
  FlipperAppLocalizationsRw([String locale = 'rw']) : super(locale);

  @override
  String get save => 'Bika';

  @override
  String get retailPrice => 'Igiciro';

  @override
  String get supplyPrice => 'Ikiranguzo';

  @override
  String get currentSale => 'Igurisha rigezweho';

  @override
  String get currentStock => 'Ububiko buriho';

  @override
  String get addProduct => 'Ongeramo ibicuruzwa';

  @override
  String get tickets => 'Amatike';

  @override
  String get charge => 'Kwishyuza';

  @override
  String get productName => 'Izina ry\'igicuruzwa';

  @override
  String get flipperSetting => 'Igenamiterere';

  @override
  String get options => 'Amahitamo';

  @override
  String get saveTicket => 'Ntushobora kubika itike utongeyeho inyandiko';

  @override
  String get productNotFound => 'Igicuruzwa ntikibonetse';

  @override
  String get noPayable => 'Nta byo kwishyuzwa bihari';

  @override
  String get delete => 'Siba';

  @override
  String get addTomenu => 'Menu';

  @override
  String get edit => 'Hindura';

  @override
  String get addWorkSpace => 'Ongeramo aho gukorera';

  @override
  String get addMembers => 'Ongeramo abakozi';

  @override
  String get logOut => 'Sohoka';

  @override
  String get syncCounter => 'Huza kontwa';

  @override
  String get resetTransaction => 'Subizaho igurisha';

  @override
  String get resetTransactionQuestion => 'Subizaho igurisha?';

  @override
  String get resetTransactionDescription =>
      'Ibi bizasiba igurisha ritegereje n\'ibicuruzwa byaryo byose. Iki gikorwa ntigisubizwa inyuma.';

  @override
  String get transactionResetSuccessfully => 'Igurisha ryasubijweho neza';

  @override
  String errorResettingTransaction(Object error) {
    return 'Habaye ikosa mu gusubizaho igurisha: $error';
  }

  @override
  String get selectedContactHasNoPhoneNumber =>
      'Kontaki wahisemo nta nimero ya telefoni ifite';

  @override
  String get contactsPermissionRequired =>
      'Uruhushya rwo kureba kontaki rurakenewe kugira ngo uhitemo kontaki';

  @override
  String get permissionRequired => 'Uruhushya rurakenewe';

  @override
  String get contactsPermissionDeniedSettings =>
      'Uruhushya rwo kureba kontaki rwanze burundu. Rubashe mu igenamiterere ry\'igikoresho cyawe kugira ngo ukoreshe iki gikorwa.';

  @override
  String get cancel => 'Kureka';

  @override
  String get openSettings => 'Fungura igenamiterere';

  @override
  String errorMessage(Object error) {
    return 'Ikosa: $error';
  }

  @override
  String get error => 'Ikosa';

  @override
  String get pickFromContacts => 'Hitamo muri kontaki';

  @override
  String get linkDevice => 'Huza igikoresho';

  @override
  String get useFlipperOnOtherDevices => 'Koresha Flipper ku bindi bikoresho';

  @override
  String get linkADevice => 'Huza igikoresho';

  @override
  String pinCode(Object pin) {
    return 'PIN: $pin';
  }

  @override
  String get listOfConnectedDevices => 'Urutonde rw\'ibikoresho byahujwe';

  @override
  String paymentTitle(Object paymentType) {
    return 'Ubwishyu: $paymentType';
  }

  @override
  String get digitalReceipt => 'Inyemezabwishyu ya elegitoroniki';

  @override
  String get needDigitalReceipt => 'Ukeneye inyemezabwishyu ya elegitoroniki?';

  @override
  String get purchaseCode => 'Kode y\'ubugure';

  @override
  String get pleaseEnterPurchaseCode => 'Nyamuneka andika kode y\'ubugure';

  @override
  String get submit => 'Ohereza';

  @override
  String get done => 'Byarangiye';

  @override
  String get receipt => 'Inyemezabwishyu';

  @override
  String get addNote => 'Ongeramo inyandiko';

  @override
  String get generatingReceiptWait =>
      'Nyamuneka tegereza, turi gutegura inyemezabwishyu';

  @override
  String get poweredBy => 'Bikorwa na';

  @override
  String get returnToHome => 'Subira ahabanza';

  @override
  String get personalGoals => 'Intego bwite';

  @override
  String get selectBranchToManageGoals =>
      'Hitamo ishami ryo gucungiramo intego.';

  @override
  String couldNotLoadGoals(Object error) {
    return 'Ntibyashobotse kuzana intego\n$error';
  }

  @override
  String get personalGoalsEyebrow => 'INTEGO BWITE';

  @override
  String totalReservedAcrossGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'intego $count',
      one: 'intego 1',
    );
    return 'Byose byabitswe kuri $_temp0';
  }

  @override
  String get savedThisMonth => 'Byazigamwe uku kwezi';

  @override
  String onTrackCount(Object count) {
    return '$count biri ku murongo';
  }

  @override
  String get goalsProgressing => 'Intego zitera imbere';

  @override
  String get allGoals => 'Intego zose';

  @override
  String get personalGoalsProfitGrowth =>
      'Flipper yongera buhoro kuri intego zawe ikuyeko inyungu zawe.';

  @override
  String get searchProducts => 'Shakisha ibicuruzwa…';

  @override
  String get clearSelection => 'Kuraho ibyatoranyijwe';

  @override
  String itemsSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ibicuruzwa $count byatoranyijwe',
      one: 'igicuruzwa 1 cyatoranyijwe',
    );
    return '$_temp0';
  }

  @override
  String get cannotDeleteVariantWithStockRemaining =>
      'Ntushobora gusiba igicuruzwa kikiri mu bubiko.';

  @override
  String get deleteMultipleItems => 'Siba ibicuruzwa byinshi';

  @override
  String deleteItemsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ibicuruzwa $count',
      one: 'igicuruzwa 1',
    );
    return 'Uremeza ko ushaka gusiba $_temp0? Iki gikorwa ntigisubizwa inyuma.';
  }

  @override
  String get refreshProducts => 'Vugurura ibicuruzwa';

  @override
  String get productsSyncingHint =>
      'Niba uhereye kufungura porogaramu, ibicuruzwa bishobora kuba biracyahuzwa — kanda vugurura.';

  @override
  String get errorLoadingProducts => 'Ikosa mu kuzana ibicuruzwa';

  @override
  String get retry => 'Ongera ugerageze';

  @override
  String get noStockDataAvailable => 'Nta makuru y\'ububiko ahari';

  @override
  String get cash => 'Amafaranga';

  @override
  String get credit => 'Inguzanyo';

  @override
  String get momoPayerPhone => 'Telefoni y\'uwishyura kuri MoMo';

  @override
  String get momoPaymentRequestHint =>
      'Tuzohereza ubusabe bw\'ubwishyu kuri iyi nimero iyo ukanze Kwishyuza.';

  @override
  String get exact => 'Nyayo';

  @override
  String get confirm => 'Emeza';

  @override
  String get numberOfPayments => 'Umubare w\'ubwishyu';

  @override
  String get applyDiscountCode => 'Koresha kode y\'igabanuka';

  @override
  String get discountCode => 'Kode y\'igabanuka';

  @override
  String get validatingCode => 'Turi kugenzura kode...';

  @override
  String get createAccount => 'Fungura konti';

  @override
  String get signIn => 'INJIRA';

  @override
  String get setDeviceTimeAutomatic =>
      'Nyamuneka shyira isaha y\'igikoresho cyawe ku buryo bwikora';

  @override
  String get continueWithPhone => 'Komeza ukoresheje telefoni';

  @override
  String get continueWithGoogle => 'Komeza ukoresheje Google';

  @override
  String get continueWithMicrosoft => 'Komeza ukoresheje Microsoft';

  @override
  String get continueWithApple => 'Komeza ukoresheje Apple';

  @override
  String get or => 'CYANGWA';

  @override
  String get pinLogin => 'Injira ukoresheje PIN';

  @override
  String get languagesTitle => 'Indimi';

  @override
  String get english => 'Icyongereza';

  @override
  String get kinyarwanda => 'Ikinyarwanda';

  @override
  String get swahili => 'Igiswahili';

  @override
  String get settings => 'Igenamiterere';

  @override
  String get home => 'Ahabanza';

  @override
  String get sales => 'Ibyagurishijwe';

  @override
  String get inventory => 'Ububiko';

  @override
  String get more => 'Ibindi';

  @override
  String get scanQr => 'Sikana QR';

  @override
  String get dashboard => 'Imbonerahamwe';

  @override
  String get noUser => 'Nta mukoresha';

  @override
  String get pleaseLogInToContinue => 'Nyamuneka injira kugira ngo ukomeze';

  @override
  String get loadingBusinesses => 'Turi kuzana ubucuruzi...';

  @override
  String get errorLoadingBusinesses => 'Ikosa mu kuzana ubucuruzi';

  @override
  String get noBusinesses => 'Nta bucuruzi buhari';

  @override
  String get createFirstBusiness =>
      'Fungura ubucuruzi bwawe bwa mbere kugira ngo utangire';

  @override
  String get signOut => 'Sohoka';

  @override
  String get phoneNumber => 'Nimero ya telefoni';

  @override
  String get sendingCode => 'Turi kohereza kode...';

  @override
  String get continueAction => 'Komeza';

  @override
  String get enterSixDigitCodeSentTo =>
      'Andika kode y\'imibare 6 yoherejwe kuri ';

  @override
  String get codeExpiredTapToResend =>
      'Kode yarangiye - Kanda wongere kuyohereza';

  @override
  String get resendCode => 'Ongera wohereze kode';

  @override
  String get resendCodeIn => 'Ongera wohereze kode mu ';

  @override
  String get seconds => 'amasegonda';

  @override
  String get verifying => 'Turi kugenzura...';

  @override
  String get verifyCode => 'Genzura kode';

  @override
  String get troubleSigningIn => 'Ufite ikibazo cyo kwinjira?';

  @override
  String get troubleSigningInHelp =>
      'Niba ufite ikibazo cyo kwinjira, reba neza ko PIN yawe na OTP (niba ikenewe) ari byo.\n\nKu bufasha bwinshi, nyamuneka vugana n\'itsinda ry\'ubufasha.';

  @override
  String get ok => 'Yego';

  @override
  String get welcomeBack => 'Murakaza neza';

  @override
  String get tinNumber => 'Nimero ya TIN';

  @override
  String get validate => 'Genzura';

  @override
  String get uploadPdfWithTin => 'Ohereza PDF irimo TIN';

  @override
  String get enterTinOrUpload =>
      'Andika nimero ya TIN cyangwa kanda ikimenyetso cyo kohereza';

  @override
  String get addEmail => 'Ongeramo imeyili';

  @override
  String get emailAdded => 'Imeyili yongewemo';

  @override
  String get updateSettings => 'Vugurura igenamiterere';

  @override
  String get invite => 'Tumira';

  @override
  String get sendRequest => 'Ohereza ubusabe';

  @override
  String get preferences => 'Ibyo uhitamo';

  @override
  String get accessibility => 'Uburyo bworoshye bwo gukoresha';

  @override
  String get language => 'Ururimi';

  @override
  String get reports => 'Raporo';

  @override
  String get enableReport => 'Emeza raporo';

  @override
  String get backups => 'Amakopi y\'ingoboka';

  @override
  String get addBackup => 'Ongeramo ikopi y\'ingoboka';

  @override
  String get restoreData => 'Garura amakuru';

  @override
  String get dataRestored => 'Amakuru yagaruwe';

  @override
  String get errorRestoringBackup => 'Ikosa mu kugarura ikopi y\'ingoboka';

  @override
  String get transactionIdCopiedToClipboard => 'ID y\'igurisha yakoporowe';

  @override
  String get transactionIdShortLabel => 'ID y\'igurisha: ';

  @override
  String get invoiceNumberLabel => 'Nimero ya fagitire: ';

  @override
  String get parkSaleAsTicket => 'Bika iri gurisha nk\'itike';

  @override
  String get saveTicketAction => 'Bika itike';

  @override
  String get remainingBalanceLabel => 'Amafaranga asigaye: ';

  @override
  String get amountToChangeLabel => 'Amafaranga yo kugarura: ';

  @override
  String get allApps => 'Porogaramu zose';

  @override
  String get sell => 'Gurisha';

  @override
  String get quickSell => 'Gurisha vuba';

  @override
  String get invoices => 'Fagitire';

  @override
  String get pricing => 'Ibiciro';

  @override
  String get payments => 'Ubwishyu';

  @override
  String get manage => 'Cunga';

  @override
  String get purchases => 'Ibyaguzwe';

  @override
  String get customers => 'Abakiriya';

  @override
  String get leads => 'Abakiriya bashoboka';

  @override
  String get insights => 'Isesengura';

  @override
  String get dailyReports => 'Raporo za buri munsi';

  @override
  String get commissions => 'Komisiyo';

  @override
  String get production => 'Umusaruro';

  @override
  String get business => 'Ubucuruzi';

  @override
  String get servicesHub => 'Ihuriro ry\'serivisi';

  @override
  String get goals => 'Intego';

  @override
  String get aiChat => 'Ikiganiro na AI';

  @override
  String get errorLoadingTransactionView => 'Ikosa mu kwerekana igurisha';

  @override
  String get customer => 'Umukiriya';

  @override
  String get payment => 'Ubwishyu';

  @override
  String get delivery => 'Itangwa';

  @override
  String get transactionSummary => 'Incamake y\'igurisha';

  @override
  String get transactionSummaryHint =>
      'Yerekana amafaranga yose na ID y\'igurisha rigezweho';

  @override
  String get totalAmount => 'Amafaranga yose';

  @override
  String get cannotDeletePartialPaymentItems =>
      'Ntushobora gusiba ibicuruzwa mu gurisha rifite ubwishyu bw\'igice';

  @override
  String get deleteAllItems => 'Siba ibicuruzwa byose';

  @override
  String get confirmRemoveAllTransactionItems =>
      'Uremeza ko ushaka gukura ibicuruzwa byose muri iri gurisha?';

  @override
  String plusMoreItems(int count) {
    return '+$count ibindi';
  }

  @override
  String get actionCannotBeUndone => 'Iki gikorwa ntigisubizwa inyuma.';

  @override
  String get deleteAll => 'Siba byose';

  @override
  String get allItemsRemovedSuccessfully => 'Ibicuruzwa byose byakuweho neza';

  @override
  String errorRemovingItems(String error) {
    return 'Ikosa mu gukura ibicuruzwa: $error';
  }

  @override
  String get noItemsAdded => 'Nta gicuruzwa cyongewemo';

  @override
  String get tapAddFirstItem =>
      'Kanda buto ya + kugira ngo wongeremo igicuruzwa cya mbere';

  @override
  String cartItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ibicuruzwa $count',
      one: 'igicuruzwa 1',
    );
    return '$_temp0';
  }

  @override
  String itemSemanticLabel(String itemName) {
    return 'Igicuruzwa: $itemName';
  }

  @override
  String cartItemSemanticHint(
    String quantity,
    String unitPrice,
    String subtotal,
  ) {
    return 'Ingano: $quantity, Igiciro cy\'igice: $unitPrice, Igiteranyo: $subtotal';
  }

  @override
  String get removeItem => 'Kuraho igicuruzwa';

  @override
  String get unitPrice => 'Igiciro cy\'igice';

  @override
  String get decreaseQuantityByOne => 'Gabanya ingano ku 1';

  @override
  String get increaseQuantityByOne => 'Ongera ingano ku 1';

  @override
  String get subtotal => 'Igiteranyo';

  @override
  String get deliveryDate => 'Itariki y\'itangwa';

  @override
  String get transactionSummaryPaymentActions =>
      'Incamake y\'igurisha n\'ibikorwa by\'ubwishyu';

  @override
  String completeSaleTotalHint(String total) {
    return 'Rangiza igurisha ku mafaranga yose $total';
  }

  @override
  String errorWithValue(String error) {
    return 'Ikosa: $error';
  }

  @override
  String confirmRemoveItemFromTransaction(String itemName) {
    return 'Uremeza ko ushaka gukura \"$itemName\" muri iri gurisha?';
  }

  @override
  String get remove => 'Kuraho';

  @override
  String get cannotModifyPartialPaymentItems =>
      'Ntushobora guhindura ibicuruzwa mu gurisha rifite ubwishyu bw\'igice';

  @override
  String get failedToRemoveItem => 'Gukura igicuruzwa ntibyakunze';

  @override
  String get failedToUpdateItemQuantity =>
      'Guhindura ingano y\'igicuruzwa ntibyakunze';

  @override
  String get transactionItemsList => 'Urutonde rw\'ibicuruzwa by\'igurisha';

  @override
  String get transactionItemsListHint =>
      'Urutonde rw\'ibicuruzwa biri mu gurisha rigezweho hamwe n\'ingano n\'ibiciro';

  @override
  String get deliveryNote => 'Inyandiko y\'itangwa';

  @override
  String get deliveryNoteSemantic => 'Inyandiko y\'itangwa';

  @override
  String get deliveryNoteHint => 'Ongeramo amabwiriza yihariye yo gutanga';

  @override
  String get deliveryInstructionsHint =>
      'Andika amabwiriza yihariye yo gutanga';

  @override
  String get discount => 'Igabanuka';

  @override
  String get pleaseEnterValidNumber => 'Nyamuneka andika umubare wemewe';

  @override
  String get discountRangeError => 'Igabanuka rigomba kuba hagati ya 0 na 100';

  @override
  String get digitalReceiptTitle => 'Inyemezabwishyu ya elegitoroniki';

  @override
  String get digitalReceiptSmsSubtitle =>
      'Ohereza inyemezabwishyu kuri SMS aho kufungura PDF';

  @override
  String receivedAmountInCurrency(String currency) {
    return 'Amafaranga yakiriwe mu $currency';
  }

  @override
  String get receivedAmountHint => 'Andika amafaranga yakiriwe ku mukiriya';

  @override
  String get receivedAmount => 'Amafaranga yakiriwe';

  @override
  String get pleaseEnterReceivedAmount =>
      'Nyamuneka andika amafaranga yakiriwe';

  @override
  String get customerName => 'Izina ry\'umukiriya';

  @override
  String get customerNameHint => 'Andika amazina yuzuye y\'umukiriya';

  @override
  String get pleaseEnterCustomerName => 'Nyamuneka andika izina ry\'umukiriya';

  @override
  String get customerPhoneNumber => 'Nimero ya telefoni y\'umukiriya';

  @override
  String get customerPhoneNumberHint =>
      'Andika nimero ya telefoni y\'umukiriya yo kuvugana no kwishyuza';

  @override
  String get items => 'Ibicuruzwa';

  @override
  String get transactionId => 'ID y\'igurisha';

  @override
  String get amountPaid => 'Amafaranga yishyuwe';

  @override
  String get remainingBalance => 'Amafaranga asigaye';

  @override
  String recordPaymentWithAmount(String amount) {
    return 'Andika ubwishyu • $amount';
  }

  @override
  String payWithAmount(String amount) {
    return 'Ishyura • $amount';
  }

  @override
  String sendForReviewWithAmount(String amount) {
    return 'Ohereza kugenzurwa • $amount';
  }

  @override
  String get phoneRequiredWhenTinMissing =>
      'Nimero ya telefoni irakenewe iyo TIN y\'umukiriya itaboneka';

  @override
  String get invalidNumber => 'Umubare utemewe';

  @override
  String get back => 'Subira inyuma';

  @override
  String get managementDashboard => 'Imbonerahamwe y\'ubuyobozi';

  @override
  String get quickActions => 'Ibikorwa byihuse';

  @override
  String get posDefault => 'POS y\'ibanze';

  @override
  String get setPosAsDefaultApp => 'Shyira POS nka porogaramu y\'ibanze';

  @override
  String get ordersDefault => 'Ibyatumijwe by\'ibanze';

  @override
  String get setOrdersAsDefaultApp =>
      'Shyira Ibyatumijwe nka porogaramu y\'ibanze';

  @override
  String get accountManagement => 'Icungamakonti';

  @override
  String get userManagement => 'Icungabakoresha';

  @override
  String get manageUsersAndPermissions =>
      'Cunga abakoresha n\'uburenganzira bwabo';

  @override
  String get branchManagement => 'Icungamashami';

  @override
  String get manageBranchLocations => 'Cunga amashami (ahantu)';

  @override
  String get financialControls => 'Igenzura ry\'imari';

  @override
  String get taxSettings => 'Igenamiterere ry\'imisoro';

  @override
  String get configureTaxRulesAndRates =>
      'Shyiraho amategeko n\'ibipimo by\'imisoro';

  @override
  String get ebmSettings => 'Igenamiterere rya EBM';

  @override
  String get electronicBillingMachineSettings =>
      'Igenamiterere ry\'imashini ya fagitire ya elegitoroniki';

  @override
  String get smsConfiguration => 'Igenamiterere rya SMS';

  @override
  String get enableSmsNotifications => 'Emeza ubutumwa bwa SMS';

  @override
  String get enableWhatsappNotifications => 'Emeza ubutumwa bwa WhatsApp';

  @override
  String get receiveWhatsappNotificationsForOrders =>
      'Kwakira ubutumwa bwa WhatsApp ku byatumijwe n\'inyemezabwishyu PDF';

  @override
  String get systemSettings => 'Igenamiterere rya sisitemu';

  @override
  String get debugMode => 'Uburyo bwo kugenzura amakosa';

  @override
  String get enableDebugFeatures => 'Emeza ibikorwa byo kugenzura amakosa';

  @override
  String get forceUpdate => 'Hatira ivugurura';

  @override
  String get forceUpdateAllData => 'Hatira ivugurura ry\'amakuru yose';

  @override
  String get taxService => 'Serivisi y\'imisoro';

  @override
  String get toggleTaxService => 'Hindura serivisi y\'imisoro';

  @override
  String get savedDiscount => 'Igabanuka ryabitswe';

  @override
  String get createDiscount => 'Kora igabanuka';

  @override
  String get nameCannotBeNull => 'Izina ntirishobora kuba ubusa';

  @override
  String get amountCannotBeNull => 'Amafaranga ntashobora kuba ubusa';

  @override
  String get name => 'Izina';

  @override
  String saveTransactionTitle(String transactionType) {
    return 'Bika igurisha rya $transactionType';
  }

  @override
  String get confirmSaveTransaction => 'Uremeza ko ushaka kubika iri gurisha?';

  @override
  String get categoryMustBeSelected => 'Icyiciro kigomba gutoranywa';

  @override
  String get confirmLogout => 'Emeza gusohoka';

  @override
  String get confirmLogoutMessage => 'Uremeza ko ushaka gusohoka?';

  @override
  String get refundReason => 'Impamvu y\'isubizwa ry\'amafaranga';

  @override
  String get waitForApproval => 'Tegereza kwemezwa';

  @override
  String get approved => 'Byemejwe';

  @override
  String get cancelRequested => 'Hasabwe guhagarika';

  @override
  String get canceled => 'Byahagaritswe';

  @override
  String get refunded => 'Amafaranga yasubijwe';

  @override
  String get transferred => 'Byimuriwe';

  @override
  String get appLanguage => 'Ururimi rwa porogaramu';

  @override
  String get chooseAppLanguage => 'Hitamo ururimi Flipper ikoresha';

  @override
  String get selectLanguage => 'Hitamo ururimi';

  @override
  String get languageAppliesEverywhere =>
      'Bikoreshwa ku mapaji yose ya porogaramu.';

  @override
  String get useDeviceLanguage => 'Koresha ururimi rw\'igikoresho';

  @override
  String get automatic => 'Byikora';

  @override
  String get french => 'Igifaransa';

  @override
  String get accountAndFinancial => 'Konti n\'imari';

  @override
  String get adminProfile => 'Umwirondoro w\'umuyobozi';

  @override
  String get smsNotifications => 'Ubutumwa bwa SMS';

  @override
  String get close => 'Funga';

  @override
  String get refresh => 'Vugurura';

  @override
  String get adminEmailHint => 'urugero: admin@flipper.rw';

  @override
  String get displayName => 'Izina rigaragara';

  @override
  String get editName => 'Hindura izina';

  @override
  String get paymentMethods => 'Uburyo bw\'ubwishyu';

  @override
  String get managePaymentOptions => 'Cunga amahitamo y\'ubwishyu';

  @override
  String get enterPhoneNumber => 'Andika nimero ya telefoni';

  @override
  String get enableOrderNotifications => 'Emeza ubutumwa bw\'ibyatumijwe';

  @override
  String get receiveSmsNotificationsForOrders =>
      'Kwakira ubutumwa bwa SMS ku byatumijwe';

  @override
  String get enableDebuggingFeatures => 'Emeza ibikorwa byo kugenzura amakosa';

  @override
  String get ebm => 'EBM';

  @override
  String get reinitializeEbm => 'Ongera utangize EBM';

  @override
  String get manageTaxServiceStatus => 'Cunga imiterere ya serivisi y\'imisoro';

  @override
  String get hydrateData => 'Zana amakuru';

  @override
  String get refreshAllLocalData =>
      'Vugurura amakuru yose yo kuri iki gikoresho';

  @override
  String get assetDownload => 'Ikuramo ry\'amashusho';

  @override
  String get manageImageDownloads => 'Cunga ikuramo ry\'amashusho';

  @override
  String get autoAddSearch => 'Kwongeramo byikora';

  @override
  String get autoAddItemsWhenOneMatch =>
      'Ongeramo igicuruzwa byikora iyo kimwe gusa kibonetse';

  @override
  String get userLogging => 'Kwandika ibikorwa by\'abakoresha';

  @override
  String get enableExtensiveUserLogging =>
      'Emeza kwandika birambuye ibikorwa by\'abakoresha';

  @override
  String get priceQtyAdjustment => 'Guhuza igiciro n\'ingano';

  @override
  String get autoAdjustQtyOnPriceChange =>
      'Hindura ingano byikora iyo igiciro cyahindutse';

  @override
  String get decimals => 'Ibice by\'umubare';

  @override
  String get enableFractionalPricing => 'Emeza ibiciro bifite ibice';

  @override
  String get ticketReviewAndHandover => 'Igenzura n\'ishyikirizwa ry\'itike';

  @override
  String get administratorPin => 'PIN y\'umuyobozi';

  @override
  String get resetAdministratorPin => 'Subizaho PIN y\'umuyobozi';

  @override
  String get updateHighSecurityPin =>
      'Vugurura PIN yawe y\'imibare 4 ifite umutekano uhanitse';

  @override
  String get flipperSettingsTitle => 'Igenamiterere rya Flipper';

  @override
  String get common => 'Bisanzwe';

  @override
  String get environment => 'Aho bikorera';

  @override
  String get local => 'Kuri iki gikoresho';

  @override
  String get account => 'Konti';

  @override
  String get email => 'Imeyili';

  @override
  String get security => 'Umutekano';

  @override
  String get sendDailyReport => 'Ohereza raporo ya buri munsi';

  @override
  String get onlinePrint => 'Icapa kuri interineti';

  @override
  String get managePrintSettings => 'Cunga igenamiterere ry\'icapa';

  @override
  String get enableExtensiveLogging => 'Emeza kwandika birambuye';

  @override
  String get backgroundSync => 'Guhuza mu nyuma';

  @override
  String get syncDataInBackground => 'Huza amakuru mu nyuma';

  @override
  String get closeShift => 'Soza igihe cy\'akazi';

  @override
  String get startNewShift => 'Tangira igihe gishya cy\'akazi';

  @override
  String get checkSubscription => 'Genzura ifatabuguzi';

  @override
  String couldNotCheckSubscription(String error) {
    return 'Ntibyashobotse kugenzura ifatabuguzi: $error';
  }

  @override
  String get chooseYourDefaultApp => 'Hitamo porogaramu yawe y\'ibanze';

  @override
  String get accountSettings => 'Igenamiterere rya konti';

  @override
  String get switchAccount => 'Hindura konti';

  @override
  String continueToBranch(String branchName) {
    return 'Komeza kuri $branchName';
  }

  @override
  String get openShift => 'Tangira igihe cy\'akazi';

  @override
  String get checkingPaymentStatus => 'Turi kugenzura imiterere y\'ubwishyu…';

  @override
  String get refreshAfterCustomerPays =>
      'Vugurura nyuma y\'uko umukiriya yishyuye';

  @override
  String get branch => 'ishami';

  @override
  String get totalItems => 'Ibicuruzwa byose';

  @override
  String get expiredItems => 'Ibicuruzwa byarengeje igihe';

  @override
  String get lowStockItems => 'Ibicuruzwa bike mu bubiko';

  @override
  String get pendingOrders => 'Ibyatumijwe bitegereje';

  @override
  String get viewAll => 'Reba byose';

  @override
  String get idLabel => 'ID';

  @override
  String get item => 'Igicuruzwa';

  @override
  String get category => 'Icyiciro';

  @override
  String get quantity => 'Ingano';

  @override
  String get location => 'Ahantu';

  @override
  String get expiredOn => 'Yarengeje igihe ku';

  @override
  String get actions => 'Ibikorwa';

  @override
  String get allExpiredItems => 'Ibicuruzwa byose byarengeje igihe';

  @override
  String get goHomeQuestion => 'Urashaka kujya ahabanza?';

  @override
  String get searchProductsOrScan => 'Shakisha ibicuruzwa cyangwa sikana…';

  @override
  String get clear => 'Kuraho';

  @override
  String get addProductAction => 'Ongeramo igicuruzwa';

  @override
  String get help => 'Ubufasha';

  @override
  String get customerManagement => 'Icungabakiriya';

  @override
  String get searchCustomersByNameOrPhone =>
      'Shakisha abakiriya ku izina cyangwa telefoni';

  @override
  String get clearSearch => 'Kuraho ishakisha';

  @override
  String get add => 'Ongeramo';

  @override
  String get editCustomer => 'Hindura umukiriya';

  @override
  String get deleteCustomer => 'Siba umukiriya';

  @override
  String get customerActions => 'Ibikorwa ku mukiriya';

  @override
  String get phone => 'Telefoni';

  @override
  String get tin => 'TIN';

  @override
  String get invoice => 'Fagitire';

  @override
  String get txnId => 'ID y\'igurisha';

  @override
  String get addCustomer => 'Ongeramo umukiriya';

  @override
  String get sortDefault => 'Uko bisanzwe bitondekanye';

  @override
  String get sortByPopularity => 'Tondeka ukurikije icyamamare';

  @override
  String get sortByAverageRating => 'Tondeka ukurikije amanota rusange';

  @override
  String get sortByLatest => 'Tondeka ukurikije ibya vuba';

  @override
  String get sortByPriceLowToHigh =>
      'Tondeka ukurikije igiciro: gito ku kinini';

  @override
  String get sortByPriceHighToLow =>
      'Tondeka ukurikije igiciro: kinini ku gito';

  @override
  String get sortByStockOut => 'Tondeka ukurikije ububiko bwashize';

  @override
  String get sortByEventDateOldToNew =>
      'Tondeka ukurikije itariki: isaza ku nshya';

  @override
  String get sortByEventDateNewToOld =>
      'Tondeka ukurikije itariki: inshya ku isaza';

  @override
  String get sortCompactLatest => 'Ibya vuba';

  @override
  String get sortCompactDefault => 'Bisanzwe';

  @override
  String get sortCompactPopular => 'Bikunzwe';

  @override
  String get sortCompactRating => 'Amanota';

  @override
  String get sortCompactPrice => 'Igiciro';

  @override
  String get sortCompactStockOut => 'Ububiko bwashize';

  @override
  String get sortCompactDate => 'Itariki';

  @override
  String get posStockFilterInStock => 'Biri mu bubiko';

  @override
  String get posStockFilterOutOfStock => 'Byashize mu bubiko';

  @override
  String get posStockFilterAll => 'Ibicuruzwa byose';

  @override
  String get posStockFilterNoneInStock => 'Nta gicuruzwa kiri mu bubiko';

  @override
  String get posStockFilterNoneOutOfStock => 'Nta gicuruzwa cyashize mu bubiko';

  @override
  String get posStockFilterEmptyHint =>
      'Shakisha ubone igicuruzwa icyo ari cyo cyose, cyangwa uhindure akayunguruzo k\'ububiko.';

  @override
  String get posStockFilterShowAll => 'Erekana ibicuruzwa byose';

  @override
  String showingRangeOfResults(String start, String end, String total) {
    return 'Byerekanwe $start–$end kuri $total';
  }

  @override
  String pageOfPages(String current, String total) {
    return 'Ipaji $current kuri $total';
  }

  @override
  String loadedOfProducts(String loaded, String total) {
    return 'Ibicuruzwa $loaded kuri $total';
  }

  @override
  String get noProductsYet => 'Nta bicuruzwa birahari';

  @override
  String get noBranchSelected => 'Nta shami ryatoranyijwe';

  @override
  String get productsRefreshedForNewBranch =>
      'Ibicuruzwa byavuguruwe ku ishami rishya';

  @override
  String deletedItemsCount(int count) {
    return 'Ibicuruzwa $count byasibwe';
  }

  @override
  String inStockCount(String count) {
    return '$count mu bubiko';
  }

  @override
  String leftInStockCount(String count) {
    return 'Hasigaye $count mu bubiko';
  }

  @override
  String get stockLow => 'Bike';

  @override
  String get stockOutBadge => 'Byashize';

  @override
  String get mode => 'Uburyo';

  @override
  String get sale => 'Igurisha';

  @override
  String get transfer => 'Kwimura';

  @override
  String get searchCustomer => 'Shakisha umukiriya';

  @override
  String get pay => 'Ishyura';

  @override
  String get noItemsYet => 'Nta gicuruzwa kirahari';

  @override
  String get tapProductToStartSale => 'Kanda igicuruzwa utangire kugurisha';

  @override
  String grandTotalWithItems(String itemLabel) {
    return 'Igiteranyo cyose · $itemLabel';
  }

  @override
  String get defaultPrice => 'Igiciro gisanzwe';

  @override
  String pricePerUnitEach(String currency, String price) {
    return '$currency $price kuri kimwe';
  }

  @override
  String get deleteItem => 'Siba igicuruzwa';

  @override
  String get editDetails => 'Hindura ibisobanuro';

  @override
  String get enterQuantity => 'Andika ingano';

  @override
  String get invalidQuantity => 'Ingano itemewe';

  @override
  String get enterPrice => 'Andika igiciro';

  @override
  String get invalidPrice => 'Igiciro kitemewe';

  @override
  String get confirmDelete => 'Emeza isibwa';

  @override
  String confirmRemoveNamedItem(String itemName) {
    return 'Uremeza ko ushaka gukuraho \"$itemName\"?';
  }

  @override
  String errorDeletingItems(String error) {
    return 'Ikosa mu gusiba ibicuruzwa: $error';
  }

  @override
  String errorDeletingItem(String error) {
    return 'Ikosa mu gusiba igicuruzwa: $error';
  }

  @override
  String get failedToDeleteItem => 'Gusiba igicuruzwa ntibyakunze';

  @override
  String get failedToUpdateItem => 'Guhindura igicuruzwa ntibyakunze';

  @override
  String skuLabel(String sku) {
    return 'SKU: $sku';
  }

  @override
  String bcdLabel(String barcode) {
    return 'BCD: $barcode';
  }

  @override
  String get split => 'Gabanya';

  @override
  String get splitAcrossAnotherMethod =>
      'Gabanya ubu bwishyu ukoresheje ubundi buryo';

  @override
  String get allPaymentTypesInUse =>
      'Uburyo bwose bw\'ubwishyu burakoreshwa — kuraho bumwe kugira ngo wongere ubundi';

  @override
  String get allPaymentTypesAdded =>
      'Uburyo bwose bw\'ubwishyu bwamaze kongerwamo. Kuraho bumwe kugira ngo wongere ubundi.';

  @override
  String get pleaseEnterAnAmount => 'Nyamuneka andika umubare w’amafaranga';

  @override
  String get cashReceived => 'Amafaranga yakiriwe';

  @override
  String get amount => 'Umubare w\'amafaranga';

  @override
  String get removeThisPayment => 'Kuraho ubu bwishyu';

  @override
  String get tapSplitToPayWithMoreThanOneMethod =>
      'Kanda Gabanya kugira ngo wishyure ukoresheje uburyo burenze bumwe';

  @override
  String get tapSplitToAddMethod => 'Kanda Gabanya wongeremo ubundi buryo';

  @override
  String invoiceNumberValue(String number) {
    return 'Nimero $number';
  }

  @override
  String tenderedAmount(String amount) {
    return 'Yatanzwe $amount';
  }

  @override
  String paymentCollectedTotal(String total) {
    return 'Ubwishyu bwakiriwe · $total';
  }

  @override
  String get viewOnlyCannotTransferStock =>
      'Ufite uburenganzira bwo kureba gusa — ntushobora kwimura ibicuruzwa.';

  @override
  String get selectDestinationBranch => 'Hitamo ishami rigenewe';

  @override
  String get currentBranchIsMissing => 'Ishami rigezweho ntiriboneka';

  @override
  String get addItemsBeforeTransferring =>
      'Ongeramo ibicuruzwa mbere yo kwimura';

  @override
  String transferredItemsToBranch(int count, String branch) {
    return 'Ibicuruzwa $count byimuriwe kuri $branch';
  }

  @override
  String get transferFailed => 'Kwimura ntibyakunze';

  @override
  String get failedToClearCart => 'Gusiba agatebo ntibyakunze';

  @override
  String get paymentsCollectedAtTill =>
      'Ubwishyu bukirwa ku kasi. Ohereza iri tumizwa iyo ryiteguye — umuyobozi ni we uzakira ubwishyu.';

  @override
  String sentToTillTicket(String reference) {
    return 'Byoherejwe ku kasi — Itike #$reference';
  }

  @override
  String failedToSendToTill(String error) {
    return 'Kohereza ku kasi ntibyakunze: $error';
  }

  @override
  String collectingPaymentForTicket(
    String reference,
    String name,
    String minutes,
  ) {
    return 'Kwakira ubwishyu bwa #$reference · byoherejwe na $name · hashize iminota $minutes';
  }

  @override
  String get returningEllipsis => 'Turasubira…';

  @override
  String get backToNewSale => 'Subira ku igurisha rishya';

  @override
  String get paymentCashCredit => 'Amafaranga / Inguzanyo';

  @override
  String get paymentBankCheck => 'Sheki ya banki';

  @override
  String get paymentDebitCreditCard => 'Ikarita ya banki';

  @override
  String get paymentMobileMoney => 'Amafaranga kuri telefoni';

  @override
  String get paymentMtnMomo => 'MTN MoMo';

  @override
  String get payerNameOptional => 'Izina ry\'uwishyuye (si ngombwa)';

  @override
  String get paidBy => 'Yishyuwe na';

  @override
  String get paymentAirtelMoney => 'Airtel Money';

  @override
  String get paymentOther => 'Ibindi';

  @override
  String get sendForReview => 'Ohereza kugenzurwa';

  @override
  String get previewCart => 'Reba agatebo';

  @override
  String previewCartWithCount(int count) {
    return 'Reba agatebo ($count)';
  }

  @override
  String get placeOrder => 'Tanga itumizwa';

  @override
  String confirmRemoveAllItemsCount(int count) {
    return 'Uremeza ko ushaka gukura ibicuruzwa $count byose muri iri gurisha?';
  }

  @override
  String get taxServerUnreachableStatus =>
      'Seriveri y\'imisoro ya RRA ntiboneka — inyemezabwishyu ntizishobora gushyirwaho umukono kugeza igarutse. Turi kongera kugenzura.';

  @override
  String get internetUnavailableStatus =>
      'Nta murandasi uhari — kugurisha birakomeza nta murandasi, bizahuzwa nimugaruka kuri interineti.';

  @override
  String get includesVat => 'Harimo TVA';

  @override
  String get chooseDefaultApp => 'Hitamo porogaramu y\'ibanze';

  @override
  String get payShortcutHint => 'Ctrl / ⌘ + Enter kwishyura';

  @override
  String get receivedEyebrow => 'Yakiriwe';

  @override
  String get cartEmptyHint =>
      'Kanda igicuruzwa cyangwa usome barcode utangire kugurisha';

  @override
  String get branchNotAvailable => 'Ishami ntiriboneka';

  @override
  String get branchSelectBranch => 'Hitamo ishami';

  @override
  String get branchSwitchBranch => 'Hindura ishami';

  @override
  String get branchUnnamed => 'Ishami ritagira izina';

  @override
  String get compositeCost => 'Ikiguzi';

  @override
  String notificationsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ubutumwa $count',
      one: 'Ubutumwa 1',
    );
    return '$_temp0';
  }

  @override
  String get notificationsNew => 'Ubutumwa bushya';

  @override
  String get purchaseCodeErrorTryAgain => 'Habaye ikosa. Ongera ugerageze.';

  @override
  String get countryOfOriginSelect => 'Hitamo igihugu gikomokamo';

  @override
  String get countryOfOriginLoadFailed => 'Kuzana ibihugu ntibyakunze';

  @override
  String get orderStatusPending => 'Bitegereje';

  @override
  String get menuChat => 'Ikiganiro';

  @override
  String get backupConfiguration => 'Igenamiterere ry\'ikopi y\'ingoboka';

  @override
  String get backupEnableAuto => 'Emeza ikopi y\'ingoboka yikora';

  @override
  String get dashDismiss => 'Funga';

  @override
  String get favoritesSetProduct => 'Shyiraho igicuruzwa ukunda';

  @override
  String dashFieldRequired(String field) {
    return '$field irakenewe';
  }

  @override
  String get supplierSelect => 'Hitamo utanga ibicuruzwa';

  @override
  String get searchProductsTransactionsHint =>
      'Shakisha ibicuruzwa, ibyagurishijwe...';

  @override
  String get compositeItem => 'Igicuruzwa gikomatanyije';

  @override
  String get branchOrders => 'Ibyatumijwe n\'amashami';

  @override
  String get rowsPerPage => 'Imirongo kuri buri paji';

  @override
  String get pleaseEnterANumber => 'Nyamuneka andika umubare';

  @override
  String get ordersNoOrders => 'Nta byatumijwe';

  @override
  String get ordersNoneAtTheMoment => 'Nta byatumijwe ufite ubu.';

  @override
  String get ordersIncomingWillAppear =>
      'Ibyatumijwe bishya bizagaragara hano!';

  @override
  String get productTypeSelect => 'Hitamo ubwoko bw\'igicuruzwa';

  @override
  String get productTypeRawMaterial => 'Ibikoresho fatizo';

  @override
  String get productTypeFinishedProduct => 'Igicuruzwa cyarangiye';

  @override
  String get productTypeServiceWithoutStock => 'Serivisi idafite ububiko';

  @override
  String get compositeSkuRequired => 'SKU irakenewe';

  @override
  String get compositeBarcodeRequired => 'Barcode irakenewe';

  @override
  String get compositeBarcode => 'Barcode';

  @override
  String get tenantRefreshUserList => 'Vugurura urutonde rw\'abakoresha';

  @override
  String get categorySearchHint => 'Shakisha ibyiciro...';

  @override
  String get categoryNoneFound => 'Nta byiciro byabonetse';

  @override
  String get categoryAdd => 'Ongeramo icyiciro';

  @override
  String get stockLevel => 'Urugero rw\'ububiko';

  @override
  String get stockCurrentValue => 'Agaciro k\'ububiko buriho';

  @override
  String get dateSelect => 'Hitamo itariki';

  @override
  String get dateReportPeriod => 'IGIHE CYA RAPORO';

  @override
  String get dateApply => 'Emeza';

  @override
  String get dateApplyingRange => 'Turi gushyiraho igihe…';

  @override
  String get posCompleteNow => 'Rangiza ubu';

  @override
  String get downloadExcelSpreadsheet => 'Urupapuro rwa Excel';

  @override
  String get downloadDownloaded => 'Byamanuwe';

  @override
  String downloadProgress(String percent) {
    return 'Biri kumanurwa: $percent%';
  }

  @override
  String downloadSavedTo(String path) {
    return 'Byamanuriwe muri: $path';
  }

  @override
  String get downloadClickToDownload => 'Kanda kugira ngo umanure';

  @override
  String get orderingLoadingProducts => 'Turi kuzana ibicuruzwa...';

  @override
  String get searchProductHint => 'Shakisha';

  @override
  String get searchProductAllProducts => 'Ibicuruzwa byose';

  @override
  String get searchProductFavorites => 'Ibyo ukunda';

  @override
  String get refundReasonCustomerRequest => 'Ubusabe bw\'umukiriya';

  @override
  String get refundReasonWrongItem => 'Igicuruzwa kitari cyo';

  @override
  String get refundReasonDamaged => 'Cyangiritse / gifite ikibazo';

  @override
  String get refundReasonDuplicateCharge => 'Kwishyuzwa kabiri';

  @override
  String get taxSettingsUpdated => 'Igenamiterere ry\'imisoro ryavuguruwe neza';

  @override
  String get taxSettingsUpdateError =>
      'Ikosa mu kuvugurura igenamiterere ry\'imisoro';

  @override
  String taxSettingsTaxType(String taxType) {
    return 'Umusoro $taxType';
  }

  @override
  String get taxSettingsRequired => 'Birakenewe';

  @override
  String get taxSettingsRange => 'Bigomba kuba hagati ya 0 na 100';

  @override
  String get taxSettingsNoneFound => 'Nta igenamiterere ry\'imisoro ryabonetse';

  @override
  String get cartQtySuffix => 'ingano';

  @override
  String cartPriceQtyEquivalent(String qty, String unitPrice) {
    return 'Bingana n\'ibice $qty ku $unitPrice RWF';
  }

  @override
  String get addProductSingleTitle => 'Igicuruzwa kimwe';

  @override
  String get addProductSingleSubtitle =>
      'Ongeramo kandi utunganye igicuruzwa kimwe';

  @override
  String get addProductBadgeQuick => 'VUBA';

  @override
  String get addProductBulkTitle => 'Ongeramo byinshi';

  @override
  String get addProductBulkSubtitle => 'Injiza ibicuruzwa byinshi icyarimwe';

  @override
  String get addProductBadgeFast => 'BYIHUSE';

  @override
  String get addProductRoomsTitle => 'Ongeramo ibyumba';

  @override
  String get addProductRoomsSubtitle => 'Hoteli n\'amacumbi';

  @override
  String get addProductBadgeHotel => 'HOTELI';

  @override
  String get addProductFuelTitle => 'Huza ibikomoka kuri peteroli';

  @override
  String get addProductFuelSubtitle => 'Mazutu na lisansi biva muri RRA';

  @override
  String get addProductBadgeFuel => 'LISANSI';

  @override
  String get addProductChooseHow => 'Hitamo uburyo ushaka kongeramo';

  @override
  String scanNoVariantsFor(String query) {
    return 'Nta bwoko bwabonetse kuri \"$query\"';
  }

  @override
  String scanErrorSearching(String error) {
    return 'Ikosa mu gushakisha amoko: $error';
  }

  @override
  String get scanNoVariantsAvailable => 'Nta bwoko buhari';

  @override
  String get scanSelectVariant => 'Hitamo ubwoko bw\'igicuruzwa';

  @override
  String get scanSearchByNameOrBarcode =>
      'Shakisha ukoresheje izina cyangwa barcode';

  @override
  String get scanNoMatchingVariants => 'Nta bwoko buhuye bwabonetse';

  @override
  String scanRetailPrice(String price) {
    return 'Igiciro cyo kugurisha: $price';
  }

  @override
  String scanBarcode(String barcode) {
    return 'Barcode: $barcode';
  }

  @override
  String scanErrorShowing(String error) {
    return 'Ikosa mu kwerekana amoko: $error';
  }

  @override
  String get productCreate => 'Kora igicuruzwa';

  @override
  String get productLabel => 'Igicuruzwa';

  @override
  String get productNameHint => 'Izina ry\'igicuruzwa';

  @override
  String get productPriceAndInventory => 'IGICIRO N\'UBUBIKO';

  @override
  String get productExpiryDate => 'Itariki yo kurangira';

  @override
  String productExpiresAt(String date) {
    return 'Kirarangira ku wa $date';
  }

  @override
  String get productAddVariation => 'Ongeramo ubwoko';

  @override
  String get productProvideName => 'Andika izina ry\'igicuruzwa';

  @override
  String get productUnsavedDiscard =>
      'Ufite igicuruzwa kitabitswe. Urashaka kukireka?';

  @override
  String get variantsTax => 'Umusoro';

  @override
  String get variantsUnit => 'Igipimo';

  @override
  String get variantsClassification => 'Ishyirwa mu byiciro';

  @override
  String get variantsExpiration => 'Irangira';

  @override
  String get variantsAction => 'Igikorwa';

  @override
  String get checkoutNoCustomer => 'Nta mukiriya';

  @override
  String get checkoutWalkIn => 'Umukiriya w\'akanya';

  @override
  String get checkoutTotal => 'Igiteranyo';

  @override
  String get checkoutReviewAndPay => 'Genzura wishyure';

  @override
  String get checkoutReviewAndSend => 'Genzura wohereze';

  @override
  String get checkoutCouldNotOpen =>
      'Ntibyashobotse gufungura kwishyura kuri iki gitebo. Ongera ugerageze.';

  @override
  String get checkoutScan => 'Sikana';

  @override
  String get checkoutItemsNotAvailable => 'Ibicuruzwa ntibiboneka';

  @override
  String checkoutErrorLoadingItemsDetail(String error) {
    return 'Ikosa mu kuzana ibicuruzwa: $error';
  }

  @override
  String get checkoutErrorLoadingItems => 'Ikosa mu kuzana ibicuruzwa';

  @override
  String get checkoutStatusOpen => 'Birafunguye';

  @override
  String get checkoutStatusCompleted => 'Byarangiye';

  @override
  String get reportsBusinessAnalytics => 'Isesengura ry\'ubucuruzi';

  @override
  String get reportsStockValue => 'Agaciro k\'ububiko';

  @override
  String get reportsTotalSales => 'Ibyagurishijwe byose';

  @override
  String get reportsProfit => 'Inyungu';

  @override
  String get reportsLoading => 'Biri kuzanwa...';

  @override
  String get reportsStockPerformance => 'Imigendekere y\'ububiko';

  @override
  String get reportsErrorLoadingChart =>
      'Ikosa mu kuzana amakuru y\'igishushanyo';

  @override
  String get reportsInsufficientData =>
      'Amakuru ntahagije ngo igishushanyo kigaragare';

  @override
  String get reportsDetailedMetrics => 'Ibipimo birambuye';

  @override
  String get reportsErrorLoadingMetrics => 'Ikosa mu kuzana ibipimo';

  @override
  String get branchesTitle => 'Amashami';

  @override
  String get branchesAddNew => 'Ongeramo ishami rishya';

  @override
  String get branchesName => 'Izina ry\'ishami';

  @override
  String get branchesNameHint => 'Andika izina ry\'ishami';

  @override
  String get branchesLocationHint => 'Andika aho ishami riherereye';

  @override
  String get branchesCreate => 'Fungura ishami';

  @override
  String get branchesAll => 'Amashami yose';

  @override
  String get branchesLoadFailed => 'Ntibyashobotse kuzana amashami';

  @override
  String get branchesNoneFound => 'Nta mashami yabonetse';

  @override
  String get dashUnknown => 'Ntibizwi';

  @override
  String get branchesDefaultBadge => 'Iy\'ibanze';

  @override
  String get branchesActiveBadge => 'Irakora';

  @override
  String get branchesDelete => 'Siba ishami';

  @override
  String get branchesDefaultCannotDelete =>
      'Ishami ry\'ibanze ntirishobora gusibwa';

  @override
  String get branchesKeepOne => 'Ugomba gusigarana nibura ishami rimwe';

  @override
  String branchesDeleteConfirm(String name) {
    return 'Uremeza ko ushaka gusiba $name?';
  }

  @override
  String get branchesDeleteFailed => 'Ntibyashobotse gusiba ishami';

  @override
  String get branchesAddError => 'Ikosa mu kongeramo ishami';

  @override
  String get branchesNameRequired => 'Izina ry\'ishami rirakenewe';

  @override
  String get branchesLocationRequired => 'Aho riherereye harakenewe';

  @override
  String get roomAdd => 'Ongeramo icyumba';

  @override
  String get roomNumber => 'Nimero y\'icyumba';

  @override
  String get roomType => 'Ubwoko bw\'icyumba';

  @override
  String get roomSelect => 'Hitamo';

  @override
  String get roomSelectTypeError => 'Nyamuneka hitamo ubwoko bw\'icyumba';

  @override
  String get roomPricePerNight => 'Igiciro ku ijoro';

  @override
  String get roomTaxCode => 'Kode y\'umusoro';

  @override
  String get roomSelectTaxCodeError => 'Nyamuneka hitamo kode y\'umusoro';

  @override
  String get roomTaxExemptShort => 'Usonewe';

  @override
  String get roomTaxStandardRate => 'Igipimo gisanzwe';

  @override
  String get roomTaxReducedRate => 'Igipimo cyagabanyijwe';

  @override
  String get roomTaxNonVat => 'Nta TVA';

  @override
  String get roomTaxExempt => 'Usonewe umusoro';

  @override
  String get roomTaxExemptHint => 'Sonera iki cyumba TVA';

  @override
  String get roomAddedSuccess => 'Icyumba cyongewemo neza';

  @override
  String roomAddError(String error) {
    return 'Ikosa mu kongeramo icyumba: $error';
  }

  @override
  String get roomTypeSingle => 'Icy\'umuntu umwe';

  @override
  String get roomTypeDouble => 'Icy\'abantu babiri';

  @override
  String get roomTypeSuite => 'Suite';

  @override
  String get roomTypeDeluxe => 'Icy\'icyubahiro';

  @override
  String get branchSwitchedRefreshing =>
      'Ishami ryahinduwe. Turi kuvugurura amakuru...';

  @override
  String get branchDefault => 'Ishami ry\'ibanze';

  @override
  String get branchLoggingOut => 'Turi kugusohora...';

  @override
  String branchSwitchedTo(String branch) {
    return 'Wimukiye kuri $branch';
  }

  @override
  String branchSwitchingTo(String branch) {
    return 'Turi kwimukira kuri $branch…';
  }

  @override
  String get branchSwitchTitle => 'Hindura ishami';

  @override
  String get branchActive => 'Ishami rikoreshwa';

  @override
  String get branchLoading => 'Turi kuzana amashami…';

  @override
  String get branchNoneAvailable => 'Nta mashami ahari';

  @override
  String get branchSearchHint => 'Shakisha amashami…';

  @override
  String get gaugeIncorrectWidgetType => 'Ubwoko bw\'igice butari bwo';

  @override
  String get gaugeFinancialOverview => 'Incamake y\'imari';

  @override
  String get gaugeReadyToTrack => 'Witeguye gutangira gukurikirana!';

  @override
  String get gaugeTransactionsWillAppear =>
      'Ibyakozwe byawe bizagaragara hano nutangira kubyongeramo.';

  @override
  String gaugeNoRecordsFor(String period) {
    return 'Nta byanditswe kuri $period';
  }

  @override
  String get gaugeTryDifferentPeriod =>
      'Gerageza guhitamo ikindi gihe cyangwa wongeremo ibyakozwe.';

  @override
  String get gaugeRecentTransactions => 'Ibyakozwe vuba';

  @override
  String get gaugeLast30Days => 'Iminsi 30 ishize';

  @override
  String get gaugeWaitingMomo => 'BITEGEREJE MOMO';

  @override
  String get gaugeLoadingTransactions => 'Turi kuzana ibyakozwe...';

  @override
  String get gaugeSomethingWentWrong => 'Hari ikitagenze neza';

  @override
  String get gaugePeriodToday => 'Uyu munsi';

  @override
  String get gaugePeriodThisWeek => 'Iki cyumweru';

  @override
  String get gaugePeriodThisMonth => 'Uku kwezi';

  @override
  String get gaugePeriodThisYear => 'Uyu mwaka';

  @override
  String get deliveryDriverAppTitle =>
      'Porogaramu y\'umushoferi utwara ibicuruzwa';

  @override
  String get deliveryOnline => 'Ari ku murongo';

  @override
  String get deliveryOffline => 'Ntari ku murongo';

  @override
  String get deliveryCurrentPickup => 'Ibyo gufata ubu';

  @override
  String get deliveryConfirmPickup => 'Emeza ko wafashe';

  @override
  String get deliveryUpcoming => 'Ibizatangwa vuba';

  @override
  String deliveryOrderNumber(String id) {
    return 'Itumiza #$id';
  }

  @override
  String deliveryPickupLine(String place) {
    return 'Aho gufatira: $place';
  }

  @override
  String deliveryDeliverTo(String name) {
    return 'Bigezwe kuri: $name';
  }

  @override
  String get deliveryYouAreOffline => 'Nturi ku murongo';

  @override
  String get deliveryGoOnline => 'Jya ku murongo utangire kwakira ibyo gutwara';

  @override
  String get sideMenuOverview => 'Incamake';

  @override
  String get sideMenuAuthenticator => 'Igenzura ry\'umwirondoro';

  @override
  String get sideMenuKitchenDisplay => 'Ikibaho cy\'igikoni';

  @override
  String get sideMenuStockRecount => 'Kongera kubara ububiko';

  @override
  String get sideMenuDelegations => 'Intumwa';

  @override
  String get sideMenuIncomingOrders => 'Ibyatumijwe byinjira';

  @override
  String get sideMenuTransfersReport => 'Raporo y\'iyimurwa';

  @override
  String get sideMenuProductionOutput => 'Umusaruro wakozwe';

  @override
  String get sideMenuTransactions => 'Ibyakozwe';

  @override
  String get sideMenuAnalytics => 'Isesengura';

  @override
  String get sideMenuShiftHistory => 'Amateka y\'ibihe by\'akazi';

  @override
  String get sideMenuAgentCommission => 'Komisiyo y\'umukozi';

  @override
  String get sideMenuEndShift => 'Soza igihe cy\'akazi';

  @override
  String get ipmPageErrorLoading => 'Ikosa mu kuzana amakuru';

  @override
  String get ipmPageNoImports => 'Nta bicuruzwa byatumijwe hanze';

  @override
  String get ipmPageNoImportsHint =>
      'Huza na RRA kugira ngo uzane ibicuruzwa bishya byatumijwe hanze.';

  @override
  String get ipmPageNoPurchases => 'Nta fagitire z\'ibyaguzwe';

  @override
  String get ipmPageNoPurchasesHint =>
      'Huza na RRA cyangwa wandike ibyaguzwe n\'intoki.';

  @override
  String get ipmPageRetrySucceeded => 'Kongera kugerageza byakunze';

  @override
  String ipmPageRetryFailed(String error) {
    return 'Kongera kugerageza ntibyakunze: $error';
  }

  @override
  String get ipmPageMissingPricing =>
      'Kimwe mu bicuruzwa byo kwemezwa kibura ibiciro bikenewe';

  @override
  String ipmPageApprovedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibicuruzwa $count byemejwe',
      one: 'Igicuruzwa 1 cyemejwe',
    );
    return '$_temp0';
  }

  @override
  String ipmPageApproveItemsFailed(String error) {
    return 'Ntibyashobotse kwemeza ibicuruzwa: $error';
  }

  @override
  String get ipmPageSetBothPrices =>
      'Nyamuneka shyiraho igiciro cyo kugurisha n\'ikiranguzo';

  @override
  String ipmPageApprovedItem(String name) {
    return '\"$name\" cyemejwe';
  }

  @override
  String ipmPageApproveItemFailed(String error) {
    return 'Ntibyashobotse kwemeza igicuruzwa: $error';
  }

  @override
  String ipmPageRejectedItem(String name) {
    return '\"$name\" cyanzwe';
  }

  @override
  String ipmPageRejectItemFailed(String error) {
    return 'Ntibyashobotse kwanga igicuruzwa: $error';
  }

  @override
  String get importsColNo => 'No.';

  @override
  String get importsColItemName => 'Izina ry\'igicuruzwa';

  @override
  String get importsColHsCode => 'Kode ya HS';

  @override
  String get importsColRetailPrice => 'Igiciro cyo kugurisha';

  @override
  String get importsColSupplyPrice => 'Ikiranguzo';

  @override
  String get importsColStatus => 'Imiterere';

  @override
  String get importsColSupplier => 'Utanga ibicuruzwa';

  @override
  String get importsColDate => 'Itariki';

  @override
  String get importsWait => 'Tegereza';

  @override
  String get importsRejected => 'Byanzwe';

  @override
  String get importsApprove => 'Emeza';

  @override
  String get importsReject => 'Anga';

  @override
  String importsApproveError(String error) {
    return 'Ikosa mu kwemeza igicuruzwa: $error';
  }

  @override
  String importsRejectError(String error) {
    return 'Ikosa mu kwanga igicuruzwa: $error';
  }

  @override
  String get importsNoData =>
      'Nta makuru yabonetse cyangwa habaye ikibazo cya murandasi, ongera ugerageze.';

  @override
  String get importsNoMatches => 'Nta bihuye n\'iyungurura wahisemo.';

  @override
  String get refundUnavailable => 'Gusubiza amafaranga ntibishoboka';

  @override
  String refundWithAmount(String amount) {
    return 'Subiza $amount';
  }

  @override
  String get refundReceiptCannotBeRefunded =>
      'Iyi nyemezabwishyu ntishobora gusubizwa';

  @override
  String get refundNoCopyToPrint =>
      'Iyi nyemezabwishyu nta kopi yo gucapa ifite';

  @override
  String get refundTransactionTitle => 'Igikorwa';

  @override
  String get refundCopied => 'Byakoporowe';

  @override
  String get refundPayerDiffers => 'atandukanye n\'umukiriya';

  @override
  String get refundTaxIncluded => 'Umusoro urimo';

  @override
  String get refundAmountLabel => 'Amafaranga asubizwa';

  @override
  String get refundPrintCopy => 'Capa kopi y\'inyemezabwishyu';

  @override
  String get refundStatusPartiallyRefunded => 'Byasubijwe igice';

  @override
  String get refundStatusParked => 'Byabitswe';

  @override
  String refundSaleSubtitle(String payment) {
    return 'Igurisha rya $payment';
  }

  @override
  String get refundPaymentCard => 'Ikarita';

  @override
  String get ebmNoActiveBranch => 'Nta shami rikoreshwa ryabonetse';

  @override
  String get ebmTinRequired => 'TIN irakenewe';

  @override
  String get ebmBhfIdRequired => 'BHF ID irakenewe';

  @override
  String get ebmDeviceSerial => 'Nimero y\'ikirango cy\'igikoresho';

  @override
  String get ebmDeviceSerialRequired =>
      'Nimero y\'ikirango cy\'igikoresho irakenewe';

  @override
  String get ebmProcessing => 'Biri gukorwa...';

  @override
  String get ebmReinitialize => 'Ongera utangize';

  @override
  String ebmInitFailed(String error) {
    return 'Gutangiza EBM ntibyakunze: $error';
  }

  @override
  String get ebmInitSuccess => 'EBM yatangijwe neza';

  @override
  String get ebmTaxpayerName => 'Izina ry\'usora';

  @override
  String get searchCustomerType => 'Ubwoko bw\'umukiriya';

  @override
  String get searchSaleType => 'Ubwoko bw\'igurisha';

  @override
  String get searchAssignAgent => 'Shyiraho umukozi';

  @override
  String get searchAgent => 'Umukozi';

  @override
  String get searchCustomerTypeShop => 'Iduka';

  @override
  String get searchSaleTypeOutgoing => 'Igurisha risanzwe';

  @override
  String get searchSaleTypeAgent => 'Igurisha rikozwe n\'umukozi';

  @override
  String get fuelSelectBranchFirst => 'Hitamo ishami mbere yo guhuza lisansi.';

  @override
  String get fuelBusinessMissing => 'Amakuru y\'ubucuruzi arabura.';

  @override
  String get fuelVatRequired =>
      'TVA / EBM bigomba kuba bikora kugira ngo uhuze ibikomoka kuri peteroli bigenzurwa.';

  @override
  String get fuelContactingConnector => 'Turi kuvugana na data-connector…';

  @override
  String get fuelFetchingCatalog =>
      'Turi kuzana urutonde rwa lisansi muri RRA…';

  @override
  String get fuelWaitingForSync => 'Dutegereje ihuzwa rya Ditto…';

  @override
  String fuelVariantsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'amoko $count',
      one: 'ubwoko 1',
    );
    return '$_temp0';
  }

  @override
  String get fuelSyncExplanation =>
      'Bizana ibikomoka kuri peteroli bigenzurwa biva muri RRA. Kwandika lisansi n\'intoki ntibyemewe — koresha iri huzwa.';

  @override
  String get fuelProductName => 'Izina ry\'igicuruzwa';

  @override
  String get fuelProductNameRequired => 'Izina ry\'igicuruzwa rirakenewe';

  @override
  String get fuelEnableVat =>
      'Emeza TVA kuri iri shami mbere yo guhuza lisansi.';

  @override
  String get fuelSyncing => 'Birahuzwa…';

  @override
  String get fuelSyncFromRra => 'Huza uvuye muri RRA';

  @override
  String get editQtyCannotBeNegative => 'Ingano ntishobora kuba munsi ya zeru';

  @override
  String editQtyRraFloor(String floor) {
    return 'Ububiko bwamenyeshejwe RRA bushobora kongerwa gusa hano. Koresha ihinduka ry\'ububiko kugira ngo ujye munsi ya $floor.';
  }

  @override
  String get editQtyServiceNotice =>
      'Serivisi ntizigira ububiko. Kubika bigumisha ubu bwoko kuri 0.';

  @override
  String editQtyCannotGoBelow(String floor) {
    return 'Ntibishobora kujya munsi ya $floor';
  }

  @override
  String editQtyAdds(String qty) {
    return 'Byongera $qty ku bubiko buriho.';
  }

  @override
  String editQtyRemoves(String qty) {
    return 'Bikuraho $qty ku bubiko buriho.';
  }

  @override
  String editQtyStays(String qty) {
    return 'Ububiko buguma kuri $qty.';
  }

  @override
  String get editQtyGotIt => 'Ndabyumvise';

  @override
  String get editQtyUpdateStock => 'Vugurura ububiko';

  @override
  String get editQtyTitle => 'Hindura ingano';

  @override
  String editQtyOnHand(String qty) {
    return 'Bihari $qty';
  }

  @override
  String get creditHubTitle => 'Ihuriro ry\'inguzanyo';

  @override
  String get creditHubAddCredits => 'Ongeramo inguzanyo';

  @override
  String get creditHubUseCredits => 'Koresha inguzanyo';

  @override
  String creditHubUseAmount(int amount) {
    return 'Koresha $amount';
  }

  @override
  String get creditHubAvailable => 'Inguzanyo zihari';

  @override
  String get creditHubCredits => 'Inguzanyo';

  @override
  String get creditHubQuickAdd => 'Ongeramo vuba';

  @override
  String get creditHubEnterAmount => 'Andika umubare';

  @override
  String creditHubUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Inguzanyo $count zakoreshejwe',
      one: 'Inguzanyo 1 yakoreshejwe',
    );
    return '$_temp0';
  }

  @override
  String creditHubAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Inguzanyo $count zongewemo neza',
      one: 'Inguzanyo 1 yongewemo neza',
    );
    return '$_temp0';
  }

  @override
  String get creditHubInvalidAmount => 'Nyamuneka andika umubare wemewe';

  @override
  String creditHubMaximum(int max) {
    return 'Ntarengwa: $max';
  }

  @override
  String get customerFormNewBusiness => 'Ubucuruzi bushya';

  @override
  String get customerFormNewCustomer => 'Umukiriya mushya';

  @override
  String get customerFormNoPhone => 'Nta telefoni iraboneka';

  @override
  String get customerFormType => 'Ubwoko bw\'umukiriya';

  @override
  String get customerFormBusinessName => 'Izina ry\'ubucuruzi';

  @override
  String get customerFormFullName => 'Amazina yuzuye';

  @override
  String get customerFormBusinessNameHint => 'urugero: Kigali Traders Ltd';

  @override
  String get customerFormFullNameHint => 'urugero: Jean Mukamana';

  @override
  String get customerFormEmail => 'Aderesi ya imeyili';

  @override
  String get customerFormTinHint => 'Nimero y\'usora ishyirwa kuri fagitire';

  @override
  String get customerFormUpdated => 'Umukiriya yavuguruwe neza!';

  @override
  String get customerFormAddedAttached =>
      'Umukiriya yongewemo kandi yometswe ku igurisha';

  @override
  String get customerFormAddFailed => 'Kongeramo umukiriya ntibyakunze';

  @override
  String get customerFormSaveChanges => 'Bika impinduka';

  @override
  String get customerFormAddAttach => 'Ongeramo kandi womeke umukiriya';

  @override
  String get customerFormOptional => 'si ngombwa';

  @override
  String get customerFormIndividual => 'Umuntu ku giti cye';

  @override
  String get backupNow => 'Kora ikopi y\'ingoboka ubu';

  @override
  String get backupCreated => 'Ikopi y\'ingoboka yakozwe';

  @override
  String get syncTitle => 'Guhuza';

  @override
  String get syncEnable => 'Emeza guhuza';

  @override
  String get qrCode => 'Kode ya QR';

  @override
  String get qrMode => 'Uburyo bwa QR';

  @override
  String get qrModeEnable => 'Emeza uburyo bwa QR';

  @override
  String get qrModeEmailNotGmail => 'Imeyili wongeyemo si iya Gmail';

  @override
  String get appChoicePosSubtitle => 'Gurisha kandi wakire ubwishyu';

  @override
  String get appChoiceBooks => 'Ibaruramari';

  @override
  String get appChoiceBooksSubtitle => 'Ibaruramari n\'ibitabo by\'imari';

  @override
  String get appChoiceInventorySubtitle => 'Ububiko n\'ibicuruzwa';

  @override
  String get appChoiceReportsSubtitle =>
      'Isesengura ry\'ibyagurishijwe n\'imisoro';

  @override
  String get appChoiceOrders => 'Ibyatumijwe';

  @override
  String get appChoiceOrdersSubtitle => 'Ibyaguzwe n\'iyimurwa';

  @override
  String get appChoiceCustomersSubtitle => 'Abo muvugana n\'inguzanyo';

  @override
  String get appChoiceSettingsSubtitle => 'Ibikoresho, imisoro n\'abakozi';

  @override
  String get appChoiceTitle => 'Hitamo porogaramu yawe';

  @override
  String get appChoiceSubtitle =>
      'Hitamo aho ushaka gutangirira. Ushobora guhindura porogaramu igihe icyo ari cyo cyose.';

  @override
  String get appChoiceKeyboardHint =>
      'Kanda 1–7 ufungure, imyambi wimuke, Esc ufunge';

  @override
  String get posBalanceDue => 'Asigaye kwishyurwa';

  @override
  String get posChange => 'Amafaranga yo kugarura';

  @override
  String posTillTicketName(String reference) {
    return 'Kasi · $reference';
  }

  @override
  String get posSentToTillNote => 'Byoherejwe ku kasi kwishyurwa';

  @override
  String get posReturnToTillFailed =>
      'Ntibyashobotse gusubiza iyi tike ku kasi. Ongera ugerageze.';

  @override
  String cashbookPersonalGoalNote(String goal) {
    return 'Intego bwite: $goal';
  }

  @override
  String get cashbookTitle => 'Igitabo cy\'amafaranga';

  @override
  String get cashbookRecentTransactions => 'Ibyakozwe vuba';

  @override
  String get cashbookFilterAll => 'Byose';

  @override
  String get cashbookCashIn => 'Amafaranga yinjiye';

  @override
  String get cashbookCashOut => 'Amafaranga yasohotse';

  @override
  String get cashbookTotalOut => 'Ayasohotse yose';

  @override
  String get cashbookMomoNet => 'Asigaye kuri MoMo';

  @override
  String get cashbookTotalIn => 'Ayinjiye yose';

  @override
  String cashbookNoCashInFor(String period) {
    return 'Nta mafaranga yinjiye muri $period.';
  }

  @override
  String cashbookNoCashOutFor(String period) {
    return 'Nta mafaranga yasohotse muri $period.';
  }

  @override
  String cashbookNoMomoFor(String period) {
    return 'Nta byakozwe kuri MoMo muri $period.';
  }

  @override
  String cashbookNoTransactionsFor(String period) {
    return 'Nta byakozwe muri $period.';
  }

  @override
  String get cashbookReceivedAs => 'Byakiriwe mu buryo bwa';

  @override
  String get cashbookPaidWith => 'Byishyuwe hakoreshejwe';

  @override
  String get cashbookCashInFor => 'Impamvu y\'amafaranga yinjiye (si ngombwa)';

  @override
  String get cashbookCashOutFor =>
      'Impamvu y\'amafaranga yasohotse (si ngombwa)';

  @override
  String get cashbookNote => 'Inyandiko';

  @override
  String get cashbookOptionalNoteHint => 'Inyandiko itari ngombwa...';

  @override
  String get cashbookMoneyIn => 'Amafaranga yinjira';

  @override
  String get cashbookMoneyOut => 'Amafaranga asohoka';

  @override
  String get cashbookAmountPositive => 'Amafaranga agomba kuba arenze zeru';

  @override
  String get cashbookNewCategory => 'Gishya';

  @override
  String cashbookCategoriesError(String error) {
    return 'Ikosa ry\'ibyiciro: $error';
  }

  @override
  String get cashbookSaveEntry => 'Bika icyanditswe';

  @override
  String get cashbookCashInSaved => 'Amafaranga yinjiye yabitswe neza';

  @override
  String get cashbookCashOutSaved => 'Amafaranga yasohotse yabitswe neza';

  @override
  String get variantsSelectAll => 'Hitamo byose';

  @override
  String get variantsVariant => 'Ubwoko';

  @override
  String get variantsNoDiscount => 'Nta gabanuka';

  @override
  String variantsPercentOff(String percent) {
    return 'Igabanuka rya $percent%';
  }

  @override
  String variantsExpires(String date) {
    return 'Kirarangira $date';
  }

  @override
  String get variantsNoExpiry => 'Nta tariki yo kurangira';

  @override
  String get variantsLowStock => 'Ububiko buke';

  @override
  String get variantsDiscountPercent => 'Igabanuka %';

  @override
  String get variantsRraItemClass => 'Icyiciro cy\'igicuruzwa cya RRA';

  @override
  String get variantsSetDate => 'Shyiraho itariki';

  @override
  String variantsPriceLine(String price) {
    return 'Igiciro: $price';
  }

  @override
  String get variantsReorderAt => 'Ongera utumize kuri';

  @override
  String get variantsImage => 'Ifoto';

  @override
  String get variantsDeleteAllSemantic => 'Siba amoko yose';

  @override
  String get variantsHideMoreDetails => 'Hisha umusoro, igipimo n\'irangira';

  @override
  String get variantsMoreDetails => 'Umusoro, igipimo n\'irangira';

  @override
  String get refundProformaNotRefundable =>
      'Ntushobora gusubiza amafaranga ya proforma';

  @override
  String get adminPhoneWithCountryCode =>
      'Andika nimero ya telefoni yemewe irimo kode y\'igihugu (urugero: +250783054874).';

  @override
  String get adminSmsConfigFailed =>
      'Kuvugurura igenamiterere rya SMS ntibyakunze';

  @override
  String get adminWhatsappChannel => 'Umuyoboro wa WhatsApp';

  @override
  String get adminWhatsappChannelHint =>
      'Hitamo uburyo inyemezabwishyu za elegitoroniki n\'ubutumwa bw\'ibyatumijwe byoherezwa.';

  @override
  String get adminOpenWaSubtitle =>
      'WhatsApp ikorera kuri seriveri yawe (umuyoboro 1)';

  @override
  String get adminMetaSubtitle =>
      'WhatsApp yemewe ya Meta (umuyoboro 2). Abakiriya bashobora gusabwa gusikana QR kugira ngo bemere mbere y\'uko inyemezabwishyu zoherezwa.';

  @override
  String get adminUserFallback => 'Ukoresha';

  @override
  String get adminEnterDisplayName => 'Andika izina rigaragara.';

  @override
  String get adminNotSignedIn => 'Ntabwo winjiye.';

  @override
  String get adminMissingLoginKey =>
      'Urufunguzo rwo kwinjira kuri konti rurabura.';

  @override
  String get adminNameUpdated => 'Izina ryavuguruwe.';

  @override
  String adminSaveNameFailed(String error) {
    return 'Ntibyashobotse kubika izina: $error';
  }

  @override
  String get adminPhoneSetOnce =>
      'Nimero ya telefoni ishyirwaho rimwe gusa. Vugana n\'ubufasha kugira ngo uyihindure.';

  @override
  String get adminPhoneSaved => 'Nimero ya telefoni yabitswe.';

  @override
  String adminSavePhoneFailed(String error) {
    return 'Ntibyashobotse kubika telefoni: $error';
  }

  @override
  String get adminEmailAlreadySet =>
      'Imeyili yamaze gushyirwaho kandi ntishobora guhindurirwa hano.';

  @override
  String get adminInvalidEmail => 'Nyamuneka andika aderesi ya imeyili yemewe.';

  @override
  String get adminEmailSavedBusinessFailed =>
      'Imeyili yabitswe kuri konti yawe. Igenamiterere ry\'ubucuruzi ntiryashoboye kuvugururwa.';

  @override
  String get adminEmailUpdated => 'Imeyili yavuguruwe.';

  @override
  String adminSaveEmailFailed(String error) {
    return 'Ntibyashobotse kubika imeyili: $error';
  }

  @override
  String get adminLogoUpdated => 'Ikirango cy\'inyemezabwishyu cyavuguruwe.';

  @override
  String adminLogoUpdateFailed(String error) {
    return 'Kuvugurura ikirango ntibyakunze: $error';
  }

  @override
  String get adminLogoRemoved =>
      'Ikirango cy\'inyemezabwishyu cyakuweho. Hazakoreshwa ikirango gisanzwe.';

  @override
  String adminLogoRemoveFailed(String error) {
    return 'Gukuraho ikirango ntibyakunze: $error';
  }

  @override
  String get adminBadge => 'UMUYOBOZI';

  @override
  String get adminNoPhoneOnAccount => 'Nta telefoni iri kuri konti';

  @override
  String get adminAddPhone => 'Ongeramo telefoni';

  @override
  String get adminNoEmailSet => 'Nta imeyili yashyizweho';

  @override
  String get adminAddEmail => 'Ongeramo imeyili';

  @override
  String get adminSmsPhoneNumber => 'Nimero ya telefoni yakira SMS';

  @override
  String get adminSmsPhoneHint =>
      'Nimero ya telefoni irimo kode y\'igihugu (urugero: +250783054874)';

  @override
  String get adminDefaultWhatsappChannel => 'Umuyoboro wa WhatsApp w\'ibanze';

  @override
  String get adminGroupSalesPricing => 'Igurisha n\'ibiciro';

  @override
  String get adminGroupWorkflow => 'Imigendekere y\'akazi';

  @override
  String get adminTicketReviewSubtitle =>
      'Saba ko umugenzuzi yemeza kandi ushinzwe ububiko agatanga mbere y\'uko itike yishyuwe irangira burundu';

  @override
  String get adminGroupTaxCompliance => 'Imisoro n\'iyubahirizwa ry\'amategeko';

  @override
  String get adminGroupDataSync => 'Amakuru n\'ihuzwa';

  @override
  String get adminGroupDiagnostics => 'Isuzuma';

  @override
  String get adminCrossDeviceFeatures => 'Ibikorwa bihuza ibikoresho';

  @override
  String get adminReceiptBranding => 'Imiterere y\'inyemezabwishyu';

  @override
  String get adminReceiptLogo => 'Ikirango cy\'inyemezabwishyu';

  @override
  String get adminReceiptLogoHint =>
      'Ohereza PNG itagira ibara ry\'inyuma cyangwa JPG iri munsi ya 200KB. Ikirango kigaragara hagati ku nyemezabwishyu zicapwe; niba nta cyo washyizeho hakoreshwa igisanzwe.';

  @override
  String get adminUploading => 'Biri koherezwa...';

  @override
  String get adminUploadLogo => 'Ohereza ikirango';

  @override
  String get adminRemoveLogo => 'Kuraho ikirango';

  @override
  String get adminPinSubtitle =>
      'Rinda ibikorwa byoroshye kwangiza nko gusiba cyangwa guhindura ibicuruzwa';

  @override
  String adminSearchSettings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Shakisha mu igenamiterere $count',
      one: 'Shakisha mu igenamiterere 1',
    );
    return '$_temp0';
  }

  @override
  String adminNoSettingMatches(String query) {
    return 'Nta genamiterere rihuye na \"$query\"';
  }

  @override
  String get adminPhoneExampleHint => 'urugero: +250783054874';

  @override
  String get perfUncategorised => 'Bitari mu cyiciro';

  @override
  String get perfUnits => 'ibice';

  @override
  String get perfUnnamedItem => 'Igicuruzwa kitagira izina';

  @override
  String get perfNoItemsTitle => 'Nta bicuruzwa biri muri iri shami';

  @override
  String get perfNoItemsMessage =>
      'Ongeramo ibicuruzwa cyangwa wandike ibyaguzwe, ububiko buzagaragara hano.';

  @override
  String get perfHeaderSubtitle => 'Ububiko buriho n\'umuvuduko w\'igurisha';

  @override
  String perfItemsTracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibicuruzwa $count bikurikiranwa',
      one: 'Igicuruzwa 1 gikurikiranwa',
    );
    return '$_temp0';
  }

  @override
  String get perfTitle => 'Imbonerahamwe y\'ububiko';

  @override
  String get perfRefreshTooltip => 'Vugurura imibare y\'ububiko n\'igurisha';

  @override
  String get perfCoverUnderADay => 'munsi y\'umunsi';

  @override
  String perfCoverDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'iminsi $count',
      one: 'umunsi 1',
    );
    return '$_temp0';
  }

  @override
  String perfCoverMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'amezi $count',
      one: 'ukwezi 1',
    );
    return '$_temp0';
  }

  @override
  String get perfCoverOverAYear => 'birenze umwaka';

  @override
  String get perfWindowToday => 'Uyu munsi';

  @override
  String get perfWindowTodayLower => 'uyu munsi';

  @override
  String perfWindowDays(int count) {
    return 'Iminsi $count';
  }

  @override
  String perfWindowLastDays(int count) {
    return 'iminsi $count ishize';
  }

  @override
  String get perfNoMatchesTitle => 'Nta kintu gihuye n\'iyungurura';

  @override
  String get perfNoMatchesMessage =>
      'Siba ibyo washakishije cyangwa uhitemo iyindi yungurura.';

  @override
  String get perfReadingSales => 'Turi gusoma ibyagurishijwe…';

  @override
  String get perfMovementUnavailable =>
      'Imigendekere y\'igurisha ntiboneka — imibare y\'ububiko gusa';

  @override
  String perfCompletedSalesIn(int count, String period) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Igurisha $count ryarangiye mu $period',
      one: 'Igurisha 1 ryarangiye mu $period',
    );
    return '$_temp0';
  }

  @override
  String perfUnitsAndItems(String units, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ibicuruzwa $count',
      one: 'igicuruzwa 1',
    );
    return 'Ibice $units · $_temp0';
  }

  @override
  String perfSoldInWindow(String period) {
    return 'Byagurishijwe · $period';
  }

  @override
  String perfRevenueAndProfit(String revenue, String profit) {
    return '$revenue byinjiye · inyungu $profit';
  }

  @override
  String get perfWaitingForSalesData => 'Dutegereje amakuru y\'igurisha';

  @override
  String get perfNothingToRestock => 'nta cyo kongera kuzana';

  @override
  String get perfTapToSeeThem => 'kanda ubirebe';

  @override
  String get perfReorderNow => 'Ongera utumize ubu';

  @override
  String get perfWaitingForSellingPace => 'dutegereje umuvuduko w\'igurisha';

  @override
  String get perfEveryItemHasRunway => 'buri gicuruzwa gifite ububiko buhagije';

  @override
  String perfUnderDaysLeft(int days) {
    return 'ububiko busigaje munsi y\'iminsi $days';
  }

  @override
  String get perfNoSalesInPeriod => 'Nta byagurishijwe muri iki gihe';

  @override
  String perfBestSellerInWindow(String period) {
    return 'Igicuruzwa cyagurishijwe cyane · $period';
  }

  @override
  String get perfMeasuredFromSales =>
      'Bibarwa hashingiwe ku byagurishijwe byarangiye';

  @override
  String perfSoldAndRevenue(String qty, String revenue) {
    return '$qty byagurishijwe · $revenue byinjiye';
  }

  @override
  String get perfPickLongerPeriod =>
      'Hitamo igihe kirekire cyangwa urebe kuri kasi';

  @override
  String get perfEverythingMoving => 'Byose biragurishwa';

  @override
  String perfTiedUp(String amount) {
    return '$amount bihagaze';
  }

  @override
  String get perfNotSelling => 'Ibitagurishwa';

  @override
  String perfEveryItemSold(String period) {
    return 'Buri gicuruzwa cyagurishijwe nibura rimwe mu $period';
  }

  @override
  String perfDeadItems(int count, String period) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibicuruzwa $count bifite ububiko bitagurishijwe mu $period',
      one: 'Igicuruzwa 1 gifite ububiko kitagurishijwe mu $period',
    );
    return '$_temp0';
  }

  @override
  String get perfCountsMatch => 'Imibare irahura';

  @override
  String perfLost(String amount) {
    return '$amount byatakaye';
  }

  @override
  String get perfStockLoss => 'Igihombo cy\'ububiko';

  @override
  String get perfFromRecounts => 'Bivuye ku ibarura ry\'ububiko muri iki gihe';

  @override
  String get perfNoShortfall => 'Nta kubura kwabonetse mu ibarura';

  @override
  String perfUnitsMissing(String units, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'bicuruzwa $count',
      one: 'gicuruzwa 1',
    );
    return 'Ibice $units bibura ku $_temp0';
  }

  @override
  String get perfNoExpiryRisk => 'Nta byago byo kurangira';

  @override
  String perfItemsAtRisk(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibicuruzwa $count biri mu byago',
      one: 'Igicuruzwa 1 kiri mu byago',
    );
    return '$_temp0';
  }

  @override
  String get perfExpiryWatch => 'Ikurikirana ry\'irangira';

  @override
  String perfNothingExpiring(int days) {
    return 'Nta kirarangira mu minsi $days iri imbere';
  }

  @override
  String perfExpiringWithin(int days) {
    return 'Byarangiye cyangwa bizarangira mu minsi $days';
  }

  @override
  String get perfChartStockOnHand => 'Ububiko buhari';

  @override
  String perfChartUnitsSold(String period) {
    return 'Ibice byagurishijwe · $period';
  }

  @override
  String perfChartRevenue(String period) {
    return 'Amafaranga yinjiye · $period';
  }

  @override
  String get perfChartDaysLeft => 'Iminsi ububiko busigaje';

  @override
  String get perfChartStockHint => 'Kanda ku murongo uhitemo igicuruzwa.';

  @override
  String get perfChartSoldHint =>
      'Bibarwa hashingiwe ku byagurishijwe byarangiye. Kanda ku murongo uhitemo.';

  @override
  String get perfChartRevenueHint => 'Agaciro k\'ibyavuye ku gipangu koko.';

  @override
  String get perfChartCoverHint =>
      'Ku muvuduko w\'igurisha uriho — ibirangira vuba mbere.';

  @override
  String perfTopOf(int shown, int total) {
    return '$shown ba mbere muri $total';
  }

  @override
  String perfItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ibicuruzwa $count',
      one: 'igicuruzwa 1',
    );
    return '$_temp0';
  }

  @override
  String get perfSold => 'Byagurishijwe';

  @override
  String get perfRevenue => 'Amafaranga yinjiye';

  @override
  String get perfStock => 'Ububiko';

  @override
  String get perfDaysLeft => 'Iminsi isigaye';

  @override
  String get perfNoSellingPace =>
      'Nta muvuduko w\'igurisha uraboneka — nta cyagurishijwe muri iki gihe';

  @override
  String get perfNothingToChart => 'Nta cyo kwerekana ku gishushanyo';

  @override
  String perfMovementMeasuredOver(String period) {
    return 'Imigendekere yapimwe mu $period';
  }

  @override
  String get perfSellingPace => 'Umuvuduko w\'igurisha';

  @override
  String perfPerDay(String qty) {
    return '$qty/ku munsi';
  }

  @override
  String get perfStockLeft => 'Ububiko busigaye';

  @override
  String get perfNoSales => 'nta byagurishijwe';

  @override
  String get perfSellThrough => 'Igipimo cy\'ibyagurishijwe';

  @override
  String get perfReceivedEst => 'Byakiriwe (ikigereranyo)';

  @override
  String get perfMissingAtCount => 'Byabuze mu ibarura';

  @override
  String get perfFoundAtCount => 'Byabonetse mu ibarura';

  @override
  String get perfAlertLevel => 'Urugero rwo kuburira';

  @override
  String get perfNotSet => 'ntibyashyizweho';

  @override
  String get perfLastSold => 'Byagurishijwe bwa nyuma';

  @override
  String get perfExpiry => 'Irangira';

  @override
  String get perfExpiredLower => 'cyarangiye';

  @override
  String perfInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mu minsi $count',
      one: 'mu munsi 1',
    );
    return '$_temp0';
  }

  @override
  String get perfStockUpdated => 'Ububiko bwavuguruwe';

  @override
  String get perfSortRunsOutSoonest => 'Ibirangira vuba';

  @override
  String get perfSortLowestStock => 'Ububiko buke mbere';

  @override
  String get perfSortBestSelling => 'Ibigurishwa cyane mbere';

  @override
  String get perfSortHighestValue => 'Agaciro kanini mbere';

  @override
  String get perfSortHighestStock => 'Ububiko bwinshi mbere';

  @override
  String get perfSortNameAz => 'Izina A–Z';

  @override
  String get perfSearchHint =>
      'Shakisha igicuruzwa, icyiciro, SKU cyangwa barcode';

  @override
  String get perfRunningLow => 'Ibigiye gushira';

  @override
  String get perfExpiryRisk => 'Ibyago byo kurangira';

  @override
  String perfShowingSummary(int shown, int total, String value) {
    return 'Herekanwa $shown muri $total · $value bigaragara';
  }

  @override
  String perfMissingAtLastCount(String qty) {
    return '$qty byabuze mu ibarura riheruka';
  }

  @override
  String get perfExpired => 'Cyarangiye';

  @override
  String perfExpiresInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kirarangira mu minsi $count',
      one: 'Kirarangira mu munsi 1',
    );
    return '$_temp0';
  }

  @override
  String get perfValue => 'Agaciro';

  @override
  String get perfEmpty => 'byashize';

  @override
  String get perfNeedsSalesForPace =>
      'Hakenewe ibyagurishijwe muri iki gihe kugira ngo umuvuduko ubarwe';

  @override
  String perfSellingPaceTooltip(String pace, String left) {
    return 'Hagurishwa $pace/ku munsi — hasigaye $left';
  }

  @override
  String perfSoldAgainstShelf(String sold, String left) {
    return '$sold byagurishijwe, $left biracyari ku gipangu';
  }

  @override
  String perfSoldOfAvailable(String sold, String available) {
    return '$sold muri $available byari bihari muri iki gihe byagurishijwe';
  }

  @override
  String get perfReorder => 'Ongera utumize';

  @override
  String get perfCouldNotLoadStock => 'Ntibyashobotse kuzana ububiko';

  @override
  String get dpaNoProductName => 'Nta zina ry\'igicuruzwa!';

  @override
  String get dpaNoProductSaved => 'Nta gicuruzwa cyabitswe!';

  @override
  String get dpaProductSaved => 'Igicuruzwa cyabitswe neza!';

  @override
  String get dpaProductNotInitialized =>
      'Igicuruzwa nticyateguwe. Ongera ugerageze.';

  @override
  String get dpaBranchIdNotFound =>
      'ID y\'ishami ntiyabonetse. Reba ko winjiye neza.';

  @override
  String get dpaBusinessIdNotFound =>
      'ID y\'ubucuruzi ntiyabonetse. Reba ko winjiye neza.';

  @override
  String get dpaAddComponent =>
      'Nyamuneka ongeramo nibura igice kimwe ku gicuruzwa gikomatanyije.';

  @override
  String get dpaCompositeSaved => 'Igicuruzwa gikomatanyije cyabitswe neza!';

  @override
  String get dpaInvalidProductRefSelect =>
      'Igicuruzwa ntikiboneka. Banza uhitemo cyangwa ukore igicuruzwa.';

  @override
  String get dpaUnexpectedReopen =>
      'Habaye ikosa ritunguranye, funga iyi dirishya wongere uyifungure';

  @override
  String get dpaInvalidProductRef => 'Igicuruzwa ntikiboneka';

  @override
  String get dpaUnexpectedError => 'Habaye ikosa ritunguranye';

  @override
  String get dpaBasics => 'Iby\'ibanze';

  @override
  String get dpaNameColor => 'Izina n\'ibara';

  @override
  String get dpaProductColor => 'Ibara ry\'igicuruzwa';

  @override
  String get dpaProductNameHint => 'urugero: Fanta Orange 500ml';

  @override
  String get dpaProductNameMinLength =>
      'Izina ry\'igicuruzwa rigomba kugira nibura inyuguti 3';

  @override
  String get dpaPricingCodes => 'Ibiciro n\'amakode';

  @override
  String get dpaPriceSkuBarcode => 'Igiciro, SKU, barcode';

  @override
  String get dpaRetailPrice => 'Igiciro cyo kugurisha';

  @override
  String get dpaRetailPriceHint => 'Ibyo umukiriya yishyura';

  @override
  String get dpaPriceRequired => 'Igiciro kirakenewe';

  @override
  String get dpaSupplyPrice => 'Ikiranguzo';

  @override
  String get dpaSupplyFromComponents => 'Kibarwa hashingiwe ku bice';

  @override
  String get dpaComponents => 'Ibice';

  @override
  String get dpaBillOfMaterials => 'Urutonde rw\'ibikoresho';

  @override
  String get dpaRetailSupply => 'Kugurisha n\'ikiranguzo';

  @override
  String get dpaCostPerUnit => 'Ikiguzi cyawe kuri buri gice';

  @override
  String get dpaInventoryCategorization => 'Ububiko n\'ibyiciro';

  @override
  String get dpaCategoryItemType => 'Icyiciro n\'ubwoko bw\'igicuruzwa';

  @override
  String get dpaVariantsStock => 'Amoko n\'ububiko';

  @override
  String get dpaStockScan => 'Ububiko no gusikana';

  @override
  String get dpaProductDeleted =>
      'Iki gicuruzwa ntikibashije kuzanwa. Gishobora kuba cyarasibwe.';

  @override
  String get dpaProductLoadFailed =>
      'Ntibyashobotse kuzana iki gicuruzwa. Ongera ugerageze.';

  @override
  String get dpaProductSavedTitle => 'Igicuruzwa cyabitswe';

  @override
  String get dpaAddedToInventory =>
      'Igicuruzwa cyawe n\'amoko yacyo byongewe mu bubiko.';

  @override
  String get dpaVariants => 'Amoko';

  @override
  String get dpaAddAnother => 'Ongeramo ikindi gicuruzwa';

  @override
  String get dpaAddVariant => 'Ongeramo ubwoko';

  @override
  String get dpaEditVariant => 'Hindura ubwoko';

  @override
  String get dpaImageUploadFailed =>
      'Ntibyashobotse kohereza ifoto. Ongera ugerageze.';

  @override
  String get dpaImageSelected => 'Ifoto yatoranyijwe';

  @override
  String get dpaAddImage => 'Ongeramo ifoto';

  @override
  String get dpaVariantName => 'Izina ry\'ubwoko';

  @override
  String get dpaVariantNameHint => 'urugero: Sandali, nimero 10';

  @override
  String get dpaNameRequired => 'Izina rirakenewe';

  @override
  String get dpaRetailOverride => 'Igiciro cyihariye cyo kugurisha';

  @override
  String get dpaLeaveBlankBasePrice => 'Siga ubusa ukoreshe igiciro fatizo';

  @override
  String get dpaBarcode => 'Barcode';

  @override
  String get dpaBarcodeHint => 'SKU / barcode (si ngombwa)';

  @override
  String get dpaLeaveBlankVariantName => 'Siga ubusa ukoreshe izina ry\'ubwoko';

  @override
  String get dpaStockQuantity => 'Ingano iri mu bubiko';

  @override
  String get dpaLowStockReorder => 'Ububiko buke / ongera utumize kuri';

  @override
  String get dpaLowStockHelper =>
      'Menyesha iyo ingano ihari igeze cyangwa iri munsi y\'uru rugero';

  @override
  String get dpaTaxStandardB => 'Gisanzwe B';

  @override
  String get dpaTaxStandardA => 'Gisanzwe A';

  @override
  String get dpaTaxNoneD => 'Nta na kimwe (D)';

  @override
  String get dpaSaveVariantFailed =>
      'Ntibyashobotse kubika ubwoko. Ongera ugerageze.';

  @override
  String get dpaSaveVariant => 'Bika ubwoko';

  @override
  String get dpaProductInfo => 'Amakuru y\'igicuruzwa';

  @override
  String get dpaAdvanced => 'Ibindi byimbitse';

  @override
  String get dpaPlusAdd => '+ Ongeramo';

  @override
  String get dpaVariantsHint =>
      'Kanda ku bwoko ubwagure · Hindura cyangwa usibe imbere · kurura usibe';

  @override
  String get dpaSaveProduct => 'Bika igicuruzwa';

  @override
  String get dpaRraTimeout =>
      'Seriveri y\'imisoro ya RRA yatinze gusubiza. Igicuruzwa cyabitswe muri iki gikoresho ariko ntikiramenyeshwa RRA neza. Reba seriveri y\'imisoro, hanyuma wongere ukande Bika.';

  @override
  String dpaRraReportingFailed(String error) {
    return 'Igicuruzwa cyabitswe muri iki gikoresho ariko kumenyesha RRA ntibyakunze: $error. Ongera ukande Bika ugerageze.';
  }

  @override
  String dpaSaveProductFailed(String error) {
    return 'Ntibyashobotse kubika igicuruzwa: $error';
  }

  @override
  String dpaCompositeSaveFailed(String error) {
    return 'Kubika igicuruzwa gikomatanyije ntibyakunze: $error';
  }

  @override
  String dpaNamedProductSaved(String name) {
    return '$name cyabitswe!';
  }

  @override
  String dpaBaseRetailPrice(String price) {
    return 'Igiciro fatizo cyo kugurisha: $price';
  }

  @override
  String get dpaNotVatRegistered =>
      'Iri shami ntiryanditswe muri TVA. Hakoreshwa \"Nta na kimwe\" (D) gusa.';

  @override
  String get cartNotEnoughStock => 'Nta bubiko buhagije ufite';

  @override
  String get cartFailedToAddItem => 'Kongera igicuruzwa mu gatebo ntibyakunze';

  @override
  String get sellNoItemSelected => 'Nta gicuruzwa cyatoranyijwe';

  @override
  String get sellChooseOne => 'HITAMO KIMWE';

  @override
  String get dashYes => 'Yego';

  @override
  String get dashNo => 'Oya';

  @override
  String get dashTryAgain => 'Ongera ugerageze';

  @override
  String get securityEnablePasscode => 'Emeza ijambo ry\'ibanga';

  @override
  String get printingConfiguration => 'Igenamiterere ry\'icapa';

  @override
  String get printingEnableAutoPrint => 'Emeza icapa ryikora';

  @override
  String get inventoryCart => 'Agatebo';

  @override
  String inventoryCartWithCount(String count) {
    return 'Agatebo ($count)';
  }

  @override
  String discountRowAmountOff(String amount, String currency) {
    return 'Igabanywa rya $amount $currency';
  }

  @override
  String get dashPendingTransactionCopied => 'Igurisha ritegereje ryakoporowe';

  @override
  String get dashUserFallback => 'Umukoresha';

  @override
  String get dashPopupDialogOpen => 'Idirishya rifunguye';

  @override
  String get memberFieldAddMember => 'Ongeraho umukozi';

  @override
  String get orderViewTitle => 'Itumizwa';

  @override
  String get switchBranchAble => 'Ushobora guhindura ishami';

  @override
  String noNetErrorCheckingConnection(String error) {
    return 'Ikosa mu kugenzura murandasi: $error';
  }

  @override
  String get noNetTitle => 'Nta murandasi';

  @override
  String get noNetSubtitle =>
      'Ntibishoboka kugera kuri murandasi.\nReba ko murandasi yawe ikora';

  @override
  String get noNetCheckConnection => 'Genzura murandasi';

  @override
  String get noNetGoToLogin => 'Jya ku kwinjira';

  @override
  String get notificationsTitle => 'Ubutumwa';

  @override
  String get notificationsWhatsNew => 'Ibishya';

  @override
  String get notificationsTakeFirstPayment => 'Akira ubwishyu bwawe bwa mbere';

  @override
  String get notificationsLearnFirstPayment =>
      'Iga uko wakira ubwishyu bwawe bwa mbere.';

  @override
  String get ordersDoneShopping => 'Warangije guhaha?';

  @override
  String get ordersOrderFromSupplier => 'Tumiza ku mutanga ibicuruzwa';

  @override
  String get ordersSelectSupplierHint =>
      'Shakisha uhitemo umutanga ibicuruzwa urebe ibicuruzwa bye';

  @override
  String ordersSearchProductsFrom(String supplier) {
    return 'Shakisha ibicuruzwa bya $supplier';
  }

  @override
  String get scannerNoBarcodeValue => 'Nta barcode yabonetse.';

  @override
  String scannerProcessingBarcode(String barcode) {
    return 'Barcode irimo gusuzumwa: $barcode';
  }

  @override
  String scannerProductNotFoundForBarcode(String barcode) {
    return 'Nta gicuruzwa gifite barcode: $barcode';
  }

  @override
  String scannerErrorAddingProduct(String error) {
    return 'Ikosa mu kongeramo igicuruzwa: $error';
  }

  @override
  String get subscriptionEnterCode => 'Andika kode y\'ifatabuguzi';

  @override
  String get subscriptionEnterCodeHint =>
      'Andika kode y\'ifatabuguzi wahawe n\'umukozi wacu';

  @override
  String get subscriptionSubscribe => 'Iyandikishe';

  @override
  String get subscriptionUpdate => 'Vugurura ifatabuguzi';

  @override
  String get subscriptionEnterVoucherError => 'Andika voucher yawe';

  @override
  String get subscriptionEnterVoucher => 'Andika voucher';

  @override
  String get subscriptionActivatePro => 'Fungura Flipper Pro!';

  @override
  String get subscriptionUpgradeToPro => 'Zamura ujye kuri Pro';

  @override
  String get saleIndicatorNoSale => 'Nta gurisha';

  @override
  String get tenantsBindProductHint =>
      'Huza igicuruzwa n\'umukoresha uri hasi kugira ngo ugurishe byoroshye';

  @override
  String tenantsBoundTo(String name) {
    return 'Byahujwe na $name';
  }

  @override
  String get tenantsBind => 'Huza';

  @override
  String get payableSendToTill => 'Ohereza ku kasi →';

  @override
  String get cashbookSuggestSales => 'Ibyagurishijwe';

  @override
  String get cashbookSuggestOwnerDeposit => 'Amafaranga ya nyirubucuruzi';

  @override
  String get cashbookSuggestLoanReceived => 'Inguzanyo yakiriwe';

  @override
  String get cashbookSuggestDebtRepayment => 'Kwishyurwa umwenda';

  @override
  String get cashbookSuggestRefund => 'Gusubizwa amafaranga';

  @override
  String get cashbookSuggestCommission => 'Komisiyo';

  @override
  String get cashbookSuggestTransport => 'Ingendo';

  @override
  String get cashbookSuggestRent => 'Ubukode';

  @override
  String get cashbookSuggestSalaries => 'Imishahara';

  @override
  String get cashbookSuggestUtilities => 'Amazi n\'amashanyarazi';

  @override
  String get cashbookSuggestSupplies => 'Ibikoresho';

  @override
  String get cashbookSuggestAirtime => 'Ama-inite';

  @override
  String get cashbookSuggestFood => 'Ibiryo';

  @override
  String get cashbookSuggestRepairs => 'Gusana';

  @override
  String get shiftStartSubtitle =>
      'Tegura agasanduku k\'amafaranga utangire akazi';

  @override
  String get shiftDetails => 'Ibisobanuro by\'igihe cy\'akazi';

  @override
  String shiftStartTime(String time) {
    return 'Igihe cyo gutangira: $time';
  }

  @override
  String shiftEndTime(String time) {
    return 'Igihe cyo gusoza: $time';
  }

  @override
  String get shiftOpeningCashFloat => 'Amafaranga yo gutangiza';

  @override
  String get shiftOpeningCashFloatHint =>
      'Andika amafaranga ari mu gasanduku utangiye igihe cy\'akazi';

  @override
  String get shiftOpeningBalanceRequired => 'Amafaranga yo gutangiza arakenewe';

  @override
  String get shiftEnterValidPositiveAmount =>
      'Andika umubare wemewe urenze zeru';

  @override
  String get shiftNotesOptional => 'Inyandiko (si ngombwa)';

  @override
  String get shiftNotesHint =>
      'Ongeraho inyandiko ku bijyanye n\'iki gihe cy\'akazi';

  @override
  String get shiftEnterNotesHere => 'Andika inyandiko hano...';

  @override
  String get shiftStarting => 'Biratangira...';

  @override
  String get shiftStartShift => 'Tangira igihe cy\'akazi';

  @override
  String get shiftErrorNetwork =>
      'Ikibazo cya murandasi. Genzura murandasi yawe wongere ugerageze.';

  @override
  String get shiftErrorSessionExpired =>
      'Igihe cyawe cyarangiye. Ongera winjire.';

  @override
  String get shiftErrorValidation => 'Genzura ibyo wanditse wongere ugerageze.';

  @override
  String get shiftErrorUnexpected =>
      'Habaye ikosa ritunguranye. Ongera ugerageze.';

  @override
  String get shiftErrorLoadingData =>
      'Ikosa mu kuzana amakuru y\'igihe cy\'akazi';

  @override
  String get shiftSummary => 'Incamake y\'igihe cy\'akazi';

  @override
  String get shiftOpeningBalance => 'Amafaranga yo gutangiza';

  @override
  String get shiftCashSales => 'Ibyagurishijwe mu mafaranga';

  @override
  String get shiftExpectedCash => 'Amafaranga ateganyijwe';

  @override
  String get shiftCashReconciliation => 'Kugenzura amafaranga';

  @override
  String get shiftCountCashHint =>
      'Bara amafaranga ari mu gasanduku hanyuma wandike\namafaranga yo gusoza hasi.';

  @override
  String get shiftClosingCashBalance => 'Amafaranga yo gusoza';

  @override
  String get shiftClosingCashHint =>
      'Andika amafaranga wabaze ari mu gasanduku';

  @override
  String get shiftRequired => 'Birakenewe';

  @override
  String get shiftInvalidAmount => 'Umubare utemewe';

  @override
  String get shiftPerfectBalance => 'Amafaranga arahura neza';

  @override
  String get shiftOverage => 'Amafaranga arenga';

  @override
  String get shiftShortage => 'Amafaranga abura';

  @override
  String get shiftDifference => 'Itandukaniro';

  @override
  String get shiftMoreCashThanExpected => 'Amafaranga arenze ayateganyijwe';

  @override
  String get shiftLessCashThanExpected =>
      'Amafaranga ari munsi y\'ayateganyijwe';

  @override
  String get shiftNotes => 'Inyandiko';

  @override
  String get shiftExplainShortage => 'Sobanura amafaranga abura';

  @override
  String get shiftAddAnyNotes => 'Ongeraho inyandiko';

  @override
  String get shiftNotesRequiredWhenDifference =>
      'Birakenewe iyo hari itandukaniro';

  @override
  String get shiftExplainDifference => 'Sobanura itandukaniro...';

  @override
  String get shiftEnterNotes => 'Andika inyandiko...';

  @override
  String get shiftConfirmClosure => 'Emeza gusoza igihe cy\'akazi';

  @override
  String get shiftGoBack => 'Subira inyuma';

  @override
  String get shiftConfirmClose => 'Emeza gusoza';

  @override
  String get shiftInvalidClosingBalance => 'Amafaranga yo gusoza atemewe';

  @override
  String shiftFailedToClose(String error) {
    return 'Gusoza igihe cy\'akazi ntibyakunze: $error';
  }

  @override
  String get umusadaBusinessFinancing => 'Inguzanyo z\'ubucuruzi';

  @override
  String get umusadaUnlockLoans => 'Bona inguzanyo z\'ubucuruzi';

  @override
  String get umusadaFinancingHint =>
      'Habwa inguzanyo hashingiwe ku mateka y\'ibyo watumije';

  @override
  String get umusadaHowItWorks => 'Uko bikora';

  @override
  String get umusadaAutoSync => 'Guhuza byikora';

  @override
  String get umusadaAutoSyncDesc =>
      'Amakuru y\'ibyo watumije ahuzwa mu mutekano kugira ngo yubake umwirondoro wawe.';

  @override
  String get umusadaCreditScore => 'Amanota y\'inguzanyo';

  @override
  String get umusadaCreditScoreDesc =>
      'Umusada isuzuma amateka yawe ikagena inguzanyo ntarengwa.';

  @override
  String get umusadaInstantLoans => 'Inguzanyo zihuse';

  @override
  String get umusadaInstantLoansDesc =>
      'Bona amafaranga vuba igihe uyakeneye cyane.';

  @override
  String get umusadaJoin => 'Injira muri Umusada';

  @override
  String get umusadaMaybeLater => 'Ubutaha';

  @override
  String get umusadaConnecting => 'Birahuza…';

  @override
  String get umusadaConnectionFailed => 'Guhuza ntibyakunze';

  @override
  String get umusadaCouldNotConnect =>
      'Ntibyashobotse guhuza na Umusada. Ongera ugerageze nyuma.';

  @override
  String get mfaUserNotLoggedIn => 'Umukoresha ntiyinjiye';

  @override
  String mfaErrorLoadingSecret(String error) {
    return 'Ikosa mu kuzana/gukora ibanga rya MFA: $error';
  }

  @override
  String get mfaSetupAuthenticator => 'Tegura authenticator';

  @override
  String get mfaSettingUp => 'Turimo gutegura authenticator yawe...';

  @override
  String get mfaSetupFailed => 'Gutegura ntibyakunze';

  @override
  String get mfaGoBack => 'Subira inyuma';

  @override
  String get mfaSetUpTwoFactor => 'Tegura kwemeza\nmu ntambwe ebyiri';

  @override
  String get mfaScanQrHint =>
      'Sikana QR code iri hasi ukoresheje porogaramu ya authenticator\nkugira ngo urinde konti yawe ya Flipper.';

  @override
  String get mfaStepVerify => 'Emeza';

  @override
  String get mfaIveSetUp => 'Narangije gutegura authenticator';

  @override
  String get mfaNeedHelp => 'Ukeneye ubufasha?';

  @override
  String get mfaHelpText =>
      'Koresha porogaramu nka Microsoft Authenticator, Google Authenticator cyangwa Authy usikane QR code kandi ubone kode zo kwemeza.';

  @override
  String get mfaSetupKey => 'URUFUNGUZO RWO GUTEGURA';

  @override
  String get mfaCopied => 'Byakoporowe';

  @override
  String get mfaCopy => 'Koporora';

  @override
  String get noticesTitle => 'Amatangazo';

  @override
  String get noticesSubtitle => 'Menya amatangazo mashya';

  @override
  String get noticesLoading => 'Amatangazo arimo kuza...';

  @override
  String get noticesUnableToLoad => 'Ntibyashobotse kuzana amatangazo';

  @override
  String get noticesCheckConnection =>
      'Genzura murandasi yawe wongere ugerageze';

  @override
  String get noticesEmpty => 'Nta matangazo arahari';

  @override
  String get noticesEmptyHint => 'Amatangazo mashya azagaragara hano';

  @override
  String get noticesNoTitle => 'Nta mutwe';

  @override
  String get noticesNoContent => 'Nta bikubiyemo bihari';

  @override
  String get noticesNoDate => 'Nta tariki';

  @override
  String get noticesReadMore => 'Soma byinshi';

  @override
  String get ribbonOrdering => 'Gutumiza';

  @override
  String get ribbonImportPurchase => 'Ibyinjijwe n\'ibyaguzwe';

  @override
  String get ribbonLocations => 'Amashami';

  @override
  String get ribbonLocationsCaption => 'Ububiko kuri buri shami';

  @override
  String get ribbonItemsCaption => 'Reba kandi ucunge ibicuruzwa';

  @override
  String get ribbonTaxSettingsCaption => 'Seriveri ya EBM / RRA na TVA';

  @override
  String importPurchasePageSyncFailed(String error) {
    return 'Guhuza ntibyakunze: $error';
  }

  @override
  String get importPurchasePageManagement => 'Gucunga ibyinjijwe n\'ibyaguzwe';

  @override
  String get importPurchasePageSyncing => 'Birahuzwa…';

  @override
  String importPurchasePageSyncedAgo(String time) {
    return 'Byahujwe $time';
  }

  @override
  String get importPurchasePageNotSynced => 'Ntibirahuzwa';

  @override
  String get importPurchasePageExport => 'Ohereza hanze';

  @override
  String get importPurchasePageRecordPurchase => 'Andika ibyaguzwe';

  @override
  String get importPurchasePageSyncFromRra => 'Huza na RRA';

  @override
  String get importPurchasePageImportFrom => 'Ibyinjijwe guhera';

  @override
  String get importPurchasePagePurchaseFrom => 'Ibyaguzwe guhera';

  @override
  String get infoDialogUnexpectedError => 'Habaye ikosa ritunguranye.';

  @override
  String get infoDialogWarning => 'Iburira';

  @override
  String get infoDialogSuccess => 'Byagenze neza';

  @override
  String get infoDialogInformation => 'Amakuru';

  @override
  String get infoDialogGotIt => 'Numvise';

  @override
  String get infoDialogDismiss => 'Funga';

  @override
  String get keypadCashInFor => 'Amafaranga yinjiye ya';

  @override
  String get keypadCashOutFor => 'Amafaranga yasohotse ya';

  @override
  String get dataMixerCannotDelete =>
      'Ntigishobora gusibwa cyangwa cyamaze gusibwa.';

  @override
  String get dataMixerCouldNotDelete =>
      'Ntibyashobotse gusiba iki gicuruzwa. Ongera ugerageze.';

  @override
  String get dataMixerUnknownProduct => 'Igicuruzwa kitazwi';

  @override
  String get searchToggleScanMode => 'Fungura/funga uburyo bwo gusikana';

  @override
  String get customAlertTitle => 'Iburira';

  @override
  String get imagePickerTitle => 'Hitamo ifoto';

  @override
  String get imagePickerUseCamera => 'Koresha kamera';

  @override
  String get imagePickerUseGallery => 'Koresha ububiko bw\'amafoto';

  @override
  String get favoritesArrange => 'Tunganya ibyo ukunda';

  @override
  String get favoritesPressDone => 'Kanda \"Byarangiye\" niba urangije';

  @override
  String get favoritesPressAndHold =>
      'Kanda kandi ufate ahantu hose mu mbonerahamwe kugira ngo utangire gushyiraho ibicuruzwa';

  @override
  String get drawerCloseBusiness => 'Funga ubucuruzi';

  @override
  String get drawerOpenBusiness => 'Fungura ubucuruzi';

  @override
  String get drawerEnterAmount => 'Ugomba kwandika amafaranga';

  @override
  String get drawerNumericOnly => 'Imibare gusa ni yo yemewe';

  @override
  String get drawerClosingBalance => 'Amafaranga yo gusoza';

  @override
  String get drawerOpenDrawer => 'Fungura agasanduku';

  @override
  String get drawerCloseDrawer => 'Funga agasanduku';

  @override
  String get drawerLogoutWithoutClosing => 'Sohoka udafunze agasanduku';

  @override
  String get cashierStaffFallback => 'Umukozi';

  @override
  String get paymentsSplitPayment => 'Gabanya ubwishyu';

  @override
  String get paymentsConfirmPayment => 'Emeza ubwishyu';

  @override
  String get paymentsHideDiscount => 'Hisha igabanywa';

  @override
  String get paymentsAddDiscount => 'Ongeraho igabanywa';

  @override
  String get paymentsSendInvoice => 'Ohereza fagitire';

  @override
  String get paymentsEnterDiscountAmount => 'Andika amafaranga y\'igabanywa';

  @override
  String get paymentsDiscountExceedsTotal =>
      'Igabanywa ntirishobora kurenza igiteranyo';

  @override
  String get paymentsPhoneWithoutZero =>
      'Andika nimero ya telefoni nta 0 imbere, urugero 783054874';

  @override
  String get paymentsEnterCashReceived => 'Andika amafaranga wakiriye';

  @override
  String get paymentsAmountLessThanPayable =>
      'Amafaranga ari munsi y\'ayo kwishyura';

  @override
  String get paymentsChooseMethod => 'Ugomba guhitamo uburyo bwo kwishyura';

  @override
  String get paymentsTypeCard => 'Ikarita';

  @override
  String get paymentsTypeMobile => 'Telefoni';

  @override
  String get paymentsTypeBank => 'Banki';

  @override
  String get paymentsTypeCheque => 'Sheki';

  @override
  String get dashNotAvailable => 'Ntibihari';

  @override
  String get itemsExportNone => 'Nta bicuruzwa byo kohereza hanze';

  @override
  String get itemsExportSaveDialogTitle => 'Bika dosiye ya Excel';

  @override
  String get itemsExportProductName => 'Izina ry\'igicuruzwa';

  @override
  String get itemsExportVariantName => 'Izina ry\'ubwoko';

  @override
  String get itemsExportItemCode => 'Kode y\'igicuruzwa';

  @override
  String get itemsExportRetailPrice => 'Igiciro cyo kugurisha';

  @override
  String get itemsExportUnit => 'Igipimo';

  @override
  String itemsExportSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibicuruzwa $count byoherejwe neza',
      one: 'Igicuruzwa 1 cyoherejwe neza',
    );
    return '$_temp0';
  }

  @override
  String get itemsExportIncompleteSync =>
      'Imwe mu mibare ishobora kuba ikirimo guhuzwa; ongera wohereze nyuma niba ibiteranyo bisa nabi.';

  @override
  String itemsExportFailed(String error) {
    return 'Kohereza ibicuruzwa hanze ntibyakunze: $error';
  }

  @override
  String get itemsTypeRawMaterial => 'Ibikoresho fatizo';

  @override
  String get itemsTypeFinishedProduct => 'Igicuruzwa cyarangiye';

  @override
  String get itemsTypeService => 'Serivisi';

  @override
  String get itemsTypeUnknown => 'Ntibizwi';

  @override
  String get itemsExportToExcel => 'Ohereza muri Excel';

  @override
  String get itemsSearchByName => 'Shakisha ukoresheje izina...';

  @override
  String itemsTransactionsSyncedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Habonetse amagurisha $count yahujwe',
      one: 'Habonetse igurisha 1 ryahujwe',
    );
    return '$_temp0';
  }

  @override
  String get itemsTransactionsSynced => 'Amagurisha yahujwe neza';

  @override
  String get itemsNoneFound => 'Nta bicuruzwa byabonetse.';

  @override
  String itemsStockValue(String quantity) {
    return 'Ububiko: $quantity';
  }

  @override
  String get itemsStockLoading => 'Ububiko: biraza...';

  @override
  String get itemsStockError => 'Ububiko: ikosa';

  @override
  String itemsErrorLoading(String error) {
    return 'Ikosa mu kuzana ibicuruzwa: $error';
  }

  @override
  String importPurchasePageFetchedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibicuruzwa bishya $count byavanywe kuri RRA',
      one: 'Igicuruzwa gishya 1 cyavanywe kuri RRA',
    );
    return '$_temp0';
  }

  @override
  String importPurchasePageFetchedInvoices(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fagitire nshya $count zavanywe kuri RRA',
      one: 'Fagitire nshya 1 yavanywe kuri RRA',
    );
    return '$_temp0';
  }

  @override
  String get importPurchasePageNoNewItems =>
      'Guhuza byarangiye — nta bicuruzwa bishya';

  @override
  String get importPurchasePageNoNewInvoices =>
      'Guhuza byarangiye — nta fagitire nshya';

  @override
  String get itemsViewFromLastWeek => 'ugereranyije n\'icyumweru gishize';

  @override
  String itemsViewExpiredOn(String date) {
    return 'Byarangiye ku itariki: $date';
  }

  @override
  String itemsViewIdValue(String id) {
    return 'ID: $id';
  }

  @override
  String itemsViewCategoryValue(String category) {
    return 'Icyiciro: $category';
  }

  @override
  String itemsViewQuantityValue(String quantity) {
    return 'Ingano: $quantity';
  }

  @override
  String itemsViewLocationValue(String location) {
    return 'Aho biherereye: $location';
  }

  @override
  String itemsViewExpiryDateValue(String date) {
    return 'Itariki yo kurangira: $date';
  }

  @override
  String get itemsViewInventoryByCategory => 'Ububiko ku byiciro';

  @override
  String get itemsViewStockLevelsTrend => 'Uko ububiko buhinduka';

  @override
  String get itemsViewRecentOrders => 'Ibyatumijwe vuba';

  @override
  String itemsViewOrderLine(String id, String date) {
    return 'Itumizwa #$id - $date';
  }

  @override
  String get itemsViewNearExpiryItems => 'Ibicuruzwa biri hafi kurangira';

  @override
  String itemsViewUnitsAtLocation(int count, String location) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibice $count',
      one: 'Igice 1',
    );
    return '$_temp0 - $location';
  }

  @override
  String itemsViewDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hasigaye iminsi $count',
      one: 'Hasigaye umunsi 1',
    );
    return '$_temp0';
  }

  @override
  String get itemsViewStatusDelivered => 'Byagejejwe';

  @override
  String get itemsViewStatusInTransit => 'Biri mu nzira';

  @override
  String get itemsViewStatusProcessing => 'Birimo gutunganywa';

  @override
  String get itemsViewStatusCancelled => 'Byahagaritswe';

  @override
  String get stockApprovalNoItems => 'Nta bicuruzwa biri mu busabe';

  @override
  String get stockApprovalAtLeastOne =>
      'Nibura igicuruzwa kimwe kigomba kwemezwa';

  @override
  String get stockApprovalProcessError => 'Habaye ikosa mu gutunganya ubusabe';

  @override
  String get stockApprovalQuantityUpdated => 'Ingano yavuguruwe neza';

  @override
  String get stockApprovalQuantityUpdateFailed =>
      'Kuvugurura ingano ntibyakunze';

  @override
  String stockApprovalInsufficientFor(String item) {
    return 'Ububiko budahagije bwa $item';
  }

  @override
  String stockApprovalVariantNotFoundFor(String item) {
    return 'Ubwoko bwa $item ntibwabonetse';
  }

  @override
  String stockApprovalAdjustedToAvailable(String quantity) {
    return 'Ingano yahujwe n\'ububiko buhari: $quantity';
  }

  @override
  String stockApprovalItemApproved(String item) {
    return '$item cyemejwe';
  }

  @override
  String get stockApprovalItemError => 'Habaye ikosa mu kwemeza igicuruzwa';

  @override
  String get stockApprovalCancelled => 'Kwemeza byahagaritswe';

  @override
  String stockApprovalSmsApproved(String reference) {
    return 'Ubusabe bwawe bw\'ububiko #$reference bwemejwe.';
  }

  @override
  String stockApprovalSmsPartiallyApproved(String reference) {
    return 'Ubusabe bwawe bw\'ububiko #$reference bwemejwe igice.';
  }

  @override
  String get stockApprovalRequestApproved => 'Ubusabe bwemejwe neza';

  @override
  String get stockApprovalRequestPartiallyApproved =>
      'Ubusabe bwemejwe igice neza';

  @override
  String get stockApprovalFinalizeFailed => 'Gusoza kwemeza ntibyakunze';

  @override
  String get stockApprovalProcessing => 'Ubusabe burimo gutunganywa...';

  @override
  String get stockApprovalPartialTitle => 'Kwemeza igice';

  @override
  String get stockApprovalApprove => 'Emeza';

  @override
  String get stockApprovalInsufficientHint =>
      'Ibicuruzwa bimwe ntibifite ububiko buhagije. Hindura ingano zemejwe:';

  @override
  String get stockApprovalVariantNotFound => 'Ubwoko ntibwabonetse';

  @override
  String get stockApprovalApproveQuantity => 'Ingano yo kwemeza';

  @override
  String get stockApprovalRequested => 'Byasabwe';

  @override
  String get stockApprovalAvailable => 'Bihari';

  @override
  String stockApprovalChipValue(String label, String value) {
    return '$label: $value';
  }

  @override
  String get stockApprovalPleaseApproveOne => 'Emeza nibura igicuruzwa kimwe';

  @override
  String get stockApprovalProcessFailed => 'Gutunganya kwemeza ntibyakunze';

  @override
  String get exportDataTotalLabel => 'Igiteranyo:';

  @override
  String get exportDataTotal => 'Igiteranyo';

  @override
  String get exportDataSheetStockRecount => 'Kongera kubara ububiko';

  @override
  String get exportDataSheetReport => 'Raporo';

  @override
  String get exportDataSheetExpenses => 'Ibyakoreshejwe';

  @override
  String get exportDataSheetPaymentMethods => 'Uburyo bwo kwishyura';

  @override
  String get exportDataTotalSalesLines =>
      'Igiteranyo cy\'ibyagurishijwe (imirongo):';

  @override
  String get exportDataNetProfitBeforeExpenses =>
      'Inyungu nyayo yose (mbere y\'ibyakoreshejwe):';

  @override
  String get exportDataNetProfitAfterExpenses =>
      'Inyungu nyayo ya nyuma (nyuma y\'ibyakoreshejwe):';

  @override
  String get exportDataPaymentType => 'Uburyo bwo kwishyura';

  @override
  String get exportDataSaleAmount => 'Amafaranga y\'ibyagurishijwe';

  @override
  String get exportDataTransactionCount => 'Umubare w\'amagurisha';

  @override
  String get exportDataPercentOfTotal => '% by\'igiteranyo';

  @override
  String get exportDataExpense => 'Icyakoreshejwe';

  @override
  String get exportDataTotalExpenses => 'Igiteranyo cy\'ibyakoreshejwe';

  @override
  String exportDataShareSubject(String date) {
    return 'Raporo yamanuwe - $date';
  }

  @override
  String get mposSaveCustomerBeforeTill =>
      'Bika izina cyangwa nimero ya telefoni y\'umukiriya kuri iyi tike mbere yo kuyohereza ku kasi.';

  @override
  String get mposCouldNotReturnTicket =>
      'Ntibyashobotse gusubiza iyi tike ku kasi. Ongera ugerageze.';

  @override
  String get mposCouldNotRemoveCustomer => 'Ntibyashobotse gukuraho umukiriya';

  @override
  String get mposPaymentsAtTillSendToManager =>
      'Ubwishyu bwakirirwa ku kasi. Ohereza iri tumizwa ku muyobozi.';

  @override
  String get mposAddCustomerBeforeCompleting =>
      'Ongeraho umukiriya ku igurisha mbere yo kurangiza';

  @override
  String get mposEnterValidMomoPhone =>
      'Andika nimero ya MoMo yemewe kugira ngo usabe ubwishyu';

  @override
  String get mposCustomerRequiredForCredit =>
      'Izina cyangwa telefoni y\'umukiriya birakenewe ku kwishyura ku ideni.';

  @override
  String get mposErrorOccurred => 'Habaye ikosa';

  @override
  String mposErrorUpdatingQuantity(String error) {
    return 'Ikosa mu kuvugurura ingano: $error';
  }

  @override
  String mposErrorRemovingProduct(String error) {
    return 'Ikosa mu gukuramo igicuruzwa: $error';
  }

  @override
  String mposErrorUpdatingPrice(String error) {
    return 'Ikosa mu kuvugurura igiciro: $error';
  }

  @override
  String get mposAddItemsToCharge => 'Ongeramo ibicuruzwa byo kwishyuza';

  @override
  String get mposRecordPayment => 'Andika ubwishyu';

  @override
  String get mposComplete => 'Soza';

  @override
  String get mposCompleteNow => 'Soza nonaha';

  @override
  String get mposWaitingForPayment => 'Dutegereje ubwishyu...';

  @override
  String get mposPrintingReceipt => 'Inyemezabuguzi irimo gucapwa...';

  @override
  String get mposPaymentFailedRetry =>
      'Kwishyura ntibyakunze. Ongera ugerageze?';

  @override
  String mposEnterAmountReceived(String amount) {
    return 'Andika $amount wakiriye';
  }

  @override
  String get mposMobileCheckout => 'Kwishyuza kuri telefoni';

  @override
  String mposCheckoutSemanticValue(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibicuruzwa $count',
      one: 'Igicuruzwa 1',
    );
    return '$_temp0, RWF $total';
  }

  @override
  String get mposNoItemsInCart => 'Nta gicuruzwa kiri mu gatebo';

  @override
  String get mposAddMoreItems => 'Ongeramo ibindi bicuruzwa';

  @override
  String get mposPaymentMethod => 'Uburyo bwo kwishyura';

  @override
  String get mposTotals => 'Ibiteranyo';

  @override
  String get loginChoicesMember => 'Umunyamuryango';

  @override
  String get loginChoicesOwner => 'Nyirubucuruzi';

  @override
  String loginChoicesBusinessSubtitle(String role, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Amashami $count',
      one: 'Ishami 1',
    );
    return '$role · $_temp0';
  }

  @override
  String get loginChoicesValidatingSession => 'Turimo kugenzura konti...';

  @override
  String get loginChoicesLoadingBusinesses => 'Ubucuruzi bwawe burimo kuza...';

  @override
  String get loginChoicesNoBusinessesSigningOut =>
      'Nta bucuruzi bwabonetse. Turimo gusohoka...';

  @override
  String get loginChoicesChooseBusiness => 'Hitamo ubucuruzi';

  @override
  String get loginChoicesSelectBusinessHint =>
      'Hitamo ubucuruzi ushaka gucunga.';

  @override
  String get loginChoicesChooseBranch => 'Hitamo ishami';

  @override
  String get loginChoicesSelectBranchHint => 'Hitamo ishami ushaka kwinjiramo';

  @override
  String get loginChoicesBranchFallback => 'Ishami';

  @override
  String get loginChoicesSigningOut => 'Turimo gusohoka…';

  @override
  String get loginChoicesPleaseWait => 'Tegereza gato';

  @override
  String get loginChoicesSignOut => 'Sohoka';

  @override
  String get loginChoicesAddBusiness => 'Ongeraho ubucuruzi';

  @override
  String get loginChoicesNotSeeingBusiness =>
      'Ntubona ubucuruzi bwawe? Saba nyirabwo akugire umunyamuryango, cyangwa ';

  @override
  String get loginChoicesAddBusinessLink => 'ongeraho ubucuruzi.';

  @override
  String get loginChoicesNoBranches => 'Nta mashami araza';

  @override
  String get loginChoicesNoBranchesHint =>
      'Ibi bishobora kubaho niba guhuza bikirimo gukorwa.\nOngera ugerageze mu kanya.';

  @override
  String get loginChoicesDefaultBadge => 'IBANZE';

  @override
  String get drawerMenuAdminFallback => 'Umuyobozi';

  @override
  String get drawerMenuMyBusiness => 'Ubucuruzi bwanjye';

  @override
  String get drawerMenuQuickActions => 'IBIKORWA BYIHUSE';

  @override
  String get drawerMenuYourBusinesses => 'UBUCURUZI BWAWE';

  @override
  String get drawerMenuManagement => 'UBUYOBOZI';

  @override
  String get drawerMenuPrintDelegation => 'Kohereza icapa ahandi';

  @override
  String get drawerMenuSaleMode => 'Uburyo bwo kugurisha';

  @override
  String get drawerMenuBackgroundSyncEnabled =>
      'Guhuza mu ibanga byafunguwe. Kugira ngo ubifunge, jya mu igenamiterere.';

  @override
  String get drawerMenuBackgroundSyncDisabled => 'Guhuza mu ibanga byafunzwe';

  @override
  String get drawerMenuEbmOn => 'EBM irakora';

  @override
  String get drawerMenuEbmOff => 'EBM ntikora';

  @override
  String get drawerMenuCheckingEbm => 'Turimo kugenzura EBM...';

  @override
  String get drawerMenuEbmStatusError => 'Ikosa ku miterere ya EBM';

  @override
  String get drawerMenuCheckingShift => 'Turimo kugenzura igihe cy\'akazi...';

  @override
  String get drawerMenuEndShift => 'Soza igihe cy\'akazi kiriho';

  @override
  String get drawerMenuStartShift => 'Tangira igihe gishya cy\'akazi';

  @override
  String get drawerMenuUnnamedBusiness => 'Ubucuruzi butagira izina';

  @override
  String get drawerMenuUnnamedBranch => 'Ishami ritagira izina';

  @override
  String drawerMenuBranchCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Amashami $count',
      one: 'Ishami 1',
    );
    return '$_temp0';
  }

  @override
  String get drawerMenuDelegationEnabled => 'Kohereza icapa ahandi byafunguwe';

  @override
  String get drawerMenuDelegationDisabled => 'Kohereza icapa ahandi byafunzwe';

  @override
  String get drawerMenuDelegationDeviceSelected =>
      'Igikoresho cyo kohererezaho cyatoranyijwe';

  @override
  String drawerMenuErrorSelectingDevice(String error) {
    return 'Ikosa mu guhitamo igikoresho: $error';
  }

  @override
  String get drawerMenuSelectDevice => 'Hitamo igikoresho';

  @override
  String get drawerMenuNoDevices => 'Nta bikoresho biri muri iri shami';

  @override
  String drawerMenuPlatform(String platform) {
    return 'Urubuga: $platform';
  }

  @override
  String drawerMenuPhone(String phone) {
    return 'Telefoni: $phone';
  }

  @override
  String drawerMenuErrorLoadingDevices(String error) {
    return 'Ikosa mu kuzana ibikoresho: $error';
  }

  @override
  String get drawerMenuDelegate => 'Ohereza ahandi';

  @override
  String get drawerMenuDelegateHint =>
      'Gucapira inyemezabuguzi kuri mudasobwa igihe seriveri ya EBM idakora';

  @override
  String get drawerMenuEnabled => 'Birakora';

  @override
  String get drawerMenuDisabled => 'Ntibikora';

  @override
  String get drawerMenuDelegationStep1 =>
      'Telefoni irangiza igurisha ariko\nikohereza ikorwa ry\'inyemezabuguzi';

  @override
  String get drawerMenuDelegationStep2 =>
      'Mudasobwa ibona igurisha binyuze mu guhuza';

  @override
  String get drawerMenuDelegationStep3 =>
      'Mudasobwa ikora inyemezabuguzi kandi\nivugana na seriveri ya EBM';

  @override
  String get drawerMenuDelegationStep4 => 'Telefoni imenyeshwa iyo\nbirangiye';

  @override
  String get drawerMenuRequirements => 'Ibisabwa';

  @override
  String get drawerMenuRequirement1 =>
      'Porogaramu ya mudasobwa igomba kuba ikora kandi yemeye kwakira';

  @override
  String get drawerMenuRequirement2 =>
      'Ibikoresho byombi bigomba kuba bihuza binyuze kuri Flipper';

  @override
  String get drawerMenuRequirement3 =>
      'Mudasobwa itunganya amagurisha yoherejwe buri masegonda 10';

  @override
  String get customersHelpSearch =>
      'Shakisha abakiriya ukoresheje izina cyangwa nimero ya telefoni';

  @override
  String get customersHelpEdit =>
      'Koresha Hindura ku murongo w\'umukiriya kugira ngo uvugurure amakuru ye';

  @override
  String get customersHelpTap =>
      'Kanda ku mukiriya kugira ngo umushyire ku igurisha riri gukorwa';

  @override
  String get customersHelpSwipe =>
      'Kuri telefoni, kurura umurongo kugira ngo usibe, uhindure, wongere cyangwa ukureho vuba';

  @override
  String get customersHelpAdd =>
      'Ongeraho umukiriya mushya ukoresheje buto iri munsi y\'ahashakirwa';

  @override
  String get customersNoneFound => 'Nta bakiriya babonetse';

  @override
  String customersFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Habonetse abakiriya $count',
      one: 'Habonetse umukiriya 1',
    );
    return '$_temp0';
  }

  @override
  String get customersTryDifferentSearch =>
      'Gerageza andi magambo cyangwa wongereho umukiriya mushya';

  @override
  String get customersAddToGetStarted =>
      'Ongeraho umukiriya kugira ngo utangire';

  @override
  String customersAddAsNew(String name) {
    return 'Ongeraho \"$name\" nk\'umukiriya mushya';
  }

  @override
  String get customersAddNew => 'Ongeraho umukiriya mushya';

  @override
  String get customersNoName => 'Nta zina';

  @override
  String customersTinValue(String tin) {
    return 'TIN: $tin';
  }

  @override
  String get customersRemoveFromSale => 'Kura ku igurisha';

  @override
  String get customersAddToSale => 'Shyira ku igurisha';

  @override
  String customersAddedToSale(String name) {
    return 'Umukiriya $name yashyizwe ku igurisha';
  }

  @override
  String get customersFailedToAdd =>
      'Gushyira umukiriya ku igurisha ntibyakunze';

  @override
  String get customersRemovedFromSale => 'Umukiriya yakuwe ku igurisha';

  @override
  String get customersFailedToRemove =>
      'Gukura umukiriya ku igurisha ntibyakunze';

  @override
  String get customersDeleted => 'Umukiriya yasibwe';

  @override
  String customersCouldNotOpenForm(String error) {
    return 'Ntibyashobotse gufungura ifishi y\'umukiriya: $error';
  }

  @override
  String customersAddNamed(String name) {
    return 'Ongeraho umukiriya \"$name\"';
  }

  @override
  String customersAddNamedToSale(String name) {
    return 'Shyira \"$name\" ku igurisha';
  }

  @override
  String get customersThisCustomer => 'uyu mukiriya';

  @override
  String get customersDeleteTitle => 'Siba umukiriya?';

  @override
  String customersDeleteBody(String name) {
    return 'Kura $name ku rutonde rw\'abakiriya bawe. Ntibishobora gusubizwa inyuma.';
  }

  @override
  String get itemRowConfirmFavorite => 'Emeza icyo ukunda';

  @override
  String itemRowConfirmFavoriteBody(String product, String position) {
    return 'Ugiye gushyira $product ku mwanya wa $position mu byo ukunda.\n\nUrabyemeza?';
  }

  @override
  String get itemRowUnnamedProduct => 'Igicuruzwa kitagira izina';

  @override
  String get itemRowDefaultVariant => 'Ubwoko bw\'ibanze';

  @override
  String get itemRowUnnamed => 'Nta zina';

  @override
  String itemRowStockLeft(String quantity) {
    return 'Hasigaye $quantity';
  }

  @override
  String get itemRowDecreaseQuantity => 'Gabanya ingano';

  @override
  String get itemRowIncreaseQuantity => 'Ongera ingano';

  @override
  String get itemRowNoImage => 'Nta foto';

  @override
  String get itemRowCannotDeleteWithStock =>
      'Ntushobora gusiba ubwoko bufite ububiko.';

  @override
  String get txDetailExpense => 'Icyakoreshejwe';

  @override
  String get txDetailIncome => 'Amafaranga yinjiye';

  @override
  String get txDetailProducts => 'Ibicuruzwa';

  @override
  String get txDetailTimeline => 'Amateka y\'igurisha';

  @override
  String txDetailEventCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibikorwa $count',
      one: 'Igikorwa 1',
    );
    return '$_temp0';
  }

  @override
  String get txDetailExpenseRecorded => 'Icyakoreshejwe cyanditswe';

  @override
  String get txDetailIncomeReceived => 'Amafaranga yakiriwe';

  @override
  String get txDetailMoreActions => 'Ibindi bikorwa';

  @override
  String get txDetailCreatedPrefix => 'Byakozwe ';

  @override
  String txDetailAmountRefunded(String amount) {
    return '$amount yasubijwe';
  }

  @override
  String get txDetailFullyRefunded => 'Umukiriya yasubijwe amafaranga yose';

  @override
  String txDetailRefundVia(String reason, String method) {
    return '$reason · binyuze kuri $method';
  }

  @override
  String get txDetailMethod => 'Uburyo';

  @override
  String get txDetailReference => 'Indango';

  @override
  String get txDetailNoLineItems => 'Nta bicuruzwa biri kuri iri gurisha.';

  @override
  String get txDetailNoTimelineEvents => 'Nta bikorwa birahari.';

  @override
  String get txDetailStatusPartiallyRefunded => 'YASUBIJWE IGICE';

  @override
  String get txDetailStatusRefunded => 'YASUBIJWE';

  @override
  String get txDetailStatusPending => 'BITEGEREJE';

  @override
  String get txDetailStatusCompleted => 'BYARANGIYE';

  @override
  String get txDetailStatusParked => 'BYABITSWE';

  @override
  String get txDetailPartiallyRefunded => 'Byasubijwe igice';

  @override
  String get txDetailRefund => 'Gusubiza amafaranga';

  @override
  String get txDetailPaymentReceived => 'Ubwishyu bwakiriwe';

  @override
  String get txDetailPaymentPending => 'Ubwishyu butegerejwe';

  @override
  String get txDetailSaleCreated => 'Igurisha ryakozwe';

  @override
  String txDetailPaymentLine(String method) {
    return 'Ubwishyu: $method';
  }

  @override
  String get txListSelectDateRange => 'Hitamo igihe';

  @override
  String get txListSelectDateRangeFirst => 'Banza uhitemo igihe';

  @override
  String get txListNoDataToExport =>
      'Nta makuru yo kohereza hanze. Tegereza amakuru aze.';

  @override
  String get txListReportStillLoading =>
      'Amakuru ya raporo aracyaza. Ongera ugerageze mu kanya.';

  @override
  String txListExportFailed(String error) {
    return 'Kohereza hanze ntibyakunze: $error';
  }

  @override
  String txListRefreshFailed(String error) {
    return 'Kuvugurura ntibyakunze: $error';
  }

  @override
  String txListReportFailed(String error) {
    return 'Raporo ntiyakunze: $error';
  }

  @override
  String get txListChangeDate => 'Hindura itariki';

  @override
  String get txListZReport => 'Raporo Z';

  @override
  String get txListXReport => 'Raporo X';

  @override
  String get txListSaleReport => 'Raporo y\'ibyagurishijwe';

  @override
  String get txListPluReport => 'Raporo ya PLU';

  @override
  String get txListAllStatuses => 'Imiterere yose';

  @override
  String get txListAllTypes => 'Ubwoko bwose';

  @override
  String get txListAllPayments => 'Ubwishyu bwose';

  @override
  String get txListByHand => 'Mu ntoki';

  @override
  String get txListSearchReceipt => 'Shakisha nimero y\'inyemezabuguzi...';

  @override
  String get txListCashierHeading => 'UMUCURUZI';

  @override
  String get txListAll => 'Bose';

  @override
  String get txListRefreshTooltip =>
      'Vugurura — kura amakuru mashya ku bindi bikoresho cyangwa kuri seriveri';

  @override
  String get txListSummarized => 'Incamake';

  @override
  String get txListDetailed => 'Birambuye';

  @override
  String get txListNoTransactions => 'Nta magurisha yabonetse muri icyo gihe.';

  @override
  String get txListPreparingReports => 'Raporo zawe zirimo gutegurwa...';

  @override
  String get txListMightTakeMoment =>
      'Bishobora gutwara akanya bitewe n\'amakuru yawe';

  @override
  String get txListSomethingWentWrong => 'Ihangane! Hari ikitagenze neza';

  @override
  String get dashViewToday => 'Uyu munsi';

  @override
  String get dashViewThisWeek => 'Iki cyumweru';

  @override
  String get dashViewThisMonth => 'Uku kwezi';

  @override
  String get dashViewThisYear => 'Uyu mwaka';

  @override
  String get dashViewNetProfit => 'Inyungu nyayo';

  @override
  String get dashViewGrossProfit => 'Inyungu mbumbe';

  @override
  String get dashViewFromYegobox => 'BYAKOZWE NA YEGOBOX';

  @override
  String dashViewTodaysGoal(String count, String target) {
    return 'Intego y\'uyu munsi · $count kuri $target by\'ibyagurishijwe';
  }

  @override
  String get dashViewLogFirstSale =>
      'Andika igurisha ryawe rya mbere utangire kunguka';

  @override
  String get dashViewGoalReached => 'Intego yagezweho! ';

  @override
  String dashViewJustMoreTo(String remaining) {
    return 'Hasigaye $remaining ngo ubone ';
  }

  @override
  String get dashViewPlusPoints => '+50 amanota';

  @override
  String get dashViewStockValue => 'Agaciro k\'ububiko';

  @override
  String dashViewItemsLowOnStock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibicuruzwa $count biri hafi gushira',
      one: 'Igicuruzwa 1 kiri hafi gushira',
    );
    return '$_temp0';
  }

  @override
  String get dashViewFullReport => 'Raporo yuzuye ›';

  @override
  String get dashViewDataIncomplete =>
      'Amakuru ashobora kuba atuzuye (guhuza kutarangiye).';

  @override
  String get dashViewUnableToLoadStock =>
      'Ntibyashobotse kuzana agaciro k\'ububiko.';

  @override
  String get dashViewRevenue => 'Amafaranga yinjiye';

  @override
  String get dashViewExpenses => 'Ibyakoreshejwe';

  @override
  String dashViewDeltaUp(String percent) {
    return 'Byazamutseho $percent%';
  }

  @override
  String dashViewDeltaDown(String percent) {
    return 'Byagabanutseho $percent%';
  }

  @override
  String get transactionsExportNotReady =>
      'Kohereza hanze ntibiriteguye. Ongera ugerageze mu kanya.';

  @override
  String get transactionsNoLineItemsToExport =>
      'Nta bicuruzwa byo kohereza hanze muri iki gihe.';

  @override
  String get transactionsFilter => 'Shungura amagurisha';

  @override
  String get transactionsExportDetailed => 'Ohereza raporo irambuye (Excel)';

  @override
  String get transactionsTitle => 'Amagurisha';

  @override
  String transactionsNoRecordsFor(String period) {
    return 'Nta byanditswe kuri $period';
  }

  @override
  String get transactionsTryDifferentPeriod =>
      'Gerageza guhitamo ikindi gihe cyangwa wongereho amagurisha.';

  @override
  String get transactionsLoading => 'Amagurisha arimo kuza...';

  @override
  String get transactionsSomethingWentWrong => 'Hari ikitagenze neza';

  @override
  String previewSaleCollectAmount(String amount) {
    return 'Akira $amount';
  }

  @override
  String previewSaleOrderAmount(String amount) {
    return 'Tumiza $amount';
  }

  @override
  String get previewSaleCartEmpty => 'Agatebo kawe karimo ubusa';

  @override
  String get previewSaleDiscounts => 'Igabanuka';

  @override
  String get importStatusAll => 'Byose';

  @override
  String get importStatusWaiting => 'Birategereje';

  @override
  String get importStatusRejected => 'Byanzwe';

  @override
  String get importSaveChanges => 'Bika impinduka';

  @override
  String get importAcceptAll => 'Emera byose';

  @override
  String get importFilterByStatus => 'Shungura ukurikije imiterere';

  @override
  String get importEnterName => 'Andika izina';

  @override
  String get importEnterSupplyPrice => 'Andika ikiranguzo';

  @override
  String get importSupplyPriceRequired => 'Ikiranguzo kirakenewe';

  @override
  String get importEnterRetailPrice => 'Andika igiciro cyo kugurisha';

  @override
  String get importRetailPriceRequired => 'Igiciro cyo kugurisha kirakenewe';

  @override
  String get paymentSettingsTitle => 'Igenamiterere ry\'ubwishyu';

  @override
  String get paymentSettingsEnabled => 'Birakora';

  @override
  String get paymentSettingsDisabled => 'Ntibikora';

  @override
  String get mposWalkIn => 'Umukiriya w\'inzira';

  @override
  String get mposSaleComplete => 'Igurisha ryarangiye';

  @override
  String get mposNewSale => 'Igurisha rishya';

  @override
  String get mposPrintReceipt => 'Sohora inyemezabwishyu';

  @override
  String get mposTotalPaid => 'Byishyuwe byose';

  @override
  String get mposTendered => 'Byatanzwe';

  @override
  String get mposChange => 'Igisagutse';

  @override
  String get settingsManageBusiness =>
      'Genzura igenamiterere ry\'ubucuruzi bwawe';

  @override
  String get gaugeGrossProfit => 'Inyungu mbumbe';

  @override
  String get gaugeNetProfit => 'Inyungu nyayo';

  @override
  String get gaugeTaxAndExpenses => 'Imisoro n\'amafaranga yakoreshejwe';

  @override
  String get gaugeLoss => 'Igihombo';

  @override
  String get gaugeBalanced => 'Biringaniye';

  @override
  String get gaugeNoTransactions => 'Nta bikorwa';

  @override
  String get dashboardGaugeGrossProfit => 'Inyungu mbumbe';

  @override
  String get dashboardGaugeTaxExpenses => 'Imisoro n\'ibyakoreshejwe';

  @override
  String get dashboardGaugeNoTransactionsYet => 'Nta bikorwa biraba';

  @override
  String dashboardGaugeGrossProfitPeriod(String period) {
    return 'Inyungu mbumbe · $period';
  }

  @override
  String dashboardGaugeNetProfitPeriod(String period) {
    return 'Inyungu nyayo · $period';
  }

  @override
  String dashboardGaugeDeltaVs(String percent, String comparison) {
    return '$percent% ugereranyije na $comparison';
  }

  @override
  String get dashboardGaugeLastPeriod => 'igihe gishize';

  @override
  String get dashboardAppPointOfSale => 'Aho kugurishiriza';

  @override
  String get dashboardAppCashBook => 'Igitabo cy\'amafaranga';

  @override
  String get dashboardAppTransactions => 'Ibikorwa by\'imari';

  @override
  String get dashboardAppContacts => 'Kontaki';

  @override
  String get dashboardAppCommission => 'Komisiyo';

  @override
  String get dashboardAppSupport => 'Ubufasha';

  @override
  String get dashboardAppCredits => 'Inguzanyo';

  @override
  String get dashboardAppOrders => 'Ibyatumijwe';

  @override
  String get dashboardAppFinance => 'Imari';

  @override
  String get dashboardAppBooks => 'Ibaruramari';

  @override
  String get dashboardAppStockRecount => 'Kongera kubara ububiko';

  @override
  String get dashboardAppTransfersReport => 'Raporo y\'iyimurwa';

  @override
  String get dashboardAppBranchOrders => 'Ibyatumijwe n\'amashami';

  @override
  String get dashboardQuickAccess => 'KUGERAHO VUBA';

  @override
  String get dashboardSeeAll => 'Reba byose';

  @override
  String get dashboardShortcutUnsupported =>
      'Iki gikoresho ntigishyigikira utubuto two kugera vuba.';

  @override
  String dashboardShortcutAddPrompt(String label) {
    return 'Ongeraho \"$label\" kuri ecran y\'ibanze igihe ubisabwe.';
  }

  @override
  String get dashboardShortcutLauncherUnsupported =>
      'Launcher yawe ntishyigikira utubuto two kugera vuba.';

  @override
  String get dashboardShortcutFailed =>
      'Ntibyakunze gukora akabuto ko kugera vuba.';

  @override
  String get dashboardAllAppsYourBusiness => 'ubucuruzi bwawe';

  @override
  String dashboardAllAppsEverythingIn(String name) {
    return 'Ibiri muri $name byose';
  }

  @override
  String appLaunchOpening(String app) {
    return 'Turimo gufungura $app';
  }

  @override
  String get appLaunchSyncingSlow =>
      'Turimo guhuza amakuru y\'ubucuruzi bwawe — bishobora gutinda gato niba interineti itihuta.';

  @override
  String get cashbookCategorySheetSaveFailed =>
      'Ntibyakunze kubika iki cyiciro. Reba interineti yawe wongere ugerageze.';

  @override
  String get cashbookCategorySheetQuickPicks => 'IBYO WAHITAMO VUBA';

  @override
  String get cashbookCategorySheetTitle => 'Icyiciro gishya';

  @override
  String get cashbookCategorySheetIncomeSubtitle => 'Huza amafaranga yinjira';

  @override
  String get cashbookCategorySheetExpenseSubtitle => 'Huza amafaranga asohoka';

  @override
  String get cashbookCategorySheetNameLabel => 'Izina ry\'icyiciro';

  @override
  String cashbookCategorySheetExampleHint(String example) {
    return 'urugero: $example';
  }

  @override
  String get cashbookCategorySheetTypeName => 'Andika izina';

  @override
  String cashbookCategorySheetAlreadyExists(String name) {
    return '\"$name\" kirasanzweho. Turagikoresha.';
  }

  @override
  String get cashbookCategorySheetUseExisting => 'Koresha icyiciro gisanzweho';

  @override
  String get cashbookCategorySheetCreate => 'Kora icyiciro';

  @override
  String get checkoutRecoveryLeaveQuestion => 'Uva ku kwishyura?';

  @override
  String get checkoutRecoveryCheckout => 'Kwishyura';

  @override
  String get checkoutRecoverySale => 'Igurisha';

  @override
  String get checkoutRecoveryActionNeeded => 'HARI IGIKENEWE';

  @override
  String get checkoutRecoveryUnavailable => 'KWISHYURA NTIBIBONEKA';

  @override
  String get checkoutRecoveryNoBranchHeadline => 'Nta shami riratoranywa';

  @override
  String get checkoutRecoveryLoadFailedHeadline =>
      'Ntibyakunze gufungura kwishyura';

  @override
  String get checkoutRecoveryNoBranchBody =>
      'Kwishyura bikenera ishami kugira ngo bizane ibicuruzwa kandi byandike igurisha. Hitamo ishami ukomeze.';

  @override
  String get checkoutRecoveryLoadFailedBody =>
      'Habaye ikibazo mu gufungura kwishyura. Ongera ugerageze cyangwa uvugane n\'ubufasha niba bikomeje.';

  @override
  String get checkoutRecoveryWhatHappened => 'Ibyabaye';

  @override
  String get checkoutRecoveryNoLocationDiagnostic =>
      'kwishyura ntibyabashije kubona aho iki gikoresho giherereye.';

  @override
  String get checkoutRecoverySelectBranch => 'Hitamo ishami';

  @override
  String get checkoutRecoveryChooseWhere => 'Hitamo aho iri gurisha ribera';

  @override
  String get checkoutRecoveryStillStuck => 'Biracyanze?';

  @override
  String get checkoutRecoveryGetHelp => 'Saba ubufasha';

  @override
  String get checkoutRecoveryLoading => 'Turimo gufungura kwishyura…';

  @override
  String get checkoutRecoveryBranch => 'Ishami';

  @override
  String get checkoutRecoveryReady => 'Kwishyura biteguye';

  @override
  String get checkoutRecoveryReadyBody =>
      'Witeguye kwakira ubwishyu. Ibicuruzwa n\'igiteranyo bizahuzwa n\'iri shami.';

  @override
  String get checkoutRecoveryOpenCheckout => 'Fungura kwishyura';

  @override
  String get checkoutRecoveryStillNoBranch =>
      'Nta shami riratoranywa — hitamo rimwe ukomeze.';

  @override
  String get checkoutRecoveryWhereQuestion => 'Iri gurisha ribera he?';

  @override
  String get checkoutRecoverySetDefaultBranch =>
      'Shyiraho nk\'ishami ry\'ibanze kuri iki gikoresho';

  @override
  String get checkoutRecoveryChooseBranch => 'Hitamo ishami';

  @override
  String get checkoutRecoveryContinue => 'Komeza ujye kwishyura';

  @override
  String get checkoutRecoveryChecking => 'Turimo kugenzura…';

  @override
  String get checkoutRecoveryTryAgain => 'Ongera ugerageze';

  @override
  String get checkoutRecoveryBranchLocation => 'Aho ishami riherereye';

  @override
  String get checkoutRecoveryHqBadge => 'ICYICARO';

  @override
  String checkoutTransferToBranch(String branch) {
    return 'Imurira kuri $branch';
  }

  @override
  String get checkoutTransferNoItemsSelected => 'Nta gicuruzwa cyatoranyijwe';

  @override
  String get checkoutTransferToBranchLabel => 'Ku ishami';

  @override
  String get checkoutTransferNoOtherBranches => 'Nta yandi mashami';

  @override
  String get checkoutTransferSelectBranch => 'Hitamo ishami';

  @override
  String get checkoutTransferLoadBranchesFailed =>
      'Ntibyakunze kuzana amashami';

  @override
  String get peersNetworkStatus => 'Imiterere y\'umuyoboro';

  @override
  String get peersThisDeviceOnly =>
      'Iki gikoresho cyonyine — nta bindi bikoresho biri ku muyoboro.';

  @override
  String peersSyncedWith(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bihujwe n\'ibikoresho $count ku muyoboro.',
      one: 'Bihujwe n\'igikoresho 1 ku muyoboro.',
    );
    return '$_temp0';
  }

  @override
  String get peersLocalDevice => 'Iki gikoresho';

  @override
  String get peersOnline => 'Kuri interineti';

  @override
  String get peersConnectedPeers => 'Ibikoresho bihujwe';

  @override
  String get peersSyncNotInitialized => 'Serivisi yo guhuza ntiratangira';

  @override
  String peersConnectedTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bihujwe n\'ibikoresho $count. Kanda urebe birambuye.',
      one: 'Bihujwe n\'igikoresho 1. Kanda urebe birambuye.',
    );
    return '$_temp0';
  }

  @override
  String get peersSearching =>
      'Turimo gushaka ibikoresho biri ku muyoboro umwe...';

  @override
  String get peersLive => 'Birakora';

  @override
  String get peersNetworkCheckError => 'Ikosa mu kugenzura umuyoboro';

  @override
  String get peersNoOtherDevices => 'Nta bindi bikoresho byabonetse';

  @override
  String get peersOpenFlipperHint =>
      'Fungura Flipper ku kindi gikoresho kiri ku muyoboro umwe.';

  @override
  String get saleModeNormal => 'Igurisha risanzwe';

  @override
  String get saleModeProforma => 'Proforma';

  @override
  String get saleModeTraining => 'Imyitozo';

  @override
  String get saleModeTitle => 'Uburyo bwo kugurisha';

  @override
  String get saleModeDescription =>
      'Ubwoko bw\'inyemezabwishyu igurisha rishya risohokaho. Bireke kuri Igurisha risanzwe keretse niba urimo kwitoza cyangwa gutanga igiciro.';

  @override
  String get saleModeNormalSubtitle =>
      'Igurisha nyaryo ryemewe n\'imisoro. Ni ryo risanzwe.';

  @override
  String get saleModeProformaSubtitle =>
      'Ibiciro bitangwa mbere. Si inyemezabwishyu, nta mpinduka mu bubiko.';

  @override
  String get saleModeTrainingSubtitle =>
      'Igurisha ryo kwitoza. Inyemezabwishyu z\'imyitozo ntizishobora gusangizwa cyangwa gusohorwa.';

  @override
  String get mposCartEmptyHint => 'Kanda ku gicuruzwa utangire igurisha';

  @override
  String get mposCartReviewPay => 'Suzuma wishyure';

  @override
  String get mposCartLabel => 'Agatebo';

  @override
  String mposCartSummary(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibicuruzwa $count, RWF $total',
      one: 'Igicuruzwa 1, RWF $total',
    );
    return '$_temp0';
  }

  @override
  String mposCartItemsInCart(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibicuruzwa $count mu gatebo',
      one: 'Igicuruzwa 1 mu gatebo',
    );
    return '$_temp0';
  }

  @override
  String get mposDismiss => 'Funga';

  @override
  String get mposBackFromCheckout => 'Subira inyuma uve ku kwishyura';

  @override
  String get mposScan => 'Sikana';

  @override
  String get mposRemovingCustomer => 'Turimo gukuraho umukiriya…';

  @override
  String get mposAttachCustomer => 'Ongeraho umukiriya';

  @override
  String get mposWalkInCustomer => 'Umukiriya w\'inzira';

  @override
  String get mposAttachCustomerHint => 'Kanda wongereho umukiriya (si ngombwa)';

  @override
  String get mposRemoveCustomer => 'Kuraho umukiriya';

  @override
  String mposCustomerAttachedToSale(String name) {
    return '$name yongewe kuri iri gurisha';
  }

  @override
  String mposCouldNotAttachCustomer(String error) {
    return 'Ntibyakunze kongeraho umukiriya: $error';
  }

  @override
  String get mposSearchNameOrPhone => 'Shakisha izina cyangwa telefoni';

  @override
  String get mposContinueAsWalkIn => 'Komeza nta mukiriya';

  @override
  String get mposNoCustomerOnSale => 'Nta mukiriya kuri iri gurisha';

  @override
  String get mposAddNewCustomer => 'Ongeraho umukiriya mushya';

  @override
  String mposItemQtyAtPrice(String qty, String price) {
    return '$qty kuri RWF $price';
  }

  @override
  String get mposDoneEditingPrice => 'Kurangiza guhindura igiciro';

  @override
  String get mposEditPrice => 'Hindura igiciro';

  @override
  String mposDeleteItem(String name) {
    return 'Siba $name';
  }

  @override
  String get mposUnitPrice => 'Igiciro cy\'igice';

  @override
  String mposUnitPriceWithDefault(String price) {
    return 'Igiciro cy\'igice · gisanzwe RWF $price';
  }

  @override
  String mposUnitPriceFor(String name) {
    return 'Igiciro cy\'igice cya $name';
  }

  @override
  String mposResetPriceFor(String name) {
    return 'Subiza igiciro cya $name';
  }

  @override
  String get mposDecreaseQuantity => 'Gabanya ingano';

  @override
  String get mposIncreaseQuantity => 'Ongera ingano';

  @override
  String get mposMomoPhoneNumber => 'Nimero ya MoMo';

  @override
  String get mposCashReceivedAmount => 'Amafaranga yakiriwe mu ntoki';

  @override
  String mposCreditAmount(String amount) {
    return 'Amafaranga y\'inguzanyo · $amount';
  }

  @override
  String get mposCreditExplanation =>
      'Iri gurisha ryandikwa ku mwenda w\'umukiriya. Ongeraho umukiriya mbere yo kurangiza.';

  @override
  String mposPaymentLinesSplitHint(int count) {
    return 'Imirongo y\'ubwishyu $count · koresha kugabanya muri mudasobwa';
  }

  @override
  String get mposTax => 'Umusoro';

  @override
  String get mposTotal => 'Igiteranyo';

  @override
  String get mposAlreadyPaid => 'Byamaze kwishyurwa';

  @override
  String get mposThisPayment => 'Ubu bwishyu';

  @override
  String get mposBalanceDue => 'Asigaye kwishyurwa';

  @override
  String get posCartLineSubtotal => 'Igiteranyo cy\'umurongo';

  @override
  String get posCartEditQtyPrice => 'Hindura ingano/igiciro';

  @override
  String get posCartHideDetails => 'Hisha ibisobanuro';

  @override
  String get posCartRemoveLine => 'Kuraho umurongo';

  @override
  String get posScanMode => 'Uburyo bwo gusikana';

  @override
  String get posSendToTillNeedsCustomer =>
      'Bika izina cyangwa nimero ya telefoni y\'umukiriya kuri iyi tike mbere yo kuyohereza ku kasi.';

  @override
  String get posPreparingCheckout => 'Turimo gutegura kwishyura...';

  @override
  String get posShiftLoadFailed =>
      'Ntibyakunze kumenya uko igihe cy\'akazi gihagaze';

  @override
  String get posShiftStartToSell =>
      'Tangira igihe cy\'akazi kugira ngo ugurishe';

  @override
  String get posShiftStartHint =>
      'Fungura igihe cy\'akazi cy\'isanduku y\'amafaranga mbere yo kwandika igurisha. Ushobora no kugifungura uhereye ku ruhande.';

  @override
  String get salesByCashierTitle => 'IBYAGURISHIJWE NA BURI MUCURUZI';

  @override
  String get salesByCashierByHand => 'Mu ntoki';

  @override
  String get startupTagline => 'Porogaramu y\'ubucuruzi idasanzwe...';

  @override
  String get startupProgressLabel => 'Aho gutangira bigeze';

  @override
  String get startupReady => 'Biteguye';

  @override
  String get startupFinishingUp => 'Turimo kurangiza';

  @override
  String get startupConfirmingPlan => 'Turimo kwemeza ifatabuguzi ryawe';

  @override
  String get startupSyncingData => 'Turimo guhuza amakuru yawe';

  @override
  String get startupStartingServices => 'Turimo gutangiza serivisi';

  @override
  String get startupCheckingWorkspace => 'Turimo kugenzura aho ukorera';

  @override
  String get startupConnecting => 'Turimo guhuza';

  @override
  String get topBarNotifications => 'Imenyesha';

  @override
  String get userInfoLoading => 'Biracyaza...';

  @override
  String get userInfoFallbackName => 'Ukoresha';

  @override
  String get userInfoSwitchBranch => 'Hindura ishami';

  @override
  String get userInfoSwitchUser => 'Hindura ukoresha';

  @override
  String get variantDropdownBranchNotSelected =>
      'Nta shami ryatoranyijwe. Hitamo ishami.';

  @override
  String get variantDropdownNoVariantsHint =>
      'Nta moko ahari yo guhitamo. Banza ukore amoko.';

  @override
  String get variantDropdownNoVariants => 'Nta moko';

  @override
  String get variantDropdownSelect => 'Hitamo ubwoko';

  @override
  String get variantDropdownSearch => 'Shakisha amoko...';

  @override
  String get variantDropdownLoadError => 'Ikosa mu kuzana amoko';

  @override
  String get variantImageSaveProductFirst =>
      'Bika igicuruzwa wongere ugerageze';

  @override
  String get variantImageUploadFailed =>
      'Ntibyakunze kohereza ifoto. Ongera ugerageze.';

  @override
  String get variantImageChange => 'Hindura ifoto y\'ubwoko';

  @override
  String get variantImageAdd => 'Ongeraho ifoto y\'ubwoko';

  @override
  String get waOptInScanTitle => 'Sikana ubone inyemezabwishyu';

  @override
  String get waOptInSubtitle =>
      'Umukiriya agomba kwandikira rimwe nimero ya WhatsApp y\'ubucuruzi bwawe kugira ngo tumwoherereze inyemezabwishyu ya elegitoroniki.';

  @override
  String get waOptInScanHint => 'Fungura WhatsApp → sikana ukoresheje kamera';

  @override
  String get waOptInQueued =>
      'Inyemezabwishyu iri ku murongo. Saba umukiriya kwandikira nimero ya WhatsApp y\'ubucuruzi bwawe, hanyuma PDF izoherezwa ubwayo.';

  @override
  String get waOptInLinkCopied => 'Ihuza rya WhatsApp ryakoporowe';

  @override
  String get waOptInCopy => 'Koporora';

  @override
  String waOptInReceiptPhone(String phone) {
    return 'Telefoni y\'inyemezabwishyu: $phone';
  }

  @override
  String get kpiTotalSales => 'Igurisha ryose';

  @override
  String get kpiCollected => 'Byakiriwe';

  @override
  String get kpiOwed => 'Ibirarane';

  @override
  String get printDelegationNoDevicesLoaded =>
      'Nta bikoresho biraboneka kuri iri shami. Reba ko izindi mudasobwa zinjiye kandi ziri kuri interineti, hanyuma wongere ufungure iyi paji.';

  @override
  String get printDelegationOnlyThisDesktop =>
      'Iyi mudasobwa yonyine ni yo yanditse kuri iri shami. Injira kuri indi POS ya Windows, macOS cyangwa Linux kugira ngo uyohereze gusohora.';

  @override
  String get printDelegationNoDesktops =>
      'Hari ibindi bikoresho kuri iri shami ariko nta na kimwe ari mudasobwa (device_name igomba kuba windows, macos cyangwa linux).';

  @override
  String get printDelegationNoOtherDesktops =>
      'Nta yindi mudasobwa yabonetse kuri iri shami';

  @override
  String get printDelegationDeviceNameSaved => 'Izina ry\'igikoresho ryabitswe';

  @override
  String printDelegationDeviceNameSaveFailed(String error) {
    return 'Ntibyakunze kubika izina ry\'igikoresho: $error';
  }

  @override
  String get printDelegationDeviceSelected =>
      'Igikoresho cyo kohereza cyatoranyijwe';

  @override
  String printDelegationSelectDeviceError(String error) {
    return 'Ikosa mu guhitamo igikoresho: $error';
  }

  @override
  String get printDelegationEnabled => 'Kohereza gusohora byatangijwe';

  @override
  String get printDelegationDisabled => 'Kohereza gusohora byahagaritswe';

  @override
  String get printDelegationTitle => 'Kohereza gusohora';

  @override
  String get printDelegationMobileDescription =>
      'Ohereza gusohora inyemezabwishyu kuri mudasobwa iyo seriveri ya EBM itaboneka';

  @override
  String get printDelegationDesktopDescription =>
      'Tunganya inyemezabwishyu zoherejwe na telefoni, cyangwa wohereze gusohora ku yindi mudasobwa';

  @override
  String get printDelegationGenericDescription =>
      'Gutunganya igurisha hagati y\'ibikoresho';

  @override
  String get printDelegationThisDevice => 'Iki gikoresho (cyakira ibyoherejwe)';

  @override
  String get printDelegationThisDeviceHint =>
      'Izindi POS zigomba guhitamo iyi ID mu igenamiterere ryazo ryo kohereza. Iyi mashini ntigaragara ku rutonde ruri hasi kuko udashobora kwiyoherereza gusohora.';

  @override
  String get printDelegationDeviceIdMissing =>
      'ID y\'igikoresho ntiranditswa — ongera utangize porogaramu cyangwa wongere winjire.';

  @override
  String printDelegationDeviceName(String name) {
    return 'Izina ry\'igikoresho: $name';
  }

  @override
  String get printDelegationFriendlyName =>
      'Izina ryoroshye (rigaragara ku bindi bikoresho)';

  @override
  String get printDelegationFriendlyNameHint =>
      'urugero: Imashini isohora yo ku kasi';

  @override
  String get printDelegationMobileTargetHint =>
      'Hitamo mudasobwa isohora iri hasi. Kuri iyo mudasobwa, fungura Ubuyobozi → Kohereza gusohora maze ukoporore ID yose ya \"Iki gikoresho\" — igomba guhura n\'iyo wahisemo hano.';

  @override
  String get printDelegationDelegateToDesktop =>
      'Ohereza gusohora ku yindi mudasobwa';

  @override
  String printDelegationPlatform(String platform) {
    return 'Urubuga: $platform';
  }

  @override
  String printDelegationPhone(String phone) {
    return 'Telefoni: $phone';
  }

  @override
  String printDelegationLoadDevicesError(String error) {
    return 'Ikosa mu kuzana ibikoresho: $error';
  }

  @override
  String get printDelegationHowItWorks => 'Uko bikora';

  @override
  String get printDelegationMobileStep1 =>
      'Telefoni irangiza igurisha ariko ikohereza gukora inyemezabwishyu';

  @override
  String get printDelegationMobileStep2 =>
      'Mudasobwa ifata igurisha binyuze mu guhuza';

  @override
  String get printDelegationMobileStep3 =>
      'Mudasobwa ikora inyemezabwishyu ikavugana na seriveri ya EBM';

  @override
  String get printDelegationMobileStep4 =>
      'Telefoni imenyeshwa iyo gutunganya birangiye';

  @override
  String get printDelegationDesktopStep1 =>
      'Mudasobwa ikurikirana igurisha ryoherejwe ako kanya';

  @override
  String get printDelegationDesktopStep2 =>
      'Itunganya ubwayo inyemezabwishyu ziturutse kuri telefoni';

  @override
  String get printDelegationDesktopStep3 =>
      'Ushobora guhitamo indi mudasobwa iri hasi yo koherezaho gusohora kw\'iki gikoresho';

  @override
  String get printDelegationDesktopStep4 =>
      'Ikora itumanaho na seriveri ya EBM';

  @override
  String get printDelegationDesktopStep5 =>
      'Isubiza ibisubizo kuri telefoni binyuze mu guhuza';

  @override
  String printDelegationCopiedDeviceId(String id) {
    return 'ID y\'igikoresho yakoporowe: $id';
  }

  @override
  String get printDelegationCopyDeviceId => 'Koporora ID y\'igikoresho';

  @override
  String get refundReasonDuplicate => 'Kwishyuzwa kabiri';

  @override
  String get refundReasonOther => 'Ikindi';

  @override
  String get refundAlreadyRefunded => 'Byamaze gusubizwa';

  @override
  String get refundPaymentTitle => 'Subiza ubwishyu';

  @override
  String get refundIncomeRefunded => 'Aya mafaranga yinjiye yarasubijwe';

  @override
  String get refundReturnMoney => 'Subiza umukiriya amafaranga';

  @override
  String get refundMoreActions => 'Ibindi bikorwa';

  @override
  String refundIncomeReference(String reference) {
    return 'Amafaranga yinjiye · $reference';
  }

  @override
  String get refundShareReceipt => 'Sangiza inyemezabwishyu';

  @override
  String get refundShareReceiptSubtitle =>
      'Ohereza kuri WhatsApp, SMS cyangwa imeyili';

  @override
  String get refundShareCopySubtitle =>
      'Ohereza kopi y\'igurisha kuri WhatsApp, SMS cyangwa imeyili';

  @override
  String get refundDownloadPdf => 'Kuramo PDF';

  @override
  String get refundDownloadReceiptSubtitle => 'Bika kopi y\'iyi nyemezabwishyu';

  @override
  String get refundDownloadCopySubtitle => 'Bika iri gurisha nka kopi ya PDF';

  @override
  String get refundPrintSubtitle => 'Ohereza ku mashini isohora ihujwe';

  @override
  String refundReturnMoneyFor(String reference) {
    return 'Subiza amafaranga ya $reference';
  }

  @override
  String get refundHowMuch => 'Angahe?';

  @override
  String get refundFull => 'Gusubiza byose';

  @override
  String get refundPartial => 'Igice';

  @override
  String get refundChooseAmount => 'Hitamo amafaranga';

  @override
  String refundCannotExceed(String amount) {
    return 'Ntibishobora kurenza $amount y\'ibanze';
  }

  @override
  String refundUpToAvailable(String amount) {
    return 'Ushobora gusubiza kugeza kuri $amount';
  }

  @override
  String get refundReasonLabel => 'Impamvu';

  @override
  String get refundTo => 'Subiza binyuze kuri';

  @override
  String get refundHandBackNow => 'Musubize ubu';

  @override
  String get refundSendToPhone => 'Ohereza kuri telefoni';

  @override
  String refundAmountButton(String amount) {
    return 'Subiza $amount';
  }

  @override
  String get refundOriginalPayment => 'Ubwishyu bw\'ibanze';

  @override
  String get refundProcessing => 'Turimo gusubiza amafaranga…';

  @override
  String get refundStepValidating => 'Kugenzura isubizwa';

  @override
  String get refundStepRestoringStock => 'Gusubiza ibicuruzwa mu bubiko';

  @override
  String get refundStepSavingRecords => 'Kubika inyandiko';

  @override
  String get refundMethodCashLower => 'amafaranga mu ntoki';

  @override
  String get refundCompleted => 'Isubizwa ryarangiye';

  @override
  String refundDoneSuffix(String method) {
    return 'yasubijwe umukiriya binyuze kuri $method.';
  }

  @override
  String get refundSheetUnavailable => 'Gusubiza ntibishoboka';

  @override
  String get internetRequiredTitle => 'Interineti irakenewe';

  @override
  String get internetRequiredBody =>
      'Ugomba kwinjira kuri interineti kugira ngo ukomeze gukoresha Flipper. Sisitemu yacu ikenera interineti buri minsi 5 kugira ngo yemeze konti yawe.';

  @override
  String get internetRequiredCheck => 'Genzura interineti';

  @override
  String get internetRequiredHint =>
      'Niba ukomeje kubona iyi paji, reba interineti yawe wongere ugerageze.';

  @override
  String get addCustomerOpening => 'Turimo gufungura…';

  @override
  String get mposStatusPending => 'Bitegereje';

  @override
  String get mposStatusCompleted => 'Byarangiye';

  @override
  String get mposStatusPaid => 'Byishyuwe';

  @override
  String get mposStatusCancelled => 'Byahagaritswe';

  @override
  String get mposStatusParked => 'Byabitswe';

  @override
  String get mposPriceEdited => 'byahinduwe';

  @override
  String get balancesExpenses => 'Amafaranga yakoreshejwe';

  @override
  String adminChannelNumber(String number) {
    return 'Umuyoboro $number';
  }

  @override
  String get adminInvalidSmsPhone =>
      'Andika nimero ya telefoni yemewe irimo kode y\'igihugu (urugero: +250783054874)';

  @override
  String get adminSmsConfigUpdateFailed =>
      'Kuvugurura igenamiterere rya SMS byanze';

  @override
  String get transactionReportsTitle => 'Raporo z\'ibyakozwe';

  @override
  String get productNewCategory => 'Icyiciro gishya';

  @override
  String get productCategoryDescription =>
      'Icyiciro gihuriza hamwe ibicuruzwa bisa.';

  @override
  String get productCategoryName => 'Izina ry\'icyiciro';

  @override
  String get productCategoryNameHint =>
      'urugero: Ibinyobwa, Umugati, Ama-inite';

  @override
  String get productCategoryNameTooShort => 'Andika nibura inyuguti 2.';

  @override
  String get productCategoryCreateFailed =>
      'Ntibyashobotse gukora icyiciro. Ongera ugerageze.';

  @override
  String productCategoryAlreadyExists(String name) {
    return '\"$name\" isanzwe ihari.';
  }

  @override
  String productCategoryUseExisting(String name) {
    return 'Koresha \"$name\"';
  }

  @override
  String get productCreateCategory => 'Kora icyiciro';

  @override
  String get serviceModeBarMode => 'Uburyo bw\'akabari';

  @override
  String get serviceModeHotelMode => 'Uburyo bwa hoteli';

  @override
  String get serviceModeBarCounter => 'Konteri y\'akabari';

  @override
  String get serviceModeFrontDesk => 'Iyakira';

  @override
  String get serviceModeAdminOnly =>
      'Umuyobozi wenyine ni we ushobora guhindura uburyo bwa serivisi bw\'iki gikoresho.';

  @override
  String serviceModeSwitchNotSaved(String mode) {
    return 'Ntibyashobotse kujya kuri $mode: igenamiterere ry\'ishami ntiryabitswe. Reba murandasi yawe wongere ugerageze.';
  }

  @override
  String serviceModeSwitched(String mode, String hotkey) {
    return 'Iki gikoresho cyagiye kuri $mode · $hotkey kugira ngo uhindure';
  }

  @override
  String get serviceModeSwitchFailed =>
      'Ntibyashobotse guhindura uburyo bwa serivisi.';

  @override
  String serviceModeDeviceNowRuns(String mode) {
    return 'Iki gikoresho ubu gikoresha $mode.';
  }

  @override
  String serviceModeDeviceFollowsBranch(String mode) {
    return 'Iki gikoresho cyongeye gukurikiza igenamiterere risanzwe ry\'ishami ($mode).';
  }

  @override
  String get serviceModeThisDevice => 'Iki gikoresho';

  @override
  String get serviceModeWhatTerminalOpens => 'Icyo iyi mashini ifungura';

  @override
  String get serviceModeBranchRunsBoth =>
      'Iri shami rikoresha byombi. Shyira iyakira kuri mashini y\'iyakira, n\'imeza ku konteri y\'akabari — buri gikoresho kigumana amahitamo yacyo.';

  @override
  String get serviceModePickAfterLogin =>
      'Hitamo icyo iyi mugaragaza yerekana nyuma yo kwinjira. Ibindi bikoresho by\'iri shami bigumana amahitamo yabyo.';

  @override
  String get serviceModePinnedOnDevice => 'Byashyizwe kuri iki gikoresho gusa.';

  @override
  String get serviceModeUseBranchDefault => 'Koresha ibisanzwe by\'ishami';

  @override
  String get barRoomChargePickerSubtitle =>
      'Fagitire yimurirwa kuri konti y\'umushyitsi ikishyurwa igihe agiye.';

  @override
  String get barRoomChargeEmptyTab =>
      'Banza wongere ikintu kuri fagitire mbere yo kuyishyira ku cyumba.';

  @override
  String barRoomChargeMoved(String table, String target, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibintu $count',
      one: 'Ikintu 1',
    );
    return '$table → $target · $_temp0 kuri konti';
  }

  @override
  String get barTables => 'Ameza';

  @override
  String barFloorOpenTapToLog(String count) {
    return '$count zifunguye · kanda wandike komande';
  }

  @override
  String barFloorOpenTapTableToLog(String count) {
    return '$count zifunguye · kanda ku meza wandike komande yayo';
  }

  @override
  String get barOpenTab => 'Fagitire ifunguye';

  @override
  String get barTableFree => 'Irimo ubusa';

  @override
  String get barRoleServer => 'Umuseriveri';

  @override
  String barCashierLogging(String role) {
    return '$role · ari mu kazi';
  }

  @override
  String get barNoTablesConfigured => 'Nta meza yashyizweho';

  @override
  String barZoneOpenCount(String open, String total) {
    return '$open/$total zifunguye';
  }

  @override
  String get barCouldNotLoadStaff => 'Ntibishobotse kuzana abakozi';

  @override
  String get barModeSharedRegister => 'Uburyo bw\'akabari · Kesi ihuriweho';

  @override
  String get barWhosServing => 'Ni nde uri gukora?';

  @override
  String get barWhosOnRegister => 'Ni nde uri kuri kesi?';

  @override
  String get barLockHintTapAbove =>
      'Kanda ku izina ryawe hejuru, hanyuma wandike PIN yawe';

  @override
  String get barLockHintTapLeft =>
      'Kanda ku izina ryawe ibumoso, hanyuma wandike PIN yawe';

  @override
  String get barLockHintEnterPin =>
      'Andika PIN yawe y\'imibare 6 kugira ngo wandike komande';

  @override
  String get barConfiguredByAdmin =>
      'Uburyo bw\'akabari bwashyizweho n\'umuyobozi kuri mudasobwa nkuru';

  @override
  String get barStaffFallback => 'Umukozi';

  @override
  String get barSaveToTab => 'Bika kuri fagitire';

  @override
  String barFreshTabFor(String table) {
    return 'Fagitire nshya ya $table';
  }

  @override
  String get barTapProductFirstRound =>
      'Kanda ku gicuruzwa wongeremo icyiciro cya mbere';

  @override
  String get barTapProductsFirstRound =>
      'Kanda ku bicuruzwa wongeremo icyiciro cya mbere';

  @override
  String barLoggedByStaff(String count, String mine) {
    return 'Byanditswe n\'abakozi $count · wowe wongeyeho $mine';
  }

  @override
  String barYouLoggedLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wanditse imirongo $count kuri iyi fagitire',
      one: 'Wanditse umurongo 1 kuri iyi fagitire',
    );
    return '$_temp0';
  }

  @override
  String get barTabTotal => 'Igiteranyo cya fagitire';

  @override
  String barTabTotalItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibintu $count',
      one: 'Ikintu 1',
    );
    return 'Igiteranyo cya fagitire · $_temp0';
  }

  @override
  String get barSettleAndClose => 'Ishyura fagitire ufunge ameza';

  @override
  String get barSettleManagerPin => 'Ishyura fagitire · PIN y\'umuyobozi';

  @override
  String get barChargeToRoom => 'Shyira ku cyumba';

  @override
  String barPriceEach(String price) {
    return '$price kimwe';
  }

  @override
  String get barHideDetails => 'Hisha ibisobanuro';

  @override
  String get barEditPriceQty => 'Hindura igiciro n\'ingano';

  @override
  String barTableMetaOpened(String seats, String time, String elapsed) {
    return 'Intebe $seats · yafunguwe saa $time · $elapsed';
  }

  @override
  String barTableMetaOpenedBy(
    String seats,
    String time,
    String opener,
    String elapsed,
  ) {
    return 'Intebe $seats · yafunguwe saa $time na $opener · $elapsed';
  }

  @override
  String barOpenedAtElapsed(String time, String elapsed) {
    return 'Yafunguwe saa $time • $elapsed';
  }

  @override
  String get barSettleRoomChargeSubtitle =>
      'Fagitire yimurirwa kuri konti y\'umushyitsi ikishyurwa igihe agiye.';

  @override
  String get barSettleChooseMethod =>
      'Hitamo uburyo bwo kwishyura wakire amafaranga kugira ngo ufunge ameza.';

  @override
  String get barMobileMoney => 'Amafaranga kuri telefoni';

  @override
  String get barPickGuestForBill =>
      'Hitamo umushyitsi uzishyura iyi fagitire kuri konti ye.';

  @override
  String barRoomChargeNoMoney(String target) {
    return 'Nta mafaranga yishyurwa ubu: iyi mirongo yongerwa kuri $target kandi inyemezabuguzi itangwa umushyitsi agiye.';
  }

  @override
  String get barEnterAmountTendered => 'Andika amafaranga yatanzwe';

  @override
  String barAmountDue(String amount) {
    return '$amount yo kwishyura';
  }

  @override
  String get barMomoPushNotice =>
      'Ubusabe bwo kwishyura buzoherezwa kuri telefoni y\'umukiriya.';

  @override
  String barChargeToRoomTotal(String amount) {
    return 'Shyira ku cyumba — $amount';
  }

  @override
  String barChargeRoomTotal(String room, String amount) {
    return 'Shyira ku cyumba $room — $amount';
  }

  @override
  String barConfirmPaymentTotal(String amount) {
    return 'Emeza ubwishyu — $amount';
  }

  @override
  String barChargeToRoomTotalShort(String amount) {
    return 'Shyira ku cyumba · $amount';
  }

  @override
  String barChargeRoomTotalShort(String room, String amount) {
    return 'Shyira ku cyumba $room · $amount';
  }

  @override
  String barConfirmTotalShort(String amount) {
    return 'Emeza · $amount';
  }

  @override
  String get barRoomChargeFootnote =>
      'Ameza ahita aba ubusa; konti y\'umushyitsi yishyurirwa ku iyakira.';

  @override
  String get barCloseTableFootnote =>
      'Gufunga ameza bibika igurisha kandi bikayarekurira abandi bakiriya.';

  @override
  String get barInvalidReceiptPhone =>
      'Andika nimero ya telefoni y\'inyemezabuguzi ifite imibare 9 nyayo.';

  @override
  String barSettledToast(String table, String amount, String method) {
    return '$table yishyuwe · $amount $method';
  }

  @override
  String get barBackToTab => 'Subira kuri fagitire';

  @override
  String barSettleBillZone(String zone) {
    return 'Ishyura fagitire · $zone';
  }

  @override
  String barSettleZone(String zone) {
    return 'Ishyura · $zone';
  }

  @override
  String get barSettlingAsManager => 'Wishyuza nk\'umuyobozi';

  @override
  String barTableRunningTab(String table) {
    return 'Ameza $table — fagitire ikomeje';
  }

  @override
  String barServerName(String name) {
    return '$name · Umuseriveri';
  }

  @override
  String get barSubtotalExclVat => 'Igiteranyo (hatarimo TVA)';

  @override
  String get barVat18 => 'TVA 18%';

  @override
  String get barTotalDue => 'Igiteranyo cyo kwishyura';

  @override
  String get barReceiptPhoneNumber => 'Nimero ya telefoni y\'inyemezabuguzi *';

  @override
  String get barReceiptPhoneRequired =>
      'Birakenewe — byandikwa ku nyemezabuguzi ya RRA (TEL).';

  @override
  String get barInvalidMobileNumber =>
      'Andika nimero ya telefoni nyayo y\'imibare 9 (urugero: 783054874).';

  @override
  String get barUnnamedProduct => 'Igicuruzwa kitagira izina';

  @override
  String get barNoProductsMatch => 'Nta gicuruzwa gihuye n\'ibyo washakishije';

  @override
  String get barRoomChargeTileSubtitle => 'Ishyuza umushyitsi ucumbitse iwacu';

  @override
  String get barChoose => 'Hitamo';

  @override
  String get barChange => 'Hindura';

  @override
  String get barRunningTab => 'Fagitire ikomeje';

  @override
  String barZoneItemCount(String zone, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibintu $count',
      one: 'Ikintu 1',
    );
    return '$zone · $_temp0';
  }

  @override
  String get barBackToTables => 'Subira ku meza';

  @override
  String get barRemoveStaffTitle => 'Kuraho umukozi';

  @override
  String barRemoveStaffBody(String name) {
    return 'Kuraho $name mu itsinda ryawe? Ntazongera kwinjira akoresheje PIN muri ubu bucuruzi.';
  }

  @override
  String get barThisStaffMember => 'uyu mukozi';

  @override
  String get barStaffRemoved => 'Umukozi yakuweho';

  @override
  String get barStaffRemoveFailed =>
      'Ntibyashobotse gukuraho umukozi. Ongera ugerageze.';

  @override
  String get barModeAlongsideHotel =>
      'Uburyo bw\'akabari bwafunguwe hamwe n\'uburyo bwa hoteli — hitamo hasi icyo iki gikoresho gikoresha.';

  @override
  String get barAdminServiceMode => 'Uburyo bwa serivisi';

  @override
  String get barRequirePinTitle => 'Saba PIN mu guhindura umubitsi';

  @override
  String get barRequirePinSubtitle =>
      'Buri mubitsi yinjira akoresheje PIN ye y\'imibare 6 mbere yo kongera kuri fagitire.';

  @override
  String get barFloorFirstTitle => 'Fungura ishusho y\'ameza winjiye';

  @override
  String get barFloorFirstSubtitle =>
      'Nyuma yo kwinjira na PIN, ugere ku ishusho y\'ameza aho kuba agaseke kamwe.';

  @override
  String get barManagerSettleTitle => 'PIN y\'umuyobozi irakenewe mu kwishyuza';

  @override
  String get barManagerSettleSubtitle =>
      'PIN y\'umuyobozi yonyine ni yo ishobora kwakira ubwishyu no gufunga ameza.';

  @override
  String get barAutoLogoutTitle =>
      'Sohoka byikora nyuma yo kubika kuri fagitire';

  @override
  String get barAutoLogoutSubtitle =>
      'Subira ku gufunga na PIN nyuma yo Kubika kuri fagitire.';

  @override
  String get barAdminFloorTables => 'Icyumba n\'ameza';

  @override
  String get barAdminStaffPins => 'Abakozi na PIN';

  @override
  String get barNoStaffYet =>
      'Nta bakozi barabaho. Ongeramo abakoresha mu Icungamakoresha — bazagaragara hano bafite PIN zabo.';

  @override
  String get barOpenPosWithBarMode => 'Fungura POS mu buryo bw\'akabari';

  @override
  String get barTableServiceTitle => 'Serivisi ku meza (uburyo bw\'akabari)';

  @override
  String barModeDescription(String hotkey) {
    return 'Ihindura kasi ikaba mashini y\'akabari isangiwe: abakozi bafungurira buri meza konti, bandika ibyo batanze bakoresheje PIN zabo, kandi basimburana batabuze fagitire. Bireke bifunze ku igurisha risanzwe. Kuri clavier, $hotkey ihinduranya Bar → Hoteli → POS utagarutse hano.';
  }

  @override
  String barCloseTabBeforeDeleting(String table) {
    return 'Funga fagitire ifunguye ya $table mbere yo kuyisiba.';
  }

  @override
  String barSaveTableFailed(String table, String error) {
    return 'Ntibyashobotse kubika $table: $error';
  }

  @override
  String get barDeleteTableQuestion => 'Gusiba ameza?';

  @override
  String barRemoveTableBody(String table) {
    return 'Kuraho $table ku ishusho y\'icyumba?';
  }

  @override
  String barCloseZoneTabsBeforeDeleting(String zone) {
    return 'Funga fagitire zifunguye muri $zone mbere yo gusiba aka gace.';
  }

  @override
  String get barDeleteZoneQuestion => 'Gusiba agace?';

  @override
  String barRemoveZoneBody(String zone, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ameza $count',
      one: 'ameza 1',
    );
    return 'Kuraho $zone n\'$_temp0 yaho?';
  }

  @override
  String get barDeleteZone => 'Siba agace';

  @override
  String get barNoTablesConfiguredYet => 'Nta meza arashyirwaho.';

  @override
  String get barLoadDefaultFloorPlan => 'Shyiraho ishusho isanzwe y\'icyumba';

  @override
  String get barAddZone => 'Ongeraho agace';

  @override
  String barTablesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ameza $count',
      one: 'Ameza 1',
    );
    return '$_temp0';
  }

  @override
  String get barAddTable => 'Ongeraho ameza';

  @override
  String get barDeleteTable => 'Siba ameza';

  @override
  String get barSeatsLabel => 'INTEBE';

  @override
  String get barZoneName => 'Izina ry\'agace';

  @override
  String get barZoneNameHint => 'urugero: Imbuga';

  @override
  String get barSettleNeedsManagerPin =>
      'Kwishyuza fagitire bisaba PIN y\'umuyobozi.';

  @override
  String get barCanSettleBills => 'ashobora kwishyuza fagitire';

  @override
  String get barLogsOrders => 'yandika komande';

  @override
  String get barWrongPinTryAgain => 'PIN siyo — ongera ugerageze';

  @override
  String get barSelectYourName => 'Hitamo izina ryawe';

  @override
  String get barOpenStatus => 'Irafunguye';

  @override
  String barSeatsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Intebe $count',
      one: 'Intebe 1',
    );
    return '$_temp0';
  }

  @override
  String barOpenedAt(String time) {
    return 'Yafunguwe saa $time';
  }

  @override
  String barOpenedAtBy(String time, String name) {
    return 'Yafunguwe saa $time na $name';
  }

  @override
  String barElapsedOpen(String elapsed) {
    return 'imaze $elapsed ifunguye';
  }

  @override
  String barItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibintu $count',
      one: 'Ikintu 1',
    );
    return '$_temp0';
  }

  @override
  String get barTapProductsToStartTab => 'Kanda ku bicuruzwa utangire fagitire';

  @override
  String get barViewTab => 'Reba fagitire';

  @override
  String get hotelAutoRoomChargeOff =>
      'Kwishyuza icyumba byikora birafunze — koresha + Amafaranga y\'icyumba';

  @override
  String hotelRoomChargeNotPosted(String error) {
    return 'Amafaranga y\'icyumba ntiyanditswe: $error';
  }

  @override
  String hotelRoomHeldFor(String room, String guest) {
    return 'Icyumba $room gifatiwe $guest';
  }

  @override
  String get hotelSmsOutOfCredits =>
      'SMS ntiyoherejwe — ishami ryashiriwe n\'inguzanyo';

  @override
  String hotelQuotationNotSent(String reference) {
    return '$reference ntiyoherejwe — ongera ugerageze';
  }

  @override
  String hotelQuotationEmailed(String reference, String email) {
    return '$reference yoherejwe kuri imeyili $email';
  }

  @override
  String hotelQuotationEmailFailed(String reference, String error) {
    return 'Ntibyashobotse kohereza $reference kuri imeyili: $error';
  }

  @override
  String hotelQuotationBooked(String reference, String room) {
    return '$reference yemejwe · Icyumba $room cyafatiwe';
  }

  @override
  String hotelRoomNoLongerOnBranch(String room) {
    return 'Icyumba $room ntikikiri muri iri shami';
  }

  @override
  String hotelRoomCheckedOut(String room) {
    return 'Umushyitsi yasohotse mu cyumba $room';
  }

  @override
  String get hotelSignInWithPinToOpenDesk =>
      'Injira ukoresheje PIN yawe ngo ufungure ibiro by\'abakira';

  @override
  String get hotelQuotationPdfTitle => 'INYEMEZABICIRO';

  @override
  String get hotelPreparedFor => 'Byateguriwe';

  @override
  String get hotelRoom => 'Icyumba';

  @override
  String get hotelArrival => 'Kuhagera';

  @override
  String get hotelDeparture => 'Kugenda';

  @override
  String get hotelNights => 'Amajoro';

  @override
  String hotelNightsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Amajoro $count',
      one: 'Ijoro 1',
    );
    return '$_temp0';
  }

  @override
  String get hotelGuests => 'Abashyitsi';

  @override
  String get hotelStay => 'Igihe cyo kuguma';

  @override
  String hotelAdultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Abantu bakuru $count',
      one: 'Umuntu mukuru 1',
    );
    return '$_temp0';
  }

  @override
  String hotelChildrenCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Abana $count',
      one: 'Umwana 1',
    );
    return '$_temp0';
  }

  @override
  String hotelQuotationRoomLine(String room, String nights, String rate) {
    return 'Icyumba $room — $nights × $rate';
  }

  @override
  String get hotelExtras => 'Ibindi byongeweho';

  @override
  String get hotelDescription => 'Ibisobanuro';

  @override
  String get hotelTotal => 'Igiteranyo';

  @override
  String get hotelQuotationHoldsNoRoom =>
      'Iyi nyemezabiciro ntifatira icyumba kugeza yemewe.';

  @override
  String hotelQuotationExpiredOn(String date) {
    return 'Yarangiye $date';
  }

  @override
  String hotelQuotationValidUntil(String date) {
    return 'Ifite agaciro kugeza $date';
  }

  @override
  String get hotelNote => 'Icyitonderwa';

  @override
  String get hotelQuotationTerms =>
      'Ibiciro ni ku cyumba ku ijoro kandi biterwa n\'imyanya ihari. Inyemezabiciro ntifatira icyumba kugeza yemewe kandi yemejwe n\'abakira abashyitsi.';

  @override
  String get hotelManagerApprovedToast =>
      'Umuyobozi yemeje — kanda Gusohoka kugira ngo wishyure';

  @override
  String hotelCalendarTapFreeNight(String month) {
    return 'Kanda ijoro riri ubusa ngo ufatire icyumba · $month';
  }

  @override
  String get hotelLegendFree => 'Kirimo ubusa';

  @override
  String get hotelLegendReserved => 'Cyafatiwe';

  @override
  String get hotelLegendInHouse => 'Kirimo umushyitsi';

  @override
  String get hotelLegendBlocked => 'Cyafunzwe';

  @override
  String get hotelToday => 'Uyu munsi';

  @override
  String get hotelNoRoomsYet => 'Nta byumba biri muri iri shami kugeza ubu.';

  @override
  String hotelFreeRoomsCount(int count) {
    return '$count birimo ubusa';
  }

  @override
  String hotelCalendarFreeTapToHold(String room) {
    return 'Kirimo ubusa — kanda ngo ufatire $room';
  }

  @override
  String get hotelBlockedForMaintenance => 'Cyafunzwe kubera gusanwa';

  @override
  String get hotelTodayAtProperty => 'Uyu munsi kuri hoteli';

  @override
  String get hotelGoodDay => 'Umunsi mwiza';

  @override
  String hotelGoodDayName(String name) {
    return 'Umunsi mwiza, $name';
  }

  @override
  String hotelOccupancySummary(int occupied, int sellable, int guests) {
    String _temp0 = intl.Intl.pluralLogic(
      guests,
      locale: localeName,
      other: 'Abashyitsi $guests',
      one: 'Umushyitsi 1',
    );
    return 'Ibyumba $occupied kuri $sellable bicururizwa birimo abantu · $_temp0 bari muri hoteli';
  }

  @override
  String get hotelOccupancy => 'by\'ibyumba bikoreshwa';

  @override
  String get hotelArrivalsToday => 'Abagera uyu munsi';

  @override
  String hotelInNextSevenDays(int count) {
    return '$count mu minsi 7 iri imbere';
  }

  @override
  String get hotelDeparturesToday => 'Abagenda uyu munsi';

  @override
  String hotelOverdueCount(int count) {
    return '$count barengeje igihe';
  }

  @override
  String get hotelNoneOverdue => 'nta warengeje igihe';

  @override
  String get hotelAvailableRooms => 'Ibyumba biboneka';

  @override
  String hotelAwaitingCleaningCount(int count) {
    return '$count bitegereje isuku';
  }

  @override
  String get hotelPendingPayments => 'Ubwishyu butegerejwe';

  @override
  String hotelOpenFoliosCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fagitire $count zifunguye',
      one: 'Fagitire 1 ifunguye',
    );
    return '$_temp0';
  }

  @override
  String get hotelRoomRevenueTonight => 'Amafaranga y\'ibyumba iri joro';

  @override
  String get hotelContractedInHouse =>
      'byumvikanyweho ku bashyitsi bari muri hoteli';

  @override
  String get hotelOpenQuotations => 'Inyemezabiciro zifunguye';

  @override
  String hotelAmountQuoted(String amount) {
    return '$amount byatanzwe mu nyemezabiciro';
  }

  @override
  String hotelStaysPastDeparture(int count, String rooms) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Abashyitsi $count barengeje',
      one: 'Umushyitsi 1 yarengeje',
    );
    return '$_temp0 igihe cyo kugenda — $rooms';
  }

  @override
  String hotelRoomNamed(String room) {
    return 'Icyumba $room';
  }

  @override
  String get hotelOpenBoard => 'Fungura urutonde';

  @override
  String get hotelArrivingToday => 'Bagera uyu munsi';

  @override
  String get hotelNoArrivalsToday =>
      'Nta bashyitsi bateganyijwe kugera uyu munsi.';

  @override
  String get hotelDepartingToday => 'Bagenda uyu munsi';

  @override
  String get hotelNoDeparturesToday =>
      'Nta muntu uteganyijwe kugenda uyu munsi.';

  @override
  String get hotelOverdue => 'yarengeje igihe';

  @override
  String get hotelCharges => 'Ibyishyurwa';

  @override
  String hotelItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibintu $count',
      one: 'Ikintu 1',
    );
    return '$_temp0';
  }

  @override
  String get hotelBackToRooms => 'Subira ku byumba';

  @override
  String hotelFolioOpenedBy(String name) {
    return 'Fagitire · yafunguwe na $name';
  }

  @override
  String get hotelFrontDesk => 'abakira abashyitsi';

  @override
  String get hotelNoChargesYet =>
      'Nta byishyurwa biraba. Andika igiciro cy\'icyumba kugira ngo utangire iyi fagitire.';

  @override
  String get hotelAutoRoomChargeOffHelp =>
      'Kwishyuza icyumba byikora birafunze muri iri shami.\nKoresha + Igiciro cy\'icyumba hejuru, cyangwa ubyongere ufungure muri Igenamiterere → Uburyo bwa hoteli.';

  @override
  String get hotelCancelStay => 'Hagarika kuguma';

  @override
  String get hotelSettling => 'Birishyurwa…';

  @override
  String hotelCheckOutAmount(String amount) {
    return 'Sezerera · $amount';
  }

  @override
  String get hotelPosting => 'Birandikwa…';

  @override
  String get hotelFolioNotFound =>
      'Fagitire ntiyabonetse — ongera ufungure icyumba ugerageze';

  @override
  String hotelCheckoutFailed(String error) {
    return 'Gusezerera byanze: $error';
  }

  @override
  String get hotelFrontDeskSharedRegister => 'Iyakira · Kasi isangiwe';

  @override
  String get hotelLockHintEnterPin =>
      'Andika PIN yawe y\'imibare 6 kugira ngo ufungure iyakira';

  @override
  String get hotelWhosOnDeskEyebrow => 'NINDE URI KU IYAKIRA?';

  @override
  String get hotelWhosOnDesk => 'Ninde uri ku iyakira?';

  @override
  String get hotelSignInToReception => 'Injira mu iyakira';

  @override
  String get hotelNoStaffToShow =>
      'Nta bakozi bagaragara. Ongeramo abakoresha mu Icungamakoresha — bazagaragara hano bafite PIN zabo. Niba iki gikoresho kidafite murandasi, gihuze rimwe kugira ngo abakozi bazashobore kwinjira nta murandasi.';

  @override
  String get hotelConfiguredByAdmin =>
      'Uburyo bwa hoteli bwashyizweho n\'umuyobozi kuri mashini nkuru';

  @override
  String get hotelQuoteNew => 'Gishya';

  @override
  String get hotelNewQuotation => 'Inyemezabiciro nshya';

  @override
  String get hotelQuotations => 'Inyemezabiciro';

  @override
  String hotelQuotationsOpenSummary(int count) {
    return '$count zifunguye · inyemezabiciro ntifatira icyumba kugeza yemewe';
  }

  @override
  String get hotelNoQuotationsYet =>
      'Nta nyemezabiciro irabaho.\nKora imwe kugira ngo uhe umushyitsi igiciro cyo kuguma mbere y\'uko yemeza.';

  @override
  String get hotelQuoteStatusBooked => 'Byafashwe';

  @override
  String get hotelQuoteStatusExpired => 'Byarangiye';

  @override
  String get hotelQuoteStatusDeclined => 'Byanzwe';

  @override
  String get hotelQuoteStatusAccepted => 'Byemewe';

  @override
  String get hotelQuoteStatusSent => 'Byoherejwe';

  @override
  String get hotelQuoteStatusDraft => 'Imbanziriza';

  @override
  String hotelRoomWithType(String room, String type) {
    return 'Icyumba $room · $type';
  }

  @override
  String hotelQuoteEmailedAt(String date) {
    return 'Yoherejwe kuri imeyili $date';
  }

  @override
  String hotelQuoteValidTo(String date) {
    return 'igeza ku wa $date';
  }

  @override
  String get hotelQuoteDocument => 'Inyandiko';

  @override
  String get hotelQuoteEmailToGuest => 'Ohereza umushyitsi kuri imeyili';

  @override
  String get hotelQuoteEmailPdfToGuest => 'Ohereza umushyitsi PDF kuri imeyili';

  @override
  String get hotelQuoteAddEmailFirst => 'Banza wongeremo imeyili';

  @override
  String get hotelQuoteDownloadPdf => 'Kuramo PDF';

  @override
  String get hotelQuotePrint => 'Capa';

  @override
  String get hotelQuoteOpenPrintDialog => 'Fungura idirishya ryo gucapa';

  @override
  String hotelQuotationHeader(String reference) {
    return 'INYEMEZABICIRO $reference';
  }

  @override
  String get hotelEmailLooksWrong => 'Iyo imeyili ntisa n\'iyemewe';

  @override
  String get hotelEmailThisQuotation =>
      'Ohereza iyi nyemezabiciro kuri imeyili';

  @override
  String get hotelPdfGoesAsAttachment => 'PDF yoherezwa nk\'umugereka.';

  @override
  String get hotelGuestEmail => 'Imeyili y\'umushyitsi';

  @override
  String get hotelEmailSavedToQuotation =>
      'Ibikwa mu nyemezabiciro, ku buryo ubutaha utazongera kuyandika.';

  @override
  String get hotelSendQuotation => 'Ohereza inyemezabiciro';

  @override
  String get hotelAcceptAndHold => 'Emera ufatire';

  @override
  String hotelRemoveQuotationTitle(String reference) {
    return 'Gusiba $reference?';
  }

  @override
  String hotelRemoveQuotationBody(String guest) {
    return 'Ibi bisiba inyemezabiciro ya $guest. Icyumba cyose cyamaze gufatirwa ntikizahinduka.';
  }

  @override
  String get hotelPreparingQuotation => 'Gutegura inyemezabiciro…';

  @override
  String get hotelQuotation => 'Inyemezabiciro';

  @override
  String hotelQuotationRef(String reference) {
    return 'Inyemezabiciro $reference';
  }

  @override
  String get hotelEmailUs => 'twe';

  @override
  String hotelEmailValidUntil(String date) {
    return 'Iyi nyemezabiciro igeza ku wa $date.';
  }

  @override
  String hotelEmailYourQuotation(String reference) {
    return 'Inyemezabiciro yawe, $reference';
  }

  @override
  String hotelEmailHtmlIntro(
    String guest,
    String business,
    String room,
    String nights,
  ) {
    return 'Muraho $guest, murakoze gutekereza kuri $business. Inyemezabiciro yanyu y\'icyumba $room mu $nights iri ku mugereka nka PDF.';
  }

  @override
  String get hotelEmailHoldsNoRoom =>
      'Inyemezabiciro ntifatira icyumba kugeza yemewe — subiza iyi imeyili cyangwa uduhamagare kugira ngo wemeze.';

  @override
  String hotelEmailHello(String guest) {
    return 'Muraho $guest,';
  }

  @override
  String hotelEmailPlainIntro(String business, String reference, String room) {
    return 'Murakoze gutekereza kuri $business. Inyemezabiciro yanyu $reference y\'icyumba $room iri ku mugereka nka PDF.';
  }

  @override
  String get hotelEmailPlainHoldsNoRoom =>
      'Inyemezabiciro ntifatira icyumba kugeza yemewe — dusubize cyangwa uduhamagare kugira ngo wemeze.';

  @override
  String get hotelFrontDeskTitle => 'Iyakira';

  @override
  String hotelBoardSubtitle(String fraction) {
    return '$fraction birimo abantu · kanda icyumba wakire umushyitsi cyangwa ufungure fagitire yacyo';
  }

  @override
  String hotelOccupiedFraction(String fraction) {
    return '$fraction birimo abantu';
  }

  @override
  String hotelRoleOnDuty(String role) {
    return '$role · ari ku kazi';
  }

  @override
  String get hotelReception => 'Iyakira';

  @override
  String get hotelSettings => 'Igenamiterere';

  @override
  String get hotelHandOver => 'Simburwa';

  @override
  String get hotelHandOverDesk => 'Simburwa ku iyakira';

  @override
  String hotelCouldNotLoadBoard(String error) {
    return 'Ntibyashobotse gufungura urutonde.\n$error';
  }

  @override
  String get hotelGuestNameRequired => 'Izina ry\'umushyitsi rirakenewe';

  @override
  String hotelRoomMaxCapacity(String room, String capacity) {
    return 'Icyumba $room: umubare ntarengwa ni $capacity';
  }

  @override
  String get hotelEmailInvalid => 'Iyi imeyili ntisa neza';

  @override
  String hotelCheckInTitle(String room) {
    return 'Kwakira umushyitsi · Icyumba $room';
  }

  @override
  String hotelRoomTypeSleeps(String type, String capacity) {
    return '$type · abantu $capacity';
  }

  @override
  String get hotelGuestName => 'Izina ry\'umushyitsi';

  @override
  String get hotelGuestNameHint => 'urugero: Aline Uwase';

  @override
  String get hotelPhoneOptional => 'Telefoni (si ngombwa)';

  @override
  String get hotelEmailOptional => 'Imeyili (si ngombwa)';

  @override
  String get hotelSendsConfirmationHint => 'Yoherezwaho icyemezo';

  @override
  String get hotelAdults => 'Abakuru';

  @override
  String get hotelChildren => 'Abana';

  @override
  String get hotelRatePerNightRwf => 'Igiciro cy\'ijoro rimwe (RWF)';

  @override
  String get hotelCheckInGuest => 'Akira umushyitsi';

  @override
  String get hotelRoomCharge => 'Igiciro cy\'icyumba';

  @override
  String get hotelNavToday => 'Uyu munsi';

  @override
  String get hotelNavRooms => 'Ibyumba';

  @override
  String get hotelNavCalendar => 'Kalendari';

  @override
  String get hotelNavQuotes => 'Ibiciro';

  @override
  String get hotelDueOut => 'Agomba kugenda';

  @override
  String get hotelRate => 'Igiciro';

  @override
  String hotelPriceEach(String price) {
    return '$price kuri kimwe';
  }

  @override
  String get hotelTaxIncl => 'Umusoro (urimo)';

  @override
  String get hotelFolioTotal => 'Igiteranyo cya fagitire';

  @override
  String get hotelCheckOut => 'Sezerera umushyitsi';

  @override
  String hotelFolioTotalAmount(String amount) {
    return 'Igiteranyo cya fagitire $amount';
  }

  @override
  String get hotelPaymentCard => 'Ikarita';

  @override
  String get hotelChangeDue => 'Amafaranga yo kugarura';

  @override
  String get hotelSettleAndRelease => 'Ishyura urekure icyumba';

  @override
  String get hotelOutOfOrder => 'Ntikora';

  @override
  String get hotelHkClean => 'Gisukuye';

  @override
  String get hotelHkCleanMeaning =>
      'Cyiteguye — ushobora kwakiramo umushyitsi.';

  @override
  String get hotelHkDirty => 'Gikeneye isuku';

  @override
  String get hotelHkDirtyMeaning =>
      'Ntikigurishwa kugeza abakora isuku bakirekuye.';

  @override
  String get hotelHkInspected => 'Cyagenzuwe';

  @override
  String get hotelHkInspectedMeaning =>
      'Cyasukuwe kandi kigenzurwa n\'umugenzuzi. Gishobora kugurishwa.';

  @override
  String get hotelHkOutOfOrderMeaning =>
      'Gifunzwe kubera gusanwa. Ntigihabwa umushyitsi.';

  @override
  String hotelHousekeepingTitle(String room) {
    return 'Isuku · Icyumba $room';
  }

  @override
  String hotelOccupiedNotice(String guest) {
    return '$guest ari muri iki cyumba. Banza umusezerere mbere yo kugifunga ngo gisanwe.';
  }

  @override
  String get hotelUnavailableWhileOccupied =>
      'Ntibishoboka igihe icyumba kirimo umushyitsi.';

  @override
  String get hotelManager => 'Umuyobozi';

  @override
  String get hotelEnterManagerPin => 'Andika PIN y\'umuyobozi y\'imibare 6';

  @override
  String get hotelNotManagerPin => 'Iyi si PIN y\'umuyobozi';

  @override
  String get hotelManagerApproval => 'Kwemezwa n\'umuyobozi';

  @override
  String get hotelSettleNeedsManagerPin =>
      'Kwishyuza fagitire bisaba PIN y\'umuyobozi.';

  @override
  String get hotelModeAlongsideBar =>
      'Uburyo bwa Hoteli bwafunguwe hamwe n\'ubwa Bar — hitamo hepfo icyo iki gikoresho kizakoresha.';

  @override
  String get hotelHouseCheckoutTime => 'Isaha yo gusohoka muri hoteli';

  @override
  String get hotelAdminLodging => 'Icumbi';

  @override
  String get hotelAdminRoomsFloors => 'Ibyumba n\'amagorofa';

  @override
  String get hotelAdminRatesBilling => 'Ibiciro n\'inyemezabuguzi';

  @override
  String get hotelAdminGuestNotifications => 'Ubutumwa ku bashyitsi';

  @override
  String get hotelAdminCompanyStamp => 'Kashe y\'ikigo';

  @override
  String get hotelAutoPostTitle =>
      'Andika igiciro cy\'icyumba umushyitsi akigera';

  @override
  String get hotelAutoPostSubtitle =>
      'Ishyira amajoro × igiciro kuri fagitire umushyitsi akimara gufata urufunguzo.';

  @override
  String get hotelRequirePinTitle => 'Saba PIN mu guhindura ukora';

  @override
  String get hotelRequirePinSubtitle =>
      'Kasi isangiwe: aho kwakirira hafunguka hasaba PIN, kandi umukozi uwo ari we wese ashobora kwinjira.';

  @override
  String get hotelManagerCheckoutTitle =>
      'Umuyobozi arakenewe mu kwishyuza fagitire';

  @override
  String get hotelManagerCheckoutSubtitle =>
      'Umuyobozi wenyine ni we ushobora kwakira ubwishyu no kurekura icyumba umushyitsi agenda.';

  @override
  String get hotelAutoLogoutTitle => 'Funga aho kwakirira nyuma yo gusezerera';

  @override
  String get hotelAutoLogoutSubtitle =>
      'Isubira ku gufunga na PIN umushyitsi akimara gusezererwa.';

  @override
  String get hotelRoomChargeProduct => 'Igicuruzwa cy\'igiciro cy\'icyumba';

  @override
  String hotelCheckoutDefaultSubtitle(String time) {
    return 'Igihe gisanzwe cyo kugenda ni $time nyuma y\'ijoro rya nyuma.';
  }

  @override
  String get hotelOpenFrontDesk => 'Fungura aho kwakirira';

  @override
  String get hotelLoading => 'Biri kuza…';

  @override
  String get hotelRoomChargeNotSet =>
      'Ntibyashyizweho — ibiciro by\'ibyumba ntibishobora kwandikwa utarahitamo igicuruzwa cyanditswe.';

  @override
  String hotelRoomChargeMissing(String id) {
    return 'Igicuruzwa $id ntikikiri muri iri shami. Hitamo ikindi.';
  }

  @override
  String get hotelNotifyEmailTitle =>
      'Oherereza umushyitsi icyemezo kuri imeyili';

  @override
  String get hotelNotifyEmailSubtitle =>
      'Ni ubuntu. Byoherezwa igihe cyose umushyitsi yatanze imeyili.';

  @override
  String get hotelNotifySmsTitle => 'Oherereza umushyitsi icyemezo kuri SMS';

  @override
  String get hotelNotifySmsSubtitle =>
      'Bitwara inguzanyo 30 kuri buri butumwa. Bizima kugeza ubifunguye.';

  @override
  String get hotelNotifyReserveTitle => 'Emeza igihe icyumba gifatiwe';

  @override
  String get hotelNotifyReserveSubtitle =>
      'Byoherezwa mu gihe umushyitsi uzaza afatiwe icyumba.';

  @override
  String get hotelNotifyCheckInTitle => 'Ha ikaze umushyitsi akigera';

  @override
  String get hotelNotifyCheckInSubtitle =>
      'Byoherezwa igihe umushyitsi afashe urufunguzo koko.';

  @override
  String get hotelStampTitle => 'Shyira kashe ku bigereranyabiciro na proforma';

  @override
  String get hotelStampUploadFirst =>
      'Banza ushyireho kashe hepfo, hanyuma ufungure ibi.';

  @override
  String get hotelStampDrawnOn =>
      'Ishyirwa ku rupapuro rwa nyuma rwa buri nyandiko ikozwe.';

  @override
  String get hotelNoStamp => 'Nta kashe';

  @override
  String get hotelStampUnreadable => 'Ntisomeka';

  @override
  String hotelStampSizeHint(String size) {
    return 'PNG cyangwa JPEG iri munsi ya ${size}KB. PNG ibonerana ni yo nziza.';
  }

  @override
  String get hotelUpload => 'Shyiraho';

  @override
  String get hotelReplace => 'Simbuza';

  @override
  String get hotelStampBottomRight => 'Hasi iburyo';

  @override
  String get hotelStampBottomLeft => 'Hasi ibumoso';

  @override
  String get hotelStampBottomCentre => 'Hasi hagati';

  @override
  String get hotelStampBesideTotal => 'Iruhande rw\'igiteranyo';

  @override
  String get hotelStampPosition => 'Aho ishyirwa';

  @override
  String get hotelStampWidth => 'Ubugari';

  @override
  String get hotelStampUpdated => 'Kashe y\'ikigo yavuguruwe.';

  @override
  String get hotelStampSavedLocalOnly =>
      'Kashe yabitswe kuri iki gikoresho gusa — ibindi bikoresho ntibizayikoresha.';

  @override
  String hotelStampSetFailed(String error) {
    return 'Gushyiraho kashe byanze: $error';
  }

  @override
  String get hotelStampRemoved => 'Kashe y\'ikigo yakuweho.';

  @override
  String get hotelStampRemovedLocalOnly =>
      'Kashe yakuweho kuri iki gikoresho gusa — ibindi bikoresho biracyayifite.';

  @override
  String get hotelStampSavedDeviceOnly =>
      'Kashe yabitswe kuri iki gikoresho gusa.';

  @override
  String get hotelModeTitle => 'Uburyo bwa Hoteli (Aho kwakirira)';

  @override
  String get hotelOnBadge => 'BIRAKORA';

  @override
  String hotelModeDescription(String hotkey) {
    return 'Ihindura kasi ikaba aho kwakirira abashyitsi: urutonde rw\'ibyumba ku igorofa, kwakira umushyitsi n\'amatariki, fagitire ifunguye kuri buri kuguma bar na resitora bishobora kwandikaho, no kwishyura umushyitsi agenda. Isimbura uburyo bwa Bar n\'igurisha risanzwe muri iri shami. Kuri clavier, $hotkey ihinduranya Bar → Hoteli → POS utagarutse hano.';
  }

  @override
  String get hotelPickRoomToQuote => 'Hitamo icyumba cyo gushyira ku giciro';

  @override
  String get hotelEditQuotation => 'Hindura igereranyabiciro';

  @override
  String get hotelQuotationIntro =>
      'Ni igiciro gitanzwe. Nta cyumba gifatirwa kugeza umushyitsi acyemeye.';

  @override
  String get hotelQuotationEmailHint => 'Aho PDF y\'igereranyabiciro yoherezwa';

  @override
  String get hotelRatePerNightShort => 'Igiciro / ijoro';

  @override
  String get hotelValidForDays => 'Igihe kimara (iminsi)';

  @override
  String get hotelSaveQuotation => 'Bika igereranyabiciro';

  @override
  String get hotelUpdateQuotation => 'Vugurura igereranyabiciro';

  @override
  String hotelRoomsAvailableForDates(String count) {
    return 'Icyumba · $count biboneka kuri aya matariki';
  }

  @override
  String hotelNoRoomFree(String count) {
    return 'Nta cyumba cyakira abantu $count kiboneka kuri ayo matariki.';
  }

  @override
  String hotelNightsQuoted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Amajoro $count yabariwe',
      one: 'Ijoro 1 ryabariwe',
    );
    return '$_temp0';
  }

  @override
  String get hotelDatesTaken => 'Ayo matariki yamaze gufatwa kuri iki cyumba';

  @override
  String hotelReserveTitle(String room) {
    return 'Fatira · Icyumba $room';
  }

  @override
  String get hotelHoldRoom => 'Fatira icyumba';

  @override
  String hotelRoomTakenBetween(String room, String from, String to) {
    return 'Icyumba $room cyamaze gufatwa hagati ya $from na $to.';
  }

  @override
  String hotelGuestsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Abashyitsi $count',
      one: 'Umushyitsi 1',
    );
    return '$_temp0';
  }

  @override
  String hotelRoomSemantic(String room, String type, String state) {
    return 'Icyumba $room, $type, $state';
  }

  @override
  String get hotelTapToCheckIn => 'kanda kugira ngo wakire umushyitsi';

  @override
  String hotelDueOutAt(String time) {
    return 'Agomba kugenda $time';
  }

  @override
  String hotelOutOn(String date) {
    return 'Agenda $date';
  }

  @override
  String get hotelAwaitingHousekeeping => 'Gitegereje isuku';

  @override
  String hotelPerNight(String amount) {
    return '$amount / ijoro';
  }

  @override
  String get hotelNoActiveBranch => 'Nta shami rikora';

  @override
  String get hotelRoomChargeIntro =>
      'Igiciro cy\'ijoro cyishyurirwa kuri iki gicuruzwa, bityo kigomba kuba cyanditswe muri RRA.';

  @override
  String get hotelNoProductsFound => 'Nta bicuruzwa byabonetse.';

  @override
  String get hotelNotRegisteredWithRra =>
      'Ntikanditswe muri RRA — banza ukandike';

  @override
  String hotelRoomIsState(String room, String state) {
    return 'Icyumba $room: $state';
  }

  @override
  String hotelCheckInGuestQuestion(String guest) {
    return 'Wakira $guest?';
  }

  @override
  String hotelReservedArrivalBody(String room) {
    return 'Icyumba $room kiramufatiwe. Kumwakira bifungura fagitire kandi bikandika igiciro cy\'icyumba.';
  }

  @override
  String get hotelNotYet => 'Si ubu';

  @override
  String get hotelCheckIn => 'Akira';

  @override
  String hotelRoomSavedNotRegistered(String room, String error) {
    return 'Icyumba $room cyabitswe, ariko ntikanditswe muri RRA: $error';
  }

  @override
  String get hotelNewFloorOrWing => 'Igorofa cyangwa igice gishya';

  @override
  String hotelRoomHasGuest(String room) {
    return 'Icyumba $room kirimo umushyitsi cyangwa kirafatiwe. Banza umusezerere.';
  }

  @override
  String hotelDeleteRoomQuestion(String room) {
    return 'Siba icyumba $room?';
  }

  @override
  String get hotelDeleteRoomBody =>
      'Kiravanwa ku rutonde, kuri kalendari no mu byumba biboneka. Abashyitsi babanje n\'inyemezabuguzi zabo ntibihinduka.';

  @override
  String hotelRoomStillHasGuest(String room) {
    return 'Icyumba $room kiracyarimo umushyitsi cyangwa kirafatiwe.';
  }

  @override
  String hotelDeleteFloorQuestion(String floor) {
    return 'Siba $floor?';
  }

  @override
  String hotelDeleteFloorBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bisiba ibyumba $count kuri iyi gorofa.',
      one: 'Bisiba icyumba 1 kuri iyi gorofa.',
    );
    return '$_temp0';
  }

  @override
  String get hotelStarterPlanBody =>
      'Tangirira ku gishushanyo cy\'ibyumba 15 ku magorofa atatu, hanyuma uhindure nimero, ubwoko n\'ibiciro bihuye n\'inyubako yawe.';

  @override
  String get hotelCreateStarterPlan => 'Kora igishushanyo cy\'ibanze';

  @override
  String hotelRoomsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibyumba $count',
      one: 'Icyumba 1',
    );
    return '$_temp0';
  }

  @override
  String get hotelDeleteFloor => 'Siba igorofa';

  @override
  String get hotelAddRoom => 'Ongeraho icyumba';

  @override
  String get hotelAddFloorOrWing => 'Ongeraho igorofa cyangwa igice';

  @override
  String get hotelFloorNameHint => 'urugero: Igorofa rya kabiri';

  @override
  String get hotelRequired => 'Birakenewe';

  @override
  String get hotelInUse => 'Irakoreshwa';

  @override
  String get hotelRoomNoHint => 'Nº';

  @override
  String get hotelRoomTypeHint => 'Ubwoko';

  @override
  String get hotelRegisteredWithRra =>
      'Cyanditswe muri RRA nka serivisi isoreshwa umusoro w\'ubukerarugendo';

  @override
  String get hotelNotRegisteredTapToRegister =>
      'Ntikanditswe muri RRA — kanda ukandike';

  @override
  String get hotelCannotDeleteOccupied =>
      'Kirimo umushyitsi cyangwa kirafatiwe — ntigishobora gusibwa';

  @override
  String get hotelDeleteRoom => 'Siba icyumba';

  @override
  String get hotelStateVacant => 'Kirimo ubusa';

  @override
  String get hotelStateOccupied => 'Kirimo umushyitsi';

  @override
  String get hotelStateReserved => 'Cyafatiwe';

  @override
  String get hotelStateCleaning => 'Kiri gusukurwa';

  @override
  String get hotelAllFloors => 'Amagorofa yose';

  @override
  String get hotelChargeToRoom => 'Andika ku cyumba';

  @override
  String get hotelChargeToRoomSubtitle =>
      'Hitamo umushyitsi fagitire ye izishyurirwamo iyi konti.';

  @override
  String get hotelStaySearchHint =>
      'Nimero y\'icyumba, izina ry\'umushyitsi cyangwa telefoni';

  @override
  String hotelStayOutLine(String summary, String date) {
    return '$summary · agenda $date';
  }

  @override
  String get hotelLookingUpGuests => 'Turi gushaka abashyitsi…';

  @override
  String get hotelNobodyCheckedIn => 'Nta mushyitsi wakiriwe';

  @override
  String get hotelReadingRooms => 'Turi gusoma ibyumba by\'iri shami.';

  @override
  String get hotelNoGuestsBody =>
      'Konti ishobora kwandikwa gusa ku mushyitsi wakiriwe. Abafatiwe ibyumba batangira kwandikirwaho bamaze kugera.';

  @override
  String hotelNoGuestMatches(String term) {
    return 'Nta mushyitsi uhuye na \"$term\"';
  }

  @override
  String get hotelSearchByHint =>
      'Shakisha ukoresheje nimero y\'icyumba, izina ry\'umushyitsi cyangwa telefoni.';

  @override
  String get creditsHubTitle => 'Ahabikwa kirediti';

  @override
  String get creditsAddCredits => 'Ongeramo kirediti';

  @override
  String get creditsAvailable => 'Kirediti zihari';

  @override
  String get creditsLabel => 'Kirediti';

  @override
  String creditsMaximum(String max) {
    return 'Ntarengwa: $max';
  }

  @override
  String get creditsEnterAmount => 'Andika amafaranga';

  @override
  String get creditsPayNow => 'Ishyura ubu';

  @override
  String get creditsEnterValidAmount => 'Nyamuneka andika amafaranga yemewe';

  @override
  String get creditsEnterValidPhone =>
      'Nyamuneka andika nimero ya telefoni yemewe';

  @override
  String get creditsPaymentRequestFailed =>
      'Ubusabe bw\'ubwishyu ntibwakunze. Nyamuneka ongera ugerageze.';

  @override
  String creditsErrorOccurred(String error) {
    return 'Habaye ikosa: $error';
  }

  @override
  String get creditsPaymentDeclined => 'Ubwishyu bwanzwe kuri telefoni yawe.';

  @override
  String get creditsPaymentSuccessful => 'Ubwishyu bwakunze';

  @override
  String get creditsPaymentInitiated => 'Ubwishyu bwatangijwe';

  @override
  String creditsPaymentRequestSent(String phone) {
    return 'Ubusabe bw\'ubwishyu bwoherejwe kuri $phone.';
  }

  @override
  String get creditsApprovePayment =>
      'Nyamuneka reba kuri telefoni yawe wemeze ubwishyu.';

  @override
  String creditsNothingCharged(String reason) {
    return '$reason Nta mafaranga yakuweho — ushobora kongera kugerageza.';
  }

  @override
  String get creditsVerificationTimedOut =>
      'Igihe cyo kugenzura ubwishyu cyarangiye. Nyamuneka uzarebe kirediti zawe nyuma.';

  @override
  String get creditsPaymentProcessed => 'Ubwishyu bwawe bwakiriwe neza!';

  @override
  String get creditsAdded => 'Kirediti zawe zongewe kuri konti yawe.';

  @override
  String get creditsQuickAdd => 'Ongeramo vuba';

  @override
  String get delegationStatusCompleted => 'Byarangiye';

  @override
  String get delegationStatusDelegated => 'Byoherejwe';

  @override
  String get delegationStatusFailed => 'Byanze';

  @override
  String get delegationFilterAll => 'Byose';

  @override
  String delegationTransactionName(String id) {
    return 'Igurisha $id';
  }

  @override
  String get delegationBannerTapToOpen => 'Kanda ufungure ibyoherejwe';

  @override
  String get delegationRetryQueued =>
      'Kongera kugerageza byashyizwe ku murongo. Nibyongera kwanga, ongera wohereze igurisha uhereye ku gikoresho cya POS.';

  @override
  String get delegationRetryError => 'Habaye ikosa mu kongera kohereza';

  @override
  String get delegationAboutTitle => 'Ibyerekeye kohereza icapa';

  @override
  String get delegationAboutBody =>
      'Kohereza icapa bituma telefoni zohereza ibyo gucapa kuri printa za mudasobwa. Ibyanze bishobora kongera koherezwa uhereye kuri iyi paji.';

  @override
  String get delegationGotIt => 'Ndabyumvise';

  @override
  String get delegationTitle => 'Kohereza icapa';

  @override
  String delegationHeaderSubtitle(String count) {
    return 'Kurikirana no gucunga ibicuruzwa byoherejwe hagati y\'amakasi yawe — $count bigaragara.';
  }

  @override
  String get delegationSearchHint =>
      'Shakisha ibyoherejwe, inyemezabwishyu, ubwishyu…';

  @override
  String get delegationFilter => 'Yungurura';

  @override
  String get delegationRetryTooltip => 'Ongera wohereze';

  @override
  String get delegationReceiptType => 'Ubwoko bw\'inyemezabwishyu';

  @override
  String get delegationEmptyTitle => 'Nta byoherejwe byabonetse';

  @override
  String get delegationEmptyDeviceHint =>
      'Ibyoherejwe kuri iki gikoresho bizagaragara hano. Abohereza bagomba guhitamo ID y\'iki gikoresho mu igenamiterere ryo kohereza.';

  @override
  String get delegationEmptyFilterHint =>
      'Gerageza irindi jambo ryo gushakisha cyangwa uhindure akayunguruzo kari hejuru ubone ibindi.';

  @override
  String get saleAgentAssignTitle => 'Shyiraho umukozi ugurisha';

  @override
  String get saleAgentAgentsSection => 'ABAKOZI BAGURISHA';

  @override
  String get saleAgentSearchHint => 'Shakisha abakozi bagurisha...';

  @override
  String get saleAgentNoAgentsForBusiness =>
      'Nta bakozi bagurisha babonetse kuri ubu bucuruzi. Ongeramo abakozi mu micungire y\'abakoresha.';

  @override
  String get saleAgentNoSearchMatch =>
      'Nta mukozi ugurisha uhuye n\'ibyo washakishije.';

  @override
  String get saleAgentCommissionSection => 'KOMISIYO';

  @override
  String get saleAgentFixedRwf => 'Ingano ihamye (RWF)';

  @override
  String get saleAgentPercent => 'Ijanisha (%)';

  @override
  String get saleAgentAmountRwf => 'Amafaranga (RWF)';

  @override
  String get saleAgentRatePercent => 'Ijanisha (%)';

  @override
  String saleAgentExample(String example) {
    return 'urugero: $example';
  }

  @override
  String get saleAgentSelectAgent => 'Hitamo umukozi ugurisha';

  @override
  String get saleAgentEnterValidCommission => 'Andika komisiyo yemewe';

  @override
  String get saleAgentPercentMax => 'Ijanisha ntirishobora kurenga 100';

  @override
  String get saleAgentApply => 'Shyiraho';

  @override
  String get saleAgentNoContact => 'Nta aderesi';

  @override
  String get saleAgentBadge => 'Umukozi ugurisha';

  @override
  String personalGoalBannerReached(String name) {
    return 'Intego yagezweho: $name';
  }

  @override
  String personalGoalBannerReachedForPeriod(String period, String name) {
    return 'Intego yagezweho kuri $period: $name';
  }

  @override
  String personalGoalBannerTargetMet(String amount) {
    return 'Intego ya $amount yagezweho';
  }

  @override
  String personalGoalBannerTargetMetRestart(String amount, String restart) {
    return 'Intego ya $amount yagezweho · $restart';
  }

  @override
  String personalGoalBannerSavedTo(String amount, String name) {
    return '+$amount byazigamiwe $name';
  }

  @override
  String personalGoalSavedOfTarget(String saved, String target) {
    return '$saved kuri $target';
  }

  @override
  String personalGoalBannerSavedSoFar(String amount) {
    return '$amount bimaze kuzigamwa';
  }

  @override
  String personalGoalBannerOneReached(String name) {
    return '$name yageze ku ntego yayo';
  }

  @override
  String personalGoalBannerManyReached(int count) {
    return 'Intego $count zagezweho';
  }

  @override
  String personalGoalBannerSavedAcross(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ntego $count',
      one: 'ntego 1',
    );
    return '+$amount byazigamwe mu $_temp0';
  }

  @override
  String get personalGoalBannerEyebrow => 'INTEGO BWITE  ·  ubu';

  @override
  String get personalGoalBannerDismiss => 'Funga';

  @override
  String personalGoalRemoteCreditNotification(String name, String amount) {
    return '$name: +$amount byazigamwe (byikora cyangwa bivuye ku kindi gikoresho)';
  }

  @override
  String get personalGoalTopPriorityEyebrow => 'IBY\'IBANZE';

  @override
  String get personalGoalSaved => 'Byazigamwe';

  @override
  String get personalGoalTarget => 'Intego';

  @override
  String get personalGoalAutoAllocation => 'Kugenera byikora';

  @override
  String personalGoalProfitReserved(String percent) {
    return '$percent% by\'inyungu byagenewe';
  }

  @override
  String get personalGoalAutoAllocationOptional =>
      'Si ngombwa — shyiraho uhindura';

  @override
  String get personalGoalUpdatedFromProfits =>
      'Byavuguruwe hashingiwe ku nyungu';

  @override
  String get personalGoalAddMoney => 'Ongeramo amafaranga';

  @override
  String get personalGoalAddMoneyCashIn => '· Amafaranga yinjiye';

  @override
  String personalGoalReachedForPeriod(String period, String restart) {
    return 'Yagezweho kuri $period · $restart';
  }

  @override
  String personalGoalLastPeriodReached(String period, String amount) {
    return '$period: $amount · yagezweho';
  }

  @override
  String personalGoalLastPeriodProgress(String period, String progress) {
    return '$period: $progress';
  }

  @override
  String get personalGoalNewGoal => 'Intego nshya';

  @override
  String get personalGoalNewGoalExamples => 'Ibikoresho, ubukode, amahugurwa…';

  @override
  String get personalGoalEditGoal => 'Hindura intego';

  @override
  String get personalGoalEditSubtitle =>
      'Vugurura amafaranga n\'igenamiterere by\'iyi ntego.';

  @override
  String get personalGoalNewSubtitle =>
      'Shyiraho izina n\'intego. Ushobora kongeramo amafaranga igihe icyo ari cyo cyose uhereye ku mafaranga yinjiye.';

  @override
  String get personalGoalNameSection => 'IZINA RY\'INTEGO';

  @override
  String get personalGoalNameLabel => 'Urizigamira iki?';

  @override
  String get personalGoalNameHint =>
      'urugero: Ikigega cy\'ingoboka, ibikoresho';

  @override
  String get personalGoalNameRequired => 'Andika izina ry\'intego';

  @override
  String get personalGoalAmountsSection => 'AMAFARANGA (RWF)';

  @override
  String get personalGoalTargetAmount => 'Amafaranga agambiriwe';

  @override
  String get personalGoalTargetRequired => 'Andika intego irenze 0';

  @override
  String get personalGoalAlreadySaved => 'Ibimaze kuzigamwa';

  @override
  String get personalGoalAlreadySavedHint => '0 — si ngombwa';

  @override
  String get personalGoalCannotBeNegative => 'Ntishobora kuba munsi ya zeru';

  @override
  String get personalGoalRepeatsSection => 'GUSUBIRAMO';

  @override
  String get personalGoalRepeats => 'Gusubiramo';

  @override
  String get personalGoalOptionalSection => 'SI NGOMBWA';

  @override
  String get personalGoalAutoAllocationPercent => 'Kugenera byikora %';

  @override
  String get personalGoalAutoAllocationHint => 'Bireke ubusa niba bidakoreshwa';

  @override
  String get personalGoalPercentRange => 'Koresha 0–100';

  @override
  String get personalGoalTopPriority => 'Iby\'ibanze';

  @override
  String get personalGoalTopPriorityHint => 'Igaragara mbere ku kibaho cyawe';

  @override
  String get personalGoalSaveChanges => 'Bika impinduka';

  @override
  String get personalGoalCreateGoal => 'Kora intego';

  @override
  String get agentCommissionPayoutsUnavailable =>
      'Amateka y\'ubwishyu ntiyashoboye kuboneka. Komisiyo yavuye ku igurisha iracyagaragara. Koresha migration ya Supabase agent_commission_payouts niba ubwishyu butabikwa.';

  @override
  String get agentCommissionEyebrow => 'ITSINDA  ·  KOMISIYO';

  @override
  String get agentCommissionTitle => 'Komisiyo z\'abakozi bacuruza';

  @override
  String get agentCommissionSubtitle =>
      'Kurikirana ibyo buri mukozi ucuruza yinjije, ibyo wamwishyuye n\'ibyo umufitiye.';

  @override
  String get agentCommissionSignOut => 'Sohoka';

  @override
  String get agentCommissionAgent => 'Umukozi';

  @override
  String get agentCommissionEarnedEyebrow => 'KOMISIYO YINJIJWE';

  @override
  String agentCommissionPaidOutPct(String percent) {
    return 'Byishyuwe · $percent %';
  }

  @override
  String agentCommissionBalanceDuePct(String percent) {
    return 'Ibisigaye kwishyurwa · $percent %';
  }

  @override
  String get agentCommissionPaidOutEyebrow => 'BYISHYUWE';

  @override
  String get agentCommissionBalanceDueEyebrow => 'IBISIGAYE KWISHYURWA';

  @override
  String get agentCommissionAllSettled => 'Byose byishyuwe';

  @override
  String get agentCommissionRecordPayout => 'Andika ubwishyu';

  @override
  String get agentCommissionAttributedSales => 'IGURISHA RYITIRIWE';

  @override
  String agentCommissionPendingCount(int count) {
    return '$count bitegereje';
  }

  @override
  String get agentCommissionExport => 'Ohereza hanze';

  @override
  String get agentCommissionColDate => 'ITARIKI';

  @override
  String get agentCommissionColReceipt => 'INYEMEZABUGUZI';

  @override
  String get agentCommissionColCashier => 'UMUBITSI';

  @override
  String get agentCommissionColSaleTotal => 'IGITERANYO';

  @override
  String get agentCommissionColRate => 'IGIPIMO';

  @override
  String get agentCommissionColCommission => 'KOMISIYO';

  @override
  String get agentCommissionColStatus => 'UKO BIHAGAZE';

  @override
  String get agentCommissionWalkIn => 'Umukiriya w\'ako kanya';

  @override
  String get agentCommissionRecentPayouts => 'UBWISHYU BUHERUTSE';

  @override
  String get agentCommissionCashier => 'Umubitsi';

  @override
  String get agentCommissionPaid => 'Byishyuwe';

  @override
  String get agentCommissionPending => 'Bitegereje';

  @override
  String get agentCommissionLast7Days => 'Iminsi 7 ishize';

  @override
  String get agentCommissionAllTime => 'Ibihe byose';

  @override
  String get agentCommissionToday => 'Uyu munsi';

  @override
  String get agentCommissionThisWeek => 'Iki cyumweru';

  @override
  String get agentCommissionThisMonth => 'Uku kwezi';

  @override
  String get agentCommissionLoadFailed =>
      'Ntibyashobotse gufungura amakuru ya komisiyo.';

  @override
  String get agentCommissionAgentsLoadFailed =>
      'Ntibyashobotse gufungura abakozi.';

  @override
  String get agentCommissionNoAgents =>
      'Nta bakozi babonetse. Banza wongere abakozi mu Icungamakoresha.';

  @override
  String get agentCommissionNoPermission =>
      'Nta burenganzira ufite bwo gucunga ubwishyu.';

  @override
  String agentCommissionBalanceDueAmount(String amount) {
    return 'Ibisigaye kwishyurwa: $amount';
  }

  @override
  String get agentCommissionAmountRwf => 'Amafaranga (RWF)';

  @override
  String get agentCommissionEnterValidAmount => 'Andika amafaranga yemewe';

  @override
  String agentCommissionCannotExceedBalance(String amount) {
    return 'Ntishobora kurenga ibisigaye ($amount)';
  }

  @override
  String get agentCommissionNoteOptional => 'Icyitonderwa (si ngombwa)';

  @override
  String agentCommissionPayoutRecorded(String amount) {
    return 'Ubwishyu bwa $amount bwanditswe.';
  }

  @override
  String get agentCommissionPayoutFailed =>
      'Ntibyashobotse kwandika ubwishyu. Reba murandasi yawe.';

  @override
  String get agentCommissionCommissionAgent => 'Umukozi uhembwa komisiyo';

  @override
  String get agentCommissionByOwner => 'na nyirayo';

  @override
  String agentCommissionSaleAmount(String amount) {
    return 'Igurisha $amount';
  }

  @override
  String get agentCommissionNoSalesYet => 'Nta gurisha ryitiriwe riraba';

  @override
  String agentCommissionNoSalesHint(String period) {
    return 'Iyo abacungamari bahaye umukozi igurisha ryarangiye muri Kugurisha vuba, komisiyo izagaragara hano kuri: $period.';
  }

  @override
  String get agentCommissionAmountMustBePositive =>
      'Amafaranga yishyurwa agomba kurenga zeru.';

  @override
  String get agentCommissionNoBusinessSelected => 'Nta bucuruzi bwatoranyijwe.';

  @override
  String get agentCommissionSignInToRecord =>
      'Injira kugira ngo wandike ubwishyu.';

  @override
  String get agentCommissionStorageNotSetUp =>
      'Ububiko bw\'ubwishyu ntiburashyirwaho. Saba umuyobozi wawe gukoresha migration ya Supabase iheruka (agent_commission_payouts).';

  @override
  String get agentCommissionCouldNotRecord =>
      'Ntibyashobotse kwandika ubwishyu.';

  @override
  String get kitchenStageIncoming => 'Ibishya';

  @override
  String get kitchenStageInProgress => 'Biri gutegurwa';

  @override
  String get kitchenStageReady => 'Byateguwe';

  @override
  String get kitchenStageServed => 'Byatanzwe';

  @override
  String get kitchenServedAlreadyPaid =>
      'Byatanzwe. Iri tumizwa ryari ryarishyuwe.';

  @override
  String get kitchenServedCashierHasTicket =>
      'Byatanzwe. Umubitsi afite iyi tike ifunguye ngo yishyurwe.';

  @override
  String get kitchenServedInTickets =>
      'Byatanzwe. Iri mu Matike, yiteguye kwishyurwa.';

  @override
  String get kitchenDisplayTitle => 'Ikibaho cy\'igikoni';

  @override
  String kitchenErrorLoadingOrders(String error) {
    return 'Ikosa mu kuzana ibyatumijwe: $error';
  }

  @override
  String kitchenFailedToUpdateOrder(String error) {
    return 'Guhindura itumizwa ntibyakunze: $error';
  }

  @override
  String kitchenFailedToSetDueDate(String error) {
    return 'Gushyiraho igihe ntarengwa ntibyakunze: $error';
  }

  @override
  String get kitchenNoOrders => 'Nta byatumijwe';

  @override
  String kitchenOrderNumber(String number) {
    return 'Itumizwa #$number';
  }

  @override
  String get kitchenSetDueDate => 'Shyiraho igihe ntarengwa';

  @override
  String get kitchenTicketNotFound =>
      'Itike ntiyabonetse — ishobora kuba yarasibwe.';

  @override
  String kitchenTicketName(String name) {
    return 'Itike: $name';
  }

  @override
  String kitchenCustomerLine(String name) {
    return 'Umukiriya: $name';
  }

  @override
  String kitchenTotalLine(String amount) {
    return 'Igiteranyo: $amount';
  }

  @override
  String get kitchenNoteLabel => 'Icyitonderwa:';

  @override
  String get kitchenNoItemsFound => 'Nta bicuruzwa byabonetse';

  @override
  String get kitchenItemsLabel => 'Ibicuruzwa:';

  @override
  String kitchenErrorLoadingItems(String error) {
    return 'Ikosa mu kuzana ibicuruzwa: $error';
  }

  @override
  String kitchenMinutesCount(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Iminota $minutes',
      one: 'Umunota 1',
    );
    return '$_temp0';
  }

  @override
  String kitchenDueInMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Bigomba kuba byiteguye mu minota $minutes',
      one: 'Bigomba kuba byiteguye mu munota 1',
    );
    return '$_temp0';
  }

  @override
  String get kitchenSetAction => 'Shyiraho';

  @override
  String get ticketUnknown => 'Ntibizwi';

  @override
  String get ticketOverdue => 'Cyarengeje igihe';

  @override
  String ticketMinutesLeft(String minutes) {
    return 'Hasigaye iminota $minutes';
  }

  @override
  String ticketDaysHoursLeft(String days, String hours) {
    return 'Hasigaye iminsi $days n\'amasaha $hours';
  }

  @override
  String ticketHoursMinutesLeft(String hours, String minutes) {
    return 'Hasigaye amasaha $hours n\'iminota $minutes';
  }

  @override
  String get ticketWalkInCustomer => 'Umukiriya usanzwe';

  @override
  String get ticketWalkIn => 'Umukiriya usanzwe';

  @override
  String get ticketStatusWaiting => 'Birategereje';

  @override
  String get ticketStatusInProgress => 'Biri gukorwa';

  @override
  String get ticketStatusPaid => 'Byishyuwe';

  @override
  String get ticketStatusPendingReview => 'Bitegereje igenzura';

  @override
  String get ticketStatusReviewed => 'Byagenzuwe';

  @override
  String get ticketStatusPartial => 'Igice';

  @override
  String get ticketStatusAwaitingPayment => 'Bitegereje kwishyurwa';

  @override
  String get ticketMarkReviewedFailed =>
      'Kwemeza ko itike yagenzuwe ntibyakunze';

  @override
  String get ticketReviewedSuccess => 'Itike yagenzuwe';

  @override
  String get ticketReviewQueue => 'Urutonde rw\'igenzura';

  @override
  String get ticketReviewQueueLoadFailed =>
      'Ntibyakunze kuzana urutonde rw\'igenzura';

  @override
  String get ticketReviewQueueEmpty => 'Nta kintu gitegereje igenzura';

  @override
  String get ticketReviewDetails => 'Genzura ibisobanuro';

  @override
  String ticketsWaitingToReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Amatike $count ategereje igenzura',
      one: 'Itike 1 itegereje igenzura',
    );
    return '$_temp0';
  }

  @override
  String ticketMoreCount(String count) {
    return '+ $count zindi';
  }

  @override
  String get ticketOpenReviewQueue => 'Fungura urutonde rw\'igenzura →';

  @override
  String ticketNumberRef(String reference) {
    return 'Itike #$reference';
  }

  @override
  String get ticketGeneric => 'Itike';

  @override
  String get ticketJustNow => 'ubu nyine';

  @override
  String ticketMinutesAgo(String count) {
    return 'hashize iminota $count';
  }

  @override
  String ticketHoursAgo(String count) {
    return 'hashize amasaha $count';
  }

  @override
  String ticketDaysAgo(String count) {
    return 'hashize iminsi $count';
  }

  @override
  String ticketItemsSectionCount(String count) {
    return 'Ibicuruzwa · $count';
  }

  @override
  String get ticketNote => 'Icyitonderwa';

  @override
  String ticketCouldNotLoadItems(String error) {
    return 'Ntibyakunze kuzana ibicuruzwa: $error';
  }

  @override
  String get ticketMarking => 'Biri kwemezwa…';

  @override
  String get ticketMarkAsReviewed => 'Emeza ko byagenzuwe';

  @override
  String get ticketReviewTicketTitle => 'Genzura itike';

  @override
  String get ticketNoItemsOnTicket => 'Nta gicuruzwa kiri kuri iyi tike.';

  @override
  String ticketIdShort(String id) {
    return '(ID: $id)';
  }

  @override
  String get ticketNotAvailable => 'Ntabwo bihari';

  @override
  String ticketSubtotalValue(String amount) {
    return 'Igiteranyo: $amount';
  }

  @override
  String ticketDueOn(String date) {
    return 'Igihe ntarengwa: $date';
  }

  @override
  String get ticketDeleteTitle => 'Siba itike';

  @override
  String get ticketDeleteConfirm =>
      'Uremeza ko ushaka gusiba iyi tike? Iki gikorwa ntigisubizwa inyuma.';

  @override
  String get ticketLoan => 'Ideni';

  @override
  String get ticketLayaway => 'Kwishyura buhoro buhoro';

  @override
  String get ticketRegular => 'Bisanzwe';

  @override
  String get ticketFilterAll => 'Amatike yose';

  @override
  String get ticketsCannotDeleteReviewed =>
      'Amatike watoranyije yamaze kugenzurwa, ntashobora gusibwa';

  @override
  String get ticketsCannotDeleteSelected =>
      'Amatike watoranyije ntashobora gusibwa (yishyuwe igice cyangwa yagenzuwe)';

  @override
  String ticketsDeletedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Amatike $count yasibwe neza',
      one: 'Itike 1 yasibwe neza',
    );
    return '$_temp0';
  }

  @override
  String get ticketsDeleteSelectedFailed =>
      'Gusiba amatike watoranyije ntibyakunze';

  @override
  String get ticketAddItemsFirst =>
      'Banza wongere ibicuruzwa mu gurisha mbere yo gukora itike';

  @override
  String get ticketCreate => 'Kora itike';

  @override
  String get ticketsPendingTitle => 'Amatike ategereje';

  @override
  String get ticketsMyTitle => 'Amatike yanjye';

  @override
  String get ticketsPendingSubtitle =>
      'Ibyatumijwe bitegereje kwishyurirwa ku kasi';

  @override
  String get ticketsMySubtitle => 'Ibyatumijwe wohereje n\'uko byishyuwe';

  @override
  String ticketsDeleteSelectedCount(String count) {
    return 'Siba ibyatoranyijwe ($count)';
  }

  @override
  String get ticketsSelectAll => 'Hitamo byose';

  @override
  String get ticketSendViaWhatsApp => 'Ohereza kuri WhatsApp';

  @override
  String ticketRefWithCustomer(String reference, String customer) {
    return 'Itike #$reference · $customer';
  }

  @override
  String get ticketHandoverStaffHeader => 'Abakozi bashyikiriza ibicuruzwa';

  @override
  String get ticketHandoverStaffLoadFailed =>
      'Ntibyakunze kuzana abakozi bashyikiriza ibicuruzwa.';

  @override
  String get ticketHandoverStaffEmpty =>
      'Nta mukozi ufite uburenganzira bwo gushyikiriza ibicuruzwa kandi ufite nimero ya telefoni yanditse. Ongeraho telefoni kuri porofayili ye kandi umuhe uburenganzira bwo gushyikiriza ibicuruzwa.';

  @override
  String get ticketOrderFormShop => 'Iduka';

  @override
  String get ticketOrderReceipt => 'Inyemezabwishyu y\'itumizwa';

  @override
  String get ticketCreated => 'Byakozwe';

  @override
  String get ticketDeliveryTime => 'Igihe cyo kugeza';

  @override
  String get ticketTotal => 'Igiteranyo';

  @override
  String get ticketBalance => 'Asigaye';

  @override
  String get ticketRemaining => 'Asigaye';

  @override
  String get ticketReviewedBy => 'Byagenzuwe na';

  @override
  String get ticketReviewedAt => 'Byagenzuwe ku wa';

  @override
  String get ticketThankYouForOrder => 'Murakoze ku itumizwa ryanyu';

  @override
  String ticketsSkippedCannotDelete(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Amatike $count adashobora gusibwa yasimbutswe (yishyuwe igice cyangwa yagenzuwe)',
      one:
          'Itike 1 itashobora gusibwa yasimbutswe (yishyuwe igice cyangwa yagenzuwe)',
    );
    return '$_temp0';
  }

  @override
  String get ticketSearchHint =>
      'Shakisha ukoresheje umukiriya, telefoni, ID y\'itike...';

  @override
  String get ticketsLoading => 'Turi kuzana amatike...';

  @override
  String get ticketsNoneInCategory => 'Nta tike iri muri iki cyiciro';

  @override
  String get ticketsTryAnotherFilter => 'Gerageza akandi kayunguruzo';

  @override
  String get ticketSortNewest => 'Ibishya mbere';

  @override
  String get ticketSortOldest => 'Ibya kera mbere';

  @override
  String get ticketsLoanSection => 'Amatike y\'amadeni';

  @override
  String get ticketsLayawaySection => 'Amatike yishyurwa buhoro buhoro';

  @override
  String get ticketsRegularSection => 'Amatike asanzwe';

  @override
  String get ticketOrderResumed => 'Itumizwa ryasubukuwe neza';

  @override
  String get ticketStaffFallback => 'Umukozi';

  @override
  String get ticketReturnToTillFailed =>
      'Ntibyakunze gusubiza itike iriho ku kasi. Ongera ugerageze.';

  @override
  String get ticketActionFailed => 'Igikorwa nticyakunze';

  @override
  String get ticketSentToKitchen => 'Byoherejwe mu gikoni';

  @override
  String get ticketSendToKitchenFailed =>
      'Ntibyakunze kohereza mu gikoni. Ongera ugerageze.';

  @override
  String get ticketSendToKitchen => 'Ohereza mu gikoni';

  @override
  String get ticketSendAgain => 'Ongera wohereze';

  @override
  String get ticketServedReadyForPayment => 'Byatanzwe · biteguye kwishyurwa';

  @override
  String ticketInKitchenStage(String stage) {
    return 'Mu gikoni · $stage';
  }

  @override
  String get ticketPrintOrderFormFailed =>
      'Gucapa urupapuro rw\'itumizwa ntibyakunze';

  @override
  String ticketOrderFormCaption(String reference, String customer) {
    return 'Urupapuro rw\'itumizwa · Itike #$reference · $customer';
  }

  @override
  String ticketOrderFormSentWhatsApp(String name) {
    return 'Urupapuro rw\'itumizwa rwoherejwe kuri $name kuri WhatsApp';
  }

  @override
  String get ticketOrderFormWhatsAppFailed =>
      'Kohereza urupapuro rw\'itumizwa kuri WhatsApp ntibyakunze';

  @override
  String get ticketHandoverRecordedReceipt =>
      'Ishyikirizwa ryanditswe — inyemezabwishyu yatanzwe';

  @override
  String get ticketHandoverRecorded => 'Ishyikirizwa ryanditswe';

  @override
  String get ticketHandoverFinalizeFailed =>
      'Kurangiza ishyikirizwa ntibyakunze — inyemezabwishyu ntiyatanzwe. Ongera ugerageze.';

  @override
  String get ticketHasPartialPayments =>
      'Iyi tike ifite ubwishyu bw\'igice, ntishobora gusibwa.';

  @override
  String get ticketDeleted => 'Itike yasibwe';

  @override
  String get ticketDeleteFailed => 'Gusiba itike ntibyakunze';

  @override
  String get ticketDeleteFailedShort => 'Gusiba ntibyakunze';

  @override
  String get ticketsNoOpen => 'Nta tike ifunguye';

  @override
  String get ticketsCreateToStart => 'Kora itike nshya kugira ngo utangire';

  @override
  String get ticketsNoSearchMatch => 'Nta tike ihuye n\'ibyo washakishije';

  @override
  String get ticketsTryDifferentSearch =>
      'Gerageza irindi jambo ryo gushakisha';

  @override
  String get ticketSomethingWentWrong => 'Hari ikitagenze neza';

  @override
  String get ticketTryAgain => 'Ongera ugerageze';

  @override
  String get ticketCompleteHandoverTitle => 'Rangiza ishyikirizwa?';

  @override
  String get ticketHandoverIssueReceiptBody =>
      'Tanga inyemezabwishyu kandi wemeze ko iyi tike yarangiye.';

  @override
  String get ticketHandoverConfirmLeftStock =>
      'Emeza ko igicuruzwa cyavuye mu bubiko koko.';

  @override
  String get ticketHandoverStockDeductedInfo =>
      'Ububiko buragabanywa kandi inyemezabwishyu y\'imisoro itangwe ubu.';

  @override
  String get ticketHandoverRecordsInfo =>
      'Ibi byandika ko ibicuruzwa byashyikirijwe umukiriya.';

  @override
  String get ticketDeleteQuestion => 'Gusiba itike?';

  @override
  String get ticketDeleteRemovesHistory =>
      'Ibi bisiba igurisha ryabitswe n\'amateka y\'itike ari kuri iki gikoresho.';

  @override
  String get ticketActionCannotBeUndone => 'Iki gikorwa ntigisubizwa inyuma.';

  @override
  String ticketCreatedOn(String date) {
    return 'Byakozwe $date';
  }

  @override
  String get ticketRecordHandover => 'Andika ishyikirizwa';

  @override
  String get ticketCollecting => 'Biri kwakirwa…';

  @override
  String get ticketCollect => 'Akira →';

  @override
  String get ticketCompleting => 'Biri kurangizwa…';

  @override
  String get ticketComplete => 'Rangiza →';

  @override
  String get ticketResumeOrder => 'Subukura itumizwa';

  @override
  String get ticketPrint => 'Capa';

  @override
  String get ticketSent => 'Byoherejwe';

  @override
  String get ticketWhatsAppNotConfigured =>
      'Kohereza kuri WhatsApp ntibirashyirwaho: URL ya data connector (Ebm.dataConnectorUrl) ntiyabonetse.';

  @override
  String configCurrencyName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'RWF': 'Ifaranga ry\'u Rwanda',
      'KES': 'Ishilingi rya Kenya',
      'UGX': 'Ishilingi rya Uganda',
      'TZS': 'Ishilingi rya Tanzaniya',
      'ETB': 'Birr ya Etiyopiya',
      'NGN': 'Naira ya Nijeriya',
      'ZAR': 'Rand ya Afurika y\'Epfo',
      'GHS': 'Cedi ya Gana',
      'MAD': 'Dirham ya Maroke',
      'EGP': 'Pawundi ya Misiri',
      'DZD': 'Dinari ya Alijeriya',
      'XOF': 'Ifaranga CFA BCEAO',
      'XAF': 'Ifaranga CFA BEAC',
      'MUR': 'Rupiya ya Morise',
      'BWP': 'Pula ya Botswana',
      'NAD': 'Idolari rya Namibiya',
      'USD': 'Idolari ry\'Amerika',
      'EUR': 'Ewuro',
      'GBP': 'Pawundi y\'Ubwongereza',
      'JPY': 'Yeni y\'Ubuyapani',
      'CNY': 'Yuwani y\'Ubushinwa',
      'CAD': 'Idolari rya Kanada',
      'AUD': 'Idolari rya Ositaraliya',
      'CHF': 'Ifaranga ry\'Ubusuwisi',
      'NZD': 'Idolari rya Nouvelle-Zélande',
      'HKD': 'Idolari rya Hong Kong',
      'SEK': 'Korona ya Suwede',
      'NOK': 'Kurone ya Noruveje',
      'DKK': 'Kurone ya Danimarike',
      'AED': 'Dirham ya Leta Zunze Ubumwe z\'Abarabu',
      'SAR': 'Riyal ya Arabiya Sawudite',
      'QAR': 'Riyal ya Katari',
      'KWD': 'Dinari ya Koweti',
      'BHD': 'Dinari ya Bahareyini',
      'OMR': 'Riyal ya Omani',
      'ILS': 'Shekeli ya Isiraheli',
      'JOD': 'Dinari ya Yorudaniya',
      'INR': 'Rupiya y\'Ubuhinde',
      'PKR': 'Rupiya ya Pakisitani',
      'BDT': 'Taka ya Bangaladeshi',
      'SGD': 'Idolari rya Singapuru',
      'MYR': 'Ringgit ya Maleziya',
      'IDR': 'Rupiya ya Indoneziya',
      'PHP': 'Peso ya Filipine',
      'THB': 'Baht ya Tayilande',
      'VND': 'Dong ya Viyetinamu',
      'KRW': 'Won ya Koreya y\'Epfo',
      'TWD': 'Idolari rishya rya Tayiwani',
      'LKR': 'Rupiya ya Siri Lanka',
      'NPR': 'Rupiya ya Nepali',
      'BRL': 'Real ya Burezili',
      'MXN': 'Peso ya Megizike',
      'ARS': 'Peso ya Arijantine',
      'COP': 'Peso ya Kolombiya',
      'CLP': 'Peso ya Shili',
      'PEN': 'Sol ya Peru',
      'UYU': 'Peso ya Irigwe',
      'BOB': 'Boliviano ya Boliviya',
      'VES': 'Bolívar ya Venezuwela',
      'RUB': 'Rubule y\'Uburusiya',
      'PLN': 'Złoty ya Polonye',
      'CZK': 'Koruna ya Ceki',
      'HUF': 'Forint ya Hongiriya',
      'RON': 'Leu ya Romaniya',
      'BGN': 'Lev ya Bulugariya',
      'TRY': 'Lira ya Turukiya',
      'UAH': 'Hryvnia ya Ukraine',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get configNeedHelp => 'Ukeneye ubufasha?';

  @override
  String get configContactSupportToAddEbm =>
      'Vugana n\'itsinda ry\'ubufasha kugira ngo bongere EBM muri Flipper';

  @override
  String get configContactSupport => 'Vugana n\'ubufasha';

  @override
  String get configEnterValidUrl => 'Nyamuneka andika URL yemewe';

  @override
  String get configEnterUrlWithScheme =>
      'Nyamuneka andika URL yemewe itangizwa na http:// cyangwa https://';

  @override
  String get configBranchIdRequired => 'ID y\'ishami irakenewe';

  @override
  String get configMrcRequired => 'MRC irakenewe';

  @override
  String get configMrcLength => 'MRC igomba kugira inyuguti 11 neza';

  @override
  String get configNoChangesToSave => 'Nta byahinduwe byo kubika';

  @override
  String get configSaveFailed =>
      'Kubika igenamiterere ry\'imisoro ntibyakunze. Genzura interineti yawe wongere ugerageze.';

  @override
  String get configTaxConfigSaved => 'Igenamiterere ry\'imisoro ryabitswe';

  @override
  String get configGeneral => 'Rusange';

  @override
  String get configTaxConfiguration => 'Igenamiterere ry\'imisoro';

  @override
  String get configSaveAppliesTo =>
      'Kubika bireba URL ya EBM / imisoro, URL ya data connector, kode y\'ishami na MRC.';

  @override
  String get configTaxServerUrl => 'URL ya seriveri ya EBM / imisoro';

  @override
  String get configDataConnectorUrl => 'URL ya data connector';

  @override
  String get configDataConnectorHelper =>
      'Kwandikisha ibicuruzwa byinshi muri RRA bikoresha iyi serivisi; URL y\'imisoro ya RRA ishyirwaho kuri data-connector.';

  @override
  String get configBranchCodeBhfId => 'Kode y\'ishami (bhfId)';

  @override
  String get configBranchCode => 'Kode y\'ishami';

  @override
  String get configEnterEbmUrl => 'Andika URL ya EBM';

  @override
  String get configSystemConfiguration => 'Igenamiterere rya sisitemu';

  @override
  String get configSystemConfigSubtitle =>
      'Cunga imikorere ya POS, ifaranga n\'ihuzwa n\'imisoro.';

  @override
  String get configTrainingMode => 'Uburyo bwo kwimenyereza';

  @override
  String get configProformaMode => 'Uburyo bwa proforma';

  @override
  String get configPrintA4 => 'Capa kuri A4';

  @override
  String get configExportAsPdf => 'Ohereza nka PDF';

  @override
  String get configSystemCurrency => 'Ifaranga rya sisitemu';

  @override
  String get configVatEnabled => 'TVA irakora';

  @override
  String get configVatControlledByEbm => 'Bigenwa n\'igenamiterere rya EBM';

  @override
  String get configVatStatusControlledByEbm =>
      'Imiterere ya TVA igenwa n\'igenamiterere rya EBM';

  @override
  String get configLoading => 'Biri gufunguka...';

  @override
  String get configErrorLoadingVat => 'Ikosa mu kuzana imiterere ya TVA';

  @override
  String configErrorWithDetails(String error) {
    return 'Ikosa: $error';
  }

  @override
  String get configTourismTaxRegistered =>
      'Yanditswe ku musoro w\'ubukerarugendo';

  @override
  String get configTourismTaxHint =>
      'Bikoreshe gusa niba RRA yanditse iri shami ku musoro w\'ubukerarugendo. Bitabaye ibyo, ibyumba byandikwa nka serivisi zisanzwe.';

  @override
  String get configVersionNotAvailable => 'Verisiyo ntiboneka';

  @override
  String configVersion(String version) {
    return 'Verisiyo $version';
  }

  @override
  String get configSaving => 'Turabika…';

  @override
  String get configSaved => 'Byabitswe';

  @override
  String get configSaveConfiguration => 'Bika igenamiterere';

  @override
  String get leadsFilterAll => 'Byose';

  @override
  String get leadsStatusNew => 'Mushya';

  @override
  String get leadsStatusContacted => 'Yavuganywe';

  @override
  String get leadsStatusQuoted => 'Yahawe igiciro';

  @override
  String get leadsStatusConverted => 'Yaguze';

  @override
  String get leadsStatusLost => 'Yatakaye';

  @override
  String get leadsHeatHot => 'Ashyushye';

  @override
  String get leadsHeatWarm => 'Akazuyazi';

  @override
  String get leadsHeatCold => 'Akonje';

  @override
  String get leadsHotLead => 'Umukiriya ushyushye';

  @override
  String get leadsWarmLead => 'Umukiriya w\'akazuyazi';

  @override
  String get leadsColdLead => 'Umukiriya ukonje';

  @override
  String get leadsSourceWalkIn => 'Yaje ku iduka';

  @override
  String get leadsSubtitle =>
      'Kurikirana abakiriya, ibibazo byabo n\'agaciro gategerejwe';

  @override
  String leadsEmailsNeedReview(String count) {
    return 'Imeyili $count zikeneye gusuzumwa';
  }

  @override
  String get leadsFilter => 'Shungura';

  @override
  String get leadsAddLead => 'Ongeramo umukiriya ushoboka';

  @override
  String get leadsStatTotalLeads => 'Abakiriya bashoboka bose';

  @override
  String get leadsStatAllSources => 'Aho bose baturutse';

  @override
  String get leadsStatPipelineValue => 'Agaciro gategerejwe';

  @override
  String get leadsStatActiveLeads => 'Abakiriya bashoboka bakiri mu nzira';

  @override
  String get leadsStatCompletedSales => 'Igurisha ryarangiye';

  @override
  String get leadsStatFromGmail => 'Biturutse kuri Gmail';

  @override
  String get leadsStatEmailEnquiries => 'Ibibazo byaje kuri imeyili';

  @override
  String get leadsStatConversionRate => 'Igipimo cy\'abaguze';

  @override
  String get leadsStatThisMonth => 'Uku kwezi';

  @override
  String get leadsAllLeads => 'Abakiriya bashoboka bose';

  @override
  String get leadsUnableToLoad => 'Ntibyakunze kuzana abakiriya bashoboka.';

  @override
  String get leadsSearchHint => 'Shakisha izina, imeyili, igicuruzwa…';

  @override
  String get leadsNoLeadsYet => 'Nta bakiriya bashoboka barahari.';

  @override
  String get leadsColSource => 'Inkomoko';

  @override
  String get leadsColInterestedIn => 'Ibyo ashaka';

  @override
  String get leadsColValue => 'Agaciro';

  @override
  String get leadsColStage => 'Icyiciro';

  @override
  String get leadsColHeat => 'Ubushake';

  @override
  String get leadsColDate => 'Itariki';

  @override
  String get leadsPipeline => 'Aho bageze';

  @override
  String get leadsPerformance => 'Imikorere';

  @override
  String get leadsConversionRateThisMonth => 'Igipimo cy\'abaguze uku kwezi';

  @override
  String get leadsAvgTimeToConvert => 'Igihe kigereranyo cyo kugura';

  @override
  String leadsDaysCount(String days) {
    return 'Iminsi $days';
  }

  @override
  String get leadsEmailReviewComingSoon =>
      'Gusuzuma abakiriya baturutse kuri imeyili biraza vuba.';

  @override
  String get leadsGmailAiFlagged =>
      'Gmail - AI yabonye aba nk\'abakiriya bashoboka.';

  @override
  String leadsPendingCount(String count) {
    return '$count bitegereje';
  }

  @override
  String get leadsGmailIngestionLater =>
      'Kuzana amakuru avuye kuri Gmail bizakora nyuma. Ubu, ongeramo abakiriya bashoboka n\'intoki.';

  @override
  String get leadsFilterLeads => 'Shungura abakiriya bashoboka';

  @override
  String get leadsContactDetails => 'Aho abarizwa';

  @override
  String get leadsEstValue => 'Agaciro kagereranyo';

  @override
  String get leadsNotes => 'Inyandiko';

  @override
  String get leadsAiExtractedItems => 'Ibicuruzwa ashaka byakuwemo na AI';

  @override
  String leadsMatchPercent(String percent) {
    return 'Bihuye ku $percent%';
  }

  @override
  String get leadsActivityTimeline => 'Amateka y\'ibikorwa';

  @override
  String get leadsCreatedFromGmail =>
      'Umukiriya ushoboka yanditswe — avuye kuri imeyili ya Gmail';

  @override
  String get leadsCreatedManual =>
      'Umukiriya ushoboka yanditswe — byanditswe n\'intoki';

  @override
  String get leadsTimelineAuto => 'Byikora';

  @override
  String get leadsTimelinePending => 'Bitegereje';

  @override
  String leadsAiExtractedProducts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ibicuruzwa $count',
      one: 'igicuruzwa 1',
    );
    return 'AI yakuyemo $_temp0 ashaka';
  }

  @override
  String get leadsProformaDraftReady =>
      'Umushinga wa proforma witeguye gusuzumwa';

  @override
  String get leadsReviewProforma => 'Suzuma proforma';

  @override
  String get leadsConverting => 'Turimo guhindura…';

  @override
  String get leadsConvertToSale => 'Hindura igurisha';

  @override
  String leadsConvertFailed(String error) {
    return 'Guhindura umukiriya ushoboka ntibyakunze. $error';
  }

  @override
  String get leadsFullNameRequired => 'Amazina yose *';

  @override
  String get leadsFullNameHint => 'Amazina yose';

  @override
  String get leadsEmailAddress => 'Aderesi ya imeyili';

  @override
  String get leadsNotesOptional => 'Inyandiko (si ngombwa)';

  @override
  String get leadsNotesHint => 'Yasabye iki?';

  @override
  String get leadsSaveLead => 'Bika umukiriya ushoboka';

  @override
  String get leadsProductsInterestedRequired => 'Ibicuruzwa ashaka *';

  @override
  String get leadsBrowseCatalogue => 'Reba urutonde rw\'ibicuruzwa';

  @override
  String get leadsTypeProductHint =>
      'Cyangwa andika izina ry\'igicuruzwa, SKU, BCD…';

  @override
  String get leadsAddLeadSubtitle =>
      'Andika umukiriya mushya cyangwa ikibazo cye n\'intoki';

  @override
  String get leadsWalkInCustomer => 'Umukiriya waje ku iduka';

  @override
  String get leadsPhoneReferral => 'Telefoni / Uwamurangiye';

  @override
  String get leadsEstimatedValue => 'Agaciro kagereranyo';

  @override
  String get leadsLeadHeat => 'Urwego rw\'ubushake';

  @override
  String leadsSaveFailed(String error) {
    return 'Kubika umukiriya ushoboka ntibyakunze. $error';
  }

  @override
  String get leadsPickFromCatalogue => 'Hitamo mu rutonde rw\'ibicuruzwa';

  @override
  String get leadsSearchCatalogHint => 'Shakisha izina, SKU, BCD…';

  @override
  String get leadsNoItemsFound => 'Nta bicuruzwa byabonetse';

  @override
  String get leadsProformaNewItem => 'Igicuruzwa gishya';

  @override
  String get leadsProforma => 'Proforma';

  @override
  String get leadsProformaInvoice => 'Fagitire proforma';

  @override
  String leadsProformaSubtitle(String name) {
    return 'Umukiriya ushoboka: $name · Umushinga wa AI — suzuma mbere yo kohereza';
  }

  @override
  String get leadsSend => 'Ohereza';

  @override
  String get leadsSending => 'Turohereza…';

  @override
  String get leadsDownloadPdf => 'Kuramo PDF';

  @override
  String get leadsProformaAiBannerNarrow =>
      'AI yabitegure ihereye kuri imeyili. Kanda igiciro cyangwa ingano ubihindure. Suzuma imirongo yose mbere yo kohereza.';

  @override
  String get leadsProformaAiBanner =>
      'AI yateguye iyi proforma ihereye kuri imeyili y\'umukiriya';

  @override
  String get leadsAllFieldsEditable => 'Byose birahindurwa';

  @override
  String get leadsDraft => 'Umushinga';

  @override
  String get leadsDraftNotSent => 'Umushinga — ntiwoherejwe';

  @override
  String get leadsBillTo => 'Yishyurwa na';

  @override
  String get leadsIssueDate => 'Itariki yatangiweho';

  @override
  String get leadsValidUntil => 'Igihe izarangirira';

  @override
  String get leadsLeadSource => 'Inkomoko y\'umukiriya';

  @override
  String get leadsGmailEnquiry => 'Ikibazo cyaje kuri Gmail';

  @override
  String get leadsManualEntry => 'Byanditswe n\'intoki';

  @override
  String get leadsAiMatchedItems => 'AI yahuje ibicuruzwa n\'urutonde';

  @override
  String get leadsColItem => 'Igicuruzwa';

  @override
  String get leadsColPrice => 'Igiciro';

  @override
  String get leadsColTotal => 'Igiteranyo';

  @override
  String get leadsColDescription => 'Ibisobanuro';

  @override
  String get leadsColUnitPrice => 'Igiciro cy\'igice';

  @override
  String get leadsColQty => 'Ingano';

  @override
  String get leadsAddProductHint => 'Ongeramo igicuruzwa...';

  @override
  String get leadsAddShort => '+ Ongeraho';

  @override
  String get leadsSearchProductToAddLine =>
      '+ Shakisha igicuruzwa wongere umurongo…';

  @override
  String get leadsAddLine => 'Ongeraho umurongo';

  @override
  String get leadsVat18 => 'TVA 18%';

  @override
  String get leadsGrandTotal => 'Igiteranyo cyose';

  @override
  String get leadsTermsShort => 'Imara iminsi 7. Kwishyura bikorwa ku itangwa.';

  @override
  String get leadsTermsLong =>
      'Iyi proforma imara iminsi 7. Kwishyura bikorwa ku itangwa. Twakira kohereza kuri banki cyangwa mobile money.';

  @override
  String get leadsNotesTerms => 'Inyandiko / Amabwiriza';

  @override
  String get leadsSummary => 'Incamake';

  @override
  String get leadsLines => 'Imirongo';

  @override
  String leadsLinesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Imirongo $count',
      one: 'Umurongo 1',
    );
    return '$_temp0';
  }

  @override
  String get leadsStatus => 'Imiterere';

  @override
  String get leadsHistory => 'Amateka';

  @override
  String get leadsHistoryAiDrafted =>
      'AI yabitegure ihereye kuri imeyili ya Gmail';

  @override
  String get leadsHistoryLeadCreated =>
      'Umukiriya ushoboka yanditswe, proforma yakozwe';

  @override
  String get leadsHistoryAwaitingReview => 'Bitegereje gusuzumwa';

  @override
  String get leadsToday => 'Uyu munsi';

  @override
  String get leadsNow => 'Ubu';

  @override
  String get leadsNoContactProvided => 'Nta aho abarizwa hatanzwe';

  @override
  String get leadsPdfSaved => 'PDF ya proforma yabitswe.';

  @override
  String leadsPdfExportFailed(String error) {
    return 'Gukora PDF ntibyakunze: $error';
  }

  @override
  String get leadsPdfReadyToShare => 'PDF ya proforma yiteguye gusangizwa.';

  @override
  String leadsSendPrepareFailed(String error) {
    return 'Gutegura kohereza ntibyakunze: $error';
  }

  @override
  String get leadsConvertedToSale => 'Umukiriya ushoboka yahinduwe igurisha.';

  @override
  String leadsConvertFailedShort(String error) {
    return 'Guhindura ntibyakunze: $error';
  }

  @override
  String get gigsNegotiable => 'Biraganirwaho';

  @override
  String gigsDurationHoursMinutes(String hours, String minutes) {
    return 'Amasaha $hours n’iminota $minutes';
  }

  @override
  String gigsDurationMinutes(String minutes) {
    return 'Iminota $minutes';
  }

  @override
  String get gigsStatusAwaitingProviderResponse =>
      'Bitegereje igisubizo cy\'utanga serivisi';

  @override
  String get gigsStatusAcceptWindowExpired => 'Igihe cyo kwemera cyarangiye';

  @override
  String get gigsStatusAwaitingPayment => 'Bitegereje ubwishyu';

  @override
  String get gigsStatusPaymentWindowExpired => 'Igihe cyo kwishyura cyarangiye';

  @override
  String get gigsStatusPaidReadyToStart => 'Byishyuwe - Biteguye gutangira';

  @override
  String get gigsStatusRequested => 'Byasabwe';

  @override
  String get gigsStatusPendingPayment => 'Ubwishyu butegerejwe';

  @override
  String get gigsStatusPaid => 'Byishyuwe';

  @override
  String get gigsStatusInProgress => 'Birimo gukorwa';

  @override
  String get gigsStatusCompleted => 'Byarangiye';

  @override
  String get gigsStatusDeclined => 'Byanzwe';

  @override
  String get gigsStatusDeclinedByProvider => 'Byanzwe n\'utanga serivisi';

  @override
  String get gigsStatusExpired => 'Igihe cyarangiye';

  @override
  String get gigsStatusCancelled => 'Byahagaritswe';

  @override
  String get gigsStatusAccepted => 'Byemewe';

  @override
  String get gigsCategoryHomeServices => 'Serivisi zo mu rugo';

  @override
  String get gigsCategoryBeautyWellness => 'Ubwiza n\'imibereho myiza';

  @override
  String get gigsCategoryDeliveryTransport => 'Gutwara no kugeza ibintu';

  @override
  String get gigsCategoryTechSupport => 'Ubufasha mu ikoranabuhanga';

  @override
  String get gigsCategoryEvents => 'Ibirori';

  @override
  String get gigsCategoryLessons => 'Amasomo n\'amahugurwa';

  @override
  String get gigsCategoryHealthcare => 'Ubuvuzi';

  @override
  String get gigsCategoryOther => 'Ibindi';

  @override
  String get gigsErrSignInToRequest => 'Injira kugira ngo usabe serivisi.';

  @override
  String get gigsErrRequestSelf => 'Ntushobora kwisaba serivisi ubwawe.';

  @override
  String get gigsErrMinAmount => 'Andika amafaranga nibura 100 RWF.';

  @override
  String get gigsErrSendRequest => 'Kohereza ubusabe bwawe ntibyakunze.';

  @override
  String get gigsErrSendRequestConnection =>
      'Kohereza ubusabe bwawe ntibyakunze. Genzura interineti wongere ugerageze.';

  @override
  String get gigsErrSignInToPay => 'Injira kugira ngo urangize kwishyura.';

  @override
  String get gigsErrValidAmount => 'Andika amafaranga yemewe.';

  @override
  String get gigsErrRequestNotFound => 'Ubusabe ntibwabonetse.';

  @override
  String get gigsErrNotAwaitingPayment =>
      'Ubu busabe ntibutegereje kwishyurwa.';

  @override
  String get gigsErrPaymentWindowEnded =>
      'Igihe cyo kwishyura cyarangiye. Vugana n\'utanga serivisi wohereze ubusabe bushya.';

  @override
  String get gigsErrConfirmPayment =>
      'Kwemeza ubwishyu ntibyakunze. Bushobora kuba bwaranditswe.';

  @override
  String get gigsErrSavePayment => 'Kubika ubwishyu ntibyakunze.';

  @override
  String get gigsErrSavePaymentConnection =>
      'Kubika ubwishyu ntibyakunze. Genzura interineti yawe.';

  @override
  String get gigsErrSignInToRespond => 'Injira kugira ngo usubize ubusabe.';

  @override
  String get gigsErrCannotAccept =>
      'Ubu busabe ntibukibasha kwemerwa. Bushobora kuba bwararengeje igihe cyangwa bwarakemuwe.';

  @override
  String get gigsErrAccept => 'Kwemera ubusabe ntibyakunze.';

  @override
  String get gigsErrAcceptConnection =>
      'Kwemera ubusabe ntibyakunze. Genzura interineti wongere ugerageze.';

  @override
  String get gigsErrSignInToDispatch => 'Injira kugira ngo wohereze ubwishyu.';

  @override
  String get gigsErrPayoutReference => 'Andika indango y\'ubwishyu.';

  @override
  String get gigsErrUpdatePayout =>
      'Guhindura imiterere y\'ubwishyu ntibyakunze.';

  @override
  String get gigsErrSignInToMessage => 'Injira kugira ngo wohereze ubutumwa.';

  @override
  String get gigsErrEmptyMessage => 'Ubutumwa ntibushobora kuba ubusa.';

  @override
  String get gigsErrRequestClosed => 'Ubu busabe bwafunzwe.';

  @override
  String get gigsErrSendMessage => 'Kohereza ubutumwa ntibyakunze.';

  @override
  String get gigsErrSignInToUpdate => 'Injira kugira ngo uvugurure ubu busabe.';

  @override
  String get gigsErrOnlyPaidToStart =>
      'Ubusabe bwishyuwe butaratangira ni bwo bwonyine bushobora gushyirwa mu birimo gukorwa.';

  @override
  String get gigsErrUpdateStatus => 'Guhindura imiterere ntibyakunze.';

  @override
  String get gigsErrMarkComplete =>
      'Kwemeza ko byarangiye ntibyakunze. Bishobora kuba byararangiye.';

  @override
  String get gigsErrSignInToReview => 'Injira kugira ngo utange igitekerezo.';

  @override
  String get gigsErrPickRating => 'Hitamo amanota kuva kuri 1 kugeza kuri 5.';

  @override
  String get gigsErrShortComment => 'Nyamuneka ongeraho igitekerezo kigufi.';

  @override
  String get gigsErrOnlyCompletedReview =>
      'Akazi karangiye ni ko konyine gashobora gutangwaho igitekerezo.';

  @override
  String get gigsErrAlreadyReviewed => 'Wamaze gutanga igitekerezo.';

  @override
  String get gigsErrSaveReviewRetry =>
      'Kubika igitekerezo ntibyakunze. Ongera ugerageze.';

  @override
  String get gigsErrSaveReview => 'Kubika igitekerezo ntibyakunze.';

  @override
  String get gigsAdminMetricsTitle => 'Imibare y\'ihuriro ry\'serivisi';

  @override
  String get gigsPayouts => 'Ubwishyu bw\'abatanga serivisi';

  @override
  String get gigsPendingDispatch => 'Bitegereje koherezwa';

  @override
  String get gigsDispatched => 'Byoherejwe';

  @override
  String get gigsPendingTotalRwf => 'Igiteranyo gitegerejwe (RWF)';

  @override
  String get gigsRequestsByStatus => 'Ubusabe hakurikijwe imiterere';

  @override
  String get gigsMetrics => 'Imibare';

  @override
  String get gigsProvider => 'Utanga serivisi';

  @override
  String gigsProviderShortId(String suffix) {
    return 'Utanga serivisi · …$suffix';
  }

  @override
  String gigsCustomerShortId(String suffix) {
    return 'Umukiriya · …$suffix';
  }

  @override
  String get gigsPayoutReference => 'Indango y\'ubwishyu';

  @override
  String get gigsPayoutReferenceHint => 'Indango ya MTN / igitabo cy\'imari';

  @override
  String get gigsMarkDispatched => 'Emeza ko byoherejwe';

  @override
  String get gigsMarkedDispatched => 'Byemejwe ko byoherejwe.';

  @override
  String get gigsDispatchPayouts => 'Ohereza ubwishyu';

  @override
  String get gigsNoPayoutsPending => 'Nta bwishyu butegereje';

  @override
  String get gigsNoPayoutsPendingHint =>
      'Akazi kishyuwe kazagaragara hano kugeza ubwishyu bwoherejwe.';

  @override
  String gigsPayoutAmountLine(String amount, String status, String date) {
    return 'Amafaranga: $amount RWF · $status\nYoherejwe $date';
  }

  @override
  String get gigsWaitingForProvider => 'Bitegereje utanga serivisi';

  @override
  String get gigsPayNow => 'Ishyura ubu';

  @override
  String get gigsPaymentWindowEnded => 'Igihe cyo kwishyura cyarangiye';

  @override
  String get gigsPaymentRecordedCanStart =>
      'Ubwishyu bwanditswe. Utanga serivisi ashobora gutangira akazi.';

  @override
  String get gigsMyRequests => 'Ubusabe bwanjye';

  @override
  String get gigsNoRequestsYet => 'Nta busabe burahari';

  @override
  String get gigsMyRequestsEmptyHint =>
      'Nusaba umuntu serivisi uhereye kuri Shaka abatanga serivisi, bizagaragara hano. Namara kwemera, ushobora kwishyura na MTN mu gihe cyerekanwe.';

  @override
  String get gigsAgreedAmount => 'Amafaranga yumvikanyweho';

  @override
  String get gigsSent => 'Byoherejwe';

  @override
  String gigsPayBy(String date) {
    return 'Ishyura bitarenze $date';
  }

  @override
  String gigsDidNotPayBefore(String date) {
    return 'Ntiwishyuye mbere ya $date';
  }

  @override
  String gigsPaidAmountSettled(String amount, String settled) {
    return 'Byishyuwe $amount RWF · MTN yishyuye $settled RWF';
  }

  @override
  String gigsPaidAmount(String amount) {
    return 'Byishyuwe $amount RWF';
  }

  @override
  String get gigsPayWithMtn => 'Ishyura na MTN';

  @override
  String gigsRequestFrom(String name) {
    return 'Ubusabe buvuye kwa $name';
  }

  @override
  String gigsRequestTo(String name) {
    return 'Ubusabe bwoherejwe kwa $name';
  }

  @override
  String get gigsNotifications => 'Imenyesha';

  @override
  String get gigsNoActivityYet => 'Nta bikorwa birahari';

  @override
  String get gigsActivityEmptyHint =>
      'Nwohereza cyangwa wakira ubusabe bwa serivisi, amakuru mashya azagaragara hano. Kurura hasi uvugurure.';

  @override
  String gigsUpdatedAt(String date) {
    return 'Byavuguruwe $date';
  }

  @override
  String get gigsPaymentRecorded => 'Ubwishyu bwanditswe.';

  @override
  String get gigsMarkedInProgress => 'Byashyizwe mu birimo gukorwa.';

  @override
  String get gigsJobMarkedComplete =>
      'Akazi kemejwe ko karangiye. Umukiriya ashobora gutanga igitekerezo.';

  @override
  String get gigsRateYourExperience => 'Tanga amanota ku byo wabonye';

  @override
  String get gigsComment => 'Igitekerezo';

  @override
  String get gigsThanksForReview => 'Urakoze ku gitekerezo cyawe.';

  @override
  String get gigsRequestDetails => 'Ibisobanuro by\'ubusabe';

  @override
  String get gigsMessages => 'Ubutumwa';

  @override
  String get gigsNoMessagesYet =>
      'Nta butumwa burahari. Mwumvikanire hano ku isaha n\'aho bizabera.';

  @override
  String get gigsTypeMessageHint => 'Andika ubutumwa…';

  @override
  String get gigsStartJob => 'Tangira akazi';

  @override
  String get gigsMarkJobComplete => 'Emeza ko akazi karangiye';

  @override
  String get gigsLeaveReview => 'Tanga igitekerezo';

  @override
  String get gigsYourReview => 'Igitekerezo cyawe';

  @override
  String get gigsAdvancedFilters => 'Kuyungurura birambuye';

  @override
  String gigsMinRating(String rating) {
    return 'Amanota rusange make: $rating';
  }

  @override
  String get gigsVerifiedOnly => 'Abatanga serivisi bemejwe gusa';

  @override
  String get gigsAvailableForBooking => 'Arahari ngo afatwe';

  @override
  String get gigsMaxBasePrice => 'Igiciro fatizo kinini (RWF), si ngombwa';

  @override
  String get gigsCategory => 'Icyiciro';

  @override
  String get gigsAllCategories => 'Ibyiciro byose';

  @override
  String get gigsApplyFilters => 'Shyiraho iyungurura';

  @override
  String get gigsFindProvider => 'Shaka utanga serivisi';

  @override
  String get gigsNoProvidersYet => 'Nta batanga serivisi barahari';

  @override
  String get gigsNoProvidersHint =>
      'Abantu nibatanga serivisi zabo hano, uzababona kuri uru rutonde kandi ushobora kubasaba serivisi.\n\nKurura hasi uvugurure. Niba nawe wiyandikishije nk\'utanga serivisi, umwirondoro wawe ntugaragara kuri uru rutonde.';

  @override
  String get gigsSearchHint => 'Shakisha izina, agace cyangwa serivisi…';

  @override
  String get gigsBrowseByService => 'Reba ukurikije serivisi';

  @override
  String get gigsAll => 'Byose';

  @override
  String get gigsNoMatches => 'Nta bihuye byabonetse';

  @override
  String get gigsNoMatchesHint =>
      'Gerageza andi magambo, hitamo indi serivisi, cyangwa ukureho iyungurura.';

  @override
  String get gigsClearSearchFilters => 'Kuraho ishakisha n\'iyungurura';

  @override
  String get gigsErrUpdateAvailability =>
      'Kuvugurura uko uboneka kuri seriveri ntibyakunze.';

  @override
  String get gigsVisibleToCustomers => 'Abakiriya barakubona.';

  @override
  String get gigsMarkedUnavailable => 'Wagaragajwe nk\'utaboneka.';

  @override
  String get gigsProviderDashboard => 'Imbonerahamwe y\'utanga serivisi';

  @override
  String get gigsAcceptNewRequests => 'Emera ubusabe bushya';

  @override
  String get gigsAcceptNewRequestsHint =>
      'Iyo bifunze, abakiriya baracyabasha gufungura umwirondoro wawe ariko ntibashobora kugufata.';

  @override
  String get gigsRecordedPayments => 'Ubwishyu bwanditswe (RWF)';

  @override
  String gigsFundedJobs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Akazi $count kishyuwe mu makuru y\'ihuriro',
      one: 'Akazi 1 kishyuwe mu makuru y\'ihuriro',
    );
    return '$_temp0';
  }

  @override
  String get gigsOpenRequests => 'Ubusabe bufunguye';

  @override
  String get gigsAwaitingResponseOrPayment =>
      'Bitegereje igisubizo cyangwa ubwishyu';

  @override
  String get gigsActiveJobs => 'Akazi kari gukorwa';

  @override
  String get gigsPaidOrInProgress => 'Byishyuwe cyangwa birimo gukorwa';

  @override
  String get gigsPayoutsHandledNote =>
      'Ubwishyu n\'amafaranga y\'urubuga bikorwa binyuze muri MTN n\'ibitabo by\'imari usanzwe ukoresha.';

  @override
  String get gigsRequestSentTrack =>
      'Ubusabe bwoherejwe. Bukurikirane muri Ubusabe bwanjye.';

  @override
  String get gigsPricing => 'Ibiciro';

  @override
  String gigsFromPrice(String price) {
    return 'Guhera kuri $price';
  }

  @override
  String get gigsAvailability => 'Igihe aboneka';

  @override
  String get gigsPortfolio => 'Ibikorwa yakoze';

  @override
  String get gigsReviews => 'Ibitekerezo';

  @override
  String get gigsRequestThisProvider => 'Saba uyu utanga serivisi';

  @override
  String get gigsUnavailableNow => 'Ntaboneka ubu';

  @override
  String get gigsVerified => 'Yemejwe';

  @override
  String get gigsBackgroundChecked => 'Amateka ye yagenzuwe';

  @override
  String get gigsStandardProfile => 'Umwirondoro usanzwe w\'utanga serivisi';

  @override
  String gigsReviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibitekerezo $count',
      one: 'Igitekerezo 1',
    );
    return '$_temp0';
  }

  @override
  String gigsJobsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Akazi $count',
      one: 'Akazi 1',
    );
    return '$_temp0';
  }

  @override
  String get gigsAcceptedCustomerCanPay =>
      'Byemewe. Umukiriya ashobora kwishyura muri Ihuriro ry\'serivisi → Ubusabe bwanjye (iminota 5).';

  @override
  String get gigsErrAcceptRetry => 'Kwemera ntibyakunze. Ongera ugerageze.';

  @override
  String get gigsDeclineRequestTitle => 'Wanze ubusabe?';

  @override
  String get gigsDeclineRequestBody => 'Umukiriya azabona ko wanze ubu busabe.';

  @override
  String get gigsDecline => 'Anga';

  @override
  String get gigsAccept => 'Emera';

  @override
  String get gigsRequestDeclined => 'Ubusabe bwanzwe.';

  @override
  String get gigsErrDeclineRetry => 'Kwanga ntibyakunze. Ongera ugerageze.';

  @override
  String get gigsAwaitingYourResponse => 'Bitegereje igisubizo cyawe';

  @override
  String get gigsWaitingForCustomerPayment =>
      'Bitegereje ubwishyu bw\'umukiriya';

  @override
  String get gigsIncomingRequests => 'Ubusabe bwakiriwe';

  @override
  String get gigsInboxEmptyHint =>
      'Umuntu nagusaba serivisi binyuze mu Ihuriro ry\'serivisi, ubusabe bwe buzagaragara hano. Uzagira igihe gito cyo kwemera cyangwa kwanga.';

  @override
  String get gigsAcceptDeadlinePassed => 'Igihe cyo kwemera cyarenze';

  @override
  String gigsCustomerBudget(String amount) {
    return 'Ingengo y\'umukiriya: $amount RWF';
  }

  @override
  String gigsReceivedAt(String date) {
    return 'Byakiriwe $date';
  }

  @override
  String gigsRespondBy(String date) {
    return 'Subiza bitarenze $date';
  }

  @override
  String gigsPaymentDueBy(String date) {
    return 'Kwishyura bitarenze $date';
  }

  @override
  String get gigsErrSignInToRegister =>
      'Ugomba kuba winjiye kugira ngo wiyandikishe nk\'utanga serivisi.';

  @override
  String get gigsErrAddService =>
      'Ongeramo nibura serivisi imwe ushobora gutanga.';

  @override
  String get gigsProfileSaved => 'Umwirondoro w\'utanga serivisi wabitswe.';

  @override
  String gigsSaveOnlineFailed(String error) {
    return 'Kubika kuri interineti ntibyakunze: $error';
  }

  @override
  String get gigsSavedOnDevice =>
      'Byabitswe kuri iki gikoresho. Bizahuzwa seriveri nibonekera.';

  @override
  String get gigsYourProviderProfile => 'Umwirondoro wawe w\'utanga serivisi';

  @override
  String get gigsBecomeProvider => 'Ba utanga serivisi';

  @override
  String get gigsRegistrationIntro =>
      'Bwira abakiriya ibyo utanga. Ushobora kubihindura igihe icyo ari cyo cyose.';

  @override
  String get gigsErrNameMin => 'Andika izina (nibura inyuguti 2).';

  @override
  String get gigsContactPhone => 'Telefoni yo kuvuganirwaho';

  @override
  String get gigsErrPhoneHelps => 'Telefoni ifasha abakiriya kukubona.';

  @override
  String get gigsAboutYou => 'Ibikwerekeyeho';

  @override
  String get gigsErrBioMin =>
      'Ongeramo ibisobanuro bigufi (nibura inyuguti 12).';

  @override
  String get gigsServicesYouProvide => 'Serivisi utanga';

  @override
  String get gigsServicesHint =>
      'Imwe ku murongo (urugero: amazi, isuku yo mu rugo, kugeza ibintu).';

  @override
  String get gigsServices => 'Serivisi';

  @override
  String get gigsServiceAreaOptional => 'Agace ukoreramo (si ngombwa)';

  @override
  String get gigsServiceAreaHint => 'Agace, umujyi cyangwa intera';

  @override
  String get gigsCategoriesOptional => 'Ibyiciro (si ngombwa)';

  @override
  String get gigsCategoriesHint => 'Bifasha abakiriya kuyungurura urutonde.';

  @override
  String get gigsSaveChanges => 'Bika ibyahinduwe';

  @override
  String get gigsSubmitRegistration => 'Ohereza iyandikwa';

  @override
  String get gigsHowProvidersTitle => 'Abatanga serivisi';

  @override
  String get gigsHowProvidersBody =>
      'Abakozi biyandikisha bakerekana serivisi bashobora gukorera abandi.';

  @override
  String get gigsHowRatingsTitle => 'Amanota';

  @override
  String get gigsHowRatingsBody =>
      'Dutanga kandi tuvugurura amanota dushingiye ku igenzura ryacu n\'ibitekerezo by\'abakiriya.';

  @override
  String get gigsHowRequestsTitle => 'Ubusabe';

  @override
  String get gigsHowRequestsBody =>
      'Abakiriya bohereza ubusabe bwa serivisi ku utanga serivisi bahisemo. Agomba kwemera cyangwa kwanga mu minota 30.';

  @override
  String get gigsHowRequestsHighlight => 'Iminota 30 yo kwemera';

  @override
  String get gigsHowPaymentTitle => 'Igihe cyo kwishyura';

  @override
  String get gigsHowPaymentBody =>
      'Nyuma yo kwemerwa, umukiriya yishyura mu minota 5 kugira ngo akazi kemezwe kandi kishyurwe.';

  @override
  String get gigsHowPaymentHighlight => 'Iminota 5 yo kwishyura';

  @override
  String get gigsHowExecutionTitle => 'Ishyirwa mu bikorwa';

  @override
  String get gigsHowExecutionBody =>
      'Iyo byishyuwe, umukozi ashobora kuvugana n\'umukiriya agakora serivisi.';

  @override
  String get gigsHowEscrowTitle => 'Kubika amafaranga no kwishyura';

  @override
  String get gigsHowEscrowBody =>
      'Dukusanya amafaranga binyuze kuri MTN (n\'izindi API zabigenewe). Amafaranga arekurwa impande zombi zimaze kwemeza ko akazi karangiye; ibitabo by\'imari bikurikirana amafaranga asigaye, komisiyo n\'ufitiwe umwenda.';

  @override
  String get gigsHowItWorksTitle => 'Uko Ihuriro ry\'serivisi rikora';

  @override
  String get gigsHowItWorks => 'Uko bikora';

  @override
  String get gigsAdminTools => 'Ibikoresho by\'ubuyobozi';

  @override
  String get gigsHubTagline =>
      'Shaka abantu bagukorera akazi, cyangwa utange ubumenyi bwawe—ubwishyu buguma ku rubuga.';

  @override
  String get gigsFindProviders => 'Shaka abatanga serivisi';

  @override
  String get gigsYourActivity => 'Ibikorwa byawe';

  @override
  String get gigsProviderTools => 'Ibikoresho by\'utanga serivisi';

  @override
  String get gigsEarnOnHub => 'Injiza amafaranga ku Ihuriro ry\'serivisi';

  @override
  String get gigsEarnOnHubBody =>
      'Andikisha serivisi utanga kugira ngo abakiriya bakubone kandi bagufate.';

  @override
  String get gigsNoServicesListed => 'Nta serivisi zirashyirwaho';

  @override
  String gigsMoreCount(String count) {
    return '+$count zindi';
  }

  @override
  String get gigsTapToEditProfile => 'Kanda uhindure umwirondoro';

  @override
  String get gigsEnterMomoNumberFull =>
      'Andika nimero ya MTN MoMo izishyuzwa (konti ya mobile money, si imeyili).';

  @override
  String get gigsPaymentDeclinedDefault => 'Ubwishyu bwanzwe.';

  @override
  String get gigsNothingChargedTryAgain =>
      'Nta mafaranga yakuweho — ushobora kongera ugerageze.';

  @override
  String get gigsPaymentNotConfirmed =>
      'Ubwishyu ntiburemezwa. Emeza ubutumwa bwa MTN kuri telefoni yawe. Niba amafaranga yavuye kuri konti yawe, vugana n\'itsinda ry\'ubufasha ukoresheje ubu busabe aho kongera kwishyura.';

  @override
  String get gigsMoneyLeftContactSupport =>
      'Niba amafaranga yavuye kuri konti yawe, vugana n\'itsinda ry\'ubufasha ukoresheje ubu busabe.';

  @override
  String get gigsPaymentSentNotUpdated =>
      'Ubwishyu bushobora kuba bwoherejwe ariko ntitwashoboye kuvugurura ubusabe.';

  @override
  String gigsPayProvider(String name) {
    return 'Ishyura $name';
  }

  @override
  String get gigsPaySheetIntro =>
      'Twohereza ubutumwa bwa MTN MoMo kuri nimero iri hasi. Bwemeze kuri telefoni yawe; dutegereza kugeza ku minota 5 ngo byemezwe mbere yo kwandika ko ubu busabe bwishyuwe.';

  @override
  String get gigsPaySheetEmailNote =>
      'Niba winjiye ukoresheje imeyili (cyangwa tudafite konti ya mobile money yawe), andika nimero ya MTN MoMo izishyuzwa. Igomba kuba nimero ya mobile money—si imeyili.';

  @override
  String get gigsAmountRwf => 'Amafaranga (RWF)';

  @override
  String get gigsMinimum100Rwf => 'Nibura 100 RWF';

  @override
  String get gigsMomoNumberLabel => 'Nimero ya MTN MoMo izishyuzwa';

  @override
  String get gigsMomoNumberHelper =>
      'Koresha nimero ya konti MTN izohereza ubutumwa, si imeyili winjiriraho';

  @override
  String get gigsErrEnterMomoNumber => 'Andika nimero ya MTN MoMo izishyuzwa';

  @override
  String get gigsErrMobileNotEmail => 'Andika nimero ya telefoni, si imeyili';

  @override
  String get gigsErrValidMobile =>
      'Andika nimero ya telefoni yemewe (imibare gusa, 9–15)';

  @override
  String get gigsWaitingForPayment => 'Dutegereje ubwishyu…';

  @override
  String get gigsSendPaymentRequest => 'Ohereza ubusabe bwo kwishyura';

  @override
  String get gigsChooseService => 'Hitamo serivisi ukeneye.';

  @override
  String get gigsSomethingWentWrong =>
      'Habaye ikibazo. Nyamuneka ongera ugerageze.';

  @override
  String get gigsWhichService => 'Ukeneye iyihe serivisi?';

  @override
  String get gigsAmountYouWillPay => 'Amafaranga uzishyura (RWF)';

  @override
  String get gigsDescribeNeed => 'Sobanura icyo ukeneye';

  @override
  String get gigsDescribeNeedExample =>
      'Urugero: Gukora robine yo mu gikoni iva muri iyi mpera z\'icyumweru. Ndaboneka ku wa Gatandatu mu gitondo.';

  @override
  String get gigsErrMoreDetail =>
      'Nyamuneka ongeraho ibisobanuro bike (nibura inyuguti 20).';

  @override
  String get gigsProviderHas30Min =>
      'Utanga serivisi afite iminota 30 yo kwemera. Nyuma yaho, ushobora kohereza ubusabe bushya.';

  @override
  String get gigsSendRequest => 'Ohereza ubusabe';

  @override
  String get gigsTimelineRequestSent => 'Ubusabe bwoherejwe';

  @override
  String get gigsTimelineProviderAccepted => 'Utanga serivisi yemeye';

  @override
  String get gigsTimelinePaymentReceived => 'Ubwishyu bwakiriwe';

  @override
  String get gigsTimelineWorkInProgress => 'Akazi karimo gukorwa';

  @override
  String get gigsTimelineReviewSubmitted => 'Igitekerezo cyoherejwe';

  @override
  String get gigsOrderTimeline => 'Uko ubusabe bwagenze';

  @override
  String get gigsErrCannotDecline =>
      'Ubu busabe ntibukibasha kwangwa. Bushobora kuba bwararengeje igihe cyangwa bwarakemuwe.';

  @override
  String get gigsErrDecline => 'Kwanga ubusabe ntibyakunze.';

  @override
  String get gigsErrDeclineConnection =>
      'Kwanga ubusabe ntibyakunze. Genzura interineti wongere ugerageze.';

  @override
  String get productEditorCategorySwitchTo => 'Hindura ujye kuri';

  @override
  String get productEditorCategoryPickYours => 'Cyangwa uhitemo kimwe mu byawe';

  @override
  String get productEditorCategorySearchToChange =>
      'Shakisha uhindure icyiciro…';

  @override
  String get productEditorCategorySearch => 'Shakisha ibyiciro…';

  @override
  String get productEditorCategoryNoneYet => 'Nta byiciro urafite';

  @override
  String productEditorCategoryNoMatch(String query) {
    return 'Nta kihuye na \"$query\"';
  }

  @override
  String productEditorCategoryMoreHidden(int count) {
    return 'Hari ibindi $count — komeza wandike ugabanye';
  }

  @override
  String productEditorCategoryCreateNamed(String name) {
    return 'Kora \"$name\"';
  }

  @override
  String get productEditorCategoryFiledUnder => 'Kibitswe muri';

  @override
  String get productEditorCategoryRemove => 'Kuraho icyiciro';

  @override
  String get productEditorCategoryNoneChosen =>
      'Nta cyiciro kirahitwamo — shakisha hejuru cyangwa ukore gishya.';

  @override
  String get productEditorCategoryCreateNew => 'Kora icyiciro gishya';

  @override
  String get productEditorCategoryNew => 'Gishya';

  @override
  String get productEditorCompositeItem => 'Igicuruzwa gikomatanyije';

  @override
  String get productEditorCompositeHint =>
      'Gikozwe mu bindi bicuruzwa — igiciro ni igiteranyo cy\'ibigize';

  @override
  String get productEditorColorSelectShade => 'Hitamo ubwoko bw\'ibara';

  @override
  String get productEditorColorShades => 'AMABARA';

  @override
  String productEditorColorHueShade(String hue, int number) {
    return '$hue · ubwoko $number';
  }

  @override
  String get productEditorColorSwatchHint =>
      'Rikoreshwa nk\'ibara ry\'igicuruzwa muri POS no muri raporo';

  @override
  String get productEditorColorChoose => 'Hitamo ibara';

  @override
  String get productEditorHueRed => 'Umutuku';

  @override
  String get productEditorHueOrange => 'Icunga';

  @override
  String get productEditorHueAmber => 'Umuhondo w\'izahabu';

  @override
  String get productEditorHueGreen => 'Icyatsi';

  @override
  String get productEditorHueTeal => 'Icyatsi-ubururu';

  @override
  String get productEditorHueBlue => 'Ubururu';

  @override
  String get productEditorHueIndigo => 'Ubururu bwijimye';

  @override
  String get productEditorHueViolet => 'Isine';

  @override
  String get productEditorHueSlate => 'Ikigina';

  @override
  String get productEditorReadyToSave => 'Biteguye kubikwa';

  @override
  String productEditorSectionsComplete(String done, String total) {
    return 'Ibice $done kuri $total byuzuye';
  }

  @override
  String get productEditorSaveProduct => 'Bika igicuruzwa';

  @override
  String get productEditorUntitledProduct => 'Igicuruzwa kitagira izina';

  @override
  String get productEditorBreadcrumbNewProduct => 'UBUBIKO · IGICURUZWA GISHYA';

  @override
  String get productEditorBreadcrumbEditProduct =>
      'UBUBIKO · HINDURA IGICURUZWA';

  @override
  String get productEditorBreadcrumbNewComposite =>
      'UBUBIKO · IGIKOMATANYIJE GISHYA';

  @override
  String get productEditorBreadcrumbEditComposite =>
      'UBUBIKO · HINDURA IGIKOMATANYIJE';

  @override
  String get productEditorOptional => 'si ngombwa';

  @override
  String get productEditorItemTypeFinished =>
      'Igicuruzwa cyarangiye — cyiteguye kugurishwa';

  @override
  String get productEditorItemTypeRawMaterial =>
      'Ibikoresho fatizo — bikorwamo ibindi bicuruzwa';

  @override
  String get productEditorItemTypeService => 'Serivisi — nta kibikwa mu bubiko';

  @override
  String get productEditorCategoryHint =>
      'Ishyira iki gicuruzwa mu itsinda muri raporo no kuri ecran yo kugurisha.';

  @override
  String get productEditorItemType => 'Ubwoko bw\'igicuruzwa';

  @override
  String get productEditorItemTypeLocked =>
      'Birafunze — ntibishobora guhinduka nyuma yo gukora igicuruzwa.';

  @override
  String get productEditorItemTypeHint =>
      'Ibicuruzwa byinshi byo mu iduka ni ibyarangiye.';

  @override
  String get productEditorPackagingUnit => 'Igipimo cy\'ipaki';

  @override
  String get productEditorCountryOfOrigin => 'Igihugu gikomokamo';

  @override
  String get productEditorNoCountryList =>
      'Urutonde rw\'ibihugu ntiruraboneka — ibicuruzwa bishya bibikwa nka RW.';

  @override
  String get productEditorCountryDefaultRw => 'RW (isanzwe)';

  @override
  String get productEditorCountriesLoadFailed =>
      'Ntibyashobotse kuzana ibihugu';

  @override
  String get productEditorOriginNotSet => 'inkomoko ntiyashyizweho';

  @override
  String get productEditorTaxDetailsTitle =>
      'Ipaki n\'inkomoko (ku nyandiko z\'imisoro)';

  @override
  String get productEditorTapToHide => 'Kanda uhishe';

  @override
  String get productEditorProfitPerUnit => 'Inyungu kuri buri kimwe';

  @override
  String get productEditorMargin => 'Inyungu ku ijana';

  @override
  String get productEditorSupplyFromComponents =>
      'Igiciro cyo kurangura kibarwa hashingiwe ku bigize';

  @override
  String get productEditorNoVariantsExisting => 'Iki gicuruzwa nta moko gifite';

  @override
  String get productEditorNoVariantsYet => 'Nta moko arajyaho';

  @override
  String get productEditorNoVariantsHint =>
      'Soma barcode cyangwa wandike izina hejuru wongereho ubwoko';

  @override
  String get productEditorSectionsHeading => 'IBICE';

  @override
  String get productEditorScanHint => 'Soma cyangwa wandike izina ry\'ubwoko…';

  @override
  String get productEditorScanWithCamera => 'Soma ukoresheje kamera';

  @override
  String get productEditorAddVariant => 'Ongeraho ubwoko';

  @override
  String get productEditorScanTipPress => 'Kanda';

  @override
  String get productEditorScanTipEnterKey => 'Enter';

  @override
  String get productEditorScanTipOrTapAdd => 'cyangwa ukande Ongeraho ubwoko';

  @override
  String get productEntryAddNewProduct => 'Ongeraho igicuruzwa gishya';

  @override
  String get productEntryEditProduct => 'Hindura igicuruzwa';

  @override
  String get productEntryNameRequired => 'Izina ry\'igicuruzwa rirakenewe';

  @override
  String get productEntryNameTooShort =>
      'Izina ry\'igicuruzwa rigomba kugira nibura inyuguti 3';

  @override
  String get productEntryProductName => 'Izina ry\'igicuruzwa';

  @override
  String get productEntryProductNameHint => 'urugero: Ikawa Arabica';

  @override
  String get productEntryInventoryTitle => 'Ububiko n\'ibyiciro';

  @override
  String get productEntryPackagingUnit => 'Igipimo cy\'ipaki';

  @override
  String get productEntryPriceRequired => 'Igiciro kirakenewe';

  @override
  String get productEntryRetailPrice => 'Igiciro cyo kugurisha';

  @override
  String get productEntrySupplyPrice => 'Igiciro cyo kurangura';

  @override
  String get productEntryQuickScan => 'Gusoma vuba';

  @override
  String get productEntryScanLabel => 'Soma cyangwa wandike izina ry\'ubwoko';

  @override
  String get productionOutputLoadingSku => 'Biracyazwa...';

  @override
  String get inventoryDashboardTotalItems => 'Ibicuruzwa byose';

  @override
  String get inventoryDashboardExpiredItems => 'Ibyarengeje igihe';

  @override
  String get inventoryDashboardLowStockItems => 'Ibisigaye bike';

  @override
  String get inventoryDashboardPendingOrders => 'Ibyatumijwe bitegereje';

  @override
  String get inventoryDashboardFromLastWeek =>
      'ugereranyije n\'icyumweru gishize';

  @override
  String get inventoryDashboardTrendEstimate =>
      'Iki cyerekezo gishingiye ku igereranya';

  @override
  String inventoryDashboardIdValue(String id) {
    return 'ID: $id';
  }

  @override
  String inventoryDashboardCategoryValue(String category) {
    return 'Icyiciro: $category';
  }

  @override
  String inventoryDashboardQuantityValue(String quantity) {
    return 'Ingano: $quantity';
  }

  @override
  String inventoryDashboardLocationValue(String location) {
    return 'Aho biherereye: $location';
  }

  @override
  String inventoryDashboardExpiryDateValue(String date) {
    return 'Itariki byarangiriraho: $date';
  }

  @override
  String inventoryDashboardExpiredLoadError(String error) {
    return 'Habaye ikosa mu kuzana ibyarengeje igihe: $error';
  }

  @override
  String inventoryDashboardNearExpiryLoadError(String error) {
    return 'Habaye ikosa mu kuzana ibigiye kurangira igihe: $error';
  }

  @override
  String get inventoryDashboardViewAll => 'Reba byose';

  @override
  String get inventoryDashboardExpiredOn => 'Byarangiye ku itariki';

  @override
  String get inventoryDashboardAllExpiredItems => 'Ibyarengeje igihe byose';

  @override
  String inventoryDashboardExpiredOnDate(String date) {
    return 'Byarangiye ku wa: $date';
  }

  @override
  String get inventoryDashboardNearExpiryItems => 'Ibigiye kurangira igihe';

  @override
  String inventoryDashboardUnitsAtLocation(int count, String location) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibice $count - $location',
      one: 'Igice 1 - $location',
    );
    return '$_temp0';
  }

  @override
  String inventoryDashboardDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hasigaye iminsi $count',
      one: 'Hasigaye umunsi 1',
    );
    return '$_temp0';
  }

  @override
  String get inventoryDashboardByCategory => 'Ububiko hakurikijwe icyiciro';

  @override
  String get inventoryDashboardStockLevelsTrend => 'Uko ububiko buhinduka';

  @override
  String get inventoryDashboardRecentOrders => 'Ibyatumijwe vuba';

  @override
  String inventoryDashboardOrderLine(String id, String date) {
    return 'Itumiza #$id - $date';
  }

  @override
  String get inventoryDashboardStatusDelivered => 'Byagejejwe';

  @override
  String get inventoryDashboardStatusInTransit => 'Biri mu nzira';

  @override
  String get inventoryDashboardStatusProcessing => 'Biri gutunganywa';

  @override
  String get inventoryDashboardStatusCancelled => 'Byahagaritswe';

  @override
  String get inventoryDashboardRunningLow =>
      'Ibigiye gushira (iteganyagihe ry\'iminsi 7)';

  @override
  String inventoryDashboardStockValue(String stock) {
    return 'Ububiko: $stock';
  }

  @override
  String inventoryDashboardDailyUsage(String usage) {
    return 'Ikoreshwa ku munsi: $usage';
  }

  @override
  String get inventoryDashboardReplenish => 'Ongera ububiko';

  @override
  String get inventoryDashboardUnknownLocation => 'Ntibizwi';

  @override
  String inventoryDashboardBranchFallback(String id) {
    return 'Ishami $id';
  }

  @override
  String get inventoryDashboardUncategorized => 'Nta cyiciro';

  @override
  String stockValueItemsNeedRestock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibicuruzwa $count bikeneye kongerwa',
      one: 'Igicuruzwa 1 gikeneye kongerwa',
    );
    return '$_temp0';
  }

  @override
  String get stockValueViewAllArrow => 'Reba byose →';

  @override
  String get stockValueStatusCritical => 'Birakomeye';

  @override
  String get stockValueStatusLow => 'Bike';

  @override
  String get stockValueStatusOk => 'Bihagije';

  @override
  String get stockValueTitleMobile => 'Agaciro k\'ububiko';

  @override
  String get stockValueTitle => 'Agaciro k\'ububiko';

  @override
  String stockValueProductsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibicuruzwa $count',
      one: 'Igicuruzwa 1',
    );
    return '$_temp0';
  }

  @override
  String get stockValueLoadError => 'Ntibyashobotse kuzana raporo y\'ububiko.';

  @override
  String get stockValueTotalValueCaps => 'AGACIRO KOSE';

  @override
  String stockValueRwfItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'RWF · ibicuruzwa $count',
      one: 'RWF · igicuruzwa 1',
    );
    return '$_temp0';
  }

  @override
  String get stockValueNeedsRestockCaps => 'BIKENEYE KONGERWA';

  @override
  String get stockValueCriticalOrLow => 'bikomeye cyangwa bike';

  @override
  String get stockValuePartialSync =>
      'Amakuru ashobora kuba atuzuye (guhuza kutarangiye).';

  @override
  String get stockValueLowCriticalCaps => 'IBISIGAYE BIKE N\'IBIKOMEYE';

  @override
  String get stockValueNoLowStock =>
      'Nta bicuruzwa bisigaye bike mu makuru ari hano.';

  @override
  String get stockValueByCategoryCaps => 'AGACIRO HAKURIKIJWE ICYICIRO';

  @override
  String get stockValueNoCategoryBreakdown =>
      'Nta gusesengura ku byiciro kuboneka.';

  @override
  String get stockValueLoadingProducts => 'Ibicuruzwa biracyazwa…';

  @override
  String get stockValueRestockHint =>
      'Koresha ububiko cyangwa kwakira ibicuruzwa kugira ngo wongere ububiko.';

  @override
  String get stockValueNoRowsToExport =>
      'Nta mirongo yo kohereza kuri iyi shungura.';

  @override
  String get stockValueCsvProduct => 'Igicuruzwa';

  @override
  String get stockValueCsvUnitPrice => 'Igiciro cy\'ikimwe';

  @override
  String get stockValueCsvStock => 'Ububiko';

  @override
  String get stockValueCsvLineValue => 'Agaciro k\'umurongo';

  @override
  String get stockValueCsvStatus => 'Imiterere';

  @override
  String stockValueCopiedCsvRows(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Imirongo $count yakoporewe nka CSV.',
      one: 'Umurongo 1 wakoporewe nka CSV.',
    );
    return '$_temp0';
  }

  @override
  String stockValueDesktopSubtitle(int products, int categories, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      products,
      locale: localeName,
      other: 'Ibicuruzwa $products',
      one: 'Igicuruzwa 1',
    );
    String _temp1 = intl.Intl.pluralLogic(
      categories,
      locale: localeName,
      other: 'byiciro $categories',
      one: 'cyiciro 1',
    );
    return '$_temp0 mu $_temp1 · Byavuguruwe uyu munsi saa $time';
  }

  @override
  String get stockValueSearchHint => 'Shakisha igicuruzwa cyangwa BCD...';

  @override
  String get stockValueExport => 'Ohereza';

  @override
  String get stockValueRestockOrder => '+ Itumiza ryo kongera ububiko';

  @override
  String get stockValueTotalStockValue => 'Agaciro kose k\'ububiko';

  @override
  String get stockValueAtRetailSupply => 'Ku giciro cyo kugurisha/kurangura';

  @override
  String get stockValueHealthyStock => 'Ububiko buhagije';

  @override
  String get stockValueWellStocked => 'ibicuruzwa bihagije';

  @override
  String stockValuePercentOfCatalogue(String percent) {
    return '$percent% by\'ibicuruzwa byose';
  }

  @override
  String get stockValueCriticalLow => 'Bikomeye / bike';

  @override
  String get stockValueNeedRestocking => 'bikeneye kongerwa';

  @override
  String get stockValueReviewAlerts => 'reba imenyesha →';

  @override
  String get stockValueHighestValueItem => 'Igicuruzwa gifite agaciro kanini';

  @override
  String get stockValueNoValueOnHand => 'Nta gaciro kari mu bubiko';

  @override
  String stockValueTopItemDetail(String value, String units) {
    return '$value · ibice $units';
  }

  @override
  String stockValuePercentOfTotal(String percent) {
    return '$percent% by\'agaciro kose';
  }

  @override
  String get stockValueAllProducts => 'Ibicuruzwa byose';

  @override
  String get stockValueFilterAll => 'Byose';

  @override
  String get stockValueNoProductsMatch =>
      'Nta gicuruzwa gihuye n\'ishakisha cyangwa ishungura.';

  @override
  String get stockValueColProduct => 'IGICURUZWA';

  @override
  String get stockValueColCategory => 'ICYICIRO';

  @override
  String get stockValueColUnitPrice => 'IGICIRO CY\'IKIMWE';

  @override
  String get stockValueColStock => 'UBUBIKO';

  @override
  String get stockValueColValue => 'AGACIRO';

  @override
  String get stockValueColStatus => 'IMITERERE';

  @override
  String get stockValueNoCategoryData => 'Nta makuru y\'ibyiciro.';

  @override
  String get stockValueByCategory => 'Agaciro hakurikijwe icyiciro';

  @override
  String get stockValueRestockAlerts => 'Imenyesha ryo kongera ububiko';

  @override
  String get stockValueNoRestockAlerts => 'Nta menyesha ryo kongera ububiko.';

  @override
  String stockValueUnitsMin(String units, String min) {
    return 'Ibice $units, byibuze: $min';
  }

  @override
  String get stockValueSalesLoadError =>
      'Ntibyashobotse kuzana amakuru y\'igurisha.';

  @override
  String stockValueInStock(String count) {
    return '$count mu bubiko';
  }

  @override
  String stockValuePerUnit(String price) {
    return '$price / ikimwe';
  }

  @override
  String get stockValueStockValueCaps => 'AGACIRO K\'UBUBIKO';

  @override
  String stockValueUnitsTimesPrice(String units, String price) {
    return 'Ibice $units × $price';
  }

  @override
  String get stockValueTotalSalesCaps => 'IGURISHA RYOSE';

  @override
  String stockValueUnitsSoldPeriod(String units) {
    return 'Ibice $units byagurishijwe (muri icyo gihe)';
  }

  @override
  String get stockValueProfitCaps => 'INYUNGU';

  @override
  String stockValueMarginEst(String percent) {
    return 'Inyungu ya $percent% (igereranya)';
  }

  @override
  String get stockValueStockPerformance => 'Uko ububiko bwitwaye';

  @override
  String stockValueRangeDays(int days) {
    return 'Imin. $days';
  }

  @override
  String get stockValueNoSalesVolume => 'Nta gurisha ryabaye muri iki gihe.';

  @override
  String get stockValueSalesVolume => 'Ingano y\'igurisha';

  @override
  String get stockValueDetailedMetrics => 'Ibipimo birambuye';

  @override
  String get stockValueTurnoverCaps => 'IHINDAGURIKA RY\'UBUBIKO';

  @override
  String get stockValueTurnoverFooter =>
      'Ugereranyije n\'ububiko buhari muri iki gihe.';

  @override
  String get stockValueGrossMarginCaps => 'INYUNGU MBUMBE';

  @override
  String get stockValueGrossMarginFooter =>
      'Igereranywa hashingiwe ku giciro cyo kugurisha n\'icyo kurangura ku byagurishijwe.';

  @override
  String get stockValueAvgTransactionCaps => 'IKIGERERANYO CY\'IGURISHA';

  @override
  String get stockValueAvgTransactionFooter =>
      'Amafaranga yinjiye / igurisha ritandukanye muri icyo gihe.';

  @override
  String get stockValueUnitsSoldCaps => 'IBICE BYAGURISHIJWE';

  @override
  String get stockValueUnitsSoldFooter =>
      'Ibice byose muri icyo gihe cyatoranyijwe.';

  @override
  String get stockValueDeleteUnavailable =>
      'Gusiba igicuruzwa mu bubiko ntibishoboka hano.';

  @override
  String get stockValueEditProduct => 'Hindura igicuruzwa';

  @override
  String get stockValueCopiedSummary => 'Incamake yakoporowe.';

  @override
  String get tenantMgmtCommissionAgentMigrationRequired =>
      'Abakozi bahembwa komisiyo gusa bakeneye ivugurura ry\'ububiko bw\'amakuru. Shyiraho migration supabase/migrations/20260518120000_agent_allow_business_login.sql (urugero: supabase db push), cyangwa ufungure \"Emerera kwinjira muri ubu bucuruzi\" wongere ugerageze.';

  @override
  String get tenantMgmtNoBusinessSelected => 'Nta bucuruzi bwatoranyijwe';

  @override
  String get tenantMgmtAgentBranchNameRequired =>
      'Andika izina ry\'ishami ry\'umukozi';

  @override
  String get tenantMgmtBranchNotInBusiness =>
      'Ishami ryatoranyijwe ntiri mu bucuruzi bugezweho. Hindura ubucuruzi cyangwa ishami wongere ugerageze.';

  @override
  String tenantMgmtUserLookupFailed(String details) {
    return 'Ntibyashobotse kubona umukoresha ufite iyi telefoni/imeyili: $details';
  }

  @override
  String get tenantMgmtSavePermissionsSupabaseError =>
      'Kubika uburenganzira byanze (ikosa rya Supabase).';

  @override
  String tenantMgmtSavePermissionsOrphanHint(String error) {
    return '$error Konti yo kwinjira ishobora kuba isanzwe ihari itari ihujwe n\'ubu bucuruzi — fungura Icungabakoresha wongere wongeremo uyu mukoresha urangize.';
  }

  @override
  String tenantMgmtSavePermissionsFailed(String error) {
    return 'Kubika uburenganzira byanze: $error';
  }

  @override
  String tenantMgmtPinGenerationFailed(String details) {
    return 'Gukora PIN y\'umukoresha mushya byanze: $details';
  }

  @override
  String get tenantMgmtOrphanUser =>
      'Umukoresha yakozwe ariko ntahujwe n\'ubu bucuruzi. Ongera ufungure Icungabakoresha ubike, cyangwa ukoreshe migration ya supabase 20260519150000_repair_orphan_users_with_pins.sql.';

  @override
  String get tenantMgmtCreated => 'Umukoresha yakozwe neza';

  @override
  String get tenantMgmtPermissionsSaved =>
      'Uburenganzira bwabitswe. Abari kuri interineti bavugururwa ako kanya; abatariho bazabibona ubutaha binjiye.';

  @override
  String get tenantMgmtPermissionsSavedSelf =>
      'Uburenganzira bwabitswe. Menyu zawe zavuguruwe.';

  @override
  String tenantMgmtUnexpectedError(String error) {
    return 'Habaye ikosa ritunguranye: $error';
  }

  @override
  String get tenantMgmtAdminCannotDelete => 'Abayobozi ntibashobora gusibwa.';

  @override
  String get tenantMgmtDeleted => 'Umukoresha yasibwe neza';

  @override
  String get tenantMgmtDeleteFailed =>
      'Habaye ikosa mu gusiba umukoresha. Ongera ugerageze.';

  @override
  String get tenantMgmtDeleteTitle => 'Siba umukoresha';

  @override
  String get tenantMgmtDeleteConfirm =>
      'Uzi neza ko ushaka gusiba uyu mukoresha?';

  @override
  String get tenantMgmtEnterPhoneOrEmail =>
      'Andika nimero cyangwa imeyili byemewe';

  @override
  String get tenantMgmtPhoneNeedsCountryCode =>
      'Nimero ya telefoni igomba kugira kode y\'igihugu n\'ikimenyetso +';

  @override
  String get tenantMgmtInvalidPhone => 'Nimero ya telefoni itemewe';

  @override
  String get tenantMgmtInvalidPhoneFormat =>
      'Imiterere ya nimero ya telefoni itemewe';

  @override
  String get tenantMgmtModulePermissions => 'UBURENGANZIRA KURI BURI GICE';

  @override
  String get tenantMgmtColModule => 'IGICE';

  @override
  String get tenantMgmtColAccessLevel => 'URWEGO RW\'UBURENGANZIRA';

  @override
  String get tenantMgmtColActive => 'BIRAKORA';

  @override
  String get tenantMgmtFeatureInventory => 'Ububiko';

  @override
  String get tenantMgmtFeatureSettings => 'Igenamiterere';

  @override
  String get tenantMgmtFeatureReports => 'Raporo';

  @override
  String get tenantMgmtFeatureTransactions => 'Ibikorwa';

  @override
  String get tenantMgmtFeatureTickets => 'Amatike';

  @override
  String get tenantMgmtFeatureOrders => 'Ibyatumijwe';

  @override
  String get tenantMgmtFeatureLeads => 'Abakiriya bashobora kuboneka';

  @override
  String get tenantMgmtFeatureAddProduct => 'Ongeraho igicuruzwa';

  @override
  String get tenantMgmtFeatureSales => 'Igurisha';

  @override
  String get tenantMgmtFeatureDriver => 'Umushoferi';

  @override
  String get tenantMgmtFeatureStock => 'Ububiko';

  @override
  String get tenantMgmtFeatureShiftHistory => 'Amateka y\'amasimburana';

  @override
  String get tenantMgmtFeatureTicketReview => 'Isuzuma ry\'amatike';

  @override
  String get tenantMgmtFeatureStockHandover => 'Gutanga ibicuruzwa';

  @override
  String get tenantMgmtFeatureHideStockQuantity => 'Hisha ingano y\'ububiko';

  @override
  String get tenantMgmtAccessNone => 'Nta burenganzira';

  @override
  String get tenantMgmtAccessRead => 'Gusoma';

  @override
  String get tenantMgmtAccessWrite => 'Kwandika';

  @override
  String get tenantMgmtAccessAdmin => 'Umuyobozi';

  @override
  String get tenantMgmtRoleUser => 'Umukoresha';

  @override
  String get tenantMgmtRoleAdmin => 'Umuyobozi';

  @override
  String get tenantMgmtRoleAgent => 'Umukozi';

  @override
  String get tenantMgmtRoleCashier => 'Umubitsi';

  @override
  String get tenantMgmtRoleDriver => 'Umushoferi';

  @override
  String get tenantMgmtRoleViewer => 'Ureba gusa';

  @override
  String get tenantMgmtRoleReviewer => 'Umugenzuzi';

  @override
  String get tenantMgmtRoleStockManager => 'Ushinzwe ububiko';

  @override
  String get tenantMgmtCurrentUsers => 'ABAKORESHA BARIHO';

  @override
  String get tenantMgmtSearchUsers => 'Shakisha abakoresha...';

  @override
  String get tenantMgmtNoUsers => 'Nta bakoresha barahari.';

  @override
  String get tenantMgmtNoUsersMatch =>
      'Nta mukoresha uhuye n\'ishakisha ryawe.';

  @override
  String get tenantMgmtNoContact => 'Nta aho kubariza';

  @override
  String get tenantMgmtNoBranches => 'Nta mashami ahari';

  @override
  String get tenantMgmtUnnamedBranch => 'Ishami ritagira izina';

  @override
  String get tenantMgmtSelectBranch => 'Hitamo ishami';

  @override
  String tenantMgmtErrorValue(String error) {
    return 'Ikosa: $error';
  }

  @override
  String get tenantMgmtUserTypeCaps => 'UBWOKO BW\'UMUKORESHA';

  @override
  String get tenantMgmtEditUser => 'Hindura umukoresha';

  @override
  String get tenantMgmtAddNewUser => 'Ongeraho umukoresha mushya';

  @override
  String get tenantMgmtFullNameCaps => 'AMAZINA YOSE';

  @override
  String get tenantMgmtEnterName => 'Andika izina';

  @override
  String get tenantMgmtPhoneEmailCaps => 'TELEFONI / IMEYILI';

  @override
  String get tenantMgmtAgentBranchNameCaps => 'IZINA RY\'ISHAMI (UMUKOZI)';

  @override
  String get tenantMgmtEnterBranchName => 'Andika izina ry\'ishami';

  @override
  String get tenantMgmtBranchNameTooShort => 'Izina ry\'ishami ni rigufi cyane';

  @override
  String get tenantMgmtUpdateUser => 'Vugurura umukoresha';

  @override
  String get tenantMgmtAddUser => '+ Ongeraho umukoresha';

  @override
  String get tenantMgmtAllowBusinessLogin =>
      'Emerera kwinjira muri ubu bucuruzi';

  @override
  String get tenantMgmtAllowBusinessLoginHint =>
      'Bisanzwe bifunze: umukozi ahabwa PIN ariko abona komisiyo ye gusa muri ubu bucuruzi. Fungura kugira ngo umuhe uburenganzira bwose bukurikije ibiri hasi.';

  @override
  String get tenantMgmtCommissionOnlyHint =>
      'Uburenganzira kuri buri gice ntibukoreshwa mu buryo bwa komisiyo gusa. Umukozi azinjira akoresheje PIN ye abone komisiyo ye gusa muri ubu bucuruzi.';

  @override
  String stockValueUnitsValue(String units) {
    return 'Ibice $units';
  }

  @override
  String stockValueMinValue(String min) {
    return 'byibuze: $min';
  }

  @override
  String stockValueItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibicuruzwa $count',
      one: 'Igicuruzwa 1',
    );
    return '$_temp0';
  }

  @override
  String get dailyReportRecipientsInvalidEmail =>
      'Andika aderesi ya imeyili yemewe.';

  @override
  String get dailyReportRecipientsNoBusiness => 'Nta bucuruzi bwatoranyijwe.';

  @override
  String get dailyReportRecipientsNotSetUpRunMigration =>
      'Abakira raporo ya buri munsi ntibarashyirwaho. Saba umuyobozi wawe gukoresha migration ya Supabase iheruka (business_report_recipients).';

  @override
  String get dailyReportRecipientsDuplicate =>
      'Iyi imeyili isanzwe iri ku rutonde rwa raporo ya buri munsi.';

  @override
  String get dailyReportRecipientsCouldNotAdd =>
      'Ntibyashobotse kongeraho uwakira.';

  @override
  String get dailyReportRecipientsNotSetUp =>
      'Abakira raporo ya buri munsi ntibarashyirwaho.';

  @override
  String get dailyReportRecipientsCouldNotRemove =>
      'Ntibyashobotse gukuraho uwakira.';

  @override
  String dailyReportRecipientsLoadFailed(String error) {
    return 'Ntibyashobotse gufungura abakira raporo ya buri munsi: $error';
  }

  @override
  String get dailyReportRecipientsEnterEmail => 'Andika aderesi ya imeyili.';

  @override
  String get dailyReportRecipientsAdded => 'Uwakira yongewemo.';

  @override
  String dailyReportRecipientsAddFailed(String error) {
    return 'Ntibyashobotse kongeraho uwakira: $error';
  }

  @override
  String get dailyReportRecipientsRemoved => 'Uwakira yakuweho.';

  @override
  String dailyReportRecipientsRemoveFailed(String error) {
    return 'Ntibyashobotse gukuraho uwakira: $error';
  }

  @override
  String get dailyReportRecipientsEmailHint =>
      'urugero: accountant@example.com';

  @override
  String get dailyReportRecipientsLabelHint => 'Izina (si ngombwa)';

  @override
  String get dailyReportRecipientsSave => 'Bika uwakira';

  @override
  String get dailyReportRecipientsAddTitle => 'Ongeraho uwakira';

  @override
  String get dailyReportRecipientsTitle => 'Abakira raporo ya buri munsi';

  @override
  String get dailyReportRecipientsSubtitle =>
      'Imeyili ya nyiri ubucuruzi iri hejuru yakira raporo irambuye y\'ibikorwa bya buri munsi. Ongeraho izindi aderesi kugira ngo nazo zakire iyo raporo.';

  @override
  String get dailyReportRecipientsEmpty => 'Nta bandi bakira barashyirwaho.';

  @override
  String transfersReportPdfExportFailed(String error) {
    return 'Kohereza PDF ntibyakunze: $error';
  }

  @override
  String get transfersReportAllDates => 'Amatariki yose';

  @override
  String transfersReportLoadFailed(String error) {
    return 'Ntibyashobotse gufungura iyimurwa: $error';
  }

  @override
  String get transfersReportSelectDestination => 'Hitamo aho byoherezwa';

  @override
  String get transfersReportSelectDestinationBody =>
      'Hitamo ishami byoherejwemo kugira ngo urebe ibyimuriwe aho hantu.';

  @override
  String transfersReportCountTo(int count, String branch) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Iyimurwa $count',
      one: 'Iyimurwa 1',
    );
    return '$_temp0 bijya kuri $branch';
  }

  @override
  String get transfersReportNoTransfers => 'Nta byimuwe';

  @override
  String get transfersReportNoTransfersBody =>
      'Nta byimuwe bihuye n\'iyi muyunguruzi mu matariki yatoranyijwe.';

  @override
  String get transfersReportTitle => 'Raporo y\'ibyimuwe';

  @override
  String get transfersReportSubtitle => 'Ibicuruzwa byimuriwe ishami runaka';

  @override
  String get transfersReportExportPdf => 'Kohereza PDF';

  @override
  String get transfersReportBranchesLoadFailed =>
      'Ntibyashobotse gufungura amashami';

  @override
  String get transfersReportToBranch => 'Ishami byoherezwamo';

  @override
  String get transfersReportFilterAll => 'Byose';

  @override
  String get transfersReportStatusPending => 'Bitegereje';

  @override
  String get transfersReportStatusProcessing => 'Biri gukorwa';

  @override
  String get transfersReportStatusPartiallyApproved => 'Byemejwe igice';

  @override
  String get transfersReportStatusRejected => 'Byanzwe';

  @override
  String get transfersReportStatusFulfilled => 'Byatanzwe';

  @override
  String get transfersReportStatusVoided => 'Byahagaritswe';

  @override
  String transfersReportItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibicuruzwa $count',
      one: 'Igicuruzwa 1',
    );
    return '$_temp0';
  }

  @override
  String get transfersReportNoLineItems => 'Nta bicuruzwa birimo';

  @override
  String get transfersReportStatusAndDelivery => 'Uko bihagaze n\'itangwa';

  @override
  String get transfersReportStatus => 'Uko bihagaze';

  @override
  String get transfersReportReceivedOn => 'Byakiriwe ku itariki';

  @override
  String get transfersReportViewPdf => 'Reba PDF';

  @override
  String get transfersReportDownload => 'Kuramo';

  @override
  String get transfersReportFromLabel => 'Biva:';

  @override
  String get transfersReportToLabel => 'Bijya:';

  @override
  String transfersReportQty(String qty) {
    return 'Ingano: $qty';
  }

  @override
  String get transfersReportPdfStockTransferSubject =>
      'Iyimurwa ry\'ibicuruzwa';

  @override
  String get transfersReportPdfSaveDialog => 'Bika PDF y\'ibyimuwe';

  @override
  String transfersReportPdfTitleTo(String branch) {
    return 'Ibicuruzwa byimuriwe $branch';
  }

  @override
  String transfersReportPdfTransferCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Iyimurwa $count',
      one: 'Iyimurwa 1',
    );
    return '$_temp0';
  }

  @override
  String transfersReportPdfUnitCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibice $count',
      one: 'Igice 1',
    );
    return '$_temp0';
  }

  @override
  String get transfersReportPdfNoTransfers => 'Nta byimuwe muri iki gihe.';

  @override
  String get transfersReportColDate => 'Itariki';

  @override
  String get transfersReportColFrom => 'Biva';

  @override
  String get transfersReportColProduct => 'Igicuruzwa';

  @override
  String get transfersReportColQty => 'Ingano';

  @override
  String get transfersReportColRequested => 'Byasabwe';

  @override
  String transfersReportPdfTransferFrom(String id, String branch) {
    return 'Iyimurwa $id · rivuye kuri $branch';
  }

  @override
  String transfersReportPdfFooter(String date, String page, String pages) {
    return 'Byakozwe $date · urupapuro $page/$pages';
  }

  @override
  String transfersReportPdfSingleTitle(String id) {
    return 'Iyimurwa ry\'ibicuruzwa $id';
  }

  @override
  String transfersReportPdfApprovedBy(String name) {
    return 'Byemejwe na: $name';
  }

  @override
  String get dailyReportFilesRangeAllTime => 'Igihe cyose';

  @override
  String get dailyReportFilesRangeLast7Days => 'Iminsi 7 ishize';

  @override
  String get dailyReportFilesRangeLast30Days => 'Iminsi 30 ishize';

  @override
  String get dailyReportFilesRangeLast90Days => 'Iminsi 90 ishize';

  @override
  String get dailyReportFilesRangeThisMonth => 'Uku kwezi';

  @override
  String get dailyReportFilesRangeLastMonth => 'Ukwezi gushize';

  @override
  String get dailyReportFilesSortNewest => 'Ibishya mbere';

  @override
  String get dailyReportFilesSortOldest => 'Ibya kera mbere';

  @override
  String get dailyReportFilesSortNameAsc => 'Izina A–Z';

  @override
  String get dailyReportFilesSortNameDesc => 'Izina Z–A';

  @override
  String get dailyReportFilesTypeAll => 'Byose';

  @override
  String get dailyReportFilesTypeTransactions => 'Ibikorwa';

  @override
  String get dailyReportFilesTypeMerged => 'Byahujwe';

  @override
  String get dailyReportFilesShareUnsupportedWeb =>
      'Gusangiza ntibishoboka muri mushakisha.';

  @override
  String get dailyReportFilesShareSubjectOne => 'Raporo ya buri munsi';

  @override
  String get dailyReportFilesNoActiveBranch =>
      'Nta shami rikora ryatoranyijwe.';

  @override
  String get dailyReportFilesNoStorageKey =>
      'Iyi dosiye ntirabona urufunguzo rwo kubikwa.';

  @override
  String dailyReportFilesSaved(String name) {
    return '$name yabitswe';
  }

  @override
  String get dailyReportFilesReportFallback => 'raporo';

  @override
  String dailyReportFilesDownloaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dosiye $count zakuwemo',
      one: 'Dosiye 1 yakuwemo',
    );
    return '$_temp0';
  }

  @override
  String dailyReportFilesShared(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dosiye $count zasangijwe',
      one: 'Dosiye 1 yasangijwe',
    );
    return '$_temp0';
  }

  @override
  String get dailyReportFilesAlreadyArchived =>
      'Dosiye watoranyije zisanzwe zarabitswe mu bubiko.';

  @override
  String get dailyReportFilesSelectedNoStorageKey =>
      'Dosiye watoranyije ntiziraba urufunguzo rwo kubikwa.';

  @override
  String get dailyReportFilesNoneArchived =>
      'Nta dosiye yashoboye kubikwa mu bubiko.';

  @override
  String dailyReportFilesArchived(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dosiye $count zabitswe mu bubiko',
      one: 'Dosiye 1 yabitswe mu bubiko',
    );
    return '$_temp0';
  }

  @override
  String dailyReportFilesArchivedSkipped(String summary, String skipped) {
    return '$summary ($skipped zasimbutswe — nta rufunguzo rwo kubikwa)';
  }

  @override
  String get dailyReportFilesMergeNeedsKeys =>
      'Buri raporo yatoranyijwe igomba kugira urufunguzo rwo kubikwa mbere yo guhuzwa.';

  @override
  String dailyReportFilesMerged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Raporo $count zahujwe. Workbook nshya yongewe ku rutonde.',
      one: 'Raporo 1 yahujwe. Workbook nshya yongewe ku rutonde.',
    );
    return '$_temp0';
  }

  @override
  String get dailyReportFilesCurrentBranch => 'Ishami ririho';

  @override
  String get dailyReportFilesNoBranch => 'Nta shami';

  @override
  String get dailyReportFilesNoBranchSelectedBody =>
      'Hitamo ishami kugira ngo urebe dosiye za Excel za buri munsi.';

  @override
  String get dailyReportFilesLoadFailed => 'Ntibyashobotse gufungura raporo';

  @override
  String get dailyReportFilesCheckConnection =>
      'Reba murandasi yawe wongere ugerageze.';

  @override
  String get dailyReportFilesEmptyTitle => 'Nta raporo za buri munsi zirabaho';

  @override
  String get dailyReportFilesNoMatches => 'Nta bihuye';

  @override
  String get dailyReportFilesEmptyBody =>
      'Raporo z\'iri shami nizimara gukorwa, zizagaragara hano kugira ngo uzikuremo.';

  @override
  String get dailyReportFilesNoMatchesFiltered =>
      'Gerageza ubundi bushakashatsi, andi matariki cyangwa ubundi bwoko.';

  @override
  String get dailyReportFilesNoMatchesSearch =>
      'Gerageza irindi zina rya raporo, indi tariki cyangwa indi ID.';

  @override
  String get dailyReportFilesClearFilters => 'Kuraho iyungurura';

  @override
  String dailyReportFilesSubtitle(String branch) {
    return 'Dosiye za Excel zakorewe $branch. Hitamo dosiye nyinshi kugira ngo uzikurure icyarimwe.';
  }

  @override
  String get dailyReportFilesKpiFiles => 'Dosiye';

  @override
  String get dailyReportFilesKpiNoneYet => 'nta na kimwe kiraboneka';

  @override
  String get dailyReportFilesKpiAvailable => 'zirahari';

  @override
  String get dailyReportFilesKpiReportDays => 'Iminsi ya raporo';

  @override
  String dailyReportFilesKpiDaysGrouped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'iminsi yahurijwe hamwe',
      one: 'umunsi wahurijwe hamwe',
    );
    return '$_temp0';
  }

  @override
  String get dailyReportFilesKpiReadyFiles => 'Dosiye ziteguye';

  @override
  String get dailyReportFilesKpiWithStorageKeys =>
      'zifite urufunguzo rwo kubikwa';

  @override
  String get dailyReportFilesKpiLastGenerated => 'Iheruka gukorwa';

  @override
  String get dailyReportFilesKpiNoExports => 'Nta dosiye zakozwe';

  @override
  String get dailyReportFilesToday => 'Uyu munsi';

  @override
  String get dailyReportFilesYesterday => 'Ejo hashize';

  @override
  String dailyReportFilesSelectedCount(String count) {
    return '$count byatoranyijwe';
  }

  @override
  String dailyReportFilesFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dosiye $count',
      one: 'Dosiye 1',
    );
    return '$_temp0';
  }

  @override
  String get dailyReportFilesAutoSync => 'Bihuzwa ubwabyo buri minota 5';

  @override
  String get dailyReportFilesSearchHint =>
      'Shakisha ukoresheje izina rya raporo, itariki cyangwa ID...';

  @override
  String get dailyReportFilesFocusSearch => 'Jya ku gushakisha (⌘K)';

  @override
  String get dailyReportFilesTypeLabel => 'Ubwoko:';

  @override
  String get dailyReportFilesSortLabel => 'Gutondeka:';

  @override
  String get dailyReportFilesGroupByDay => 'Huriza ku munsi';

  @override
  String get dailyReportFilesFlatList => 'Urutonde rusanzwe';

  @override
  String get dailyReportFilesUnknownDate => 'Itariki itazwi';

  @override
  String get dailyReportFilesNoReportDay => 'Nta munsi wa raporo';

  @override
  String get dailyReportFilesPreview => 'Igaragaza';

  @override
  String get dailyReportFilesDownload => 'Kuramo';

  @override
  String get dailyReportFilesMoreActions => 'Ibindi bikorwa';

  @override
  String get dailyReportFilesShare => 'Sangiza';

  @override
  String get dailyReportFilesArchive => 'Bika mu bubiko';

  @override
  String get dailyReportFilesNameDailyTransactions => 'Ibikorwa bya buri munsi';

  @override
  String get dailyReportFilesNameSalesSummary => 'Incamake y\'igurisha';

  @override
  String get dailyReportFilesNamePaymentsBreakdown => 'Isesengura ry\'ubwishyu';

  @override
  String get dailyReportFilesNameStockMovement => 'Imigendekere y\'ububiko';

  @override
  String dailyReportFilesMergedRange(String start, String end) {
    return '$start - $end (byahujwe)';
  }

  @override
  String dailyReportFilesMergedDay(String day) {
    return '$day (byahujwe)';
  }

  @override
  String get dailyReportFilesMergedWorkbook => 'Workbook yahujwe';

  @override
  String get dailyReportFilesNew => 'Gishya';

  @override
  String get dailyReportFilesReady => 'Biteguye';

  @override
  String get dailyReportFilesPending => 'Bitegereje';

  @override
  String get dailyReportFilesReportFile => 'Dosiye ya raporo';

  @override
  String get dailyReportFilesClosePreview => 'Funga igaragaza';

  @override
  String get dailyReportFilesPreviewLoadFailed =>
      'Ntibyashobotse kugaragaza workbook.';

  @override
  String dailyReportFilesFirstRows(String shown, String total) {
    return 'Imirongo $shown ya mbere muri $total';
  }

  @override
  String get dailyReportFilesRawFilename => 'Izina nyaryo rya dosiye';

  @override
  String get dailyReportFilesStatFileId => 'ID ya dosiye';

  @override
  String get dailyReportFilesStatRows => 'Imirongo';

  @override
  String get dailyReportFilesStatSize => 'Ingano';

  @override
  String get dailyReportFilesStatStatus => 'Uko bihagaze';

  @override
  String get dailyReportFilesStatSheet => 'Urupapuro';

  @override
  String get dailyReportFilesStatFormat => 'Imiterere';

  @override
  String get dailyReportFilesColTime => 'Isaha';

  @override
  String get dailyReportFilesColReceipt => 'Nimero y\'inyemezabwishyu';

  @override
  String get dailyReportFilesColCashier => 'Umubitsi';

  @override
  String get dailyReportFilesColTax => 'Umusoro';

  @override
  String get dailyReportFilesColTotal => 'Igiteranyo cyose';

  @override
  String get dailyReportFilesMerge => 'Huza';

  @override
  String get dailyReportFilesMergeIntoOne => 'Huriza muri workbook imwe';

  @override
  String dailyReportFilesFilesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dosiye zatoranyijwe',
      one: 'dosiye yatoranyijwe',
    );
    return '$_temp0';
  }

  @override
  String get importPurchaseStatusPending => 'Bitegereje';

  @override
  String get importPurchaseStatusRejected => 'Byanzwe';

  @override
  String get importPurchaseStatusProcessing => 'Biri gukorwa';

  @override
  String get importPurchaseStatusWaiting => 'Bitegereje';

  @override
  String get importPurchaseStatusDeclined => 'Byanzwe';

  @override
  String get importPurchaseFilterAll => 'Byose';

  @override
  String get importPurchaseFilterByStatus => 'Yungurura ukurikije imiterere';

  @override
  String get importPurchaseItemCodeCopied => 'Kode y\'igicuruzwa yakoporowe';

  @override
  String get importPurchaseMapLineTitle => 'Huza umurongo w\'ibyaguzwe';

  @override
  String get importPurchaseRraItemCode => 'Kode y\'igicuruzwa ya RRA';

  @override
  String get importPurchaseCreateNewVariant => 'Kora ubwoko bushya';

  @override
  String get importPurchaseCreateNewVariantDesc =>
      'Ikora igicuruzwa mu rutonde ubu kandi ikagihuza n\'uyu murongo w\'ibyaguzwe.';

  @override
  String get importPurchaseMapExistingVariant =>
      'Huza n\'ubwoko busanzwe buhari';

  @override
  String get importPurchaseMapExistingVariantDesc =>
      'Yongera iyi ngano ku bwoko usanzwe ufite mu bubiko.';

  @override
  String get importPurchaseExistingVariant => 'Ubwoko buhari';

  @override
  String get importPurchaseSelectVariantEllipsis => 'Hitamo ubwoko…';

  @override
  String get importPurchaseSupplyPrice => 'Ikiranguzo';

  @override
  String get importPurchaseRetailPrice => 'Igiciro cyo kugurisha';

  @override
  String get importPurchaseCreating => 'Birimo gukorwa…';

  @override
  String get importPurchaseSaveMapping => 'Bika ihuza';

  @override
  String get importPurchaseNoPurchaseInvoices => 'Nta fagitire z\'ibyaguzwe';

  @override
  String get importPurchaseNoPurchaseInvoicesHint =>
      'Nta kihuye n\'aka kayunguruzo. Andika ibyaguzwe cyangwa uhindure akayunguruzo.';

  @override
  String importPurchasePagerRange(String range, String total) {
    return '$range kuri $total';
  }

  @override
  String importPurchaseSupplierHeader(String name, String count) {
    return 'Utanga ibicuruzwa: $name ($count)';
  }

  @override
  String importPurchaseInvoiceHeader(String number) {
    return 'Fagitire: $number';
  }

  @override
  String get importPurchaseProcessing => 'Birimo gukorwa…';

  @override
  String get importPurchaseAcceptAll => 'Emeza byose';

  @override
  String get importPurchaseDeclineAll => 'Anga byose';

  @override
  String get importPurchaseColNo => 'No.';

  @override
  String get importPurchaseColQty => 'Ingano';

  @override
  String get importPurchaseColSupply => 'Ikiranguzo';

  @override
  String get importPurchaseColRetail => 'Igiciro';

  @override
  String get importPurchaseColMapping => 'Ihuza';

  @override
  String importPurchaseMappedTapToChange(String label) {
    return 'Byahujwe · $label — kanda uhindure';
  }

  @override
  String get importPurchaseTapToMapLine => 'Kanda uhuze uyu murongo';

  @override
  String get importPurchaseRetryFailedJob => 'Ongera ugerageze igikorwa cyanze';

  @override
  String get importPurchaseNoImportedItems => 'Nta bicuruzwa byatumijwe hanze';

  @override
  String get importPurchaseNoImportedItemsHint =>
      'Nta kihuye n\'aka kayunguruzo. Hindura akayunguruzo cyangwa utumize ibindi.';

  @override
  String get importPurchaseSelectRowToEdit =>
      'Hitamo umurongo uri hasi uhindure izina, ibiciro n\'ubwoko';

  @override
  String get importPurchaseEditing => 'Birimo guhindurwa';

  @override
  String get importPurchaseItemName => 'Izina ry\'igicuruzwa';

  @override
  String get importPurchaseEnterName => 'Andika izina';

  @override
  String get importPurchaseEnterSupplyPrice => 'Andika ikiranguzo';

  @override
  String get importPurchaseEnterRetailPrice => 'Andika igiciro cyo kugurisha';

  @override
  String get importPurchaseVariant => 'Ubwoko';

  @override
  String get importPurchaseSaveChanges => 'Bika impinduka';

  @override
  String get importPurchaseHsCode => 'Kode ya HS';

  @override
  String get importPurchaseColStatus => 'Imiterere';

  @override
  String get importPurchaseSupplier => 'Utanga ibicuruzwa';

  @override
  String get importPurchaseDate => 'Itariki';

  @override
  String importPurchaseVariantTag(String name) {
    return 'Ubwoko · $name';
  }

  @override
  String get importPurchaseNoVariantAssigned => 'Nta bwoko bwahujwe';

  @override
  String get importPurchaseEditItem => 'Hindura igicuruzwa';

  @override
  String get importPurchaseMapVariant => 'Huza ubwoko';

  @override
  String get importPurchaseNewVariant => 'Ubwoko bushya';

  @override
  String get importPurchaseTabImport => 'Ibitumijwe hanze';

  @override
  String get importPurchasePurchase => 'Ibyaguzwe';

  @override
  String get importPurchaseImports => 'Ibitumijwe hanze';

  @override
  String get importPurchaseSelectVariant => 'Hitamo ubwoko';

  @override
  String get importPurchaseSearchVariants => 'Shakisha ubwoko…';

  @override
  String get importPurchaseFailedToLoadVariants => 'Kuzana ubwoko byanze';

  @override
  String get importPurchaseNameRequired => 'Izina rirakenewe';

  @override
  String get importPurchaseSetBothPrices =>
      'Nyamuneka shyiramo igiciro cyo kugurisha n\'ikiranguzo';

  @override
  String get importPurchaseSelectExistingVariant => 'Hitamo ubwoko buhari';

  @override
  String get importPurchaseMappedToExisting => 'Byahujwe n\'ubwoko buhari';

  @override
  String importPurchaseCreatedVariantWithCode(String code) {
    return 'Ubwoko bwakozwe · $code';
  }

  @override
  String get importPurchaseCreatedVariant => 'Ubwoko bwakozwe';

  @override
  String importPurchaseCouldNotCreateVariant(String error) {
    return 'Ntibyashobotse gukora ubwoko: $error';
  }

  @override
  String importPurchaseLinesNeedMapping(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Imirongo $count iracyakeneye guhuzwa',
      one: 'Umurongo 1 uracyakeneye guhuzwa',
    );
    return '$_temp0';
  }

  @override
  String get importPurchasePurchaseAccepted => 'Ibyaguzwe byemejwe';

  @override
  String get importPurchasePurchaseDeclined => 'Ibyaguzwe byanzwe';

  @override
  String importPurchaseCouldNotAccept(String error) {
    return 'Ntibyashobotse kwemeza ibyaguzwe: $error';
  }

  @override
  String importPurchaseCouldNotDecline(String error) {
    return 'Ntibyashobotse kwanga ibyaguzwe: $error';
  }

  @override
  String importPurchaseApprovedItem(String name) {
    return '\"$name\" byemejwe';
  }

  @override
  String importPurchaseRejectedItem(String name) {
    return '\"$name\" byanzwe';
  }

  @override
  String get importPurchaseRetrySucceeded => 'Kongera kugerageza byakunze';

  @override
  String importPurchaseCouldNotUpdateItem(String name, String error) {
    return 'Ntibyashobotse kuvugurura \"$name\": $error';
  }

  @override
  String importPurchaseItemsNeedPrices(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Ibicuruzwa $count bikeneye ikiranguzo n\'igiciro cyo kugurisha, cyangwa guhuzwa n\'igicuruzwa cyawe',
      one:
          'Igicuruzwa 1 gikeneye ikiranguzo n\'igiciro cyo kugurisha, cyangwa guhuzwa n\'igicuruzwa cyawe',
    );
    return '$_temp0';
  }

  @override
  String importPurchaseApproveItemsTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Emeza ibicuruzwa $count?',
      one: 'Emeza igicuruzwa 1?',
    );
    return '$_temp0';
  }

  @override
  String get importPurchaseApproveAllBody =>
      'Ingano zabyo zongerwa mu bubiko bwawe kandi zikamenyeshwa RRA.';

  @override
  String get importPurchaseApproveAll => 'Emeza byose';

  @override
  String importPurchaseApprovedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibicuruzwa $count byemejwe',
      one: 'Igicuruzwa 1 cyemejwe',
    );
    return '$_temp0';
  }

  @override
  String importPurchaseCouldNotApproveAll(String error) {
    return 'Ntibyashobotse kwemeza byose: $error';
  }

  @override
  String get importPurchaseCouldNotLoadImports =>
      'Ntibyashobotse kuzana ibitumijwe hanze';

  @override
  String get importPurchaseNoImportsWaiting => 'Nta bitumijwe hanze bitegereje';

  @override
  String get importPurchaseNoImportsHere => 'Nta bitumijwe hanze bihari';

  @override
  String get importPurchaseFetchCustomsHint =>
      'Kanda ⟳ uzane imenyekanisha ryawe rya gasutamo kuri RRA.';

  @override
  String importPurchaseApproveAllWaiting(int count) {
    return 'Emeza byose $count bitegereje';
  }

  @override
  String importPurchaseFromOrigin(String origin) {
    return 'bivuye $origin';
  }

  @override
  String importPurchaseCostSellsAt(String cost, String price) {
    return 'Ikiranguzo $cost · kigurishwa $price';
  }

  @override
  String get importPurchaseSetPricesBeforeApproving =>
      'Shyiraho ibiciro mbere yo kwemeza';

  @override
  String get importPurchaseWorking => 'Birimo gukorwa…';

  @override
  String get importPurchaseFailedTapToRetry =>
      'Byanze · kanda wongere ugerageze';

  @override
  String importPurchaseAddsTo(String name) {
    return 'Byongerwa kuri $name';
  }

  @override
  String get importPurchaseNewProduct => 'Igicuruzwa gishya';

  @override
  String get importPurchaseEnterBothPrices =>
      'Andika ibiciro byombi, cyangwa uhuze n\'igicuruzwa ugurisha';

  @override
  String get importPurchaseOrigin => 'Inkomoko';

  @override
  String get importPurchaseDeclaration => 'Imenyekanisha';

  @override
  String get importPurchaseNameInYourShop => 'Izina mu iduka ryawe';

  @override
  String get importPurchaseCreateAsNewProduct => 'Kora nk\'igicuruzwa gishya';

  @override
  String get importPurchaseLinkProductHint =>
      'Cyangwa kanda wongere ibi mu bubiko bw\'igicuruzwa ugurisha';

  @override
  String get importPurchaseStockAddedToProduct =>
      'Ububiko buzongerwa kuri iki gicuruzwa';

  @override
  String get importPurchaseUnlink => 'Kuraho ihuza';

  @override
  String get importPurchaseRetryWithPrevious =>
      'Ongera ugerageze ukoresheje ibyari byanditswe';

  @override
  String get importPurchaseReject => 'Anga';

  @override
  String get importPurchaseApprove => 'Emeza';

  @override
  String get importPurchaseSaveForLater => 'Bika ukore nyuma';

  @override
  String get importPurchaseSearchYourProducts => 'Shakisha ibicuruzwa byawe';

  @override
  String get importPurchaseTypeProductName => 'Andika izina ry\'igicuruzwa';

  @override
  String get importPurchaseNoProductMatches => 'Nta gicuruzwa gihuye';

  @override
  String importPurchaseSellsAt(String price) {
    return 'Kigurishwa $price';
  }

  @override
  String importPurchaseSyncFailed(String error) {
    return 'Guhuza byanze: $error';
  }

  @override
  String get importPurchaseRecordPurchase => 'Andika ibyaguzwe';

  @override
  String get importPurchaseRecordPurchaseSubtitle =>
      'Andika fagitire y\'utanga ibicuruzwa n\'ibiyirimo';

  @override
  String get importPurchaseFetchingInvoices => 'Kuzana fagitire kuri RRA…';

  @override
  String importPurchaseSyncedWithRra(String time) {
    return 'Byahujwe na RRA $time';
  }

  @override
  String get importPurchasePullToRefreshHint =>
      'Kurura hasi uvugurure · kanda ⟳ uzane kuri RRA';

  @override
  String get importPurchaseFetchFromRra => 'Zana kuri RRA';

  @override
  String get importPurchaseCouldNotLoadPurchases =>
      'Ntibyashobotse kuzana ibyaguzwe';

  @override
  String get importPurchaseNothingWaiting => 'Nta kitegereje kwemezwa';

  @override
  String get importPurchaseNoPurchasesHere => 'Nta byaguzwe bihari';

  @override
  String get importPurchaseNoPurchasesHint =>
      'Andika ibyaguzwe, cyangwa uzane fagitire z\'abaguha ibicuruzwa kuri RRA.';

  @override
  String get importPurchaseRecorded => 'Byanditswe';

  @override
  String get importPurchaseFromRra => 'Bivuye kuri RRA';

  @override
  String get importPurchaseOnCredit => 'Ku ideni';

  @override
  String importPurchaseItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibicuruzwa $count',
      one: 'Igicuruzwa 1',
    );
    return '$_temp0';
  }

  @override
  String importPurchaseCardMeta(String number, String time, String items) {
    return 'Fagitire $number · $time · $items';
  }

  @override
  String get importPurchaseDeclineTitle => 'Wanga ibi byaguzwe?';

  @override
  String importPurchaseDeclineBody(String number, String supplier) {
    return 'Fagitire $number ya $supplier ntizongerwa mu bubiko bwawe.';
  }

  @override
  String get importPurchaseDecline => 'Anga';

  @override
  String get importPurchaseNotFound => 'Ibyaguzwe ntibibonetse';

  @override
  String get importPurchaseNotFoundHint =>
      'Bishobora kuba byimukiye mu yindi miterere.';

  @override
  String importPurchaseInclVat(String amount) {
    return 'harimo TVA $amount';
  }

  @override
  String get importPurchasePaidWith => 'Byishyuwe na';

  @override
  String get importPurchaseSupplierTin => 'TIN y\'utanga ibicuruzwa';

  @override
  String importPurchaseItemsHeader(String count) {
    return 'Ibicuruzwa · $count';
  }

  @override
  String get importPurchaseMatchItemsHint =>
      'Huza buri gicuruzwa cy\'utanga ibicuruzwa n\'icyawe mbere yo kwemeza, kugira ngo ububiko bujye ku gicuruzwa nyacyo.';

  @override
  String importPurchaseAcceptWithMatch(int count) {
    return 'Emeza ($count byo guhuza)';
  }

  @override
  String get importPurchaseAccept => 'Emeza';

  @override
  String get importPurchaseMatchedChange => 'Byahujwe · hindura';

  @override
  String get importPurchaseMatchToMyItem => 'Huza n\'igicuruzwa cyanjye';

  @override
  String bulkProductProductCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibicuruzwa $count',
      one: 'Igicuruzwa 1',
    );
    return '$_temp0';
  }

  @override
  String get bulkProductRegisterViaServer =>
      'Andikisha unyuze kuri seriveri (RRA mbere)';

  @override
  String get bulkProductRegisterViaServerHint =>
      'Urutonde rukorwa muri Ditto ari uko RRA imaze kwemeza. Zimya ukoreshe uburyo bwa kera bukorerwa ku gikoresho.';

  @override
  String get bulkProductSaveAll => 'Bika byose';

  @override
  String get bulkProductLoadingAllRows =>
      'Kuzana imirongo yose yo muri spreadsheet (kubika ntibikora kugeza birangiye)…';

  @override
  String get bulkProductParsingSpreadsheet => 'Gusoma spreadsheet…';

  @override
  String bulkProductProgressCount(
    String percent,
    String current,
    String total,
  ) {
    return '$percent · $current kuri $total';
  }

  @override
  String get bulkProductSaving => 'Birimo kubikwa…';

  @override
  String bulkProductRowsMissingName(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Imirongo $count idafite izina',
      one: 'Umurongo 1 udafite izina',
    );
    return '$_temp0';
  }

  @override
  String bulkProductDuplicateBarcodes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Barcode $count zisubiramo',
      one: 'Barcode 1 isubiramo',
    );
    return '$_temp0';
  }

  @override
  String get bulkProductSavingProducts => 'Kubika ibicuruzwa';

  @override
  String bulkProductCurrentOfTotal(String current, String total) {
    return '$current kuri $total';
  }

  @override
  String get bulkProductPleaseWait => 'Tegereza gato…';

  @override
  String get bulkProductHideSaveContinues => 'Hisha · kubika birakomeza';

  @override
  String get bulkProductProgressStaysOnBar =>
      'Aho bigeze bikomeza kugaragara ku murongo uri hejuru y\'imbonerahamwe.';

  @override
  String bulkProductLargeImportBanner(String count) {
    return 'Ibyinjizwa byinshi (ibicuruzwa $count): ushobora guhindura ibiciro n\'amahitamo kuri buri paji. Koresha imyambi iri munsi y\'imbonerahamwe uzane imirongo 20 ikurikira cyangwa ibanza.';
  }

  @override
  String get bulkProductColBarcode => 'Barcode';

  @override
  String get bulkProductColSupplyPrice => 'Ikiranguzo';

  @override
  String get bulkProductColItemClass => 'Icyiciro cy\'igicuruzwa';

  @override
  String get bulkProductColTax => 'Umusoro';

  @override
  String get bulkProductColType => 'Ubwoko';

  @override
  String bulkProductPageStatus(
    String page,
    String pages,
    String start,
    String end,
    String total,
    String visible,
  ) {
    return 'Ipaji $page kuri $pages — guhindura imirongo $start–$end kuri $total ($visible kuri ecran)';
  }

  @override
  String get bulkProductPreviousPage => 'Ipaji ibanza';

  @override
  String get bulkProductNextPage => 'Ipaji ikurikira';

  @override
  String bulkProductShowingRows(String count) {
    return 'Imirongo $count igaragara';
  }

  @override
  String get bulkProductRemoveRow => 'Kuraho umurongo';

  @override
  String get bulkProductNoDataToSave => 'Nta makuru yo kubika';

  @override
  String bulkProductLoadingFullSpreadsheet(String count) {
    return 'Kuzana spreadsheet yose (imirongo ~$count)…';
  }

  @override
  String get bulkProductCouldNotLoadSpreadsheet =>
      'Ntibyashobotse kuzana spreadsheet. Kanda \"Hindura\" uhitemo indi dosiye.';

  @override
  String get bulkProductUploadToPreview =>
      'Ohereza dosiye ya Excel urebe ibicuruzwa';

  @override
  String get bulkProductNoRowsInFile =>
      'Nta mirongo iri muri dosiye — ohereza indi spreadsheet cyangwa wongere imirongo muri Excel.';

  @override
  String bulkProductLargeImportLoading(String count) {
    return 'Ibyinjizwa byinshi (ibicuruzwa ~$count, kuzana dosiye yose…) — Kubika ntibikora kugeza kuzana birangiye.';
  }

  @override
  String bulkProductLargeImportTitle(String count) {
    return 'Ibyinjizwa byinshi (ibicuruzwa $count)';
  }

  @override
  String get bulkProductPreviewLoadingHint =>
      'Herekanwa incamake mu gihe imirongo yose iri kuzanwa. Gukuraho imirongo ntibikora kugeza dosiye yose yiteguye.';

  @override
  String get bulkProductPreviewReadyHint =>
      'Ushobora gukuraho imirongo mu incamake iri hasi. Dosiye yose nimara kwitegura, urabona imbonerahamwe ihindurwa nk\'iy\'ibyinjizwa bike, ibicuruzwa 20 kuri buri paji.';

  @override
  String bulkProductPreviewFirstOf(String count, String total) {
    return 'Incamake (ibya mbere $count kuri $total)';
  }

  @override
  String get bulkProductNoName => '(nta zina)';

  @override
  String bulkProductBarcodePrice(String barcode, String price) {
    return 'Barcode: $barcode · Igiciro: $price';
  }

  @override
  String get bulkProductAvailableAfterLoad =>
      'Bizaboneka dosiye yose imaze kuzanwa';

  @override
  String get bulkProductDropExcelHere => 'Shyira dosiye yawe ya Excel hano';

  @override
  String get bulkProductClickToBrowse =>
      'cyangwa ukande ushakishe mu madosiye yawe';

  @override
  String bulkProductProductsLoaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibicuruzwa $count byazanywe',
      one: 'Igicuruzwa 1 cyazanywe',
    );
    return '$_temp0';
  }

  @override
  String get bulkProductChange => 'Hindura';

  @override
  String get bulkProductSupportedFormats =>
      'Byemewe: .xlsx, .xls (bika WPS nka Excel .xlsx)';

  @override
  String get bulkProductDownloadTemplate => 'Kuramo icyitegererezo';

  @override
  String get bulkProductTypeRawMaterial => 'Ibikoresho fatizo';

  @override
  String get bulkProductTypeFinishedProduct => 'Igicuruzwa cyarangiye';

  @override
  String get bulkProductTypeService => 'Serivisi idafite ububiko';

  @override
  String get bulkProductLoading => 'Birimo kuzanwa…';

  @override
  String get bulkProductSelectCategory => 'Hitamo icyiciro';

  @override
  String get bulkProductSearchCategory => 'Shakisha icyiciro';

  @override
  String get bulkProductAddNewCategory => 'Ongeramo icyiciro gishya';

  @override
  String get bulkProductSaveComplete => 'Kubika byinshi icyarimwe byarangiye';

  @override
  String get bulkProductSaveFailed => 'Kubika byinshi icyarimwe byanze';

  @override
  String get bulkProductStatTotal => 'Igiteranyo';

  @override
  String get bulkProductStatSucceeded => 'Byakunze';

  @override
  String get bulkProductStatFailed => 'Byanze';

  @override
  String get bulkProductTaxRegistrationSkipped =>
      'Kwandikisha imisoro byasimbutswe kuri iri shami.';

  @override
  String bulkProductJobId(String id) {
    return 'Igikorwa $id';
  }

  @override
  String get bulkProductStay => 'Guma';

  @override
  String get stockRecountTitle => 'Kongera kubara ububiko';

  @override
  String get stockRecountNew => 'Ibarura rishya';

  @override
  String get stockRecountStatusAll => 'Byose';

  @override
  String get stockRecountStatusDraft => 'Agateganyo';

  @override
  String get stockRecountStatusSubmitted => 'Byoherejwe';

  @override
  String get stockRecountStatusSynced => 'Byahujwe';

  @override
  String get stockRecountBalanced => 'Biringaniye';

  @override
  String stockRecountNetValue(String value) {
    return '$value muri rusange';
  }

  @override
  String get stockRecountExporting => 'Birimo koherezwa…';

  @override
  String get stockRecountExportPdf => 'Kohereza PDF';

  @override
  String stockRecountStartFailed(String error) {
    return 'Ntibyashobotse gutangira ibarura: $error';
  }

  @override
  String get stockRecountDeleteTitle => 'Gusiba ibarura?';

  @override
  String get stockRecountDeleteMessage =>
      'Gusiba iri barura ry\'agateganyo? Ntibishobora gusubizwaho.';

  @override
  String get stockRecountDeleted => 'Ibarura ryasibwe';

  @override
  String stockRecountDeleteFailed(String error) {
    return 'Gusiba byanze: $error';
  }

  @override
  String stockRecountExportFailed(String error) {
    return 'Kohereza byanze: $error';
  }

  @override
  String get stockRecountSearchHint =>
      'Shakisha igikoresho, icyitonderwa cyangwa igicuruzwa…';

  @override
  String get stockRecountClearFilters => 'Kuraho akayunguruzo';

  @override
  String get stockRecountStartNew => 'Tangira ibarura rishya';

  @override
  String get stockRecountFilter => 'Muyunguruzi';

  @override
  String get stockRecountNothingMatches => 'Nta gihuye';

  @override
  String get stockRecountNoRecountsYet => 'Nta barura rirakorwa';

  @override
  String get stockRecountNothingMatchesHint =>
      'Gerageza irindi jambo cyangwa akandi kayunguruzo ngo ubone ibarura ushaka.';

  @override
  String get stockRecountEmptyHint =>
      'Tangira ibarura rishya ubare ibiri mu bubiko ubigereranye n\'ibiri muri sisitemu.';

  @override
  String get stockRecountUnknownDevice => 'Igikoresho kitazwi';

  @override
  String stockRecountItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibicuruzwa $count',
      one: 'Igicuruzwa 1',
    );
    return '$_temp0';
  }

  @override
  String stockRecountShortCount(String count) {
    return '$count byabuze';
  }

  @override
  String stockRecountMatchingCount(String count) {
    return '$count bihuye';
  }

  @override
  String stockRecountSurplusCount(String count) {
    return '$count birenga';
  }

  @override
  String get stockRecountDeleteDraft => 'Siba agateganyo';

  @override
  String stockRecountAlreadyInCount(String name) {
    return '$name gisanzwe kiri muri iri barura';
  }

  @override
  String stockRecountAddedToCount(String name) {
    return '$name cyongewe mu ibarura';
  }

  @override
  String stockRecountAddItemFailed(String error) {
    return 'Ntibyashobotse kongeramo igicuruzwa: $error';
  }

  @override
  String stockRecountUpdateFailed(String error) {
    return 'Kuvugurura byanze: $error';
  }

  @override
  String get stockRecountItemRemoved => 'Igicuruzwa cyakuweho';

  @override
  String stockRecountRemoveFailed(String error) {
    return 'Gukuraho byanze: $error';
  }

  @override
  String get stockRecountUnknownBarcode => 'Barcode itazwi';

  @override
  String stockRecountScanned(String name) {
    return '$name cyasikanwe — hindura umubare niba bikenewe';
  }

  @override
  String get stockRecountSubmitTitle => 'Kohereza ibarura?';

  @override
  String get stockRecountSubmitMessage =>
      'Ibi bihindura ingano y\'ububiko hakurikijwe imibare wabaze.';

  @override
  String get stockRecountSubmitted => 'Ibarura ryoherejwe ✓';

  @override
  String stockRecountSubmitFailed(String error) {
    return 'Kohereza byanze: $error';
  }

  @override
  String get stockRecountInfo =>
      'Bara ibiri mu bubiko, gereranya ikinyuranyo, hanyuma wohereze kugira ngo ububiko buhuzwe.';

  @override
  String stockRecountLoadFailed(String error) {
    return 'Ntibyashobotse gufungura ibarura: $error';
  }

  @override
  String get stockRecountNotFound => 'Ibarura ntiryabonetse';

  @override
  String get stockRecountCountedItems => 'Ibicuruzwa byabazwe';

  @override
  String stockRecountItemsNet(int count, String net) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibicuruzwa $count',
      one: 'Igicuruzwa 1',
    );
    return '$_temp0 · muri rusange $net';
  }

  @override
  String stockRecountNetItems(String net, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ibicuruzwa $count',
      one: 'igicuruzwa 1',
    );
    return '$net · $_temp0';
  }

  @override
  String get stockRecountDevice => 'Igikoresho';

  @override
  String stockRecountCreatedAt(String date) {
    return 'Ryakozwe $date';
  }

  @override
  String get stockRecountNoteHint => 'Ongeraho icyitonderwa kuri iri barura…';

  @override
  String get stockRecountNoNote => 'Nta cyitonderwa';

  @override
  String get stockRecountItemsCounted => 'Ibicuruzwa byabazwe';

  @override
  String get stockRecountMatching => 'Bihuye';

  @override
  String get stockRecountSurplus => 'Birenga';

  @override
  String get stockRecountShort => 'Byabuze';

  @override
  String get stockRecountAddProduct => 'Ongeramo igicuruzwa cyo kubara';

  @override
  String get stockRecountProductSearchHint =>
      'Shakisha izina ry\'igicuruzwa, SKU cyangwa barcode…';

  @override
  String stockRecountNoProductMatches(String query) {
    return 'Nta gicuruzwa gihuye na \"$query\".';
  }

  @override
  String get stockRecountAdded => 'Cyongewemo';

  @override
  String get stockRecountInSystem => 'muri sisitemu';

  @override
  String stockRecountStagedLine(String sku, String qty) {
    return 'SKU $sku · $qty muri sisitemu';
  }

  @override
  String stockRecountItemLine(String sku, String time) {
    return 'SKU $sku · cyabazwe saa $time';
  }

  @override
  String stockRecountShrinkageNote(String qty) {
    return 'Wabaze $qty munsi y\'ibiri muri sisitemu — bizandikwa nk\'igihombo.';
  }

  @override
  String stockRecountSurplusNote(String qty) {
    return 'Wabaze $qty hejuru y\'ibiri muri sisitemu — hazandikwa ibirenga.';
  }

  @override
  String get stockRecountSystem => 'Sisitemu';

  @override
  String get stockRecountCounted => 'Byabazwe';

  @override
  String get stockRecountVariance => 'Ikinyuranyo';

  @override
  String get stockRecountEmptyItemsHint =>
      'Shakisha igicuruzwa hejuru cyangwa usikane barcode, hanyuma wandike umubare wabaze.';

  @override
  String get stockRecountNoCountedItems =>
      'Iri barura nta gicuruzwa cyabazwe rifite.';

  @override
  String get stockRecountNetVariance => 'Ikinyuranyo rusange';

  @override
  String get stockRecountTotal => 'Igiteranyo cy\'ibarura';

  @override
  String get stockRecountConfirmShortagesTitle =>
      'Emeza ibyabuze mbere yo kohereza';

  @override
  String stockRecountConfirmShortagesBody(int count, String net) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibicuruzwa $count byabazwe',
      one: 'Igicuruzwa 1 cyabazwe',
    );
    return '$_temp0 munsi y\'ibiri muri sisitemu — kubyemeza bizohereza ikinyuranyo rusange cya $net. Andika impamvu…';
  }

  @override
  String get stockRecountShortageReasonHint =>
      'Impamvu y\'ibura (urugero: byangiritse, byaboze, byibwe)…';

  @override
  String get stockRecountKeepEditing => 'Komeza uhindure';

  @override
  String get stockRecountConfirmSubmit => 'Emeza wohereze';

  @override
  String get stockRecountPointCamera => 'Erekeza kamera kuri barcode';

  @override
  String get stockRecountPdfSubject => 'Raporo yo kongera kubara ububiko';

  @override
  String get stockRecountPdfSaveTitle => 'Bika PDF y\'ibarura ry\'ububiko';

  @override
  String stockRecountPdfReportNumber(String id) {
    return 'Raporo #$id';
  }

  @override
  String get stockRecountPdfNote => 'Icyitonderwa:';

  @override
  String stockRecountPdfCountedByName(String name) {
    return 'Byabazwe na — $name';
  }

  @override
  String get stockRecountPdfApprovedBy => 'Byemejwe na';

  @override
  String get stockRecountPdfFooter =>
      'Byakozwe na Flipper · Kongera kubara ububiko';

  @override
  String get stockRecountCountedBy => 'Byabazwe na';

  @override
  String get stockRecountCreated => 'Ryakozwe';

  @override
  String get stockRecountGenerated => 'Byakozwe';

  @override
  String get stockRecountProduct => 'Igicuruzwa';

  @override
  String stockRecountPdfTotals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ibicuruzwa $count',
      one: 'igicuruzwa 1',
    );
    return 'Igiteranyo · $_temp0';
  }

  @override
  String get stockRecountFallbackAgent => 'Umukozi';

  @override
  String get stockRecountFallbackBranch => 'Ishami';

  @override
  String get productionOutputTitle => 'Umusaruro wakozwe';

  @override
  String get productionOutputNew => 'Gishya';

  @override
  String get productionOutputNewOrder => 'Gahunda nshya';

  @override
  String get productionOutputWorkOrders => 'Gahunda z\'akazi';

  @override
  String productionOutputItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibintu $count',
      one: 'Ikintu 1',
    );
    return '$_temp0';
  }

  @override
  String get productionOutputLoadFailed =>
      'Ntibyashobotse gufungura gahunda z\'akazi';

  @override
  String get productionOutputCheckConnection =>
      'Reba murandasi yawe wongere ugerageze.';

  @override
  String get productionOutputNoWorkOrdersYet => 'Nta gahunda z\'akazi zirahari';

  @override
  String get productionOutputNoWorkOrdersHint =>
      'Kora gahunda y\'akazi kugira ngo utangire gukurikirana umusaruro.';

  @override
  String get productionOutputNewWorkOrder => 'Gahunda y\'akazi nshya';

  @override
  String get productionOutputUnknownProduct => 'Igicuruzwa kitazwi';

  @override
  String get productionOutputUnknown => 'Kitazwi';

  @override
  String get productionOutputPlanned => 'Byateganyijwe';

  @override
  String get productionOutputActual => 'Byakozwe';

  @override
  String get productionOutputVariance => 'Ikinyuranyo';

  @override
  String get productionOutputRecord => 'Andika';

  @override
  String get productionOutputComplete => 'Soza';

  @override
  String get productionOutputStart => 'Tangira';

  @override
  String get productionOutputRecordFailed =>
      'Ntibyashobotse kwandika umusaruro. Ongera ugerageze.';

  @override
  String get productionOutputCompleteFailed =>
      'Ntibyashobotse gusoza iyi gahunda y\'akazi. Ongera ugerageze.';

  @override
  String get productionOutputStartFailed =>
      'Ntibyashobotse gutangira iyi gahunda y\'akazi. Ongera ugerageze.';

  @override
  String get productionOutputCompleteTitle => 'Soza gahunda y\'akazi?';

  @override
  String productionOutputCompleteMessage(String name) {
    return 'Shyira \"$name\" mu byarangiye?';
  }

  @override
  String get productionOutputStartTitle => 'Tangira gahunda y\'akazi?';

  @override
  String productionOutputStartMessage(String name) {
    return 'Tangira gukora \"$name\"?';
  }

  @override
  String get productionOutputRecordOutput => 'Andika umusaruro';

  @override
  String productionOutputProductLabel(String name) {
    return 'Igicuruzwa: $name';
  }

  @override
  String productionOutputTargetLabel(String quantity) {
    return 'Intego: $quantity';
  }

  @override
  String get productionOutputActualQuantity => 'Ingano yakozwe';

  @override
  String get productionOutputReasonMachine => 'Imashini';

  @override
  String get productionOutputReasonMachineDesc =>
      'Imashini yahagaze cyangwa yapfuye';

  @override
  String get productionOutputReasonMaterial => 'Ibikoresho';

  @override
  String get productionOutputReasonMaterialDesc =>
      'Ibura ry\'ibikoresho cyangwa ubuziranenge buke';

  @override
  String get productionOutputReasonLabor => 'Abakozi';

  @override
  String get productionOutputReasonLaborDesc =>
      'Ibura ry\'abakozi cyangwa ubumenyi buke';

  @override
  String get productionOutputReasonQuality => 'Ubuziranenge';

  @override
  String get productionOutputReasonQualityDesc =>
      'Byanzwe mu igenzura ry\'ubuziranenge';

  @override
  String get productionOutputReasonPlanning => 'Igenamigambi';

  @override
  String get productionOutputReasonPlanningDesc =>
      'Ibibazo by\'igenamigambi cyangwa gahunda';

  @override
  String get productionOutputReasonOther => 'Ibindi';

  @override
  String get productionOutputReasonOtherDesc => 'Izindi mpamvu';

  @override
  String get productionOutputStatusPlanned => 'Byateganyijwe';

  @override
  String get productionOutputStatusInProgress => 'Biri gukorwa';

  @override
  String get productionOutputStatusCompleted => 'Byarangiye';

  @override
  String get productionOutputStatusCancelled => 'Byahagaritswe';

  @override
  String get productionOutputRatingExcellent => 'Byiza cyane';

  @override
  String get productionOutputRatingGood => 'Byiza';

  @override
  String get productionOutputRatingFair => 'Biringaniye';

  @override
  String get productionOutputRatingPoor => 'Bibi';

  @override
  String get productionOutputVarianceReason => 'Impamvu y\'ikinyuranyo';

  @override
  String get productionOutputVarianceReasonHint =>
      'Hitamo impamvu nyamukuru y\'ikinyuranyo mu musaruro';

  @override
  String get productionOutputAdditionalNotes => 'Ibisobanuro by\'inyongera';

  @override
  String get productionOutputVarianceNotesHint => 'Sobanura ikinyuranyo…';

  @override
  String get productionOutputEditWorkOrder => 'Hindura gahunda y\'akazi';

  @override
  String get productionOutputCreateWorkOrder => 'Kora gahunda y\'akazi';

  @override
  String get productionOutputUpdateWorkOrder => 'Vugurura gahunda y\'akazi';

  @override
  String get productionOutputFormSubtitle =>
      'Tegura umusaruro w\'ibicuruzwa byawe';

  @override
  String get productionOutputProductMaterialRequired =>
      'Igicuruzwa/Ibikoresho *';

  @override
  String get productionOutputSearchProduct => 'Shakisha igicuruzwa';

  @override
  String get productionOutputSelectProduct => 'Hitamo igicuruzwa';

  @override
  String get productionOutputNoProductsFound => 'Nta gicuruzwa cyabonetse';

  @override
  String get productionOutputNoProductsHint =>
      'Gerageza irindi zina ry\'igicuruzwa cyangwa SKU';

  @override
  String get productionOutputNotAvailable => 'Ntacyo';

  @override
  String get productionOutputPlannedQuantityRequired => 'Ingano iteganyijwe *';

  @override
  String get productionOutputUnits => 'ibice';

  @override
  String get productionOutputRequired => 'Birakenewe';

  @override
  String get productionOutputTargetDateRequired => 'Itariki ntego *';

  @override
  String get productionOutputTargetDate => 'Itariki ntego';

  @override
  String get productionOutputShiftOptional => 'Igihe cy\'akazi (si ngombwa)';

  @override
  String get productionOutputShiftMorning => 'Mu gitondo';

  @override
  String get productionOutputShiftAfternoon => 'Ku manywa';

  @override
  String get productionOutputShiftNight => 'Nijoro';

  @override
  String get productionOutputNotes => 'Ibisobanuro';

  @override
  String get productionOutputNotesHint => 'Andi mabwiriza cyangwa ibitekerezo…';

  @override
  String get productionOutputSaveFailed =>
      'Ntibyashobotse kubika gahunda y\'akazi. Ongera ugerageze.';

  @override
  String get productionOutputChartTitle => 'Umusaruro wateganyijwe n\'uwakozwe';

  @override
  String productionOutputLastDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Iminsi $count ishize',
      one: 'Umunsi ushize',
    );
    return '$_temp0';
  }

  @override
  String get productionOutputVariancePercent => 'Ikinyuranyo %';

  @override
  String get productionOutputNoDataAvailable => 'Nta makuru ahari';

  @override
  String get productionOutputDayMon => 'Mbe';

  @override
  String get productionOutputDayTue => 'Kab';

  @override
  String get productionOutputDayWed => 'Gtu';

  @override
  String get productionOutputDayThu => 'Kan';

  @override
  String get productionOutputDayFri => 'Gnu';

  @override
  String get productionOutputDaySat => 'Gnd';

  @override
  String get productionOutputDaySun => 'Cyu';

  @override
  String get productionOutputEfficiencyRate => 'Igipimo cy\'imikorere';

  @override
  String get productionOutputCompletion => 'Ibyarangiye';

  @override
  String get productionOutputCompletionRate => 'Igipimo cy\'ibyarangiye';

  @override
  String productionOutputCompletedOfTotal(String completed, String total) {
    return '$completed kuri $total';
  }

  @override
  String get productionOutputVarianceReasons => 'Impamvu z\'ibinyuranyo';

  @override
  String get productionOutputNoData => 'Nta makuru';

  @override
  String get productionOutputOverview => 'Incamake y\'umusaruro';

  @override
  String get productionOutputOrders => 'Gahunda';

  @override
  String get productionOutputStatusFilterLabel => 'Imiterere:';

  @override
  String get productionOutputFilterAll => 'Byose';

  @override
  String get productionOutputProduct => 'Igicuruzwa';

  @override
  String get productionOutputStatus => 'Imiterere';

  @override
  String get productionOutputNoWorkOrdersFound =>
      'Nta gahunda y\'akazi yabonetse';

  @override
  String get productionOutputTableEmptyHint =>
      'Kora gahunda y\'akazi kugira ngo utangire gukurikirana umusaruro';

  @override
  String get incomingOrdersIncoming => 'Byinjira';

  @override
  String get incomingOrdersOutgoing => 'Bisohoka';

  @override
  String get incomingOrdersBranchNotFound => 'Ishami ntiryabonetse';

  @override
  String get incomingOrdersBranchLoadFailed =>
      'Ntibyashobotse gufungura ishami rikora';

  @override
  String get incomingOrdersReceivedOrders => 'Ibyatumijwe byakiriwe';

  @override
  String get incomingOrdersSentOrders => 'Ibyatumijwe byoherejwe';

  @override
  String get incomingOrdersErrorLoadingBranch => 'Ikosa mu gufungura ishami';

  @override
  String get incomingOrdersErrorLoadingRequests => 'Ikosa mu gufungura ubusabe';

  @override
  String get incomingOrdersTitle => 'Gucunga ibyatumijwe';

  @override
  String get incomingOrdersSubtitle =>
      'Kurikirana kandi ucunge ibyatumijwe byinjira n\'ibisohoka';

  @override
  String get incomingOrdersPendingRequests => 'Ubusabe butegereje';

  @override
  String incomingOrdersNoRequests(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'pending': 'Nta busabe butegereje',
      'approved': 'Nta busabe bwemejwe',
      'processing': 'Nta busabe buri gukorwa',
      'voided': 'Nta busabe bwasheshwe',
      'rejected': 'Nta busabe bwanzwe',
      'other': 'Nta busabe',
    });
    return '$_temp0';
  }

  @override
  String get incomingOrdersNothingToShow => 'Nta kintu cyo kwerekana ubu.';

  @override
  String get incomingOrdersTryAgain => 'Ongera ugerageze';

  @override
  String incomingOrdersSelectedCount(int count) {
    return '$count byatoranyijwe';
  }

  @override
  String get incomingOrdersNoApprovePermission =>
      'Nta burenganzira ufite bwo kwemeza ibyatumijwe';

  @override
  String get incomingOrdersApprove => 'Emeza';

  @override
  String get incomingOrdersReject => 'Anga';

  @override
  String get incomingOrdersItemsHeading => 'IBICURUZWA';

  @override
  String get incomingOrdersNoItems => 'Nta bicuruzwa biri muri ubu busabe';

  @override
  String incomingOrdersErrorLoadingItems(String error) {
    return 'Ikosa mu gufungura ibicuruzwa: $error';
  }

  @override
  String incomingOrdersUpdateItemFailed(String error) {
    return 'Kuvugurura igicuruzwa byanze: $error';
  }

  @override
  String get incomingOrdersUpdateQtyLabel => 'Hindura ingano:';

  @override
  String get incomingOrdersRequestedLabel => 'Byasabwe:';

  @override
  String get incomingOrdersApprovedLabel => 'Byemejwe:';

  @override
  String get incomingOrdersUpdate => 'Vugurura';

  @override
  String get incomingOrdersStatusDeliveryHeading => 'IMITERERE N\'ITANGWA';

  @override
  String get incomingOrdersStatus => 'Imiterere';

  @override
  String get incomingOrdersRequestedOn => 'Byasabwe ku wa';

  @override
  String get incomingOrdersStatusPending => 'Bitegereje';

  @override
  String get incomingOrdersStatusProcessing => 'Biri gutunganywa';

  @override
  String get incomingOrdersStatusPartiallyApproved => 'Byemejwe igice';

  @override
  String get incomingOrdersStatusRejected => 'Byanzwe';

  @override
  String get incomingOrdersStatusFulfilled => 'Byatanzwe';

  @override
  String get incomingOrdersStatusVoided => 'Byasheshwe';

  @override
  String get incomingOrdersOrderNoteHeading => 'ICYITONDERWA KY\'IBYATUMIJWE';

  @override
  String get incomingOrdersProduce => 'Kora';

  @override
  String get incomingOrdersVoid => 'Sesa';

  @override
  String get incomingOrdersFinishProduction => 'Soza umusaruro';

  @override
  String get incomingOrdersInProduction => 'Biri gukorwa';

  @override
  String get incomingOrdersApproveRequest => 'Emeza ubusabe';

  @override
  String get incomingOrdersApproveAllConfirm =>
      'Uzi neza ko ushaka kwemeza ibicuruzwa byose biri muri ubu busabe?';

  @override
  String get incomingOrdersApproveAll => 'Emeza byose';

  @override
  String get incomingOrdersVoidRequest => 'Sesa ubusabe';

  @override
  String get incomingOrdersVoidConfirm =>
      'Uzi neza ko ushaka gusesa ubu busabe?';

  @override
  String incomingOrdersDeclinedSms(String reference) {
    return 'Ubusabe bwawe bw\'ibicuruzwa #$reference bwanzwe.';
  }

  @override
  String get incomingOrdersVoidSuccess => 'Ubusabe bwasheshwe neza';

  @override
  String incomingOrdersVoidFailed(String error) {
    return 'Gusesa ubusabe byanze: $error';
  }

  @override
  String get incomingOrdersProductionFinished =>
      'Umusaruro wanditswe ko warangiye. Witeguye kwemezwa.';

  @override
  String get incomingOrdersFinishProductionFailed => 'Gusoza umusaruro byanze';

  @override
  String get incomingOrdersUnknown => 'Ntizwi';

  @override
  String get incomingOrdersFromLabel => 'Kuva:';

  @override
  String get incomingOrdersToLabel => 'Kuri:';

  @override
  String incomingOrdersRequestFrom(String branch) {
    return 'Ubusabe buturutse kuri $branch';
  }

  @override
  String incomingOrdersLineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '(ibicuruzwa $count)',
      one: '(igicuruzwa 1)',
    );
    return '$_temp0';
  }

  @override
  String incomingOrdersQtyItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibicuruzwa $count',
      one: 'Igicuruzwa 1',
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
    return 'Ibicuruzwa $approved/$_temp0';
  }

  @override
  String get failedPaymentCardEmailRequired =>
      'Imeyili irakenewe kugira ngo wakire inyemezabwishyu y\'ikarita';

  @override
  String get failedPaymentEnterValidEmail => 'Andika imeyili yemewe';

  @override
  String get failedPaymentPhoneMustStartWith250 =>
      'Nimero ya telefoni igomba gutangirwa na 250';

  @override
  String get failedPaymentPhoneMustBe12Digits =>
      'Nimero ya telefoni igomba kugira imibare 12';

  @override
  String get failedPaymentPhoneCannotExceed12Digits =>
      'Nimero ya telefoni ntishobora kurenza imibare 12';

  @override
  String get failedPaymentInvalidMtnPrefix =>
      'Intangiriro ya nimero ya MTN si yo (igomba gutangirwa na 78 cyangwa 79)';

  @override
  String get failedPaymentLoadingTookTooLong =>
      'Gufungura byatinze cyane. Reba interineti yawe, wongere ufungure paji, cyangwa ugerageze nanone.';

  @override
  String failedPaymentErrorLoadingPlanDetails(String error) {
    return 'Ikosa mu gufungura amakuru y\'ifatabuguzi: $error';
  }

  @override
  String get failedPaymentFailedTryAgain =>
      'Kwishyura byanze, ongera ugerageze';

  @override
  String get failedPaymentFailedToValidateCode => 'Kwemeza kode byanze';

  @override
  String get failedPaymentLoadingDetails =>
      'Turimo gufungura amakuru yo kwishyura…';

  @override
  String get failedPaymentIssueTitle => 'Ikibazo cyo kwishyura';

  @override
  String get failedPaymentCompleteOnCardPage =>
      'Rangiza kwishyura kuri paji y\'ikarita';

  @override
  String get failedPaymentCompleteOnPhone =>
      'Rangiza kwishyura kuri telefoni yawe';

  @override
  String get failedPaymentCardWaitingBody =>
      'Andika amakuru y\'ikarita yawe kuri paji yafunguwe.\nIyi paji izivugurura ubwayo kwishyura nibimara kurangira.';

  @override
  String get failedPaymentMomoWaitingBody =>
      'Ubusabe bwo kwishyura bwoherejwe kuri MTN Mobile Money yawe.\nFungura telefoni yawe wemeze iki gikorwa.';

  @override
  String get failedPaymentReopenPage => 'Ongera ufungure paji yo kwishyura';

  @override
  String get failedPaymentNotNowBackToOptions =>
      'Si ubu — subira ku buryo bwo kwishyura';

  @override
  String get failedPaymentNeedsAttention => 'Kwishyura bikeneye ko ubyitaho';

  @override
  String get failedPaymentNeedsAttentionBody =>
      'Humura, ibi bijya bibaho.\nReka tubikemure vuba.';

  @override
  String get failedPaymentSwitchOrUpgradePlan =>
      'Hindura cyangwa uzamure ifatabuguzi';

  @override
  String get failedPaymentTapToCollapse => 'Kanda ngo ubihine';

  @override
  String get failedPaymentChooseDifferentPlan =>
      'Hitamo irindi fatabuguzi mbere yo kongera kugerageza';

  @override
  String get failedPaymentPlanStillActive =>
      'Ifatabuguzi ryawe riracyakora. Ushobora kuryongera cyangwa kurihindura hepfo. Irishya rizatangira gukurikizwa mu gihe gikurikira cyo kwishyura.';

  @override
  String get failedPaymentEnterpriseServices => 'Serivisi z\'ibigo binini';

  @override
  String get failedPaymentAdditionalServices => 'Serivisi z\'inyongera';

  @override
  String get failedPaymentNewPlanTotal => 'Igiteranyo cy\'ifatabuguzi rishya';

  @override
  String get failedPaymentCouldNotOpenPage =>
      'Ntibyashobotse gufungura paji yo kwishyura kuri iki gikoresho. Gerageza Mobile Money, cyangwa urangirize kwishyura kuri telefoni cyangwa mudasobwa ifite mushakisha.';

  @override
  String get failedPaymentSubscriptionEnded =>
      'Iri fatabuguzi ryarangiye. Hitamo ifatabuguzi hejuru kugira ngo wongere utangire.';

  @override
  String get failedPaymentPageNotReady =>
      'Paji yo kwishyura ntiraboneka. Ongera ugerageze mu kanya.';

  @override
  String get failedPaymentCouldNotOpenCardPage =>
      'Ntibyashobotse gufungura paji yo kwishyura n\'ikarita kuri iki gikoresho. Koresha umurongo uri hepfo, cyangwa wishyure na Mobile Money.';

  @override
  String failedPaymentCardNotStartedWithError(String error) {
    return 'Kwishyura n\'ikarita ntibyashoboye gutangira: $error';
  }

  @override
  String get failedPaymentCardNotStarted =>
      'Kwishyura n\'ikarita ntibyashoboye gutangira.';

  @override
  String get failedPaymentCardNotThrough =>
      'Kwishyura n\'ikarita ntibyakunze. Ongera ugerageze, cyangwa ukoreshe Mobile Money.';

  @override
  String get failedPaymentPayByCard => 'Ishyura n\'ikarita';

  @override
  String get failedPaymentTryAgain => 'Ongera ugerageze';

  @override
  String get failedPaymentOpening => 'Birafunguka…';

  @override
  String get failedPaymentRetrying => 'Turongera kugerageza…';

  @override
  String get failedPaymentTimeout =>
      'Igihe cyo kwishyura cyarangiye. Ongera ugerageze.';

  @override
  String get failedPaymentNothingChargedApprove =>
      'Nta mafaranga yakuweho. Emeza ubusabe bwa Mobile Money kuri telefoni yawe, hanyuma wongere ugerageze.';

  @override
  String failedPaymentFailedWithError(String error) {
    return 'Kwishyura byanze: $error';
  }

  @override
  String get failedPaymentFailedTryAgainShort =>
      'Kwishyura byanze. Ongera ugerageze.';

  @override
  String get failedPaymentFailedAgainTryDifferent =>
      'Kwishyura byongeye kwanga. Gerageza indi nimero ya MTN cyangwa irindi fatabuguzi.';

  @override
  String get failedPaymentMaxSkipReached =>
      'Wageze ku mubare ntarengwa wo gusimbuka. Rangiza kwishyura kugira ngo ukomeze.';

  @override
  String failedPaymentSkipsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ushobora gusimbuka inshuro $count',
      one: 'Ushobora gusimbuka inshuro 1 gusa',
    );
    return '$_temp0';
  }

  @override
  String get failedPaymentSkipForNow => 'Simbuka ubu';

  @override
  String get failedPaymentSkipLimitReached => 'Wageze ku mubare ntarengwa';

  @override
  String get failedPaymentTotal => 'Igiteranyo';

  @override
  String get failedPaymentPlan => 'Ifatabuguzi';

  @override
  String get dashboardNotApplicable => 'Ntibihari';

  @override
  String failedPaymentDiscountWithCode(String code) {
    return 'Igabanyirizwa ($code)';
  }

  @override
  String get failedPaymentBilling => 'Kwishyura';

  @override
  String get failedPaymentAdditionalDevices => 'Ibikoresho by\'inyongera';

  @override
  String get failedPaymentEnterMtnNumber =>
      'Andika nimero yawe ya telefoni ya MTN.';

  @override
  String get failedPaymentPhoneRequiredForMomo =>
      'Nimero ya telefoni irakenewe kuri MTN Mobile Money. Fungura \"Koresha indi nimero ya telefoni\" maze wandike nimero yawe ya MTN.';

  @override
  String failedPaymentReasonNothingCharged(String reason) {
    return '$reason Nta mafaranga yakuweho — ongera ugerageze.';
  }

  @override
  String get failedPaymentDeclinedNothingCharged =>
      'Kwishyura byanzwe. Nta mafaranga yakuweho — ongera ugerageze.';

  @override
  String paymentFinalizeListenerError(String error) {
    return 'Ikosa mu gutegura ikurikirana: $error';
  }

  @override
  String get paymentFinalizeSubscriptionEnded =>
      'Iri fatabuguzi ryarangiye. Hitamo ifatabuguzi kugira ngo wongere utangire.';

  @override
  String get paymentFinalizeReusedCheckout =>
      'Wari usanzwe ufite paji yo kwishyura iri fatabuguzi ifunguye — twayongeye kuyifungura aho gutangiza irindi fatabuguzi.';

  @override
  String get paymentFinalizeNotSeenYet =>
      'Ntiturabona ubwishyu. Burangirize kuri paji yo kwishyura, hanyuma ukande \"Nishyuye\".';

  @override
  String get paymentFinalizeDidNotGoThrough =>
      'Ubwo bwishyu ntibwakunze. Hitamo ifatabuguzi kugira ngo wongere utangire.';

  @override
  String get paymentFinalizeNotArrivedYet =>
      'Ubwishyu ntiburagera. Bishobora gutwara akanya nyuma yo kurangiza kuri paji yo kwishyura.';

  @override
  String paymentFinalizeCouldNotCheck(String error) {
    return 'Ntibyashobotse kugenzura ubwishyu ubu: $error';
  }

  @override
  String get paymentFinalizeWaitingForCard =>
      'Dutegereje ubwishyu bw\'ikarita yawe';

  @override
  String get paymentFinalizeFinishOnPage =>
      'Rangiza kwishyura kuri paji yafunguwe. Iyi paji izivugurura ubwayo nibimara gukunda.';

  @override
  String get paymentFinalizeCompletePayment => 'Rangiza kwishyura';

  @override
  String get paymentFinalizeCardPayment => 'Kwishyura n\'ikarita';

  @override
  String get paymentFinalizeMomoPayment => 'Kwishyura na MTN Mobile Money';

  @override
  String get paymentFinalizeProcessedByCard =>
      'Kwishyura bizakorwa n\'ikarita kuri paji yo kwishyura itekanye';

  @override
  String get paymentFinalizeProcessedByMomo =>
      'Kwishyura bizakorwa hakoreshejwe MTN Mobile Money';

  @override
  String get paymentFinalizePlanSummary => 'Incamake y\'ifatabuguzi';

  @override
  String get paymentFinalizeUseDifferentPhone =>
      'Koresha indi nimero ya telefoni';

  @override
  String get paymentFinalizeSpecifyDifferentNumber =>
      'Shyiraho indi nimero yo kwishyuriraho';

  @override
  String get paymentFinalizeMtnPhoneNumber => 'Nimero ya telefoni ya MTN';

  @override
  String get paymentFinalizeMtnPhoneHelper =>
      'Igomba gutangirwa na 250 78 cyangwa 250 79';

  @override
  String get paymentFinalizeIHavePaid => 'Nishyuye — genzura ubu';

  @override
  String get paymentFinalizeContinueToPage => 'Komeza kuri paji yo kwishyura';

  @override
  String get paymentFinalizeUseDifferentMethod =>
      'Koresha ubundi buryo bwo kwishyura';

  @override
  String paymentFinalizeApproveMomo(String message) {
    return '$message Emeza ubusabe bwa Mobile Money kuri telefoni yawe, hanyuma wongere ugerageze.';
  }

  @override
  String paymentFinalizeFailedToInitiate(String error) {
    return 'Gutangiza kwishyura byanze: $error';
  }

  @override
  String get paymentPlanNoPlansAvailable => 'Nta mafatabuguzi ahari.';

  @override
  String get paymentPlanCouldNotLoadPlans =>
      'Ntibyashobotse gufungura amafatabuguzi. Ongera ugerageze.';

  @override
  String get paymentPlanErrorOccurred => 'Habaye ikosa. Ongera ugerageze.';

  @override
  String get paymentPlanSelectTitle => 'Hitamo ifatabuguzi rikunogeye';

  @override
  String paymentPlanSelectSubtitle(String percent) {
    return 'Hindura ifatabuguzi igihe icyo ari cyo cyose. Kwishyura buri mwaka bikuzigamira $percent%.';
  }

  @override
  String get paymentPlanProceedToPayment => 'Komeza wishyure';

  @override
  String get paymentPlanSettingUp => 'Turimo gutegura ifatabuguzi ryawe…';

  @override
  String get paymentPlanLoadingPlans => 'Turimo gufungura amafatabuguzi…';

  @override
  String get paymentPlanTitle => 'Ifatabuguzi';

  @override
  String get manualPurchasePaidExceedsTotal =>
      'Amafaranga yishyuwe ubu ntashobora kurenza igiteranyo cy\'ibyaguzwe.';

  @override
  String get manualPurchaseRequiredFields =>
      'Hakenewe umucuruzi ugurisha, nimero ya fagitire igizwe n\'imibare, nibura umurongo umwe ufite ingano irenze zeru.';

  @override
  String get manualPurchaseTaxVat18 => 'TVA 18%';

  @override
  String get manualPurchaseTaxExempt => 'Isonewe umusoro';

  @override
  String get manualPurchaseTaxZeroRated => 'Igipimo cya zeru';

  @override
  String get manualPurchaseTaxNonVat => 'Itarimo TVA';

  @override
  String get manualPurchasePaySupplierBy => 'Kwishyura umucuruzi bitarenze';

  @override
  String get manualPurchaseRecordPurchase => 'Andika ibyaguzwe';

  @override
  String get manualPurchaseSupplier => 'Umucuruzi ugurisha';

  @override
  String get manualPurchaseChooseSupplier => 'Hitamo umucuruzi ugurisha';

  @override
  String get manualPurchaseTinOptional => 'TIN (si ngombwa)';

  @override
  String get manualPurchaseTinMustBe9Digits => 'TIN igomba kugira imibare 9';

  @override
  String get manualPurchaseInvoiceNumber => 'Nimero ya fagitire';

  @override
  String get manualPurchaseNextInvoiceHint =>
      'Nimero ikurikira fagitire yawe iheruka';

  @override
  String get manualPurchaseEnterInvoiceNumber => 'Andika nimero ya fagitire';

  @override
  String get manualPurchasePurchaseDate => 'Itariki yo kugura';

  @override
  String get manualPurchaseHowDidYouPay => 'Wishyuye ute?';

  @override
  String get manualPurchasePaidNow => 'Ayishyuwe ubu';

  @override
  String get manualPurchaseItemsEmptyHint =>
      'Ongeramo ibyo waguze ubikuye mu bicuruzwa byawe, cyangwa wandike igicuruzwa gishya.';

  @override
  String get manualPurchaseFromCatalog => 'Mu bicuruzwa';

  @override
  String get manualPurchaseNewItem => 'Igicuruzwa gishya';

  @override
  String get manualPurchaseYouWillOwe => 'Uzaba ufitiye uyu mucuruzi umwenda';

  @override
  String get manualPurchaseUnnamedItem => 'Igicuruzwa kitagira izina';

  @override
  String get manualPurchaseSummary => 'Incamake';

  @override
  String get manualPurchaseTaxableVat18 => 'Ibisoreshwa (TVA 18%)';

  @override
  String get manualPurchaseVatIncluded => 'TVA irimo';

  @override
  String get manualPurchaseExemptZeroRated => 'Isonewe / igipimo cya zeru';

  @override
  String get manualPurchaseSaveAsWaiting => 'Bika bitegereje';

  @override
  String manualPurchaseApproveWithTotal(String total) {
    return 'Emeza · $total';
  }

  @override
  String get manualPurchaseSaveAndApprove => 'Bika kandi wemeze';

  @override
  String get manualPurchaseSearchSuppliers => 'Shakisha abacuruzi bagurisha';

  @override
  String get manualPurchaseNewSupplier => 'Umucuruzi ugurisha mushya';

  @override
  String manualPurchaseAddNamed(String name) {
    return 'Ongeraho \"$name\"';
  }

  @override
  String get manualPurchaseNewSupplierHint =>
      'Bika umucuruzi ugurisha utarakoresha mbere';

  @override
  String get manualPurchaseNoSuppliersYet => 'Nta bacuruzi bagurisha barahari';

  @override
  String manualPurchaseNoSupplierMatches(String query) {
    return 'Nta mucuruzi uhuye na \"$query\"';
  }

  @override
  String manualPurchaseTinValue(String tin) {
    return 'TIN $tin';
  }

  @override
  String get manualPurchaseFromYourInvoices => 'Bivuye muri fagitire zawe';

  @override
  String get manualPurchaseSearchCatalog => 'Shakisha mu bicuruzwa byawe';

  @override
  String get manualPurchaseTypeProductName => 'Andika izina ry\'igicuruzwa';

  @override
  String manualPurchaseNoProductMatches(String query) {
    return 'Nta gicuruzwa gihuye na \"$query\"';
  }

  @override
  String manualPurchaseCostValue(String amount) {
    return 'Ikiguzi $amount';
  }

  @override
  String get manualPurchaseEditItem => 'Hindura igicuruzwa';

  @override
  String get manualPurchaseItemName => 'Izina ry\'igicuruzwa';

  @override
  String get manualPurchaseEnterItemName => 'Andika izina ry\'igicuruzwa';

  @override
  String get manualPurchaseMoreThanZero => 'Birenze 0';

  @override
  String get manualPurchaseUnitCost => 'Ikiguzi cya kimwe';

  @override
  String get manualPurchaseTax => 'Umusoro';

  @override
  String get manualPurchaseLineTotal => 'Igiteranyo cy\'umurongo';

  @override
  String get manualPurchaseAddItem => 'Ongeraho igicuruzwa';

  @override
  String get manualPurchaseSupplierRequired => 'Umucuruzi ugurisha arakenewe';

  @override
  String get manualPurchaseSupplierTin => 'TIN y\'umucuruzi ugurisha';

  @override
  String get manualPurchaseOptionalSuffix => '(si ngombwa)';

  @override
  String manualPurchaseExampleValue(String example) {
    return 'urugero: $example';
  }

  @override
  String get manualPurchaseInvoiceNo => 'Nimero ya fagitire';

  @override
  String get manualPurchaseNumericInvoiceRequired =>
      'Nimero ya fagitire igizwe n\'imibare irakenewe';

  @override
  String get manualPurchasePaymentType => 'Uburyo bwo kwishyura';

  @override
  String get manualPurchaseNoneFullCredit => '(nta na kimwe — ideni ryose)';

  @override
  String get manualPurchaseYouWillOweLabel => 'Uzaba ufite umwenda wa';

  @override
  String get manualPurchaseLineItems => 'Ibicuruzwa';

  @override
  String get manualPurchaseAddFromCatalog => 'Ongeramo uvanye mu bicuruzwa';

  @override
  String get manualPurchaseSearchCatalogEllipsis => 'Shakisha mu bicuruzwa…';

  @override
  String manualPurchaseSupplyAndTax(String price, String tax) {
    return 'Igiciro cyo kurangura: $price · Umusoro: $tax';
  }

  @override
  String get manualPurchaseNoItemsHint =>
      'Nta bicuruzwa biraboneka — ongeramo uvanye mu bicuruzwa byawe cyangwa ukore umurongo mushya.';

  @override
  String get manualPurchaseQty => 'Ingano';

  @override
  String get manualPurchaseTaxable => 'Ibisoreshwa';

  @override
  String get manualPurchaseExemptZero => 'Isonewe / zeru';

  @override
  String get manualPurchaseRequired => 'Birakenewe';

  @override
  String get manualPurchaseNewBadge => 'gishya';

  @override
  String get manualPurchaseDuplicateInvoice => 'Fagitire isubiwemo';

  @override
  String get manualPurchaseDuplicateInvoiceBody =>
      'Hari ibyaguzwe bifite iyi nimero ya fagitire muri iri shami. Ubika uko byagenda kose?';

  @override
  String get manualPurchaseSaveAnyway => 'Bika uko byagenda kose';

  @override
  String get manualPurchaseRecordedApproved =>
      'Ibyaguzwe byanditswe kandi byemejwe';

  @override
  String manualPurchaseApprovalFailed(String error) {
    return 'Ibyaguzwe byabitswe bitegereje. Kwemeza byanze: $error';
  }

  @override
  String get manualPurchaseSavedAsWaiting => 'Ibyaguzwe byabitswe bitegereje';

  @override
  String get manualPurchaseNewSupplierSubtitle =>
      'Ashyirwaho utavuye kuri ibi byaguzwe';

  @override
  String get manualPurchaseSupplierName => 'Izina ry\'umucuruzi ugurisha';

  @override
  String get manualPurchasePhoneOptional => 'Telefoni (si ngombwa)';

  @override
  String get manualPurchaseCreateAndSelect => 'Shyiraho kandi uhitemo';

  @override
  String get manualPurchaseNoMatchingSuppliers => 'Nta bacuruzi bahuye';

  @override
  String get manualPurchaseCreateNewSupplier =>
      'Shyiraho umucuruzi ugurisha mushya';

  @override
  String get manualPurchaseSearchOrEnterSupplier =>
      'Shakisha cyangwa wandike izina ry\'umucuruzi';

  @override
  String get manualPurchaseBackToImport => 'Subira ku Bitumizwa n\'Ibiguzwe';

  @override
  String get manualPurchasePageSubtitle =>
      'Andika fagitire y\'umucuruzi n\'ibiyirimo';

  @override
  String get reportStatusParked => 'Byahagaritswe';

  @override
  String get reportStatusCompleted => 'Byarangiye';

  @override
  String get reportStatusCancelled => 'Byahagaritswe burundu';

  @override
  String get reportStatusPending => 'Bitegereje';

  @override
  String get reportView => 'Reba';

  @override
  String get reportPrint => 'Sohora';

  @override
  String get reportReceiptNo => 'Nimero y\'inyemezabuguzi';

  @override
  String get reportCashier => 'Umubitsi';

  @override
  String get reportType => 'Ubwoko';

  @override
  String get reportStatus => 'Imimerere';

  @override
  String get reportSaleTotal => 'Igiteranyo cy\'igurisha';

  @override
  String get reportByHand => 'Mu ntoki';

  @override
  String get reportBalanceDue => 'Asigaye kwishyurwa';

  @override
  String get reportItemCode => 'Kode y\'igicuruzwa';

  @override
  String get reportBarcode => 'Barcode';

  @override
  String get reportTaxRate => 'Igipimo cy\'umusoro';

  @override
  String get reportProfitMade => 'Inyungu yabonetse';

  @override
  String get reportSupplyAmount => 'Agaciro k\'ibyaranguwe';

  @override
  String get reportTaxPayable => 'Umusoro ugomba kwishyurwa';

  @override
  String get reportNetProfit => 'Inyungu nyayo';

  @override
  String get reportTotalSales => 'Igiteranyo cy\'ibyagurishijwe';

  @override
  String get reportPeriodByHand => 'Igihe — Mu ntoki';

  @override
  String get reportPeriodCredit => 'Igihe — Ideni';

  @override
  String reportStockCountUpdated(String product) {
    return 'Ibarura rya stock ryavuguruwe neza kuri $product';
  }

  @override
  String reportStockCountUpdateFailed(String error) {
    return 'Kuvugurura ibarura rya stock byanze: $error';
  }

  @override
  String get reportDismiss => 'Funga';

  @override
  String get reportTotalStockUnits => 'Stock yose (ibice):';

  @override
  String get reportTotalSalesLines =>
      'Igiteranyo cy\'ibyagurishijwe (imirongo):';

  @override
  String get reportTotalSalesLabel => 'Igiteranyo cy\'ibyagurishijwe:';

  @override
  String reportTransactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibikorwa $count',
      one: 'Igikorwa 1',
    );
    return '$_temp0';
  }

  @override
  String get reportTitleReport => 'Raporo';

  @override
  String get reportTitleStockRecount => 'Kongera kubara stock';

  @override
  String get reportTotalGrossProfit => 'Inyungu mbumbe yose';

  @override
  String get reportClosingBalance => 'Amafaranga asigaye ku musozo';

  @override
  String reportStockRecountFor(String item) {
    return 'Kongera kubara stock #$item';
  }

  @override
  String get reportNewCount => 'Umubare mushya';

  @override
  String get reportPleaseEnterNumber => 'Andika umubare';

  @override
  String get reportSummarized => 'Incamake';

  @override
  String get reportDetailed => 'Birambuye';

  @override
  String get reportZReport => 'Raporo Z';

  @override
  String get reportXReport => 'Raporo X';

  @override
  String get reportSaleReport => 'Raporo y\'igurisha';

  @override
  String get reportPluReport => 'Raporo ya PLU';

  @override
  String get reportGrossProfit => 'Inyungu mbumbe';

  @override
  String get reportStartDate => 'Itariki yo gutangira';

  @override
  String get reportEndDate => 'Itariki yo kurangiza';

  @override
  String get reportTaxAmount => 'Amafaranga y\'umusoro';

  @override
  String get reportPaymentType => 'Uburyo bwo kwishyura';

  @override
  String get reportSaleAmount => 'Agaciro k\'igurisha';

  @override
  String get reportTransactionCount => 'Umubare w\'ibikorwa';

  @override
  String get reportPercentOfTotal => '% by\'igiteranyo';

  @override
  String get reportExpense => 'Ikoreshwa';

  @override
  String get reportTotalExpenses => 'Igiteranyo cy\'ibyakoreshejwe';

  @override
  String reportLabelWithColon(String label) {
    return '$label:';
  }

  @override
  String get reportSavePdfFile => 'Bika dosiye ya PDF';

  @override
  String reportDownloadSubject(String date) {
    return 'Raporo yakuwe - $date';
  }

  @override
  String get reportBusinessFallback => 'Ubucuruzi';

  @override
  String get reportPoweredByFlipper => 'Bikoreshwa na Flipper';

  @override
  String reportGeneratedAt(String date) {
    return 'Yakozwe: $date';
  }

  @override
  String get reportUnknownExpense => 'Ikoreshwa ritazwi';

  @override
  String get reportPdfExportNeedsGrid =>
      'Gusohora PDF bisaba paji ya raporo yuzuye ifite imbonerahamwe. Hagarika gusohora PDF mu igenamiterere kugira ngo usohore Excel hano, cyangwa ukoreshe Raporo kuri mudasobwa.';

  @override
  String get reportDate => 'Itariki';

  @override
  String get reportPaymentMethod => 'Uburyo bwo kwishyura';

  @override
  String get reportWalkInCustomer => 'Umukiriya w\'akanya';

  @override
  String get reportStatusUnknown => 'Ntibizwi';

  @override
  String get reportImportsReport => 'Raporo y\'ibitumizwa';

  @override
  String get reportPurchasesReport => 'Raporo y\'ibyaguzwe';

  @override
  String reportDateValue(String date) {
    return 'Itariki: $date';
  }

  @override
  String get reportRequestDate => 'Itariki y\'ubusabe';

  @override
  String get reportDeclarationNumber => 'Nimero y\'imenyekanisha';

  @override
  String get reportQuantityUnitCode => 'Kode y\'igipimo cy\'ingano';

  @override
  String get reportAgentName => 'Izina ry\'umuhuza';

  @override
  String get reportInvoiceForeignAmount =>
      'Agaciro ka fagitire\nmu mafaranga y\'amahanga';

  @override
  String get reportForeignCurrency => 'Amafaranga\ny\'amahanga';

  @override
  String get reportSalesReport => 'Raporo y\'ibyagurishijwe';

  @override
  String reportPeriodRange(String end, String start) {
    return 'Igihe cya raporo: $start - $end';
  }

  @override
  String get reportTotalRevenue => 'Amafaranga yose yinjiye';

  @override
  String get reportTotalVat => 'TVA yose';

  @override
  String get reportTotalTransactions => 'Ibikorwa byose';

  @override
  String get reportAvgTransaction => 'Impuzandengo y\'igikorwa';

  @override
  String get reportBuyerTin => 'TIN y\'umuguzi';

  @override
  String get reportBuyerName => 'Izina ry\'umuguzi';

  @override
  String get reportReceiptNumberShort => 'Inyemezabuguzi #';

  @override
  String get reportItemsDetails => 'Ibisobanuro by\'ibicuruzwa';

  @override
  String get reportIndividual => 'Umuntu ku giti cye';

  @override
  String reportSaleItemLine(
    String name,
    String price,
    String qty,
    String total,
  ) {
    return '$name\n  Ingano: $qty × $price\n  Igiteranyo: $total';
  }

  @override
  String get reportStandard => 'Bisanzwe';

  @override
  String get branchTransferSelectDifferentBranch =>
      'Hitamo irindi shami ryakira';

  @override
  String branchTransferItemMissingVariant(String name) {
    return 'Igicuruzwa $name kibura ubwoko bwacyo';
  }

  @override
  String get branchTransferCreatedNotLoaded =>
      'Iyimurwa ryakozwe ariko ntiryashoboye gufunguka';

  @override
  String get branchTransferApprovalIncomplete =>
      'Iyimurwa ryakozwe ariko kwemezwa ntibyarangiye; riracyategereje kugenzurwa';

  @override
  String branchTransferSmsReceived(int count, String requestId) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Iyimurwa rya stock: ibicuruzwa $count byakiriwe bivuye mu rindi shami (#$requestId).',
      one:
          'Iyimurwa rya stock: igicuruzwa 1 cyakiriwe kivuye mu rindi shami (#$requestId).',
    );
    return '$_temp0';
  }

  @override
  String get pdfPreparingDocument => 'Turimo gutegura inyandiko…';

  @override
  String get pdfDocument => 'Inyandiko';

  @override
  String pdfReadyToSaveOrShare(String label) {
    return '$label yiteguye kubikwa cyangwa gusangizwa.';
  }

  @override
  String pdfSaveLabelPdf(String label) {
    return 'Bika PDF: $label';
  }

  @override
  String pdfSavedTo(String file, String label) {
    return '$label yabitswe muri $file.';
  }

  @override
  String pdfSavedOnDevice(String label) {
    return '$label yabitswe kuri iki gikoresho.';
  }

  @override
  String pdfReadyChooseWhere(String label) {
    return '$label yiteguye — hitamo aho uyibika.';
  }

  @override
  String get pdfSomethingWentWrong => 'Hari ikitagenze neza. Ongera ugerageze.';

  @override
  String get receiptActionsPreparing => 'Turimo gutegura inyemezabuguzi…';

  @override
  String receiptActionsShareSubject(String reference) {
    return 'Inyemezabuguzi · $reference';
  }

  @override
  String get receiptActionsThankYou => 'Murakoze kugura.';

  @override
  String get receiptActionsBuildFailed =>
      'Ntibyashobotse gutegura inyemezabuguzi y\'iri gurisha. Reba interineti yawe wongere ugerageze.';

  @override
  String get receiptActionsTrainingBlocked =>
      'Inyemezabuguzi z\'imyitozo ntizishobora gusangizwa cyangwa gusohorwa.';

  @override
  String get saleReceiptExpenseRecord => 'Inyandiko y\'ikoreshwa';

  @override
  String get saleReceiptSaleReceipt => 'Inyemezabuguzi y\'igurisha';

  @override
  String get saleReceiptNoLineItems =>
      'Nta bicuruzwa byanditswe kuri iki gikorwa.';

  @override
  String saleReceiptCopyFooter(String date) {
    return 'Kopi y\'umukiriya yakozwe hifashishijwe inyandiko za Flipper ku wa $date. Iyi nyandiko si inyemezabuguzi ya EBM.';
  }

  @override
  String saleReceiptCopyFooterWithEbm(String date) {
    return 'Kopi y\'umukiriya yakozwe hifashishijwe inyandiko za Flipper ku wa $date, amakuru ya EBM y\'iri gurisha akaba yanditse hejuru. Iyi nyandiko si inyemezabuguzi yasinywe na EBM.';
  }

  @override
  String get saleReceiptCustomerCopy => 'Kopi y\'umukiriya';

  @override
  String get saleReceiptReference => 'Nimero ndanga';

  @override
  String get saleReceiptCustomerTin => 'TIN y\'umukiriya';

  @override
  String get saleReceiptChange => 'Amafaranga asubizwa';

  @override
  String saleReceiptRefundedVia(String amount, String method) {
    return 'Yasubijwe: $amount hakoreshejwe $method';
  }

  @override
  String saleReceiptReason(String reason) {
    return 'Impamvu: $reason';
  }

  @override
  String get saleReceiptCard => 'Ikarita';

  @override
  String get refundTransactionAlreadyRefunded =>
      'Iki gikorwa cyamaze gusubizwa';

  @override
  String get refundCannotRefundProforma =>
      'Ntushobora gusubiza inyemezabuguzi ya proforma';

  @override
  String get refundOnlyCompleted =>
      'Ibikorwa byarangiye ni byo byonyine bishobora gusubizwa';

  @override
  String get refundCreditNotFullyPaid =>
      'Ibyagurishijwe ku ideni cyangwa byishyuwe igice ntibishobora gusubizwa bitarishyurwa byose';

  @override
  String get refundEnterPurchaseCodeTitle => 'Andika kode yo kugura';

  @override
  String get refundEnterPurchaseCodeHint => 'Andika kode yo kugura';

  @override
  String get refundNoLineItems => 'Nta bicuruzwa byo gusubiza kuri iki gikorwa';

  @override
  String get refundAmountMustBePositive =>
      'Amafaranga asubizwa agomba kurenza zeru';

  @override
  String get refundAmountExceedsOriginal =>
      'Amafaranga asubizwa ntashobora kurenza ayishyuwe mbere';

  @override
  String get refundPartialVatUnsupported =>
      'Gusubiza igice hamwe na EBM/TVA ntibirashoboka. Koresha gusubiza byose.';

  @override
  String get refundPurchaseCodeRequired => 'Kode yo kugura irakenewe';

  @override
  String get refundCannotRefundReceiptType =>
      'Ntushobora gusubiza ubu bwoko bw\'inyemezabuguzi';

  @override
  String get shiftSignOutAnyway => 'Sohoka uko byagenda kose';

  @override
  String get shiftCheckingYourShift =>
      'Turimo kugenzura igihe cyawe cy\'akazi…';

  @override
  String get shiftCannotCloseShift => 'Ntushobora gufunga igihe cy\'akazi';

  @override
  String get shiftBelongsToAnotherUserSwitch =>
      'Igihe cy\'akazi gifunguye ni icy\'undi mukoresha. Saba uwo mukozi gufunga igihe cye mbere, hanyuma wongere ugerageze guhindura.';

  @override
  String get shiftBelongsToAnotherUserTitle =>
      'Igihe cy\'akazi ni icy\'undi mukoresha';

  @override
  String get shiftBelongsToAnotherUserSignOut =>
      'Igihe cy\'akazi gifunguye cyatangijwe n\'undi mukozi, bityo ntigishobora gufungirwa hano.\n\nUshobora gusohoka. Igihe cy\'akazi kiguma gifunguye kugira ngo uwo mukozi agifunge.';

  @override
  String get shiftCloseToSwitchUser =>
      'Funga igihe cy\'akazi kugira ngo uhindure umukoresha';

  @override
  String get shiftCloseToSignOut => 'Funga igihe cy\'akazi kugira ngo usohoke';

  @override
  String get shiftCouldNotCloseShift =>
      'Ntibyashobotse gufunga igihe cy\'akazi';

  @override
  String shiftCouldNotCloseSignOutAnyway(String error) {
    return 'Igihe cy\'akazi ntigishoboye gufungwa:\n\n$error\n\nUshobora gusohoka uko byagenda kose. Igihe cy\'akazi kiguma gifunguye kandi gishobora gufungwa ubutaha winjiye.';
  }

  @override
  String get shiftClosedTakingToLogin =>
      'Igihe cy\'akazi cyafunzwe neza. Turakujyana ku rupapuro rwo kwinjira…';

  @override
  String get shiftSignOut => 'Sohoka';

  @override
  String get shiftNoOpenShiftContinue =>
      'Nta gihe cy\'akazi gifunguye ufite. Ukomeze ku rupapuro rwo kwinjira?';

  @override
  String get shiftSigningOut => 'Turimo gusohoka…';

  @override
  String shiftTakingTooLongRetry(String error) {
    return 'Biratinda cyane. Reba interineti yawe wongere ugerageze.\n\n$error';
  }

  @override
  String get shiftTakingTooLongSignOutAnyway =>
      'Kugenzura igihe cyawe cy\'akazi biratinda cyane — ushobora kuba udafite interineti.\n\nUshobora gusohoka uko byagenda kose. Igihe cy\'akazi gifunguye kiguma gifunguye kandi gishobora gufungwa ubutaha winjiye.';

  @override
  String shiftCheckFailedRetry(String error) {
    return 'Ongera ugerageze. Ikibazo nigikomeza, reba interineti yawe.\n\n$error';
  }

  @override
  String shiftCheckFailedSignOutAnyway(String error) {
    return 'Igihe cyawe cy\'akazi ntigishoboye kugenzurwa:\n\n$error\n\nUshobora gusohoka uko byagenda kose. Igihe cy\'akazi gifunguye kiguma gifunguye kandi gishobora gufungwa ubutaha winjiye.';
  }

  @override
  String get shiftCouldNotVerify => 'Ntibyashobotse kugenzura igihe cy\'akazi';

  @override
  String endOfShiftTodaysShift(String day) {
    return 'Igihe cy\'akazi cy\'uyu munsi · $day';
  }

  @override
  String get endOfShiftTitle => 'Kurangiza igihe cy\'akazi';

  @override
  String get endOfShiftNoOpenShift => 'Nta gihe cy\'akazi gifunguye';

  @override
  String get endOfShiftCollected => 'Ayakiriwe muri iki gihe cy\'akazi';

  @override
  String get endOfShiftCashDrawer => 'Agasanduku k\'amafaranga';

  @override
  String get endOfShiftSalesCompleted => 'Ibyagurishijwe byarangiye';

  @override
  String get endOfShiftItemsSold => 'Ibicuruzwa byagurishijwe';

  @override
  String get endOfShiftCloseAndSignOut => 'Funga igihe cy\'akazi usohoke';

  @override
  String get endOfShiftSwitchBranch => 'Hindura ishami';

  @override
  String get endOfShiftStaySignedIn => 'Guma winjiye';

  @override
  String get endOfShiftSalesSaved =>
      'Ibyo wagurishije byabitswe — agasanduku kazahuzwa igihe ufunga.';

  @override
  String get endOfShiftAgent => 'Umukozi';

  @override
  String get endOfShiftBranch => 'Ishami';

  @override
  String get signOutSigningYouOut => 'Turimo kugusohora…';

  @override
  String get logoutLoggingOut => 'Turimo gusohoka...';

  @override
  String get posSwitchCouldNotLoadStaff => 'Ntibyashobotse gufungura abakozi';

  @override
  String get posSwitchNoOtherStaff => 'Nta bandi bakozi bahari wahinduriraho.';

  @override
  String get posSwitchUserTitle => 'Hindura umukoresha';

  @override
  String get posSwitchUserSubtitle => 'Hitamo umukozi maze wandike PIN ye';

  @override
  String get posSwitchTapNameLeft =>
      'Kanda ku izina riri ibumoso, hanyuma wandike PIN ye';

  @override
  String get posSwitchTapNameAbove =>
      'Kanda ku izina riri hejuru, hanyuma wandike PIN ye';

  @override
  String get posSwitchEnterPin => 'Andika PIN y\'imibare 6 kugira ngo uhindure';

  @override
  String get posSwitchWhosNext => 'Ukurikiyeho ni nde?';

  @override
  String get posSwitchSelectStaff => 'Hitamo umukozi';

  @override
  String get posSwitchStaff => 'Umukozi';

  @override
  String get posSwitchCannotSwitchUser => 'Ntushobora guhindura umukoresha';

  @override
  String get posSwitchNoLinkedAccount =>
      'Uyu mukozi nta konti y\'ukoresha ifitanye isano na we.';

  @override
  String get posSwitchPinMismatch => 'PIN ntihuye n\'umukozi wahisemo.';

  @override
  String get posSwitchPinUnresolved =>
      'Ntibyashobotse kumenya PIN y\'umukozi wahisemo.';

  @override
  String get posSwitchMissingContext =>
      'Ntushobora guhindura umukoresha hatazwi ubucuruzi/ishami. Sohoka wongere winjire, hanyuma wongere ugerageze guhindura umukoresha.';

  @override
  String get posSwitchCouldNotSwitch => 'Ntibyashobotse guhindura umukoresha';

  @override
  String get posSwitchRefreshStaff => 'Vugurura urutonde rw\'abakozi';

  @override
  String get posSwitchSharedRegister => 'POS · Kesi isangiwe';

  @override
  String get posSwitchNoStaffAvailable => 'Nta bakozi bahari.';

  @override
  String get posSwitchTapYourNameLeft =>
      'Kanda ku izina ryawe riri ibumoso, hanyuma wandike PIN yawe';

  @override
  String get posSwitchTapYourNameAbove =>
      'Kanda ku izina ryawe riri hejuru, hanyuma wandike PIN yawe';

  @override
  String get posSwitchEnterYourPin =>
      'Andika PIN yawe y\'imibare 6 kugira ngo ufungure POS';

  @override
  String get posSwitchWhosServing => 'Ni nde uri kwakira abakiriya?';

  @override
  String get posSwitchWhosOnRegister => 'Ni nde uri kuri kesi?';

  @override
  String posSwitchOpeningPosFor(String name) {
    return 'Turafungurira POS $name…';
  }

  @override
  String get posSwitchOpeningPos => 'Turafungura POS…';

  @override
  String get orderingNoSupplierSelected => 'Nta mucuruzi ugurisha wahiswemo';

  @override
  String get orderingSelectSupplierHint =>
      'Hitamo umucuruzi ugurisha mu ishakisha riri hejuru\nkugira ngo ubone ibicuruzwa bihari';

  @override
  String get orderingNewOrder => 'Komande nshya';

  @override
  String get orderingPointOfSale => 'Aho bagurishiriza';

  @override
  String get orderingTransactionHistory => 'Amateka y\'ibikorwa';

  @override
  String get orderingMoreOptions => 'Andi mahitamo';

  @override
  String get orderingAllProducts => 'Ibicuruzwa byose';

  @override
  String get orderingUncategorised => 'Bitari mu cyiciro';

  @override
  String get orderingCategories => 'Ibyiciro';

  @override
  String get orderingLoading => 'Birafunguka…';

  @override
  String get orderingFilter => 'Akayunguruzo';

  @override
  String get orderingInStockOnly => 'Ibiri muri stock gusa';

  @override
  String get orderingShowRetailMargin => 'Erekana inyungu yo kudandaza';

  @override
  String get orderingHidingOutOfStock =>
      'Turahisha ibicuruzwa umucuruzi adafite.';

  @override
  String get orderingOutOfStockShown =>
      'Ibicuruzwa byashize biracyagaragara, bisizwe umutuku.';

  @override
  String get orderingLastOrder => 'Komande iheruka';

  @override
  String get orderingNoPreviousOrder =>
      'Nta komande yabanje kuri uyu mucuruzi.';

  @override
  String orderingLineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Imirongo $count',
      one: 'Umurongo 1',
    );
    return '$_temp0';
  }

  @override
  String get orderingAwaitingApproval => 'bitegereje kwemezwa';

  @override
  String get orderingApprovedLower => 'byemejwe';

  @override
  String get orderingPartlyApproved => 'byemejwe igice';

  @override
  String get orderingEmpty => 'ntacyo kirimo';

  @override
  String orderingUnitCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ibice $count',
      one: 'Igice 1',
    );
    return '$_temp0';
  }

  @override
  String get orderingThisOrder => 'Iyi komande';

  @override
  String get orderingClearAll => 'Siba byose';

  @override
  String get orderingNoLinesYet => 'Nta murongo urajyamo';

  @override
  String get orderingEmptyHintBefore => 'Shakisha igicuruzwa maze ukande';

  @override
  String get orderingEmptyHintAfter => '— igihuye neza kiza hano.';

  @override
  String get orderingRemoveLine => 'Kuraho umurongo';

  @override
  String orderingCostDeltaVsLast(String delta) {
    return '$delta% ugereranyije n\'iheruka';
  }

  @override
  String orderingOnlyAvailable(String count) {
    return 'hari $count gusa';
  }

  @override
  String get orderingOneLess => 'Gabanya kimwe';

  @override
  String get orderingOneMore => 'Ongeraho kimwe';

  @override
  String orderingVatRate(String rate) {
    return 'TVA $rate%';
  }

  @override
  String get orderingPayWith => 'Ishyura ukoresheje';

  @override
  String get orderingSendingOrder => 'Turohereza komande…';

  @override
  String get orderingAddProductToContinue =>
      'Ongeramo igicuruzwa kugira ngo ukomeze';

  @override
  String get orderingChoosePayment => 'Hitamo uko uri bwishyure';

  @override
  String orderingPlaceOrderTotal(String total) {
    return 'Ohereza komande · $total';
  }

  @override
  String get orderingLoadingPaymentOptions =>
      'Turimo gufungura uburyo bwo kwishyura…';

  @override
  String get orderingPaymentOptionsUnavailable =>
      'Uburyo bwo kwishyura ntibuboneka — komande izoherezwa nta bwo.';

  @override
  String get orderingNoPaymentOption =>
      'Nta buryo bwo kwishyura bwashyizweho kuri ubu bucuruzi — komande izoherezwa nta bwo.';

  @override
  String get orderingDeliveryNoteOptional =>
      'Icyitonderwa cyo kugeza (si ngombwa)';

  @override
  String orderingOrderSentTo(String supplier) {
    return 'Komande yoherejwe kuri $supplier';
  }

  @override
  String get orderingPlacedHint =>
      'Barakira SMS ubu; uzayibona muri Komande zinjira nimara kwemerwa.';

  @override
  String get orderingStartAnotherOrder => 'Tangira indi komande';

  @override
  String get orderingSearchProductsHint =>
      'Shakisha ibicuruzwa, SKU cyangwa barcode…';

  @override
  String get orderingColProduct => 'Igicuruzwa';

  @override
  String get orderingColTheirStock => 'Stock yabo';

  @override
  String get orderingColRetailMargin => 'Igiciro cyo kudandaza · inyungu';

  @override
  String get orderingColOrderQty => 'Ingano yatumijwe';

  @override
  String get orderingStockNone => 'nta na kimwe';

  @override
  String get orderingSupplierNoProducts =>
      'Uyu mucuruzi nta bicuruzwa afite byo gutumiza';

  @override
  String get orderingSupplierNoProductsHint =>
      'Nta na kimwe mu bicuruzwa byabo kirasangizwa ishami ryawe.';

  @override
  String get orderingNothingMatchesFilters =>
      'Nta kintu gihuye n\'utu duyunguruzo';

  @override
  String orderingNothingMatchesQuery(String query) {
    return 'Nta kintu gihuye na “$query”';
  }

  @override
  String get orderingNothingMatchesHint =>
      'Gerageza ijambo rigufi, cyangwa ukureho akayunguruzo k\'ibiri muri stock.';

  @override
  String get orderingCouldNotLoadCatalogue =>
      'Ntibyashobotse gufungura uru rutonde rw\'ibicuruzwa';

  @override
  String get orderingPickerTitle => 'Urimo gutumiza ku wuhe mucuruzi?';

  @override
  String get orderingPickerBody =>
      'Hitamo ishami uranguraho. Ibicuruzwa byabo, igiciro waguzeho giheruka na stock bafite byinjira muri komande ako kanya.';

  @override
  String get orderingSearchSuppliersHint =>
      'Shakisha abacuruzi ukoresheje izina…';

  @override
  String get orderingNotOnList => 'Ntari ku rutonde?';

  @override
  String get orderingCouldNotLoadSuppliers =>
      'Ntibyashobotse gufungura abacuruzi';

  @override
  String get orderingNoOtherBranch => 'Nta rindi shami ryo gutumizaho';

  @override
  String get orderingNoOtherBranchHint =>
      'Ongeraho ishami, cyangwa ushakishe umucuruzi ukoresheje izina.';

  @override
  String get orderingFrequentSuppliers => 'Abacuruzi utumizaho kenshi';

  @override
  String get orderingBranchesYouCanOrderFrom => 'Amashami ushobora gutumizaho';

  @override
  String get orderingOtherBranchesYouCanOrderFrom =>
      'Andi mashami ushobora gutumizaho';

  @override
  String orderingNoSupplierMatches(String query) {
    return 'Nta mucuruzi uhuye na “$query”';
  }

  @override
  String get orderingNoSupplierMatchesHint =>
      'Reba uko wanditse, cyangwa umwongereho nk\'ishami rishya.';

  @override
  String get orderingOnThisDevice => 'Kuri iki gikoresho';

  @override
  String get orderingFoundByNameSearch => 'Byabonetse hashakishijwe izina';

  @override
  String get orderingUnnamedBranch => 'Ishami ritagira izina';

  @override
  String get orderingAddNewSupplier => 'Ongeraho umucuruzi mushya';

  @override
  String get orderingThisBranch => 'Iri shami';

  @override
  String get orderingNewPurchaseOrder => 'Komande nshya yo kurangura';

  @override
  String get orderingShortcutSearch => 'shakisha';

  @override
  String get orderingShortcutAddTopMatch => 'ongeraho igihuye neza';

  @override
  String get orderingChangeSupplier => 'Hindura umucuruzi';

  @override
  String get orderingChoosePaymentBeforeSending =>
      'Hitamo uko uri bwishyure mbere yo kohereza komande.';

  @override
  String get orderingTheSupplier => 'umucuruzi';

  @override
  String get orderingSearchSuppliersEllipsis => 'Shakisha abacuruzi...';

  @override
  String get orderingUnknownSupplier => 'Umucuruzi utazwi';

  @override
  String get orderingNoSuppliersFound => 'Nta bacuruzi babonetse';

  @override
  String get orderingTryDifferentSearch =>
      'Gerageza irindi jambo ryo gushakisha';

  @override
  String get orderingSelectSupplierFirst => 'Banza uhitemo umucuruzi.';

  @override
  String get orderingSupplierInvalidId =>
      'Umucuruzi wahisemo afite ID itemewe. Hitamo undi mucuruzi.';

  @override
  String get orderingCannotOrderFromYourself =>
      'Ntushobora gutumiza kuri wowe ubwawe.';

  @override
  String get orderingCartIsEmpty => 'Agaseke karimo ubusa';

  @override
  String orderingSmsNewOrder(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Komande nshya y\'ibicuruzwa $count, igiteranyo: $total',
      one: 'Komande nshya y\'igicuruzwa 1, igiteranyo: $total',
    );
    return '$_temp0';
  }

  @override
  String get orderingPlacedTitle => 'Komande yoherejwe neza';

  @override
  String get orderingPlacedDescription => 'Komande yawe yakozwe kandi yemejwe.';

  @override
  String get orderingPlacedSnack => 'Komande yoherejwe neza';

  @override
  String get orderingCartEmptyAddProduct =>
      'Agaseke karimo ubusa — ongeramo igicuruzwa mbere yo gutumiza.';

  @override
  String get createCategoryTitle => 'Shyiraho icyiciro';

  @override
  String get createCategoryEnterName => 'Andika izina ry\'icyiciro';

  @override
  String get createCategoryNameHint => 'Izina ry\'icyiciro';

  @override
  String get createLoadingEllipsis => 'Birafunguka...';

  @override
  String get createSelectCategory => 'Hitamo icyiciro';

  @override
  String get createAddVariation => 'Ongeraho ubwoko';

  @override
  String get createEnterProductName => 'Andika izina ry\'igicuruzwa';

  @override
  String get createNameRequired => 'Izina rirakenewe';

  @override
  String get createRetailPrice => 'Igiciro cyo kudandaza';

  @override
  String get createEnterRetailPrice => 'Andika igiciro cyo kudandaza';

  @override
  String get createRetailPriceRequired => 'Igiciro cyo kudandaza kirakenewe';

  @override
  String get createShouldBeNumber => 'Bigomba kuba umubare';

  @override
  String get createCostPrice => 'Igiciro cyo kurangura';

  @override
  String get createEnterCostPrice => 'Andika igiciro cyo kurangura';

  @override
  String get createCostPriceRequired => 'Igiciro cyo kurangura kirakenewe';

  @override
  String get createEnterSku => 'Andika SKU';

  @override
  String get createTaxExempted => 'Isonewe umusoro';

  @override
  String get createFillRequiredFields => 'Uzuza ibisabwa byose';

  @override
  String get photosPickColor => 'Hitamo ibara';

  @override
  String get photosSelectColorShade => 'Hitamo urugero rw\'ibara';

  @override
  String get photosSelectedColorShades => 'Ibara ryahiswemo n\'ingero zaryo';

  @override
  String get photosPickColorInstead => 'Hitamo ibara aho kuba ifoto';

  @override
  String get photosSavedLocally =>
      'Ifoto yabitswe kuri iki gikoresho. Izoherezwa interineti nibonekana.';

  @override
  String get photosAddImageOffline => 'Ongeraho ifoto (nta interineti)';

  @override
  String get photosAddImage => 'Ongeraho ifoto';

  @override
  String get photosClickToChange => 'Kanda uhindure ifoto';

  @override
  String get photosUploadImage => 'Ohereza ifoto';

  @override
  String get colorTileColors => 'Amabara';

  @override
  String get colorTileNewItem => 'Igicuruzwa gishya';

  @override
  String get colorTileChooseLabelColor => 'Hitamo ibara ry\'ikirango';

  @override
  String get colorTilePhotoLabel => 'Ikirango cy\'ifoto';

  @override
  String get colorTileTakePhoto => 'Fata ifoto';

  @override
  String get categoriesSearchHint => 'Shakisha ibyiciro...';

  @override
  String get categoriesCreateNew => 'Shyiraho icyiciro gishya';

  @override
  String get categoriesAll => 'Ibyiciro byose';

  @override
  String get categoriesNoneFound => 'Nta byiciro byabonetse';

  @override
  String get unitsUnitType => 'Ubwoko bw\'igipimo';

  @override
  String get unitsNoneAvailable => 'Nta bipimo bihari';

  @override
  String get unitsSelectUnit => 'Hitamo igipimo';

  @override
  String get receiveStockTitle => 'Akira stock';

  @override
  String get receiveStockButton => 'Akira stock';

  @override
  String get receiveStockEnterValue => 'Andika ingano ya stock';

  @override
  String get receiveStockAddStock => 'Ongeraho stock';

  @override
  String get receiveStockTrackingHint =>
      'Gukurikirana stock bizafungurwa ku bicuruzwa bifite ingano ya stock. Kugira ngo ubihagarike, jya ku rubuga rwawe rwa Flipper';

  @override
  String get purchaseStatusWaiting => 'Bitegereje';

  @override
  String get purchaseStatusDeclined => 'Byanzwe';

  @override
  String get purchaseColumnNo => 'No.';

  @override
  String get purchaseSupplyPrice => 'Igiciro cyo kurangura';

  @override
  String get purchaseAssignVariant => 'Huza n\'ubwoko';

  @override
  String get purchaseSearchVariants => 'Shakisha amoko...';

  @override
  String get cartPaymentsAtTillSendToManager =>
      'Kwishyura bikorerwa kuri kesi. Ohereza iyi komande ku muyobozi.';

  @override
  String get cartTransactionNotFound => 'Igikorwa cyo kurangiza nticyabonetse.';

  @override
  String cartSplitEnterAmountFor(String indices) {
    return 'andika amafaranga y\'ubwishyu $indices';
  }

  @override
  String cartSplitFixInvalidAmountFor(String indices) {
    return 'kosora amafaranga atemewe y\'ubwishyu $indices';
  }

  @override
  String cartSplitAmountAboveZeroFor(String indices) {
    return 'buri buryo bukeneye amafaranga arenze zeru (ubwishyu $indices)';
  }

  @override
  String cartSplitMultipleMethodsInUse(String details) {
    return 'Hakoreshejwe uburyo bwinshi bwo kwishyura: $details.';
  }

  @override
  String get cartCreditNeedsCustomer =>
      'Izina cyangwa telefoni y\'umukiriya birakenewe ku bwishyu bw\'ideni.';

  @override
  String get cartUnsavedOneItem =>
      'Igicuruzwa kimwe nticyashoboye kubikwa muri iri gurisha. Gikure mu gaseke wongere ugishyiremo.';

  @override
  String cartUnsavedNamed(String name) {
    return '$name nticyashoboye kubikwa muri iri gurisha. Gikure mu gaseke wongere ugishyiremo.';
  }

  @override
  String cartUnsavedTwo(String first, String second) {
    return '$first na $second ntibyashoboye kubikwa muri iri gurisha. Bikure mu gaseke wongere ubishyiremo.';
  }

  @override
  String cartUnsavedMany(String count, String first, String second) {
    return '$first, $second n\'ibindi $count ntibyashoboye kubikwa muri iri gurisha. Bikure mu gaseke wongere ubishyiremo.';
  }

  @override
  String get cartAddItemsBeforeReview =>
      'Ongera ibicuruzwa mu gaseke mbere yo kohereza ngo bigenzurwe.';

  @override
  String get cartPaymentParkedAsLoan =>
      'Ubwishyu bwanditswe. Igikorwa cyashyizwe ku ideni.';

  @override
  String get cartSentForReview => 'Byoherejwe kugenzurwa';

  @override
  String get cartPaymentSuccessful => 'Kwishyura byagenze neza';

  @override
  String get cartPaymentConfirmationTimeout =>
      'Igihe cyo kwemeza ubwishyu cyarangiye. Ongera ugerageze.';

  @override
  String get errorUnableToSaveData =>
      'Ntibyashobotse kubika amakuru. Ongera ufungure porogaramu wongere ugerageze.';

  @override
  String get errorDatabaseBusy =>
      'Ububiko bw\'amakuru buhuze. Tegereza akanya wongere ugerageze.';

  @override
  String get errorNoInternet =>
      'Nta interineti. Reba umuyoboro wawe wongere ugerageze.';

  @override
  String get errorSessionExpired => 'Igihe cyawe cyarangiye. Ongera winjire.';

  @override
  String get errorNoPermission =>
      'Nta burenganzira ufite bwo gukora iki gikorwa.';

  @override
  String get errorRequestTimedOut =>
      'Igihe cy\'ubusabe cyarangiye. Ongera ugerageze.';

  @override
  String get errorPermissionDenied =>
      'Uburenganzira bwanzwe. Reba uburenganzira bwa porogaramu mu igenamiterere.';

  @override
  String get errorServerUnavailable =>
      'Seriveri ntiboneka by\'agateganyo. Ongera ugerageze nyuma.';

  @override
  String get errorNotFound => 'Icyasabwe nticyabonetse.';

  @override
  String get errorCheckInput => 'Reba ibyo wanditse wongere ugerageze.';

  @override
  String get errorSyncUnavailable =>
      'Guhuza amakuru ntibiboneka by\'agateganyo. Impinduka zawe zizahuzwa interineti nigaruka.';

  @override
  String get errorGenericContactSupport =>
      'Hari ikitagenze neza. Ongera ugerageze cyangwa uhamagare ubufasha niba ikibazo gikomeje.';

  @override
  String get pickImageNoFileSelected => 'Nta dosiye yahiswemo.';

  @override
  String get pickImageReadFailed =>
      'Ntibyashobotse gusoma dosiye wahisemo. Ongera ugerageze.';

  @override
  String get pickImageNoData => 'Iyo dosiye nta makuru irimo. Hitamo indi.';

  @override
  String pickImageTooLarge(String kb) {
    return 'Hitamo ifoto iri munsi ya ${kb}KB.';
  }

  @override
  String get pickImageNotReadable =>
      'Iyo dosiye si PNG cyangwa JPEG isomeka. Hitamo indi.';

  @override
  String get posCartViewOnlyCannotAdd =>
      'Ushobora kureba gusa — ntushobora kongera ibicuruzwa mu igurisha.';

  @override
  String get posCartNoActiveCart =>
      'Nta gaseke k\'igurisha kari gukora. Ongera ugerageze.';

  @override
  String get imageSourceGallery => 'Amafoto';

  @override
  String get imageSourceCamera => 'Kamera';

  @override
  String get imageSourceBrowseFiles => 'Shakisha dosiye';

  @override
  String get stockItemUnavailable => 'Igicuruzwa ntikiboneka';

  @override
  String get stockItemsUnavailable => 'Ibicuruzwa ntibiboneka';

  @override
  String stockNotEnoughSingle(String name) {
    return 'Nta $name ihagije iri muri stock kugira ngo turangize komande yawe.';
  }

  @override
  String get stockRequestedQuantity => 'Ingano yasabwe:';

  @override
  String get stockNotEnoughMultiple =>
      'Ntidufite ibi bicuruzwa bihagije muri stock:';

  @override
  String stockRequestedValue(String qty) {
    return 'Byasabwe: $qty';
  }

  @override
  String get stockReduceOrRemoveItem =>
      'Ushobora kugabanya ingano cyangwa ugakuramo iki gicuruzwa kugira ngo ukomeze.';

  @override
  String get stockAdjustOrRemoveItems =>
      'Ushobora guhindura ingano cyangwa ugakuramo ibi bicuruzwa kugira ngo ukomeze.';

  @override
  String get stockGotIt => 'Ndabyumvise';

  @override
  String get ticketCompleteEnterCustomerName =>
      'Andika izina ry\'umukiriya mbere yo kurangiza.';

  @override
  String get ticketCompletePhoneRequiredNoTin =>
      'Nimero ya telefoni y\'umukiriya irakenewe iyo nta TIN yanditswe.';

  @override
  String get ticketCompleteDone => 'Tike yarangiye';

  @override
  String get ticketCompleteFailed => 'Kurangiza tike byanze';

  @override
  String get ticketCompleteInProgress => 'Turimo kurangiza tike…';

  @override
  String get manualPurchaseSellPrice => 'Igiciro cyo kugurisha';

  @override
  String get cashbookSelectDates => 'Hitamo amatariki';

  @override
  String get cashbookSaveCashIn => 'Bika amafaranga yinjiye';

  @override
  String get cashbookSaveCashOut => 'Bika amafaranga yasohotse';

  @override
  String get cashbookNewEntry => 'Gishya';

  @override
  String get cashbookEnterValidAmount => 'Andika amafaranga yemewe';

  @override
  String get cashbookToday => 'Uyu munsi';

  @override
  String get cashbookYesterday => 'Ejo hashize';

  @override
  String get cashbookListNoMovements =>
      'Nta mafaranga arinjira cyangwa ngo asohoke';

  @override
  String cashbookListNoFilterEntries(String filter) {
    return 'Nta byanditswe bya $filter';
  }

  @override
  String get cashbookListEmptyHint =>
      'Andika amafaranga yinjiye cyangwa yasohotse ukoresheje utubuto two hasi.';

  @override
  String cashbookListNothingMatches(String period) {
    return 'Nta kintu gihuye n\'aka kayunguruzo muri $period.';
  }

  @override
  String get cashbookViewAll => 'Reba byose';

  @override
  String get cashbookMoneyInLabel => 'Ayinjiye';

  @override
  String get cashbookMoneyOutLabel => 'Ayasohotse';

  @override
  String get manualPurchaseSellingPriceOptional =>
      'Igiciro cyo kugurisha (si ngombwa)';

  @override
  String get txDetailCategory => 'Icyiciro';

  @override
  String get txDetailNote => 'Icyitonderwa';

  @override
  String get manualPurchaseSellAtCostHelper =>
      'Bireke ubusa ugurishe ku giciro waguze';

  @override
  String get scannerAlignQrCode => 'Shyira kode ya QR mu kazu';

  @override
  String get scannerInstructionSelling =>
      'Sikana barcode y\'igicuruzwa ngo ucyongere mu gitebo';

  @override
  String get scannerInstructionAttendance =>
      'Sikana kode ya QR y\'ubwitabire ngo wiyandikishe';

  @override
  String get scannerInstructionLogin =>
      'Sikana kode ya QR ngo winjire muri konti yawe';

  @override
  String get scannerScanning => 'Birimo gusikana...';

  @override
  String get scannerStatusProcessing => 'Birimo gukorwa';

  @override
  String get scannerSendingLoginToDesktop =>
      'Kohereza kwinjira kuri mudasobwa...';

  @override
  String get scannerWaitingForDesktop => 'Dutegereje mudasobwa';

  @override
  String get scannerLoginSentCompleting =>
      'Kwinjira kwoherejwe — birarangirira kuri mudasobwa yawe...';

  @override
  String get scannerScanSuccessful => 'Gusikana byagenze neza';

  @override
  String get scannerQrProcessedSuccessfully => 'Kode ya QR yakozwe neza';

  @override
  String get scannerLoginSuccessful => 'Kwinjira byagenze neza';

  @override
  String get scannerDesktopAuthenticated => 'Mudasobwa yemejwe';

  @override
  String get scannerLoginFailed => 'Kwinjira byanze';

  @override
  String get scannerCouldNotAuthenticateDesktop =>
      'Ntibyashobotse kwemeza mudasobwa';

  @override
  String get scannerQrCodeDetected => 'Kode ya QR yabonetse';

  @override
  String get scannerProcessingRequest => 'Turimo gukora ku busabe bwawe...';

  @override
  String get scannerHelpTitle => 'Ubufasha bwo gusikana';

  @override
  String get scannerHelpPositionCode => 'Shyira kode mu kazu';

  @override
  String get scannerHelpWellLit => 'Reba ko hari urumuri kandi bigaragara neza';

  @override
  String get scannerHelpUseFlash => 'Koresha itara mu mwijima';

  @override
  String get scannerHelpToggleFlash => 'Kanda ikimenyetso cy\'itara hasi';

  @override
  String get scannerHelpCleanLens => 'Sukura ijisho rya kamera yawe';

  @override
  String get scannerHelpBetterResults => 'Kugira ngo usikane neza kurushaho';

  @override
  String get scannerTitleProduct => 'Gusikana ibicuruzwa';

  @override
  String get scannerTitleAttendance => 'Gusikana ubwitabire';

  @override
  String get scannerTitleLogin => 'Gusikana ngo winjire';

  @override
  String get scannerTitleQr => 'Gusikana QR';

  @override
  String get scannerGalleryComingSoon => 'Guhitamo mu mafoto biraza vuba';

  @override
  String get scannerInvalidQrFormat => 'Imiterere ya kode ya QR ntiyemewe';

  @override
  String scannerLoginError(String error) {
    return 'Ikosa ryo kwinjira: $error';
  }

  @override
  String get scannerDesktopNoResponse =>
      'Mudasobwa ntiyasubije — reba ko iri ku rupapuro rwo kwinjira na QR';

  @override
  String get scannerDesktopSelectBusiness =>
      'Mudasobwa yinjiye — hitamo ubucuruzi bwawe kuri yo';

  @override
  String get scannerDesktopLoginSuccessful =>
      'Kwinjira kuri mudasobwa byagenze neza';

  @override
  String get scannerDesktopLoginFailed => 'Kwinjira kuri mudasobwa byanze';

  @override
  String get dialogGotIt => 'Ndabyumvise';

  @override
  String get socialsRequestEarlyAccess => 'Saba kugerwaho mbere';

  @override
  String get socialsEarlyAccessHint =>
      'Andika imeyili yawe, nimero ya telefoni n\'ubutumwa busobanura impamvu ushaka kwinjira!';

  @override
  String get socialsPleaseEnterMessage => 'Andika ubutumwa';

  @override
  String get socialsThanksForInterest => 'Murakoze ku bwo kubyitaho';

  @override
  String get socialsThanksWeWillGetBack =>
      'Murakoze ku bwo kubyitaho, tuzabagarukaho vuba';

  @override
  String get socialsExpressInterest => 'Garagaza ubushake';

  @override
  String get appInitStepFirebase => 'Guhuza serivisi';

  @override
  String get appInitStepLocator => 'Gutegura porogaramu';

  @override
  String get appInitStepPlatform => 'Gutunganya igikoresho';

  @override
  String get appInitStepDiagnostics => 'Gutunganya isuzuma';

  @override
  String get appInitStepDatabase =>
      'Gufungura ububiko bw\'amakuru bwo muri telefoni';

  @override
  String get appInitStepServices => 'Gutangiza serivisi';

  @override
  String get appInitStepAnalytics => 'Gutangiza isesengura';

  @override
  String get appInitStepCloudStorage => 'Guhuza ububiko bwo kuri murandasi';

  @override
  String get appInitStepSync => 'Gutegura guhuza amakuru';

  @override
  String get appInitStepFinishing => 'Birarangira';

  @override
  String get appInitStepStartup => 'Gutangira';

  @override
  String get appInitFailedTitle => 'Gutangira byanze';

  @override
  String appInitFailedMessage(String step) {
    return 'Porogaramu ntiyashoboye kurangiza gutangira ku ntambwe \"$step\". Kanda Ongera ugerageze — izakomereza kuri iyo ntambwe.';
  }

  @override
  String get appInitTryAgain => 'Ongera ugerageze';

  @override
  String get appInitCopyErrorDetails => 'Koporora ibisobanuro by\'ikosa';

  @override
  String get appInitTechnicalDetails => 'Ibisobanuro bya tekiniki';

  @override
  String get paywallRailMobileMoney => 'Mobile Money';

  @override
  String get paywallRailCard => 'Ikarita';

  @override
  String get paywallRailMomoDescription =>
      'Emeza kuri telefoni yawe ukoresheje MTN MoMo';

  @override
  String get paywallRailCardDescription =>
      'Ishyura ukoresheje Visa cyangwa Mastercard';

  @override
  String get paywallCadenceDaily => 'Buri munsi';

  @override
  String get paywallCadenceMonthly => 'Buri kwezi';

  @override
  String get paywallCadenceYearly => 'Buri mwaka';

  @override
  String get paywallPeriodDay => '/ku munsi';

  @override
  String get paywallPeriodMonth => '/ku kwezi';

  @override
  String get paywallPeriodYear => '/ku mwaka';

  @override
  String paywallPaidInFull(String amount) {
    return 'Kwishyura byose icyarimwe — inshuro imwe ya RWF $amount.';
  }

  @override
  String paywallInstallmentsEach(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kwishyura inshuro $count za RWF $amount buri imwe.',
      one: 'Kwishyura inshuro 1 ya RWF $amount.',
    );
    return '$_temp0';
  }

  @override
  String paywallPricePerMonthBilledYearly(String amount) {
    return '$amount RWF/ukwezi · yishyurwa buri mwaka';
  }

  @override
  String paywallPricePerDay(String amount) {
    return '$amount RWF/ku munsi';
  }

  @override
  String paywallPricePerMonth(String amount) {
    return '$amount RWF/ku kwezi';
  }

  @override
  String get paywallCardPayment => 'Kwishyura n\'ikarita';

  @override
  String get paywallTestMode => 'IGERAGEZA';

  @override
  String get paywallCardRedirectInfo =>
      'Uzajyanwa ku rupapuro rwizewe rwo kwishyuriraho kugira ngo wandike amakuru ya Visa cyangwa Mastercard yawe. Garuka hano numara — ifatabuguzi rizikora ubwaryo.';

  @override
  String get paywallReceiptEmail => 'Imeyili yo kwakiriraho inyemezabwishyu';

  @override
  String get paywallReceiptEmailHint =>
      'Inyemezabuguzi n\'inyemezabwishyu by\'ikarita byoherezwa hano.';

  @override
  String get paywallCardDiscountApplies =>
      'Igabanyirizwa ryawe rikora no ku kwishyura n\'ikarita: ikarita yishyuzwa igiciro cyagabanyijwe ubu no kuri buri kuvugurura.';

  @override
  String paywallCardDiscountAppliesAmount(String amount) {
    return 'Igabanyirizwa ryawe rirakora: ikarita yishyuzwa $amount ubu no kuri buri kuvugurura.';
  }

  @override
  String get paywallDiscountMomoOnly =>
      'Kode z\'igabanyirizwa zikora gusa ku kwishyura na Mobile Money. Kwishyura n\'ikarita bisaba igiciro cyuzuye.';

  @override
  String get paywallPendingCheckout =>
      'Hari urupapuro rwo kwishyuriraho rusanzwe rutegereje iri fatabuguzi. Rufungure urangize — urundi rushya ntirwarusimbura.';

  @override
  String get paywallOpenPaymentPage => 'Fungura urupapuro rwo kwishyura';

  @override
  String get paywallDiscountHint => 'Andika kode uko iri neza neza.';

  @override
  String get paywallNeedHelp => 'Ukeneye ubufasha?';

  @override
  String get paywallChatWithSupport => 'Vugana n\'abafasha kuri iri yishyurwa';

  @override
  String get paywallMomoPayment => 'Kwishyura na Mobile Money';

  @override
  String paywallProcessedUsing(String provider) {
    return 'Kwishyura bizakorwa hakoreshejwe $provider.';
  }

  @override
  String get paywallUseDifferentNumber => 'Koresha indi nimero ya telefoni';

  @override
  String get paywallTryAnotherNumber =>
      'Gerageza indi nimero ya MTN niba iyi yanze';

  @override
  String get paywallMomoNumberRule =>
      'Igomba gutangirwa na 250 78 cyangwa 250 79.';

  @override
  String get paywallProcessing => 'Birimo gukorwa…';

  @override
  String paywallSecurePaymentVia(String provider) {
    return 'Kwishyura kwizewe binyuze kuri $provider';
  }

  @override
  String get paywallHowToPay => 'Urashaka kwishyura ute?';

  @override
  String get paywallLoading => 'Birimo gufunguka…';

  @override
  String paywallPercentOff(String percent) {
    return '(-$percent%)';
  }

  @override
  String get paywallSplitIntoPayments => 'Gabanya mu byiciro';

  @override
  String get paywallPaymentSummary => 'Incamake y\'ubwishyu';

  @override
  String get paywallTotal => 'Igiteranyo';

  @override
  String get paywallSubscriptionEnded =>
      'Iri fatabuguzi ryarangiye. Hitamo ifatabuguzi kugira ngo wongere utangire.';

  @override
  String get paywallPaymentPageNotReady =>
      'Urupapuro rwo kwishyura ntiruraboneka. Ongera ugerageze mu kanya.';

  @override
  String get paywallCouldNotOpenPageCopyLink =>
      'Ntibyashobotse gufungura urupapuro rwo kwishyura kuri iki gikoresho. Koporora umurongo, cyangwa wishyure na Mobile Money.';

  @override
  String get paywallCouldNotOpenPage =>
      'Ntibyashobotse gufungura urupapuro rwo kwishyura kuri iki gikoresho.';

  @override
  String get paywallServiceNoResponse =>
      'Serivisi yo kwishyura ntiyasubije. Reba murandasi yawe wongere ugerageze.';

  @override
  String get paywallServiceUnreachable =>
      'Ntibyashobotse kugera kuri serivisi yo kwishyura. Reba murandasi yawe wongere ugerageze.';

  @override
  String get paywallBusinessRequiredForCard =>
      'Ubucuruzi burakenewe kugira ngo utangire ifatabuguzi ry\'ikarita.';

  @override
  String get paywallCardStartedNoReference =>
      'Ifatabuguzi ry\'ikarita ryatangiye ariko nta nomero y\'icyitegererezo yaje. Reba ku rupapuro rw\'inyishyu mbere yo kongera kugerageza.';

  @override
  String get paywallNoCardUpdateLink =>
      'Nta murongo wo kuvugurura ikarita waje.';

  @override
  String get paywallNoPortalLink => 'Nta murongo w\'urubuga rw\'inyishyu waje.';

  @override
  String get paywallCardNotAuthorised =>
      'Kwishyura n\'ikarita ntibyemewe kuri iyi serivisi.';

  @override
  String get paywallCardUnavailable =>
      'Kwishyura n\'ikarita ntibiboneka ubu. Koresha Mobile Money, cyangwa wongere ugerageze nyuma.';

  @override
  String paywallCouldNotAction(String action, String status) {
    return 'Ntibyashobotse $action (HTTP $status).';
  }

  @override
  String paywallUnreadableReply(String status) {
    return 'Serivisi y\'inyishyu yohereje igisubizo kidasomeka (HTTP $status).';
  }

  @override
  String get paywallActionStartCardSubscription =>
      'gutangiza ifatabuguzi ry\'ikarita';

  @override
  String get paywallActionReadCardSubscription =>
      'gusoma ifatabuguzi ry\'ikarita';

  @override
  String get paywallActionRefreshCardSubscription =>
      'kuvugurura ifatabuguzi ry\'ikarita';

  @override
  String get paywallActionGetCardLink => 'kubona umurongo mushya w\'ikarita';

  @override
  String get paywallActionOpenBillingPortal => 'gufungura urubuga rw\'inyishyu';

  @override
  String get paywallActionCancelCardSubscription =>
      'guhagarika ifatabuguzi ry\'ikarita';

  @override
  String get paywallActionStartCustomPayment => 'gutangiza ubwishyu bwihariye';

  @override
  String get paywallActionReadCustomPayment => 'gusoma ubwishyu bwihariye';

  @override
  String get paywallActionListCustomPayments => 'kwerekana ubwishyu bwihariye';

  @override
  String get paywallEnterAmountAboveZero => 'Andika amafaranga aruta zeru.';

  @override
  String get paywallEnterValidMomoNumber =>
      'Andika nimero ya Mobile Money yemewe, urugero 0788123456.';

  @override
  String paywallPaymentNotStarted(String status) {
    return 'Kwishyura ntibyashoboye gutangira (HTTP $status).';
  }

  @override
  String paywallGatewayUnreadable(String status) {
    return 'Serivisi yo kwishyura yohereje igisubizo kidasomeka (HTTP $status).';
  }

  @override
  String get paywallStartedNoReference =>
      'Kwishyura byatangiye ariko nta nomero y\'icyitegererezo yaje — reba amateka ya MoMo mbere yo kongera kugerageza.';

  @override
  String paywallPreApprovalFailed(String status) {
    return 'Kwemeza mbere byanze (HTTP $status).';
  }

  @override
  String get paywallRequestRejected => 'Ubusabe bwo kwishyura bwanzwe.';

  @override
  String get paywallDeviceNotAuthorised =>
      'Iki gikoresho ntikemerewe kwakira ubwishyu.';

  @override
  String get paywallServiceNotFound => 'Serivisi yo kwishyura ntiyabonetse.';

  @override
  String get paywallAlreadySubmitted => 'Ubwo bwishyu bwamaze koherezwa.';

  @override
  String get paywallMomoUnavailableNow =>
      'Mobile Money ntiboneka ubu. Ongera ugerageze mu kanya.';

  @override
  String get paywallMomoNotSetUp =>
      'Mobile Money ntiratunganywa kuri iki gikoresho.';

  @override
  String get paywallNotCompletedOnPhone =>
      'Kwishyura ntibyarangiriye kuri telefoni y\'uwishyura.';

  @override
  String get paywallNoConfirmationYet =>
      'Nta cyemezo kiraza. Kwishyura bishobora kugenda neza — reba amateka ya MoMo mbere yo kongera kwishyuza.';

  @override
  String get paywallConsentDeclined =>
      'Uruhushya rwa Mobile Money rwanzwe, nta mafaranga yakuweho. Emeza ubusabe kuri telefoni yawe wongere ugerageze.';

  @override
  String get paywallChooseBusinessFirst => 'Banza uhitemo ubucuruzi.';

  @override
  String get paywallAmountAboveZero => 'Amafaranga agomba kuruta zeru.';

  @override
  String get paywallCustomerMomoRequired =>
      'Nimero ya Mobile Money y\'umukiriya irakenewe.';

  @override
  String get paywallStaffNotAuthorised =>
      'Iyi konti ntiyemerewe ubwishyu bw\'abakozi.';

  @override
  String get paywallAlreadyCollecting =>
      'Hari ubwishyu busanzwe burimo kwakirwa kuri ubu bucuruzi.';

  @override
  String get paywallStaffNotConfigured =>
      'Ubwishyu bw\'abakozi ntibwatunganyijwe kuri iyi serivisi.';

  @override
  String accountingShiftUser(String id) {
    return 'Ukoresha: $id';
  }

  @override
  String get accountingShiftHistory => 'Amateka y\'amasaha y\'akazi';

  @override
  String get accountingLoadingShiftHistory =>
      'Gufungura amateka y\'amasaha y\'akazi...';

  @override
  String get accountingNoMatchingShifts =>
      'Nta masaha y\'akazi ahuye n\'ibyo washatse';

  @override
  String get accountingNoShiftsFound => 'Nta masaha y\'akazi yabonetse';

  @override
  String get accountingAdjustFiltersHint =>
      'Gerageza guhindura uburyo bwo gushungura cyangwa ibyo washatse.';

  @override
  String get accountingNoShiftsHint =>
      'Amasaha y\'akazi azagaragara hano umaze\ngutangira kuyacunga.';

  @override
  String get accountingClearFilters => 'Kuraho uburyo bwo gushungura';

  @override
  String accountingCashSalesRange(String currency) {
    return 'IGIPIMO CY\'IBYAGURISHIJWE MU MAFARANGA ($currency)';
  }

  @override
  String get accountingFilterShifts => 'Shungura amasaha y\'akazi';

  @override
  String get accountingDateRange => 'IGIHE';

  @override
  String get accountingFrom => 'Kuva';

  @override
  String get accountingTo => 'Kugeza';

  @override
  String get accountingStatusLabel => 'IMIMERERE';

  @override
  String get accountingAllShifts => 'Amasaha yose';

  @override
  String get accountingShiftOpen => 'Afunguye';

  @override
  String get accountingShiftClosed => 'Afunze';

  @override
  String get accountingMinimum => 'Ntoya';

  @override
  String get accountingMaximum => 'Nini';

  @override
  String get accountingNoLimit => 'Nta mbibi';

  @override
  String get accountingSortBy => 'TONDEKA HAKURIKIJWE';

  @override
  String get accountingNewestFirst => 'Ibya vuba mbere';

  @override
  String get accountingOldestFirst => 'Ibya kera mbere';

  @override
  String get accountingCashSalesHighToLow =>
      'Ibyagurishijwe mu mafaranga — kuva ku byinshi';

  @override
  String get accountingCashSalesLowToHigh =>
      'Ibyagurishijwe mu mafaranga — kuva ku bike';

  @override
  String get accountingClearAll => 'Siba byose';

  @override
  String get accountingApplyFilters => 'Shyira mu bikorwa';

  @override
  String get accountingDatePlaceholder => 'uk/um/umwaka';

  @override
  String get accountingTotalShifts => 'AMASAHA YOSE';

  @override
  String get accountingTotalCashSales => 'IBYAGURISHIJWE MU MAFARANGA BYOSE';

  @override
  String get accountingOpenClosed => 'AFUNGUYE / AFUNZE';

  @override
  String get accountingSearchShiftsHint =>
      'Shakisha ukoresheje ID y\'ukoresha cyangwa itariki...';

  @override
  String accountingShowingShifts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Herekanywe amasaha $count y\'akazi',
      one: 'Herekanywe isaha 1 y\'akazi',
    );
    return '$_temp0';
  }

  @override
  String accountingStartedAt(String time) {
    return 'Yatangiye $time';
  }

  @override
  String accountingCashDifference(String amount) {
    return 'Ikinyuranyo cy\'amafaranga: $amount';
  }

  @override
  String get accountingTimePeriod => 'IGIHE';

  @override
  String get accountingStartTime => 'Igihe cyo gutangira';

  @override
  String get accountingEndTime => 'Igihe cyo gusoza';

  @override
  String accountingDuration(String duration) {
    return 'Igihe byamaze: $duration';
  }

  @override
  String get accountingInProgress => 'Birakomeje';

  @override
  String get accountingFinancialSummary => 'INCAMAKE Y\'IMARI';

  @override
  String get accountingOpeningBalance => 'Amafaranga yo gutangira';

  @override
  String get accountingCashSales => 'Ibyagurishijwe mu mafaranga';

  @override
  String get accountingExpectedCash => 'Amafaranga ategerejwe';

  @override
  String get accountingClosingBalance => 'Amafaranga yo gusoza';

  @override
  String get uiAdminPinMismatch => 'PIN ntizihuye. Ongera ugerageze.';

  @override
  String uiAdminPinIncorrect(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'PIN si yo. Hasigaye amagerageza $count.',
      one: 'PIN si yo. Hasigaye igerageza 1.',
    );
    return '$_temp0';
  }

  @override
  String get uiAdminPinSaveFailed =>
      'Ntibyashobotse kubika PIN. Ongera ugerageze.';

  @override
  String get uiAdminPinSaved => 'PIN yabitswe';

  @override
  String get uiAdminPinEnter => 'Andika PIN y\'umuyobozi';

  @override
  String get uiAdminPinConfirm => 'Emeza PIN yawe';

  @override
  String get uiAdminPinSetUp => 'Shyiraho PIN y\'umuyobozi';

  @override
  String get uiAdminPinSavedSubtitle =>
      'Ibikorwa byihariye ubu bisaba iyi PIN.';

  @override
  String get uiAdminPinVerifySubtitle =>
      'Iki gikorwa kirinzwe. Andika PIN y\'umuyobozi y\'imibare 4.';

  @override
  String get uiAdminPinConfirmSubtitle =>
      'Ongera wandike iyo mibare 4 kugira ngo wemeze.';

  @override
  String get uiAdminPinSetSubtitle =>
      'Hitamo PIN y\'imibare 4 yo kurinda guhindura, gusiba n\'igenamiterere.';

  @override
  String uiAdminPinDigitsSemantic(String entered, String total) {
    return 'PIN, imibare $entered kuri $total yanditswe';
  }

  @override
  String uiAdminPinLockout(String seconds) {
    return 'Wagerageje inshuro nyinshi. Ongera ugerageze nyuma y\'amasegonda $seconds.';
  }

  @override
  String get uiAdminPinStartOver => 'Ongera utangire';

  @override
  String get uiMonthShortJan => 'Mut';

  @override
  String get uiMonthShortFeb => 'Gas';

  @override
  String get uiMonthShortMar => 'Wer';

  @override
  String get uiMonthShortApr => 'Mat';

  @override
  String get uiMonthShortMay => 'Gic';

  @override
  String get uiMonthShortJun => 'Kam';

  @override
  String get uiMonthShortJul => 'Nya';

  @override
  String get uiMonthShortAug => 'Kan';

  @override
  String get uiMonthShortSep => 'Nze';

  @override
  String get uiMonthShortOct => 'Ukw';

  @override
  String get uiMonthShortNov => 'Ugu';

  @override
  String get uiMonthShortDec => 'Uku';

  @override
  String get uiTicketResumeOrder => 'Komeza itumiza';

  @override
  String get uiTicketResuming => 'Birakomeza…';

  @override
  String get uiTicketCustomerSection => 'UMUKIRIYA';

  @override
  String uiTicketItemsSection(String count) {
    return 'IBICURUZWA · $count';
  }

  @override
  String uiTicketCouldNotLoadItems(String error) {
    return 'Ntibyashobotse gufungura ibicuruzwa: $error';
  }

  @override
  String get uiTicketStatusSection => 'IMIMERERE';

  @override
  String get uiTicketResumeTicket => 'Komeza tike';

  @override
  String get uiTicketWalkIn => 'Umukiriya w\'impfabusa';

  @override
  String get uiTicketLoan => 'Ideni';

  @override
  String get uiTicketNoItems => 'Nta bicuruzwa biri kuri iyi tike.';

  @override
  String uiTicketPaymentsSection(String count) {
    return 'UBWISHYU · $count';
  }

  @override
  String get uiTicketTotalPaidSoFar => 'Ayishyuwe kugeza ubu';

  @override
  String get uiTicketStillDue => 'Asigaye kwishyurwa';

  @override
  String get uiTicketUnknown => 'Ntibizwi';

  @override
  String uiTicketPaymentLine(String index, String method) {
    return 'Ubwishyu $index · $method';
  }

  @override
  String uiTicketPaidBy(String name) {
    return 'Byishyuwe na $name';
  }

  @override
  String get uiTicketStatusWaiting => 'Birategereje';

  @override
  String get uiTicketStatusInProgress => 'Birakomeje';

  @override
  String get uiTicketStatusCompleted => 'Byarangiye';

  @override
  String get uiTicketBadgeInProgress => 'BIRAKOMEJE';

  @override
  String get uiTicketBadgeCompleted => 'BYARANGIYE';

  @override
  String get uiTicketBadgeParked => 'BYAHAGARITSWE';

  @override
  String get uiTicketDateNotRecorded => 'Itariki ntiyanditswe';

  @override
  String uiTicketTodayAt(String time) {
    return 'Uyu munsi · $time';
  }

  @override
  String uiTicketYesterdayAt(String time) {
    return 'Ejo hashize · $time';
  }

  @override
  String get uiTicketParkTransaction => 'Hagarika igurisha';

  @override
  String get uiTicketParking => 'Birahagarikwa…';

  @override
  String uiTicketParkFailed(String error) {
    return 'Guhagarika igurisha byanze: $error';
  }

  @override
  String get uiTicketAttachCustomer => 'Ongeraho umukiriya';

  @override
  String get uiTicketSearchCustomers => 'Shakisha abakiriya…';

  @override
  String get uiTicketNoCustomer => 'Nta mukiriya';

  @override
  String get uiTicketName => 'Izina rya tike';

  @override
  String get uiTicketEnterName => 'Andika izina rya tike';

  @override
  String get uiTicketNotes => 'Ibisobanuro';

  @override
  String get uiTicketOptional => 'Si ngombwa';

  @override
  String get uiTicketAddNotes => 'Ongeraho ibisobanuro';

  @override
  String get uiTicketPaymentDue => 'Igihe cyo kwishyura';

  @override
  String get uiTicketSendToKitchen => 'Ohereza mu gikoni';

  @override
  String get uiTicketShowOnKds => 'Erekana iyi tike kuri ecran y\'igikoni';

  @override
  String get uiTicketSelectCustomer => 'Hitamo umukiriya';

  @override
  String get uiTicketMarkAsLoan => 'Bishyire nk\'ideni';

  @override
  String get uiTicketTrackPaymentLater => 'Kurikirana ubwishyu buzakirwa nyuma';

  @override
  String get uiTicketOneWeek => 'Icyumweru 1';

  @override
  String get uiTicketTwoWeeks => 'Ibyumweru 2';

  @override
  String get uiTicketOneMonth => 'Ukwezi 1';

  @override
  String get uiTicketSelectDate => 'Hitamo itariki';

  @override
  String get uiTicketDueDate => 'Itariki ntarengwa';

  @override
  String get uiTicketHoldSale => 'Bika iri gurisha uzarirangize nyuma';

  @override
  String get uiWorkOrderUnknownProduct => 'Igicuruzwa kitazwi';

  @override
  String uiWorkOrderId(String id) {
    return 'ID: $id';
  }

  @override
  String get uiWorkOrderStart => 'Tangira';

  @override
  String get uiWorkOrderRecordOutput => 'Andika umusaruro';

  @override
  String get uiWorkOrderCompleted => 'Byarangiye';

  @override
  String get uiWorkOrderInProgress => 'Birakomeje';

  @override
  String get uiWorkOrderPlanned => 'Byateganyijwe';

  @override
  String get uiWorkOrderActual => 'Ibyakozwe';

  @override
  String get uiWorkOrderVariance => 'Ikinyuranyo';

  @override
  String get uiWorkOrderEfficiency => 'Umusaruro ugereranyije';

  @override
  String get uiWorkOrderTargetDate => 'Itariki iteganyijwe';

  @override
  String get uiWorkOrderShift => 'Isaha y\'akazi';

  @override
  String get uiWorkOrderNotApplicable => 'Ntabwo';

  @override
  String get uiWorkOrderNotes => 'Ibisobanuro';

  @override
  String get uiWorkOrderTimeline => 'Uko byagenze';

  @override
  String get uiWorkOrderCreated => 'Byakozwe';

  @override
  String get uiWorkOrderStarted => 'Byatangiye';

  @override
  String get uiProduceItems => 'Ibicuruzwa';

  @override
  String get uiProduceSelectItem => 'Hitamo igicuruzwa cyo gukora';

  @override
  String get uiProduceDescription =>
      'Hitamo igicuruzwa ku rutonde ruri hasi kugira ngo utangire gukora.';

  @override
  String uiProduceItemsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hasigaye ibicuruzwa $count',
      one: 'Hasigaye igicuruzwa 1',
    );
    return '$_temp0';
  }

  @override
  String uiProduceAssignedCount(String count) {
    return '$count byahawe';
  }

  @override
  String uiProduceQty(String qty) {
    return 'Ingano: $qty';
  }

  @override
  String get uiProduceAssigned => 'Byahawe';

  @override
  String get uiProduceInProgress => 'Birakomeje';

  @override
  String get uiProduceBackToList => 'Subira ku rutonde';

  @override
  String get uiProduceDetails => 'Ibisobanuro by\'umusaruro';

  @override
  String get uiPaymentModeSelect => 'Hitamo uburyo bwo kwishyura';

  @override
  String get uiPaymentModeFailed => 'Kwishyura byanze';

  @override
  String get uiPaymentModePleaseSelect => 'Hitamo uburyo bwo kwishyura';

  @override
  String get uiPaymentModeSelectFinancing => 'Hitamo uburyo bw\'inguzanyo';

  @override
  String uiPaymentModeInterest(String rate) {
    return 'Inyungu: $rate%';
  }

  @override
  String get uiBackupDescription =>
      'Gufungura kubika kopi bizajya bibika amakuru yawe buri munsi, ntuzongere guhangayikishwa no kuyatakaza.';

  @override
  String get uiTicketNoName => 'Nta zina';

  @override
  String get uiTicketResume => 'Komeza';

  @override
  String get uiNoteRequired => 'Ibisobanuro birakenewe';

  @override
  String uiNotificationSemantic(String message) {
    return 'Ubutumwa: $message';
  }

  @override
  String uiDeleteConfirmSemantic(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kwemeza gusiba ibintu $count',
      one: 'Kwemeza gusiba ikintu 1',
    );
    return '$_temp0';
  }

  @override
  String uiDeleteItemsQuestion(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gusiba ibintu $count?',
      one: 'Gusiba ikintu 1?',
    );
    return '$_temp0';
  }

  @override
  String uiMoreItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+ ibindi bintu $count',
      one: '+ ikindi kintu 1',
    );
    return '$_temp0';
  }

  @override
  String get uiRefreshStatusAfterPayment =>
      'Vugurura imimerere nyuma yo kwishyura';

  @override
  String get uiSubscriptionActive => 'Ifatabuguzi rirakora.';

  @override
  String get uiNoPlanOpeningSetup =>
      'Nta fatabuguzi ryabonetse — gufungura gutunganya ubwishyu.';

  @override
  String get uiPlanInactiveOpeningPayment =>
      'Ifatabuguzi ryabonetse ariko ntirikora — gufungura urupapuro rwo kwishyura.';

  @override
  String get uiCouldNotVerifyPayment =>
      'Ntibyashobotse kugenzura imimerere y\'ubwishyu.';

  @override
  String get uiTimerDone => 'Byarangiye!';

  @override
  String get uiTimerDelivered => 'Byagejejwe!';

  @override
  String get uiTimerUntilDelivered => 'Mbere yo kugezwa';

  @override
  String uiTimerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Iminsi $count',
      one: 'Umunsi 1',
    );
    return '$_temp0';
  }

  @override
  String uiTimerHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Amasaha $count',
      one: 'Isaha 1',
    );
    return '$_temp0';
  }

  @override
  String uiTimerMinutes(String count) {
    return '$count MIN';
  }

  @override
  String uiTimerSeconds(String count) {
    return '$count SEG';
  }

  @override
  String get uiEnterCouponCode => 'Andika kode y\'igabanyirizwa';

  @override
  String get uiShop => 'Iduka';

  @override
  String uiShopActiveSemantic(String name) {
    return '$name irakora';
  }

  @override
  String uiShopInactiveSemantic(String name) {
    return '$name ntikora';
  }

  @override
  String get uiSaveTicket => 'Bika tike';

  @override
  String get floSuggestTodayTitle => 'Incamake y\'uko uyu munsi wagenze';

  @override
  String get floSuggestTodayDesc =>
      'Amafaranga yinjiye, inyungu n\'ibicuruzwa mu ncamake';

  @override
  String get floSuggestTodayQuestion =>
      'Mpa incamake y\'uko ubucuruzi bwanjye bwagenze uyu munsi';

  @override
  String get floSuggestProfitTitle => 'Ibicuruzwa byunguka cyane';

  @override
  String get floSuggestProfitDesc =>
      'Bitondetse hakurikijwe inyungu muri iki cyumweru';

  @override
  String get floSuggestProfitQuestion =>
      'Ni ibihe bicuruzwa byunguka cyane muri iki cyumweru?';

  @override
  String get floSuggestUsersTitle => 'Abakoresha bangahe bari muri MiniData?';

  @override
  String get floSuggestUsersDesc => 'Imibare n\'ibikorwa bya vuba';

  @override
  String get floSuggestUsersQuestion =>
      'Dufite abakoresha bangahe muri MiniData?';

  @override
  String get floSuggestTrendTitle =>
      'Uko ibicuruzwa byagurishijwe muri iki cyumweru';

  @override
  String get floSuggestTrendDesc => 'Uko amafaranga yinjiye mu minsi 7';

  @override
  String get floSuggestTrendQuestion =>
      'Nyereka uko ibicuruzwa byagurishijwe muri iki cyumweru';

  @override
  String get floGoodMorning => 'Mwaramutse';

  @override
  String get floGoodAfternoon => 'Mwiriwe';

  @override
  String get floGoodEvening => 'Mwiriwe';

  @override
  String floGreetingShop(String greeting, String shop) {
    return '$greeting, $shop.';
  }

  @override
  String floAskMeAnything(String anything) {
    return 'Mbaza $anything ku bucuruzi bwawe.';
  }

  @override
  String get floAnything => 'icyo ari cyo cyose';

  @override
  String get floHomeIntro =>
      'Nsoma amakuru yawe ahujwe ako kanya, nkagusubiza n\'imibare, ibishushanyo n\'intambwe zikurikira — mu rurimi rworoshye.';

  @override
  String get floTryAsking => 'Gerageza kubaza';

  @override
  String get floChannels => 'Inzira';

  @override
  String get floMiniDataDesc =>
      'Amakuru ya Supabase ako kanya — ibyagurishijwe, abakoresha, ibicuruzwa.';

  @override
  String get floManage => 'Cunga';

  @override
  String get floConnect => 'Huza';

  @override
  String get floWhatsAppConnectedDesc =>
      'Ushobora kuganira na Flo kuri WhatsApp.';

  @override
  String get floWhatsAppSetupDesc =>
      'Vugana na Flo uri kuri telefoni yawe — bitunganywa mu munota umwe.';

  @override
  String get floLoadingBriefing => 'Gufungura incamake y\'uyu munsi…';

  @override
  String get floBriefingUnavailable => 'Incamake y\'umunsi ntiboneka';

  @override
  String get floReadingLiveSales =>
      'Gusoma ibyagurishijwe ako kanya muri MiniData.';

  @override
  String get floCheckDataConnection =>
      'Reba ihuzwa ry\'amakuru yawe wongere ugerageze.';

  @override
  String get floDailyBriefing => 'INCAMAKE Y\'UMUNSI';

  @override
  String floDateAuto(String date) {
    return '$date · byikora';
  }

  @override
  String get floConnected => 'BYAHUJWE';

  @override
  String get floNotSetUp => 'NTIBIRATUNGANYWA';

  @override
  String aiWhatsappReadInboxFailed(String error) {
    return 'Ntibyashobotse gusoma ubutumwa bwa WhatsApp\n$error';
  }

  @override
  String aiWhatsappSendFailed(String error) {
    return 'Kohereza byanze: $error';
  }

  @override
  String get aiWhatsappAnswerCustomers => 'Subiza abakiriya kuri WhatsApp';

  @override
  String get aiWhatsappConnectPitch =>
      'Huza konti yawe ya Meta WhatsApp Business kugira ngo ubone ubutumwa bw\'abakiriya hano kandi wandike ibisubizo ufashijwe na Flo.';

  @override
  String get aiWhatsappConnect => 'Huza WhatsApp';

  @override
  String get aiWhatsappSelectCustomer => 'Hitamo umukiriya';

  @override
  String get aiWhatsappInboxSource =>
      'Ubutumwa bwa WhatsApp · data-connector + Ditto';

  @override
  String get aiWhatsappCustomers => 'Abakiriya · WhatsApp';

  @override
  String get floTimeNow => 'ubu';

  @override
  String floTimeMinutesShort(String count) {
    return 'imin $count';
  }

  @override
  String floTimeDaysShort(String count) {
    return 'iminsi $count';
  }

  @override
  String get aiWhatsappNoMessages => 'Nta butumwa bwa WhatsApp buraza';

  @override
  String get aiWhatsappNoMessagesHint =>
      'Ubutumwa bwinjira buturuka kuri data-connector (Ditto yo muri telefoni ni ingoboka). Iyo Meta ibwohereje kuri webhook, bugaragara hano mu masegonda make.';

  @override
  String get aiWhatsappNoThreadMessages => 'Nta butumwa buri muri iki kiganiro';

  @override
  String get aiWhatsappPdfDownloadFailed => 'Ntibyashobotse gukuramo iyi PDF';

  @override
  String get aiWhatsappSavePdf => 'Bika PDF';

  @override
  String aiWhatsappSavedFile(String file) {
    return '$file yabitswe';
  }

  @override
  String aiWhatsappDownloadFailed(String error) {
    return 'Gukuramo byanze: $error';
  }

  @override
  String get aiWhatsappPdfDocument => 'Inyandiko ya PDF';

  @override
  String get aiWhatsappFloSuggestedReply => 'Igisubizo Flo igusabye';

  @override
  String get aiWhatsappSend => 'Ohereza';

  @override
  String get aiWhatsappEditFirst => 'Banza uhindure';

  @override
  String get aiWhatsappDraft => 'Tegura';

  @override
  String get aiWhatsappReplyHint => 'Subiza kuri WhatsApp…';

  @override
  String get floBusinessAi => 'AI y\'ubucuruzi';

  @override
  String get floMiniDataConnectedLive => 'MiniData ihujwe · ako kanya';

  @override
  String get floNewChat => 'Ikiganiro gishya';

  @override
  String get floAskFlo => 'Baza Flo';

  @override
  String get floMessages => 'Ubutumwa';

  @override
  String get floNewConversation => 'Ikiganiro gishya';

  @override
  String get floChatWithFloAndCustomers => 'Ganira na Flo n\'abakiriya';

  @override
  String get floOn => 'Birakora';

  @override
  String get floOff => 'Birafunze';

  @override
  String get floManageDataSources => 'Cunga aho amakuru aturuka';

  @override
  String get floQuickSummarizeToday => 'Incamake y\'uyu munsi';

  @override
  String get floQuickTopProducts => 'Ibicuruzwa by\'imbere';

  @override
  String get floQuickUserCount => 'Umubare w\'abakoresha';

  @override
  String get floQuickSalesTrend => 'Uko ibicuruzwa bigurishwa';

  @override
  String get floComposerHint =>
      'Baza ku byagurishijwe, ububiko, abakiriya cyangwa imisoro…';

  @override
  String get floStopDictating => 'Hagarika kuvuga';

  @override
  String get floDictate => 'Vuga — Flo irandika ibyo uvuze';

  @override
  String get floCanMakeMistakes =>
      'Flo ishobora kwibeshya — genzura imibare y\'ingenzi. ';

  @override
  String get floGroundedInMiniData => 'Bishingiye kuri MiniData.';

  @override
  String get floStarting => 'Biratangira…';

  @override
  String get floListening => 'Ndakumva…';

  @override
  String get floModeCloud => 'Kuri murandasi';

  @override
  String get floModeOnDevice => 'Kuri telefoni';

  @override
  String get floChooseAiMode => 'Hitamo uburyo bwa AI';

  @override
  String get floOnDeviceSubtitle => 'Ubuntu · nta murandasi · ibanga';

  @override
  String get floCloudSubtitle =>
      'Ifite ubushobozi burenzeho · ikoresha murandasi';

  @override
  String get floThinkingUnderstanding => 'Gusobanukirwa ikibazo';

  @override
  String get floThinkingQuerying => 'Gushakira muri MiniData';

  @override
  String get floThinkingComposing => 'Gutegura igisubizo';

  @override
  String get floCopied => 'Byakoporowe!';

  @override
  String get floCopyChart => 'Koporora igishushanyo';

  @override
  String get floSuggestedFollowUps => 'IBIBAZO BIKURIKIRA BYASABWE';

  @override
  String get aiDataSourceEdit => 'Hindura aho amakuru aturuka';

  @override
  String get aiDataSourceConnectTitle => 'Huza aho amakuru aturuka';

  @override
  String get aiDataSourceType => 'Ubwoko bw\'aho amakuru aturuka';

  @override
  String get aiDataSourceConnectionName => 'Izina ry\'ihuzwa';

  @override
  String get aiDataSourceConnectionNameHint => 'urugero: Ububiko bw\'ibikorwa';

  @override
  String get aiDataSourceSupabaseUrl => 'URL ya Supabase';

  @override
  String get aiDataSourceAnonKey => 'Urufunguzo rusange (Anon)';

  @override
  String get aiDataSourceServiceKey =>
      'Urufunguzo rwa Service Role (si ngombwa)';

  @override
  String get aiDataSourceServiceKeyHelper =>
      'Birakenewe ku bikorwa by\'ubuyobozi';

  @override
  String get aiDataSourceTestFailedCredentials =>
      'Igerageza ry\'ihuzwa ryanze. Reba amakuru yawe yo kwinjira.';

  @override
  String aiDataSourceTestFailed(String error) {
    return 'Igerageza ry\'ihuzwa ryanze: $error';
  }

  @override
  String get aiDataSourceTesting => 'Birageragezwa...';

  @override
  String get aiDataSourceTestConnection => 'Gerageza ihuzwa';

  @override
  String get aiDataSourcePrivacyNote =>
      'Iyo bihujwe, umufasha ashobora gukoresha imiterere n\'ingero z\'imirongo yo muri aya makuru mu biganiro byawe. Amakuru yo kwinjira abikwa kuri iki gikoresho gusa.';

  @override
  String get aiDataSourceEnterName => 'Andika izina ry\'ihuzwa';

  @override
  String get aiDataSourceEnterUrl => 'Andika URL ya Supabase';

  @override
  String get aiDataSourceEnterKey =>
      'Andika urufunguzo rusange cyangwa urwa Service Role';

  @override
  String get aiDataSourceUpdated => 'Aho amakuru aturuka havuguruwe neza';

  @override
  String get aiDataSourceConnected => 'Aho amakuru aturuka hahujwe neza';

  @override
  String aiDataSourceConnectFailed(String error) {
    return 'Guhuza byanze: $error';
  }

  @override
  String get aiDataSourceConnecting => 'Birahuzwa...';

  @override
  String get aiDataSourceUpdate => 'Vugurura';

  @override
  String get aiDataSourceConnect => 'Huza';

  @override
  String get aiDataSourceStatusConnected => 'Byahujwe';

  @override
  String get aiDataSourceStatusConnecting => 'Birahuzwa';

  @override
  String get aiDataSourceStatusError => 'Ikosa';

  @override
  String get aiDataSourceStatusDisconnected => 'Ntibihujwe';

  @override
  String get aiDataSourceTitle => 'Aho amakuru aturuka';

  @override
  String get aiDataSourceNotFound => 'Aho amakuru aturuka ntihabonetse';

  @override
  String get aiDataSourceGoBack => 'Subira inyuma';

  @override
  String get aiDataSourceTables => 'Imbonerahamwe';

  @override
  String get aiDataSourceUrl => 'URL';

  @override
  String get aiDataSourceNotAvailable => 'Ntabwo';

  @override
  String aiDataSourceLastConnected(String time) {
    return 'Byahujwe bwa nyuma: $time';
  }

  @override
  String get aiDataSourceInformation => 'Amakuru';

  @override
  String aiDataSourceMetadataFailed(String error) {
    return 'Gufungura ibisobanuro byanze: $error';
  }

  @override
  String get aiDataSourceTotalRows => 'Imirongo yose';

  @override
  String get aiDataSourceTypeLabel => 'Ubwoko';

  @override
  String get aiDataSourceUnknown => 'Ntibizwi';

  @override
  String aiDataSourceTablesFailed(String error) {
    return 'Gufungura imbonerahamwe byanze: $error';
  }

  @override
  String get aiDataSourceNoTables => 'Nta mbonerahamwe yabonetse';

  @override
  String aiDataSourceColumnsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Inkingi $count',
      one: 'Inkingi 1',
    );
    return '$_temp0';
  }

  @override
  String aiDataSourceRowsCount(String count) {
    return 'Imirongo $count';
  }

  @override
  String get aiDataSourceColumns => 'Inkingi';

  @override
  String get aiDataSourceNotNull => 'NTIBIBURA';

  @override
  String get aiDataSourceJustNow => 'Ubu nyine';

  @override
  String aiDataSourceMinutesAgo(String count) {
    return 'hashize imin $count';
  }

  @override
  String aiDataSourceHoursAgo(String count) {
    return 'hashize amasaha $count';
  }

  @override
  String get aiDataSourceCsvFile => 'Dosiye ya CSV';

  @override
  String get aiDataSourceJsonFile => 'Dosiye ya JSON';

  @override
  String get aiDataSources => 'Aho amakuru aturuka';

  @override
  String get aiDataSourceAdd => 'Ongeraho aho amakuru aturuka';

  @override
  String get aiDataSourceNoneConnected => 'Nta hantu amakuru aturuka hahujwe';

  @override
  String get aiDataSourceNoneHint =>
      'Huza ububiko bw\'amakuru kugira ngo AI ishobore gukoresha imiterere yabwo n\'ingero z\'imirongo\nisubiza mu kiganiro cy\'Ubucuruzi cyangwa Bwite.';

  @override
  String get aiDataSourceConnectFirst =>
      'Huza aho amakuru yawe ya mbere aturuka';

  @override
  String get aiDataSourceActive => 'Birakora';

  @override
  String get aiDataSourceDisconnect => 'Hagarika ihuzwa';

  @override
  String get aiDataSourceDeleteTitle => 'Siba aho amakuru aturuka';

  @override
  String aiDataSourceDeleteConfirm(String name) {
    return 'Urashaka koko gusiba \"$name\"? Ibi bizakuraho ihuzwa n\'amakuru yose ajyanye na ryo.';
  }

  @override
  String aiDataSourceDeleted(String name) {
    return 'Aho amakuru aturuka \"$name\" hasibwe';
  }

  @override
  String get aiWhatsappPhoneIdEmpty =>
      'ID ya nimero ya telefoni ntishobora kuba ubusa';

  @override
  String get aiWhatsappPhoneIdInvalid =>
      'ID ya nimero ya telefoni igomba kuba imibare gusa, iri hagati ya 5 na 15';

  @override
  String get aiWhatsappConnectedSuccess => 'Konti ya WhatsApp yahujwe neza';

  @override
  String get aiWhatsappDisconnectedSuccess => 'Konti ya WhatsApp yakuweho neza';

  @override
  String get aiWhatsappConnected => 'Byahujwe';

  @override
  String get aiWhatsappNotConnected => 'Ntibihujwe';

  @override
  String get aiWhatsappAccountActive => 'Konti irakora';

  @override
  String get aiWhatsappSavedToBusiness =>
      'Byabitswe kuri konti y\'ubucuruzi bwawe — bikomeza guhuzwa no ku bindi bikoresho iyo winjiyemo.';

  @override
  String get aiWhatsappDisconnecting => 'Birakurwaho...';

  @override
  String get aiWhatsappDisconnect => 'Hagarika ihuzwa';

  @override
  String get aiWhatsappConnectIntro =>
      'Huza konti yawe ya WhatsApp Business kugira ngo wakire kandi usubize ubutumwa bw\'abakiriya.';

  @override
  String get aiWhatsappStep1 => 'Jya kuri Meta Business Suite yawe';

  @override
  String get aiWhatsappStep2 =>
      'Shaka ID ya nimero yawe ya telefoni mu igenamiterere rya WhatsApp';

  @override
  String get aiWhatsappStep3 => 'Yishyire hasi hano maze uhuze';

  @override
  String get aiWhatsappPhoneIdLabel => 'ID ya nimero ya telefoni';

  @override
  String get aiWhatsappPhoneIdHint => 'urugero: 101514826127381';

  @override
  String get aiWhatsappConnectionError => 'Ikosa ryo guhuza';

  @override
  String get aiWhatsappTryAgain => 'Ongera ugerageze';

  @override
  String get aiMessageHint => 'Ubutumwa';

  @override
  String aiRecordingStartFailed(String error) {
    return 'Gutangira gufata amajwi byanze: $error';
  }

  @override
  String get aiVoiceMessageSent => 'Ubutumwa bw\'ijwi bwoherejwe!';

  @override
  String get aiAudioCorrupted =>
      'Dosiye y\'amajwi yangiritse cyangwa ntiyuzuye';

  @override
  String get aiRecordingTooShort =>
      'Amajwi ni magufi cyane (nibura isegonda 1)';

  @override
  String aiRecordingStopFailed(String error) {
    return 'Guhagarika gufata amajwi byanze: $error';
  }

  @override
  String get aiMicPermissionTitle => 'Uruhushya rwa mikoro';

  @override
  String get aiMicPermissionBody =>
      'Mikoro irakenewe kugira ngo ufate ubutumwa bw\'ijwi. Yemerere mu igenamiterere ry\'igikoresho cyawe.';

  @override
  String aiFilePickError(String error) {
    return 'Ikosa mu guhitamo dosiye: $error';
  }

  @override
  String get aiSlideToCancel => 'Nyereza uhagarike';

  @override
  String get aiSlideUpToLock => 'Nyereza hejuru ufunge';

  @override
  String get aiHoldAndSlide =>
      'Fata unyereze kugira ngo ugenzure ifatwa ry\'amajwi';

  @override
  String get aiExcelAnalysis => 'Isesengura rya Excel';

  @override
  String get aiExcelAnalystTitle => 'Umusesenguzi wa Excel wa AI';

  @override
  String get aiExcelAnalystSubtitle =>
      'Gusesengura mu buryo bufatika n\'ibishushanyo by\'imigendekere';

  @override
  String aiModelDefaultSuffix(String name) {
    return '$name (isanzwe)';
  }

  @override
  String get aiExcelNoData => 'Nta makuru yabonetse muri dosiye ya Excel';

  @override
  String get aiExcelSourceData => 'Amakuru y\'inkomoko:';

  @override
  String get aiExcelVisualAnalysis => 'Isesengura mu bishushanyo:';

  @override
  String aiChartRenderError(String error) {
    return 'Ikosa mu kwerekana igishushanyo: $error';
  }

  @override
  String get aiExcelAskForCharts =>
      'Baza ibibazo kugira ngo hakorwe ibishushanyo';

  @override
  String get aiExcelAnalystChat => 'Ikiganiro n\'umusesenguzi';

  @override
  String get aiExcelAskHint => 'Baza kuri aya makuru...';

  @override
  String get aiAssistant => 'Umufasha wa AI';

  @override
  String get aiConversations => 'Ibiganiro';

  @override
  String get aiAdd => 'Ongeraho';

  @override
  String get aiNewConversation => 'Ikiganiro gishya';

  @override
  String get aiDeleteConversation => 'Siba ikiganiro';

  @override
  String aiDaysAgo(String count) {
    return 'hashize iminsi $count';
  }

  @override
  String get aiPurchaseCredits => 'Gura inguzanyo';

  @override
  String get aiCopied => 'Byakoporowe';

  @override
  String get aiProcessingExpandThinking =>
      'AI iri gutekereza... Fungura ibitekerezo urebe ibisobanuro.';

  @override
  String get aiHideThinking => 'Hisha ibitekerezo';

  @override
  String get aiShowThinking => 'Erekana ibitekerezo';

  @override
  String get aiWelcomeTitle => 'Umufasha wawe wa AI mu bucuruzi';

  @override
  String get aiWelcomeSubtitle =>
      'Niteguye kugufasha gusobanukirwa ubucuruzi bwawe. Gerageza kubaza kimwe mu bibazo biri hasi.';

  @override
  String get aiSamplePersonalBooks => 'Ni ibihe bitabo byiza ku buyobozi?';

  @override
  String get aiSamplePersonalEmail =>
      'Mfasha kwandika imeyili yo kohereza ku mufatanyabikorwa ushoboka.';

  @override
  String get aiSamplePersonalTime => 'Mpa inama zo gucunga neza igihe.';

  @override
  String get aiSampleBusinessSales =>
      'Ibyo nagurishije byose mu cyumweru gishize byari angahe?';

  @override
  String get aiSampleBusinessTopProducts =>
      'Nyereka uko ibicuruzwa byanjye bigurishwa cyane muri uku kwezi bihagaze.';

  @override
  String get aiSampleBusinessTax =>
      'Kora incamake y\'imisoro y\'igihembwe gishize.';

  @override
  String get aiTaxBreakdown => 'ISESENGURA RY\'IMISORO';

  @override
  String get aiTotalTax => 'IMISORO YOSE';

  @override
  String get aiTaxSummaryReport => 'Raporo y\'incamake y\'imisoro';

  @override
  String get aiCopyReport => 'Koporora raporo';

  @override
  String get aiInventoryVisualization => 'Igishushanyo cy\'ububiko';

  @override
  String get aiComingSoon => 'Biraza vuba';

  @override
  String get uiTicketDue => 'ASIGAYE';

  @override
  String get uiTicketAmount => 'AMAFARANGA';

  @override
  String get aiYourShop => 'iduka ryawe';

  @override
  String get aiBranchIdRequired => 'ID y\'ishami irakenewe';

  @override
  String get aiNoResponse => 'Nta gisubizo cyabonetse. Ongera ugerageze.';

  @override
  String aiWhatsappSendMessageFailed(String error) {
    return 'Kohereza ubutumwa bwa WhatsApp byanze: $error';
  }

  @override
  String get aiChartNotFound =>
      'Ikosa: igishushanyo cyo gukoporora ntikibonetse.';

  @override
  String get aiChartImageFailed => 'Ikosa: ntibyashobotse gukora ifoto.';

  @override
  String get aiChartCopied => 'Igishushanyo cyakoporowe!';

  @override
  String aiChartCopyFailed(String error) {
    return 'Gukoporora igishushanyo byanze: $error';
  }

  @override
  String get aiVoiceUnavailable =>
      'Kwandika ukoresheje ijwi ntibiraboneka kuri iki gikoresho.';

  @override
  String aiVoiceStartFailed(String error) {
    return 'Ntibyashobotse gutangiza kwandika ukoresheje ijwi: $error';
  }

  @override
  String get aiMicAccessOff =>
      'Mikoro ntiyemerewe. Yemerere Flipper mu igenamiterere rya sisitemu, hanyuma wongere ugerageze.';

  @override
  String aiListenStartFailed(String error) {
    return 'Ntibyashobotse gutangira kumva: $error';
  }

  @override
  String get aiVoiceNeedsNetwork =>
      'Kwandika ukoresheje ijwi bikeneye murandasi ubu.';

  @override
  String get aiMicInUse => 'Mikoro irimo gukoreshwa n\'indi porogaramu.';

  @override
  String aiVoiceFailed(String error) {
    return 'Kwandika ukoresheje ijwi byanze ($error).';
  }

  @override
  String get aiLocalUnavailable =>
      'AI yo kuri telefoni ntiboneka kuri iki gikoresho.';

  @override
  String get aiLocalPreparing => 'Gutegura moderi yo kuri telefoni…';

  @override
  String aiLocalLoadFailed(String error) {
    return 'Ntibyashobotse gufungura moderi yo kuri telefoni: $error';
  }

  @override
  String get aiLocalReadingShopData => 'Gusoma amakuru y\'iduka ryawe…';

  @override
  String get aiLocalThinking => 'Gutekereza kuri telefoni…';

  @override
  String aiLocalGenerationFailed(String error) {
    return 'Gukora igisubizo kuri telefoni byanze: $error';
  }

  @override
  String get floBriefingSalesComingIn =>
      'Ibicuruzwa birimo kugurishwa uyu munsi.';

  @override
  String floBriefingBody(String revenue, String transactions, String units) {
    return 'Amafaranga yinjiye ageze kuri <b>RWF $revenue</b> mu <b>$transactions</b> (ibicuruzwa $units) uyu munsi — biturutse ku gikoresho cyawe ako kanya.';
  }

  @override
  String floBriefingTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'amagurisha $count',
      one: 'igurisha 1',
    );
    return '$_temp0';
  }

  @override
  String get floStatRevenue => 'Amafaranga yinjiye';

  @override
  String get floStatNetProfit => 'Inyungu nyayo';

  @override
  String get floStatUnitsSold => 'Ibicuruzwa byagurishijwe';

  @override
  String get aiWhatsappNoBusiness =>
      'Nta bucuruzi bwatoranyijwe — ntibishoboka kubika ihuzwa rya WhatsApp';

  @override
  String get aiWhatsappBusinessNotFound =>
      'Ubucuruzi ntibwabonetse — ntibishoboka kubika ihuzwa rya WhatsApp';

  @override
  String get loginErrorTimeout =>
      'Seriveri ya Flipper yatinze gusubiza. Interineti yawe ishobora kuba itinda. Ongera ugerageze. (TIMEOUT)';

  @override
  String get loginErrorSessionExpired =>
      'Igihe cyo kwinjira cyarangiye. Ongera wandike PIN yawe. (SESSION)';

  @override
  String get loginErrorPinCheckFailed =>
      'Iyo PIN ntiyashoboye kugenzurwa. Ongera ugerageze. (PIN)';

  @override
  String get loginErrorBadResponse =>
      'Seriveri ya Flipper yohereje igisubizo kitari cyitezwe. Ongera ugerageze mu munota umwe. (BAD-RESPONSE)';

  @override
  String get loginErrorTls =>
      'Guhuza mu buryo bwizewe ntibyakunze. Reba ko itariki n\'isaha bya telefoni yawe bishyirwaho byikora, hanyuma wongere ugerageze. (TLS)';

  @override
  String get loginErrorTlsNetwork =>
      'Guhuza na seriveri ya Flipper byacitse mbere yo kurindwa. Umuyoboro wawe ushobora kuba udahamye. Ongera ugerageze, cyangwa uhinduranye interineti ya telefoni na Wi-Fi. (TLS-NET)';

  @override
  String get loginErrorDns =>
      'Seriveri ya Flipper ntiboneka. Interineti yawe ishobora kuba yazimye cyangwa ifite imbogamizi. Reba interineti ya telefoni cyangwa Wi-Fi. (DNS)';

  @override
  String get loginErrorNetwork =>
      'Ntibyashobotse kugera kuri seriveri ya Flipper. Reba interineti yawe hanyuma wongere ugerageze. (NET)';

  @override
  String get loginErrorOfflineFirst =>
      'Iyi telefoni ntirashobora kukwinjiza nta interineti. Fata interineti winjire rimwe, hanyuma kwinjira nta interineti bizakunda. (OFFLINE-FIRST)';

  @override
  String get loginErrorUnknown =>
      'Kwinjira ntibyakunze. Ongera ugerageze. (UNKNOWN)';

  @override
  String get loginErrorNoAccountForPin =>
      'Nta konti ikoresha iyi PIN. Reba PIN hanyuma wongere ugerageze. (PIN-404)';

  @override
  String get loginErrorHttp404 =>
      'Seriveri ya Flipper ntiyabonye ibyo porogaramu yasabye. Vugurura porogaramu hanyuma wongere ugerageze. (HTTP-404)';

  @override
  String get loginErrorHttp429 =>
      'Wagerageje inshuro nyinshi cyane. Tegereza umunota umwe, hanyuma wongere ugerageze. (HTTP-429)';

  @override
  String loginErrorHttpRefused(String status) {
    return 'Seriveri ya Flipper yanze iki cyifuzo. Vugurura porogaramu hanyuma wongere ugerageze. (HTTP-$status)';
  }

  @override
  String loginErrorHttpServer(String status) {
    return 'Seriveri za Flipper zifite ikibazo muri iki gihe. Ongera ugerageze mu munota umwe. (HTTP-$status)';
  }

  @override
  String loginErrorHttpOther(String status) {
    return 'Seriveri ya Flipper ntiyashoboye kugenzura iyi PIN. Ongera ugerageze. (HTTP-$status)';
  }

  @override
  String get loginYourBusiness => 'ubucuruzi bwawe';

  @override
  String get loginPinRequired => 'PIN irakenewe';

  @override
  String get loginPinTooShort => 'PIN igomba kugira nibura imibare 4';

  @override
  String loginPinTooLong(String max) {
    return 'PIN ntigomba kurenza imibare $max';
  }

  @override
  String get loginAuthenticatorCodeRequired =>
      'Kode ya Authenticator irakenewe';

  @override
  String get loginOtpRequired => 'OTP irakenewe';

  @override
  String get loginAuthenticatorCodeInvalidFormat =>
      'Kode ya Authenticator igomba kuba imibare 6.';

  @override
  String get loginOtpInvalidFormat => 'OTP igomba kuba imibare 6.';

  @override
  String get loginInvalidPinReenter =>
      'PIN ntabwo ari yo. Nyamuneka yandike bundi bushya wongere ugerageze.';

  @override
  String get loginAuthenticatorUnavailable =>
      'Ntibyashobotse kugera kuri seriveri ngo Authenticator yawe ifungurwe kuri iki gikoresho. Reba interineti yawe hanyuma wongere ugerageze.';

  @override
  String get loginAuthenticatorNotEnrolled =>
      'Nta Authenticator yashyizweho kuri iyi konti. Injira ukoresheje SMS, hanyuma uyishyireho muri Igenamiterere.';

  @override
  String get loginAuthenticatorInvalidCode =>
      'Kode ya Authenticator ntabwo ari yo. Nyamuneka ongera ugerageze.';

  @override
  String get loginPinSubtitle =>
      'Andika PIN yawe kugira ngo ucunge ubucuruzi bwawe mu mutekano.';

  @override
  String get loginSignedIn => 'Winjiye';

  @override
  String get loginSignIn => 'Injira';

  @override
  String get loginCreateAnAccount => 'Fungura konti';

  @override
  String get loginNewToFlipperCreateAccount =>
      'Uri mushya kuri Flipper? Fungura konti';

  @override
  String get loginShowPin => 'Erekana PIN';

  @override
  String get loginHidePin => 'Hisha PIN';

  @override
  String get loginShow => 'Erekana';

  @override
  String get loginHide => 'Hisha';

  @override
  String loginPinDigitsEntered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Imibare $count yanditswe',
      one: 'Umubare 1 wanditswe',
    );
    return '$_temp0';
  }

  @override
  String get loginAuthenticator => 'Authenticator';

  @override
  String get loginAuthenticatorCode => 'Kode ya Authenticator';

  @override
  String get loginSmsCode => 'Kode ya SMS';

  @override
  String get loginPinEntryCells => 'Udusanduku two kwandikamo PIN';

  @override
  String loginVerifiedOpening(String business) {
    return 'Byemejwe — turi gufungura $business…';
  }

  @override
  String get loginShowOrHidePin => 'Erekana cyangwa uhishe PIN';

  @override
  String get loginBackspace => 'Siba';

  @override
  String get loginSecuredE2e =>
      'Birinzwe n\'uburyo bw\'ibanga kuva ku mpera imwe kugeza ku yindi';

  @override
  String get loginBrandHeadline =>
      'Iduka ryawe, abakozi bawe, imibare yawe — byose ahantu hamwe.';

  @override
  String get loginBrandSubhead =>
      'Komereza aho wari ugeze. Ibyagurishijwe by\'uyu munsi, ububiko na raporo biriteguye.';

  @override
  String get loginStatBusinesses => 'ubucuruzi';

  @override
  String get loginStatProcessedMonthly => 'bicungwa buri kwezi';

  @override
  String get loginStatUptime => 'igihe sisitemu ikora';

  @override
  String get loginRevenueThisWeek => 'Amafaranga yinjiye · iki cyumweru';

  @override
  String get loginNewSale => 'Igurisha rishya';

  @override
  String get loginSampleSaleDetail =>
      'Ibikoresho by\'imirasire y\'izuba · MoMo';

  @override
  String loginStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Iminsi $count',
      one: 'Umunsi 1',
    );
    return '$_temp0';
  }

  @override
  String get loginSalesStreak => 'Iminsi ikurikirana yo kugurisha';

  @override
  String get loginLandingSlide1Title =>
      'Cunga ubucuruzi\nbwawe bwose muri porogaramu imwe';

  @override
  String get loginLandingSlide1Highlight => 'ubucuruzi';

  @override
  String get loginLandingSlide1Text =>
      'Gurisha, ukurikirane ububiko, kandi ucunge abakozi bawe - Flipper ni ubucuruzi bwawe mu mufuka.';

  @override
  String get loginLandingSlide2Title =>
      'Raporo zoroshye kandi\nzigufasha gutera imbere';

  @override
  String get loginLandingSlide2Highlight => 'Raporo';

  @override
  String get loginLandingSlide2Text =>
      'Menya neza ibigurishwa, ibiri hafi gushira, n\'aho amafaranga yawe ajya - buri munsi.';

  @override
  String get loginLandingSlide3Title =>
      'Ishyurwa vuba,\nukurikirane buri faranga';

  @override
  String get loginLandingSlide3Highlight => 'ukurikirane buri faranga';

  @override
  String get loginLandingSlide3Text =>
      'Akira MoMo, amafaranga mu ntoki n\'ikarita. Flipper yandika buri igurisha ikanaguhuriza konti.';

  @override
  String get loginLandingSlide4Title =>
      'Teza imbere ubucuruzi bwawe,\nubone ibihembo';

  @override
  String get loginLandingSlide4Highlight => 'ubone ibihembo';

  @override
  String get loginLandingSlide4Text =>
      'Gera ku ntego za buri munsi, ntuhagarike urukurikirane rwawe, kandi uzamuke uve ku Mucuruzi wa Bronze ugere ku Mucuruzi wa Zahabu.';

  @override
  String get loginLandingSemantic => 'Ahabanza ha Flipper';

  @override
  String get loginNext => 'Ibikurikira';

  @override
  String get loginSkipIntroSemantic => 'Simbuka intangiriro ufungure konti';

  @override
  String get loginSkipIntro => 'Simbuka intangiriro - Fungura konti';

  @override
  String get loginAlreadySellingSignIn =>
      'Usanzwe ucururiza kuri Flipper? Injira';

  @override
  String get loginDailyReport => 'Raporo ya buri munsi';

  @override
  String get loginStock => 'Ububiko';

  @override
  String get loginTax => 'Imisoro';

  @override
  String get loginGoldSeller => 'Umucuruzi wa Zahabu';

  @override
  String get loginFinalizingAuthentication => 'Turi kurangiza kwemeza...';

  @override
  String get loginAuthTimedOut =>
      'Igihe cyo kwemeza cyarenze. Nyamuneka ongera ugerageze.';

  @override
  String get loginPhoneLoginNavigationFailed =>
      'Ntibyashobotse gufungura kwinjira ukoresheje telefoni';

  @override
  String get loginSignInFailed => 'Kwinjira ntibyakunze';

  @override
  String get loginAuthenticationFailed => 'Kwemeza umwirondoro ntibyakunze';

  @override
  String get loginUnexpectedError => 'Habaye ikibazo kitunguranye';

  @override
  String get loginAuthDomainUnauthorized =>
      'Domeni yo kwemeza ntiyemewe. Nyamuneka vugana n\'abatanga ubufasha.';

  @override
  String get loginAccountDisabled => 'Iyi konti yahagaritswe.';

  @override
  String get loginAccountExistsDifferentCredential =>
      'Hari konti isanzwe ifite iyi meyili ariko ikoresha ubundi buryo bwo kwinjira.';

  @override
  String loginMicrosoftFailedWithReason(String error) {
    return 'Kwinjira na Microsoft ntibyakunze: $error';
  }

  @override
  String get loginMicrosoftFailed =>
      'Kwinjira na Microsoft ntibyakunze. Nyamuneka uzongere ugerageze nyuma.';

  @override
  String loginAppleAuthorizationFailed(String error) {
    return 'Uburenganzira bwa Apple ntibwabonetse: $error';
  }

  @override
  String loginAppleFailed(String error) {
    return 'Kwinjira na Apple ntibyakunze: $error';
  }

  @override
  String get loginWelcomeToFlipper => 'Murakaza neza kuri Flipper';

  @override
  String get loginHowToSignIn => 'Urashaka kwinjira ute?';

  @override
  String get loginLoggingIn => 'Turi kwinjira...';

  @override
  String get loginTryAgainOrUsePin =>
      'Nyamuneka ongera ugerageze cyangwa winjire ukoresheje PIN';

  @override
  String get loginSuccessful => 'Winjiye neza!';

  @override
  String get loginQrScanned => 'QR code yasomwe! Turi kurangiza kwinjira...';

  @override
  String get loginFailedTryAgain =>
      'Kwinjira ntibyakunze. Nyamuneka ongera ugerageze.';

  @override
  String get loginSuccessfulRedirecting => 'Winjiye neza! Turi kukwerekeza...';

  @override
  String get loginQrTitle => 'Injira muri Flipper ukoresheje QR code';

  @override
  String get loginQrStep1 => '1. Fungura Flipper kuri telefoni yawe';

  @override
  String get loginQrStep2 =>
      '2. Jya ku kamenyetso ka Profile > ugakandeho igihe kirekire.';

  @override
  String get loginQrStep3 =>
      '3. Erekeza telefoni yawe kuri iyi paji kugira ngo wemeze kwinjira';

  @override
  String get loginDownloadApp => 'Nta porogaramu ya Flipper ufite? Yimanure:';

  @override
  String get loginOpeningAppStore => 'Turi gufungura App Store...';

  @override
  String get loginOpeningPlayStore => 'Turi gufungura Play Store...';

  @override
  String get loginSwitchToPin => 'Koresha PIN winjire';

  @override
  String get loginDeviceOffline => 'Igikoresho nta interineti gifite';

  @override
  String get loginInvalidEmail => 'Imeyili itemewe';

  @override
  String get loginGmailRequired => 'Imeyili ya Gmail irakenewe';

  @override
  String get loginEnterEmail => 'Andika imeyili';

  @override
  String get loginAddEmailHint =>
      'Numara kwandika imeyili yawe, kanda kuri Ongeramo imeyili';

  @override
  String get signupErrorGeneric => 'Habaye ikibazo mu gufungura konti';

  @override
  String get signupOtpExpiredOrInvalid =>
      'OTP yarangiye cyangwa ntabwo ari yo. Nyamuneka saba kode nshya.';

  @override
  String get signupResendOtp => 'Ongera wohereze OTP';

  @override
  String get signupNewOtpSent => 'OTP nshya yoherejwe neza!';

  @override
  String signupFailedToResendOtp(String error) {
    return 'Kongera kohereza OTP ntibyakunze: $error';
  }

  @override
  String get signupUsername => 'Izina ukoresha';

  @override
  String get signupUsernameHint => 'Andika izina ukoresha';

  @override
  String get signupFullName => 'Amazina yose';

  @override
  String get signupFullNameHint => 'Izina bwite, Izina ry\'umuryango';

  @override
  String get signupPhoneOrEmail => 'Telefoni / Imeyili';

  @override
  String get signupPhoneOrEmailHint => '783054874 cyangwa your@email.com';

  @override
  String get signupOtpResent => 'OTP yongeye koherezwa neza!';

  @override
  String get signupResend => 'Ongera wohereze';

  @override
  String get signupOtpSent => 'OTP yoherejwe neza!';

  @override
  String signupFailedToSendOtp(String error) {
    return 'Kohereza OTP ntibyakunze: $error';
  }

  @override
  String get signupSendCode => 'Ohereza kode';

  @override
  String get signupOtpCode => 'Kode ya OTP';

  @override
  String get signupOtpHint => 'Andika OTP y\'imibare 6';

  @override
  String get signupPhoneVerified => 'Nimero ya telefoni yemejwe neza!';

  @override
  String get signupUsage => 'Imikoreshereze';

  @override
  String get signupCountry => 'Igihugu';

  @override
  String get signupSearchCountry => 'Shakisha igihugu cyawe';

  @override
  String get signupStepIdentity => 'Umwirondoro';

  @override
  String get signupStepVerify => 'Kwemeza';

  @override
  String signupStepOf(String step, String total) {
    return 'Intambwe $step kuri $total';
  }

  @override
  String get signupRewardTitle => 'Rangiza kwiyandikisha ubone amanota 500';

  @override
  String get signupRewardSubtitle =>
      'Koresha amanota ugabanyirizwe ikiguzi kandi ubone raporo zihariye';

  @override
  String get signupStep1Title => 'Uri nde?';

  @override
  String get signupStep1Description =>
      'Ibi ni byo uzakoresha winjira, kandi ni byo bagenzi bawe bazakoresha bakubona.';

  @override
  String get signupStep2Title => 'Twakubona dute?';

  @override
  String get signupStep2Description =>
      'Turakoherereza kode y\'inshuro imwe kugira ngo twemeze ko ari wowe koko.';

  @override
  String get signupStep3Title => 'Tubwire ibijyanye n\'iduka ryawe';

  @override
  String get signupStep3Description => 'Tuzahuza Flipper n\'uburyo ucuruza.';

  @override
  String get signupCreateAccountClaim => 'Fungura konti · akira amanota 500';

  @override
  String signupTermsAgreement(String terms, String privacy) {
    return 'Ukomeje, uba wemeye $terms na $privacy bya Flipper';
  }

  @override
  String get signupTermsLink => 'Amabwiriza';

  @override
  String get signupPrivacyLink => 'Politiki y\'ibanga';

  @override
  String get signupVerificationFailed => 'Kwemeza ntibyakunze';

  @override
  String get signupNameTooLong => 'Izina ni rirerire cyane';

  @override
  String get signupContactRequired =>
      'Nimero ya telefoni cyangwa imeyili irakenewe';

  @override
  String get signupContactInvalid =>
      'Nyamuneka andika nimero ya telefoni cyangwa imeyili byemewe';

  @override
  String get signupUsernameRequired =>
      'Izina ukoresha cyangwa izina ry\'ubucuruzi rirakenewe';

  @override
  String get signupUsernameTaken => 'Iryo zina ukoresha ryamaze gufatwa';

  @override
  String get signupUsernameCheckUnavailable =>
      'Gushakisha izina ntibiboneka ubu';

  @override
  String get signupOtpMustBe6Digits => 'OTP igomba kuba imibare 6';

  @override
  String get signupOtpDigitsOnly => 'OTP igomba kuba igizwe n\'imibare gusa';

  @override
  String get signupValidateTin => 'Nyamuneka emeza TIN';

  @override
  String get signupPhoneMustBeVerified => 'Nimero ya telefoni igomba kwemezwa';

  @override
  String get signupFieldRequired => 'Iki gice kigomba kuzuzwa.';

  @override
  String get signupSelectOption => 'Nyamuneka hitamo kimwe';

  @override
  String get signupJoinFlipper => 'Iyandikishe kuri Flipper';

  @override
  String get signupJourneyTagline => 'Tangira urugendo natwe uyu munsi 🚀';

  @override
  String get signupNoMatches => 'Nta bihuye';

  @override
  String get signupTinExtractFailed =>
      'Ntibyashobotse gukura TIN mu nyandiko watanze';

  @override
  String signupTinPdfError(String error) {
    return 'Ikosa mu gusoma PDF: $error';
  }

  @override
  String signupTinValidated(String name) {
    return 'TIN yemejwe: $name';
  }

  @override
  String get signupTinNoData => 'Nta makuru yabonetse kuri iyi TIN';

  @override
  String get signupTinServiceUnavailable =>
      'Serivisi ntiboneka: kwemeza byasimbutswe';

  @override
  String signupTinValidationError(String error) {
    return 'Ikosa mu kwemeza TIN: $error';
  }

  @override
  String get phoneAuthSelectCountryTitle =>
      'Hitamo igihugu ubucuruzi bwawe bukoreramo';

  @override
  String get phoneAuthSearchCountry => 'Shakisha igihugu...';

  @override
  String get phoneAuthAgreeSellerAgreement =>
      'Nemeye Amasezerano y\'Umucuruzi na Politiki y\'Ibanga bya Flipper.';

  @override
  String get phoneAuthRecaptchaNotice =>
      'Iyi porogaramu irinzwe na reCAPTCHA Enterprise, kandi Politiki y\'Ibanga n\'Amabwiriza ya Serivisi bya Google birakurikizwa.';

  @override
  String get phoneAuthEnterPhone => 'Nyamuneka andika nimero yawe ya telefoni';

  @override
  String get phoneAuthInvalidPhone =>
      'Nyamuneka andika nimero ya telefoni yemewe';

  @override
  String get phoneAuthTitle => 'Kwemeza telefoni';

  @override
  String get phoneAuthSubtitle =>
      'Turakoherereza kode yo kwemeza kuri nimero yawe ya telefoni kugira ngo twemeze umwirondoro wawe.';

  @override
  String get phoneAuthPhoneHint => '783054874 (utabanje 0)';

  @override
  String phoneAuthTermsAgreement(String terms, String privacy) {
    return 'Ukomeje, uba wemeye $terms na $privacy byacu';
  }

  @override
  String get phoneAuthTermsOfService => 'Amabwiriza ya Serivisi';

  @override
  String get phoneAuthPrivacyPolicy => 'Politiki y\'Ibanga';

  @override
  String get phoneAuthVerificationCode => 'Kode yo kwemeza';

  @override
  String get phoneAuthChangeNumber => 'Hindura nimero ya telefoni';

  @override
  String phoneAuthVerificationFailed(String error) {
    return 'Kwemeza ntibyakunze: $error';
  }

  @override
  String get phoneAuthUnknownError => 'Habaye ikibazo kitazwi';

  @override
  String phoneAuthErrorOccurred(String error) {
    return 'Habaye ikibazo: $error';
  }

  @override
  String get phoneAuthNewCodeSent => 'Kode nshya yo kwemeza yoherejwe';

  @override
  String get phoneAuthEnterValidCode =>
      'Nyamuneka andika kode yemewe y\'imibare 6';

  @override
  String get phoneAuthCodeExpired =>
      'Iyi kode yo kwemeza yarangiye. Nyamuneka saba indi nshya.';

  @override
  String phoneAuthFailedToVerify(String error) {
    return 'Kwemeza kode ntibyakunze: $error';
  }

  @override
  String phoneAuthAuthFailed(String error) {
    return 'Kwemeza umwirondoro ntibyakunze: $error';
  }

  @override
  String get loginFailed => 'Kwinjira byanze';
}
