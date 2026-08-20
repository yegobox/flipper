import 'package:flipper_hr/features/invite/data/hr_invite.dart';

/// Backend-agnostic contract for inviting someone into HR.
///
/// Three hops against two backends — apihub for the account and the PIN,
/// Supabase for the tenant membership — behind one method, so the UI cannot
/// half-invite someone by calling them out of order. The interface exists so the
/// page, the providers and the row action can be tested against a fake.
abstract class HrInviteRepository {
  /// Finds or creates the login account for [contact], grants it membership of
  /// the business at [role], and issues the PIN the person signs in with.
  ///
  /// [contact] is a phone number or an email — apihub's `/v2/api/user` accepts
  /// either. [name] is what shows on the tenant row.
  ///
  /// Throws [HrInviteException] with the failing [HrInviteStep] on any hop.
  Future<HrInvite> invite({
    required String contact,
    required String name,
    required String businessId,
    required String branchId,
    required HrRole role,
  });
}
