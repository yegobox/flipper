import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flipper_models/bulk_add_constants.dart';
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
    final oldPage = oldWidget.model.largeImportPageIndex;
    final newPage = widget.model.largeImportPageIndex;
    if (oldWidget.model != widget.model ||
        oldLen != newLen ||
        oldPage != newPage) {
      _dataSource = _newSource();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.model.exceedsEditableLimit) ...[
          Material(
            color: Colors.lightBlue.shade50,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Large import: you can edit prices and options for each page '
                '(${widget.model.rowCount} products). Use the arrows below the '
                'grid to load the next or previous 20 rows.',
                style: TextStyle(fontSize: 13, color: Colors.blueGrey.shade900),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
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
          child: widget.model.exceedsEditableLimit
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final page = widget.model.largeImportPageIndex;
                          final total = widget.model.rowCount;
                          final start = page * kBulkLargeEditPageSize + 1;
                          var end = (page + 1) * kBulkLargeEditPageSize;
                          if (end > total) end = total;
                          return Text(
                            'Page ${page + 1} of ${widget.model.largeImportPageCount}'
                            ' — editing rows $start–$end of $total '
                            '(${widget.model.rowsVisibleInGrid.length} '
                            'on screen)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      tooltip: 'Previous page',
                      onPressed:
                          widget.model.largeImportPageIndex > 0
                          ? widget.model.prevLargeImportPage
                          : null,
                      icon: const Icon(Icons.chevron_left, size: 28),
                    ),
                    IconButton(
                      tooltip: 'Next page',
                      onPressed:
                          widget.model.largeImportPageIndex <
                              widget.model.largeImportPageCount - 1
                          ? widget.model.nextLargeImportPage
                          : null,
                      icon: const Icon(Icons.chevron_right, size: 28),
                    ),
                  ],
                )
              : Text(
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
  List<Map<String, dynamic>> _visibleRows = [];

  ProductDataGridSource({
    required this.model,
    required this.onDeleteRow,
  }) {
    _buildRows();
  }

  void _buildRows() {
    final data = model.rowsVisibleInGrid;
    _visibleRows = List<Map<String, dynamic>>.from(data);
    if (data.isEmpty) {
      _rows = [];
      return;
    }
    _rows = data.asMap().entries.map<DataGridRow>((entry) {
      final product = entry.value;
      final displayBarCode = product['BarCode'] ?? '';
      final rowUid = model.bulkRowUidForRow(product);
      model.selectedProductTypes[rowUid] ??= '2';
      model.selectedTaxTypes[rowUid] ??= model.defaultBulkTaxTyCd;
      model.selectedItemClasses[rowUid] ??= '5020230602';

      return DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: 'BarCode',
            value: displayBarCode.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Name',
            value: product['Name'] ?? '',
          ),
          DataGridCell<String>(
            columnName: 'Category',
            value: model.selectedCategories[rowUid],
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
            value: model.selectedItemClasses[rowUid],
          ),
          DataGridCell<String>(
            columnName: 'TaxType',
            value: model.selectedTaxTypes[rowUid],
          ),
          DataGridCell<String>(
            columnName: 'ProductType',
            value: model.selectedProductTypes[rowUid],
          ),
          DataGridCell<int>(
            columnName: 'Actions',
            value: model.gridLocalToAbsoluteIndex(entry.key),
          ),
        ],
      );
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final cells = row.getCells();
    final i = rows.indexWhere((r) => identical(r, row));
    final rowUid = (i >= 0 && i < _visibleRows.length)
        ? model.bulkRowUidForRow(_visibleRows[i])
        : '';
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
            barCode: rowUid,
            selectedValue: model.selectedCategories[rowUid],
          ),
        ),
        _editablePrice(rowUid, model.controllers[rowUid], model.updatePrice),
        _editablePrice(
          rowUid,
          model.supplyPriceControllers[rowUid],
          model.updateSupplyPrice,
        ),
        _editablePrice(
          rowUid,
          model.quantityControllers[rowUid],
          model.updateQuantity,
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ItemClassDropdown(
            barCode: rowUid,
            selectedValue: model.selectedItemClasses[rowUid],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: TaxTypeDropdown(
            barCode: rowUid,
            selectedValue: model.selectedTaxTypes[rowUid],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ProductTypeDropdown(
            barCode: rowUid,
            selectedValue: model.selectedProductTypes[rowUid],
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
