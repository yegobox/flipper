import 'package:flipper_dashboard/constants/import_options.dart';
import './variant_selection_dropdown.dart';
import 'package:flipper_ui/flipper_ui.dart';
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

  /// The variant currently selected in the dropdown, used to pre-fill the dropdown state.
  /// This typically represents the variant associated with the item being edited.
  final Variant? selectedItemForDropdown;

  /// A map to store and manage variant selections, keyed by the original item's ID.
  final Map<String, Variant> variantMap;

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
    required this.selectedItemForDropdown,
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
  }) {
    return StyledTextFormField.create(
      context: context,
      labelText: hintText,
      hintText: hintText,
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      minLines: 1,
      onChanged: (value) {
        // This onChanged callback is available if needed for immediate reactions
        // to text field changes, though currently not used for state updates here.
      },
      validator: validator,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        FlipperButton(
          onPressed: anyLoading ? null : saveChangeMadeOnItemCallback,
          text: 'Save Changes',
          textColor: Colors.black,
        ),
        const SizedBox(width: 8),
        FlipperIconButton(
          onPressed:
              anyLoading ? null : () => acceptAllImportCallback(finalItemList),
          icon: Icons.done_all,
          text: 'Accept All',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align items to the top
          children: [
            Expanded(
              child: _buildTextField(
                context: context,
                controller: nameController,
                hintText: 'Enter a name',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                context: context,
                controller: supplyPriceController,
                hintText: 'Enter supply price',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Supply price is required' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                context: context,
                controller: retailPriceController,
                hintText: 'Enter retail price',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Retail price is required' : null,
              ),
            ),
            const SizedBox(width: 16),
            // Variant Selection Dropdown
            Expanded(
              flex: 2,
              child: VariantSelectionDropdown(
                initialSelectedVariantId: selectedItemForDropdown?.id,
                onVariantSelected: (selectedVariant) {
                  if (variantSelectedWhenClickingOnRow != null &&
                      selectedVariant != null) {
                    variantMap[variantSelectedWhenClickingOnRow!.id] =
                        selectedVariant;
                  } else if (variantSelectedWhenClickingOnRow != null &&
                      selectedVariant == null) {
                    variantMap.remove(variantSelectedWhenClickingOnRow!.id);
                  }
                  selectItemCallback(selectedVariant);
                },
              ),
            ),
            const SizedBox(width: 16),
            _buildActionButtons(context),
            const SizedBox(width: 16),
            // Status Filter Dropdown
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String?>(
                value: selectedFilterStatus,
                decoration: const InputDecoration(
                  labelText: 'Filter by Status',
                  border: OutlineInputBorder(),
                ),
                items: importStatusOptions.entries.map((entry) {
                  return DropdownMenuItem<String?>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: onFilterStatusChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
