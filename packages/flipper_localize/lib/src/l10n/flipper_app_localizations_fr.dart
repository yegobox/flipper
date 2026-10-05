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
  String plusMoreItems(int count) {
    return '+$count de plus';
  }

  @override
  String get actionCannotBeUndone => 'Cette action est irréversible.';

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
  String get enableWhatsappNotifications =>
      'Activer les notifications WhatsApp';

  @override
  String get receiveWhatsappNotificationsForOrders =>
      'Recevoir des notifications WhatsApp pour les commandes et les reçus PDF';

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

  @override
  String get sortDefault => 'Tri par défaut';

  @override
  String get sortByPopularity => 'Trier par popularité';

  @override
  String get sortByAverageRating => 'Trier par note moyenne';

  @override
  String get sortByLatest => 'Trier par plus récent';

  @override
  String get sortByPriceLowToHigh => 'Trier par prix : croissant';

  @override
  String get sortByPriceHighToLow => 'Trier par prix : décroissant';

  @override
  String get sortByStockOut => 'Trier par rupture de stock';

  @override
  String get sortByEventDateOldToNew => 'Trier par date : ancienne à récente';

  @override
  String get sortByEventDateNewToOld => 'Trier par date : récente à ancienne';

  @override
  String get sortCompactLatest => 'Récent';

  @override
  String get sortCompactDefault => 'Défaut';

  @override
  String get sortCompactPopular => 'Populaire';

  @override
  String get sortCompactRating => 'Note';

  @override
  String get sortCompactPrice => 'Prix';

  @override
  String get sortCompactStockOut => 'Rupture';

  @override
  String get sortCompactDate => 'Date';

  @override
  String get posStockFilterInStock => 'En stock';

  @override
  String get posStockFilterOutOfStock => 'En rupture de stock';

  @override
  String get posStockFilterAll => 'Tous les articles';

  @override
  String get posStockFilterNoneInStock => 'Aucun article en stock';

  @override
  String get posStockFilterNoneOutOfStock =>
      'Aucun article en rupture de stock';

  @override
  String get posStockFilterEmptyHint =>
      'Recherchez un article ou changez le filtre de stock.';

  @override
  String get posStockFilterShowAll => 'Afficher tous les articles';

  @override
  String showingRangeOfResults(String start, String end, String total) {
    return 'Affichage de $start–$end sur $total résultats';
  }

  @override
  String pageOfPages(String current, String total) {
    return 'Page $current sur $total';
  }

  @override
  String loadedOfProducts(String loaded, String total) {
    return '$loaded produits sur $total';
  }

  @override
  String get noProductsYet => 'Aucun produit pour le moment';

  @override
  String get noBranchSelected => 'Aucune succursale sélectionnée';

  @override
  String get productsRefreshedForNewBranch =>
      'Produits actualisés pour la nouvelle succursale';

  @override
  String deletedItemsCount(int count) {
    return '$count articles supprimés';
  }

  @override
  String inStockCount(String count) {
    return '$count en stock';
  }

  @override
  String leftInStockCount(String count) {
    return 'Il reste $count en stock';
  }

  @override
  String get stockLow => 'Faible';

  @override
  String get stockOutBadge => 'Épuisé';

  @override
  String get mode => 'Mode';

  @override
  String get sale => 'Vente';

  @override
  String get transfer => 'Transfert';

  @override
  String get searchCustomer => 'Rechercher un client';

  @override
  String get pay => 'Payer';

  @override
  String get noItemsYet => 'Aucun article pour le moment';

  @override
  String get tapProductToStartSale =>
      'Appuyez sur un produit pour démarrer une vente';

  @override
  String grandTotalWithItems(String itemLabel) {
    return 'Total général · $itemLabel';
  }

  @override
  String get defaultPrice => 'Prix par défaut';

  @override
  String pricePerUnitEach(String currency, String price) {
    return '$currency $price chacun';
  }

  @override
  String get deleteItem => 'Supprimer l\'article';

  @override
  String get editDetails => 'Modifier les détails';

  @override
  String get enterQuantity => 'Saisir la quantité';

  @override
  String get invalidQuantity => 'Quantité invalide';

  @override
  String get enterPrice => 'Saisir le prix';

  @override
  String get invalidPrice => 'Prix invalide';

  @override
  String get confirmDelete => 'Confirmer la suppression';

  @override
  String confirmRemoveNamedItem(String itemName) {
    return 'Voulez-vous vraiment retirer « $itemName » ?';
  }

  @override
  String errorDeletingItems(String error) {
    return 'Erreur lors de la suppression des articles : $error';
  }

  @override
  String errorDeletingItem(String error) {
    return 'Erreur lors de la suppression de l\'article : $error';
  }

  @override
  String get failedToDeleteItem => 'Échec de la suppression de l\'article';

  @override
  String get failedToUpdateItem => 'Échec de la mise à jour de l\'article';

  @override
  String skuLabel(String sku) {
    return 'SKU : $sku';
  }

  @override
  String bcdLabel(String barcode) {
    return 'BCD : $barcode';
  }

  @override
  String get split => 'Diviser';

  @override
  String get splitAcrossAnotherMethod =>
      'Diviser ce paiement sur un autre moyen';

  @override
  String get allPaymentTypesInUse =>
      'Tous les moyens de paiement sont utilisés — retirez-en un pour en ajouter un autre';

  @override
  String get allPaymentTypesAdded =>
      'Tous les moyens de paiement sont déjà ajoutés. Retirez-en un pour en ajouter un autre.';

  @override
  String get pleaseEnterAnAmount => 'Veuillez saisir un montant';

  @override
  String get cashReceived => 'Espèces reçues';

  @override
  String get amount => 'Montant';

  @override
  String get removeThisPayment => 'Retirer ce paiement';

  @override
  String get tapSplitToPayWithMoreThanOneMethod =>
      'Appuyez sur Diviser pour payer avec plusieurs moyens';

  @override
  String get tapSplitToAddMethod => 'Appuyez sur Diviser pour ajouter un moyen';

  @override
  String invoiceNumberValue(String number) {
    return 'N° $number';
  }

  @override
  String tenderedAmount(String amount) {
    return 'Remis $amount';
  }

  @override
  String paymentCollectedTotal(String total) {
    return 'Paiement encaissé · $total';
  }

  @override
  String get viewOnlyCannotTransferStock =>
      'Accès en lecture seule — vous ne pouvez pas transférer de stock.';

  @override
  String get selectDestinationBranch =>
      'Sélectionnez une succursale de destination';

  @override
  String get currentBranchIsMissing => 'La succursale actuelle est introuvable';

  @override
  String get addItemsBeforeTransferring =>
      'Ajoutez des articles avant de transférer';

  @override
  String transferredItemsToBranch(int count, String branch) {
    return '$count article(s) transféré(s) vers $branch';
  }

  @override
  String get transferFailed => 'Le transfert a échoué';

  @override
  String get failedToClearCart => 'Échec de la réinitialisation du panier';

  @override
  String get paymentsCollectedAtTill =>
      'Les paiements sont encaissés à la caisse. Envoyez cette commande dès qu\'elle est prête — un responsable encaissera.';

  @override
  String sentToTillTicket(String reference) {
    return 'Envoyé à la caisse — Ticket #$reference';
  }

  @override
  String failedToSendToTill(String error) {
    return 'Échec de l\'envoi à la caisse : $error';
  }

  @override
  String collectingPaymentForTicket(
    String reference,
    String name,
    String minutes,
  ) {
    return 'Encaissement de #$reference · envoyé par $name · il y a $minutes min';
  }

  @override
  String get returningEllipsis => 'Retour…';

  @override
  String get backToNewSale => 'Retour à une nouvelle vente';

  @override
  String get paymentCashCredit => 'Espèces / Crédit';

  @override
  String get paymentBankCheck => 'Chèque bancaire';

  @override
  String get paymentDebitCreditCard => 'Carte bancaire';

  @override
  String get paymentMobileMoney => 'Argent mobile';

  @override
  String get paymentMtnMomo => 'MTN MoMo';

  @override
  String get payerNameOptional => 'Nom du payeur (facultatif)';

  @override
  String get paidBy => 'Payé par';

  @override
  String get paymentAirtelMoney => 'Airtel Money';

  @override
  String get paymentOther => 'Autre';

  @override
  String get sendForReview => 'Envoyer pour révision';

  @override
  String get previewCart => 'Aperçu du panier';

  @override
  String previewCartWithCount(int count) {
    return 'Aperçu du panier ($count)';
  }

  @override
  String get placeOrder => 'Passer la commande';

  @override
  String confirmRemoveAllItemsCount(int count) {
    return 'Voulez-vous vraiment retirer les $count articles de cette transaction ?';
  }

  @override
  String get taxServerUnreachableStatus =>
      'Serveur fiscal RRA injoignable — les reçus ne peuvent pas être signés tant qu\'il ne revient pas. Nouvelle tentative automatique.';

  @override
  String get internetUnavailableStatus =>
      'Pas de connexion Internet — les ventes continuent hors ligne et se synchroniseront au retour du réseau.';

  @override
  String get includesVat => 'TVA comprise';

  @override
  String get chooseDefaultApp => 'Choisir l\'application par défaut';

  @override
  String get payShortcutHint => 'Ctrl / ⌘ + Entrée pour payer';

  @override
  String get receivedEyebrow => 'Reçu';

  @override
  String get cartEmptyHint =>
      'Appuyez sur un produit ou scannez un code-barres pour démarrer une vente';

  @override
  String get branchNotAvailable => 'Succursale indisponible';

  @override
  String get branchSelectBranch => 'Choisir une succursale';

  @override
  String get branchSwitchBranch => 'Changer de succursale';

  @override
  String get branchUnnamed => 'Succursale sans nom';

  @override
  String get compositeCost => 'Coût';

  @override
  String notificationsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count notifications',
      one: '1 notification',
    );
    return '$_temp0';
  }

  @override
  String get notificationsNew => 'Nouvelle notification';

  @override
  String get purchaseCodeErrorTryAgain =>
      'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get countryOfOriginSelect => 'Choisir le pays d\'origine';

  @override
  String get countryOfOriginLoadFailed => 'Échec du chargement des pays';

  @override
  String get orderStatusPending => 'En attente';

  @override
  String get menuChat => 'Discussion';

  @override
  String get backupConfiguration => 'Configuration de la sauvegarde';

  @override
  String get backupEnableAuto => 'Activer la sauvegarde automatique';

  @override
  String get dashDismiss => 'Ignorer';

  @override
  String get favoritesSetProduct => 'Définir un produit favori';

  @override
  String dashFieldRequired(String field) {
    return '$field est obligatoire';
  }

  @override
  String get supplierSelect => 'Choisir un fournisseur';

  @override
  String get searchProductsTransactionsHint =>
      'Rechercher des produits, des transactions...';

  @override
  String get compositeItem => 'Article composé';

  @override
  String get branchOrders => 'Commandes des succursales';

  @override
  String get rowsPerPage => 'Lignes par page';

  @override
  String get pleaseEnterANumber => 'Veuillez saisir un nombre';

  @override
  String get ordersNoOrders => 'Aucune commande';

  @override
  String get ordersNoneAtTheMoment =>
      'Vous n\'avez aucune commande pour le moment.';

  @override
  String get ordersIncomingWillAppear =>
      'Les commandes entrantes apparaîtront ici !';

  @override
  String get productTypeSelect => 'Choisir le type de produit';

  @override
  String get productTypeRawMaterial => 'Matière première';

  @override
  String get productTypeFinishedProduct => 'Produit fini';

  @override
  String get productTypeServiceWithoutStock => 'Service sans stock';

  @override
  String get compositeSkuRequired => 'Le SKU est obligatoire';

  @override
  String get compositeBarcodeRequired => 'Le code-barres est obligatoire';

  @override
  String get compositeBarcode => 'Code-barres';

  @override
  String get tenantRefreshUserList => 'Actualiser la liste des utilisateurs';

  @override
  String get categorySearchHint => 'Rechercher des catégories...';

  @override
  String get categoryNoneFound => 'Aucune catégorie trouvée';

  @override
  String get categoryAdd => 'Ajouter une catégorie';

  @override
  String get stockLevel => 'Niveau de stock';

  @override
  String get stockCurrentValue => 'Valeur actuelle du stock';

  @override
  String get dateSelect => 'Choisir une date';

  @override
  String get dateReportPeriod => 'PÉRIODE DU RAPPORT';

  @override
  String get dateApply => 'Appliquer';

  @override
  String get dateApplyingRange => 'Application de la période…';

  @override
  String get posCompleteNow => 'Terminer maintenant';

  @override
  String get downloadExcelSpreadsheet => 'Feuille de calcul Excel';

  @override
  String get downloadDownloaded => 'Téléchargé';

  @override
  String downloadProgress(String percent) {
    return 'Téléchargement : $percent %';
  }

  @override
  String downloadSavedTo(String path) {
    return 'Téléchargé dans : $path';
  }

  @override
  String get downloadClickToDownload => 'Cliquez pour télécharger';

  @override
  String get orderingLoadingProducts => 'Chargement des produits...';

  @override
  String get searchProductHint => 'Rechercher';

  @override
  String get searchProductAllProducts => 'Tous les produits';

  @override
  String get searchProductFavorites => 'Favoris';

  @override
  String get refundReasonCustomerRequest => 'Demande du client';

  @override
  String get refundReasonWrongItem => 'Mauvais article';

  @override
  String get refundReasonDamaged => 'Endommagé / défectueux';

  @override
  String get refundReasonDuplicateCharge => 'Double facturation';

  @override
  String get taxSettingsUpdated => 'Paramètres fiscaux mis à jour avec succès';

  @override
  String get taxSettingsUpdateError =>
      'Erreur lors de la mise à jour des paramètres fiscaux';

  @override
  String taxSettingsTaxType(String taxType) {
    return 'Taxe $taxType';
  }

  @override
  String get taxSettingsRequired => 'Obligatoire';

  @override
  String get taxSettingsRange => 'Doit être entre 0 et 100';

  @override
  String get taxSettingsNoneFound => 'Aucune configuration fiscale trouvée';

  @override
  String get cartQtySuffix => 'qté';

  @override
  String cartPriceQtyEquivalent(String qty, String unitPrice) {
    return 'Équivaut à $qty unités à $unitPrice RWF';
  }

  @override
  String get addProductSingleTitle => 'Produit unique';

  @override
  String get addProductSingleSubtitle => 'Ajouter et configurer un article';

  @override
  String get addProductBadgeQuick => 'RAPIDE';

  @override
  String get addProductBulkTitle => 'Ajout groupé';

  @override
  String get addProductBulkSubtitle => 'Importer plusieurs produits à la fois';

  @override
  String get addProductBadgeFast => 'EXPRESS';

  @override
  String get addProductRoomsTitle => 'Ajouter des chambres';

  @override
  String get addProductRoomsSubtitle => 'Hôtel et hébergement';

  @override
  String get addProductBadgeHotel => 'HÔTEL';

  @override
  String get addProductFuelTitle => 'Synchroniser le carburant';

  @override
  String get addProductFuelSubtitle => 'Diesel et essence depuis la RRA';

  @override
  String get addProductBadgeFuel => 'CARBURANT';

  @override
  String get addProductChooseHow => 'Choisissez comment ajouter';

  @override
  String scanNoVariantsFor(String query) {
    return 'Aucune variante trouvée pour « $query »';
  }

  @override
  String scanErrorSearching(String error) {
    return 'Erreur lors de la recherche des variantes : $error';
  }

  @override
  String get scanNoVariantsAvailable => 'Aucune variante disponible';

  @override
  String get scanSelectVariant => 'Choisir une variante du produit';

  @override
  String get scanSearchByNameOrBarcode => 'Rechercher par nom ou code-barres';

  @override
  String get scanNoMatchingVariants => 'Aucune variante correspondante';

  @override
  String scanRetailPrice(String price) {
    return 'Prix de vente : $price';
  }

  @override
  String scanBarcode(String barcode) {
    return 'Code-barres : $barcode';
  }

  @override
  String scanErrorShowing(String error) {
    return 'Erreur lors de l\'affichage des variantes : $error';
  }

  @override
  String get productCreate => 'Créer un produit';

  @override
  String get productLabel => 'Produit';

  @override
  String get productNameHint => 'Nom du produit';

  @override
  String get productPriceAndInventory => 'PRIX ET STOCK';

  @override
  String get productExpiryDate => 'Date d\'expiration';

  @override
  String productExpiresAt(String date) {
    return 'Expire le $date';
  }

  @override
  String get productAddVariation => 'Ajouter une variante';

  @override
  String get productProvideName => 'Indiquez le nom du produit';

  @override
  String get productUnsavedDiscard =>
      'Vous avez un produit non enregistré. Voulez-vous l\'abandonner ?';

  @override
  String get variantsTax => 'Taxe';

  @override
  String get variantsUnit => 'Unité';

  @override
  String get variantsClassification => 'Classification';

  @override
  String get variantsExpiration => 'Expiration';

  @override
  String get variantsAction => 'Action';

  @override
  String get checkoutNoCustomer => 'Aucun client';

  @override
  String get checkoutWalkIn => 'Client de passage';

  @override
  String get checkoutTotal => 'Total';

  @override
  String get checkoutReviewAndPay => 'Vérifier et payer';

  @override
  String get checkoutReviewAndSend => 'Vérifier et envoyer';

  @override
  String get checkoutCouldNotOpen =>
      'Impossible d\'ouvrir le paiement pour ce panier. Veuillez réessayer.';

  @override
  String get checkoutScan => 'Scanner';

  @override
  String get checkoutItemsNotAvailable => 'Articles indisponibles';

  @override
  String checkoutErrorLoadingItemsDetail(String error) {
    return 'Erreur lors du chargement des articles : $error';
  }

  @override
  String get checkoutErrorLoadingItems =>
      'Erreur lors du chargement des articles';

  @override
  String get checkoutStatusOpen => 'Ouvert';

  @override
  String get checkoutStatusCompleted => 'Terminé';

  @override
  String get reportsBusinessAnalytics => 'Analyses de l\'entreprise';

  @override
  String get reportsStockValue => 'Valeur du stock';

  @override
  String get reportsTotalSales => 'Ventes totales';

  @override
  String get reportsProfit => 'Bénéfice';

  @override
  String get reportsLoading => 'Chargement...';

  @override
  String get reportsStockPerformance => 'Performance du stock';

  @override
  String get reportsErrorLoadingChart =>
      'Erreur lors du chargement du graphique';

  @override
  String get reportsInsufficientData =>
      'Données insuffisantes pour le graphique';

  @override
  String get reportsDetailedMetrics => 'Indicateurs détaillés';

  @override
  String get reportsErrorLoadingMetrics =>
      'Erreur lors du chargement des indicateurs';

  @override
  String get branchesTitle => 'Succursales';

  @override
  String get branchesAddNew => 'Ajouter une succursale';

  @override
  String get branchesName => 'Nom de la succursale';

  @override
  String get branchesNameHint => 'Saisissez le nom de la succursale';

  @override
  String get branchesLocationHint =>
      'Saisissez l\'emplacement de la succursale';

  @override
  String get branchesCreate => 'Créer la succursale';

  @override
  String get branchesAll => 'Toutes les succursales';

  @override
  String get branchesLoadFailed => 'Impossible de charger les succursales';

  @override
  String get branchesNoneFound => 'Aucune succursale trouvée';

  @override
  String get dashUnknown => 'Inconnu';

  @override
  String get branchesDefaultBadge => 'Par défaut';

  @override
  String get branchesActiveBadge => 'Active';

  @override
  String get branchesDelete => 'Supprimer la succursale';

  @override
  String get branchesDefaultCannotDelete =>
      'La succursale par défaut ne peut pas être supprimée';

  @override
  String get branchesKeepOne => 'Vous devez conserver au moins une succursale';

  @override
  String branchesDeleteConfirm(String name) {
    return 'Voulez-vous vraiment supprimer $name ?';
  }

  @override
  String get branchesDeleteFailed => 'Impossible de supprimer la succursale';

  @override
  String get branchesAddError => 'Erreur lors de l\'ajout de la succursale';

  @override
  String get branchesNameRequired => 'Le nom de la succursale est obligatoire';

  @override
  String get branchesLocationRequired => 'L\'emplacement est obligatoire';

  @override
  String get roomAdd => 'Ajouter une chambre';

  @override
  String get roomNumber => 'N° de chambre';

  @override
  String get roomType => 'Type de chambre';

  @override
  String get roomSelect => 'Choisir';

  @override
  String get roomSelectTypeError => 'Veuillez choisir un type de chambre';

  @override
  String get roomPricePerNight => 'Prix par nuit';

  @override
  String get roomTaxCode => 'Code de taxe';

  @override
  String get roomSelectTaxCodeError => 'Veuillez choisir un code de taxe';

  @override
  String get roomTaxExemptShort => 'Exonéré';

  @override
  String get roomTaxStandardRate => 'Taux normal';

  @override
  String get roomTaxReducedRate => 'Taux réduit';

  @override
  String get roomTaxNonVat => 'Hors TVA';

  @override
  String get roomTaxExempt => 'Exonéré de taxe';

  @override
  String get roomTaxExemptHint => 'Exonérer cette chambre de TVA';

  @override
  String get roomAddedSuccess => 'Chambre ajoutée avec succès';

  @override
  String roomAddError(String error) {
    return 'Erreur lors de l\'ajout de la chambre : $error';
  }

  @override
  String get roomTypeSingle => 'Simple';

  @override
  String get roomTypeDouble => 'Double';

  @override
  String get roomTypeSuite => 'Suite';

  @override
  String get roomTypeDeluxe => 'Deluxe';

  @override
  String get branchSwitchedRefreshing =>
      'Succursale changée. Actualisation des données...';

  @override
  String get branchDefault => 'Succursale par défaut';

  @override
  String get branchLoggingOut => 'Déconnexion en cours...';

  @override
  String branchSwitchedTo(String branch) {
    return 'Passage à $branch effectué';
  }

  @override
  String branchSwitchingTo(String branch) {
    return 'Passage à $branch…';
  }

  @override
  String get branchSwitchTitle => 'Changer de succursale';

  @override
  String get branchActive => 'Succursale active';

  @override
  String get branchLoading => 'Chargement des succursales…';

  @override
  String get branchNoneAvailable => 'Aucune succursale disponible';

  @override
  String get branchSearchHint => 'Rechercher des succursales…';

  @override
  String get gaugeIncorrectWidgetType => 'Type de widget incorrect';

  @override
  String get gaugeFinancialOverview => 'Aperçu financier';

  @override
  String get gaugeReadyToTrack => 'Prêt à commencer le suivi !';

  @override
  String get gaugeTransactionsWillAppear =>
      'Vos transactions apparaîtront ici dès que vous commencerez à en ajouter.';

  @override
  String gaugeNoRecordsFor(String period) {
    return 'Aucun enregistrement pour $period';
  }

  @override
  String get gaugeTryDifferentPeriod =>
      'Essayez une autre période ou ajoutez des transactions.';

  @override
  String get gaugeRecentTransactions => 'Transactions récentes';

  @override
  String get gaugeLast30Days => '30 derniers jours';

  @override
  String get gaugeWaitingMomo => 'EN ATTENTE MOMO';

  @override
  String get gaugeLoadingTransactions => 'Chargement des transactions...';

  @override
  String get gaugeSomethingWentWrong => 'Une erreur s\'est produite';

  @override
  String get gaugePeriodToday => 'Aujourd\'hui';

  @override
  String get gaugePeriodThisWeek => 'Cette semaine';

  @override
  String get gaugePeriodThisMonth => 'Ce mois-ci';

  @override
  String get gaugePeriodThisYear => 'Cette année';

  @override
  String get deliveryDriverAppTitle => 'Application livreur';

  @override
  String get deliveryOnline => 'En ligne';

  @override
  String get deliveryOffline => 'Hors ligne';

  @override
  String get deliveryCurrentPickup => 'Retrait en cours';

  @override
  String get deliveryConfirmPickup => 'Confirmer le retrait';

  @override
  String get deliveryUpcoming => 'Livraisons à venir';

  @override
  String deliveryOrderNumber(String id) {
    return 'Commande n° $id';
  }

  @override
  String deliveryPickupLine(String place) {
    return 'Retrait : $place';
  }

  @override
  String deliveryDeliverTo(String name) {
    return 'Livrer à : $name';
  }

  @override
  String get deliveryYouAreOffline => 'Vous êtes hors ligne';

  @override
  String get deliveryGoOnline => 'Passez en ligne pour recevoir des livraisons';

  @override
  String get sideMenuOverview => 'Vue d\'ensemble';

  @override
  String get sideMenuAuthenticator => 'Authentificateur';

  @override
  String get sideMenuKitchenDisplay => 'Écran cuisine';

  @override
  String get sideMenuStockRecount => 'Recomptage du stock';

  @override
  String get sideMenuDelegations => 'Délégations';

  @override
  String get sideMenuIncomingOrders => 'Commandes entrantes';

  @override
  String get sideMenuTransfersReport => 'Rapport des transferts';

  @override
  String get sideMenuProductionOutput => 'Production réalisée';

  @override
  String get sideMenuTransactions => 'Transactions';

  @override
  String get sideMenuAnalytics => 'Analyses';

  @override
  String get sideMenuShiftHistory => 'Historique des services';

  @override
  String get sideMenuAgentCommission => 'Commission de l\'agent';

  @override
  String get sideMenuEndShift => 'Terminer le service';

  @override
  String get ipmPageErrorLoading => 'Erreur lors du chargement des données';

  @override
  String get ipmPageNoImports => 'Aucun article importé';

  @override
  String get ipmPageNoImportsHint =>
      'Synchronisez avec la RRA pour récupérer les nouveaux articles importés.';

  @override
  String get ipmPageNoPurchases => 'Aucune facture d\'achat';

  @override
  String get ipmPageNoPurchasesHint =>
      'Synchronisez avec la RRA ou enregistrez un achat manuellement.';

  @override
  String get ipmPageRetrySucceeded => 'Nouvelle tentative réussie';

  @override
  String ipmPageRetryFailed(String error) {
    return 'Échec de la nouvelle tentative : $error';
  }

  @override
  String get ipmPageMissingPricing =>
      'Il manque les prix requis pour l\'un des articles à approuver';

  @override
  String ipmPageApprovedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles approuvés',
      one: '1 article approuvé',
    );
    return '$_temp0';
  }

  @override
  String ipmPageApproveItemsFailed(String error) {
    return 'Impossible d\'approuver les articles : $error';
  }

  @override
  String get ipmPageSetBothPrices =>
      'Veuillez définir le prix de vente et le prix d\'achat';

  @override
  String ipmPageApprovedItem(String name) {
    return '« $name » approuvé';
  }

  @override
  String ipmPageApproveItemFailed(String error) {
    return 'Impossible d\'approuver l\'article : $error';
  }

  @override
  String ipmPageRejectedItem(String name) {
    return '« $name » rejeté';
  }

  @override
  String ipmPageRejectItemFailed(String error) {
    return 'Impossible de rejeter l\'article : $error';
  }

  @override
  String get importsColNo => 'N°';

  @override
  String get importsColItemName => 'Nom de l\'article';

  @override
  String get importsColHsCode => 'Code SH';

  @override
  String get importsColRetailPrice => 'Prix de vente';

  @override
  String get importsColSupplyPrice => 'Prix d\'achat';

  @override
  String get importsColStatus => 'Statut';

  @override
  String get importsColSupplier => 'Fournisseur';

  @override
  String get importsColDate => 'Date';

  @override
  String get importsWait => 'En attente';

  @override
  String get importsRejected => 'Rejeté';

  @override
  String get importsApprove => 'Approuver';

  @override
  String get importsReject => 'Rejeter';

  @override
  String importsApproveError(String error) {
    return 'Erreur lors de l\'approbation de l\'article : $error';
  }

  @override
  String importsRejectError(String error) {
    return 'Erreur lors du rejet de l\'article : $error';
  }

  @override
  String get importsNoData =>
      'Aucune donnée trouvée ou erreur réseau, veuillez réessayer.';

  @override
  String get importsNoMatches => 'Aucun résultat pour le filtre sélectionné.';

  @override
  String get refundUnavailable => 'Remboursement indisponible';

  @override
  String refundWithAmount(String amount) {
    return 'Rembourser $amount';
  }

  @override
  String get refundReceiptCannotBeRefunded =>
      'Ce reçu ne peut pas être remboursé';

  @override
  String get refundNoCopyToPrint => 'Ce reçu n\'a pas de copie à imprimer';

  @override
  String get refundTransactionTitle => 'Transaction';

  @override
  String get refundCopied => 'Copié';

  @override
  String get refundPayerDiffers => 'différent du client';

  @override
  String get refundTaxIncluded => 'Taxe incluse';

  @override
  String get refundAmountLabel => 'Montant remboursé';

  @override
  String get refundPrintCopy => 'Imprimer une copie du reçu';

  @override
  String get refundStatusPartiallyRefunded => 'Partiellement remboursé';

  @override
  String get refundStatusParked => 'En attente';

  @override
  String refundSaleSubtitle(String payment) {
    return 'Vente $payment';
  }

  @override
  String get refundPaymentCard => 'Carte';

  @override
  String get ebmNoActiveBranch => 'Aucune succursale active trouvée';

  @override
  String get ebmTinRequired => 'Le TIN est obligatoire';

  @override
  String get ebmBhfIdRequired => 'Le BHF ID est obligatoire';

  @override
  String get ebmDeviceSerial => 'Numéro de série de l\'appareil';

  @override
  String get ebmDeviceSerialRequired =>
      'Le numéro de série de l\'appareil est obligatoire';

  @override
  String get ebmProcessing => 'Traitement...';

  @override
  String get ebmReinitialize => 'Réinitialiser';

  @override
  String ebmInitFailed(String error) {
    return 'Échec de l\'initialisation de l\'EBM : $error';
  }

  @override
  String get ebmInitSuccess => 'EBM initialisé avec succès';

  @override
  String get ebmTaxpayerName => 'Nom du contribuable';

  @override
  String get searchCustomerType => 'Type de client';

  @override
  String get searchSaleType => 'Type de vente';

  @override
  String get searchAssignAgent => 'Attribuer un agent';

  @override
  String get searchAgent => 'Agent';

  @override
  String get searchCustomerTypeShop => 'Boutique';

  @override
  String get searchSaleTypeOutgoing => 'Vente sortante';

  @override
  String get searchSaleTypeAgent => 'Vente par agent';

  @override
  String get fuelSelectBranchFirst =>
      'Choisissez une succursale avant de synchroniser le carburant.';

  @override
  String get fuelBusinessMissing =>
      'Les informations de l\'entreprise sont manquantes.';

  @override
  String get fuelVatRequired =>
      'La TVA / l\'EBM doit être activée pour synchroniser les carburants réglementés.';

  @override
  String get fuelContactingConnector => 'Connexion au data-connector…';

  @override
  String get fuelFetchingCatalog =>
      'Récupération du catalogue carburant depuis la RRA…';

  @override
  String get fuelWaitingForSync => 'En attente de la synchronisation Ditto…';

  @override
  String fuelVariantsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count variantes',
      one: '1 variante',
    );
    return '$_temp0';
  }

  @override
  String get fuelSyncExplanation =>
      'Importe les carburants réglementés depuis la RRA. L\'enregistrement manuel du carburant n\'est pas autorisé — utilisez plutôt cette synchronisation.';

  @override
  String get fuelProductName => 'Nom du produit';

  @override
  String get fuelProductNameRequired => 'Le nom du produit est obligatoire';

  @override
  String get fuelEnableVat =>
      'Activez la TVA sur cette succursale avant de synchroniser le carburant.';

  @override
  String get fuelSyncing => 'Synchronisation…';

  @override
  String get fuelSyncFromRra => 'Synchroniser depuis la RRA';

  @override
  String get editQtyCannotBeNegative => 'La quantité ne peut pas être négative';

  @override
  String editQtyRraFloor(String floor) {
    return 'Le stock déclaré à la RRA ne peut qu\'être augmenté ici. Utilisez un ajustement de stock pour descendre sous $floor.';
  }

  @override
  String get editQtyServiceNotice =>
      'Les services n\'ont pas de stock. L\'enregistrement maintient cette variante à 0.';

  @override
  String editQtyCannotGoBelow(String floor) {
    return 'Impossible de descendre sous $floor';
  }

  @override
  String editQtyAdds(String qty) {
    return 'Ajoute $qty au stock actuel.';
  }

  @override
  String editQtyRemoves(String qty) {
    return 'Retire $qty du stock actuel.';
  }

  @override
  String editQtyStays(String qty) {
    return 'Le stock reste à $qty.';
  }

  @override
  String get editQtyGotIt => 'Compris';

  @override
  String get editQtyUpdateStock => 'Mettre à jour le stock';

  @override
  String get editQtyTitle => 'Modifier la quantité';

  @override
  String editQtyOnHand(String qty) {
    return 'En stock $qty';
  }

  @override
  String get creditHubTitle => 'Centre de crédits';

  @override
  String get creditHubAddCredits => 'Ajouter des crédits';

  @override
  String get creditHubUseCredits => 'Utiliser des crédits';

  @override
  String creditHubUseAmount(int amount) {
    return 'Utiliser $amount';
  }

  @override
  String get creditHubAvailable => 'Crédits disponibles';

  @override
  String get creditHubCredits => 'Crédits';

  @override
  String get creditHubQuickAdd => 'Ajout rapide';

  @override
  String get creditHubEnterAmount => 'Saisissez le montant';

  @override
  String creditHubUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count crédits utilisés',
      one: '1 crédit utilisé',
    );
    return '$_temp0';
  }

  @override
  String creditHubAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count crédits ajoutés avec succès',
      one: '1 crédit ajouté avec succès',
    );
    return '$_temp0';
  }

  @override
  String get creditHubInvalidAmount => 'Veuillez saisir un montant valide';

  @override
  String creditHubMaximum(int max) {
    return 'Maximum : $max';
  }

  @override
  String get customerFormNewBusiness => 'Nouvelle entreprise';

  @override
  String get customerFormNewCustomer => 'Nouveau client';

  @override
  String get customerFormNoPhone => 'Pas encore de téléphone';

  @override
  String get customerFormType => 'Type de client';

  @override
  String get customerFormBusinessName => 'Nom de l\'entreprise';

  @override
  String get customerFormFullName => 'Nom complet';

  @override
  String get customerFormBusinessNameHint => 'ex. Kigali Traders Ltd';

  @override
  String get customerFormFullNameHint => 'ex. Jean Mukamana';

  @override
  String get customerFormEmail => 'Adresse e-mail';

  @override
  String get customerFormTinHint => 'Numéro fiscal pour les factures';

  @override
  String get customerFormUpdated => 'Client mis à jour avec succès !';

  @override
  String get customerFormAddedAttached => 'Client ajouté et associé';

  @override
  String get customerFormAddFailed => 'Échec de l\'ajout du client';

  @override
  String get customerFormSaveChanges => 'Enregistrer les modifications';

  @override
  String get customerFormAddAttach => 'Ajouter et associer le client';

  @override
  String get customerFormOptional => 'facultatif';

  @override
  String get customerFormIndividual => 'Particulier';

  @override
  String get backupNow => 'Sauvegarder maintenant';

  @override
  String get backupCreated => 'Sauvegarde créée';

  @override
  String get syncTitle => 'Synchronisation';

  @override
  String get syncEnable => 'Activer la synchronisation';

  @override
  String get qrCode => 'Code QR';

  @override
  String get qrMode => 'Mode QR';

  @override
  String get qrModeEnable => 'Activer le mode QR';

  @override
  String get qrModeEmailNotGmail =>
      'L\'e-mail ajouté n\'est pas une adresse Gmail';

  @override
  String get appChoicePosSubtitle => 'Vendre et encaisser';

  @override
  String get appChoiceBooks => 'Comptabilité';

  @override
  String get appChoiceBooksSubtitle => 'Comptabilité et grands livres';

  @override
  String get appChoiceInventorySubtitle => 'Stock et produits';

  @override
  String get appChoiceReportsSubtitle => 'Analyses des ventes et des taxes';

  @override
  String get appChoiceOrders => 'Commandes';

  @override
  String get appChoiceOrdersSubtitle => 'Achats et transferts';

  @override
  String get appChoiceCustomersSubtitle => 'Contacts et crédit';

  @override
  String get appChoiceSettingsSubtitle => 'Appareils, taxes et personnel';

  @override
  String get appChoiceTitle => 'Choisissez votre application';

  @override
  String get appChoiceSubtitle =>
      'Choisissez par où commencer. Vous pouvez changer d\'application à tout moment.';

  @override
  String get appChoiceKeyboardHint =>
      'Appuyez sur 1–7 pour ouvrir, les flèches pour vous déplacer, Échap pour fermer';

  @override
  String get posBalanceDue => 'Solde dû';

  @override
  String get posChange => 'Monnaie';

  @override
  String posTillTicketName(String reference) {
    return 'Caisse · $reference';
  }

  @override
  String get posSentToTillNote => 'Envoyé à la caisse pour paiement';

  @override
  String get posReturnToTillFailed =>
      'Impossible de renvoyer ce ticket à la caisse. Veuillez réessayer.';

  @override
  String cashbookPersonalGoalNote(String goal) {
    return 'Objectif personnel : $goal';
  }

  @override
  String get cashbookTitle => 'Livre de caisse';

  @override
  String get cashbookRecentTransactions => 'Transactions récentes';

  @override
  String get cashbookFilterAll => 'Tout';

  @override
  String get cashbookCashIn => 'Entrée';

  @override
  String get cashbookCashOut => 'Sortie';

  @override
  String get cashbookTotalOut => 'Total des sorties';

  @override
  String get cashbookMomoNet => 'Solde net MoMo';

  @override
  String get cashbookTotalIn => 'Total des entrées';

  @override
  String cashbookNoCashInFor(String period) {
    return 'Aucune entrée pour $period.';
  }

  @override
  String cashbookNoCashOutFor(String period) {
    return 'Aucune sortie pour $period.';
  }

  @override
  String cashbookNoMomoFor(String period) {
    return 'Aucune transaction MoMo pour $period.';
  }

  @override
  String cashbookNoTransactionsFor(String period) {
    return 'Aucune transaction pour $period.';
  }

  @override
  String get cashbookReceivedAs => 'Reçu en';

  @override
  String get cashbookPaidWith => 'Payé par';

  @override
  String get cashbookCashInFor => 'Motif de l\'entrée (facultatif)';

  @override
  String get cashbookCashOutFor => 'Motif de la sortie (facultatif)';

  @override
  String get cashbookNote => 'Note';

  @override
  String get cashbookOptionalNoteHint => 'Note facultative...';

  @override
  String get cashbookMoneyIn => 'Argent entrant';

  @override
  String get cashbookMoneyOut => 'Argent sortant';

  @override
  String get cashbookAmountPositive => 'Le montant doit être supérieur à zéro';

  @override
  String get cashbookNewCategory => 'Nouvelle';

  @override
  String cashbookCategoriesError(String error) {
    return 'Erreur des catégories : $error';
  }

  @override
  String get cashbookSaveEntry => 'Enregistrer l\'écriture';

  @override
  String get cashbookCashInSaved => 'Entrée enregistrée avec succès';

  @override
  String get cashbookCashOutSaved => 'Sortie enregistrée avec succès';

  @override
  String get variantsSelectAll => 'Tout sélectionner';

  @override
  String get variantsVariant => 'Variante';

  @override
  String get variantsNoDiscount => 'Aucune remise';

  @override
  String variantsPercentOff(String percent) {
    return '-$percent %';
  }

  @override
  String variantsExpires(String date) {
    return 'Expire le $date';
  }

  @override
  String get variantsNoExpiry => 'Pas de date d\'expiration';

  @override
  String get variantsLowStock => 'Stock bas';

  @override
  String get variantsDiscountPercent => 'Remise %';

  @override
  String get variantsRraItemClass => 'Classe d\'article RRA';

  @override
  String get variantsSetDate => 'Définir la date';

  @override
  String variantsPriceLine(String price) {
    return 'Prix : $price';
  }

  @override
  String get variantsReorderAt => 'Recommander à';

  @override
  String get variantsImage => 'Image';

  @override
  String get variantsDeleteAllSemantic => 'Supprimer toutes les variantes';

  @override
  String get variantsHideMoreDetails => 'Masquer taxe, unité et expiration';

  @override
  String get variantsMoreDetails => 'Taxe, unité et expiration';

  @override
  String get refundProformaNotRefundable =>
      'Impossible de rembourser une facture proforma';

  @override
  String get adminPhoneWithCountryCode =>
      'Saisissez un numéro de téléphone valide avec l\'indicatif du pays (ex. +250783054874).';

  @override
  String get adminSmsConfigFailed =>
      'Échec de la mise à jour de la configuration SMS';

  @override
  String get adminWhatsappChannel => 'Canal WhatsApp';

  @override
  String get adminWhatsappChannelHint =>
      'Choisissez comment envoyer les reçus numériques et les notifications de commande.';

  @override
  String get adminOpenWaSubtitle =>
      'Session WhatsApp locale / auto-hébergée (canal 1)';

  @override
  String get adminMetaSubtitle =>
      'WhatsApp officiel de Meta (canal 2). Les clients devront peut-être scanner un QR pour accepter avant l\'envoi des reçus.';

  @override
  String get adminUserFallback => 'Utilisateur';

  @override
  String get adminEnterDisplayName => 'Saisissez un nom d\'affichage.';

  @override
  String get adminNotSignedIn => 'Non connecté.';

  @override
  String get adminMissingLoginKey => 'Clé de connexion du compte manquante.';

  @override
  String get adminNameUpdated => 'Nom mis à jour.';

  @override
  String adminSaveNameFailed(String error) {
    return 'Impossible d\'enregistrer le nom : $error';
  }

  @override
  String get adminPhoneSetOnce =>
      'Le numéro de téléphone ne peut être défini qu\'une fois. Contactez le support pour le modifier.';

  @override
  String get adminPhoneSaved => 'Numéro de téléphone enregistré.';

  @override
  String adminSavePhoneFailed(String error) {
    return 'Impossible d\'enregistrer le téléphone : $error';
  }

  @override
  String get adminEmailAlreadySet =>
      'L\'e-mail est déjà défini et ne peut pas être modifié ici.';

  @override
  String get adminInvalidEmail => 'Veuillez saisir une adresse e-mail valide.';

  @override
  String get adminEmailSavedBusinessFailed =>
      'E-mail enregistré sur votre compte. Les paramètres de l\'entreprise n\'ont pas pu être mis à jour.';

  @override
  String get adminEmailUpdated => 'E-mail mis à jour.';

  @override
  String adminSaveEmailFailed(String error) {
    return 'Impossible d\'enregistrer l\'e-mail : $error';
  }

  @override
  String get adminLogoUpdated => 'Logo du reçu mis à jour.';

  @override
  String adminLogoUpdateFailed(String error) {
    return 'Échec de la mise à jour du logo : $error';
  }

  @override
  String get adminLogoRemoved =>
      'Logo du reçu supprimé. Le logo par défaut sera utilisé.';

  @override
  String adminLogoRemoveFailed(String error) {
    return 'Échec de la suppression du logo : $error';
  }

  @override
  String get adminBadge => 'ADMIN';

  @override
  String get adminNoPhoneOnAccount => 'Aucun téléphone sur le compte';

  @override
  String get adminAddPhone => 'Ajouter un téléphone';

  @override
  String get adminNoEmailSet => 'Aucun e-mail défini';

  @override
  String get adminAddEmail => 'Ajouter un e-mail';

  @override
  String get adminSmsPhoneNumber => 'Numéro de téléphone SMS';

  @override
  String get adminSmsPhoneHint =>
      'Numéro de téléphone avec l\'indicatif du pays (ex. +250783054874)';

  @override
  String get adminDefaultWhatsappChannel => 'Canal WhatsApp par défaut';

  @override
  String get adminGroupSalesPricing => 'Ventes et prix';

  @override
  String get adminGroupWorkflow => 'Flux de travail';

  @override
  String get adminTicketReviewSubtitle =>
      'Exiger la validation d\'un réviseur et la remise par le gestionnaire de stock avant qu\'un ticket payé soit finalisé';

  @override
  String get adminGroupTaxCompliance => 'Taxes et conformité';

  @override
  String get adminGroupDataSync => 'Données et synchronisation';

  @override
  String get adminGroupDiagnostics => 'Diagnostics';

  @override
  String get adminCrossDeviceFeatures => 'Fonctions multi-appareils';

  @override
  String get adminReceiptBranding => 'Personnalisation du reçu';

  @override
  String get adminReceiptLogo => 'Logo du reçu';

  @override
  String get adminReceiptLogoHint =>
      'Téléversez un PNG transparent ou un JPG de moins de 200 Ko. Le logo apparaît au centre des reçus imprimés ; le logo par défaut est utilisé si aucun n\'est fourni.';

  @override
  String get adminUploading => 'Téléversement...';

  @override
  String get adminUploadLogo => 'Téléverser le logo';

  @override
  String get adminRemoveLogo => 'Supprimer le logo';

  @override
  String get adminPinSubtitle =>
      'Protéger les actions sensibles comme la suppression ou la modification de produits';

  @override
  String adminSearchSettings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rechercher $count paramètres',
      one: 'Rechercher 1 paramètre',
    );
    return '$_temp0';
  }

  @override
  String adminNoSettingMatches(String query) {
    return 'Aucun paramètre ne correspond à « $query »';
  }

  @override
  String get adminPhoneExampleHint => 'ex. +250783054874';

  @override
  String get perfUncategorised => 'Sans catégorie';

  @override
  String get perfUnits => 'unités';

  @override
  String get perfUnnamedItem => 'Article sans nom';

  @override
  String get perfNoItemsTitle => 'Aucun article dans cette succursale';

  @override
  String get perfNoItemsMessage =>
      'Ajoutez des produits ou enregistrez un achat et le stock apparaîtra ici.';

  @override
  String get perfHeaderSubtitle => 'Stock en direct et rythme de vente';

  @override
  String perfItemsTracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles suivis',
      one: '1 article suivi',
    );
    return '$_temp0';
  }

  @override
  String get perfTitle => 'Tableau de bord du stock';

  @override
  String get perfRefreshTooltip =>
      'Actualiser les chiffres du stock et des ventes';

  @override
  String get perfCoverUnderADay => 'moins d\'un jour';

  @override
  String perfCoverDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String perfCoverMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mois',
      one: '1 mois',
    );
    return '$_temp0';
  }

  @override
  String get perfCoverOverAYear => 'plus d\'un an';

  @override
  String get perfWindowToday => 'Aujourd\'hui';

  @override
  String get perfWindowTodayLower => 'aujourd\'hui';

  @override
  String perfWindowDays(int count) {
    return '$count jours';
  }

  @override
  String perfWindowLastDays(int count) {
    return 'les $count derniers jours';
  }

  @override
  String get perfNoMatchesTitle => 'Aucun résultat pour ces filtres';

  @override
  String get perfNoMatchesMessage =>
      'Effacez la recherche ou choisissez un autre filtre.';

  @override
  String get perfReadingSales => 'Lecture des ventes…';

  @override
  String get perfMovementUnavailable =>
      'Mouvements de vente indisponibles — chiffres du stock uniquement';

  @override
  String perfCompletedSalesIn(int count, String period) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ventes finalisées sur $period',
      one: '1 vente finalisée sur $period',
    );
    return '$_temp0';
  }

  @override
  String perfUnitsAndItems(String units, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return '$units unités · $_temp0';
  }

  @override
  String perfSoldInWindow(String period) {
    return 'Vendu · $period';
  }

  @override
  String perfRevenueAndProfit(String revenue, String profit) {
    return '$revenue encaissés · $profit de bénéfice';
  }

  @override
  String get perfWaitingForSalesData => 'En attente des données de vente';

  @override
  String get perfNothingToRestock => 'rien à réapprovisionner';

  @override
  String get perfTapToSeeThem => 'appuyez pour les voir';

  @override
  String get perfReorderNow => 'À recommander';

  @override
  String get perfWaitingForSellingPace => 'en attente du rythme de vente';

  @override
  String get perfEveryItemHasRunway => 'chaque article a du stock d\'avance';

  @override
  String perfUnderDaysLeft(int days) {
    return 'moins de $days jours de stock';
  }

  @override
  String get perfNoSalesInPeriod => 'Aucune vente sur cette période';

  @override
  String perfBestSellerInWindow(String period) {
    return 'Meilleure vente · $period';
  }

  @override
  String get perfMeasuredFromSales => 'Calculé à partir des ventes finalisées';

  @override
  String perfSoldAndRevenue(String qty, String revenue) {
    return '$qty vendus · $revenue encaissés';
  }

  @override
  String get perfPickLongerPeriod =>
      'Choisissez une période plus longue ou vérifiez la caisse';

  @override
  String get perfEverythingMoving => 'Tout se vend';

  @override
  String perfTiedUp(String amount) {
    return '$amount immobilisés';
  }

  @override
  String get perfNotSelling => 'Invendus';

  @override
  String perfEveryItemSold(String period) {
    return 'Chaque article s\'est vendu au moins une fois sur $period';
  }

  @override
  String perfDeadItems(int count, String period) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles en stock sans vente sur $period',
      one: '1 article en stock sans vente sur $period',
    );
    return '$_temp0';
  }

  @override
  String get perfCountsMatch => 'Les comptages correspondent';

  @override
  String perfLost(String amount) {
    return '$amount perdus';
  }

  @override
  String get perfStockLoss => 'Pertes de stock';

  @override
  String get perfFromRecounts =>
      'D\'après les recomptages de stock de la période';

  @override
  String get perfNoShortfall => 'Aucun manque constaté lors des recomptages';

  @override
  String perfUnitsMissing(String units, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return '$units unités manquantes sur $_temp0';
  }

  @override
  String get perfNoExpiryRisk => 'Aucun risque d\'expiration';

  @override
  String perfItemsAtRisk(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles à risque',
      one: '1 article à risque',
    );
    return '$_temp0';
  }

  @override
  String get perfExpiryWatch => 'Suivi des expirations';

  @override
  String perfNothingExpiring(int days) {
    return 'Rien n\'expire dans les $days prochains jours';
  }

  @override
  String perfExpiringWithin(int days) {
    return 'Expirés ou expirant d\'ici $days jours';
  }

  @override
  String get perfChartStockOnHand => 'Stock disponible';

  @override
  String perfChartUnitsSold(String period) {
    return 'Unités vendues · $period';
  }

  @override
  String perfChartRevenue(String period) {
    return 'Chiffre d\'affaires · $period';
  }

  @override
  String get perfChartDaysLeft => 'Jours de stock restants';

  @override
  String get perfChartStockHint =>
      'Appuyez sur une barre pour sélectionner l\'article.';

  @override
  String get perfChartSoldHint =>
      'Calculé à partir des ventes finalisées. Appuyez sur une barre pour sélectionner.';

  @override
  String get perfChartRevenueHint =>
      'Valeur de vente de ce qui a réellement quitté les rayons.';

  @override
  String get perfChartCoverHint =>
      'Au rythme de vente actuel — les plus courts d\'abord.';

  @override
  String perfTopOf(int shown, int total) {
    return 'top $shown sur $total';
  }

  @override
  String perfItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return '$_temp0';
  }

  @override
  String get perfSold => 'Vendu';

  @override
  String get perfRevenue => 'Chiffre d\'affaires';

  @override
  String get perfStock => 'Stock';

  @override
  String get perfDaysLeft => 'Jours restants';

  @override
  String get perfNoSellingPace =>
      'Pas encore de rythme de vente — rien vendu sur cette période';

  @override
  String get perfNothingToChart => 'Rien à afficher';

  @override
  String perfMovementMeasuredOver(String period) {
    return 'Mouvement mesuré sur $period';
  }

  @override
  String get perfSellingPace => 'Rythme de vente';

  @override
  String perfPerDay(String qty) {
    return '$qty/jour';
  }

  @override
  String get perfStockLeft => 'Stock restant';

  @override
  String get perfNoSales => 'aucune vente';

  @override
  String get perfSellThrough => 'Taux d\'écoulement';

  @override
  String get perfReceivedEst => 'Reçu (est.)';

  @override
  String get perfMissingAtCount => 'Manquant au comptage';

  @override
  String get perfFoundAtCount => 'Trouvé au comptage';

  @override
  String get perfAlertLevel => 'Seuil d\'alerte';

  @override
  String get perfNotSet => 'non défini';

  @override
  String get perfLastSold => 'Dernière vente';

  @override
  String get perfExpiry => 'Expiration';

  @override
  String get perfExpiredLower => 'expiré';

  @override
  String perfInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dans $count jours',
      one: 'dans 1 jour',
    );
    return '$_temp0';
  }

  @override
  String get perfStockUpdated => 'Stock mis à jour';

  @override
  String get perfSortRunsOutSoonest => 'Rupture la plus proche';

  @override
  String get perfSortLowestStock => 'Stock le plus bas d\'abord';

  @override
  String get perfSortBestSelling => 'Meilleures ventes d\'abord';

  @override
  String get perfSortHighestValue => 'Valeur la plus élevée d\'abord';

  @override
  String get perfSortHighestStock => 'Stock le plus élevé d\'abord';

  @override
  String get perfSortNameAz => 'Nom A–Z';

  @override
  String get perfSearchHint =>
      'Rechercher un article, une catégorie, un SKU ou un code-barres';

  @override
  String get perfRunningLow => 'Stock faible';

  @override
  String get perfExpiryRisk => 'Risque d\'expiration';

  @override
  String perfShowingSummary(int shown, int total, String value) {
    return '$shown sur $total articles affichés · $value visibles';
  }

  @override
  String perfMissingAtLastCount(String qty) {
    return '$qty manquants lors du dernier comptage';
  }

  @override
  String get perfExpired => 'Expiré';

  @override
  String perfExpiresInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Expire dans $count jours',
      one: 'Expire dans 1 jour',
    );
    return '$_temp0';
  }

  @override
  String get perfValue => 'Valeur';

  @override
  String get perfEmpty => 'vide';

  @override
  String get perfNeedsSalesForPace =>
      'Il faut des ventes sur la période pour calculer un rythme de vente';

  @override
  String perfSellingPaceTooltip(String pace, String left) {
    return 'Vente de $pace/jour — $left restants';
  }

  @override
  String perfSoldAgainstShelf(String sold, String left) {
    return '$sold vendus contre $left encore en rayon';
  }

  @override
  String perfSoldOfAvailable(String sold, String available) {
    return '$sold vendus sur $available disponibles sur la période';
  }

  @override
  String get perfReorder => 'À recommander';

  @override
  String get perfCouldNotLoadStock => 'Impossible de charger le stock';

  @override
  String get dpaNoProductName => 'Aucun nom de produit !';

  @override
  String get dpaNoProductSaved => 'Aucun produit enregistré !';

  @override
  String get dpaProductSaved => 'Produit enregistré avec succès !';

  @override
  String get dpaProductNotInitialized =>
      'Produit non initialisé. Veuillez réessayer.';

  @override
  String get dpaBranchIdNotFound =>
      'ID de succursale introuvable. Vérifiez que vous êtes bien connecté.';

  @override
  String get dpaBusinessIdNotFound =>
      'ID d\'entreprise introuvable. Vérifiez que vous êtes bien connecté.';

  @override
  String get dpaAddComponent =>
      'Veuillez ajouter au moins un composant au produit composé.';

  @override
  String get dpaCompositeSaved => 'Produit composé enregistré avec succès !';

  @override
  String get dpaInvalidProductRefSelect =>
      'Référence produit invalide. Sélectionnez ou créez d\'abord un produit.';

  @override
  String get dpaUnexpectedReopen =>
      'Une erreur inattendue s\'est produite, fermez cette fenêtre et rouvrez-la';

  @override
  String get dpaInvalidProductRef => 'Référence produit invalide';

  @override
  String get dpaUnexpectedError => 'Une erreur inattendue s\'est produite';

  @override
  String get dpaBasics => 'Informations de base';

  @override
  String get dpaNameColor => 'Nom et couleur';

  @override
  String get dpaProductColor => 'Couleur du produit';

  @override
  String get dpaProductNameHint => 'ex. Fanta Orange 500ml';

  @override
  String get dpaProductNameMinLength =>
      'Le nom du produit doit comporter au moins 3 caractères';

  @override
  String get dpaPricingCodes => 'Prix et codes';

  @override
  String get dpaPriceSkuBarcode => 'Prix, SKU, code-barres';

  @override
  String get dpaRetailPrice => 'Prix de vente';

  @override
  String get dpaRetailPriceHint => 'Ce que paie le client';

  @override
  String get dpaPriceRequired => 'Le prix est obligatoire';

  @override
  String get dpaSupplyPrice => 'Prix d\'achat';

  @override
  String get dpaSupplyFromComponents => 'Calculé à partir des composants';

  @override
  String get dpaComponents => 'Composants';

  @override
  String get dpaBillOfMaterials => 'Nomenclature';

  @override
  String get dpaRetailSupply => 'Vente et achat';

  @override
  String get dpaCostPerUnit => 'Votre coût unitaire';

  @override
  String get dpaInventoryCategorization => 'Stock et catégorisation';

  @override
  String get dpaCategoryItemType => 'Catégorie et type d\'article';

  @override
  String get dpaVariantsStock => 'Variantes et stock';

  @override
  String get dpaStockScan => 'Stock et scan';

  @override
  String get dpaProductDeleted =>
      'Ce produit n\'a pas pu être chargé. Il a peut-être été supprimé.';

  @override
  String get dpaProductLoadFailed =>
      'Impossible de charger ce produit. Veuillez réessayer.';

  @override
  String get dpaProductSavedTitle => 'Produit enregistré';

  @override
  String get dpaAddedToInventory =>
      'Votre produit et ses variantes ont été ajoutés au stock.';

  @override
  String get dpaVariants => 'Variantes';

  @override
  String get dpaAddAnother => 'Ajouter un autre produit';

  @override
  String get dpaAddVariant => 'Ajouter une variante';

  @override
  String get dpaEditVariant => 'Modifier la variante';

  @override
  String get dpaImageUploadFailed =>
      'Impossible de téléverser l\'image. Veuillez réessayer.';

  @override
  String get dpaImageSelected => 'Image sélectionnée';

  @override
  String get dpaAddImage => 'Ajouter une image';

  @override
  String get dpaVariantName => 'Nom de la variante';

  @override
  String get dpaVariantNameHint => 'ex. Sandales, pointure 10';

  @override
  String get dpaNameRequired => 'Le nom est obligatoire';

  @override
  String get dpaRetailOverride => 'Prix de vente spécifique';

  @override
  String get dpaLeaveBlankBasePrice =>
      'Laissez vide pour utiliser le prix de vente de base';

  @override
  String get dpaBarcode => 'Code-barres';

  @override
  String get dpaBarcodeHint => 'SKU / code-barres (facultatif)';

  @override
  String get dpaLeaveBlankVariantName =>
      'Laissez vide pour utiliser le nom de la variante';

  @override
  String get dpaStockQuantity => 'Quantité en stock';

  @override
  String get dpaLowStockReorder => 'Stock bas / recommander à';

  @override
  String get dpaLowStockHelper =>
      'Alerter lorsque la quantité disponible atteint ou passe sous ce niveau';

  @override
  String get dpaTaxStandardB => 'Normal B';

  @override
  String get dpaTaxStandardA => 'Normal A';

  @override
  String get dpaTaxNoneD => 'Aucune (D)';

  @override
  String get dpaSaveVariantFailed =>
      'Impossible d\'enregistrer la variante. Veuillez réessayer.';

  @override
  String get dpaSaveVariant => 'Enregistrer la variante';

  @override
  String get dpaProductInfo => 'Infos produit';

  @override
  String get dpaAdvanced => 'Avancé';

  @override
  String get dpaPlusAdd => '+ Ajouter';

  @override
  String get dpaVariantsHint =>
      'Appuyez sur une variante pour la déplier · Modifiez ou supprimez à l\'intérieur · balayez pour supprimer';

  @override
  String get dpaSaveProduct => 'Enregistrer le produit';

  @override
  String get dpaRraTimeout =>
      'Le serveur fiscal RRA ne répond pas. Le produit est enregistré localement mais pas encore entièrement déclaré à la RRA. Vérifiez le serveur fiscal, puis appuyez de nouveau sur Enregistrer.';

  @override
  String dpaRraReportingFailed(String error) {
    return 'Produit enregistré localement mais la déclaration à la RRA a échoué : $error. Appuyez de nouveau sur Enregistrer pour réessayer.';
  }

  @override
  String dpaSaveProductFailed(String error) {
    return 'Impossible d\'enregistrer le produit : $error';
  }

  @override
  String dpaCompositeSaveFailed(String error) {
    return 'Échec de l\'enregistrement du produit composé : $error';
  }

  @override
  String dpaNamedProductSaved(String name) {
    return '$name enregistré !';
  }

  @override
  String dpaBaseRetailPrice(String price) {
    return 'Prix de vente de base : $price';
  }

  @override
  String get dpaNotVatRegistered =>
      'Cette succursale n\'est pas assujettie à la TVA. Seul « Aucune » (D) s\'applique.';

  @override
  String get cartNotEnoughStock => 'Stock insuffisant';

  @override
  String get cartFailedToAddItem =>
      'Impossible d\'ajouter l\'article au panier';

  @override
  String get sellNoItemSelected => 'Aucun article sélectionné';

  @override
  String get sellChooseOne => 'CHOISISSEZ-EN UN';

  @override
  String get dashYes => 'Oui';

  @override
  String get dashNo => 'Non';

  @override
  String get dashTryAgain => 'Réessayer';

  @override
  String get securityEnablePasscode => 'Activer le code d\'accès';

  @override
  String get printingConfiguration => 'Configuration de l\'impression';

  @override
  String get printingEnableAutoPrint => 'Activer l\'impression automatique';

  @override
  String get inventoryCart => 'Panier';

  @override
  String inventoryCartWithCount(String count) {
    return 'Panier ($count)';
  }

  @override
  String discountRowAmountOff(String amount, String currency) {
    return '$amount $currency de remise';
  }

  @override
  String get dashPendingTransactionCopied =>
      'Transaction en attente copiée dans le presse-papiers';

  @override
  String get dashUserFallback => 'Utilisateur';

  @override
  String get dashPopupDialogOpen => 'Fenêtre contextuelle ouverte';

  @override
  String get memberFieldAddMember => 'Ajouter un membre';

  @override
  String get orderViewTitle => 'Commande';

  @override
  String get switchBranchAble => 'Vous pouvez changer de succursale';

  @override
  String noNetErrorCheckingConnection(String error) {
    return 'Erreur lors de la vérification de la connexion : $error';
  }

  @override
  String get noNetTitle => 'Pas d\'Internet';

  @override
  String get noNetSubtitle =>
      'Impossible de se connecter à Internet.\nVeuillez vérifier votre connexion';

  @override
  String get noNetCheckConnection => 'Vérifier la connexion';

  @override
  String get noNetGoToLogin => 'Aller à la connexion';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsWhatsNew => 'Nouveautés';

  @override
  String get notificationsTakeFirstPayment =>
      'Encaissez votre premier paiement';

  @override
  String get notificationsLearnFirstPayment =>
      'Découvrez comment encaisser votre premier paiement.';

  @override
  String get ordersDoneShopping => 'Vous avez terminé vos achats ?';

  @override
  String get ordersOrderFromSupplier => 'Commander auprès du fournisseur';

  @override
  String get ordersSelectSupplierHint =>
      'Recherchez et sélectionnez un fournisseur pour voir ses produits';

  @override
  String ordersSearchProductsFrom(String supplier) {
    return 'Rechercher des produits de $supplier';
  }

  @override
  String get scannerNoBarcodeValue => 'Aucun code-barres détecté.';

  @override
  String scannerProcessingBarcode(String barcode) {
    return 'Traitement du code-barres : $barcode';
  }

  @override
  String scannerProductNotFoundForBarcode(String barcode) {
    return 'Aucun produit pour le code-barres : $barcode';
  }

  @override
  String scannerErrorAddingProduct(String error) {
    return 'Erreur lors de l\'ajout du produit : $error';
  }

  @override
  String get subscriptionEnterCode => 'Saisissez le code d\'abonnement';

  @override
  String get subscriptionEnterCodeHint =>
      'Saisissez le code d\'abonnement reçu de notre agent';

  @override
  String get subscriptionSubscribe => 'S\'abonner';

  @override
  String get subscriptionUpdate => 'Mettre à jour l\'abonnement';

  @override
  String get subscriptionEnterVoucherError => 'Veuillez saisir votre bon';

  @override
  String get subscriptionEnterVoucher => 'Saisir le bon';

  @override
  String get subscriptionActivatePro => 'Activez Flipper Pro !';

  @override
  String get subscriptionUpgradeToPro => 'Passer à Pro';

  @override
  String get saleIndicatorNoSale => 'Aucune vente';

  @override
  String get tenantsBindProductHint =>
      'Associez le produit à un utilisateur ci-dessous pour vendre plus facilement';

  @override
  String tenantsBoundTo(String name) {
    return 'Associé à $name';
  }

  @override
  String get tenantsBind => 'Associer';

  @override
  String get payableSendToTill => 'Envoyer à la caisse →';

  @override
  String get cashbookSuggestSales => 'Ventes';

  @override
  String get cashbookSuggestOwnerDeposit => 'Apport du propriétaire';

  @override
  String get cashbookSuggestLoanReceived => 'Prêt reçu';

  @override
  String get cashbookSuggestDebtRepayment => 'Remboursement de dette';

  @override
  String get cashbookSuggestRefund => 'Remboursement';

  @override
  String get cashbookSuggestCommission => 'Commission';

  @override
  String get cashbookSuggestTransport => 'Transport';

  @override
  String get cashbookSuggestRent => 'Loyer';

  @override
  String get cashbookSuggestSalaries => 'Salaires';

  @override
  String get cashbookSuggestUtilities => 'Charges';

  @override
  String get cashbookSuggestSupplies => 'Fournitures';

  @override
  String get cashbookSuggestAirtime => 'Crédit téléphonique';

  @override
  String get cashbookSuggestFood => 'Nourriture';

  @override
  String get cashbookSuggestRepairs => 'Réparations';

  @override
  String get shiftStartSubtitle =>
      'Initialisez votre tiroir-caisse et commencez';

  @override
  String get shiftDetails => 'Détails du service';

  @override
  String shiftStartTime(String time) {
    return 'Heure de début : $time';
  }

  @override
  String shiftEndTime(String time) {
    return 'Heure de fin : $time';
  }

  @override
  String get shiftOpeningCashFloat => 'Fonds de caisse initial';

  @override
  String get shiftOpeningCashFloatHint =>
      'Saisissez le montant en espèces dans votre tiroir au début du service';

  @override
  String get shiftOpeningBalanceRequired => 'Le solde d\'ouverture est requis';

  @override
  String get shiftEnterValidPositiveAmount =>
      'Veuillez saisir un montant positif valide';

  @override
  String get shiftNotesOptional => 'Notes (facultatif)';

  @override
  String get shiftNotesHint =>
      'Ajoutez des notes supplémentaires sur ce service';

  @override
  String get shiftEnterNotesHere => 'Saisissez vos notes ici...';

  @override
  String get shiftStarting => 'Démarrage...';

  @override
  String get shiftStartShift => 'Démarrer le service';

  @override
  String get shiftErrorNetwork =>
      'Erreur réseau. Vérifiez votre connexion et réessayez.';

  @override
  String get shiftErrorSessionExpired =>
      'Votre session a expiré. Veuillez vous reconnecter.';

  @override
  String get shiftErrorValidation => 'Vérifiez votre saisie et réessayez.';

  @override
  String get shiftErrorUnexpected =>
      'Une erreur inattendue s\'est produite. Veuillez réessayer.';

  @override
  String get shiftErrorLoadingData =>
      'Erreur de chargement des données du service';

  @override
  String get shiftSummary => 'Résumé du service';

  @override
  String get shiftOpeningBalance => 'Solde d\'ouverture';

  @override
  String get shiftCashSales => 'Ventes en espèces';

  @override
  String get shiftExpectedCash => 'Espèces attendues';

  @override
  String get shiftCashReconciliation => 'Rapprochement de caisse';

  @override
  String get shiftCountCashHint =>
      'Comptez les espèces dans le tiroir et saisissez le\nsolde de clôture ci-dessous.';

  @override
  String get shiftClosingCashBalance => 'Solde de caisse de clôture';

  @override
  String get shiftClosingCashHint =>
      'Saisissez les espèces réellement comptées dans le tiroir';

  @override
  String get shiftRequired => 'Obligatoire';

  @override
  String get shiftInvalidAmount => 'Montant invalide';

  @override
  String get shiftPerfectBalance => 'Caisse équilibrée';

  @override
  String get shiftOverage => 'Excédent';

  @override
  String get shiftShortage => 'Manquant';

  @override
  String get shiftDifference => 'Écart';

  @override
  String get shiftMoreCashThanExpected => 'Plus d\'espèces que prévu';

  @override
  String get shiftLessCashThanExpected => 'Moins d\'espèces que prévu';

  @override
  String get shiftNotes => 'Notes';

  @override
  String get shiftExplainShortage => 'Expliquez le manquant';

  @override
  String get shiftAddAnyNotes => 'Ajoutez des notes';

  @override
  String get shiftNotesRequiredWhenDifference => 'Obligatoire en cas d\'écart';

  @override
  String get shiftExplainDifference => 'Expliquez l\'écart...';

  @override
  String get shiftEnterNotes => 'Saisissez des notes...';

  @override
  String get shiftConfirmClosure => 'Confirmer la clôture du service';

  @override
  String get shiftGoBack => 'Retour';

  @override
  String get shiftConfirmClose => 'Confirmer la clôture';

  @override
  String get shiftInvalidClosingBalance => 'Solde de clôture invalide';

  @override
  String shiftFailedToClose(String error) {
    return 'Échec de la clôture du service : $error';
  }

  @override
  String get umusadaBusinessFinancing => 'Financement d\'entreprise';

  @override
  String get umusadaUnlockLoans => 'Accédez aux prêts professionnels';

  @override
  String get umusadaFinancingHint =>
      'Obtenez un financement basé sur votre historique de commandes';

  @override
  String get umusadaHowItWorks => 'Comment ça marche';

  @override
  String get umusadaAutoSync => 'Synchronisation auto';

  @override
  String get umusadaAutoSyncDesc =>
      'Vos données de commande sont synchronisées en toute sécurité pour créer votre profil.';

  @override
  String get umusadaCreditScore => 'Score de crédit';

  @override
  String get umusadaCreditScoreDesc =>
      'Umusada évalue votre historique pour fixer un plafond de prêt.';

  @override
  String get umusadaInstantLoans => 'Prêts instantanés';

  @override
  String get umusadaInstantLoansDesc =>
      'Accédez rapidement à des fonds quand vous en avez le plus besoin.';

  @override
  String get umusadaJoin => 'Rejoindre Umusada';

  @override
  String get umusadaMaybeLater => 'Plus tard';

  @override
  String get umusadaConnecting => 'Connexion…';

  @override
  String get umusadaConnectionFailed => 'Échec de la connexion';

  @override
  String get umusadaCouldNotConnect =>
      'Impossible de se connecter à Umusada. Veuillez réessayer plus tard.';

  @override
  String get mfaUserNotLoggedIn => 'Utilisateur non connecté';

  @override
  String mfaErrorLoadingSecret(String error) {
    return 'Erreur de chargement/génération du secret MFA : $error';
  }

  @override
  String get mfaSetupAuthenticator => 'Configurer l\'authentificateur';

  @override
  String get mfaSettingUp => 'Configuration de votre authentificateur...';

  @override
  String get mfaSetupFailed => 'Échec de la configuration';

  @override
  String get mfaGoBack => 'Retour';

  @override
  String get mfaSetUpTwoFactor =>
      'Configurer l\'authentification\nà deux facteurs';

  @override
  String get mfaScanQrHint =>
      'Scannez le QR code ci-dessous avec votre application\nd\'authentification pour protéger votre compte Flipper.';

  @override
  String get mfaStepVerify => 'Vérifier';

  @override
  String get mfaIveSetUp => 'J\'ai configuré mon authentificateur';

  @override
  String get mfaNeedHelp => 'Besoin d\'aide ?';

  @override
  String get mfaHelpText =>
      'Utilisez des applications comme Microsoft Authenticator, Google Authenticator ou Authy pour scanner le QR code et générer des codes de vérification.';

  @override
  String get mfaSetupKey => 'CLÉ DE CONFIGURATION';

  @override
  String get mfaCopied => 'Copié';

  @override
  String get mfaCopy => 'Copier';

  @override
  String get noticesTitle => 'Avis';

  @override
  String get noticesSubtitle => 'Restez informé des dernières annonces';

  @override
  String get noticesLoading => 'Chargement des avis...';

  @override
  String get noticesUnableToLoad => 'Impossible de charger les avis';

  @override
  String get noticesCheckConnection => 'Vérifiez votre connexion et réessayez';

  @override
  String get noticesEmpty => 'Aucun avis pour le moment';

  @override
  String get noticesEmptyHint =>
      'Les nouveaux avis et annonces apparaîtront ici';

  @override
  String get noticesNoTitle => 'Sans titre';

  @override
  String get noticesNoContent => 'Aucun contenu disponible';

  @override
  String get noticesNoDate => 'Pas de date';

  @override
  String get noticesReadMore => 'Lire la suite';

  @override
  String get ribbonOrdering => 'Commandes';

  @override
  String get ribbonImportPurchase => 'Import et achats';

  @override
  String get ribbonLocations => 'Emplacements';

  @override
  String get ribbonLocationsCaption => 'Stock par succursale';

  @override
  String get ribbonItemsCaption => 'Parcourir et gérer le catalogue';

  @override
  String get ribbonTaxSettingsCaption => 'Serveur EBM / RRA et TVA';

  @override
  String importPurchasePageSyncFailed(String error) {
    return 'Échec de la synchronisation : $error';
  }

  @override
  String get importPurchasePageManagement => 'Gestion des imports et achats';

  @override
  String get importPurchasePageSyncing => 'Synchronisation…';

  @override
  String importPurchasePageSyncedAgo(String time) {
    return 'Synchronisé $time';
  }

  @override
  String get importPurchasePageNotSynced => 'Pas encore synchronisé';

  @override
  String get importPurchasePageExport => 'Exporter';

  @override
  String get importPurchasePageRecordPurchase => 'Enregistrer un achat';

  @override
  String get importPurchasePageSyncFromRra => 'Synchroniser depuis RRA';

  @override
  String get importPurchasePageImportFrom => 'Importé depuis';

  @override
  String get importPurchasePagePurchaseFrom => 'Achats depuis';

  @override
  String get infoDialogUnexpectedError =>
      'Une erreur inattendue s\'est produite.';

  @override
  String get infoDialogWarning => 'Avertissement';

  @override
  String get infoDialogSuccess => 'Succès';

  @override
  String get infoDialogInformation => 'Information';

  @override
  String get infoDialogGotIt => 'Compris';

  @override
  String get infoDialogDismiss => 'Fermer';

  @override
  String get keypadCashInFor => 'Entrée d\'argent pour';

  @override
  String get keypadCashOutFor => 'Sortie d\'argent pour';

  @override
  String get dataMixerCannotDelete =>
      'Impossible à supprimer ou déjà supprimé.';

  @override
  String get dataMixerCouldNotDelete =>
      'Impossible de supprimer cet article. Veuillez réessayer.';

  @override
  String get dataMixerUnknownProduct => 'Produit inconnu';

  @override
  String get searchToggleScanMode => 'Activer/désactiver le mode scan';

  @override
  String get customAlertTitle => 'Alerte';

  @override
  String get imagePickerTitle => 'Choisir une image';

  @override
  String get imagePickerUseCamera => 'Utiliser l\'appareil photo';

  @override
  String get imagePickerUseGallery => 'Utiliser la galerie';

  @override
  String get favoritesArrange => 'Organisez vos favoris';

  @override
  String get favoritesPressDone =>
      'Appuyez sur « Terminé » quand vous avez fini';

  @override
  String get favoritesPressAndHold =>
      'Appuyez longuement n\'importe où dans la grille pour placer les articles';

  @override
  String get drawerCloseBusiness => 'Fermer l\'activité';

  @override
  String get drawerOpenBusiness => 'Ouvrir l\'activité';

  @override
  String get drawerEnterAmount => 'Vous devez saisir le montant';

  @override
  String get drawerNumericOnly =>
      'Seules les valeurs numériques sont autorisées';

  @override
  String get drawerClosingBalance => 'Solde de clôture';

  @override
  String get drawerOpenDrawer => 'Ouvrir la caisse';

  @override
  String get drawerCloseDrawer => 'Fermer la caisse';

  @override
  String get drawerLogoutWithoutClosing =>
      'Se déconnecter sans fermer la caisse';

  @override
  String get cashierStaffFallback => 'Personnel';

  @override
  String get paymentsSplitPayment => 'Diviser le paiement';

  @override
  String get paymentsConfirmPayment => 'Confirmer le paiement';

  @override
  String get paymentsHideDiscount => 'Masquer la remise';

  @override
  String get paymentsAddDiscount => 'Ajouter une remise';

  @override
  String get paymentsSendInvoice => 'Envoyer la facture';

  @override
  String get paymentsEnterDiscountAmount =>
      'Veuillez saisir le montant de la remise';

  @override
  String get paymentsDiscountExceedsTotal =>
      'La remise ne peut pas dépasser le montant total';

  @override
  String get paymentsPhoneWithoutZero =>
      'Saisissez le numéro de téléphone sans le 0, ex. 783054874';

  @override
  String get paymentsEnterCashReceived => 'Veuillez saisir les espèces reçues';

  @override
  String get paymentsAmountLessThanPayable =>
      'Le montant est inférieur au montant à payer';

  @override
  String get paymentsChooseMethod => 'Vous devez choisir un moyen de paiement';

  @override
  String get paymentsTypeCard => 'Carte';

  @override
  String get paymentsTypeMobile => 'Mobile';

  @override
  String get paymentsTypeBank => 'Banque';

  @override
  String get paymentsTypeCheque => 'Chèque';

  @override
  String get dashNotAvailable => 'N/D';

  @override
  String get itemsExportNone => 'Aucun article à exporter';

  @override
  String get itemsExportSaveDialogTitle => 'Enregistrer le fichier Excel';

  @override
  String get itemsExportProductName => 'Nom du produit';

  @override
  String get itemsExportVariantName => 'Nom de la variante';

  @override
  String get itemsExportItemCode => 'Code article';

  @override
  String get itemsExportRetailPrice => 'Prix de vente';

  @override
  String get itemsExportUnit => 'Unité';

  @override
  String itemsExportSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles exportés avec succès',
      one: '1 article exporté avec succès',
    );
    return '$_temp0';
  }

  @override
  String get itemsExportIncompleteSync =>
      'Certaines quantités sont peut-être encore en cours de synchronisation ; réexportez plus tard si les totaux semblent faux.';

  @override
  String itemsExportFailed(String error) {
    return 'Échec de l\'export des articles : $error';
  }

  @override
  String get itemsTypeRawMaterial => 'Matière première';

  @override
  String get itemsTypeFinishedProduct => 'Produit fini';

  @override
  String get itemsTypeService => 'Service';

  @override
  String get itemsTypeUnknown => 'Inconnu';

  @override
  String get itemsExportToExcel => 'Exporter vers Excel';

  @override
  String get itemsSearchByName => 'Rechercher par nom...';

  @override
  String itemsTransactionsSyncedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions synchronisées trouvées',
      one: '1 transaction synchronisée trouvée',
    );
    return '$_temp0';
  }

  @override
  String get itemsTransactionsSynced =>
      'Transactions synchronisées avec succès';

  @override
  String get itemsNoneFound => 'Aucun article trouvé.';

  @override
  String itemsStockValue(String quantity) {
    return 'Stock : $quantity';
  }

  @override
  String get itemsStockLoading => 'Stock : chargement...';

  @override
  String get itemsStockError => 'Stock : erreur';

  @override
  String itemsErrorLoading(String error) {
    return 'Erreur de chargement des articles : $error';
  }

  @override
  String importPurchasePageFetchedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nouveaux articles récupérés depuis RRA',
      one: '1 nouvel article récupéré depuis RRA',
    );
    return '$_temp0';
  }

  @override
  String importPurchasePageFetchedInvoices(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nouvelles factures récupérées depuis RRA',
      one: '1 nouvelle facture récupérée depuis RRA',
    );
    return '$_temp0';
  }

  @override
  String get importPurchasePageNoNewItems =>
      'Synchronisation terminée — aucun nouvel article';

  @override
  String get importPurchasePageNoNewInvoices =>
      'Synchronisation terminée — aucune nouvelle facture';

  @override
  String get itemsViewFromLastWeek => 'depuis la semaine dernière';

  @override
  String itemsViewExpiredOn(String date) {
    return 'Expiré le : $date';
  }

  @override
  String itemsViewIdValue(String id) {
    return 'ID : $id';
  }

  @override
  String itemsViewCategoryValue(String category) {
    return 'Catégorie : $category';
  }

  @override
  String itemsViewQuantityValue(String quantity) {
    return 'Quantité : $quantity';
  }

  @override
  String itemsViewLocationValue(String location) {
    return 'Emplacement : $location';
  }

  @override
  String itemsViewExpiryDateValue(String date) {
    return 'Date d\'expiration : $date';
  }

  @override
  String get itemsViewInventoryByCategory => 'Stock par catégorie';

  @override
  String get itemsViewStockLevelsTrend => 'Évolution des niveaux de stock';

  @override
  String get itemsViewRecentOrders => 'Commandes récentes';

  @override
  String itemsViewOrderLine(String id, String date) {
    return 'Commande n° $id - $date';
  }

  @override
  String get itemsViewNearExpiryItems => 'Articles bientôt périmés';

  @override
  String itemsViewUnitsAtLocation(int count, String location) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unités',
      one: '1 unité',
    );
    return '$_temp0 - $location';
  }

  @override
  String itemsViewDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours restants',
      one: '1 jour restant',
    );
    return '$_temp0';
  }

  @override
  String get itemsViewStatusDelivered => 'Livrée';

  @override
  String get itemsViewStatusInTransit => 'En transit';

  @override
  String get itemsViewStatusProcessing => 'En traitement';

  @override
  String get itemsViewStatusCancelled => 'Annulée';

  @override
  String get stockApprovalNoItems => 'Aucun article trouvé dans la demande';

  @override
  String get stockApprovalAtLeastOne =>
      'Au moins un article doit être approuvé';

  @override
  String get stockApprovalProcessError =>
      'Une erreur s\'est produite lors du traitement de la demande';

  @override
  String get stockApprovalQuantityUpdated => 'Quantité mise à jour';

  @override
  String get stockApprovalQuantityUpdateFailed =>
      'Échec de la mise à jour de la quantité';

  @override
  String stockApprovalInsufficientFor(String item) {
    return 'Stock insuffisant pour $item';
  }

  @override
  String stockApprovalVariantNotFoundFor(String item) {
    return 'Variante introuvable pour $item';
  }

  @override
  String stockApprovalAdjustedToAvailable(String quantity) {
    return 'Quantité ajustée au stock disponible : $quantity';
  }

  @override
  String stockApprovalItemApproved(String item) {
    return '$item a été approuvé';
  }

  @override
  String get stockApprovalItemError =>
      'Une erreur s\'est produite lors de l\'approbation de l\'article';

  @override
  String get stockApprovalCancelled => 'Approbation annulée';

  @override
  String stockApprovalSmsApproved(String reference) {
    return 'Votre demande de stock n° $reference a été approuvée.';
  }

  @override
  String stockApprovalSmsPartiallyApproved(String reference) {
    return 'Votre demande de stock n° $reference a été partiellement approuvée.';
  }

  @override
  String get stockApprovalRequestApproved => 'Demande approuvée avec succès';

  @override
  String get stockApprovalRequestPartiallyApproved =>
      'Demande partiellement approuvée avec succès';

  @override
  String get stockApprovalFinalizeFailed =>
      'Échec de la finalisation de l\'approbation';

  @override
  String get stockApprovalProcessing => 'Traitement de la demande...';

  @override
  String get stockApprovalPartialTitle => 'Approbation partielle';

  @override
  String get stockApprovalApprove => 'Approuver';

  @override
  String get stockApprovalInsufficientHint =>
      'Certains articles ont un stock insuffisant. Ajustez les quantités approuvées :';

  @override
  String get stockApprovalVariantNotFound => 'Variante introuvable';

  @override
  String get stockApprovalApproveQuantity => 'Quantité à approuver';

  @override
  String get stockApprovalRequested => 'Demandé';

  @override
  String get stockApprovalAvailable => 'Disponible';

  @override
  String stockApprovalChipValue(String label, String value) {
    return '$label : $value';
  }

  @override
  String get stockApprovalPleaseApproveOne =>
      'Veuillez approuver au moins un article';

  @override
  String get stockApprovalProcessFailed =>
      'Échec du traitement de l\'approbation';

  @override
  String get exportDataTotalLabel => 'Total :';

  @override
  String get exportDataTotal => 'Total';

  @override
  String get exportDataSheetStockRecount => 'Recomptage du stock';

  @override
  String get exportDataSheetReport => 'Rapport';

  @override
  String get exportDataSheetExpenses => 'Dépenses';

  @override
  String get exportDataSheetPaymentMethods => 'Moyens de paiement';

  @override
  String get exportDataTotalSalesLines => 'Total des ventes (lignes) :';

  @override
  String get exportDataNetProfitBeforeExpenses =>
      'Bénéfice net total (avant dépenses) :';

  @override
  String get exportDataNetProfitAfterExpenses =>
      'Bénéfice net final (après dépenses) :';

  @override
  String get exportDataPaymentType => 'Type de paiement';

  @override
  String get exportDataSaleAmount => 'Montant des ventes';

  @override
  String get exportDataTransactionCount => 'Nombre de transactions';

  @override
  String get exportDataPercentOfTotal => '% du total';

  @override
  String get exportDataExpense => 'Dépense';

  @override
  String get exportDataTotalExpenses => 'Total des dépenses';

  @override
  String exportDataShareSubject(String date) {
    return 'Téléchargement du rapport - $date';
  }

  @override
  String get mposSaveCustomerBeforeTill =>
      'Enregistrez un nom ou un numéro de téléphone client sur ce ticket avant de l\'envoyer à la caisse.';

  @override
  String get mposCouldNotReturnTicket =>
      'Impossible de renvoyer ce ticket à la caisse. Veuillez réessayer.';

  @override
  String get mposCouldNotRemoveCustomer => 'Impossible de retirer le client';

  @override
  String get mposPaymentsAtTillSendToManager =>
      'Les paiements sont encaissés à la caisse. Envoyez cette commande à un responsable.';

  @override
  String get mposAddCustomerBeforeCompleting =>
      'Veuillez ajouter un client à la vente avant de la finaliser';

  @override
  String get mposEnterValidMomoPhone =>
      'Saisissez un numéro MoMo valide pour demander le paiement';

  @override
  String get mposCustomerRequiredForCredit =>
      'Un nom ou un téléphone client est requis pour les paiements à crédit.';

  @override
  String get mposErrorOccurred => 'Une erreur s\'est produite';

  @override
  String mposErrorUpdatingQuantity(String error) {
    return 'Erreur de mise à jour de la quantité : $error';
  }

  @override
  String mposErrorRemovingProduct(String error) {
    return 'Erreur lors du retrait du produit : $error';
  }

  @override
  String mposErrorUpdatingPrice(String error) {
    return 'Erreur de mise à jour du prix : $error';
  }

  @override
  String get mposAddItemsToCharge => 'Ajoutez des articles à encaisser';

  @override
  String get mposRecordPayment => 'Enregistrer le paiement';

  @override
  String get mposComplete => 'Terminer';

  @override
  String get mposCompleteNow => 'Terminer maintenant';

  @override
  String get mposWaitingForPayment => 'En attente du paiement...';

  @override
  String get mposPrintingReceipt => 'Impression du reçu...';

  @override
  String get mposPaymentFailedRetry => 'Échec du paiement. Réessayer ?';

  @override
  String mposEnterAmountReceived(String amount) {
    return 'Saisissez $amount reçus';
  }

  @override
  String get mposMobileCheckout => 'Encaissement mobile';

  @override
  String mposCheckoutSemanticValue(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return '$_temp0, RWF $total';
  }

  @override
  String get mposNoItemsInCart => 'Aucun article dans le panier';

  @override
  String get mposAddMoreItems => 'Ajouter des articles';

  @override
  String get mposPaymentMethod => 'Moyen de paiement';

  @override
  String get mposTotals => 'Totaux';

  @override
  String get loginChoicesMember => 'Membre';

  @override
  String get loginChoicesOwner => 'Propriétaire';

  @override
  String loginChoicesBusinessSubtitle(String role, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count succursales',
      one: '1 succursale',
    );
    return '$role · $_temp0';
  }

  @override
  String get loginChoicesValidatingSession => 'Validation de la session...';

  @override
  String get loginChoicesLoadingBusinesses =>
      'Chargement de vos entreprises...';

  @override
  String get loginChoicesNoBusinessesSigningOut =>
      'Aucune entreprise trouvée. Déconnexion...';

  @override
  String get loginChoicesChooseBusiness => 'Choisissez une entreprise';

  @override
  String get loginChoicesSelectBusinessHint =>
      'Sélectionnez l\'entreprise que vous voulez gérer.';

  @override
  String get loginChoicesChooseBranch => 'Choisissez une succursale';

  @override
  String get loginChoicesSelectBranchHint =>
      'Sélectionnez la succursale à laquelle accéder';

  @override
  String get loginChoicesBranchFallback => 'Succursale';

  @override
  String get loginChoicesSigningOut => 'Déconnexion…';

  @override
  String get loginChoicesPleaseWait => 'Veuillez patienter un instant';

  @override
  String get loginChoicesSignOut => 'Se déconnecter';

  @override
  String get loginChoicesAddBusiness => 'Ajouter une entreprise';

  @override
  String get loginChoicesNotSeeingBusiness =>
      'Vous ne voyez pas votre entreprise ? Demandez au propriétaire de vous inviter, ou ';

  @override
  String get loginChoicesAddBusinessLink => 'ajoutez une entreprise.';

  @override
  String get loginChoicesNoBranches =>
      'Aucune succursale chargée pour le moment';

  @override
  String get loginChoicesNoBranchesHint =>
      'Cela peut arriver si la synchronisation est en cours.\nRéessayez dans un instant.';

  @override
  String get loginChoicesDefaultBadge => 'PAR DÉFAUT';

  @override
  String get drawerMenuAdminFallback => 'Administrateur';

  @override
  String get drawerMenuMyBusiness => 'Mon entreprise';

  @override
  String get drawerMenuQuickActions => 'ACTIONS RAPIDES';

  @override
  String get drawerMenuYourBusinesses => 'VOS ENTREPRISES';

  @override
  String get drawerMenuManagement => 'GESTION';

  @override
  String get drawerMenuPrintDelegation => 'Délégation d\'impression';

  @override
  String get drawerMenuSaleMode => 'Mode de vente';

  @override
  String get drawerMenuBackgroundSyncEnabled =>
      'Synchronisation en arrière-plan activée. Pour la désactiver, allez dans les paramètres.';

  @override
  String get drawerMenuBackgroundSyncDisabled =>
      'Synchronisation en arrière-plan désactivée';

  @override
  String get drawerMenuEbmOn => 'EBM activé';

  @override
  String get drawerMenuEbmOff => 'EBM désactivé';

  @override
  String get drawerMenuCheckingEbm => 'Vérification du statut EBM...';

  @override
  String get drawerMenuEbmStatusError => 'Erreur de statut EBM';

  @override
  String get drawerMenuCheckingShift => 'Vérification du service...';

  @override
  String get drawerMenuEndShift => 'Terminer le service en cours';

  @override
  String get drawerMenuStartShift => 'Démarrer un nouveau service';

  @override
  String get drawerMenuUnnamedBusiness => 'Entreprise sans nom';

  @override
  String get drawerMenuUnnamedBranch => 'Succursale sans nom';

  @override
  String drawerMenuBranchCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count succursales',
      one: '1 succursale',
    );
    return '$_temp0';
  }

  @override
  String get drawerMenuDelegationEnabled => 'Délégation d\'impression activée';

  @override
  String get drawerMenuDelegationDisabled =>
      'Délégation d\'impression désactivée';

  @override
  String get drawerMenuDelegationDeviceSelected =>
      'Appareil de délégation sélectionné';

  @override
  String drawerMenuErrorSelectingDevice(String error) {
    return 'Erreur lors de la sélection de l\'appareil : $error';
  }

  @override
  String get drawerMenuSelectDevice => 'Sélectionner l\'appareil';

  @override
  String get drawerMenuNoDevices =>
      'Aucun appareil disponible dans cette succursale';

  @override
  String drawerMenuPlatform(String platform) {
    return 'Plateforme : $platform';
  }

  @override
  String drawerMenuPhone(String phone) {
    return 'Téléphone : $phone';
  }

  @override
  String drawerMenuErrorLoadingDevices(String error) {
    return 'Erreur de chargement des appareils : $error';
  }

  @override
  String get drawerMenuDelegate => 'Déléguer';

  @override
  String get drawerMenuDelegateHint =>
      'Impression des reçus sur l\'ordinateur quand le serveur EBM est indisponible';

  @override
  String get drawerMenuEnabled => 'Activé';

  @override
  String get drawerMenuDisabled => 'Désactivé';

  @override
  String get drawerMenuDelegationStep1 =>
      'Le mobile finalise la transaction mais\ndélègue la génération du reçu';

  @override
  String get drawerMenuDelegationStep2 =>
      'L\'ordinateur récupère la transaction via la synchronisation';

  @override
  String get drawerMenuDelegationStep3 =>
      'L\'ordinateur génère le reçu et\ncommunique avec le serveur EBM';

  @override
  String get drawerMenuDelegationStep4 =>
      'Le mobile est notifié une fois\nle traitement terminé';

  @override
  String get drawerMenuRequirements => 'Prérequis';

  @override
  String get drawerMenuRequirement1 =>
      'L\'application de bureau doit tourner avec la délégation activée';

  @override
  String get drawerMenuRequirement2 =>
      'Les deux appareils doivent se synchroniser via Flipper';

  @override
  String get drawerMenuRequirement3 =>
      'L\'ordinateur traite les transactions déléguées toutes les 10 secondes';

  @override
  String get customersHelpSearch =>
      'Recherchez des clients par nom ou numéro de téléphone';

  @override
  String get customersHelpEdit =>
      'Utilisez Modifier sur une ligne client pour mettre à jour ses informations';

  @override
  String get customersHelpTap =>
      'Touchez un client pour l\'associer à la vente en cours';

  @override
  String get customersHelpSwipe =>
      'Sur téléphone, balayez une ligne pour supprimer, modifier, ajouter ou retirer rapidement';

  @override
  String get customersHelpAdd =>
      'Ajoutez un nouveau client avec le bouton sous le champ de recherche';

  @override
  String get customersNoneFound => 'Aucun client trouvé';

  @override
  String customersFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clients trouvés',
      one: '1 client trouvé',
    );
    return '$_temp0';
  }

  @override
  String get customersTryDifferentSearch =>
      'Essayez d\'autres termes de recherche ou ajoutez un nouveau client';

  @override
  String get customersAddToGetStarted => 'Ajoutez un client pour commencer';

  @override
  String customersAddAsNew(String name) {
    return 'Ajouter « $name » comme nouveau client';
  }

  @override
  String get customersAddNew => 'Ajouter un nouveau client';

  @override
  String get customersNoName => 'Sans nom';

  @override
  String customersTinValue(String tin) {
    return 'TIN : $tin';
  }

  @override
  String get customersRemoveFromSale => 'Retirer de la vente';

  @override
  String get customersAddToSale => 'Ajouter à la vente';

  @override
  String customersAddedToSale(String name) {
    return 'Client $name ajouté à la vente';
  }

  @override
  String get customersFailedToAdd =>
      'Impossible d\'ajouter le client à la vente';

  @override
  String get customersRemovedFromSale => 'Client retiré de la vente';

  @override
  String get customersFailedToRemove =>
      'Impossible de retirer le client de la vente';

  @override
  String get customersDeleted => 'Client supprimé';

  @override
  String customersCouldNotOpenForm(String error) {
    return 'Impossible d\'ouvrir le formulaire client : $error';
  }

  @override
  String customersAddNamed(String name) {
    return 'Ajouter le client « $name »';
  }

  @override
  String customersAddNamedToSale(String name) {
    return 'Ajouter « $name » à la vente';
  }

  @override
  String get customersThisCustomer => 'ce client';

  @override
  String get customersDeleteTitle => 'Supprimer le client ?';

  @override
  String customersDeleteBody(String name) {
    return 'Retirer $name de votre liste de clients. Cette action est irréversible.';
  }

  @override
  String get itemRowConfirmFavorite => 'Confirmer le favori';

  @override
  String itemRowConfirmFavoriteBody(String product, String position) {
    return 'Vous allez ajouter $product à la position favorite $position.\n\nConfirmez-vous ?';
  }

  @override
  String get itemRowUnnamedProduct => 'Produit sans nom';

  @override
  String get itemRowDefaultVariant => 'Variante par défaut';

  @override
  String get itemRowUnnamed => 'Sans nom';

  @override
  String itemRowStockLeft(String quantity) {
    return '$quantity restant(s)';
  }

  @override
  String get itemRowDecreaseQuantity => 'Diminuer la quantité';

  @override
  String get itemRowIncreaseQuantity => 'Augmenter la quantité';

  @override
  String get itemRowNoImage => 'Pas d\'image';

  @override
  String get itemRowCannotDeleteWithStock =>
      'Impossible de supprimer une variante qui a du stock.';

  @override
  String get txDetailExpense => 'Dépense';

  @override
  String get txDetailIncome => 'Revenu';

  @override
  String get txDetailProducts => 'Produits';

  @override
  String get txDetailTimeline => 'Historique de la transaction';

  @override
  String txDetailEventCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count événements',
      one: '1 événement',
    );
    return '$_temp0';
  }

  @override
  String get txDetailExpenseRecorded => 'Dépense enregistrée';

  @override
  String get txDetailIncomeReceived => 'Revenu reçu';

  @override
  String get txDetailMoreActions => 'Plus d\'actions';

  @override
  String get txDetailCreatedPrefix => 'Créée le ';

  @override
  String txDetailAmountRefunded(String amount) {
    return '$amount remboursés';
  }

  @override
  String get txDetailFullyRefunded => 'Entièrement remboursé au client';

  @override
  String txDetailRefundVia(String reason, String method) {
    return '$reason · via $method';
  }

  @override
  String get txDetailMethod => 'Moyen';

  @override
  String get txDetailReference => 'Référence';

  @override
  String get txDetailNoLineItems => 'Aucun article pour cette transaction.';

  @override
  String get txDetailNoTimelineEvents => 'Aucun événement pour le moment.';

  @override
  String get txDetailStatusPartiallyRefunded => 'PARTIELLEMENT REMBOURSÉ';

  @override
  String get txDetailStatusRefunded => 'REMBOURSÉ';

  @override
  String get txDetailStatusPending => 'EN ATTENTE';

  @override
  String get txDetailStatusCompleted => 'TERMINÉ';

  @override
  String get txDetailStatusParked => 'EN ATTENTE (TICKET)';

  @override
  String get txDetailPartiallyRefunded => 'Partiellement remboursé';

  @override
  String get txDetailRefund => 'Remboursement';

  @override
  String get txDetailPaymentReceived => 'Paiement reçu';

  @override
  String get txDetailPaymentPending => 'Paiement en attente';

  @override
  String get txDetailSaleCreated => 'Vente créée';

  @override
  String txDetailPaymentLine(String method) {
    return 'Paiement : $method';
  }

  @override
  String get txListSelectDateRange => 'Sélectionnez une période';

  @override
  String get txListSelectDateRangeFirst =>
      'Veuillez d\'abord sélectionner une période';

  @override
  String get txListNoDataToExport =>
      'Aucune donnée à exporter. Attendez le chargement des données.';

  @override
  String get txListReportStillLoading =>
      'Les données du rapport sont en cours de chargement. Réessayez dans un instant.';

  @override
  String txListExportFailed(String error) {
    return 'Échec de l\'export : $error';
  }

  @override
  String txListRefreshFailed(String error) {
    return 'Échec de l\'actualisation : $error';
  }

  @override
  String txListReportFailed(String error) {
    return 'Échec du rapport : $error';
  }

  @override
  String get txListChangeDate => 'Changer la date';

  @override
  String get txListZReport => 'Rapport Z';

  @override
  String get txListXReport => 'Rapport X';

  @override
  String get txListSaleReport => 'Rapport des ventes';

  @override
  String get txListPluReport => 'Rapport PLU';

  @override
  String get txListAllStatuses => 'Tous les statuts';

  @override
  String get txListAllTypes => 'Tous les types';

  @override
  String get txListAllPayments => 'Tous les paiements';

  @override
  String get txListByHand => 'En main propre';

  @override
  String get txListSearchReceipt => 'Rechercher un numéro de reçu...';

  @override
  String get txListCashierHeading => 'CAISSIER';

  @override
  String get txListAll => 'Tous';

  @override
  String get txListRefreshTooltip =>
      'Actualiser — récupérer les données récentes des appareils voisins ou du serveur';

  @override
  String get txListSummarized => 'Résumé';

  @override
  String get txListDetailed => 'Détaillé';

  @override
  String get txListNoTransactions =>
      'Aucune transaction trouvée pour la période sélectionnée.';

  @override
  String get txListPreparingReports => 'Préparation de vos rapports...';

  @override
  String get txListMightTakeMoment =>
      'Cela peut prendre un moment selon vos données';

  @override
  String get txListSomethingWentWrong => 'Oups ! Une erreur s\'est produite';

  @override
  String get dashViewToday => 'Aujourd\'hui';

  @override
  String get dashViewThisWeek => 'Cette semaine';

  @override
  String get dashViewThisMonth => 'Ce mois-ci';

  @override
  String get dashViewThisYear => 'Cette année';

  @override
  String get dashViewNetProfit => 'Bénéfice net';

  @override
  String get dashViewGrossProfit => 'Bénéfice brut';

  @override
  String get dashViewFromYegobox => 'PAR YEGOBOX';

  @override
  String dashViewTodaysGoal(String count, String target) {
    return 'Objectif du jour · $count ventes sur $target';
  }

  @override
  String get dashViewLogFirstSale =>
      'Enregistrez votre première vente pour commencer à gagner';

  @override
  String get dashViewGoalReached => 'Objectif atteint ! ';

  @override
  String dashViewJustMoreTo(String remaining) {
    return 'Plus que $remaining pour gagner ';
  }

  @override
  String get dashViewPlusPoints => '+50 pts';

  @override
  String get dashViewStockValue => 'Valeur du stock';

  @override
  String dashViewItemsLowOnStock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles en stock faible',
      one: '1 article en stock faible',
    );
    return '$_temp0';
  }

  @override
  String get dashViewFullReport => 'Rapport complet ›';

  @override
  String get dashViewDataIncomplete =>
      'Les données peuvent être incomplètes (synchronisation partielle).';

  @override
  String get dashViewUnableToLoadStock =>
      'Impossible de charger la valeur du stock.';

  @override
  String get dashViewRevenue => 'Chiffre d\'affaires';

  @override
  String get dashViewExpenses => 'Dépenses';

  @override
  String dashViewDeltaUp(String percent) {
    return '+$percent %';
  }

  @override
  String dashViewDeltaDown(String percent) {
    return '-$percent %';
  }

  @override
  String get transactionsExportNotReady =>
      'L\'export n\'est pas encore prêt. Réessayez dans un instant.';

  @override
  String get transactionsNoLineItemsToExport =>
      'Aucun article à exporter pour cette période.';

  @override
  String get transactionsFilter => 'Filtrer les transactions';

  @override
  String get transactionsExportDetailed =>
      'Exporter le rapport détaillé (Excel)';

  @override
  String get transactionsTitle => 'Transactions';

  @override
  String transactionsNoRecordsFor(String period) {
    return 'Aucun enregistrement pour : $period';
  }

  @override
  String get transactionsTryDifferentPeriod =>
      'Essayez une autre période ou ajoutez des transactions.';

  @override
  String get transactionsLoading => 'Chargement des transactions...';

  @override
  String get transactionsSomethingWentWrong => 'Une erreur s\'est produite';

  @override
  String previewSaleCollectAmount(String amount) {
    return 'Encaisser $amount';
  }

  @override
  String previewSaleOrderAmount(String amount) {
    return 'Commander $amount';
  }

  @override
  String get previewSaleCartEmpty => 'Votre panier est vide';

  @override
  String get previewSaleDiscounts => 'Remises';

  @override
  String get importStatusAll => 'Tous';

  @override
  String get importStatusWaiting => 'En attente';

  @override
  String get importStatusRejected => 'Rejeté';

  @override
  String get importSaveChanges => 'Enregistrer les modifications';

  @override
  String get importAcceptAll => 'Tout accepter';

  @override
  String get importFilterByStatus => 'Filtrer par statut';

  @override
  String get importEnterName => 'Saisissez un nom';

  @override
  String get importEnterSupplyPrice => 'Saisissez le prix fournisseur';

  @override
  String get importSupplyPriceRequired => 'Le prix fournisseur est obligatoire';

  @override
  String get importEnterRetailPrice => 'Saisissez le prix de vente';

  @override
  String get importRetailPriceRequired => 'Le prix de vente est obligatoire';

  @override
  String get paymentSettingsTitle => 'Paramètres de paiement';

  @override
  String get paymentSettingsEnabled => 'Activé';

  @override
  String get paymentSettingsDisabled => 'Désactivé';

  @override
  String get mposWalkIn => 'Client de passage';

  @override
  String get mposSaleComplete => 'Vente terminée';

  @override
  String get mposNewSale => 'Nouvelle vente';

  @override
  String get mposPrintReceipt => 'Imprimer le reçu';

  @override
  String get mposTotalPaid => 'Total payé';

  @override
  String get mposTendered => 'Remis';

  @override
  String get mposChange => 'Monnaie';

  @override
  String get settingsManageBusiness =>
      'Gérez les paramètres de votre entreprise';

  @override
  String get gaugeGrossProfit => 'Bénéfice brut';

  @override
  String get gaugeNetProfit => 'Bénéfice net';

  @override
  String get gaugeTaxAndExpenses => 'Taxes et dépenses';

  @override
  String get gaugeLoss => 'Perte';

  @override
  String get gaugeBalanced => 'Équilibré';

  @override
  String get gaugeNoTransactions => 'Aucune transaction';

  @override
  String get dashboardGaugeGrossProfit => 'Bénéfice brut';

  @override
  String get dashboardGaugeTaxExpenses => 'Taxes et dépenses';

  @override
  String get dashboardGaugeNoTransactionsYet =>
      'Aucune transaction pour l\'instant';

  @override
  String dashboardGaugeGrossProfitPeriod(String period) {
    return 'Bénéfice brut · $period';
  }

  @override
  String dashboardGaugeNetProfitPeriod(String period) {
    return 'Bénéfice net · $period';
  }

  @override
  String dashboardGaugeDeltaVs(String percent, String comparison) {
    return '$percent % vs $comparison';
  }

  @override
  String get dashboardGaugeLastPeriod => 'période précédente';

  @override
  String get dashboardAppPointOfSale => 'Point de vente';

  @override
  String get dashboardAppCashBook => 'Livre de caisse';

  @override
  String get dashboardAppTransactions => 'Transactions';

  @override
  String get dashboardAppContacts => 'Contacts';

  @override
  String get dashboardAppCommission => 'Commission';

  @override
  String get dashboardAppSupport => 'Assistance';

  @override
  String get dashboardAppCredits => 'Crédits';

  @override
  String get dashboardAppOrders => 'Commandes';

  @override
  String get dashboardAppFinance => 'Finances';

  @override
  String get dashboardAppBooks => 'Comptabilité';

  @override
  String get dashboardAppStockRecount => 'Recomptage du stock';

  @override
  String get dashboardAppTransfersReport => 'Rapport des transferts';

  @override
  String get dashboardAppBranchOrders => 'Commandes des succursales';

  @override
  String get dashboardQuickAccess => 'ACCÈS RAPIDE';

  @override
  String get dashboardSeeAll => 'Tout voir';

  @override
  String get dashboardShortcutUnsupported =>
      'Les raccourcis épinglés ne sont pas pris en charge sur cet appareil.';

  @override
  String dashboardShortcutAddPrompt(String label) {
    return 'Ajoutez « $label » à votre écran d\'accueil lorsque vous y êtes invité.';
  }

  @override
  String get dashboardShortcutLauncherUnsupported =>
      'Votre lanceur ne prend pas en charge les raccourcis épinglés.';

  @override
  String get dashboardShortcutFailed => 'Impossible de créer le raccourci.';

  @override
  String get dashboardAllAppsYourBusiness => 'votre entreprise';

  @override
  String dashboardAllAppsEverythingIn(String name) {
    return 'Tout dans $name';
  }

  @override
  String appLaunchOpening(String app) {
    return 'Ouverture de $app';
  }

  @override
  String get appLaunchSyncingSlow =>
      'Synchronisation de votre entreprise — cela peut prendre un moment avec une connexion lente.';

  @override
  String get cashbookCategorySheetSaveFailed =>
      'Impossible d\'enregistrer cette catégorie. Vérifiez votre connexion et réessayez.';

  @override
  String get cashbookCategorySheetQuickPicks => 'SUGGESTIONS';

  @override
  String get cashbookCategorySheetTitle => 'Nouvelle catégorie';

  @override
  String get cashbookCategorySheetIncomeSubtitle =>
      'Regroupez l\'argent qui entre';

  @override
  String get cashbookCategorySheetExpenseSubtitle =>
      'Regroupez l\'argent qui sort';

  @override
  String get cashbookCategorySheetNameLabel => 'Nom de la catégorie';

  @override
  String cashbookCategorySheetExampleHint(String example) {
    return 'ex. $example';
  }

  @override
  String get cashbookCategorySheetTypeName => 'Saisissez un nom';

  @override
  String cashbookCategorySheetAlreadyExists(String name) {
    return '« $name » existe déjà. Nous l\'utiliserons.';
  }

  @override
  String get cashbookCategorySheetUseExisting =>
      'Utiliser la catégorie existante';

  @override
  String get cashbookCategorySheetCreate => 'Créer la catégorie';

  @override
  String get checkoutRecoveryLeaveQuestion => 'Quitter le paiement ?';

  @override
  String get checkoutRecoveryCheckout => 'Paiement';

  @override
  String get checkoutRecoverySale => 'Vente';

  @override
  String get checkoutRecoveryActionNeeded => 'ACTION REQUISE';

  @override
  String get checkoutRecoveryUnavailable => 'PAIEMENT INDISPONIBLE';

  @override
  String get checkoutRecoveryNoBranchHeadline =>
      'Aucune succursale sélectionnée';

  @override
  String get checkoutRecoveryLoadFailedHeadline =>
      'Impossible de charger le paiement';

  @override
  String get checkoutRecoveryNoBranchBody =>
      'Le paiement nécessite une succursale pour charger les produits et enregistrer la vente. Choisissez une succursale pour continuer.';

  @override
  String get checkoutRecoveryLoadFailedBody =>
      'Un problème est survenu à l\'ouverture du paiement. Réessayez ou contactez l\'assistance si le problème persiste.';

  @override
  String get checkoutRecoveryWhatHappened => 'Ce qui s\'est passé';

  @override
  String get checkoutRecoveryNoLocationDiagnostic =>
      'le paiement n\'a pas pu déterminer d\'emplacement pour cet appareil.';

  @override
  String get checkoutRecoverySelectBranch => 'Sélectionnez une succursale';

  @override
  String get checkoutRecoveryChooseWhere => 'Choisissez où cette vente a lieu';

  @override
  String get checkoutRecoveryStillStuck => 'Toujours bloqué ?';

  @override
  String get checkoutRecoveryGetHelp => 'Obtenir de l\'aide';

  @override
  String get checkoutRecoveryLoading => 'Chargement du paiement…';

  @override
  String get checkoutRecoveryBranch => 'Succursale';

  @override
  String get checkoutRecoveryReady => 'Paiement prêt';

  @override
  String get checkoutRecoveryReadyBody =>
      'Vous êtes prêt à encaisser. Les articles et les totaux seront synchronisés avec cette succursale.';

  @override
  String get checkoutRecoveryOpenCheckout => 'Ouvrir le paiement';

  @override
  String get checkoutRecoveryStillNoBranch =>
      'Toujours aucune succursale sélectionnée — choisissez-en une pour continuer.';

  @override
  String get checkoutRecoveryWhereQuestion => 'Où cette vente a-t-elle lieu ?';

  @override
  String get checkoutRecoverySetDefaultBranch =>
      'Définir comme succursale par défaut pour cet appareil';

  @override
  String get checkoutRecoveryChooseBranch => 'Choisissez une succursale';

  @override
  String get checkoutRecoveryContinue => 'Continuer vers le paiement';

  @override
  String get checkoutRecoveryChecking => 'Vérification…';

  @override
  String get checkoutRecoveryTryAgain => 'Réessayer';

  @override
  String get checkoutRecoveryBranchLocation => 'Emplacement de la succursale';

  @override
  String get checkoutRecoveryHqBadge => 'SIÈGE';

  @override
  String checkoutTransferToBranch(String branch) {
    return 'Transférer vers $branch';
  }

  @override
  String get checkoutTransferNoItemsSelected => 'Aucun article sélectionné';

  @override
  String get checkoutTransferToBranchLabel => 'Vers la succursale';

  @override
  String get checkoutTransferNoOtherBranches => 'Aucune autre succursale';

  @override
  String get checkoutTransferSelectBranch => 'Choisir une succursale';

  @override
  String get checkoutTransferLoadBranchesFailed =>
      'Échec du chargement des succursales';

  @override
  String get peersNetworkStatus => 'État du réseau';

  @override
  String get peersThisDeviceOnly =>
      'Cet appareil uniquement — aucun pair sur le réseau maillé pour l\'instant.';

  @override
  String peersSyncedWith(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Synchronisé avec $count pairs sur le réseau maillé.',
      one: 'Synchronisé avec 1 pair sur le réseau maillé.',
    );
    return '$_temp0';
  }

  @override
  String get peersLocalDevice => 'Appareil local';

  @override
  String get peersOnline => 'En ligne';

  @override
  String get peersConnectedPeers => 'Pairs connectés';

  @override
  String get peersSyncNotInitialized =>
      'Service de synchronisation non initialisé';

  @override
  String peersConnectedTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Connecté à $count appareils. Touchez pour voir les détails.',
      one: 'Connecté à 1 appareil. Touchez pour voir les détails.',
    );
    return '$_temp0';
  }

  @override
  String get peersSearching => 'Recherche d\'appareils sur le même réseau...';

  @override
  String get peersLive => 'En direct';

  @override
  String get peersNetworkCheckError => 'Erreur de vérification du réseau';

  @override
  String get peersNoOtherDevices => 'Aucun autre appareil trouvé';

  @override
  String get peersOpenFlipperHint =>
      'Ouvrez Flipper sur un autre appareil du même réseau.';

  @override
  String get saleModeNormal => 'Vente normale';

  @override
  String get saleModeProforma => 'Proforma';

  @override
  String get saleModeTraining => 'Formation';

  @override
  String get saleModeTitle => 'Mode de vente';

  @override
  String get saleModeDescription =>
      'Le type de reçu sous lequel les nouvelles ventes sont émises. Laissez Vente normale sauf si vous vous entraînez ou faites un devis.';

  @override
  String get saleModeNormalSubtitle =>
      'Ventes réelles et fiscales. Par défaut.';

  @override
  String get saleModeProformaSubtitle =>
      'Devis. Pas un reçu, aucun mouvement de stock.';

  @override
  String get saleModeTrainingSubtitle =>
      'Ventes d\'entraînement. Les reçus de formation ne peuvent être ni partagés ni imprimés.';

  @override
  String get mposCartEmptyHint => 'Touchez un produit pour commencer une vente';

  @override
  String get mposCartReviewPay => 'Vérifier et payer';

  @override
  String get mposCartLabel => 'Panier';

  @override
  String mposCartSummary(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles, RWF $total',
      one: '1 article, RWF $total',
    );
    return '$_temp0';
  }

  @override
  String mposCartItemsInCart(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles dans le panier',
      one: '1 article dans le panier',
    );
    return '$_temp0';
  }

  @override
  String get mposDismiss => 'Fermer';

  @override
  String get mposBackFromCheckout => 'Retour depuis le paiement';

  @override
  String get mposScan => 'Scanner';

  @override
  String get mposRemovingCustomer => 'Retrait du client…';

  @override
  String get mposAttachCustomer => 'Associer un client';

  @override
  String get mposWalkInCustomer => 'Client de passage';

  @override
  String get mposAttachCustomerHint =>
      'Touchez pour associer un client (facultatif)';

  @override
  String get mposRemoveCustomer => 'Retirer le client';

  @override
  String mposCustomerAttachedToSale(String name) {
    return '$name associé à cette vente';
  }

  @override
  String mposCouldNotAttachCustomer(String error) {
    return 'Impossible d\'associer le client : $error';
  }

  @override
  String get mposSearchNameOrPhone => 'Rechercher un nom ou un téléphone';

  @override
  String get mposContinueAsWalkIn => 'Continuer sans client';

  @override
  String get mposNoCustomerOnSale => 'Aucun client pour cette vente';

  @override
  String get mposAddNewCustomer => 'Ajouter un nouveau client';

  @override
  String mposItemQtyAtPrice(String qty, String price) {
    return '$qty à RWF $price';
  }

  @override
  String get mposDoneEditingPrice => 'Modification du prix terminée';

  @override
  String get mposEditPrice => 'Modifier le prix';

  @override
  String mposDeleteItem(String name) {
    return 'Supprimer $name';
  }

  @override
  String get mposUnitPrice => 'Prix unitaire';

  @override
  String mposUnitPriceWithDefault(String price) {
    return 'Prix unitaire · par défaut RWF $price';
  }

  @override
  String mposUnitPriceFor(String name) {
    return 'Prix unitaire de $name';
  }

  @override
  String mposResetPriceFor(String name) {
    return 'Réinitialiser le prix de $name';
  }

  @override
  String get mposDecreaseQuantity => 'Diminuer la quantité';

  @override
  String get mposIncreaseQuantity => 'Augmenter la quantité';

  @override
  String get mposMomoPhoneNumber => 'Numéro MoMo';

  @override
  String get mposCashReceivedAmount => 'Montant en espèces reçu';

  @override
  String mposCreditAmount(String amount) {
    return 'Montant à crédit · $amount';
  }

  @override
  String get mposCreditExplanation =>
      'Cette vente est enregistrée sur le solde de crédit du client. Associez un client avant de terminer.';

  @override
  String mposPaymentLinesSplitHint(int count) {
    return '$count lignes de paiement · utilisez le fractionnement en mode bureau';
  }

  @override
  String get mposTax => 'Taxe';

  @override
  String get mposTotal => 'Total';

  @override
  String get mposAlreadyPaid => 'Déjà payé';

  @override
  String get mposThisPayment => 'Ce paiement';

  @override
  String get mposBalanceDue => 'Solde dû';

  @override
  String get posCartLineSubtotal => 'Sous-total de la ligne';

  @override
  String get posCartEditQtyPrice => 'Modifier qté/prix';

  @override
  String get posCartHideDetails => 'Masquer les détails';

  @override
  String get posCartRemoveLine => 'Supprimer la ligne';

  @override
  String get posScanMode => 'Mode scan';

  @override
  String get posSendToTillNeedsCustomer =>
      'Enregistrez un nom ou un numéro de téléphone client sur ce ticket avant de l\'envoyer à la caisse.';

  @override
  String get posPreparingCheckout => 'Préparation du paiement...';

  @override
  String get posShiftLoadFailed => 'Impossible de charger l\'état du service';

  @override
  String get posShiftStartToSell => 'Ouvrez un service pour vendre';

  @override
  String get posShiftStartHint =>
      'Ouvrez votre service de caisse avant d\'enregistrer des ventes. Vous pouvez aussi ouvrir un service depuis la barre latérale.';

  @override
  String get salesByCashierTitle => 'VENTES PAR CAISSIER';

  @override
  String get salesByCashierByHand => 'En main';

  @override
  String get startupTagline => 'Un logiciel de gestion révolutionnaire...';

  @override
  String get startupProgressLabel => 'Progression du démarrage';

  @override
  String get startupReady => 'Prêt';

  @override
  String get startupFinishingUp => 'Finalisation';

  @override
  String get startupConfirmingPlan => 'Confirmation de votre abonnement';

  @override
  String get startupSyncingData => 'Synchronisation de vos données';

  @override
  String get startupStartingServices => 'Démarrage des services';

  @override
  String get startupCheckingWorkspace =>
      'Vérification de votre espace de travail';

  @override
  String get startupConnecting => 'Connexion';

  @override
  String get topBarNotifications => 'Notifications';

  @override
  String get userInfoLoading => 'Chargement...';

  @override
  String get userInfoFallbackName => 'Utilisateur';

  @override
  String get userInfoSwitchBranch => 'Changer de succursale';

  @override
  String get userInfoSwitchUser => 'Changer d\'utilisateur';

  @override
  String get variantDropdownBranchNotSelected =>
      'Aucune succursale sélectionnée. Veuillez en choisir une.';

  @override
  String get variantDropdownNoVariantsHint =>
      'Aucune variante disponible. Veuillez d\'abord créer des variantes.';

  @override
  String get variantDropdownNoVariants => 'Aucune variante';

  @override
  String get variantDropdownSelect => 'Choisir une variante';

  @override
  String get variantDropdownSearch => 'Rechercher des variantes...';

  @override
  String get variantDropdownLoadError => 'Erreur de chargement des variantes';

  @override
  String get variantImageSaveProductFirst =>
      'Enregistrez le produit et réessayez';

  @override
  String get variantImageUploadFailed =>
      'Impossible de téléverser l\'image. Veuillez réessayer.';

  @override
  String get variantImageChange => 'Changer l\'image de la variante';

  @override
  String get variantImageAdd => 'Ajouter une image à la variante';

  @override
  String get waOptInScanTitle => 'Scannez pour recevoir le reçu';

  @override
  String get waOptInSubtitle =>
      'Le client doit écrire une fois à votre numéro WhatsApp Business pour que nous puissions lui envoyer son reçu numérique.';

  @override
  String get waOptInScanHint =>
      'Ouvrez WhatsApp → scannez avec l\'appareil photo';

  @override
  String get waOptInQueued =>
      'Le reçu est en file d\'attente. Demandez au client d\'écrire à votre numéro WhatsApp Business ; le PDF sera ensuite envoyé automatiquement.';

  @override
  String get waOptInLinkCopied => 'Lien WhatsApp copié';

  @override
  String get waOptInCopy => 'Copier';

  @override
  String waOptInReceiptPhone(String phone) {
    return 'Téléphone du reçu : $phone';
  }

  @override
  String get kpiTotalSales => 'Ventes totales';

  @override
  String get kpiCollected => 'Encaissé';

  @override
  String get kpiOwed => 'Dû';

  @override
  String get printDelegationNoDevicesLoaded =>
      'Aucun appareil chargé pour cette succursale. Vérifiez que les autres ordinateurs sont connectés et en ligne, puis rouvrez cet écran.';

  @override
  String get printDelegationOnlyThisDesktop =>
      'Seul cet ordinateur est enregistré dans cette succursale. Connectez-vous sur un autre poste Windows, macOS ou Linux pour lui déléguer l\'impression.';

  @override
  String get printDelegationNoDesktops =>
      'D\'autres appareils existent dans cette succursale, mais aucun n\'est un ordinateur (device_name doit être windows, macos ou linux).';

  @override
  String get printDelegationNoOtherDesktops =>
      'Aucun autre ordinateur trouvé dans cette succursale';

  @override
  String get printDelegationDeviceNameSaved => 'Nom de l\'appareil enregistré';

  @override
  String printDelegationDeviceNameSaveFailed(String error) {
    return 'Impossible d\'enregistrer le nom de l\'appareil : $error';
  }

  @override
  String get printDelegationDeviceSelected =>
      'Appareil de délégation sélectionné';

  @override
  String printDelegationSelectDeviceError(String error) {
    return 'Erreur lors de la sélection de l\'appareil : $error';
  }

  @override
  String get printDelegationEnabled => 'Délégation d\'impression activée';

  @override
  String get printDelegationDisabled => 'Délégation d\'impression désactivée';

  @override
  String get printDelegationTitle => 'Délégation d\'impression';

  @override
  String get printDelegationMobileDescription =>
      'Déléguer l\'impression des reçus à un ordinateur lorsque le serveur EBM est indisponible';

  @override
  String get printDelegationDesktopDescription =>
      'Traiter les reçus délégués par les appareils mobiles, ou déléguer l\'impression à un autre ordinateur';

  @override
  String get printDelegationGenericDescription =>
      'Traitement des transactions entre appareils';

  @override
  String get printDelegationThisDevice =>
      'Cet appareil (reçoit les délégations)';

  @override
  String get printDelegationThisDeviceHint =>
      'Les autres POS doivent cibler cet ID dans leurs paramètres de délégation. Cet appareil n\'apparaît pas dans la liste ci-dessous, car vous ne pouvez pas vous déléguer l\'impression.';

  @override
  String get printDelegationDeviceIdMissing =>
      'ID de l\'appareil pas encore enregistré — redémarrez l\'application ou reconnectez-vous.';

  @override
  String printDelegationDeviceName(String name) {
    return 'Nom de l\'appareil : $name';
  }

  @override
  String get printDelegationFriendlyName =>
      'Nom convivial (visible par les autres appareils)';

  @override
  String get printDelegationFriendlyNameHint => 'ex. Imprimante du comptoir';

  @override
  String get printDelegationMobileTargetHint =>
      'Sélectionnez l\'ordinateur d\'impression ci-dessous. Sur cet ordinateur, ouvrez Gestion → Délégation d\'impression et copiez l\'ID complet « Cet appareil » — il doit correspondre à votre sélection ici.';

  @override
  String get printDelegationDelegateToDesktop =>
      'Déléguer l\'impression à un autre ordinateur';

  @override
  String printDelegationPlatform(String platform) {
    return 'Plateforme : $platform';
  }

  @override
  String printDelegationPhone(String phone) {
    return 'Téléphone : $phone';
  }

  @override
  String printDelegationLoadDevicesError(String error) {
    return 'Erreur de chargement des appareils : $error';
  }

  @override
  String get printDelegationHowItWorks => 'Fonctionnement';

  @override
  String get printDelegationMobileStep1 =>
      'Le mobile termine la transaction mais délègue la génération du reçu';

  @override
  String get printDelegationMobileStep2 =>
      'L\'ordinateur récupère la transaction via la synchronisation';

  @override
  String get printDelegationMobileStep3 =>
      'L\'ordinateur génère le reçu et communique avec le serveur EBM';

  @override
  String get printDelegationMobileStep4 =>
      'Le mobile est averti une fois le traitement terminé';

  @override
  String get printDelegationDesktopStep1 =>
      'L\'ordinateur surveille les transactions déléguées en temps réel';

  @override
  String get printDelegationDesktopStep2 =>
      'Traite automatiquement les reçus des appareils mobiles';

  @override
  String get printDelegationDesktopStep3 =>
      'Choisissez éventuellement un autre ordinateur ci-dessous pour lui déléguer l\'impression de cet appareil';

  @override
  String get printDelegationDesktopStep4 =>
      'Gère la communication avec le serveur EBM';

  @override
  String get printDelegationDesktopStep5 =>
      'Renvoie les résultats au mobile via la synchronisation';

  @override
  String printDelegationCopiedDeviceId(String id) {
    return 'ID de l\'appareil copié : $id';
  }

  @override
  String get printDelegationCopyDeviceId => 'Copier l\'ID de l\'appareil';

  @override
  String get refundReasonDuplicate => 'Paiement en double';

  @override
  String get refundReasonOther => 'Autre';

  @override
  String get refundAlreadyRefunded => 'Déjà remboursé';

  @override
  String get refundPaymentTitle => 'Rembourser le paiement';

  @override
  String get refundIncomeRefunded => 'Ce revenu a été remboursé';

  @override
  String get refundReturnMoney => 'Rendre l\'argent au client';

  @override
  String get refundMoreActions => 'Plus d\'actions';

  @override
  String refundIncomeReference(String reference) {
    return 'Revenu · $reference';
  }

  @override
  String get refundShareReceipt => 'Partager le reçu';

  @override
  String get refundShareReceiptSubtitle =>
      'Envoyer par WhatsApp, SMS ou e-mail';

  @override
  String get refundShareCopySubtitle =>
      'Envoyer une copie de la vente par WhatsApp, SMS ou e-mail';

  @override
  String get refundDownloadPdf => 'Télécharger le PDF';

  @override
  String get refundDownloadReceiptSubtitle =>
      'Enregistrer une copie de ce reçu';

  @override
  String get refundDownloadCopySubtitle =>
      'Enregistrer cette vente en copie PDF';

  @override
  String get refundPrintSubtitle => 'Envoyer à une imprimante connectée';

  @override
  String refundReturnMoneyFor(String reference) {
    return 'Rembourser $reference';
  }

  @override
  String get refundHowMuch => 'Combien ?';

  @override
  String get refundFull => 'Remboursement total';

  @override
  String get refundPartial => 'Partiel';

  @override
  String get refundChooseAmount => 'Choisir le montant';

  @override
  String refundCannotExceed(String amount) {
    return 'Ne peut pas dépasser le montant initial de $amount';
  }

  @override
  String refundUpToAvailable(String amount) {
    return 'Jusqu\'à $amount remboursables';
  }

  @override
  String get refundReasonLabel => 'Motif';

  @override
  String get refundTo => 'Rembourser via';

  @override
  String get refundHandBackNow => 'Rendre maintenant';

  @override
  String get refundSendToPhone => 'Envoyer au téléphone';

  @override
  String refundAmountButton(String amount) {
    return 'Rembourser $amount';
  }

  @override
  String get refundOriginalPayment => 'Paiement initial';

  @override
  String get refundProcessing => 'Remboursement en cours…';

  @override
  String get refundStepValidating => 'Validation du remboursement';

  @override
  String get refundStepRestoringStock => 'Restauration du stock';

  @override
  String get refundStepSavingRecords => 'Enregistrement des données';

  @override
  String get refundMethodCashLower => 'espèces';

  @override
  String get refundCompleted => 'Remboursement effectué';

  @override
  String refundDoneSuffix(String method) {
    return 'a été remboursé au client via $method.';
  }

  @override
  String get refundSheetUnavailable => 'Remboursement indisponible';

  @override
  String get internetRequiredTitle => 'Connexion Internet requise';

  @override
  String get internetRequiredBody =>
      'Vous devez vous connecter à Internet pour continuer à utiliser Flipper. Notre système nécessite une connexion Internet tous les 5 jours pour vérifier votre compte.';

  @override
  String get internetRequiredCheck => 'Vérifier la connexion';

  @override
  String get internetRequiredHint =>
      'Si cet écran s\'affiche toujours, vérifiez votre connexion Internet et réessayez.';

  @override
  String get addCustomerOpening => 'Ouverture…';

  @override
  String get mposStatusPending => 'En attente';

  @override
  String get mposStatusCompleted => 'Terminée';

  @override
  String get mposStatusPaid => 'Payée';

  @override
  String get mposStatusCancelled => 'Annulée';

  @override
  String get mposStatusParked => 'En attente de paiement';

  @override
  String get mposPriceEdited => 'modifié';

  @override
  String get balancesExpenses => 'Dépenses';

  @override
  String adminChannelNumber(String number) {
    return 'Canal $number';
  }

  @override
  String get adminInvalidSmsPhone =>
      'Saisissez un numéro de téléphone valide avec l\'indicatif du pays (ex. +250783054874)';

  @override
  String get adminSmsConfigUpdateFailed =>
      'Échec de la mise à jour de la configuration SMS';

  @override
  String get transactionReportsTitle => 'Rapports des transactions';

  @override
  String get productNewCategory => 'Nouvelle catégorie';

  @override
  String get productCategoryDescription =>
      'Une catégorie regroupe des produits similaires.';

  @override
  String get productCategoryName => 'Nom de la catégorie';

  @override
  String get productCategoryNameHint =>
      'ex. Boissons, Pain, Crédit téléphonique';

  @override
  String get productCategoryNameTooShort => 'Saisissez au moins 2 caractères.';

  @override
  String get productCategoryCreateFailed =>
      'Impossible de créer la catégorie. Veuillez réessayer.';

  @override
  String productCategoryAlreadyExists(String name) {
    return '« $name » existe déjà.';
  }

  @override
  String productCategoryUseExisting(String name) {
    return 'Utiliser « $name »';
  }

  @override
  String get productCreateCategory => 'Créer la catégorie';

  @override
  String get serviceModeBarMode => 'Mode bar';

  @override
  String get serviceModeHotelMode => 'Mode hôtel';

  @override
  String get serviceModeBarCounter => 'Comptoir du bar';

  @override
  String get serviceModeFrontDesk => 'Réception';

  @override
  String get serviceModeAdminOnly =>
      'Seul un administrateur peut changer le mode de service de cet appareil.';

  @override
  String serviceModeSwitchNotSaved(String mode) {
    return 'Impossible de passer en $mode : les paramètres de la succursale n\'ont pas été enregistrés. Vérifiez votre connexion et réessayez.';
  }

  @override
  String serviceModeSwitched(String mode, String hotkey) {
    return 'Cet appareil est passé en $mode · $hotkey pour changer';
  }

  @override
  String get serviceModeSwitchFailed =>
      'Impossible de changer le mode de service.';

  @override
  String serviceModeDeviceNowRuns(String mode) {
    return 'Cet appareil utilise désormais : $mode.';
  }

  @override
  String serviceModeDeviceFollowsBranch(String mode) {
    return 'Cet appareil suit de nouveau le réglage par défaut de la succursale ($mode).';
  }

  @override
  String get serviceModeThisDevice => 'Cet appareil';

  @override
  String get serviceModeWhatTerminalOpens => 'Ce que ce terminal ouvre';

  @override
  String get serviceModeBranchRunsBoth =>
      'Cette succursale utilise les deux. Mettez la réception sur le terminal d\'accueil et la salle sur le comptoir du bar — chaque appareil garde son propre choix.';

  @override
  String get serviceModePickAfterLogin =>
      'Choisissez ce que cet écran affiche après la connexion. Les autres appareils de cette succursale gardent leur propre choix.';

  @override
  String get serviceModePinnedOnDevice =>
      'Épinglé sur cet appareil uniquement.';

  @override
  String get serviceModeUseBranchDefault =>
      'Utiliser le réglage de la succursale';

  @override
  String get barRoomChargePickerSubtitle =>
      'La note est transférée sur le folio du client et réglée au départ.';

  @override
  String get barRoomChargeEmptyTab =>
      'Ajoutez un article à la note avant de la facturer à une chambre.';

  @override
  String barRoomChargeMoved(String table, String target, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return '$table → $target · $_temp0 sur le folio';
  }

  @override
  String get barTables => 'Tables';

  @override
  String barFloorOpenTapToLog(String count) {
    return '$count ouvertes · touchez pour saisir une commande';
  }

  @override
  String barFloorOpenTapTableToLog(String count) {
    return '$count ouvertes · touchez une table pour saisir sa commande';
  }

  @override
  String get barOpenTab => 'Note ouverte';

  @override
  String get barTableFree => 'Libre';

  @override
  String get barRoleServer => 'Serveur';

  @override
  String barCashierLogging(String role) {
    return '$role · en service';
  }

  @override
  String get barNoTablesConfigured => 'Aucune table configurée';

  @override
  String barZoneOpenCount(String open, String total) {
    return '$open/$total ouvertes';
  }

  @override
  String get barCouldNotLoadStaff => 'Impossible de charger le personnel';

  @override
  String get barModeSharedRegister => 'Mode bar · Caisse partagée';

  @override
  String get barWhosServing => 'Qui sert ?';

  @override
  String get barWhosOnRegister => 'Qui est à la caisse ?';

  @override
  String get barLockHintTapAbove =>
      'Touchez votre nom ci-dessus, puis saisissez votre PIN';

  @override
  String get barLockHintTapLeft =>
      'Touchez votre nom à gauche, puis saisissez votre PIN';

  @override
  String get barLockHintEnterPin =>
      'Saisissez votre PIN à 6 chiffres pour enregistrer des commandes';

  @override
  String get barConfiguredByAdmin =>
      'Mode bar configuré par l\'administrateur sur le terminal principal';

  @override
  String get barStaffFallback => 'Employé';

  @override
  String get barSaveToTab => 'Ajouter à la note';

  @override
  String barFreshTabFor(String table) {
    return 'Nouvelle note pour $table';
  }

  @override
  String get barTapProductFirstRound =>
      'Touchez un produit pour ajouter la première tournée';

  @override
  String get barTapProductsFirstRound =>
      'Touchez des produits pour ajouter la première tournée';

  @override
  String barLoggedByStaff(String count, String mine) {
    return 'Saisi par $count employés · vous en avez ajouté $mine';
  }

  @override
  String barYouLoggedLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vous avez saisi $count lignes sur cette note',
      one: 'Vous avez saisi 1 ligne sur cette note',
    );
    return '$_temp0';
  }

  @override
  String get barTabTotal => 'Total de la note';

  @override
  String barTabTotalItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return 'Total de la note · $_temp0';
  }

  @override
  String get barSettleAndClose => 'Régler et libérer la table';

  @override
  String get barSettleManagerPin => 'Régler · PIN du gérant';

  @override
  String get barChargeToRoom => 'Facturer à la chambre';

  @override
  String barPriceEach(String price) {
    return '$price l\'unité';
  }

  @override
  String get barHideDetails => 'Masquer les détails';

  @override
  String get barEditPriceQty => 'Modifier le prix et la quantité';

  @override
  String barTableMetaOpened(String seats, String time, String elapsed) {
    return '$seats places · ouverte à $time · $elapsed';
  }

  @override
  String barTableMetaOpenedBy(
    String seats,
    String time,
    String opener,
    String elapsed,
  ) {
    return '$seats places · ouverte à $time par $opener · $elapsed';
  }

  @override
  String barOpenedAtElapsed(String time, String elapsed) {
    return 'Ouverte à $time • $elapsed';
  }

  @override
  String get barSettleRoomChargeSubtitle =>
      'La note est transférée sur le folio du client et facturée au départ.';

  @override
  String get barSettleChooseMethod =>
      'Choisissez le mode et encaissez pour libérer la table.';

  @override
  String get barMobileMoney => 'Argent mobile';

  @override
  String get barPickGuestForBill =>
      'Choisissez le client dont le folio reprend cette note.';

  @override
  String barRoomChargeNoMoney(String target) {
    return 'Aucun paiement maintenant : ces lignes rejoignent $target et seront facturées au départ du client.';
  }

  @override
  String get barEnterAmountTendered => 'Saisir le montant reçu';

  @override
  String barAmountDue(String amount) {
    return '$amount à payer';
  }

  @override
  String get barMomoPushNotice =>
      'Une demande de paiement sera envoyée sur le téléphone du client.';

  @override
  String barChargeToRoomTotal(String amount) {
    return 'Facturer à la chambre — $amount';
  }

  @override
  String barChargeRoomTotal(String room, String amount) {
    return 'Facturer la chambre $room — $amount';
  }

  @override
  String barConfirmPaymentTotal(String amount) {
    return 'Confirmer le paiement — $amount';
  }

  @override
  String barChargeToRoomTotalShort(String amount) {
    return 'Facturer à la chambre · $amount';
  }

  @override
  String barChargeRoomTotalShort(String room, String amount) {
    return 'Facturer la chambre $room · $amount';
  }

  @override
  String barConfirmTotalShort(String amount) {
    return 'Confirmer · $amount';
  }

  @override
  String get barRoomChargeFootnote =>
      'La table est libérée ; le folio sera réglé à la réception.';

  @override
  String get barCloseTableFootnote =>
      'Clôturer la table enregistre la vente et la libère pour de nouveaux clients.';

  @override
  String get barInvalidReceiptPhone =>
      'Saisissez un numéro de téléphone valide à 9 chiffres pour le reçu.';

  @override
  String barSettledToast(String table, String amount, String method) {
    return '$table réglée · $amount $method';
  }

  @override
  String get barBackToTab => 'Retour à la note';

  @override
  String barSettleBillZone(String zone) {
    return 'Régler l\'addition · $zone';
  }

  @override
  String barSettleZone(String zone) {
    return 'Régler · $zone';
  }

  @override
  String get barSettlingAsManager => 'Règlement en tant que gérant';

  @override
  String barTableRunningTab(String table) {
    return 'Table $table — note en cours';
  }

  @override
  String barServerName(String name) {
    return '$name · Serveur';
  }

  @override
  String get barSubtotalExclVat => 'Sous-total (HT)';

  @override
  String get barVat18 => 'TVA 18 %';

  @override
  String get barTotalDue => 'Total à payer';

  @override
  String get barReceiptPhoneNumber => 'Téléphone pour le reçu *';

  @override
  String get barReceiptPhoneRequired =>
      'Obligatoire — imprimé sur le reçu RRA (TEL).';

  @override
  String get barInvalidMobileNumber =>
      'Saisissez un numéro mobile valide à 9 chiffres (ex. 783054874).';

  @override
  String get barUnnamedProduct => 'Produit sans nom';

  @override
  String get barNoProductsMatch =>
      'Aucun produit ne correspond à votre recherche';

  @override
  String get barRoomChargeTileSubtitle =>
      'Facturer un client hébergé chez nous';

  @override
  String get barChoose => 'Choisir';

  @override
  String get barChange => 'Modifier';

  @override
  String get barRunningTab => 'Note en cours';

  @override
  String barZoneItemCount(String zone, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return '$zone · $_temp0';
  }

  @override
  String get barBackToTables => 'Retour aux tables';

  @override
  String get barRemoveStaffTitle => 'Retirer un membre du personnel';

  @override
  String barRemoveStaffBody(String name) {
    return 'Retirer $name de votre équipe ? Cette personne perdra son accès PIN à cette entreprise.';
  }

  @override
  String get barThisStaffMember => 'ce membre du personnel';

  @override
  String get barStaffRemoved => 'Membre du personnel retiré';

  @override
  String get barStaffRemoveFailed =>
      'Impossible de retirer ce membre du personnel. Veuillez réessayer.';

  @override
  String get barModeAlongsideHotel =>
      'Mode bar activé en plus du mode hôtel — choisissez ci-dessous ce que cet appareil utilise.';

  @override
  String get barAdminServiceMode => 'Mode de service';

  @override
  String get barRequirePinTitle => 'Exiger un PIN pour changer de caissier';

  @override
  String get barRequirePinSubtitle =>
      'Chaque caissier se connecte avec son PIN à 6 chiffres avant d\'ajouter à une note.';

  @override
  String get barFloorFirstTitle => 'Ouvrir le plan de salle à la connexion';

  @override
  String get barFloorFirstSubtitle =>
      'Après la connexion par PIN, afficher le plan de salle au lieu d\'un panier unique.';

  @override
  String get barManagerSettleTitle => 'PIN responsable requis pour encaisser';

  @override
  String get barManagerSettleSubtitle =>
      'Seul un PIN responsable peut encaisser et clôturer une table.';

  @override
  String get barAutoLogoutTitle =>
      'Déconnexion auto après enregistrement sur une note';

  @override
  String get barAutoLogoutSubtitle =>
      'Revenir au verrou PIN après « Enregistrer sur la note ».';

  @override
  String get barAdminFloorTables => 'Salle et tables';

  @override
  String get barAdminStaffPins => 'Personnel et PIN';

  @override
  String get barNoStaffYet =>
      'Aucun personnel pour l\'instant. Ajoutez des utilisateurs dans la gestion des utilisateurs — ils apparaissent ici avec leur PIN.';

  @override
  String get barOpenPosWithBarMode => 'Ouvrir le POS en mode bar';

  @override
  String get barTableServiceTitle => 'Service à table (mode bar)';

  @override
  String barModeDescription(String hotkey) {
    return 'Transforme la caisse en terminal de bar partagé : le personnel tient une note ouverte par table, enregistre les tournées sous son propre PIN et passe le relais entre caissiers sans perdre l\'addition. Laissez désactivé pour l\'encaissement standard. Au clavier, $hotkey alterne Bar → Hôtel → POS sans revenir ici.';
  }

  @override
  String barCloseTabBeforeDeleting(String table) {
    return 'Clôturez la note ouverte de $table avant de la supprimer.';
  }

  @override
  String get barDeleteTableQuestion => 'Supprimer la table ?';

  @override
  String barRemoveTableBody(String table) {
    return 'Retirer $table du plan de salle ?';
  }

  @override
  String barCloseZoneTabsBeforeDeleting(String zone) {
    return 'Clôturez les notes ouvertes de $zone avant de supprimer la zone.';
  }

  @override
  String get barDeleteZoneQuestion => 'Supprimer la zone ?';

  @override
  String barRemoveZoneBody(String zone, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ses $count tables',
      one: 'sa table',
    );
    return 'Retirer $zone et $_temp0 ?';
  }

  @override
  String get barDeleteZone => 'Supprimer la zone';

  @override
  String get barNoTablesConfiguredYet =>
      'Aucune table configurée pour l\'instant.';

  @override
  String get barLoadDefaultFloorPlan => 'Charger le plan de salle par défaut';

  @override
  String get barAddZone => 'Ajouter une zone';

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
  String get barAddTable => 'Ajouter une table';

  @override
  String get barDeleteTable => 'Supprimer la table';

  @override
  String get barSeatsLabel => 'PLACES';

  @override
  String get barZoneName => 'Nom de la zone';

  @override
  String get barZoneNameHint => 'ex. Terrasse';

  @override
  String get barSettleNeedsManagerPin =>
      'Le règlement d\'une addition nécessite le PIN d\'un responsable.';

  @override
  String get barCanSettleBills => 'peut encaisser les additions';

  @override
  String get barLogsOrders => 'enregistre les commandes';

  @override
  String get barWrongPinTryAgain => 'PIN incorrect — réessayez';

  @override
  String get barSelectYourName => 'Sélectionnez votre nom';

  @override
  String get barOpenStatus => 'Ouverte';

  @override
  String barSeatsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count places',
      one: '1 place',
    );
    return '$_temp0';
  }

  @override
  String barOpenedAt(String time) {
    return 'Ouverte à $time';
  }

  @override
  String barOpenedAtBy(String time, String name) {
    return 'Ouverte à $time par $name';
  }

  @override
  String barElapsedOpen(String elapsed) {
    return 'ouverte depuis $elapsed';
  }

  @override
  String barItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return '$_temp0';
  }

  @override
  String get barTapProductsToStartTab =>
      'Touchez des produits pour ouvrir une note';

  @override
  String get barViewTab => 'Voir la note';

  @override
  String get hotelAutoRoomChargeOff =>
      'Facturation auto de la chambre désactivée — utilisez + Frais de chambre';

  @override
  String hotelRoomChargeNotPosted(String error) {
    return 'Frais de chambre non enregistrés : $error';
  }

  @override
  String hotelRoomHeldFor(String room, String guest) {
    return 'Chambre $room réservée pour $guest';
  }

  @override
  String get hotelSmsOutOfCredits =>
      'SMS non envoyé — la succursale n\'a plus de crédits';

  @override
  String hotelQuotationNotSent(String reference) {
    return '$reference n\'a pas été envoyé — réessayez';
  }

  @override
  String hotelQuotationEmailed(String reference, String email) {
    return '$reference envoyé par e-mail à $email';
  }

  @override
  String hotelQuotationEmailFailed(String reference, String error) {
    return 'Impossible d\'envoyer $reference par e-mail : $error';
  }

  @override
  String hotelQuotationBooked(String reference, String room) {
    return '$reference réservé · Chambre $room bloquée';
  }

  @override
  String hotelRoomNoLongerOnBranch(String room) {
    return 'La chambre $room n\'existe plus dans cette succursale';
  }

  @override
  String hotelRoomCheckedOut(String room) {
    return 'Départ enregistré pour la chambre $room';
  }

  @override
  String get hotelSignInWithPinToOpenDesk =>
      'Connectez-vous avec votre PIN pour ouvrir la réception';

  @override
  String get hotelQuotationPdfTitle => 'DEVIS';

  @override
  String get hotelPreparedFor => 'Établi pour';

  @override
  String get hotelRoom => 'Chambre';

  @override
  String get hotelArrival => 'Arrivée';

  @override
  String get hotelDeparture => 'Départ';

  @override
  String get hotelNights => 'Nuits';

  @override
  String hotelNightsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nuits',
      one: '1 nuit',
    );
    return '$_temp0';
  }

  @override
  String get hotelGuests => 'Clients';

  @override
  String get hotelStay => 'Séjour';

  @override
  String hotelAdultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count adultes',
      one: '1 adulte',
    );
    return '$_temp0';
  }

  @override
  String hotelChildrenCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count enfants',
      one: '1 enfant',
    );
    return '$_temp0';
  }

  @override
  String hotelQuotationRoomLine(String room, String nights, String rate) {
    return 'Chambre $room — $nights × $rate';
  }

  @override
  String get hotelExtras => 'Suppléments';

  @override
  String get hotelDescription => 'Description';

  @override
  String get hotelTotal => 'Total';

  @override
  String get hotelQuotationHoldsNoRoom =>
      'Ce devis ne bloque aucune chambre tant qu\'il n\'est pas accepté.';

  @override
  String hotelQuotationExpiredOn(String date) {
    return 'Expiré le $date';
  }

  @override
  String hotelQuotationValidUntil(String date) {
    return 'Valable jusqu\'au $date';
  }

  @override
  String get hotelNote => 'Remarque';

  @override
  String get hotelQuotationTerms =>
      'Les tarifs s\'entendent par chambre et par nuit, sous réserve de disponibilité. Un devis ne bloque aucune chambre tant qu\'il n\'est pas accepté et confirmé par la réception.';

  @override
  String get hotelManagerApprovedToast =>
      'Approuvé par le gérant — appuyez sur Départ pour régler';

  @override
  String hotelCalendarTapFreeNight(String month) {
    return 'Touchez une nuit libre pour réserver la chambre · $month';
  }

  @override
  String get hotelLegendFree => 'Libre';

  @override
  String get hotelLegendReserved => 'Réservé';

  @override
  String get hotelLegendInHouse => 'Occupé';

  @override
  String get hotelLegendBlocked => 'Bloqué';

  @override
  String get hotelToday => 'Aujourd\'hui';

  @override
  String get hotelNoRoomsYet =>
      'Aucune chambre dans cette succursale pour l\'instant.';

  @override
  String hotelFreeRoomsCount(int count) {
    return '$count libres';
  }

  @override
  String hotelCalendarFreeTapToHold(String room) {
    return 'Libre — touchez pour réserver $room';
  }

  @override
  String get hotelBlockedForMaintenance => 'Bloquée pour maintenance';

  @override
  String get hotelTodayAtProperty => 'Aujourd\'hui à l\'établissement';

  @override
  String get hotelGoodDay => 'Bonjour';

  @override
  String hotelGoodDayName(String name) {
    return 'Bonjour, $name';
  }

  @override
  String hotelOccupancySummary(int occupied, int sellable, int guests) {
    String _temp0 = intl.Intl.pluralLogic(
      guests,
      locale: localeName,
      other: '$guests clients',
      one: '1 client',
    );
    return '$occupied chambres occupées sur $sellable disponibles · $_temp0 sur place';
  }

  @override
  String get hotelOccupancy => 'd\'occupation';

  @override
  String get hotelArrivalsToday => 'Arrivées du jour';

  @override
  String hotelInNextSevenDays(int count) {
    return '$count dans les 7 prochains jours';
  }

  @override
  String get hotelDeparturesToday => 'Départs du jour';

  @override
  String hotelOverdueCount(int count) {
    return '$count en retard';
  }

  @override
  String get hotelNoneOverdue => 'aucun retard';

  @override
  String get hotelAvailableRooms => 'Chambres disponibles';

  @override
  String hotelAwaitingCleaningCount(int count) {
    return '$count en attente de ménage';
  }

  @override
  String get hotelPendingPayments => 'Paiements en attente';

  @override
  String hotelOpenFoliosCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count folios ouverts',
      one: '1 folio ouvert',
    );
    return '$_temp0';
  }

  @override
  String get hotelRoomRevenueTonight => 'Revenu des chambres ce soir';

  @override
  String get hotelContractedInHouse => 'prévu pour les séjours en cours';

  @override
  String get hotelOpenQuotations => 'Devis en cours';

  @override
  String hotelAmountQuoted(String amount) {
    return '$amount proposés';
  }

  @override
  String hotelStaysPastDeparture(int count, String rooms) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count séjours ont dépassé',
      one: '1 séjour a dépassé',
    );
    return '$_temp0 la date de départ — $rooms';
  }

  @override
  String hotelRoomNamed(String room) {
    return 'Chambre $room';
  }

  @override
  String get hotelOpenBoard => 'Ouvrir le tableau';

  @override
  String get hotelArrivingToday => 'Arrivent aujourd\'hui';

  @override
  String get hotelNoArrivalsToday => 'Aucune arrivée prévue aujourd\'hui.';

  @override
  String get hotelDepartingToday => 'Partent aujourd\'hui';

  @override
  String get hotelNoDeparturesToday => 'Aucun départ prévu aujourd\'hui.';

  @override
  String get hotelOverdue => 'en retard';

  @override
  String get hotelCharges => 'Frais';

  @override
  String hotelItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return '$_temp0';
  }

  @override
  String get hotelBackToRooms => 'Retour aux chambres';

  @override
  String hotelFolioOpenedBy(String name) {
    return 'Folio · ouvert par $name';
  }

  @override
  String get hotelFrontDesk => 'la réception';

  @override
  String get hotelNoChargesYet =>
      'Aucun frais pour l\'instant. Facturez la chambre pour démarrer ce folio.';

  @override
  String get hotelAutoRoomChargeOffHelp =>
      'La facturation automatique de la chambre est désactivée pour cette succursale.\nUtilisez + Frais de chambre ci-dessus, ou réactivez-la dans Paramètres → Mode hôtel.';

  @override
  String get hotelCancelStay => 'Annuler le séjour';

  @override
  String get hotelSettling => 'Règlement…';

  @override
  String hotelCheckOutAmount(String amount) {
    return 'Départ · $amount';
  }

  @override
  String get hotelPosting => 'Enregistrement…';

  @override
  String get hotelFolioNotFound =>
      'Folio introuvable — rouvrez la chambre et réessayez';

  @override
  String hotelCheckoutFailed(String error) {
    return 'Échec du départ : $error';
  }

  @override
  String get hotelFrontDeskSharedRegister => 'Réception · Caisse partagée';

  @override
  String get hotelLockHintEnterPin =>
      'Saisissez votre PIN à 6 chiffres pour ouvrir la réception';

  @override
  String get hotelWhosOnDeskEyebrow => 'QUI EST À LA RÉCEPTION ?';

  @override
  String get hotelWhosOnDesk => 'Qui est à la réception ?';

  @override
  String get hotelSignInToReception => 'Connexion à la réception';

  @override
  String get hotelNoStaffToShow =>
      'Aucun personnel à afficher. Ajoutez des utilisateurs dans la gestion des utilisateurs — ils apparaissent ici avec leur PIN. Si cet appareil est hors ligne, connectez-le une fois pour que le personnel puisse ensuite se connecter hors ligne.';

  @override
  String get hotelConfiguredByAdmin =>
      'Mode hôtel configuré par l\'administrateur sur le terminal principal';

  @override
  String get hotelQuoteNew => 'Nouveau';

  @override
  String get hotelNewQuotation => 'Nouveau devis';

  @override
  String get hotelQuotations => 'Devis';

  @override
  String hotelQuotationsOpenSummary(int count) {
    return '$count en cours · un devis ne bloque aucune chambre tant qu\'il n\'est pas accepté';
  }

  @override
  String get hotelNoQuotationsYet =>
      'Aucun devis pour l\'instant.\nCréez-en un pour chiffrer un séjour avant que le client ne s\'engage.';

  @override
  String get hotelQuoteStatusBooked => 'Réservé';

  @override
  String get hotelQuoteStatusExpired => 'Expiré';

  @override
  String get hotelQuoteStatusDeclined => 'Refusé';

  @override
  String get hotelQuoteStatusAccepted => 'Accepté';

  @override
  String get hotelQuoteStatusSent => 'Envoyé';

  @override
  String get hotelQuoteStatusDraft => 'Brouillon';

  @override
  String hotelRoomWithType(String room, String type) {
    return 'Chambre $room · $type';
  }

  @override
  String hotelQuoteEmailedAt(String date) {
    return 'Envoyé par e-mail le $date';
  }

  @override
  String hotelQuoteValidTo(String date) {
    return 'valable jusqu\'au $date';
  }

  @override
  String get hotelQuoteDocument => 'Document';

  @override
  String get hotelQuoteEmailToGuest => 'Envoyer au client par e-mail';

  @override
  String get hotelQuoteEmailPdfToGuest => 'Envoyer le PDF au client';

  @override
  String get hotelQuoteAddEmailFirst => 'Ajoutez d\'abord une adresse e-mail';

  @override
  String get hotelQuoteDownloadPdf => 'Télécharger le PDF';

  @override
  String get hotelQuotePrint => 'Imprimer';

  @override
  String get hotelQuoteOpenPrintDialog => 'Ouvrir la boîte d\'impression';

  @override
  String hotelQuotationHeader(String reference) {
    return 'DEVIS $reference';
  }

  @override
  String get hotelEmailLooksWrong => 'Cette adresse e-mail semble incorrecte';

  @override
  String get hotelEmailThisQuotation => 'Envoyer ce devis par e-mail';

  @override
  String get hotelPdfGoesAsAttachment => 'Le PDF est envoyé en pièce jointe.';

  @override
  String get hotelGuestEmail => 'E-mail du client';

  @override
  String get hotelEmailSavedToQuotation =>
      'Enregistrée dans le devis : pas besoin de la retaper au prochain envoi.';

  @override
  String get hotelSendQuotation => 'Envoyer le devis';

  @override
  String get hotelAcceptAndHold => 'Accepter et bloquer';

  @override
  String hotelRemoveQuotationTitle(String reference) {
    return 'Supprimer $reference ?';
  }

  @override
  String hotelRemoveQuotationBody(String guest) {
    return 'Cela supprime le devis de $guest. Toute réservation déjà créée reste inchangée.';
  }

  @override
  String get hotelPreparingQuotation => 'Préparation du devis…';

  @override
  String get hotelQuotation => 'Devis';

  @override
  String hotelQuotationRef(String reference) {
    return 'Devis $reference';
  }

  @override
  String get hotelEmailUs => 'notre établissement';

  @override
  String hotelEmailValidUntil(String date) {
    return 'Ce devis est valable jusqu\'au $date.';
  }

  @override
  String hotelEmailYourQuotation(String reference) {
    return 'Votre devis, $reference';
  }

  @override
  String hotelEmailHtmlIntro(
    String guest,
    String business,
    String room,
    String nights,
  ) {
    return 'Bonjour $guest, merci d\'avoir pensé à $business. Votre devis pour la chambre $room ($nights) est joint en PDF.';
  }

  @override
  String get hotelEmailHoldsNoRoom =>
      'Un devis ne bloque aucune chambre tant qu\'il n\'est pas accepté — répondez à cet e-mail ou appelez-nous pour confirmer.';

  @override
  String hotelEmailHello(String guest) {
    return 'Bonjour $guest,';
  }

  @override
  String hotelEmailPlainIntro(String business, String reference, String room) {
    return 'Merci d\'avoir pensé à $business. Votre devis $reference pour la chambre $room est joint en PDF.';
  }

  @override
  String get hotelEmailPlainHoldsNoRoom =>
      'Un devis ne bloque aucune chambre tant qu\'il n\'est pas accepté — répondez ou appelez-nous pour confirmer.';

  @override
  String get hotelFrontDeskTitle => 'Réception';

  @override
  String hotelBoardSubtitle(String fraction) {
    return '$fraction occupées · touchez une chambre pour enregistrer une arrivée ou ouvrir son folio';
  }

  @override
  String hotelOccupiedFraction(String fraction) {
    return '$fraction occupées';
  }

  @override
  String hotelRoleOnDuty(String role) {
    return '$role · en service';
  }

  @override
  String get hotelReception => 'Réception';

  @override
  String get hotelSettings => 'Paramètres';

  @override
  String get hotelHandOver => 'Passer la main';

  @override
  String get hotelHandOverDesk => 'Passer la main à la réception';

  @override
  String hotelCouldNotLoadBoard(String error) {
    return 'Impossible de charger le tableau.\n$error';
  }

  @override
  String get hotelGuestNameRequired => 'Le nom du client est obligatoire';

  @override
  String hotelRoomMaxCapacity(String room, String capacity) {
    return 'Chambre $room : capacité maximale de $capacity';
  }

  @override
  String get hotelEmailInvalid => 'Cette adresse e-mail semble incorrecte';

  @override
  String hotelCheckInTitle(String room) {
    return 'Arrivée · Chambre $room';
  }

  @override
  String hotelRoomTypeSleeps(String type, String capacity) {
    return '$type · $capacity pers. max.';
  }

  @override
  String get hotelGuestName => 'Nom du client';

  @override
  String get hotelGuestNameHint => 'ex. Aline Uwase';

  @override
  String get hotelPhoneOptional => 'Téléphone (facultatif)';

  @override
  String get hotelEmailOptional => 'E-mail (facultatif)';

  @override
  String get hotelSendsConfirmationHint => 'Pour envoyer la confirmation';

  @override
  String get hotelAdults => 'Adultes';

  @override
  String get hotelChildren => 'Enfants';

  @override
  String get hotelRatePerNightRwf => 'Tarif par nuit (RWF)';

  @override
  String get hotelCheckInGuest => 'Enregistrer le client';

  @override
  String get hotelRoomCharge => 'Frais de chambre';

  @override
  String get hotelNavToday => 'Aujourd\'hui';

  @override
  String get hotelNavRooms => 'Chambres';

  @override
  String get hotelNavCalendar => 'Calendrier';

  @override
  String get hotelNavQuotes => 'Devis';

  @override
  String get hotelDueOut => 'Départ prévu';

  @override
  String get hotelRate => 'Tarif';

  @override
  String hotelPriceEach(String price) {
    return '$price l\'unité';
  }

  @override
  String get hotelTaxIncl => 'Taxes (incl.)';

  @override
  String get hotelFolioTotal => 'Total du folio';

  @override
  String get hotelCheckOut => 'Départ';

  @override
  String hotelFolioTotalAmount(String amount) {
    return 'Total du folio $amount';
  }

  @override
  String get hotelPaymentCard => 'Carte';

  @override
  String get hotelChangeDue => 'Monnaie à rendre';

  @override
  String get hotelSettleAndRelease => 'Régler et libérer la chambre';

  @override
  String get hotelOutOfOrder => 'Hors service';

  @override
  String get hotelHkClean => 'Propre';

  @override
  String get hotelHkCleanMeaning =>
      'Prête à la vente — la réception peut y installer un client.';

  @override
  String get hotelHkDirty => 'À nettoyer';

  @override
  String get hotelHkDirtyMeaning =>
      'Retirée de la vente jusqu\'à sa libération par le ménage.';

  @override
  String get hotelHkInspected => 'Inspectée';

  @override
  String get hotelHkInspectedMeaning =>
      'Nettoyée et vérifiée par un superviseur. Disponible à la vente.';

  @override
  String get hotelHkOutOfOrderMeaning =>
      'Bloquée pour maintenance. Jamais proposée à un client.';

  @override
  String hotelHousekeepingTitle(String room) {
    return 'Ménage · Chambre $room';
  }

  @override
  String hotelOccupiedNotice(String guest) {
    return '$guest occupe cette chambre. Enregistrez son départ avant de la bloquer pour maintenance.';
  }

  @override
  String get hotelUnavailableWhileOccupied =>
      'Indisponible tant que la chambre est occupée.';

  @override
  String get hotelManager => 'Responsable';

  @override
  String get hotelEnterManagerPin =>
      'Saisissez le PIN à 6 chiffres du responsable';

  @override
  String get hotelNotManagerPin => 'Ce n\'est pas un PIN de responsable';

  @override
  String get hotelManagerApproval => 'Validation du responsable';

  @override
  String get hotelSettleNeedsManagerPin =>
      'Le règlement d\'un folio nécessite le PIN d\'un responsable.';

  @override
  String get hotelModeAlongsideBar =>
      'Mode Hôtel activé en plus du Mode Bar — choisissez ci-dessous ce que cet appareil affiche.';

  @override
  String get hotelHouseCheckoutTime => 'Heure de départ de l\'établissement';

  @override
  String get hotelAdminLodging => 'Hébergement';

  @override
  String get hotelAdminRoomsFloors => 'Chambres et étages';

  @override
  String get hotelAdminRatesBilling => 'Tarifs et facturation';

  @override
  String get hotelAdminGuestNotifications => 'Notifications aux clients';

  @override
  String get hotelAdminCompanyStamp => 'Cachet de l\'entreprise';

  @override
  String get hotelAutoPostTitle => 'Facturer la chambre à l\'arrivée';

  @override
  String get hotelAutoPostSubtitle =>
      'Porte nuits × tarif au folio dès que le client prend la clé.';

  @override
  String get hotelRequirePinTitle =>
      'Exiger un PIN pour changer de réceptionniste';

  @override
  String get hotelRequirePinSubtitle =>
      'Caisse partagée : la réception s\'ouvre sur un verrou PIN et tout membre du personnel peut se connecter.';

  @override
  String get hotelManagerCheckoutTitle =>
      'Responsable requis pour régler un folio';

  @override
  String get hotelManagerCheckoutSubtitle =>
      'Seul un responsable peut encaisser et libérer la chambre au départ.';

  @override
  String get hotelAutoLogoutTitle => 'Libérer la réception après un départ';

  @override
  String get hotelAutoLogoutSubtitle =>
      'Revient au verrou PIN dès qu\'un client a quitté la chambre.';

  @override
  String get hotelRoomChargeProduct => 'Produit des frais de chambre';

  @override
  String hotelCheckoutDefaultSubtitle(String time) {
    return 'Départ par défaut à $time après la dernière nuit.';
  }

  @override
  String get hotelOpenFrontDesk => 'Ouvrir la réception';

  @override
  String get hotelLoading => 'Chargement…';

  @override
  String get hotelRoomChargeNotSet =>
      'Non défini — les frais de chambre ne peuvent pas être facturés tant qu\'aucun produit enregistré n\'est choisi.';

  @override
  String hotelRoomChargeMissing(String id) {
    return 'Le produit $id n\'existe plus dans cette succursale. Choisissez-en un autre.';
  }

  @override
  String get hotelNotifyEmailTitle =>
      'Envoyer une confirmation par e-mail au client';

  @override
  String get hotelNotifyEmailSubtitle =>
      'Gratuit. Envoyé dès que le client a donné une adresse e-mail.';

  @override
  String get hotelNotifySmsTitle =>
      'Envoyer une confirmation par SMS au client';

  @override
  String get hotelNotifySmsSubtitle =>
      'Coûte 30 crédits par message. Désactivé jusqu\'à ce que vous l\'activiez.';

  @override
  String get hotelNotifyReserveTitle => 'Confirmer lors d\'une réservation';

  @override
  String get hotelNotifyReserveSubtitle =>
      'Envoyé au moment où une arrivée future est réservée.';

  @override
  String get hotelNotifyCheckInTitle => 'Accueillir le client à son arrivée';

  @override
  String get hotelNotifyCheckInSubtitle =>
      'Envoyé quand le client prend effectivement la clé.';

  @override
  String get hotelStampTitle => 'Apposer le cachet sur les devis et proformas';

  @override
  String get hotelStampUploadFirst =>
      'Téléversez un cachet ci-dessous, puis activez cette option.';

  @override
  String get hotelStampDrawnOn =>
      'Apposé sur la dernière page de chaque document généré.';

  @override
  String get hotelNoStamp => 'Aucun cachet';

  @override
  String get hotelStampUnreadable => 'Illisible';

  @override
  String hotelStampSizeHint(String size) {
    return 'PNG ou JPEG de moins de $size Ko. Un PNG transparent rend le mieux.';
  }

  @override
  String get hotelUpload => 'Téléverser';

  @override
  String get hotelReplace => 'Remplacer';

  @override
  String get hotelStampBottomRight => 'En bas à droite';

  @override
  String get hotelStampBottomLeft => 'En bas à gauche';

  @override
  String get hotelStampBottomCentre => 'En bas au centre';

  @override
  String get hotelStampBesideTotal => 'À côté du total';

  @override
  String get hotelStampPosition => 'Position';

  @override
  String get hotelStampWidth => 'Largeur';

  @override
  String get hotelStampUpdated => 'Cachet de l\'entreprise mis à jour.';

  @override
  String get hotelStampSavedLocalOnly =>
      'Cachet enregistré sur cet appareil uniquement — les autres terminaux ne l\'utiliseront pas.';

  @override
  String hotelStampSetFailed(String error) {
    return 'Impossible de définir le cachet : $error';
  }

  @override
  String get hotelStampRemoved => 'Cachet de l\'entreprise supprimé.';

  @override
  String get hotelStampRemovedLocalOnly =>
      'Cachet supprimé sur cet appareil uniquement — les autres terminaux l\'ont encore.';

  @override
  String get hotelStampSavedDeviceOnly =>
      'Cachet enregistré sur cet appareil uniquement.';

  @override
  String get hotelModeTitle => 'Mode Hôtel (Réception)';

  @override
  String get hotelOnBadge => 'ACTIF';

  @override
  String hotelModeDescription(String hotkey) {
    return 'Transforme la caisse en réception : un tableau des chambres par étage, l\'enregistrement des arrivées avec client et dates, un folio ouvert par séjour que le bar et le restaurant peuvent débiter, et le règlement au départ. Remplace le Mode Bar et l\'encaissement standard dans cette succursale. Au clavier, $hotkey alterne Bar → Hôtel → POS sans revenir ici.';
  }

  @override
  String get hotelPickRoomToQuote => 'Choisissez une chambre pour le devis';

  @override
  String get hotelEditQuotation => 'Modifier le devis';

  @override
  String get hotelQuotationIntro =>
      'Une offre chiffrée. Aucune chambre n\'est bloquée tant que le client ne l\'a pas acceptée.';

  @override
  String get hotelQuotationEmailHint => 'Adresse d\'envoi du devis PDF';

  @override
  String get hotelRatePerNightShort => 'Tarif / nuit';

  @override
  String get hotelValidForDays => 'Valable (jours)';

  @override
  String get hotelSaveQuotation => 'Enregistrer le devis';

  @override
  String get hotelUpdateQuotation => 'Mettre à jour le devis';

  @override
  String hotelRoomsAvailableForDates(String count) {
    return 'Chambre · $count disponible(s) à ces dates';
  }

  @override
  String hotelNoRoomFree(String count) {
    return 'Aucune chambre pour $count personne(s) n\'est libre à ces dates.';
  }

  @override
  String hotelNightsQuoted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nuits au devis',
      one: '1 nuit au devis',
    );
    return '$_temp0';
  }

  @override
  String get hotelDatesTaken => 'Ces dates sont déjà prises pour cette chambre';

  @override
  String hotelReserveTitle(String room) {
    return 'Réserver · Chambre $room';
  }

  @override
  String get hotelHoldRoom => 'Réserver la chambre';

  @override
  String hotelRoomTakenBetween(String room, String from, String to) {
    return 'La chambre $room est déjà prise entre le $from et le $to.';
  }

  @override
  String hotelGuestsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personnes',
      one: '1 personne',
    );
    return '$_temp0';
  }

  @override
  String hotelRoomSemantic(String room, String type, String state) {
    return 'Chambre $room, $type, $state';
  }

  @override
  String get hotelTapToCheckIn => 'touchez pour enregistrer une arrivée';

  @override
  String hotelDueOutAt(String time) {
    return 'Départ prévu $time';
  }

  @override
  String hotelOutOn(String date) {
    return 'Départ $date';
  }

  @override
  String get hotelAwaitingHousekeeping => 'En attente du ménage';

  @override
  String hotelPerNight(String amount) {
    return '$amount / nuit';
  }

  @override
  String get hotelNoActiveBranch => 'Aucune succursale active';

  @override
  String get hotelRoomChargeIntro =>
      'Le tarif de la nuit est facturé sur ce produit, il doit donc être enregistré auprès de la RRA.';

  @override
  String get hotelNoProductsFound => 'Aucun produit trouvé.';

  @override
  String get hotelNotRegisteredWithRra =>
      'Non enregistré auprès de la RRA — enregistrez-le d\'abord';

  @override
  String hotelRoomIsState(String room, String state) {
    return 'La chambre $room est : $state';
  }

  @override
  String hotelCheckInGuestQuestion(String guest) {
    return 'Enregistrer l\'arrivée de $guest ?';
  }

  @override
  String hotelReservedArrivalBody(String room) {
    return 'La chambre $room lui est réservée. L\'enregistrement ouvre le folio et facture la chambre.';
  }

  @override
  String get hotelNotYet => 'Pas encore';

  @override
  String get hotelCheckIn => 'Enregistrer l\'arrivée';

  @override
  String hotelRoomSavedNotRegistered(String room, String error) {
    return 'Chambre $room enregistrée, mais non déclarée à la RRA : $error';
  }

  @override
  String get hotelNewFloorOrWing => 'Nouvel étage ou aile';

  @override
  String hotelRoomHasGuest(String room) {
    return 'La chambre $room a un client ou une réservation. Enregistrez d\'abord son départ.';
  }

  @override
  String hotelDeleteRoomQuestion(String room) {
    return 'Supprimer la chambre $room ?';
  }

  @override
  String get hotelDeleteRoomBody =>
      'Elle disparaît du tableau, du calendrier et des disponibilités. Les séjours passés et leurs factures restent intacts.';

  @override
  String hotelRoomStillHasGuest(String room) {
    return 'La chambre $room a encore un client ou une réservation.';
  }

  @override
  String hotelDeleteFloorQuestion(String floor) {
    return 'Supprimer $floor ?';
  }

  @override
  String hotelDeleteFloorBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Supprime $count chambres de cet étage.',
      one: 'Supprime 1 chambre de cet étage.',
    );
    return '$_temp0';
  }

  @override
  String get hotelStarterPlanBody =>
      'Partez d\'un plan type de 15 chambres sur trois étages, puis modifiez les numéros, types et tarifs selon votre établissement.';

  @override
  String get hotelCreateStarterPlan => 'Créer un plan de départ';

  @override
  String hotelRoomsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chambres',
      one: '1 chambre',
    );
    return '$_temp0';
  }

  @override
  String get hotelDeleteFloor => 'Supprimer l\'étage';

  @override
  String get hotelAddRoom => 'Ajouter une chambre';

  @override
  String get hotelAddFloorOrWing => 'Ajouter un étage ou une aile';

  @override
  String get hotelFloorNameHint => 'ex. Deuxième étage';

  @override
  String get hotelRequired => 'Obligatoire';

  @override
  String get hotelInUse => 'Déjà utilisé';

  @override
  String get hotelRoomNoHint => 'N°';

  @override
  String get hotelRoomTypeHint => 'Type';

  @override
  String get hotelRegisteredWithRra =>
      'Enregistrée auprès de la RRA comme service soumis à la taxe touristique';

  @override
  String get hotelNotRegisteredTapToRegister =>
      'Non enregistrée auprès de la RRA — touchez pour l\'enregistrer';

  @override
  String get hotelCannotDeleteOccupied =>
      'Occupée ou réservée — suppression impossible';

  @override
  String get hotelDeleteRoom => 'Supprimer la chambre';

  @override
  String get hotelStateVacant => 'Libre';

  @override
  String get hotelStateOccupied => 'Occupée';

  @override
  String get hotelStateReserved => 'Réservée';

  @override
  String get hotelStateCleaning => 'Ménage';

  @override
  String get hotelAllFloors => 'Tous les étages';

  @override
  String get hotelChargeToRoom => 'Débiter sur la chambre';

  @override
  String get hotelChargeToRoomSubtitle =>
      'Choisissez le client dont le folio reprend cette note.';

  @override
  String get hotelStaySearchHint =>
      'Numéro de chambre, nom du client ou téléphone';

  @override
  String hotelStayOutLine(String summary, String date) {
    return '$summary · départ $date';
  }

  @override
  String get hotelLookingUpGuests => 'Recherche des clients…';

  @override
  String get hotelNobodyCheckedIn => 'Aucun client enregistré';

  @override
  String get hotelReadingRooms => 'Lecture des chambres de cette succursale.';

  @override
  String get hotelNoGuestsBody =>
      'Une note ne peut être débitée qu\'à un client enregistré. Les réservations reçoivent les frais dès l\'arrivée du client.';

  @override
  String hotelNoGuestMatches(String term) {
    return 'Aucun client ne correspond à « $term »';
  }

  @override
  String get hotelSearchByHint =>
      'Recherchez par numéro de chambre, nom du client ou téléphone.';

  @override
  String get creditsHubTitle => 'Espace crédits';

  @override
  String get creditsAddCredits => 'Ajouter des crédits';

  @override
  String get creditsAvailable => 'Crédits disponibles';

  @override
  String get creditsLabel => 'Crédits';

  @override
  String creditsMaximum(String max) {
    return 'Maximum : $max';
  }

  @override
  String get creditsEnterAmount => 'Saisissez le montant';

  @override
  String get creditsPayNow => 'Payer maintenant';

  @override
  String get creditsEnterValidAmount => 'Veuillez saisir un montant valide';

  @override
  String get creditsEnterValidPhone =>
      'Veuillez saisir un numéro de téléphone valide';

  @override
  String get creditsPaymentRequestFailed =>
      'La demande de paiement a échoué. Veuillez réessayer.';

  @override
  String creditsErrorOccurred(String error) {
    return 'Une erreur s\'est produite : $error';
  }

  @override
  String get creditsPaymentDeclined =>
      'Le paiement a été refusé sur votre téléphone.';

  @override
  String get creditsPaymentSuccessful => 'Paiement réussi';

  @override
  String get creditsPaymentInitiated => 'Paiement lancé';

  @override
  String creditsPaymentRequestSent(String phone) {
    return 'Une demande de paiement a été envoyée au $phone.';
  }

  @override
  String get creditsApprovePayment =>
      'Vérifiez votre téléphone et approuvez le paiement.';

  @override
  String creditsNothingCharged(String reason) {
    return '$reason Rien n\'a été débité — vous pouvez réessayer.';
  }

  @override
  String get creditsVerificationTimedOut =>
      'La vérification du paiement a expiré. Vérifiez vos crédits plus tard.';

  @override
  String get creditsPaymentProcessed => 'Votre paiement a bien été traité !';

  @override
  String get creditsAdded => 'Vos crédits ont été ajoutés à votre compte.';

  @override
  String get creditsQuickAdd => 'Ajout rapide';

  @override
  String get delegationStatusCompleted => 'Terminé';

  @override
  String get delegationStatusDelegated => 'Délégué';

  @override
  String get delegationStatusFailed => 'Échec';

  @override
  String get delegationFilterAll => 'Toutes';

  @override
  String delegationTransactionName(String id) {
    return 'Transaction $id';
  }

  @override
  String get delegationBannerTapToOpen => 'Appuyez pour ouvrir les délégations';

  @override
  String get delegationRetryQueued =>
      'Nouvelle tentative en file d\'attente. En cas de nouvel échec, renvoyez la vente depuis l\'appareil de caisse.';

  @override
  String get delegationRetryError =>
      'Erreur lors de la nouvelle tentative de délégation';

  @override
  String get delegationAboutTitle => 'À propos des délégations';

  @override
  String get delegationAboutBody =>
      'La délégation d\'impression permet aux appareils mobiles d\'envoyer des impressions vers les imprimantes des ordinateurs. Les délégations en échec peuvent être relancées depuis cet écran.';

  @override
  String get delegationGotIt => 'Compris';

  @override
  String get delegationTitle => 'Délégation d\'impression';

  @override
  String delegationHeaderSubtitle(String count) {
    return 'Suivez et gérez les transactions déléguées entre vos caisses — $count affichée(s).';
  }

  @override
  String get delegationSearchHint =>
      'Rechercher une délégation, un reçu, un paiement…';

  @override
  String get delegationFilter => 'Filtrer';

  @override
  String get delegationRetryTooltip => 'Relancer la délégation';

  @override
  String get delegationReceiptType => 'Type de reçu';

  @override
  String get delegationEmptyTitle => 'Aucune délégation trouvée';

  @override
  String get delegationEmptyDeviceHint =>
      'Les délégations envoyées à cet appareil apparaîtront ici. Les expéditeurs doivent cibler l\'ID de cet appareil dans les paramètres de délégation.';

  @override
  String get delegationEmptyFilterHint =>
      'Essayez un autre terme de recherche ou changez le filtre ci-dessus pour voir plus de résultats.';

  @override
  String get saleAgentAssignTitle => 'Attribuer un agent';

  @override
  String get saleAgentAgentsSection => 'AGENTS';

  @override
  String get saleAgentSearchHint => 'Rechercher des agents…';

  @override
  String get saleAgentNoAgentsForBusiness =>
      'Aucun agent trouvé pour cette entreprise. Ajoutez des agents dans la gestion des utilisateurs.';

  @override
  String get saleAgentNoSearchMatch =>
      'Aucun agent ne correspond à votre recherche.';

  @override
  String get saleAgentCommissionSection => 'COMMISSION';

  @override
  String get saleAgentFixedRwf => 'Fixe (RWF)';

  @override
  String get saleAgentPercent => 'Pourcentage (%)';

  @override
  String get saleAgentAmountRwf => 'Montant (RWF)';

  @override
  String get saleAgentRatePercent => 'Taux (%)';

  @override
  String saleAgentExample(String example) {
    return 'ex. $example';
  }

  @override
  String get saleAgentSelectAgent => 'Sélectionnez un agent';

  @override
  String get saleAgentEnterValidCommission => 'Saisissez une commission valide';

  @override
  String get saleAgentPercentMax => 'Le pourcentage ne peut pas dépasser 100';

  @override
  String get saleAgentApply => 'Appliquer';

  @override
  String get saleAgentNoContact => 'Aucun contact';

  @override
  String get saleAgentBadge => 'Agent';

  @override
  String personalGoalBannerReached(String name) {
    return 'Objectif atteint : $name';
  }

  @override
  String personalGoalBannerReachedForPeriod(String period, String name) {
    return 'Objectif atteint pour $period : $name';
  }

  @override
  String personalGoalBannerTargetMet(String amount) {
    return 'Objectif de $amount atteint';
  }

  @override
  String personalGoalBannerTargetMetRestart(String amount, String restart) {
    return 'Objectif de $amount atteint · $restart';
  }

  @override
  String personalGoalBannerSavedTo(String amount, String name) {
    return '+$amount épargnés pour $name';
  }

  @override
  String personalGoalSavedOfTarget(String saved, String target) {
    return '$saved sur $target';
  }

  @override
  String personalGoalBannerSavedSoFar(String amount) {
    return '$amount épargnés jusqu\'ici';
  }

  @override
  String personalGoalBannerOneReached(String name) {
    return '$name a atteint son objectif';
  }

  @override
  String personalGoalBannerManyReached(int count) {
    return '$count objectifs ont été atteints';
  }

  @override
  String personalGoalBannerSavedAcross(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count objectifs',
      one: '1 objectif',
    );
    return '+$amount épargnés sur $_temp0';
  }

  @override
  String get personalGoalBannerEyebrow => 'OBJECTIF PERSONNEL  ·  maintenant';

  @override
  String get personalGoalBannerDismiss => 'Ignorer';

  @override
  String personalGoalRemoteCreditNotification(String name, String amount) {
    return '$name : +$amount épargnés (automatiquement ou synchronisés depuis un autre appareil)';
  }

  @override
  String get personalGoalTopPriorityEyebrow => 'PRIORITÉ ABSOLUE';

  @override
  String get personalGoalSaved => 'Épargné';

  @override
  String get personalGoalTarget => 'Objectif';

  @override
  String get personalGoalAutoAllocation => 'Allocation automatique';

  @override
  String personalGoalProfitReserved(String percent) {
    return '$percent % du bénéfice réservé';
  }

  @override
  String get personalGoalAutoAllocationOptional =>
      'Facultatif — à définir en modification';

  @override
  String get personalGoalUpdatedFromProfits =>
      'Mis à jour à partir des bénéfices';

  @override
  String get personalGoalAddMoney => 'Ajouter de l\'argent';

  @override
  String get personalGoalAddMoneyCashIn => '· Encaissement';

  @override
  String personalGoalReachedForPeriod(String period, String restart) {
    return 'Atteint pour $period · $restart';
  }

  @override
  String personalGoalLastPeriodReached(String period, String amount) {
    return '$period : $amount · atteint';
  }

  @override
  String personalGoalLastPeriodProgress(String period, String progress) {
    return '$period : $progress';
  }

  @override
  String get personalGoalNewGoal => 'Nouvel objectif';

  @override
  String get personalGoalNewGoalExamples => 'Équipement, loyer, formation…';

  @override
  String get personalGoalEditGoal => 'Modifier l\'objectif';

  @override
  String get personalGoalEditSubtitle =>
      'Mettez à jour les montants et paramètres de cet objectif.';

  @override
  String get personalGoalNewSubtitle =>
      'Choisissez un nom et un objectif. Vous pouvez ajouter de l\'argent à tout moment depuis l\'encaissement.';

  @override
  String get personalGoalNameSection => 'NOM DE L\'OBJECTIF';

  @override
  String get personalGoalNameLabel => 'Pour quoi épargnez-vous ?';

  @override
  String get personalGoalNameHint => 'ex. Fonds d\'urgence, équipement';

  @override
  String get personalGoalNameRequired => 'Saisissez un nom d\'objectif';

  @override
  String get personalGoalAmountsSection => 'MONTANTS (RWF)';

  @override
  String get personalGoalTargetAmount => 'Montant visé';

  @override
  String get personalGoalTargetRequired =>
      'Saisissez un objectif supérieur à 0';

  @override
  String get personalGoalAlreadySaved => 'Déjà épargné';

  @override
  String get personalGoalAlreadySavedHint => '0 — facultatif';

  @override
  String get personalGoalCannotBeNegative => 'Ne peut pas être négatif';

  @override
  String get personalGoalRepeatsSection => 'RÉPÉTITION';

  @override
  String get personalGoalRepeats => 'Répétition';

  @override
  String get personalGoalOptionalSection => 'FACULTATIF';

  @override
  String get personalGoalAutoAllocationPercent => 'Allocation automatique %';

  @override
  String get personalGoalAutoAllocationHint => 'Laissez vide si inutilisé';

  @override
  String get personalGoalPercentRange => 'Utilisez 0–100';

  @override
  String get personalGoalTopPriority => 'Priorité absolue';

  @override
  String get personalGoalTopPriorityHint =>
      'Affiché en premier sur votre tableau de bord';

  @override
  String get personalGoalSaveChanges => 'Enregistrer les modifications';

  @override
  String get personalGoalCreateGoal => 'Créer l\'objectif';

  @override
  String get agentCommissionPayoutsUnavailable =>
      'L\'historique des versements n\'a pas pu être chargé. Les commissions gagnées sur les ventes restent affichées. Exécutez la migration Supabase agent_commission_payouts si les versements ne s\'enregistrent pas.';

  @override
  String get agentCommissionEyebrow => 'ÉQUIPE  ·  COMMISSIONS';

  @override
  String get agentCommissionTitle => 'Commissions des agents';

  @override
  String get agentCommissionSubtitle =>
      'Suivez ce que chaque agent commercial a gagné, ce que vous avez versé et ce qui reste dû.';

  @override
  String get agentCommissionSignOut => 'Se déconnecter';

  @override
  String get agentCommissionAgent => 'Agent';

  @override
  String get agentCommissionEarnedEyebrow => 'COMMISSION GAGNÉE';

  @override
  String agentCommissionPaidOutPct(String percent) {
    return 'Versé · $percent %';
  }

  @override
  String agentCommissionBalanceDuePct(String percent) {
    return 'Reste dû · $percent %';
  }

  @override
  String get agentCommissionPaidOutEyebrow => 'VERSÉ';

  @override
  String get agentCommissionBalanceDueEyebrow => 'RESTE DÛ';

  @override
  String get agentCommissionAllSettled => 'Tout est réglé';

  @override
  String get agentCommissionRecordPayout => 'Enregistrer un versement';

  @override
  String get agentCommissionAttributedSales => 'VENTES ATTRIBUÉES';

  @override
  String agentCommissionPendingCount(int count) {
    return '$count en attente';
  }

  @override
  String get agentCommissionExport => 'Exporter';

  @override
  String get agentCommissionColDate => 'DATE';

  @override
  String get agentCommissionColReceipt => 'REÇU';

  @override
  String get agentCommissionColCashier => 'CAISSIER';

  @override
  String get agentCommissionColSaleTotal => 'TOTAL VENTE';

  @override
  String get agentCommissionColRate => 'TAUX';

  @override
  String get agentCommissionColCommission => 'COMMISSION';

  @override
  String get agentCommissionColStatus => 'STATUT';

  @override
  String get agentCommissionWalkIn => 'Client de passage';

  @override
  String get agentCommissionRecentPayouts => 'VERSEMENTS RÉCENTS';

  @override
  String get agentCommissionCashier => 'Caissier';

  @override
  String get agentCommissionPaid => 'Payé';

  @override
  String get agentCommissionPending => 'En attente';

  @override
  String get agentCommissionLast7Days => '7 derniers jours';

  @override
  String get agentCommissionAllTime => 'Depuis le début';

  @override
  String get agentCommissionToday => 'Aujourd\'hui';

  @override
  String get agentCommissionThisWeek => 'Cette semaine';

  @override
  String get agentCommissionThisMonth => 'Ce mois-ci';

  @override
  String get agentCommissionLoadFailed =>
      'Impossible de charger les données de commission.';

  @override
  String get agentCommissionAgentsLoadFailed =>
      'Impossible de charger les agents.';

  @override
  String get agentCommissionNoAgents =>
      'Aucun agent trouvé. Ajoutez d\'abord des agents dans la gestion des utilisateurs.';

  @override
  String get agentCommissionNoPermission =>
      'Vous n\'avez pas l\'autorisation de gérer les versements.';

  @override
  String agentCommissionBalanceDueAmount(String amount) {
    return 'Reste dû : $amount';
  }

  @override
  String get agentCommissionAmountRwf => 'Montant (RWF)';

  @override
  String get agentCommissionEnterValidAmount => 'Saisissez un montant valide';

  @override
  String agentCommissionCannotExceedBalance(String amount) {
    return 'Ne peut pas dépasser le solde ($amount)';
  }

  @override
  String get agentCommissionNoteOptional => 'Note (facultatif)';

  @override
  String agentCommissionPayoutRecorded(String amount) {
    return 'Versement de $amount enregistré.';
  }

  @override
  String get agentCommissionPayoutFailed =>
      'Impossible d\'enregistrer le versement. Vérifiez votre connexion.';

  @override
  String get agentCommissionCommissionAgent => 'Agent commissionné';

  @override
  String get agentCommissionByOwner => 'par le propriétaire';

  @override
  String agentCommissionSaleAmount(String amount) {
    return 'Vente $amount';
  }

  @override
  String get agentCommissionNoSalesYet =>
      'Aucune vente attribuée pour l\'instant';

  @override
  String agentCommissionNoSalesHint(String period) {
    return 'Lorsque les caissiers attribuent un agent à une vente terminée dans Vente rapide, la commission apparaîtra ici pour : $period.';
  }

  @override
  String get agentCommissionAmountMustBePositive =>
      'Le montant du versement doit être supérieur à zéro.';

  @override
  String get agentCommissionNoBusinessSelected =>
      'Aucune entreprise sélectionnée.';

  @override
  String get agentCommissionSignInToRecord =>
      'Connectez-vous pour enregistrer un versement.';

  @override
  String get agentCommissionStorageNotSetUp =>
      'Le stockage des versements n\'est pas encore configuré. Demandez à votre administrateur d\'exécuter la dernière migration Supabase (agent_commission_payouts).';

  @override
  String get agentCommissionCouldNotRecord =>
      'Impossible d\'enregistrer le versement.';

  @override
  String get kitchenStageIncoming => 'Entrantes';

  @override
  String get kitchenStageInProgress => 'En préparation';

  @override
  String get kitchenStageReady => 'Prête';

  @override
  String get kitchenStageServed => 'Servie';

  @override
  String get kitchenServedAlreadyPaid =>
      'Servie. Cette commande était déjà payée.';

  @override
  String get kitchenServedCashierHasTicket =>
      'Servie. Le caissier a ce ticket ouvert pour l\'encaissement.';

  @override
  String get kitchenServedInTickets =>
      'Servie. Elle est dans Tickets, prête à être encaissée.';

  @override
  String get kitchenDisplayTitle => 'Écran cuisine';

  @override
  String kitchenErrorLoadingOrders(String error) {
    return 'Erreur lors du chargement des commandes : $error';
  }

  @override
  String kitchenFailedToUpdateOrder(String error) {
    return 'Échec de la mise à jour de la commande : $error';
  }

  @override
  String kitchenFailedToSetDueDate(String error) {
    return 'Échec de la définition de l\'échéance : $error';
  }

  @override
  String get kitchenNoOrders => 'Aucune commande';

  @override
  String kitchenOrderNumber(String number) {
    return 'Commande n°$number';
  }

  @override
  String get kitchenSetDueDate => 'Définir l\'échéance';

  @override
  String get kitchenTicketNotFound =>
      'Ticket introuvable — il a peut-être été supprimé.';

  @override
  String kitchenTicketName(String name) {
    return 'Ticket : $name';
  }

  @override
  String kitchenCustomerLine(String name) {
    return 'Client : $name';
  }

  @override
  String kitchenTotalLine(String amount) {
    return 'Total : $amount';
  }

  @override
  String get kitchenNoteLabel => 'Note :';

  @override
  String get kitchenNoItemsFound => 'Aucun article trouvé';

  @override
  String get kitchenItemsLabel => 'Articles :';

  @override
  String kitchenErrorLoadingItems(String error) {
    return 'Erreur lors du chargement des articles : $error';
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
      other: 'À livrer dans $minutes minutes',
      one: 'À livrer dans 1 minute',
    );
    return '$_temp0';
  }

  @override
  String get kitchenSetAction => 'Définir';

  @override
  String get ticketUnknown => 'Inconnu';

  @override
  String get ticketOverdue => 'En retard';

  @override
  String ticketMinutesLeft(String minutes) {
    return '$minutes min restantes';
  }

  @override
  String ticketDaysHoursLeft(String days, String hours) {
    return '$days j $hours h restants';
  }

  @override
  String ticketHoursMinutesLeft(String hours, String minutes) {
    return '$hours h $minutes min restantes';
  }

  @override
  String get ticketWalkInCustomer => 'Client de passage';

  @override
  String get ticketWalkIn => 'De passage';

  @override
  String get ticketStatusWaiting => 'En attente';

  @override
  String get ticketStatusInProgress => 'En cours';

  @override
  String get ticketStatusPaid => 'Payé';

  @override
  String get ticketStatusPendingReview => 'En attente de révision';

  @override
  String get ticketStatusReviewed => 'Révisé';

  @override
  String get ticketStatusPartial => 'Partiel';

  @override
  String get ticketStatusAwaitingPayment => 'En attente de paiement';

  @override
  String get ticketMarkReviewedFailed =>
      'Impossible de marquer le ticket comme révisé';

  @override
  String get ticketReviewedSuccess => 'Ticket révisé';

  @override
  String get ticketReviewQueue => 'File de révision';

  @override
  String get ticketReviewQueueLoadFailed =>
      'Impossible de charger la file de révision';

  @override
  String get ticketReviewQueueEmpty => 'Rien en attente de révision';

  @override
  String get ticketReviewDetails => 'Voir les détails';

  @override
  String ticketsWaitingToReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tickets en attente de révision',
      one: '1 ticket en attente de révision',
    );
    return '$_temp0';
  }

  @override
  String ticketMoreCount(String count) {
    return '+ $count de plus';
  }

  @override
  String get ticketOpenReviewQueue => 'Ouvrir la file de révision →';

  @override
  String ticketNumberRef(String reference) {
    return 'Ticket #$reference';
  }

  @override
  String get ticketGeneric => 'Ticket';

  @override
  String get ticketJustNow => 'à l\'instant';

  @override
  String ticketMinutesAgo(String count) {
    return 'il y a $count min';
  }

  @override
  String ticketHoursAgo(String count) {
    return 'il y a $count h';
  }

  @override
  String ticketDaysAgo(String count) {
    return 'il y a $count j';
  }

  @override
  String ticketItemsSectionCount(String count) {
    return 'Articles · $count';
  }

  @override
  String get ticketNote => 'Note';

  @override
  String ticketCouldNotLoadItems(String error) {
    return 'Impossible de charger les articles : $error';
  }

  @override
  String get ticketMarking => 'Enregistrement…';

  @override
  String get ticketMarkAsReviewed => 'Marquer comme révisé';

  @override
  String get ticketReviewTicketTitle => 'Réviser le ticket';

  @override
  String get ticketNoItemsOnTicket => 'Aucun article sur ce ticket.';

  @override
  String ticketIdShort(String id) {
    return '(ID : $id)';
  }

  @override
  String get ticketNotAvailable => 'N/D';

  @override
  String ticketSubtotalValue(String amount) {
    return 'Sous-total : $amount';
  }

  @override
  String ticketDueOn(String date) {
    return 'Échéance : $date';
  }

  @override
  String get ticketDeleteTitle => 'Supprimer le ticket';

  @override
  String get ticketDeleteConfirm =>
      'Voulez-vous vraiment supprimer ce ticket ? Cette action est irréversible.';

  @override
  String get ticketLoan => 'Crédit';

  @override
  String get ticketLayaway => 'Paiement échelonné';

  @override
  String get ticketRegular => 'Standard';

  @override
  String get ticketFilterAll => 'Tous les tickets';

  @override
  String get ticketsCannotDeleteReviewed =>
      'Les tickets sélectionnés ont été révisés et ne peuvent pas être supprimés';

  @override
  String get ticketsCannotDeleteSelected =>
      'Les tickets sélectionnés ne peuvent pas être supprimés (paiements partiels ou révisés)';

  @override
  String ticketsDeletedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tickets supprimés avec succès',
      one: '1 ticket supprimé avec succès',
    );
    return '$_temp0';
  }

  @override
  String get ticketsDeleteSelectedFailed =>
      'Échec de la suppression des tickets sélectionnés';

  @override
  String get ticketAddItemsFirst =>
      'Veuillez ajouter des articles à la transaction avant de créer un ticket';

  @override
  String get ticketCreate => 'Créer un ticket';

  @override
  String get ticketsPendingTitle => 'Tickets en attente';

  @override
  String get ticketsMyTitle => 'Mes tickets';

  @override
  String get ticketsPendingSubtitle =>
      'Commandes en attente d\'encaissement à la caisse';

  @override
  String get ticketsMySubtitle =>
      'Les commandes que vous avez envoyées et leur statut de paiement';

  @override
  String ticketsDeleteSelectedCount(String count) {
    return 'Supprimer la sélection ($count)';
  }

  @override
  String get ticketsSelectAll => 'Tout sélectionner';

  @override
  String get ticketSendViaWhatsApp => 'Envoyer par WhatsApp';

  @override
  String ticketRefWithCustomer(String reference, String customer) {
    return 'Ticket #$reference · $customer';
  }

  @override
  String get ticketHandoverStaffHeader => 'Personnel de remise du stock';

  @override
  String get ticketHandoverStaffLoadFailed =>
      'Impossible de charger le personnel de remise.';

  @override
  String get ticketHandoverStaffEmpty =>
      'Aucun membre du personnel n\'a l\'accès Remise du stock et un numéro de téléphone enregistré. Ajoutez un téléphone à son profil et accordez-lui l\'accès Remise du stock.';

  @override
  String get ticketOrderFormShop => 'Boutique';

  @override
  String get ticketOrderReceipt => 'Reçu de commande';

  @override
  String get ticketCreated => 'Créé';

  @override
  String get ticketDeliveryTime => 'Heure de livraison';

  @override
  String get ticketTotal => 'Total';

  @override
  String get ticketBalance => 'Solde';

  @override
  String get ticketRemaining => 'Restant';

  @override
  String get ticketReviewedBy => 'Révisé par';

  @override
  String get ticketReviewedAt => 'Révisé le';

  @override
  String get ticketThankYouForOrder => 'Merci pour votre commande';

  @override
  String ticketsSkippedCannotDelete(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count tickets ignorés car ils ne peuvent pas être supprimés (paiements partiels ou révisés)',
      one:
          '1 ticket ignoré car il ne peut pas être supprimé (paiements partiels ou révisé)',
    );
    return '$_temp0';
  }

  @override
  String get ticketSearchHint =>
      'Rechercher par client, téléphone, ID du ticket...';

  @override
  String get ticketsLoading => 'Chargement des tickets...';

  @override
  String get ticketsNoneInCategory => 'Aucun ticket dans cette catégorie';

  @override
  String get ticketsTryAnotherFilter => 'Essayez un autre filtre';

  @override
  String get ticketSortNewest => 'Plus récents d\'abord';

  @override
  String get ticketSortOldest => 'Plus anciens d\'abord';

  @override
  String get ticketsLoanSection => 'Tickets à crédit';

  @override
  String get ticketsLayawaySection => 'Tickets à paiement échelonné';

  @override
  String get ticketsRegularSection => 'Tickets standard';

  @override
  String get ticketOrderResumed => 'Commande reprise avec succès';

  @override
  String get ticketStaffFallback => 'Personnel';

  @override
  String get ticketReturnToTillFailed =>
      'Impossible de renvoyer le ticket en cours à la caisse. Réessayez.';

  @override
  String get ticketActionFailed => 'Échec de l\'action';

  @override
  String get ticketSentToKitchen => 'Envoyé en cuisine';

  @override
  String get ticketSendToKitchenFailed =>
      'Impossible d\'envoyer en cuisine. Réessayez.';

  @override
  String get ticketSendToKitchen => 'Envoyer en cuisine';

  @override
  String get ticketSendAgain => 'Renvoyer';

  @override
  String get ticketServedReadyForPayment => 'Servie · prête à être encaissée';

  @override
  String ticketInKitchenStage(String stage) {
    return 'En cuisine · $stage';
  }

  @override
  String get ticketPrintOrderFormFailed =>
      'Échec de l\'impression du bon de commande';

  @override
  String ticketOrderFormCaption(String reference, String customer) {
    return 'Bon de commande · Ticket #$reference · $customer';
  }

  @override
  String ticketOrderFormSentWhatsApp(String name) {
    return 'Bon de commande envoyé à $name sur WhatsApp';
  }

  @override
  String get ticketOrderFormWhatsAppFailed =>
      'Échec de l\'envoi du bon de commande sur WhatsApp';

  @override
  String get ticketHandoverRecordedReceipt => 'Remise enregistrée — reçu émis';

  @override
  String get ticketHandoverRecorded => 'Remise enregistrée';

  @override
  String get ticketHandoverFinalizeFailed =>
      'Échec de la finalisation de la remise — le reçu n\'a pas été émis. Veuillez réessayer.';

  @override
  String get ticketHasPartialPayments =>
      'Ce ticket a des paiements partiels et ne peut pas être supprimé.';

  @override
  String get ticketDeleted => 'Ticket supprimé';

  @override
  String get ticketDeleteFailed => 'Échec de la suppression du ticket';

  @override
  String get ticketDeleteFailedShort => 'Échec de la suppression';

  @override
  String get ticketsNoOpen => 'Aucun ticket ouvert';

  @override
  String get ticketsCreateToStart => 'Créez un nouveau ticket pour commencer';

  @override
  String get ticketsNoSearchMatch =>
      'Aucun ticket ne correspond à votre recherche';

  @override
  String get ticketsTryDifferentSearch => 'Essayez un autre terme de recherche';

  @override
  String get ticketSomethingWentWrong => 'Une erreur s\'est produite';

  @override
  String get ticketTryAgain => 'Réessayer';

  @override
  String get ticketCompleteHandoverTitle => 'Finaliser la remise ?';

  @override
  String get ticketHandoverIssueReceiptBody =>
      'Émettre le reçu et marquer ce ticket comme terminé.';

  @override
  String get ticketHandoverConfirmLeftStock =>
      'Confirmez que l\'article a physiquement quitté le stock.';

  @override
  String get ticketHandoverStockDeductedInfo =>
      'Le stock sera déduit et le reçu fiscal sera émis maintenant.';

  @override
  String get ticketHandoverRecordsInfo =>
      'Ceci enregistre que les marchandises ont été remises au client.';

  @override
  String get ticketDeleteQuestion => 'Supprimer le ticket ?';

  @override
  String get ticketDeleteRemovesHistory =>
      'Cela supprime la vente en attente et l\'historique local du ticket.';

  @override
  String get ticketActionCannotBeUndone => 'Cette action est irréversible.';

  @override
  String ticketCreatedOn(String date) {
    return 'Créé le $date';
  }

  @override
  String get ticketRecordHandover => 'Enregistrer la remise';

  @override
  String get ticketCollecting => 'Encaissement…';

  @override
  String get ticketCollect => 'Encaisser →';

  @override
  String get ticketCompleting => 'Finalisation…';

  @override
  String get ticketComplete => 'Terminer →';

  @override
  String get ticketResumeOrder => 'Reprendre la commande';

  @override
  String get ticketPrint => 'Imprimer';

  @override
  String get ticketSent => 'Envoyé';

  @override
  String get ticketWhatsAppNotConfigured =>
      'L\'envoi WhatsApp n\'est pas configuré : l\'URL du connecteur de données (Ebm.dataConnectorUrl) est manquante.';

  @override
  String configCurrencyName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'RWF': 'Franc rwandais',
      'KES': 'Shilling kényan',
      'UGX': 'Shilling ougandais',
      'TZS': 'Shilling tanzanien',
      'ETB': 'Birr éthiopien',
      'NGN': 'Naira nigérian',
      'ZAR': 'Rand sud-africain',
      'GHS': 'Cedi ghanéen',
      'MAD': 'Dirham marocain',
      'EGP': 'Livre égyptienne',
      'DZD': 'Dinar algérien',
      'XOF': 'Franc CFA BCEAO',
      'XAF': 'Franc CFA BEAC',
      'MUR': 'Roupie mauricienne',
      'BWP': 'Pula botswanais',
      'NAD': 'Dollar namibien',
      'USD': 'Dollar américain',
      'EUR': 'Euro',
      'GBP': 'Livre sterling',
      'JPY': 'Yen japonais',
      'CNY': 'Yuan chinois',
      'CAD': 'Dollar canadien',
      'AUD': 'Dollar australien',
      'CHF': 'Franc suisse',
      'NZD': 'Dollar néo-zélandais',
      'HKD': 'Dollar de Hong Kong',
      'SEK': 'Couronne suédoise',
      'NOK': 'Couronne norvégienne',
      'DKK': 'Couronne danoise',
      'AED': 'Dirham des Émirats arabes unis',
      'SAR': 'Riyal saoudien',
      'QAR': 'Riyal qatari',
      'KWD': 'Dinar koweïtien',
      'BHD': 'Dinar bahreïni',
      'OMR': 'Rial omanais',
      'ILS': 'Shekel israélien',
      'JOD': 'Dinar jordanien',
      'INR': 'Roupie indienne',
      'PKR': 'Roupie pakistanaise',
      'BDT': 'Taka bangladais',
      'SGD': 'Dollar de Singapour',
      'MYR': 'Ringgit malaisien',
      'IDR': 'Roupie indonésienne',
      'PHP': 'Peso philippin',
      'THB': 'Baht thaïlandais',
      'VND': 'Dong vietnamien',
      'KRW': 'Won sud-coréen',
      'TWD': 'Nouveau dollar de Taïwan',
      'LKR': 'Roupie srilankaise',
      'NPR': 'Roupie népalaise',
      'BRL': 'Real brésilien',
      'MXN': 'Peso mexicain',
      'ARS': 'Peso argentin',
      'COP': 'Peso colombien',
      'CLP': 'Peso chilien',
      'PEN': 'Sol péruvien',
      'UYU': 'Peso uruguayen',
      'BOB': 'Boliviano bolivien',
      'VES': 'Bolívar vénézuélien',
      'RUB': 'Rouble russe',
      'PLN': 'Złoty polonais',
      'CZK': 'Couronne tchèque',
      'HUF': 'Forint hongrois',
      'RON': 'Leu roumain',
      'BGN': 'Lev bulgare',
      'TRY': 'Livre turque',
      'UAH': 'Hryvnia ukrainienne',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get configNeedHelp => 'Besoin d\'aide ?';

  @override
  String get configContactSupportToAddEbm =>
      'Contactez le support pour ajouter l\'EBM à Flipper';

  @override
  String get configContactSupport => 'Contacter le support';

  @override
  String get configEnterValidUrl => 'Veuillez saisir une URL valide';

  @override
  String get configEnterUrlWithScheme =>
      'Veuillez saisir une URL valide avec un schéma (par ex. http:// ou https://)';

  @override
  String get configBranchIdRequired => 'L\'ID de succursale est requis';

  @override
  String get configMrcRequired => 'Le MRC est requis';

  @override
  String get configMrcLength =>
      'Le MRC doit comporter exactement 11 caractères';

  @override
  String get configNoChangesToSave => 'Aucune modification à enregistrer';

  @override
  String get configSaveFailed =>
      'Impossible d\'enregistrer la configuration fiscale. Vérifiez votre connexion et réessayez.';

  @override
  String get configTaxConfigSaved => 'Configuration fiscale enregistrée';

  @override
  String get configGeneral => 'Général';

  @override
  String get configTaxConfiguration => 'Configuration fiscale';

  @override
  String get configSaveAppliesTo =>
      'L\'enregistrement s\'applique à l\'URL EBM / fiscale, à l\'URL du data connector, au code de succursale et au MRC.';

  @override
  String get configTaxServerUrl => 'URL du serveur EBM / fiscal';

  @override
  String get configDataConnectorUrl => 'URL du data connector';

  @override
  String get configDataConnectorHelper =>
      'L\'enregistrement RRA groupé des produits utilise ce service ; l\'URL fiscale RRA est configurée sur le data connector.';

  @override
  String get configBranchCodeBhfId => 'Code de succursale (bhfId)';

  @override
  String get configBranchCode => 'Code de succursale';

  @override
  String get configEnterEbmUrl => 'Saisissez l\'URL EBM';

  @override
  String get configSystemConfiguration => 'Configuration du système';

  @override
  String get configSystemConfigSubtitle =>
      'Gérez le comportement du PDV, la devise et l\'intégration fiscale.';

  @override
  String get configTrainingMode => 'Mode formation';

  @override
  String get configProformaMode => 'Mode proforma';

  @override
  String get configPrintA4 => 'Imprimer en A4';

  @override
  String get configExportAsPdf => 'Exporter en PDF';

  @override
  String get configSystemCurrency => 'Devise du système';

  @override
  String get configVatEnabled => 'TVA activée';

  @override
  String get configVatControlledByEbm => 'Contrôlé par la configuration EBM';

  @override
  String get configVatStatusControlledByEbm =>
      'Le statut de la TVA est contrôlé par la configuration EBM';

  @override
  String get configLoading => 'Chargement...';

  @override
  String get configErrorLoadingVat =>
      'Erreur lors du chargement du statut de la TVA';

  @override
  String configErrorWithDetails(String error) {
    return 'Erreur : $error';
  }

  @override
  String get configTourismTaxRegistered => 'Inscrit à la taxe touristique';

  @override
  String get configTourismTaxHint =>
      'Activez uniquement si la RRA a inscrit cette succursale à la taxe touristique. Sinon, les chambres sont enregistrées comme de simples services.';

  @override
  String get configVersionNotAvailable => 'Version non disponible';

  @override
  String configVersion(String version) {
    return 'Version $version';
  }

  @override
  String get configSaving => 'Enregistrement…';

  @override
  String get configSaved => 'Enregistré';

  @override
  String get configSaveConfiguration => 'Enregistrer la configuration';

  @override
  String get leadsFilterAll => 'Tous';

  @override
  String get leadsStatusNew => 'Nouveau';

  @override
  String get leadsStatusContacted => 'Contacté';

  @override
  String get leadsStatusQuoted => 'Devis envoyé';

  @override
  String get leadsStatusConverted => 'Converti';

  @override
  String get leadsStatusLost => 'Perdu';

  @override
  String get leadsHeatHot => 'Chaud';

  @override
  String get leadsHeatWarm => 'Tiède';

  @override
  String get leadsHeatCold => 'Froid';

  @override
  String get leadsHotLead => 'Prospect chaud';

  @override
  String get leadsWarmLead => 'Prospect tiède';

  @override
  String get leadsColdLead => 'Prospect froid';

  @override
  String get leadsSourceWalkIn => 'En boutique';

  @override
  String get leadsSubtitle =>
      'Suivez les clients, les demandes et la valeur du pipeline';

  @override
  String leadsEmailsNeedReview(String count) {
    return '$count e-mails à examiner';
  }

  @override
  String get leadsFilter => 'Filtrer';

  @override
  String get leadsAddLead => 'Ajouter un prospect';

  @override
  String get leadsStatTotalLeads => 'Total des prospects';

  @override
  String get leadsStatAllSources => 'Toutes les sources';

  @override
  String get leadsStatPipelineValue => 'Valeur du pipeline';

  @override
  String get leadsStatActiveLeads => 'Prospects actifs';

  @override
  String get leadsStatCompletedSales => 'Ventes conclues';

  @override
  String get leadsStatFromGmail => 'Depuis Gmail';

  @override
  String get leadsStatEmailEnquiries => 'Demandes par e-mail';

  @override
  String get leadsStatConversionRate => 'Taux de conversion';

  @override
  String get leadsStatThisMonth => 'Ce mois-ci';

  @override
  String get leadsAllLeads => 'Tous les prospects';

  @override
  String get leadsUnableToLoad => 'Impossible de charger les prospects.';

  @override
  String get leadsSearchHint => 'Rechercher un nom, un e-mail, un produit…';

  @override
  String get leadsNoLeadsYet => 'Aucun prospect pour le moment.';

  @override
  String get leadsColSource => 'Source';

  @override
  String get leadsColInterestedIn => 'Intéressé par';

  @override
  String get leadsColValue => 'Valeur';

  @override
  String get leadsColStage => 'Étape';

  @override
  String get leadsColHeat => 'Intérêt';

  @override
  String get leadsColDate => 'Date';

  @override
  String get leadsPipeline => 'Pipeline';

  @override
  String get leadsPerformance => 'Performance';

  @override
  String get leadsConversionRateThisMonth => 'Taux de conversion ce mois-ci';

  @override
  String get leadsAvgTimeToConvert => 'Délai moyen de conversion';

  @override
  String leadsDaysCount(String days) {
    return '$days jours';
  }

  @override
  String get leadsEmailReviewComingSoon =>
      'L\'examen des prospects par e-mail arrive bientôt.';

  @override
  String get leadsGmailAiFlagged =>
      'Gmail - l\'IA les a identifiés comme prospects potentiels.';

  @override
  String leadsPendingCount(String count) {
    return '$count en attente';
  }

  @override
  String get leadsGmailIngestionLater =>
      'L\'import depuis Gmail sera activé plus tard. Pour l\'instant, ajoutez les prospects manuellement.';

  @override
  String get leadsFilterLeads => 'Filtrer les prospects';

  @override
  String get leadsContactDetails => 'Coordonnées';

  @override
  String get leadsEstValue => 'Valeur est.';

  @override
  String get leadsNotes => 'Notes';

  @override
  String get leadsAiExtractedItems => 'Articles d\'intérêt extraits par l\'IA';

  @override
  String leadsMatchPercent(String percent) {
    return '$percent % de correspondance';
  }

  @override
  String get leadsActivityTimeline => 'Historique d\'activité';

  @override
  String get leadsCreatedFromGmail => 'Prospect créé — depuis un e-mail Gmail';

  @override
  String get leadsCreatedManual => 'Prospect créé — saisie manuelle';

  @override
  String get leadsTimelineAuto => 'Auto';

  @override
  String get leadsTimelinePending => 'En attente';

  @override
  String leadsAiExtractedProducts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count produits',
      one: '1 produit',
    );
    return 'L’IA a extrait $_temp0 d’intérêt';
  }

  @override
  String get leadsProformaDraftReady =>
      'Brouillon de proforma prêt à être examiné';

  @override
  String get leadsReviewProforma => 'Examiner la proforma';

  @override
  String get leadsConverting => 'Conversion…';

  @override
  String get leadsConvertToSale => 'Convertir en vente';

  @override
  String leadsConvertFailed(String error) {
    return 'Échec de la conversion du prospect. $error';
  }

  @override
  String get leadsFullNameRequired => 'Nom complet *';

  @override
  String get leadsFullNameHint => 'Nom complet';

  @override
  String get leadsEmailAddress => 'Adresse e-mail';

  @override
  String get leadsNotesOptional => 'Notes (facultatif)';

  @override
  String get leadsNotesHint => 'Qu\'ont-ils demandé ?';

  @override
  String get leadsSaveLead => 'Enregistrer le prospect';

  @override
  String get leadsProductsInterestedRequired => 'Produits souhaités *';

  @override
  String get leadsBrowseCatalogue => 'Parcourir le catalogue';

  @override
  String get leadsTypeProductHint =>
      'Ou saisissez le nom du produit, le SKU, le BCD…';

  @override
  String get leadsAddLeadSubtitle =>
      'Enregistrez manuellement un nouveau client ou une demande';

  @override
  String get leadsWalkInCustomer => 'Client en boutique';

  @override
  String get leadsPhoneReferral => 'Téléphone / Recommandation';

  @override
  String get leadsEstimatedValue => 'Valeur estimée';

  @override
  String get leadsLeadHeat => 'Niveau d\'intérêt';

  @override
  String leadsSaveFailed(String error) {
    return 'Échec de l\'enregistrement du prospect. $error';
  }

  @override
  String get leadsPickFromCatalogue => 'Choisir dans le catalogue';

  @override
  String get leadsSearchCatalogHint => 'Rechercher un nom, un SKU, un BCD…';

  @override
  String get leadsNoItemsFound => 'Aucun article trouvé';

  @override
  String get leadsProformaNewItem => 'Nouvel article';

  @override
  String get leadsProforma => 'Proforma';

  @override
  String get leadsProformaInvoice => 'Facture proforma';

  @override
  String leadsProformaSubtitle(String name) {
    return 'Prospect : $name · Brouillon IA — à vérifier avant l\'envoi';
  }

  @override
  String get leadsSend => 'Envoyer';

  @override
  String get leadsSending => 'Envoi…';

  @override
  String get leadsDownloadPdf => 'Télécharger le PDF';

  @override
  String get leadsProformaAiBannerNarrow =>
      'Brouillon IA créé depuis l\'e-mail. Touchez un prix ou une quantité pour le modifier. Vérifiez toutes les lignes avant l\'envoi.';

  @override
  String get leadsProformaAiBanner =>
      'L\'IA a rédigé cette proforma à partir de l\'e-mail du client';

  @override
  String get leadsAllFieldsEditable => 'Tous les champs modifiables';

  @override
  String get leadsDraft => 'Brouillon';

  @override
  String get leadsDraftNotSent => 'Brouillon — non envoyé';

  @override
  String get leadsBillTo => 'Facturer à';

  @override
  String get leadsIssueDate => 'Date d\'émission';

  @override
  String get leadsValidUntil => 'Valable jusqu\'au';

  @override
  String get leadsLeadSource => 'Source du prospect';

  @override
  String get leadsGmailEnquiry => 'Demande Gmail';

  @override
  String get leadsManualEntry => 'Saisie manuelle';

  @override
  String get leadsAiMatchedItems => 'L\'IA a associé les articles au catalogue';

  @override
  String get leadsColItem => 'Article';

  @override
  String get leadsColPrice => 'Prix';

  @override
  String get leadsColTotal => 'Total';

  @override
  String get leadsColDescription => 'Description';

  @override
  String get leadsColUnitPrice => 'Prix unitaire';

  @override
  String get leadsColQty => 'Qté';

  @override
  String get leadsAddProductHint => 'Ajouter un produit...';

  @override
  String get leadsAddShort => '+ Ajouter';

  @override
  String get leadsSearchProductToAddLine =>
      '+ Rechercher un produit pour ajouter une ligne…';

  @override
  String get leadsAddLine => 'Ajouter une ligne';

  @override
  String get leadsVat18 => 'TVA 18 %';

  @override
  String get leadsGrandTotal => 'Total général';

  @override
  String get leadsTermsShort => 'Valable 7 jours. Paiement à la livraison.';

  @override
  String get leadsTermsLong =>
      'Cette proforma est valable 7 jours. Paiement à la livraison. Virement bancaire ou mobile money acceptés.';

  @override
  String get leadsNotesTerms => 'Notes / Conditions';

  @override
  String get leadsSummary => 'Résumé';

  @override
  String get leadsLines => 'Lignes';

  @override
  String leadsLinesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lignes',
      one: '1 ligne',
    );
    return '$_temp0';
  }

  @override
  String get leadsStatus => 'Statut';

  @override
  String get leadsHistory => 'Historique';

  @override
  String get leadsHistoryAiDrafted =>
      'Brouillon IA à partir d\'un e-mail Gmail';

  @override
  String get leadsHistoryLeadCreated => 'Prospect créé, proforma générée';

  @override
  String get leadsHistoryAwaitingReview => 'En attente de vérification';

  @override
  String get leadsToday => 'Aujourd\'hui';

  @override
  String get leadsNow => 'Maintenant';

  @override
  String get leadsNoContactProvided => 'Aucun contact fourni';

  @override
  String get leadsPdfSaved => 'PDF de la proforma enregistré.';

  @override
  String leadsPdfExportFailed(String error) {
    return 'Échec de l\'export du PDF : $error';
  }

  @override
  String get leadsPdfReadyToShare => 'PDF de la proforma prêt à être partagé.';

  @override
  String leadsSendPrepareFailed(String error) {
    return 'Échec de la préparation de l\'envoi : $error';
  }

  @override
  String get leadsConvertedToSale => 'Prospect converti en vente.';

  @override
  String leadsConvertFailedShort(String error) {
    return 'Échec de la conversion : $error';
  }

  @override
  String get gigsNegotiable => 'À négocier';

  @override
  String gigsDurationHoursMinutes(String hours, String minutes) {
    return '$hours h $minutes min';
  }

  @override
  String gigsDurationMinutes(String minutes) {
    return '$minutes min';
  }

  @override
  String get gigsStatusAwaitingProviderResponse =>
      'En attente de réponse du prestataire';

  @override
  String get gigsStatusAcceptWindowExpired => 'Délai d\'acceptation expiré';

  @override
  String get gigsStatusAwaitingPayment => 'En attente de paiement';

  @override
  String get gigsStatusPaymentWindowExpired => 'Délai de paiement expiré';

  @override
  String get gigsStatusPaidReadyToStart => 'Payé - Prêt à démarrer';

  @override
  String get gigsStatusRequested => 'Demandé';

  @override
  String get gigsStatusPendingPayment => 'Paiement en attente';

  @override
  String get gigsStatusPaid => 'Payé';

  @override
  String get gigsStatusInProgress => 'En cours';

  @override
  String get gigsStatusCompleted => 'Terminé';

  @override
  String get gigsStatusDeclined => 'Refusé';

  @override
  String get gigsStatusDeclinedByProvider => 'Refusé par le prestataire';

  @override
  String get gigsStatusExpired => 'Expiré';

  @override
  String get gigsStatusCancelled => 'Annulé';

  @override
  String get gigsStatusAccepted => 'Accepté';

  @override
  String get gigsCategoryHomeServices => 'Services à domicile';

  @override
  String get gigsCategoryBeautyWellness => 'Beauté et bien-être';

  @override
  String get gigsCategoryDeliveryTransport => 'Livraison et transport';

  @override
  String get gigsCategoryTechSupport => 'Assistance technique';

  @override
  String get gigsCategoryEvents => 'Événements';

  @override
  String get gigsCategoryLessons => 'Cours et formation';

  @override
  String get gigsCategoryHealthcare => 'Santé';

  @override
  String get gigsCategoryOther => 'Autre';

  @override
  String get gigsErrSignInToRequest =>
      'Connectez-vous pour demander un service.';

  @override
  String get gigsErrRequestSelf =>
      'Vous ne pouvez pas vous demander un service à vous-même.';

  @override
  String get gigsErrMinAmount => 'Saisissez un montant d\'au moins 100 RWF.';

  @override
  String get gigsErrSendRequest => 'Impossible d\'envoyer votre demande.';

  @override
  String get gigsErrSendRequestConnection =>
      'Impossible d\'envoyer votre demande. Vérifiez votre connexion et réessayez.';

  @override
  String get gigsErrSignInToPay => 'Connectez-vous pour finaliser le paiement.';

  @override
  String get gigsErrValidAmount => 'Saisissez un montant valide.';

  @override
  String get gigsErrRequestNotFound => 'Demande introuvable.';

  @override
  String get gigsErrNotAwaitingPayment =>
      'Cette demande n\'attend pas de paiement.';

  @override
  String get gigsErrPaymentWindowEnded =>
      'Le délai de paiement est terminé. Contactez le prestataire pour envoyer une nouvelle demande.';

  @override
  String get gigsErrConfirmPayment =>
      'Impossible de confirmer le paiement. Il a peut-être déjà été enregistré.';

  @override
  String get gigsErrSavePayment => 'Impossible d\'enregistrer le paiement.';

  @override
  String get gigsErrSavePaymentConnection =>
      'Impossible d\'enregistrer le paiement. Vérifiez votre connexion.';

  @override
  String get gigsErrSignInToRespond =>
      'Connectez-vous pour répondre aux demandes.';

  @override
  String get gigsErrCannotAccept =>
      'Cette demande ne peut plus être acceptée. Elle a peut-être expiré ou déjà été traitée.';

  @override
  String get gigsErrAccept => 'Impossible d\'accepter la demande.';

  @override
  String get gigsErrAcceptConnection =>
      'Impossible d\'accepter la demande. Vérifiez votre connexion et réessayez.';

  @override
  String get gigsErrSignInToDispatch =>
      'Connectez-vous pour effectuer les versements.';

  @override
  String get gigsErrPayoutReference => 'Saisissez une référence de versement.';

  @override
  String get gigsErrUpdatePayout =>
      'Impossible de mettre à jour le statut du versement.';

  @override
  String get gigsErrSignInToMessage =>
      'Connectez-vous pour envoyer un message.';

  @override
  String get gigsErrEmptyMessage => 'Le message ne peut pas être vide.';

  @override
  String get gigsErrRequestClosed => 'Cette demande est clôturée.';

  @override
  String get gigsErrSendMessage => 'Impossible d\'envoyer le message.';

  @override
  String get gigsErrSignInToUpdate =>
      'Connectez-vous pour mettre à jour cette demande.';

  @override
  String get gigsErrOnlyPaidToStart =>
      'Seules les demandes payées et non démarrées peuvent passer en cours.';

  @override
  String get gigsErrUpdateStatus => 'Impossible de mettre à jour le statut.';

  @override
  String get gigsErrMarkComplete =>
      'Impossible de marquer comme terminé. C\'est peut-être déjà fait.';

  @override
  String get gigsErrSignInToReview => 'Connectez-vous pour laisser un avis.';

  @override
  String get gigsErrPickRating => 'Choisissez une note de 1 à 5.';

  @override
  String get gigsErrShortComment => 'Veuillez ajouter un court commentaire.';

  @override
  String get gigsErrOnlyCompletedReview =>
      'Seules les missions terminées peuvent être évaluées.';

  @override
  String get gigsErrAlreadyReviewed => 'Vous avez déjà laissé un avis.';

  @override
  String get gigsErrSaveReviewRetry =>
      'Impossible d\'enregistrer l\'avis. Réessayez.';

  @override
  String get gigsErrSaveReview => 'Impossible d\'enregistrer l\'avis.';

  @override
  String get gigsAdminMetricsTitle => 'Statistiques de l\'espace services';

  @override
  String get gigsPayouts => 'Versements';

  @override
  String get gigsPendingDispatch => 'En attente de versement';

  @override
  String get gigsDispatched => 'Versés';

  @override
  String get gigsPendingTotalRwf => 'Total en attente (RWF)';

  @override
  String get gigsRequestsByStatus => 'Demandes par statut';

  @override
  String get gigsMetrics => 'Statistiques';

  @override
  String get gigsProvider => 'Prestataire';

  @override
  String gigsProviderShortId(String suffix) {
    return 'Prestataire · …$suffix';
  }

  @override
  String gigsCustomerShortId(String suffix) {
    return 'Client · …$suffix';
  }

  @override
  String get gigsPayoutReference => 'Référence du versement';

  @override
  String get gigsPayoutReferenceHint => 'Référence MTN / grand livre';

  @override
  String get gigsMarkDispatched => 'Marquer comme versé';

  @override
  String get gigsMarkedDispatched => 'Marqué comme versé.';

  @override
  String get gigsDispatchPayouts => 'Effectuer les versements';

  @override
  String get gigsNoPayoutsPending => 'Aucun versement en attente';

  @override
  String get gigsNoPayoutsPendingHint =>
      'Les missions financées apparaîtront ici jusqu\'à leur versement.';

  @override
  String gigsPayoutAmountLine(String amount, String status, String date) {
    return 'Montant : $amount RWF · $status\nEnvoyée le $date';
  }

  @override
  String get gigsWaitingForProvider => 'En attente du prestataire';

  @override
  String get gigsPayNow => 'Payer maintenant';

  @override
  String get gigsPaymentWindowEnded => 'Délai de paiement terminé';

  @override
  String get gigsPaymentRecordedCanStart =>
      'Paiement enregistré. Le prestataire peut commencer la mission.';

  @override
  String get gigsMyRequests => 'Mes demandes';

  @override
  String get gigsNoRequestsYet => 'Aucune demande pour le moment';

  @override
  String get gigsMyRequestsEmptyHint =>
      'Quand vous demandez un service depuis Trouver des prestataires, la demande apparaît ici. Une fois acceptée, vous pouvez payer avec MTN dans le délai indiqué.';

  @override
  String get gigsAgreedAmount => 'Montant convenu';

  @override
  String get gigsSent => 'Envoyée';

  @override
  String gigsPayBy(String date) {
    return 'Payer avant le $date';
  }

  @override
  String gigsDidNotPayBefore(String date) {
    return 'Vous n\'avez pas payé avant le $date';
  }

  @override
  String gigsPaidAmountSettled(String amount, String settled) {
    return 'Payé $amount RWF · MTN a réglé $settled RWF';
  }

  @override
  String gigsPaidAmount(String amount) {
    return 'Payé $amount RWF';
  }

  @override
  String get gigsPayWithMtn => 'Payer avec MTN';

  @override
  String gigsRequestFrom(String name) {
    return 'Demande de $name';
  }

  @override
  String gigsRequestTo(String name) {
    return 'Demande à $name';
  }

  @override
  String get gigsNotifications => 'Notifications';

  @override
  String get gigsNoActivityYet => 'Aucune activité pour le moment';

  @override
  String get gigsActivityEmptyHint =>
      'Quand vous envoyez ou recevez des demandes de service, les mises à jour apparaissent ici. Tirez vers le bas pour actualiser.';

  @override
  String gigsUpdatedAt(String date) {
    return 'Mis à jour le $date';
  }

  @override
  String get gigsPaymentRecorded => 'Paiement enregistré.';

  @override
  String get gigsMarkedInProgress => 'Marqué comme en cours.';

  @override
  String get gigsJobMarkedComplete =>
      'Mission marquée comme terminée. Le client peut laisser un avis.';

  @override
  String get gigsRateYourExperience => 'Évaluez votre expérience';

  @override
  String get gigsComment => 'Commentaire';

  @override
  String get gigsThanksForReview => 'Merci pour votre avis.';

  @override
  String get gigsRequestDetails => 'Détails de la demande';

  @override
  String get gigsMessages => 'Messages';

  @override
  String get gigsNoMessagesYet =>
      'Aucun message pour le moment. Convenez ici de l\'heure et du lieu.';

  @override
  String get gigsTypeMessageHint => 'Écrivez un message…';

  @override
  String get gigsStartJob => 'Démarrer la mission';

  @override
  String get gigsMarkJobComplete => 'Marquer la mission comme terminée';

  @override
  String get gigsLeaveReview => 'Laisser un avis';

  @override
  String get gigsYourReview => 'Votre avis';

  @override
  String get gigsAdvancedFilters => 'Filtres avancés';

  @override
  String gigsMinRating(String rating) {
    return 'Note moyenne minimale : $rating';
  }

  @override
  String get gigsVerifiedOnly => 'Prestataires vérifiés uniquement';

  @override
  String get gigsAvailableForBooking => 'Disponible à la réservation';

  @override
  String get gigsMaxBasePrice => 'Prix de base max. (RWF), facultatif';

  @override
  String get gigsCategory => 'Catégorie';

  @override
  String get gigsAllCategories => 'Toutes les catégories';

  @override
  String get gigsApplyFilters => 'Appliquer les filtres';

  @override
  String get gigsFindProvider => 'Trouver un prestataire';

  @override
  String get gigsNoProvidersYet => 'Aucun prestataire pour le moment';

  @override
  String get gigsNoProvidersHint =>
      'Quand des personnes proposent leurs services ici, elles apparaissent dans cette liste et vous pouvez leur envoyer une demande.\n\nTirez vers le bas pour actualiser. Si vous êtes vous-même inscrit comme prestataire, votre profil n\'apparaît pas dans cette liste.';

  @override
  String get gigsSearchHint => 'Rechercher un nom, une zone ou un service…';

  @override
  String get gigsBrowseByService => 'Parcourir par service';

  @override
  String get gigsAll => 'Tous';

  @override
  String get gigsNoMatches => 'Aucun résultat';

  @override
  String get gigsNoMatchesHint =>
      'Essayez d\'autres mots-clés, choisissez un autre service ou effacez vos filtres.';

  @override
  String get gigsClearSearchFilters => 'Effacer la recherche et les filtres';

  @override
  String get gigsErrUpdateAvailability =>
      'Impossible de mettre à jour la disponibilité sur le serveur.';

  @override
  String get gigsVisibleToCustomers => 'Vous êtes visible par les clients.';

  @override
  String get gigsMarkedUnavailable => 'Vous êtes marqué comme indisponible.';

  @override
  String get gigsProviderDashboard => 'Tableau de bord prestataire';

  @override
  String get gigsAcceptNewRequests => 'Accepter de nouvelles demandes';

  @override
  String get gigsAcceptNewRequestsHint =>
      'Désactivé, les clients peuvent toujours voir votre profil mais ne peuvent pas réserver.';

  @override
  String get gigsRecordedPayments => 'Paiements enregistrés (RWF)';

  @override
  String gigsFundedJobs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count missions financées dans les données',
      one: '1 mission financée dans les données',
    );
    return '$_temp0';
  }

  @override
  String get gigsOpenRequests => 'Demandes ouvertes';

  @override
  String get gigsAwaitingResponseOrPayment =>
      'En attente de réponse ou de paiement';

  @override
  String get gigsActiveJobs => 'Missions actives';

  @override
  String get gigsPaidOrInProgress => 'Payées ou en cours';

  @override
  String get gigsPayoutsHandledNote =>
      'Les versements et les frais de plateforme passent par vos flux MTN et comptables existants.';

  @override
  String get gigsRequestSentTrack =>
      'Demande envoyée. Suivez-la dans Mes demandes.';

  @override
  String get gigsPricing => 'Tarifs';

  @override
  String gigsFromPrice(String price) {
    return 'À partir de $price';
  }

  @override
  String get gigsAvailability => 'Disponibilité';

  @override
  String get gigsPortfolio => 'Portfolio';

  @override
  String get gigsReviews => 'Avis';

  @override
  String get gigsRequestThisProvider => 'Demander ce prestataire';

  @override
  String get gigsUnavailableNow => 'Indisponible pour le moment';

  @override
  String get gigsVerified => 'Vérifié';

  @override
  String get gigsBackgroundChecked => 'Antécédents vérifiés';

  @override
  String get gigsStandardProfile => 'Profil prestataire standard';

  @override
  String gigsReviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count avis',
      one: '1 avis',
    );
    return '$_temp0';
  }

  @override
  String gigsJobsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count missions',
      one: '1 mission',
    );
    return '$_temp0';
  }

  @override
  String get gigsAcceptedCustomerCanPay =>
      'Acceptée. Le client peut payer dans Espace services → Mes demandes (5 min).';

  @override
  String get gigsErrAcceptRetry => 'Impossible d\'accepter. Réessayez.';

  @override
  String get gigsDeclineRequestTitle => 'Refuser la demande ?';

  @override
  String get gigsDeclineRequestBody =>
      'Le client verra que vous avez refusé cette demande.';

  @override
  String get gigsDecline => 'Refuser';

  @override
  String get gigsAccept => 'Accepter';

  @override
  String get gigsRequestDeclined => 'Demande refusée.';

  @override
  String get gigsErrDeclineRetry => 'Impossible de refuser. Réessayez.';

  @override
  String get gigsAwaitingYourResponse => 'En attente de votre réponse';

  @override
  String get gigsWaitingForCustomerPayment =>
      'En attente du paiement du client';

  @override
  String get gigsIncomingRequests => 'Demandes reçues';

  @override
  String get gigsInboxEmptyHint =>
      'Quand quelqu\'un vous demande un service via l\'Espace services, sa demande apparaît ici. Vous aurez un temps limité pour accepter ou refuser.';

  @override
  String get gigsAcceptDeadlinePassed => 'Délai d\'acceptation dépassé';

  @override
  String gigsCustomerBudget(String amount) {
    return 'Budget du client : $amount RWF';
  }

  @override
  String gigsReceivedAt(String date) {
    return 'Reçue le $date';
  }

  @override
  String gigsRespondBy(String date) {
    return 'Répondre avant le $date';
  }

  @override
  String gigsPaymentDueBy(String date) {
    return 'Paiement attendu avant le $date';
  }

  @override
  String get gigsErrSignInToRegister =>
      'Vous devez être connecté pour vous inscrire comme prestataire.';

  @override
  String get gigsErrAddService =>
      'Ajoutez au moins un service que vous pouvez fournir.';

  @override
  String get gigsProfileSaved => 'Profil prestataire enregistré.';

  @override
  String gigsSaveOnlineFailed(String error) {
    return 'Impossible d\'enregistrer en ligne : $error';
  }

  @override
  String get gigsSavedOnDevice =>
      'Enregistré sur cet appareil. La synchronisation se fera dès que le serveur sera disponible.';

  @override
  String get gigsYourProviderProfile => 'Votre profil prestataire';

  @override
  String get gigsBecomeProvider => 'Devenir prestataire';

  @override
  String get gigsRegistrationIntro =>
      'Dites aux clients ce que vous proposez. Vous pouvez le modifier à tout moment.';

  @override
  String get gigsErrNameMin => 'Saisissez un nom (au moins 2 caractères).';

  @override
  String get gigsContactPhone => 'Téléphone de contact';

  @override
  String get gigsErrPhoneHelps =>
      'Le téléphone permet aux clients de vous joindre.';

  @override
  String get gigsAboutYou => 'À propos de vous';

  @override
  String get gigsErrBioMin =>
      'Ajoutez une courte présentation (au moins 12 caractères).';

  @override
  String get gigsServicesYouProvide => 'Services que vous proposez';

  @override
  String get gigsServicesHint =>
      'Un par ligne (par ex. plomberie, ménage, livraison).';

  @override
  String get gigsServices => 'Services';

  @override
  String get gigsServiceAreaOptional => 'Zone d\'intervention (facultatif)';

  @override
  String get gigsServiceAreaHint => 'Quartier, ville ou rayon';

  @override
  String get gigsCategoriesOptional => 'Catégories (facultatif)';

  @override
  String get gigsCategoriesHint => 'Aide les clients à filtrer l\'annuaire.';

  @override
  String get gigsSaveChanges => 'Enregistrer les modifications';

  @override
  String get gigsSubmitRegistration => 'Envoyer l\'inscription';

  @override
  String get gigsHowProvidersTitle => 'Prestataires';

  @override
  String get gigsHowProvidersBody =>
      'Les travailleurs s\'inscrivent et listent les services qu\'ils peuvent rendre.';

  @override
  String get gigsHowRatingsTitle => 'Notes';

  @override
  String get gigsHowRatingsBody =>
      'Nous attribuons et mettons à jour les notes selon nos vérifications et les retours clients.';

  @override
  String get gigsHowRequestsTitle => 'Demandes';

  @override
  String get gigsHowRequestsBody =>
      'Les clients envoient une demande au prestataire choisi. Celui-ci doit accepter ou refuser sous 30 minutes.';

  @override
  String get gigsHowRequestsHighlight => '30 min pour accepter';

  @override
  String get gigsHowPaymentTitle => 'Délai de paiement';

  @override
  String get gigsHowPaymentBody =>
      'Après acceptation, le client paie sous 5 minutes pour que la mission soit confirmée et financée.';

  @override
  String get gigsHowPaymentHighlight => '5 min pour payer';

  @override
  String get gigsHowExecutionTitle => 'Exécution';

  @override
  String get gigsHowExecutionBody =>
      'Une fois le paiement effectué, le travailleur peut contacter le client et réaliser le service.';

  @override
  String get gigsHowEscrowTitle => 'Séquestre et versement';

  @override
  String get gigsHowEscrowBody =>
      'Nous collectons les fonds via MTN (et des API de paiement dédiées). L\'argent est libéré une fois que les deux parties confirment la fin ; les registres suivent les soldes, la commission et les sommes dues.';

  @override
  String get gigsHowItWorksTitle => 'Fonctionnement de l\'espace services';

  @override
  String get gigsHowItWorks => 'Comment ça marche';

  @override
  String get gigsAdminTools => 'Outils d\'administration';

  @override
  String get gigsHubTagline =>
      'Trouvez des personnes pour vos travaux ou proposez vos compétences — les paiements restent sur la plateforme.';

  @override
  String get gigsFindProviders => 'Trouver des prestataires';

  @override
  String get gigsYourActivity => 'Votre activité';

  @override
  String get gigsProviderTools => 'Outils prestataire';

  @override
  String get gigsEarnOnHub => 'Gagnez de l\'argent avec l\'espace services';

  @override
  String get gigsEarnOnHubBody =>
      'Inscrivez les services que vous proposez pour que les clients vous trouvent et vous réservent.';

  @override
  String get gigsNoServicesListed => 'Aucun service listé pour le moment';

  @override
  String gigsMoreCount(String count) {
    return '+$count de plus';
  }

  @override
  String get gigsTapToEditProfile => 'Touchez pour modifier le profil';

  @override
  String get gigsEnterMomoNumberFull =>
      'Saisissez le numéro MTN MoMo à débiter (portefeuille mobile, pas un e-mail).';

  @override
  String get gigsPaymentDeclinedDefault => 'Le paiement a été refusé.';

  @override
  String get gigsNothingChargedTryAgain =>
      'Rien n\'a été débité — vous pouvez réessayer.';

  @override
  String get gigsPaymentNotConfirmed =>
      'Le paiement n\'est pas encore confirmé. Validez la demande MTN sur votre téléphone. Si de l\'argent a quitté votre compte, contactez le support avec cette demande au lieu de payer à nouveau.';

  @override
  String get gigsMoneyLeftContactSupport =>
      'Si de l\'argent a quitté votre portefeuille, contactez le support avec cette demande.';

  @override
  String get gigsPaymentSentNotUpdated =>
      'Le paiement a peut-être été envoyé, mais nous n\'avons pas pu mettre à jour la demande.';

  @override
  String gigsPayProvider(String name) {
    return 'Payer $name';
  }

  @override
  String get gigsPaySheetIntro =>
      'Nous envoyons une demande MTN MoMo au numéro ci-dessous. Validez-la sur votre téléphone ; nous attendons jusqu\'à 5 minutes la confirmation avant de marquer cette demande comme payée.';

  @override
  String get gigsPaySheetEmailNote =>
      'Si vous vous êtes connecté par e-mail (ou si nous n\'avons pas de portefeuille mobile enregistré), saisissez le numéro MTN MoMo à débiter. Il doit s\'agir d\'une ligne mobile money — pas d\'un e-mail.';

  @override
  String get gigsAmountRwf => 'Montant (RWF)';

  @override
  String get gigsMinimum100Rwf => 'Minimum 100 RWF';

  @override
  String get gigsMomoNumberLabel => 'Numéro MTN MoMo à débiter';

  @override
  String get gigsMomoNumberHelper =>
      'Utilisez le numéro du portefeuille que MTN sollicitera, pas votre e-mail de connexion';

  @override
  String get gigsErrEnterMomoNumber => 'Saisissez le numéro MTN MoMo à débiter';

  @override
  String get gigsErrMobileNotEmail =>
      'Saisissez un numéro de mobile, pas un e-mail';

  @override
  String get gigsErrValidMobile =>
      'Saisissez un numéro de mobile valide (chiffres uniquement, 9 à 15)';

  @override
  String get gigsWaitingForPayment => 'En attente du paiement…';

  @override
  String get gigsSendPaymentRequest => 'Envoyer la demande de paiement';

  @override
  String get gigsChooseService =>
      'Choisissez le service dont vous avez besoin.';

  @override
  String get gigsSomethingWentWrong =>
      'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get gigsWhichService => 'De quel service avez-vous besoin ?';

  @override
  String get gigsAmountYouWillPay => 'Montant que vous paierez (RWF)';

  @override
  String get gigsDescribeNeed => 'Décrivez votre besoin';

  @override
  String get gigsDescribeNeedExample =>
      'Exemple : réparer un robinet de cuisine qui fuit ce week-end. Je suis disponible samedi matin.';

  @override
  String get gigsErrMoreDetail =>
      'Veuillez ajouter un peu plus de détails (au moins 20 caractères).';

  @override
  String get gigsProviderHas30Min =>
      'Le prestataire a 30 minutes pour accepter. Passé ce délai, vous pourrez envoyer une nouvelle demande.';

  @override
  String get gigsSendRequest => 'Envoyer la demande';

  @override
  String get gigsTimelineRequestSent => 'Demande envoyée';

  @override
  String get gigsTimelineProviderAccepted => 'Prestataire a accepté';

  @override
  String get gigsTimelinePaymentReceived => 'Paiement reçu';

  @override
  String get gigsTimelineWorkInProgress => 'Travail en cours';

  @override
  String get gigsTimelineReviewSubmitted => 'Avis envoyé';

  @override
  String get gigsOrderTimeline => 'Chronologie de la demande';

  @override
  String get gigsErrCannotDecline =>
      'Cette demande ne peut plus être refusée. Elle a peut-être expiré ou déjà été traitée.';

  @override
  String get gigsErrDecline => 'Impossible de refuser la demande.';

  @override
  String get gigsErrDeclineConnection =>
      'Impossible de refuser la demande. Vérifiez votre connexion et réessayez.';

  @override
  String get productEditorCategorySwitchTo => 'Changer pour';

  @override
  String get productEditorCategoryPickYours =>
      'Ou choisissez l\'une des vôtres';

  @override
  String get productEditorCategorySearchToChange =>
      'Rechercher pour changer de catégorie…';

  @override
  String get productEditorCategorySearch => 'Rechercher des catégories…';

  @override
  String get productEditorCategoryNoneYet =>
      'Vous n\'avez pas encore de catégories';

  @override
  String productEditorCategoryNoMatch(String query) {
    return 'Aucun résultat pour « $query »';
  }

  @override
  String productEditorCategoryMoreHidden(int count) {
    return '$count de plus — continuez à taper pour affiner';
  }

  @override
  String productEditorCategoryCreateNamed(String name) {
    return 'Créer « $name »';
  }

  @override
  String get productEditorCategoryFiledUnder => 'Classé dans';

  @override
  String get productEditorCategoryRemove => 'Retirer la catégorie';

  @override
  String get productEditorCategoryNoneChosen =>
      'Aucune catégorie choisie — recherchez ci-dessus ou créez-en une.';

  @override
  String get productEditorCategoryCreateNew => 'Créer une nouvelle catégorie';

  @override
  String get productEditorCategoryNew => 'Nouvelle';

  @override
  String get productEditorCompositeItem => 'Article composé';

  @override
  String get productEditorCompositeHint =>
      'Composé d\'autres produits — le prix est la somme de ses composants';

  @override
  String get productEditorColorSelectShade => 'Choisir une nuance';

  @override
  String get productEditorColorShades => 'NUANCES';

  @override
  String productEditorColorHueShade(String hue, int number) {
    return '$hue · nuance $number';
  }

  @override
  String get productEditorColorSwatchHint =>
      'Utilisée comme couleur du produit dans la caisse et les rapports';

  @override
  String get productEditorColorChoose => 'Choisir la couleur';

  @override
  String get productEditorHueRed => 'Rouge';

  @override
  String get productEditorHueOrange => 'Orange';

  @override
  String get productEditorHueAmber => 'Ambre';

  @override
  String get productEditorHueGreen => 'Vert';

  @override
  String get productEditorHueTeal => 'Bleu canard';

  @override
  String get productEditorHueBlue => 'Bleu';

  @override
  String get productEditorHueIndigo => 'Indigo';

  @override
  String get productEditorHueViolet => 'Violet';

  @override
  String get productEditorHueSlate => 'Ardoise';

  @override
  String get productEditorReadyToSave => 'Prêt à enregistrer';

  @override
  String productEditorSectionsComplete(String done, String total) {
    return '$done sur $total sections terminées';
  }

  @override
  String get productEditorSaveProduct => 'Enregistrer le produit';

  @override
  String get productEditorUntitledProduct => 'Produit sans nom';

  @override
  String get productEditorBreadcrumbNewProduct => 'STOCK · NOUVEAU PRODUIT';

  @override
  String get productEditorBreadcrumbEditProduct =>
      'STOCK · MODIFIER LE PRODUIT';

  @override
  String get productEditorBreadcrumbNewComposite =>
      'STOCK · NOUVEL ARTICLE COMPOSÉ';

  @override
  String get productEditorBreadcrumbEditComposite =>
      'STOCK · MODIFIER L\'ARTICLE COMPOSÉ';

  @override
  String get productEditorOptional => 'facultatif';

  @override
  String get productEditorItemTypeFinished => 'Produit fini — prêt à la vente';

  @override
  String get productEditorItemTypeRawMaterial =>
      'Matière première — sert à fabriquer d\'autres produits';

  @override
  String get productEditorItemTypeService => 'Service — rien à garder en stock';

  @override
  String get productEditorCategoryHint =>
      'Regroupe ce produit dans les rapports et sur l\'écran de vente.';

  @override
  String get productEditorItemType => 'Type d\'article';

  @override
  String get productEditorItemTypeLocked =>
      'Verrouillé — ne peut plus être modifié après la création du produit.';

  @override
  String get productEditorItemTypeHint =>
      'La plupart des articles en boutique sont des produits finis.';

  @override
  String get productEditorPackagingUnit => 'Unité d\'emballage';

  @override
  String get productEditorCountryOfOrigin => 'Pays d\'origine';

  @override
  String get productEditorNoCountryList =>
      'Liste des pays pas encore disponible — les nouveaux produits sont enregistrés avec RW.';

  @override
  String get productEditorCountryDefaultRw => 'RW (par défaut)';

  @override
  String get productEditorCountriesLoadFailed =>
      'Impossible de charger les pays';

  @override
  String get productEditorOriginNotSet => 'origine non définie';

  @override
  String get productEditorTaxDetailsTitle =>
      'Emballage et origine (pour la déclaration fiscale)';

  @override
  String get productEditorTapToHide => 'Appuyez pour masquer';

  @override
  String get productEditorProfitPerUnit => 'Bénéfice par unité';

  @override
  String get productEditorMargin => 'Marge';

  @override
  String get productEditorSupplyFromComponents =>
      'Prix d\'achat calculé à partir des composants';

  @override
  String get productEditorNoVariantsExisting =>
      'Ce produit n\'a aucune variante';

  @override
  String get productEditorNoVariantsYet => 'Aucune variante pour l\'instant';

  @override
  String get productEditorNoVariantsHint =>
      'Scannez un code-barres ou saisissez un nom ci-dessus pour en ajouter une';

  @override
  String get productEditorSectionsHeading => 'SECTIONS';

  @override
  String get productEditorScanHint =>
      'Scannez ou saisissez le nom de la variante…';

  @override
  String get productEditorScanWithCamera => 'Scanner avec la caméra';

  @override
  String get productEditorAddVariant => 'Ajouter une variante';

  @override
  String get productEditorScanTipPress => 'Appuyez sur';

  @override
  String get productEditorScanTipEnterKey => 'Entrée';

  @override
  String get productEditorScanTipOrTapAdd =>
      'ou appuyez sur Ajouter une variante';

  @override
  String get productEntryAddNewProduct => 'Ajouter un produit';

  @override
  String get productEntryEditProduct => 'Modifier le produit';

  @override
  String get productEntryNameRequired => 'Le nom du produit est obligatoire';

  @override
  String get productEntryNameTooShort =>
      'Le nom du produit doit contenir au moins 3 caractères';

  @override
  String get productEntryProductName => 'Nom du produit';

  @override
  String get productEntryProductNameHint => 'ex. Café Arabica';

  @override
  String get productEntryInventoryTitle => 'Stock et catégorisation';

  @override
  String get productEntryPackagingUnit => 'Unité d\'emballage';

  @override
  String get productEntryPriceRequired => 'Le prix est obligatoire';

  @override
  String get productEntryRetailPrice => 'Prix de vente';

  @override
  String get productEntrySupplyPrice => 'Prix d\'achat';

  @override
  String get productEntryQuickScan => 'Scan rapide';

  @override
  String get productEntryScanLabel =>
      'Scannez ou saisissez le nom de la variante';

  @override
  String get productionOutputLoadingSku => 'Chargement...';

  @override
  String get inventoryDashboardTotalItems => 'Total des articles';

  @override
  String get inventoryDashboardExpiredItems => 'Articles expirés';

  @override
  String get inventoryDashboardLowStockItems => 'Articles en stock faible';

  @override
  String get inventoryDashboardPendingOrders => 'Commandes en attente';

  @override
  String get inventoryDashboardFromLastWeek =>
      'par rapport à la semaine dernière';

  @override
  String get inventoryDashboardTrendEstimate =>
      'Cette tendance est basée sur une estimation';

  @override
  String inventoryDashboardIdValue(String id) {
    return 'ID : $id';
  }

  @override
  String inventoryDashboardCategoryValue(String category) {
    return 'Catégorie : $category';
  }

  @override
  String inventoryDashboardQuantityValue(String quantity) {
    return 'Quantité : $quantity';
  }

  @override
  String inventoryDashboardLocationValue(String location) {
    return 'Emplacement : $location';
  }

  @override
  String inventoryDashboardExpiryDateValue(String date) {
    return 'Date d\'expiration : $date';
  }

  @override
  String inventoryDashboardExpiredLoadError(String error) {
    return 'Erreur lors du chargement des articles expirés : $error';
  }

  @override
  String inventoryDashboardNearExpiryLoadError(String error) {
    return 'Erreur lors du chargement des articles bientôt expirés : $error';
  }

  @override
  String get inventoryDashboardViewAll => 'Tout voir';

  @override
  String get inventoryDashboardExpiredOn => 'Expiré le';

  @override
  String get inventoryDashboardAllExpiredItems => 'Tous les articles expirés';

  @override
  String inventoryDashboardExpiredOnDate(String date) {
    return 'Expiré le : $date';
  }

  @override
  String get inventoryDashboardNearExpiryItems => 'Articles bientôt expirés';

  @override
  String inventoryDashboardUnitsAtLocation(int count, String location) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unités - $location',
      one: '1 unité - $location',
    );
    return '$_temp0';
  }

  @override
  String inventoryDashboardDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours restants',
      one: '1 jour restant',
    );
    return '$_temp0';
  }

  @override
  String get inventoryDashboardByCategory => 'Stock par catégorie';

  @override
  String get inventoryDashboardStockLevelsTrend =>
      'Évolution des niveaux de stock';

  @override
  String get inventoryDashboardRecentOrders => 'Commandes récentes';

  @override
  String inventoryDashboardOrderLine(String id, String date) {
    return 'Commande n° $id - $date';
  }

  @override
  String get inventoryDashboardStatusDelivered => 'Livrée';

  @override
  String get inventoryDashboardStatusInTransit => 'En transit';

  @override
  String get inventoryDashboardStatusProcessing => 'En cours de traitement';

  @override
  String get inventoryDashboardStatusCancelled => 'Annulée';

  @override
  String get inventoryDashboardRunningLow =>
      'Stock bientôt épuisé (prévision sur 7 jours)';

  @override
  String inventoryDashboardStockValue(String stock) {
    return 'Stock : $stock';
  }

  @override
  String inventoryDashboardDailyUsage(String usage) {
    return 'Consommation journalière : $usage';
  }

  @override
  String get inventoryDashboardReplenish => 'Réapprovisionner';

  @override
  String get inventoryDashboardUnknownLocation => 'Inconnu';

  @override
  String inventoryDashboardBranchFallback(String id) {
    return 'Succursale $id';
  }

  @override
  String get inventoryDashboardUncategorized => 'Sans catégorie';

  @override
  String stockValueItemsNeedRestock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles à réapprovisionner',
      one: '1 article à réapprovisionner',
    );
    return '$_temp0';
  }

  @override
  String get stockValueViewAllArrow => 'Tout voir →';

  @override
  String get stockValueStatusCritical => 'Critique';

  @override
  String get stockValueStatusLow => 'Faible';

  @override
  String get stockValueStatusOk => 'OK';

  @override
  String get stockValueTitleMobile => 'Valeurs du stock';

  @override
  String get stockValueTitle => 'Valeur du stock';

  @override
  String stockValueProductsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count produits',
      one: '1 produit',
    );
    return '$_temp0';
  }

  @override
  String get stockValueLoadError =>
      'Impossible de charger le rapport de stock.';

  @override
  String get stockValueTotalValueCaps => 'VALEUR TOTALE';

  @override
  String stockValueRwfItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'RWF · $count articles',
      one: 'RWF · 1 article',
    );
    return '$_temp0';
  }

  @override
  String get stockValueNeedsRestockCaps => 'À RÉAPPROVISIONNER';

  @override
  String get stockValueCriticalOrLow => 'critique ou faible';

  @override
  String get stockValuePartialSync =>
      'Les données peuvent être incomplètes (synchronisation partielle).';

  @override
  String get stockValueLowCriticalCaps => 'ARTICLES FAIBLES ET CRITIQUES';

  @override
  String get stockValueNoLowStock =>
      'Aucun article en stock faible dans les données locales.';

  @override
  String get stockValueByCategoryCaps => 'VALEUR PAR CATÉGORIE';

  @override
  String get stockValueNoCategoryBreakdown =>
      'Aucune répartition par catégorie disponible.';

  @override
  String get stockValueLoadingProducts => 'Chargement des produits…';

  @override
  String get stockValueRestockHint =>
      'Utilisez le stock ou la réception de marchandises pour réapprovisionner.';

  @override
  String get stockValueNoRowsToExport =>
      'Aucune ligne à exporter pour ce filtre.';

  @override
  String get stockValueCsvProduct => 'Produit';

  @override
  String get stockValueCsvUnitPrice => 'Prix unitaire';

  @override
  String get stockValueCsvStock => 'Stock';

  @override
  String get stockValueCsvLineValue => 'Valeur de la ligne';

  @override
  String get stockValueCsvStatus => 'Statut';

  @override
  String stockValueCopiedCsvRows(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lignes copiées en CSV dans le presse-papiers.',
      one: '1 ligne copiée en CSV dans le presse-papiers.',
    );
    return '$_temp0';
  }

  @override
  String stockValueDesktopSubtitle(int products, int categories, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      products,
      locale: localeName,
      other: '$products produits',
      one: '1 produit',
    );
    String _temp1 = intl.Intl.pluralLogic(
      categories,
      locale: localeName,
      other: '$categories catégories',
      one: '1 catégorie',
    );
    return '$_temp0 dans $_temp1 · Mis à jour aujourd\'hui à $time';
  }

  @override
  String get stockValueSearchHint => 'Rechercher un produit ou un BCD...';

  @override
  String get stockValueExport => 'Exporter';

  @override
  String get stockValueRestockOrder => '+ Commande de réapprovisionnement';

  @override
  String get stockValueTotalStockValue => 'Valeur totale du stock';

  @override
  String get stockValueAtRetailSupply => 'Au prix de vente/d\'achat';

  @override
  String get stockValueHealthyStock => 'Stock sain';

  @override
  String get stockValueWellStocked => 'produits bien approvisionnés';

  @override
  String stockValuePercentOfCatalogue(String percent) {
    return '$percent % du catalogue';
  }

  @override
  String get stockValueCriticalLow => 'Critique / faible';

  @override
  String get stockValueNeedRestocking => 'à réapprovisionner';

  @override
  String get stockValueReviewAlerts => 'voir les alertes →';

  @override
  String get stockValueHighestValueItem => 'Article de plus grande valeur';

  @override
  String get stockValueNoValueOnHand => 'Aucune valeur en stock';

  @override
  String stockValueTopItemDetail(String value, String units) {
    return '$value · $units unités';
  }

  @override
  String stockValuePercentOfTotal(String percent) {
    return '$percent % de la valeur totale';
  }

  @override
  String get stockValueAllProducts => 'Tous les produits';

  @override
  String get stockValueFilterAll => 'Tous';

  @override
  String get stockValueNoProductsMatch =>
      'Aucun produit ne correspond à la recherche ou au filtre.';

  @override
  String get stockValueColProduct => 'PRODUIT';

  @override
  String get stockValueColCategory => 'CATÉGORIE';

  @override
  String get stockValueColUnitPrice => 'PRIX UNITAIRE';

  @override
  String get stockValueColStock => 'STOCK';

  @override
  String get stockValueColValue => 'VALEUR';

  @override
  String get stockValueColStatus => 'STATUT';

  @override
  String get stockValueNoCategoryData => 'Aucune donnée de catégorie.';

  @override
  String get stockValueByCategory => 'Valeur par catégorie';

  @override
  String get stockValueRestockAlerts => 'Alertes de réapprovisionnement';

  @override
  String get stockValueNoRestockAlerts =>
      'Aucune alerte de réapprovisionnement.';

  @override
  String stockValueUnitsMin(String units, String min) {
    return '$units unités, min : $min';
  }

  @override
  String get stockValueSalesLoadError =>
      'Impossible de charger les données de vente.';

  @override
  String stockValueInStock(String count) {
    return '$count en stock';
  }

  @override
  String stockValuePerUnit(String price) {
    return '$price / unité';
  }

  @override
  String get stockValueStockValueCaps => 'VALEUR DU STOCK';

  @override
  String stockValueUnitsTimesPrice(String units, String price) {
    return '$units unités × $price';
  }

  @override
  String get stockValueTotalSalesCaps => 'VENTES TOTALES';

  @override
  String stockValueUnitsSoldPeriod(String units) {
    return '$units unités vendues (période)';
  }

  @override
  String get stockValueProfitCaps => 'BÉNÉFICE';

  @override
  String stockValueMarginEst(String percent) {
    return '$percent % de marge (est.)';
  }

  @override
  String get stockValueStockPerformance => 'Performance du stock';

  @override
  String stockValueRangeDays(int days) {
    return '$days J';
  }

  @override
  String get stockValueNoSalesVolume => 'Aucune vente sur cette période.';

  @override
  String get stockValueSalesVolume => 'Volume des ventes';

  @override
  String get stockValueDetailedMetrics => 'Indicateurs détaillés';

  @override
  String get stockValueTurnoverCaps => 'ROTATION DU STOCK';

  @override
  String get stockValueTurnoverFooter =>
      'Par rapport au stock disponible sur la période.';

  @override
  String get stockValueGrossMarginCaps => 'MARGE BRUTE';

  @override
  String get stockValueGrossMarginFooter =>
      'Estimée à partir du prix de vente et du prix d\'achat des unités vendues.';

  @override
  String get stockValueAvgTransactionCaps => 'TRANSACTION MOY.';

  @override
  String get stockValueAvgTransactionFooter =>
      'Chiffre d\'affaires / transactions distinctes sur la période.';

  @override
  String get stockValueUnitsSoldCaps => 'UNITÉS VENDUES';

  @override
  String get stockValueUnitsSoldFooter =>
      'Total des unités sur la période choisie.';

  @override
  String get stockValueDeleteUnavailable =>
      'La suppression du produit n\'est pas disponible ici.';

  @override
  String get stockValueEditProduct => 'Modifier le produit';

  @override
  String get stockValueCopiedSummary => 'Résumé copié dans le presse-papiers.';

  @override
  String get tenantMgmtCommissionAgentMigrationRequired =>
      'Les agents à commission uniquement nécessitent une mise à jour de la base de données. Appliquez la migration supabase/migrations/20260518120000_agent_allow_business_login.sql (par ex. supabase db push), ou activez « Autoriser la connexion à cette entreprise » et réessayez.';

  @override
  String get tenantMgmtNoBusinessSelected => 'Aucune entreprise sélectionnée';

  @override
  String get tenantMgmtAgentBranchNameRequired =>
      'Veuillez saisir un nom de succursale pour l\'agent';

  @override
  String get tenantMgmtBranchNotInBusiness =>
      'La succursale sélectionnée n\'appartient pas à l\'entreprise actuelle. Changez d\'entreprise ou de succursale et réessayez.';

  @override
  String tenantMgmtUserLookupFailed(String details) {
    return 'Utilisateur introuvable avec ce téléphone/e-mail : $details';
  }

  @override
  String get tenantMgmtSavePermissionsSupabaseError =>
      'Échec de l\'enregistrement des autorisations (erreur Supabase).';

  @override
  String tenantMgmtSavePermissionsOrphanHint(String error) {
    return '$error Le compte de connexion existe peut-être déjà sans lien avec cette entreprise — ouvrez la gestion des utilisateurs et ajoutez à nouveau cet utilisateur pour terminer.';
  }

  @override
  String tenantMgmtSavePermissionsFailed(String error) {
    return 'Échec de l\'enregistrement des autorisations : $error';
  }

  @override
  String tenantMgmtPinGenerationFailed(String details) {
    return 'Échec de la génération du PIN pour le nouvel utilisateur : $details';
  }

  @override
  String get tenantMgmtOrphanUser =>
      'L\'utilisateur a été créé mais n\'est pas lié à cette entreprise. Rouvrez la gestion des utilisateurs et enregistrez à nouveau, ou exécutez la migration supabase 20260519150000_repair_orphan_users_with_pins.sql.';

  @override
  String get tenantMgmtCreated => 'Utilisateur créé avec succès';

  @override
  String get tenantMgmtPermissionsSaved =>
      'Autorisations enregistrées. Les utilisateurs en ligne sont mis à jour automatiquement ; ceux hors ligne verront les changements à leur prochaine connexion.';

  @override
  String get tenantMgmtPermissionsSavedSelf =>
      'Autorisations enregistrées. Vos menus ont été actualisés.';

  @override
  String tenantMgmtUnexpectedError(String error) {
    return 'Une erreur inattendue s\'est produite : $error';
  }

  @override
  String get tenantMgmtAdminCannotDelete =>
      'Les administrateurs ne peuvent pas être supprimés.';

  @override
  String get tenantMgmtDeleted => 'Utilisateur supprimé avec succès';

  @override
  String get tenantMgmtDeleteFailed =>
      'Erreur lors de la suppression de l\'utilisateur. Veuillez réessayer.';

  @override
  String get tenantMgmtDeleteTitle => 'Supprimer l\'utilisateur';

  @override
  String get tenantMgmtDeleteConfirm =>
      'Voulez-vous vraiment supprimer cet utilisateur ?';

  @override
  String get tenantMgmtEnterPhoneOrEmail =>
      'Saisissez un numéro ou une adresse e-mail valide';

  @override
  String get tenantMgmtPhoneNeedsCountryCode =>
      'Le numéro doit contenir l\'indicatif du pays avec le signe +';

  @override
  String get tenantMgmtInvalidPhone => 'Numéro de téléphone invalide';

  @override
  String get tenantMgmtInvalidPhoneFormat =>
      'Format de numéro de téléphone invalide';

  @override
  String get tenantMgmtModulePermissions => 'AUTORISATIONS PAR MODULE';

  @override
  String get tenantMgmtColModule => 'MODULE';

  @override
  String get tenantMgmtColAccessLevel => 'NIVEAU D\'ACCÈS';

  @override
  String get tenantMgmtColActive => 'ACTIF';

  @override
  String get tenantMgmtFeatureInventory => 'Stock';

  @override
  String get tenantMgmtFeatureSettings => 'Paramètres';

  @override
  String get tenantMgmtFeatureReports => 'Rapports';

  @override
  String get tenantMgmtFeatureTransactions => 'Transactions';

  @override
  String get tenantMgmtFeatureTickets => 'Tickets';

  @override
  String get tenantMgmtFeatureOrders => 'Commandes';

  @override
  String get tenantMgmtFeatureLeads => 'Prospects';

  @override
  String get tenantMgmtFeatureAddProduct => 'Ajouter un produit';

  @override
  String get tenantMgmtFeatureSales => 'Ventes';

  @override
  String get tenantMgmtFeatureDriver => 'Livreur';

  @override
  String get tenantMgmtFeatureStock => 'Stock';

  @override
  String get tenantMgmtFeatureShiftHistory => 'Historique des services';

  @override
  String get tenantMgmtFeatureTicketReview => 'Vérification des tickets';

  @override
  String get tenantMgmtFeatureStockHandover => 'Remise du stock';

  @override
  String get tenantMgmtFeatureHideStockQuantity =>
      'Masquer la quantité en stock';

  @override
  String get tenantMgmtAccessNone => 'Aucun accès';

  @override
  String get tenantMgmtAccessRead => 'Lecture';

  @override
  String get tenantMgmtAccessWrite => 'Écriture';

  @override
  String get tenantMgmtAccessAdmin => 'Administrateur';

  @override
  String get tenantMgmtRoleUser => 'Utilisateur';

  @override
  String get tenantMgmtRoleAdmin => 'Administrateur';

  @override
  String get tenantMgmtRoleAgent => 'Agent';

  @override
  String get tenantMgmtRoleCashier => 'Caissier';

  @override
  String get tenantMgmtRoleDriver => 'Livreur';

  @override
  String get tenantMgmtRoleViewer => 'Lecteur';

  @override
  String get tenantMgmtRoleReviewer => 'Vérificateur';

  @override
  String get tenantMgmtRoleStockManager => 'Gestionnaire de stock';

  @override
  String get tenantMgmtCurrentUsers => 'UTILISATEURS ACTUELS';

  @override
  String get tenantMgmtSearchUsers => 'Rechercher des utilisateurs...';

  @override
  String get tenantMgmtNoUsers => 'Aucun utilisateur pour l\'instant.';

  @override
  String get tenantMgmtNoUsersMatch =>
      'Aucun utilisateur ne correspond à votre recherche.';

  @override
  String get tenantMgmtNoContact => 'Aucun contact';

  @override
  String get tenantMgmtNoBranches => 'Aucune succursale disponible';

  @override
  String get tenantMgmtUnnamedBranch => 'Succursale sans nom';

  @override
  String get tenantMgmtSelectBranch => 'Choisir une succursale';

  @override
  String tenantMgmtErrorValue(String error) {
    return 'Erreur : $error';
  }

  @override
  String get tenantMgmtUserTypeCaps => 'TYPE D\'UTILISATEUR';

  @override
  String get tenantMgmtEditUser => 'Modifier l\'utilisateur';

  @override
  String get tenantMgmtAddNewUser => 'Ajouter un utilisateur';

  @override
  String get tenantMgmtFullNameCaps => 'NOM COMPLET';

  @override
  String get tenantMgmtEnterName => 'Veuillez saisir un nom';

  @override
  String get tenantMgmtPhoneEmailCaps => 'TÉLÉPHONE / E-MAIL';

  @override
  String get tenantMgmtAgentBranchNameCaps => 'NOM DE LA SUCCURSALE (AGENT)';

  @override
  String get tenantMgmtEnterBranchName =>
      'Veuillez saisir un nom de succursale';

  @override
  String get tenantMgmtBranchNameTooShort =>
      'Le nom de la succursale est trop court';

  @override
  String get tenantMgmtUpdateUser => 'Mettre à jour l\'utilisateur';

  @override
  String get tenantMgmtAddUser => '+ Ajouter un utilisateur';

  @override
  String get tenantMgmtAllowBusinessLogin =>
      'Autoriser la connexion à cette entreprise';

  @override
  String get tenantMgmtAllowBusinessLoginHint =>
      'Désactivé par défaut : l\'agent reçoit un PIN mais ne voit que sa commission pour cette entreprise. Activez pour donner l\'accès au tableau de bord selon les autorisations ci-dessous.';

  @override
  String get tenantMgmtCommissionOnlyHint =>
      'Les autorisations par module ne s\'appliquent pas en mode commission uniquement. L\'agent se connectera avec son PIN et ne verra que sa commission pour cette entreprise.';

  @override
  String stockValueUnitsValue(String units) {
    return '$units unités';
  }

  @override
  String stockValueMinValue(String min) {
    return 'min : $min';
  }

  @override
  String stockValueItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return '$_temp0';
  }

  @override
  String get dailyReportRecipientsInvalidEmail =>
      'Saisissez une adresse e-mail valide.';

  @override
  String get dailyReportRecipientsNoBusiness =>
      'Aucune entreprise sélectionnée.';

  @override
  String get dailyReportRecipientsNotSetUpRunMigration =>
      'Les destinataires du rapport quotidien ne sont pas encore configurés. Demandez à votre administrateur d\'exécuter la dernière migration Supabase (business_report_recipients).';

  @override
  String get dailyReportRecipientsDuplicate =>
      'Cette adresse e-mail figure déjà dans la liste du rapport quotidien.';

  @override
  String get dailyReportRecipientsCouldNotAdd =>
      'Impossible d\'ajouter le destinataire.';

  @override
  String get dailyReportRecipientsNotSetUp =>
      'Les destinataires du rapport quotidien ne sont pas encore configurés.';

  @override
  String get dailyReportRecipientsCouldNotRemove =>
      'Impossible de retirer le destinataire.';

  @override
  String dailyReportRecipientsLoadFailed(String error) {
    return 'Impossible de charger les destinataires du rapport quotidien : $error';
  }

  @override
  String get dailyReportRecipientsEnterEmail => 'Saisissez une adresse e-mail.';

  @override
  String get dailyReportRecipientsAdded => 'Destinataire ajouté.';

  @override
  String dailyReportRecipientsAddFailed(String error) {
    return 'Impossible d\'ajouter le destinataire : $error';
  }

  @override
  String get dailyReportRecipientsRemoved => 'Destinataire retiré.';

  @override
  String dailyReportRecipientsRemoveFailed(String error) {
    return 'Impossible de retirer le destinataire : $error';
  }

  @override
  String get dailyReportRecipientsEmailHint => 'ex. comptable@example.com';

  @override
  String get dailyReportRecipientsLabelHint => 'Libellé (facultatif)';

  @override
  String get dailyReportRecipientsSave => 'Enregistrer le destinataire';

  @override
  String get dailyReportRecipientsAddTitle => 'Ajouter un destinataire';

  @override
  String get dailyReportRecipientsTitle => 'Destinataires du rapport quotidien';

  @override
  String get dailyReportRecipientsSubtitle =>
      'L\'adresse e-mail du propriétaire ci-dessus reçoit le rapport quotidien détaillé des transactions. Ajoutez d\'autres adresses pour recevoir le même rapport.';

  @override
  String get dailyReportRecipientsEmpty =>
      'Aucun destinataire supplémentaire pour le moment.';

  @override
  String transfersReportPdfExportFailed(String error) {
    return 'Échec de l\'export PDF : $error';
  }

  @override
  String get transfersReportAllDates => 'Toutes les dates';

  @override
  String transfersReportLoadFailed(String error) {
    return 'Impossible de charger les transferts : $error';
  }

  @override
  String get transfersReportSelectDestination => 'Sélectionnez une destination';

  @override
  String get transfersReportSelectDestinationBody =>
      'Choisissez une succursale de destination pour charger ses transferts.';

  @override
  String transfersReportCountTo(int count, String branch) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transferts',
      one: '1 transfert',
    );
    return '$_temp0 vers $branch';
  }

  @override
  String get transfersReportNoTransfers => 'Aucun transfert';

  @override
  String get transfersReportNoTransfersBody =>
      'Aucun transfert ne correspond à ce filtre pour la période sélectionnée.';

  @override
  String get transfersReportTitle => 'Rapport des transferts';

  @override
  String get transfersReportSubtitle =>
      'Transferts de stock reçus par une succursale de destination';

  @override
  String get transfersReportExportPdf => 'Exporter en PDF';

  @override
  String get transfersReportBranchesLoadFailed =>
      'Impossible de charger les succursales';

  @override
  String get transfersReportToBranch => 'Succursale de destination';

  @override
  String get transfersReportFilterAll => 'Tous';

  @override
  String get transfersReportStatusPending => 'En attente';

  @override
  String get transfersReportStatusProcessing => 'En cours';

  @override
  String get transfersReportStatusPartiallyApproved => 'Partiellement approuvé';

  @override
  String get transfersReportStatusRejected => 'Rejeté';

  @override
  String get transfersReportStatusFulfilled => 'Livré';

  @override
  String get transfersReportStatusVoided => 'Annulé';

  @override
  String transfersReportItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return '$_temp0';
  }

  @override
  String get transfersReportNoLineItems => 'Aucune ligne d\'article incluse';

  @override
  String get transfersReportStatusAndDelivery => 'Statut et livraison';

  @override
  String get transfersReportStatus => 'Statut';

  @override
  String get transfersReportReceivedOn => 'Reçu le';

  @override
  String get transfersReportViewPdf => 'Voir le PDF';

  @override
  String get transfersReportDownload => 'Télécharger';

  @override
  String get transfersReportFromLabel => 'De :';

  @override
  String get transfersReportToLabel => 'Vers :';

  @override
  String transfersReportQty(String qty) {
    return 'Qté : $qty';
  }

  @override
  String get transfersReportPdfStockTransferSubject => 'Transfert de stock';

  @override
  String get transfersReportPdfSaveDialog =>
      'Enregistrer le PDF des transferts';

  @override
  String transfersReportPdfTitleTo(String branch) {
    return 'Transferts de stock vers $branch';
  }

  @override
  String transfersReportPdfTransferCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transferts',
      one: '1 transfert',
    );
    return '$_temp0';
  }

  @override
  String transfersReportPdfUnitCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unités',
      one: '1 unité',
    );
    return '$_temp0';
  }

  @override
  String get transfersReportPdfNoTransfers =>
      'Aucun transfert sur cette période.';

  @override
  String get transfersReportColDate => 'Date';

  @override
  String get transfersReportColFrom => 'De';

  @override
  String get transfersReportColProduct => 'Produit';

  @override
  String get transfersReportColQty => 'Qté';

  @override
  String get transfersReportColRequested => 'Demandé';

  @override
  String transfersReportPdfTransferFrom(String id, String branch) {
    return 'Transfert $id · depuis $branch';
  }

  @override
  String transfersReportPdfFooter(String date, String page, String pages) {
    return 'Généré le $date · page $page/$pages';
  }

  @override
  String transfersReportPdfSingleTitle(String id) {
    return 'Transfert de stock $id';
  }

  @override
  String transfersReportPdfApprovedBy(String name) {
    return 'Approuvé par : $name';
  }

  @override
  String get dailyReportFilesRangeAllTime => 'Toute la période';

  @override
  String get dailyReportFilesRangeLast7Days => '7 derniers jours';

  @override
  String get dailyReportFilesRangeLast30Days => '30 derniers jours';

  @override
  String get dailyReportFilesRangeLast90Days => '90 derniers jours';

  @override
  String get dailyReportFilesRangeThisMonth => 'Ce mois-ci';

  @override
  String get dailyReportFilesRangeLastMonth => 'Le mois dernier';

  @override
  String get dailyReportFilesSortNewest => 'Plus récents d\'abord';

  @override
  String get dailyReportFilesSortOldest => 'Plus anciens d\'abord';

  @override
  String get dailyReportFilesSortNameAsc => 'Nom A–Z';

  @override
  String get dailyReportFilesSortNameDesc => 'Nom Z–A';

  @override
  String get dailyReportFilesTypeAll => 'Tous';

  @override
  String get dailyReportFilesTypeTransactions => 'Transactions';

  @override
  String get dailyReportFilesTypeMerged => 'Fusionnés';

  @override
  String get dailyReportFilesShareUnsupportedWeb =>
      'Le partage n\'est pas pris en charge dans le navigateur.';

  @override
  String get dailyReportFilesShareSubjectOne => 'Rapport quotidien';

  @override
  String get dailyReportFilesNoActiveBranch => 'Aucune succursale active.';

  @override
  String get dailyReportFilesNoStorageKey =>
      'Ce fichier n\'a pas encore de clé de stockage.';

  @override
  String dailyReportFilesSaved(String name) {
    return '$name enregistré';
  }

  @override
  String get dailyReportFilesReportFallback => 'rapport';

  @override
  String dailyReportFilesDownloaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers téléchargés',
      one: '1 fichier téléchargé',
    );
    return '$_temp0';
  }

  @override
  String dailyReportFilesShared(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers partagés',
      one: '1 fichier partagé',
    );
    return '$_temp0';
  }

  @override
  String get dailyReportFilesAlreadyArchived =>
      'Les fichiers sélectionnés sont déjà archivés.';

  @override
  String get dailyReportFilesSelectedNoStorageKey =>
      'Les fichiers sélectionnés n\'ont pas encore de clé de stockage.';

  @override
  String get dailyReportFilesNoneArchived =>
      'Aucun fichier n\'a pu être archivé.';

  @override
  String dailyReportFilesArchived(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers archivés',
      one: '1 fichier archivé',
    );
    return '$_temp0';
  }

  @override
  String dailyReportFilesArchivedSkipped(String summary, String skipped) {
    return '$summary ($skipped ignoré(s) — pas encore de clé de stockage)';
  }

  @override
  String get dailyReportFilesMergeNeedsKeys =>
      'Chaque rapport sélectionné doit avoir une clé de stockage avant la fusion.';

  @override
  String dailyReportFilesMerged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rapports fusionnés. Nouveau classeur ajouté à la liste.',
      one: '1 rapport fusionné. Nouveau classeur ajouté à la liste.',
    );
    return '$_temp0';
  }

  @override
  String get dailyReportFilesCurrentBranch => 'Succursale actuelle';

  @override
  String get dailyReportFilesNoBranch => 'Aucune succursale';

  @override
  String get dailyReportFilesNoBranchSelectedBody =>
      'Sélectionnez une succursale pour voir les exports Excel quotidiens.';

  @override
  String get dailyReportFilesLoadFailed => 'Impossible de charger les rapports';

  @override
  String get dailyReportFilesCheckConnection =>
      'Vérifiez votre connexion et réessayez.';

  @override
  String get dailyReportFilesEmptyTitle =>
      'Aucun rapport quotidien pour le moment';

  @override
  String get dailyReportFilesNoMatches => 'Aucun résultat';

  @override
  String get dailyReportFilesEmptyBody =>
      'Lorsque des rapports seront générés pour cette succursale, ils apparaîtront ici pour être téléchargés.';

  @override
  String get dailyReportFilesNoMatchesFiltered =>
      'Essayez une autre recherche, période ou un autre type.';

  @override
  String get dailyReportFilesNoMatchesSearch =>
      'Essayez un autre nom de rapport, une autre date ou un autre ID.';

  @override
  String get dailyReportFilesClearFilters => 'Effacer les filtres';

  @override
  String dailyReportFilesSubtitle(String branch) {
    return 'Exports Excel générés pour $branch. Sélectionnez plusieurs fichiers pour les télécharger ensemble.';
  }

  @override
  String get dailyReportFilesKpiFiles => 'Fichiers';

  @override
  String get dailyReportFilesKpiNoneYet => 'aucun pour l\'instant';

  @override
  String get dailyReportFilesKpiAvailable => 'disponibles';

  @override
  String get dailyReportFilesKpiReportDays => 'Jours de rapport';

  @override
  String dailyReportFilesKpiDaysGrouped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'jours regroupés',
      one: 'jour regroupé',
    );
    return '$_temp0';
  }

  @override
  String get dailyReportFilesKpiReadyFiles => 'Fichiers prêts';

  @override
  String get dailyReportFilesKpiWithStorageKeys => 'avec clé de stockage';

  @override
  String get dailyReportFilesKpiLastGenerated => 'Dernière génération';

  @override
  String get dailyReportFilesKpiNoExports => 'Aucun export';

  @override
  String get dailyReportFilesToday => 'Aujourd\'hui';

  @override
  String get dailyReportFilesYesterday => 'Hier';

  @override
  String dailyReportFilesSelectedCount(String count) {
    return '$count sélectionné(s)';
  }

  @override
  String dailyReportFilesFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers',
      one: '1 fichier',
    );
    return '$_temp0';
  }

  @override
  String get dailyReportFilesAutoSync =>
      'Synchronisation auto toutes les 5 min';

  @override
  String get dailyReportFilesSearchHint =>
      'Rechercher par nom de rapport, date ou ID…';

  @override
  String get dailyReportFilesFocusSearch => 'Aller à la recherche (⌘K)';

  @override
  String get dailyReportFilesTypeLabel => 'Type :';

  @override
  String get dailyReportFilesSortLabel => 'Tri :';

  @override
  String get dailyReportFilesGroupByDay => 'Grouper par jour';

  @override
  String get dailyReportFilesFlatList => 'Liste simple';

  @override
  String get dailyReportFilesUnknownDate => 'Date inconnue';

  @override
  String get dailyReportFilesNoReportDay => 'Aucun jour de rapport';

  @override
  String get dailyReportFilesPreview => 'Aperçu';

  @override
  String get dailyReportFilesDownload => 'Télécharger';

  @override
  String get dailyReportFilesMoreActions => 'Plus d\'actions';

  @override
  String get dailyReportFilesShare => 'Partager';

  @override
  String get dailyReportFilesArchive => 'Archiver';

  @override
  String get dailyReportFilesNameDailyTransactions =>
      'Transactions quotidiennes';

  @override
  String get dailyReportFilesNameSalesSummary => 'Synthèse des ventes';

  @override
  String get dailyReportFilesNamePaymentsBreakdown =>
      'Répartition des paiements';

  @override
  String get dailyReportFilesNameStockMovement => 'Mouvements de stock';

  @override
  String dailyReportFilesMergedRange(String start, String end) {
    return '$start - $end (fusionné)';
  }

  @override
  String dailyReportFilesMergedDay(String day) {
    return '$day (fusionné)';
  }

  @override
  String get dailyReportFilesMergedWorkbook => 'Classeur fusionné';

  @override
  String get dailyReportFilesNew => 'Nouveau';

  @override
  String get dailyReportFilesReady => 'Prêt';

  @override
  String get dailyReportFilesPending => 'En attente';

  @override
  String get dailyReportFilesReportFile => 'Fichier de rapport';

  @override
  String get dailyReportFilesClosePreview => 'Fermer l\'aperçu';

  @override
  String get dailyReportFilesPreviewLoadFailed =>
      'Impossible de charger l\'aperçu du classeur.';

  @override
  String dailyReportFilesFirstRows(String shown, String total) {
    return '$shown premières lignes sur $total';
  }

  @override
  String get dailyReportFilesRawFilename => 'Nom de fichier brut';

  @override
  String get dailyReportFilesStatFileId => 'ID du fichier';

  @override
  String get dailyReportFilesStatRows => 'Lignes';

  @override
  String get dailyReportFilesStatSize => 'Taille';

  @override
  String get dailyReportFilesStatStatus => 'Statut';

  @override
  String get dailyReportFilesStatSheet => 'Feuille';

  @override
  String get dailyReportFilesStatFormat => 'Format';

  @override
  String get dailyReportFilesColTime => 'Heure';

  @override
  String get dailyReportFilesColReceipt => 'N° de reçu';

  @override
  String get dailyReportFilesColCashier => 'Caissier';

  @override
  String get dailyReportFilesColTax => 'Taxe';

  @override
  String get dailyReportFilesColTotal => 'Total';

  @override
  String get dailyReportFilesMerge => 'Fusionner';

  @override
  String get dailyReportFilesMergeIntoOne => 'Fusionner en un seul classeur';

  @override
  String dailyReportFilesFilesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'fichiers sélectionnés',
      one: 'fichier sélectionné',
    );
    return '$_temp0';
  }

  @override
  String get importPurchaseStatusPending => 'En attente';

  @override
  String get importPurchaseStatusRejected => 'Rejeté';

  @override
  String get importPurchaseStatusProcessing => 'En cours';

  @override
  String get importPurchaseStatusWaiting => 'En attente';

  @override
  String get importPurchaseStatusDeclined => 'Refusé';

  @override
  String get importPurchaseFilterAll => 'Tous';

  @override
  String get importPurchaseFilterByStatus => 'Filtrer par statut';

  @override
  String get importPurchaseItemCodeCopied => 'Code article copié';

  @override
  String get importPurchaseMapLineTitle => 'Associer la ligne d\'achat';

  @override
  String get importPurchaseRraItemCode => 'Code article RRA';

  @override
  String get importPurchaseCreateNewVariant => 'Créer une nouvelle variante';

  @override
  String get importPurchaseCreateNewVariantDesc =>
      'Crée un article du catalogue maintenant et y associe cette ligne d\'achat.';

  @override
  String get importPurchaseMapExistingVariant =>
      'Associer à une variante existante';

  @override
  String get importPurchaseMapExistingVariantDesc =>
      'Ajoute cette quantité à une variante que vous avez déjà en stock.';

  @override
  String get importPurchaseExistingVariant => 'Variante existante';

  @override
  String get importPurchaseSelectVariantEllipsis =>
      'Sélectionnez une variante…';

  @override
  String get importPurchaseSupplyPrice => 'Prix d\'achat';

  @override
  String get importPurchaseRetailPrice => 'Prix de vente';

  @override
  String get importPurchaseCreating => 'Création…';

  @override
  String get importPurchaseSaveMapping => 'Enregistrer l\'association';

  @override
  String get importPurchaseNoPurchaseInvoices => 'Aucune facture d\'achat';

  @override
  String get importPurchaseNoPurchaseInvoicesHint =>
      'Rien ne correspond à ce filtre. Enregistrez un achat ou changez le filtre.';

  @override
  String importPurchasePagerRange(String range, String total) {
    return '$range sur $total';
  }

  @override
  String importPurchaseSupplierHeader(String name, String count) {
    return 'Fournisseur : $name ($count)';
  }

  @override
  String importPurchaseInvoiceHeader(String number) {
    return 'Facture : $number';
  }

  @override
  String get importPurchaseProcessing => 'Traitement…';

  @override
  String get importPurchaseAcceptAll => 'Tout accepter';

  @override
  String get importPurchaseDeclineAll => 'Tout refuser';

  @override
  String get importPurchaseColNo => 'N°';

  @override
  String get importPurchaseColQty => 'Qté';

  @override
  String get importPurchaseColSupply => 'Achat';

  @override
  String get importPurchaseColRetail => 'Vente';

  @override
  String get importPurchaseColMapping => 'Association';

  @override
  String importPurchaseMappedTapToChange(String label) {
    return 'Associé · $label — appuyez pour modifier';
  }

  @override
  String get importPurchaseTapToMapLine => 'Appuyez pour associer cette ligne';

  @override
  String get importPurchaseRetryFailedJob => 'Relancer la tâche échouée';

  @override
  String get importPurchaseNoImportedItems => 'Aucun article importé';

  @override
  String get importPurchaseNoImportedItemsHint =>
      'Rien ne correspond à ce filtre. Changez le filtre ou importez un nouveau lot.';

  @override
  String get importPurchaseSelectRowToEdit =>
      'Sélectionnez une ligne ci-dessous pour modifier son nom, ses prix et sa variante';

  @override
  String get importPurchaseEditing => 'Modification';

  @override
  String get importPurchaseItemName => 'Nom de l\'article';

  @override
  String get importPurchaseEnterName => 'Saisissez un nom';

  @override
  String get importPurchaseEnterSupplyPrice => 'Saisissez le prix d\'achat';

  @override
  String get importPurchaseEnterRetailPrice => 'Saisissez le prix de vente';

  @override
  String get importPurchaseVariant => 'Variante';

  @override
  String get importPurchaseSaveChanges => 'Enregistrer';

  @override
  String get importPurchaseHsCode => 'Code SH';

  @override
  String get importPurchaseColStatus => 'Statut';

  @override
  String get importPurchaseSupplier => 'Fournisseur';

  @override
  String get importPurchaseDate => 'Date';

  @override
  String importPurchaseVariantTag(String name) {
    return 'Variante · $name';
  }

  @override
  String get importPurchaseNoVariantAssigned => 'Aucune variante associée';

  @override
  String get importPurchaseEditItem => 'Modifier l\'article';

  @override
  String get importPurchaseMapVariant => 'Associer une variante';

  @override
  String get importPurchaseNewVariant => 'Nouvelle variante';

  @override
  String get importPurchaseTabImport => 'Import';

  @override
  String get importPurchasePurchase => 'Achat';

  @override
  String get importPurchaseImports => 'Imports';

  @override
  String get importPurchaseSelectVariant => 'Sélectionner une variante';

  @override
  String get importPurchaseSearchVariants => 'Rechercher des variantes…';

  @override
  String get importPurchaseFailedToLoadVariants =>
      'Échec du chargement des variantes';

  @override
  String get importPurchaseNameRequired => 'Le nom est obligatoire';

  @override
  String get importPurchaseSetBothPrices =>
      'Veuillez saisir le prix de vente et le prix d\'achat';

  @override
  String get importPurchaseSelectExistingVariant =>
      'Sélectionnez une variante existante';

  @override
  String get importPurchaseMappedToExisting =>
      'Associé à une variante existante';

  @override
  String importPurchaseCreatedVariantWithCode(String code) {
    return 'Variante créée · $code';
  }

  @override
  String get importPurchaseCreatedVariant => 'Variante créée';

  @override
  String importPurchaseCouldNotCreateVariant(String error) {
    return 'Impossible de créer la variante : $error';
  }

  @override
  String importPurchaseLinesNeedMapping(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lignes doivent encore être associées',
      one: '1 ligne doit encore être associée',
    );
    return '$_temp0';
  }

  @override
  String get importPurchasePurchaseAccepted => 'Achat accepté';

  @override
  String get importPurchasePurchaseDeclined => 'Achat refusé';

  @override
  String importPurchaseCouldNotAccept(String error) {
    return 'Impossible d\'accepter l\'achat : $error';
  }

  @override
  String importPurchaseCouldNotDecline(String error) {
    return 'Impossible de refuser l\'achat : $error';
  }

  @override
  String importPurchaseApprovedItem(String name) {
    return '« $name » approuvé';
  }

  @override
  String importPurchaseRejectedItem(String name) {
    return '« $name » rejeté';
  }

  @override
  String get importPurchaseRetrySucceeded => 'Nouvelle tentative réussie';

  @override
  String importPurchaseCouldNotUpdateItem(String name, String error) {
    return 'Impossible de mettre à jour « $name » : $error';
  }

  @override
  String importPurchaseItemsNeedPrices(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count articles ont besoin d\'un prix d\'achat et de vente, ou d\'un lien vers l\'un de vos produits',
      one:
          '1 article a besoin d\'un prix d\'achat et de vente, ou d\'un lien vers l\'un de vos produits',
    );
    return '$_temp0';
  }

  @override
  String importPurchaseApproveItemsTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Approuver $count articles ?',
      one: 'Approuver 1 article ?',
    );
    return '$_temp0';
  }

  @override
  String get importPurchaseApproveAllBody =>
      'Leurs quantités sont ajoutées à votre stock et déclarées à la RRA.';

  @override
  String get importPurchaseApproveAll => 'Tout approuver';

  @override
  String importPurchaseApprovedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles approuvés',
      one: '1 article approuvé',
    );
    return '$_temp0';
  }

  @override
  String importPurchaseCouldNotApproveAll(String error) {
    return 'Impossible de tout approuver : $error';
  }

  @override
  String get importPurchaseCouldNotLoadImports =>
      'Impossible de charger les imports';

  @override
  String get importPurchaseNoImportsWaiting => 'Aucun import en attente';

  @override
  String get importPurchaseNoImportsHere => 'Aucun import ici';

  @override
  String get importPurchaseFetchCustomsHint =>
      'Appuyez sur ⟳ pour récupérer vos déclarations en douane depuis la RRA.';

  @override
  String importPurchaseApproveAllWaiting(int count) {
    return 'Approuver les $count en attente';
  }

  @override
  String importPurchaseFromOrigin(String origin) {
    return 'de $origin';
  }

  @override
  String importPurchaseCostSellsAt(String cost, String price) {
    return 'Coût $cost · vendu à $price';
  }

  @override
  String get importPurchaseSetPricesBeforeApproving =>
      'Définissez les prix avant d\'approuver';

  @override
  String get importPurchaseWorking => 'En cours…';

  @override
  String get importPurchaseFailedTapToRetry => 'Échec · appuyez pour réessayer';

  @override
  String importPurchaseAddsTo(String name) {
    return 'Ajouté à $name';
  }

  @override
  String get importPurchaseNewProduct => 'Nouveau produit';

  @override
  String get importPurchaseEnterBothPrices =>
      'Saisissez les deux prix, ou liez un produit que vous vendez';

  @override
  String get importPurchaseOrigin => 'Origine';

  @override
  String get importPurchaseDeclaration => 'Déclaration';

  @override
  String get importPurchaseNameInYourShop => 'Nom dans votre boutique';

  @override
  String get importPurchaseCreateAsNewProduct => 'Créer comme nouveau produit';

  @override
  String get importPurchaseLinkProductHint =>
      'Ou appuyez pour ajouter ce stock à un produit que vous vendez';

  @override
  String get importPurchaseStockAddedToProduct =>
      'Le stock sera ajouté à ce produit';

  @override
  String get importPurchaseUnlink => 'Dissocier';

  @override
  String get importPurchaseRetryWithPrevious =>
      'Réessayer avec les valeurs précédentes';

  @override
  String get importPurchaseReject => 'Rejeter';

  @override
  String get importPurchaseApprove => 'Approuver';

  @override
  String get importPurchaseSaveForLater => 'Enregistrer pour plus tard';

  @override
  String get importPurchaseSearchYourProducts => 'Rechercher vos produits';

  @override
  String get importPurchaseTypeProductName => 'Saisissez un nom de produit';

  @override
  String get importPurchaseNoProductMatches => 'Aucun produit correspondant';

  @override
  String importPurchaseSellsAt(String price) {
    return 'Vendu à $price';
  }

  @override
  String importPurchaseSyncFailed(String error) {
    return 'Échec de la synchronisation : $error';
  }

  @override
  String get importPurchaseRecordPurchase => 'Enregistrer un achat';

  @override
  String get importPurchaseRecordPurchaseSubtitle =>
      'Saisissez une facture fournisseur et ses lignes';

  @override
  String get importPurchaseFetchingInvoices =>
      'Récupération des factures depuis la RRA…';

  @override
  String importPurchaseSyncedWithRra(String time) {
    return 'Synchronisé avec la RRA $time';
  }

  @override
  String get importPurchasePullToRefreshHint =>
      'Tirez vers le bas pour actualiser · appuyez sur ⟳ pour récupérer depuis la RRA';

  @override
  String get importPurchaseFetchFromRra => 'Récupérer depuis la RRA';

  @override
  String get importPurchaseCouldNotLoadPurchases =>
      'Impossible de charger les achats';

  @override
  String get importPurchaseNothingWaiting => 'Rien en attente d\'approbation';

  @override
  String get importPurchaseNoPurchasesHere => 'Aucun achat ici';

  @override
  String get importPurchaseNoPurchasesHint =>
      'Enregistrez un achat ou récupérez vos factures fournisseurs depuis la RRA.';

  @override
  String get importPurchaseRecorded => 'Enregistré';

  @override
  String get importPurchaseFromRra => 'Depuis la RRA';

  @override
  String get importPurchaseOnCredit => 'À crédit';

  @override
  String importPurchaseItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return '$_temp0';
  }

  @override
  String importPurchaseCardMeta(String number, String time, String items) {
    return 'Facture $number · $time · $items';
  }

  @override
  String get importPurchaseDeclineTitle => 'Refuser cet achat ?';

  @override
  String importPurchaseDeclineBody(String number, String supplier) {
    return 'La facture $number de $supplier ne sera pas ajoutée à votre stock.';
  }

  @override
  String get importPurchaseDecline => 'Refuser';

  @override
  String get importPurchaseNotFound => 'Achat introuvable';

  @override
  String get importPurchaseNotFoundHint => 'Il a peut-être changé de statut.';

  @override
  String importPurchaseInclVat(String amount) {
    return 'dont TVA $amount';
  }

  @override
  String get importPurchasePaidWith => 'Payé par';

  @override
  String get importPurchaseSupplierTin => 'TIN du fournisseur';

  @override
  String importPurchaseItemsHeader(String count) {
    return 'Articles · $count';
  }

  @override
  String get importPurchaseMatchItemsHint =>
      'Associez chaque article du fournisseur à l\'un des vôtres avant d\'accepter, pour que le stock aille sur le bon produit.';

  @override
  String importPurchaseAcceptWithMatch(int count) {
    return 'Accepter ($count à associer)';
  }

  @override
  String get importPurchaseAccept => 'Accepter';

  @override
  String get importPurchaseMatchedChange => 'Associé · modifier';

  @override
  String get importPurchaseMatchToMyItem => 'Associer à mon article';

  @override
  String bulkProductProductCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count produits',
      one: '1 produit',
    );
    return '$_temp0';
  }

  @override
  String get bulkProductRegisterViaServer =>
      'Enregistrer via le serveur (RRA d\'abord)';

  @override
  String get bulkProductRegisterViaServerHint =>
      'Le catalogue n\'est créé dans Ditto qu\'après la réussite de la RRA. Désactivez pour utiliser l\'ancien traitement sur l\'appareil.';

  @override
  String get bulkProductSaveAll => 'Tout enregistrer';

  @override
  String get bulkProductLoadingAllRows =>
      'Chargement de toutes les lignes du tableur (enregistrement désactivé jusqu\'à la fin)…';

  @override
  String get bulkProductParsingSpreadsheet => 'Analyse du tableur…';

  @override
  String bulkProductProgressCount(
    String percent,
    String current,
    String total,
  ) {
    return '$percent · $current sur $total';
  }

  @override
  String get bulkProductSaving => 'Enregistrement…';

  @override
  String bulkProductRowsMissingName(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lignes sans nom',
      one: '1 ligne sans nom',
    );
    return '$_temp0';
  }

  @override
  String bulkProductDuplicateBarcodes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count codes-barres en double',
      one: '1 code-barres en double',
    );
    return '$_temp0';
  }

  @override
  String get bulkProductSavingProducts => 'Enregistrement des produits';

  @override
  String bulkProductCurrentOfTotal(String current, String total) {
    return '$current sur $total';
  }

  @override
  String get bulkProductPleaseWait => 'Veuillez patienter…';

  @override
  String get bulkProductHideSaveContinues =>
      'Masquer · l\'enregistrement continue';

  @override
  String get bulkProductProgressStaysOnBar =>
      'La progression reste affichée dans la barre au-dessus de la grille.';

  @override
  String bulkProductLargeImportBanner(String count) {
    return 'Import volumineux : vous pouvez modifier les prix et options page par page ($count produits). Utilisez les flèches sous la grille pour charger les 20 lignes suivantes ou précédentes.';
  }

  @override
  String get bulkProductColBarcode => 'Code-barres';

  @override
  String get bulkProductColSupplyPrice => 'Prix d\'achat';

  @override
  String get bulkProductColItemClass => 'Classe d\'article';

  @override
  String get bulkProductColTax => 'Taxe';

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
    return 'Page $page sur $pages — modification des lignes $start à $end sur $total ($visible à l\'écran)';
  }

  @override
  String get bulkProductPreviousPage => 'Page précédente';

  @override
  String get bulkProductNextPage => 'Page suivante';

  @override
  String bulkProductShowingRows(String count) {
    return '$count lignes affichées';
  }

  @override
  String get bulkProductRemoveRow => 'Supprimer la ligne';

  @override
  String get bulkProductNoDataToSave => 'Aucune donnée à enregistrer';

  @override
  String bulkProductLoadingFullSpreadsheet(String count) {
    return 'Chargement du tableur complet (~$count lignes)…';
  }

  @override
  String get bulkProductCouldNotLoadSpreadsheet =>
      'Impossible de charger le tableur. Utilisez « Changer » pour choisir un autre fichier.';

  @override
  String get bulkProductUploadToPreview =>
      'Téléversez un fichier Excel pour prévisualiser les produits';

  @override
  String get bulkProductNoRowsInFile =>
      'Aucune ligne dans le fichier — téléversez un autre tableur ou ajoutez des lignes dans Excel.';

  @override
  String bulkProductLargeImportLoading(String count) {
    return 'Import volumineux (~$count produits, chargement du fichier complet…) — L\'enregistrement reste désactivé jusqu\'à la fin du chargement.';
  }

  @override
  String bulkProductLargeImportTitle(String count) {
    return 'Import volumineux ($count produits)';
  }

  @override
  String get bulkProductPreviewLoadingHint =>
      'Aperçu rapide pendant le chargement de toutes les lignes. La suppression de lignes est désactivée jusqu\'à ce que le fichier complet soit prêt.';

  @override
  String get bulkProductPreviewReadyHint =>
      'Vous pouvez supprimer des lignes de l\'aperçu ci-dessous. Une fois le fichier complet prêt, vous aurez la même grille modifiable que pour les petits imports, 20 produits par page.';

  @override
  String bulkProductPreviewFirstOf(String count, String total) {
    return 'Aperçu ($count premiers sur $total)';
  }

  @override
  String get bulkProductNoName => '(sans nom)';

  @override
  String bulkProductBarcodePrice(String barcode, String price) {
    return 'Code-barres : $barcode · Prix : $price';
  }

  @override
  String get bulkProductAvailableAfterLoad =>
      'Disponible après le chargement complet du fichier';

  @override
  String get bulkProductDropExcelHere => 'Déposez votre fichier Excel ici';

  @override
  String get bulkProductClickToBrowse =>
      'ou cliquez pour parcourir vos fichiers';

  @override
  String bulkProductProductsLoaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count produits chargés',
      one: '1 produit chargé',
    );
    return '$_temp0';
  }

  @override
  String get bulkProductChange => 'Changer';

  @override
  String get bulkProductSupportedFormats =>
      'Formats acceptés : .xlsx, .xls (enregistrez WPS au format Excel .xlsx)';

  @override
  String get bulkProductDownloadTemplate => 'Télécharger le modèle';

  @override
  String get bulkProductTypeRawMaterial => 'Matière première';

  @override
  String get bulkProductTypeFinishedProduct => 'Produit fini';

  @override
  String get bulkProductTypeService => 'Service sans stock';

  @override
  String get bulkProductLoading => 'Chargement…';

  @override
  String get bulkProductSelectCategory => 'Sélectionner une catégorie';

  @override
  String get bulkProductSearchCategory => 'Rechercher une catégorie';

  @override
  String get bulkProductAddNewCategory => 'Ajouter une catégorie';

  @override
  String get bulkProductSaveComplete => 'Enregistrement groupé terminé';

  @override
  String get bulkProductSaveFailed => 'Échec de l\'enregistrement groupé';

  @override
  String get bulkProductStatTotal => 'Total';

  @override
  String get bulkProductStatSucceeded => 'Réussis';

  @override
  String get bulkProductStatFailed => 'Échoués';

  @override
  String get bulkProductTaxRegistrationSkipped =>
      'L\'enregistrement fiscal a été ignoré pour cette succursale.';

  @override
  String bulkProductJobId(String id) {
    return 'Tâche $id';
  }

  @override
  String get bulkProductStay => 'Rester';

  @override
  String get stockRecountTitle => 'Recomptage du stock';

  @override
  String get stockRecountNew => 'Nouveau recomptage';

  @override
  String get stockRecountStatusAll => 'Tous';

  @override
  String get stockRecountStatusDraft => 'Brouillon';

  @override
  String get stockRecountStatusSubmitted => 'Soumis';

  @override
  String get stockRecountStatusSynced => 'Synchronisé';

  @override
  String get stockRecountBalanced => 'Équilibré';

  @override
  String stockRecountNetValue(String value) {
    return '$value net';
  }

  @override
  String get stockRecountExporting => 'Exportation…';

  @override
  String get stockRecountExportPdf => 'Exporter en PDF';

  @override
  String stockRecountStartFailed(String error) {
    return 'Impossible de démarrer le recomptage : $error';
  }

  @override
  String get stockRecountDeleteTitle => 'Supprimer le recomptage ?';

  @override
  String get stockRecountDeleteMessage =>
      'Supprimer ce brouillon de recomptage ? Cette action est irréversible.';

  @override
  String get stockRecountDeleted => 'Recomptage supprimé';

  @override
  String stockRecountDeleteFailed(String error) {
    return 'Échec de la suppression : $error';
  }

  @override
  String stockRecountExportFailed(String error) {
    return 'Échec de l\'exportation : $error';
  }

  @override
  String get stockRecountSearchHint =>
      'Rechercher un appareil, une note ou un produit…';

  @override
  String get stockRecountClearFilters => 'Effacer les filtres';

  @override
  String get stockRecountStartNew => 'Démarrer un recomptage';

  @override
  String get stockRecountFilter => 'Filtrer';

  @override
  String get stockRecountNothingMatches => 'Aucun résultat';

  @override
  String get stockRecountNoRecountsYet => 'Aucun recomptage pour l\'instant';

  @override
  String get stockRecountNothingMatchesHint =>
      'Essayez un autre terme de recherche ou un autre filtre pour trouver le recomptage voulu.';

  @override
  String get stockRecountEmptyHint =>
      'Démarrez un recomptage pour compter le stock physique et le comparer aux données du système.';

  @override
  String get stockRecountUnknownDevice => 'Appareil inconnu';

  @override
  String stockRecountItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return '$_temp0';
  }

  @override
  String stockRecountShortCount(String count) {
    return '$count en manque';
  }

  @override
  String stockRecountMatchingCount(String count) {
    return '$count conformes';
  }

  @override
  String stockRecountSurplusCount(String count) {
    return '$count en surplus';
  }

  @override
  String get stockRecountDeleteDraft => 'Supprimer le brouillon';

  @override
  String stockRecountAlreadyInCount(String name) {
    return '$name est déjà dans ce recomptage';
  }

  @override
  String stockRecountAddedToCount(String name) {
    return '$name ajouté au recomptage';
  }

  @override
  String stockRecountAddItemFailed(String error) {
    return 'Impossible d\'ajouter l\'article : $error';
  }

  @override
  String stockRecountUpdateFailed(String error) {
    return 'Échec de la mise à jour : $error';
  }

  @override
  String get stockRecountItemRemoved => 'Article retiré';

  @override
  String stockRecountRemoveFailed(String error) {
    return 'Échec du retrait : $error';
  }

  @override
  String get stockRecountUnknownBarcode => 'Code-barres inconnu';

  @override
  String stockRecountScanned(String name) {
    return '$name scanné — ajustez la quantité si besoin';
  }

  @override
  String get stockRecountSubmitTitle => 'Soumettre le recomptage ?';

  @override
  String get stockRecountSubmitMessage =>
      'Les niveaux de stock seront mis à jour à partir des quantités comptées.';

  @override
  String get stockRecountSubmitted => 'Recomptage soumis ✓';

  @override
  String stockRecountSubmitFailed(String error) {
    return 'Échec de l\'envoi : $error';
  }

  @override
  String get stockRecountInfo =>
      'Comptez le stock physique, comparez les écarts, puis soumettez pour synchroniser l\'inventaire.';

  @override
  String stockRecountLoadFailed(String error) {
    return 'Impossible de charger le recomptage : $error';
  }

  @override
  String get stockRecountNotFound => 'Recomptage introuvable';

  @override
  String get stockRecountCountedItems => 'Articles comptés';

  @override
  String stockRecountItemsNet(int count, String net) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return '$_temp0 · net $net';
  }

  @override
  String stockRecountNetItems(String net, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return '$net · $_temp0';
  }

  @override
  String get stockRecountDevice => 'Appareil';

  @override
  String stockRecountCreatedAt(String date) {
    return 'Créé le $date';
  }

  @override
  String get stockRecountNoteHint => 'Ajoutez une note pour ce recomptage…';

  @override
  String get stockRecountNoNote => 'Aucune note';

  @override
  String get stockRecountItemsCounted => 'Articles comptés';

  @override
  String get stockRecountMatching => 'Conformes';

  @override
  String get stockRecountSurplus => 'Surplus';

  @override
  String get stockRecountShort => 'En manque';

  @override
  String get stockRecountAddProduct => 'Ajouter un produit à compter';

  @override
  String get stockRecountProductSearchHint =>
      'Rechercher par nom, SKU ou code-barres…';

  @override
  String stockRecountNoProductMatches(String query) {
    return 'Aucun produit ne correspond à « $query ».';
  }

  @override
  String get stockRecountAdded => 'Ajouté';

  @override
  String get stockRecountInSystem => 'dans le système';

  @override
  String stockRecountStagedLine(String sku, String qty) {
    return 'SKU $sku · $qty dans le système';
  }

  @override
  String stockRecountItemLine(String sku, String time) {
    return 'SKU $sku · compté à $time';
  }

  @override
  String stockRecountShrinkageNote(String qty) {
    return '$qty de moins que dans le système — cet écart sera enregistré comme perte.';
  }

  @override
  String stockRecountSurplusNote(String qty) {
    return '$qty de plus que dans le système — un surplus sera enregistré.';
  }

  @override
  String get stockRecountSystem => 'Système';

  @override
  String get stockRecountCounted => 'Compté';

  @override
  String get stockRecountVariance => 'Écart';

  @override
  String get stockRecountEmptyItemsHint =>
      'Recherchez un produit ci-dessus ou scannez un code-barres, puis saisissez la quantité comptée.';

  @override
  String get stockRecountNoCountedItems =>
      'Ce recomptage ne contient aucun article compté.';

  @override
  String get stockRecountNetVariance => 'Écart net';

  @override
  String get stockRecountTotal => 'Total du recomptage';

  @override
  String get stockRecountConfirmShortagesTitle =>
      'Confirmez les manques avant de soumettre';

  @override
  String stockRecountConfirmShortagesBody(int count, String net) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles comptés',
      one: '1 article compté',
    );
    return '$_temp0 en dessous du système — l\'enregistrement soumettra un écart net de $net. Indiquez un motif…';
  }

  @override
  String get stockRecountShortageReasonHint =>
      'Motif du manque (ex. articles endommagés, avariés, vol)…';

  @override
  String get stockRecountKeepEditing => 'Continuer la modification';

  @override
  String get stockRecountConfirmSubmit => 'Confirmer et soumettre';

  @override
  String get stockRecountPointCamera => 'Pointez la caméra vers le code-barres';

  @override
  String get stockRecountPdfSubject => 'Rapport de recomptage du stock';

  @override
  String get stockRecountPdfSaveTitle => 'Enregistrer le PDF du recomptage';

  @override
  String stockRecountPdfReportNumber(String id) {
    return 'Rapport n° $id';
  }

  @override
  String get stockRecountPdfNote => 'Note :';

  @override
  String stockRecountPdfCountedByName(String name) {
    return 'Compté par — $name';
  }

  @override
  String get stockRecountPdfApprovedBy => 'Approuvé par';

  @override
  String get stockRecountPdfFooter =>
      'Généré par Flipper · Recomptage du stock';

  @override
  String get stockRecountCountedBy => 'Compté par';

  @override
  String get stockRecountCreated => 'Créé';

  @override
  String get stockRecountGenerated => 'Généré';

  @override
  String get stockRecountProduct => 'Produit';

  @override
  String stockRecountPdfTotals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return 'Totaux · $_temp0';
  }

  @override
  String get stockRecountFallbackAgent => 'Agent';

  @override
  String get stockRecountFallbackBranch => 'Succursale';

  @override
  String get productionOutputTitle => 'Suivi de production';

  @override
  String get productionOutputNew => 'Nouveau';

  @override
  String get productionOutputNewOrder => 'Nouvel ordre';

  @override
  String get productionOutputWorkOrders => 'Ordres de fabrication';

  @override
  String productionOutputItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      one: '1 élément',
    );
    return '$_temp0';
  }

  @override
  String get productionOutputLoadFailed =>
      'Impossible de charger les ordres de fabrication';

  @override
  String get productionOutputCheckConnection =>
      'Vérifiez votre connexion et réessayez.';

  @override
  String get productionOutputNoWorkOrdersYet =>
      'Aucun ordre de fabrication pour l\'instant';

  @override
  String get productionOutputNoWorkOrdersHint =>
      'Créez un ordre de fabrication pour commencer à suivre la production.';

  @override
  String get productionOutputNewWorkOrder => 'Nouvel ordre de fabrication';

  @override
  String get productionOutputUnknownProduct => 'Produit inconnu';

  @override
  String get productionOutputUnknown => 'Inconnu';

  @override
  String get productionOutputPlanned => 'Prévu';

  @override
  String get productionOutputActual => 'Réel';

  @override
  String get productionOutputVariance => 'Écart';

  @override
  String get productionOutputRecord => 'Enregistrer';

  @override
  String get productionOutputComplete => 'Terminer';

  @override
  String get productionOutputStart => 'Démarrer';

  @override
  String get productionOutputRecordFailed =>
      'Impossible d\'enregistrer la production. Veuillez réessayer.';

  @override
  String get productionOutputCompleteFailed =>
      'Impossible de terminer cet ordre de fabrication. Veuillez réessayer.';

  @override
  String get productionOutputStartFailed =>
      'Impossible de démarrer cet ordre de fabrication. Veuillez réessayer.';

  @override
  String get productionOutputCompleteTitle =>
      'Terminer l\'ordre de fabrication ?';

  @override
  String productionOutputCompleteMessage(String name) {
    return 'Marquer « $name » comme terminé ?';
  }

  @override
  String get productionOutputStartTitle => 'Démarrer l\'ordre de fabrication ?';

  @override
  String productionOutputStartMessage(String name) {
    return 'Lancer la production de « $name » ?';
  }

  @override
  String get productionOutputRecordOutput => 'Enregistrer la production';

  @override
  String productionOutputProductLabel(String name) {
    return 'Produit : $name';
  }

  @override
  String productionOutputTargetLabel(String quantity) {
    return 'Objectif : $quantity';
  }

  @override
  String get productionOutputActualQuantity => 'Quantité réelle';

  @override
  String get productionOutputReasonMachine => 'Machine';

  @override
  String get productionOutputReasonMachineDesc => 'Arrêt ou panne de machine';

  @override
  String get productionOutputReasonMaterial => 'Matière';

  @override
  String get productionOutputReasonMaterialDesc =>
      'Pénurie ou problème de qualité des matières';

  @override
  String get productionOutputReasonLabor => 'Main-d\'œuvre';

  @override
  String get productionOutputReasonLaborDesc =>
      'Manque de personnel ou de compétences';

  @override
  String get productionOutputReasonQuality => 'Qualité';

  @override
  String get productionOutputReasonQualityDesc => 'Rejet au contrôle qualité';

  @override
  String get productionOutputReasonPlanning => 'Planification';

  @override
  String get productionOutputReasonPlanningDesc =>
      'Problèmes de planification ou d\'ordonnancement';

  @override
  String get productionOutputReasonOther => 'Autre';

  @override
  String get productionOutputReasonOtherDesc => 'Autres raisons';

  @override
  String get productionOutputStatusPlanned => 'Planifié';

  @override
  String get productionOutputStatusInProgress => 'En cours';

  @override
  String get productionOutputStatusCompleted => 'Terminé';

  @override
  String get productionOutputStatusCancelled => 'Annulé';

  @override
  String get productionOutputRatingExcellent => 'Excellent';

  @override
  String get productionOutputRatingGood => 'Bon';

  @override
  String get productionOutputRatingFair => 'Moyen';

  @override
  String get productionOutputRatingPoor => 'Faible';

  @override
  String get productionOutputVarianceReason => 'Raison de l\'écart';

  @override
  String get productionOutputVarianceReasonHint =>
      'Sélectionnez la principale raison de l\'écart de production';

  @override
  String get productionOutputAdditionalNotes => 'Notes supplémentaires';

  @override
  String get productionOutputVarianceNotesHint =>
      'Précisez les détails de l\'écart…';

  @override
  String get productionOutputEditWorkOrder =>
      'Modifier l\'ordre de fabrication';

  @override
  String get productionOutputCreateWorkOrder => 'Créer un ordre de fabrication';

  @override
  String get productionOutputUpdateWorkOrder => 'Mettre à jour l\'ordre';

  @override
  String get productionOutputFormSubtitle =>
      'Planifiez la production de vos produits';

  @override
  String get productionOutputProductMaterialRequired => 'Produit/Matière *';

  @override
  String get productionOutputSearchProduct => 'Rechercher un produit';

  @override
  String get productionOutputSelectProduct =>
      'Veuillez sélectionner un produit';

  @override
  String get productionOutputNoProductsFound => 'Aucun produit trouvé';

  @override
  String get productionOutputNoProductsHint =>
      'Essayez un autre nom de produit ou SKU';

  @override
  String get productionOutputNotAvailable => 'N/D';

  @override
  String get productionOutputPlannedQuantityRequired => 'Quantité prévue *';

  @override
  String get productionOutputUnits => 'unités';

  @override
  String get productionOutputRequired => 'Obligatoire';

  @override
  String get productionOutputTargetDateRequired => 'Date cible *';

  @override
  String get productionOutputTargetDate => 'Date cible';

  @override
  String get productionOutputShiftOptional => 'Équipe (facultatif)';

  @override
  String get productionOutputShiftMorning => 'Matin';

  @override
  String get productionOutputShiftAfternoon => 'Après-midi';

  @override
  String get productionOutputShiftNight => 'Nuit';

  @override
  String get productionOutputNotes => 'Notes';

  @override
  String get productionOutputNotesHint =>
      'Instructions ou commentaires supplémentaires…';

  @override
  String get productionOutputSaveFailed =>
      'Impossible d\'enregistrer l\'ordre de fabrication. Veuillez réessayer.';

  @override
  String get productionOutputChartTitle => 'Production prévue vs réelle';

  @override
  String productionOutputLastDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count derniers jours',
      one: 'Dernier jour',
    );
    return '$_temp0';
  }

  @override
  String get productionOutputVariancePercent => 'Écart %';

  @override
  String get productionOutputNoDataAvailable => 'Aucune donnée disponible';

  @override
  String get productionOutputDayMon => 'lun.';

  @override
  String get productionOutputDayTue => 'mar.';

  @override
  String get productionOutputDayWed => 'mer.';

  @override
  String get productionOutputDayThu => 'jeu.';

  @override
  String get productionOutputDayFri => 'ven.';

  @override
  String get productionOutputDaySat => 'sam.';

  @override
  String get productionOutputDaySun => 'dim.';

  @override
  String get productionOutputEfficiencyRate => 'Taux d\'efficacité';

  @override
  String get productionOutputCompletion => 'Achèvement';

  @override
  String get productionOutputCompletionRate => 'Taux d\'achèvement';

  @override
  String productionOutputCompletedOfTotal(String completed, String total) {
    return '$completed sur $total';
  }

  @override
  String get productionOutputVarianceReasons => 'Raisons des écarts';

  @override
  String get productionOutputNoData => 'Aucune donnée';

  @override
  String get productionOutputOverview => 'Aperçu de la production';

  @override
  String get productionOutputOrders => 'Ordres';

  @override
  String get productionOutputStatusFilterLabel => 'Statut :';

  @override
  String get productionOutputFilterAll => 'Tous';

  @override
  String get productionOutputProduct => 'Produit';

  @override
  String get productionOutputStatus => 'Statut';

  @override
  String get productionOutputNoWorkOrdersFound =>
      'Aucun ordre de fabrication trouvé';

  @override
  String get productionOutputTableEmptyHint =>
      'Créez un ordre de fabrication pour suivre la production';

  @override
  String get incomingOrdersIncoming => 'Entrantes';

  @override
  String get incomingOrdersOutgoing => 'Sortantes';

  @override
  String get incomingOrdersBranchNotFound => 'Succursale introuvable';

  @override
  String get incomingOrdersBranchLoadFailed =>
      'Impossible de charger la succursale active';

  @override
  String get incomingOrdersReceivedOrders => 'Commandes reçues';

  @override
  String get incomingOrdersSentOrders => 'Commandes envoyées';

  @override
  String get incomingOrdersErrorLoadingBranch =>
      'Erreur de chargement de la succursale';

  @override
  String get incomingOrdersErrorLoadingRequests =>
      'Erreur de chargement des demandes';

  @override
  String get incomingOrdersTitle => 'Gestion des commandes';

  @override
  String get incomingOrdersSubtitle =>
      'Suivez et gérez les commandes entrantes et sortantes';

  @override
  String get incomingOrdersPendingRequests => 'Demandes en attente';

  @override
  String incomingOrdersNoRequests(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'pending': 'Aucune demande en attente',
      'approved': 'Aucune demande approuvée',
      'processing': 'Aucune demande en production',
      'voided': 'Aucune demande annulée',
      'rejected': 'Aucune demande rejetée',
      'other': 'Aucune demande',
    });
    return '$_temp0';
  }

  @override
  String get incomingOrdersNothingToShow => 'Rien à afficher pour le moment.';

  @override
  String get incomingOrdersTryAgain => 'Réessayer';

  @override
  String incomingOrdersSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sélectionnés',
      one: '1 sélectionné',
    );
    return '$_temp0';
  }

  @override
  String get incomingOrdersNoApprovePermission =>
      'Vous n\'avez pas l\'autorisation d\'approuver les commandes';

  @override
  String get incomingOrdersApprove => 'Approuver';

  @override
  String get incomingOrdersReject => 'Rejeter';

  @override
  String get incomingOrdersItemsHeading => 'ARTICLES';

  @override
  String get incomingOrdersNoItems => 'Aucun article dans cette demande';

  @override
  String incomingOrdersErrorLoadingItems(String error) {
    return 'Erreur de chargement des articles : $error';
  }

  @override
  String incomingOrdersUpdateItemFailed(String error) {
    return 'Échec de la mise à jour de l\'article : $error';
  }

  @override
  String get incomingOrdersUpdateQtyLabel => 'Modifier la qté :';

  @override
  String get incomingOrdersRequestedLabel => 'Demandé :';

  @override
  String get incomingOrdersApprovedLabel => 'Approuvé :';

  @override
  String get incomingOrdersUpdate => 'Mettre à jour';

  @override
  String get incomingOrdersStatusDeliveryHeading => 'STATUT ET LIVRAISON';

  @override
  String get incomingOrdersStatus => 'Statut';

  @override
  String get incomingOrdersRequestedOn => 'Demandé le';

  @override
  String get incomingOrdersStatusPending => 'En attente';

  @override
  String get incomingOrdersStatusProcessing => 'En cours';

  @override
  String get incomingOrdersStatusPartiallyApproved => 'Partiellement approuvé';

  @override
  String get incomingOrdersStatusRejected => 'Rejeté';

  @override
  String get incomingOrdersStatusFulfilled => 'Livré';

  @override
  String get incomingOrdersStatusVoided => 'Annulé';

  @override
  String get incomingOrdersOrderNoteHeading => 'NOTE DE COMMANDE';

  @override
  String get incomingOrdersProduce => 'Produire';

  @override
  String get incomingOrdersVoid => 'Annuler';

  @override
  String get incomingOrdersFinishProduction => 'Terminer la production';

  @override
  String get incomingOrdersInProduction => 'En production';

  @override
  String get incomingOrdersApproveRequest => 'Approuver la demande';

  @override
  String get incomingOrdersApproveAllConfirm =>
      'Voulez-vous vraiment approuver tous les articles de cette demande ?';

  @override
  String get incomingOrdersApproveAll => 'Tout approuver';

  @override
  String get incomingOrdersVoidRequest => 'Annuler la demande';

  @override
  String get incomingOrdersVoidConfirm =>
      'Voulez-vous vraiment annuler cette demande ?';

  @override
  String incomingOrdersDeclinedSms(String reference) {
    return 'Votre demande de stock n°$reference a été refusée.';
  }

  @override
  String get incomingOrdersVoidSuccess => 'Demande annulée avec succès';

  @override
  String incomingOrdersVoidFailed(String error) {
    return 'Échec de l\'annulation de la demande : $error';
  }

  @override
  String get incomingOrdersProductionFinished =>
      'Production marquée comme terminée. Prête pour approbation.';

  @override
  String get incomingOrdersFinishProductionFailed =>
      'Impossible de terminer la production';

  @override
  String get incomingOrdersUnknown => 'Inconnu';

  @override
  String get incomingOrdersFromLabel => 'De :';

  @override
  String get incomingOrdersToLabel => 'À :';

  @override
  String incomingOrdersRequestFrom(String branch) {
    return 'Demande de $branch';
  }

  @override
  String incomingOrdersLineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '($count articles)',
      one: '(1 article)',
    );
    return '$_temp0';
  }

  @override
  String incomingOrdersQtyItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return '$_temp0';
  }

  @override
  String incomingOrdersQtyRatio(int requested, String approved) {
    String _temp0 = intl.Intl.pluralLogic(
      requested,
      locale: localeName,
      other: '$requested articles',
      one: '1 article',
    );
    return '$approved/$_temp0';
  }

  @override
  String get failedPaymentCardEmailRequired =>
      'Une adresse e-mail est requise pour le reçu de carte';

  @override
  String get failedPaymentEnterValidEmail =>
      'Saisissez une adresse e-mail valide';

  @override
  String get failedPaymentPhoneMustStartWith250 =>
      'Le numéro de téléphone doit commencer par 250';

  @override
  String get failedPaymentPhoneMustBe12Digits =>
      'Le numéro de téléphone doit comporter 12 chiffres';

  @override
  String get failedPaymentPhoneCannotExceed12Digits =>
      'Le numéro de téléphone ne peut pas dépasser 12 chiffres';

  @override
  String get failedPaymentInvalidMtnPrefix =>
      'Préfixe MTN invalide (doit commencer par 78 ou 79)';

  @override
  String get failedPaymentLoadingTookTooLong =>
      'Le chargement a pris trop de temps. Vérifiez votre connexion, actualisez la page ou réessayez.';

  @override
  String failedPaymentErrorLoadingPlanDetails(String error) {
    return 'Erreur lors du chargement du forfait : $error';
  }

  @override
  String get failedPaymentFailedTryAgain => 'Le paiement a échoué, réessayez';

  @override
  String get failedPaymentFailedToValidateCode =>
      'Impossible de valider le code';

  @override
  String get failedPaymentLoadingDetails =>
      'Chargement des détails du paiement…';

  @override
  String get failedPaymentIssueTitle => 'Problème de paiement';

  @override
  String get failedPaymentCompleteOnCardPage =>
      'Finalisez le paiement sur la page de carte';

  @override
  String get failedPaymentCompleteOnPhone =>
      'Finalisez le paiement sur votre téléphone';

  @override
  String get failedPaymentCardWaitingBody =>
      'Saisissez les détails de votre carte sur la page qui s\'est ouverte.\nCet écran se met à jour automatiquement une fois le paiement effectué.';

  @override
  String get failedPaymentMomoWaitingBody =>
      'Une demande de paiement a été envoyée à votre MTN Mobile Money.\nOuvrez votre téléphone et approuvez la transaction.';

  @override
  String get failedPaymentReopenPage => 'Rouvrir la page de paiement';

  @override
  String get failedPaymentNotNowBackToOptions =>
      'Pas maintenant — retour aux options de paiement';

  @override
  String get failedPaymentNeedsAttention =>
      'Le paiement nécessite votre attention';

  @override
  String get failedPaymentNeedsAttentionBody =>
      'Pas d\'inquiétude, cela arrive parfois.\nRéglons cela rapidement.';

  @override
  String get failedPaymentSwitchOrUpgradePlan =>
      'Changer ou améliorer le forfait';

  @override
  String get failedPaymentTapToCollapse => 'Appuyez pour réduire';

  @override
  String get failedPaymentChooseDifferentPlan =>
      'Choisissez un autre forfait avant de réessayer';

  @override
  String get failedPaymentPlanStillActive =>
      'Votre forfait est toujours actif. Vous pouvez l\'améliorer ou en changer ci-dessous. Le nouveau forfait s\'appliquera à partir de votre prochain cycle de facturation.';

  @override
  String get failedPaymentEnterpriseServices => 'Services entreprise';

  @override
  String get failedPaymentAdditionalServices => 'Services supplémentaires';

  @override
  String get failedPaymentNewPlanTotal => 'Total du nouveau forfait';

  @override
  String get failedPaymentCouldNotOpenPage =>
      'Impossible d\'ouvrir la page de paiement sur cet appareil. Essayez Mobile Money, ou terminez le paiement sur un téléphone ou un ordinateur doté d\'un navigateur.';

  @override
  String get failedPaymentSubscriptionEnded =>
      'Cet abonnement est terminé. Choisissez un forfait ci-dessus pour recommencer.';

  @override
  String get failedPaymentPageNotReady =>
      'La page de paiement n\'est pas encore prête. Réessayez dans un instant.';

  @override
  String get failedPaymentCouldNotOpenCardPage =>
      'Impossible d\'ouvrir la page de paiement par carte sur cet appareil. Utilisez le lien ci-dessous ou payez avec Mobile Money.';

  @override
  String failedPaymentCardNotStartedWithError(String error) {
    return 'Impossible de lancer le paiement par carte : $error';
  }

  @override
  String get failedPaymentCardNotStarted =>
      'Impossible de lancer le paiement par carte.';

  @override
  String get failedPaymentCardNotThrough =>
      'Le paiement par carte n\'a pas abouti. Réessayez ou utilisez Mobile Money.';

  @override
  String get failedPaymentPayByCard => 'Payer par carte';

  @override
  String get failedPaymentTryAgain => 'Réessayer';

  @override
  String get failedPaymentOpening => 'Ouverture…';

  @override
  String get failedPaymentRetrying => 'Nouvelle tentative…';

  @override
  String get failedPaymentTimeout =>
      'Délai de paiement dépassé. Veuillez réessayer.';

  @override
  String get failedPaymentNothingChargedApprove =>
      'Aucun montant n\'a été débité. Approuvez la demande Mobile Money sur votre téléphone, puis réessayez.';

  @override
  String failedPaymentFailedWithError(String error) {
    return 'Échec du paiement : $error';
  }

  @override
  String get failedPaymentFailedTryAgainShort =>
      'Échec du paiement. Réessayez.';

  @override
  String get failedPaymentFailedAgainTryDifferent =>
      'Le paiement a de nouveau échoué. Essayez un autre numéro MTN ou un autre forfait.';

  @override
  String get failedPaymentMaxSkipReached =>
      'Nombre maximal de reports atteint. Veuillez effectuer le paiement pour continuer.';

  @override
  String failedPaymentSkipsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vous pouvez reporter encore $count fois',
      one: 'Vous pouvez reporter encore 1 fois',
    );
    return '$_temp0';
  }

  @override
  String get failedPaymentSkipForNow => 'Ignorer pour l\'instant';

  @override
  String get failedPaymentSkipLimitReached => 'Limite de reports atteinte';

  @override
  String get failedPaymentTotal => 'Total';

  @override
  String get failedPaymentPlan => 'Forfait';

  @override
  String get dashboardNotApplicable => 'N/D';

  @override
  String failedPaymentDiscountWithCode(String code) {
    return 'Remise ($code)';
  }

  @override
  String get failedPaymentBilling => 'Facturation';

  @override
  String get failedPaymentAdditionalDevices => 'Appareils supplémentaires';

  @override
  String get failedPaymentEnterMtnNumber =>
      'Veuillez saisir votre numéro de téléphone MTN.';

  @override
  String get failedPaymentPhoneRequiredForMomo =>
      'Un numéro de téléphone est requis pour MTN Mobile Money. Activez « Utiliser un autre numéro » et saisissez votre numéro MTN.';

  @override
  String failedPaymentReasonNothingCharged(String reason) {
    return '$reason Aucun montant n\'a été débité — réessayez.';
  }

  @override
  String get failedPaymentDeclinedNothingCharged =>
      'Le paiement a été refusé. Aucun montant n\'a été débité — réessayez.';

  @override
  String paymentFinalizeListenerError(String error) {
    return 'Erreur lors de la configuration du suivi : $error';
  }

  @override
  String get paymentFinalizeSubscriptionEnded =>
      'Cet abonnement est terminé. Choisissez un forfait pour recommencer.';

  @override
  String get paymentFinalizeReusedCheckout =>
      'Une page de paiement était déjà ouverte pour ce forfait — nous l\'avons rouverte au lieu de créer un second abonnement.';

  @override
  String get paymentFinalizeNotSeenYet =>
      'Nous n\'avons pas encore reçu le paiement. Terminez-le sur la page de paiement, puis appuyez sur « J\'ai payé ».';

  @override
  String get paymentFinalizeDidNotGoThrough =>
      'Ce paiement n\'a pas abouti. Choisissez un forfait pour recommencer.';

  @override
  String get paymentFinalizeNotArrivedYet =>
      'Le paiement n\'est pas encore arrivé. Cela peut prendre un moment après avoir terminé sur la page de paiement.';

  @override
  String paymentFinalizeCouldNotCheck(String error) {
    return 'Impossible de vérifier le paiement pour le moment : $error';
  }

  @override
  String get paymentFinalizeWaitingForCard =>
      'En attente de votre paiement par carte';

  @override
  String get paymentFinalizeFinishOnPage =>
      'Terminez le paiement sur la page qui s\'est ouverte. Cet écran se met à jour automatiquement une fois le paiement effectué.';

  @override
  String get paymentFinalizeCompletePayment => 'Finaliser le paiement';

  @override
  String get paymentFinalizeCardPayment => 'Paiement par carte';

  @override
  String get paymentFinalizeMomoPayment => 'Paiement MTN Mobile Money';

  @override
  String get paymentFinalizeProcessedByCard =>
      'Le paiement sera traité par carte sur une page de paiement sécurisée';

  @override
  String get paymentFinalizeProcessedByMomo =>
      'Le paiement sera traité via MTN Mobile Money';

  @override
  String get paymentFinalizePlanSummary => 'Récapitulatif du forfait';

  @override
  String get paymentFinalizeUseDifferentPhone => 'Utiliser un autre numéro';

  @override
  String get paymentFinalizeSpecifyDifferentNumber =>
      'Indiquez un autre numéro pour le paiement';

  @override
  String get paymentFinalizeMtnPhoneNumber => 'Numéro de téléphone MTN';

  @override
  String get paymentFinalizeMtnPhoneHelper =>
      'Doit commencer par 250 78 ou 250 79';

  @override
  String get paymentFinalizeIHavePaid => 'J\'ai payé — vérifier maintenant';

  @override
  String get paymentFinalizeContinueToPage =>
      'Continuer vers la page de paiement';

  @override
  String get paymentFinalizeUseDifferentMethod =>
      'Utiliser un autre moyen de paiement';

  @override
  String paymentFinalizeApproveMomo(String message) {
    return '$message Approuvez la demande Mobile Money sur votre téléphone, puis réessayez.';
  }

  @override
  String paymentFinalizeFailedToInitiate(String error) {
    return 'Impossible de lancer le paiement : $error';
  }

  @override
  String get paymentPlanNoPlansAvailable =>
      'Aucun forfait d\'abonnement n\'est disponible.';

  @override
  String get paymentPlanCouldNotLoadPlans =>
      'Impossible de charger les forfaits d\'abonnement. Veuillez réessayer.';

  @override
  String get paymentPlanErrorOccurred =>
      'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get paymentPlanSelectTitle =>
      'Choisissez le forfait qui vous convient';

  @override
  String paymentPlanSelectSubtitle(String percent) {
    return 'Changez de forfait à tout moment. La facturation annuelle vous fait économiser $percent %.';
  }

  @override
  String get paymentPlanProceedToPayment => 'Passer au paiement';

  @override
  String get paymentPlanSettingUp => 'Configuration de votre forfait…';

  @override
  String get paymentPlanLoadingPlans => 'Chargement des forfaits…';

  @override
  String get paymentPlanTitle => 'Forfait de paiement';

  @override
  String get manualPurchasePaidExceedsTotal =>
      'Le montant payé maintenant ne peut pas dépasser le total de l\'achat.';

  @override
  String get manualPurchaseRequiredFields =>
      'Le fournisseur, un numéro de facture numérique et au moins une ligne avec une quantité supérieure à zéro sont requis.';

  @override
  String get manualPurchaseTaxVat18 => 'TVA 18 %';

  @override
  String get manualPurchaseTaxExempt => 'Exonéré';

  @override
  String get manualPurchaseTaxZeroRated => 'Taux zéro';

  @override
  String get manualPurchaseTaxNonVat => 'Hors TVA';

  @override
  String get manualPurchasePaySupplierBy => 'Payer le fournisseur avant le';

  @override
  String get manualPurchaseRecordPurchase => 'Enregistrer un achat';

  @override
  String get manualPurchaseSupplier => 'Fournisseur';

  @override
  String get manualPurchaseChooseSupplier => 'Choisir un fournisseur';

  @override
  String get manualPurchaseTinOptional => 'TIN (facultatif)';

  @override
  String get manualPurchaseTinMustBe9Digits =>
      'Le TIN doit comporter 9 chiffres';

  @override
  String get manualPurchaseInvoiceNumber => 'Numéro de facture';

  @override
  String get manualPurchaseNextInvoiceHint =>
      'Numéro suivant votre dernière facture';

  @override
  String get manualPurchaseEnterInvoiceNumber =>
      'Saisissez le numéro de facture';

  @override
  String get manualPurchasePurchaseDate => 'Date d\'achat';

  @override
  String get manualPurchaseHowDidYouPay => 'Comment avez-vous payé ?';

  @override
  String get manualPurchasePaidNow => 'Payé maintenant';

  @override
  String get manualPurchaseItemsEmptyHint =>
      'Ajoutez ce que vous avez acheté depuis votre catalogue, ou saisissez un nouvel article.';

  @override
  String get manualPurchaseFromCatalog => 'Depuis le catalogue';

  @override
  String get manualPurchaseNewItem => 'Nouvel article';

  @override
  String get manualPurchaseYouWillOwe => 'Vous devrez à ce fournisseur';

  @override
  String get manualPurchaseUnnamedItem => 'Article sans nom';

  @override
  String get manualPurchaseSummary => 'Récapitulatif';

  @override
  String get manualPurchaseTaxableVat18 => 'Imposable (TVA 18 %)';

  @override
  String get manualPurchaseVatIncluded => 'TVA incluse';

  @override
  String get manualPurchaseExemptZeroRated => 'Exonéré / taux zéro';

  @override
  String get manualPurchaseSaveAsWaiting => 'Enregistrer en attente';

  @override
  String manualPurchaseApproveWithTotal(String total) {
    return 'Approuver · $total';
  }

  @override
  String get manualPurchaseSaveAndApprove => 'Enregistrer et approuver';

  @override
  String get manualPurchaseSearchSuppliers => 'Rechercher des fournisseurs';

  @override
  String get manualPurchaseNewSupplier => 'Nouveau fournisseur';

  @override
  String manualPurchaseAddNamed(String name) {
    return 'Ajouter « $name »';
  }

  @override
  String get manualPurchaseNewSupplierHint =>
      'Enregistrez un fournisseur que vous n\'avez jamais utilisé';

  @override
  String get manualPurchaseNoSuppliersYet =>
      'Aucun fournisseur pour l\'instant';

  @override
  String manualPurchaseNoSupplierMatches(String query) {
    return 'Aucun fournisseur ne correspond à « $query »';
  }

  @override
  String manualPurchaseTinValue(String tin) {
    return 'TIN $tin';
  }

  @override
  String get manualPurchaseFromYourInvoices => 'Depuis vos factures';

  @override
  String get manualPurchaseSearchCatalog => 'Rechercher dans votre catalogue';

  @override
  String get manualPurchaseTypeProductName => 'Saisissez un nom de produit';

  @override
  String manualPurchaseNoProductMatches(String query) {
    return 'Aucun produit ne correspond à « $query »';
  }

  @override
  String manualPurchaseCostValue(String amount) {
    return 'Coût $amount';
  }

  @override
  String get manualPurchaseEditItem => 'Modifier l\'article';

  @override
  String get manualPurchaseItemName => 'Nom de l\'article';

  @override
  String get manualPurchaseEnterItemName => 'Saisissez le nom de l\'article';

  @override
  String get manualPurchaseMoreThanZero => 'Supérieur à 0';

  @override
  String get manualPurchaseUnitCost => 'Coût unitaire';

  @override
  String get manualPurchaseTax => 'Taxe';

  @override
  String get manualPurchaseLineTotal => 'Total de la ligne';

  @override
  String get manualPurchaseAddItem => 'Ajouter l\'article';

  @override
  String get manualPurchaseSupplierRequired => 'Le fournisseur est requis';

  @override
  String get manualPurchaseSupplierTin => 'TIN du fournisseur';

  @override
  String get manualPurchaseOptionalSuffix => '(facultatif)';

  @override
  String manualPurchaseExampleValue(String example) {
    return 'ex. $example';
  }

  @override
  String get manualPurchaseInvoiceNo => 'N° de facture';

  @override
  String get manualPurchaseNumericInvoiceRequired =>
      'Un numéro de facture numérique est requis';

  @override
  String get manualPurchasePaymentType => 'Type de paiement';

  @override
  String get manualPurchaseNoneFullCredit => '(aucun — crédit total)';

  @override
  String get manualPurchaseYouWillOweLabel => 'Vous devrez';

  @override
  String get manualPurchaseLineItems => 'Lignes d\'articles';

  @override
  String get manualPurchaseAddFromCatalog => 'Ajouter depuis le catalogue';

  @override
  String get manualPurchaseSearchCatalogEllipsis =>
      'Rechercher dans le catalogue…';

  @override
  String manualPurchaseSupplyAndTax(String price, String tax) {
    return 'Achat : $price · Taxe : $tax';
  }

  @override
  String get manualPurchaseNoItemsHint =>
      'Aucun article pour l\'instant — ajoutez-en depuis votre catalogue ou créez une nouvelle ligne.';

  @override
  String get manualPurchaseQty => 'Qté';

  @override
  String get manualPurchaseTaxable => 'Imposable';

  @override
  String get manualPurchaseExemptZero => 'Exonéré / zéro';

  @override
  String get manualPurchaseRequired => 'Obligatoire';

  @override
  String get manualPurchaseNewBadge => 'nouveau';

  @override
  String get manualPurchaseDuplicateInvoice => 'Facture en double';

  @override
  String get manualPurchaseDuplicateInvoiceBody =>
      'Un achat avec ce numéro de facture existe déjà pour cette succursale. Enregistrer quand même ?';

  @override
  String get manualPurchaseSaveAnyway => 'Enregistrer quand même';

  @override
  String get manualPurchaseRecordedApproved => 'Achat enregistré et approuvé';

  @override
  String manualPurchaseApprovalFailed(String error) {
    return 'Achat enregistré en attente. Échec de l\'approbation : $error';
  }

  @override
  String get manualPurchaseSavedAsWaiting => 'Achat enregistré en attente';

  @override
  String get manualPurchaseNewSupplierSubtitle => 'Créé sans quitter cet achat';

  @override
  String get manualPurchaseSupplierName => 'Nom du fournisseur';

  @override
  String get manualPurchasePhoneOptional => 'Téléphone (facultatif)';

  @override
  String get manualPurchaseCreateAndSelect => 'Créer et sélectionner';

  @override
  String get manualPurchaseNoMatchingSuppliers =>
      'Aucun fournisseur correspondant';

  @override
  String get manualPurchaseCreateNewSupplier => 'Créer un nouveau fournisseur';

  @override
  String get manualPurchaseSearchOrEnterSupplier =>
      'Rechercher ou saisir le nom du fournisseur';

  @override
  String get manualPurchaseBackToImport => 'Retour à Import et achats';

  @override
  String get manualPurchasePageSubtitle =>
      'Saisissez une facture fournisseur et ses lignes';

  @override
  String get reportStatusParked => 'En attente';

  @override
  String get reportStatusCompleted => 'Terminée';

  @override
  String get reportStatusCancelled => 'Annulée';

  @override
  String get reportStatusPending => 'En cours';

  @override
  String get reportView => 'Afficher';

  @override
  String get reportPrint => 'Imprimer';

  @override
  String get reportReceiptNo => 'N° de reçu';

  @override
  String get reportCashier => 'Caissier';

  @override
  String get reportType => 'Type';

  @override
  String get reportStatus => 'Statut';

  @override
  String get reportSaleTotal => 'Total de la vente';

  @override
  String get reportByHand => 'En main propre';

  @override
  String get reportBalanceDue => 'Solde dû';

  @override
  String get reportItemCode => 'Code article';

  @override
  String get reportBarcode => 'Code-barres';

  @override
  String get reportTaxRate => 'Taux de taxe';

  @override
  String get reportProfitMade => 'Bénéfice réalisé';

  @override
  String get reportSupplyAmount => 'Montant d\'achat';

  @override
  String get reportTaxPayable => 'Taxe à payer';

  @override
  String get reportNetProfit => 'Bénéfice net';

  @override
  String get reportTotalSales => 'Ventes totales';

  @override
  String get reportPeriodByHand => 'Période — En main propre';

  @override
  String get reportPeriodCredit => 'Période — Crédit';

  @override
  String reportStockCountUpdated(String product) {
    return 'Inventaire mis à jour pour $product';
  }

  @override
  String reportStockCountUpdateFailed(String error) {
    return 'Impossible de mettre à jour l\'inventaire : $error';
  }

  @override
  String get reportDismiss => 'Ignorer';

  @override
  String get reportTotalStockUnits => 'Stock total (unités) :';

  @override
  String get reportTotalSalesLines => 'Ventes totales (lignes) :';

  @override
  String get reportTotalSalesLabel => 'Ventes totales :';

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
  String get reportTitleReport => 'Rapport';

  @override
  String get reportTitleStockRecount => 'Recomptage du stock';

  @override
  String get reportTotalGrossProfit => 'Bénéfice brut total';

  @override
  String get reportClosingBalance => 'Solde de clôture';

  @override
  String reportStockRecountFor(String item) {
    return 'Recomptage du stock n° $item';
  }

  @override
  String get reportNewCount => 'Nouveau comptage';

  @override
  String get reportPleaseEnterNumber => 'Veuillez saisir un nombre';

  @override
  String get reportSummarized => 'Résumé';

  @override
  String get reportDetailed => 'Détaillé';

  @override
  String get reportZReport => 'Rapport Z';

  @override
  String get reportXReport => 'Rapport X';

  @override
  String get reportSaleReport => 'Rapport des ventes';

  @override
  String get reportPluReport => 'Rapport PLU';

  @override
  String get reportGrossProfit => 'Bénéfice brut';

  @override
  String get reportStartDate => 'Date de début';

  @override
  String get reportEndDate => 'Date de fin';

  @override
  String get reportTaxAmount => 'Montant de la taxe';

  @override
  String get reportPaymentType => 'Type de paiement';

  @override
  String get reportSaleAmount => 'Montant des ventes';

  @override
  String get reportTransactionCount => 'Nombre de transactions';

  @override
  String get reportPercentOfTotal => '% du total';

  @override
  String get reportExpense => 'Dépense';

  @override
  String get reportTotalExpenses => 'Total des dépenses';

  @override
  String reportLabelWithColon(String label) {
    return '$label :';
  }

  @override
  String get reportSavePdfFile => 'Enregistrer le fichier PDF';

  @override
  String reportDownloadSubject(String date) {
    return 'Téléchargement du rapport - $date';
  }

  @override
  String get reportBusinessFallback => 'Entreprise';

  @override
  String get reportPoweredByFlipper => 'Propulsé par Flipper';

  @override
  String reportGeneratedAt(String date) {
    return 'Généré le : $date';
  }

  @override
  String get reportUnknownExpense => 'Dépense inconnue';

  @override
  String get reportPdfExportNeedsGrid =>
      'L\'export PDF nécessite l\'écran de rapport complet avec un tableau. Désactivez l\'export PDF dans les paramètres pour exporter en Excel d\'ici, ou utilisez Rapports sur ordinateur.';

  @override
  String get reportDate => 'Date';

  @override
  String get reportPaymentMethod => 'Moyen de paiement';

  @override
  String get reportWalkInCustomer => 'Client de passage';

  @override
  String get reportStatusUnknown => 'Inconnu';

  @override
  String get reportImportsReport => 'Rapport des importations';

  @override
  String get reportPurchasesReport => 'Rapport des achats';

  @override
  String reportDateValue(String date) {
    return 'Date : $date';
  }

  @override
  String get reportRequestDate => 'Date de la demande';

  @override
  String get reportDeclarationNumber => 'Numéro de déclaration';

  @override
  String get reportQuantityUnitCode => 'Code d\'unité de quantité';

  @override
  String get reportAgentName => 'Nom de l\'agent';

  @override
  String get reportInvoiceForeignAmount => 'Montant de la facture\nen devise';

  @override
  String get reportForeignCurrency => 'Devise\nétrangère';

  @override
  String get reportSalesReport => 'Rapport des ventes';

  @override
  String reportPeriodRange(String end, String start) {
    return 'Période du rapport : $start - $end';
  }

  @override
  String get reportTotalRevenue => 'Chiffre d\'affaires total';

  @override
  String get reportTotalVat => 'TVA totale';

  @override
  String get reportTotalTransactions => 'Total des transactions';

  @override
  String get reportAvgTransaction => 'Transaction moyenne';

  @override
  String get reportBuyerTin => 'TIN de l\'acheteur';

  @override
  String get reportBuyerName => 'Nom de l\'acheteur';

  @override
  String get reportReceiptNumberShort => 'Reçu n°';

  @override
  String get reportItemsDetails => 'Détails des articles';

  @override
  String get reportIndividual => 'Particulier';

  @override
  String reportSaleItemLine(
    String name,
    String price,
    String qty,
    String total,
  ) {
    return '$name\n  Qté : $qty × $price\n  Total : $total';
  }

  @override
  String get reportStandard => 'Standard';

  @override
  String get branchTransferSelectDifferentBranch =>
      'Sélectionnez une autre succursale de destination';

  @override
  String branchTransferItemMissingVariant(String name) {
    return 'L\'article $name n\'a pas de variante de produit';
  }

  @override
  String get branchTransferCreatedNotLoaded =>
      'Le transfert a été créé mais n\'a pas pu être chargé';

  @override
  String get branchTransferApprovalIncomplete =>
      'Le transfert a été créé mais l\'approbation n\'a pas abouti ; il reste en attente de vérification';

  @override
  String branchTransferSmsReceived(int count, String requestId) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Transfert de stock : $count articles reçus d\'une autre succursale (n° $requestId).',
      one:
          'Transfert de stock : 1 article reçu d\'une autre succursale (n° $requestId).',
    );
    return '$_temp0';
  }

  @override
  String get pdfPreparingDocument => 'Préparation du document…';

  @override
  String get pdfDocument => 'Document';

  @override
  String pdfReadyToSaveOrShare(String label) {
    return '$label prêt à être enregistré ou partagé.';
  }

  @override
  String pdfSaveLabelPdf(String label) {
    return 'Enregistrer le PDF : $label';
  }

  @override
  String pdfSavedTo(String file, String label) {
    return '$label enregistré dans $file.';
  }

  @override
  String pdfSavedOnDevice(String label) {
    return '$label enregistré sur cet appareil.';
  }

  @override
  String pdfReadyChooseWhere(String label) {
    return '$label prêt — choisissez où l\'enregistrer.';
  }

  @override
  String get pdfSomethingWentWrong =>
      'Un problème est survenu. Veuillez réessayer.';

  @override
  String get receiptActionsPreparing => 'Préparation du reçu…';

  @override
  String receiptActionsShareSubject(String reference) {
    return 'Reçu · $reference';
  }

  @override
  String get receiptActionsThankYou => 'Merci pour votre achat.';

  @override
  String get receiptActionsBuildFailed =>
      'Impossible de préparer un reçu pour cette vente. Vérifiez votre connexion et réessayez.';

  @override
  String get receiptActionsTrainingBlocked =>
      'Les reçus de formation ne peuvent pas être partagés ni imprimés.';

  @override
  String get saleReceiptExpenseRecord => 'Note de dépense';

  @override
  String get saleReceiptSaleReceipt => 'Reçu de vente';

  @override
  String get saleReceiptNoLineItems =>
      'Aucune ligne n\'a été enregistrée pour cette transaction.';

  @override
  String saleReceiptCopyFooter(String date) {
    return 'Copie client générée à partir des données Flipper le $date. Ce document n\'est pas un reçu fiscal EBM.';
  }

  @override
  String saleReceiptCopyFooterWithEbm(String date) {
    return 'Copie client générée à partir des données Flipper le $date, avec les détails EBM enregistrés pour cette vente reproduits ci-dessus. Ce document n\'est pas le reçu signé par l\'EBM.';
  }

  @override
  String get saleReceiptCustomerCopy => 'Copie client';

  @override
  String get saleReceiptReference => 'Référence';

  @override
  String get saleReceiptCustomerTin => 'TIN du client';

  @override
  String get saleReceiptChange => 'Monnaie rendue';

  @override
  String saleReceiptRefundedVia(String amount, String method) {
    return 'Remboursé : $amount par $method';
  }

  @override
  String saleReceiptReason(String reason) {
    return 'Motif : $reason';
  }

  @override
  String get saleReceiptCard => 'Carte';

  @override
  String get refundTransactionAlreadyRefunded =>
      'Cette transaction a déjà été remboursée';

  @override
  String get refundCannotRefundProforma =>
      'Impossible de rembourser un reçu proforma';

  @override
  String get refundOnlyCompleted =>
      'Seules les transactions terminées peuvent être remboursées';

  @override
  String get refundCreditNotFullyPaid =>
      'Les ventes à crédit ou partiellement payées ne peuvent être remboursées qu\'une fois entièrement payées';

  @override
  String get refundEnterPurchaseCodeTitle => 'Saisir le code d\'achat';

  @override
  String get refundEnterPurchaseCodeHint => 'Saisissez le code d\'achat';

  @override
  String get refundNoLineItems =>
      'Aucune ligne à rembourser pour cette transaction';

  @override
  String get refundAmountMustBePositive =>
      'Le montant du remboursement doit être supérieur à zéro';

  @override
  String get refundAmountExceedsOriginal =>
      'Le montant du remboursement ne peut pas dépasser le paiement initial';

  @override
  String get refundPartialVatUnsupported =>
      'Les remboursements partiels avec EBM/TVA ne sont pas encore pris en charge. Effectuez un remboursement total.';

  @override
  String get refundPurchaseCodeRequired => 'Le code d\'achat est requis';

  @override
  String get refundCannotRefundReceiptType =>
      'Impossible de rembourser ce type de reçu';

  @override
  String get shiftSignOutAnyway => 'Se déconnecter quand même';

  @override
  String get shiftCheckingYourShift => 'Vérification de votre service…';

  @override
  String get shiftCannotCloseShift => 'Impossible de clôturer le service';

  @override
  String get shiftBelongsToAnotherUserSwitch =>
      'Le service ouvert appartient à un autre utilisateur. Demandez à cet agent de clôturer son service, puis réessayez de changer d\'utilisateur.';

  @override
  String get shiftBelongsToAnotherUserTitle =>
      'Le service appartient à un autre utilisateur';

  @override
  String get shiftBelongsToAnotherUserSignOut =>
      'Le service ouvert a été démarré par un autre agent ; il ne peut donc pas être clôturé ici.\n\nVous pouvez quand même vous déconnecter. Le service reste ouvert pour que cet agent le clôture.';

  @override
  String get shiftCloseToSwitchUser =>
      'Clôturer le service pour changer d\'utilisateur';

  @override
  String get shiftCloseToSignOut => 'Clôturer le service pour se déconnecter';

  @override
  String get shiftCouldNotCloseShift => 'Impossible de clôturer le service';

  @override
  String shiftCouldNotCloseSignOutAnyway(String error) {
    return 'Le service n\'a pas pu être clôturé :\n\n$error\n\nVous pouvez quand même vous déconnecter. Le service reste ouvert et pourra être clôturé à votre prochaine connexion.';
  }

  @override
  String get shiftClosedTakingToLogin =>
      'Service clôturé. Redirection vers l\'écran de connexion…';

  @override
  String get shiftSignOut => 'Se déconnecter';

  @override
  String get shiftNoOpenShiftContinue =>
      'Vous n\'avez aucun service ouvert. Continuer vers l\'écran de connexion ?';

  @override
  String get shiftSigningOut => 'Déconnexion…';

  @override
  String shiftTakingTooLongRetry(String error) {
    return 'Cela prend trop de temps. Vérifiez votre connexion et réessayez.\n\n$error';
  }

  @override
  String get shiftTakingTooLongSignOutAnyway =>
      'La vérification de votre service prend trop de temps — vous êtes peut-être hors ligne.\n\nVous pouvez quand même vous déconnecter. Tout service ouvert le reste et pourra être clôturé à votre prochaine connexion.';

  @override
  String shiftCheckFailedRetry(String error) {
    return 'Veuillez réessayer. Si le problème persiste, vérifiez votre connexion.\n\n$error';
  }

  @override
  String shiftCheckFailedSignOutAnyway(String error) {
    return 'Votre service n\'a pas pu être vérifié :\n\n$error\n\nVous pouvez quand même vous déconnecter. Tout service ouvert le reste et pourra être clôturé à votre prochaine connexion.';
  }

  @override
  String get shiftCouldNotVerify => 'Impossible de vérifier le service';

  @override
  String endOfShiftTodaysShift(String day) {
    return 'Service du jour · $day';
  }

  @override
  String get endOfShiftTitle => 'Fin de service';

  @override
  String get endOfShiftNoOpenShift => 'Aucun service ouvert';

  @override
  String get endOfShiftCollected => 'Encaissé pendant ce service';

  @override
  String get endOfShiftCashDrawer => 'Tiroir-caisse';

  @override
  String get endOfShiftSalesCompleted => 'Ventes réalisées';

  @override
  String get endOfShiftItemsSold => 'Articles vendus';

  @override
  String get endOfShiftCloseAndSignOut =>
      'Clôturer le service et se déconnecter';

  @override
  String get endOfShiftSwitchBranch => 'Changer de succursale';

  @override
  String get endOfShiftStaySignedIn => 'Rester connecté';

  @override
  String get endOfShiftSalesSaved =>
      'Vos ventes sont enregistrées — la caisse sera rapprochée à la clôture.';

  @override
  String get endOfShiftAgent => 'Agent';

  @override
  String get endOfShiftBranch => 'Succursale';

  @override
  String get signOutSigningYouOut => 'Déconnexion en cours…';

  @override
  String get logoutLoggingOut => 'Déconnexion...';

  @override
  String get posSwitchCouldNotLoadStaff => 'Impossible de charger le personnel';

  @override
  String get posSwitchNoOtherStaff =>
      'Aucun autre membre du personnel disponible.';

  @override
  String get posSwitchUserTitle => 'Changer d\'utilisateur';

  @override
  String get posSwitchUserSubtitle =>
      'Sélectionnez un membre du personnel et saisissez son PIN';

  @override
  String get posSwitchTapNameLeft =>
      'Appuyez sur un nom à gauche, puis saisissez son PIN';

  @override
  String get posSwitchTapNameAbove =>
      'Appuyez sur un nom ci-dessus, puis saisissez son PIN';

  @override
  String get posSwitchEnterPin => 'Saisissez le PIN à 6 chiffres pour changer';

  @override
  String get posSwitchWhosNext => 'Qui est le suivant ?';

  @override
  String get posSwitchSelectStaff => 'Choisir un employé';

  @override
  String get posSwitchStaff => 'Employé';

  @override
  String get posSwitchCannotSwitchUser =>
      'Impossible de changer d\'utilisateur';

  @override
  String get posSwitchNoLinkedAccount =>
      'Ce membre du personnel n\'a pas de compte utilisateur associé.';

  @override
  String get posSwitchPinMismatch =>
      'Le PIN ne correspond pas au membre du personnel sélectionné.';

  @override
  String get posSwitchPinUnresolved =>
      'Impossible de vérifier le PIN du membre du personnel sélectionné.';

  @override
  String get posSwitchMissingContext =>
      'Impossible de changer d\'utilisateur sans entreprise ni succursale. Déconnectez-vous puis reconnectez-vous, puis réessayez.';

  @override
  String get posSwitchCouldNotSwitch => 'Impossible de changer d\'utilisateur';

  @override
  String get posSwitchRefreshStaff => 'Actualiser la liste du personnel';

  @override
  String get posSwitchSharedRegister => 'Caisse · Poste partagé';

  @override
  String get posSwitchNoStaffAvailable =>
      'Aucun membre du personnel disponible.';

  @override
  String get posSwitchTapYourNameLeft =>
      'Appuyez sur votre nom à gauche, puis saisissez votre PIN';

  @override
  String get posSwitchTapYourNameAbove =>
      'Appuyez sur votre nom ci-dessus, puis saisissez votre PIN';

  @override
  String get posSwitchEnterYourPin =>
      'Saisissez votre PIN à 6 chiffres pour ouvrir la caisse';

  @override
  String get posSwitchWhosServing => 'Qui sert ?';

  @override
  String get posSwitchWhosOnRegister => 'Qui tient la caisse ?';

  @override
  String posSwitchOpeningPosFor(String name) {
    return 'Ouverture de la caisse pour $name…';
  }

  @override
  String get posSwitchOpeningPos => 'Ouverture de la caisse…';

  @override
  String get orderingNoSupplierSelected => 'Aucun fournisseur sélectionné';

  @override
  String get orderingSelectSupplierHint =>
      'Sélectionnez un fournisseur dans la recherche ci-dessus\npour voir les produits disponibles';

  @override
  String get orderingNewOrder => 'Nouvelle commande';

  @override
  String get orderingPointOfSale => 'Point de vente';

  @override
  String get orderingTransactionHistory => 'Historique des transactions';

  @override
  String get orderingMoreOptions => 'Plus d\'options';

  @override
  String get orderingAllProducts => 'Tous les produits';

  @override
  String get orderingUncategorised => 'Sans catégorie';

  @override
  String get orderingCategories => 'Catégories';

  @override
  String get orderingLoading => 'Chargement…';

  @override
  String get orderingFilter => 'Filtre';

  @override
  String get orderingInStockOnly => 'En stock uniquement';

  @override
  String get orderingShowRetailMargin => 'Afficher la marge de détail';

  @override
  String get orderingHidingOutOfStock =>
      'Les articles que le fournisseur n\'a pas sont masqués.';

  @override
  String get orderingOutOfStockShown =>
      'Les articles en rupture restent affichés, en rouge.';

  @override
  String get orderingLastOrder => 'Dernière commande';

  @override
  String get orderingNoPreviousOrder =>
      'Aucune commande précédente avec ce fournisseur.';

  @override
  String orderingLineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lignes',
      one: '1 ligne',
    );
    return '$_temp0';
  }

  @override
  String get orderingAwaitingApproval => 'en attente d\'approbation';

  @override
  String get orderingApprovedLower => 'approuvée';

  @override
  String get orderingPartlyApproved => 'partiellement approuvée';

  @override
  String get orderingEmpty => 'vide';

  @override
  String orderingUnitCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unités',
      one: '1 unité',
    );
    return '$_temp0';
  }

  @override
  String get orderingThisOrder => 'Cette commande';

  @override
  String get orderingClearAll => 'Tout effacer';

  @override
  String get orderingNoLinesYet => 'Aucune ligne pour l\'instant';

  @override
  String get orderingEmptyHintBefore => 'Recherchez un produit et appuyez sur';

  @override
  String get orderingEmptyHintAfter => '— le meilleur résultat arrive ici.';

  @override
  String get orderingRemoveLine => 'Supprimer la ligne';

  @override
  String orderingCostDeltaVsLast(String delta) {
    return '$delta % vs dernier';
  }

  @override
  String orderingOnlyAvailable(String count) {
    return 'seulement $count disponible(s)';
  }

  @override
  String get orderingOneLess => 'Commander un de moins';

  @override
  String get orderingOneMore => 'Commander un de plus';

  @override
  String orderingVatRate(String rate) {
    return 'TVA $rate %';
  }

  @override
  String get orderingPayWith => 'Payer avec';

  @override
  String get orderingSendingOrder => 'Envoi de la commande…';

  @override
  String get orderingAddProductToContinue =>
      'Ajoutez un produit pour continuer';

  @override
  String get orderingChoosePayment => 'Choisissez votre mode de paiement';

  @override
  String orderingPlaceOrderTotal(String total) {
    return 'Passer la commande · $total';
  }

  @override
  String get orderingLoadingPaymentOptions =>
      'Chargement des options de paiement…';

  @override
  String get orderingPaymentOptionsUnavailable =>
      'Options de paiement indisponibles — la commande sera envoyée sans.';

  @override
  String get orderingNoPaymentOption =>
      'Aucune option de paiement configurée pour cette entreprise — la commande sera envoyée sans.';

  @override
  String get orderingDeliveryNoteOptional => 'Note de livraison (facultatif)';

  @override
  String orderingOrderSentTo(String supplier) {
    return 'Commande envoyée à $supplier';
  }

  @override
  String get orderingPlacedHint =>
      'Ils reçoivent un SMS maintenant ; vous la verrez dans Commandes entrantes une fois acceptée.';

  @override
  String get orderingStartAnotherOrder => 'Démarrer une autre commande';

  @override
  String get orderingSearchProductsHint =>
      'Rechercher produits, SKU ou code-barres…';

  @override
  String get orderingColProduct => 'Produit';

  @override
  String get orderingColTheirStock => 'Leur stock';

  @override
  String get orderingColRetailMargin => 'Détail · marge';

  @override
  String get orderingColOrderQty => 'Qté commandée';

  @override
  String get orderingStockNone => 'aucun';

  @override
  String get orderingSupplierNoProducts =>
      'Ce fournisseur n\'a aucun produit à commander';

  @override
  String get orderingSupplierNoProductsHint =>
      'Rien de leur catalogue n\'est encore partagé avec votre succursale.';

  @override
  String get orderingNothingMatchesFilters => 'Aucun résultat pour ces filtres';

  @override
  String orderingNothingMatchesQuery(String query) {
    return 'Aucun résultat pour « $query »';
  }

  @override
  String get orderingNothingMatchesHint =>
      'Essayez un mot plus court ou retirez le filtre « en stock ».';

  @override
  String get orderingCouldNotLoadCatalogue =>
      'Impossible de charger ce catalogue';

  @override
  String get orderingPickerTitle =>
      'Auprès de quel fournisseur commandez-vous ?';

  @override
  String get orderingPickerBody =>
      'Choisissez une succursale auprès de laquelle vous achetez. Son catalogue, votre dernier coût et son stock disponible se chargent directement dans la commande.';

  @override
  String get orderingSearchSuppliersHint =>
      'Rechercher des fournisseurs par nom…';

  @override
  String get orderingNotOnList => 'Pas dans la liste ?';

  @override
  String get orderingCouldNotLoadSuppliers =>
      'Impossible de charger les fournisseurs';

  @override
  String get orderingNoOtherBranch =>
      'Aucune autre succursale auprès de laquelle commander';

  @override
  String get orderingNoOtherBranchHint =>
      'Ajoutez une succursale ou recherchez un fournisseur par nom.';

  @override
  String get orderingFrequentSuppliers => 'Fournisseurs les plus utilisés';

  @override
  String get orderingBranchesYouCanOrderFrom =>
      'Succursales auprès desquelles commander';

  @override
  String get orderingOtherBranchesYouCanOrderFrom =>
      'Autres succursales auprès desquelles commander';

  @override
  String orderingNoSupplierMatches(String query) {
    return 'Aucun fournisseur ne correspond à « $query »';
  }

  @override
  String get orderingNoSupplierMatchesHint =>
      'Vérifiez l\'orthographe ou ajoutez-le comme nouvelle succursale.';

  @override
  String get orderingOnThisDevice => 'Sur cet appareil';

  @override
  String get orderingFoundByNameSearch => 'Trouvés par recherche de nom';

  @override
  String get orderingUnnamedBranch => 'Succursale sans nom';

  @override
  String get orderingAddNewSupplier => 'Ajouter un nouveau fournisseur';

  @override
  String get orderingThisBranch => 'Cette succursale';

  @override
  String get orderingNewPurchaseOrder => 'Nouveau bon de commande';

  @override
  String get orderingShortcutSearch => 'rechercher';

  @override
  String get orderingShortcutAddTopMatch => 'ajouter le meilleur résultat';

  @override
  String get orderingChangeSupplier => 'Changer de fournisseur';

  @override
  String get orderingChoosePaymentBeforeSending =>
      'Choisissez votre mode de paiement avant d\'envoyer la commande.';

  @override
  String get orderingTheSupplier => 'le fournisseur';

  @override
  String get orderingSearchSuppliersEllipsis =>
      'Rechercher des fournisseurs...';

  @override
  String get orderingUnknownSupplier => 'Fournisseur inconnu';

  @override
  String get orderingNoSuppliersFound => 'Aucun fournisseur trouvé';

  @override
  String get orderingTryDifferentSearch =>
      'Essayez un autre terme de recherche';

  @override
  String get orderingSelectSupplierFirst =>
      'Veuillez d\'abord sélectionner un fournisseur.';

  @override
  String get orderingSupplierInvalidId =>
      'Le fournisseur sélectionné a un identifiant invalide. Veuillez en choisir un autre.';

  @override
  String get orderingCannotOrderFromYourself =>
      'Vous ne pouvez pas commander auprès de vous-même.';

  @override
  String get orderingCartIsEmpty => 'Le panier est vide';

  @override
  String orderingSmsNewOrder(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nouvelle commande de $count articles, total : $total',
      one: 'Nouvelle commande de 1 article, total : $total',
    );
    return '$_temp0';
  }

  @override
  String get orderingPlacedTitle => 'Commande passée avec succès';

  @override
  String get orderingPlacedDescription =>
      'Votre commande a été traitée et confirmée.';

  @override
  String get orderingPlacedSnack => 'Commande passée avec succès';

  @override
  String get orderingCartEmptyAddProduct =>
      'Le panier est vide — ajoutez un produit avant de commander.';

  @override
  String get createCategoryTitle => 'Créer une catégorie';

  @override
  String get createCategoryEnterName => 'Saisissez le nom de la catégorie';

  @override
  String get createCategoryNameHint => 'Nom de la catégorie';

  @override
  String get createLoadingEllipsis => 'Chargement...';

  @override
  String get createSelectCategory => 'Choisir une catégorie';

  @override
  String get createAddVariation => 'Ajouter une variante';

  @override
  String get createEnterProductName => 'Saisissez le nom du produit';

  @override
  String get createNameRequired => 'Nom requis';

  @override
  String get createRetailPrice => 'Prix de vente';

  @override
  String get createEnterRetailPrice => 'Saisissez le prix de vente';

  @override
  String get createRetailPriceRequired => 'Prix de vente requis';

  @override
  String get createShouldBeNumber => 'Doit être un nombre';

  @override
  String get createCostPrice => 'Prix d\'achat';

  @override
  String get createEnterCostPrice => 'Saisissez le prix d\'achat';

  @override
  String get createCostPriceRequired => 'Prix d\'achat requis';

  @override
  String get createEnterSku => 'Saisissez le SKU';

  @override
  String get createTaxExempted => 'Exonéré de taxe';

  @override
  String get createFillRequiredFields =>
      'Remplissez tous les champs obligatoires';

  @override
  String get photosPickColor => 'Choisir une couleur';

  @override
  String get photosSelectColorShade => 'Choisir une nuance';

  @override
  String get photosSelectedColorShades => 'Couleur sélectionnée et ses nuances';

  @override
  String get photosPickColorInstead => 'Choisir plutôt une couleur';

  @override
  String get photosSavedLocally =>
      'Image enregistrée localement. Elle sera envoyée une fois en ligne.';

  @override
  String get photosAddImageOffline => 'Ajouter une image (hors ligne)';

  @override
  String get photosAddImage => 'Ajouter une image';

  @override
  String get photosClickToChange => 'Cliquez pour changer l\'image';

  @override
  String get photosUploadImage => 'Téléverser une image';

  @override
  String get colorTileColors => 'Couleurs';

  @override
  String get colorTileNewItem => 'Nouvel article';

  @override
  String get colorTileChooseLabelColor => 'Choisir la couleur de l\'étiquette';

  @override
  String get colorTilePhotoLabel => 'Étiquette photo';

  @override
  String get colorTileTakePhoto => 'Prendre une photo';

  @override
  String get categoriesSearchHint => 'Rechercher des catégories...';

  @override
  String get categoriesCreateNew => 'Créer une nouvelle catégorie';

  @override
  String get categoriesAll => 'Toutes les catégories';

  @override
  String get categoriesNoneFound => 'Aucune catégorie trouvée';

  @override
  String get unitsUnitType => 'Type d\'unité';

  @override
  String get unitsNoneAvailable => 'Aucune unité disponible';

  @override
  String get unitsSelectUnit => 'Choisir une unité';

  @override
  String get receiveStockTitle => 'Réceptionner du stock';

  @override
  String get receiveStockButton => 'Réceptionner';

  @override
  String get receiveStockEnterValue => 'Veuillez saisir la quantité en stock';

  @override
  String get receiveStockAddStock => 'Ajouter du stock';

  @override
  String get receiveStockTrackingHint =>
      'Le suivi de l\'inventaire sera activé par défaut pour les articles avec un stock. Pour le désactiver, rendez-vous sur votre tableau de bord Flipper';

  @override
  String get purchaseStatusWaiting => 'En attente';

  @override
  String get purchaseStatusDeclined => 'Refusé';

  @override
  String get purchaseColumnNo => 'N°';

  @override
  String get purchaseSupplyPrice => 'Prix d\'achat';

  @override
  String get purchaseAssignVariant => 'Associer une variante';

  @override
  String get purchaseSearchVariants => 'Rechercher des variantes...';

  @override
  String get cartPaymentsAtTillSendToManager =>
      'Les paiements sont encaissés à la caisse. Envoyez cette commande à un responsable.';

  @override
  String get cartTransactionNotFound =>
      'Transaction introuvable pour la finalisation.';

  @override
  String cartSplitEnterAmountFor(String indices) {
    return 'saisissez un montant pour le paiement $indices';
  }

  @override
  String cartSplitFixInvalidAmountFor(String indices) {
    return 'corrigez le montant invalide du paiement $indices';
  }

  @override
  String cartSplitAmountAboveZeroFor(String indices) {
    return 'chaque moyen doit avoir un montant supérieur à zéro (paiement $indices)';
  }

  @override
  String cartSplitMultipleMethodsInUse(String details) {
    return 'Plusieurs moyens de paiement sont utilisés : $details.';
  }

  @override
  String get cartCreditNeedsCustomer =>
      'Un nom ou un téléphone client est requis pour les paiements à crédit.';

  @override
  String get cartUnsavedOneItem =>
      'Un article n\'a pas pu être enregistré dans cette vente. Retirez-le du panier et ajoutez-le à nouveau.';

  @override
  String cartUnsavedNamed(String name) {
    return '$name n\'a pas pu être enregistré dans cette vente. Retirez-le du panier et ajoutez-le à nouveau.';
  }

  @override
  String cartUnsavedTwo(String first, String second) {
    return '$first et $second n\'ont pas pu être enregistrés dans cette vente. Retirez-les du panier et ajoutez-les à nouveau.';
  }

  @override
  String cartUnsavedMany(String count, String first, String second) {
    return '$first, $second et $count autre(s) n\'ont pas pu être enregistrés dans cette vente. Retirez-les du panier et ajoutez-les à nouveau.';
  }

  @override
  String get cartAddItemsBeforeReview =>
      'Ajoutez des articles au panier avant d\'envoyer pour vérification.';

  @override
  String get cartPaymentParkedAsLoan =>
      'Paiement enregistré. Transaction mise en attente comme crédit.';

  @override
  String get cartSentForReview => 'Envoyé pour vérification';

  @override
  String get cartPaymentSuccessful => 'Paiement réussi';

  @override
  String get cartPaymentConfirmationTimeout =>
      'Délai de confirmation du paiement dépassé. Veuillez réessayer.';

  @override
  String get errorUnableToSaveData =>
      'Impossible d\'enregistrer les données. Redémarrez l\'application et réessayez.';

  @override
  String get errorDatabaseBusy =>
      'La base de données est occupée. Patientez un instant et réessayez.';

  @override
  String get errorNoInternet =>
      'Pas de connexion Internet. Vérifiez votre réseau et réessayez.';

  @override
  String get errorSessionExpired =>
      'Session expirée. Veuillez vous reconnecter.';

  @override
  String get errorNoPermission =>
      'Vous n\'avez pas l\'autorisation d\'effectuer cette action.';

  @override
  String get errorRequestTimedOut => 'La requête a expiré. Veuillez réessayer.';

  @override
  String get errorPermissionDenied =>
      'Autorisation refusée. Vérifiez les autorisations de l\'application dans les paramètres.';

  @override
  String get errorServerUnavailable =>
      'Le serveur est temporairement indisponible. Veuillez réessayer plus tard.';

  @override
  String get errorNotFound => 'La ressource demandée est introuvable.';

  @override
  String get errorCheckInput => 'Vérifiez votre saisie et réessayez.';

  @override
  String get errorSyncUnavailable =>
      'Synchronisation temporairement indisponible. Vos modifications seront synchronisées au retour de la connexion.';

  @override
  String get errorGenericContactSupport =>
      'Un problème est survenu. Réessayez ou contactez le support si le problème persiste.';

  @override
  String get pickImageNoFileSelected => 'Aucun fichier sélectionné.';

  @override
  String get pickImageReadFailed =>
      'Impossible de lire le fichier sélectionné. Veuillez réessayer.';

  @override
  String get pickImageNoData =>
      'Ce fichier est vide. Veuillez en choisir un autre.';

  @override
  String pickImageTooLarge(String kb) {
    return 'Veuillez choisir une image de moins de $kb Ko.';
  }

  @override
  String get pickImageNotReadable =>
      'Ce fichier n\'est pas un PNG ou JPEG lisible. Veuillez en choisir un autre.';

  @override
  String get posCartViewOnlyCannotAdd =>
      'Accès en lecture seule — vous ne pouvez pas ajouter d\'articles à une vente.';

  @override
  String get posCartNoActiveCart => 'Aucun panier de vente actif. Réessayez.';

  @override
  String get imageSourceGallery => 'Galerie';

  @override
  String get imageSourceCamera => 'Appareil photo';

  @override
  String get imageSourceBrowseFiles => 'Parcourir les fichiers';

  @override
  String get stockItemUnavailable => 'Article indisponible';

  @override
  String get stockItemsUnavailable => 'Articles indisponibles';

  @override
  String stockNotEnoughSingle(String name) {
    return 'Nous n\'avons pas assez de $name en stock pour finaliser votre commande.';
  }

  @override
  String get stockRequestedQuantity => 'Quantité demandée :';

  @override
  String get stockNotEnoughMultiple =>
      'Nous n\'avons pas assez de ces articles en stock :';

  @override
  String stockRequestedValue(String qty) {
    return 'Demandé : $qty';
  }

  @override
  String get stockReduceOrRemoveItem =>
      'Vous pouvez réduire la quantité ou retirer cet article pour continuer.';

  @override
  String get stockAdjustOrRemoveItems =>
      'Vous pouvez ajuster les quantités ou retirer ces articles pour continuer.';

  @override
  String get stockGotIt => 'Compris';

  @override
  String get ticketCompleteEnterCustomerName =>
      'Veuillez saisir le nom du client avant de finaliser.';

  @override
  String get ticketCompletePhoneRequiredNoTin =>
      'Un numéro de téléphone client est requis lorsqu\'aucun TIN n\'est enregistré.';

  @override
  String get ticketCompleteDone => 'Ticket finalisé';

  @override
  String get ticketCompleteFailed => 'Impossible de finaliser le ticket';

  @override
  String get ticketCompleteInProgress => 'Finalisation du ticket…';

  @override
  String get hrWeekdayMonday => 'lundi';

  @override
  String get hrWeekdayShortMon => 'lun.';

  @override
  String get hrWeekdayTuesday => 'mardi';

  @override
  String get hrWeekdayShortTue => 'mar.';

  @override
  String get hrWeekdayWednesday => 'mercredi';

  @override
  String get hrWeekdayShortWed => 'mer.';

  @override
  String get hrWeekdayThursday => 'jeudi';

  @override
  String get hrWeekdayShortThu => 'jeu.';

  @override
  String get hrWeekdayFriday => 'vendredi';

  @override
  String get hrWeekdayShortFri => 'ven.';

  @override
  String get hrWeekdaySaturday => 'samedi';

  @override
  String get hrWeekdayShortSat => 'sam.';

  @override
  String get hrWeekdaySunday => 'dimanche';

  @override
  String get hrWeekdayShortSun => 'dim.';

  @override
  String get hrMonthJanuary => 'janvier';

  @override
  String get hrMonthShortJan => 'janv.';

  @override
  String get hrMonthFebruary => 'février';

  @override
  String get hrMonthShortFeb => 'févr.';

  @override
  String get hrMonthMarch => 'mars';

  @override
  String get hrMonthShortMar => 'mars';

  @override
  String get hrMonthApril => 'avril';

  @override
  String get hrMonthShortApr => 'avr.';

  @override
  String get hrMonthMay => 'mai';

  @override
  String get hrMonthShortMay => 'mai';

  @override
  String get hrMonthJune => 'juin';

  @override
  String get hrMonthShortJun => 'juin';

  @override
  String get hrMonthJuly => 'juillet';

  @override
  String get hrMonthShortJul => 'juil.';

  @override
  String get hrMonthAugust => 'août';

  @override
  String get hrMonthShortAug => 'août';

  @override
  String get hrMonthSeptember => 'septembre';

  @override
  String get hrMonthShortSep => 'sept.';

  @override
  String get hrMonthOctober => 'octobre';

  @override
  String get hrMonthShortOct => 'oct.';

  @override
  String get hrMonthNovember => 'novembre';

  @override
  String get hrMonthShortNov => 'nov.';

  @override
  String get hrMonthDecember => 'décembre';

  @override
  String get hrMonthShortDec => 'déc.';

  @override
  String hrLongDate(String weekday, String day, String month) {
    return '$weekday $day $month';
  }

  @override
  String hrDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String hrDaysFractional(String days) {
    return '$days jours';
  }

  @override
  String hrDurationMinutes(String minutes) {
    return '$minutes min';
  }

  @override
  String hrDurationHours(String hours) {
    return '$hours h';
  }

  @override
  String hrDurationHoursMinutes(String hours, String minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get hrGoodMorning => 'Bonjour';

  @override
  String get hrGoodAfternoon => 'Bon après-midi';

  @override
  String get hrGoodEvening => 'Bonsoir';

  @override
  String hrGreetingWithName(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get hrAddAPerson => 'Ajouter une personne';

  @override
  String get hrApprovals => 'Approbations';

  @override
  String hrReviewRequests(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Examiner $count demandes',
      one: 'Examiner 1 demande',
    );
    return '$_temp0';
  }

  @override
  String get hrAttendanceBoard => 'Tableau des présences';

  @override
  String get hrHeadcount => 'Effectif';

  @override
  String hrActiveCount(String count) {
    return '$count actifs';
  }

  @override
  String get hrOnLeave => 'En congé';

  @override
  String get hrWaitingOnYou => 'En attente de vous';

  @override
  String get hrNeedsADecision => 'Décision requise';

  @override
  String get hrAllClear => 'Rien en attente';

  @override
  String get hrNewThisMonth => 'Nouveaux ce mois-ci';

  @override
  String get hrMonthlyPayroll => 'Masse salariale mensuelle';

  @override
  String get hrEstimated => 'Estimation';

  @override
  String get hrNeedsYourDecision => 'Requiert votre décision';

  @override
  String get hrNeedsYourDecisionSubtitle =>
      'Demandes de congé encore sans réponse';

  @override
  String get hrOpenQueue => 'Ouvrir la file';

  @override
  String get hrCouldNotLoadApprovalsQueue =>
      'Impossible de charger la file d\'approbation.';

  @override
  String get hrTryAgain => 'Réessayer';

  @override
  String get hrNothingWaitingOnYou =>
      'Rien ne vous attend. Toutes les demandes ont été traitées.';

  @override
  String hrMoreWaiting(String count) {
    return '$count autres en attente';
  }

  @override
  String hrEmployeeWithId(String id) {
    return 'Employé $id';
  }

  @override
  String get hrOutToday => 'Absents aujourd\'hui';

  @override
  String get hrRoster => 'Effectif';

  @override
  String get hrEveryoneIsInToday => 'Tout le monde est présent aujourd\'hui.';

  @override
  String get hrJoinedThisMonth => 'Arrivés ce mois-ci';

  @override
  String get hrNobodyNewThisMonth => 'Aucune arrivée ce mois-ci.';

  @override
  String get hrEmploymentFullTime => 'Temps plein';

  @override
  String get hrEmploymentPartTime => 'Temps partiel';

  @override
  String get hrEmploymentContract => 'Contrat';

  @override
  String get hrEmploymentIntern => 'Stagiaire';

  @override
  String get hrEmploymentCasual => 'Occasionnel';

  @override
  String get hrStatusActive => 'Actif';

  @override
  String get hrStatusSuspended => 'Suspendu';

  @override
  String get hrStatusTerminated => 'Licencié';

  @override
  String get hrPayMonthly => 'Mensuel';

  @override
  String get hrPayWeekly => 'Hebdomadaire';

  @override
  String get hrPayDaily => 'Journalier';

  @override
  String get hrPayHourly => 'À l\'heure';

  @override
  String get hrPaymentBankTransfer => 'Virement bancaire';

  @override
  String get hrAttendanceNotIn => 'Absent';

  @override
  String get hrAttendanceClockedIn => 'Pointé à l\'arrivée';

  @override
  String get hrAttendanceClockedOut => 'Pointé au départ';

  @override
  String get hrAttendanceSourceSelf => 'Soi-même';

  @override
  String get hrAttendanceSourceManager => 'Enregistré par le responsable';

  @override
  String get hrLeaveStatusPending => 'En attente';

  @override
  String get hrLeaveStatusRejected => 'Refusé';

  @override
  String get hrLeaveStatusCancelled => 'Annulé';

  @override
  String get hrLeaveTypeAnnual => 'Congé annuel';

  @override
  String get hrLeaveTypeSick => 'Congé maladie';

  @override
  String get hrLeaveTypeMaternity => 'Congé de maternité';

  @override
  String get hrLeaveTypePaternity => 'Congé de paternité';

  @override
  String get hrLeaveTypeCompassionate => 'Congé pour événement familial';

  @override
  String get hrLeaveTypeUnpaid => 'Congé sans solde';

  @override
  String hrPersonAddedToRoster(String name) {
    return '$name a été ajouté(e) à l\'effectif.';
  }

  @override
  String hrSavedChangesTo(String name) {
    return 'Modifications de $name enregistrées.';
  }

  @override
  String hrInviteSentNotLinked(String message) {
    return 'Invitation envoyée, mais non liée. $message';
  }

  @override
  String hrPersonIsNowStatus(String name, String status) {
    return '$name est désormais $status.';
  }

  @override
  String hrTerminatePersonTitle(String name) {
    return 'Licencier $name ?';
  }

  @override
  String hrTerminatePersonBody(String date) {
    return 'Son dernier jour sera enregistré au $date. La fiche est conservée pour l\'historique de paie, mais la personne quitte l\'effectif.';
  }

  @override
  String get hrTerminate => 'Licencier';

  @override
  String get hrAccessDiagnostic => 'Diagnostic d\'accès';

  @override
  String hrDiagnosticFailed(String error) {
    return 'Échec du diagnostic : $error';
  }

  @override
  String get hrPeople => 'Personnel';

  @override
  String get hrEveryoneOnThisBranch => 'Tout le personnel de cette succursale';

  @override
  String hrEveryoneAtBranch(String branch) {
    return 'Tout le personnel de $branch';
  }

  @override
  String get hrAddPerson => 'Ajouter une personne';

  @override
  String get hrSearchPeopleHint => 'Rechercher nom, poste, téléphone…';

  @override
  String get hrStatus => 'Statut';

  @override
  String get hrEmployed => 'Employés';

  @override
  String get hrDepartment => 'Service';

  @override
  String get hrAllDepartments => 'Tous les services';

  @override
  String get hrSortBy => 'Trier par';

  @override
  String get hrReportsTo => 'Responsable';

  @override
  String get hrContact => 'Contact';

  @override
  String get hrTenure => 'Ancienneté';

  @override
  String get hrBasePay => 'Salaire de base';

  @override
  String hrReportsToName(String name) {
    return 'Rend compte à $name';
  }

  @override
  String get hrResendHrInvite => 'Renvoyer l\'invitation RH';

  @override
  String get hrInviteToHr => 'Inviter dans RH';

  @override
  String get hrMarkActive => 'Marquer actif';

  @override
  String get hrMarkOnLeave => 'Marquer en congé';

  @override
  String get hrSuspend => 'Suspendre';

  @override
  String get hrNoOneOnBranchYet =>
      'Personne dans cette succursale pour l\'instant';

  @override
  String get hrNoOneOnBranchYetMessage =>
      'Ajoutez une première personne pour suivre les présences, les congés et la paie.';

  @override
  String get hrNoOneMatchesFilters => 'Personne ne correspond à ces filtres';

  @override
  String get hrClearFilters => 'Effacer les filtres';

  @override
  String get hrWhyWasThisDenied => 'Pourquoi l\'accès a-t-il été refusé ?';

  @override
  String hrTenureStarts(String date) {
    return 'Débute le $date';
  }

  @override
  String hrTenureDays(String days) {
    return '$days j';
  }

  @override
  String hrTenureMonths(String months) {
    return '$months mois';
  }

  @override
  String hrTenureYears(String years) {
    return '$years a';
  }

  @override
  String hrTenureYearsMonths(String years, String months) {
    return '$years a $months mois';
  }

  @override
  String get hrSortNameAsc => 'Nom (A–Z)';

  @override
  String get hrSortNameDesc => 'Nom (Z–A)';

  @override
  String get hrSortNewestHire => 'Embauche la plus récente';

  @override
  String get hrSortLongestServing => 'Plus ancien';

  @override
  String get hrSortHighestPaid => 'Mieux payé';

  @override
  String get hrEditPerson => 'Modifier la personne';

  @override
  String get hrSectionIdentity => 'Identité';

  @override
  String get hrFirstName => 'Prénom';

  @override
  String get hrLastName => 'Nom';

  @override
  String get hrEmailOptional => 'E-mail (facultatif)';

  @override
  String get hrNationalIdOptional => 'Pièce d\'identité nationale (facultatif)';

  @override
  String get hrRssbNumberOptional => 'Numéro RSSB (facultatif)';

  @override
  String get hrSectionRole => 'Poste';

  @override
  String get hrJobTitle => 'Intitulé du poste';

  @override
  String get hrDepartmentOptional => 'Service (facultatif)';

  @override
  String get hrEmploymentType => 'Type d\'emploi';

  @override
  String get hrStartDate => 'Date de début';

  @override
  String get hrLastDayOptional => 'Dernier jour (facultatif)';

  @override
  String get hrSectionPay => 'Rémunération';

  @override
  String hrBasePayWithCurrency(String currency) {
    return 'Salaire de base ($currency)';
  }

  @override
  String get hrPayFrequency => 'Fréquence de paie';

  @override
  String get hrAnnualLeaveDays => 'Jours de congé annuel';

  @override
  String hrAnnualLeaveDaysHelper(String days) {
    return 'Laissez vide pour le minimum légal de $days jours ouvrés';
  }

  @override
  String get hrMobileMoneyNumber => 'Numéro mobile money';

  @override
  String get hrMobileMoneyNumberHelper =>
      'Laissez vide pour payer le numéro de contact ci-dessus';

  @override
  String get hrBank => 'Banque';

  @override
  String get hrAccountNumber => 'Numéro de compte';

  @override
  String get hrSectionNotes => 'Notes';

  @override
  String get hrNotesOptional => 'Notes (facultatif)';

  @override
  String get hrSaveChanges => 'Enregistrer les modifications';

  @override
  String get hrManagerNotOnRoster =>
      'Son responsable actuel ne fait pas partie de l\'effectif de cette succursale. Choisissez quelqu\'un ici pour le changer.';

  @override
  String get hrManagerNobodyToChoose =>
      'Personne à choisir pour l\'instant — les demandes de congé vont au gérant de l\'entreprise.';

  @override
  String get hrManagerHelper =>
      'Ses demandes de congé iront à cette personne. Sans choix, elles vont au gérant de l\'entreprise.';

  @override
  String get hrNoManager => 'Aucun responsable';

  @override
  String get hrFirstNameRequired => 'Le prénom est obligatoire';

  @override
  String get hrLastNameRequired => 'Le nom est obligatoire';

  @override
  String get hrJobTitleRequired => 'L\'intitulé du poste est obligatoire';

  @override
  String get hrPhoneNumberRequired => 'Le numéro de téléphone est obligatoire';

  @override
  String get hrEnterValidPhoneNumber =>
      'Saisissez un numéro de téléphone valide';

  @override
  String get hrEnterValidEmail => 'Saisissez une adresse e-mail valide';

  @override
  String hrNationalIdLength(String min, String max) {
    return 'Une pièce d\'identité nationale compte de $min à $max caractères';
  }

  @override
  String get hrStartDateTooFarAhead =>
      'La date de début ne peut pas dépasser un an';

  @override
  String get hrLastDayRequiredToTerminate =>
      'Un dernier jour est requis pour licencier';

  @override
  String get hrLastDayBeforeStart =>
      'Le dernier jour ne peut pas précéder la date de début';

  @override
  String get hrCannotReportToSelf =>
      'Une personne ne peut pas être son propre responsable';

  @override
  String get hrPayCannotBeNegative => 'Le salaire ne peut pas être négatif';

  @override
  String get hrLeaveDaysCannotBeNegative =>
      'Les jours de congé ne peuvent pas être négatifs';

  @override
  String get hrLeaveDaysTooMany =>
      'C\'est plus qu\'une année de travail — saisissez des jours, pas des heures';

  @override
  String get hrMobileMoneyNumberRequired =>
      'Le numéro mobile money est obligatoire';

  @override
  String get hrEnterValidMobileMoneyNumber =>
      'Saisissez un numéro mobile money valide';

  @override
  String get hrBankNameRequired => 'Le nom de la banque est obligatoire';

  @override
  String get hrAccountNumberRequired => 'Le numéro de compte est obligatoire';

  @override
  String get hrPickFirstDayOfLeave => 'Choisissez le premier jour de congé.';

  @override
  String get hrPickLastDayOfLeave => 'Choisissez le dernier jour de congé.';

  @override
  String get hrLastDayBeforeFirstDay =>
      'Le dernier jour ne peut pas précéder le premier.';

  @override
  String get hrLeaveTooFarAhead =>
      'Un congé ne peut pas être réservé plus d\'un an à l\'avance. Vérifiez l\'année de ces dates.';

  @override
  String get hrLeaveCannotStartInPast =>
      'Un congé ne peut pas commencer dans le passé.';

  @override
  String hrLeaveBackdatedTooFar(String days) {
    return 'Ce congé a commencé il y a plus de $days jours. Demandez au gestionnaire de l\'effectif de l\'enregistrer.';
  }

  @override
  String hrLeaveReasonRequired(String leaveType) {
    return 'Indiquez brièvement pourquoi vous avez besoin de : $leaveType.';
  }

  @override
  String get hrPickAtLeastOneDay => 'Choisissez au moins un jour.';

  @override
  String get hrPeriodAllWeekend =>
      'Cette période ne contient que des week-ends — choisissez au moins un jour ouvré.';

  @override
  String hrLeaveOverlaps(String start, String end, String status) {
    return 'Ce congé chevauche un congé existant du $start au $end ($status).';
  }

  @override
  String hrNoLeaveLeft(String leaveType, String year) {
    return 'Plus de $leaveType disponible pour $year.';
  }

  @override
  String hrOnlyLeaveLeft(
    String left,
    String leaveType,
    String year,
    String requested,
  ) {
    return 'Il ne reste que $left de $leaveType pour $year ; cette demande en compte $requested.';
  }

  @override
  String get hrRequestLeave => 'Demander un congé';

  @override
  String hrLeaveForName(String name) {
    return 'Congé pour $name';
  }

  @override
  String get hrLeaveTypeField => 'Type';

  @override
  String get hrFirstDay => 'Premier jour';

  @override
  String get hrLastDay => 'Dernier jour';

  @override
  String get hrNoteOptional => 'Note (facultatif)';

  @override
  String get hrReason => 'Motif';

  @override
  String get hrSending => 'Envoi…';

  @override
  String get hrSendRequest => 'Envoyer la demande';

  @override
  String hrLeaveCostCalendarDays(String days) {
    return '$days (jours calendaires)';
  }

  @override
  String hrLeaveCostWorkingDays(String days) {
    return '$days (jours ouvrés)';
  }

  @override
  String get hrUnpaidLeaveNoLimit =>
      'le congé sans solde n\'a pas de limite annuelle';

  @override
  String hrMoreThanYouHaveLeft(String days) {
    return '$days de plus que votre solde';
  }

  @override
  String hrLeftAfterThis(String days) {
    return '$days restants ensuite';
  }

  @override
  String get hrLeaveTakenNoLimit => 'pris · sans limite annuelle';

  @override
  String hrLeaveLeftOf(String days) {
    return 'restants sur $days';
  }

  @override
  String hrLeaveAwaitingApproval(String days) {
    return '$days en attente d\'approbation';
  }

  @override
  String get hrLeaveRequestSent =>
      'Demande de congé envoyée. Elle apparaîtra ici une fois traitée.';

  @override
  String get hrWithdrawRequestTitle => 'Retirer cette demande ?';

  @override
  String hrWithdrawRequestBody(String start, String end) {
    return 'Votre congé du $start au $end sera annulé et les jours seront recrédités sur votre solde.';
  }

  @override
  String get hrKeepIt => 'Conserver';

  @override
  String get hrWithdraw => 'Retirer';

  @override
  String get hrRequestWithdrawn => 'Demande retirée.';

  @override
  String get hrCouldNotLoadYourRecord => 'Impossible de charger votre fiche';

  @override
  String get hrCouldNotLoadYourLeave => 'Impossible de charger vos congés';

  @override
  String get hrMyLeave => 'Mes congés';

  @override
  String hrBalancesFor(String name, String year) {
    return '$name · soldes $year';
  }

  @override
  String hrRequestsGoTo(String name) {
    return 'Les demandes vont à $name';
  }

  @override
  String get hrEmploymentEndedNotice =>
      'Votre contrat a pris fin : aucun nouveau congé ne peut être réservé. Votre historique reste disponible ici.';

  @override
  String get hrRequests => 'Demandes';

  @override
  String get hrNoLeaveBookedYet =>
      'Aucun congé réservé pour l\'instant. Vos soldes ci-dessus sont ce dont vous disposez cette année.';

  @override
  String get hrNoEmployeeRecordTitle => 'Aucune fiche employé pour ce compte';

  @override
  String get hrNoEmployeeRecordLeaveBody =>
      'Les congés sont réservés pour une personne inscrite à l\'effectif d\'une succursale, et cette connexion ne correspond encore à personne. Demandez au gestionnaire de votre effectif de vous inviter depuis la page Personnel — c\'est ce qui lie votre fiche à ce compte. S\'il l\'a déjà fait, vérifiez que le numéro de téléphone de votre fiche est celui utilisé pour vous connecter.';

  @override
  String get hrLeaveApproved => 'Congé approuvé.';

  @override
  String get hrLeaveRejected => 'Congé refusé.';

  @override
  String get hrLeave => 'Congés';

  @override
  String get hrWithTheirManager => 'Chez leur responsable';

  @override
  String get hrWithTheirManagerCaption =>
      'Leur responsable n\'a pas encore répondu. En décider ici revient à trancher à sa place.';

  @override
  String get hrDecided => 'Traitées';

  @override
  String get hrNothingWaitingOnYouShort => 'Rien en attente de vous';

  @override
  String hrRequestsWaitingOnYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count demandes vous attendent',
      one: '1 demande vous attend',
    );
    return '$_temp0';
  }

  @override
  String hrWithAnotherManager(String count) {
    return '$count chez un autre responsable';
  }

  @override
  String get hrYourTeam => 'Votre équipe';

  @override
  String get hrApproveThisLeave => 'Approuver ce congé ?';

  @override
  String get hrRejectThisLeave => 'Refuser ce congé ?';

  @override
  String get hrRejectReasonLabel => 'Pourquoi ? (visible par la personne)';

  @override
  String get hrApprove => 'Approuver';

  @override
  String get hrReject => 'Refuser';

  @override
  String get hrOnlyTheirManagerCanAnswer =>
      'Seul leur responsable peut répondre à celle-ci.';

  @override
  String get hrNoLeaveRequestsYet => 'Aucune demande de congé pour l\'instant';

  @override
  String get hrNoLeaveRequestsOwnerHint =>
      'Invitez des personnes depuis la page Personnel pour qu\'elles réservent leurs congés. Indiquez le responsable de chacun et ses demandes lui seront adressées ; celles des personnes sans responsable arrivent ici.';

  @override
  String get hrNoLeaveRequestsManagerHint =>
      'Les demandes des personnes qui vous rendent compte apparaîtront ici pour approbation.';

  @override
  String get hrErrorLoadPeopleOnBranch =>
      'Impossible de charger le personnel de cette succursale.';

  @override
  String get hrErrorLoadPersonRecord =>
      'Impossible de charger la fiche de cette personne.';

  @override
  String hrErrorAddPerson(String name) {
    return 'Impossible d\'ajouter $name.';
  }

  @override
  String hrErrorSavePerson(String name) {
    return 'Impossible d\'enregistrer les modifications de $name.';
  }

  @override
  String get hrErrorLinkAccount =>
      'L\'invitation a été envoyée, mais cette fiche n\'a pas pu être liée au nouveau compte. Ses congés ne fonctionneront pas tant que ce n\'est pas fait.';

  @override
  String hrErrorChangeStatus(String status) {
    return 'Impossible de passer cette personne au statut $status.';
  }

  @override
  String get hrThisPerson => 'cette personne';

  @override
  String get hrErrorLoadYourLeave => 'Impossible de charger vos congés.';

  @override
  String get hrErrorLoadBranchLeave =>
      'Impossible de charger les congés de cette succursale.';

  @override
  String get hrErrorLoadTeamLeave =>
      'Impossible de charger les congés de votre équipe.';

  @override
  String get hrErrorSendLeaveRequest =>
      'Impossible d\'envoyer cette demande de congé.';

  @override
  String get hrErrorWithdrawRequest =>
      'Impossible de retirer cette demande. Elle a peut-être déjà été traitée.';

  @override
  String get hrErrorApproveAlreadyDecided =>
      'Impossible d\'approuver cette demande : elle a déjà été traitée ou retirée. Actualisez pour voir son état.';

  @override
  String get hrErrorRejectAlreadyDecided =>
      'Impossible de refuser cette demande : elle a déjà été traitée ou retirée. Actualisez pour voir son état.';

  @override
  String get hrErrorApproveRequest => 'Impossible d\'approuver cette demande.';

  @override
  String get hrErrorRejectRequest => 'Impossible de refuser cette demande.';

  @override
  String get hrErrorLoadDayAttendance =>
      'Impossible de charger les présences de ce jour.';

  @override
  String get hrErrorLoadTimesheet =>
      'Impossible de charger cette feuille de temps.';

  @override
  String get hrErrorCheckClockedIn =>
      'Impossible de vérifier si vous avez pointé.';

  @override
  String get hrErrorCorrectEntry => 'Impossible de corriger cette entrée.';

  @override
  String get hrErrorServerReturnedNothing =>
      'Le serveur a accepté le pointage mais n\'a rien renvoyé à afficher.';

  @override
  String get hrErrorClockInNotAllowed =>
      'Vous n\'êtes pas autorisé à pointer l\'arrivée de cette personne.';

  @override
  String get hrErrorClockOutNotAllowed =>
      'Vous n\'êtes pas autorisé à pointer le départ de cette personne.';

  @override
  String get hrErrorClockIn => 'Impossible de pointer l\'arrivée.';

  @override
  String get hrErrorClockOut => 'Impossible de pointer le départ.';

  @override
  String get hrErrorLoadYourTeam => 'Impossible de charger votre équipe.';

  @override
  String hrErrorResolveAccess(String error) {
    return 'Impossible de déterminer vos accès : $error';
  }

  @override
  String get hrRoleStaffLabel => 'Employé — réserve ses propres congés';

  @override
  String get hrRoleManagerLabel => 'Responsable — effectif et approbations';

  @override
  String get hrRoleStaff => 'Employé';

  @override
  String get hrRoleManager => 'Responsable';

  @override
  String hrInviteTitle(String name) {
    return 'Inviter $name dans RH';
  }

  @override
  String get hrInviteNoContact =>
      'Cette fiche n\'a ni téléphone ni e-mail : impossible d\'envoyer une invitation. Ajoutez-en un d\'abord.';

  @override
  String hrInviteWillGetPin(String contact) {
    return 'La personne recevra un PIN pour se connecter sur hr.useflipper.com, confirmé par un code envoyé à $contact.';
  }

  @override
  String get hrInviteEmailNoPhone =>
      'Cette fiche a un e-mail mais pas de téléphone. La connexion exige un code par SMS : ajoutez un numéro avant d\'inviter.';

  @override
  String get hrInviteAlreadyHasAccount =>
      'La personne a déjà un compte. Une nouvelle invitation génère un nouveau PIN et met à jour ses droits — elle ne crée pas de doublon.';

  @override
  String hrInviteDirectReports(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count personnes lui rendent compte : elle approuvera leurs congés quel que soit le rôle choisi. Le rôle de responsable ajoute l\'effectif et la paie de tous.',
      one:
          '1 personne lui rend compte : elle approuvera ses congés quel que soit le rôle choisi. Le rôle de responsable ajoute l\'effectif et la paie de tous.',
    );
    return '$_temp0';
  }

  @override
  String get hrInviteWhatCanTheyDo => 'Que peut faire cette personne ?';

  @override
  String get hrSendInvite => 'Envoyer l\'invitation';

  @override
  String get hrRoleStaffDescription =>
      'Consulte sa fiche, réserve ses congés et vérifie son solde — et approuve les congés des personnes qui lui rendent compte.';

  @override
  String get hrRoleManagerDescription =>
      'Tout ce qui précède, plus l\'effectif de la succursale, la paie et l\'approbation des congés pour toute l\'entreprise.';

  @override
  String get hrInviteSent => 'Invitation envoyée';

  @override
  String hrInviteCanNowSignIn(String name, String role) {
    return '$name peut maintenant se connecter sur hr.useflipper.com en tant que $role.';
  }

  @override
  String get hrCopyPin => 'Copier le PIN';

  @override
  String get hrPinCopied => 'PIN copié.';

  @override
  String hrInvitePinHelp(String phone) {
    return 'La connexion demande ce PIN, puis un code envoyé au $phone. Transmettez le PIN maintenant — il ne sera plus affiché, et un PIN perdu se remplace en invitant la personne à nouveau.';
  }

  @override
  String get hrInviteNeedsContact =>
      'Un numéro de téléphone ou un e-mail est requis pour inviter cette personne.';

  @override
  String hrInviteErrorAccount(String contact) {
    return 'Impossible de trouver ou de créer un compte Flipper pour $contact.';
  }

  @override
  String hrInviteErrorNoAccountId(String contact) {
    return 'Flipper a répondu sans identifiant de compte pour $contact.';
  }

  @override
  String get hrInviteErrorNoMembershipId =>
      'L\'adhésion a été créée mais Flipper n\'a pas renvoyé son identifiant.';

  @override
  String hrInviteErrorGrantAccess(String name, String error) {
    return 'Impossible de donner à $name l\'accès à cette entreprise : $error';
  }

  @override
  String hrInviteErrorCreatePin(String name) {
    return 'Impossible de créer un PIN de connexion pour $name.';
  }

  @override
  String get hrInviteErrorNoPin =>
      'Le PIN a été demandé mais Flipper n\'en a renvoyé aucun.';

  @override
  String get hrInviteErrorNoMembership =>
      'Le compte a été créé mais n\'a aucune adhésion à cette entreprise : la connexion ne mènerait nulle part. Réessayez d\'inviter cette personne.';

  @override
  String hrInviteErrorConfirmMembership(String error) {
    return 'Impossible de confirmer la nouvelle adhésion : $error';
  }

  @override
  String get hrInviteErrorTimeout =>
      'Flipper n\'a pas répondu à temps — vérifiez la connexion et réessayez.';

  @override
  String get hrInviteErrorNotJson =>
      'Flipper a répondu avec un contenu qui n\'est pas du JSON :';

  @override
  String get hrEnterValidMomoNumber =>
      'Saisissez un numéro MTN ou Airtel valide, p. ex. 0788123456.';

  @override
  String get hrMomoUnreadableReply =>
      'La passerelle de paiement a envoyé une réponse illisible.';

  @override
  String get hrMomoNoReference =>
      'Le paiement a démarré mais aucune référence n\'a été renvoyée — vérifiez votre relevé Mobile Money avant de réessayer.';

  @override
  String get hrMomoMissingReference => 'Référence de paiement manquante.';

  @override
  String get hrMomoRejectedInvalid =>
      'La demande de paiement a été rejetée comme invalide.';

  @override
  String get hrMomoNotAuthorised =>
      'Ce compte n\'est pas autorisé à encaisser des paiements.';

  @override
  String get hrMomoServiceNotFound => 'Le service de paiement est introuvable.';

  @override
  String get hrMomoAlreadySubmitted => 'Ce paiement a déjà été soumis.';

  @override
  String get hrMomoUnavailable =>
      'Mobile Money est indisponible pour le moment. Réessayez dans un instant.';

  @override
  String hrMomoCouldNotStart(String status) {
    return 'Le paiement n\'a pas pu démarrer (HTTP $status).';
  }

  @override
  String get hrErrorCheckSubscription =>
      'Impossible de vérifier l\'abonnement de cette entreprise.';

  @override
  String get hrErrorLoadPlanPrice =>
      'Impossible de charger le prix de cette formule.';

  @override
  String get hrErrorStartSubscription =>
      'Impossible de démarrer l\'abonnement.';

  @override
  String get hrErrorSkipPayment => 'Impossible de reporter ce paiement.';

  @override
  String get hrPreparingSubscription => 'Préparation de votre abonnement…';

  @override
  String hrErrorStartSubscriptionWith(String error) {
    return 'Impossible de démarrer l\'abonnement : $error';
  }

  @override
  String get hrSubscriptionAlreadyActive => 'Cet abonnement est déjà actif.';

  @override
  String get hrSendingRequestToPhone =>
      'Envoi de la demande sur votre téléphone…';

  @override
  String hrPaymentCouldNotStartWith(String error) {
    return 'Le paiement n\'a pas pu démarrer : $error';
  }

  @override
  String get hrApproveMomoOnPhone =>
      'Approuvez la demande Mobile Money sur votre téléphone.';

  @override
  String get hrPaymentReceivedActive =>
      'Paiement reçu. Votre abonnement est actif.';

  @override
  String get hrPaymentNotCompleted =>
      'Le paiement n\'a pas été finalisé sur votre téléphone.';

  @override
  String get hrPaymentNoVerdictYet =>
      'Mobile Money n\'a pas encore répondu. Si vous avez approuvé la demande, l\'accès sera débloqué sous peu — revérifiez dans un instant.';

  @override
  String get hrSubscriptionEnded => 'Votre abonnement a expiré';

  @override
  String get hrThisNeedsSubscription =>
      'Cette fonctionnalité nécessite un abonnement';

  @override
  String hrFeatureNeedsSubscription(String feature) {
    return '$feature : abonnement requis';
  }

  @override
  String get hrSubscriptionEndedBody =>
      'Rien n\'a été supprimé — l\'effectif, les congés et les présences sont toujours là. Renouvelez l\'abonnement pour y accéder à nouveau.';

  @override
  String get hrSubscriptionPitch =>
      'Flipper HR fait partie de l\'abonnement Flipper. Payez une fois pour l\'entreprise et l\'effectif, les congés et les présences s\'ouvrent pour toute l\'équipe.';

  @override
  String get hrPaymentOnItsWay =>
      'Un paiement est déjà en cours. Si vous l\'avez approuvé sur votre téléphone, l\'accès sera débloqué dès confirmation par Mobile Money.';

  @override
  String get hrRenewNow => 'Renouveler maintenant';

  @override
  String get hrSeeThePlan => 'Voir la formule';

  @override
  String get hrSubscriptionCheckFailedOpen =>
      'Impossible de vérifier l\'abonnement de cette entreprise : l\'accès reste ouvert pour l\'instant.';

  @override
  String get hrTestPricingOn =>
      'La tarification de test est activée pour ce projet : les abonnements sont facturés à prix réduit.';

  @override
  String hrSkipEndsSoon(String used, String max) {
    return 'Vous utilisez un accès gratuit sans payer ($used report(s) sur $max utilisé(s)). Il prend fin bientôt.';
  }

  @override
  String hrSkipEndsToday(String used, String max) {
    return 'Vous utilisez un accès gratuit sans payer ($used report(s) sur $max utilisé(s)). Il prend fin aujourd\'hui.';
  }

  @override
  String hrSkipEndsInDays(int days, String used, String max) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other:
          'Vous utilisez un accès gratuit sans payer ($used report(s) sur $max utilisé(s)). Il prend fin dans $days jours.',
      one:
          'Vous utilisez un accès gratuit sans payer ($used report(s) sur $max utilisé(s)). Il prend fin dans 1 jour.',
    );
    return '$_temp0';
  }

  @override
  String get hrPayNow => 'Payer maintenant';

  @override
  String get hrSubscriptionEndsToday =>
      'Votre abonnement prend fin aujourd\'hui.';

  @override
  String get hrSubscriptionEndsTomorrow => 'Votre abonnement prend fin demain.';

  @override
  String hrSubscriptionEndsInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Votre abonnement prend fin dans $days jours.',
      one: 'Votre abonnement prend fin dans 1 jour.',
    );
    return '$_temp0';
  }

  @override
  String get hrRenew => 'Renouveler';

  @override
  String get hrFeatureDashboard => 'Le tableau de bord';

  @override
  String get hrFeatureRoster => 'L\'effectif';

  @override
  String get hrFeatureAttendanceBoard => 'Le tableau des présences';

  @override
  String hrErrorSkipPaymentWith(String error) {
    return 'Impossible de reporter ce paiement : $error';
  }

  @override
  String get hrSkipping => 'Report en cours…';

  @override
  String hrSkipForNow(String count) {
    return 'Reporter pour l\'instant ($count restant(s))';
  }

  @override
  String get hrSubscribePickBusiness =>
      'Choisissez l\'entreprise pour laquelle vous payez ; la formule et son prix s\'afficheront ici.';

  @override
  String get hrChooseABusiness => 'Choisir une entreprise';

  @override
  String hrCouldNotLoadPlan(String error) {
    return 'Impossible de charger la formule : $error';
  }

  @override
  String get hrRenewYourSubscription => 'Renouveler votre abonnement';

  @override
  String get hrSubscribeToFlipper => 'S\'abonner à Flipper';

  @override
  String get hrPeriodYearly => 'Annuel';

  @override
  String hrTestPricingNormally(String amount, String period) {
    return 'Tarification de test active — normalement $amount $period.';
  }

  @override
  String get hrWhatBusinessIsUsing => 'Ce que cette entreprise utilise';

  @override
  String get hrUsagePosUsers => 'Utilisateurs POS';

  @override
  String get hrUsageBranches => 'Succursales';

  @override
  String get hrUsageHrEmployees => 'Employés RH';

  @override
  String hrUsageUnlimited(String used) {
    return '$used · illimité';
  }

  @override
  String hrUsageOf(String used, String cap) {
    return '$used sur $cap';
  }

  @override
  String get hrMomoNumberLabel => 'Numéro Mobile Money';

  @override
  String get hrPaymentReceived => 'Paiement reçu.';

  @override
  String get hrOpenFlipperHr => 'Ouvrir Flipper HR';

  @override
  String get hrPreparing => 'Préparation…';

  @override
  String get hrWaitingForApproval => 'En attente de votre approbation…';

  @override
  String hrPayWithMomo(String amount) {
    return 'Payer $amount avec Mobile Money';
  }

  @override
  String hrMomoPromptNote(String amount) {
    return 'Vous recevrez une demande Mobile Money sur ce numéro. L\'approuver débite $amount.';
  }

  @override
  String get hrPerYear => 'par an';

  @override
  String get hrPerMonth => 'par mois';

  @override
  String get hrExpandMenu => 'Développer le menu';

  @override
  String get hrCollapseMenu => 'Réduire le menu';

  @override
  String get hrSearchPeople => 'Rechercher des personnes…';

  @override
  String get hrSwitchBusinessOrBranch =>
      'Changer d\'entreprise ou de succursale';

  @override
  String get hrSigningOut => 'Déconnexion…';

  @override
  String get hrNavYou => 'Vous';

  @override
  String get hrAttendance => 'Présences';

  @override
  String get hrMyTime => 'Mon temps';

  @override
  String get hrPickBranchToContinue =>
      'Choisissez une succursale pour continuer';

  @override
  String get hrPickBranchBody =>
      'Les données RH sont rattachées à une succursale : choisissez celle sur laquelle vous travaillez.';

  @override
  String get hrChooseBusinessOrBranch =>
      'Choisir l\'entreprise ou la succursale';

  @override
  String hrCouldNotCheckSession(String error) {
    return 'Impossible de vérifier votre session : $error';
  }

  @override
  String hrCouldNotLoadBusinesses(String error) {
    return 'Impossible de charger vos entreprises : $error';
  }

  @override
  String get hrBackToSignIn => 'Retour à la connexion';

  @override
  String get hrBrandTagline =>
      'Votre équipe, votre temps, votre personnel — tout au même endroit.';

  @override
  String get hrBrandSubtitle =>
      'Présences, paie et congés sont prêts dès votre connexion.';

  @override
  String get hrBrandStatEmployees => 'employés gérés';

  @override
  String get hrBrandStatPayroll => 'de paie traitée chaque mois';

  @override
  String get hrBrandStatUptime => 'de disponibilité';

  @override
  String get hrBrandPayrollThisMonth => 'Paie · ce mois-ci';

  @override
  String get hrBrandNewHire => 'Nouvelle recrue';

  @override
  String get hrBrandDayOne => 'Jour 1';

  @override
  String get hrBrandAttendanceStreak => 'Série de présences';

  @override
  String get hrClockedInToast => 'Arrivée pointée.';

  @override
  String hrClockedOutToast(String worked) {
    return 'Départ pointé — $worked aujourd\'hui.';
  }

  @override
  String hrYourHoursForLastDays(String days) {
    return 'Vos heures des $days derniers jours.';
  }

  @override
  String get hrNoRecordNoHours =>
      'Ce compte n\'a pas encore de fiche employé : aucune heure à suivre. Demandez au responsable RH de vous ajouter.';

  @override
  String get hrRecentDays => 'Jours récents';

  @override
  String hrClockedInAt(String time) {
    return 'Arrivée pointée à $time';
  }

  @override
  String get hrNotClockedInToday => 'Pas encore pointé aujourd\'hui';

  @override
  String hrLastOutAt(String time) {
    return 'Dernier départ à $time';
  }

  @override
  String get hrClockOut => 'Pointer le départ';

  @override
  String get hrClockIn => 'Pointer l\'arrivée';

  @override
  String hrWorkedInDays(String worked, String days) {
    return '$worked en $days jours';
  }

  @override
  String get hrToday => 'Aujourd\'hui';

  @override
  String get hrOvernight => 'de nuit';

  @override
  String get hrNoHours => 'Aucune heure';

  @override
  String hrSessionUntilNow(String start) {
    return '$start – maintenant';
  }

  @override
  String hrBreakDuration(String duration) {
    return '$duration de pause';
  }

  @override
  String hrPersonClockedIn(String name) {
    return 'Arrivée de $name pointée.';
  }

  @override
  String hrPersonClockedOut(String name) {
    return 'Départ de $name pointé.';
  }

  @override
  String get hrAttendanceNoOneOnBranch =>
      'Personne dans cette succursale pour l\'instant. Ajoutez d\'abord des personnes pour enregistrer leurs heures ici.';

  @override
  String get hrOnRoster => 'À l\'effectif';

  @override
  String get hrRecorded => 'Enregistrés';

  @override
  String get hrHours => 'Heures';

  @override
  String get hrChangeDay => 'Changer de jour';

  @override
  String get hrNoHoursToday => 'Aucune heure aujourd\'hui';

  @override
  String hrInAt(String time) {
    return 'Arrivée $time';
  }

  @override
  String hrOutAt(String time) {
    return 'départ $time';
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
  String get authSignIn => 'Se connecter';

  @override
  String get authToContinueToAccount => 'pour accéder à votre compte';

  @override
  String get authEnterYourEmail => 'Saisissez votre e-mail';

  @override
  String get authPleaseEnterEmail => 'Veuillez saisir votre e-mail';

  @override
  String get authPleaseEnterValidEmail => 'Veuillez saisir un e-mail valide';

  @override
  String get authPassword => 'Mot de passe';

  @override
  String get authEnterYourPassword => 'Saisissez votre mot de passe';

  @override
  String get authPleaseEnterPassword => 'Veuillez saisir votre mot de passe';

  @override
  String get authPasswordMinLength =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get authKeepMeSignedIn => 'Rester connecté';

  @override
  String get authForgotPassword => 'Mot de passe oublié ?';

  @override
  String get authNoAccountPrompt => 'Pas encore de compte ?';

  @override
  String get authCreateOne => 'Créer un compte';

  @override
  String get authCreateYourAccount => 'Créez votre compte';

  @override
  String get authSignupSubtitle =>
      'Le même parcours d\'inscription sécurisé, désormais optimisé pour une configuration mobile plus rapide.';

  @override
  String get authFullName => 'Nom complet';

  @override
  String get authEnterFullName => 'Saisissez votre nom complet';

  @override
  String get authPleaseEnterName => 'Veuillez saisir votre nom';

  @override
  String get authHidePassword => 'Masquer le mot de passe';

  @override
  String get authShowPassword => 'Afficher le mot de passe';

  @override
  String get authConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get authConfirmYourPassword => 'Confirmez votre mot de passe';

  @override
  String get authPleaseConfirmPassword =>
      'Veuillez confirmer votre mot de passe';

  @override
  String get authPasswordsDoNotMatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get authCreateAccountButton => 'Créer un compte';

  @override
  String get authAlreadyHaveAccount => 'Déjà un compte ? Se connecter';

  @override
  String get authBusinessSetup => 'Configuration de l\'entreprise';

  @override
  String get authAuthenticator => 'Authentificateur';

  @override
  String get authAddAccount => 'Ajouter un compte';

  @override
  String get authSomethingWentWrong => 'Une erreur est survenue';

  @override
  String get authUnexpectedErrorTryAgain =>
      'Une erreur inattendue est survenue. Veuillez réessayer.';

  @override
  String get authTryAgain => 'Réessayer';

  @override
  String get authNoAccountsAdded => 'Aucun compte ajouté';

  @override
  String get authAddFirstAccountHint =>
      'Ajoutez votre premier compte pour générer des codes de vérification';

  @override
  String get authCodeCopied => 'Code copié dans le presse-papiers';

  @override
  String get authInvalidQrCode => 'Code QR invalide';

  @override
  String get authAccountAdded => 'Compte ajouté avec succès';

  @override
  String authFailedToAddAccount(String error) {
    return 'Échec de l\'ajout du compte : $error';
  }

  @override
  String get personalReadyForAdventure => 'Prêt pour l\'aventure ?';

  @override
  String personalDayStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours d\'affilée !',
      one: '1 jour d\'affilée !',
    );
    return '$_temp0';
  }

  @override
  String get personalTodaysProgress => 'Progrès du jour';

  @override
  String personalCompletedOf(String done, String total) {
    return '$done/$total terminés';
  }

  @override
  String get personalXpProgress => 'Progression XP';

  @override
  String personalXpToday(String xp) {
    return '+$xp XP aujourd\'hui';
  }

  @override
  String get personalFindChallenges => 'Trouver des défis';

  @override
  String get personalViewRewards => 'Voir les récompenses';

  @override
  String get personalLeaderboard => 'Classement';

  @override
  String get personalRecentAchievements => 'Succès récents';

  @override
  String get personalOpeningAchievements => 'Ouverture de tous les succès !';

  @override
  String get personalViewAll => 'Tout voir';

  @override
  String get personalAchievementFirstSteps => 'Premiers pas';

  @override
  String get personalAchievementExplorer => 'Explorateur';

  @override
  String get personalAchievementStreakMaster => 'Maître des séries';

  @override
  String get personalAchievementSocialStar => 'Star sociale';

  @override
  String get personalHowToLevelUp => 'Comment monter de niveau';

  @override
  String get personalDiscoverQuests => 'Découvrez des quêtes cachées';

  @override
  String get personalDiscoverQuestsBody =>
      'Visitez des commerces locaux pour débloquer des défis secrets et gagner des XP bonus !';

  @override
  String get personalDailyChallenges => 'Relevez les défis quotidiens';

  @override
  String get personalDailyChallengesBody =>
      'Gardez votre série et grimpez dans le classement avec vos amis !';

  @override
  String get personalTeamUp => 'Faites équipe avec vos amis';

  @override
  String get personalTeamUpBody =>
      'Unissez vos forces pour des défis de groupe et gagnez des bonus multiplicateurs !';

  @override
  String get personalAdventureBegins => 'Que l\'aventure commence ! 🚀';

  @override
  String get personalStartAdventure => 'Commencez votre aventure !';

  @override
  String get personalSyncingAdventures =>
      'Synchronisation avec les aventures à proximité...';

  @override
  String get personalLoggingOut => 'Déconnexion...';

  @override
  String get personalLoggedOut => 'Déconnexion réussie !';

  @override
  String personalLogoutFailed(String error) {
    return 'Échec de la déconnexion : $error';
  }

  @override
  String get personalCouldNotDetermineLocation =>
      'Impossible de déterminer votre position.';

  @override
  String get personalBusinessIdNotFound =>
      'Identifiant d\'entreprise introuvable. Veuillez vous reconnecter.';

  @override
  String get personalFailedToFetchChallenges =>
      'Impossible de récupérer les défis';

  @override
  String get personalFailedToFetchChallengesRetry =>
      'Impossible de récupérer les défis. Veuillez réessayer.';

  @override
  String get personalYourRewards => 'Vos récompenses';

  @override
  String get personalRewardFreeCoffee => 'Café offert';

  @override
  String get personalRewardFreeCoffeeBody =>
      'Obtenez un café offert dans nos cafés partenaires.';

  @override
  String get personalRewardDiscount => '10 % de réduction';

  @override
  String get personalRewardDiscountBody =>
      'Profitez de 10 % de réduction sur votre prochain achat.';

  @override
  String get personalRewardEarlyAccess => 'Accès anticipé';

  @override
  String get personalRewardEarlyAccessBody =>
      'Accédez en avant-première aux nouvelles fonctionnalités.';

  @override
  String get personalChallengeDiscovered => 'Défi découvert !';

  @override
  String get personalRewardAvailable => 'Récompense disponible !';

  @override
  String get personalLater => 'Plus tard';

  @override
  String get personalClaimReward => 'Réclamer la récompense';

  @override
  String get personalFailedToClaimReward =>
      'Impossible de réclamer la récompense. Veuillez réessayer.';

  @override
  String get personalRewardClaimed => 'Récompense réclamée avec succès !';

  @override
  String personalErrorLoadingRewards(String error) {
    return 'Erreur de chargement des récompenses : $error';
  }

  @override
  String get personalChallengeClaimed => 'Défi réclamé';

  @override
  String personalClaimedOn(String date) {
    return 'Réclamé le $date';
  }

  @override
  String personalBusinessLabel(String business) {
    return 'Entreprise : $business';
  }

  @override
  String personalRewardLabel(String reward) {
    return 'Récompense : $reward';
  }

  @override
  String get personalSpecialReward => 'Récompense spéciale';

  @override
  String get personalClaim => 'Réclamer';

  @override
  String get personalNoChallengesNearby =>
      'Aucun défi à proximité. Essayez de vous déplacer !';

  @override
  String get personalTapToDiscover =>
      'Touchez pour découvrir des défis à proximité';

  @override
  String get personalTapToSearchAgain => 'Touchez pour relancer la recherche';

  @override
  String get personalSearchingChallenges => 'Recherche de défis à proximité...';

  @override
  String get personalChallengesFound => 'Défis trouvés !';

  @override
  String personalNearbyRewards(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count récompenses à proximité',
      one: '1 récompense à proximité',
    );
    return '$_temp0';
  }

  @override
  String get personalChallengeClaimedToast => 'Défi réclamé avec succès ! 🎉';

  @override
  String personalFailedToClaimChallenge(String error) {
    return 'Impossible de réclamer le défi : $error';
  }

  @override
  String get manualPurchaseSellPrice => 'Prix de vente';

  @override
  String get cashbookSelectDates => 'Choisir les dates';

  @override
  String get cashbookSaveCashIn => 'Enregistrer l\'entrée';

  @override
  String get cashbookSaveCashOut => 'Enregistrer la sortie';

  @override
  String get cashbookNewEntry => 'Nouveau';

  @override
  String get cashbookEnterValidAmount => 'Veuillez saisir un montant valide';

  @override
  String get cashbookToday => 'Aujourd\'hui';

  @override
  String get cashbookYesterday => 'Hier';

  @override
  String get cashbookListNoMovements =>
      'Aucun mouvement de caisse pour l\'instant';

  @override
  String cashbookListNoFilterEntries(String filter) {
    return 'Aucune écriture « $filter »';
  }

  @override
  String get cashbookListEmptyHint =>
      'Enregistrez les entrées ou sorties d\'argent avec les boutons ci-dessous.';

  @override
  String cashbookListNothingMatches(String period) {
    return 'Rien ne correspond à ce filtre pour $period.';
  }

  @override
  String get cashbookViewAll => 'Tout voir';

  @override
  String get cashbookMoneyInLabel => 'Entrées';

  @override
  String get cashbookMoneyOutLabel => 'Sorties';

  @override
  String get manualPurchaseSellingPriceOptional => 'Prix de vente (facultatif)';

  @override
  String get txDetailCategory => 'Catégorie';

  @override
  String get txDetailNote => 'Note';

  @override
  String get manualPurchaseSellAtCostHelper =>
      'Laisser vide pour vendre au prix coûtant';

  @override
  String get scannerAlignQrCode => 'Alignez le code QR dans le cadre';

  @override
  String get scannerInstructionSelling =>
      'Scannez le code-barres du produit pour l\'ajouter au panier';

  @override
  String get scannerInstructionAttendance =>
      'Scannez le code QR de présence pour pointer';

  @override
  String get scannerInstructionLogin =>
      'Scannez le code QR pour vous connecter à votre compte';

  @override
  String get scannerScanning => 'Analyse en cours...';

  @override
  String get scannerStatusProcessing => 'Traitement';

  @override
  String get scannerSendingLoginToDesktop =>
      'Envoi de la connexion à l\'ordinateur...';

  @override
  String get scannerWaitingForDesktop => 'En attente de l\'ordinateur';

  @override
  String get scannerLoginSentCompleting =>
      'Connexion envoyée — finalisation sur votre ordinateur...';

  @override
  String get scannerScanSuccessful => 'Scan réussi';

  @override
  String get scannerQrProcessedSuccessfully => 'Code QR traité avec succès';

  @override
  String get scannerLoginSuccessful => 'Connexion réussie';

  @override
  String get scannerDesktopAuthenticated => 'Ordinateur authentifié';

  @override
  String get scannerLoginFailed => 'Échec de la connexion';

  @override
  String get scannerCouldNotAuthenticateDesktop =>
      'Impossible d\'authentifier l\'ordinateur';

  @override
  String get scannerQrCodeDetected => 'Code QR détecté';

  @override
  String get scannerProcessingRequest => 'Traitement de votre demande...';

  @override
  String get scannerHelpTitle => 'Aide du scanner';

  @override
  String get scannerHelpPositionCode => 'Placez le code dans le cadre';

  @override
  String get scannerHelpWellLit =>
      'Assurez-vous qu\'il est bien éclairé et net';

  @override
  String get scannerHelpUseFlash => 'Utilisez le flash en faible luminosité';

  @override
  String get scannerHelpToggleFlash => 'Activez l\'icône du flash en bas';

  @override
  String get scannerHelpCleanLens => 'Nettoyez l\'objectif de votre caméra';

  @override
  String get scannerHelpBetterResults => 'Pour de meilleurs résultats de scan';

  @override
  String get scannerTitleProduct => 'Scanner de produits';

  @override
  String get scannerTitleAttendance => 'Scanner de présence';

  @override
  String get scannerTitleLogin => 'Scanner de connexion';

  @override
  String get scannerTitleQr => 'Scanner QR';

  @override
  String get scannerGalleryComingSoon =>
      'La sélection depuis la galerie arrive bientôt';

  @override
  String get scannerInvalidQrFormat => 'Format de code QR invalide';

  @override
  String scannerLoginError(String error) {
    return 'Erreur de connexion : $error';
  }

  @override
  String get scannerDesktopNoResponse =>
      'L\'ordinateur n\'a pas répondu — vérifiez qu\'il affiche l\'écran de connexion QR';

  @override
  String get scannerDesktopSelectBusiness =>
      'Ordinateur connecté — sélectionnez votre entreprise dessus';

  @override
  String get scannerDesktopLoginSuccessful =>
      'Connexion de l\'ordinateur réussie';

  @override
  String get scannerDesktopLoginFailed =>
      'Échec de la connexion de l\'ordinateur';

  @override
  String get dialogGotIt => 'Compris';

  @override
  String get socialsRequestEarlyAccess => 'Demander un accès anticipé';

  @override
  String get socialsEarlyAccessHint =>
      'Saisissez votre e-mail, votre numéro de téléphone et un message expliquant pourquoi vous voulez nous rejoindre !';

  @override
  String get socialsPleaseEnterMessage => 'Veuillez saisir un message';

  @override
  String get socialsThanksForInterest => 'Merci de votre intérêt';

  @override
  String get socialsThanksWeWillGetBack =>
      'Merci de votre intérêt, nous vous recontacterons bientôt';

  @override
  String get socialsExpressInterest => 'Manifester son intérêt';

  @override
  String get appInitStepFirebase => 'Connexion aux services';

  @override
  String get appInitStepLocator => 'Préparation de l\'application';

  @override
  String get appInitStepPlatform => 'Configuration de l\'appareil';

  @override
  String get appInitStepDiagnostics => 'Configuration des diagnostics';

  @override
  String get appInitStepDatabase => 'Ouverture de la base de données locale';

  @override
  String get appInitStepServices => 'Chargement des services';

  @override
  String get appInitStepAnalytics => 'Démarrage des statistiques';

  @override
  String get appInitStepCloudStorage => 'Connexion au stockage cloud';

  @override
  String get appInitStepSync => 'Préparation de la synchronisation';

  @override
  String get appInitStepFinishing => 'Finalisation';

  @override
  String get appInitStepStartup => 'Démarrage';

  @override
  String get appInitFailedTitle => 'Échec du démarrage';

  @override
  String appInitFailedMessage(String step) {
    return 'L\'application n\'a pas pu terminer son démarrage à l\'étape « $step ». Touchez Réessayer — elle reprendra à partir de cette étape.';
  }

  @override
  String get appInitTryAgain => 'Réessayer';

  @override
  String get appInitCopyErrorDetails => 'Copier les détails de l\'erreur';

  @override
  String get appInitTechnicalDetails => 'Détails techniques';

  @override
  String get paywallRailMobileMoney => 'Mobile Money';

  @override
  String get paywallRailCard => 'Carte';

  @override
  String get paywallRailMomoDescription =>
      'Validez sur votre téléphone avec MTN MoMo';

  @override
  String get paywallRailCardDescription => 'Payez par Visa ou Mastercard';

  @override
  String get paywallCadenceDaily => 'Quotidien';

  @override
  String get paywallCadenceMonthly => 'Mensuel';

  @override
  String get paywallCadenceYearly => 'Annuel';

  @override
  String get paywallPeriodDay => '/jour';

  @override
  String get paywallPeriodMonth => '/mois';

  @override
  String get paywallPeriodYear => '/an';

  @override
  String paywallPaidInFull(String amount) {
    return 'Payé en une fois — un seul prélèvement de RWF $amount.';
  }

  @override
  String paywallInstallmentsEach(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paiements de RWF $amount chacun.',
      one: '1 paiement de RWF $amount.',
    );
    return '$_temp0';
  }

  @override
  String paywallPricePerMonthBilledYearly(String amount) {
    return '$amount RWF/mois · facturé annuellement';
  }

  @override
  String paywallPricePerDay(String amount) {
    return '$amount RWF/jour';
  }

  @override
  String paywallPricePerMonth(String amount) {
    return '$amount RWF/mois';
  }

  @override
  String get paywallCardPayment => 'Paiement par carte';

  @override
  String get paywallTestMode => 'MODE TEST';

  @override
  String get paywallCardRedirectInfo =>
      'Vous serez redirigé vers une page de paiement sécurisée pour saisir les informations de votre carte Visa ou Mastercard. Revenez ici une fois terminé — l\'abonnement s\'active automatiquement.';

  @override
  String get paywallReceiptEmail => 'E-mail pour le reçu';

  @override
  String get paywallReceiptEmailHint =>
      'Les factures et reçus de carte sont envoyés ici.';

  @override
  String get paywallCardDiscountApplies =>
      'Votre réduction s\'applique aux paiements par carte : la carte est débitée du prix réduit maintenant et à chaque renouvellement.';

  @override
  String paywallCardDiscountAppliesAmount(String amount) {
    return 'Votre réduction s\'applique : la carte est débitée de $amount maintenant et à chaque renouvellement.';
  }

  @override
  String get paywallDiscountMomoOnly =>
      'Les codes de réduction s\'appliquent uniquement aux paiements Mobile Money. Le paiement par carte débite le prix complet.';

  @override
  String get paywallPendingCheckout =>
      'Une page de paiement attend déjà pour cet abonnement. Ouvrez-la pour terminer — une nouvelle ne la remplacerait pas.';

  @override
  String get paywallOpenPaymentPage => 'Ouvrir la page de paiement';

  @override
  String get paywallDiscountHint =>
      'Saisissez le code exactement tel qu\'il apparaît.';

  @override
  String get paywallNeedHelp => 'Besoin d\'aide ?';

  @override
  String get paywallChatWithSupport =>
      'Discutez avec le support à propos de ce paiement';

  @override
  String get paywallMomoPayment => 'Paiement Mobile Money';

  @override
  String paywallProcessedUsing(String provider) {
    return 'Le paiement sera traité via $provider.';
  }

  @override
  String get paywallUseDifferentNumber => 'Utiliser un autre numéro';

  @override
  String get paywallTryAnotherNumber =>
      'Essayez un autre numéro MTN si celui-ci a échoué';

  @override
  String get paywallMomoNumberRule => 'Doit commencer par 250 78 ou 250 79.';

  @override
  String get paywallProcessing => 'Traitement…';

  @override
  String paywallSecurePaymentVia(String provider) {
    return 'Paiement sécurisé via $provider';
  }

  @override
  String get paywallHowToPay => 'Comment souhaitez-vous payer ?';

  @override
  String get paywallLoading => 'Chargement…';

  @override
  String paywallPercentOff(String percent) {
    return '(-$percent %)';
  }

  @override
  String get paywallSplitIntoPayments => 'Payer en plusieurs fois';

  @override
  String get paywallPaymentSummary => 'Récapitulatif du paiement';

  @override
  String get paywallTotal => 'Total';

  @override
  String get paywallSubscriptionEnded =>
      'Cet abonnement est terminé. Choisissez un forfait pour recommencer.';

  @override
  String get paywallPaymentPageNotReady =>
      'La page de paiement n\'est pas encore prête. Réessayez dans un instant.';

  @override
  String get paywallCouldNotOpenPageCopyLink =>
      'Impossible d\'ouvrir la page de paiement sur cet appareil. Copiez le lien ou payez plutôt par Mobile Money.';

  @override
  String get paywallCouldNotOpenPage =>
      'Impossible d\'ouvrir la page de paiement sur cet appareil.';

  @override
  String get paywallServiceNoResponse =>
      'Le service de paiement n\'a pas répondu. Vérifiez votre connexion et réessayez.';

  @override
  String get paywallServiceUnreachable =>
      'Impossible de joindre le service de paiement. Vérifiez votre connexion et réessayez.';

  @override
  String get paywallBusinessRequiredForCard =>
      'Une entreprise est requise pour démarrer un abonnement par carte.';

  @override
  String get paywallCardStartedNoReference =>
      'L\'abonnement par carte a démarré mais aucune référence n\'a été reçue. Vérifiez l\'écran de facturation avant de réessayer.';

  @override
  String get paywallNoCardUpdateLink =>
      'Aucun lien de mise à jour de la carte n\'a été reçu.';

  @override
  String get paywallNoPortalLink =>
      'Aucun lien vers le portail de facturation n\'a été reçu.';

  @override
  String get paywallCardNotAuthorised =>
      'Le paiement par carte n\'est pas autorisé sur ce service.';

  @override
  String get paywallCardUnavailable =>
      'Le paiement par carte n\'est pas disponible pour le moment. Utilisez Mobile Money ou réessayez plus tard.';

  @override
  String paywallCouldNotAction(String action, String status) {
    return 'Impossible de $action (HTTP $status).';
  }

  @override
  String paywallUnreadableReply(String status) {
    return 'Le service de facturation a envoyé une réponse illisible (HTTP $status).';
  }

  @override
  String get paywallActionStartCardSubscription =>
      'démarrer un abonnement par carte';

  @override
  String get paywallActionReadCardSubscription =>
      'lire l\'abonnement par carte';

  @override
  String get paywallActionRefreshCardSubscription =>
      'actualiser l\'abonnement par carte';

  @override
  String get paywallActionGetCardLink => 'obtenir un nouveau lien de carte';

  @override
  String get paywallActionOpenBillingPortal =>
      'ouvrir le portail de facturation';

  @override
  String get paywallActionCancelCardSubscription =>
      'annuler l\'abonnement par carte';

  @override
  String get paywallActionStartCustomPayment =>
      'démarrer le paiement personnalisé';

  @override
  String get paywallActionReadCustomPayment => 'lire le paiement personnalisé';

  @override
  String get paywallActionListCustomPayments =>
      'lister les paiements personnalisés';

  @override
  String get paywallEnterAmountAboveZero =>
      'Saisissez un montant supérieur à zéro.';

  @override
  String get paywallEnterValidMomoNumber =>
      'Saisissez un numéro Mobile Money valide, p. ex. 0788123456.';

  @override
  String paywallPaymentNotStarted(String status) {
    return 'Le paiement n\'a pas pu démarrer (HTTP $status).';
  }

  @override
  String paywallGatewayUnreadable(String status) {
    return 'La passerelle de paiement a envoyé une réponse illisible (HTTP $status).';
  }

  @override
  String get paywallStartedNoReference =>
      'Le paiement a démarré mais aucune référence n\'a été reçue — vérifiez le relevé MoMo avant de réessayer.';

  @override
  String paywallPreApprovalFailed(String status) {
    return 'La pré-autorisation a échoué (HTTP $status).';
  }

  @override
  String get paywallRequestRejected => 'La demande de paiement a été refusée.';

  @override
  String get paywallDeviceNotAuthorised =>
      'Cet appareil n\'est pas autorisé à encaisser des paiements.';

  @override
  String get paywallServiceNotFound =>
      'Le service de paiement est introuvable.';

  @override
  String get paywallAlreadySubmitted => 'Ce paiement a déjà été soumis.';

  @override
  String get paywallMomoUnavailableNow =>
      'Mobile Money est indisponible pour le moment. Veuillez réessayer sous peu.';

  @override
  String get paywallMomoNotSetUp =>
      'Mobile Money n\'est pas encore configuré sur cet appareil.';

  @override
  String get paywallNotCompletedOnPhone =>
      'Le paiement n\'a pas été finalisé sur le téléphone du payeur.';

  @override
  String get paywallNoConfirmationYet =>
      'Pas encore de confirmation. Le paiement peut encore aboutir — vérifiez le relevé MoMo avant de débiter à nouveau.';

  @override
  String get paywallConsentDeclined =>
      'L\'autorisation Mobile Money a été refusée, rien n\'a donc été débité. Validez la demande sur votre téléphone et réessayez.';

  @override
  String get paywallChooseBusinessFirst =>
      'Choisissez d\'abord une entreprise.';

  @override
  String get paywallAmountAboveZero => 'Le montant doit être supérieur à zéro.';

  @override
  String get paywallCustomerMomoRequired =>
      'Le numéro Mobile Money du client est requis.';

  @override
  String get paywallStaffNotAuthorised =>
      'Ce compte n\'est pas autorisé pour les paiements du personnel.';

  @override
  String get paywallAlreadyCollecting =>
      'Un encaissement est déjà en cours pour cette entreprise.';

  @override
  String get paywallStaffNotConfigured =>
      'Les paiements du personnel ne sont pas configurés sur ce service.';

  @override
  String accountingShiftUser(String id) {
    return 'Utilisateur : $id';
  }

  @override
  String get accountingShiftHistory => 'Historique des postes';

  @override
  String get accountingLoadingShiftHistory =>
      'Chargement de l\'historique des postes...';

  @override
  String get accountingNoMatchingShifts => 'Aucun poste correspondant';

  @override
  String get accountingNoShiftsFound => 'Aucun poste trouvé';

  @override
  String get accountingAdjustFiltersHint =>
      'Essayez de modifier vos filtres ou votre recherche.';

  @override
  String get accountingNoShiftsHint =>
      'Les postes apparaîtront ici dès que vous\ncommencerez à les gérer.';

  @override
  String get accountingClearFilters => 'Effacer les filtres';

  @override
  String accountingCashSalesRange(String currency) {
    return 'PLAGE DES VENTES EN ESPÈCES ($currency)';
  }

  @override
  String get accountingFilterShifts => 'Filtrer les postes';

  @override
  String get accountingDateRange => 'PÉRIODE';

  @override
  String get accountingFrom => 'Du';

  @override
  String get accountingTo => 'Au';

  @override
  String get accountingStatusLabel => 'STATUT';

  @override
  String get accountingAllShifts => 'Tous les postes';

  @override
  String get accountingShiftOpen => 'Ouvert';

  @override
  String get accountingShiftClosed => 'Fermé';

  @override
  String get accountingMinimum => 'Minimum';

  @override
  String get accountingMaximum => 'Maximum';

  @override
  String get accountingNoLimit => 'Sans limite';

  @override
  String get accountingSortBy => 'TRIER PAR';

  @override
  String get accountingNewestFirst => 'Plus récents d\'abord';

  @override
  String get accountingOldestFirst => 'Plus anciens d\'abord';

  @override
  String get accountingCashSalesHighToLow => 'Ventes en espèces — décroissant';

  @override
  String get accountingCashSalesLowToHigh => 'Ventes en espèces — croissant';

  @override
  String get accountingClearAll => 'Tout effacer';

  @override
  String get accountingApplyFilters => 'Appliquer les filtres';

  @override
  String get accountingDatePlaceholder => 'mm/jj/aaaa';

  @override
  String get accountingTotalShifts => 'TOTAL DES POSTES';

  @override
  String get accountingTotalCashSales => 'TOTAL DES VENTES EN ESPÈCES';

  @override
  String get accountingOpenClosed => 'OUVERTS / FERMÉS';

  @override
  String get accountingSearchShiftsHint =>
      'Rechercher par ID utilisateur ou date...';

  @override
  String accountingShowingShifts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count postes affichés',
      one: '1 poste affiché',
    );
    return '$_temp0';
  }

  @override
  String accountingStartedAt(String time) {
    return 'Commencé le $time';
  }

  @override
  String accountingCashDifference(String amount) {
    return 'Écart de caisse : $amount';
  }

  @override
  String get accountingTimePeriod => 'PÉRIODE';

  @override
  String get accountingStartTime => 'Heure de début';

  @override
  String get accountingEndTime => 'Heure de fin';

  @override
  String accountingDuration(String duration) {
    return 'Durée : $duration';
  }

  @override
  String get accountingInProgress => 'En cours';

  @override
  String get accountingFinancialSummary => 'RÉSUMÉ FINANCIER';

  @override
  String get accountingOpeningBalance => 'Solde d\'ouverture';

  @override
  String get accountingCashSales => 'Ventes en espèces';

  @override
  String get accountingExpectedCash => 'Espèces attendues';

  @override
  String get accountingClosingBalance => 'Solde de clôture';

  @override
  String get uiAdminPinMismatch => 'Les PIN ne correspondent pas. Réessayez.';

  @override
  String uiAdminPinIncorrect(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'PIN incorrect. $count essais restants.',
      one: 'PIN incorrect. 1 essai restant.',
    );
    return '$_temp0';
  }

  @override
  String get uiAdminPinSaveFailed =>
      'Impossible d\'enregistrer le PIN. Veuillez réessayer.';

  @override
  String get uiAdminPinSaved => 'PIN enregistré';

  @override
  String get uiAdminPinEnter => 'Saisissez le PIN administrateur';

  @override
  String get uiAdminPinConfirm => 'Confirmez votre PIN';

  @override
  String get uiAdminPinSetUp => 'Configurer le PIN administrateur';

  @override
  String get uiAdminPinSavedSubtitle =>
      'Les actions sensibles exigent désormais ce PIN.';

  @override
  String get uiAdminPinVerifySubtitle =>
      'Cette action est protégée. Saisissez votre PIN administrateur à 4 chiffres.';

  @override
  String get uiAdminPinConfirmSubtitle =>
      'Saisissez à nouveau les mêmes 4 chiffres pour confirmer.';

  @override
  String get uiAdminPinSetSubtitle =>
      'Choisissez un PIN à 4 chiffres pour protéger les modifications, suppressions et paramètres.';

  @override
  String uiAdminPinDigitsSemantic(String entered, String total) {
    return 'PIN, $entered chiffres saisis sur $total';
  }

  @override
  String uiAdminPinLockout(String seconds) {
    return 'Trop de tentatives. Réessayez dans $seconds s.';
  }

  @override
  String get uiAdminPinStartOver => 'Recommencer';

  @override
  String get uiMonthShortJan => 'janv.';

  @override
  String get uiMonthShortFeb => 'févr.';

  @override
  String get uiMonthShortMar => 'mars';

  @override
  String get uiMonthShortApr => 'avr.';

  @override
  String get uiMonthShortMay => 'mai';

  @override
  String get uiMonthShortJun => 'juin';

  @override
  String get uiMonthShortJul => 'juil.';

  @override
  String get uiMonthShortAug => 'août';

  @override
  String get uiMonthShortSep => 'sept.';

  @override
  String get uiMonthShortOct => 'oct.';

  @override
  String get uiMonthShortNov => 'nov.';

  @override
  String get uiMonthShortDec => 'déc.';

  @override
  String get uiTicketResumeOrder => 'Reprendre la commande';

  @override
  String get uiTicketResuming => 'Reprise…';

  @override
  String get uiTicketCustomerSection => 'CLIENT';

  @override
  String uiTicketItemsSection(String count) {
    return 'ARTICLES · $count';
  }

  @override
  String uiTicketCouldNotLoadItems(String error) {
    return 'Impossible de charger les articles : $error';
  }

  @override
  String get uiTicketStatusSection => 'STATUT';

  @override
  String get uiTicketResumeTicket => 'Reprendre le ticket';

  @override
  String get uiTicketWalkIn => 'Client de passage';

  @override
  String get uiTicketLoan => 'Crédit';

  @override
  String get uiTicketNoItems => 'Aucun article sur ce ticket.';

  @override
  String uiTicketPaymentsSection(String count) {
    return 'PAIEMENTS · $count';
  }

  @override
  String get uiTicketTotalPaidSoFar => 'Total payé jusqu\'ici';

  @override
  String get uiTicketStillDue => 'Reste dû';

  @override
  String get uiTicketUnknown => 'Inconnu';

  @override
  String uiTicketPaymentLine(String index, String method) {
    return 'Paiement $index · $method';
  }

  @override
  String uiTicketPaidBy(String name) {
    return 'Payé par $name';
  }

  @override
  String get uiTicketStatusWaiting => 'En attente';

  @override
  String get uiTicketStatusInProgress => 'En cours';

  @override
  String get uiTicketStatusCompleted => 'Terminé';

  @override
  String get uiTicketBadgeInProgress => 'EN COURS';

  @override
  String get uiTicketBadgeCompleted => 'TERMINÉ';

  @override
  String get uiTicketBadgeParked => 'EN ATTENTE';

  @override
  String get uiTicketDateNotRecorded => 'Date non enregistrée';

  @override
  String uiTicketTodayAt(String time) {
    return 'Aujourd\'hui · $time';
  }

  @override
  String uiTicketYesterdayAt(String time) {
    return 'Hier · $time';
  }

  @override
  String get uiTicketParkTransaction => 'Mettre la vente en attente';

  @override
  String get uiTicketParking => 'Mise en attente…';

  @override
  String uiTicketParkFailed(String error) {
    return 'Impossible de mettre la vente en attente : $error';
  }

  @override
  String get uiTicketAttachCustomer => 'Associer un client';

  @override
  String get uiTicketSearchCustomers => 'Rechercher des clients…';

  @override
  String get uiTicketNoCustomer => 'Aucun client';

  @override
  String get uiTicketName => 'Nom du ticket';

  @override
  String get uiTicketEnterName => 'Saisissez un nom de ticket';

  @override
  String get uiTicketNotes => 'Notes';

  @override
  String get uiTicketOptional => 'Facultatif';

  @override
  String get uiTicketAddNotes => 'Ajouter des notes';

  @override
  String get uiTicketPaymentDue => 'Échéance de paiement';

  @override
  String get uiTicketSendToKitchen => 'Envoyer en cuisine';

  @override
  String get uiTicketShowOnKds => 'Afficher ce ticket sur l\'écran de cuisine';

  @override
  String get uiTicketSelectCustomer => 'Sélectionner un client';

  @override
  String get uiTicketMarkAsLoan => 'Marquer comme crédit';

  @override
  String get uiTicketTrackPaymentLater =>
      'Suivre le paiement pour un encaissement ultérieur';

  @override
  String get uiTicketOneWeek => '1 semaine';

  @override
  String get uiTicketTwoWeeks => '2 semaines';

  @override
  String get uiTicketOneMonth => '1 mois';

  @override
  String get uiTicketSelectDate => 'Choisir une date';

  @override
  String get uiTicketDueDate => 'Date d\'échéance';

  @override
  String get uiTicketHoldSale =>
      'Mettre cette vente de côté pour la terminer plus tard';

  @override
  String get uiWorkOrderUnknownProduct => 'Produit inconnu';

  @override
  String uiWorkOrderId(String id) {
    return 'ID : $id';
  }

  @override
  String get uiWorkOrderStart => 'Démarrer';

  @override
  String get uiWorkOrderRecordOutput => 'Enregistrer la production';

  @override
  String get uiWorkOrderCompleted => 'Terminé';

  @override
  String get uiWorkOrderInProgress => 'En cours';

  @override
  String get uiWorkOrderPlanned => 'Planifié';

  @override
  String get uiWorkOrderActual => 'Réel';

  @override
  String get uiWorkOrderVariance => 'Écart';

  @override
  String get uiWorkOrderEfficiency => 'Efficacité';

  @override
  String get uiWorkOrderTargetDate => 'Date cible';

  @override
  String get uiWorkOrderShift => 'Poste';

  @override
  String get uiWorkOrderNotApplicable => 'N/D';

  @override
  String get uiWorkOrderNotes => 'Notes';

  @override
  String get uiWorkOrderTimeline => 'Chronologie';

  @override
  String get uiWorkOrderCreated => 'Créé';

  @override
  String get uiWorkOrderStarted => 'Démarré';

  @override
  String get uiProduceItems => 'Articles';

  @override
  String get uiProduceSelectItem => 'Choisir l\'article à produire';

  @override
  String get uiProduceDescription =>
      'Choisissez un article dans la liste ci-dessous pour lancer la production.';

  @override
  String uiProduceItemsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles restants',
      one: '1 article restant',
    );
    return '$_temp0';
  }

  @override
  String uiProduceAssignedCount(String count) {
    return '$count attribués';
  }

  @override
  String uiProduceQty(String qty) {
    return 'Qté : $qty';
  }

  @override
  String get uiProduceAssigned => 'Attribué';

  @override
  String get uiProduceInProgress => 'En cours';

  @override
  String get uiProduceBackToList => 'Retour à la liste';

  @override
  String get uiProduceDetails => 'Détails de la production';

  @override
  String get uiPaymentModeSelect => 'Choisir le mode de paiement';

  @override
  String get uiPaymentModeFailed => 'Échec du paiement';

  @override
  String get uiPaymentModePleaseSelect =>
      'Veuillez choisir un mode de paiement';

  @override
  String get uiPaymentModeSelectFinancing =>
      'Choisir une option de financement';

  @override
  String uiPaymentModeInterest(String rate) {
    return 'Intérêt : $rate %';
  }

  @override
  String get uiBackupDescription =>
      'Activer la sauvegarde enregistre vos données chaque jour : plus besoin de craindre de les perdre.';

  @override
  String get uiTicketNoName => 'Sans nom';

  @override
  String get uiTicketResume => 'Reprendre';

  @override
  String get uiNoteRequired => 'La note est obligatoire';

  @override
  String uiNotificationSemantic(String message) {
    return 'Notification : $message';
  }

  @override
  String uiDeleteConfirmSemantic(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Confirmation de suppression pour $count articles',
      one: 'Confirmation de suppression pour 1 article',
    );
    return '$_temp0';
  }

  @override
  String uiDeleteItemsQuestion(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Supprimer $count articles ?',
      one: 'Supprimer 1 article ?',
    );
    return '$_temp0';
  }

  @override
  String uiMoreItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+ $count autres articles',
      one: '+ 1 autre article',
    );
    return '$_temp0';
  }

  @override
  String get uiRefreshStatusAfterPayment =>
      'Actualiser le statut après le paiement';

  @override
  String get uiSubscriptionActive => 'L\'abonnement est actif.';

  @override
  String get uiNoPlanOpeningSetup =>
      'Aucun abonnement trouvé — ouverture de la configuration du paiement.';

  @override
  String get uiPlanInactiveOpeningPayment =>
      'Abonnement trouvé mais inactif — ouverture de l\'écran de paiement.';

  @override
  String get uiCouldNotVerifyPayment =>
      'Impossible de vérifier le statut du paiement.';

  @override
  String get uiTimerDone => 'Terminé !';

  @override
  String get uiTimerDelivered => 'Livré !';

  @override
  String get uiTimerUntilDelivered => 'Avant la livraison';

  @override
  String uiTimerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String uiTimerHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count heures',
      one: '1 heure',
    );
    return '$_temp0';
  }

  @override
  String uiTimerMinutes(String count) {
    return '$count MIN';
  }

  @override
  String uiTimerSeconds(String count) {
    return '$count S';
  }

  @override
  String get uiEnterCouponCode => 'Saisir le code promo';

  @override
  String get uiShop => 'Boutique';

  @override
  String uiShopActiveSemantic(String name) {
    return '$name actif';
  }

  @override
  String uiShopInactiveSemantic(String name) {
    return '$name inactif';
  }

  @override
  String get uiSaveTicket => 'Enregistrer le ticket';

  @override
  String get floSuggestTodayTitle => 'Résumer la performance du jour';

  @override
  String get floSuggestTodayDesc =>
      'Chiffre d\'affaires, bénéfice et unités en un coup d\'œil';

  @override
  String get floSuggestTodayQuestion =>
      'Résume la performance de mon entreprise aujourd\'hui';

  @override
  String get floSuggestProfitTitle => 'Produits les plus rentables';

  @override
  String get floSuggestProfitDesc => 'Classés par marge cette semaine';

  @override
  String get floSuggestProfitQuestion =>
      'Quels produits sont les plus rentables cette semaine ?';

  @override
  String get floSuggestUsersTitle => 'Combien d\'utilisateurs dans MiniData ?';

  @override
  String get floSuggestUsersDesc => 'Totaux et activité récente';

  @override
  String get floSuggestUsersQuestion =>
      'Combien d\'utilisateurs avons-nous dans MiniData ?';

  @override
  String get floSuggestTrendTitle => 'Tendance des ventes de la semaine';

  @override
  String get floSuggestTrendDesc =>
      'Évolution du chiffre d\'affaires sur 7 jours';

  @override
  String get floSuggestTrendQuestion =>
      'Montre la tendance des ventes de cette semaine';

  @override
  String get floGoodMorning => 'Bonjour';

  @override
  String get floGoodAfternoon => 'Bon après-midi';

  @override
  String get floGoodEvening => 'Bonsoir';

  @override
  String floGreetingShop(String greeting, String shop) {
    return '$greeting, $shop.';
  }

  @override
  String floAskMeAnything(String anything) {
    return 'Demandez-moi $anything sur votre entreprise.';
  }

  @override
  String get floAnything => 'n\'importe quoi';

  @override
  String get floHomeIntro =>
      'Je lis vos données connectées en direct et réponds avec des chiffres, des graphiques et des prochaines étapes — en langage clair.';

  @override
  String get floTryAsking => 'Essayez de demander';

  @override
  String get floChannels => 'Canaux';

  @override
  String get floMiniDataDesc =>
      'Données Supabase en direct — ventes, utilisateurs, produits.';

  @override
  String get floManage => 'Gérer';

  @override
  String get floConnect => 'Connecter';

  @override
  String get floWhatsAppConnectedDesc =>
      'Vous pouvez discuter avec Flo sur WhatsApp.';

  @override
  String get floWhatsAppSetupDesc =>
      'Parlez à Flo depuis votre téléphone — configuration en une minute.';

  @override
  String get floLoadingBriefing => 'Chargement du point du jour…';

  @override
  String get floBriefingUnavailable => 'Point du jour indisponible';

  @override
  String get floReadingLiveSales =>
      'Lecture des ventes en direct depuis MiniData.';

  @override
  String get floCheckDataConnection =>
      'Vérifiez votre connexion aux données et réessayez.';

  @override
  String get floDailyBriefing => 'POINT DU JOUR';

  @override
  String floDateAuto(String date) {
    return '$date · auto';
  }

  @override
  String get floConnected => 'CONNECTÉ';

  @override
  String get floNotSetUp => 'NON CONFIGURÉ';

  @override
  String aiWhatsappReadInboxFailed(String error) {
    return 'Impossible de lire les messages WhatsApp\n$error';
  }

  @override
  String aiWhatsappSendFailed(String error) {
    return 'Échec de l\'envoi : $error';
  }

  @override
  String get aiWhatsappAnswerCustomers => 'Répondez à vos clients sur WhatsApp';

  @override
  String get aiWhatsappConnectPitch =>
      'Connectez votre compte Meta WhatsApp Business pour voir les messages clients ici et rédiger des réponses avec Flo.';

  @override
  String get aiWhatsappConnect => 'Connecter WhatsApp';

  @override
  String get aiWhatsappSelectCustomer => 'Sélectionnez un client';

  @override
  String get aiWhatsappInboxSource => 'Boîte WhatsApp · data-connector + Ditto';

  @override
  String get aiWhatsappCustomers => 'Clients · WhatsApp';

  @override
  String get floTimeNow => 'maintenant';

  @override
  String floTimeMinutesShort(String count) {
    return '$count min';
  }

  @override
  String floTimeDaysShort(String count) {
    return '$count j';
  }

  @override
  String get aiWhatsappNoMessages => 'Aucun message WhatsApp pour l\'instant';

  @override
  String get aiWhatsappNoMessagesHint =>
      'Les messages entrants sont chargés depuis data-connector (Ditto local sert de secours). Quand Meta les envoie au webhook, ils apparaissent ici en quelques secondes.';

  @override
  String get aiWhatsappNoThreadMessages =>
      'Aucun message dans cette conversation pour l\'instant';

  @override
  String get aiWhatsappPdfDownloadFailed => 'Impossible de télécharger ce PDF';

  @override
  String get aiWhatsappSavePdf => 'Enregistrer le PDF';

  @override
  String aiWhatsappSavedFile(String file) {
    return '$file enregistré';
  }

  @override
  String aiWhatsappDownloadFailed(String error) {
    return 'Échec du téléchargement : $error';
  }

  @override
  String get aiWhatsappPdfDocument => 'Document PDF';

  @override
  String get aiWhatsappFloSuggestedReply => 'Réponse suggérée par Flo';

  @override
  String get aiWhatsappSend => 'Envoyer';

  @override
  String get aiWhatsappEditFirst => 'Modifier d\'abord';

  @override
  String get aiWhatsappDraft => 'Brouillon';

  @override
  String get aiWhatsappReplyHint => 'Répondre sur WhatsApp…';

  @override
  String get floBusinessAi => 'IA d\'entreprise';

  @override
  String get floMiniDataConnectedLive => 'MiniData connecté · en direct';

  @override
  String get floNewChat => 'Nouvelle discussion';

  @override
  String get floAskFlo => 'Demander à Flo';

  @override
  String get floMessages => 'Messages';

  @override
  String get floNewConversation => 'Nouvelle conversation';

  @override
  String get floChatWithFloAndCustomers => 'Discutez avec Flo et vos clients';

  @override
  String get floOn => 'Activé';

  @override
  String get floOff => 'Désactivé';

  @override
  String get floManageDataSources => 'Gérer les sources de données';

  @override
  String get floQuickSummarizeToday => 'Résumer la journée';

  @override
  String get floQuickTopProducts => 'Meilleurs produits';

  @override
  String get floQuickUserCount => 'Nombre d\'utilisateurs';

  @override
  String get floQuickSalesTrend => 'Tendance des ventes';

  @override
  String get floComposerHint =>
      'Posez une question sur les ventes, le stock, les clients ou les taxes…';

  @override
  String get floStopDictating => 'Arrêter la dictée';

  @override
  String get floDictate => 'Dicter — parlez et Flo écrit';

  @override
  String get floCanMakeMistakes =>
      'Flo peut se tromper — vérifiez les chiffres importants. ';

  @override
  String get floGroundedInMiniData => 'Basé sur MiniData.';

  @override
  String get floStarting => 'Démarrage…';

  @override
  String get floListening => 'Écoute…';

  @override
  String get floModeCloud => 'Cloud';

  @override
  String get floModeOnDevice => 'Sur l\'appareil';

  @override
  String get floChooseAiMode => 'Choisir le mode IA';

  @override
  String get floOnDeviceSubtitle => 'Gratuit · hors ligne · privé';

  @override
  String get floCloudSubtitle => 'Plus performant · utilise la connexion';

  @override
  String get floThinkingUnderstanding => 'Compréhension de la question';

  @override
  String get floThinkingQuerying => 'Interrogation de MiniData';

  @override
  String get floThinkingComposing => 'Rédaction de la réponse';

  @override
  String get floCopied => 'Copié !';

  @override
  String get floCopyChart => 'Copier le graphique';

  @override
  String get floSuggestedFollowUps => 'QUESTIONS SUGGÉRÉES';

  @override
  String get aiDataSourceEdit => 'Modifier la source de données';

  @override
  String get aiDataSourceConnectTitle => 'Connecter une source de données';

  @override
  String get aiDataSourceType => 'Type de source de données';

  @override
  String get aiDataSourceConnectionName => 'Nom de la connexion';

  @override
  String get aiDataSourceConnectionNameHint => 'p. ex. Base de production';

  @override
  String get aiDataSourceSupabaseUrl => 'URL Supabase';

  @override
  String get aiDataSourceAnonKey => 'Clé anonyme/publique';

  @override
  String get aiDataSourceServiceKey => 'Clé de rôle de service (facultatif)';

  @override
  String get aiDataSourceServiceKeyHelper =>
      'Requis pour les opérations d\'administration';

  @override
  String get aiDataSourceTestFailedCredentials =>
      'Échec du test de connexion. Vérifiez vos identifiants.';

  @override
  String aiDataSourceTestFailed(String error) {
    return 'Échec du test de connexion : $error';
  }

  @override
  String get aiDataSourceTesting => 'Test en cours...';

  @override
  String get aiDataSourceTestConnection => 'Tester la connexion';

  @override
  String get aiDataSourcePrivacyNote =>
      'Une fois connectée, l\'assistant peut utiliser le schéma et des exemples de lignes de cette source dans vos discussions. Les identifiants sont stockés uniquement sur cet appareil.';

  @override
  String get aiDataSourceEnterName => 'Veuillez saisir un nom de connexion';

  @override
  String get aiDataSourceEnterUrl => 'Veuillez saisir l\'URL Supabase';

  @override
  String get aiDataSourceEnterKey =>
      'Veuillez saisir une clé anonyme/publique ou une clé de rôle de service';

  @override
  String get aiDataSourceUpdated => 'Source de données mise à jour';

  @override
  String get aiDataSourceConnected => 'Source de données connectée';

  @override
  String aiDataSourceConnectFailed(String error) {
    return 'Échec de la connexion : $error';
  }

  @override
  String get aiDataSourceConnecting => 'Connexion...';

  @override
  String get aiDataSourceUpdate => 'Mettre à jour';

  @override
  String get aiDataSourceConnect => 'Connecter';

  @override
  String get aiDataSourceStatusConnected => 'Connecté';

  @override
  String get aiDataSourceStatusConnecting => 'Connexion';

  @override
  String get aiDataSourceStatusError => 'Erreur';

  @override
  String get aiDataSourceStatusDisconnected => 'Déconnecté';

  @override
  String get aiDataSourceTitle => 'Source de données';

  @override
  String get aiDataSourceNotFound => 'Source de données introuvable';

  @override
  String get aiDataSourceGoBack => 'Retour';

  @override
  String get aiDataSourceTables => 'Tables';

  @override
  String get aiDataSourceUrl => 'URL';

  @override
  String get aiDataSourceNotAvailable => 'N/D';

  @override
  String aiDataSourceLastConnected(String time) {
    return 'Dernière connexion : $time';
  }

  @override
  String get aiDataSourceInformation => 'Informations';

  @override
  String aiDataSourceMetadataFailed(String error) {
    return 'Échec du chargement des métadonnées : $error';
  }

  @override
  String get aiDataSourceTotalRows => 'Total des lignes';

  @override
  String get aiDataSourceTypeLabel => 'Type';

  @override
  String get aiDataSourceUnknown => 'Inconnu';

  @override
  String aiDataSourceTablesFailed(String error) {
    return 'Échec du chargement des tables : $error';
  }

  @override
  String get aiDataSourceNoTables => 'Aucune table trouvée';

  @override
  String aiDataSourceColumnsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colonnes',
      one: '1 colonne',
    );
    return '$_temp0';
  }

  @override
  String aiDataSourceRowsCount(String count) {
    return '$count lignes';
  }

  @override
  String get aiDataSourceColumns => 'Colonnes';

  @override
  String get aiDataSourceNotNull => 'NON NUL';

  @override
  String get aiDataSourceJustNow => 'À l\'instant';

  @override
  String aiDataSourceMinutesAgo(String count) {
    return 'il y a $count min';
  }

  @override
  String aiDataSourceHoursAgo(String count) {
    return 'il y a $count h';
  }

  @override
  String get aiDataSourceCsvFile => 'Fichier CSV';

  @override
  String get aiDataSourceJsonFile => 'Fichier JSON';

  @override
  String get aiDataSources => 'Sources de données';

  @override
  String get aiDataSourceAdd => 'Ajouter une source de données';

  @override
  String get aiDataSourceNoneConnected => 'Aucune source de données connectée';

  @override
  String get aiDataSourceNoneHint =>
      'Connectez une base de données pour que l\'IA puisse inclure son schéma et des exemples de lignes\ndans ses réponses en discussion Entreprise ou Personnelle.';

  @override
  String get aiDataSourceConnectFirst =>
      'Connectez votre première source de données';

  @override
  String get aiDataSourceActive => 'Actif';

  @override
  String get aiDataSourceDisconnect => 'Déconnecter';

  @override
  String get aiDataSourceDeleteTitle => 'Supprimer la source de données';

  @override
  String aiDataSourceDeleteConfirm(String name) {
    return 'Voulez-vous vraiment supprimer « $name » ? La connexion et toutes les données associées seront supprimées.';
  }

  @override
  String aiDataSourceDeleted(String name) {
    return 'Source de données « $name » supprimée';
  }

  @override
  String get aiWhatsappPhoneIdEmpty =>
      'L\'ID du numéro de téléphone ne peut pas être vide';

  @override
  String get aiWhatsappPhoneIdInvalid =>
      'L\'ID du numéro de téléphone doit contenir uniquement des chiffres (5 à 15)';

  @override
  String get aiWhatsappConnectedSuccess => 'Compte WhatsApp connecté';

  @override
  String get aiWhatsappDisconnectedSuccess => 'Compte WhatsApp déconnecté';

  @override
  String get aiWhatsappConnected => 'Connecté';

  @override
  String get aiWhatsappNotConnected => 'Non connecté';

  @override
  String get aiWhatsappAccountActive => 'Compte actif';

  @override
  String get aiWhatsappSavedToBusiness =>
      'Enregistré sur votre compte entreprise — la connexion reste active sur vos autres appareils quand vous vous connectez.';

  @override
  String get aiWhatsappDisconnecting => 'Déconnexion...';

  @override
  String get aiWhatsappDisconnect => 'Déconnecter';

  @override
  String get aiWhatsappConnectIntro =>
      'Connectez votre compte WhatsApp Business pour recevoir les messages clients et y répondre.';

  @override
  String get aiWhatsappStep1 => 'Allez dans votre Meta Business Suite';

  @override
  String get aiWhatsappStep2 =>
      'Trouvez l\'ID de votre numéro de téléphone dans les paramètres WhatsApp';

  @override
  String get aiWhatsappStep3 => 'Collez-le ci-dessous et connectez';

  @override
  String get aiWhatsappPhoneIdLabel => 'ID du numéro de téléphone';

  @override
  String get aiWhatsappPhoneIdHint => 'p. ex. 101514826127381';

  @override
  String get aiWhatsappConnectionError => 'Erreur de connexion';

  @override
  String get aiWhatsappTryAgain => 'Réessayer';

  @override
  String get aiMessageHint => 'Message';

  @override
  String aiRecordingStartFailed(String error) {
    return 'Impossible de démarrer l\'enregistrement : $error';
  }

  @override
  String get aiVoiceMessageSent => 'Message vocal envoyé !';

  @override
  String get aiAudioCorrupted => 'Le fichier audio est corrompu ou incomplet';

  @override
  String get aiRecordingTooShort =>
      'Enregistrement trop court (1 seconde minimum)';

  @override
  String aiRecordingStopFailed(String error) {
    return 'Impossible d\'arrêter l\'enregistrement : $error';
  }

  @override
  String get aiMicPermissionTitle => 'Autorisation du micro';

  @override
  String get aiMicPermissionBody =>
      'L\'accès au micro est nécessaire pour enregistrer des messages vocaux. Activez-le dans les paramètres de votre appareil.';

  @override
  String aiFilePickError(String error) {
    return 'Erreur lors du choix du fichier : $error';
  }

  @override
  String get aiSlideToCancel => 'Glissez pour annuler';

  @override
  String get aiSlideUpToLock => 'Glissez vers le haut pour verrouiller';

  @override
  String get aiHoldAndSlide =>
      'Maintenez et glissez pour contrôler l\'enregistrement';

  @override
  String get aiExcelAnalysis => 'Analyse Excel';

  @override
  String get aiExcelAnalystTitle => 'Analyste Excel IA';

  @override
  String get aiExcelAnalystSubtitle =>
      'Exploration interactive et tendances visuelles';

  @override
  String aiModelDefaultSuffix(String name) {
    return '$name (par défaut)';
  }

  @override
  String get aiExcelNoData => 'Aucune donnée trouvée dans le fichier Excel';

  @override
  String get aiExcelSourceData => 'Données source :';

  @override
  String get aiExcelVisualAnalysis => 'Analyse visuelle :';

  @override
  String aiChartRenderError(String error) {
    return 'Erreur d\'affichage du graphique : $error';
  }

  @override
  String get aiExcelAskForCharts =>
      'Posez des questions pour générer des graphiques';

  @override
  String get aiExcelAnalystChat => 'Discussion avec l\'analyste';

  @override
  String get aiExcelAskHint => 'Posez une question sur ces données...';

  @override
  String get aiAssistant => 'Assistant IA';

  @override
  String get aiConversations => 'Conversations';

  @override
  String get aiAdd => 'Ajouter';

  @override
  String get aiNewConversation => 'Nouvelle conversation';

  @override
  String get aiDeleteConversation => 'Supprimer la conversation';

  @override
  String aiDaysAgo(String count) {
    return 'il y a $count j';
  }

  @override
  String get aiPurchaseCredits => 'Acheter des crédits';

  @override
  String get aiCopied => 'Copié';

  @override
  String get aiProcessingExpandThinking =>
      'L\'IA réfléchit... Développez le raisonnement pour voir les détails.';

  @override
  String get aiHideThinking => 'Masquer le raisonnement';

  @override
  String get aiShowThinking => 'Afficher le raisonnement';

  @override
  String get aiWelcomeTitle => 'Votre assistant IA d\'entreprise';

  @override
  String get aiWelcomeSubtitle =>
      'Prêt à vous éclairer sur votre entreprise. Essayez l\'une des questions ci-dessous.';

  @override
  String get aiSamplePersonalBooks =>
      'Quels sont de bons livres sur le leadership ?';

  @override
  String get aiSamplePersonalEmail =>
      'Aide-moi à rédiger un e-mail à un partenaire potentiel.';

  @override
  String get aiSamplePersonalTime =>
      'Donne-moi des conseils pour mieux gérer mon temps.';

  @override
  String get aiSampleBusinessSales =>
      'Quel a été mon total des ventes la semaine dernière ?';

  @override
  String get aiSampleBusinessTopProducts =>
      'Montre-moi la répartition de mes produits les plus vendus ce mois-ci.';

  @override
  String get aiSampleBusinessTax =>
      'Génère un résumé fiscal du dernier trimestre.';

  @override
  String get aiTaxBreakdown => 'DÉTAIL DES TAXES';

  @override
  String get aiTotalTax => 'TOTAL DES TAXES';

  @override
  String get aiTaxSummaryReport => 'Rapport de synthèse fiscale';

  @override
  String get aiCopyReport => 'Copier le rapport';

  @override
  String get aiInventoryVisualization => 'Visualisation du stock';

  @override
  String get aiComingSoon => 'Bientôt disponible';

  @override
  String get uiTicketDue => 'DÛ';

  @override
  String get uiTicketAmount => 'MONTANT';

  @override
  String get aiYourShop => 'votre boutique';

  @override
  String get aiBranchIdRequired => 'L\'ID de la succursale est requis';

  @override
  String get aiNoResponse =>
      'Aucune réponse n\'a été produite. Veuillez réessayer.';

  @override
  String aiWhatsappSendMessageFailed(String error) {
    return 'Impossible d\'envoyer le message WhatsApp : $error';
  }

  @override
  String get aiChartNotFound => 'Erreur : graphique à copier introuvable.';

  @override
  String get aiChartImageFailed => 'Erreur : impossible de générer l\'image.';

  @override
  String get aiChartCopied => 'Graphique copié dans le presse-papiers !';

  @override
  String aiChartCopyFailed(String error) {
    return 'Impossible de copier le graphique : $error';
  }

  @override
  String get aiVoiceUnavailable =>
      'La saisie vocale n\'est pas encore disponible sur cette plateforme.';

  @override
  String aiVoiceStartFailed(String error) {
    return 'Impossible de démarrer la saisie vocale : $error';
  }

  @override
  String get aiMicAccessOff =>
      'L\'accès au micro est désactivé. Activez-le pour Flipper dans les paramètres système, puis réessayez.';

  @override
  String aiListenStartFailed(String error) {
    return 'Impossible de démarrer l\'écoute : $error';
  }

  @override
  String get aiVoiceNeedsNetwork =>
      'La saisie vocale nécessite une connexion réseau pour le moment.';

  @override
  String get aiMicInUse => 'Le micro est utilisé par une autre application.';

  @override
  String aiVoiceFailed(String error) {
    return 'Échec de la saisie vocale ($error).';
  }

  @override
  String get aiLocalUnavailable =>
      'L\'IA sur l\'appareil n\'est pas disponible sur cet appareil.';

  @override
  String get aiLocalPreparing => 'Préparation du modèle sur l\'appareil…';

  @override
  String aiLocalLoadFailed(String error) {
    return 'Impossible de charger le modèle sur l\'appareil : $error';
  }

  @override
  String get aiLocalReadingShopData => 'Lecture des données de votre boutique…';

  @override
  String get aiLocalThinking => 'Réflexion sur l\'appareil…';

  @override
  String aiLocalGenerationFailed(String error) {
    return 'Échec de la génération sur l\'appareil : $error';
  }

  @override
  String get floBriefingSalesComingIn => 'Les ventes arrivent aujourd\'hui.';

  @override
  String floBriefingBody(String revenue, String transactions, String units) {
    return 'Le chiffre d\'affaires atteint <b>RWF $revenue</b> sur <b>$transactions</b> ($units unités) aujourd\'hui — en direct depuis votre appareil.';
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
  String get floStatRevenue => 'Chiffre d\'affaires';

  @override
  String get floStatNetProfit => 'Bénéfice net';

  @override
  String get floStatUnitsSold => 'Unités vendues';

  @override
  String get aiWhatsappNoBusiness =>
      'Aucune entreprise sélectionnée — impossible d\'enregistrer la connexion WhatsApp';

  @override
  String get aiWhatsappBusinessNotFound =>
      'Entreprise introuvable — impossible d\'enregistrer la connexion WhatsApp';

  @override
  String get loginErrorTimeout =>
      'Le serveur Flipper a mis trop de temps à répondre. Votre connexion est peut-être lente. Réessayez. (TIMEOUT)';

  @override
  String get loginErrorSessionExpired =>
      'Votre session a expiré. Saisissez à nouveau votre PIN. (SESSION)';

  @override
  String get loginErrorPinCheckFailed =>
      'Impossible de vérifier ce PIN. Réessayez. (PIN)';

  @override
  String get loginErrorBadResponse =>
      'Le serveur Flipper a renvoyé une réponse inattendue. Réessayez dans une minute. (BAD-RESPONSE)';

  @override
  String get loginErrorTls =>
      'La connexion sécurisée a échoué. Vérifiez que la date et l\'heure de votre téléphone sont réglées automatiquement, puis réessayez. (TLS)';

  @override
  String get loginErrorTlsNetwork =>
      'La connexion au serveur Flipper a été interrompue avant d\'être sécurisée. Votre réseau est peut-être instable. Réessayez, ou basculez entre les données mobiles et le Wi-Fi. (TLS-NET)';

  @override
  String get loginErrorDns =>
      'Serveur Flipper introuvable. Votre connexion Internet est peut-être coupée ou limitée. Vérifiez les données mobiles ou le Wi-Fi. (DNS)';

  @override
  String get loginErrorNetwork =>
      'Impossible de joindre le serveur Flipper. Vérifiez votre connexion Internet et réessayez. (NET)';

  @override
  String get loginErrorOfflineFirst =>
      'Ce téléphone ne peut pas encore vous connecter hors ligne. Connectez-vous à Internet et identifiez-vous une fois ; la connexion hors ligne fonctionnera ensuite. (OFFLINE-FIRST)';

  @override
  String get loginErrorUnknown => 'Échec de la connexion. Réessayez. (UNKNOWN)';

  @override
  String get loginErrorNoAccountForPin =>
      'Aucun compte n\'utilise ce PIN. Vérifiez le PIN et réessayez. (PIN-404)';

  @override
  String get loginErrorHttp404 =>
      'Le serveur Flipper n\'a pas trouvé ce que l\'application a demandé. Mettez l\'application à jour et réessayez. (HTTP-404)';

  @override
  String get loginErrorHttp429 =>
      'Trop de tentatives. Patientez une minute, puis réessayez. (HTTP-429)';

  @override
  String loginErrorHttpRefused(String status) {
    return 'Le serveur Flipper a refusé cette requête. Mettez l\'application à jour et réessayez. (HTTP-$status)';
  }

  @override
  String loginErrorHttpServer(String status) {
    return 'Les serveurs Flipper rencontrent des difficultés en ce moment. Réessayez dans une minute. (HTTP-$status)';
  }

  @override
  String loginErrorHttpOther(String status) {
    return 'Le serveur Flipper n\'a pas pu vérifier ce PIN. Réessayez. (HTTP-$status)';
  }

  @override
  String get loginYourBusiness => 'votre entreprise';

  @override
  String get loginPinRequired => 'Le PIN est requis';

  @override
  String get loginPinTooShort => 'Le PIN doit comporter au moins 4 chiffres';

  @override
  String loginPinTooLong(String max) {
    return 'Le PIN doit comporter au plus $max chiffres';
  }

  @override
  String get loginAuthenticatorCodeRequired =>
      'Le code d\'authentification est requis';

  @override
  String get loginOtpRequired => 'Le code OTP est requis';

  @override
  String get loginAuthenticatorCodeInvalidFormat =>
      'Le code d\'authentification doit comporter 6 chiffres.';

  @override
  String get loginOtpInvalidFormat => 'Le code OTP doit comporter 6 chiffres.';

  @override
  String get loginInvalidPinReenter =>
      'PIN invalide. Saisissez-le à nouveau et réessayez.';

  @override
  String get loginAuthenticatorUnavailable =>
      'Impossible de vérifier le code d\'authentification. Vérifiez votre connexion, ou connectez-vous une fois en ligne pour activer la MFA hors ligne.';

  @override
  String get loginAuthenticatorInvalidCode =>
      'Code d\'authentification invalide. Veuillez réessayer.';

  @override
  String get loginPinSubtitle =>
      'Saisissez votre PIN pour gérer votre entreprise en toute sécurité.';

  @override
  String get loginSignedIn => 'Connecté';

  @override
  String get loginSignIn => 'Se connecter';

  @override
  String get loginCreateAnAccount => 'Créer un compte';

  @override
  String get loginNewToFlipperCreateAccount =>
      'Nouveau sur Flipper ? Créez un compte';

  @override
  String get loginShowPin => 'Afficher le PIN';

  @override
  String get loginHidePin => 'Masquer le PIN';

  @override
  String get loginShow => 'Afficher';

  @override
  String get loginHide => 'Masquer';

  @override
  String loginPinDigitsEntered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chiffres saisis',
      one: '1 chiffre saisi',
    );
    return '$_temp0';
  }

  @override
  String get loginAuthenticator => 'Authentificateur';

  @override
  String get loginAuthenticatorCode => 'Code d\'authentification';

  @override
  String get loginSmsCode => 'Code SMS';

  @override
  String get loginPinEntryCells => 'Cases de saisie du PIN';

  @override
  String loginVerifiedOpening(String business) {
    return 'Vérifié — ouverture de $business…';
  }

  @override
  String get loginShowOrHidePin => 'Afficher ou masquer le PIN';

  @override
  String get loginBackspace => 'Effacer';

  @override
  String get loginSecuredE2e => 'Protégé par un chiffrement de bout en bout';

  @override
  String get loginBrandHeadline =>
      'Votre boutique, votre équipe, vos chiffres — tout au même endroit.';

  @override
  String get loginBrandSubhead =>
      'Reprenez là où vous vous étiez arrêté. Les ventes, le stock et les rapports du jour sont prêts.';

  @override
  String get loginStatBusinesses => 'entreprises';

  @override
  String get loginStatProcessedMonthly => 'traités chaque mois';

  @override
  String get loginStatUptime => 'disponibilité';

  @override
  String get loginRevenueThisWeek => 'Chiffre d\'affaires · cette semaine';

  @override
  String get loginNewSale => 'Nouvelle vente';

  @override
  String get loginSampleSaleDetail => 'Kit solaire · MoMo';

  @override
  String loginStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String get loginSalesStreak => 'Série de ventes';

  @override
  String get loginLandingSlide1Title =>
      'Gérez toute votre\nentreprise depuis une seule appli';

  @override
  String get loginLandingSlide1Highlight => 'entreprise';

  @override
  String get loginLandingSlide1Text =>
      'Vendez, suivez votre stock et gérez votre équipe - Flipper, c\'est votre entreprise dans votre poche.';

  @override
  String get loginLandingSlide2Title =>
      'Des rapports simples et utiles\npour vous aider à grandir';

  @override
  String get loginLandingSlide2Highlight => 'rapports';

  @override
  String get loginLandingSlide2Text =>
      'Voyez exactement ce qui se vend, ce qui s\'épuise et où va votre argent - chaque jour.';

  @override
  String get loginLandingSlide3Title =>
      'Soyez payé plus vite,\nsuivez chaque franc';

  @override
  String get loginLandingSlide3Highlight => 'suivez chaque franc';

  @override
  String get loginLandingSlide3Text =>
      'Acceptez MoMo, les espèces et les cartes. Flipper enregistre chaque vente et la rapproche pour vous.';

  @override
  String get loginLandingSlide4Title =>
      'Développez votre entreprise,\ngagnez des récompenses';

  @override
  String get loginLandingSlide4Highlight => 'gagnez des récompenses';

  @override
  String get loginLandingSlide4Text =>
      'Atteignez vos objectifs quotidiens, maintenez votre série et passez de Vendeur Bronze à Vendeur Or.';

  @override
  String get loginLandingSemantic => 'Accueil Flipper';

  @override
  String get loginNext => 'Suivant';

  @override
  String get loginSkipIntroSemantic =>
      'Passer l\'introduction et créer un compte';

  @override
  String get loginSkipIntro => 'Passer l\'intro - Créer un compte';

  @override
  String get loginAlreadySellingSignIn =>
      'Vous vendez déjà sur Flipper ? Connectez-vous';

  @override
  String get loginDailyReport => 'Rapport quotidien';

  @override
  String get loginStock => 'Stock';

  @override
  String get loginTax => 'Taxes';

  @override
  String get loginGoldSeller => 'Vendeur Or';

  @override
  String get loginFinalizingAuthentication =>
      'Finalisation de l\'authentification...';

  @override
  String get loginAuthTimedOut =>
      'Le délai d\'authentification a expiré. Veuillez réessayer.';

  @override
  String get loginPhoneLoginNavigationFailed =>
      'Impossible d\'ouvrir la connexion par téléphone';

  @override
  String get loginSignInFailed => 'Échec de la connexion';

  @override
  String get loginAuthenticationFailed => 'Échec de l\'authentification';

  @override
  String get loginUnexpectedError => 'Une erreur inattendue s\'est produite';

  @override
  String get loginAuthDomainUnauthorized =>
      'Domaine d\'authentification non autorisé. Veuillez contacter le support.';

  @override
  String get loginAccountDisabled => 'Ce compte a été désactivé.';

  @override
  String get loginAccountExistsDifferentCredential =>
      'Un compte existe déjà avec cette adresse e-mail, mais avec d\'autres identifiants de connexion.';

  @override
  String loginMicrosoftFailedWithReason(String error) {
    return 'Échec de la connexion Microsoft : $error';
  }

  @override
  String get loginMicrosoftFailed =>
      'Échec de la connexion Microsoft. Veuillez réessayer plus tard.';

  @override
  String loginAppleAuthorizationFailed(String error) {
    return 'Échec de l\'autorisation Apple : $error';
  }

  @override
  String loginAppleFailed(String error) {
    return 'Échec de la connexion Apple : $error';
  }

  @override
  String get loginWelcomeToFlipper => 'Bienvenue sur Flipper';

  @override
  String get loginHowToSignIn => 'Comment souhaitez-vous vous connecter ?';

  @override
  String get loginLoggingIn => 'Connexion...';

  @override
  String get loginTryAgainOrUsePin =>
      'Veuillez réessayer ou utiliser la connexion par PIN';

  @override
  String get loginSuccessful => 'Connexion réussie !';

  @override
  String get loginQrScanned =>
      'Code QR scanné ! Finalisation de la connexion...';

  @override
  String get loginFailedTryAgain =>
      'Échec de la connexion. Veuillez réessayer.';

  @override
  String get loginSuccessfulRedirecting => 'Connexion réussie ! Redirection...';

  @override
  String get loginQrTitle => 'Connectez-vous à Flipper avec un code QR';

  @override
  String get loginQrStep1 => '1. Ouvrez Flipper sur votre téléphone';

  @override
  String get loginQrStep2 =>
      '2. Allez sur l\'icône du profil > appuyez longuement dessus.';

  @override
  String get loginQrStep3 =>
      '3. Pointez votre téléphone vers cet écran pour confirmer la connexion';

  @override
  String get loginDownloadApp =>
      'Vous n\'avez pas l\'application Flipper ? Téléchargez-la :';

  @override
  String get loginOpeningAppStore => 'Ouverture de l\'App Store...';

  @override
  String get loginOpeningPlayStore => 'Ouverture du Play Store...';

  @override
  String get loginSwitchToPin => 'Passer à la connexion par PIN';

  @override
  String get loginDeviceOffline => 'L\'appareil est hors ligne';

  @override
  String get loginInvalidEmail => 'E-mail invalide';

  @override
  String get loginGmailRequired => 'Une adresse Gmail est requise';

  @override
  String get loginEnterEmail => 'Saisissez l\'e-mail';

  @override
  String get loginAddEmailHint =>
      'Après avoir saisi votre e-mail, cliquez sur Ajouter un e-mail';

  @override
  String get signupErrorGeneric =>
      'Une erreur s\'est produite lors de l\'inscription';

  @override
  String get signupOtpExpiredOrInvalid =>
      'Code OTP expiré ou invalide. Veuillez demander un nouveau code.';

  @override
  String get signupResendOtp => 'Renvoyer l\'OTP';

  @override
  String get signupNewOtpSent => 'Nouveau code OTP envoyé !';

  @override
  String signupFailedToResendOtp(String error) {
    return 'Échec du renvoi de l\'OTP : $error';
  }

  @override
  String get signupUsername => 'Nom d\'utilisateur';

  @override
  String get signupUsernameHint => 'Saisissez votre nom d\'utilisateur';

  @override
  String get signupFullName => 'Nom complet';

  @override
  String get signupFullNameHint => 'Prénom, Nom';

  @override
  String get signupPhoneOrEmail => 'Téléphone / E-mail';

  @override
  String get signupPhoneOrEmailHint => '783054874 ou votre@email.com';

  @override
  String get signupOtpResent => 'Code OTP renvoyé !';

  @override
  String get signupResend => 'Renvoyer';

  @override
  String get signupOtpSent => 'Code OTP envoyé !';

  @override
  String signupFailedToSendOtp(String error) {
    return 'Échec de l\'envoi de l\'OTP : $error';
  }

  @override
  String get signupSendCode => 'Envoyer le code';

  @override
  String get signupOtpCode => 'Code OTP';

  @override
  String get signupOtpHint => 'Saisissez le code OTP à 6 chiffres';

  @override
  String get signupPhoneVerified => 'Numéro de téléphone vérifié !';

  @override
  String get signupUsage => 'Utilisation';

  @override
  String get signupCountry => 'Pays';

  @override
  String get signupSearchCountry => 'Recherchez votre pays';

  @override
  String get signupStepIdentity => 'Identité';

  @override
  String get signupStepVerify => 'Vérification';

  @override
  String signupStepOf(String step, String total) {
    return 'Étape $step sur $total';
  }

  @override
  String get signupRewardTitle =>
      'Terminez la configuration pour débloquer 500 points';

  @override
  String get signupRewardSubtitle =>
      'Utilisez vos points pour réduire vos frais et obtenir des rapports premium';

  @override
  String get signupStep1Title => 'Qui êtes-vous ?';

  @override
  String get signupStep1Description =>
      'C\'est ainsi que vous vous connecterez et que vos coéquipiers vous trouveront.';

  @override
  String get signupStep2Title => 'Comment vous joindre ?';

  @override
  String get signupStep2Description =>
      'Nous vous enverrons un code à usage unique pour vérifier que c\'est bien vous.';

  @override
  String get signupStep3Title => 'Parlez-nous de votre boutique';

  @override
  String get signupStep3Description =>
      'Nous adapterons Flipper à votre façon de vendre.';

  @override
  String get signupCreateAccountClaim => 'Créer un compte · 500 pts offerts';

  @override
  String signupTermsAgreement(String terms, String privacy) {
    return 'En continuant, vous acceptez les $terms et la $privacy de Flipper';
  }

  @override
  String get signupTermsLink => 'Conditions';

  @override
  String get signupPrivacyLink => 'politique de confidentialité';

  @override
  String get signupVerificationFailed => 'Échec de la vérification';

  @override
  String get signupNameTooLong => 'Le nom est trop long';

  @override
  String get signupContactRequired =>
      'Le numéro de téléphone ou l\'e-mail est requis';

  @override
  String get signupContactInvalid =>
      'Veuillez saisir un numéro de téléphone ou une adresse e-mail valide';

  @override
  String get signupUsernameRequired =>
      'Le nom d\'utilisateur ou de l\'entreprise est requis';

  @override
  String get signupUsernameTaken => 'Ce nom d\'utilisateur est déjà pris';

  @override
  String get signupUsernameCheckUnavailable => 'Recherche de nom indisponible';

  @override
  String get signupOtpMustBe6Digits => 'Le code OTP doit comporter 6 chiffres';

  @override
  String get signupOtpDigitsOnly =>
      'Le code OTP ne doit contenir que des chiffres';

  @override
  String get signupValidateTin => 'Veuillez valider le TIN';

  @override
  String get signupPhoneMustBeVerified =>
      'Le numéro de téléphone doit être vérifié';

  @override
  String get signupFieldRequired => 'Ce champ est obligatoire.';

  @override
  String get signupSelectOption => 'Veuillez sélectionner une option';

  @override
  String get signupJoinFlipper => 'Rejoignez Flipper';

  @override
  String get signupJourneyTagline =>
      'Commencez l\'aventure avec nous dès aujourd\'hui 🚀';

  @override
  String get signupNoMatches => 'Aucun résultat';

  @override
  String get signupTinExtractFailed =>
      'Impossible d\'extraire le TIN du document fourni';

  @override
  String signupTinPdfError(String error) {
    return 'Erreur lors du traitement du PDF : $error';
  }

  @override
  String signupTinValidated(String name) {
    return 'TIN validé : $name';
  }

  @override
  String get signupTinNoData => 'Aucune donnée trouvée pour ce TIN';

  @override
  String get signupTinServiceUnavailable =>
      'Service indisponible : validation ignorée';

  @override
  String signupTinValidationError(String error) {
    return 'Erreur de validation du TIN : $error';
  }

  @override
  String get phoneAuthSelectCountryTitle =>
      'Sélectionnez le pays où se trouve votre entreprise';

  @override
  String get phoneAuthSearchCountry => 'Rechercher un pays...';

  @override
  String get phoneAuthAgreeSellerAgreement =>
      'J\'accepte le Contrat vendeur et la Politique de confidentialité de Flipper.';

  @override
  String get phoneAuthRecaptchaNotice =>
      'Cette application est protégée par reCAPTCHA Enterprise ; les Règles de confidentialité et les Conditions d\'utilisation de Google s\'appliquent.';

  @override
  String get phoneAuthEnterPhone => 'Veuillez saisir votre numéro de téléphone';

  @override
  String get phoneAuthInvalidPhone =>
      'Veuillez saisir un numéro de téléphone valide';

  @override
  String get phoneAuthTitle => 'Vérification du téléphone';

  @override
  String get phoneAuthSubtitle =>
      'Nous enverrons un code de vérification à votre numéro de téléphone pour confirmer votre identité.';

  @override
  String get phoneAuthPhoneHint => '783054874 (sans le 0 initial)';

  @override
  String phoneAuthTermsAgreement(String terms, String privacy) {
    return 'En continuant, vous acceptez nos $terms et notre $privacy';
  }

  @override
  String get phoneAuthTermsOfService => 'Conditions d\'utilisation';

  @override
  String get phoneAuthPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get phoneAuthVerificationCode => 'Code de vérification';

  @override
  String get phoneAuthChangeNumber => 'Changer de numéro';

  @override
  String phoneAuthVerificationFailed(String error) {
    return 'Échec de la vérification : $error';
  }

  @override
  String get phoneAuthUnknownError => 'Une erreur inconnue s\'est produite';

  @override
  String phoneAuthErrorOccurred(String error) {
    return 'Une erreur s\'est produite : $error';
  }

  @override
  String get phoneAuthNewCodeSent => 'Nouveau code de vérification envoyé';

  @override
  String get phoneAuthEnterValidCode =>
      'Veuillez saisir un code valide à 6 chiffres';

  @override
  String get phoneAuthCodeExpired =>
      'Ce code de vérification a expiré. Veuillez en demander un nouveau.';

  @override
  String phoneAuthFailedToVerify(String error) {
    return 'Échec de la vérification du code : $error';
  }

  @override
  String phoneAuthAuthFailed(String error) {
    return 'Échec de l\'authentification : $error';
  }

  @override
  String get loginFailed => 'Échec de la connexion';

  @override
  String get webPricingTitle => 'Tarification simple et transparente';

  @override
  String get webPlanMobile => 'Mobile';

  @override
  String get webPlanMobileDesktop => 'Mobile + Bureau';

  @override
  String get webPlanEnterprise => 'Entreprise';

  @override
  String get webCurrencyPerMonth => 'RWF / mois';

  @override
  String get webFeatureMobileAppAccess => 'Accès à l\'application mobile';

  @override
  String get webFeatureBasicBusinessTools => 'Outils de gestion de base';

  @override
  String get webFeatureDataEncryption => 'Chiffrement des données';

  @override
  String get webFeatureSingleDevice => 'Appareil unique';

  @override
  String get webFeatureTaxReportingAddon =>
      '+ Déclaration fiscale (+30 000 RWF)';

  @override
  String get webFeatureMobileDesktopAppAccess =>
      'Accès aux applications mobile et bureau';

  @override
  String get webFeatureAdvancedBusinessTools => 'Outils de gestion avancés';

  @override
  String get webFeatureMilitaryGradeEncryption =>
      'Chiffrement de niveau militaire';

  @override
  String get webFeaturePrioritySupport => 'Assistance prioritaire';

  @override
  String get webFeatureMultipleDevices => 'Plusieurs appareils';

  @override
  String get webFeatureAdvancedAnalytics => 'Analyses avancées';

  @override
  String get webFeatureFullPlatformAccess => 'Accès complet à la plateforme';

  @override
  String get webFeatureEnterpriseGradeSecurity =>
      'Sécurité de niveau entreprise';

  @override
  String get webFeature247DedicatedSupport => 'Assistance dédiée 24h/24, 7j/7';

  @override
  String get webFeatureUnlimitedUsersBranches =>
      'Utilisateurs et succursales illimités';

  @override
  String get webFeatureCustomIntegrations => 'Intégrations sur mesure';

  @override
  String get webFeaturePremiumTaxConsulting =>
      '+ Conseil fiscal premium (+400 000 RWF)';

  @override
  String get webGetStarted => 'Commencer';

  @override
  String get booksReceivables => 'Créances clients';

  @override
  String get booksBills => 'Factures fournisseurs';

  @override
  String get booksSuppliers => 'Fournisseurs';

  @override
  String get booksPayables => 'Dettes fournisseurs';

  @override
  String get booksJournalEntries => 'Écritures comptables';

  @override
  String get booksGeneralLedger => 'Grand livre';

  @override
  String get booksRecurring => 'Récurrentes';

  @override
  String get booksBankReconciliation => 'Rapprochement bancaire';

  @override
  String get booksFinancialStatements => 'États financiers';

  @override
  String get booksTrialBalance => 'Balance générale';

  @override
  String get booksTaxVat => 'Taxes et TVA';

  @override
  String get booksChartOfAccounts => 'Plan comptable';

  @override
  String get booksPeriodClose => 'Clôture de période';

  @override
  String get booksAuditTrail => 'Piste d\'audit';

  @override
  String get booksUsersRoles => 'Utilisateurs et rôles';

  @override
  String get booksOverview => 'Vue d\'ensemble';

  @override
  String get booksDaybook => 'Journal';

  @override
  String get booksSetup => 'Configuration';

  @override
  String get booksCompliance => 'Conformité';

  @override
  String booksClosingBalance(String amount) {
    return 'Clôture $amount';
  }

  @override
  String booksAccountPostingHistory(String currency) {
    return 'Historique des écritures par compte · $currency';
  }

  @override
  String get booksReadingStatement => 'Lecture du relevé…';

  @override
  String get booksStatementImported => 'Relevé importé';

  @override
  String booksStatementLinesLoaded(int count, String source) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lignes chargées',
      one: '1 ligne chargée',
    );
    return '$source · $_temp0';
  }

  @override
  String get booksImportFailed => 'Échec de l\'import';

  @override
  String get booksMatchDifferentAccountTitle =>
      'Rapprocher sur un autre compte ?';

  @override
  String booksMatchDifferentAccountBody(
    String account,
    String amount,
    String bankCode,
    String code,
  ) {
    return 'Cette écriture mouvemente $amount sur $account ($code), et non sur Banque ($bankCode). Rapprocher quand même ?';
  }

  @override
  String get booksMatch => 'Rapprocher';

  @override
  String get booksBankLineMatched => 'Ligne bancaire rapprochée';

  @override
  String get booksBankCatSaleIncome => 'Une vente / un revenu';

  @override
  String get booksBankCatSaleIncomeHint => 'Argent que vous avez gagné';

  @override
  String get booksBankCatCustomerPaid => 'Un client a réglé une dette';

  @override
  String get booksBankCatCustomerPaidHint => 'Il vous devait de l\'argent';

  @override
  String get booksBankCatOwnerAdded => 'Apport du propriétaire';

  @override
  String get booksBankCatOwnerAddedHint => 'Capital que vous avez apporté';

  @override
  String get booksBankCatLoanReceived => 'Un prêt reçu';

  @override
  String get booksBankCatLoanReceivedHint => 'Argent emprunté';

  @override
  String get booksBankCatFromCash => 'Virement depuis la caisse';

  @override
  String get booksBankCatFromCashHint => 'Transféré depuis votre caisse';

  @override
  String get booksBankCatFromMomo => 'Virement depuis Mobile Money';

  @override
  String get booksBankCatFromMomoHint => 'Transféré depuis MoMo';

  @override
  String get booksBankCatOtherIncome => 'Autres revenus';

  @override
  String get booksBankCatOtherIncomeHint => 'Toute autre rentrée';

  @override
  String get booksBankCatBankFee => 'Frais bancaires';

  @override
  String get booksBankCatBankFeeHint => 'Frais prélevés par la banque';

  @override
  String get booksBankCatPaidSupplier =>
      'Paiement fournisseur / achat de stock';

  @override
  String get booksBankCatPaidSupplierHint => 'Stock ou marchandises';

  @override
  String get booksBankCatRent => 'Loyer';

  @override
  String get booksBankCatRentHint => 'Loyer du magasin ou du bureau';

  @override
  String get booksBankCatSalaries => 'Salaires';

  @override
  String get booksBankCatSalariesHint => 'Personnel payé';

  @override
  String get booksBankCatUtilities => 'Services publics';

  @override
  String get booksBankCatUtilitiesHint => 'Électricité, eau, internet';

  @override
  String get booksBankCatTransport => 'Transport / carburant';

  @override
  String get booksBankCatTransportHint => 'Déplacements et livraisons';

  @override
  String get booksBankCatLoanRepayment => 'Remboursement de prêt';

  @override
  String get booksBankCatLoanRepaymentHint => 'Remboursement d\'un emprunt';

  @override
  String get booksBankCatOwnerWithdrew => 'Retrait du propriétaire';

  @override
  String get booksBankCatOwnerWithdrewHint => 'Retrait personnel';

  @override
  String get booksBankCatToCash => 'Virement vers la caisse';

  @override
  String get booksBankCatToCashHint => 'Transféré vers votre caisse';

  @override
  String get booksBankCatToMomo => 'Virement vers Mobile Money';

  @override
  String get booksBankCatToMomoHint => 'Transféré vers MoMo';

  @override
  String get booksBankCatOtherExpense => 'Autres dépenses';

  @override
  String get booksBankCatOtherExpenseHint => 'Toute autre dépense';

  @override
  String get booksEntryCreatedMatched => 'Écriture créée et rapprochée';

  @override
  String booksEntryCreatedMatchedDetail(
    String amount,
    String category,
    String ref,
  ) {
    return '$category — $amount sur Banque ($ref)';
  }

  @override
  String get booksCouldNotCreateEntry => 'Impossible de créer l\'écriture';

  @override
  String get booksWhereMoneyFrom => 'D\'où vient cet argent ?';

  @override
  String get booksWhatPaymentFor => 'À quoi correspondait ce paiement ?';

  @override
  String get booksPickClosestMatch =>
      'Choisissez l\'option la plus proche — nous l\'enregistrerons correctement pour vous.';

  @override
  String get booksMatchBankLine => 'Rapprocher la ligne bancaire';

  @override
  String get booksBank => 'Banque';

  @override
  String booksBankRecSubtitle(String bank, String currency, String period) {
    return 'Banque · $bank · relevé $period · $currency';
  }

  @override
  String get booksImportStatement => 'Importer un relevé';

  @override
  String get booksReconciled => 'Rapproché';

  @override
  String get booksFinishReconciliation => 'Terminer le rapprochement';

  @override
  String get booksReconciliationComplete => 'Rapprochement terminé';

  @override
  String booksLinesMatchedOfTotal(String matched, String total) {
    return '$matched lignes sur $total rapprochées';
  }

  @override
  String get booksStatementBalance => 'Solde du relevé';

  @override
  String get booksFromImportedStatement => 'du relevé importé';

  @override
  String get booksMatched => 'Rapprochées';

  @override
  String get booksNoLinesYet => 'aucune ligne';

  @override
  String booksOfTotal(String total) {
    return 'sur $total';
  }

  @override
  String get booksNeedsAttention => 'À traiter';

  @override
  String get booksStatementLines => 'Lignes du relevé';

  @override
  String get booksMatchEachLine =>
      'Rapprochez chaque ligne bancaire d\'une écriture';

  @override
  String get booksNoStatementLines =>
      'Aucune ligne de relevé pour l\'instant. Importez un relevé pour commencer.';

  @override
  String booksVatSubtitle(String period, String rate) {
    return 'TVA à $rate % (taux standard Rwanda) · période $period';
  }

  @override
  String get booksFileWithRra => 'Déclarer à la RRA';

  @override
  String get booksVatReturnSubmitted => 'Déclaration de TVA envoyée';

  @override
  String booksRraAckRef(String ref) {
    return 'Accusé RRA · réf. $ref';
  }

  @override
  String get booksOutputVatOnSales => 'TVA collectée (sur ventes)';

  @override
  String get booksInputVatReclaimable => 'TVA déductible (récupérable)';

  @override
  String get booksNetVatPayable => 'TVA nette à payer';

  @override
  String booksDueDate(String date) {
    return 'Échéance $date';
  }

  @override
  String get booksVatReturnSummary => 'Résumé de la déclaration de TVA';

  @override
  String get booksDraft => 'Brouillon';

  @override
  String get booksTotalSalesVatInclusive => 'Total des ventes (TTC)';

  @override
  String get booksOutputVatCollected => 'TVA collectée';

  @override
  String get booksInputVatOnPurchases => 'TVA déductible sur achats';

  @override
  String get booksNetVatDueToRra => 'TVA nette due à la RRA';

  @override
  String get booksPrint => 'Imprimer';

  @override
  String get booksPreparingPrintLayout => 'Préparation de la mise en page';

  @override
  String get booksGeneratingPdf => 'Génération du PDF';

  @override
  String booksStatementPack(String currency) {
    return 'Dossier des états · $currency';
  }

  @override
  String get booksIncomeStatement => 'Compte de résultat';

  @override
  String get booksBalanceSheet => 'Bilan';

  @override
  String get booksCashFlow => 'Flux de trésorerie';

  @override
  String get booksNetRevenue => 'Chiffre d\'affaires net';

  @override
  String get booksCogs => 'Coût des marchandises vendues';

  @override
  String get booksGrossProfit => 'Marge brute';

  @override
  String get booksOperatingExpenses => 'Charges d\'exploitation';

  @override
  String get booksTotalAssets => 'Total de l\'actif';

  @override
  String get booksTotalLiabilities => 'Total du passif';

  @override
  String get booksTotalEquity => 'Total des capitaux propres';

  @override
  String get booksLiabilitiesPlusEquity => 'Passif + capitaux propres';

  @override
  String get booksOperatingActivities => 'Activités d\'exploitation';

  @override
  String get booksInvestingActivities => 'Activités d\'investissement';

  @override
  String get booksFinancingActivities => 'Activités de financement';

  @override
  String get booksNetChangeInCash => 'Variation nette de trésorerie';

  @override
  String get booksBalancedAssetsEqual =>
      'Équilibré — l\'actif est égal au passif plus les capitaux propres';

  @override
  String booksAsOfPeriod(String currency, String period) {
    return 'Au $period · $currency';
  }

  @override
  String get booksInBalance => 'Équilibrée';

  @override
  String get booksOutOfBalance => 'Déséquilibrée';

  @override
  String get booksNoAccountsYet => 'Aucun compte chargé pour le moment.';

  @override
  String get booksTotals => 'Totaux';

  @override
  String get booksAssets => 'Actifs';

  @override
  String get booksLiabilities => 'Passifs';

  @override
  String get booksEquity => 'Capitaux propres';

  @override
  String get booksIncome => 'Produits';

  @override
  String get booksExpenses => 'Charges';

  @override
  String booksCoaSubtitle(String count) {
    return '$count comptes · structure numérotée du grand livre';
  }

  @override
  String get booksFilterByType => 'Filtrer par type';

  @override
  String get booksAllTypes => 'Tous les types';

  @override
  String get booksFilter => 'Filtrer';

  @override
  String get booksAddAccount => 'Ajouter un compte';

  @override
  String get booksNetIncome => 'Résultat net';

  @override
  String get booksNetLoss => 'Perte nette';

  @override
  String get booksOpenOnWiderScreen =>
      'Ouvrez sur un écran plus large pour l\'espace de travail bureau';

  @override
  String get booksFreqMonthly => 'Mensuel';

  @override
  String get booksFreqWeekly => 'Hebdomadaire';

  @override
  String get booksFreqQuarterly => 'Trimestriel';

  @override
  String get booksFreqYearly => 'Annuel';

  @override
  String get booksRoleOwner => 'Propriétaire';

  @override
  String get booksRoleOwnerDesc =>
      'Accès complet — approuver, comptabiliser, déclarer les taxes, gérer l\'équipe';

  @override
  String get booksRoleBookkeeper => 'Aide-comptable';

  @override
  String get booksRoleBookkeeperDesc =>
      'Créer et modifier écritures, factures et factures fournisseurs ; ne peut ni approuver ni déclarer';

  @override
  String get booksRoleCashier => 'Caissier';

  @override
  String get booksRoleCashierDesc =>
      'Enregistrer uniquement les ventes et reçus depuis le POS';

  @override
  String get booksRoleViewer => 'Lecteur';

  @override
  String get booksRoleViewerDesc =>
      'Accès en lecture seule aux rapports et états';

  @override
  String get booksCapViewReports => 'Voir les rapports et états';

  @override
  String get booksCapCreateInvoicesBills =>
      'Créer des factures client et fournisseur';

  @override
  String get booksCapRecordPayments => 'Enregistrer paiements et encaissements';

  @override
  String get booksCapPostJournal => 'Comptabiliser et modifier les écritures';

  @override
  String get booksCapApproveEntries => 'Approuver les écritures';

  @override
  String get booksCapFileVat => 'Déclarer la TVA à la RRA';

  @override
  String get booksCapClosePeriods => 'Clôturer les périodes et gérer l\'équipe';

  @override
  String get booksRecurringEntries => 'Écritures récurrentes';

  @override
  String booksRecurringSubtitle(String currency) {
    return 'Loyer, salaires et autres écritures répétitives se comptabilisent seuls · $currency';
  }

  @override
  String get booksNewSchedule => 'Nouvelle planification';

  @override
  String get booksActiveSchedules => 'Planifications actives';

  @override
  String booksCountOfTotal(String count, String total) {
    return '$count sur $total';
  }

  @override
  String get booksMonthlyCommitted => 'Engagement mensuel';

  @override
  String get booksNextRun => 'Prochaine exécution';

  @override
  String get booksNoRecurringYet =>
      'Aucune planification pour l\'instant. Créez-en une pour comptabiliser loyer, salaires ou autres écritures répétitives.';

  @override
  String get booksSchedule => 'Planification';

  @override
  String get booksFrequency => 'Fréquence';

  @override
  String get booksPostsTo => 'Comptabilisé sur';

  @override
  String get booksStatus => 'Statut';

  @override
  String get booksPaused => '— en pause —';

  @override
  String get booksRunNow => 'Exécuter maintenant';

  @override
  String get booksScheduleResumed => 'Planification reprise';

  @override
  String get booksSchedulePaused => 'Planification en pause';

  @override
  String get booksEntryPosted => 'Écriture comptabilisée';

  @override
  String get booksAlreadyPostedThisPeriod =>
      'Déjà comptabilisée pour cette période';

  @override
  String get booksCouldNotPostEntry =>
      'Impossible de comptabiliser l\'écriture';

  @override
  String get booksScheduleCreated => 'Planification créée';

  @override
  String get booksScheduleUpdated => 'Planification mise à jour';

  @override
  String booksPeriodCloseSubtitle(String currency, String period) {
    return 'Verrouillez $period une fois les comptes définitifs · $currency';
  }

  @override
  String booksPeriodLocked(String period) {
    return '$period verrouillée';
  }

  @override
  String get booksReopenPeriod => 'Rouvrir la période';

  @override
  String get booksCouldNotReopenPeriod => 'Impossible de rouvrir la période';

  @override
  String get booksPeriodReopened => 'Période rouverte';

  @override
  String booksPeriodPostableAgain(String period) {
    return '$period est à nouveau ouverte aux écritures';
  }

  @override
  String get booksClosePeriod => 'Clôturer la période';

  @override
  String get booksCouldNotClosePeriod => 'Impossible de clôturer la période';

  @override
  String get booksPeriodClosed => 'Période clôturée';

  @override
  String booksPeriodLockedReadOnly(String period) {
    return '$period verrouillée · écritures en lecture seule';
  }

  @override
  String get booksCloseChecklist => 'Liste de clôture';

  @override
  String booksStepsComplete(String done, String total) {
    return '$done étapes sur $total terminées';
  }

  @override
  String get booksReview => 'Vérifier';

  @override
  String get booksWhatClosingDoes => 'Ce que fait la clôture';

  @override
  String get booksCloseNoteLocks =>
      'Verrouille la période. Les écritures comptabilisées passent en lecture seule — aucune modification sans réouverture.';

  @override
  String get booksCloseNoteRollsForward =>
      'Report à nouveau. Le résultat net passe en report à nouveau et les soldes sont reportés sur le mois suivant.';

  @override
  String get booksCloseNoteAuditPoint =>
      'Crée un point d\'audit. Un instantané est consigné dans la piste d\'audit avec votre nom et l\'heure.';

  @override
  String get booksAllChecksPassed =>
      'Tous les contrôles sont validés — prêt pour la clôture.';

  @override
  String get booksFinishChecklist =>
      'Terminez chaque étape de la liste pour activer la clôture.';

  @override
  String get booksAuditSubtitle =>
      'Chaque modification, son auteur et sa date · immuable';

  @override
  String get booksAllUsers => 'Tous les utilisateurs';

  @override
  String get booksExport => 'Exporter';

  @override
  String get booksExportingAuditLog => 'Export du journal d\'audit';

  @override
  String booksEventsCsv(String count) {
    return '$count événements · CSV';
  }

  @override
  String get booksNoAuditEvents => 'Aucun événement d\'audit pour l\'instant.';

  @override
  String get booksRolesSubtitle =>
      'Contrôlez qui peut voir et modifier la comptabilité';

  @override
  String get booksInviteTeammate => 'Inviter un collègue';

  @override
  String get booksInviteSent => 'Invitation envoyée';

  @override
  String get booksInvitationsComingSoon =>
      'Invitations d\'équipe bientôt disponibles';

  @override
  String booksTeamCount(String count) {
    return 'Équipe ($count)';
  }

  @override
  String get booksOnlyYouHaveAccess =>
      'Vous êtes seul à avoir accès. Invitez des collègues pour collaborer.';

  @override
  String get booksYou => 'Vous';

  @override
  String get booksRoles => 'Rôles';

  @override
  String get booksCapability => 'Autorisation';

  @override
  String get booksActiveNow => 'Actif maintenant';

  @override
  String get booksRoleSystem => 'Système';

  @override
  String get booksTaskAllPosted => 'Toutes les écritures comptabilisées';

  @override
  String booksTaskPendingApproval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count écritures en attente d\'approbation',
      one: '1 écriture en attente d\'approbation',
    );
    return '$_temp0';
  }

  @override
  String get booksTaskNoPending => 'Aucune écriture en attente';

  @override
  String get booksTaskBankReconciled => 'Comptes bancaires rapprochés';

  @override
  String booksTaskLinesUnmatched(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lignes de relevé non rapprochées',
      one: '1 ligne de relevé non rapprochée',
    );
    return '$_temp0';
  }

  @override
  String get booksTaskAllLinesMatched => 'Toutes les lignes rapprochées';

  @override
  String get booksTaskReceivablesReviewed => 'Créances vérifiées';

  @override
  String get booksTaskNoOpenReceivables => 'Aucune créance ouverte';

  @override
  String booksTaskAgingOverdue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Échéancier confirmé · $count factures en retard',
      one: 'Échéancier confirmé · 1 facture en retard',
    );
    return '$_temp0';
  }

  @override
  String booksTaskAgingBalances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Échéancier confirmé · $count soldes',
      one: 'Échéancier confirmé · 1 solde',
    );
    return '$_temp0';
  }

  @override
  String get booksTaskPayablesReviewed => 'Dettes vérifiées';

  @override
  String get booksTaskNoOpenPayables => 'Aucune dette ouverte';

  @override
  String get booksTaskAllBillsEntered =>
      'Toutes les factures fournisseurs saisies';

  @override
  String get booksTaskVatPrepared => 'Déclaration de TVA préparée';

  @override
  String get booksTaskNoVatActivity => 'Aucune opération de TVA sur la période';

  @override
  String booksTaskVatNetPayable(String amount, String date) {
    return 'Net à payer $amount · échéance $date';
  }

  @override
  String get booksTaskDepreciationPosted => 'Amortissements comptabilisés';

  @override
  String get booksTaskDepreciationMaybePending =>
      'Les écritures en attente peuvent inclure des amortissements';

  @override
  String get booksTaskDepreciationUpToDate => 'Amortissements à jour';

  @override
  String get booksStatusSent => 'Envoyée';

  @override
  String get booksStatusPartPaid => 'Partiellement payée';

  @override
  String get booksStatusPaid => 'Payée';

  @override
  String get booksStatusOverdue => 'En retard';

  @override
  String get booksSignOutTitle => 'Se déconnecter ?';

  @override
  String get booksSignOutBody =>
      'Termine votre session et efface la synchronisation Ditto pour cet onglet. Choisissez « Actualiser depuis le cloud » si vous voulez seulement recharger les données Books.';

  @override
  String get booksRefreshFromCloud => 'Actualiser depuis le cloud';

  @override
  String get booksResyncDitto => 'Resynchroniser les données Ditto';

  @override
  String get booksSupplier => 'Fournisseur';

  @override
  String get booksAgingCurrent => 'Courant';

  @override
  String get booksAging1to30 => '1–30 jours';

  @override
  String get booksAging31to60 => '31–60 jours';

  @override
  String get booksAging60plus => '60+ jours';

  @override
  String get booksMoneyIn => 'Entrées';

  @override
  String get booksMoneyOut => 'Sorties';

  @override
  String get booksAccountsReceivable => 'Créances clients';

  @override
  String get booksAccountsPayable => 'Dettes fournisseurs';

  @override
  String booksArSubtitle(String currency) {
    return 'Ce que vous doivent les clients · par ancienneté · $currency';
  }

  @override
  String booksApSubtitle(String currency) {
    return 'Ce que vous devez aux fournisseurs · par ancienneté · $currency';
  }

  @override
  String get booksSendReminders => 'Envoyer des relances';

  @override
  String get booksSchedulePayment => 'Planifier un paiement';

  @override
  String get booksRemindersSent => 'Relances envoyées';

  @override
  String get booksPaymentScheduled => 'Paiement planifié';

  @override
  String booksEmailedCustomers(String count) {
    return '$count clients avec un solde ouvert relancés par e-mail';
  }

  @override
  String booksQueuedSupplierPayments(String count) {
    return '$count paiements fournisseurs en file d\'attente';
  }

  @override
  String get booksNewInvoice => 'Nouvelle facture';

  @override
  String get booksNewBill => 'Nouvelle facture fournisseur';

  @override
  String get booksAgingSummary => 'Synthèse par ancienneté';

  @override
  String get booksReference => 'Référence';

  @override
  String get booksTotal => 'Total';

  @override
  String get booksStatementOfAccount => 'Relevé de compte';

  @override
  String booksOutstanding(String amount, String name) {
    return '$name · $amount restant dû';
  }

  @override
  String booksJournalSubtitle(String currency) {
    return 'Chaque transaction en partie double équilibrée · $currency';
  }

  @override
  String get booksFilterBySource => 'Filtrer par origine';

  @override
  String get booksAllSources => 'Toutes les origines';

  @override
  String get booksRecordExpense => 'Enregistrer une dépense';

  @override
  String get booksNewJournalEntry => 'Nouvelle écriture';

  @override
  String get booksFilterAll => 'Toutes';

  @override
  String get booksFilterPosted => 'Comptabilisées';

  @override
  String get booksFilterPending => 'En attente';

  @override
  String get booksFilterDrafts => 'Brouillons';

  @override
  String booksEntriesAwaitingApproval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count écritures en attente d\'approbation',
      one: '1 écriture en attente d\'approbation',
    );
    return '$_temp0';
  }

  @override
  String get booksNoEntriesMatchFilter =>
      'Aucune écriture ne correspond à ce filtre.';

  @override
  String get booksDrAbbr => 'Débit';

  @override
  String get booksCrAbbr => 'Crédit';

  @override
  String get booksFinancialOverview => 'Vue financière';

  @override
  String get booksAtAGlance => 'La comptabilité en un coup d\'œil';

  @override
  String booksDashSubtitleEntity(
    String currency,
    String entity,
    String period,
  ) {
    return '$entity · période fiscale $period · montants en $currency';
  }

  @override
  String booksDashSubtitle(String currency, String period) {
    return 'Période fiscale $period · montants en $currency';
  }

  @override
  String get booksGeneralLedgerLines => 'Lignes du grand livre';

  @override
  String get booksExportingExcel => 'Export vers Excel';

  @override
  String get booksExportingCsv => 'Export CSV';

  @override
  String get booksExcelWorkbook => 'Classeur Excel (.xlsx)';

  @override
  String get booksPdfReport => 'Rapport PDF';

  @override
  String get booksCsvRawLedger => 'CSV (grand livre brut)';

  @override
  String get booksVsPriorPeriod => 'vs période précédente';

  @override
  String get booksCashAndBank => 'Caisse et banque';

  @override
  String booksAcrossAccounts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'sur $count comptes',
      one: 'sur 1 compte',
    );
    return '$_temp0';
  }

  @override
  String get booksReceivable => 'À recevoir';

  @override
  String booksOverdue60(String amount) {
    return '$amount en retard de 60+ jours';
  }

  @override
  String get booksNoOverdue60 => 'aucun retard de 60+ jours';

  @override
  String get booksPayable => 'À payer';

  @override
  String get booksNoOpenBills => 'aucune facture ouverte';

  @override
  String booksOpenBills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count factures ouvertes',
      one: '1 facture ouverte',
    );
    return '$_temp0';
  }

  @override
  String get booksRevenueVsExpenses => 'Revenus vs dépenses';

  @override
  String get booksTrailing6Months => '6 derniers mois';

  @override
  String get booksWhereMoneyWent => 'Où va l\'argent';

  @override
  String get booksOpexBreakdown => 'Répartition des charges d\'exploitation';

  @override
  String get booksOpexShort => 'charges';

  @override
  String get booksRecentJournalEntries => 'Écritures récentes';

  @override
  String get booksNoJournalEntriesYet => 'Aucune écriture pour l\'instant.';

  @override
  String get booksProfitLoss => 'Compte de résultat';

  @override
  String booksDocAlreadyExists(String id) {
    return '$id existe déjà';
  }

  @override
  String get booksUseAnotherNumber => 'Utilisez un autre numéro';

  @override
  String get booksBillSaved => 'Facture fournisseur enregistrée';

  @override
  String get booksDraftSaved => 'Brouillon enregistré';

  @override
  String get booksInvoiceSentPosted => 'Facture envoyée et comptabilisée';

  @override
  String get booksBillRecordedPosted =>
      'Facture fournisseur enregistrée et comptabilisée';

  @override
  String get booksPaymentRecorded => 'Paiement enregistré';

  @override
  String booksInvoicesSubtitle(String currency) {
    return 'Facturez vos clients et soyez payé · $currency';
  }

  @override
  String booksBillsSubtitle(String currency) {
    return 'Suivez ce que vous devez à vos fournisseurs · $currency';
  }

  @override
  String get booksPdfSummary => 'Résumé PDF';

  @override
  String booksInvoicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count factures',
      one: '1 facture',
    );
    return '$_temp0';
  }

  @override
  String booksBillsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count factures fournisseurs',
      one: '1 facture fournisseur',
    );
    return '$_temp0';
  }

  @override
  String get booksOutstandingLabel => 'Impayés';

  @override
  String get booksOwedToSuppliers => 'Dû aux fournisseurs';

  @override
  String get booksDrafts => 'Brouillons';

  @override
  String get booksNoInvoicesYet =>
      'Aucune facture pour l\'instant. Créez une facture pour commencer.';

  @override
  String get booksNoBillsYet =>
      'Aucune facture fournisseur pour l\'instant. Enregistrez-en une pour commencer.';

  @override
  String booksNoInvoicesInTab(String tab) {
    return 'Aucune facture dans « $tab ».';
  }

  @override
  String booksNoBillsInTab(String tab) {
    return 'Aucune facture fournisseur dans « $tab ».';
  }

  @override
  String get booksBill => 'Facture fournisseur';

  @override
  String get booksDue => 'Échéance';

  @override
  String get booksOpenPreview => 'Ouvrir et prévisualiser';

  @override
  String get booksRecordPayment => 'Enregistrer un paiement';

  @override
  String get booksPayThisBill => 'Payer cette facture';

  @override
  String get booksSendReminder => 'Envoyer une relance';

  @override
  String get booksReminderSent => 'Relance envoyée';

  @override
  String get booksDeleted => 'Supprimé';

  @override
  String get booksCustomerAdded => 'Client ajouté';

  @override
  String get booksSupplierAdded => 'Fournisseur ajouté';

  @override
  String booksCustomersSubtitle(String count) {
    return 'Personnes et entreprises à qui vous vendez · $count fiches';
  }

  @override
  String booksSuppliersSubtitle(String count) {
    return 'Fournisseurs auprès de qui vous achetez · $count fiches';
  }

  @override
  String get booksSearchCustomers => 'Rechercher des clients…';

  @override
  String get booksSearchSuppliers => 'Rechercher des fournisseurs…';

  @override
  String get booksNewCustomer => 'Nouveau client';

  @override
  String get booksNewSupplier => 'Nouveau fournisseur';

  @override
  String get booksTotalCustomers => 'Total clients';

  @override
  String get booksTotalSuppliers => 'Total fournisseurs';

  @override
  String get booksWithOpenBalance => 'Avec solde ouvert';

  @override
  String get booksWithBillsDue => 'Avec factures dues';

  @override
  String get booksTotalReceivable => 'Total à recevoir';

  @override
  String get booksTotalPayable => 'Total à payer';

  @override
  String get booksNoCustomersYet => 'Aucun client pour l\'instant.';

  @override
  String get booksNoSuppliersYet => 'Aucun fournisseur pour l\'instant.';

  @override
  String booksNoMatchesFor(String query) {
    return 'Aucun résultat pour « $query ».';
  }

  @override
  String get booksContact => 'Contact';

  @override
  String get booksTerms => 'Conditions';

  @override
  String get booksOwesYou => 'Vous doit';

  @override
  String get booksYouOwe => 'Vous devez';

  @override
  String get booksViewRecord => 'Voir la fiche';

  @override
  String get booksSendStatement => 'Envoyer le relevé';

  @override
  String get booksCallContact => 'Appeler le contact';

  @override
  String get booksStatementSent => 'Relevé envoyé';

  @override
  String get booksNoPhoneOnFile => 'Aucun numéro enregistré';

  @override
  String booksDeleteNamed(String name) {
    return 'Supprimer $name ?';
  }

  @override
  String get booksDeleteSharedContactBody =>
      'Ce contact est partagé avec l\'application POS. Le supprimer retire la fiche client partout ; les ventes passées gardent leur copie mais perdent le lien. Supprimer quand même ?';

  @override
  String get booksDeleteEverywhere => 'Supprimer partout';

  @override
  String booksCustomerSince(String date) {
    return 'Client depuis $date';
  }

  @override
  String booksSupplierSince(String date) {
    return 'Fournisseur depuis $date';
  }

  @override
  String get booksOutstandingBalance => 'Solde restant dû';

  @override
  String get booksAmountPayable => 'Montant à payer';

  @override
  String get booksLifetimeBilled => 'Total facturé';

  @override
  String get booksLifetimePurchased => 'Total acheté';

  @override
  String get booksContactDetails => 'COORDONNÉES';

  @override
  String get booksPrimaryContact => 'Contact principal';

  @override
  String booksInvoicesHeader(String count) {
    return 'FACTURES ($count)';
  }

  @override
  String booksBillsHeader(String count) {
    return 'FACTURES FOURNISSEURS ($count)';
  }

  @override
  String get booksNoDocumentsYet => 'Aucun document pour l\'instant.';

  @override
  String get booksAddCustomerToContacts => 'Ajoutez un client à vos contacts';

  @override
  String get booksAddSupplierToContacts =>
      'Ajoutez un fournisseur à vos contacts';

  @override
  String get booksBusinessCustomerName => 'Nom de l\'entreprise / du client';

  @override
  String get booksSupplierName => 'Nom du fournisseur';

  @override
  String get booksExampleBusinessName => 'ex. Karake Retail Group';

  @override
  String get booksFullName => 'Nom complet';

  @override
  String get booksEmailPlaceholder => 'nom@email.rw';

  @override
  String get booksTaxId => 'Numéro fiscal';

  @override
  String get booksPaymentTerms => 'Conditions de paiement';

  @override
  String get booksAddSupplier => 'Ajouter le fournisseur';

  @override
  String booksNetDays(String days) {
    return '$days jours net';
  }

  @override
  String booksNewInvoiceTitle(String id) {
    return 'Nouvelle facture · $id';
  }

  @override
  String booksEditInvoiceTitle(String id) {
    return 'Modifier la facture · $id';
  }

  @override
  String booksNewBillTitle(String id) {
    return 'Nouvelle facture fournisseur · $id';
  }

  @override
  String booksEditBillTitle(String id) {
    return 'Modifier la facture fournisseur · $id';
  }

  @override
  String get booksInvoiceEditorSubtitle =>
      'Facturez un client — Flipper comptabilise automatiquement la vente et la TVA.';

  @override
  String get booksBillEditorSubtitle =>
      'Enregistrez une facture fournisseur — Flipper comptabilise la charge et la TVA déductible.';

  @override
  String get booksSelectCustomer => 'Choisir un client…';

  @override
  String get booksSelectSupplier => 'Choisir un fournisseur…';

  @override
  String get booksIssueDate => 'Date d\'émission';

  @override
  String get booksBillDate => 'Date de facture';

  @override
  String get booksDueDateLabel => 'Date d\'échéance';

  @override
  String get booksLineItems => 'Lignes';

  @override
  String get booksAddLine => 'Ajouter une ligne';

  @override
  String get booksInvoiceWillPost => 'Cette facture sera comptabilisée ainsi';

  @override
  String get booksBillWillPost =>
      'Cette facture fournisseur sera comptabilisée ainsi';

  @override
  String get booksSaveDraft => 'Enregistrer le brouillon';

  @override
  String get booksSaveAndSend => 'Enregistrer et envoyer';

  @override
  String get booksDownloadPdfOnly => 'Télécharger le PDF uniquement';

  @override
  String get booksApproveInPurchases => 'Approuver dans Achats';

  @override
  String get booksRecordBill => 'Enregistrer la facture';

  @override
  String booksNewScheduleTitle(String id) {
    return 'Nouvelle planification · $id';
  }

  @override
  String booksEditScheduleTitle(String id) {
    return 'Modifier la planification · $id';
  }

  @override
  String get booksScheduleEditorSubtitle =>
      'Les écritures répétitives se comptabilisent seules avec un journal équilibré.';

  @override
  String get booksScheduleName => 'Nom de la planification';

  @override
  String get booksScheduleNameHint => 'ex. Loyer mensuel';

  @override
  String get booksDay => 'Jour';

  @override
  String get booksDayHint => 'ex. 1er';

  @override
  String get booksDebitAccountLabel => 'Compte de débit (charge / actif)';

  @override
  String get booksCreditAccountLabel =>
      'Compte de crédit (source de financement)';

  @override
  String get booksSelectAccount => 'Choisir un compte…';

  @override
  String get booksAccountsMustDiffer =>
      'Les comptes de débit et de crédit doivent être différents.';

  @override
  String get booksActive => 'Actif';

  @override
  String get booksPausedLabel => 'En pause';

  @override
  String get booksSaveSchedule => 'Enregistrer la planification';

  @override
  String get booksPaymentFailed => 'Échec du paiement';

  @override
  String booksInvoicePaidMessage(String amount, String who) {
    return '$who a payé $amount. La facture est marquée payée.';
  }

  @override
  String booksBillPartPaidMessage(String amount, String balance, String who) {
    return '$amount payé à $who. Il reste $balance à payer.';
  }

  @override
  String booksBillSettledMessage(String amount, String who) {
    return '$amount payé à $who. La facture est soldée.';
  }

  @override
  String get booksPayBill => 'Payer la facture';

  @override
  String booksAmountDue(String amount, String id, String who) {
    return '$id · $who · $amount dû';
  }

  @override
  String get booksDepositTo => 'Déposer sur';

  @override
  String get booksPayFrom => 'Payer depuis';

  @override
  String get booksAmountReceived => 'Montant reçu';

  @override
  String get booksPostsAs => 'Comptabilisé comme';

  @override
  String get booksBusinessFallback => 'Entreprise';

  @override
  String get booksInvoiceUpper => 'FACTURE';

  @override
  String get booksBillUpper => 'FACTURE FOURNISSEUR';

  @override
  String get booksBillTo => 'Facturer à';

  @override
  String get booksFrom => 'De';

  @override
  String get booksIssued => 'Émise le';

  @override
  String get booksDescription => 'Description';

  @override
  String get booksQty => 'Qté';

  @override
  String get booksItemOrService => 'Article ou service';

  @override
  String get booksItemOrServiceHint => 'Article ou service…';

  @override
  String booksBalancedEquation(String amount, String total) {
    return 'Équilibré · $total = $amount';
  }

  @override
  String get booksVat18 => 'TVA (18 %)';

  @override
  String get booksPillPosted => 'comptabilisée';

  @override
  String get booksPillPending => 'en attente';

  @override
  String get booksPillDraft => 'brouillon';

  @override
  String get booksTypeAsset => 'Actif';

  @override
  String get booksTypeLiability => 'Passif';

  @override
  String get booksTypeEquity => 'Capitaux propres';

  @override
  String get booksTypeIncome => 'Produit';

  @override
  String get booksTypeExpense => 'Charge';

  @override
  String get booksCodeInUse => 'Code déjà utilisé';

  @override
  String get booksPickDifferentCode => 'Choisissez un autre code de compte';

  @override
  String get booksAccountCreated => 'Compte créé';

  @override
  String get booksCouldNotCreateAccount => 'Impossible de créer le compte';

  @override
  String get booksNewAccount => 'Nouveau compte';

  @override
  String get booksAddLineToCoa => 'Ajoutez une ligne au plan comptable';

  @override
  String get booksAccountType => 'Type de compte';

  @override
  String get booksCode => 'Code';

  @override
  String get booksCodeHint => 'ex. 6060';

  @override
  String get booksCategoryHint => 'ex. Charges d\'exploitation';

  @override
  String get booksAccountName => 'Nom du compte';

  @override
  String get booksAccountNameHint => 'ex. Fournitures de bureau';

  @override
  String get booksCreating => 'Création…';

  @override
  String get booksCreateAccount => 'Créer le compte';

  @override
  String get booksDrShort => 'D';

  @override
  String get booksCrShort => 'C';

  @override
  String booksEntryMeta(String date, String ref, String source) {
    return '$date · $ref · via $source';
  }

  @override
  String booksBalancedDrCr(String cr, String dr) {
    return 'Équilibré · $dr = $cr';
  }

  @override
  String get booksApprovedPosted => 'Approuvée et comptabilisée';

  @override
  String get booksSentBackToDrafts => 'Renvoyée aux brouillons';

  @override
  String get booksReject => 'Rejeter';

  @override
  String get booksApprove => 'Approuver';

  @override
  String get booksSubmittedForApproval => 'Soumise pour approbation';

  @override
  String get booksSubmittedForApprovalBody =>
      'Débits et crédits sont égaux. Vérifiez et approuvez depuis l\'onglet Approbations pour comptabiliser au grand livre.';

  @override
  String get booksRecordExpenseSubtitle =>
      'Choisissez une catégorie et le moyen de paiement — Flipper passe une écriture équilibrée.';

  @override
  String get booksExpenseCategory => 'Catégorie de dépense';

  @override
  String get booksAddExpenseAccount => '+ Ajouter un compte de charge';

  @override
  String get booksPaidVia => 'Payé via';

  @override
  String get booksMemoDescription => 'Libellé / description';

  @override
  String get booksExpenseMemoHint => 'À quoi correspondait cette dépense ?';

  @override
  String get booksSubmitForApproval => 'Soumettre pour approbation';

  @override
  String get booksJournalPreview => 'Aperçu de l\'écriture';

  @override
  String booksBalancedAmount(String amount) {
    return 'Équilibré · $amount';
  }

  @override
  String get booksTplRecordSale => 'Enregistrer une vente';

  @override
  String get booksTplPayExpense => 'Payer une dépense';

  @override
  String get booksTplReceivePayment => 'Recevoir un paiement';

  @override
  String get booksTplPayBill => 'Payer une facture';

  @override
  String booksDraftKeptInDrafts(String ref) {
    return '$ref conservée dans Brouillons';
  }

  @override
  String get booksCouldNotSaveEntry => 'Impossible d\'enregistrer l\'écriture';

  @override
  String get booksQuickStart => 'Démarrage rapide';

  @override
  String get booksEntryMemoHint => 'À quoi sert cette écriture ?';

  @override
  String get booksLines => 'Lignes';

  @override
  String booksDebitCreditHint(String into, String out) {
    return 'Chaque écriture a deux côtés. Un montant qui $into sur un compte est un débit ; un montant qui $out est un crédit. Les deux totaux doivent être égaux.';
  }

  @override
  String get booksMoneyIntoWord => 'entre';

  @override
  String get booksMoneyOutWord => 'sort';

  @override
  String get booksComposerSubtitle =>
      'Choisissez les comptes et saisissez les montants — Flipper garde l\'équilibre.';

  @override
  String get booksAccountUpper => 'COMPTE';

  @override
  String get booksDebitUpper => 'DÉBIT';

  @override
  String get booksCreditUpper => 'CRÉDIT';

  @override
  String get booksBalanced => 'Équilibré';

  @override
  String get booksEnterAmounts => 'Saisissez les montants';

  @override
  String booksOffBy(String amount) {
    return 'Écart de $amount';
  }

  @override
  String get booksTotalDebits => 'Total des débits';

  @override
  String get booksTotalCredits => 'Total des crédits';

  @override
  String get booksSearchAccounts => 'Rechercher des comptes…';

  @override
  String get booksDataRefreshed => 'Données Books actualisées depuis le cloud';

  @override
  String booksActionFailed(String error) {
    return 'Échec de l\'action : $error';
  }

  @override
  String get booksAllCaughtUp => 'Tout est à jour';

  @override
  String get booksNotificationsMarkedRead =>
      'Notifications marquées comme lues';

  @override
  String get booksSearchPlaceholder =>
      'Rechercher écritures, comptes, factures…';

  @override
  String get booksFiscalPeriod => 'Période fiscale';

  @override
  String get booksPeriodChanged => 'Période modifiée';

  @override
  String booksFiscalPeriodYear(String year) {
    return 'Période fiscale $year';
  }

  @override
  String get booksNotifications => 'Notifications';

  @override
  String get booksMarkAllRead => 'Tout marquer comme lu';

  @override
  String get booksEntriesAwaitingApprovalTitle =>
      'Écritures en attente d\'approbation';

  @override
  String get booksReviewPendingPostings =>
      'Vérifiez les écritures en partie double en attente';

  @override
  String get booksNoNewNotifications => 'Aucune nouvelle notification';

  @override
  String get booksNoPendingEntries => 'Aucune écriture en attente';

  @override
  String get booksTabSnapshot => 'Aperçu';

  @override
  String get booksTabApprovals => 'Approbations';

  @override
  String booksCouldNotRestoreBusiness(String error) {
    return 'Impossible de restaurer le contexte de l\'entreprise : $error';
  }

  @override
  String get webHomeNavPlatform => 'Plateforme';

  @override
  String get webHomeNavFeatures => 'Fonctionnalités';

  @override
  String get webHomeLogIn => 'Se connecter';

  @override
  String get webHomeStartFree => 'Commencer gratuitement';

  @override
  String get webHomeHeroLine1 => 'La comptabilité';

  @override
  String get webHomeHeroLine2Lead => 'qui';

  @override
  String get webHomeHeroLine2Accent => 'se fait toute seule.';

  @override
  String get webHomeHeroBody =>
      'Flipper Books est la comptabilité moderne des entreprises en croissance. Chaque vente de Flipper POS arrive directement dans votre grand livre — et Flow AI classe, rapproche et déclare le reste. Vous, vous gérez votre entreprise.';

  @override
  String get webHomeSeeHowItWorks => 'Voir comment ça marche';

  @override
  String get webHomeCheckEbmReady => 'Prêt pour RRA / EBM';

  @override
  String get webHomeCheckOffline => 'Fonctionne hors ligne';

  @override
  String get webHomeCheckRwf => 'Pensé pour le RWF';

  @override
  String get webHomeTrustTagline =>
      'Conçu pour les entreprises du monde entier — et pour la façon dont l\'argent circule vraiment.';

  @override
  String get webHomeTrustTaxIntegration => 'intégration fiscale';

  @override
  String get webHomeTrustBusinesses => 'entreprises';

  @override
  String get webHomeTrustMomoBank => 'Synchro MoMo et banque';

  @override
  String get webHomeTrustRealtimeLedger => 'Grand livre en temps réel';

  @override
  String get webHomeSuiteEyebrow => 'Une seule plateforme';

  @override
  String get webHomeSuiteTitle =>
      'Trois applications. Un grand livre. Zéro double saisie.';

  @override
  String get webHomeSuiteBody =>
      'Flipper POS, Books et Flow ne sont pas des intégrations assemblées tant bien que mal — c\'est un seul système. L\'argent n\'y passe qu\'une fois et vos comptes restent clôturés.';

  @override
  String get webHomeLoopSellOnPos => 'Vendez sur le POS →';

  @override
  String get webHomeLoopPostsToBooks => 'comptabilisé dans Books';

  @override
  String get webHomeLoopFlowReconciles => 'Flow rapproche';

  @override
  String get webHomeLoopTail =>
      '→ vous voyez le bénéfice en temps réel. Une boucle, entièrement automatique.';

  @override
  String get webHomePosRole => 'Vendre';

  @override
  String get webHomePosTagline => 'Le comptoir';

  @override
  String get webHomePosBody =>
      'Encaissez sur mobile ou ordinateur, scannez le stock, acceptez espèces ou MoMo. Fonctionne dès l\'ouverture de la boutique — en ligne ou hors ligne.';

  @override
  String get webHomeBooksRole => 'Comptabiliser';

  @override
  String get webHomeBooksTagline => 'La source de vérité';

  @override
  String get webHomeBooksBody =>
      'Chaque vente devient une écriture équilibrée. Compte de résultat, trésorerie, créances et taxes prêtes pour l\'EBM en temps réel — sans tableur ni rush de fin de mois.';

  @override
  String get webHomeFlowRole => 'Automatiser';

  @override
  String get webHomeFlowTagline => 'Le comptable IA';

  @override
  String get webHomeFlowBody =>
      'Flow surveille tout le flux — classement, rapprochement, détection des anomalies et préparation des taxes. Le travail qui prenait une semaine à un comptable se fait en temps réel.';

  @override
  String get webHomeMeetFlow => 'Découvrez Flow AI';

  @override
  String get webHomeFlowHeadlineLead => 'Votre comptabilité, tenue par un';

  @override
  String get webHomeFlowHeadlineAccent => 'comptable IA.';

  @override
  String get webHomeFlowLead =>
      'Flow transforme les transactions brutes en une comptabilité propre et prête pour l\'audit — et ne vous sollicite que lorsqu\'une décision est vraiment nécessaire. Dormez tranquille, sans corvées comptables.';

  @override
  String get webHomeFlowAutoCat => 'Catégorisation automatique';

  @override
  String get webHomeFlowAutoCatBody =>
      'Chaque vente, dépense et virement est affecté au bon compte à l\'instant même.';

  @override
  String get webHomeFlowRecon => 'Rapprochement banque et MoMo';

  @override
  String get webHomeFlowReconBody =>
      'Flow rapproche automatiquement votre grand livre des relevés et ne signale que les vraies anomalies.';

  @override
  String get webHomeFlowTax => 'Taxes et TVA, préparées';

  @override
  String get webHomeFlowTaxBody =>
      'Des déclarations prêtes pour l\'EBM rédigées depuis votre grand livre, pour que les échéances RRA ne soient plus une panique.';

  @override
  String get webHomeFlowAnomaly => 'Alertes d\'anomalies';

  @override
  String get webHomeFlowAnomalyBody =>
      'Doublons, baisses de marge et dépenses inhabituelles sont signalés avant de devenir un problème.';

  @override
  String get webHomeExploreFlow => 'Découvrir Flow AI';

  @override
  String get webHomeWatchingLedger => 'Surveille votre grand livre';

  @override
  String get webHomeChatUser1 =>
      'Une nouvelle vente de 12 000 RWF est arrivée sur le POS, payée par MoMo. Enregistre-la.';

  @override
  String get webHomeChatBot1 =>
      'C\'est fait — écriture équilibrée passée et rapprochée de votre compte MTN MoMo. Voici l\'écriture :';

  @override
  String get webHomeChatUser2 => 'Quelque chose à vérifier cette semaine ?';

  @override
  String get webHomeChatBot2 =>
      'La TVA de mai est prête à être déclarée (318 400 RWF) et un fournisseur a été payé deux fois — je l\'ai signalé dans les dettes.';

  @override
  String get webHomeCapMultiBranch => 'Multi-succursales';

  @override
  String get webHomeCapStatementsBody =>
      'Compte de résultat, bilan et flux de trésorerie générés en direct depuis votre grand livre.';

  @override
  String get webHomeCapBankRecBody =>
      'Rapprochez les lignes du grand livre des relevés bancaires et MoMo en une seule passe, avec les écarts mis en évidence.';

  @override
  String get webHomeCapArAp => 'Créances et dettes';

  @override
  String get webHomeCapArApBody =>
      'Suivez qui vous doit et ce que vous devez, avec des tranches d\'ancienneté et des relances automatiques.';

  @override
  String get webHomeCapTaxBody =>
      'Intégration EBM 2.1 et TVA calculée en continu — déclarations préparées avant l\'échéance.';

  @override
  String get webHomeCapCoaBody =>
      'Une structure de grand livre numérotée et adaptée à l\'audit, qui s\'ajuste à l\'organisation de votre entreprise.';

  @override
  String get webHomeCapMultiBranchBody =>
      'Consolidez toutes vos boutiques dans une seule comptabilité, puis examinez chaque succursale séparément.';

  @override
  String get webHomeInsideBooks => 'DANS BOOKS';

  @override
  String get webHomeCapTitle => 'Tout ce que fait un comptable — intégré.';

  @override
  String get webHomeCapBody =>
      'Une comptabilité en partie double assez sérieuse pour votre auditeur et assez simple pour la tenir vous-même.';

  @override
  String get webHomePricingEyebrow => 'TARIFS';

  @override
  String get webHomePricingBody =>
      'Choisissez le forfait qui vous convient. Chaque forfait inclut toute la suite Flipper — POS, Books et Flow.';

  @override
  String get webHomeContactSales => 'Contacter les ventes';

  @override
  String get webHomeBandTitle =>
      'Votre boutique, votre comptabilité, au même endroit.';

  @override
  String get webHomeBandBody =>
      'Commencez à vendre sur Flipper dès aujourd\'hui et laissez Flow tenir vos comptes — automatiquement, en temps réel. Reprenez là où vous vous étiez arrêté.';

  @override
  String get webHomeTalkToSales => 'Parler aux ventes';

  @override
  String get webHomeStatProcessedMonthly => 'traités chaque mois';

  @override
  String get webHomeStatUptime => 'disponibilité';

  @override
  String get webHomeRevenueThisWeek => 'Revenus · cette semaine';

  @override
  String get webHomeNewSale => 'Nouvelle vente';

  @override
  String webHomeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String get webHomeSalesStreak => 'Série de ventes';

  @override
  String get webHomeFooterTagline =>
      'La plateforme d\'entreprise connectée pour l\'Afrique — caisse, comptabilité et comptable IA, au même endroit.';

  @override
  String get webHomeCopyright =>
      '© 2026 Flipper. Conçu pour les entreprises du monde entier.';

  @override
  String get webHomePrivacy => 'Confidentialité';

  @override
  String get webHomeTerms => 'Conditions';

  @override
  String get webHomeFooterPlatform => 'PLATEFORME';

  @override
  String get webHomeFooterCompany => 'ENTREPRISE';

  @override
  String get webHomeFooterSupport => 'ASSISTANCE';

  @override
  String get webHomeAbout => 'À propos';

  @override
  String get webHomeBlog => 'Blog';

  @override
  String get webHomeCareers => 'Carrières';

  @override
  String get webHomeContact => 'Contact';

  @override
  String get webHomeHelpCenter => 'Centre d\'aide';

  @override
  String get webHomeDownload => 'Télécharger';

  @override
  String get webHomeStatus => 'Statut';

  @override
  String get webHomeCommunity => 'Communauté';

  @override
  String get webHomePoweredBy => 'Flipper Books · propulsé par';

  @override
  String get webHomeMostPopular => 'Le plus populaire';

  @override
  String get webHomeSwitchToLight => 'Passer en mode clair';

  @override
  String get webHomeSwitchToDark => 'Passer en mode sombre';

  @override
  String get webHomeLightMode => 'Mode clair';

  @override
  String get webHomeDarkMode => 'Mode sombre';

  @override
  String get webHomeMockFinancialOverview => 'VUE FINANCIÈRE';

  @override
  String get webHomeMockCashOnHand => 'Trésorerie disponible';

  @override
  String get webHomeMockRevenueTrend => 'Évolution des revenus';

  @override
  String get webHomeMockLast8Months => '8 derniers mois';

  @override
  String get webHomeMockCostOfSales => 'Coût des ventes';

  @override
  String get webHomeMockOperatingExp => 'Charges d\'expl.';

  @override
  String get webHomeMockAutoPosted => 'COMPTABILISÉ AUTO';

  @override
  String webHomeMockToast(String account, String pos) {
    return 'Nouvelle vente sur $pos — classée dans $account et rapprochée de MoMo.';
  }

  @override
  String get webHomeMockSalesRevenue => 'Ventes';

  @override
  String get webHomeMockBalancedSuffix => '· équilibrée';

  @override
  String get webHomeMockPending => '● EN ATTENTE';

  @override
  String get webHomeMockSearchOrScan => 'Rechercher ou scanner…';

  @override
  String webHomeMockLeft(String count) {
    return '$count restants';
  }

  @override
  String get webAppsFinance => 'Finance';

  @override
  String get webAppsSell => 'Vendre';

  @override
  String get webAppsEverything => 'Tout votre commerce';

  @override
  String webAppsComingSoon(String app) {
    return '$app — bientôt disponible';
  }

  @override
  String get webBillingInvalidMomo =>
      'Saisissez un numéro Mobile Money valide, ex. 0788123456.';

  @override
  String get webBillingPreparing => 'Préparation de votre abonnement…';

  @override
  String webBillingCouldNotSave(String error) {
    return 'Impossible d\'enregistrer l\'abonnement : $error';
  }

  @override
  String get webBillingNoPlanIdCharge =>
      'Cet abonnement n\'a pas encore d\'identifiant de forfait et ne peut donc pas être débité en toute sécurité. Rechargez et réessayez.';

  @override
  String get webBillingNoPlanIdPay =>
      'Cet abonnement n\'a pas encore d\'identifiant de forfait et ne peut donc pas être payé en toute sécurité. Rechargez et réessayez.';

  @override
  String get webBillingSendingRequest =>
      'Envoi de la demande sur votre téléphone…';

  @override
  String get webBillingApproveOnPhone =>
      'Approuvez la demande Mobile Money sur votre téléphone.';

  @override
  String webBillingCouldNotStart(String error) {
    return 'Le paiement n\'a pas pu être lancé : $error';
  }

  @override
  String get webBillingConsentDeclined =>
      'Le consentement Mobile Money a été refusé, rien n\'a donc été débité.';

  @override
  String get webBillingCouldNotStartPlain =>
      'Le paiement n\'a pas pu être lancé.';

  @override
  String get webBillingNoReference =>
      'La passerelle a accepté le paiement mais n\'a renvoyé aucune référence pour le suivre. Vérifiez votre téléphone puis réessayez.';

  @override
  String get webBillingPaymentReceived =>
      'Paiement reçu. Votre abonnement est actif.';

  @override
  String get webBillingNotCompletedOnPhone =>
      'Le paiement n\'a pas été finalisé sur votre téléphone.';

  @override
  String get webBillingMomoNoVerdict =>
      'Mobile Money n\'a pas encore répondu. Si vous avez approuvé la demande, Books s\'ouvrira sous peu — revérifiez dans un instant.';

  @override
  String get webBillingCardNeedsEmail =>
      'Le paiement par carte nécessite une adresse e-mail pour le reçu.';

  @override
  String get webBillingOpeningPaymentPage =>
      'Ouverture de la page de paiement…';

  @override
  String webBillingCardCouldNotStart(String error) {
    return 'Le paiement par carte n\'a pas pu être lancé : $error';
  }

  @override
  String get webBillingAlreadyActive => 'Cet abonnement est déjà actif.';

  @override
  String get webBillingCouldNotOpenCardPage =>
      'Impossible d\'ouvrir la page de paiement par carte dans ce navigateur.';

  @override
  String get webBillingSubscriptionEnded =>
      'Cet abonnement est terminé. Choisissez un forfait pour recommencer.';

  @override
  String get webBillingFinishOnOpenedPage =>
      'Finalisez le paiement sur la page qui vient de s\'ouvrir. Books se débloque ici dès que la carte est débitée.';

  @override
  String get webBillingCheckingCard =>
      'Vérification de votre paiement par carte…';

  @override
  String webBillingCouldNotCheckCard(String error) {
    return 'Impossible de vérifier le paiement par carte : $error';
  }

  @override
  String get webBillingCardDeclined =>
      'La carte a été refusée. Rouvrez la page de paiement pour utiliser une autre carte.';

  @override
  String get webBillingCardNoVerdict =>
      'Nous n\'avons pas encore de retour sur le paiement par carte. Si vous l\'avez finalisé, Books s\'ouvrira sous peu — revérifiez dans un instant.';

  @override
  String get webBillingCheckingSubscription =>
      'Vérification de votre abonnement…';

  @override
  String get webBillingEnded => 'Votre abonnement est terminé';

  @override
  String get webBillingNeedsSubscription =>
      'Flipper Books nécessite un abonnement';

  @override
  String get webBillingEndedBody =>
      'Rien n\'a été supprimé — votre comptabilité, vos ventes et votre stock sont toujours là. Renouvelez l\'abonnement pour y accéder à nouveau.';

  @override
  String get webBillingNeedsBody =>
      'Un seul abonnement couvre cette entreprise sur le web, le téléphone et l\'application de bureau. Payez une fois et Flipper s\'ouvre partout où vous l\'utilisez.';

  @override
  String get webBillingAwaitingSettlement =>
      'Un paiement est déjà en cours. Si vous l\'avez approuvé sur votre téléphone, l\'accès se débloque dès que Mobile Money le confirme.';

  @override
  String get webBillingRenewNow => 'Renouveler';

  @override
  String get webBillingChoosePlan => 'Choisir un forfait';

  @override
  String get webBillingSwitchBusiness => 'Changer d\'entreprise';

  @override
  String get webBillingLoadingBusiness => 'Chargement de votre entreprise…';

  @override
  String get webBillingPickBusiness =>
      'Choisissez l\'entreprise pour laquelle vous payez, puis les forfaits et leurs prix s\'afficheront ici.';

  @override
  String get webBillingChooseBusiness => 'Choisir une entreprise';

  @override
  String get webBillingRenewTitle => 'Renouveler votre abonnement';

  @override
  String get webBillingSubscribe => 'S\'abonner';

  @override
  String get webBillingTestBadge => 'TEST';

  @override
  String get webBillingOneMoment => 'Un instant…';

  @override
  String get webBillingIntroSubtitle =>
      'Un seul abonnement ouvre cette entreprise sur le web, le téléphone et l\'application de bureau.';

  @override
  String get webBillingActiveReady =>
      'Votre abonnement est actif. Books est prêt à s\'ouvrir.';

  @override
  String get webBillingLoadingPlans => 'Chargement des forfaits…';

  @override
  String webBillingCouldNotLoadPlans(String error) {
    return 'Impossible de charger les forfaits : $error';
  }

  @override
  String get webBillingTryAgain => 'Réessayer';

  @override
  String get webBillingNoPlans =>
      'Aucun forfait n\'est en vente pour le moment.';

  @override
  String get webBillingPlan => 'Forfait';

  @override
  String get webBillingAddons => 'Options';

  @override
  String get webBillingPayWith => 'Payer avec';

  @override
  String get webBillingContinueToCard => 'Continuer vers le paiement par carte';

  @override
  String webBillingPayAmount(String amount) {
    return 'Payer $amount RWF';
  }

  @override
  String get webBillingWaitingApproval => 'En attente de votre approbation…';

  @override
  String get webBillingWaitingCard => 'En attente du paiement par carte…';

  @override
  String get webBillingPreparingShort => 'Préparation…';

  @override
  String get webBillingCheckAgain => 'Vérifier à nouveau';

  @override
  String get webBillingStartOver => 'Recommencer';

  @override
  String get webBillingOpenBooks => 'Ouvrir Books';

  @override
  String get webPayNotAuthorised =>
      'Ce compte n\'est pas autorisé pour les paiements du personnel.';

  @override
  String get webPayEnterAmount => 'Saisissez le montant convenu en RWF.';

  @override
  String get webPayStarting => 'Lancement du paiement…';

  @override
  String webPayCouldNotStart(String error) {
    return 'Impossible de lancer le paiement : $error';
  }

  @override
  String get webPayNoPaymentYetCard =>
      'Aucun paiement pour l\'instant. Renvoyez le lien ou vérifiez la référence plus tard — un paiement effectué après la fermeture compte quand même.';

  @override
  String get webPayNoApprovalYet =>
      'Pas encore d\'approbation. Le client peut encore approuver ; vérifiez la référence plus tard ou recommencez.';

  @override
  String get webPayPaidActive =>
      'Payé. Le forfait est actif et le prix négocié est désormais son prix récurrent.';

  @override
  String get webPayDidNotGoThrough => 'Le paiement n\'a pas abouti.';

  @override
  String get webPayLinkExpired =>
      'Le lien de paiement a expiré avant d\'être payé.';

  @override
  String get webPayAskCustomerApprove =>
      'Demandez au client d\'approuver la demande Mobile Money sur son téléphone.';

  @override
  String get webPaySendLink =>
      'Envoyez le lien de paiement au client et attendez qu\'il paie.';

  @override
  String get webPayWaitingSettle => 'En attente du règlement du paiement…';

  @override
  String get webPayTitle => 'Paiement personnalisé';

  @override
  String get webPayCheckingAccess => 'Vérification de l\'accès…';

  @override
  String webPayCouldNotCheckAccess(String error) {
    return 'Impossible de vérifier l\'accès du personnel : $error';
  }

  @override
  String get webPayStaffOnlyBody =>
      'Cette page est réservée au personnel de facturation. Demandez à un administrateur de vous ajouter à la liste.';

  @override
  String get webPayPerYear => '/an';

  @override
  String get webPayPerMonth => '/mois';

  @override
  String get webPayNegotiatedPrice => 'Prix négocié';

  @override
  String get webPayNegotiatedBody =>
      'Facturez le montant convenu avec le client. Il devient son prix récurrent et l\'ancienne facturation s\'arrête.';

  @override
  String webPaySignedInAs(String name) {
    return 'Connecté en tant que $name.';
  }

  @override
  String get webPaySearchHint =>
      'Rechercher par nom, téléphone, e-mail ou identifiant';

  @override
  String get webPayAgreedAmount => 'Montant convenu';

  @override
  String get webPayAmountHint => 'Montant en RWF par période';

  @override
  String get webPayCustomerPaysWith => 'Le client paie avec';

  @override
  String get webPayLinkCopied => 'Lien copié';

  @override
  String get webPayNoteHint => 'Note pour le dossier (facultatif)';

  @override
  String get webPayNotSelected => 'Non sélectionné';

  @override
  String get webPayBillingPeriod => 'Période de facturation';

  @override
  String get webPayPaysWith => 'Paie avec';

  @override
  String get webPayCard => 'Carte';

  @override
  String get webPayPricePerPeriod => 'Prix par période';

  @override
  String get webPayChargedNow => 'Débité maintenant, puis à chaque période';

  @override
  String get webPayCreateCardLink => 'Créer un lien de paiement par carte';

  @override
  String webPayChargeByMomo(String amount) {
    return 'Débiter $amount RWF par Mobile Money';
  }

  @override
  String get webPayWaitingCustomerApproval =>
      'En attente de l\'approbation du client…';

  @override
  String get webPayStartingShort => 'Lancement…';

  @override
  String get webPayConfirmTitle => 'Débiter cette entreprise ?';

  @override
  String webPayConfirmSummary(String amount, String cadence, String rail) {
    return '$amount RWF · $cadence · $rail';
  }

  @override
  String get webPayConfirmBodyMomo =>
      'Ce prix devient récurrent. Tout abonnement par carte existant est annulé immédiatement.';

  @override
  String get webPayConfirmBodyCard =>
      'Ce prix devient récurrent. Tout abonnement par carte existant est annulé immédiatement et son mandat Mobile Money est révoqué.';

  @override
  String get webPayCharge => 'Débiter';

  @override
  String get webPayStaffOnly => 'Réservé au personnel';

  @override
  String get webPayBackToBooks => 'Retour à Books';

  @override
  String get webPaySearching => 'Recherche…';

  @override
  String webPaySearchFailed(String error) {
    return 'Échec de la recherche : $error';
  }

  @override
  String webPayNoBusinessMatches(String query) {
    return 'Aucune entreprise ne correspond à « $query ».';
  }

  @override
  String get webPayChange => 'Modifier';

  @override
  String get webPayCopyLink => 'Copier le lien';

  @override
  String get webPayOpen => 'Ouvrir';

  @override
  String webPayExistingPayment(String id, String status) {
    return 'Le paiement existant $id est $status';
  }

  @override
  String webPayLinkSuffix(String link) {
    return 'lien : $link';
  }

  @override
  String get webPayReference => 'Référence';

  @override
  String get webPayRail => 'Moyen';

  @override
  String get webPayPaidThrough => 'Payé jusqu\'au';

  @override
  String get webPayMomoCharge => 'Débit MoMo';

  @override
  String get webPayMtnTransaction => 'Transaction MTN';

  @override
  String get webPayDodoSubscription => 'Abonnement Dodo';

  @override
  String get webPayDodoPayment => 'Paiement Dodo';

  @override
  String get webPayCancelledCardSub => 'Abonnement carte annulé';

  @override
  String get webPayRevokedMandate => 'Mandat MoMo révoqué';

  @override
  String get webPayPaid => 'Payé';

  @override
  String get webPaySettledBody =>
      'Le montant négocié est désormais le prix récurrent de cette entreprise. Conservez la référence ci-dessous pour l\'assistance.';

  @override
  String get webPayCopyAllIds => 'Copier tous les identifiants';

  @override
  String get webPayCopied => 'Copié';

  @override
  String get webPayNewPayment => 'Nouveau paiement';

  @override
  String get webPinTooShort => 'Le PIN doit comporter au moins 4 chiffres';

  @override
  String get webPinInvalid => 'PIN invalide. Veuillez réessayer.';

  @override
  String get webPinOtpRequired => 'Le code OTP est requis';

  @override
  String get webPinAuthCodeRequired => 'Le code d\'authentification est requis';

  @override
  String get webPinOtpInvalid => 'Code OTP invalide. Veuillez réessayer.';

  @override
  String get webPinAuthCodeInvalid =>
      'Code d\'authentification invalide. Veuillez réessayer.';

  @override
  String get webPinTroubleTitle => 'Problème de connexion ?';

  @override
  String get webPinTroubleBody =>
      'Si vous avez oublié votre PIN, contactez l\'administrateur de votre compte ou l\'assistance Flipper.';

  @override
  String get webPinVerifyIdentity => 'Vérifiez votre identité';

  @override
  String get webPinEnterSmsCode =>
      'Saisissez le code que nous vous avons envoyé pour continuer.';

  @override
  String get webPinEnterAuthCode =>
      'Saisissez le code de votre application d\'authentification pour continuer.';

  @override
  String get webPinEnterPinSubtitle =>
      'Saisissez votre PIN pour gérer votre entreprise en toute sécurité.';

  @override
  String get webPinSignedIn => 'Connecté ✓';

  @override
  String get webPinVerifying => 'Vérification…';

  @override
  String get webPinVerify => 'Vérifier';

  @override
  String get webPinSignIn => 'Se connecter';

  @override
  String get webPinNoAccountSignUp => 'Pas de compte ? Inscrivez-vous';

  @override
  String get webPinHide => 'Masquer';

  @override
  String get webPinShow => 'Afficher';

  @override
  String get webPinAuthenticator => 'Authentificateur';

  @override
  String get webPinSmsEmail => 'SMS / E-mail';

  @override
  String get webPinAuthenticatorCode => 'Code d\'authentification';

  @override
  String get webPinSmsEmailCode => 'Code SMS / e-mail';

  @override
  String get webSignupTypeRetailer => 'Commerçant Flipper';

  @override
  String get webSignupTypeIndividual => 'Particulier';

  @override
  String get webSignupTypeEnterprise => 'Entreprise';

  @override
  String get webSignupUsernameCheckError =>
      'Erreur lors de la vérification du nom d\'utilisateur';

  @override
  String get webSignupNoTinData => 'Aucune donnée trouvée pour ce TIN';

  @override
  String get webSignupEnterContactFirst =>
      'Saisissez d\'abord un numéro de téléphone ou un e-mail.';

  @override
  String get webSignupFailedToSendCode => 'Échec de l\'envoi du code.';

  @override
  String get webSignupWrongCode => 'Ce code est incorrect. Veuillez réessayer.';

  @override
  String get webSignupCouldNotCheckCode => 'Impossible de vérifier ce code.';

  @override
  String get webSignupUsernameRequired => 'Le nom d\'utilisateur est requis';

  @override
  String get webSignupUsernameTooShort =>
      'Le nom d\'utilisateur doit comporter au moins 4 caractères';

  @override
  String get webSignupEnterFullName => 'Veuillez saisir votre nom complet';

  @override
  String get webSignupSelectBusinessType =>
      'Veuillez choisir un type d\'entreprise';

  @override
  String get webSignupInvalidTin =>
      'Veuillez saisir un numéro TIN valide (au moins 9 caractères)';

  @override
  String get webSignupSelectCountry => 'Veuillez choisir un pays';

  @override
  String webSignupEnterCodeSentTo(String contact) {
    return 'Saisissez le code envoyé à $contact pour continuer.';
  }

  @override
  String webSignupVerifyFirst(String contact) {
    return 'Vérifiez d\'abord $contact — touchez « Envoyer le code ».';
  }

  @override
  String get webSignupUsernameTaken =>
      'Ce nom d\'utilisateur n\'est pas disponible. Veuillez en choisir un autre.';

  @override
  String get webSignupUsernameCheckRetry =>
      'Erreur lors de la vérification du nom d\'utilisateur. Veuillez réessayer.';

  @override
  String get webSignupFillRequired =>
      'Veuillez remplir correctement tous les champs obligatoires';

  @override
  String get webSignupNetworkError =>
      'Erreur réseau. Vérifiez votre connexion et réessayez.';

  @override
  String get webSignupTimeout =>
      'La requête a expiré. Veuillez réessayer plus tard.';

  @override
  String webSignupFailedCreate(String error) {
    return 'Échec de la création du compte : $error';
  }

  @override
  String get webSignupDismiss => 'Fermer';

  @override
  String get webSignupBusinessSetup => 'Configuration de l\'entreprise';

  @override
  String get webSignupSubtitle =>
      'Configurez votre compte d\'entreprise Flipper pour commencer.';

  @override
  String get webSignupUsername => 'Nom d\'utilisateur';

  @override
  String get webSignupFullName => 'Nom complet';

  @override
  String get webSignupFullNameHint => 'Saisissez votre nom complet';

  @override
  String get webSignupFullNameRequired => 'Le nom complet est requis';

  @override
  String get webSignupPhoneEmail => 'Téléphone / E-mail';

  @override
  String get webSignupUsage => 'Utilisation';

  @override
  String get webSignupUsageHint => 'Comment vous comptez utiliser Flipper';

  @override
  String webSignupTinBusiness(String name) {
    return 'Entreprise : $name';
  }

  @override
  String get webSignupTinUnavailable =>
      'Recherche TIN indisponible — validation ignorée.';

  @override
  String get webSignupCountry => 'Pays';

  @override
  String get webSignupAlreadyHaveAccount =>
      'Vous avez déjà un compte ? Connectez-vous';

  @override
  String get webSignupChooseDifferentUsername =>
      'Veuillez choisir un autre nom d\'utilisateur. Celui-ci n\'est pas disponible ou n\'a pas été vérifié.';

  @override
  String get webSignupAccountCreated => 'Compte créé avec succès !';

  @override
  String get webSignupFailedTryAgain =>
      'Échec de la création du compte. Veuillez réessayer.';

  @override
  String get webSignupUsernameNotAvailable => 'Nom d\'utilisateur indisponible';

  @override
  String get webSignupUsernameHint => 'Saisissez votre nom d\'utilisateur';

  @override
  String get webSignupContactRequired =>
      'Le numéro de téléphone ou l\'e-mail est requis';

  @override
  String get webSignupInvalidEmail =>
      'Veuillez saisir une adresse e-mail valide';

  @override
  String get webSignupInvalidPhone =>
      'Veuillez saisir un numéro de téléphone valide';

  @override
  String get webSignupContactHint => '783054874 ou votre@email.com';

  @override
  String get webSignupResend => 'Renvoyer';

  @override
  String get webSignupSendCode => 'Envoyer le code';

  @override
  String webSignupContactVerified(String contact) {
    return '$contact vérifié.';
  }

  @override
  String get webSignupVerificationCode => 'Code de vérification';

  @override
  String get webSignupEnter6Digit => 'Saisissez le code à 6 chiffres';

  @override
  String webSignupCodeSentHint(String contact) {
    return 'Nous avons envoyé un code à $contact.';
  }

  @override
  String webSignupCodeSentTo(String contact) {
    return 'Code envoyé à $contact';
  }

  @override
  String get webSignupEnterTin => 'Saisissez le numéro TIN';

  @override
  String get webSignupTinRequired => 'Le numéro TIN est requis';

  @override
  String get webSignupTinTooShort =>
      'Le numéro TIN doit comporter au moins 9 chiffres';

  @override
  String get webSignupPickCountryFromList =>
      'Veuillez choisir un pays dans la liste';

  @override
  String get webSignupSearchCountry => 'Recherchez votre pays';

  @override
  String get webSignupCreateYourAccount => 'Créez votre compte';

  @override
  String get webAuthSecuredE2e => 'Sécurisé par chiffrement de bout en bout';

  @override
  String webAuthVerifiedOpening(String target) {
    return 'Vérifié — ouverture de $target…';
  }

  @override
  String get webAuthYourBusiness => 'votre entreprise';

  @override
  String get webAuthBrandTitle =>
      'Votre boutique, votre équipe, vos chiffres — au même endroit.';

  @override
  String get webAuthBrandBody =>
      'Reprenez là où vous vous étiez arrêté. Les ventes, le stock et les rapports du jour sont prêts.';

  @override
  String webAuthErrorCheckingPrefs(String error) {
    return 'Erreur lors de la vérification des préférences : $error';
  }

  @override
  String get webBizNoBusinesses => 'Aucune entreprise disponible';

  @override
  String get webBizChooseBusiness => 'Choisissez une entreprise';

  @override
  String get webBizChooseBusinessSubtitle =>
      'Sélectionnez l\'entreprise que vous voulez gérer.';

  @override
  String get webBizNotSeeing =>
      'Vous ne voyez pas votre entreprise ? Demandez au propriétaire de vous inviter.';

  @override
  String get webBizChooseBranch => 'Choisissez une succursale';

  @override
  String get webBizChooseBranchSubtitle =>
      'Sélectionnez la succursale à laquelle accéder';

  @override
  String get webBizCouldNotSet =>
      'Impossible de définir l\'entreprise. Veuillez réessayer.';

  @override
  String get webBizProfileLoadFailed =>
      'Impossible de charger votre profil. Cela peut arriver si le réseau est indisponible ou si votre session a expiré.';

  @override
  String get webBizBackToLogin => 'Retour à la connexion';

  @override
  String get webBizUser => 'Utilisateur';

  @override
  String webBizOwnerBranches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Propriétaire · $count succursales',
      one: 'Propriétaire · 1 succursale',
    );
    return '$_temp0';
  }

  @override
  String webBizMemberBranches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Membre · $count succursales',
      one: 'Membre · 1 succursale',
    );
    return '$_temp0';
  }

  @override
  String get webBizSigningOut => 'Déconnexion…';

  @override
  String get webBizDefault => 'PAR DÉFAUT';

  @override
  String get webBizAddBusiness => 'Ajouter une entreprise';

  @override
  String get webAuthPinNotFound => 'PIN introuvable';

  @override
  String get webAuthAccessDenied =>
      'Accès refusé — vérifiez l\'authentification';

  @override
  String webAuthInvalidPinCode(String code) {
    return 'PIN invalide ($code)';
  }

  @override
  String get webAuthNetworkFailed =>
      'Échec de la connexion réseau. Vérifiez votre connexion internet.';

  @override
  String get webAuthTimedOut => 'La requête a expiré. Veuillez réessayer.';

  @override
  String get webAuthOtpNotFound => 'Code OTP introuvable';

  @override
  String get webAuthInvalidOtp => 'Code OTP invalide';

  @override
  String get webAuthTotpNotFound => 'Code d\'authentification introuvable';

  @override
  String get webAuthInvalidTotp => 'Code d\'authentification invalide';

  @override
  String webSignupRegistrationFailedStatus(String code) {
    return 'Échec de l\'inscription, code d\'état : $code';
  }

  @override
  String get webSignupNetworkConnect =>
      'Erreur réseau : impossible de joindre le serveur. Vérifiez votre connexion internet.';

  @override
  String get webSignupServerSlow =>
      'La requête a expiré. Le serveur met trop de temps à répondre. Veuillez réessayer plus tard.';

  @override
  String get webSignupNetworkIncomplete =>
      'Erreur réseau : impossible de terminer la requête. Veuillez réessayer plus tard.';

  @override
  String webSignupRegistrationFailed(String error) {
    return 'Échec de l\'inscription : $error';
  }

  @override
  String get webSignupNetworkSendCode =>
      'Erreur réseau lors de l\'envoi du code. Veuillez réessayer.';

  @override
  String get webSignupContactExists => 'Ce contact existe déjà';

  @override
  String get webSignupSendOtpFailed =>
      'Échec de l\'envoi du code d\'inscription';

  @override
  String get webSignupNetworkCheckCode =>
      'Erreur réseau lors de la vérification du code. Veuillez réessayer.';
}
