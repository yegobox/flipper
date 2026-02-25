import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flipper_models/view_models/BulkAddProductViewModel.dart';
import 'package:flipper_dashboard/features/bulk_product/widgets/product_field_widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class ProductDataTable extends ConsumerStatefulWidget {
  final BulkAddProductViewModel model;

  const ProductDataTable({super.key, required this.model});

  @override
  ProductDataTableState createState() => ProductDataTableState();
}

class ProductDataTableState extends ConsumerState<ProductDataTable> {
  late ProductDataGridSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = ProductDataGridSource(model: widget.model);
  }

  @override
  void didUpdateWidget(ProductDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.model != widget.model ||
        oldWidget.model.excelData != widget.model.excelData) {
      _dataSource = ProductDataGridSource(model: widget.model);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize controllers if not already done
    widget.model.initializeControllers();

    return Container(
      // Limit height to 600 or content height, whatever is smaller, or just content height
      // but let's make it more production-ready by using a max height.
      constraints: BoxConstraints(
        maxHeight: 600,
        minHeight: 110, // Header + at least one row
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SfDataGrid(
          source: _dataSource,
          columnWidthMode: ColumnWidthMode.fill,
          rowHeight: 60,
          headerRowHeight: 50,
          gridLinesVisibility: GridLinesVisibility.horizontal,
          headerGridLinesVisibility: GridLinesVisibility.horizontal,
          columns: [
            GridColumn(
              columnName: 'BarCode',
              label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'BarCode',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GridColumn(
              columnName: 'Name',
              label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GridColumn(
              columnName: 'Category',
              label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Category',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GridColumn(
              columnName: 'Price',
              label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Price',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GridColumn(
              columnName: 'Quantity',
              label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Quantity',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GridColumn(
              columnName: 'ItemClass',
              label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Item Class',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GridColumn(
              columnName: 'TaxType',
              columnWidthMode: ColumnWidthMode.auto,
              label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tax',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GridColumn(
              columnName: 'ProductType',
              label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Type',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDataGridSource extends DataGridSource {
  final BulkAddProductViewModel model;
  List<DataGridRow> _rows = [];

  ProductDataGridSource({required this.model}) {
    _buildRows();
  }

  void _buildRows() {
    _rows = model.excelData!.map<DataGridRow>((product) {
      String barCode = product['BarCode'] ?? '';

      // Set up controllers if they don't exist
      if (!model.controllers.containsKey(barCode)) {
        model.controllers[barCode] = TextEditingController(
          text: product['Price'],
        );
      }
      if (!model.quantityControllers.containsKey(barCode)) {
        model.quantityControllers[barCode] = TextEditingController(
          text: product['Quantity'] ?? '0',
        );
      }

      return DataGridRow(
        cells: [
          DataGridCell<String>(columnName: 'BarCode', value: barCode),
          DataGridCell<String>(
            columnName: 'Name',
            value: product['Name'] ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Category',
            value: model.selectedCategories[barCode],
          ),
          DataGridCell<String>(
            columnName: 'Price',
            value: product['Price'] ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Quantity',
            value: product['Quantity'] ?? '0',
          ),
          DataGridCell<String>(
            columnName: 'ItemClass',
            value: model.selectedItemClasses[barCode],
          ),
          DataGridCell<String>(
            columnName: 'TaxType',
            value: model.selectedTaxTypes[barCode],
          ),
          DataGridCell<String>(
            columnName: 'ProductType',
            value: model.selectedProductTypes[barCode],
          ),
        ],
      );
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final String barCode = row.getCells()[0].value.toString();

    return DataGridRowAdapter(
      cells: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            barCode,
            style: const TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            row.getCells()[1].value.toString(),
            style: const TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: CategoryDropdown(
            barCode: barCode,
            selectedValue: model.selectedCategories[barCode],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: PriceQuantityField(
            controller: model.controllers[barCode]!,
            onChanged: (value) {
              model.updatePrice(barCode, value);
            },
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: PriceQuantityField(
            controller: model.quantityControllers[barCode]!,
            onChanged: (value) {
              model.updateQuantity(barCode, value);
            },
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ItemClassDropdown(
            barCode: barCode,
            selectedValue: model.selectedItemClasses[barCode],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: TaxTypeDropdown(
            barCode: barCode,
            selectedValue: model.selectedTaxTypes[barCode],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ProductTypeDropdown(
            barCode: barCode,
            selectedValue: model.selectedProductTypes[barCode],
          ),
        ),
      ],
    );
  }
}
