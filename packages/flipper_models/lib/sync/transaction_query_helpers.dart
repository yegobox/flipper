import 'package:flipper_models/sync/dql_for_sync_subscription.dart';

/// Ditto sync subscription query for [CapellaTransactionMixin.transactions].
///
/// - Agent attribution (commission) uses [attributedAgentUserId] (all branches).
/// - Otherwise uses [branchId] when set (existing POS / reports behavior).
/// - Returns null when neither is set (no subscription registered).
DqlSyncPrepared? capellaTransactionsSyncSubscription({
  String? branchId,
  String? attributedAgentUserId,
}) {
  if (attributedAgentUserId != null && attributedAgentUserId.isNotEmpty) {
    return prepareDqlSyncSubscription(
      'SELECT * FROM transactions WHERE attributedAgentUserId = :attributedAgentUserId',
      {'attributedAgentUserId': attributedAgentUserId},
    );
  }
  if (branchId != null && branchId.isNotEmpty) {
    return prepareDqlSyncSubscription(
      'SELECT * FROM transactions WHERE branchId = :branchId',
      {'branchId': branchId},
    );
  }
  return null;
}

/// Date column for period filters in transaction list queries.
String transactionsPeriodDateField({bool filterPeriodByCreatedAt = false}) =>
    filterPeriodByCreatedAt ? 'createdAt' : 'lastTouched';

/// Whether [CapellaTransactionMixin.transactions] should wait and re-query
/// after replication (new device / cold start), mirroring [CapellaVariantMixin].
bool transactionsShouldWaitForRemoteSync({
  required bool fetchRemote,
  String? id,
  List<String>? receiptNumber,
  String? attributedAgentUserId,
}) {
  if (!fetchRemote) return false;
  if (id != null) return false;
  if (receiptNumber != null && receiptNumber.isNotEmpty) return false;
  return attributedAgentUserId != null && attributedAgentUserId.isNotEmpty;
}
