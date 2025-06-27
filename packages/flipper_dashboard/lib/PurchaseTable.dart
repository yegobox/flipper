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
    required List<Purchase> purchases,
    required String pchsSttsCd,
    required Purchase purchase,
    Variant? clickedVariant,
  }) acceptPurchases;

  @override
  ConsumerState<PurchaseTable> createState() => _PurchaseTableState();
}

class _PurchaseTableState extends ConsumerState<PurchaseTable> {
  String?
      _selectedStatusFilter; // null for 'All', '01' for Waiting, '02' for Approved, '04' for Declined
  final Map<String, double> _editedRetailPrices = {};
  final Map<String, double> _editedSupplyPrices = {};
  final Talker talker = TalkerFlutter.init();
  final Map<String, bool> _expandedPurchases = {};

  late PurchaseDataSource _dataSource;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _dataSource.dispose();
    super.dispose();
  }

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
      data: (allBranchVariants) {
        talker.info(
            "PurchaseTable.build: Received ${widget.purchases.length} purchases.");
        for (var p_ui_log in widget.purchases) {
          talker.info(
              "  UI Purchase ID: ${p_ui_log.id}, Invoice: ${p_ui_log.spplrInvcNo}");
          if (p_ui_log.variants == null) {
            talker.info("    p_ui_log.variants is NULL");
          } else if (p_ui_log.variants!.isEmpty) {
            talker.info("    p_ui_log.variants is EMPTY");
          } else {
            talker.info(
                "    p_ui_log.variants contents (${p_ui_log.variants!.length} items):");
            for (var v_ui_log in p_ui_log.variants!) {
              talker.info(
                  "      UI Variant ID: ${v_ui_log.id}, Status: ${v_ui_log.pchsSttsCd}, Name: ${v_ui_log.name}");
            }
          }
        }

        // Define the status filter options
        final Map<String?, String> statusOptions = {
          null: 'All',
          '01': 'Waiting',
          '02': 'Approved',
          '04': 'Declined',
        };

        // Filter purchases based on the selected status filter and variant availability
        final List<Purchase> displayablePurchases =
            widget.purchases.where((purchase) {
          // Rule 1: Purchase must have variants relevant to the purchase screen.
          // purchase.variants is populated by PurchaseMixin with items having pchsSttsCd '01', '02', or '04'.
          if (purchase.variants == null || purchase.variants!.isEmpty) {
            return false;
          }
          // Rule 2: If a specific status filter is active, purchase must have variants matching that status.
          if (_selectedStatusFilter != null) {
            return purchase.variants!
                .any((v) => v.pchsSttsCd == _selectedStatusFilter);
          }
          // Rule 3: If filter is "All" (null), and it passed Rule 1, show it.
          return true;
        }).toList();

        return Container(
          width: double.infinity,
          color: Colors.grey[50],
          child: Column(
            // Main column that always shows the filter
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String?>(
                  value: _selectedStatusFilter,
                  decoration: InputDecoration(
                    labelText: 'Filter by Status',
                    border: OutlineInputBorder(),
                  ),
                  items: statusOptions.entries.map((entry) {
                    return DropdownMenuItem<String?>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStatusFilter = newValue;
                    });
                  },
                ),
              ),
              Expanded(
                child: displayablePurchases.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.filter_list_off_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              _selectedStatusFilter == null
                                  ? 'No Purchases Found'
                                  : 'No Purchases Match Selected Filter',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(12),
                        itemCount: displayablePurchases.length,
                        itemBuilder: (context, index) {
                          final purchase = displayablePurchases[index];
                          final isExpanded =
                              _expandedPurchases[purchase.id] ?? false;

                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  title: Text(
                                    'Supplier: ${purchase.spplrNm} (${purchase.variants?.length ?? 0})',
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
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Chip(
                                          label: Text(
                                            timeago.format(
                                              purchase.createdAt,
                                              clock: DateTime.now(),
                                            ),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                          ),
                                          backgroundColor: Colors.green,
                                          visualDensity: VisualDensity.compact,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.indigo
                                                  .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Text(
                                              'Total: ${purchase.totAmt}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.indigo[700],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.green.withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: TextButton.icon(
                                              icon: Icon(
                                                  Icons.check_circle_outline,
                                                  size: 16,
                                                  color: Colors.green),
                                              label: Text(
                                                'Accept All',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green[700],
                                                ),
                                              ),
                                              onPressed: () async {
                                                await widget.acceptPurchases(
                                                  purchases: [purchase],
                                                  pchsSttsCd:
                                                      '02', // Assuming '02' is the status code for accepted
                                                  purchase: purchase,
                                                  clickedVariant: null,
                                                );
                                              },
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 4),
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                minimumSize: Size.zero,
                                              ),
                                            ),
                                          ),
                                        ],
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
                                  Builder(builder: (context) {
                                    // Get variants directly from purchase object
                                    final purchaseVariants =
                                        purchase.variants ?? [];

                                    // Apply the selected status filter
                                    final List<Variant>
                                        filteredPurchaseVariants;
                                    if (_selectedStatusFilter == null) {
                                      filteredPurchaseVariants =
                                          purchaseVariants;
                                    } else {
                                      filteredPurchaseVariants =
                                          purchaseVariants
                                              .where((v) =>
                                                  v.pchsSttsCd ==
                                                  _selectedStatusFilter)
                                              .toList();
                                    }

                                    if (filteredPurchaseVariants.isEmpty) {
                                      return Padding(
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
                                              'No variants matching selected filter',
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    _dataSource = PurchaseDataSource(
                                      filteredPurchaseVariants,
                                      _editedRetailPrices,
                                      _editedSupplyPrices,
                                      talker,
                                      () => setState(() {}),
                                      widget.acceptPurchases,
                                      purchase,
                                    );
                                    return Padding(
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
                                            if (filteredPurchaseVariants
                                                .isNotEmpty)
                                              SizedBox(
                                                height:
                                                    300, // Adjust this value as needed
                                                child: SfDataGrid(
                                                  key:
                                                      UniqueKey(), // Add a key to force a rebuild when data changes
                                                  source: _dataSource,
                                                  columns:
                                                      buildPurchaseColumns(),
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
                                                          filteredPurchaseVariants[
                                                              details.rowColumnIndex
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
                                  }),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ], // End of Column children
          ), // End of Column (that's the 'else' part of the ternary)
        ); // End of Container (returned by the data callback)
      }, // End of data: (variants) { ... } callback block
    ); // End of variantsAsync.when(...)
  } // End of build method

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
