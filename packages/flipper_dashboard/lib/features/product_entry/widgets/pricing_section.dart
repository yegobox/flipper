import 'package:flutter/material.dart';
import 'package:flipper_models/view_models/ScannViewModel.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PricingSection extends HookConsumerWidget {
  final TextEditingController retailPriceController;
  final TextEditingController supplyPriceController;
  final ScannViewModel model;
  final bool isComposite;

  const PricingSection({
    Key? key,
    required this.retailPriceController,
    required this.supplyPriceController,
    required this.model,
    required this.isComposite,
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
              "Pricing",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: retailPriceController,
                    onChanged: (value) => model.setRetailPrice(price: value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Price is required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid price';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Retail Price',
                      prefixText: '', // Currency symbol could go here
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: supplyPriceController,
                    readOnly: isComposite,
                    onChanged: (value) => model.setSupplyPrice(price: value),
                    decoration: InputDecoration(
                      labelText: 'Supply Price',
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
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
