// ignore_for_file: unused_result

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

mixin TransactionItemTable<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  List<TransactionItem> transactionItems = [];

  // Calculation methods
  double get grandTotal {
    double total = 0.0;
    double compositeTotal = 0.0;
    int compositeCount = 0;

    for (final item in transactionItems) {
      if (item.compositePrice != 0) {
        compositeTotal = item.compositePrice!;
        compositeCount++;
      } else {
        total += item.price * item.qty;
      }
    }

    return compositeCount == transactionItems.length
        ? compositeTotal
        : total + compositeTotal;
  }

  Widget buildTransactionItemsTable(bool isOrdering) {
    return Table(
      columnWidths: {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(3),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
      },
      children: [
        _buildTableHeader(),
        if (transactionItems.isEmpty)
          TableRow(children: [
            _buildTableCell('No data available'),
            _buildTableCell(''),
            _buildTableCell(''),
            _buildTableCell(''),
            _buildTableCell(''),
          ])
        else
          ...transactionItems.map((item) => _buildTableRow(item, isOrdering)),
      ],
    );
  }

  // UI Components
  TableRow _buildTableHeader() {
    return TableRow(
      children: ['Name', 'Price', '', 'Total', '']
          .map((title) => Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              ))
          .toList(),
    );
  }

  TableRow _buildTableRow(TransactionItem item, bool isOrdering) {
    // Check if the item is valid before accessing its properties

    // If the item is valid, proceed with building the row
    return TableRow(
      children: [
        _buildTableCell(_getItemName(item)),
        _buildTableCell(_getItemPrice(item)),
        _buildQuantityCell(item, isOrdering),
        _buildTableCell(_getItemTotal(item)),
        _buildDeleteButton(item, isOrdering),
      ],
    );
  }

// Helper function to safely get the item name
  String _getItemName(TransactionItem item) {
    return item.name.extractNameAndNumber();
  }

// Helper function to safely get the item price
  String _getItemPrice(TransactionItem item) {
    return item.price.toStringAsFixed(0);
  }

// Helper function to safely calculate the total price
  String _getItemTotal(TransactionItem item) {
    return (item.price * item.qty).toStringAsFixed(0);
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: TextStyle(fontSize: 12)),
    );
  }

  Widget _buildQuantityCell(TransactionItem item, bool isOrdering) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildQuantityButton(Icons.remove, Colors.red,
              () => _decrementQuantity(item, isOrdering)),
          SizedBox(width: 8),
          _buildQuantityField(item, isOrdering),
          SizedBox(width: 8),
          _buildQuantityButton(Icons.add, Colors.blue,
              () => _incrementQuantity(item, isOrdering)),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildQuantityField(TransactionItem item, bool isOrdering) {
    return SizedBox(
      width: 50,
      child: TextFormField(
        key: ValueKey(item.qty),
        initialValue: item.qty.toString(),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(4),
          ),
          fillColor: Colors.grey[200],
          filled: true,
        ),
        onChanged: (value) => _updateQuantity(item, value, isOrdering),
      ),
    );
  }

  Widget _buildDeleteButton(TransactionItem item, bool isOrdering) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => _deleteItem(item, isOrdering),
      ),
    );
  }

  // Item manipulation methods
  Future<void> _decrementQuantity(TransactionItem item, bool isOrdering) async {
    if (!item.partOfComposite!) {
      if (item.qty > 0) {
        item.qty--;
        await ProxyService.strategy.updateTransactionItem(
          transactionItemId: item.id,
          qty: item.qty,
          quantityRequested: item.qty.toInt(),
        );
      }
      _refreshTransactionItems(isOrdering);
    }
  }

  Future<void> _incrementQuantity(TransactionItem item, bool isOrdering) async {
    if (!item.partOfComposite!) {
      await ProxyService.strategy.updateTransactionItem(
        transactionItemId: item.id,
        qty: item.qty,
        incrementQty: true,
        quantityRequested: item.qty.toInt(),
      );
      _refreshTransactionItems(isOrdering);
    }
  }

  Future<void> _updateQuantity(
      TransactionItem item, String value, bool isOrdering) async {
    if (!item.partOfComposite!) {
      final trimmedValue = value.trim();
      final doubleValue = double.tryParse(trimmedValue) ??
          int.tryParse(trimmedValue)?.toDouble();
      if (doubleValue != null) {
        final newQty = doubleValue.toInt();
        if (doubleValue == newQty.toDouble() && newQty >= 0) {
          await ProxyService.strategy.updateTransactionItem(
            transactionItemId: item.id,
            qty: doubleValue,
            incrementQty: false,
            quantityRequested: newQty,
          );
          _refreshTransactionItems(isOrdering);
        }
      }
    }
  }

  void _deleteItem(TransactionItem item, bool isOrdering) {
    if (!item.partOfComposite!) {
      _deleteSingleItem(item, isOrdering);
      ref.refresh(transactionItemsProvider((isExpense: isOrdering)));
      ref.refresh(transactionItemsProvider((isExpense: isOrdering)));
    } else {
      _deleteCompositeItems(item, isOrdering);
      ref.refresh(transactionItemsProvider((isExpense: isOrdering)));
    }
  }

  void _deleteSingleItem(TransactionItem item, bool isOrdering) {
    try {
      ProxyService.strategy.delete(id: item.id, endPoint: 'transactionItem');
      _refreshTransactionItems(isOrdering);
    } catch (e) {
      talker.error(e);
    }
  }

  Future<void> _deleteCompositeItems(
      TransactionItem item, bool isOrdering) async {
    try {
      Variant? variant = (await ProxyService.strategy.variants(
              variantId: item.variantId!,
              branchId: ProxyService.box.getBranchId()!))
          .firstOrNull;
      final composites = await ProxyService.strategy
          .composites(productId: variant!.productId!);

      for (final composite in composites) {
        final deletableItem = await ProxyService.strategy
            .getTransactionItemByVariantId(variantId: composite.variantId!);
        if (deletableItem != null) {
          ProxyService.strategy
              .delete(id: deletableItem.id, endPoint: 'transactionItem');
        }
      }
    } catch (e) {}
    _refreshTransactionItems(isOrdering);
  }

  void _refreshTransactionItems(bool isOrdering) {
    ref.refresh(transactionItemsProvider((isExpense: isOrdering)));
    setState(() {});
  }
}
