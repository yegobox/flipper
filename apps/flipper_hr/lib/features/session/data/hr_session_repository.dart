import 'package:flipper_hr/features/session/data/hr_session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Resolves the signed-in session to what HR can prove about it.
abstract class HrSessionRepository {
  Future<HrSession> resolve();
}

/// Reads `public.hr_whoami_employee()`, the diagnostic function
/// `0004_hr_leave.sql` installs.
///
/// Deliberately one RPC rather than two table reads. The two identity paths are
/// SQL functions, and asking the server to evaluate them is the only way to get
/// the same answer the policies will give — inferring "am I an owner?" from
/// whether a `hr_employees` select came back non-empty cannot distinguish an
/// owner from an employee reading their own row, because RLS allows both.
class SupabaseHrSessionRepository implements HrSessionRepository {
  const SupabaseHrSessionRepository(this._client);

  static const rpcName = 'hr_whoami_employee';

  final SupabaseClient _client;

  @override
  Future<HrSession> resolve() async {
    try {
      final data = await _client.rpc(rpcName);
      return parseSession(data);
    } on PostgrestException catch (e) {
      // PGRST202: the function is not in this project — 0004 has not been
      // applied. Worth naming, because every HR page downstream will look
      // permission-denied instead of unmigrated.
      if (e.code == 'PGRST202') {
        throw HrSessionException(
          'This Supabase project is missing hr_whoami_employee(). Apply '
          'apps/flipper_hr/supabase/migrations/0004_hr_leave.sql.',
          cause: e,
        );
      }
      throw HrSessionException(
        'Could not work out what you have access to: ${e.message}',
        cause: e,
      );
    } catch (e) {
      throw HrSessionException(
        'Could not work out what you have access to: $e',
        cause: e,
      );
    }
  }

  /// Parses the RPC's jsonb. Kept static and public so the shape is testable
  /// without a client — the arrays come back as `List<dynamic>` of whatever
  /// `jsonb_agg` produced, which is stringly-typed at the boundary.
  static HrSession parseSession(Object? data) {
    if (data is! Map) return HrSession.none;
    final row = data.cast<String, dynamic>();
    return HrSession(
      businessIds: _ids(row['business_ids']),
      employeeIds: _ids(row['employee_ids']),
      identityKeys: _ids(row['identity_keys']),
    );
  }

  static List<String> _ids(Object? value) {
    if (value is! List) return const [];
    final out = <String>[];
    for (final item in value) {
      final s = item?.toString().trim();
      if (s != null && s.isNotEmpty && s != 'null') out.add(s);
    }
    return out;
  }
}

class HrSessionException implements Exception {
  HrSessionException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'HrSessionException: $message';
}
