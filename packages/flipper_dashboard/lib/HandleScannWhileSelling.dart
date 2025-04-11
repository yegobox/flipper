// ignore_for_file: unused_result

import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flutter/material.dart';

mixin HandleScannWhileSelling<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  late bool hasText;
  late FocusNode focusNode;
  void processDebouncedValue(
      String value, CoreViewModel model, TextEditingController controller) {
    ref.read(searchStringProvider.notifier).emitString(value: value);
    focusNode.requestFocus();

    handleScanningMode(value, model, controller);
  }

  void handleScanningMode(String value, CoreViewModel model,
      TextEditingController controller) async {
    controller.clear();
    hasText = false;
    final isScanningModeEnabled = ref.read(toggleProvider.notifier).state;

    if (isScanningModeEnabled) {
      if (value.isNotEmpty) {
        // Show loading indicator immediately to give feedback to the user
        // This helps with perceived performance, especially on Windows
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 10),
                  Text('Searching...'),
                ],
              ),
              duration: Duration(milliseconds: 500),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        List<Variant> variants = await ProxyService.strategy
            .variants(bcd: value, branchId: ProxyService.box.getBranchId()!);

        // Dismiss the loading indicator if it's still showing
        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }

        if (variants.isNotEmpty) {
          if (variants.length == 1) {
            // If only one variant is found, proceed directly
            Variant variant = variants.first;
            await _processTransaction(variant, model);
          } else {
            // If multiple variants are found, prompt the user to select one
            Variant? selectedVariant =
                await _showVariantSelectionDialog(variants);
            if (selectedVariant != null) {
              await _processTransaction(selectedVariant, model);
            }
          }
        }
      }
    }
  }

  Future<Variant?> _showVariantSelectionDialog(List<Variant> variants) async {
    // Early return if list is empty
    if (variants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No variants available'),
          duration: Duration(seconds: 2),
        ),
      );
      return null;
    }

    final TextEditingController searchController = TextEditingController();
    List<Variant> filteredVariants = List.from(variants);

    try {
      return await showDialog<Variant>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              void filterVariants(String query) {
                // Optimize filtering by avoiding unnecessary work when query is empty
                if (query.isEmpty) {
                  setState(() {
                    filteredVariants = List.from(variants);
                  });
                  return;
                }

                // Pre-compute lowercase query for better performance
                final lowercaseQuery = query.toLowerCase();

                setState(() {
                  filteredVariants = variants
                      .where((variant) =>
                          variant.name.toLowerCase().contains(lowercaseQuery) ||
                          (variant.bcd
                                  ?.toLowerCase()
                                  .contains(lowercaseQuery) ??
                              false))
                      .toList();
                });
              }

              return Dialog(
                insetPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select Product Variant',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.of(context).pop(),
                              tooltip: 'Close',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Search Box
                        TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search by name or barcode',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      searchController.clear();
                                      filterVariants('');
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: filterVariants,
                        ),
                        const SizedBox(height: 16),

                        // Variants List
                        Flexible(
                          child: filteredVariants.isEmpty
                              ? Center(
                                  child: Text(
                                    'No matching variants found',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: filteredVariants.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 8),
                                  itemBuilder: (context, index) {
                                    final variant = filteredVariants[index];
                                    return Card(
                                      margin: EdgeInsets.zero,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: InkWell(
                                        onTap: () =>
                                            Navigator.of(context).pop(variant),
                                        borderRadius: BorderRadius.circular(12),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                variant.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              if (variant.retailPrice !=
                                                  null) ...[
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Retail Price: ${variant.retailPrice?.toRwf()}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color:
                                                            Colors.green[700],
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                              ],
                                              if (variant.bcd != null) ...[
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Barcode: ${variant.bcd}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall
                                                            ?.color,
                                                      ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      debugPrint('Error showing variant selection dialog: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error showing variants: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
      return null;
    }
  }

  Future<void> _processTransaction(Variant variant, CoreViewModel model) async {
    final pendingTransaction =
        ref.watch(pendingTransactionStreamProvider(isExpense: false));

    await ProxyService.strategy.saveTransactionItem(
      variation: variant,
      amountTotal: variant.retailPrice!,
      customItem: false,
      doneWithTransaction: true,
      pendingTransaction: pendingTransaction.value!,
      currentStock: variant.stock!.currentStock!,
      partOfComposite: false,
    );

    ref.refresh(
        transactionItemsProvider(transactionId: pendingTransaction.value!.id));
    ref.read(searchStringProvider.notifier).emitString(value: "d");
  }
}
