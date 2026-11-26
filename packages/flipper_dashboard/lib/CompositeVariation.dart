import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/pe_field.dart'
    show PosTokensRadius;
import 'package:flipper_dashboard/features/product_editor/widgets/pe_variant_field.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final costProvider = StateProvider<double>((ref) => 0.0);

class VVariant {
  final String productName;
  final String? name;
  final String id;
  final String productId;
  final double retailPrice;

  /// What one unit costs the business (the variant's supply price). A combo's
  /// cost is built from this, never from the selling price.
  final double supplyPrice;

  VVariant({
    required this.productName,
    this.name,
    required this.id,
    required this.productId,
    required this.retailPrice,
    this.supplyPrice = 0,
  });
}

class VariantState {
  final VVariant variant;
  final double quantity;
  final double cost;

  VariantState({required this.variant, this.quantity = 1})
    : cost = variant.supplyPrice * quantity;

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

  /// An edited combo's saved lines, quantities kept. Replaces whatever was
  /// held, and forgets earlier removals so a saved line can be removed and
  /// picked again.
  void loadComponents(List<VariantState> lines) {
    _deletedVariants.clear();
    state = List.of(lines);
  }

  void updateQuantity(VVariant variant, double quantity) {
    state = [
      for (final vs in state)
        if (vs.variant.id == variant.id)
          vs.copyWith(quantity: quantity)
        else
          vs,
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

/// The combo's component lines: quantity in, cost (supply price × quantity)
/// out. Keeps the combo's supply price at the sum of its lines.
class CompositeVariation extends StatefulHookConsumerWidget {
  final EdgeInsets padding;
  final TextEditingController supplyPriceController;

  /// The business currency, shown before each line's cost (as the retail
  /// and supply prices show it).
  final String currency;

  const CompositeVariation({
    Key? key,
    this.padding = const EdgeInsets.all(16.0),
    required this.supplyPriceController,
    required this.currency,
  }) : super(key: key);

  @override
  CompositeVariationState createState() => CompositeVariationState();
}

/// One component line's inputs, kept across rebuilds so typing is not lost.
typedef CompositeLineControllers = ({
  TextEditingController quantity,
  TextEditingController cost,
});

class CompositeVariationState extends ConsumerState<CompositeVariation> {
  double totalCost = 0.0;
  final Map<String, CompositeLineControllers> _lines = {};

  /// The live controllers, by component (variant) id.
  @visibleForTesting
  Map<String, CompositeLineControllers> get lineControllers => _lines;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) recalculateTotalCost();
    });
  }

  @override
  void dispose() {
    for (final line in _lines.values) {
      line.quantity.dispose();
      line.cost.dispose();
    }
    _lines.clear();
    super.dispose();
  }

  void recalculateTotalCost() {
    final selectedVariants = ref.read(selectedVariantsLocalProvider);
    totalCost = selectedVariants.fold(0, (sum, vs) {
      return sum + (vs.variant.supplyPrice * vs.quantity);
    });
    widget.supplyPriceController.text = totalCost.toString();
  }

  /// A line's cost: whole amounts without decimals (`1,500`), anything else
  /// to two places (`1.25`), so the line shows what the total adds up.
  @visibleForTesting
  static String costText(double cost) => NumberFormat.decimalPatternDigits(
    locale: 'en_US',
    decimalDigits: cost == cost.roundToDouble() ? 0 : 2,
  ).format(cost);

  static String _quantityText(double quantity) =>
      quantity == quantity.truncateToDouble()
      ? quantity.toInt().toString()
      : quantity.toString();

  static void _setText(TextEditingController controller, String text) {
    if (controller.text == text) return;
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  CompositeLineControllers _controllersFor(VariantState line) {
    final controllers = _lines.putIfAbsent(
      line.variant.id,
      () => (
        quantity: TextEditingController(text: _quantityText(line.quantity)),
        cost: TextEditingController(text: costText(line.cost)),
      ),
    );
    // Rewrite the quantity only when the line moved away from what is typed,
    // so a half-typed "1." keeps its text and cursor.
    if ((double.tryParse(controllers.quantity.text) ?? 0) != line.quantity) {
      _setText(controllers.quantity, _quantityText(line.quantity));
    }
    _setText(controllers.cost, costText(line.cost));
    return controllers;
  }

  /// Drops the controllers of removed lines. They are disposed after the
  /// frame, once their fields have let go of them.
  void _pruneControllers(List<VariantState> lines) {
    final live = {for (final line in lines) line.variant.id};
    final stale = _lines.keys.where((id) => !live.contains(id)).toList();
    if (stale.isEmpty) return;
    final dead = [for (final id in stale) _lines.remove(id)!];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final line in dead) {
        line.quantity.dispose();
        line.cost.dispose();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedVariants = ref.watch(selectedVariantsLocalProvider);
    final selectedVariantsNotifier = ref.read(
      selectedVariantsLocalProvider.notifier,
    );
    // A line added elsewhere (the component search) moves the total too.
    // After the frame: the supply field is listened to by the editor.
    ref.listen(selectedVariantsLocalProvider, (previous, next) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) recalculateTotalCost();
      });
    });
    _pruneControllers(selectedVariants);
    final l10n = context.flipperL10n;

    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final variantState in selectedVariants)
            Padding(
              key: ValueKey(variantState.variant.id),
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _line(
                variantState,
                _controllersFor(variantState),
                l10n,
                selectedVariantsNotifier,
              ),
            ),
        ],
      ),
    );
  }

  Widget _line(
    VariantState variantState,
    CompositeLineControllers controllers,
    FlipperAppLocalizations l10n,
    VariantNotifier notifier,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
      decoration: BoxDecoration(
        color: ProductEditorTokens.surface,
        borderRadius: BorderRadius.circular(PosTokensRadius.md),
        border: Border.all(color: ProductEditorTokens.line, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              // Centre the name on the 40px inputs, not on their labels.
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                variantState.variant.productName +
                    " " +
                    (variantState.variant.name ?? ""),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ProductEditorTokens.ink1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: PeVariantField(
              label: l10n.quantity,
              child: PeVariantTextInput(
                controller: controllers.quantity,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final double quantity = double.tryParse(value) ?? 0.0;
                  notifier.updateQuantity(variantState.variant, quantity);
                  recalculateTotalCost();
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: PeVariantField(
              label: l10n.compositeCost,
              child: PeVariantTextInput(
                controller: controllers.cost,
                prefix: widget.currency,
                readOnly: true,
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: () {
              notifier.deleteVariant(variantState.variant);
              recalculateTotalCost();
            },
            icon: const Icon(
              Icons.delete_outline,
              color: ProductEditorTokens.loss,
            ),
          ),
        ],
      ),
    );
  }
}
