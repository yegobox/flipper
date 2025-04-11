// ignore_for_file: unused_result

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';

import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

mixin TransactionItemTable<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  List<TransactionItem> internalTransactionItems = [];
  // Add a map to track local quantities
  final Map<String, double> _localQuantities = {};

  @override
  void initState() {
    super.initState();
    // Initialize local quantities from internalTransactionItems
    _updateLocalQuantities();
  }

  void _updateLocalQuantities() {
    for (var item in internalTransactionItems) {
      _localQuantities[item.id] = item.qty;
    }
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update local quantities when internalTransactionItems changes
    _updateLocalQuantities();
  }

  // Calculation methods
  double get grandTotal {
    double total = 0.0;
    double compositeTotal = 0.0;
    int compositeCount = 0;

    for (final item in internalTransactionItems) {
      if (item.compositePrice != 0) {
        compositeTotal = item.compositePrice!;
        compositeCount++;
      } else {
        total += item.price * item.qty;
      }
    }

    return compositeCount == internalTransactionItems.length
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
        if (internalTransactionItems.isEmpty)
          TableRow(children: [
            _buildTableCell('No data available'),
            _buildTableCell(''),
            _buildTableCell(''),
            _buildTableCell(''),
            _buildTableCell(''),
          ])
        else
          ...internalTransactionItems
              .map((item) => _buildTableRow(item, isOrdering)),
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
    final currentQty = _getCurrentQuantity(item);
    return SizedBox(
      width: 50,
      child: TextFormField(
        key: ValueKey('${item.id}_$currentQty'),
        initialValue: currentQty.toString(),
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

  // Helper method to get the current quantity
  double _getCurrentQuantity(TransactionItem item) {
    // Always get the latest quantity from the item itself
    _localQuantities[item.id] = item.qty;
    return _localQuantities[item.id] ?? item.qty;
  }

  // Update both local and remote quantity
  Future<void> _updateQuantityBoth(
      TransactionItem item, double newQty, bool isOrdering) async {
    if (item.partOfComposite!) return;

    // Update local state immediately
    setState(() {
      _localQuantities[item.id] = newQty;
      item.qty = newQty; // Also update the item's quantity
    });

    try {
      await ProxyService.strategy.updateTransactionItem(
        transactionItemId: item.id,
        qty: newQty,
        incrementQty: false,
        quantityRequested: newQty.toInt(),
      );
      _refreshTransactionItems(isOrdering, transactionId: item.transactionId!);
    } catch (e) {
      // Revert local state on error
      setState(() {
        _localQuantities[item.id] = item.qty;
      });
      talker.error(e);
    }
  }

  Future<void> _incrementQuantity(TransactionItem item, bool isOrdering) async {
    if (!item.partOfComposite!) {
      final newQty = _getCurrentQuantity(item) + 1;
      await _updateQuantityBoth(item, newQty, isOrdering);
    }
  }

  Future<void> _decrementQuantity(TransactionItem item, bool isOrdering) async {
    if (!item.partOfComposite!) {
      final currentQty = _getCurrentQuantity(item);
      if (currentQty > 0) {
        await _updateQuantityBoth(item, currentQty - 1, isOrdering);
      }
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
          await _updateQuantityBoth(item, doubleValue, isOrdering);
        }
      }
    }
  }

  // Item manipulation methods
  Future<void> _deleteItem(TransactionItem item, bool isOrdering) async {
    if (!item.partOfComposite!) {
      await _deleteSingleItem(item, isOrdering);
      ref.refresh(transactionItemsProvider(transactionId: item.transactionId));
      ref.refresh(transactionItemsProvider(transactionId: item.transactionId));
    } else {
      await _deleteCompositeItems(item, isOrdering);
      ref.refresh(transactionItemsProvider(transactionId: item.transactionId));
    }
  }

  Future<void> _deleteSingleItem(TransactionItem item, bool isOrdering) async {
    try {
      await ProxyService.strategy
          .delete(id: item.id, endPoint: 'transactionItem');
      _refreshTransactionItems(isOrdering, transactionId: item.transactionId!);
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
            .getTransactionItem(variantId: composite.variantId!);
        if (deletableItem != null) {
          ProxyService.strategy
              .delete(id: deletableItem.id, endPoint: 'transactionItem');
        }
      }
    } catch (e) {}
    _refreshTransactionItems(isOrdering, transactionId: item.transactionId!);
  }

  void _refreshTransactionItems(bool isOrdering,
      {required String transactionId}) {
    ref.refresh(transactionItemsProvider(transactionId: transactionId));
  }
}
