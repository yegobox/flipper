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
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bulkAddProductViewModelProvider).initializeControllers();
    });
  }

  @override
  void dispose() {
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
      setState(() {
        _errorMessage = e.toString();
      });
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
                  setState(() {
                    _errorMessage = null;
                  });
                  try {
                    if (model.excelData != null) {
                      await _showProgressDialog(model.saveAllWithProgress);
                    } else {
                      setState(() {
                        _errorMessage = 'No data to save';
                      });
                    }
                  } catch (e) {
                    setState(() {
                      _errorMessage = e.toString();
                    });
                  }
                },
                text: 'Save All',
              ),
            const SizedBox(height: 8.0),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
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
              if (mounted) {
                model.updateItemClass(barCode, newValue);
              }
            },
          ),
        );
      },
      loading: () => Text('Loading...'),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}
// import 'dart:io';

// import 'package:desktop_drop/desktop_drop.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flipper_dashboard/SaveProgressDialog.dart';
// import 'package:flipper_models/view_models/BulkAddProductViewModel.dart';
// import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
// import 'package:flipper_ui/flipper_ui.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:flutter/services.dart';
// import 'package:supabase_models/brick/models/all_models.dart';

// // Constants
// const String _dragAndDropText = "Drag and drop your Excel file here";
// const String _releaseToUploadText = "Release to upload file";
// const String _supportedFormatsText = "Supported formats: .xlsx, .xls";
// const String _parsingDataText = 'Parsing Data...';
// const String _noDataToSaveMessage = 'No data to save';
// const String _errorLoadingData = 'Error loading data';
// const String _selectedFileLabel = 'Selected File:';

// class BulkAddProduct extends StatefulHookConsumerWidget {
//   const BulkAddProduct({super.key});

//   @override
//   BulkAddProductState createState() => BulkAddProductState();
// }

