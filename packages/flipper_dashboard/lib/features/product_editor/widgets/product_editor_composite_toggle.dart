import 'package:flipper_dashboard/ToggleButtonWidget.dart';
import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Handoff-styled composite toggle wrapping [isCompositeProvider].
class ProductEditorCompositeToggle extends ConsumerWidget {
  const ProductEditorCompositeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isToggled = ref.watch(isCompositeProvider);
    return ProductEditorSwitchRow(
      icon: Icons.layers_outlined,
      title: context.flipperL10n.productEditorCompositeItem,
      hint: context.flipperL10n.productEditorCompositeHint,
      value: isToggled,
      onChanged: (value) =>
          ref.read(isCompositeProvider.notifier).state = value,
    );
  }
}

/// Whether a new combo is made ahead in Production Output (a finished product
/// with its own stock) rather than put together when it is sold (a service).
/// Starts off each time the editor opens.
final madeInProductionProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);

/// "Made in production" switch, shown for a combo.
class ProductEditorMadeInProductionToggle extends ConsumerWidget {
  const ProductEditorMadeInProductionToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(madeInProductionProvider);
    return ProductEditorSwitchRow(
      icon: Icons.factory_outlined,
      title: context.flipperL10n.productEditorMadeInProduction,
      hint: context.flipperL10n.productEditorMadeInProductionHint,
      value: value,
      onChanged: (v) => ref.read(madeInProductionProvider.notifier).state = v,
    );
  }
}

/// The editor's labelled on/off row.
class ProductEditorSwitchRow extends StatelessWidget {
  const ProductEditorSwitchRow({
    super.key,
    required this.icon,
    required this.title,
    required this.hint,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String hint;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final isToggled = value;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: ProductEditorTokens.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ProductEditorTokens.line, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: ProductEditorTokens.violetTint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: ProductEditorTokens.violet),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ProductEditorTokens.ink1,
                  ),
                ),
                Text(
                  hint,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: ProductEditorTokens.ink3,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(!isToggled),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50,
              height: 30,
              decoration: BoxDecoration(
                color: isToggled
                    ? ProductEditorTokens.blue
                    : ProductEditorTokens.lineStrong,
                borderRadius: BorderRadius.circular(999),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutBack,
                alignment: isToggled
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
