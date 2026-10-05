import 'dart:async';
import 'package:flipper_localize/flipper_localize.dart';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/sync/branch_catalog_cloud_sync.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_models/helperModels/talker.dart';

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

  /// Loads current stock docs from Ditto for export (fresh read, no Riverpod cache).
  /// Optionally waits briefly if mesh replication has not landed rows yet.
  Future<({Map<String, Stock> byId, bool incompleteSync})>
  _resolveStocksForExport(List<Variant> variants) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null || branchId.isEmpty) {
      return (byId: <String, Stock>{}, incompleteSync: false);
    }

    final ditto = DittoService.instance.dittoInstance;
    if (ditto != null) {
      await ensureBranchCatalogCloudSubscriptions(
        ditto: ditto,
        branchId: branchId,
        businessId: ProxyService.box.getBusinessId(),
      );
    }

    final stockIds = variants
        .map((v) => v.stockId)
        .where((id) => id != null && id.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();

    if (stockIds.isEmpty) {
      return (byId: <String, Stock>{}, incompleteSync: false);
    }

    final capella = ProxyService.getStrategy(Strategy.capella);

    Future<Map<String, Stock>> runBatch() =>
        capella.batchGetStocksByIds(stockIds);

    var stocksById = await runBatch();

    bool missingIds() => stockIds.any((id) => !stocksById.containsKey(id));

    var incompleteSync = false;

    if (missingIds()) {
      incompleteSync = true;
      const meshDelays = <Duration>[
        Duration(milliseconds: 2000),
        Duration(milliseconds: 3500),
        Duration(milliseconds: 5000),
      ];
      for (final delay in meshDelays) {
        await Future.delayed(delay);
        final next = await runBatch();
        for (final entry in next.entries) {
          stocksById[entry.key] = entry.value;
        }
        if (!missingIds()) {
          incompleteSync = false;
          break;
        }
      }
    }

    for (final sid in stockIds) {
      if (!stocksById.containsKey(sid)) {
        try {
          final loaded = await capella.getStockById(id: sid);
          if (loaded != null) {
            stocksById[sid] = loaded;
          } else {
            incompleteSync = true;
          }
        } catch (_) {
          incompleteSync = true;
        }
      }
    }

    if (stockIds.any((id) => !stocksById.containsKey(id))) {
      incompleteSync = true;
    }

    return (byId: stocksById, incompleteSync: incompleteSync);
  }

  /// Export items to Excel file
  Future<void> _exportItemsToExcel(List<Variant> variants) async {
    if (variants.isEmpty) {
      toast(context.flipperL10n.itemsExportNone);
      return;
    }

    setState(() {
      _isExporting = true;
    });

    try {
      // Pick file save location
      final result = await FilePicker.platform.saveFile(
        dialogTitle: context.flipperL10n.itemsExportSaveDialogTitle,
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

      final resolved = await _resolveStocksForExport(variants);
      final stocksById = resolved.byId;

      // Create Excel file (default sheet is Sheet1; rename to sheet1 for a single data sheet)
      final excel = Excel.createExcel();
      excel.rename('Sheet1', 'sheet1');
      final sheet = excel['sheet1'];

      // Add headers
      final l10n = FlipperL10n.current;
      sheet.appendRow([
        TextCellValue(l10n.itemsExportProductName),
        TextCellValue(l10n.itemsExportVariantName),
        TextCellValue(l10n.itemsExportItemCode),
        TextCellValue('SKU'),
        TextCellValue(l10n.quantity),
        TextCellValue(l10n.itemsExportRetailPrice),
        TextCellValue(l10n.supplyPrice),
        TextCellValue(l10n.category),
        TextCellValue(l10n.itemsExportUnit),
      ]);

      // Add data rows — quantities from one Ditto batch read (not the live per-row stock stream).
      for (final variant in variants) {
        final sid = variant.stockId;
        final qty = (sid != null && sid.isNotEmpty)
            ? (stocksById[sid]?.currentStock ?? 0)
            : 0;

        sheet.appendRow([
          TextCellValue(variant.productName ?? ''),
          TextCellValue(variant.name),
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

      toast(FlipperL10n.current.itemsExportSuccess(variants.length));
      if (resolved.incompleteSync && mounted) {
        toast(FlipperL10n.current.itemsExportIncompleteSync);
      }
    } catch (e) {
      talker.error('Error exporting items: $e');
      setState(() {
        _isExporting = false;
      });
      toast(FlipperL10n.current.itemsExportFailed(e.toString()));
    }
  }

  String _getItemTypeName(String? itemTyCd) {
    switch (itemTyCd) {
      case '1':
        return context.flipperL10n.itemsTypeRawMaterial;
      case '2':
        return context.flipperL10n.itemsTypeFinishedProduct;
      case '3':
        return context.flipperL10n.itemsTypeService;
      default:
        return context.flipperL10n.itemsTypeUnknown;
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
      return Dialog(
        child: Center(child: Text(context.flipperL10n.noBranchSelected)),
      );
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
                Text(
                  context.flipperL10n.items,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
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
                              final variants = await notifier
                                  .futureFetchAllVariants();
                              await _exportItemsToExcel(variants);
                            },
                      tooltip: context.flipperL10n.itemsExportToExcel,
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
                hintText: context.flipperL10n.itemsSearchByName,
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
                            child: Text(
                              context.flipperL10n.errorMessage(
                                '${snapshot.error}',
                              ),
                            ),
                          );
                        }
                        final transactions = snapshot.data ?? [];
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          toast(
                            context.flipperL10n.itemsTransactionsSyncedCount(
                              transactions.length,
                            ),
                          );
                        });
                        return Center(
                          child: Text(
                            context.flipperL10n.itemsTransactionsSynced,
                          ),
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
                          return Center(
                            child: Text(context.flipperL10n.itemsNoneFound),
                          );
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
                              child: Material(
                                color: Colors.transparent,
                                child: ListTile(
                                  title: Text(
                                    variant.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${_getItemTypeName(variant.itemTyCd)} - ${variant.itemCd ?? context.flipperL10n.dashNotAvailable}',
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (variant.stockId != null &&
                                          variant.stockId!.isNotEmpty)
                                        ref
                                            .watch(
                                              stockByVariantProvider(
                                                variant.stockId!,
                                              ),
                                            )
                                            .when(
                                              data: (stock) => Text(
                                                context.flipperL10n.itemsStockValue(
                                                  '${stock?.currentStock ?? 0}',
                                                ),
                                              ),
                                              loading: () => Text(
                                                context
                                                    .flipperL10n
                                                    .itemsStockLoading,
                                              ),
                                              error: (err, stack) => Text(
                                                context
                                                    .flipperL10n
                                                    .itemsStockError,
                                              ),
                                            )
                                      else
                                        Text(
                                          context.flipperL10n.itemsStockValue(
                                            '0',
                                          ),
                                        ),
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
                                            Timer(
                                              const Duration(seconds: 2),
                                              () {
                                                if (mounted) {
                                                  setState(() {
                                                    _copiedVariantId = null;
                                                  });
                                                }
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Center(
                        child: Text(
                          context.flipperL10n.itemsErrorLoading('$error'),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
