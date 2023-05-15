import 'package:flutter/material.dart';

class ProductForm {
  final TextEditingController barCodeController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController retailPriceController = TextEditingController();
  final TextEditingController supplyPriceController = TextEditingController();

  void dispose() {
    barCodeController.dispose();
    productNameController.dispose();
    retailPriceController.dispose();
    supplyPriceController.dispose();
  }
}
