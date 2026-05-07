// ignore_for_file: unused_result

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_services/utils.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
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
  final Map<String, double> _optimisticQtyByItemId = {};
  final SettingsService _settingsService = locator<SettingsService>();

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
    final displayQty = _displayQtyFor(item);

    // Quantity Controller
    _quantityControllers.putIfAbsent(
      id,
      () => TextEditingController(text: displayQty.toString()),
    );
    _quantityFocusNodes.putIfAbsent(id, () => FocusNode());

    // Price Controller
    _priceControllers.putIfAbsent(
      id,
      () => TextEditingController(text: price.toStringAsFixed(2)),
    );
    _priceFocusNodes.putIfAbsent(id, () => FocusNode());

    // Update controller text only if not focused to avoid input issues
    // and if the backend value is different (e.g., after a refresh)
    if (!_quantityFocusNodes[id]!.hasFocus &&
        _quantityControllers[id]!.text != displayQty.toString()) {
      _quantityControllers[id]!.text = displayQty.toString();
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
    final toRemove = _quantityControllers.keys
        .where((id) => !ids.contains(id))
        .toList();

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
      _optimisticQtyByItemId.remove(id);
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
    num total = 0;

    for (final item in internalTransactionItems) {
      final price = (item.compositePrice ?? 0) != 0
          ? item.compositePrice!
          : item.price;

      final displayQty = _displayQtyFor(item);
      if (_settingsService.isCurrencyDecimal) {
        total += (price * displayQty).toDouble().roundToTwoDecimalPlaces();
      } else {
        total += (price * displayQty).toDouble().roundToDouble();
      }
    }

    return total;
  }

  // === MICROSOFT FLUENT-INSPIRED UI ===
  ///
  /// When [pinGrandTotal] is true, the item list scrolls inside an [Expanded]
  /// area and [_buildModernSummary] stays fixed at the bottom (parent must
  /// give a bounded height, e.g. [Expanded] in [Column]).
  Widget buildTransactionItemsTable(
    bool isOrdering, {
    bool pinGrandTotal = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: pinGrandTotal ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (internalTransactionItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${internalTransactionItems.length} item${internalTransactionItems.length > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _showDeleteAllConfirmation(isOrdering),
                    icon: Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.red.shade600,
                    ),
                    label: Text(
                      'Delete All',
                      style: TextStyle(
                        color: Colors.red.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red.shade600,
                    ),
                  ),
                ],
              ),
            ),
          if (internalTransactionItems.isEmpty)
            pinGrandTotal
                ? Expanded(child: _buildPinnedEmptyStateScrollSlot())
                : _buildEmptyState()
          else if (pinGrandTotal)
            Expanded(child: _buildItemsList(isOrdering, scrollable: true))
          else
            _buildItemsList(isOrdering, scrollable: false),
          _buildModernSummary(),
        ],
      ),
    );
  }

  /// Empty cart when the list sits in a fixed [Expanded] (pinGrandTotal).
  /// [Center] alone does not clip: large padding + copy can overflow the slot.
  Widget _buildPinnedEmptyStateScrollSlot() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: _buildEmptyState(compact: true)),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState({bool compact = false}) {
    final outerPad = compact ? 16.0 : 60.0;
    final iconInnerPad = compact ? 12.0 : 20.0;
    final iconSize = compact ? 36.0 : 48.0;
    final titleSize = compact ? 16.0 : 18.0;
    final gapAfterIcon = compact ? 12.0 : 20.0;
    final gapBeforeSubtitle = compact ? 6.0 : 8.0;

    return Container(
      padding: EdgeInsets.all(outerPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(iconInnerPad),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: iconSize,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: gapAfterIcon),
          Text(
            'No items yet',
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: gapBeforeSubtitle),
          Text(
            'Add your first item to get started',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: compact ? 13 : 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(bool isOrdering, {required bool scrollable}) {
    return ListView.separated(
      shrinkWrap: !scrollable,
      physics: scrollable
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: hasError
            ? Colors.red[50]
            : hasChanged
            ? Colors.blue[50]
            : Colors.transparent,
        border: isExpanded
            ? Border.all(color: PosLayoutBreakpoints.posAccentBlue, width: 2)
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
    TransactionItem item,
    bool isOrdering,
    bool isSaving,
    bool hasError,
  ) {
    final plu = _lineItemInventoryLabel(item);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getItemName(item),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: hasError ? Colors.red[700] : const Color(0xFF111827),
                ),
              ),
              if (plu != null) ...[
                const SizedBox(height: 2),
                Text(
                  plu,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              if (hasError) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.error_outline, size: 16, color: Colors.red[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _itemErrors[item.id] ?? '',
                        style: TextStyle(fontSize: 12, color: Colors.red[600]),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 4),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                visualDensity: VisualDensity.compact,
                tooltip: 'Delete item',
                onPressed: isSaving
                    ? null
                    : () => _showDeleteConfirmation(item, isOrdering),
                icon: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: isSaving ? Colors.grey[300] : Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
        Expanded(flex: 2, child: _buildQuickQuantityControls(item, isOrdering)),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              formatNumber(item.price.toDouble()),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  _getItemTotal(item),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: PosLayoutBreakpoints.posAccentBlue,
                  ),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildItemActions(item, isOrdering, isSaving),
            ],
          ),
        ),
      ],
    );
  }

  // === DUOLINGO-INSPIRED QUICK CONTROLS ===
  Widget _buildQuickQuantityControls(TransactionItem item, bool isOrdering) {
    final pendingOpt =
        ref
            .watch(optimisticCartProvider)
            .pendingQtyByVariantId[item.variantId ?? ''] ??
        0;
    final qtyLocked = pendingOpt > 0 || OptimisticCartIds.isOptimistic(item.id);
    final displayQty = _displayQtyFor(item);
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCircularQtyButton(
            icon: Icons.remove,
            onTap: () => _decrementQuantity(item, isOrdering),
            enabled: displayQty > 0 && !qtyLocked,
            id: '${item.id}-remove',
          ),
          const SizedBox(width: 10),
          Text(
            _formatQty(displayQty),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(width: 10),
          _buildCircularQtyButton(
            icon: Icons.add,
            onTap: () => _incrementQuantity(item, isOrdering),
            enabled: !qtyLocked,
            id: '${item.id}-add',
          ),
        ],
      ),
    );
  }

  Widget _buildCircularQtyButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
    required String id,
  }) {
    final border = Border.all(
      color: enabled ? const Color(0xFFE5E7EB) : Colors.grey[300]!,
    );
    return Material(
      key: Key('quantity-button-$id'),
      color: Colors.white,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled ? onTap : null,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 34,
          height: 34,
          decoration: BoxDecoration(shape: BoxShape.circle, border: border),
          child: Icon(
            icon,
            size: 18,
            color: enabled ? const Color(0xFF374151) : Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _buildItemActions(
    TransactionItem item,
    bool isOrdering,
    bool isSaving,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          visualDensity: VisualDensity.compact,
          onPressed: isSaving
              ? null
              : () {
                  setState(() {
                    _expandedItemId = _expandedItemId == item.id
                        ? null
                        : item.id;
                  });
                },
          icon: Icon(
            _expandedItemId == item.id ? Icons.expand_less : Icons.expand_more,
            color: isSaving
                ? Colors.grey[400]
                : PosLayoutBreakpoints.posAccentBlue,
          ),
          tooltip: 'Edit details',
        ),
        if (isSaving)
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                PosLayoutBreakpoints.posAccentBlue,
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
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: PosLayoutBreakpoints.posAccentBlue,
            width: 2,
          ),
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

    final originalUnitPrice = item.retailPrice ?? item.price;
    final double? currentPrice = double.tryParse(controller.text);
    String? helperText;

    if (_settingsService.enablePriceQuantityAdjustment &&
        currentPrice != null &&
        originalUnitPrice > 0 &&
        currentPrice != item.price) {
      final calculatedQty = currentPrice / originalUnitPrice;
      helperText =
          'Equivalent to ${calculatedQty.toStringAsFixed(2)} units at ${originalUnitPrice.toStringAsFixed(0)} RWF';
    }

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
        helperText: helperText,
        helperStyle: const TextStyle(color: Colors.blue, fontSize: 12),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: PosLayoutBreakpoints.posAccentBlue,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (value) {
        setState(() {
          _hasItemChanged[item.id] = true;
          _itemErrors.remove(item.id);
        });

        // Real-time quantity feedback
        final newPrice = double.tryParse(value);
        if (_settingsService.enablePriceQuantityAdjustment &&
            newPrice != null &&
            originalUnitPrice > 0) {
          final newQty = newPrice / originalUnitPrice;
          _quantityControllers[item.id]?.text = newQty.toStringAsFixed(2);
        }

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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Grand Total',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
          ),
          Flexible(
            child: Text(
              grandTotal.toCurrencyFormatted(
                symbol: ProxyService.box.defaultCurrency(),
              ),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: PosLayoutBreakpoints.posAccentBlue,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // === ENHANCED INTERACTION METHODS ===
  void _showDeleteAllConfirmation(bool isOrdering) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange[600]),
            const SizedBox(width: 8),
            const Text('Delete All Items'),
          ],
        ),
        content: Text(
          'Are you sure you want to remove all ${internalTransactionItems.length} items from this transaction?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteAllItems(isOrdering);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAllItems(bool isOrdering) async {
    final itemsToDelete = List<TransactionItem>.from(internalTransactionItems);

    final txnId = itemsToDelete.isNotEmpty
        ? itemsToDelete.first.transactionId
        : null;
    if (txnId != null && txnId.isNotEmpty) {
      ref.read(optimisticCartProvider.notifier).clearForTransaction(txnId);
    }

    for (final item in itemsToDelete) {
      setState(() {
        _isItemSaving[item.id] = true;
      });
    }

    try {
      for (final item in itemsToDelete) {
        if (OptimisticCartIds.isOptimistic(item.id)) continue;
        if (!(item.partOfComposite ?? false)) {
          await ProxyService.getStrategy(
            Strategy.capella,
          ).flipperDelete(id: item.id, endPoint: 'transactionItem');
        }
      }

      if (itemsToDelete.isNotEmpty) {
        _refreshTransactionItems(
          isOrdering,
          transactionId: itemsToDelete.first.transactionId!,
        );
      }
    } catch (e, s) {
      talker.error('Error deleting items: $e', s);
    } finally {
      for (final item in itemsToDelete) {
        setState(() {
          _isItemSaving[item.id] = false;
        });
      }
    }
  }

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
        content: Text(
          'Are you sure you want to remove "${_getItemName(item)}"?',
        ),
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

  /// Grey subtitle under the line name (BCD preferred, else SKU).
  String? _lineItemInventoryLabel(TransactionItem item) {
    final bcd = item.bcd?.trim();
    if (bcd != null && bcd.isNotEmpty) return 'BCD: $bcd';
    final sku = item.sku?.trim();
    if (sku != null && sku.isNotEmpty) return 'SKU: $sku';
    return null;
  }

  String _getItemTotal(TransactionItem item) {
    final displayQty = _displayQtyFor(item);
    final double price;
    if (_settingsService.isCurrencyDecimal) {
      price = (item.price * displayQty).toDouble().roundToTwoDecimalPlaces();
    } else {
      price = (item.price * displayQty).toDouble().roundToDouble();
    }
    return formatNumber(price);
  }

  double _displayQtyFor(TransactionItem item) {
    final optimisticQty = _optimisticQtyByItemId[item.id];
    if (optimisticQty == null) return item.qty.toDouble();

    if ((item.qty.toDouble() - optimisticQty).abs() < 0.0001) {
      _optimisticQtyByItemId.remove(item.id);
      _hasItemChanged[item.id] = false;
      return item.qty.toDouble();
    }

    return optimisticQty;
  }

  String _formatQty(double qty) {
    return qty.toStringAsFixed(qty.truncateToDouble() == qty ? 0 : 2);
  }

  void _setOptimisticQty(TransactionItem item, double qty) {
    _optimisticQtyByItemId[item.id] = qty;
    _quantityControllers[item.id]?.text = qty.toString();
    _hasItemChanged[item.id] = true;
  }

  void _rollbackOptimisticQty(TransactionItem item, double delta) {
    final current = _optimisticQtyByItemId[item.id];
    if (current == null) return;
    final rolledBack = current - delta;
    if ((rolledBack - item.qty.toDouble()).abs() < 0.0001) {
      _optimisticQtyByItemId.remove(item.id);
      _quantityControllers[item.id]?.text = item.qty.toString();
      _hasItemChanged[item.id] = false;
    } else {
      _optimisticQtyByItemId[item.id] = rolledBack;
      _quantityControllers[item.id]?.text = rolledBack.toString();
    }
  }

  Future<void> _updateTransactionItemInDb(
    TransactionItem item, {
    double? qty,
    double? price,
    bool isIncrement = false,
    bool isOrdering = false,
    double? optimisticDelta,
  }) async {
    if (item.partOfComposite ?? false) return;
    if (OptimisticCartIds.isOptimistic(item.id)) return;
    final pendingOpt =
        ref.read(optimisticCartProvider).pendingQtyByVariantId[item.variantId ??
            ''] ??
        0;
    if (pendingOpt > 0) return;

    setState(() {
      _isItemSaving[item.id] = true;
      _itemErrors.remove(item.id);
    });

    try {
      await ProxyService.getStrategy(Strategy.capella).updateTransactionItem(
        transactionItemId: item.id,
        qty: isIncrement ? null : qty,
        price: price,
        incrementQty: isIncrement,
        ignoreForReport: false,
        quantityRequested: isIncrement ? null : qty?.toInt(),
      );
      // After successful update, refresh the provider to update the UI
      _refreshTransactionItems(isOrdering, transactionId: item.transactionId!);
      setState(() {
        _hasItemChanged[item.id] = _optimisticQtyByItemId.containsKey(item.id);
      });
    } catch (e) {
      setState(() {
        _itemErrors[item.id] = 'Failed to update item';
        if (optimisticDelta != null) {
          _rollbackOptimisticQty(item, optimisticDelta);
        }
        // Revert controller text to original if update fails
        _quantityControllers[item.id]?.text =
            _optimisticQtyByItemId[item.id]?.toString() ?? item.qty.toString();
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
    if (item.partOfComposite ?? false) return;
    final newQty = _displayQtyFor(item) + 1;
    setState(() => _setOptimisticQty(item, newQty));
    await _updateTransactionItemInDb(
      item,
      isIncrement: true,
      isOrdering: isOrdering,
      optimisticDelta: 1,
    );
  }

  Future<void> _decrementQuantity(TransactionItem item, bool isOrdering) async {
    if (item.partOfComposite ?? false) return;
    if (item.qty > 0) {
      // Ensure quantity doesn't go below 0
      // We can't use incrementQty: true for decrement.
      // So, for decrement, we must calculate the new quantity locally.
      final currentQty = _displayQtyFor(item);
      final newQty = currentQty - 1;
      setState(() => _setOptimisticQty(item, newQty));
      await _updateTransactionItemInDb(
        item,
        qty: newQty.toDouble(),
        price: item.price.toDouble(),
        isOrdering: isOrdering,
        optimisticDelta: newQty - currentQty,
      );
    }
  }

  Future<void> _updateQuantityFromTextField(
    TransactionItem item,
    String value,
    bool isOrdering,
  ) async {
    if (item.partOfComposite ?? false) return;

    final trimmedValue = value.trim();
    final doubleValue = double.tryParse(trimmedValue);

    if (doubleValue != null && doubleValue >= 0) {
      // Pass only 'qty' to updateTransactionItemInDb
      await _updateTransactionItemInDb(
        item,
        qty: doubleValue,
        isOrdering: isOrdering,
      );
    } else {
      setState(() {
        _itemErrors[item.id] = 'Invalid quantity';
        _quantityControllers[item.id]?.text = item.qty.toString();
        _hasItemChanged[item.id] = false;
      });
    }
  }

  Future<void> _updatePriceFromTextField(
    TransactionItem item,
    String value,
    bool isOrdering,
  ) async {
    if (item.partOfComposite ?? false) return;

    final trimmedValue = value.trim();
    final doubleValue = double.tryParse(trimmedValue);

    if (doubleValue != null && doubleValue >= 0) {
      final originalUnitPrice = item.retailPrice ?? item.price;

      if (_settingsService.enablePriceQuantityAdjustment &&
          originalUnitPrice > 0 &&
          doubleValue != item.price) {
        final newQty = doubleValue / originalUnitPrice;

        // If we are adjusting quantity based on price, we keep the unit price
        // as the original retail price and adjust the quantity.
        // This ensures correct stock deduction and mathematical consistency.
        try {
          await _updateTransactionItemInDb(
            item,
            qty: newQty,
            price: originalUnitPrice.toDouble(),
            isOrdering: isOrdering,
          );

          // Update controllers to reflect adjusted values only if the DB update succeeded
          setState(() {
            _quantityControllers[item.id]?.text = newQty.toStringAsFixed(2);
            _priceControllers[item.id]?.text = originalUnitPrice
                .toStringAsFixed(2);
          });
        } catch (e) {
          // Log the error and don't update the UI controllers to keep them in sync with the backend
          talker.error('Failed to update transaction item in DB: $e');
        }
      } else {
        try {
          // If Price-Quantity sync is OFF, or original unit price is unknown,
          // we update the price directly without changing the quantity.
          await _updateTransactionItemInDb(
            item,
            price: doubleValue,
            qty: item.qty.toDouble(), // explicitly keep same quantity
            isOrdering: isOrdering,
          );

          // Update the price controller to reflect the new value only if the DB update succeeded
          setState(() {
            _priceControllers[item.id]?.text = doubleValue.toStringAsFixed(2);
          });
        } catch (e) {
          // Log the error and don't update the UI controllers to keep them in sync with the backend
          talker.error('Failed to update transaction item in DB: $e');
        }
      }
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
      if (OptimisticCartIds.isOptimistic(item.id)) {
        final tid = item.transactionId;
        final vid = item.variantId;
        if (tid != null && vid != null) {
          ref
              .read(optimisticCartProvider.notifier)
              .clearPendingForVariant(transactionId: tid, variantId: vid);
        }
        return;
      }
      if (!(item.partOfComposite ?? false)) {
        await ProxyService.getStrategy(
          Strategy.capella,
        ).flipperDelete(id: item.id, endPoint: 'transactionItem');
      } else {
        final paged = await ProxyService.strategy.variants(
          taxTyCds: ProxyService.box.vatEnabled() ? ['A', 'B', 'C'] : ['D'],
          variantId: item.variantId!,
          branchId: ProxyService.box.getBranchId()!,
        );
        Variant? variant = (List<Variant>.from(paged.variants)).firstOrNull;

        if (variant != null) {
          final composites = await ProxyService.strategy.composites(
            productId: variant.productId!,
          );

          for (final composite in composites) {
            final deletableItem = await ProxyService.strategy
                .getTransactionItem(variantId: composite.variantId!);
            if (deletableItem != null) {
              await ProxyService.getStrategy(Strategy.capella).flipperDelete(
                id: deletableItem.id,
                endPoint: 'transactionItem',
              );
            }
          }
        }
      }
      _refreshTransactionItems(isOrdering, transactionId: item.transactionId!);
    } catch (e, s) {
      talker.error('Error deleting item: $e', s);
      setState(() {
        _itemErrors[item.id] = 'Failed to delete item';
      });
    } finally {
      setState(() {
        _isItemSaving[item.id] = false;
      });
    }
  }

  void _refreshTransactionItems(
    bool isOrdering, {
    required String transactionId,
  }) {
    // The stream-based transactionItemsStreamProvider auto-updates via
    // Ditto observer / brick subscription when the underlying data changes.
    // No manual refresh needed — avoids redundant DB queries and lock contention.
  }
}
