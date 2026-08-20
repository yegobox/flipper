/// Phone-number handling for MTN / Airtel Rwanda Mobile Money.
///
/// Copied from Flipper's rules (`flipper_services/lib/momo/momo_msisdn.dart`)
/// because HR pays through the same gateway: `payNow` wants MSISDN digits only,
/// and it rejects anything that is not a Rwandan mobile number.
abstract final class HrMsisdn {
  /// Rwandan mobile prefixes after the country code: MTN 78/79, Airtel 72/73.
  static final RegExp _rwandaMobile = RegExp(r'^7[2389]\d{7}$');
  static final RegExp _nonDigits = RegExp(r'\D');

  /// Strips every separator and the leading `+`, leaving digits only. The
  /// fullwidth plus (U+FF0B) is handled too: some phone keyboards emit it and
  /// it is invisible in a text field.
  static String normalise(String phone) =>
      phone.replaceAll('＋', '').replaceAll(_nonDigits, '');

  /// The nine significant digits, country code and leading zero removed.
  static String subscriberDigits(String phone) {
    var digits = normalise(phone);
    if (digits.startsWith('250')) digits = digits.substring(3);
    if (digits.startsWith('0')) digits = digits.substring(1);
    return digits;
  }

  /// True for a Rwandan mobile number in any of the usual shapes:
  /// `0788123456`, `788123456`, `+250788123456`, `250788123456`.
  static bool isValid(String phone) =>
      phone.trim().isNotEmpty && _rwandaMobile.hasMatch(subscriberDigits(phone));

  /// What `payer.partyId` expects: `250` + nine digits, or null when the number
  /// is not a valid Rwandan mobile — so a malformed number never reaches MTN.
  static String? toPartyId(String phone) {
    final digits = subscriberDigits(phone);
    if (!_rwandaMobile.hasMatch(digits)) return null;
    return '250$digits';
  }

  /// Local display form, `0788123456`.
  static String toLocal(String phone) {
    final digits = subscriberDigits(phone);
    return digits.isEmpty ? '' : '0$digits';
  }
}
