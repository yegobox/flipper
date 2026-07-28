import 'package:flipper_localize/flipper_localize.dart';

/// Localized display name for a value from `paymentTypes`.
///
/// The identifiers in `paymentTypes` are persisted on the transaction and feed
/// the RRA `pmtTyCd` mapping, so they must never be translated at rest. This
/// resolver is display-only: the stored value stays `CASH`, only the label the
/// cashier reads changes. Unknown values fall through unchanged so a new
/// payment type is still readable before it gets a key.
String paymentMethodDisplayName(FlipperAppLocalizations l10n, String method) {
  switch (method.toUpperCase()) {
    case 'CASH':
      return l10n.cash;
    case 'CREDIT':
      return l10n.credit;
    case 'CASH/CREDIT':
      return l10n.paymentCashCredit;
    case 'BANK CHECK':
      return l10n.paymentBankCheck;
    case 'DEBIT&CREDIT CARD':
      return l10n.paymentDebitCreditCard;
    case 'MOBILE MONEY':
      return l10n.paymentMobileMoney;
    case 'MTN MOMO':
      return l10n.paymentMtnMomo;
    case 'AIRTEL MONEY':
      return l10n.paymentAirtelMoney;
    case 'OTHER':
      return l10n.paymentOther;
    default:
      return method;
  }
}
