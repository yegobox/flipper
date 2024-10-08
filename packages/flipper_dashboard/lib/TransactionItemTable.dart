// ignore_for_file: unused_result

import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/DeviceType.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/helperModels/extensions.dart';

mixin TransactionItemTable<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  List<TransactionItem> transactionItems = [];

  // Calculation methods
  double get grandTotal {
    double total = 0.0;
    double compositeTotal = 0.0;
    int compositeCount = 0;

    for (final item in transactionItems) {
      if (!item.isValid) continue;
      if (item.compositePrice != 0) {
        compositeTotal = item.compositePrice;
        compositeCount++;
      } else {
        total += item.price * item.qty;
      }
    }

    return compositeCount == transactionItems.length
        ? compositeTotal
        : total + compositeTotal;
  }

  String getDeviceType(BuildContext context) {
    return DeviceType.getDeviceType(context);
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
    if (!item.isValid) {
      return TableRow(
        children: [
          _buildTableCell("Invalid Item"),
          _buildTableCell(""),
          _buildTableCell(""),
          _buildTableCell(""),
          _buildDeleteButton(item, isOrdering),
        ],
      );
    }

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
    if (item.isValid && item.name != null) {
      return item.name!.extractNameAndNumber();
    }
    return "";
  }

// Helper function to safely get the item price
  String _getItemPrice(TransactionItem item) {
    if (item.isValid) {
      return item.price.toStringAsFixed(0);
    }
    return "";
  }

// Helper function to safely calculate the total price
  String _getItemTotal(TransactionItem item) {
    if (item.isValid) {
      return (item.price * item.qty).toStringAsFixed(0);
    }
    return "";
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
  void _decrementQuantity(TransactionItem item, bool isOrdering) {
    if (!item.partOfComposite && item.isValid) {
      ProxyService.realm.realm!.write(() {
        if (item.qty > 0) {
          item.qty--;
          item.quantityRequested = item.qty.toInt();
        }
      });
      _refreshTransactionItems(isOrdering);
    }
  }

  void _incrementQuantity(TransactionItem item, bool isOrdering) {
    if (!item.partOfComposite && item.isValid) {
      ProxyService.realm.realm!.write(() {
        item.qty++;
        item.quantityRequested = item.qty.toInt();
      });
      _refreshTransactionItems(isOrdering);
    }
  }

  void _updateQuantity(TransactionItem item, String value, bool isOrdering) {
    if (!item.partOfComposite && item.isValid) {
      final trimmedValue = value.trim();
      final doubleValue = double.tryParse(trimmedValue) ??
          int.tryParse(trimmedValue)?.toDouble();
      if (doubleValue != null) {
        final newQty = doubleValue.toInt();
        if (doubleValue == newQty.toDouble() && newQty >= 0) {
          ProxyService.realm.realm!.write(() {
            item.qty = doubleValue;
            item.quantityRequested = newQty;
          });
          _refreshTransactionItems(isOrdering);
        }
      }
    }
  }

  void _deleteItem(TransactionItem item, bool isOrdering) {
    if (!item.isValid) return;

    if (!item.partOfComposite) {
      _deleteSingleItem(item, isOrdering);
    } else {
      _deleteCompositeItems(item, isOrdering);
    }
  }

  void _deleteSingleItem(TransactionItem item, bool isOrdering) {
    try {
      ProxyService.realm.realm!.write(() {
        ProxyService.realm.realm!.delete(item);
      });
      _refreshTransactionItems(isOrdering);
    } catch (e) {
      talker.error(e);
    }
  }

  void _deleteCompositeItems(TransactionItem item, bool isOrdering) {
    final coo = ProxyService.realm.composite(variantId: item.variantId!);
    final composites = ProxyService.realm.composites(productId: coo.productId!);

    for (final composite in composites) {
      final deletableItem = ProxyService.realm
          .getTransactionItemByVariantId(variantId: composite.variantId!);
      if (deletableItem != null && deletableItem.isValid) {
        ProxyService.realm.realm!.write(() {
          ProxyService.realm.realm!.delete(deletableItem);
        });
      }
    }
    _refreshTransactionItems(isOrdering);
  }

  void _refreshTransactionItems(bool isOrdering) {
    ref.refresh(transactionItemsProvider((isExpense: isOrdering)));
    setState(() {});
  }
}
