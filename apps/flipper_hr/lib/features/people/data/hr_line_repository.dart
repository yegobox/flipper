import 'package:flipper_hr/features/people/data/person_ref.dart';
import 'package:flipper_hr/features/people/data/supabase_employee_repository.dart'
    show describeBackendError;
import 'package:supabase_flutter/supabase_flutter.dart';

/// The people the signed-in person is tied to by the reporting line.
///
/// A separate contract from `EmployeeRepository` because it answers a different
/// question with different authority: the roster is "everyone on this branch, if
/// you manage the business", while this is "you, your manager and your team,
/// whoever you are". A team lead with no business grant gets nothing from the
/// first and their whole team from the second.
abstract class HrLineRepository {
  /// The caller's own record, their direct manager, and everyone below them —
  /// names and roles only. Empty for a session with no employee record.
  Future<List<PersonRef>> fetchMyLine();
}

/// Reads `public.hr_my_line()`, installed by
/// `supabase/migrations/0007_hr_reporting_line.sql`.
///
/// An RPC rather than a table read: the projection is the permission. Selecting
/// these columns from `hr_employees` directly would need a row-level SELECT
/// policy, and a row-level grant carries salary with it — see the header of 0007.
class SupabaseHrLineRepository implements HrLineRepository {
  const SupabaseHrLineRepository(this._client);

  static const rpcName = 'hr_my_line';

  final SupabaseClient _client;

  @override
  Future<List<PersonRef>> fetchMyLine() async {
    try {
      final data = await _client.rpc(rpcName);
      return parseRows(data);
    } on PostgrestException catch (e) {
      // PGRST202: the function is not in this project. Named, because otherwise
      // every approvals queue for a line manager reads as "nothing to do" when
      // the truth is that 0007 has not been applied.
      if (e.code == 'PGRST202') {
        throw HrLineException(
          'This Supabase project is missing hr_my_line(). Apply '
          'apps/flipper_hr/supabase/migrations/0007_hr_reporting_line.sql.',
          cause: e,
        );
      }
      throw HrLineException(
        describeBackendError('Could not load your team.', e),
        cause: e,
      );
    } catch (e) {
      throw HrLineException('Could not load your team: $e', cause: e);
    }
  }

  /// Parses the RPC's rows. Static and public so the shape is testable without a
  /// client — `returns table (...)` arrives as a `List` of row maps.
  static List<PersonRef> parseRows(Object? data) {
    if (data is! List) return const [];
    final out = <PersonRef>[];
    for (final row in data) {
      if (row is Map) {
        final person = PersonRef.fromRow(row.cast<String, dynamic>());
        if (person.id.isNotEmpty) out.add(person);
      }
    }
    return out;
  }
}

class HrLineException implements Exception {
  HrLineException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'HrLineException: $message';
}
