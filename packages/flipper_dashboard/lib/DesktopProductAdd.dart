import 'dart:async';

import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/isar_models.dart';

class ProductEntryScreen extends StatefulWidget {
  const ProductEntryScreen({super.key});

  @override
  State<ProductEntryScreen> createState() => _ProductEntryScreenState();
}

class _ProductEntryScreenState extends State<ProductEntryScreen> {
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
  TextEditingController defaultPriceController = TextEditingController();
  TextEditingController scannedInputController = TextEditingController();
  FocusNode scannedInputFocusNode = FocusNode();
  Timer? _inputTimer;

  @override
  void dispose() {
    _inputTimer?.cancel();
    productNameController.dispose();
    defaultPriceController.dispose();
    scannedInputController.dispose();
    scannedInputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ScannViewModel>.reactive(
      viewModelBuilder: () => ScannViewModel(),
      onViewModelReady: (model) {
        model.createProduct(name: TEMP_PRODUCT);
        model.setProductName(name: null);
      },
      builder: (context, model, child) {
        return Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: SizedBox(
            width: double.infinity,
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
                            if (model.scannedVariants.isEmpty) {
                              toast('No Product saved!');
                            } else {
                              if (model.productName != null) {
                                await model.addVariant(
                                    variations: model.scannedVariants);

                                model.product.color = pickerColor.toHex();
                                await model.saveProduct(
                                    mproduct: model.product);

                                toast("Product Saved");
                                Navigator.maybePop(context);
                              } else {
                                toast('No product name!');
                              }
                            }
                            Navigator.maybePop(context);
                          },
                          child: const Text('Save'),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: productNameController,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      model.setProductName(name: value);
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
                    controller: defaultPriceController,
                    decoration: InputDecoration(
                      labelText: 'Default Variant Price',
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
                    controller: scannedInputController,
                    decoration: InputDecoration(
                      labelText: 'Scan or Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    onChanged: (scannedInput) {
                      _inputTimer?.cancel();
                      _inputTimer = Timer(const Duration(seconds: 1), () {
                        double defaultPrice =
                            double.parse(defaultPriceController.text);
                        if (scannedInput.isNotEmpty) {
                          model.onAddVariant(
                            variantName: scannedInput,
                            defaultPrice: defaultPrice,
                            isTaxExempted: false,
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
                        rows: model.scannedVariants.map((variant) {
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
                              Text(variant.qty.toString()),
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
        );
      },
    );
  }
}
