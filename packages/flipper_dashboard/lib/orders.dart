import 'package:flipper_dashboard/CustomSupplierDropdown.dart';
import 'package:flipper_models/providers/selected_provider.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/ProductList.dart';
import 'package:flipper_dashboard/functions.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flipper_routing/app.locator.dart' show locator;
import 'package:stacked_services/stacked_services.dart';

class Orders extends HookConsumerWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suppliers = ref.watch(branchesProvider((includeSelf: false)));
    final selectedSupplier = useState<Branch?>(null);
    final theme = Theme.of(context);

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
                  context, ref, suppliers.value ?? [], selectedSupplier);
            } else {
              return _buildMobileLayout(
                  context, ref, suppliers.value ?? [], selectedSupplier);
            }
          },
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref,
      List<Branch> suppliers, ValueNotifier<Branch?> selectedSupplier) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          _buildSearchableSupplierField(suppliers, selectedSupplier, ref, context),
          const SizedBox(height: 24),
          Expanded(
            child: _buildProductsView(context, ref, selectedSupplier.value),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(
      BuildContext context,
      WidgetRef ref,
      List<Branch> suppliers,
      ValueNotifier<Branch?> selectedSupplier
      ) {
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
          _buildSearchableSupplierField(suppliers, selectedSupplier, ref, context),
          const SizedBox(height: 32),
          _buildViewProductsButton(context, ref),
        ],
      ),
    );
  }

  Widget _buildSearchableSupplierField(
      List<Branch> suppliers,
      ValueNotifier<Branch?> selectedSupplier,
      WidgetRef ref,
      BuildContext context
      ) {
    return TypeAheadField<Branch>(
      suggestionsCallback: (search) {
        return suppliers
            .where((supplier) =>
            supplier.name!.toLowerCase().contains(search.toLowerCase()))
            .toList();
      },
      builder: (context, controller, focusNode) {
        // Initialize controller text with selected supplier if exists
        if (selectedSupplier.value != null && controller.text.isEmpty) {
          controller.text = selectedSupplier.value!.name!;
        }
        return StyledTextFormField.create(
          focusNode: focusNode,
          context: context,
          labelText: 'Search suppliers...',
          hintText: 'Search suppliers...',
          controller: controller,
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          minLines: 1,
          prefixIcon: Icons.search,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            }
            return null;
          },
        );
      },
      itemBuilder: (context, supplier) {
        return ListTile(
          title: Text(supplier.name!),
          subtitle: Text( 'No address available'),
        );
      },
      onSelected: (supplier) {

        ref
            .read(selectedSupplierProvider.notifier)
            .setSupplier(supplier);
      },
      emptyBuilder: (context) =>
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('No suppliers found.'),
          ),
    );
  }

  Widget _buildViewProductsButton(BuildContext context, WidgetRef ref) {
    final selectedSupplier = ref.watch(selectedSupplierProvider);

    return FlipperButton(
      textColor: Theme.of(context).colorScheme.onPrimary,
      color: Theme.of(context).colorScheme.primary,
      radius: 4,
      onPressed: () {
        if(selectedSupplier==null){
          showToast(context, "Choose supplier");
          return;
        }
        ProxyService.box.writeBool(key: 'isOrdering', value: true);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductListScreen(),
          ),
        );
      },
      text: 'View Products',
    );
  }

  Widget _buildProductsView(
      BuildContext context, WidgetRef ref, Branch? selectedSupplier) {
    if (selectedSupplier == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.store_rounded,
              size: 48,
              color:
              Theme.of(context).colorScheme.onSurface.withValues(alpha: .2),
            ),
            const SizedBox(height: 16),
            Text(
              'Select a supplier to view products',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }
    return const ProductListScreen();
  }
}
