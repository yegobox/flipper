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
///
/// Ordered by how often a shopkeeper actually touches them: the required
/// category first, then what kind of item it is, then the RRA packaging/origin
/// codes that are almost always left at their defaults.
class ProductEditorInventorySection extends ConsumerStatefulWidget {
  const ProductEditorInventorySection({
    super.key,
    required this.selectedPackageUnitValue,
    required this.pkgUnits,
    required this.onPackageUnitChanged,
    required this.selectedCategoryId,
    this.selectedCategoryName,
    required this.onCategoryChanged,
    required this.onAddCategory,
    this.onCreateCategory,
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
  final Future<void> Function(String? initialName)? onCreateCategory;
  final String selectedProductType;
  final ValueChanged<String?> onProductTypeChanged;
  final TextEditingController countryOfOriginController;
  final bool isEditMode;

  @override
  ConsumerState<ProductEditorInventorySection> createState() =>
      _ProductEditorInventorySectionState();
}

class _ProductEditorInventorySectionState
    extends ConsumerState<ProductEditorInventorySection> {
  /// Packaging unit + country of origin are RRA plumbing with working defaults;
  /// collapsed by default with their current values summarised on the toggle.
  bool _showTaxDetails = false;

  static const _productTypes = [
    (
      value: '2',
      label: 'Finished product — ready to sell',
      short: 'Finished product',
    ),
    (
      value: '1',
      label: 'Raw material — used to make other products',
      short: 'Raw material',
    ),
    (
      value: '3',
      label: 'Service — nothing to keep in stock',
      short: 'Service',
    ),
  ];

  String _packagingLabel(String unit) {
    if (unit.split(':').length > 2) {
      return unit.split(':').sublist(2).join(':');
    }
    return unit;
  }

  @override
  Widget build(BuildContext context) {
    final countriesAsync = ref.watch(countriesProvider);

    // Resolved here (not inside the collapsible) so the default origin is
    // applied whether or not the field is on screen.
    final countries = countriesAsync.value ?? const <Country>[];
    final unique = <String, Country>{};
    for (final c in countries) {
      unique.putIfAbsent(c.code, () => c);
    }
    final countryList = unique.values.toList();
    final currentCode = widget.countryOfOriginController.text;
    final countryValue = countryList.any((c) => c.code == currentCode)
        ? currentCode
        : (countryList.isNotEmpty ? countryList.first.code : null);

    if (countryValue != null && currentCode.isEmpty && countryList.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (widget.countryOfOriginController.text.isEmpty) {
          widget.countryOfOriginController.text = countryValue;
        }
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PeField(
          label: 'Category',
          required: true,
          hint: 'Groups this product in reports and on the sell screen.',
          child: ProductEditorCategoryPicker(
            selectedCategoryId: widget.selectedCategoryId,
            selectedCategoryName: widget.selectedCategoryName,
            onCategoryChanged: widget.onCategoryChanged,
            onAddCategory: widget.onAddCategory,
            onCreateCategory: widget.onCreateCategory,
          ),
        ),
        const SizedBox(height: 18),
        PeField(
          label: 'Item type',
          hint: widget.isEditMode
              ? 'Locked — this cannot change after the product is created.'
              : 'Most shop items are a finished product.',
          child: PeSelect<String>(
            value: widget.selectedProductType,
            enabled: !widget.isEditMode,
            items: [
              for (final t in _productTypes)
                DropdownMenuItem(value: t.value, child: Text(t.label)),
            ],
            onChanged: widget.onProductTypeChanged,
          ),
        ),
        const SizedBox(height: 18),
        _TaxDetailsToggle(
          expanded: _showTaxDetails,
          summary: _summaryLine(countryValue),
          onTap: () => setState(() => _showTaxDetails = !_showTaxDetails),
        ),
        if (_showTaxDetails) ...[
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final stack = constraints.maxWidth < 520;
              final packaging = PeField(
                label: 'Packaging unit',
                child: PeSelect<String>(
                  value: widget.pkgUnits.contains(widget.selectedPackageUnitValue)
                      ? widget.selectedPackageUnitValue
                      : (widget.pkgUnits.isNotEmpty
                            ? widget.pkgUnits.first
                            : null),
                  items: [
                    for (final unit in widget.pkgUnits)
                      DropdownMenuItem(
                        value: unit,
                        child: Text(_packagingLabel(unit)),
                      ),
                  ],
                  onChanged: widget.onPackageUnitChanged,
                ),
              );
              final origin = PeField(
                label: 'Country of origin',
                child: countriesAsync.when(
                  data: (_) => PeSelect<String>(
                    value: countryValue,
                    items: [
                      for (final country in countryList)
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
                        widget.countryOfOriginController.text = code;
                        setState(() {});
                      }
                    },
                  ),
                  loading: () => const SizedBox(
                    height: 50,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  error: (_, __) => Text(
                    'Could not load countries',
                    style: GoogleFonts.outfit(color: ProductEditorTokens.ink3),
                  ),
                ),
              );

              if (stack) {
                return Column(
                  children: [packaging, const SizedBox(height: 18), origin],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: packaging),
                  const SizedBox(width: 16),
                  Expanded(child: origin),
                ],
              );
            },
          ),
        ],
      ],
    );
  }

  String _summaryLine(String? countryCode) {
    final packaging = _packagingLabel(widget.selectedPackageUnitValue);
    final origin = (countryCode == null || countryCode.isEmpty)
        ? 'origin not set'
        : countryCode.toUpperCase();
    return '$packaging · $origin';
  }
}

/// Discloses the RRA packaging/origin fields while keeping their current values
/// readable when collapsed — hidden must not mean unknown.
class _TaxDetailsToggle extends StatelessWidget {
  const _TaxDetailsToggle({
    required this.expanded,
    required this.summary,
    required this.onTap,
  });

  final bool expanded;
  final String summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ProductEditorTokens.surface2,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ProductEditorTokens.line, width: 1.5),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.tune,
                size: 17,
                color: ProductEditorTokens.ink3,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Packaging & origin (for tax reporting)',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: ProductEditorTokens.ink2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      expanded ? 'Tap to hide' : summary,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: ProductEditorTokens.ink3,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                expanded ? Icons.expand_less : Icons.expand_more,
                size: 20,
                color: ProductEditorTokens.ink3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
