import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:supabase_models/brick/models/all_models.dart'; // Ensure this import is correct

Future<void> showVariantEditDialog(
  BuildContext context,
  Variant item, {
  required List<Variant> variants,
  required TextEditingController nameController,
  required TextEditingController supplyPriceController,
  required TextEditingController retailPriceController,
  required VoidCallback saveItemName,
  required void Function(Variant? itemToAssign, Variant? itemFromPurchase)
      selectSale,
}) {
  nameController.text = item.name;
  supplyPriceController.text = item.supplyPrice?.toString() ?? '';
  retailPriceController.text = item.retailPrice?.toString() ?? '';

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Item'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Using the working approach from your example
              DropdownSearch<Variant>(
                selectedItem: item,
                // This is the key fix - providing items as a function that returns the list
                items: (a, b) => variants,
                compareFn: (Variant i, Variant s) => i.id == s.id,
                itemAsString: (Variant v) => v.name,
                // Updated to decoratorProps instead of dropdownDecoratorProps
                decoratorProps: const DropDownDecoratorProps(
                  baseStyle: TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                onChanged: (Variant? selectedVariant) {
                  selectSale(selectedVariant, item);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: supplyPriceController,
                decoration: const InputDecoration(
                  labelText: 'Supply Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: retailPriceController,
                decoration: const InputDecoration(
                  labelText: 'Retail Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              saveItemName();
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
