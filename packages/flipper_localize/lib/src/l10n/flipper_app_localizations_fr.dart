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
  String get error => 'Error';

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
    return 'Payment: $paymentType';
  }

  @override
  String get digitalReceipt => 'Digital Receipt';

  @override
  String get needDigitalReceipt => 'Do you need a digital receipt?';

  @override
  String get purchaseCode => 'Purchase Code';

  @override
  String get pleaseEnterPurchaseCode => 'Please enter a purchase code';

  @override
  String get submit => 'Submit';

  @override
  String get done => 'Done';

  @override
  String get receipt => 'Receipt';

  @override
  String get addNote => 'Add Note';

  @override
  String get generatingReceiptWait =>
      'Please wait we are generating the receipt';

  @override
  String get poweredBy => 'Powered By';

  @override
  String get returnToHome => 'Return to Home';

  @override
  String get personalGoals => 'Personal goals';

  @override
  String get selectBranchToManageGoals => 'Select a branch to manage goals.';

  @override
  String couldNotLoadGoals(Object error) {
    return 'Could not load goals\n$error';
  }

  @override
  String get personalGoalsEyebrow => 'PERSONAL GOALS';

  @override
  String totalReservedAcrossGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count goals',
      one: '1 goal',
    );
    return 'Total reserved across $_temp0';
  }

  @override
  String get savedThisMonth => 'Saved this month';

  @override
  String onTrackCount(Object count) {
    return '$count on track';
  }

  @override
  String get goalsProgressing => 'Goals progressing';

  @override
  String get allGoals => 'All goals';

  @override
  String get personalGoalsProfitGrowth =>
      'Flipper quietly grows each goal from your profits.';

  @override
  String get searchProducts => 'Search products…';

  @override
  String get clearSelection => 'Clear selection';

  @override
  String itemsSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items selected',
      one: '1 item selected',
    );
    return '$_temp0';
  }

  @override
  String get cannotDeleteVariantWithStockRemaining =>
      'Cannot delete variant with stock remaining.';

  @override
  String get deleteMultipleItems => 'Delete Multiple Items';

  @override
  String deleteItemsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return 'Are you sure you want to delete $_temp0? This action cannot be undone.';
  }

  @override
  String get refreshProducts => 'Refresh products';

  @override
  String get productsSyncingHint =>
      'If you just opened the app, products may still be syncing — tap refresh.';

  @override
  String get errorLoadingProducts => 'Error loading products';

  @override
  String get retry => 'Retry';

  @override
  String get noStockDataAvailable => 'No stock data available';

  @override
  String get cash => 'Cash';

  @override
  String get credit => 'Credit';

  @override
  String get momoPayerPhone => 'MoMo payer phone';

  @override
  String get momoPaymentRequestHint =>
      'We will send a payment request to this number when you tap Charge.';

  @override
  String get exact => 'Exact';
}
