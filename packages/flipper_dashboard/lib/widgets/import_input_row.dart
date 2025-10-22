import 'package:flipper_dashboard/constants/import_options.dart';
import './variant_selection_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart';

/// A widget representing the input row for managing an import item.
///
/// This includes fields for item name, supply price, retail price, variant selection,
/// action buttons (save, accept all), and a status filter dropdown.
class ImportInputRow extends HookConsumerWidget {
  /// Controller for the item name text field.
  final TextEditingController nameController;

  /// Controller for the supply price text field.
  final TextEditingController supplyPriceController;

  /// Controller for the retail price text field.
  final TextEditingController retailPriceController;

  /// A map to store and manage variant selections, keyed by the original item's ID.
  final Map<String, List<Variant>> variantMap;

  /// The variant that was selected when a row in the data grid was clicked.
  /// This helps maintain context for which item's variant is being manipulated.
  final Variant? variantSelectedWhenClickingOnRow;

  /// The complete list of items being imported, used by the 'Accept All' action.
  final List<Variant> finalItemList;

  /// Callback invoked when a variant is selected from the dropdown.
  final void Function(Variant?) selectItemCallback;

  /// Callback invoked when the 'Save Changes' button is pressed.
  final void Function() saveChangeMadeOnItemCallback;

  /// Callback invoked when the 'Accept All' button is pressed.
  final void Function(List<Variant>) acceptAllImportCallback;

  /// Flag indicating if any background operation is in progress, used to disable action buttons.
  final bool anyLoading;

  /// The currently selected status for filtering items.
  final String? selectedFilterStatus;

  /// Callback invoked when the filter status is changed.
  final void Function(String?) onFilterStatusChanged;

  /// Creates an [ImportInputRow] widget.
  const ImportInputRow({
    super.key,
    required this.nameController,
    required this.supplyPriceController,
    required this.retailPriceController,
    required this.variantMap,
    required this.variantSelectedWhenClickingOnRow,
    required this.finalItemList,
    required this.selectItemCallback,
    required this.saveChangeMadeOnItemCallback,
    required this.acceptAllImportCallback,
    required this.anyLoading,
    required this.selectedFilterStatus,
    required this.onFilterStatusChanged,
  });

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    bool isNumeric = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF0078D4),
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      keyboardType: isNumeric
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.multiline,
      maxLines: isNumeric ? 1 : 3,
      minLines: 1,
      validator: validator,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ElevatedButton(
          onPressed: anyLoading ? null : saveChangeMadeOnItemCallback,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0078D4),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Save Changes',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed:
              anyLoading ? null : () => acceptAllImportCallback(finalItemList),
          icon: const Icon(Icons.done_all, size: 18),
          label: const Text('Accept All'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusFilterDropdown(BuildContext context) {
    return DropdownButtonFormField<String?>(
      initialValue: selectedFilterStatus,
      decoration: InputDecoration(
        labelText: 'Filter by Status',
        labelStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF0078D4),
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      items: importStatusOptions.entries.map((entry) {
        return DropdownMenuItem<String?>(
          value: entry.key,
          child: Text(
            entry.value,
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
      onChanged: onFilterStatusChanged,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? initialSelectedVariantId;
    if (variantSelectedWhenClickingOnRow != null) {
      for (final entry in variantMap.entries) {
        if (entry.value
            .any((v) => v.id == variantSelectedWhenClickingOnRow!.id)) {
          initialSelectedVariantId = entry.key;
          break;
        }
      }
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: _buildTextField(
                context: context,
                controller: nameController,
                hintText: 'Enter a name',
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              flex: 2,
              child: _buildTextField(
                context: context,
                controller: supplyPriceController,
                hintText: 'Enter supply price',
                isNumeric: true,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Supply price is required' : null,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              flex: 2,
              child: _buildTextField(
                context: context,
                controller: retailPriceController,
                hintText: 'Enter retail price',
                isNumeric: true,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Retail price is required' : null,
              ),
            ),
            const SizedBox(width: 10),
            // Variant Selection Dropdown
            Flexible(
              flex: 3,
              child: VariantSelectionDropdown(
                initialSelectedVariantId: initialSelectedVariantId,
                onVariantSelected: (selectedVariant) {
                  if (variantSelectedWhenClickingOnRow != null) {
                    // Remove the import from any existing lists
                    for (final list in variantMap.values) {
                      list.removeWhere(
                          (v) => v.id == variantSelectedWhenClickingOnRow!.id);
                    }
                    if (selectedVariant != null &&
                        selectedVariant.id !=
                            variantSelectedWhenClickingOnRow!.id) {
                      variantMap[selectedVariant.id] ??= [];
                      variantMap[selectedVariant.id]!
                          .add(variantSelectedWhenClickingOnRow!);
                    }
                  }
                  selectItemCallback(selectedVariant);
                },
              ),
            ),
            const SizedBox(width: 10),
            // Action Buttons
            Flexible(
              flex: 3,
              child: _buildActionButtons(context),
            ),
            const SizedBox(width: 10),
            // Status Filter Dropdown
            Flexible(
              flex: 2,
              child: _buildStatusFilterDropdown(context),
            ),
          ],
        ),
      ),
    );
  }
}
