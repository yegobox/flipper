/// Signup accepts either a phone number or an email address in the same field,
/// matching the mobile signup form (`SignupFormBloc.EMAIL_REGEX` and
/// `_ensurePhoneHasDialCode` in packages/flipper_login).
library;

/// Dial codes for the countries offered by `countriesProvider`.
const Map<String, String> kSignupDialCodes = {
  'Rwanda': '+250',
  'Kenya': '+254',
  'Uganda': '+256',
  'Tanzania': '+255',
  'Burundi': '+257',
};

/// Same pattern the mobile signup bloc validates emails with.
final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[a-zA-Z]{2,}$');

/// Whether [raw] is a complete, valid email address.
bool isEmailContact(String raw) => _emailRegex.hasMatch(raw.trim());

/// Whether [raw] is being typed as an email. True from the first `@`, so the
/// dial-code prefix can disappear before the address is finished — this is what
/// the mobile field keys its prefix chip off.
bool looksLikeEmailContact(String raw) => raw.contains('@');

String signupDialCode(String country) => kSignupDialCodes[country] ?? '+250';

/// Separators people type into a phone field: spaces, dashes (including the
/// unicode ones a phone keyboard offers), dots and brackets.
final RegExp _phoneSeparators = RegExp(r'[\s().\u2010-\u2015-]');

/// A phone number with its separators removed, so `078 305 4874`,
/// `078-305-4874` and `(078) 305 4874` all reach apihub as the same contact —
/// the OTP is sent to it, the account is keyed on it, and a stray space made
/// those two different numbers. Emails never go through here.
String _canonicalPhone(String raw) => raw.replaceAll(_phoneSeparators, '');

/// The local part shown in the input, with any known dial code removed.
String localPhonePart(String raw) {
  final cleaned = raw.trim();
  if (looksLikeEmailContact(cleaned)) return cleaned;
  final digits = _canonicalPhone(cleaned);
  for (final code in kSignupDialCodes.values) {
    if (digits.startsWith(code)) return digits.substring(code.length);
  }
  return digits;
}

/// The canonical value to send to the API.
///
/// Emails pass through untouched; phone numbers lose their separators and get
/// [country]'s dial code, with any other known dial code or leading zero
/// replaced. Empty input stays empty so an untouched field never counts as
/// filled in.
String normalizeSignupContact(String raw, {required String country}) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return '';
  if (looksLikeEmailContact(trimmed)) return trimmed;

  // Canonicalize before matching dial codes: `+250 783…` has to be recognized
  // as already carrying its code.
  final cleaned = _canonicalPhone(trimmed);
  if (cleaned.isEmpty) return '';

  final code = signupDialCode(country);
  if (cleaned.startsWith(code)) return cleaned;
  for (final other in kSignupDialCodes.values) {
    if (cleaned.startsWith(other)) {
      return code + cleaned.substring(other.length);
    }
  }

  var local = cleaned;
  if (local.startsWith('0')) local = local.substring(1);
  return '$code$local';
}
