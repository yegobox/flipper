import 'package:flipper_dashboard/constants/import_options.dart';
import 'package:flipper_models/providers/variants_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart';

class ImportInputRow extends HookConsumerWidget {
  final TextEditingController nameController;
  final TextEditingController supplyPriceController;
  final TextEditingController retailPriceController;
  final Variant? selectedItemForDropdown; // For the variant selection dropdown
  final Map<String, Variant> variantMap;
  final Variant? variantSelectedWhenClickingOnRow;
  final List<Variant> finalItemList;
  final void Function(Variant?) selectItemCallback;
  final void Function() saveChangeMadeOnItemCallback;
  final void Function(List<Variant>) acceptAllImportCallback;
  final bool anyLoading; // To enable/disable action buttons
  final String? selectedFilterStatus;
  final void Function(String?) onFilterStatusChanged;

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
        // If stateful, call setState(() {});
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
            Consumer(
              builder: (context, ref, child) {
                final variantProviders = ref.watch(
                  variantProvider(branchId: ProxyService.box.getBranchId()!),
                );

                return variantProviders.when(
                  data: (variants) {
                    final Variant? selectedVariantObject =
                        selectedItemForDropdown != null
                            ? variants.firstWhere(
                                (variant) =>
                                    variant.id == selectedItemForDropdown!.id,
                                orElse: () => variants
                                    .first, // Consider if this default is okay
                              )
                            : null;

                    return Column(
                      children: [
                        DropdownButton<String>(
                          value: selectedVariantObject?.id,
                          hint: const Text('Select Variant'),
                          items: variants.map((variant) {
                            return DropdownMenuItem<String>(
                              value: variant.id,
                              child: Text(variant.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              final selectedVariant = variants
                                  .firstWhere((variant) => variant.id == value);
                              variantMap.clear();
                              if (variantSelectedWhenClickingOnRow != null) {
                                variantMap.putIfAbsent(
                                    variantSelectedWhenClickingOnRow!.id,
                                    () => selectedVariant);
                              } else if (finalItemList.isNotEmpty) {
                                // This logic might need care if finalItemList is empty
                                // or if the first item isn't the one being edited.
                                variantMap.putIfAbsent(finalItemList.first.id,
                                    () => selectedVariant);
                              }
                              selectItemCallback(selectedVariant);
                            } else {
                              selectItemCallback(null);
                            }
                          },
                        ),
                      ],
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text('Error: $error'),
                );
              },
            ),
            const SizedBox(width: 16),
            _buildActionButtons(context),
            const SizedBox(width: 16),
            // Status Filter Dropdown
            Expanded(
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
