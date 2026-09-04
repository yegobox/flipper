/// Phone-number handling for MTN Mobile Money collections.
///
/// Ported from eduAI (`lib/features/payments/domain/momo_msisdn.dart`) because
/// both products bill through the same data-connector gateway. The one
/// difference is reach: eduAI is Rwanda-only, Flipper has businesses in
/// Kenya, Uganda, Tanzania and further south, so a number that is not a
/// Rwandan mobile must still be allowed through — it is only *checked* harder
/// when it is one.
///
/// The gateway wants MSISDN digits only: no `+`, spaces, dashes or brackets.
abstract final class MomoMsisdn {
  /// Rwandan mobile prefixes after the country code: MTN 78/79, Airtel 72/73.
  static final RegExp _rwandaMobile = RegExp(r'^7[2389]\d{7}$');
  static final RegExp _nonDigits = RegExp(r'\D');

  /// Shortest / longest MSISDN the gateway will accept. E.164 caps at 15;
  /// nine digits is a bare subscriber number with no country code.
  static const int minDigits = 9;
  static const int maxDigits = 15;

  /// Strips every separator and the leading `+`, leaving digits only.
  ///
  /// The fullwidth plus (U+FF0B) is handled too — some phone keyboards emit it
  /// and it is invisible in a text field.
  static String normalise(String phone) {
    return phone.replaceAll('＋', '').replaceAll(_nonDigits, '');
  }

  /// The nine significant digits of a Rwandan number, country code and leading
  /// zero removed. Meaningless for other countries — use [normalise] there.
  static String subscriberDigits(String phone) {
    var digits = normalise(phone);
    if (digits.startsWith('250')) digits = digits.substring(3);
    if (digits.startsWith('0')) digits = digits.substring(1);
    return digits;
  }

  /// True for a Rwandan mobile in any of the usual shapes: `0788123456`,
  /// `788123456`, `+250788123456`, `250788123456`.
  static bool isRwandaMobile(String phone) {
    if (phone.trim().isEmpty) return false;
    return _rwandaMobile.hasMatch(subscriberDigits(phone));
  }

  /// True when [phone] could be dialled at all.
  ///
  /// Deliberately weaker than [isRwandaMobile]: a Kenyan or Ugandan MSISDN is
  /// perfectly valid at the gateway and must not be blocked here. This only
  /// catches what can never work — an empty field, a truncated number, a
  /// pasted account number.
  static bool isPlausible(String phone) {
    final digits = normalise(phone);
    return digits.length >= minDigits && digits.length <= maxDigits;
  }

  /// The value `payer.partyId` expects.
  ///
  /// Rwandan numbers are canonicalised to `250` + nine digits so the same payer
  /// typed as `0788…`, `788…` and `+250788…` is one payer — mandates are matched
  /// by MSISDN, and three spellings of one number look like three people who
  /// each need their own consent. Everything else is passed through as digits.
  ///
  /// Returns null when [phone] cannot be dialled, so a malformed number can
  /// never reach the gateway.
  static String? toPartyId(String phone) {
    final subscriber = subscriberDigits(phone);
    if (_rwandaMobile.hasMatch(subscriber)) return '250$subscriber';
    final digits = normalise(phone);
    return isPlausible(digits) ? digits : null;
  }

  /// Log-safe form, `…456`.
  ///
  /// A payer's MSISDN is personal data and a log file is the wrong place for
  /// it, but a payment that failed still has to be traceable — three digits is
  /// enough to match a log line against the person who rang about it.
  static String masked(String phone) {
    final digits = normalise(phone);
    if (digits.length < 3) return '…';
    return '…${digits.substring(digits.length - 3)}';
  }
}
