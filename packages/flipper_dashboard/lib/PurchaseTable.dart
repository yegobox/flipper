import 'package:flipper_models/providers/variants_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'purchase_table/purchase_columns.dart';
import 'purchase_table/purchase_data_source.dart';
import 'purchase_table/variant_edit_dialog.dart';

final selectedVariantProvider =
    StateProvider.family<Variant?, String>((ref, variantId) => null);

final purchaseVariantsProvider = FutureProvider.family<List<Variant>, String>(
  (ref, purchaseId) async {
    final branchId = ProxyService.box.getBranchId()!;
    return await ProxyService.strategy.variants(
      purchaseId: purchaseId,
      branchId: branchId,
    );
  },
);

class PurchaseTable extends StatefulHookConsumerWidget {
  const PurchaseTable({
    Key? key,
    required this.nameController,
    required this.supplyPriceController,
    required this.retailPriceController,
    required this.saveItemName,
    required this.acceptPurchases,
    required this.selectSale,
    required this.finalSalesList,
    required this.purchases,
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController supplyPriceController;
  final TextEditingController retailPriceController;
  final void Function(
    Variant? itemToAssign,
    Variant? itemFromPurchase,
  ) selectSale;
  final List<Variant> finalSalesList;
  final List<Purchase> purchases;
  final VoidCallback saveItemName;
  final void Function({
    required List<Variant> variants,
    required String pchsSttsCd,
  }) acceptPurchases;

  @override
  ConsumerState<PurchaseTable> createState() => _PurchaseTableState();
}

class _PurchaseTableState extends ConsumerState<PurchaseTable> {
  final Map<String, double> _editedRetailPrices = {};
  final Map<String, double> _editedSupplyPrices = {};
  final Talker talker = TalkerFlutter.init();
  final Map<String, bool> _expandedPurchases = {};

  @override
  Widget build(BuildContext context) {
    final variantsAsync =
        ref.watch(variantProvider(branchId: ProxyService.box.getBranchId()!));

    return variantsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (variants) => Container(
        width: double.infinity,
        child: widget.purchases.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.hourglass_empty, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No Purchases Found',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: widget.purchases.length,
                itemBuilder: (context, index) {
                  final purchase = widget.purchases[index];
                  final isExpanded = _expandedPurchases[purchase.id] ?? false;

                  return Card(
                    margin: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('Supplier: ${purchase.spplrNm}'),
                          subtitle: Text('Invoice: ${purchase.spplrInvcNo}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Total: ${purchase.totAmt}'),
                              IconButton(
                                icon: Icon(isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more),
                                onPressed: () {
                                  setState(() {
                                    _expandedPurchases[purchase.id] = !isExpanded;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        if (isExpanded)
                          Consumer(
                            builder: (context, ref, child) {
                              final variantsAsync = ref
                                  .watch(purchaseVariantsProvider(purchase.id));

                              return variantsAsync.when(
                                loading: () => Container(
                                  height: 100,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                error: (err, stack) => Container(
                                  padding: EdgeInsets.all(16),
                                  child: Text('Error: $err'),
                                ),
                                data: (purchaseVariants) {
                                  final unapprovedVariants = purchaseVariants
                                      .where((v) => v.pchsSttsCd == '01')
                                      .toList();

                                  if (unapprovedVariants.isEmpty) {
                                    return Container(
                                      padding: EdgeInsets.all(16),
                                      child: Text('No unapproved variants found'),
                                    );
                                  }

                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: SfDataGrid(
                                      source: PurchaseDataSource(
                                        unapprovedVariants,
                                        _editedRetailPrices,
                                        _editedSupplyPrices,
                                        talker,
                                        () => setState(() {}),
                                        widget.acceptPurchases,
                                      ),
                                      columns: buildPurchaseColumns(),
                                      columnWidthMode: ColumnWidthMode.fill,
                                      headerRowHeight: 56.0,
                                      rowHeight: 48.0,
                                      selectionMode: SelectionMode.single,
                                      onCellTap: (details) {
                                        if (details.rowColumnIndex.rowIndex > 0) {
                                          final item = unapprovedVariants[
                                              details.rowColumnIndex.rowIndex - 1];
                                          _showEditDialog(context, item,
                                              variants: variants);
                                        }
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, Variant item,
      {required List<Variant> variants}) {
    return showVariantEditDialog(
      context,
      item,
      variants: variants,
      nameController: widget.nameController,
      supplyPriceController: widget.supplyPriceController,
      retailPriceController: widget.retailPriceController,
      saveItemName: widget.saveItemName,
      selectSale: widget.selectSale,
    );
  }
}
