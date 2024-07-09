import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final costProvider = StateProvider<double>((ref) => 0.0);

class VVariant {
  final String productName;
  final String? name;
  final int id;
  final int productId;
  final double retailPrice;

  VVariant({
    required this.productName,
    this.name,
    required this.id,
    required this.productId,
    required this.retailPrice,
  });
}

class VariantState {
  final VVariant variant;
  final double quantity;
  final double cost;

  VariantState({required this.variant, this.quantity = 1})
      : cost = variant.retailPrice * quantity;

  VariantState copyWith({VVariant? variant, double? quantity}) {
    return VariantState(
      variant: variant ?? this.variant,
      quantity: quantity ?? this.quantity,
    );
  }
}

class VariantNotifier extends StateNotifier<List<VariantState>> {
  VariantNotifier() : super([]);

  final List<VVariant> _deletedVariants = []; // For storing deleted variants

  void initializeVariants(List<VVariant> variants) {
    state = variants.map((variant) => VariantState(variant: variant)).toList();
  }

  void updateQuantity(VVariant variant, double quantity) {
    state = [
      for (final vs in state)
        if (vs.variant.id == variant.id) vs.copyWith(quantity: quantity) else vs
    ];
  }

  // Properly delete a variant and store it in the temporary storage
  void deleteVariant(VVariant variant) {
    // Remove from main state
    state = state.where((vs) => vs.variant.id != variant.id).toList();
    // Store in the temporary storage list
    _deletedVariants.add(variant);
  }

  // Add a variant, but only if it's not in the main state or the deleted storage
  // Add a variant, but only if it's not in the main state or the deleted storage
  void addVariant({required VVariant variant}) {
    talker.info("we got here ${variant.productName}");
    // Remove the variant from the deleted list if it exists
    _deletedVariants.removeWhere((vs) => vs.id == variant.id);

    if (!state.any((vs) => vs.variant.id == variant.id) &&
        !_deletedVariants.any((vs) => vs.id == variant.id)) {
      // Corrected comparison
      state = [...state, VariantState(variant: variant)];
    }
  }

  void clearState() {
    state = [];
  }

  List<VVariant> get allVariants => state.map((vs) => vs.variant).toList();
}

final selectedVariantsLocalProvider =
    StateNotifierProvider<VariantNotifier, List<VariantState>>((ref) {
  return VariantNotifier();
});

class CompositeVariation extends StatefulHookConsumerWidget {
  final EdgeInsets padding;
  final TextEditingController supplyPriceController;

  CompositeVariation({
    Key? key,
    this.padding = const EdgeInsets.all(16.0),
    required this.supplyPriceController,
  }) : super(key: key);

  @override
  _SearchVariantState createState() => _SearchVariantState();
}

class _SearchVariantState extends ConsumerState<CompositeVariation> {
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
                      final double quantity = double.tryParse(value) ?? 0.0;
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
