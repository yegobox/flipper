import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';

// Add provider for selected variant state
final selectedVariantProvider =
    StateProvider.family<Variant?, String>((ref, variantId) => null);

Future<void> showVariantEditDialog(
  BuildContext context,
  Variant item, {
  required List<Variant> variants,
  required TextEditingController nameController,
  required TextEditingController supplyPriceController,
  required TextEditingController retailPriceController,
  required VoidCallback saveItemName,
  required void Function(Variant? itemToAssign, Variant? itemFromPurchase)
      selectSale,
}) {
  nameController.text = item.name;
  supplyPriceController.text = item.supplyPrice?.toString() ?? '';
  retailPriceController.text = item.retailPrice?.toString() ?? '';

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Assign Variant'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer(
                builder: (context, ref, _) {
                  final selectedVariant =
                      ref.watch(selectedVariantProvider(item.id));
                  final setSelectedVariant =
                      ref.read(selectedVariantProvider(item.id).notifier);

                  return DropdownSearch<Variant>(
                    selectedItem: selectedVariant,
                    items: (filter, loadProps) => _searchVariants(filter),
                    compareFn: (Variant i, Variant s) => i.id == s.id,
                    itemAsString: (Variant v) => v.name,
                    decoratorProps: const DropDownDecoratorProps(
                      baseStyle: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    popupProps: const PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          hintText: 'Search variants...',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ),
                    onChanged: (Variant? itemToAssign) {
                      setSelectedVariant.state = itemToAssign;
                      selectSale(itemToAssign, item);
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: supplyPriceController,
                decoration: const InputDecoration(
                  labelText: 'Supply Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: retailPriceController,
                decoration: const InputDecoration(
                  labelText: 'Retail Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              saveItemName();
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

Future<List<Variant>> _searchVariants(String filter) async {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) return [];

  if (filter.isEmpty) {
    // Return initial variants when no search filter
    final variants = await ProxyService.getStrategy(Strategy.capella).variants(
      name: '',
      fetchRemote: false,
      branchId: branchId,
      page: 0,
      itemsPerPage: 20,
      taxTyCds: ['A', 'B', 'C', 'D', 'TT'],
      scanMode: false,
    );
    return variants.variants
        .where((v) => v.itemTyCd != '3')
        .cast<Variant>()
        .toList();
  }

  // Perform global search similar to search_field.dart
  final variants = await ProxyService.getStrategy(Strategy.capella).variants(
    name: filter.toLowerCase(),
    fetchRemote: true, // Always fetch remote for searches
    branchId: branchId,
    page: 0,
    itemsPerPage: 50, // Larger page size for search results
    taxTyCds: ['A', 'B', 'C', 'D', 'TT'],
    scanMode: false,
  );

  return variants.variants
      .where((v) => v.itemTyCd != '3')
      .cast<Variant>()
      .toList();
}
