import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/all_providers.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UnifiedSearchField extends HookConsumerWidget {
  const UnifiedSearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSupplier = ref.watch(selectedSupplierProvider);
    final searchText = useState('');
    final controller = useTextEditingController();
    final focusNode = useFocusNode();

    // Watch suppliers for typeahead
    // final suppliersAsync = ref.watch(
    //   branchesProvider(businessId: ProxyService.box.getBusinessId()),
    // );
    // final suppliers = suppliersAsync.value ?? [];
    final currentBranchId = ProxyService.box.getBranchId();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Update controller when supplier is selected
    useEffect(() {
      if (selectedSupplier != null && controller.text.isEmpty) {
        controller.text = '';
      }
      return null;
    }, [selectedSupplier]);

    return TypeAheadField<Branch>(
      controller: controller,
      focusNode: focusNode,
      suggestionsCallback: (search) async {
        // Only show supplier suggestions if no supplier is selected
        if (selectedSupplier != null) {
          return [];
        }

        if (search.isEmpty) {
          return [];
        }

        List<Branch> suppliers = await ProxyService.app.searchSuppliers(search);

        return suppliers.where((supplier) {
          // Filter out current branch just in case
          if (currentBranchId != null && supplier.id == currentBranchId) {
            return false;
          }
          return true;
        }).toList();
      },
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: selectedSupplier == null
                ? 'Search suppliers...'
                : 'Search products...',
            hintStyle: TextStyle(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            prefixIcon: selectedSupplier != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                    child: Chip(
                      avatar: Icon(
                        Icons.store,
                        size: 16,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      label: Text(
                        selectedSupplier.name ?? 'Unknown',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      deleteIcon: Icon(
                        Icons.close,
                        size: 16,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      onDeleted: () {
                        // Clear supplier selection
                        ref
                            .read(selectedSupplierProvider.notifier)
                            .clearSupplier();
                        ref.read(searchStringProvider.notifier).state = '';
                        controller.clear();
                        searchText.value = '';
                      },
                      backgroundColor: colorScheme.primaryContainer,
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  )
                : Icon(
                    Icons.search,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    size: 20,
                  ),
            suffixIcon: controller.text.isNotEmpty && selectedSupplier != null
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 20,
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
                    ),
                    onPressed: () {
                      controller.clear();
                      searchText.value = '';
                      ref.read(searchStringProvider.notifier).state = '';
                    },
                    tooltip: 'Clear search',
                  )
                : null,
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.5,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 14.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
          ),
          onChanged: (value) {
            searchText.value = value;
            // Only update product search if supplier is selected
            if (selectedSupplier != null) {
              ref.read(searchStringProvider.notifier).state = value;
            }
          },
        );
      },
      itemBuilder: (context, supplier) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            leading: Icon(Icons.store, color: colorScheme.primary, size: 20),
            title: Text(
              supplier.name ?? 'Unknown Supplier',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            subtitle:
                supplier.description != null && supplier.description!.isNotEmpty
                ? Text(
                    supplier.description!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  )
                : null,
            trailing: Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 20,
            ),
          ),
        );
      },
      onSelected: (supplier) {
        ref.read(selectedSupplierProvider.notifier).setSupplier(supplier);
        controller.clear();
        searchText.value = '';
        ref.read(searchStringProvider.notifier).state = '';
      },
      emptyBuilder: (context) {
        // Only show empty state for supplier search
        if (selectedSupplier != null) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off,
                size: 48,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 12),
              Text(
                'No suppliers found',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Try a different search term',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
