import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_models/providers/variants_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ImportSalesWidget extends StatefulHookConsumerWidget {
  final Future<List<Variant>>? futureResponse;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController supplyPriceController;
  final TextEditingController retailPriceController;
  final void Function() saveChangeMadeOnItem;
  final void Function() acceptAllImport;
  final void Function(Variant? selectedItem) selectItem;
  final Variant? selectedItem;
  final List<Variant> finalItemList;
  final Map<String, Variant> variantMap;

  const ImportSalesWidget({
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
  });

  @override
  ImportSalesWidgetState createState() => ImportSalesWidgetState();
}

class ImportSalesWidgetState extends ConsumerState<ImportSalesWidget> {
  bool _isLoading = false;
  late VariantDataSource _variantDataSource;
  Variant? variantSelectedWhenClickingOnRow;

  @override
  void initState() {
    super.initState();
    _variantDataSource = VariantDataSource([], this);
  }

  Future<void> _handleApproval(Variant item) async {
    setState(() => _isLoading = true);
    try {
      Variant? variantToUpdate = widget.variantMap[item.id];

      /// Avoid self-update of the stock
      if (variantToUpdate != null && variantToUpdate.id != item.id) {
        variantToUpdate.ebmSynced = false;
        await ProxyService.strategy
            .updateVariant(updatables: [variantToUpdate]);
        talker.warning("KEE${item.stock!.currentStock}");
        await ProxyService.strategy.updateStock(
          stockId: variantToUpdate.stock!.id,
          currentStock: item.stock!.currentStock,
        );
      }

      await _processVariantApproval(item);
    } catch (e, s) {
      talker.error(s);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error approving item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _processVariantApproval(Variant item) async {
    item.imptItemSttsCd = "3";
    item.ebmSynced = false;
    await ProxyService.strategy.updateVariant(updatables: [item]);

    final combinedNotifier = ref.read(refreshProvider);
    combinedNotifier.performActions(productName: "", scanMode: true);

    final URI = await ProxyService.box.getServerUrl();
    if (URI != null) {
      await VariantPatch.patchVariant(
        URI: URI,
        identifier: item.id,
        sendPort: (message) {
          ProxyService.notification.sendLocalNotification(body: message);
        },
      );

      await StockPatch.patchStock(
        identifier: item.id,
        URI: URI,
        sendPort: (message) {
          ProxyService.notification.sendLocalNotification(body: message);
        },
      );
    }

    await ProxyService.tax.updateImportItems(
      item: item,
      URI: URI ?? "",
    );

    item.ebmSynced = true;
    ProxyService.strategy.updateVariant(updatables: [item]);
    _variantDataSource.updateDataSource();
  }

  Future<void> _handleRejection(Variant item) async {
    setState(() => _isLoading = true);
    try {
      item.imptItemSttsCd = "4";
      item.ebmSynced = false;
      await ProxyService.strategy.updateVariant(updatables: [item]);

      final URI = await ProxyService.box.getServerUrl();
      await VariantPatch.patchVariant(
        URI: URI!,
        identifier: item.id,
        sendPort: (message) {
          ProxyService.notification.sendLocalNotification(body: message);
        },
      );
      await StockPatch.patchStock(
        identifier: item.id,
        URI: URI,
        sendPort: (message) {
          ProxyService.notification.sendLocalNotification(body: message);
        },
      );
      await ProxyService.tax.updateImportItems(
          item: item, URI: await ProxyService.box.getServerUrl() ?? "");

      item.ebmSynced = true;
      ProxyService.strategy.updateVariant(updatables: [item]);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item rejected successfully'),
          backgroundColor: Colors.orange,
        ),
      );
      _variantDataSource.updateDataSource();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error rejecting item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 400,
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<List<Variant>>(
            future: widget.futureResponse,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => setState(() {}),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data!.isEmpty) {
                return const Center(
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
                );
              }

              final itemList = snapshot.data ?? [];
              widget.finalItemList
                ..clear()
                ..addAll(itemList);

              _variantDataSource = VariantDataSource(itemList, this);

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

                    return DropdownButton<String>(
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
                          // print(
                          //     "Proff:${variantSelectedWhenClickingOnRow?.name}");
                          // Update the map when a variant is selected
                          widget.variantMap[variantSelectedWhenClickingOnRow!
                              .id] = selectedVariant;
                        } else {
                          widget.selectItem(null);
                        }
                      },
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
          onPressed: _isLoading ? null : widget.saveChangeMadeOnItem,
          text: 'Save Changes',
          textColor: Colors.black,
        ),
        const SizedBox(width: 8),
        FlipperIconButton(
          onPressed: _isLoading ? null : widget.acceptAllImport,
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
            // Add/Update the variant in the map when row is selected
            widget.variantMap[selectedVariant!.id] = selectedVariant;
            _updateTextFields(selectedVariant); // Update TextFields
          } else {
            widget.selectItem(null);
          }
        },
        columns: [
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
    widget.supplyPriceController.text =
        variant.supplyPrice?.toString() ?? ''; // Ensure null safety
    widget.retailPriceController.text =
        variant.retailPrice?.toString() ?? ''; // Ensure null safety
  }
}

class VariantDataSource extends DataGridSource {
  final List<Variant> _variants;
  final ImportSalesWidgetState _state;
  List<DataGridRow> _dataGridRows = [];

  VariantDataSource(this._variants, this._state) {
    updateDataSource();
  }

  void updateDataSource() {
    _dataGridRows = _variants.map<DataGridRow>((variant) {
      return DataGridRow(cells: [
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
          value: '${variant.stock!.currentStock} ${variant.qtyUnitCd}',
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
          value: _buildStatusWidget(variant),
        ),
        DataGridCell<Widget>(
          columnName: 'actions',
          value: _buildActionsWidget(variant),
        ),
      ]);
    }).toList();
    notifyListeners();
  }

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
          'Waiting Approval',
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    return const Text('Processed');
  }

  Widget _buildActionsWidget(Variant variant) {
    final isWaitingApproval = variant.imptItemSttsCd == "2";
    if (!isWaitingApproval) {
      return const Text('-');
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          onPressed:
              _state._isLoading ? null : () => _state._handleApproval(variant),
          tooltip: 'Approve',
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.all(8),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.cancel_outlined, color: Colors.red),
          onPressed:
              _state._isLoading ? null : () => _state._handleRejection(variant),
          tooltip: 'Reject',
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.all(8),
        ),
      ],
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
      cells: row.getCells().map<Widget>((dataGridCell) {
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
