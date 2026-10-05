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
}
