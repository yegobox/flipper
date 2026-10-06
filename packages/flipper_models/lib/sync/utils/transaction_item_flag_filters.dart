/// DQL conditions for the `active` / `doneWithTransaction` filters on a
/// `transaction_items` read.
///
/// POS writes every line with `active: true`, but Bar Mode and Hotel Mode
/// lines were written with both flags unset (null or missing). A bar tab is a
/// PARKED transaction, so it shows in the POS Tickets list — and a strict
/// `active = true` filter hid every one of its lines: Resume showed "No items"
/// over a non-zero total, and Collect would settle the tab with no lines.
///
/// When the read is pinned to one ticket, an unset flag is read as its
/// default — `active` true, `doneWithTransaction` false — so the ticket's own
/// lines are all returned. Every other combination (an `active: false` read,
/// a `doneWithTransaction: true` read, or a branch-wide read) keeps the strict
/// equality it always had.
typedef TransactionItemFlagFilters = ({
  List<String> conditions,
  Map<String, dynamic> arguments,
});

TransactionItemFlagFilters transactionItemFlagFilters({
  bool? active,
  bool? doneWithTransaction,
  required bool pinnedToTransaction,
}) {
  final conditions = <String>[];
  final arguments = <String, dynamic>{};

  if (active != null) {
    conditions.add(
      pinnedToTransaction && active
          ? 'COALESCE(active, true) = :active'
          : 'active = :active',
    );
    arguments['active'] = active;
  }
  if (doneWithTransaction != null) {
    conditions.add(
      pinnedToTransaction && !doneWithTransaction
          ? 'COALESCE(doneWithTransaction, false) = :doneWithTransaction'
          : 'doneWithTransaction = :doneWithTransaction',
    );
    arguments['doneWithTransaction'] = doneWithTransaction;
  }

  return (conditions: conditions, arguments: arguments);
}
