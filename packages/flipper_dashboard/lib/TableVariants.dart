import 'package:flipper_dashboard/dialog_status.dart';
import 'package:flipper_dashboard/widgets/variant_table_image_cell.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_dashboard/QuantityCell.dart';
import 'package:flipper_dashboard/TaxDropdown.dart';
import 'package:flipper_dashboard/UnitOfMeasureDropdown.dart';
import 'package:flipper_dashboard/UniversalProductDropdown.dart';
import 'package:flipper_dashboard/_showEditQuantityDialog.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/pe_variant_field.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/ebm_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/product_editor_variants_empty.dart';
import 'package:google_fonts/google_fonts.dart';

class TableVariants extends StatelessWidget {
  final ScannViewModel model;
  final List<String> unitOfMeasures;
  final void Function(String? unitCode, String variantId)?
  onUnitOfMeasureChanged;
  final FocusNode scannedInputFocusNode;
  final List<IUnit> units;
  final AsyncValue<List<UnversalProduct>>? unversalProducts;
  final Function(String variantId, DateTime date) onDateChanged;

  const TableVariants({
    Key? key,
    required this.model,
    required this.unitOfMeasures,
    this.onUnitOfMeasureChanged,
    required this.scannedInputFocusNode,
    required this.unversalProducts,
    required this.units,
    required this.onDateChanged,
    this.isEditMode = false,
    required this.isEbmEnabled,
    this.productId,
    this.useCardLayout = false,
  }) : super(key: key);
  final bool isEditMode;
  final bool isEbmEnabled;
  final String? productId;
  final bool useCardLayout;

  @override
  Widget build(BuildContext context) {
    // Check the screen size to determine whether to use mobile or desktop layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768; // Common breakpoint for mobile

    // Only the legacy DataTable layout needs the incoming constraints, and the
    // card / mobile subtrees must stay OUT of a LayoutBuilder: they mount
    // Tooltips (variant image cell) whose OverlayPortal child cannot be attached
    // while a LayoutBuilder is performing layout — that trips
    // `_RenderTheater._addDeferredChild` / `_elements.contains(element)`.
    if (isMobile) return _wrapContent(context, _buildMobileLayout(context));
    if (useCardLayout) {
      // The card layout puts the delete action inline in its header row, so the
      // floating Positioned button must not also be stacked on top — it landed
      // over the "Select all" / count text.
      return _wrapContent(
        context,
        _buildDesktopCardLayout(context),
        hasInlineDelete: true,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) =>
          _wrapContent(context, _buildDesktopLayout(context, constraints)),
    );
  }

