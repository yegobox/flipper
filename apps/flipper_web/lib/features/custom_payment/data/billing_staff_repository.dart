import 'package:supabase_flutter/supabase_flutter.dart';

/// A person allowed to use the negotiated-payment page, and the token the
/// connector expects from them.
class BillingStaffMember {
  const BillingStaffMember({
    required this.userId,
    required this.staffToken,
    this.displayName,
  });

  final String userId;

  /// Sent as `Authorization: Bearer …` to `/api/billing/custom-payments`. Held
  /// in memory only — never persisted on the client.
  final String staffToken;
  final String? displayName;
}

/// Who the signed-in user is to the billing staff allowlist.
abstract class BillingStaffRepository {
  /// The current user's own `billing_staff` row, or null when they are not
  /// staff (no row, inactive, or not signed in).
  Future<BillingStaffMember?> current();
}

/// Reads `public.billing_staff` under RLS.
///
/// The policy is `auth.uid() = user_id`, so the query needs no filter: a staff
/// member sees exactly one row, everyone else sees none. That is the whole
/// access model — the same row is the allowlist *and* the credential, so
/// deactivating it revokes the page and the API together, and no secret ever
/// ships in the web bundle.
class SupabaseBillingStaffRepository implements BillingStaffRepository {
  const SupabaseBillingStaffRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<BillingStaffMember?> current() async {
    if (_client.auth.currentUser == null) return null;
    try {
      final row = await _client
          .from('billing_staff')
          .select('user_id, display_name, staff_token, active')
          .eq('active', true)
          .maybeSingle();
      if (row == null) return null;
      final token = row['staff_token']?.toString().trim() ?? '';
      final userId = row['user_id']?.toString() ?? '';
      if (token.isEmpty || userId.isEmpty) return null;
      return BillingStaffMember(
        userId: userId,
        staffToken: token,
        displayName: row['display_name']?.toString(),
      );
    } on PostgrestException {
      // A missing table (migration not applied) or a permission error both
      // mean "not staff" for this page; the connector fails closed regardless.
      return null;
    }
  }
}
