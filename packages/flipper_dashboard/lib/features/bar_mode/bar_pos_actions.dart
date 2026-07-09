import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/models/bar_table.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

/// Shared bar POS mutations used by desktop and mobile layouts.
abstract final class BarPosActions {
  static Future<void> addItem({
    required WidgetRef ref,
    required Variant variant,
    required ITransaction tab,
    required BarTable table,
    required String branchId,
    required Tenant cashier,
  }) async {
    await ProxyService.getStrategy(Strategy.capella).addLineToBarTab(
      transactionId: tab.id,
      branchId: branchId,
      variantId: variant.id,
      productName: variant.name,
      defaultPrice: variant.retailPrice ?? 0,
      stock: (variant.stock?.currentStock ?? 999).toInt(),
      cashierTenantId: cashier.id,
      cashierName: cashier.name ?? 'Staff',
      color: variant.color,
      sku: variant.sku,
    );
    ref.invalidate(barTabLinesProvider(tab.id));
  }

  static Future<void> changeQty({
    required WidgetRef ref,
    required ITransaction tab,
    required TransactionItem line,
    required int delta,
  }) async {
    const stock = 999;
    await ProxyService.getStrategy(Strategy.capella).setBarTabLineQty(
      lineId: line.id,
      transactionId: tab.id,
      qty: line.qty + delta,
      stockCap: stock,
    );
    ref.invalidate(barTabLinesProvider(tab.id));
  }

  static Future<void> deleteLine({
    required WidgetRef ref,
    required ITransaction tab,
    required TransactionItem line,
  }) async {
    await ProxyService.getStrategy(Strategy.capella).deleteBarTabLine(
      lineId: line.id,
      transactionId: tab.id,
    );
    ref.invalidate(barTabLinesProvider(tab.id));
  }

  static Future<void> openTable({
    required WidgetRef ref,
    required BarTable table,
    required Tenant cashier,
  }) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;

    final sync = ProxyService.getStrategy(Strategy.capella);
    final tab = await sync.openBarTab(
      branchId: branchId,
      table: table,
      cashierTenantId: cashier.id,
      cashierName: cashier.name ?? 'Staff',
    );
    ref.read(barModeProvider.notifier).bindTable(table, tab);
  }
}
