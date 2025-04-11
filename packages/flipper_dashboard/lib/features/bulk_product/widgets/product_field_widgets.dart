import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/view_models/BulkAddProductViewModel.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';

/// Widget for price and quantity input fields
class PriceQuantityField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final bool isNumeric;

  const PriceQuantityField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.isNumeric = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      inputFormatters:
          isNumeric ? [FilteringTextInputFormatter.digitsOnly] : null,
    );
  }
}

/// Widget for product type dropdown
class ProductTypeDropdown extends ConsumerWidget {
  final String barCode;
  final String? selectedValue;

  const ProductTypeDropdown({
    super.key,
    required this.barCode,
    this.selectedValue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
}

/// Widget for tax type dropdown
class TaxTypeDropdown extends ConsumerWidget {
  final String barCode;
  final String? selectedValue;

  const TaxTypeDropdown({
    super.key,
    required this.barCode,
    this.selectedValue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
}

/// Widget for item class dropdown
class ItemClassDropdown extends ConsumerWidget {
  final String barCode;
  final String? selectedValue;

  const ItemClassDropdown({
    super.key,
    required this.barCode,
    this.selectedValue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
