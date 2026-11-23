import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/view_models/ScannViewModel.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/features/product_entry/widgets/mobile_entry_style.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';

class PricingSection extends HookConsumerWidget {
  final TextEditingController retailPriceController;
  final TextEditingController supplyPriceController;
  final ScannViewModel model;
  final bool isComposite;

  /// When true, retail and supply fields stay on one row (narrow phones).
  final bool forceHorizontalPrices;

  /// Shown before both prices (the business's currency, e.g. RWF).
  final String? currencySymbol;

  const PricingSection({
    Key? key,
    required this.retailPriceController,
    required this.supplyPriceController,
    required this.model,
    required this.isComposite,
    this.forceHorizontalPrices = false,
    this.currencySymbol,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const priceKeyboard = TextInputType.numberWithOptions(decimal: true);
    return MobileEntryCard(
      title: context.flipperL10n.pricing,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final retailField = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MobileEntryFieldLabel(
                context.flipperL10n.productEntryRetailPrice,
                required: true,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: retailPriceController,
                style: mobileEntryInputTextStyle,
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
                decoration: mobileEntryInputDecoration(
                  hint: '0',
                  prefixText: currencySymbol,
                ),
                keyboardType: priceKeyboard,
              ),
            ],
          );

          final supplyField = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MobileEntryFieldLabel(
                context.flipperL10n.productEntrySupplyPrice,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: supplyPriceController,
                readOnly: isComposite,
                onChanged: (value) => model.setSupplyPrice(price: value),
                decoration: mobileEntryInputDecoration(
                  hint: '0',
                  prefixText: currencySymbol,
                  locked: isComposite,
                  suffixIcon: isComposite
                      ? const Icon(Icons.lock, size: 18, color: PosTokens.ink3)
                      : null,
                ),
                keyboardType: priceKeyboard,
                style: mobileEntryInputTextStyle.copyWith(
                  color: isComposite ? PosTokens.ink3 : PosTokens.ink1,
                ),
              ),
            ],
          );

          final shouldStack =
              !forceHorizontalPrices && constraints.maxWidth < 520;
          if (shouldStack) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [retailField, const SizedBox(height: 14), supplyField],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: retailField),
              const SizedBox(width: 12),
              Expanded(child: supplyField),
            ],
          );
        },
      ),
    );
  }
}
