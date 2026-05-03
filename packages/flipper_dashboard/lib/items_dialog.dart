import 'dart:async';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/models/stock.model.dart';
import 'package:flipper_models/helperModels/talker.dart';

final stockProvider = FutureProvider.family<Stock, String>((
  ref,
  stockId,
) async {
  return await ProxyService.getStrategy(
    Strategy.capella,
  ).getStockById(id: stockId);
});

class ItemsDialog extends StatefulHookConsumerWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const ItemsDialog({Key? key, required this.request, required this.completer})
    : super(key: key);

  @override
  _ItemsDialogState createState() => _ItemsDialogState();
}

class _ItemsDialogState extends ConsumerState<ItemsDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _copiedVariantId;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Export items to Excel file
  Future<void> _exportItemsToExcel(List<dynamic> variants) async {
    if (variants.isEmpty) {
      toast('No items to export');
      return;
    }

    setState(() {
      _isExporting = true;
    });

    try {
      // Pick file save location
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Excel file',
        fileName: 'items_export_${DateTime.now().millisecondsSinceEpoch}.xlsx',
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result == null) {
        // User cancelled
        setState(() {
          _isExporting = false;
        });
        return;
      }

      // Create Excel file (default sheet is Sheet1; rename to sheet1 for a single data sheet)
      final excel = Excel.createExcel();
      excel.rename('Sheet1', 'sheet1');
      final sheet = excel['sheet1'];

      // Add headers
      sheet.appendRow([
        TextCellValue('Product Name'),
        TextCellValue('Variant Name'),
        TextCellValue('Item Code'),
        TextCellValue('SKU'),
        TextCellValue('Quantity'),
        TextCellValue('Retail Price'),
        TextCellValue('Supply Price'),
        TextCellValue('Category'),
        TextCellValue('Unit'),
      ]);

      // Add data rows
      for (final variant in variants) {
        Stock? stockAsync;
        try {
          stockAsync = await ref.read(
            stockProvider(variant.stock?.id ?? '').future,
          );
        } catch (e) {
          talker.warning('Error fetching stock for variant: $e');
        }

        final qty = stockAsync?.currentStock ?? 0;

        sheet.appendRow([
          TextCellValue(variant.productName ?? ''),
          TextCellValue(variant.name ?? ''),
          TextCellValue(variant.itemCd ?? ''),
          TextCellValue(variant.sku ?? ''),
          IntCellValue(qty.toInt()),
          DoubleCellValue(variant.retailPrice ?? 0.0),
          DoubleCellValue(variant.supplyPrice ?? 0.0),
          TextCellValue(variant.categoryName ?? ''),
          TextCellValue(variant.unit ?? ''),
        ]);
      }

      // Save file
      final file = File(result);
      await file.writeAsBytes(excel.encode()!);

      setState(() {
        _isExporting = false;
      });

      toast('Successfully exported ${variants.length} items');
    } catch (e) {
      talker.error('Error exporting items: $e');
      setState(() {
        _isExporting = false;
      });
      toast('Failed to export items: $e');
    }
  }

  String _getItemTypeName(String? itemTyCd) {
    switch (itemTyCd) {
      case '1':
        return 'Raw Material';
      case '2':
        return 'Finished Product';
      case '3':
        return 'Service';
      default:
        return 'Unknown';
    }
  }

  List<String> _extractReceiptNumbers(String query) {
    final regex = RegExp(r'\d+(?=,)');
    return regex.allMatches(query).map((match) => match.group(0)!).toList();
  }

  bool _hasReceiptNumbers(String query) {
    return RegExp(r'\d+,').hasMatch(query);
  }

  @override
  Widget build(BuildContext context) {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      return const Dialog(child: Center(child: Text("No branch selected")));
    }
    final variantsAsyncValue = ref.watch(outerVariantsProvider(branchId));

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        height: 800,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Items', style: Theme.of(context).textTheme.headlineSmall),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: _isExporting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.file_download_outlined),
                      onPressed: _isExporting
                          ? null
                          : () async {
                              final notifier = ref.read(
                                outerVariantsProvider(branchId).notifier,
                              );
                              final variants =
                                  await notifier.futureFetchAllVariants();
                              await _exportItemsToExcel(variants);
                            },
                      tooltip: 'Export to Excel',
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () =>
                          widget.completer(DialogResponse(confirmed: false)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _hasReceiptNumbers(_searchQuery)
                  ? FutureBuilder(
                      future: ProxyService.strategy.transactions(
                        receiptNumber: _extractReceiptNumbers(_searchQuery),
                        fetchRemote: true,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }
                        final transactions = snapshot.data ?? [];
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          toast(
                            'Found ${transactions.length} transactions synced',
                          );
                        });
                        return const Center(
                          child: Text('Transactions synced successfully'),
                        );
                      },
                    )
                  : variantsAsyncValue.when(
                      data: (variants) {
                        final filteredVariants = variants
                            .where(
                              (v) => v.name.toLowerCase().contains(
                                _searchQuery.toLowerCase(),
                              ),
                            )
                            .toList();

                        if (filteredVariants.isEmpty) {
                          return const Center(child: Text('No items found.'));
                        }

                        return ListView.builder(
                          itemCount: filteredVariants.length,
                          itemBuilder: (context, index) {
                            final variant = filteredVariants[index];
                            final isCopied = _copiedVariantId == variant.id;
                            return Card(
                              color: isCopied
                                  ? Colors.green.withValues(alpha: 0.3)
                                  : null,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: Theme.of(context).dividerColor,
                                ),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                title: Text(
                                  variant.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '${_getItemTypeName(variant.itemTyCd)} - ${variant.itemCd ?? 'N/A'}',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (variant.stock != null)
                                      ref
                                          .watch(
                                            stockProvider(variant.stock!.id),
                                          )
                                          .when(
                                            data: (stock) => Text(
                                              'Stock: ${stock.currentStock ?? 0}',
                                            ),
                                            loading: () =>
                                                const Text('Stock: loading...'),
                                            error: (err, stack) =>
                                                const Text('Stock: error'),
                                          )
                                    else
                                      const Text('Stock: 0'),
                                    IconButton(
                                      icon: const Icon(Icons.copy),
                                      onPressed: () {
                                        if (variant.itemCd != null) {
                                          Clipboard.setData(
                                            ClipboardData(
                                              text: variant.itemCd!,
                                            ),
                                          );
                                          setState(() {
                                            _copiedVariantId = variant.id;
                                          });
                                          Timer(const Duration(seconds: 2), () {
                                            if (mounted) {
                                              setState(() {
                                                _copiedVariantId = null;
                                              });
                                            }
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stack) =>
                          Center(child: Text('Error loading items: $error')),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
