import 'package:flutter/material.dart';
import 'package:supabase_models/brick/models/all_models.dart';

import 'import_purchase_ui.dart';
import 'ipm_variant_combo.dart';

Future<void> showIpmAssignVariantModal(
  BuildContext context, {
  required Variant item,
  required TextEditingController nameController,
  required TextEditingController supplyPriceController,
  required TextEditingController retailPriceController,
  required VoidCallback saveItemName,
  required void Function(Variant? itemToAssign, Variant? itemFromPurchase)
      selectSale,
  String? initialCatalogVariantId,
}) {
  nameController.text = item.name;
  supplyPriceController.text = item.supplyPrice?.toString() ?? '';
  retailPriceController.text = item.retailPrice?.toString() ?? '';

  return showDialog<void>(
    context: context,
    barrierColor: Colors.transparent,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: IpmModalShell(
          title: 'Assign Variant',
          subtitle: item.name,
          icon: Icons.local_offer_outlined,
          maxWidth: 440,
          showBackdrop: false,
          onClose: () => Navigator.of(dialogContext).pop(),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(22, 6, 22, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const IpmFieldLabel('Variant'),
                    IpmVariantCombo(
                      selectedVariantId: initialCatalogVariantId,
                      placeholder: 'Select a variant…',
                      onSelected: (catalog) => selectSale(catalog, item),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const IpmFieldLabel('Name'),
                    IpmTextField(controller: nameController),
                  ],
                ),
                const SizedBox(height: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const IpmFieldLabel('Supply Price'),
                    IpmTextField(
                      controller: supplyPriceController,
                      numeric: true,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const IpmFieldLabel('Retail Price'),
                    IpmTextField(
                      controller: retailPriceController,
                      numeric: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IpmButton(
                label: 'Cancel',
                variant: IpmButtonVariant.ghost,
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
              const SizedBox(width: 10),
              IpmButton(
                label: 'Save',
                icon: Icons.check,
                onPressed: () {
                  saveItemName();
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
