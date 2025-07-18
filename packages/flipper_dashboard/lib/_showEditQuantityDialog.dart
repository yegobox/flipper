import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

void showEditQuantityDialog(
  BuildContext context,
  Variant variant,
  ScannViewModel model,
  VoidCallback onDialogClosed,
) {
  TextEditingController quantityController =
      TextEditingController(text: variant.stock?.currentStock.toString());

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
              if (variant.itemTyCd == "3") {
                double newQuantity = 0.0;
                model.updateVariantQuantity(variant.id, newQuantity);
                toast("Services do not have stock");
                return;
              }
              double newQuantity =
                  double.tryParse(quantityController.text) ?? 0.0;
              if (newQuantity < (variant.stock?.currentStock ?? 0.0)) {
                toast("Quantity cannot be less than the current stock.");
                return;
              }
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
