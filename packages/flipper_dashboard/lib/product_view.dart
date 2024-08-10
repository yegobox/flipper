// ignore_for_file: unused_result

import 'package:flipper_dashboard/DesktopProductAdd.dart';
import 'package:flipper_dashboard/dataMixer.dart';
import 'package:flipper_dashboard/itemRow.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_dashboard/tenants_list.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/DeviceType.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:flipper_dashboard/TransactionList.dart';

class ProductView extends StatefulHookConsumerWidget {
  final int? favIndex;
  final List<int> existingFavs;

  ProductView.normalMode({Key? key})
      : favIndex = null,
        existingFavs = [],
        super(key: key);

  ProductView.favoriteMode({
    Key? key,
    required this.favIndex,
    required this.existingFavs,
  }) : super(key: key);

  @override
  ProductViewState createState() => ProductViewState();
}

class ProductViewState extends ConsumerState<ProductView> with Datamixer {
  final searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final _routerService = locator<RouterService>();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  String _getDeviceType(BuildContext context) {
    return DeviceType.getDeviceType(context);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.nonReactive(
      onViewModelReady: (model) async {
        await model.loadTenants();
        ref
            .read(
                productsProvider(ProxyService.box.getBranchId() ?? 0).notifier)
            .loadProducts(
                searchString: ref.read(searchStringProvider),
                scanMode: ref.read(scanningModeProvider));
      },
      viewModelBuilder: () => ProductViewModel(),
      builder: (context, model, child) {
        return _buildContent(context, model);
      },
    );
  }

  Widget _buildContent(BuildContext context, ProductViewModel model) {
    final buttonIndex = ref.watch(buttonIndexProvider);

    if (buttonIndex == 1) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 700),
        child: TransactionList(showDetailedReport: true),
      );
    }

    final deviceType = _getDeviceType(context);
    return deviceType != 'Phone'
        ? _buildVariantList(context, model)
        : _buildProductsSection(context, model);
  }

  Widget _buildVariantList(BuildContext context, ProductViewModel model) {
    return Consumer(
      builder: (context, ref, _) {
        return ref
            .watch(outerVariantsProvider(ProxyService.box.getBranchId() ?? 0))
            .when(
              data: (variants) {
                if (variants.isEmpty) {
                  return Text('No Products available.');
                }
                return _buildVariantsGrid(context, model, variants);
              },
              error: (_, __) => SizedBox.shrink(),
              loading: () => SizedBox(
                  width: 20, height: 20, child: CircularProgressIndicator()),
            );
      },
    );
  }

  Widget _buildVariantsGrid(
      BuildContext context, ProductViewModel model, List<Variant> variants) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 2.0,
      ),
      itemCount: variants.length,
      itemBuilder: (context, index) {
        if (index < 0 || index >= variants.length) {
          return SizedBox.shrink();
        }
        return buildVariantRow(
          context: context,
          model: model,
          variant: variants[index],
          isOrdering: false,
        );
      },
      shrinkWrap: true,
    );
  }

  Widget _buildProductsSection(BuildContext context, ProductViewModel model) {
    return Consumer(
      builder: (context, ref, _) {
        final productsRef =
            ref.watch(productsProvider(ProxyService.box.getBranchId() ?? 0));
        return productsRef.when(
          data: (products) => _buildProductList(context, model, products),
          error: (_, __) => SizedBox.shrink(),
          loading: () => CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildProductList(
      BuildContext context, ProductViewModel model, List<Product> products) {
    if (products.isEmpty) {
      return _buildNoItemsFoundWidget();
    }
    return _buildProductRows(context, model, products);
  }

  Widget _buildNoItemsFoundWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FluentIcons.calendar_cancel_20_filled, size: 48),
          Text((widget.favIndex == null)
              ? 'No items found'
              : 'All items are in favorites'),
        ],
      ),
    );
  }

  Widget _buildProductRows(
      BuildContext context, ProductViewModel model, List<Product> products) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: products.length,
      itemBuilder: (context, index) =>
          _buildProductPanel(context, model, products[index]),
    );
  }

  Widget _buildProductPanel(
      BuildContext context, ProductViewModel model, Product product) {
    return ExpansionTile(
      title: _buildProductHeader(context, model, product),
      children: [_buildVariantsList(product)],
    );
  }

  Widget _buildProductHeader(
      BuildContext context, ProductViewModel model, Product product) {
    return FutureBuilder<double>(
      future: ProxyService.realm.stocks(productId: product.id),
      builder: (context, stock) {
        return RowItem(
          isOrdering: false,
          isComposite: product.isComposite ?? false,
          color: product.color,
          stock: stock.data ?? 0.0,
          model: model,
          product: product,
          productName: product.name ?? "",
          variantName: product.name ?? "",
          orderItem: null,
          imageUrl: product.imageUrl,
          addFavoriteMode: (widget.favIndex != null),
          favIndex: widget.favIndex,
          edit: (productId) => _editProduct(context, productId),
          delete: (productId, type) async => await deleteFunc(productId, model),
          enableNfc: (product) => _showNfcModal(context, model, product),
        );
      },
    );
  }

  Widget _buildVariantsList(Product product) {
    return Consumer(
      builder: (context, ref, _) {
        return ref.watch(variantsProvider(product.id ?? 0)).when(
              data: (variants) => ListView.builder(
                shrinkWrap: true,
                itemCount: variants.length,
                itemBuilder: (context, index) {
                  final variant = variants[index];
                  return ListTile(
                    title: Text(variant.name ?? ""),
                    trailing: Text("${variant.retailPrice} RWF"),
                  );
                },
              ),
              loading: () => Text("searching..."),
              error: (_, __) => SizedBox.shrink(),
            );
      },
    );
  }

  void _editProduct(BuildContext context, int productId) {
    if (_getDeviceType(context) != "Phone") {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => OptionModal(
          child: ProductEntryScreen(productId: productId),
        ),
      );
    } else {
      _routerService.navigateTo(AddProductViewRoute(productId: productId));
    }
  }

  void _showNfcModal(
      BuildContext context, ProductViewModel model, Product product) {
    showMaterialModalBottomSheet(
      context: context,
      expand: false,
      backgroundColor: Colors.white,
      builder: (context) => LayoutBuilder(
        builder: (context, constraints) => SizedBox(
          height: constraints.maxHeight * 0.4,
          child: ListTenants(
            tenants: model.tenants,
            model: model,
            product: product,
          ),
        ),
      ),
    );
  }
}
