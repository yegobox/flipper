import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';

/// Searches the full branch catalog for purchase lines, falling back to the
/// in-memory [snapshot] when the branch is unknown or the search fails
/// (offline).
Future<Iterable<Variant>> searchPurchaseCatalog(
  String rawQuery, {
  List<Variant> snapshot = const [],
}) async {
  final query = rawQuery.trim();
  if (query.isEmpty) return const Iterable<Variant>.empty();
  Iterable<Variant> fromSnapshot() => snapshot
      .where((v) => v.name.toLowerCase().contains(query.toLowerCase()))
      .take(20);

  final branchId = ProxyService.box.getBranchId() ?? '';
  if (branchId.isEmpty) return fromSnapshot();
  try {
    final paged = await ProxyService.getStrategy(
      Strategy.capella,
    ).variants(branchId: branchId, name: query, itemsPerPage: 20);
    return paged.variants.cast<Variant>();
  } catch (e, s) {
    talker.error('Catalog search failed', e, s);
    return fromSnapshot();
  }
}
