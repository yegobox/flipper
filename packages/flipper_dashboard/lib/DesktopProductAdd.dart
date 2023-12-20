import 'dart:async';

import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/isar_models.dart';

class QuantityCell extends StatelessWidget {
  final double? quantity;
  final VoidCallback onEdit;

  const QuantityCell({required this.quantity, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Row(
        children: [
          Text(quantity.toString()),
          const Icon(
              Icons.edit), // You can replace this icon with your edit icon
        ],
      ),
    );
  }
}

class ProductEntryScreen extends StatefulHookConsumerWidget {
  const ProductEntryScreen({super.key});

  @override
  ProductEntryScreenState createState() => ProductEntryScreenState();
}

class ProductEntryScreenState extends ConsumerState<ProductEntryScreen> {
  int _portraitCrossAxisCount = 4;
  int _landscapeCrossAxisCount = 5;
  double _borderRadius = 30;
  double _blurRadius = 5;
  double _iconSize = 24;
  Color pickerColor = Colors.amber;

  void changeColor(Color color) => setState(() => pickerColor = color);

  Widget pickerLayoutBuilder(
      BuildContext context, List<Color> colors, PickerItem child) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return SizedBox(
      width: 300,
      height: orientation == Orientation.portrait ? 360 : 240,
      child: GridView.count(
        crossAxisCount: orientation == Orientation.portrait
            ? _portraitCrossAxisCount
            : _landscapeCrossAxisCount,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        children: [for (Color color in colors) child(color)],
      ),
    );
  }

  Widget pickerItemBuilder(
      Color color, bool isCurrentColor, void Function() changeColor) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: color,
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.8),
              offset: const Offset(1, 2),
              blurRadius: _blurRadius)
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: changeColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: isCurrentColor ? 1 : 0,
            child: Icon(
              Icons.done,
              size: _iconSize,
              color: useWhiteForeground(color) ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  TextEditingController productNameController = TextEditingController();
  TextEditingController retailPriceController = TextEditingController();
  TextEditingController supplyPriceController = TextEditingController();
  TextEditingController scannedInputController = TextEditingController();
  FocusNode scannedInputFocusNode = FocusNode();
  Timer? _inputTimer;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _inputTimer?.cancel();
    productNameController.dispose();
    retailPriceController.dispose();
    scannedInputController.dispose();
    supplyPriceController.dispose();
    scannedInputFocusNode.dispose();
    super.dispose();
  }

  void _showEditQuantityDialog(
    BuildContext context,
    Variant variant,
    ScannViewModel model,
    VoidCallback onDialogClosed,
  ) {
    TextEditingController quantityController =
        TextEditingController(text: variant.qty.toString());

    // Create a FocusNode and set autofocus to true
    FocusNode focusNode = FocusNode();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Quantity'),
          content: TextFormField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Quantity'),
            focusNode: focusNode,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double newQuantity =
                    double.tryParse(quantityController.text) ?? 0.0;
                model.updateVariantQuantity(variant.id, newQuantity);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    // Use WidgetsBinding.instance?.addPostFrameCallback to focus after the frame is painted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });

    // Add a callback to execute when the dialog is closed
    Navigator.of(context).popUntil((route) {
      onDialogClosed();
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productRef = ref.watch(productProvider);
    return ViewModelBuilder<ScannViewModel>.reactive(
      viewModelBuilder: () => ScannViewModel(),
      onViewModelReady: (model) async {
        Product product = await model.createProduct(name: TEMP_PRODUCT);
        ref.read(productProvider.notifier).emitProduct(value: product);
        model.initialize();
      },
      builder: (context, model, child) {
        return Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: SizedBox(
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 300, // Set a specific width
                      height: 50, // Set a specific height
                      child: Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          content: SingleChildScrollView(
                                        child: BlockPicker(
                                          pickerColor: pickerColor,
                                          onColorChanged: changeColor,
                                          availableColors: colors,
                                          layoutBuilder: pickerLayoutBuilder,
                                        ),
                                      ));
                                    });
                              },
                              child: Icon(Icons.color_lens,
                                  color: useWhiteForeground(pickerColor)
                                      ? Colors.white
                                      : Colors.black),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: pickerColor,
                                shadowColor: pickerColor.withOpacity(1),
                                elevation: 0,
                              )),
                          ElevatedButton(
                            onPressed: () async {
                              /// check if the user has added variant
                              /// and has added the name of the product
                              /// if not then do not save anything and just exit
                              if (_formKey.currentState!.validate()) {
                                if (model.scannedVariants.isEmpty) {
                                  toast('No Product saved!');
                                } else {
                                  if (model.productName != null) {
                                    await model.addVariant(
                                        variations: model.scannedVariants);

                                    model.currentColor = pickerColor.toHex();
                                    Product? product = await model.saveProduct(
                                      mproduct: productRef!,
                                    );
                                    ref
                                        .read(productsProvider(
                                                ProxyService.box.getBranchId()!)
                                            .notifier)
                                        .addProducts(products: [
                                      if (product != null) ...[product]
                                    ]);

                                    toast("Product Saved");
                                    Navigator.maybePop(context);
                                  } else {
                                    toast('No product name!');
                                  }
                                }
                                Navigator.maybePop(context);
                              }
                            },
                            child: const Text('Save'),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: productNameController,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        model.setProductName(name: value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Product name is required';
                        } else if (value.length < 3) {
                          return 'Product name must be at least 3 characters long';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: retailPriceController,
                      onChanged: (value) => model.setRetailPrice(price: value),
                      decoration: InputDecoration(
                        labelText: 'Retail Price',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: supplyPriceController,
                      onChanged: (value) => model.setSupplyPrice(price: value),
                      decoration: InputDecoration(
                        labelText: 'Supply Price',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: scannedInputController,
                      decoration: InputDecoration(
                        labelText: 'Scan or Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (scannedInput) {
                        _inputTimer?.cancel();
                        _inputTimer = Timer(const Duration(seconds: 1), () {
                          if (scannedInput.isNotEmpty) {
                            model.onAddVariant(
                              variantName: scannedInput,
                              isTaxExempted: false,
                              product: productRef!,
                            );
                            scannedInputController.clear();
                            scannedInputFocusNode.requestFocus();
                          }
                        });
                      },
                      focusNode: scannedInputFocusNode,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: Text(
                      'Product Name: ${model.productName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView(
                      children: [
                        DataTable(
                          columns: const [
                            DataColumn(label: Text('Variant Name')),
                            DataColumn(label: Text('Price')),
                            DataColumn(label: Text('Created At')),
                            DataColumn(label: Text('Quantity')),
                            DataColumn(label: Text('Action')),
                          ],
                          rows: model.scannedVariants.reversed.map((variant) {
                            return DataRow(cells: [
                              DataCell(Text(variant.name)),
                              DataCell(
                                Text(variant.retailPrice.toStringAsFixed(2)),
                              ),
                              DataCell(
                                Text(variant.lastTouched == null
                                    ? ''
                                    : variant.lastTouched!
                                        .toUtc()
                                        .toIso8601String()),
                              ),
                              DataCell(
                                // Custom widget for displaying and editing quantity
                                QuantityCell(
                                  quantity: variant.qty,
                                  onEdit: () {
                                    // Add your logic for editing the quantity here
                                    // You may use a dialog or another UI element for editing
                                    _showEditQuantityDialog(
                                      context,
                                      variant,
                                      model,
                                      () {
                                        // Callback to regain focus on TextFormField
                                        FocusScope.of(context).requestFocus(
                                            scannedInputFocusNode);
                                      },
                                    );
                                  },
                                ),
                              ),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () {
                                    model.removeVariant(id: variant.id);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
