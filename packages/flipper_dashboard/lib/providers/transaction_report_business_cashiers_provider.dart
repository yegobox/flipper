import 'package:flipper_dashboard/transaction_report_cashier_profile.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:supabase_models/brick/models/access.model.dart';
import 'package:supabase_models/brick/models/user.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_dashboard/transaction_report_cashier_utils.dart';

/// Staff with active [accesses] for the logged-in business; names from [users].
///
/// Offline-first:
/// - reads cached `accesses` + `users` from the local DB (Ditto/SQLite via Brick)
/// - when internet is available, Brick will refresh from Supabase using `awaitRemote`
/// - when offline, falls back to local-only results
final transactionReportBusinessCashiersProvider =
    FutureProvider.autoDispose<List<TransactionReportCashierProfile>>((
      ref,
    ) async {
      final businessId = ProxyService.box.getBusinessId();
      if (businessId == null || businessId.isEmpty) return const [];

      final repo = Repository();
      final accessQuery = Query(
        where: [
          Where('businessId').isExactly(businessId),
          Where('status').isExactly('active'),
        ],
      );

      List<Access> accesses;
      try {
        accesses = await repo.get<Access>(
          policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
          query: accessQuery,
        );
      } catch (_) {
        accesses = await repo.get<Access>(
          policy: OfflineFirstGetPolicy.localOnly,
          query: accessQuery,
        );
      }

      final ids = accesses
          .map((a) => (a.userId ?? '').trim())
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();
      if (ids.isEmpty) return const [];

      // Load user rows offline-first. We only need name/key/email; the User model has name + key.
      final users = <User>[];
      for (final id in ids) {
        final q = Query(where: [Where('id').isExactly(id)]);
        try {
          final rows = await repo.get<User>(
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
            query: q,
          );
          if (rows.isNotEmpty) users.add(rows.first);
        } catch (_) {
          final rows = await repo.get<User>(
            policy: OfflineFirstGetPolicy.localOnly,
            query: q,
          );
          if (rows.isNotEmpty) users.add(rows.first);
        }
      }

      final profiles =
          users
              .map(
                (u) => TransactionReportCashierProfile(
                  userId: u.id,
                  displayName:
                      TransactionReportCashierProfile.displayNameFromUserRow(
                        name: u.name,
                        email: u.key,
                      ),
                  initials: TransactionReportCashierProfile.initialsFromUserRow(
                    name: u.name,
                    email: u.key,
                  ),
                  avatarColor: cashierAccentColorForAgentId(u.id),
                ),
              )
              .toList()
            ..sort(
              (a, b) => a.displayName.toLowerCase().compareTo(
                b.displayName.toLowerCase(),
              ),
            );

      return profiles;
    });
