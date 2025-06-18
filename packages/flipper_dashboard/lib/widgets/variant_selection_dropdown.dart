import 'package:flipper_models/providers/variants_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart';

/// A widget that displays a dropdown button for selecting a product variant.
///
/// It fetches variants based on the current branch ID and allows the user to pick one.
class VariantSelectionDropdown extends HookConsumerWidget {
  /// The ID of the variant that should be initially selected in the dropdown.
  /// Can be null if no variant is pre-selected.
  final String? initialSelectedVariantId;

  /// Callback function that is invoked when a variant is selected.
  /// Passes the selected [Variant] object, or null if the selection is cleared.
  final void Function(Variant? selectedVariant) onVariantSelected;

  /// Creates a [VariantSelectionDropdown].
  const VariantSelectionDropdown({
    super.key,
    this.initialSelectedVariantId,
    required this.onVariantSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchId = ProxyService.box.getBranchId();

    if (branchId == null) {
      return const Tooltip(
        message: "Branch not selected. Please select a branch.",
        child: Text('No Branch Selected', style: TextStyle(color: Colors.red)),
      );
    }

    final variantAsyncValue = ref.watch(variantProvider(branchId: branchId));

    return variantAsyncValue.when(
      data: (variants) {
        if (variants.isEmpty) {
          return const Tooltip(
            message: "No variants available to select. Please create variants first.",
            child: Text("No variants"),
          );
        }

        // Determine the currently selected variant for the dropdown based on ID.
        Variant? currentlySelectedVariant;
        if (initialSelectedVariantId != null &&
            variants.any((v) => v.id == initialSelectedVariantId)) {
          currentlySelectedVariant = variants.firstWhere((v) => v.id == initialSelectedVariantId);
        }

        return DropdownButton<String>(
          value: currentlySelectedVariant?.id,
          hint: const Text('Select Variant'),
          isExpanded: true, // Allow dropdown to use available horizontal space
          items: variants.map((variant) {
            return DropdownMenuItem<String>(
              value: variant.id,
              child: Text(variant.name),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              final selectedVariant =
                  variants.firstWhere((variant) => variant.id == value);
              onVariantSelected(selectedVariant);
            } else {
              onVariantSelected(null);
            }
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
      error: (error, stack) => Tooltip(
        message: error.toString(),
        child: const Text('Error loading variants', style: TextStyle(color: Colors.red)),
      ),
    );
  }
}
