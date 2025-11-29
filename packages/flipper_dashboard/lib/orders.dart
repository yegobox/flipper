import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_models/providers/selected_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/OrderingView.dart';
import 'package:flipper_dashboard/functions.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flipper_routing/app.locator.dart' show locator;
import 'package:stacked_services/stacked_services.dart';

class Orders extends HookConsumerWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suppliers = ref.watch(
      branchesProvider(businessId: ProxyService.box.getBusinessId()),
    );
    final theme = Theme.of(context);
    final pendingTransaction = ref.watch(
      pendingTransactionStreamProvider(isExpense: true),
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic other) {
        ProxyService.box.writeBool(key: 'isOrdering', value: false);
        if (!didPop) {
          ProxyService.box.writeBool(key: 'isOrdering', value: true);
        }
        ref.read(previewingCart.notifier).state = false;
        onWillPop(
          context: context,
          navigationPurpose: NavigationPurpose.home,
          message: 'Done shopping?',
        );
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () => locator<RouterService>().back(),
          ),
          elevation: 0,
          backgroundColor: theme.colorScheme.surface,
          actions: [
            // You can add any actions here, such as a refresh button.
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return _buildDesktopLayout(
                context,
                ref,
                suppliers.value ?? [],
                transaction: pendingTransaction.value,
              );
            } else {
              return _buildMobileLayout(
                context,
                ref,
                suppliers.value ?? [],
                transaction: pendingTransaction.value,
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    WidgetRef ref,
    List<Branch> suppliers, {
    ITransaction? transaction,
  }) {
    if (transaction == null) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          _buildSearchableSupplierField(suppliers, ref, context),
          const SizedBox(height: 24),
          Expanded(child: OrderingView(transaction)),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    WidgetRef ref,
    List<Branch> suppliers, {
    ITransaction? transaction,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Choose Your Supplier',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a supplier to view their available products',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),
          _buildSearchableSupplierField(suppliers, ref, context),
          const SizedBox(height: 32),
          _buildViewProductsButton(context, ref, transaction: transaction),
        ],
      ),
    );
  }

  Widget _buildSearchableSupplierField(
    List<Branch> suppliers,
    WidgetRef ref,
    BuildContext context,
  ) {
    // Get the currently selected supplier
    final selectedSupplier = ref.watch(selectedSupplierProvider);

    // Get current branch ID to filter it out from suppliers
    final currentBranchId = ProxyService.box.getBranchId();

    return TypeAheadField<Branch>(
      suggestionsCallback: (search) {
        return suppliers.where((supplier) {
          // Filter out current branch
          if (currentBranchId != null && supplier.id == currentBranchId) {
            return false;
          }
          // Safely handle null names - return false if name is null
          return supplier.name?.toLowerCase().contains(search.toLowerCase()) ??
              false;
        }).toList();
      },
      builder: (context, controller, focusNode) {
        // Initialize controller text with selected supplier if exists
        if (selectedSupplier != null && controller.text.isEmpty) {
          controller.text = selectedSupplier.name ?? '';
        }

        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: selectedSupplier == null
                ? 'Search suppliers...'
                : 'Selected: ${selectedSupplier.name}',
            hintStyle: TextStyle(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              size: 20,
            ),
            suffixIcon: selectedSupplier != null
                ? Icon(Icons.check_circle, color: colorScheme.primary, size: 20)
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
        );
      },
      itemBuilder: (context, supplier) {
        final isSelected = selectedSupplier?.id == supplier.id;
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Container(
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                : null,
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
            title: Text(
              supplier.name ?? 'Unknown Supplier',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
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
            trailing: isSelected
                ? Icon(Icons.check_circle, color: colorScheme.primary, size: 20)
                : Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    size: 20,
                  ),
          ),
        );
      },
      onSelected: (supplier) {
        ref.read(selectedSupplierProvider.notifier).setSupplier(supplier);
      },
      emptyBuilder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

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

  Widget _buildViewProductsButton(
    BuildContext context,
    WidgetRef ref, {
    ITransaction? transaction,
  }) {
    final selectedSupplier = ref.watch(selectedSupplierProvider);
    if (transaction == null) return SizedBox.shrink();
    return FlipperButton(
      textColor: Theme.of(context).colorScheme.onPrimary,
      color: selectedSupplier == null
          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.6)
          : Theme.of(context).colorScheme.primary,
      radius: 4,
      onPressed: () {
        if (selectedSupplier == null) {
          showToast(context, "Please select a supplier first");
          return;
        }
        ProxyService.box.writeBool(key: 'isOrdering', value: true);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderingView(transaction)),
        );
      },
      text: selectedSupplier == null
          ? 'Select a Supplier First'
          : 'View Products from ${selectedSupplier.name}',
    );
  }
}
