// ignore_for_file: unused_result

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // Import for Timer

/// Modern Transaction Item Table Mixin
/// Inspired by Microsoft Fluent Design, QuickBooks clarity, and Duolingo engagement
mixin TransactionItemTable<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  // === CORE DATA ===
  List<TransactionItem> internalTransactionItems = [];
  final Map<String, TextEditingController> _quantityControllers = {};
  final Map<String, FocusNode> _quantityFocusNodes = {};
  final Map<String, TextEditingController> _priceControllers = {};
  final Map<String, FocusNode> _priceFocusNodes = {};

  // === MODERN UX ENHANCEMENTS ===
  final Map<String, bool> _isItemSaving = {};
  final Map<String, bool> _hasItemChanged = {};
  final Map<String, String> _itemErrors = {};
  String? _expandedItemId;

  // Debouncing for text fields
  final Map<String, Timer?> _debounceTimers = {};
  static const Duration _debounceDuration = Duration(milliseconds: 800);

  @override
  void initState() {
    super.initState();
    for (var item in internalTransactionItems) {
      _initController(item);
    }
  }

  void _initController(TransactionItem item) {
    final id = item.id;
    final qty = item.qty;
    final price = item.price;

    // Quantity Controller
    _quantityControllers.putIfAbsent(
        id, () => TextEditingController(text: qty.toString()));
    _quantityFocusNodes.putIfAbsent(id, () => FocusNode());

    // Price Controller
    _priceControllers.putIfAbsent(
        id, () => TextEditingController(text: price.toStringAsFixed(2)));
    _priceFocusNodes.putIfAbsent(id, () => FocusNode());

    // Update controller text only if not focused to avoid input issues
    // and if the backend value is different (e.g., after a refresh)
    if (!_quantityFocusNodes[id]!.hasFocus &&
        _quantityControllers[id]!.text != qty.toString()) {
      _quantityControllers[id]!.text = qty.toString();
    }
    if (!_priceFocusNodes[id]!.hasFocus &&
        _priceControllers[id]!.text != price.toStringAsFixed(2)) {
      _priceControllers[id]!.text = price.toStringAsFixed(2);
    }

    // Initialize UI state
    _isItemSaving[id] ??= false;
    _hasItemChanged[id] ??= false;
    _itemErrors.remove(id); // Clear errors on init/update
  }

  void _removeUnusedControllers() {
    final ids = internalTransactionItems.map((e) => e.id).toSet();
    final toRemove =
        _quantityControllers.keys.where((id) => !ids.contains(id)).toList();

    for (final id in toRemove) {
      _quantityControllers[id]?.dispose();
      _quantityControllers.remove(id);
      _quantityFocusNodes[id]?.dispose();
      _quantityFocusNodes.remove(id);
      _priceControllers[id]?.dispose();
      _priceControllers.remove(id);
      _priceFocusNodes[id]?.dispose();
      _priceFocusNodes.remove(id);

      // Clean up modern UX state and debounce timers
      _isItemSaving.remove(id);
      _hasItemChanged.remove(id);
      _itemErrors.remove(id);
      _debounceTimers[id]?.cancel();
      _debounceTimers.remove(id);
    }
  }

  @override
  void dispose() {
    for (final c in _quantityControllers.values) {
      c.dispose();
    }
    for (final f in _quantityFocusNodes.values) {
      f.dispose();
    }
    for (final c in _priceControllers.values) {
      c.dispose();
    }
    for (final f in _priceFocusNodes.values) {
      f.dispose();
    }
    for (final timer in _debounceTimers.values) {
      timer?.cancel();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    for (var item in internalTransactionItems) {
      _initController(item);
    }
    _removeUnusedControllers();
  }

  // === MODERN CALCULATIONS WITH QUICKBOOKS PRECISION ===
  num get grandTotal {
    num total = 0.0;
    num compositeTotal = 0.0;
    int compositeCount = 0;

    for (final item in internalTransactionItems) {
      if (item.compositePrice != 0) {
        compositeTotal = item.compositePrice ?? 0.0;
        compositeCount++;
      } else {
        total += item.price * item.qty;
      }
    }

    return compositeCount == internalTransactionItems.length
        ? compositeTotal
        : total + compositeTotal;
  }

  // === MICROSOFT FLUENT-INSPIRED UI ===
  Widget buildTransactionItemsTable(bool isOrdering) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (internalTransactionItems.isEmpty)
            _buildEmptyState()
          else
            _buildItemsList(isOrdering),
          _buildModernSummary(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No items yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first item to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(bool isOrdering) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: internalTransactionItems.length,
      separatorBuilder: (context, index) => Container(
        height: 1,
        color: Colors.grey[100],
        margin: const EdgeInsets.symmetric(horizontal: 20),
      ),
      itemBuilder: (context, index) {
        final item = internalTransactionItems[index];
        return _buildModernItemRow(item, isOrdering);
      },
    );
  }

  Widget _buildModernItemRow(TransactionItem item, bool isOrdering) {
    final isExpanded = _expandedItemId == item.id;
    final isSaving = _isItemSaving[item.id] ?? false;
    final hasError = _itemErrors.containsKey(item.id);
    final hasChanged = _hasItemChanged[item.id] ?? false;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: hasError
            ? Colors.red[50]
            : hasChanged
                ? Colors.blue[50]
                : Colors.transparent,
        border: isExpanded
            ? Border.all(color: const Color(0xFF0078D4), width: 2)
            : null,
      ),
      child: Column(
        children: [
          _buildItemHeader(item, isOrdering, isSaving, hasError),
          if (isExpanded) ...[
            const SizedBox(height: 16),
            _buildExpandedControls(item, isOrdering),
          ],
        ],
      ),
    );
  }

  Widget _buildItemHeader(
      TransactionItem item, bool isOrdering, bool isSaving, bool hasError) {
    return Row(
      children: [
        // Item info
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getItemName(item),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: hasError ? Colors.red[700] : Colors.grey[800],
                ),
              ),
              if (hasError) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.error_outline, size: 16, color: Colors.red[600]),
                    const SizedBox(width: 4),
                    Text(
                      _itemErrors[item.id] ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[600],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        // Quick controls
        Expanded(
          flex: 2,
          child: _buildQuickQuantityControls(item, isOrdering),
        ),

        // Price display
        Expanded(
          child: Text(
            formatNumber(item.price.toDouble()),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Total
        Expanded(
          child: Text(
            _getItemTotal(item),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0078D4),
            ),
            textAlign: TextAlign.right,
          ),
        ),

        // Actions
        const SizedBox(width: 12),
        Expanded(
          flex: 1,
          child: _buildItemActions(item, isOrdering, isSaving),
        ),
      ],
    );
  }

  // === DUOLINGO-INSPIRED QUICK CONTROLS ===
  Widget _buildQuickQuantityControls(TransactionItem item, bool isOrdering) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildModernQuantityButton(
          icon: Icons.remove,
          color: Colors.red[400]!,
          onTap: () => _decrementQuantity(item, isOrdering),
          enabled: item.qty > 0,
          id: '${item.id}-remove',
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              item.qty.toStringAsFixed(
                  item.qty.truncateToDouble() == item.qty ? 0 : 2),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(width: 12),
        _buildModernQuantityButton(
          icon: Icons.add,
          color: Colors.blue[400]!,
          onTap: () => _incrementQuantity(item, isOrdering),
          enabled: true,
          id: '${item.id}-add',
        ),
      ],
    );
  }

  Widget _buildModernQuantityButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool enabled,
    required String id,
  }) {
    return GestureDetector(
      key: Key('quantity-button-$id'),
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: enabled ? color : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildItemActions(
      TransactionItem item, bool isOrdering, bool isSaving) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Expand/Edit button
        Expanded(
          child: IconButton(
            onPressed: isSaving
                ? null
                : () {
                    setState(() {
                      _expandedItemId =
                          _expandedItemId == item.id ? null : item.id;
                    });
                  },
            icon: Icon(
              _expandedItemId == item.id
                  ? Icons.expand_less
                  : Icons.expand_more,
              color: isSaving ? Colors.grey[400] : const Color(0xFF0078D4),
            ),
            tooltip: 'Edit details',
          ),
        ),

        // Delete button
        Expanded(
          child: IconButton(
            onPressed: isSaving
                ? null
                : () => _showDeleteConfirmation(item, isOrdering),
            icon: Icon(
              Icons.delete_outline,
              color: isSaving ? Colors.grey[400] : Colors.red[400],
            ),
            tooltip: 'Delete item',
          ),
        ),

        // Saving indicator
        if (isSaving)
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(left: 8),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFF0078D4),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildExpandedControls(TransactionItem item, bool isOrdering) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Quantity field
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantity',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildPrecisionQuantityField(item, isOrdering),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // Price field
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Unit Price',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildModernPriceField(item, isOrdering),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrecisionQuantityField(TransactionItem item, bool isOrdering) {
    _initController(item);
    final controller = _quantityControllers[item.id]!;
    final focusNode = _quantityFocusNodes[item.id]!;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.shopping_cart_outlined, color: Colors.grey[600]),
        suffixText: 'qty',
        suffixStyle: TextStyle(color: Colors.grey[600]),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF0078D4), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (value) {
        setState(() {
          _hasItemChanged[item.id] = true;
          _itemErrors.remove(item.id);
        });
        _debounceTimers[item.id]?.cancel();
        _debounceTimers[item.id] = Timer(_debounceDuration, () {
          _updateQuantityFromTextField(item, value, isOrdering);
        });
      },
      onFieldSubmitted: (value) {
        _debounceTimers[item.id]?.cancel();
        _updateQuantityFromTextField(item, value, isOrdering);
      },
      validator: (value) {
        if (value == null || value.isEmpty) return 'Enter quantity';
        final parsed = double.tryParse(value);
        if (parsed == null || parsed < 0) return 'Invalid quantity';
        return null;
      },
    );
  }

  Widget _buildModernPriceField(TransactionItem item, bool isOrdering) {
    _initController(item);
    final controller = _priceControllers[item.id]!;
    final focusNode = _priceFocusNodes[item.id]!;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        prefixText: ProxyService.box.defaultCurrency(),
        prefixStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF0078D4), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (value) {
        setState(() {
          _hasItemChanged[item.id] = true;
          _itemErrors.remove(item.id);
        });
        _debounceTimers[item.id]?.cancel();
        _debounceTimers[item.id] = Timer(_debounceDuration, () {
          _updatePriceFromTextField(item, value, isOrdering);
        });
      },
      onFieldSubmitted: (value) {
        _debounceTimers[item.id]?.cancel();
        _updatePriceFromTextField(item, value, isOrdering);
      },
      validator: (value) {
        if (value == null || value.isEmpty) return 'Enter price';
        final parsed = double.tryParse(value);
        if (parsed == null || parsed < 0) return 'Invalid price';
        return null;
      },
    );
  }

  Widget _buildModernSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Grand Total',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Text(
            grandTotal.toCurrencyFormatted(
                symbol: ProxyService.box.defaultCurrency()),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0078D4),
            ),
          ),
        ],
      ),
    );
  }

  // === ENHANCED INTERACTION METHODS ===
  void _showDeleteConfirmation(TransactionItem item, bool isOrdering) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange[600]),
            const SizedBox(width: 8),
            const Text('Confirm Delete'),
          ],
        ),
        content:
            Text('Are you sure you want to remove "${_getItemName(item)}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteItem(item, isOrdering);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // === PRESERVED CORE LOGIC ===
  String _getItemName(TransactionItem item) {
    return item.name.extractNameAndNumber();
  }

  String _getItemTotal(TransactionItem item) {
    final price = item.price * item.qty;
    return formatNumber(price.toDouble());
  }

  Future<void> _updateTransactionItemInDb(TransactionItem item,
      {double? qty,
      double? price,
      bool isIncrement = false,
      bool isOrdering = false}) async {
    if (item.partOfComposite!) return;

    setState(() {
      _isItemSaving[item.id] = true;
      _itemErrors.remove(item.id);
    });

    try {
      await ProxyService.strategy.updateTransactionItem(
        transactionItemId: item.id,
        // Only pass the specific parameter that is intended to be changed.
        // If qty is null, it means we are updating price. If price is null, we are updating qty.
        // If isIncrement is true, we pass null for qty and let the backend handle the increment.
        qty: isIncrement ? null : qty,
        price: price,
        incrementQty: isIncrement,
        ignoreForReport: false,
        quantityRequested:
            isIncrement ? null : qty?.toInt(), // Only if setting exact quantity
      );
      // After successful update, refresh the provider to update the UI
      _refreshTransactionItems(isOrdering, transactionId: item.transactionId!);
      setState(() {
        _hasItemChanged[item.id] = false;
      });
    } catch (e) {
      setState(() {
        _itemErrors[item.id] = 'Failed to update item';
        // Revert controller text to original if update fails
        _quantityControllers[item.id]?.text = item.qty.toString();
        _priceControllers[item.id]?.text = item.price.toStringAsFixed(2);
      });
      talker.error('Failed to update transaction item: $e');
    } finally {
      setState(() {
        _isItemSaving[item.id] = false;
      });
    }
  }

  Future<void> _incrementQuantity(TransactionItem item, bool isOrdering) async {
    if (item.partOfComposite!) return;
    // Update controller immediately for visual feedback
    // We don't need to read current quantity from controller here, as we are telling backend to increment
    // For visual feedback, you could temporarily update the controller here or just wait for refresh.
    // For accuracy, waiting for refresh is better. If we want immediate visual feedback *before* DB,
    // we would need to manually increment item.qty and then revert on error.
    // For now, let's keep it simple and just trigger the DB update.
    await _updateTransactionItemInDb(item,
        isIncrement: true, isOrdering: isOrdering);
  }

  Future<void> _decrementQuantity(TransactionItem item, bool isOrdering) async {
    if (item.partOfComposite!) return;
    if (item.qty > 0) {
      // Ensure quantity doesn't go below 0
      // We can't use incrementQty: true for decrement.
      // So, for decrement, we must calculate the new quantity locally.
      final currentQty = double.tryParse(
              _quantityControllers[item.id]?.text ?? item.qty.toString()) ??
          item.qty;
      final newQty = currentQty - 1;
      // Update controller immediately for visual feedback
      _quantityControllers[item.id]?.text = newQty.toString();
      setState(() {
        _hasItemChanged[item.id] = true;
      });
      await _updateTransactionItemInDb(item,
          qty: newQty.toDouble(),
          price: item.price.toDouble(),
          isOrdering: isOrdering);
    }
  }

  Future<void> _updateQuantityFromTextField(
      TransactionItem item, String value, bool isOrdering) async {
    if (item.partOfComposite!) return;

    final trimmedValue = value.trim();
    final doubleValue = double.tryParse(trimmedValue);

    if (doubleValue != null && doubleValue >= 0) {
      // Pass only 'qty' to updateTransactionItemInDb
      await _updateTransactionItemInDb(item,
          qty: doubleValue, isOrdering: isOrdering);
    } else {
      setState(() {
        _itemErrors[item.id] = 'Invalid quantity';
        _quantityControllers[item.id]?.text = item.qty.toString();
        _hasItemChanged[item.id] = false;
      });
    }
  }

  Future<void> _updatePriceFromTextField(
      TransactionItem item, String value, bool isOrdering) async {
    if (item.partOfComposite!) return;

    final trimmedValue = value.trim();
    final doubleValue = double.tryParse(trimmedValue);

    if (doubleValue != null && doubleValue >= 0) {
      // Pass only 'price' to updateTransactionItemInDb
      await _updateTransactionItemInDb(item,
          price: doubleValue, isOrdering: isOrdering);
    } else {
      setState(() {
        _itemErrors[item.id] = 'Invalid price';
        _priceControllers[item.id]?.text = item.price.toStringAsFixed(2);
        _hasItemChanged[item.id] = false;
      });
    }
  }

  Future<void> _deleteItem(TransactionItem item, bool isOrdering) async {
    setState(() {
      _isItemSaving[item.id] = true;
    });
    try {
      if (!item.partOfComposite!) {
        await ProxyService.strategy
            .flipperDelete(id: item.id, endPoint: 'transactionItem');
      } else {
        Variant? variant = (await ProxyService.strategy.variants(
          taxTyCds: ProxyService.box.vatEnabled() ? ['A', 'B', 'C'] : ['D'],
          variantId: item.variantId!,
          branchId: ProxyService.box.getBranchId()!,
        ))
            .firstOrNull;

        if (variant != null) {
          final composites = await ProxyService.strategy
              .composites(productId: variant.productId!);

          for (final composite in composites) {
            final deletableItem = await ProxyService.strategy
                .getTransactionItem(variantId: composite.variantId!);
            if (deletableItem != null) {
              await ProxyService.strategy.flipperDelete(
                  id: deletableItem.id, endPoint: 'transactionItem');
            }
          }
        }
      }
      _refreshTransactionItems(isOrdering, transactionId: item.transactionId!);
    } catch (e) {
      talker.error('Error deleting item: $e');
      setState(() {
        _itemErrors[item.id] = 'Failed to delete item';
      });
    } finally {
      setState(() {
        _isItemSaving[item.id] = false;
      });
    }
  }

  void _refreshTransactionItems(bool isOrdering,
      {required String transactionId}) {
    ref.refresh(transactionItemsProvider(transactionId: transactionId));
  }
}
