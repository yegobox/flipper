/// Signup accepts either a phone number or an email address in the same field,
/// matching the mobile signup form (`SignupFormBloc.EMAIL_REGEX` and
/// `_ensurePhoneHasDialCode` in packages/flipper_login).
library;

import 'package:flipper_models/helperModels/signup_countries.dart';

/// Dial codes for every country `countriesProvider` offers — the whole world,
/// not the five East African countries this map used to be hardcoded to.
final Map<String, String> kSignupDialCodes = Map.unmodifiable({
  for (final country in kSignupCountries) country.name: country.dialCode,
});

/// Same pattern the mobile signup bloc validates emails with.
final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[a-zA-Z]{2,}$');

/// Whether [raw] is a complete, valid email address.
bool isEmailContact(String raw) => _emailRegex.hasMatch(raw.trim());

/// Whether [raw] is being typed as an email. True from the first `@`, so the
/// dial-code prefix can disappear before the address is finished — this is what
/// the mobile field keys its prefix chip off.
bool looksLikeEmailContact(String raw) => raw.contains('@');

String signupDialCode(String country) => signupDialCodeFor(country);

/// The local part shown in the input, with any known dial code removed.
String localPhonePart(String raw) {
  final cleaned = raw.trim();
  if (looksLikeEmailContact(cleaned)) return cleaned;
  final digits = stripSignupPhoneSeparators(cleaned);
  final code = matchLeadingDialCode(digits);
  if (code != null) return digits.substring(code.length);
  return digits;
}

/// The canonical value to send to the API.
///
/// Emails pass through untouched; phone numbers go through
/// [normalizeSignupPhone] (flipper_models), the same normalizer the mobile
/// signup form uses, so the two cannot drift: separators removed, [country]'s
/// dial code in front, any other `+` dial code or leading zero replaced. Empty
/// input stays empty so an untouched field never counts as filled in.
String normalizeSignupContact(String raw, {required String country}) {
  final trimmed = raw.trim();
  if (looksLikeEmailContact(trimmed)) return trimmed;
  return normalizeSignupPhone(trimmed, country: country);
}
