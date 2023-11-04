import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/isar_models.dart';

import 'BlockColorPicker.dart';

class ProductEntryScreen extends StatefulWidget {
  const ProductEntryScreen({super.key});

  @override
  State<ProductEntryScreen> createState() => _ProductEntryScreenState();
}

class _ProductEntryScreenState extends State<ProductEntryScreen> {
  Color currentColor = Colors.amber;
  List<Color> currentColors = [Colors.yellow, Colors.green];
  List<Color> colorHistory = [];

  void changeColor(Color color) => setState(() => currentColor = color);
  void changeColors(List<Color> colors) =>
      setState(() => currentColors = colors);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ScannViewModel>.reactive(
      viewModelBuilder: () => ScannViewModel(),
      onViewModelReady: (model) {
        model.createProduct(name: TEMP_PRODUCT);
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
                        // BlockColorPicker(
                        //   pickerColor: currentColor,
                        //   onColorChanged: changeColor,
                        //   pickerColors: currentColors,
                        //   onColorsChanged: changeColors,
                        //   colorHistory: colorHistory,
                        // ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle button click here
                            // You can use model.productNameController.text to get the product name
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
                    controller: model.productNameController,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (value) {
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
                    controller: model.defaultPriceController,
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
                    controller: model.scannedInputController,
                    decoration: InputDecoration(
                      labelText: 'Scan or Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    onChanged: (scannedInput) {
                      model.handleScannedInput(scannedInput);
                    },
                    focusNode: model.scannedInputFocusNode,
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
                        ],
                        rows: model.scannedVariants.map((variant) {
                          return DataRow(cells: [
                            DataCell(Text(variant.name)),
                            DataCell(
                              Text(variant.retailPrice.toStringAsFixed(2)),
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