// class BulkAddProductState extends ConsumerState<BulkAddProduct> {
//   String? _errorMessage;
//   bool _isDragging = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(bulkAddProductViewModelProvider).initializeControllers();
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Future<void> _showProgressDialog(
//     Future<void> Function(ValueNotifier<ProgressData>) savingFunction,
//   ) async {
//     final progressNotifier = ValueNotifier<ProgressData>(
//       ProgressData(progress: '', currentItem: 0, totalItems: 0),
//     );

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return ValueListenableBuilder<ProgressData>(
//           valueListenable: progressNotifier,
//           builder: (context, progressData, child) {
//             return SaveProgressDialog(
//               progress: progressData.progress,
//               currentItem: progressData.currentItem,
//               totalItems: progressData.totalItems,
//             );
//           },
//         );
//       },
//     );

//     try {
//       await savingFunction(progressNotifier);
//       // Add a small delay to show completion state
//       await Future.delayed(const Duration(milliseconds: 500));
//       Navigator.of(context).pop();
//       final combinedNotifier = ref.read(refreshProvider);
//       combinedNotifier.performActions(productName: "", scanMode: true);
//       Navigator.maybePop(context);
//     } catch (e) {
//       Navigator.of(context).pop();
//       setState(() {
//         _errorMessage = e.toString();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final model = ref.watch(bulkAddProductViewModelProvider);
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             DropTarget(
//               onDragDone: (details) async {
//                 if (details.files.isNotEmpty) {
//                   final file = File(details.files.first.path);
//                   final fileName = file.path.split('.').last.toLowerCase();

//                   if (fileName != 'xlsx' && fileName != 'xls') {
//                     setState(() {
//                       _errorMessage =
//                           'Invalid file format. Only .xlsx and .xls files are supported.';
//                     });
//                     return;
//                   }
//                   await model.selectFile(filePath: file.path);
//                 }
//                 setState(() {
//                   _isDragging = false;
//                 });
//               },
//               onDragEntered: (event) {
//                 setState(() {
//                   _isDragging = true;
//                 });
//               },
//               onDragExited: (event) {
//                 setState(() {
//                   _isDragging = false;
//                 });
//               },
//               child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   return AnimatedContainer(
//                     duration: const Duration(milliseconds: 200),
//                     decoration: BoxDecoration(
//                       color: _isDragging
//                           ? colorScheme.primaryContainer.withOpacity(0.1)
//                           : Colors.white,
//                       border: Border.all(
//                         color: _isDragging
//                             ? colorScheme.primary
//                             : colorScheme.outline.withOpacity(0.5),
//                         width: _isDragging ? 2.5 : 1.5,
//                       ),
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: _isDragging
//                           ? [
//                               BoxShadow(
//                                 color: colorScheme.primary.withOpacity(0.3),
//                                 blurRadius: 8,
//                                 spreadRadius: 1,
//                               )
//                             ]
//                           : [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 4,
//                                 spreadRadius: 0.5,
//                               )
//                             ],
//                     ),
//                     child: ConstrainedBox(
//                       constraints: BoxConstraints(
//                         minHeight: constraints.maxHeight,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(24.0),
//                         child: Stack(
//                           children: [
//                             if (model.selectedFile == null)
//                               Positioned.fill(
//                                 child: _buildFileUploadArea(model, colorScheme),
//                               ),
//                             if (model.selectedFile != null &&
//                                 model.excelData == null &&
//                                 !model.isLoading)
//                               Positioned.fill(
//                                 child: _buildParsingData(colorScheme),
//                               ),
//                             if (model.isLoading)
//                               Positioned.fill(
//                                 child: _buildLoadingIndicator(colorScheme),
//                               ),
//                             if (model.selectedFile != null &&
//                                 model.excelData != null)
//                               _buildSelectedFileArea(model, colorScheme),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFileUploadArea(
//       BulkAddProductViewModel model, ColorScheme colorScheme) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Container(
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             color: colorScheme.primaryContainer.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: _isDragging
//                   ? colorScheme.primary
//                   : colorScheme.outline.withOpacity(0.3),
//               width: _isDragging ? 2 : 1,
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.cloud_upload_outlined,
//                 size: 70,
//                 color: _isDragging
//                     ? colorScheme.primary
//                     : colorScheme.primary.withOpacity(0.7),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 _isDragging ? _releaseToUploadText : _dragAndDropText,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: _isDragging
//                       ? colorScheme.primary
//                       : colorScheme.onSurface.withOpacity(0.8),
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 "or",
//                 style: TextStyle(
//                   color: colorScheme.onSurface.withOpacity(0.6),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               FlipperButton(
//                 textColor: Colors.white,
//                 color: colorScheme.primary,
//                 onPressed: () async {
//                   await model.selectFile();
//                 },
//                 text: 'Choose Excel File',
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 _supportedFormatsText,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: colorScheme.onSurface.withOpacity(0.5),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSelectedFileArea(
//       BulkAddProductViewModel model, ColorScheme colorScheme) {
//     return Padding(
//       padding: const EdgeInsets.all(0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           ListTile(
//             title: Text(
//               _selectedFileLabel,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: colorScheme.onSurface.withOpacity(0.7),
//               ),
//             ),
//             subtitle: Text(
//               model.selectedFile!.name,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//                 color: colorScheme.onSurface,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//             trailing: IconButton(
//               onPressed: () {
//                 _clearFile();
//               },
//               icon: Icon(
//                 Icons.close,
//                 color: colorScheme.error,
//               ),
//               tooltip: 'Remove file',
//             ),
//           ),
//           const SizedBox(height: 24),
//           if (model.excelData != null) _buildDataTable(model, colorScheme),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               FlipperIconButton(
//                 textColor: Colors.white,
//                 onPressed: () async {
//                   setState(() {
//                     _errorMessage = null;
//                   });
//                   try {
//                     if (model.excelData != null) {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: const Text('Confirm Save'),
//                             content: const Text(
//                                 'Are you sure you want to save all products?'),
//                             actions: <Widget>[
//                               TextButton(
//                                 child: const Text('Cancel'),
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                 },
//                               ),
//                               TextButton(
//                                 child: const Text('Save'),
//                                 onPressed: () async {
//                                   Navigator.of(context).pop();
//                                   await _showProgressDialog(
//                                       model.saveAllWithProgress);
//                                 },
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     } else {
//                       setState(() {
//                         _errorMessage = _noDataToSaveMessage;
//                       });
//                     }
//                   } catch (e) {
//                     setState(() {
//                       _errorMessage = e.toString();
//                     });
//                   }
//                 },
//                 text: 'Save All',
//                 icon: Icons.save_outlined,
//               ),
//             ],
//           ),
//           if (_errorMessage != null)
//             Container(
//               margin: const EdgeInsets.only(top: 16),
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 color: colorScheme.error.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(
//                   color: colorScheme.error.withOpacity(0.5),
//                   width: 1,
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.error_outline,
//                     color: colorScheme.error,
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       _errorMessage!,
//                       style: TextStyle(
//                         color: colorScheme.error,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }

//   Widget _buildDataTable(
//       BulkAddProductViewModel model, ColorScheme colorScheme) {
//     return Expanded(
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               spreadRadius: 1,
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//               child: Text(
//                 'Product Data Preview',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                   color: colorScheme.onSurface,
//                 ),
//               ),
//             ),
//             Divider(
//               color: colorScheme.outline.withOpacity(0.3),
//               height: 1,
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: DataTable(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   headingRowColor: MaterialStateProperty.all(
//                     colorScheme.surfaceVariant.withOpacity(0.3),
//                   ),
//                   dataRowColor: MaterialStateProperty.resolveWith<Color?>(
//                     (Set<MaterialState> states) {
//                       if (states.contains(MaterialState.selected)) {
//                         return colorScheme.primaryContainer.withOpacity(0.1);
//                       }
//                       return null;
//                     },
//                   ),
//                   dividerThickness: 1,
//                   columns: [
//                     DataColumn(
//                       label: Text('BarCode',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                     ),
//                     DataColumn(
//                       label: Text('Name',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                     ),
//                     DataColumn(
//                       label: Text('Category',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                     ),
//                     DataColumn(
//                       label: Text('Price',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                     ),
//                     DataColumn(
//                       label: Text('Quantity',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                     ),
//                     DataColumn(
//                       label: Text('Item Class',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                     ),
//                     DataColumn(
//                       label: Text('Tax Type',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                     ),
//                     DataColumn(
//                       label: Text('Product Type',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                     ),
//                   ],
//                   rows: model.excelData!.map((product) {
//                     String barCode = product['BarCode'] ?? '';
//                     if (!model.controllers.containsKey(barCode)) {
//                       model.controllers[barCode] =
//                           TextEditingController(text: product['Price']);
//                     }
//                     if (!model.quantityControllers.containsKey(barCode)) {
//                       model.quantityControllers[barCode] =
//                           TextEditingController(
//                               text: product['Quantity'] ?? '0');
//                     }

//                     return DataRow(
//                       cells: [
//                         DataCell(Text(product['BarCode'] ?? '')),
//                         DataCell(Text(product['Name'] ?? '')),
//                         DataCell(Text(product['Category'] ?? '')),
//                         DataCell(
//                           SizedBox(
//                             width: 100,
//                             child: _buildTextField(
//                               model.controllers[barCode]!,
//                               (value) =>
//                                   model.updatePrice(product['BarCode'], value),
//                               colorScheme,
//                             ),
//                           ),
//                         ),
//                         DataCell(
//                           SizedBox(
//                             width: 80,
//                             child: _buildTextField(
//                               model.quantityControllers[barCode]!,
//                               (value) => model.updateQuantity(
//                                   product['BarCode'], value),
//                               colorScheme,
//                               isNumeric: true,
//                             ),
//                           ),
//                         ),
//                         DataCell(
//                           SizedBox(
//                             width: 200,
//                             child: _buildUniversalProductDropDown(
//                               context,
//                               barCode: barCode,
//                               selectedValue: model.selectedItemClasses[barCode],
//                               colorScheme: colorScheme,
//                             ),
//                           ),
//                         ),
//                         DataCell(
//                           SizedBox(
//                             width: 100,
//                             child: _buildTaxDropdown(
//                               context,
//                               barCode: barCode,
//                               selectedValue: model.selectedTaxTypes[barCode],
//                               colorScheme: colorScheme,
//                             ),
//                           ),
//                         ),
//                         DataCell(
//                           SizedBox(
//                             width: 100,
//                             child: _productTypeDropDown(
//                               context,
//                               barCode: barCode,
//                               selectedValue:
//                                   model.selectedProductTypes[barCode],
//                               colorScheme: colorScheme,
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(TextEditingController controller,
//       Function(String) onChanged, ColorScheme colorScheme,
//       {bool isNumeric = false}) {
//     return TextField(
//       controller: controller,
//       onChanged: onChanged,
//       keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
//       inputFormatters:
//           isNumeric ? [FilteringTextInputFormatter.digitsOnly] : null,
//       decoration: InputDecoration(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         isDense: true,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(4),
//           borderSide: BorderSide(
//             color: colorScheme.outline.withOpacity(0.5),
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(4),
//           borderSide: BorderSide(
//             color: colorScheme.primary,
//             width: 1.5,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _productTypeDropDown(
//     BuildContext context, {
//     required String barCode,
//     String? selectedValue,
//     required ColorScheme colorScheme,
//   }) {
//     final model = ref.watch(bulkAddProductViewModelProvider);
//     final List<Map<String, String>> options = [
//       {"name": "Raw Material", "value": "1"},
//       {"name": "Finished Product", "value": "2"},
//       {"name": "Service without stock", "value": "3"},
//     ];

//     // Use the first option's value as default if selectedValue is null
//     final effectiveValue = selectedValue ?? options.first['value'];

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 4.0),
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: colorScheme.outline.withOpacity(0.5),
//         ),
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: effectiveValue,
//           items: options.map((option) {
//             return DropdownMenuItem<String>(
//               value: option['value'],
//               child: Text(
//                 option['name']!,
//                 style: const TextStyle(fontSize: 14),
//               ),
//             );
//           }).toList(),
//           onChanged: (String? newValue) {
//             model.updateProductType(barCode, newValue);
//           },
//           isExpanded: true,
//           icon: Icon(
//             Icons.arrow_drop_down,
//             color: colorScheme.primary,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTaxDropdown(
//     BuildContext context, {
//     required String barCode,
//     String? selectedValue,
//     required ColorScheme colorScheme,
//   }) {
//     final model = ref.watch(bulkAddProductViewModelProvider);
//     final List<String> options = ["A", "B", "C", "D"];

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 4.0),
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: colorScheme.outline.withOpacity(0.5),
//         ),
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: selectedValue ?? "B",
//           items: options.map((String option) {
//             return DropdownMenuItem<String>(
//               value: option,
//               child: Text(option),
//             );
//           }).toList(),
//           onChanged: (String? newValue) {
//             model.updateTaxType(barCode, newValue);
//           },
//           isExpanded: true,
//           icon: Icon(
//             Icons.arrow_drop_down,
//             color: colorScheme.primary,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildUniversalProductDropDown(
//     BuildContext context, {
//     required String barCode,
//     String? selectedValue,
//     required ColorScheme colorScheme,
//   }) {
//     final model = ref.watch(bulkAddProductViewModelProvider);
//     final unitsAsyncValue = ref.watch(universalProductsNames);

//     return unitsAsyncValue.when(
//       data: (items) {
//         final List<String> itemClsCdList = items.asData?.value
//                 .map((unit) => ((unit.itemClsNm ?? "") + " " + unit.itemClsCd!))
//                 .toList() ??
//             [];

//         return DropdownSearch<String>(
//           items: (a, b) => itemClsCdList,
//           selectedItem: selectedValue ??
//               (itemClsCdList.isNotEmpty ? itemClsCdList.first : null),
//           compareFn: (String i, String s) => i == s,
//           decoratorProps: DropDownDecoratorProps(
//             decoration: InputDecoration(
//               isDense: true,
//               contentPadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(4),
//                 borderSide: BorderSide(
//                   color: colorScheme.outline.withOpacity(0.5),
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(4),
//                 borderSide: BorderSide(
//                   color: colorScheme.primary,
//                   width: 1.5,
//                 ),
//               ),
//             ),
//           ),
//           onChanged: (String? newValue) {
//             if (mounted) {
//               model.updateItemClass(barCode, newValue);
//             }
//           },
//           popupProps: const PopupProps.menu(
//             fit: FlexFit.loose,
//             menuProps: MenuProps(
//               elevation: 4,
//             ),
//           ),
//         );
//       },
//       loading: () => Center(
//         child: SizedBox(
//           width: 20,
//           height: 20,
//           child: CircularProgressIndicator(
//             strokeWidth: 2,
//             color: colorScheme.primary,
//           ),
//         ),
//       ),
//       error: (error, stackTrace) => Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: colorScheme.error.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(4),
//           border: Border.all(
//             color: colorScheme.error.withOpacity(0.5),
//           ),
//         ),
//         child: Text(
//           _errorLoadingData,
//           style: TextStyle(
//             color: colorScheme.error,
//             fontSize: 12,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingIndicator(ColorScheme colorScheme) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         CircularProgressIndicator(
//           color: colorScheme.primary,
//         ),
//         const SizedBox(height: 16),
//         Text(
//           'Processing...',
//           style: TextStyle(
//             color: colorScheme.primary,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildParsingData(ColorScheme colorScheme) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           _parsingDataText,
//           style: TextStyle(
//             fontSize: 16,
//             fontStyle: FontStyle.italic,
//             color: colorScheme.onSurface.withOpacity(0.7),
//           ),
//         ),
//       ],
//     );
//   }

//   void _clearFile() {
//     final model = ref.read(bulkAddProductViewModelProvider);
//     // model.clearFile();
//     setState(() {
//       _errorMessage = null;
//     });
//   }
// }
