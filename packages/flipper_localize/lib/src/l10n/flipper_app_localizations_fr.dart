// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'flipper_app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class FlipperAppLocalizationsFr extends FlipperAppLocalizations {
  FlipperAppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get save => 'Enregistrer';

  @override
  String get retailPrice => 'Prix';

  @override
  String get supplyPrice => 'Prix fournisseur';

  @override
  String get currentSale => 'Vente en cours';

  @override
  String get currentStock => 'Stock actuel';

  @override
  String get addProduct => 'Ajouter des produits';

  @override
  String get tickets => 'Tickets';

  @override
  String get charge => 'Facturer';

  @override
  String get productName => 'Nom du produit';

  @override
  String get flipperSetting => 'Paramètres';

  @override
  String get options => 'Options';

  @override
  String get saveTicket =>
      'Vous ne pouvez pas enregistrer le ticket sans ajouter une note';

  @override
  String get productNotFound => 'Produit introuvable';

  @override
  String get noPayable => 'Aucun montant à payer';

  @override
  String get delete => 'Supprimer';

  @override
  String get addTomenu => 'Menu';

  @override
  String get edit => 'Modifier';

  @override
  String get addWorkSpace => 'Ajouter un espace de travail';

  @override
  String get addMembers => 'Ajouter des membres';

  @override
  String get logOut => 'Se déconnecter';

  @override
  String get syncCounter => 'Synchroniser le compteur';

  @override
  String get resetTransaction => 'Réinitialiser la transaction';

  @override
  String get resetTransactionQuestion => 'Réinitialiser la transaction ?';

  @override
  String get resetTransactionDescription =>
      'Cela supprimera la transaction en attente actuelle et tous ses articles. Cette action est irréversible.';

  @override
  String get transactionResetSuccessfully =>
      'Transaction réinitialisée avec succès';

  @override
  String errorResettingTransaction(Object error) {
    return 'Erreur lors de la réinitialisation de la transaction : $error';
  }

  @override
  String get selectedContactHasNoPhoneNumber =>
      'Le contact sélectionné n\'a pas de numéro de téléphone';

  @override
  String get contactsPermissionRequired =>
      'L\'autorisation d\'accéder aux contacts est requise pour choisir un contact';

  @override
  String get permissionRequired => 'Autorisation requise';

  @override
  String get contactsPermissionDeniedSettings =>
      'L\'autorisation d\'accéder aux contacts a été refusée définitivement. Activez-la dans les paramètres de votre appareil pour utiliser cette fonctionnalité.';

  @override
  String get cancel => 'Annuler';

  @override
  String get openSettings => 'Ouvrir les paramètres';

  @override
  String errorMessage(Object error) {
    return 'Erreur : $error';
  }

  @override
  String get error => 'Erreur';

  @override
  String get pickFromContacts => 'Choisir dans les contacts';

  @override
  String get linkDevice => 'Lier un appareil';

  @override
  String get useFlipperOnOtherDevices =>
      'Utilisez Flipper sur d\'autres appareils';

  @override
  String get linkADevice => 'Lier un appareil';

  @override
  String pinCode(Object pin) {
    return 'PIN : $pin';
  }

  @override
  String get listOfConnectedDevices => 'Liste des appareils connectés';

  @override
  String paymentTitle(Object paymentType) {
    return 'Paiement : $paymentType';
  }

  @override
  String get digitalReceipt => 'Reçu numérique';

  @override
  String get needDigitalReceipt => 'Avez-vous besoin d\'un reçu numérique ?';

  @override
  String get purchaseCode => 'Code d\'achat';

  @override
  String get pleaseEnterPurchaseCode => 'Veuillez saisir un code d\'achat';

  @override
  String get submit => 'Envoyer';

  @override
  String get done => 'Terminé';

  @override
  String get receipt => 'Reçu';

  @override
  String get addNote => 'Ajouter une note';

  @override
  String get generatingReceiptWait =>
      'Veuillez patienter, nous générons le reçu';

  @override
  String get poweredBy => 'Propulsé par';

  @override
  String get returnToHome => 'Retour à l\'accueil';

  @override
  String get personalGoals => 'Objectifs personnels';

  @override
  String get selectBranchToManageGoals =>
      'Sélectionnez une succursale pour gérer les objectifs.';

  @override
  String couldNotLoadGoals(Object error) {
    return 'Impossible de charger les objectifs\n$error';
  }

  @override
  String get personalGoalsEyebrow => 'OBJECTIFS PERSONNELS';

  @override
  String totalReservedAcrossGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count objectifs',
      one: '1 objectif',
    );
    return 'Total réservé sur $_temp0';
  }

  @override
  String get savedThisMonth => 'Épargné ce mois-ci';

  @override
  String onTrackCount(Object count) {
    return '$count en bonne voie';
  }

  @override
  String get goalsProgressing => 'Objectifs en progression';

  @override
  String get allGoals => 'Tous les objectifs';

  @override
  String get personalGoalsProfitGrowth =>
      'Flipper fait discrètement croître chaque objectif à partir de vos bénéfices.';

  @override
  String get searchProducts => 'Rechercher des produits…';

  @override
  String get clearSelection => 'Effacer la sélection';

  @override
  String itemsSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles sélectionnés',
      one: '1 article sélectionné',
    );
    return '$_temp0';
  }

  @override
  String get cannotDeleteVariantWithStockRemaining =>
      'Impossible de supprimer une variante qui a encore du stock.';

  @override
  String get deleteMultipleItems => 'Supprimer plusieurs articles';

  @override
  String deleteItemsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return 'Voulez-vous vraiment supprimer $_temp0 ? Cette action est irréversible.';
  }

  @override
  String get refreshProducts => 'Actualiser les produits';

  @override
  String get productsSyncingHint =>
      'Si vous venez d\'ouvrir l\'application, les produits sont peut-être encore en cours de synchronisation — appuyez sur actualiser.';

  @override
  String get errorLoadingProducts => 'Erreur lors du chargement des produits';

  @override
  String get retry => 'Réessayer';

  @override
  String get noStockDataAvailable => 'Aucune donnée de stock disponible';

  @override
  String get cash => 'Espèces';

  @override
  String get credit => 'Crédit';

  @override
  String get momoPayerPhone => 'Téléphone du payeur MoMo';

  @override
  String get momoPaymentRequestHint =>
      'Nous enverrons une demande de paiement à ce numéro lorsque vous appuierez sur Facturer.';

  @override
  String get exact => 'Exact';

  @override
  String get confirm => 'Confirmer';

  @override
  String get numberOfPayments => 'Nombre de paiements';

  @override
  String get applyDiscountCode => 'Appliquer un code de remise';

  @override
  String get discountCode => 'Code de remise';

  @override
  String get validatingCode => 'Validation du code...';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get signIn => 'SE CONNECTER';

  @override
  String get setDeviceTimeAutomatic =>
      'Veuillez régler l\'heure de votre appareil sur automatique';

  @override
  String get continueWithPhone => 'Continuer avec le téléphone';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get continueWithMicrosoft => 'Continuer avec Microsoft';

  @override
  String get continueWithApple => 'Continuer avec Apple';

  @override
  String get or => 'OU';

  @override
  String get pinLogin => 'Connexion par PIN';

  @override
  String get languagesTitle => 'Langues';

  @override
  String get english => 'Anglais';

  @override
  String get kinyarwanda => 'Kinyarwanda';

  @override
  String get swahili => 'Swahili';

  @override
  String get settings => 'Paramètres';

  @override
  String get home => 'Accueil';

  @override
  String get sales => 'Ventes';

  @override
  String get inventory => 'Stock';

  @override
  String get more => 'Plus';

  @override
  String get scanQr => 'Scanner le QR';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get noUser => 'Aucun utilisateur';

  @override
  String get pleaseLogInToContinue => 'Veuillez vous connecter pour continuer';

  @override
  String get loadingBusinesses => 'Chargement des entreprises...';

  @override
  String get errorLoadingBusinesses =>
      'Erreur lors du chargement des entreprises';

  @override
  String get noBusinesses => 'Aucune entreprise';

  @override
  String get createFirstBusiness =>
      'Créez votre première entreprise pour commencer';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get sendingCode => 'Envoi du code...';

  @override
  String get continueAction => 'Continuer';

  @override
  String get enterSixDigitCodeSentTo =>
      'Saisissez le code à 6 chiffres envoyé au ';

  @override
  String get codeExpiredTapToResend => 'Code expiré - Appuyez pour renvoyer';

  @override
  String get resendCode => 'Renvoyer le code';

  @override
  String get resendCodeIn => 'Renvoyer le code dans ';

  @override
  String get seconds => 'secondes';

  @override
  String get verifying => 'Vérification...';

  @override
  String get verifyCode => 'Vérifier le code';

  @override
  String get troubleSigningIn => 'Problème de connexion ?';

  @override
  String get troubleSigningInHelp =>
      'Si vous avez des difficultés à vous connecter, vérifiez que votre PIN et votre OTP (le cas échéant) sont corrects.\n\nPour toute aide supplémentaire, contactez le support.';

  @override
  String get ok => 'OK';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get tinNumber => 'Numéro TIN';

  @override
  String get validate => 'Valider';

  @override
  String get uploadPdfWithTin => 'Téléverser un PDF avec le TIN';

  @override
  String get enterTinOrUpload =>
      'Saisissez le numéro TIN ou appuyez sur l\'icône de téléversement';

  @override
  String get addEmail => 'Ajouter un e-mail';

  @override
  String get emailAdded => 'E-mail ajouté';

  @override
  String get updateSettings => 'Mettre à jour les paramètres';

  @override
  String get invite => 'Inviter';

  @override
  String get sendRequest => 'Envoyer la demande';

  @override
  String get preferences => 'Préférences';

  @override
  String get accessibility => 'Accessibilité';

  @override
  String get language => 'Langue';

  @override
  String get reports => 'Rapports';

  @override
  String get enableReport => 'Activer le rapport';

  @override
  String get backups => 'Sauvegardes';

  @override
  String get addBackup => 'Ajouter une sauvegarde';

  @override
  String get restoreData => 'Restaurer les données';

  @override
  String get dataRestored => 'Données restaurées';

  @override
  String get errorRestoringBackup =>
      'Erreur lors de la restauration de la sauvegarde';

  @override
  String get transactionIdCopiedToClipboard =>
      'ID de transaction copié dans le presse-papiers';

  @override
  String get transactionIdShortLabel => 'ID transaction : ';

  @override
  String get invoiceNumberLabel => 'N° de facture : ';

  @override
  String get parkSaleAsTicket => 'Mettre cette vente en attente comme ticket';

  @override
  String get saveTicketAction => 'Enregistrer le ticket';

  @override
  String get remainingBalanceLabel => 'Solde restant : ';

  @override
  String get amountToChangeLabel => 'Montant à rendre : ';

  @override
  String get allApps => 'Toutes les applications';

  @override
  String get sell => 'Vendre';

  @override
  String get quickSell => 'Vente rapide';

  @override
  String get invoices => 'Factures';

  @override
  String get pricing => 'Tarifs';

  @override
  String get payments => 'Paiements';

  @override
  String get manage => 'Gérer';

  @override
  String get purchases => 'Achats';

  @override
  String get customers => 'Clients';

  @override
  String get leads => 'Prospects';

  @override
  String get insights => 'Analyses';

  @override
  String get dailyReports => 'Rapports quotidiens';

  @override
  String get commissions => 'Commissions';

  @override
  String get production => 'Production';

  @override
  String get business => 'Entreprise';

  @override
  String get servicesHub => 'Espace services';

  @override
  String get goals => 'Objectifs';

  @override
  String get aiChat => 'Chat IA';

  @override
  String get errorLoadingTransactionView =>
      'Erreur lors du chargement de la transaction';

  @override
  String get customer => 'Client';

  @override
  String get payment => 'Paiement';

  @override
  String get delivery => 'Livraison';

  @override
  String get transactionSummary => 'Récapitulatif de la transaction';

  @override
  String get transactionSummaryHint =>
      'Affiche le montant total et l\'ID de la vente en cours';

  @override
  String get totalAmount => 'Montant total';

  @override
  String get cannotDeletePartialPaymentItems =>
      'Impossible de supprimer des articles d\'une transaction avec paiements partiels';

  @override
  String get deleteAllItems => 'Supprimer tous les articles';

  @override
  String get confirmRemoveAllTransactionItems =>
      'Voulez-vous vraiment retirer tous les articles de cette transaction ?';

  @override
  String get deleteAll => 'Tout supprimer';

  @override
  String get allItemsRemovedSuccessfully =>
      'Tous les articles ont été retirés avec succès';

  @override
  String errorRemovingItems(String error) {
    return 'Erreur lors du retrait des articles : $error';
  }

  @override
  String get noItemsAdded => 'Aucun article ajouté';

  @override
  String get tapAddFirstItem =>
      'Appuyez sur le bouton + pour ajouter votre premier article';

  @override
  String cartItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return '$_temp0';
  }

  @override
  String itemSemanticLabel(String itemName) {
    return 'Article : $itemName';
  }

  @override
  String cartItemSemanticHint(
    String quantity,
    String unitPrice,
    String subtotal,
  ) {
    return 'Quantité : $quantity, Prix unitaire : $unitPrice, Sous-total : $subtotal';
  }

  @override
  String get removeItem => 'Retirer l\'article';

  @override
  String get unitPrice => 'Prix unitaire';

  @override
  String get decreaseQuantityByOne => 'Diminuer la quantité de 1';

  @override
  String get increaseQuantityByOne => 'Augmenter la quantité de 1';

  @override
  String get subtotal => 'Sous-total';

  @override
  String get deliveryDate => 'Date de livraison';

  @override
  String get transactionSummaryPaymentActions =>
      'Récapitulatif de la transaction et actions de paiement';

  @override
  String completeSaleTotalHint(String total) {
    return 'Finaliser la vente pour un total de $total';
  }

  @override
  String errorWithValue(String error) {
    return 'Erreur : $error';
  }

  @override
  String confirmRemoveItemFromTransaction(String itemName) {
    return 'Voulez-vous vraiment retirer « $itemName » de cette transaction ?';
  }

  @override
  String get remove => 'Retirer';

  @override
  String get cannotModifyPartialPaymentItems =>
      'Impossible de modifier les articles d\'une transaction avec paiements partiels';

  @override
  String get failedToRemoveItem => 'Échec du retrait de l\'article';

  @override
  String get failedToUpdateItemQuantity =>
      'Échec de la mise à jour de la quantité';

  @override
  String get transactionItemsList => 'Liste des articles de la transaction';

  @override
  String get transactionItemsListHint =>
      'Liste des articles de la transaction en cours avec quantités et prix';

  @override
  String get deliveryNote => 'Bon de livraison';

  @override
  String get deliveryNoteSemantic => 'Bon de livraison';

  @override
  String get deliveryNoteHint =>
      'Ajoutez des instructions particulières pour la livraison';

  @override
  String get deliveryInstructionsHint =>
      'Saisissez des instructions particulières pour la livraison';

  @override
  String get discount => 'Remise';

  @override
  String get pleaseEnterValidNumber => 'Veuillez saisir un nombre valide';

  @override
  String get discountRangeError =>
      'La remise doit être comprise entre 0 et 100';

  @override
  String get digitalReceiptTitle => 'Reçu numérique';

  @override
  String get digitalReceiptSmsSubtitle =>
      'Envoyer le reçu par SMS au lieu d\'ouvrir un PDF';

  @override
  String receivedAmountInCurrency(String currency) {
    return 'Montant reçu en $currency';
  }

  @override
  String get receivedAmountHint => 'Saisissez le montant reçu du client';

  @override
  String get receivedAmount => 'Montant reçu';

  @override
  String get pleaseEnterReceivedAmount => 'Veuillez saisir le montant reçu';

  @override
  String get customerName => 'Nom du client';

  @override
  String get customerNameHint => 'Saisissez le nom complet du client';

  @override
  String get pleaseEnterCustomerName => 'Veuillez saisir le nom du client';

  @override
  String get customerPhoneNumber => 'Numéro de téléphone du client';

  @override
  String get customerPhoneNumberHint =>
      'Saisissez le numéro de téléphone du client pour le contact et la facturation';

  @override
  String get items => 'Articles';

  @override
  String get transactionId => 'ID de transaction';

  @override
  String get amountPaid => 'Montant payé';

  @override
  String get remainingBalance => 'Solde restant';

  @override
  String recordPaymentWithAmount(String amount) {
    return 'Enregistrer le paiement • $amount';
  }

  @override
  String payWithAmount(String amount) {
    return 'Payer • $amount';
  }

  @override
  String sendForReviewWithAmount(String amount) {
    return 'Envoyer pour révision • $amount';
  }

  @override
  String get phoneRequiredWhenTinMissing =>
      'Le numéro de téléphone est requis lorsque le TIN du client n\'est pas disponible';

  @override
  String get invalidNumber => 'Nombre invalide';

  @override
  String get back => 'Retour';

  @override
  String get managementDashboard => 'Tableau de bord de gestion';

  @override
  String get quickActions => 'Actions rapides';

  @override
  String get posDefault => 'PDV par défaut';

  @override
  String get setPosAsDefaultApp =>
      'Définir le PDV comme application par défaut';

  @override
  String get ordersDefault => 'Commandes par défaut';

  @override
  String get setOrdersAsDefaultApp =>
      'Définir Commandes comme application par défaut';

  @override
  String get accountManagement => 'Gestion des comptes';

  @override
  String get userManagement => 'Gestion des utilisateurs';

  @override
  String get manageUsersAndPermissions =>
      'Gérer les utilisateurs et les autorisations';

  @override
  String get branchManagement => 'Gestion des succursales';

  @override
  String get manageBranchLocations => 'Gérer les succursales (emplacements)';

  @override
  String get financialControls => 'Contrôles financiers';

  @override
  String get taxSettings => 'Paramètres fiscaux';

  @override
  String get configureTaxRulesAndRates =>
      'Configurer les règles et taux de taxe';

  @override
  String get ebmSettings => 'Paramètres EBM';

  @override
  String get electronicBillingMachineSettings =>
      'Paramètres de la machine de facturation électronique';

  @override
  String get smsConfiguration => 'Configuration SMS';

  @override
  String get enableSmsNotifications => 'Activer les notifications SMS';

  @override
  String get systemSettings => 'Paramètres système';

  @override
  String get debugMode => 'Mode débogage';

  @override
  String get enableDebugFeatures => 'Activer les fonctions de débogage';

  @override
  String get forceUpdate => 'Forcer la mise à jour';

  @override
  String get forceUpdateAllData =>
      'Forcer la mise à jour de toutes les données';

  @override
  String get taxService => 'Service fiscal';

  @override
  String get toggleTaxService => 'Activer/désactiver le service fiscal';

  @override
  String get savedDiscount => 'Remise enregistrée';

  @override
  String get createDiscount => 'Créer une remise';

  @override
  String get nameCannotBeNull => 'Le nom ne peut pas être vide';

  @override
  String get amountCannotBeNull => 'Le montant ne peut pas être vide';

  @override
  String get name => 'Nom';

  @override
  String saveTransactionTitle(String transactionType) {
    return 'Enregistrer la transaction $transactionType';
  }

  @override
  String get confirmSaveTransaction =>
      'Voulez-vous vraiment enregistrer cette transaction ?';

  @override
  String get categoryMustBeSelected => 'Une catégorie doit être sélectionnée';

  @override
  String get confirmLogout => 'Confirmer la déconnexion';

  @override
  String get confirmLogoutMessage => 'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get refundReason => 'Motif du remboursement';

  @override
  String get waitForApproval => 'En attente d\'approbation';

  @override
  String get approved => 'Approuvé';

  @override
  String get cancelRequested => 'Annulation demandée';

  @override
  String get canceled => 'Annulé';

  @override
  String get refunded => 'Remboursé';

  @override
  String get transferred => 'Transféré';

  @override
  String get appLanguage => 'Langue de l\'application';

  @override
  String get chooseAppLanguage => 'Choisissez la langue utilisée par Flipper';

  @override
  String get selectLanguage => 'Choisir la langue';

  @override
  String get languageAppliesEverywhere =>
      'S\'applique à tous les écrans de l\'application.';

  @override
  String get useDeviceLanguage => 'Utiliser la langue de l\'appareil';

  @override
  String get automatic => 'Automatique';

  @override
  String get french => 'Français';

  @override
  String get accountAndFinancial => 'Compte et finances';

  @override
  String get adminProfile => 'Profil administrateur';

  @override
  String get smsNotifications => 'Notifications SMS';

  @override
  String get close => 'Fermer';

  @override
  String get refresh => 'Actualiser';

  @override
  String get adminEmailHint => 'ex. admin@flipper.rw';

  @override
  String get displayName => 'Nom affiché';

  @override
  String get editName => 'Modifier le nom';

  @override
  String get paymentMethods => 'Moyens de paiement';

  @override
  String get managePaymentOptions => 'Gérer les options de paiement';

  @override
  String get enterPhoneNumber => 'Saisissez le numéro de téléphone';

  @override
  String get enableOrderNotifications =>
      'Activer les notifications de commande';

  @override
  String get receiveSmsNotificationsForOrders =>
      'Recevoir des notifications SMS pour les commandes';

  @override
  String get enableDebuggingFeatures => 'Activer les fonctions de débogage';

  @override
  String get ebm => 'EBM';

  @override
  String get reinitializeEbm => 'Réinitialiser l\'EBM';

  @override
  String get manageTaxServiceStatus => 'Gérer l\'état du service fiscal';

  @override
  String get hydrateData => 'Recharger les données';

  @override
  String get refreshAllLocalData => 'Actualiser toutes les données locales';

  @override
  String get assetDownload => 'Téléchargement des images';

  @override
  String get manageImageDownloads => 'Gérer le téléchargement des images';

  @override
  String get autoAddSearch => 'Ajout automatique';

  @override
  String get autoAddItemsWhenOneMatch =>
      'Ajouter automatiquement quand un seul résultat correspond';

  @override
  String get userLogging => 'Journalisation utilisateur';

  @override
  String get enableExtensiveUserLogging =>
      'Activer la journalisation détaillée des utilisateurs';

  @override
  String get priceQtyAdjustment => 'Ajust. prix-quantité';

  @override
  String get autoAdjustQtyOnPriceChange =>
      'Ajuster la quantité automatiquement au changement de prix';

  @override
  String get decimals => 'Décimales';

  @override
  String get enableFractionalPricing => 'Activer les prix fractionnaires';

  @override
  String get ticketReviewAndHandover => 'Révision et transfert de ticket';

  @override
  String get administratorPin => 'PIN administrateur';

  @override
  String get resetAdministratorPin => 'Réinitialiser le PIN administrateur';

  @override
  String get updateHighSecurityPin =>
      'Mettez à jour votre PIN de haute sécurité à 4 chiffres';

  @override
  String get flipperSettingsTitle => 'Paramètres Flipper';

  @override
  String get common => 'Général';

  @override
  String get environment => 'Environnement';

  @override
  String get local => 'Cet appareil';

  @override
  String get account => 'Compte';

  @override
  String get email => 'E-mail';

  @override
  String get security => 'Sécurité';

  @override
  String get sendDailyReport => 'Envoyer le rapport quotidien';

  @override
  String get onlinePrint => 'Impression en ligne';

  @override
  String get managePrintSettings => 'Gérer les paramètres d\'impression';

  @override
  String get enableExtensiveLogging => 'Activer la journalisation détaillée';

  @override
  String get backgroundSync => 'Synchronisation en arrière-plan';

  @override
  String get syncDataInBackground => 'Synchroniser les données en arrière-plan';

  @override
  String get closeShift => 'Clôturer le service';

  @override
  String get startNewShift => 'Démarrer un nouveau service';

  @override
  String get checkSubscription => 'Vérifier l\'abonnement';

  @override
  String couldNotCheckSubscription(String error) {
    return 'Impossible de vérifier l\'abonnement : $error';
  }

  @override
  String get chooseYourDefaultApp => 'Choisissez votre application par défaut';

  @override
  String get accountSettings => 'Paramètres du compte';

  @override
  String get switchAccount => 'Changer de compte';

  @override
  String continueToBranch(String branchName) {
    return 'Continuer vers $branchName';
  }

  @override
  String get openShift => 'Ouvrir le service';

  @override
  String get checkingPaymentStatus => 'Vérification du statut de paiement…';

  @override
  String get refreshAfterCustomerPays =>
      'Actualiser après le paiement du client';

  @override
  String get branch => 'succursale';

  @override
  String get totalItems => 'Total des articles';

  @override
  String get expiredItems => 'Articles périmés';

  @override
  String get lowStockItems => 'Articles en stock faible';

  @override
  String get pendingOrders => 'Commandes en attente';

  @override
  String get viewAll => 'Voir tout';

  @override
  String get idLabel => 'ID';

  @override
  String get item => 'Article';

  @override
  String get category => 'Catégorie';

  @override
  String get quantity => 'Quantité';

  @override
  String get location => 'Emplacement';

  @override
  String get expiredOn => 'Périmé le';

  @override
  String get actions => 'Actions';

  @override
  String get allExpiredItems => 'Tous les articles périmés';

  @override
  String get goHomeQuestion => 'Voulez-vous revenir à l\'accueil ?';

  @override
  String get searchProductsOrScan => 'Rechercher un produit ou scanner…';

  @override
  String get clear => 'Effacer';

  @override
  String get addProductAction => 'Ajouter un produit';

  @override
  String get help => 'Aide';

  @override
  String get customerManagement => 'Gestion des clients';

  @override
  String get searchCustomersByNameOrPhone =>
      'Rechercher un client par nom ou téléphone';

  @override
  String get clearSearch => 'Effacer la recherche';

  @override
  String get add => 'Ajouter';

  @override
  String get editCustomer => 'Modifier le client';

  @override
  String get deleteCustomer => 'Supprimer le client';

  @override
  String get customerActions => 'Actions client';

  @override
  String get phone => 'Téléphone';

  @override
  String get tin => 'TIN';

  @override
  String get invoice => 'Facture';

  @override
  String get txnId => 'ID transaction';

  @override
  String get addCustomer => 'Ajouter un client';
}
