import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Screen state for the desktop purchase-order view.
///
/// The catalogue itself is [productFromSupplierWrapper]; everything here is the
/// operator's view onto it (which category, which filters, what they typed) plus
/// the two pieces of order context the handoff shows — the finance option and
/// the confirmation panel after the order is sent.

/// `All` means "no category filter"; every other value is a
/// [Variant.categoryName].
const String kOrderingAllCategories = 'All';

final orderingCategoryProvider = StateProvider<String>(
  (ref) => kOrderingAllCategories,
);

/// Hide rows the supplier has none of.
final orderingStockOnlyProvider = StateProvider<bool>((ref) => false);

/// Break the catalogue into category sections instead of one flat list.
final orderingGroupByCategoryProvider = StateProvider<bool>((ref) => true);

/// Show the "Retail · margin" column. Off by default: it is buying-desk
/// context, not something every operator needs on screen.
final orderingShowMarginProvider = StateProvider<bool>((ref) => false);

/// Catalogue search, applied **locally** over the rows already fetched.
///
/// Deliberately not [supplierCatalogSearchProvider], which re-queries Supabase:
/// filtering in memory is what lets the result count, the "nothing matches"
/// state and Enter-adds-top-match respond on the keystroke instead of a
/// round-trip.
final orderingQueryProvider = StateProvider<String>((ref) => '');

/// Chosen finance option, once the operator picks one.
final orderingFinanceProvider = StateProvider<FinanceProvider?>((ref) => null);

/// Set when an order has been sent; drives the confirmation panel.
final orderingPlacedProvider = StateProvider<PlacedOrder?>((ref) => null);

/// What the confirmation panel reports back.
class PlacedOrder {
  const PlacedOrder({
    required this.supplierName,
    required this.lineCount,
    required this.unitCount,
    required this.total,
  });

  final String supplierName;
  final int lineCount;
  final int unitCount;
  final double total;
}

/// Finance options the operator can pay with.
final orderingFinanceOptionsProvider =
    FutureProvider<List<FinanceProvider>>((ref) async {
      return ProxyService.getStrategy(Strategy.capella).financeProviders();
    });

/// What the picker offers: the branches ordered from before, and the rest.
class SupplierOptions {
  const SupplierOptions({required this.frequent, required this.others});

  const SupplierOptions.empty() : frequent = const [], others = const [];

  /// Ordered from before, most orders first.
  final List<Branch> frequent;

  /// Everything else on this device, by name.
  final List<Branch> others;

  bool get isEmpty => frequent.isEmpty && others.isEmpty;
}

/// Who this branch has ordered from before, and how often.
class SupplierOrderHistory {
  const SupplierOrderHistory({required this.counts, required this.branches});

  const SupplierOrderHistory.empty() : counts = const {}, branches = const {};

  /// Orders sent, keyed by supplier branch id.
  final Map<String, int> counts;

  /// The supplier branch each request carried — the only record of a supplier
  /// that is not in this device's own `branches` collection.
  final Map<String, Branch> branches;
}

final orderingSupplierHistoryProvider =
    StreamProvider<SupplierOrderHistory>((ref) {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) {
        return Stream.value(const SupplierOrderHistory.empty());
      }

      return ProxyService.getStrategy(Strategy.capella)
          .requestsStreamOutgoing(
            branchId: branchId,
            filter: 'all',
            limit: 100,
          )
          .map((requests) {
            final counts = <String, int>{};
            final branches = <String, Branch>{};
            for (final request in requests) {
              final id = request.mainBranchId;
              if (id == null || id.isEmpty || id == branchId) continue;
              counts[id] = (counts[id] ?? 0) + 1;
              final supplier = request.branch;
              if (supplier != null) branches.putIfAbsent(id, () => supplier);
            }
            return SupplierOrderHistory(counts: counts, branches: branches);
          });
    });

/// Every branch the operator could order from, ranked.
///
/// `searchSuppliers` answers an empty query with nothing, so the picker needs
/// its own default list. Order history alone is not it: a business with many
/// registered branches but few past orders saw two rows and no way to reach the
/// rest. So the list is every branch on the device except this one — the same
/// breadth typing gives — with the ones actually ordered from lifted to the top.
///
/// A supplier known only from order history (not in the local `branches`
/// collection) is still included, from the branch embedded in its request.
final orderingSupplierOptionsProvider = FutureProvider<SupplierOptions>((
  ref,
) async {
  final branchId = ProxyService.box.getBranchId();
  final history =
      ref.watch(orderingSupplierHistoryProvider).value ??
      const SupplierOrderHistory.empty();
  final counts = history.counts;

  final byId = <String, Branch>{};
  // Deliberately unfiltered on `active`: Branch defaults it to false, so
  // filtering here would hide most of the roster.
  for (final branch in await ProxyService.getStrategy(Strategy.capella)
      .branches(excludeId: branchId)) {
    if (branch.id == branchId) continue;
    byId[branch.id] = branch;
  }

  final frequent = <Branch>[];
  for (final id in counts.keys.toList()
    ..sort((a, b) => (counts[b] ?? 0).compareTo(counts[a] ?? 0))) {
    // Fall back to the branch the request carried, so a supplier outside this
    // device's own branches is still offered.
    final branch = byId.remove(id) ?? history.branches[id];
    if (branch != null) frequent.add(branch);
  }

  final others = byId.values.toList()
    ..sort(
      (a, b) => (a.name ?? '').toLowerCase().compareTo(
        (b.name ?? '').toLowerCase(),
      ),
    );

  return SupplierOptions(frequent: frequent, others: others);
});

/// Supplier name search, for when the operator types in the picker.
final orderingSupplierSearchProvider = FutureProvider.family<
  List<Branch>,
  String
>((ref, query) async {
  final trimmed = query.trim();
  if (trimmed.isEmpty) return const [];
  final currentBranchId = ProxyService.box.getBranchId();
  final results = await ProxyService.app.searchSuppliers(trimmed);
  // Ordering from yourself is rejected downstream; never offer it.
  return results.where((b) => b.id != currentBranchId).toList();
});

/// Summary of the previous order placed with [supplierId], for the rail card.
class LastOrder {
  const LastOrder({
    required this.total,
    required this.lineCount,
    required this.placedAt,
    required this.status,
  });

  final double total;
  final int lineCount;
  final DateTime? placedAt;
  final String status;
}

/// The most recent order this branch sent to [supplierId].
///
/// `requestsStreamOutgoing` is already the outgoing feed (it filters on
/// `subBranchId`, this branch, newest first) and carries each request's embedded
/// items, so the total is summed here rather than fetched again.
final orderingLastOrderProvider = StreamProvider.family<LastOrder?, String>((
  ref,
  supplierId,
) {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null || supplierId.isEmpty) {
    return Stream.value(null);
  }

  return ProxyService.getStrategy(Strategy.capella)
      .requestsStreamOutgoing(branchId: branchId, filter: 'all', limit: 50)
      .map((requests) {
        for (final request in requests) {
          if (request.mainBranchId != supplierId) continue;
          final items = request.transactionItems ?? const <TransactionItem>[];
          final total = items.fold<double>(
            0,
            (sum, item) => sum + (item.price * item.qty),
          );
          return LastOrder(
            total: total,
            lineCount: items.length,
            placedAt: request.createdAt,
            status: request.status ?? RequestStatus.pending,
          );
        }
        return null;
      });
});
