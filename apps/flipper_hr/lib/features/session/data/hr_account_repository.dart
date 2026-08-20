import 'package:supabase_flutter/supabase_flutter.dart';

/// The `public.users` row behind the session — name, email, phone.
///
/// One narrow read, kept behind an interface so the shell can be built in a test
/// without a Supabase client.
abstract class HrAccountRepository {
  /// Returns the first row among [identityKeys] that carries a name, or null.
  ///
  /// Never throws: the account row is decoration. A session that cannot read
  /// `users` still gets a working shell labelled with whatever else is known,
  /// which is why every failure here degrades to null rather than surfacing.
  Future<HrAccountRow?> fetchAccount({required List<String> identityKeys});
}

class HrAccountRow {
  const HrAccountRow({this.name, this.email, this.phoneNumber});

  final String? name;
  final String? email;
  final String? phoneNumber;

  factory HrAccountRow.fromRow(Map<String, dynamic> row) => HrAccountRow(
    name: row['name'] as String?,
    email: row['email'] as String?,
    phoneNumber: row['phone_number'] as String?,
  );
}

class SupabaseHrAccountRepository implements HrAccountRepository {
  const SupabaseHrAccountRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<HrAccountRow?> fetchAccount({
    required List<String> identityKeys,
  }) async {
    // `hr_identity_keys()` returns every id shape it could tie to the session —
    // `users.id`, `users.uuid`, `pins.user_id`, `auth.uid()`. Only the uuid-shaped
    // ones can match `users.id`, and passing a non-uuid to a uuid column fails the
    // whole query rather than matching nothing, so they are filtered out here.
    final ids = identityKeys.where(_looksLikeUuid).toSet().toList();
    if (ids.isEmpty) return null;

    try {
      final rows = await _client
          .from('users')
          .select('name,email,phone_number')
          .inFilter('id', ids)
          .limit(_maxRows);

      HrAccountRow? fallback;
      for (final raw in rows) {
        final row = HrAccountRow.fromRow(Map<String, dynamic>.from(raw));
        // More than one row can be the same person (migration 0003 walks the
        // whole phone-number family), and only some of them were ever named.
        if ((row.name?.trim() ?? '').isNotEmpty) return row;
        fallback ??= row;
      }
      return fallback;
    } catch (_) {
      return null;
    }
  }

  /// Enough rows to find a named one in a phone-number family, few enough that
  /// a chrome label never pulls a page of users.
  static const _maxRows = 8;

  static bool _looksLikeUuid(String value) => RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
    caseSensitive: false,
  ).hasMatch(value.trim());
}
