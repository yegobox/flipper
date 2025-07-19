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

  Future<void> processDebouncedValue(String value, CoreViewModel model,
      TextEditingController controller) async {
    ref.read(searchStringProvider.notifier).emitString(value: value);
    focusNode.requestFocus();

    await handleScanningMode(value, model, controller);
  }

  Future<void> handleScanningMode(String value, CoreViewModel model,
      TextEditingController controller) async {
    final isScanningModeEnabled = ref.read(toggleProvider.notifier).state;

    if (isScanningModeEnabled) {
      // Only clear controller and set hasText if in scanning mode
      controller.clear();
      hasText = false;
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

        try {
          final isVatEnabled = ProxyService.box.vatEnabled();
          // First try to find locally
          List<Variant> variants = await ProxyService.strategy
              .variants(
                  name: value,
                  branchId: ProxyService.box.getBranchId()!,
                  scanMode: true,
                  taxTyCds: isVatEnabled ? ['A', 'B', 'C'] : ['D'])
              .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              // Return empty list on timeout
              return [];
            },
          );

          // If no variants found locally, try to fetch from remote
          if (variants.isEmpty) {
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
                      Text('Searching from remote...'),
                    ],
                  ),
                  duration: Duration(milliseconds: 1000),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }

            // Try to fetch from remote with fetchRemote flag set to true
            variants = await ProxyService.strategy
                .variants(
                    name: value,
                    branchId: ProxyService.box.getBranchId()!,
                    scanMode: true,
                    taxTyCds: isVatEnabled ? ['A', 'B', 'C'] : ['D'],
                    fetchRemote: true)
                .timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                // Return empty list on timeout
                return [];
              },
            );
          }

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
        } catch (e) {
          // Handle errors during search
          if (mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error searching for variants: ${e.toString()}'),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }
    } else {
      // Not in scanning mode, but we should still search remotely if local search returns no results
      if (value.isNotEmpty) {
        try {
          final isVatEnabled = ProxyService.box.vatEnabled();
          // First try to find locally
          List<Variant> variants = await ProxyService.strategy
              .variants(
                  name: value,
                  branchId: ProxyService.box.getBranchId()!,
                  scanMode: false,
                  taxTyCds: isVatEnabled ? ['A', 'B', 'C'] : ['D'])
              .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              // Return empty list on timeout
              return [];
            },
          );

          // If no variants found locally, try to fetch from remote
          if (variants.isEmpty) {
            // Try to fetch from remote with fetchRemote flag set to true
            variants = await ProxyService.strategy
                .variants(
                    name: value,
                    branchId: ProxyService.box.getBranchId()!,
                    scanMode: false,
                    taxTyCds: isVatEnabled ? ['A', 'B', 'C'] : ['D'],
                    fetchRemote: true)
                .timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                // Return empty list on timeout
                return [];
              },
            );

            // Update the UI with the results from remote
            if (variants.isNotEmpty && mounted) {
              // Refresh the search results by updating the search string provider
              ref.read(searchStringProvider.notifier).emitString(value: value);
            }
          }
        } catch (e) {
          // Silently handle errors in non-scanning mode
          print(
              'Error searching for variants in non-scanning mode: ${e.toString()}');
        }
      }
    }
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
    try {
      // Get the current pending transaction
      final pendingTransaction =
          ref.read(pendingTransactionStreamProvider(isExpense: false));

      if (pendingTransaction.hasValue && pendingTransaction.value != null) {
        final transactionId = pendingTransaction.value!.id;

        // Show a loading indicator to provide feedback to the user
        if (mounted) {
          // showCustomSnackBar(context, );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              margin: const EdgeInsets.only(
                left: 350.0,
                right: 350.0,
                bottom: 20.0,
              ),
              content: Text('Adding item to cart..'),
              backgroundColor: Colors.black,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }

        // STEP 1: Save the transaction item directly using the strategy
        final success = await ProxyService.strategy.saveTransactionItem(
          variation: variant,
          ignoreForReport: false,
          amountTotal: variant.retailPrice!,
          customItem: false,
          doneWithTransaction: false,
          pendingTransaction: pendingTransaction.value!,
          currentStock: variant.stock!.currentStock!,
          partOfComposite: false,
        );

        if (!success) {
          throw Exception("Failed to save transaction item");
        }

        // STEP 2: Clear the search field
        ref.read(searchStringProvider.notifier).emitString(value: "");

        // Then refresh them to ensure the UI updates
        await Future.delayed(const Duration(milliseconds: 500));

        ref.refresh(
            transactionItemsStreamProvider(transactionId: transactionId));

        // STEP 4: Use a global notification to force UI updates
        // ProxyService.strategy.notify(
        //   notification: AppNotification(
        //     identifier: ProxyService.box.getBranchId(),
        //     type: "transaction_update",
        //     completed: true,
        //     message: "Transaction item added: ${variant.name}",
        //   ),
        // );

        // STEP 5: Show a success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              margin: const EdgeInsets.only(
                left: 350.0,
                right: 350.0,
                bottom: 20.0,
              ),
              content: Text('Added ${variant.name} to cart'),
              backgroundColor: Colors.black,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      } else {
        // Handle case where there's no pending transaction
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No active transaction found. Please try again.'),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      // Handle any errors that might occur during the process
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding item: ${e.toString()}'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
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
