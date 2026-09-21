import 'package:supabase_flutter/supabase_flutter.dart';

/// One business as the search shows it.
class BusinessHit {
  const BusinessHit({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.email,
    this.country,
  });

  final String id;
  final String name;
  final String? phoneNumber;
  final String? email;
  final String? country;

  /// `name · phone · email`, whichever exist.
  String get summary => [
    if (phoneNumber != null && phoneNumber!.isNotEmpty) phoneNumber!,
    if (email != null && email!.isNotEmpty) email!,
  ].join(' · ');
}

abstract class BusinessSearchRepository {
  Future<List<BusinessHit>> search(String query, {int limit = 15});
}

final _uuid = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
  caseSensitive: false,
);

/// Searches `public.businesses` by name, phone or email; an exact UUID looks
/// the business up directly so an id pasted from a ticket resolves at once.
class SupabaseBusinessSearchRepository implements BusinessSearchRepository {
  const SupabaseBusinessSearchRepository(this._client);

  final SupabaseClient _client;

  static const _columns = 'id, name, phone_number, email, country';

  @override
  Future<List<BusinessHit>> search(String query, {int limit = 15}) async {
    final q = query.trim();
    if (q.isEmpty) return const [];

    final List<dynamic> rows;
    if (_uuid.hasMatch(q)) {
      rows = await _client
          .from('businesses')
          .select(_columns)
          .eq('id', q)
          .limit(1);
    } else {
      // PostgREST `or=` takes a comma-separated filter list; a comma or paren
      // in the query would split it, so those characters are dropped.
      final safe = q.replaceAll(RegExp(r'[,()]'), ' ').trim();
      if (safe.isEmpty) return const [];
      rows = await _client
          .from('businesses')
          .select(_columns)
          .or(
            'name.ilike.%$safe%,phone_number.ilike.%$safe%,email.ilike.%$safe%',
          )
          .order('name', ascending: true)
          .limit(limit);
    }
    return [
      for (final row in rows.whereType<Map>())
        BusinessHit(
          id: row['id']?.toString() ?? '',
          name: (row['name']?.toString() ?? '').trim(),
          phoneNumber: row['phone_number']?.toString(),
          email: row['email']?.toString(),
          country: row['country']?.toString(),
        ),
    ].where((hit) => hit.id.isNotEmpty).toList();
  }
}
