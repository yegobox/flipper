/// Pure validation + normalization rules for customers/suppliers ("parties").
///
/// Shared by the POS app (flipper_dashboard `AddCustomer` form) and the web
/// app (flipper_web Books contacts form) so both enforce identical rules.
/// Keep this file pure Dart — no ProxyService, Brick, or Flutter imports —
/// so it stays importable from the wasm-compiled web app.
library;

import 'package:email_validator/email_validator.dart';

/// Name is required; message wording depends on the party type.
String? validatePartyName(String? value, {required bool isBusiness}) {
  if (value == null || value.trim().isEmpty) {
    return isBusiness ? 'Business name is required' : 'Name is required';
  }
  return null;
}

/// Phone is required.
String? validatePartyPhone(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Phone number is required';
  }
  return null;
}

/// Email is optional; when provided it must be a valid address.
String? validatePartyEmail(String? value) {
  if (value != null && value.isNotEmpty && !EmailValidator.validate(value)) {
    return 'Please enter a valid email address';
  }
  return null;
}

/// TIN is optional; when provided it must be exactly 9 digits (RRA rule).
String? validatePartyTin(String? value) {
  if (value != null && value.trim().isNotEmpty) {
    final trimmedValue = value.trim();
    if (!RegExp(r'^\d+$').hasMatch(trimmedValue)) {
      return 'TIN should contain only digits';
    }
    if (trimmedValue.length != 9) {
      return 'TIN must be 9 digits';
    }
  }
  return null;
}

/// Customer number derivation used by the `customers` store: the phone
/// number without its leading zero (RRA compatibility). Mirrors the
/// `Customer` model constructor in supabase_models exactly.
String? normalizeCustNo(String? telNo) {
  if (telNo != null && telNo.startsWith('0')) return telNo.substring(1);
  return telNo;
}

/// Digits-only local subscriber number for duplicate matching.
///
/// Strips non-digits, a leading Rwanda country code (`250`), and a leading
/// `0` so `0783…`, `+250783…`, and `783…` compare equal.
String normalizePartyPhone(String? phone) {
  if (phone == null) return '';
  var digits = phone.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return '';
  if (digits.startsWith('250') && digits.length >= 12) {
    digits = digits.substring(3);
  }
  if (digits.startsWith('0') && digits.length > 1) {
    digits = digits.substring(1);
  }
  return digits;
}

/// True when both phones normalize to the same non-empty subscriber number.
bool partyPhonesMatch(String? a, String? b) {
  final na = normalizePartyPhone(a);
  final nb = normalizePartyPhone(b);
  if (na.isEmpty || nb.isEmpty) return false;
  return na == nb;
}
