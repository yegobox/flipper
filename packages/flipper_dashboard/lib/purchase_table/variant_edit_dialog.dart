import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import '../utils/variant_utils.dart';

// Add provider for selected variant state
final selectedVariantProvider = StateProvider.family<Variant?, String>(
  (ref, variantId) => null,
);

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
      final l10n = context.flipperL10n;
      return AlertDialog(
        title: Text(l10n.purchaseAssignVariant),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer(
                builder: (context, ref, _) {
                  final selectedVariant = ref.watch(
                    selectedVariantProvider(item.id),
                  );
                  final setSelectedVariant = ref.read(
                    selectedVariantProvider(item.id).notifier,
                  );

                  return DropdownSearch<Variant>(
                    selectedItem: selectedVariant,
                    items: (filter, loadProps) =>
                        VariantUtils.searchVariants(filter),
                    compareFn: (Variant i, Variant s) => i.id == s.id,
                    itemAsString: (Variant v) => v.name,
                    decoratorProps: const DropDownDecoratorProps(
                      baseStyle: TextStyle(fontSize: 13),
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          hintText: l10n.purchaseSearchVariants,
                          border: const OutlineInputBorder(),
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
                decoration: InputDecoration(
                  labelText: l10n.name,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: supplyPriceController,
                decoration: InputDecoration(
                  labelText: l10n.purchaseSupplyPrice,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: retailPriceController,
                decoration: InputDecoration(
                  labelText: l10n.createRetailPrice,
                  border: const OutlineInputBorder(),
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
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              saveItemName();
              Navigator.of(context).pop();
            },
            child: Text(l10n.save),
          ),
        ],
      );
    },
  );
}
