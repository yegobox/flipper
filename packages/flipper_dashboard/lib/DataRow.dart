import 'package:flipper_models/helper_models.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart';

class DataRowWidget extends StatefulHookConsumerWidget {
  const DataRowWidget({
    Key? key,
    required this.nameController,
    required this.supplyPriceController,
    required this.retailPriceController,
    required this.saveItemName,
    required this.acceptPurchases,
    required this.selectSale,
    required this.finalSalesList,
    required this.salesList,
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController supplyPriceController;
  final TextEditingController retailPriceController;
  final void Function(Variant? selectedItem, Purchase saleList) selectSale;
  final List<Variant> finalSalesList;
  final List<Purchase> salesList;
  final VoidCallback saveItemName;
  final VoidCallback acceptPurchases;

  @override
  _DataRowWidgetState createState() => _DataRowWidgetState();
}

class _DataRowWidgetState extends ConsumerState<DataRowWidget> {
  Variant? selectedItemList;

  int? _hoveredRowIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 80,
          ),
          child: DataTable(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              border:
                  Border.all(color: theme.dividerColor.withValues(alpha: 0.2)),
            ),
            columnSpacing: 32.0,
            headingRowHeight: 56.0,
            headingRowColor: WidgetStateProperty.all(
              theme.primaryColor.withValues(alpha: 0.1),
            ),
            columns: _buildColumns(),
            rows: _buildRows(theme),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    const headerStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16.0,
      letterSpacing: 0.5,
    );

    return [
      DataColumn(
        label: Flexible(
          child: Text(
            'Supplier Name',
            style: headerStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        tooltip: 'Name of the supplier',
      ),
      DataColumn(
        label: Flexible(
          child: Text(
            'Supplier TIN',
            style: headerStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        tooltip: 'Tax Identification Number',
      ),
      DataColumn(
        label: Flexible(
          child: Text(
            'Total Taxable Amount',
            style: headerStyle,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
        ),
        tooltip: 'Total amount subject to tax',
        numeric: true,
      ),
    ];
  }

  List<DataRow> _buildRows(ThemeData theme) {
    return List.generate(widget.salesList.length, (index) {
      final item = widget.salesList[index];

      return DataRow(
        color:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (_hoveredRowIndex == index) {
            return theme.hoverColor;
          }
          return index.isEven ? theme.scaffoldBackgroundColor : Colors.white;
        }),
        onSelectChanged: (_) => _showEditDialog(context, item),
        cells: [
          _buildDataCell(item.spplrNm, alignment: Alignment.centerLeft),
          _buildDataCell(item.spplrTin),
          _buildDataCell(
            item.totTaxAmt.toRwf(),
            alignment: Alignment.centerRight,
          ),
        ],
      );
    });
  }

  DataCell _buildDataCell(String text,
      {Alignment alignment = Alignment.center}) {
    return DataCell(
      Align(
        alignment: alignment,
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 14.0,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Purchase item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogHeader(context),
              _buildEditForm(),
              _buildItemsTable(item),
              _buildDialogActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Edit Item Details',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: _buildTextField(
              widget.nameController,
              'Item Name',
              prefixIcon: Icons.inventory,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildTextField(
              widget.supplyPriceController,
              'Supply Price',
              prefixIcon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildTextField(
              widget.retailPriceController,
              'Retail Price',
              prefixIcon: Icons.point_of_sale,
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    IconData? prefixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool isPassword = false,
    String? hintText,
    bool autoFocus = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      autofocus: autoFocus,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: validator,
      style: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildItemsTable(Purchase saleList) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return DataTable(
            headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
            columns: [
              DataColumn(label: SizedBox(child: const Text('Item Name'))),
              DataColumn(
                  label: SizedBox(child: const Text('Quantity')),
                  numeric: true),
              DataColumn(
                  label: SizedBox(child: const Text('Price')), numeric: true),
              DataColumn(
                  label: SizedBox(child: const Text('Total Tax')),
                  numeric: true),
            ],
            rows: _buildItemRows(saleList),
          );
        },
      ),
    );
  }

  List<DataRow> _buildItemRows(Purchase saleList) {
    return saleList.variants!.map((item) {
      widget.finalSalesList.add(item);
      return DataRow(
        selected: selectedItemList == item,
        onSelectChanged: (selected) {
          setState(() {
            selectedItemList = selected == true ? item : null;
          });
          widget.selectSale(selectedItemList, saleList);
        },
        cells: [
          DataCell(
              Text(item.itemNm ?? item.name, overflow: TextOverflow.ellipsis)),
          DataCell(Text(item.qty.toString())),
          DataCell(Text(item.prc!.toRwf())),
          DataCell(Text(item.totAmt!.toRwf())),
        ],
      );
    }).toList();
  }

  Widget _buildDialogActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 16),
          FlipperButton(
            onPressed: () {
              widget.saveItemName();
              Navigator.of(context).pop();
            },
            text: 'Save Changes',
            textColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