  Widget _wrapContent(
    BuildContext context,
    Widget content, {
    bool hasInlineDelete = false,
  }) {
    return Stack(
      children: [
        if (useCardLayout)
          content
        else
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: content,
          ),
        // Show delete button only if at least one item is selected
        if (!hasInlineDelete &&
            model.scannedVariants.any(
              (variant) => model.isSelected(variant.id),
            ))
          Positioned(
            top: 10,
            right: 10,
            child: _buildDeleteButton(context, model),
          ),
      ],
    );
  }

  Widget _buildDesktopCardLayout(BuildContext context) {
    final variants = model.scannedVariants.reversed.toList();

    if (variants.isEmpty) {
      return ProductEditorVariantsEmpty(isEditMode: isEditMode);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 10),
          child: Row(
            children: [
              if (variants.length > 1) ...[
                Checkbox(
                  value: model.selectAll(model.scannedVariants),
                  onChanged: (value) => model.toggleSelectAll(
                    model.scannedVariants,
                    value ?? false,
                  ),
                ),
                // Flexible so a narrow sheet shrinks this label instead of
                // overflowing the row once the delete action joins it.
                Flexible(
                  child: Text(
                    'Select all',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ProductEditorTokens.ink2,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              if (model.scannedVariants.any((v) => model.isSelected(v.id))) ...[
                _DeleteAllVariantsButton(onPressed: model.deleteAllVariants),
                const SizedBox(width: 12),
              ],
              Text(
                variants.length == 1
                    ? '1 variant'
                    : '${variants.length} variants',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: ProductEditorTokens.ink2,
                ),
              ),
            ],
          ),
        ),
        for (final variant in variants)
          _VariantCard(
            // Keyed by id so the expand/collapse state follows its variant
            // when rows are added or deleted.
            key: ValueKey(variant.id),
            table: this,
            variant: variant,
          ),
      ],
    );
  }

  /// Headline for a variant row. Prefers the human name; the barcode is shown
  /// underneath rather than as the title, so a long code never stands in for a
  /// readable name.
  String _variantTitle(Variant variant) {
    final name = variant.name.trim();
    if (name.isNotEmpty && name != _tempProductName) return name;
    final barcode = (variant.bcd ?? '').trim();
    if (barcode.isNotEmpty) return barcode;
    return 'Variant';
  }

  String? _variantSubtitle(Variant variant) {
    final barcode = (variant.bcd ?? variant.sku ?? '').trim();
    if (barcode.isEmpty || barcode == _variantTitle(variant)) return null;
    return barcode;
  }

  /// One-line recap of the fields hidden behind "More details" — collapsed
  /// should never mean the user has to guess what a value is.
  String _detailsSummary(Variant variant) {
    final tax = (variant.taxTyCd ?? '').trim();
    final discountText = model.getDiscountController(variant.id).text.trim();
    final discount =
        double.tryParse(discountText) ?? (variant.dcRt ?? 0).toDouble();
    final unit = (variant.unit ?? '').trim();
    final parts = <String>[
      if (tax.isNotEmpty) 'Tax $tax',
      discount == 0 ? 'No discount' : '${discount.toStringAsFixed(0)}% off',
      if (unit.isNotEmpty) unit,
      variant.expirationDate != null
          ? 'Expires ${DateFormat('MMM d, yyyy').format(variant.expirationDate!)}'
          : 'No expiry date',
    ];
    return parts.join(' · ');
  }

  Widget _priceField(Variant variant) => _cardField(
    'Price',
    PeVariantTextInput(
      controller: model.getPriceController(variant.id),
      prefix: 'RWF',
      mono: true,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      onChanged: (s) {
        final d = double.tryParse(s);
        if (d != null) variant.retailPrice = d;
      },
    ),
  );

  Widget _quantityField(BuildContext context, Variant variant) => _cardField(
    'Quantity',
    PeVariantQtyButton(
      quantity: variant.stock?.currentStock ?? variant.qty,
      onTap: () => showEditQuantityDialog(
        context,
        variant,
        model,
        () => FocusScope.of(context).requestFocus(scannedInputFocusNode),
      ),
    ),
  );

  Widget _lowStockField(Variant variant) => _cardField(
    'Low stock',
    PeVariantTextInput(
      controller: model.getLowStockController(variant.id),
      mono: true,
      placeholder: '0',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      onChanged: (s) {
        final d = double.tryParse(s);
        if (d != null && variant.stock != null) {
          variant.stock!.lowStock = d;
        }
      },
    ),
  );

  Widget _taxField(Variant variant) {
    final options = isEbmEnabled ? ["A", "B", "C"] : ["D"];
    final currentValue = options.contains(variant.taxTyCd)
        ? variant.taxTyCd
        : (isEbmEnabled ? "B" : "D");
    return _cardField(
      'Tax',
      TaxDropdown(
        isEditMode: isEditMode,
        selectedValue: currentValue,
        options: options,
        onChanged: (v) => model.updateTax(variant, v),
      ),
    );
  }

  Widget _discountField(Variant variant) => _cardField(
    'Discount %',
    PeVariantTextInput(
      controller: model.getDiscountController(variant.id),
      mono: true,
      placeholder: '0',
      suffix: '%',
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    ),
  );

  Widget _unitField(Variant variant) => _cardField(
    'Unit',
    UnitOfMeasureDropdown(
      items: units.map((e) => e.name ?? '').toList(),
      selectedItem: variant.unit,
      onChanged: (String? newValue) {
        if (newValue != null) {
          final unit = units.firstWhere(
            (u) => u.name == newValue,
            orElse: () => units.firstWhere(
              (u) => u.name == variant.unit,
              orElse: () => units.first,
            ),
          );
          onUnitOfMeasureChanged?.call(unit.code ?? newValue, variant.id);
        }
      },
    ),
  );

  // Named "RRA item class" to distinguish it from the product-level "Item
  // type" (raw material / finished product / service) in the section above.
  Widget _itemClassField(BuildContext context, Variant variant) => _cardField(
    'RRA item class',
    UniversalProductDropdown(
      context: context,
      model: model,
      variant: variant,
      universalProducts: unversalProducts,
    ),
  );

  Widget _expirationField(BuildContext context, Variant variant) => _cardField(
    'Expiration',
    PeVariantBox(
      expirationStyle: true,
      onTap: () async {
        final date = await model.pickDate(context);
        if (date != null) {
          onDateChanged(variant.id, date);
          model.updateDateController(variant.id, date);
        }
      },
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            size: 15,
            color: ProductEditorTokens.blue,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              variant.expirationDate != null
                  ? DateFormat('MMM d, yyyy').format(variant.expirationDate!)
                  : 'Set date',
              style: GoogleFonts.outfit(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: variant.expirationDate != null
                    ? ProductEditorTokens.ink1
                    : ProductEditorTokens.ink4,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _cardField(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 10.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            color: ProductEditorTokens.ink3,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  Future<void> _deleteVariant(BuildContext context, Variant variant) async {
    final businessId = ProxyService.box.getBusinessId();
    final branchId = ProxyService.box.getBranchId();
    final isEbmEnabledLocal =
        businessId != null &&
        branchId != null &&
        await ProxyService.strategy.isTaxEnabled(
          businessId: businessId,
          branchId: branchId,
        );

    if ((variant.stock?.currentStock ?? 0) > 0 &&
        isEbmEnabledLocal &&
        !kDebugMode) {
      final dialogService = locator<DialogService>();
      dialogService.showCustomDialog(
        variant: DialogType.info,
        title: 'Error',
        description: 'Cannot delete variant with stock remaining.',
        data: {'status': InfoDialogStatus.error},
      );
    } else {
      model.removeVariant(id: variant.id);
    }
  }

  Widget _buildDesktopLayout(BuildContext context, BoxConstraints constraints) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: constraints.maxWidth),
        child: DataTable(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          columnSpacing: 12, // Adjust spacing between columns
          columns: _buildColumns(),
          rows: model.scannedVariants.reversed.map((variant) {
            return _buildRow(context, model, variant);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: model.scannedVariants.length,
      itemBuilder: (context, index) {
        final variant = model.scannedVariants.reversed.toList()[index];
        return _buildMobileCard(context, variant);
      },
    );
  }

  Widget _buildMobileCard(BuildContext context, Variant variant) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ExpansionTile(
        title: Row(
          children: [
            Checkbox(
              value: model.isSelected(variant.id),
              onChanged: (value) => model.toggleSelect(variant.id),
            ),
            if (productId != null && productId!.isNotEmpty) ...[
              VariantTableImageCell(
                productId: productId!,
                variant: variant,
                model: model,
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    variant.bcd ?? variant.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Price: ${variant.retailPrice?.toStringAsFixed(2) ?? ''}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () async {
                final businessId = ProxyService.box.getBusinessId();
                final branchId = ProxyService.box.getBranchId();
                final isEbmEnabled =
                    businessId != null &&
                    branchId != null &&
                    await ProxyService.strategy.isTaxEnabled(
                      businessId: businessId,
                      branchId: branchId,
                    );

                if ((variant.stock?.currentStock ?? 0) > 0 &&
                    isEbmEnabled &&
                    !kDebugMode) {
                  final dialogService = locator<DialogService>();
                  dialogService.showCustomDialog(
                    variant: DialogType.info,
                    title: 'Error',
                    description: 'Cannot delete variant with stock remaining.',
                    data: {'status': InfoDialogStatus.error},
                  );
                } else {
                  model.removeVariant(id: variant.id);
                }
              },
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildMobileInfoRow(
                  'Quantity',
                  QuantityCell(
                    quantity: variant.stock?.currentStock ?? variant.qty,
                    onEdit: () {
                      showEditQuantityDialog(context, variant, model, () {
                        FocusScope.of(
                          context,
                        ).requestFocus(scannedInputFocusNode);
                      });
                    },
                  ),
                ),
                _buildMobileInfoRow(
                  'Low stock',
                  TextFormField(
                    controller: model.getLowStockController(variant.id),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    onChanged: (s) {
                      final d = double.tryParse(s);
                      if (d != null && variant.stock != null) {
                        variant.stock!.lowStock = d;
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Reorder at',
                    ),
                  ),
                ),
                _buildMobileInfoRow(
                  'Tax',
                  Consumer(
                    builder: (context, ref, child) {
                      final vatEnabledAsync = ref.watch(ebmVatEnabledProvider);
                      return vatEnabledAsync.when(
                        data: (vatEnabled) {
                          // If VAT is enabled, show A, B, C (exclude D)
                          // If VAT is disabled, only show tax type D
                          final options = vatEnabled ? ["A", "B", "C"] : ["D"];
                          // If current value is not in options, default based on VAT status
                          final currentValue = options.contains(variant.taxTyCd)
                              ? variant.taxTyCd
                              : (vatEnabled ? "B" : "D");
                          return TaxDropdown(
                            isEditMode: isEditMode,
                            selectedValue: currentValue,
                            options: options,
                            onChanged: (newValue) =>
                                model.updateTax(variant, newValue),
                          );
                        },
                        loading: () => TaxDropdown(
                          selectedValue: variant.taxTyCd,
                          options: ["A", "B", "C", "D"],
                          onChanged: (newValue) =>
                              model.updateTax(variant, newValue),
                        ),
                        error: (_, __) => TaxDropdown(
                          selectedValue: variant.taxTyCd,
                          options: ["A", "B", "C", "D"],
                          onChanged: (newValue) =>
                              model.updateTax(variant, newValue),
                        ),
                      );
                    },
                  ),
                ),
                _buildMobileInfoRow(
                  'Discount',
                  TextFormField(
                    controller: model.getDiscountController(variant.id),
                    decoration: const InputDecoration(suffixText: '%'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                _buildMobileInfoRow(
                  'Unit',
                  UnitOfMeasureDropdown(
                    items: units.map((e) => e.name ?? '').toList(),
                    selectedItem: variant.unit,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        // Find the unit by name and pass its code and variant ID
                        final unit = units.firstWhere(
                          (u) => u.name == newValue,
                          orElse: () => units.first,
                        );
                        onUnitOfMeasureChanged?.call(
                          unit.code ?? newValue,
                          variant.id,
                        );
                      }
                    },
                  ),
                ),
                _buildMobileInfoRow(
                  'Classification',
                  UniversalProductDropdown(
                    context: context,
                    model: model,
                    variant: variant,
                    universalProducts: unversalProducts,
                  ),
                ),
                _buildMobileInfoRow(
                  'Expiration',
                  TextFormField(
                    controller: model.getDateController(variant.id),
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.calendar_today),
                      hintText: variant.expirationDate != null
                          ? DateFormat(
                              'MMMM dd, yyyy',
                            ).format(variant.expirationDate!)
                          : 'Select Date',
                    ),
                    readOnly: true,
                    onTap: () async {
                      final date = await model.pickDate(context);
                      if (date != null) {
                        onDateChanged(variant.id, date);
                        model.updateDateController(variant.id, date);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileInfoRow(String label, Widget widget) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: widget),
        ],
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      DataColumn(
        label: Checkbox(
          value: model.selectAll(model.scannedVariants),
          onChanged: (bool? value) =>
              model.toggleSelectAll(model.scannedVariants, value ?? false),
        ),
      ),
      const DataColumn(
        label: Text('Image', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataColumn(
        label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataColumn(
        label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataColumn(
        label: Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataColumn(
        label: Text(
          'Low stock',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      const DataColumn(
        label: Text('Tax', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataColumn(
        label: Text('Discount', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataColumn(
        label: Text('Unit', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataColumn(
        label: Text(
          'Classification',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      const DataColumn(
        label: Text(
          'Expiration',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      const DataColumn(
        label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    ];
  }

  DataRow _buildRow(
    BuildContext context,
    ScannViewModel model,
    Variant variant,
  ) {
    return DataRow(
      selected: model.isSelected(variant.id),
      cells: [
        DataCell(
          Checkbox(
            value: model.isSelected(variant.id),
            onChanged: (value) => model.toggleSelect(variant.id),
          ),
        ),
        DataCell(
          productId != null && productId!.isNotEmpty
              ? VariantTableImageCell(
                  productId: productId!,
                  variant: variant,
                  model: model,
                )
              : const Text('—'),
        ),
        DataCell(Text(variant.bcd ?? variant.name)),
        DataCell(Text(variant.retailPrice?.toStringAsFixed(2) ?? '')),
        DataCell(
          QuantityCell(
            quantity: variant.stock?.currentStock ?? variant.qty,
            onEdit: () {
              showEditQuantityDialog(context, variant, model, () {
                FocusScope.of(context).requestFocus(scannedInputFocusNode);
              });
            },
          ),
        ),
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 100),
            child: TextFormField(
              controller: model.getLowStockController(variant.id),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              onChanged: (s) {
                final d = double.tryParse(s);
                if (d != null && variant.stock != null) {
                  variant.stock!.lowStock = d;
                }
              },
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
            ),
          ),
        ),
        DataCell(
          Consumer(
            builder: (context, ref, child) {
              final vatEnabledAsync = ref.watch(ebmVatEnabledProvider);
              return vatEnabledAsync.when(
                data: (vatEnabled) {
                  // If VAT is enabled, show A, B, C (exclude D)
                  // If VAT is disabled, only show tax type D
                  final options = vatEnabled ? ["A", "B", "C"] : ["D"];
                  // If current value is not in options, default based on VAT status
                  final currentValue = options.contains(variant.taxTyCd)
                      ? variant.taxTyCd
                      : (vatEnabled ? "B" : "D");
                  return TaxDropdown(
                    selectedValue: currentValue,
                    options: options,
                    isEditMode: isEditMode,
                    onChanged: (newValue) => model.updateTax(variant, newValue),
                  );
                },
                loading: () => TaxDropdown(
                  selectedValue: variant.taxTyCd,
                  options: ["A", "B", "C", "D"],
                  isEditMode: isEditMode,
                  onChanged: (newValue) => model.updateTax(variant, newValue),
                ),
                error: (_, __) => TaxDropdown(
                  selectedValue: variant.taxTyCd,
                  options: ["A", "B", "C", "D"],
                  isEditMode: isEditMode,
                  onChanged: (newValue) => model.updateTax(variant, newValue),
                ),
              );
            },
          ),
        ),
        DataCell(
          TextFormField(
            controller: model.getDiscountController(variant.id),
            decoration: const InputDecoration(suffixText: '%'),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ),
        DataCell(
          UnitOfMeasureDropdown(
            items: units.map((e) => e.name ?? '').toList(),
            selectedItem: variant.unit,
            onChanged: (String? newValue) {
              if (newValue != null) {
                // Find the unit by name and pass its code and variant ID
                final unit = units.firstWhere(
                  (u) => u.name == newValue,
                  orElse: () => units.firstWhere(
                    (u) => u.name == variant.unit,
                    orElse: () => units.first,
                  ),
                );
                onUnitOfMeasureChanged?.call(unit.code ?? newValue, variant.id);
              }
            },
          ),
        ),
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150), // Limit width
            child: UniversalProductDropdown(
              context: context,
              model: model,
              variant: variant,
              universalProducts: unversalProducts,
            ),
          ),
        ),
        DataCell(
          TextFormField(
            controller: model.getDateController(variant.id),
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.calendar_today),
              hintText: variant.expirationDate != null
                  ? DateFormat('MMMM dd, yyyy').format(variant.expirationDate!)
                  : 'Select Date',
            ),
            readOnly: true,
            onTap: () async {
              final date = await model.pickDate(context);
              if (date != null) {
                onDateChanged(variant.id, date);
                model.updateDateController(variant.id, date);
              }
            },
          ),
        ),
        DataCell(
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () async {
              final businessId = ProxyService.box.getBusinessId();
              final branchId = ProxyService.box.getBranchId();
              final isEbmEnabled =
                  businessId != null &&
                  branchId != null &&
                  await ProxyService.strategy.isTaxEnabled(
                    businessId: businessId,
                    branchId: branchId,
                  );

              if ((variant.stock?.currentStock ?? 0) > 0 &&
                  isEbmEnabled &&
                  !kDebugMode) {
                final dialogService = locator<DialogService>();
                dialogService.showCustomDialog(
                  variant: DialogType.info,
                  title: 'Error',
                  description: 'Cannot delete variant with stock remaining.',
                  data: {'status': InfoDialogStatus.error},
                );
              } else {
                model.removeVariant(id: variant.id);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton(BuildContext context, ScannViewModel model) {
    return ElevatedButton(
      onPressed: model.deleteAllVariants,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: const Text('Delete', style: TextStyle(color: Colors.white)),
    );
  }
}

/// Mirrors `TEMP_PRODUCT` in flipper_services/constants.dart — the placeholder
/// name a product carries before the user has named it.
const String _tempProductName = 'temp';

/// Inline bulk-delete for the card layout. Lives in the header row rather than
/// floating in a Stack, where it overlapped the "Select all" / count text.
///
/// Labelled "Delete all" because that is literally what
/// [ScannViewModel.deleteAllVariants] does — it clears every variant and ignores
/// which ones are selected. The button only APPEARS on selection, so the old
/// "Delete" label read as "delete the selected ones".
class _DeleteAllVariantsButton extends StatelessWidget {
  const _DeleteAllVariantsButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Delete all variants',
      child: Material(
        color: ProductEditorTokens.loss.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.delete_outline,
                  size: 16,
                  color: ProductEditorTokens.loss,
                ),
                const SizedBox(width: 6),
                Text(
                  'Delete all',
                  style: GoogleFonts.outfit(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: ProductEditorTokens.loss,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// One variant, split into what people edit on every product (price, quantity,
/// low stock) and the tax/unit/expiry fields they rarely touch. The second group
/// is collapsed behind a toggle that still summarises its values.
class _VariantCard extends StatefulWidget {
  const _VariantCard({
    super.key,
    required this.table,
    required this.variant,
  });

  final TableVariants table;
  final Variant variant;

  @override
  State<_VariantCard> createState() => _VariantCardState();
}

class _VariantCardState extends State<_VariantCard> {
  /// Always starts collapsed — price/quantity/low stock are what people come
  /// here for, and the summary line carries the rest at a glance.
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final table = widget.table;
    final variant = widget.variant;
    final model = table.model;
    final selected = model.isSelected(variant.id);
    final subtitle = table._variantSubtitle(variant);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: selected
            ? ProductEditorTokens.blueTint
            : ProductEditorTokens.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? ProductEditorTokens.blue : ProductEditorTokens.line,
          width: 1.5,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: ProductEditorTokens.blue.withValues(alpha: 0.08),
                  blurRadius: 0,
                  spreadRadius: 3,
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Checkbox(
                value: selected,
                onChanged: (value) => model.toggleSelect(variant.id),
              ),
              if (table.productId != null && table.productId!.isNotEmpty) ...[
                VariantTableImageCell(
                  productId: table.productId!,
                  variant: variant,
                  model: model,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      table._variantTitle(variant),
                      style: GoogleFonts.outfit(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: ProductEditorTokens.ink1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.qr_code_2,
                              size: 13,
                              color: ProductEditorTokens.ink4,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                subtitle,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 11.5,
                                  color: ProductEditorTokens.ink3,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: ProductEditorTokens.loss,
                ),
                onPressed: () => table._deleteVariant(context, variant),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(
            height: 1,
            color: selected
                ? ProductEditorTokens.blue.withValues(alpha: 0.2)
                : ProductEditorTokens.lineSoft,
          ),
          const SizedBox(height: 14),
          // ONE LayoutBuilder for the whole field area (same count as before
          // this card was split into primary/advanced groups). Extra nested
          // layout callbacks are exactly what this file's header warns about.
          LayoutBuilder(
            builder: (context, constraints) {
              final crossCount = constraints.maxWidth > 520 ? 3 : 2;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _grid(crossCount, [
                    table._priceField(variant),
                    table._quantityField(context, variant),
                    table._lowStockField(variant),
                  ]),
                  const SizedBox(height: 12),
                  _MoreDetailsToggle(
                    expanded: _expanded,
                    summary: table._detailsSummary(variant),
                    onTap: () => setState(() => _expanded = !_expanded),
                  ),
                  if (_expanded) ...[
                    const SizedBox(height: 14),
                    _grid(crossCount, [
                      table._taxField(variant),
                      table._discountField(variant),
                      table._unitField(variant),
                      table._itemClassField(context, variant),
                      table._expirationField(context, variant),
                    ]),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _grid(int crossCount, List<Widget> children) {
    return GridView.count(
      crossAxisCount: crossCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 14,
      childAspectRatio: 2.2,
      children: children,
    );
  }
}

class _MoreDetailsToggle extends StatelessWidget {
  const _MoreDetailsToggle({
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
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          child: Row(
            children: [
              Icon(
                expanded ? Icons.expand_less : Icons.expand_more,
                size: 18,
                color: ProductEditorTokens.blue,
              ),
              const SizedBox(width: 6),
              Text(
                expanded
                    ? 'Hide tax, unit & expiry'
                    : 'Tax, unit & expiry',
                style: GoogleFonts.outfit(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: ProductEditorTokens.blue,
                ),
              ),
              if (!expanded) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    summary,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.outfit(
                      fontSize: 11.5,
                      color: ProductEditorTokens.ink3,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
