import 'package:dropdown_search/dropdown_search.dart';
import 'package:flipper_dashboard/SaveProgressDialog.dart';
import 'package:flipper_models/view_models/BulkAddProductViewModel.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:supabase_models/brick/models/all_models.dart';

class BulkAddProduct extends StatefulHookConsumerWidget {
  const BulkAddProduct({super.key});

  @override
  BulkAddProductState createState() => BulkAddProductState();
}

class BulkAddProductState extends ConsumerState<BulkAddProduct> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bulkAddProductViewModelProvider).initializeControllers();
    });
  }

  @override
  void dispose() {
    ref.read(bulkAddProductViewModelProvider).disposeControllers();
    super.dispose();
  }

  Future<void> _showProgressDialog(
    Future<void> Function(ValueNotifier<ProgressData>) savingFunction,
  ) async {
    final progressNotifier = ValueNotifier<ProgressData>(
      ProgressData(progress: '', currentItem: 0, totalItems: 0),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ValueListenableBuilder<ProgressData>(
          valueListenable: progressNotifier,
          builder: (context, progressData, child) {
            return SaveProgressDialog(
              progress: progressData.progress,
              currentItem: progressData.currentItem,
              totalItems: progressData.totalItems,
            );
          },
        );
      },
    );

    try {
      await savingFunction(progressNotifier);
      // Add a small delay to show completion state
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.of(context).pop();
      final combinedNotifier = ref.read(refreshProvider);
      combinedNotifier.performActions(productName: "", scanMode: true);
      Navigator.maybePop(context);
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(bulkAddProductViewModelProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FlipperButton(
              textColor: Colors.black,
              onPressed: model.selectFile,
              text: model.selectedFile == null
                  ? 'Choose Excel File'
                  : 'Change Excel File',
            ),
            if (model.selectedFile != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Selected File: ${model.selectedFile!.name}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            if (model.selectedFile != null)
              FlipperButton(
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () async {
                  if (model.excelData != null) {
                    await _showProgressDialog(model.saveAllWithProgress);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No data to save')),
                    );
                  }
                },
                text: 'Save All',
              ),
            const SizedBox(height: 24.0),
            if (model.isLoading)
              const Center(child: CircularProgressIndicator()),
            if (model.excelData == null &&
                model.selectedFile != null &&
                !model.isLoading)
              const Center(
                child: Text('Parsing Data...',
                    style:
                        TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
              ),
            if (model.excelData != null)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    columns: [
                      DataColumn(
                        label: Text('BarCode',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Name',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Category',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Price',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Quantity',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Item Class',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Tax Type',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Product Type',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                    rows: model.excelData!.map((product) {
                      String barCode = product['BarCode'] ?? '';
                      if (!model.controllers.containsKey(barCode)) {
                        model.controllers[barCode] =
                            TextEditingController(text: product['Price']);
                      }
                      if (!model.quantityControllers.containsKey(barCode)) {
                        model.quantityControllers[barCode] =
                            TextEditingController(
                                text: product['Quantity'] ?? '0');
                      }

                      return DataRow(
                        cells: [
                          DataCell(Text(product['BarCode'] ?? '')),
                          DataCell(Text(product['Name'] ?? '')),
                          DataCell(Text(product['Category'] ?? '')),
                          DataCell(
                            TextField(
                              controller: model.controllers[barCode],
                              onChanged: (value) {
                                model.updatePrice(product['BarCode'], value);
                              },
                            ),
                          ),
                          DataCell(
                            TextField(
                              controller: model.quantityControllers[barCode],
                              onChanged: (value) {
                                model.updateQuantity(product['BarCode'], value);
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 200, // Fixed width, you can adjust this
                              child: _buildUniversalProductDropDown(
                                context,
                                barCode: barCode,
                                selectedValue: model.selectedItemClasses[
                                    barCode], // Use view model's data
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 100, // Fixed width, you can adjust this
                              child: _buildTaxDropdown(
                                context,
                                barCode: barCode,
                                selectedValue: model.selectedTaxTypes[
                                    barCode], // Use view model's data
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 100, // Fixed width, you can adjust this
                              child: _productTypeDropDown(
                                context,
                                barCode: barCode,
                                selectedValue: model.selectedProductTypes[
                                    barCode], // Use view model's data
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _productTypeDropDown(
    BuildContext context, {
    required String barCode,
    String? selectedValue,
  }) {
    final model = ref.watch(bulkAddProductViewModelProvider);
    final List<Map<String, String>> options = [
      {"name": "Raw Material", "value": "1"},
      {"name": "Finished Product", "value": "2"},
      {"name": "Service without stock", "value": "3"},
    ];

    // Use the first option's value as default if selectedValue is null
    final effectiveValue = selectedValue ?? options.first['value'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButtonHideUnderline(
        // Better way to hide underline
        child: DropdownButton<String>(
          value: effectiveValue,
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option['value'],
              child: Text(
                option['name']!,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            model.updateProductType(barCode, newValue);
          },
          isExpanded: true,
        ),
      ),
    );
  }

  Widget _buildTaxDropdown(BuildContext context,
      {required String barCode, String? selectedValue}) {
    final model = ref.watch(bulkAddProductViewModelProvider);
    final List<String> options = ["A", "B", "C", "D"];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<String>(
        value: selectedValue ?? "B",
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (String? newValue) {
          model.updateTaxType(barCode, newValue);
        },
        isExpanded: true,
        underline: const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildUniversalProductDropDown(
    BuildContext context, {
    required String barCode,
    String? selectedValue,
  }) {
    final model = ref.watch(bulkAddProductViewModelProvider);

    final unitsAsyncValue = ref.watch(universalProductsNames);

    return unitsAsyncValue.when(
      data: (items) {
        final List<String> itemClsCdList = items.asData?.value
                .map((unit) => ((unit.itemClsNm ?? "") + " " + unit.itemClsCd!))
                .toList() ??
            [];

        return Container(
          width: double.infinity,
          child: DropdownSearch<String>(
            items: (a, b) => itemClsCdList,
            selectedItem: selectedValue ??
                (itemClsCdList.isNotEmpty ? itemClsCdList.first : null),
            compareFn: (String i, String s) => i == s,
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
              ),
            ),
            onChanged: (String? newValue) {
              model.updateItemClass(barCode, newValue);
            },
          ),
        );
      },
      loading: () => Text('Loading...'),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}
