import 'package:flipper_dashboard/ToggleButtonWidget.dart';
import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Handoff-styled composite toggle wrapping [isCompositeProvider].
class ProductEditorCompositeToggle extends ConsumerWidget {
  const ProductEditorCompositeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isToggled = ref.watch(isCompositeProvider);

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
            child: const Icon(
              Icons.layers_outlined,
              size: 17,
              color: ProductEditorTokens.violet,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Composite item',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ProductEditorTokens.ink1,
                  ),
                ),
                Text(
                  'Built from other products — price is the sum of its components',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: ProductEditorTokens.ink3,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              ref.read(isCompositeProvider.notifier).state = !isToggled;
            },
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
