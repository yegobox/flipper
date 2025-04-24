import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/variants_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:timeago/timeago.dart' as timeago;

class Imports extends StatefulHookConsumerWidget {
  final Future<List<Variant>>? futureResponse;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController supplyPriceController;
  final TextEditingController retailPriceController;
  final void Function() saveChangeMadeOnItem;
  final void Function(List<Variant> variants) acceptAllImport;
  final void Function(Variant? selectedItem) selectItem;
  final Variant? selectedItem;
  final List<Variant> finalItemList;
  final Map<String, Variant> variantMap;
  final Future<void> Function(Variant, Map<String, Variant>) onApprove;
  final Future<void> Function(Variant, Map<String, Variant>) onReject;

  const Imports({
    super.key,
    required this.futureResponse,
    required this.formKey,
    required this.nameController,
    required this.supplyPriceController,
    required this.retailPriceController,
    required this.saveChangeMadeOnItem,
    required this.acceptAllImport,
    required this.selectItem,
    required this.selectedItem,
    required this.finalItemList,
    required this.variantMap,
    required this.onApprove,
    required this.onReject,
  });

  @override
  ImportsState createState() => ImportsState();
}

class ImportsState extends ConsumerState<Imports> {
  late VariantDataSource _variantDataSource;
  Variant? variantSelectedWhenClickingOnRow;

  Widget _buildStatusWidget(Variant variant) {
    final isWaitingApproval = variant.imptItemSttsCd == "2";
    if (isWaitingApproval) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'Wait',
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    return const Text('Done');
  }

