import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/stock_recount.model.dart';
import 'package:supabase_models/brick/models/stock_recount_item.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

DatabaseSyncInterface stockRecountSync() =>
    ProxyService.getStrategy(Strategy.capella);

class StockRecountService {
  const StockRecountService();

  Future<StockRecount> startSession({String? notes}) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      throw StateError('No branch selected');
    }
    final deviceId = await stockRecountSync().getPlatformDeviceId();
    final suffix = (deviceId ?? 'UNKN').substring(0, 4).toUpperCase();
    return stockRecountSync().startRecountSession(
      branchId: branchId,
      userId: ProxyService.box.getUserId()?.toString(),
      deviceId: deviceId,
      deviceName: 'Device $suffix',
      notes: notes,
    );
  }

  Stream<List<StockRecount>> recountsStream({String? status}) {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      return Stream.value(const []);
    }
    return stockRecountSync().recountsStream(
      branchId: branchId,
      status: status == 'all' ? null : status,
    );
  }

  Future<StockRecount?> getRecount(String id) =>
      stockRecountSync().getRecount(recountId: id);

  Future<List<StockRecountItem>> getItems(String recountId) =>
      stockRecountSync().getRecountItems(recountId: recountId);

  Future<StockRecountItem> addOrUpdateItem({
    required String recountId,
    required String variantId,
    required double countedQuantity,
  }) =>
      stockRecountSync().addOrUpdateRecountItem(
        recountId: recountId,
        variantId: variantId,
        countedQuantity: countedQuantity,
      );

  Future<void> removeItem(String itemId) =>
      stockRecountSync().removeRecountItem(itemId: itemId);

  Future<StockRecount> submit(String recountId, {String? shortageReason}) async {
    if (shortageReason != null && shortageReason.trim().isNotEmpty) {
      final recount = await getRecount(recountId);
      if (recount != null && recount.status == 'draft') {
        final existing = recount.notes?.trim() ?? '';
        final reasonLine = 'Shortage reason: ${shortageReason.trim()}';
        final merged = existing.isEmpty ? reasonLine : '$existing\n$reasonLine';
        await updateNotes(recountId, merged);
      }
    }
    return stockRecountSync().submitRecount(recountId: recountId);
  }

  Future<void> deleteRecount(String recountId) =>
      stockRecountSync().deleteRecount(recountId: recountId);

  Future<StockRecount> updateNotes(String recountId, String notes) =>
      stockRecountSync().updateRecountNotes(recountId: recountId, notes: notes);

  Future<List<Variant>> searchVariants(String query) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return const [];
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];
    final paged = await stockRecountSync().variants(
      branchId: branchId,
      name: trimmed,
      fetchRemote: true,
    );
    return List<Variant>.from(paged.variants)
        .where((v) => v.itemTyCd != '3')
        .take(6)
        .toList();
  }

  Future<Variant?> variantByBarcode(String barcode) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return null;
    final paged = await stockRecountSync().variants(
      branchId: branchId,
      name: barcode.trim(),
      fetchRemote: true,
    );
    for (final v in List<Variant>.from(paged.variants)) {
      if (v.itemTyCd == '3') continue;
      final code = v.bcd?.trim() ?? v.itemCd?.trim();
      if (code == barcode.trim()) return v;
    }
    return null;
  }
}
