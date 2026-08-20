import 'package:flipper_hr/features/session/data/hr_account_repository.dart';

/// Returns a canned `public.users` row, or nothing.
///
/// Null is the interesting case as much as a row is: an account the session
/// cannot read is what sends the chrome down its fallback chain.
class FakeHrAccountRepository implements HrAccountRepository {
  FakeHrAccountRepository({this.row});

  HrAccountRow? row;

  List<List<String>> requestedKeys = [];

  @override
  Future<HrAccountRow?> fetchAccount({required List<String> identityKeys}) async {
    requestedKeys.add(identityKeys);
    return row;
  }
}