  Widget _buildActionsWidget(Variant variant) {
    final bool isWaitingApproval = variant.imptItemSttsCd == "2";
    final bool isApproved = variant.imptItemSttsCd == "3";

    if (!isWaitingApproval) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isApproved ? Colors.green.shade100 : Colors.red.shade100,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isApproved ? Colors.green : Colors.red,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isApproved ? Icons.check_circle : Icons.cancel,
              size: 16,
              color: isApproved ? Colors.green.shade700 : Colors.red.shade700,
            ),
            const SizedBox(width: 8),
            Text(
              isApproved ? 'Approved' : 'Rejected',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isApproved ? Colors.green.shade700 : Colors.red.shade700,
              ),
            ),
          ],
        ),
      );
    }

    final bool approveIsLoading =
        _variantDataSource.isApproveLoading(variant.id);
    final bool rejectIsLoading = _variantDataSource.isRejectLoading(variant.id);
    final bool isProcessing = approveIsLoading || rejectIsLoading;

    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 36,
            width: 36,
            child: _variantDataSource._buildActionButton(
              isLoading: approveIsLoading,
              icon: Icons.check_circle_outline,
              color: Colors.green,
              tooltip: 'Approve',
              onPressed: isProcessing ? null : () => _handleApproval(variant),
            ),
          ),
          SizedBox(
            height: 36,
            width: 36,
            child: _variantDataSource._buildActionButton(
              isLoading: rejectIsLoading,
              icon: Icons.cancel_outlined,
              color: Colors.red,
              tooltip: 'Reject',
              onPressed: isProcessing ? null : () => _handleRejection(variant),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _variantDataSource = VariantDataSource(
      [],
      this,
      buildStatusWidget: _buildStatusWidget,
      buildActionsWidget: _buildActionsWidget,
    );
  }

  Future<void> _handleApproval(Variant item) async {
    // Update both local state and datasource state
    _variantDataSource.setApproveLoading(item.id, true);

    try {
      await widget.onApprove(item, widget.variantMap);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error approving item: $e'),
            backgroundColor: Colors.red),
      );
    } finally {
      // Important: Always update the state when the operation completes
      _variantDataSource.setApproveLoading(item.id, false);
    }
  }

  Future<void> _handleRejection(Variant item) async {
    // Update both local state and datasource state

    _variantDataSource.setRejectLoading(item.id, true);

    try {
      await widget.onReject(item, widget.variantMap);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error rejecting item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Important: Always update the state when the operation completes
      _variantDataSource.setRejectLoading(item.id, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<List<Variant>>(
            future: widget.futureResponse,
            builder: (context, snapshot) {
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data!.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.hourglass_empty, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No Data Found or Network error please try again.',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ],
                  ),
                );
              }

              final itemList = snapshot.data ?? [];
              widget.finalItemList
                ..clear()
                ..addAll(itemList);
              _variantDataSource = VariantDataSource(itemList, this,
                  buildStatusWidget: _buildStatusWidget,
                  buildActionsWidget: _buildActionsWidget);
              return SizedBox(
                width: constraints.maxWidth,
                child: Form(
                  key: widget.formKey,
                  child: Column(
                    children: [
                      _buildInputRow(),
                      const SizedBox(height: 16),
                      Expanded(
                        child: _buildDataGrid(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildInputRow() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: widget.nameController,
                hintText: 'Enter a name',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: widget.supplyPriceController,
                hintText: 'Enter supply price',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Supply price is required' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: widget.retailPriceController,
                hintText: 'Enter retail price',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Retail price is required' : null,
              ),
            ),
            const SizedBox(width: 16),
            Consumer(
              builder: (context, ref, child) {
                final variantProviders = ref.watch(
                  variantProvider(branchId: ProxyService.box.getBranchId()!),
                );

                return variantProviders.when(
                  data: (variants) {
                    final Variant? selectedVariantObject =
                        widget.selectedItem != null
                            ? variants.firstWhere(
                                (variant) =>
                                    variant.id == widget.selectedItem!.id,
                                orElse: () => variants.first,
                              )
                            : null;

                    return Column(
                      children: [
                        DropdownButton<String>(
                          value: selectedVariantObject?.id,
                          hint: const Text('Select Variant'),
                          items: variants.map((variant) {
                            return DropdownMenuItem<String>(
                              value: variant.id,
                              child: Text(variant.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              final selectedVariant = variants
                                  .firstWhere((variant) => variant.id == value);
                              widget.variantMap.clear();
                              if (variantSelectedWhenClickingOnRow != null) {
                                widget.variantMap.putIfAbsent(
                                    variantSelectedWhenClickingOnRow!.id,
                                    () => selectedVariant);
                              } else if (widget.finalItemList.isNotEmpty) {
                                widget.variantMap.putIfAbsent(
                                    widget.finalItemList.first.id,
                                    () => selectedVariant);
                              }
                              widget.selectItem(selectedVariant);
                            } else {
                              widget.selectItem(null);
                            }
                          },
                        ),
                      ],
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text('Error: $error'),
                );
              },
            ),
            const SizedBox(width: 16),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
  }) {
    return StyledTextFormField.create(
      context: context,
      labelText: hintText,
      hintText: hintText,
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      minLines: 1,
      onChanged: (value) {
        setState(() {});
      },
      validator: validator,
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        FlipperButton(
          onPressed: _variantDataSource.anyLoading
              ? null
              : widget.saveChangeMadeOnItem,
          text: 'Save Changes',
          textColor: Colors.black,
        ),
        const SizedBox(width: 8),
        FlipperIconButton(
          onPressed: _variantDataSource.anyLoading
              ? null
              : () => widget.acceptAllImport(widget.finalItemList),
          icon: Icons.done_all,
          text: 'Accept All',
        ),
      ],
    );
  }

  Widget _buildDataGrid() {
    return Card(
      elevation: 2,
      child: SfDataGrid(
        source: _variantDataSource,
        selectionMode: SelectionMode.single,
        columnWidthMode: ColumnWidthMode.fill,
        onSelectionChanged: (addedRows, removedRows) {
          if (addedRows.isNotEmpty) {
            final selectedVariant = _variantDataSource
                .getVariantAt(_variantDataSource.rows.indexOf(addedRows.first));
            widget.selectItem(selectedVariant);
            setState(() {
              variantSelectedWhenClickingOnRow = selectedVariant;
            });
            widget.variantMap.clear();
            widget.variantMap
                .putIfAbsent(selectedVariant!.id, () => selectedVariant);
            _updateTextFields(selectedVariant);
          } else {
            widget.selectItem(null);
          }
        },
        columns: [
          GridColumn(
            columnName: 'rowNumber',
            width: 70,
            label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: const Text(
                'No.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: 'itemName',
            label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Item Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: 'hsCode',
            label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: const Text(
                'HS Code',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: 'quantity',
            label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Quantity',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: 'retailPrice',
            label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Retail Price',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: 'supplyPrice',
            label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Supply Price',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: 'status',
            label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Status',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: 'Supplier',
            label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Supplier',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: 'actions',
            label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Actions',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateTextFields(Variant variant) {
    widget.nameController.text = variant.itemNm ?? variant.name;
    widget.supplyPriceController.text = variant.supplyPrice?.toString() ?? '';
    widget.retailPriceController.text = variant.retailPrice?.toString() ?? '';
  }
}

class VariantDataSource extends DataGridSource {
  final List<Variant> _variants;
  final ImportsState _state;
  final Widget Function(Variant) buildStatusWidget;
  final Widget Function(Variant) buildActionsWidget;
  List<DataGridRow> _dataGridRows = [];
  final Map<String, bool> _approveLoadingState = {};
  final Map<String, bool> _rejectLoadingState = {};

  VariantDataSource(
    this._variants,
    this._state, {
    required this.buildStatusWidget,
    required this.buildActionsWidget,
  }) {
    for (final variant in _variants) {
      _approveLoadingState[variant.id] = false;
      _rejectLoadingState[variant.id] = false;
    }
    updateDataSource();
  }

  void setApproveLoading(String variantId, bool isLoading) {
    if (_approveLoadingState.containsKey(variantId)) {
      _approveLoadingState[variantId] = isLoading;
    } else {
      _approveLoadingState[variantId] = isLoading;
      talker.warning("Variant ID $variantId was missing, adding it now.");
    }
    updateDataSource(); // Rebuild rows with new state
  }

  void setRejectLoading(String variantId, bool isLoading) {
    if (_rejectLoadingState.containsKey(variantId)) {
      _rejectLoadingState[variantId] = isLoading;
    } else {
      _rejectLoadingState[variantId] = isLoading;
      talker.warning("Variant ID $variantId was missing, adding it now.");
    }
    updateDataSource(); // Rebuild rows with new state
  }

  bool isApproveLoading(String variantId) {
    return _approveLoadingState[variantId] ?? false;
  }

  bool isRejectLoading(String variantId) {
    return _rejectLoadingState[variantId] ?? false;
  }

  bool get anyLoading =>
      _approveLoadingState.values.any((isLoading) => isLoading) ||
      _rejectLoadingState.values.any((isLoading) => isLoading);

  void updateDataSource() {
    _dataGridRows = _variants.asMap().entries.map<DataGridRow>((entry) {
      final index = entry.key;
      final variant = entry.value;
      return DataGridRow(cells: [
        DataGridCell<int>(
          columnName: 'rowNumber',
          value: index + 1,
        ),
        DataGridCell<String>(
          columnName: 'itemName',
          value: variant.itemNm ?? variant.name,
        ),
        DataGridCell<String>(
          columnName: 'hsCode',
          value: variant.hsCd?.toString() ?? '',
        ),
        DataGridCell<String>(
          columnName: 'quantity',
          value: '${variant.stock?.currentStock} ${variant.qtyUnitCd}',
        ),
        DataGridCell<double>(
          columnName: 'retailPrice',
          value: variant.retailPrice ?? 0.0,
        ),
        DataGridCell<double>(
          columnName: 'supplyPrice',
          value: variant.supplyPrice ?? 0.0,
        ),
        DataGridCell<Widget>(
          columnName: 'status',
          value: buildStatusWidget(variant),
        ),
        DataGridCell<Widget>(
          columnName: 'Supplier',
          value: Text(variant.spplrNm ?? ""),
        ),
        DataGridCell<Widget>(
          columnName: 'actions',
          value: buildActionsWidget(variant),
        ),
      ]);
    }).toList();
    notifyListeners();
  }

  Widget _buildActionButton({
    required bool isLoading,
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback? onPressed,
  }) {
    return Center(
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            )
          : Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: onPressed,
                child: Tooltip(
                  message: tooltip,
                  child: Icon(icon, color: color, size: 20),
                ),
              ),
            ),
    );
  }

  Variant? getVariantAt(int index) {
    if (index >= 0 && index < _variants.length) {
      return _variants[index];
    }
    return null;
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().asMap().entries.map<Widget>((entry) {
        final dataGridCell = entry.value;
        if (dataGridCell.columnName == 'rowNumber') {
          return Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: Text(
              dataGridCell.value.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }
        if (dataGridCell.value is Widget) {
          return Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: dataGridCell.value as Widget,
          );
        }
        return Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }

  @override
  bool shouldRecalculateColumnWidths() => true;
}
