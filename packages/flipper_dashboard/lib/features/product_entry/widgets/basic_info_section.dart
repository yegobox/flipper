import 'package:flutter/material.dart';
import 'package:flipper_models/view_models/ScannViewModel.dart';

class BasicInfoSection extends StatelessWidget {
  final TextEditingController productNameController;
  final ScannViewModel model;
  final bool isEditMode;

  const BasicInfoSection({
    Key? key,
    required this.productNameController,
    required this.model,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
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
                hintText: 'e.g. Arabica Coffee',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
