import 'package:flutter/material.dart';
import 'package:flipper_models/view_models/BulkAddProductViewModel.dart';
import 'package:flipper_dashboard/features/bulk_product/widgets/product_field_widgets.dart';

class ProductDataTable extends StatelessWidget {
  final BulkAddProductViewModel model;

  const ProductDataTable({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          columns: [
            DataColumn(
              label: Text('BarCode',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label:
                  Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Category',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label:
                  Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Quantity',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Item Class',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Tax Type',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Product Type',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
          rows: model.excelData!.map((product) {
            String barCode = product['BarCode'] ?? '';
            if (!model.controllers.containsKey(barCode)) {
              model.controllers[barCode] =
                  TextEditingController(text: product['Price']);
            }
            if (!model.quantityControllers.containsKey(barCode)) {
              model.quantityControllers[barCode] =
                  TextEditingController(text: product['Quantity'] ?? '0');
            }

            return DataRow(
              cells: [
                DataCell(Text(product['BarCode'] ?? '')),
                DataCell(Text(product['Name'] ?? '')),
                DataCell(
                  SizedBox(
                    width: 200, // Fixed width, you can adjust this
                    child: CategoryDropdown(
                      barCode: barCode,
                      selectedValue: model.selectedCategories[barCode],
                    ),
                  ),
                ),
                DataCell(
                  TextField(
                    controller: model.controllers[barCode],
                    onChanged: (value) {
                      model.updatePrice(product['BarCode'], value);
                    },
                  ),
                ),
                DataCell(
                  PriceQuantityField(
                    controller: model.quantityControllers[barCode]!,
                    onChanged: (value) {
                      model.updateQuantity(product['BarCode'], value);
                    },
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 200, // Fixed width, you can adjust this
                    child: ItemClassDropdown(
                      barCode: barCode,
                      selectedValue: model.selectedItemClasses[barCode],
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 100, // Fixed width, you can adjust this
                    child: TaxTypeDropdown(
                      barCode: barCode,
                      selectedValue: model.selectedTaxTypes[barCode],
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 100, // Fixed width, you can adjust this
                    child: ProductTypeDropdown(
                      barCode: barCode,
                      selectedValue: model.selectedProductTypes[barCode],
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
