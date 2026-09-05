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
    return 'No. $number';
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
}
