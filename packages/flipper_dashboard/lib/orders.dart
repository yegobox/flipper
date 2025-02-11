import 'package:flipper_dashboard/CustomSupplierDropdown.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/ProductList.dart';
import 'package:flipper_dashboard/functions.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/states/selectedSupplierProvider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Select Supplier',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          elevation: 0,
          backgroundColor: theme.colorScheme.surface,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ShopIconWithStatus(
                statusColor: theme.colorScheme.primary,
              ),
            )
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
    return Row(
      children: [
        Container(
          width: 280,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: _buildSupplierList(context, suppliers, selectedSupplier, ref),
        ),
        Expanded(
          flex: 5,
          child: _buildProductsView(context, ref, selectedSupplier.value),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, WidgetRef ref,
      List<Branch> suppliers, ValueNotifier<Branch?> selectedSupplier) {
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
          _buildSupplierDropdown(suppliers, selectedSupplier, ref, context),
          const SizedBox(height: 32),
          _buildViewProductsButton(context, ref, selectedSupplier.value),
        ],
      ),
    );
  }

  Widget _buildSupplierList(BuildContext context, List<Branch> suppliers,
      ValueNotifier<Branch?> selectedSupplier, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Suppliers',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${suppliers.length} available',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: suppliers.length,
            itemBuilder: (context, index) {
              final supplier = suppliers[index];
              final isSelected = selectedSupplier.value == supplier;

              return Material(
                color: isSelected
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  title: Text(
                    supplier.name ?? "-",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.store_rounded,
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  onTap: () {
                    selectedSupplier.value = supplier;
                    ref
                        .read(selectedSupplierProvider.notifier)
                        .setSupplier(supplier: supplier);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSupplierDropdown(
    List<Branch> suppliers,
    ValueNotifier<Branch?> selectedSupplier,
    WidgetRef ref,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
        ),
      ),
      child: CustomSupplierDropdown(
        suppliers: suppliers,
        selectedSupplier: selectedSupplier.value,
        onChanged: (Branch? newValue) {
          selectedSupplier.value = newValue;
          if (newValue != null) {
            ref
                .read(selectedSupplierProvider.notifier)
                .setSupplier(supplier: newValue);
          }
        },
      ),
    );
  }

  Widget _buildViewProductsButton(
      BuildContext context, WidgetRef ref, Branch? selectedSupplier) {
    return FlipperButton(
      textColor: Theme.of(context).colorScheme.onPrimary,
      onPressed: selectedSupplier == null
          ? null
          : () {
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
