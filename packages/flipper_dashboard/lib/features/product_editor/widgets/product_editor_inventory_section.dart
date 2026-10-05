import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/pe_field.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/pe_select.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/product_editor_category_picker.dart';
import 'package:flipper_models/countries_asset.dart' show kDefaultCountryCode;
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

  /// `value` is the stored item-type code; only `label` is localized.
  static List<({String value, String label})> _productTypes(
    FlipperAppLocalizations l10n,
  ) => [
    (value: '2', label: l10n.productEditorItemTypeFinished),
    (value: '1', label: l10n.productEditorItemTypeRawMaterial),
    (value: '3', label: l10n.productEditorItemTypeService),
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
    final l10n = context.flipperL10n;

    // Resolved here (not inside the collapsible) so the default origin is
    // applied whether or not the field is on screen.
    final countries = countriesAsync.value ?? const <Country>[];
    final unique = <String, Country>{};
    for (final c in countries) {
      unique.putIfAbsent(c.code, () => c);
    }
    final countryList = unique.values.toList();
    final currentCode = widget.countryOfOriginController.text;
    // Falls back to RW explicitly rather than to the first row: the list is now
    // the full ISO set, where "first" alphabetically would file products under
    // Ascension Island. RW also matches what the save path uses when the field
    // is left blank.
    final countryValue = countryList.any((c) => c.code == currentCode)
        ? currentCode
        : (countryList.any((c) => c.code == kDefaultCountryCode)
              ? kDefaultCountryCode
              : (countryList.isNotEmpty ? countryList.first.code : null));

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
          label: l10n.category,
          required: true,
          hint: l10n.productEditorCategoryHint,
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
          label: l10n.productEditorItemType,
          hint: widget.isEditMode
              ? l10n.productEditorItemTypeLocked
              : l10n.productEditorItemTypeHint,
          child: PeSelect<String>(
            value: widget.selectedProductType,
            enabled: !widget.isEditMode,
            items: [
              for (final t in _productTypes(l10n))
                DropdownMenuItem(value: t.value, child: Text(t.label)),
            ],
            onChanged: widget.onProductTypeChanged,
          ),
        ),
        const SizedBox(height: 18),
        _TaxDetailsToggle(
          expanded: _showTaxDetails,
          summary: _summaryLine(l10n, countryValue),
          onTap: () => setState(() => _showTaxDetails = !_showTaxDetails),
        ),
        if (_showTaxDetails) ...[
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final stack = constraints.maxWidth < 520;
              final packaging = PeField(
                label: l10n.productEditorPackagingUnit,
                child: PeSelect<String>(
                  value:
                      widget.pkgUnits.contains(widget.selectedPackageUnitValue)
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
                label: l10n.productEditorCountryOfOrigin,
                // The country list comes from the `countries` table via Brick
                // (awaitRemoteWhenNoneExist). When that table is empty the
                // dropdown has no items and renders as a dead grey box, so say
                // what will actually be saved instead.
                hint: countryList.isEmpty && !countriesAsync.isLoading
                    ? l10n.productEditorNoCountryList
                    : null,
                child: countriesAsync.when(
                  data: (_) => countryList.isEmpty
                      ? _UnavailableValueBox(
                          value: l10n.productEditorCountryDefaultRw,
                        )
                      : PeSelect<String>(
                          value: countryValue,
                          items: [
                            for (final country in countryList)
                              DropdownMenuItem(
                                value: country.code,
                                child: Text(
                                  '${country.name} (${country.code})'
                                      .toUpperCase(),
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
                    l10n.productEditorCountriesLoadFailed,
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

  String _summaryLine(FlipperAppLocalizations l10n, String? countryCode) {
    final packaging = _packagingLabel(widget.selectedPackageUnitValue);
    final origin = (countryCode == null || countryCode.isEmpty)
        ? l10n.productEditorOriginNotSet
        : countryCode.toUpperCase();
    return '$packaging · $origin';
  }
}

/// Stands in for a dropdown whose option list is empty, showing the value that
/// will actually be used. An items-less [PeSelect] renders as a greyed, dead
/// control that reads as a bug.
class _UnavailableValueBox extends StatelessWidget {
  const _UnavailableValueBox({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ProductEditorTokens.fieldHeight,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: ProductEditorTokens.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ProductEditorTokens.line, width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: ProductEditorTokens.ink2,
              ),
            ),
          ),
          const Icon(Icons.lock, size: 16, color: ProductEditorTokens.ink4),
        ],
      ),
    );
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
              const Icon(Icons.tune, size: 17, color: ProductEditorTokens.ink3),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.flipperL10n.productEditorTaxDetailsTitle,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: ProductEditorTokens.ink2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      expanded
                          ? context.flipperL10n.productEditorTapToHide
                          : summary,
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
