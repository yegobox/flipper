import 'package:flipper_dashboard/CustomSupplierDropdown.dart';
import 'package:flipper_models/realm/schemas.dart';
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
    final suppliers = ref.watch(branchesProvider);
    final selectedSupplier = useState<Branch?>(null);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic other) {
        if (didPop) {
          ProxyService.box.writeBool(key: 'isOrdering', value: false);
        } else {
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
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('Select Supplier',
              style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 1,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ShopIconWithStatus(
                statusColor: Colors.green,
              ),
            )
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return _buildDesktopLayout(
                  context, ref, suppliers, selectedSupplier);
            } else {
              return _buildMobileLayout(
                  context, ref, suppliers, selectedSupplier);
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
        Expanded(
          flex: 1,
          child: _buildSupplierList(context, suppliers, selectedSupplier, ref),
        ),
        VerticalDivider(thickness: 1, width: 1, color: Colors.grey[300]),
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSupplierDropdown(suppliers, selectedSupplier, ref, context),
          const SizedBox(height: 20),
          _buildViewProductsButton(context, ref, selectedSupplier.value),
        ],
      ),
    );
  }

  Widget _buildSupplierList(BuildContext context, List<Branch> suppliers,
      ValueNotifier<Branch?> selectedSupplier, WidgetRef ref) {
    return ListView.builder(
      itemCount: suppliers.length,
      itemBuilder: (context, index) {
        final supplier = suppliers[index];
        return ListTile(
          title: Text(
            supplier.name ?? "-",
            style: TextStyle(
              fontWeight: selectedSupplier.value == supplier
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          selected: selectedSupplier.value == supplier,
          selectedTileColor: Colors.grey[100],
          onTap: () {
            selectedSupplier.value = supplier;
            ref
                .read(selectedSupplierProvider.notifier)
                .setSupplier(supplier: supplier);
          },
        );
      },
    );
  }

  Widget _buildSupplierDropdown(
    List<Branch> suppliers,
    ValueNotifier<Branch?> selectedSupplier,
    WidgetRef ref,
    BuildContext context,
  ) {
    return CustomSupplierDropdown(
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
    );
  }

  Widget _buildViewProductsButton(
      BuildContext context, WidgetRef ref, Branch? selectedSupplier) {
    return FlipperButton(
      textColor: Colors.black,
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
        child: Text(
          'Please select a supplier',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
      );
    }
    return const ProductListScreen();
  }
}
