import 'package:flipper_dashboard/SearchProduct.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final costProvider = StateProvider<double>((ref) => 0.0);

class VVariant {
  final String productName;
  final String? name;
  final double retailPrice;

  VVariant({required this.productName, this.name, required this.retailPrice});
}

class VariantState {
  final VVariant variant;
  final int quantity;
  final double cost;

  VariantState({required this.variant, this.quantity = 1})
      : cost = variant.retailPrice * quantity;

  VariantState copyWith({int? quantity}) {
    return VariantState(
      variant: variant,
      quantity: quantity ?? this.quantity,
    );
  }
}

class VariantNotifier extends StateNotifier<List<VariantState>> {
  VariantNotifier(List<VVariant> variants)
      : super(
            variants.map((variant) => VariantState(variant: variant)).toList());

  void updateQuantity(VVariant variant, int quantity) {
    state = state.map((vs) {
      if (vs.variant == variant) {
        return vs.copyWith(quantity: quantity);
      }
      return vs;
    }).toList();
  }

  void deleteVariant(VVariant variant) {
    state = state.where((vs) => vs.variant != variant).toList();
  }

  // Add this method to add variants back
  void addVariant(VVariant variant) {
    // Check if the variant already exists in the list
    if (!state.any((vs) => vs.variant == variant)) {
      // If it doesn't exist, add it
      state = [...state, VariantState(variant: variant)];
    }
  }
}

final selectedVariantsLocalProvider =
    StateNotifierProvider<VariantNotifier, List<VariantState>>((ref) {
  final variants = ref
      .watch(selectedVariantsProvider)
      .map((e) => VVariant(
          productName: e.productName ?? "",
          name: e.name,
          retailPrice: e.retailPrice))
      .toList();
  return VariantNotifier(variants);
});

class SelectedVariant extends StatefulHookConsumerWidget {
  final EdgeInsets padding;
  final TextEditingController supplyPriceController;

  SelectedVariant({
    Key? key,
    this.padding = const EdgeInsets.all(16.0),
    required this.supplyPriceController,
  }) : super(key: key);

  @override
  _SearchVariantState createState() => _SearchVariantState();
}

class _SearchVariantState extends ConsumerState<SelectedVariant> {
  double totalCost = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      recalculateTotalCost();
    });
  }

  void recalculateTotalCost() {
    final selectedVariants = ref.read(selectedVariantsLocalProvider);
    totalCost = selectedVariants.fold(0, (sum, vs) {
      return sum + (vs.variant.retailPrice * vs.quantity);
    });
    widget.supplyPriceController.text = totalCost.toString();
  }

  @override
  Widget build(BuildContext context) {
    final selectedVariants = ref.watch(selectedVariantsLocalProvider);
    final selectedVariantsNotifier =
        ref.read(selectedVariantsLocalProvider.notifier);

    return Padding(
      padding: widget.padding,
      child: Column(
        children: selectedVariants.map((variantState) {
          final quantityController = TextEditingController(
              text: variantState.quantity.toString()); // Keep initial value

          final costController =
              TextEditingController(text: variantState.cost.toString());

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(variantState.variant.productName +
                      " " +
                      (variantState.variant.name ?? "")),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final int quantity = int.tryParse(value) ?? 0;
                      selectedVariantsNotifier.updateQuantity(
                          variantState.variant, quantity);
                      recalculateTotalCost();
                    },
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    readOnly: true,
                    controller: costController,
                    decoration: InputDecoration(
                      labelText: 'Cost',
                      border: OutlineInputBorder(),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    selectedVariantsNotifier
                        .deleteVariant(variantState.variant);
                    recalculateTotalCost();
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
