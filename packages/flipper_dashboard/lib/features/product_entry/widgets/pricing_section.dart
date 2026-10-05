import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/view_models/ScannViewModel.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PricingSection extends HookConsumerWidget {
  final TextEditingController retailPriceController;
  final TextEditingController supplyPriceController;
  final ScannViewModel model;
  final bool isComposite;

  /// When true, retail and supply fields stay on one row (narrow phones).
  final bool forceHorizontalPrices;

  const PricingSection({
    Key? key,
    required this.retailPriceController,
    required this.supplyPriceController,
    required this.model,
    required this.isComposite,
    this.forceHorizontalPrices = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.flipperL10n.pricing,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final retailField = TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: retailPriceController,
                  onChanged: (value) => model.setRetailPrice(price: value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.flipperL10n.productEntryPriceRequired;
                    }
                    if (double.tryParse(value) == null) {
                      return context.flipperL10n.invalidPrice;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: context.flipperL10n.productEntryRetailPrice,
                    prefixText: '', // Currency symbol could go here
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  keyboardType: TextInputType.number,
                );

                final supplyField = TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: supplyPriceController,
                  readOnly: isComposite,
                  onChanged: (value) => model.setSupplyPrice(price: value),
                  decoration: InputDecoration(
                    labelText: context.flipperL10n.productEntrySupplyPrice,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: isComposite
                        ? Colors.grey.shade200
                        : Colors.grey.shade50,
                    suffixIcon: isComposite
                        ? const Icon(Icons.lock, color: Colors.grey)
                        : null,
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: isComposite ? Colors.grey : Colors.black,
                  ),
                );

                final shouldStack =
                    !forceHorizontalPrices && constraints.maxWidth < 520;
                if (shouldStack) {
                  return Column(
                    children: [
                      retailField,
                      const SizedBox(height: 12),
                      supplyField,
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: retailField),
                    const SizedBox(width: 16),
                    Expanded(child: supplyField),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
