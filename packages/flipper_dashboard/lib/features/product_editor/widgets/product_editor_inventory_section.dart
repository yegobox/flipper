import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/pe_field.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/pe_select.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/product_editor_category_picker.dart';
import 'package:flipper_models/providers/country_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart';

/// Handoff-styled inventory fields (no nested Card chrome).
class ProductEditorInventorySection extends ConsumerWidget {
  const ProductEditorInventorySection({
    super.key,
    required this.selectedPackageUnitValue,
    required this.pkgUnits,
    required this.onPackageUnitChanged,
    required this.selectedCategoryId,
    this.selectedCategoryName,
    required this.onCategoryChanged,
    required this.onAddCategory,
    required this.selectedProductType,
    required this.onProductTypeChanged,
    required this.countryOfOriginController,
    this.isEditMode = false,
  });

  final String selectedPackageUnitValue;
  final List<String> pkgUnits;
  final ValueChanged<String?> onPackageUnitChanged;
  final String? selectedCategoryId;
  final String? selectedCategoryName;
  final ValueChanged<String?> onCategoryChanged;
  final VoidCallback onAddCategory;
  final String selectedProductType;
  final ValueChanged<String?> onProductTypeChanged;
  final TextEditingController countryOfOriginController;
  final bool isEditMode;

  static const _productTypes = [
    (value: '1', label: 'Raw Material'),
    (value: '2', label: 'Finished Product'),
    (value: '3', label: 'Service without stock'),
  ];

  String _packagingLabel(String unit) {
    if (unit.split(':').length > 2) {
      return unit.split(':').sublist(2).join(':');
    }
    return unit;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countriesAsync = ref.watch(countriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PeField(
          label: 'Packaging unit',
          child: PeSelect<String>(
            value: pkgUnits.contains(selectedPackageUnitValue)
                ? selectedPackageUnitValue
                : (pkgUnits.isNotEmpty ? pkgUnits.first : null),
            items: [
              for (final unit in pkgUnits)
                DropdownMenuItem(
                  value: unit,
                  child: Text(_packagingLabel(unit)),
                ),
            ],
            onChanged: onPackageUnitChanged,
          ),
        ),
        const SizedBox(height: 18),
        PeField(
          label: 'Category',
          required: true,
          child: ProductEditorCategoryPicker(
            selectedCategoryId: selectedCategoryId,
            selectedCategoryName: selectedCategoryName,
            onCategoryChanged: onCategoryChanged,
            onAddCategory: onAddCategory,
          ),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final stack = constraints.maxWidth < 520;
            final classification = PeField(
              label: 'Classification',
              child: PeSelect<String>(
                value: selectedProductType,
                enabled: !isEditMode,
                items: [
                  for (final t in _productTypes)
                    DropdownMenuItem(value: t.value, child: Text(t.label)),
                ],
                onChanged: onProductTypeChanged,
              ),
            );
            final origin = PeField(
              label: 'Country of origin',
              child: countriesAsync.when(
                data: (countries) {
                  final unique = <String, Country>{};
                  for (final c in countries) {
                    unique.putIfAbsent(c.code, () => c);
                  }
                  final list = unique.values.toList();
                  final currentCode = countryOfOriginController.text;
                  final value = list.any((c) => c.code == currentCode)
                      ? currentCode
                      : (list.isNotEmpty ? list.first.code : null);

                  if (value != null &&
                      currentCode.isEmpty &&
                      list.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      countryOfOriginController.text = value;
                    });
                  }

                  return PeSelect<String>(
                    value: value,
                    items: [
                      for (final country in list)
                        DropdownMenuItem(
                          value: country.code,
                          child: Text(
                            '${country.name} (${country.code})'.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (code) {
                      if (code != null) {
                        countryOfOriginController.text = code;
                      }
                    },
                  );
                },
                loading: () => const SizedBox(
                  height: 50,
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                error: (_, __) => Text(
                  'Could not load countries',
                  style: GoogleFonts.outfit(color: ProductEditorTokens.ink3),
                ),
              ),
            );

            if (stack) {
              return Column(
                children: [
                  classification,
                  const SizedBox(height: 18),
                  origin,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: classification),
                const SizedBox(width: 16),
                Expanded(child: origin),
              ],
            );
          },
        ),
      ],
    );
  }
}
