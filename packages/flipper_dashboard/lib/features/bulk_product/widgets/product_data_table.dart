import 'package:fluentui_system_icons/fluentui_system_icons.dart';
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
    _dataSource = _newSource();
  }

  ProductDataGridSource _newSource() {
    return ProductDataGridSource(
      model: widget.model,
      onDeleteRow: _onDeleteRow,
    );
  }

  void _onDeleteRow(int index) {
    widget.model.removeRowAt(index);
    setState(() {
      _dataSource = _newSource();
    });
  }

  @override
  void didUpdateWidget(ProductDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldLen = oldWidget.model.excelData?.length;
    final newLen = widget.model.excelData?.length;
    if (oldWidget.model != widget.model || oldLen != newLen) {
      _dataSource = _newSource();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
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
                    label: _headerLabel('BarCode'),
                  ),
                  GridColumn(
                    columnName: 'Name',
                    label: _headerLabel('Name'),
                  ),
                  GridColumn(
                    columnName: 'Category',
                    label: _headerLabel('Category'),
                  ),
                  GridColumn(
                    columnName: 'Price',
                    label: _headerLabel('Price'),
                  ),
                  GridColumn(
                    columnName: 'SupplyPrice',
                    label: _headerLabel('Supply Price'),
                  ),
                  GridColumn(
                    columnName: 'Quantity',
                    label: _headerLabel('Quantity'),
                  ),
                  GridColumn(
                    columnName: 'ItemClass',
                    label: _headerLabel('Item Class'),
                  ),
                  GridColumn(
                    columnName: 'TaxType',
                    columnWidthMode: ColumnWidthMode.auto,
                    label: _headerLabel('Tax'),
                  ),
                  GridColumn(
                    columnName: 'ProductType',
                    label: _headerLabel('Type'),
                  ),
                  GridColumn(
                    columnName: 'Actions',
                    width: 56,
                    columnWidthMode: ColumnWidthMode.none,
                    label: _headerLabel(''),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Showing ${widget.model.rowCount} rows',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  Widget _headerLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ProductDataGridSource extends DataGridSource {
  final BulkAddProductViewModel model;
  final void Function(int index) onDeleteRow;
  List<DataGridRow> _rows = [];

  ProductDataGridSource({
    required this.model,
    required this.onDeleteRow,
  }) {
    _buildRows();
  }

  void _buildRows() {
    final data = model.excelData;
    if (data == null) {
      _rows = [];
      return;
    }
    _rows = data.asMap().entries.map<DataGridRow>((entry) {
      final product = entry.value;
      final barCode = product['BarCode'] ?? '';
      model.selectedProductTypes[barCode] ??= '2';
      model.selectedTaxTypes[barCode] ??= 'B';
      model.selectedItemClasses[barCode] ??= '5020230602';

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
            columnName: 'SupplyPrice',
            value: product['SupplyPrice'] ?? product['Price'] ?? '',
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
          DataGridCell<int>(columnName: 'Actions', value: entry.key),
        ],
      );
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final cells = row.getCells();
    final barCode = cells[0].value.toString();
    final rowIndex = cells.last.value as int;

    return DataGridRowAdapter(
      cells: [
        _textCell(barCode),
        _textCell(cells[1].value.toString()),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: CategoryDropdown(
            barCode: barCode,
            selectedValue: model.selectedCategories[barCode],
          ),
        ),
        _editablePrice(barCode, model.controllers[barCode], model.updatePrice),
        _editablePrice(
          barCode,
          model.supplyPriceControllers[barCode],
          model.updateSupplyPrice,
        ),
        _editablePrice(
          barCode,
          model.quantityControllers[barCode],
          model.updateQuantity,
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
        Container(
          alignment: Alignment.center,
          child: IconButton(
            tooltip: 'Remove row',
            icon: const Icon(FluentIcons.delete_24_regular, size: 20),
            onPressed: () => onDeleteRow(rowIndex),
          ),
        ),
      ],
    );
  }

  Widget _textCell(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _editablePrice(
    String barCode,
    TextEditingController? controller,
    void Function(String, String) onChanged,
  ) {
    if (controller == null) {
      return _textCell('');
    }
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: PriceQuantityField(
        controller: controller,
        onChanged: (value) => onChanged(barCode, value),
      ),
    );
  }
}
