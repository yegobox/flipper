// ignore_for_file: unused_result

import 'dart:async';
import 'dart:io';

import 'package:flipper_dashboard/SearchProduct.dart';
import 'package:flipper_dashboard/SelectedVariant.dart';
import 'package:flipper_dashboard/ToggleButtonWidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flipper_dashboard/create/browsePhotos.dart';
import 'package:flipper_models/helperModels/hexColor.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';

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
  const ProductEntryScreen({super.key, this.productId});

  final int? productId;

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

  bool _selectAll = false;
  bool _showDeleteButton = false;

  bool _savingInProgress = false;

  String selectedPackageUnitValue = "BJ: Bucket Bucket";

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
                model.updateVariantQuantity(variant.id!, newQuantity);
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

  Widget _buildUniversalProductDropDown(
      BuildContext context, ScannViewModel model, Variant variant) {
    final unitsAsyncValue = ref.watch(universalProductsNames);

    return unitsAsyncValue.when(
      data: (items) {
        final List<String> itemClsCdList = items.asData?.value
                .map((unit) => ((unit.itemClsNm ?? "") + " " + unit.itemClsCd!))
                .toList() ??
            [];

        // talker.warning(itemClsCdList);
        return Container(
          width: double.infinity,
          child: DropdownSearch<String>(
            items: itemClsCdList,
            selectedItem: itemClsCdList.isNotEmpty ? itemClsCdList.first : null,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
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
              if (newValue != null) {
                // Loop through model.scannedVariants
                for (var scannedVariant in model.scannedVariants) {
                  // Find the related variant based on some criteria
                  // For example, matching variant.id
                  if (scannedVariant.id == variant.id) {
                    // Update the variant.itemClsCd with the value of newValue
                    final value = newValue.split(' ').last;
                    scannedVariant.itemClsCd = value;
                    break; // Exit the loop since the variant is found and updated
                  }
                }
              }
            },
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }

  Widget _buildUnitOfMeasureDropDown(
      BuildContext context, Variant variant, ScannViewModel model) {
    final unitsAsyncValue = ref.watch(unitsProvider);

    return unitsAsyncValue.when(
      data: (units) {
        return Container(
          width: double.infinity,
          child: DropdownSearch<String>(
            items: units.asData?.value.map((unit) => unit.name!).toList() ?? [],
            selectedItem: variant.unit,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
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
          ),
        );
      },
      loading: () =>
          const CircularProgressIndicator(), // Show a loading indicator
      error: (error, stackTrace) =>
          Text('Error: $error'), // Show an error message
    );
  }

  Widget _buildTaxDropdown(
      BuildContext context, Variant variant, ScannViewModel model) {
    final List<String> options = ["A", "B", "C", "D"];

    return DropdownSearch<String>(
      items: options,
      selectedItem: variant.taxTyCd ?? "B",
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
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
        try {
          ProxyService.realm.realm!.write(() => variant.taxTyCd = newValue!);
        } catch (e) {
          talker.error(e);
        }
      },
    );
  }

  // Helper function to get a valid color or a default color

  // Helper function to check if a string is a valid hexadecimal color code

  void _showSaveInProgressToast() {
    toast('Saving item in progress, please be patient!');
  }

  void _showNoProductNameToast() {
    toast('No product name!');
  }

  void _showNoProductSavedToast() {
    toast('No Product saved!');
  }

  Future<void> _saveProductAndVariants(
      ScannViewModel model, BuildContext context, Product productRef) async {
    if (model.kProductName == null) {
      _showNoProductNameToast();
      return;
    }

    if (widget.productId != null) {
      await model.bulkUpdateVariants(true);
    }

    model.currentColor = pickerColor.toHex();
    await model.addVariant(
        variations: model.scannedVariants,
        packagingUnit: selectedPackageUnitValue.split(":")[0]);

    await model.saveProduct(
        mproduct: productRef,
        inUpdateProcess: widget.productId != null,
        productName: model.kProductName!);

    final searchKeyword = ref.watch(searchStringProvider);
    final scanMode = ref.watch(scanningModeProvider);
    ref
        .read(productsProvider(ProxyService.box.getBranchId()!).notifier)
        .loadProducts(searchString: searchKeyword, scanMode: scanMode);

    /// end of reloading

    /// attempt to see newly created product
    ref.read(searchStringProvider.notifier).emitString(value: "search");
    ref.read(searchStringProvider.notifier).emitString(value: "");

    ref
        .read(productsProvider(ProxyService.box.getBranchId()!).notifier)
        .loadProducts(searchString: model.kProductName ?? "", scanMode: true);
    toast("Product Saved");
    Navigator.maybePop(context);
  }

  void _onSaveButtonPressed(
      ScannViewModel model, BuildContext context, Product product) {
    print("product");
    // _saveProductAndVariants(model, context, product);
    if (!_savingInProgress) {
      setState(() {
        _savingInProgress = true;
      });

      /// if the there is no scanned variant and there is no productId it means we are creating new item
      /// then we inforce having the variants saved, otherwise we can allow the user to edit the product name and or its
      /// retail price, supply price.

      if (model.scannedVariants.isEmpty && widget.productId == null) {
        _showNoProductSavedToast();
      } else {
        _saveProductAndVariants(model, context, product);
      }
    } else {
      _showSaveInProgressToast();
    }
  }

  Widget _buildDropdownButton(ScannViewModel model) {
    return Column(
      children: [
        Text("Packaging unit"),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: DropdownButton<String>(
            value: selectedPackageUnitValue,
            onChanged: (String? newValue) {
              setState(() {
                if (newValue != null) {
                  selectedPackageUnitValue = newValue;
                }
              });
            },
            items: model.pkgUnits.map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
            style: const TextStyle(color: Colors.black, fontSize: 16),
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 30,
            isExpanded: true,
            underline: SizedBox(), // Remove the default underline
          ),
        ),
      ],
    );
  }

// Define your default color
  Color DEFAULT_COLOR = Colors.grey;

  @override
  Widget build(BuildContext context) {
    final productRef = ref.watch(productProvider);
    return ViewModelBuilder<ScannViewModel>.reactive(
      viewModelBuilder: () => ScannViewModel(),
      onViewModelReady: (model) async {
        if (widget.productId != null) {
          // Load existing product if productId is given

          Product product =
              await model.getProduct(productId: widget.productId!);
          ref.read(productProvider.notifier).emitProduct(value: product);

          // Populate product name with the name of the product being edited
          productNameController.text = product.name!;
          model.setProductName(name: product.name!);

          // Populate variants related to the product
          List<Variant> variants = await ProxyService.realm.variants(
              productId: widget.productId!,
              branchId: ProxyService.box.getBranchId()!);

          /// populate the supplyPrice and retailPrice of the first item
          /// this in assumption that all variants added has same supply and retail price
          /// but this will change in future when we support for variant to have different
          /// prices
          supplyPriceController.text = variants.first.supplyPrice.toString();
          retailPriceController.text = variants.first.retailPrice.toString();

          model.setScannedVariants(variants);

          // If there are variants, set the color to the color of the first variant
          if (variants.isNotEmpty) {
            pickerColor = getColorOrDefault(variants.first.color!);
          }
        } else {
          // If productId is not given, create a new product
          Product? product = await model.createProduct(name: TEMP_PRODUCT);
          ref.read(productProvider.notifier).emitProduct(value: product!);
        }

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
                  topButtons(context, model, productRef),

                  /// toggle between is composite vs non-composite product
                  ToggleButtonWidget(),

                  /// End of toggle
                  productNameField(model),
                  retailPrice(model),
                  supplyPrice(model),
                  !ref.watch(isCompositeProvider)
                      ? scanField(model, productRef)
                      : SizedBox.shrink(),
                  packagingDropDown(model),
                  // previewName(model),
                  !ref.watch(isCompositeProvider)
                      ? TableVariants(model, context)
                      : SizedBox.shrink(),
                  ref.watch(isCompositeProvider)
                      ? SearchProduct()
                      : SizedBox.shrink(),
                  ref.watch(isCompositeProvider)
                      ? Padding(
                          padding: EdgeInsets.all(16),
                          child: Text("Components"),
                        )
                      : SizedBox.shrink(),
                  ref.watch(isCompositeProvider)
                      ? SelectedVariant(
                          supplyPriceController: supplyPriceController)
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<String?> getImageFilePath({required String imageFileName}) async {
    final appSupportDir = await getApplicationSupportDirectory();
    final imageFilePath = '${appSupportDir.path}/${imageFileName}';
    final file = File(imageFilePath);

    if (await file.exists()) {
      talker.info("image exist at path ${imageFilePath}");
      return imageFilePath;
    } else {
      talker.info("image does not exist at path ${imageFilePath}");
      return null;
    }
  }

  Widget topButtons(
      BuildContext context, ScannViewModel productModel, Product? productRef) {
    return ViewModelBuilder.nonReactive(
        viewModelBuilder: () => UploadViewModel(),
        builder: (context, model, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  // mainAxisAlignment: MainAxisAlignment.end,
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
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => _onSaveButtonPressed(
                        productModel,
                        context,
                        productRef!,
                      ),
                      child: const Text('Save'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.maybePop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Background color
                        foregroundColor: Colors.white, // Text color
                      ),
                      child: const Text('Close'),
                    )
                  ],
                ),
              ),
              if (ref.watch(productProvider)?.imageUrl != null)
                FutureBuilder(
                  future: getImageFilePath(
                      imageFileName: ref.watch(productProvider)!.imageUrl!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      final imageFilePath = snapshot.data as String;
                      return Container(
                        width: 200, // Specify the width you need
                        height: 200, // Specify the height you need
                        child: Image.file(
                          new File(imageFilePath),
                          fit: BoxFit.cover,
                        ),
                      );
                    } else {
                      return Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey[500],
                          ),
                        ),
                      );
                    }
                  },
                )
              else
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.grey[300],
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              Browsephotos(
                productId: ref.read(productProvider)?.id ?? 0,
              )
            ],
          );
        });
  }

  Padding productNameField(ScannViewModel model) {
    return Padding(
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ),
    );
  }

  Container previewName(ScannViewModel model) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Text(
        'Product Name: ${model.kProductName}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Padding packagingDropDown(ScannViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: model.EBMenabled
          ? _buildDropdownButton(model)
          : const SizedBox.shrink(),
    );
  }

  Padding scanField(ScannViewModel model, Product? productRef) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: scannedInputController,
        decoration: InputDecoration(
          labelText: 'Scan or Type',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (scannedInput) {
          _inputTimer?.cancel();
          _inputTimer = Timer(const Duration(seconds: 1), () {
            if (scannedInput.isNotEmpty) {
              model.onAddVariant(
                editmode: widget.productId != null,
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
    );
  }

  Padding supplyPrice(ScannViewModel model) {
    bool isComposite = ref.watch(isCompositeProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        controller: supplyPriceController,
        readOnly: isComposite,
        onChanged: (value) => model.setSupplyPrice(price: value),
        decoration: InputDecoration(
          labelText: 'Cost',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          filled: isComposite, // Fill the background color when read-only
          fillColor: isComposite
              ? Colors.grey[200]
              : null, // Light grey background when read-only
          suffixIcon: isComposite
              ? Icon(Icons.lock,
                  color: Colors.grey) // Lock icon to indicate read-only
              : null,
        ),
        keyboardType: TextInputType.number,
        style: TextStyle(
          color: isComposite
              ? Colors.grey
              : Colors.black, // Lighter text color when read-only
        ),
      ),
    );
  }

  Padding retailPrice(ScannViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        controller: retailPriceController,
        onChanged: (value) => model.setRetailPrice(price: value),
        decoration: InputDecoration(
          labelText: 'Price',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Stack TableVariants(ScannViewModel model, BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 200,
          child: ListView(
            children: [
              DataTable(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                ),
                columns: [
                  DataColumn(
                    label: Row(
                      children: [
                        Checkbox(
                          value: _selectAll,
                          onChanged: (value) {
                            setState(() {
                              _selectAll = value!;
                              _showDeleteButton = value;
                            });
                          },
                        ),
                        const Text('All'),
                      ],
                    ),
                  ),
                  const DataColumn(label: Text('Name')),
                  const DataColumn(label: Text('Price')),
                  const DataColumn(label: Text('Created At')),
                  const DataColumn(label: Text('Quantity')),
                  const DataColumn(label: Text('Tax')),
                  const DataColumn(label: Text('Unit')),
                  const DataColumn(label: Text('ClsCd')),
                  const DataColumn(label: Text('Action')),
                ],
                rows: model.scannedVariants.reversed.map((variant) {
                  return DataRow(
                    color: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.08);
                      }
                      return null; // Use the default value.
                    }),
                    cells: [
                      DataCell(Checkbox(
                        value: _selectAll,
                        onChanged: (value) {
                          // Handle row checkbox state if needed
                        },
                      )),
                      DataCell(Text(variant.name!)),
                      DataCell(Text(variant.retailPrice.toStringAsFixed(2))),
                      DataCell(
                        Text(
                          variant.lastTouched == null
                              ? ''
                              : variant.lastTouched!
                                  .toLocal()
                                  .toIso8601String(),
                        ),
                      ),
                      DataCell(
                        QuantityCell(
                          quantity: variant.qty,
                          onEdit: () {
                            _showEditQuantityDialog(
                              context,
                              variant,
                              model,
                              () {
                                FocusScope.of(context)
                                    .requestFocus(scannedInputFocusNode);
                              },
                            );
                          },
                        ),
                      ),
                      DataCell(
                        _buildTaxDropdown(context, variant, model),
                      ),
                      DataCell(
                        _buildUnitOfMeasureDropDown(context, variant, model),
                      ),
                      DataCell(
                        _buildUniversalProductDropDown(context, model, variant),
                      ),
                      DataCell(
                        ElevatedButton(
                          onPressed: () {
                            model.removeVariant(id: variant.id!);
                          },
                          child: const Text('Delete'),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        if (_showDeleteButton)
          Positioned(
            top: 0,
            right: 0,
            child: ElevatedButton(
              onPressed: () async {
                // Display a confirmation dialog or perform any other action
                bool confirmed = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirm Deletion'),
                      content:
                          Text('Are you sure you want to delete all variants?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    );
                  },
                );

                // If user confirmed, call model.deleteAllVariants()
                if (confirmed == true) {
                  model.deleteAllVariants();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Background color
                foregroundColor: Colors.white, // Text color
              ),
              child: const Text('Delete'),
            ),
          ),
      ],
    );
  }
}
