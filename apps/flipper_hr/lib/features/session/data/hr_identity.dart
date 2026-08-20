/// Who the signed-in person is, in the words the chrome puts on screen.
///
/// The account menu used to show the login phone number, because that is what a
/// Flipper session actually carries. A phone number makes a poor label and a
/// worse avatar — `+2` is nobody's initials — so this resolves a human name the
/// same way Flipper's own drawer does (`users.name`, see
/// `packages/flipper_dashboard/lib/dashboard_drawer.dart`), plus the two sources
/// HR has that the drawer does not: the caller's own `hr_employees` row, and the
/// tenant on the login profile.
///
/// Plain Dart on purpose — the ordering below is the whole of the decision, and
/// it is worth testing without Supabase in the room.
library;

class HrIdentity {
  const HrIdentity({required this.name, this.phone, this.email});

  /// Signed in, nothing resolved yet. Never shows a number: an avatar that
  /// flickers from digits to initials reads as two different people.
  static const unknown = HrIdentity(name: 'Account');

  /// The best name available. Never empty.
  final String name;

  /// The login number, when known. Shown under [name] rather than as it.
  final String? phone;

  final String? email;

  /// Up to two letters for an avatar, or empty when [name] carries none —
  /// a fallback label like a phone number or `Account` has no initials worth
  /// drawing, and the avatar shows a person icon instead.
  String get initials => hrInitials(name);

  /// The contact line under the name, or null when it would only repeat it.
  String? get secondary {
    for (final value in [phone, email]) {
      final trimmed = value?.trim();
      if (trimmed != null && trimmed.isNotEmpty && trimmed != name) {
        return trimmed;
      }
    }
    return null;
  }

  @override
  String toString() => 'HrIdentity($name)';
}

/// Picks the name to show, most authoritative source first.
///
/// [accountName] is `public.users.name` — what the person typed at signup, and
/// what every other Flipper surface shows them. [employeeName] is their
/// `hr_employees` row, which exists for staff and for an owner on their own
/// payroll. [tenantName] is the login profile's tenant, which is only a name
/// when it is not just the business repeated back (the API's `businesses` shape
/// sets it to the business name — see `UserProfile.fromApiResponse`).
///
/// Anything that is plainly an identifier rather than a name — a uuid, a
/// `<pin>@flipper.rw` login key, the phone number itself — is skipped, so a
/// blank `users.name` never puts a uuid where a person should be.
HrIdentity resolveHrIdentity({
  String? accountName,
  String? employeeName,
  String? tenantName,
  String? businessName,
  String? email,
  String? phone,
}) {
  final normalizedPhone = _clean(phone);
  final normalizedEmail = _clean(email);
  final business = _clean(businessName);

  for (final candidate in <String?>[
    accountName,
    employeeName,
    // A tenant named after the business is the business, not the person.
    if (_clean(tenantName) != business) tenantName,
    _localPartOf(normalizedEmail),
  ]) {
    final name = _clean(candidate);
    if (name == null) continue;
    if (_isIdentifier(name)) continue;
    if (normalizedPhone != null && _sameNumber(name, normalizedPhone)) continue;
    return HrIdentity(
      name: name,
      phone: normalizedPhone,
      email: normalizedEmail,
    );
  }

  // Nothing nameable: the number is still the truest thing we can say, and it
  // reads fine as a label — it just never becomes an avatar (see [initials]).
  return HrIdentity(
    name: normalizedPhone ?? HrIdentity.unknown.name,
    phone: normalizedPhone,
    email: normalizedEmail,
  );
}

/// Up to two uppercase letters from [value], or empty when it has none.
///
/// Empty is a real answer, not a failure: it is how the avatar knows to draw a
/// person instead of the first two characters of a phone number.
String hrInitials(String value) {
  final words = value
      .trim()
      .split(RegExp(r'[\s._-]+'))
      .where((word) => word.isNotEmpty && _letter.hasMatch(word[0]))
      .toList();
  if (words.isEmpty) return '';
  if (words.length >= 2) {
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }
  final only = words.first;
  return (only.length >= 2 ? only.substring(0, 2) : only).toUpperCase();
}

final _letter = RegExp(r'[A-Za-z]');
final _uuid = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
  caseSensitive: false,
);

String? _clean(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

/// True for values that identify an account without naming a person.
bool _isIdentifier(String value) {
  if (_uuid.hasMatch(value)) return true;
  // `<pin>@flipper.rw` — a synthetic login key, never a person (migration 0003).
  if (value.toLowerCase().endsWith('@flipper.rw')) return true;
  return !_letter.hasMatch(value);
}

/// The readable half of an email, or null when there is none worth showing.
String? _localPartOf(String? email) {
  if (email == null || !email.contains('@')) return null;
  if (email.toLowerCase().endsWith('@flipper.rw')) return null;
  final local = email.split('@').first.replaceAll(RegExp(r'[._]+'), ' ').trim();
  return local.isEmpty ? null : local;
}

/// Digits-only comparison, so `+250783054874` and `0783054874` are one number —
/// the same rule `hr_phones_match()` applies server-side.
bool _sameNumber(String a, String b) {
  final da = a.replaceAll(RegExp(r'\D'), '');
  final db = b.replaceAll(RegExp(r'\D'), '');
  if (da.length < 9 || db.length < 9) return false;
  return da == db || da.endsWith(db) || db.endsWith(da);
}
