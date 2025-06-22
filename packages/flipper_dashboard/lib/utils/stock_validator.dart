import 'package:flutter/material.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/cache/cache_manager.dart';

/// Validates if the requested quantities are available in stock
/// Returns a list of out-of-stock items, or an empty list if all items are in stock
Future<List<TransactionItem>> validateStockQuantity(
  List<TransactionItem> items,
) async {
  final outOfStockItems = <TransactionItem>[];

  for (final item in items) {
    final stock = await CacheManager().getStockByVariantId(item.variantId!);
    if (stock != null && stock.currentStock! < item.qty) {
      outOfStockItems.add(item);
    }
  }

  return outOfStockItems;
}

/// Shows a dialog when items are out of stock
/// Displays a dialog listing all out-of-stock items
/// Displays a dialog indicating that one or more items are out of stock.
Future<void> showOutOfStockDialog(
  BuildContext context,
  List<TransactionItem> outOfStockItems,
) {
  final isSingleItem = outOfStockItems.length == 1;
  final singleItem = outOfStockItems.first;

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8), // Microsoft uses subtle rounded corners
        ),
        // Microsoft-style spacing and padding
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),

        title: Row(
          children: [
            // Microsoft often uses icons for context
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange[600],
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isSingleItem ? 'Item unavailable' : 'Items unavailable',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            if (isSingleItem) ...[
              // Microsoft style: Clear, direct messaging
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: 15,
                        height: 1.4,
                      ),
                  children: [
                    const TextSpan(
                      text: 'We don\'t have enough ',
                    ),
                    TextSpan(
                      text: singleItem.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(
                      text: ' in stock to complete your order.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Microsoft loves data tables/structured info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Available quantity:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${singleItem.qty.toInt()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const Text(
                'We don\'t have enough of these items in stock:',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),

              // Microsoft-style list with better structure
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: Column(
                    children: outOfStockItems.map((item) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              'Requested: ${item.qty.toInt()}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Microsoft often provides helpful next steps
            Text(
              isSingleItem
                  ? 'You can reduce the quantity or remove this item to continue.'
                  : 'You can adjust quantities or remove these items to continue.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.3,
              ),
            ),
          ],
        ),

        actions: [
          // Microsoft typically uses primary/secondary button patterns
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              'Got it',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      );
    },
  );
}
