import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Flipper's action blue (`PosTokens.blue`); the storefront's only CTA colour.
const Color kShopBlue = Color(0xFF2563EB);
const Color kShopBlueTint = Color(0xFFEFF4FF);
const Color kShopInk = Color(0xFF111827);
const Color kShopMuted = FlipperColors.mediumGrey;
const Color kShopLine = FlipperColors.border;
const Color kShopCanvas = Color(0xFFF7F8FA);

/// Widest the storefront grows on a desktop browser.
const double kShopMaxWidth = 960;

/// `4,997 RWF`.
String shopMoney(double amount, String currency) {
  final digits = amount == amount.roundToDouble() ? 0 : 2;
  return '${NumberFormat.decimalPatternDigits(decimalDigits: digits).format(amount)} $currency';
}

String shopQty(double qty) =>
    qty == qty.roundToDouble() ? '${qty.toInt()}' : '$qty';

ButtonStyle shopPrimaryButton() => FilledButton.styleFrom(
  backgroundColor: kShopBlue,
  foregroundColor: Colors.white,
  minimumSize: const Size.fromHeight(50),
  shape: const RoundedRectangleBorder(borderRadius: Corners.s12Border),
  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
);

/// Centered, width-capped page body with the design system's side gutter.
class ShopBody extends StatelessWidget {
  const ShopBody({super.key, required this.child, this.shrinkHeight = false});

  final Widget child;

  /// Wrap the child's height instead of filling the space (a bottom bar
  /// must not, or it takes the whole screen from the body).
  final bool shrinkHeight;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      heightFactor: shrinkHeight ? 1 : null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: kShopMaxWidth),
        child: child,
      ),
    );
  }
}

/// Minus / qty / plus, or a single "Add" before the first unit.
class ShopStepper extends StatelessWidget {
  const ShopStepper({
    super.key,
    required this.qty,
    required this.onAdd,
    required this.onRemove,
    required this.addLabel,
    this.canAdd = true,
  });

  final double qty;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final String addLabel;
  final bool canAdd;

  @override
  Widget build(BuildContext context) {
    if (qty <= 0) {
      return SizedBox(
        height: 36,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: kShopBlue,
            shape: const RoundedRectangleBorder(borderRadius: Corners.s8Border),
          ),
          onPressed: canAdd ? onAdd : null,
          child: Text(addLabel),
        ),
      );
    }
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: kShopBlueTint,
        borderRadius: Corners.s8Border,
        border: Border.all(color: kShopBlue.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.remove, size: 18, color: kShopBlue),
            onPressed: onRemove,
          ),
          Text(
            shopQty(qty),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: kShopBlue,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.add, size: 18, color: kShopBlue),
            onPressed: canAdd ? onAdd : null,
          ),
        ],
      ),
    );
  }
}
