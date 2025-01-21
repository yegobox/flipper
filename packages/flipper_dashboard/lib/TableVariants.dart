import 'package:flipper_dashboard/QuantityCell.dart';
import 'package:flipper_dashboard/TaxDropdown.dart';
import 'package:flipper_dashboard/UnitOfMeasureDropdown.dart';
import 'package:flipper_dashboard/UniversalProductDropdown.dart';
import 'package:flipper_dashboard/_showEditQuantityDialog.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TableVariants extends StatelessWidget {
  final ScannViewModel model;
  final List<String> unitOfMeasures;
  final Function(String? newValue)? onUnitOfMeasureChanged;
  final FocusNode scannedInputFocusNode;
  final List<IUnit> units;
  final AsyncValue<List<UnversalProduct>>? unversalProducts;

  const TableVariants({
    Key? key,
    required this.model,
    required this.unitOfMeasures,
    this.onUnitOfMeasureChanged,
    required this.scannedInputFocusNode,
    required this.unversalProducts,
    required this.units,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    color: Colors.black.withValues(alpha: .1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                  ),
                  child: SingleChildScrollView(
                    child: DataTable(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      columns: _buildColumns(),
                      rows: model.scannedVariants.reversed.map((variant) {
                        return _buildRow(context, model, variant);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            // Modified Positioned Widget: Show only if at least one item selected.
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

  List<DataColumn> _buildColumns() {
    return [
      DataColumn(
          label: Checkbox(
              value: model.selectAll(model.scannedVariants),
              onChanged: (bool? value) => model.toggleSelectAll(
                  model.scannedVariants, value ?? false))),
      const DataColumn(
          label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
      const DataColumn(
          label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
      const DataColumn(
          label:
              Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold))),
      const DataColumn(
          label: Text('Tax', style: TextStyle(fontWeight: FontWeight.bold))),
      const DataColumn(
          label:
              Text('Discount', style: TextStyle(fontWeight: FontWeight.bold))),
      const DataColumn(
          label: Text('Unit', style: TextStyle(fontWeight: FontWeight.bold))),
      const DataColumn(
          label: Text('Classification',
              style: TextStyle(fontWeight: FontWeight.bold))),
      const DataColumn(
          label: Text('Expiration',
              style: TextStyle(fontWeight: FontWeight.bold))),
      const DataColumn(
          label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
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
        DataCell(TaxDropdown(
          selectedValue: variant.taxTyCd,
          options: ["A", "B", "C", "D"],
          onChanged: (newValue) => model.updateTax(variant, newValue),
        )),
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
              onUnitOfMeasureChanged?.call(newValue);
            }
          },
        )),
        DataCell(UniversalProductDropdown(
          context: context,
          model: model,
          variant: variant,
          unitsAsyncValue: unversalProducts,
        )),
        DataCell(TextFormField(
          controller: model.getDateController(variant.id),
          decoration:
              const InputDecoration(suffixIcon: Icon(Icons.calendar_today)),
          readOnly: true,
          onTap: () async {
            final date = await model.pickDate(context);
            if (date != null) {
              // model.updateDateController(variant.id, date);
            }
          },
        )),
        DataCell(IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => model.removeVariant(id: variant.id),
        )),
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
