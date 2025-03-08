import 'package:flipper_models/providers/variants_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';

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
    required this.finalSalesList,
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController supplyPriceController;
  final TextEditingController retailPriceController;
  final void Function(
    Variant? itemToAssign,
    Variant? itemFromPurchase,
  ) selectSale;
  final List<Variant> finalSalesList;
  final VoidCallback saveItemName;
  final void Function(List<Variant> acceptedVariants, String pchsSttsCd)
      acceptPurchases;

  @override
  ConsumerState<PurchaseTable> createState() => _DataRowWidgetState();
}

class _DataRowWidgetState extends ConsumerState<PurchaseTable> {
  final Map<String, double> _editedRetailPrices = {};
  final Map<String, double> _editedSupplyPrices = {};
  final Talker talker = TalkerFlutter.init();
  late _DataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = _DataSource(
      widget.finalSalesList,
      _editedRetailPrices,
      _editedSupplyPrices,
      talker,
      _updateDataGrid,
      widget.acceptPurchases,
    );
  }

  void _updateDataGrid() {
    setState(() {
      _dataSource.updatePrices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final variantProviders =
        ref.watch(variantProvider(branchId: ProxyService.box.getBranchId()!));

    return Container(
      width: double.infinity,
      child: widget.finalSalesList.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hourglass_empty, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No Data Found',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
            )
          : SfDataGrid(
              source: _dataSource,
              columns: _buildColumns(),
              columnWidthMode: ColumnWidthMode.fill,
              headerRowHeight: 56.0,
              rowHeight: 48.0,
              selectionMode: SelectionMode.single,
              onCellTap: (DataGridCellTapDetails details) {
                if (details.rowColumnIndex.rowIndex > 0) {
                  final item = widget
                      .finalSalesList[details.rowColumnIndex.rowIndex - 1];
                  _showEditDialog(context, item, variants: variantProviders);
                }
              },
            ),
    );
  }

  void _showEditDialog(BuildContext context, Variant item,
      {required AsyncValue<List<Variant>> variants}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 890),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                _buildItemsTable(item, variants: variants),
                const SizedBox(height: 24),
                _buildDialogActions(context),
              ],
            ),
          ),
        ),
      ),
    ).then((_) {
      _updateDataGrid();
    });
  }

  Widget _buildItemsTable(Variant item,
      {required AsyncValue<List<Variant>> variants}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Item Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.grey.shade200,
                dataTableTheme: DataTableThemeData(
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                  dataTextStyle: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                  headingRowColor:
                      WidgetStateProperty.all(Colors.grey.shade100),
                  horizontalMargin: 16,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DataTable(
                  headingRowHeight: 56,
                  columnSpacing: 24,
                  columns: const [
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Item Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Qty',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Supply',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Retail',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Item to assign',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.inventory_2,
                                      color: Colors.blue.shade400,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item.stock!.currentStock.toString(),
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: _buildPriceTextField(
                              initialValue:
                                  _editedSupplyPrices[item.id]?.toString() ??
                                      item.supplyPrice?.toString() ??
                                      '',
                              hintText: 'Supply',
                              onChanged: (value) {
                                final supplyPrice = double.tryParse(value);
                                if (supplyPrice != null) {
                                  _editedSupplyPrices[item.id] = supplyPrice;
                                  _updateDataGrid();
                                }
                              },
                            ),
                          ),
                        ),
                        DataCell(
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: _buildPriceTextField(
                              initialValue:
                                  _editedRetailPrices[item.id]?.toString() ??
                                      item.retailPrice?.toString() ??
                                      '',
                              hintText: 'Retail',
                              onChanged: (value) {
                                final retailPrice = double.tryParse(value);
                                if (retailPrice != null) {
                                  _editedRetailPrices[item.id] = retailPrice;
                                  _updateDataGrid();
                                }
                              },
                            ),
                          ),
                        ),
                        DataCell(
                          Consumer(builder: (context, ref, _) {
                            final selectedVariant =
                                ref.watch(selectedVariantProvider(item.id));
                            final setSelectedVariant = ref.read(
                                selectedVariantProvider(item.id).notifier);

                            return variants.when(
                              data: (variants) {
                                return DropdownSearch<Variant>(
                                  selectedItem: selectedVariant,
                                  // Provide the list of items directly.
                                  items: (a, b) => variants,
                                  // Add compareFn to compare Variant objects correctly
                                  compareFn: (Variant i, Variant s) =>
                                      i.id == s.id,
                                  itemAsString: (Variant v) => v.name,
                                  decoratorProps: const DropDownDecoratorProps(
                                    baseStyle: TextStyle(fontSize: 13),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  onChanged: (Variant? itemToAssign) {
                                    setSelectedVariant.state = itemToAssign;
                                    widget.selectSale(itemToAssign, item);
                                  },
                                );
                              },
                              loading: () => const Text("Loading variants..."),
                              error: (error, stack) => Text('Error: $error'),
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceTextField({
    required String initialValue,
    required String hintText,
    required Function(String) onChanged,
  }) {
    return SizedBox(
      width: 100,
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: hintText,
          prefixText: '\RWF ',
          prefixStyle: const TextStyle(color: Colors.black87),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required';
          }
          if (double.tryParse(value) == null) {
            return 'Invalid number';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDialogActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FlipperButtonFlat(
          textColor: Colors.red,
          onPressed: () => Navigator.of(context).pop(),
          text: 'Cancel',
        ),
        const SizedBox(width: 16),
        FlipperButton(
          textColor: Colors.black,
          onPressed: () {
            _editedRetailPrices.forEach((id, retailPrice) {
              final variant = widget.finalSalesList.firstWhere(
                (v) => v.id == id,
                orElse: () => throw Exception('Variant not found'),
              );
              variant.retailPrice = retailPrice;
              ProxyService.strategy.updateVariant(updatables: [variant]);
            });

            _editedSupplyPrices.forEach((id, supplyPrice) {
              final variant = widget.finalSalesList.firstWhere(
                (v) => v.id == id,
                orElse: () => throw Exception('Variant not found'),
              );
              variant.supplyPrice = supplyPrice;
              ProxyService.strategy.updateVariant(updatables: [variant]);
            });

            talker.log(
                'Prices updated for items: ${_editedRetailPrices.keys.join(', ')}');
            Navigator.of(context).pop();
          },
          text: 'Save Changes',
        ),
      ],
    );
  }

  List<GridColumn> _buildColumns() {
    const headerStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16.0,
      letterSpacing: 0.5,
    );

    return [
      GridColumn(
        columnName: 'itemName!',
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Item Name',
            style: headerStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'quantity',
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text(
            'Quantity',
            style: headerStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'supplyPrice',
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerRight,
          child: const Text(
            'Supply Price',
            style: headerStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'retailPrice',
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerRight,
          child: const Text(
            'Retail Price',
            style: headerStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'status',
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text(
            'Status',
            style: headerStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'Supplier',
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text(
            'Supplier',
            style: headerStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'actions',
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text(
            'Actions',
            style: headerStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ];
  }
}

class _DataSource extends DataGridSource {
  _DataSource(
    this.finalSalesList,
    this.editedRetailPrices,
    this.editedSupplyPrices,
    this.talker,
    this.updateStatus,
    this.acceptPurchases,
  ) {
    buildDataGridRows();
  }

  final List<Variant> finalSalesList;
  final Map<String, double> editedRetailPrices;
  final Map<String, double> editedSupplyPrices;
  final Talker talker;
  final VoidCallback updateStatus;
  final void Function(List<Variant> acceptedVariants, String pchsSttsCd)
      acceptPurchases;

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = finalSalesList.map<DataGridRow>((variant) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'itemName', value: variant.name),
        DataGridCell<int>(
            columnName: 'quantity',
            value: (variant.stock?.currentStock ?? 0).toInt()),
        DataGridCell<double>(
            columnName: 'supplyPrice',
            value:
                editedSupplyPrices[variant.id] ?? variant.supplyPrice ?? 0.0),
        DataGridCell<double>(
            columnName: 'retailPrice',
            value:
                editedRetailPrices[variant.id] ?? variant.retailPrice ?? 0.0),
        DataGridCell<Widget>(
          columnName: 'status',
          value: _buildStatusWidget(variant),
        ),
        DataGridCell<String>(
          columnName: 'Supplier',
          value: variant.spplrNm ?? '',
        ),
        DataGridCell<Widget>(
          columnName: 'actions',
          value: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: () => _onStatusChange(variant.id, "02"),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => _onStatusChange(variant.id, "04"),
              ),
            ],
          ),
        ),
      ]);
    }).toList();
  }

  Widget _buildStatusWidget(Variant variant) {
    Color badgeColor;
    String statusText;

    switch (variant.pchsSttsCd) {
      case "01":
        badgeColor = Colors.orange.withValues(alpha: .2);
        statusText = 'Pending';
        break;
      case "02":
        badgeColor = Colors.green.withValues(alpha: 0.2);
        statusText = 'Accepted';
        break;
      case "04":
        badgeColor = Colors.red.withValues(alpha: 0.2);
        statusText = 'Canceled';
        break;
      default:
        badgeColor = Colors.grey.withValues(alpha: 0.2);
        statusText = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: badgeColor.withValues(alpha: 1.0),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _onStatusChange(String id, String status) {
    final variant = finalSalesList.firstWhere((v) => v.id == id);
    variant.pchsSttsCd = status;

    acceptPurchases([variant], status);

    talker.log(
        'Updating status for variant: ${variant.name} from ${variant.pchsSttsCd} to $status');
    updateStatus();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: dataGridCell.columnName == 'retailPrice' ||
                  dataGridCell.columnName == 'supplyPrice'
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: dataGridCell.columnName == 'status' ||
                  dataGridCell.columnName == 'actions'
              ? dataGridCell.value
              : Text(
                  dataGridCell.value.toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 14.0,
                    letterSpacing: 0.3,
                  ),
                ),
        );
      }).toList(),
    );
  }

  void updatePrices() {
    buildDataGridRows();
    notifyListeners();
  }
}
