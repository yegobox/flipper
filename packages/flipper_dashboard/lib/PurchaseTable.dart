import 'package:flipper_models/providers/variants_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'purchase_table/purchase_columns.dart';
import 'purchase_table/purchase_data_source.dart';
import 'purchase_table/variant_edit_dialog.dart';

final selectedVariantProvider =
    StateProvider.family<Variant?, String>((ref, variantId) => null);

class PurchaseTable extends StatefulHookConsumerWidget {
  const PurchaseTable({
    Key? key,
    required this.nameController,
    required this.supplyPriceController,
    required this.retailPriceController,
    required this.saveItemName,
    required this.acceptPurchases,
    required this.selectSale,
    required this.variants,
    required this.purchases,
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController supplyPriceController;
  final TextEditingController retailPriceController;
  final void Function(
    Variant? itemToAssign,
    Variant? itemFromPurchase,
  ) selectSale;
  final List<Variant> variants;
  final List<Purchase> purchases;
  final VoidCallback saveItemName;
  final Future<void> Function({
    required List<Variant> variants,
    required String pchsSttsCd,
    required Purchase purchase,
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
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
        ),
      ),
      error: (err, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
            SizedBox(height: 16),
            Text(
              'Error: $err',
              style: TextStyle(color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      data: (variants) => Container(
        width: double.infinity,
        color: Colors.grey[50],
        child: widget.purchases.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No Purchases Found',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: widget.purchases.length,
                itemBuilder: (context, index) {
                  final purchase = widget.purchases[index];
                  final isExpanded = _expandedPurchases[purchase.id] ?? false;

                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text(
                            'Supplier: ${purchase.spplrNm}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              'Invoice: ${purchase.spplrInvcNo}',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Chip(
                                  label: Text(
                                    timeago.format(
                                      purchase.createdAt,
                                      clock: DateTime.now(),
                                    ),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                  backgroundColor: Colors.green,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.indigo.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  'Total: ${purchase.totAmt}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo[700],
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 300),
                                  child: Icon(
                                    isExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    key: ValueKey<bool>(isExpanded),
                                    color: Colors.indigo,
                                    size: 28,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _expandedPurchases[purchase.id] =
                                        !isExpanded;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        if (isExpanded)
                          Consumer(
                            builder: (context, ref, child) {
                              final variantsAsync = ref.watch(
                                  purchaseVariantProvider(
                                      purchaseId: purchase.id,
                                      branchId:
                                          ProxyService.box.getBranchId()!));

                              return variantsAsync.when(
                                loading: () => Container(
                                  height: 100,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.indigo),
                                    ),
                                  ),
                                ),
                                error: (err, stack) => Container(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    'Error: $err',
                                    style: TextStyle(color: Colors.red[400]),
                                  ),
                                ),
                                data: (purchaseVariants) {
                                  final relevantVariants = purchaseVariants
                                      .where((v) =>
                                              v.pchsSttsCd == '01' || // Waiting
                                              v.pchsSttsCd ==
                                                  '02' || // Approved
                                              v.pchsSttsCd == '04' // Declined
                                          )
                                      .toList();

                                  if (relevantVariants.isEmpty) {
                                    return Container(
                                      padding: EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check_circle_outline,
                                            color: Colors.green[400],
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'No unapproved variants found',
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        dataTableTheme: DataTableThemeData(
                                          headingTextStyle: TextStyle(
                                            color: Colors.indigo[700],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          if (relevantVariants.isNotEmpty)
                                            SizedBox(
                                              // Or Container with a height
                                              height:
                                                  300, // Adjust this value as needed
                                              child: SfDataGrid(
                                                key:
                                                    UniqueKey(), // Add a key to force a rebuild when data changes
                                                source: PurchaseDataSource(
                                                  relevantVariants,
                                                  _editedRetailPrices,
                                                  _editedSupplyPrices,
                                                  talker,
                                                  () => setState(() {}),
                                                  widget.acceptPurchases,
                                                  purchase,
                                                ),
                                                columns: buildPurchaseColumns(),
                                                columnWidthMode:
                                                    ColumnWidthMode.fill,
                                                headerRowHeight: 56.0,
                                                rowHeight: 50.0,
                                                gridLinesVisibility:
                                                    GridLinesVisibility
                                                        .horizontal,
                                                headerGridLinesVisibility:
                                                    GridLinesVisibility.both,
                                                selectionMode:
                                                    SelectionMode.single,
                                                onCellTap: (details) async {
                                                  if (details.rowColumnIndex
                                                          .rowIndex >
                                                      0) {
                                                    final item =
                                                        relevantVariants[details
                                                                .rowColumnIndex
                                                                .rowIndex -
                                                            1];
                                                    final variants =
                                                        await ProxyService
                                                            .strategy
                                                            .variants(
                                                                fetchRemote:
                                                                    false,
                                                                branchId:
                                                                    ProxyService
                                                                        .box
                                                                        .getBranchId()!);
                                                    _showEditDialog(
                                                        context, item,
                                                        variants: variants);
                                                  }
                                                },
                                              ),
                                            ),
                                        ],
                                      ),
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
