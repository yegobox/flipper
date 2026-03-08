// ignore_for_file: unused_result

import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flutter/material.dart';

import 'package:flipper_dashboard/transaction_item_adder.dart';

mixin HandleScannWhileSelling<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  late bool hasText;
  late FocusNode focusNode;

  Future<void> processDebouncedValue(
    String value,
    CoreViewModel model,
    TextEditingController controller,
  ) async {
    final enableAutoAdd = ref.read(autoAddSearchProvider);

    if (value.isNotEmpty && enableAutoAdd) {
      // Use auto-add search when enabled
      await searchAndAutoAdd(value, model, controller);
    } else {
      // Use normal search behavior
      ref.read(searchStringProvider.notifier).emitString(value: value);
    }
  }

  Future<void> handleScanningMode(
    String value,
    CoreViewModel model,
    TextEditingController controller,
  ) async {
    // Only clear controller and set hasText if in scanning mode
    controller.clear();
    hasText = false;
    if (value.isNotEmpty) {
      // Trigger search in outerVariantsProvider
      ref.read(searchStringProvider.notifier).emitString(value: value);

      // Wait for search results
      await Future.delayed(const Duration(milliseconds: 200));

      // Get results from outerVariantsProvider
      final branchId = ProxyService.box.getBranchId()!;
      final variantsAsync = ref.read(outerVariantsProvider(branchId));

      variantsAsync.when(
        data: (variants) async {
          if (variants.isNotEmpty) {
            if (variants.length == 1) {
              // If only one variant is found, proceed directly
              await _processTransaction(variants.first, model);
            } else {
              // If multiple variants are found, prompt the user to select one
              Variant? selectedVariant = await _showVariantSelectionDialog(
                variants,
              );
              if (selectedVariant != null) {
                await _processTransaction(selectedVariant, model);
              }
            }
          } else {
            // Show a message when no variants are found
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('No variants found for "$value"'),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
        },
        loading: () {
          // Show loading indicator
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
        },
        error: (error, _) {
          // Handle errors
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error searching for variants: ${error.toString()}',
                ),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      );
    }
  }

  Future<void> searchAndAutoAdd(
    String value,
    CoreViewModel model,
    TextEditingController controller,
  ) async {
    // Trigger search in outerVariantsProvider
    ref.read(searchStringProvider.notifier).emitString(value: value);

    // Wait for search results
    await Future.delayed(const Duration(milliseconds: 100));

    // Get results from outerVariantsProvider
    final branchId = ProxyService.box.getBranchId()!;
    final variantsAsync = ref.read(outerVariantsProvider(branchId));

    variantsAsync.when(
      data: (variants) async {
        if (variants.length == 1) {
          // Exactly one match - auto-add to cart
          controller.clear();
          hasText = false;
          // Clear search to avoid showing search results
          ref.read(searchStringProvider.notifier).emitString(value: "");
          await _processTransaction(variants.first, model);
        }
        // If multiple or no matches, search results are already showing via outerVariantsProvider
      },
      loading: () {}, // Search is in progress
      error: (e, _) {}, // Error handled by UI
    );
  }

  Future<void> refreshTransactionItems({required String transactionId}) async {
    try {
      /// clear the current cart
      ref.refresh(transactionItemsProvider(transactionId: transactionId));

      // Add a small delay to ensure the refresh completes
      await Future.delayed(const Duration(milliseconds: 300));

      // Refresh again to ensure the UI is updated
      ref.refresh(transactionItemsStreamProvider(transactionId: transactionId));
    } catch (e) {
      debugPrint("Error refreshing transaction items: $e");
    }
  }

  Future<void> _processTransaction(Variant variant, CoreViewModel model) async {
    final itemAdder = TransactionItemAdder(context, ref);
    await itemAdder.addItemToTransaction(variant: variant, isOrdering: false);
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
                      .where(
                        (variant) =>
                            variant.name.toLowerCase().contains(
                              lowercaseQuery,
                            ) ||
                            (variant.bcd?.toLowerCase().contains(
                                  lowercaseQuery,
                                ) ??
                                false),
                      )
                      .toList();
                });
              }

              return Dialog(
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
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
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
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
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge,
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
                                                  'Retail Price: ${variant.retailPrice?.toCurrencyFormatted()}',
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
}
