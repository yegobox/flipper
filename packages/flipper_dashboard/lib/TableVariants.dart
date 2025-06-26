import 'package:flipper_dashboard/QuantityCell.dart';
import 'package:flipper_dashboard/TaxDropdown.dart';
import 'package:flipper_dashboard/UnitOfMeasureDropdown.dart';
import 'package:flipper_dashboard/UniversalProductDropdown.dart';
import 'package:flipper_dashboard/_showEditQuantityDialog.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/ebm_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check the screen size to determine whether to use mobile or desktop layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768; // Common breakpoint for mobile

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: isMobile
                  ? _buildMobileLayout(context, constraints)
                  : _buildDesktopLayout(context, constraints),
            ),
            // Show delete button only if at least one item is selected
            if (model.scannedVariants
                .any((variant) => model.isSelected(variant.id)))
              Positioned(
                top: 10,
                right: 10,
                child: _buildDeleteButton(context, model),
              ),
          ],
        );
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context, BoxConstraints constraints) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: constraints.maxWidth,
        ),
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

  Widget _buildMobileLayout(BuildContext context, BoxConstraints constraints) {
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
              onPressed: () => model.removeVariant(id: variant.id),
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
                      quantity: variant.stock?.currentStock,
                      onEdit: () {
                        showEditQuantityDialog(
                          context,
                          variant,
                          model,
                          () {
                            FocusScope.of(context)
                                .requestFocus(scannedInputFocusNode);
                          },
                        );
                      },
                    )),
                _buildMobileInfoRow('Tax',
                    Consumer(builder: (context, ref, child) {
                  final vatEnabledAsync = ref.watch(ebmVatEnabledProvider);
                  return vatEnabledAsync.when(
                    data: (vatEnabled) {
                      // If VAT is disabled, only allow tax type D
                      final options = vatEnabled ? ["A", "B", "C", "D"] : ["B"];
                      // If current value is not in options, default to D
                      final currentValue = options.contains(variant.taxTyCd)
                          ? variant.taxTyCd
                          : "B";
                      return TaxDropdown(
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
                })),
                _buildMobileInfoRow(
                    'Discount',
                    TextFormField(
                      controller: model.getDiscountController(variant.id),
                      decoration: const InputDecoration(suffixText: '%'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    )),
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
                              orElse: () => units
                                  .firstWhere((u) => u.name == variant.unit));
                          onUnitOfMeasureChanged?.call(
                              unit.code ?? newValue, variant.id);
                        }
                      },
                    )),
                _buildMobileInfoRow(
                    'Classification',
                    UniversalProductDropdown(
                      context: context,
                      model: model,
                      variant: variant,
                      universalProducts: unversalProducts,
                    )),
                _buildMobileInfoRow(
                    'Expiration',
                    TextFormField(
                      controller: model.getDateController(variant.id),
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.calendar_today),
                        hintText: variant.expirationDate != null
                            ? DateFormat('MMMM dd, yyyy')
                                .format(variant.expirationDate!)
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
                    )),
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
        label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataColumn(
        label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataColumn(
        label: Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
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
        label: Text('Classification',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataColumn(
        label:
            Text('Expiration', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataColumn(
        label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    ];
  }

  DataRow _buildRow(
      BuildContext context, ScannViewModel model, Variant variant) {
    return DataRow(
      selected: model.isSelected(variant.id),
      cells: [
        DataCell(Checkbox(
          value: model.isSelected(variant.id),
          onChanged: (value) => model.toggleSelect(variant.id),
        )),
        DataCell(Text(variant.bcd ?? variant.name)),
        DataCell(Text(variant.retailPrice?.toStringAsFixed(2) ?? '')),
        DataCell(
          QuantityCell(
            quantity: variant.stock?.currentStock,
            onEdit: () {
              showEditQuantityDialog(
                context,
                variant,
                model,
                () {
                  FocusScope.of(context).requestFocus(scannedInputFocusNode);
                },
              );
            },
          ),
        ),
        DataCell(Consumer(builder: (context, ref, child) {
          final vatEnabledAsync = ref.watch(ebmVatEnabledProvider);
          return vatEnabledAsync.when(
            data: (vatEnabled) {
              // If VAT is disabled, only allow tax type D
              final options = vatEnabled ? ["A", "B", "C", "D"] : ["D"];
              // If current value is not in options, default to D
              final currentValue =
                  options.contains(variant.taxTyCd) ? variant.taxTyCd : "D";
              return TaxDropdown(
                selectedValue: currentValue,
                options: options,
                onChanged: (newValue) => model.updateTax(variant, newValue),
              );
            },
            loading: () => TaxDropdown(
              selectedValue: variant.taxTyCd,
              options: ["A", "B", "C", "D"],
              onChanged: (newValue) => model.updateTax(variant, newValue),
            ),
            error: (_, __) => TaxDropdown(
              selectedValue: variant.taxTyCd,
              options: ["A", "B", "C", "D"],
              onChanged: (newValue) => model.updateTax(variant, newValue),
            ),
          );
        })),
        DataCell(TextFormField(
          controller: model.getDiscountController(variant.id),
          decoration: const InputDecoration(suffixText: '%'),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        )),
        DataCell(UnitOfMeasureDropdown(
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
        )),
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
        DataCell(TextFormField(
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
        )),
        DataCell(
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () => model.removeVariant(id: variant.id),
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
