/// The one stored spelling for each mobile-money tender.
///
/// Mobile money was saved under several names over time (`MTN MOMO` from the
/// POS picker and cash book, `Mobile Money` from bar mode, `Momo` from the
/// hotel folio). RRA has a single code for all of them (`06`), so the stored
/// value is [kMobileMoney]; Airtel stays its own tender, [kAirtelMoney], under
/// the same code.
///
/// Keep the alias rules in step with data-connector's
/// `src/payment_method.rs`, which reads the same rows.
library;

const String kMobileMoney = 'MOBILE MONEY';
const String kAirtelMoney = 'AIRTEL MONEY';

/// [raw] with every legacy mobile-money spelling folded into [kMobileMoney] or
/// [kAirtelMoney]. Any other tender comes back trimmed but otherwise as given,
/// so callers that compare `'Cash'` or `'CASH'` keep working.
String canonicalPaymentMethod(String? raw) {
  final value = raw?.trim() ?? '';
  final upper = value.toUpperCase().replaceAll('_', ' ');
  if (upper.contains('AIRTEL')) return kAirtelMoney;
  if (upper.contains('MOMO') ||
      upper.contains('MTN') ||
      upper.contains('MOBILE')) {
    return kMobileMoney;
  }
  return value;
}

/// RRA `pmtTyCd` for a payment method name. Every mobile-money spelling, MTN
/// or Airtel, is `06`; anything unrecognised is `07` (other).
String rraPaymentTypeCode(String? paymentMethod) {
  switch (canonicalPaymentMethod(paymentMethod).toUpperCase()) {
    case 'CASH':
      return '01';
    case 'CREDIT':
    case 'CREDIT CARD':
      return '02';
    case 'CASH/CREDIT':
      return '03';
    case 'BANK CHECK':
      return '04';
    case 'DEBIT&CREDIT CARD':
      return '05';
    case kMobileMoney:
    case kAirtelMoney:
      return '06';
    default:
      return '07';
  }
}

/// True for any spelling of an MTN or Airtel mobile-money tender.
bool isMobileMoneyTender(String? raw) {
  final canonical = canonicalPaymentMethod(raw);
  return canonical == kMobileMoney || canonical == kAirtelMoney;
}
