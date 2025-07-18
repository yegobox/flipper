import 'dart:async';

import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';

class ItemsDialog extends StatefulHookConsumerWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const ItemsDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  _ItemsDialogState createState() => _ItemsDialogState();
}

class _ItemsDialogState extends ConsumerState<ItemsDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _copiedVariantId;

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

  @override
  Widget build(BuildContext context) {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      return const Dialog(
        child: Center(
          child: Text("No branch selected"),
        ),
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
                Text('Items', style: Theme.of(context).textTheme.headlineSmall),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () =>
                      widget.completer(DialogResponse(confirmed: false)),
                )
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
              child: variantsAsyncValue.when(
                data: (variants) {
                  final filteredVariants = variants
                      .where((v) => v.name
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()))
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
                          side:
                              BorderSide(color: Theme.of(context).dividerColor),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(variant.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              '${_getItemTypeName(variant.itemTyCd)} - ${variant.itemCd ?? 'N/A'}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  'Stock: ${variant.stock?.currentStock ?? 0}'),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () {
                                  if (variant.itemCd != null) {
                                    Clipboard.setData(
                                        ClipboardData(text: variant.itemCd!));
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
                loading: () => const Center(child: CircularProgressIndicator()),
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
