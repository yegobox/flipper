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
      'Ntibyashobotse kugenzura Authenticator. Reba interineti yawe, cyangwa winjire rimwe ufite interineti kugira ngo MFA ibashe gukora nta interineti.';

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
