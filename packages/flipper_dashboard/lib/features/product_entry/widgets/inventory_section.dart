import 'package:flutter/material.dart';
import 'package:flipper_dashboard/CountryOfOriginSelector.dart';
import 'package:flipper_dashboard/DropdownButtonWithLabel.dart';
import 'package:flipper_dashboard/SearchableCategoryDropdown.dart';
import 'package:flipper_dashboard/ProductTypeDropdown.dart';
import 'package:flipper_models/helperModels/talker.dart';

class InventorySection extends StatelessWidget {
  final String selectedPackageUnitValue;
  final List<String> pkgUnits;
  final Function(String?) onPackageUnitChanged;
  final String? selectedCategoryId;
  final Function(String?) onCategoryChanged;
  final VoidCallback onAddCategory;
  final String selectedProductType;
  final Function(String?) onProductTypeChanged;
  final TextEditingController countryOfOriginController;
  final bool isEditMode;

  const InventorySection({
    Key? key,
    required this.selectedPackageUnitValue,
    required this.pkgUnits,
    required this.onPackageUnitChanged,
    required this.selectedCategoryId,
    required this.onCategoryChanged,
    required this.onAddCategory,
    required this.selectedProductType,
    required this.onProductTypeChanged,
    required this.countryOfOriginController,
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
            Text(
              "Inventory & Categorization",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonWithLabel(
              label: "Packaging Unit",
              selectedValue: selectedPackageUnitValue,
              options: pkgUnits,
              displayNames: Map.fromEntries(
                pkgUnits.map(
                  (unit) => MapEntry(
                    unit,
                    unit.split(':').length > 2
                        ? unit.split(':').sublist(2).join(':')
                        : unit,
                  ),
                ),
              ),
              onChanged: onPackageUnitChanged,
            ),
            const SizedBox(height: 16),
            SearchableCategoryDropdown(
              selectedValue: selectedCategoryId,
              onChanged: onCategoryChanged,
              onAdd: onAddCategory,
            ),
            const SizedBox(height: 16),
            ProductTypeDropdown(
              selectedValue: selectedProductType,
              onChanged: onProductTypeChanged,
              isEditMode: isEditMode,
            ),
            const SizedBox(height: 16),
            CountryOfOriginSelector(
              controller: countryOfOriginController,
              onCountrySelected: (country) {
                talker.info("Selected country: ${country.name}");
              },
            ),
          ],
        ),
      ),
    );
  }
}
