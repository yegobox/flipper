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
    final suppliers = ref.watch(branchesProvider((includeSelf: false)));
    final theme = Theme.of(context);
    final pendingTransaction =
        ref.watch(pendingTransactionStreamProvider(isExpense: true));
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
              return _buildDesktopLayout(context, ref, suppliers.value ?? [],
                  transaction: pendingTransaction.value);
            } else {
              return _buildMobileLayout(context, ref, suppliers.value ?? [],
                  transaction: pendingTransaction.value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(
      BuildContext context, WidgetRef ref, List<Branch> suppliers,
      {ITransaction? transaction}) {
    if (transaction == null) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          _buildSearchableSupplierField(suppliers, ref, context),
          const SizedBox(height: 24),
          Expanded(
            child: OrderingView(transaction),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(
      BuildContext context, WidgetRef ref, List<Branch> suppliers,
      {ITransaction? transaction}) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Choose Your Supplier',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a supplier to view their available products',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
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
      List<Branch> suppliers, WidgetRef ref, BuildContext context) {
    // Get the currently selected supplier
    final selectedSupplier = ref.watch(selectedSupplierProvider);

    return TypeAheadField<Branch>(
      suggestionsCallback: (search) {
        return suppliers
            .where((supplier) =>
                supplier.name!.toLowerCase().contains(search.toLowerCase()))
            .toList();
      },
      builder: (context, controller, focusNode) {
        // Initialize controller text with selected supplier if exists
        if (selectedSupplier != null && controller.text.isEmpty) {
          controller.text = selectedSupplier.name ?? '';
        }

        return StyledTextFormField.create(
          focusNode: focusNode,
          context: context,
          labelText: 'Search suppliers...',
          hintText: selectedSupplier == null
              ? 'Search suppliers...'
              : 'Selected: ${selectedSupplier.name}',
          controller: controller,
          keyboardType: TextInputType.text,
          maxLines: 1,
          minLines: 1,
          prefixIcon: Icons.search,
          suffixIcon: selectedSupplier != null
              ? Icon(Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary)
              : null,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            }
            return null;
          },
        );
      },
      itemBuilder: (context, supplier) {
        final isSelected = selectedSupplier?.id == supplier.id;
        return ListTile(
          title: Text(supplier.name!),
          subtitle: Text('No address available'),
          trailing: isSelected
              ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
              : null,
          tileColor: isSelected
              ? Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withValues(alpha: 0.2)
              : null,
        );
      },
      onSelected: (supplier) {
        ref.read(selectedSupplierProvider.notifier).setSupplier(supplier);
      },
      emptyBuilder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('No suppliers found.'),
      ),
    );
  }

  Widget _buildViewProductsButton(BuildContext context, WidgetRef ref,
      {ITransaction? transaction}) {
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
          MaterialPageRoute(
            builder: (context) => OrderingView(transaction),
          ),
        );
      },
      text: selectedSupplier == null
          ? 'Select a Supplier First'
          : 'View Products from ${selectedSupplier.name}',
    );
  }
}
