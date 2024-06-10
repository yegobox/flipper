import 'package:device_type/device_type.dart';
import 'package:flipper_dashboard/DesktopProductAdd.dart';
import 'package:flipper_dashboard/itemRow.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_dashboard/profile.dart';
import 'package:flipper_dashboard/tenants_list.dart';
import 'package:flipper_dashboard/transactionList.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

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

class ProductViewState extends ConsumerState<ProductView> {
  final searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final _routerService = locator<RouterService>();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchKeyword = ref.watch(searchStringProvider);
    final scanMode = ref.watch(scanningModeProvider);
    int buttonIndex = ref.watch(buttonIndexProvider);

    if (buttonIndex == 1) {
      return TransactionList();
    }
    return ViewModelBuilder<ProductViewModel>.nonReactive(
      onViewModelReady: (model) async {
        await model.loadTenants();
        ref
            .read(
                productsProvider(ProxyService.box.getBranchId() ?? 0).notifier)
            .loadProducts(searchString: searchKeyword, scanMode: scanMode);
      },
      viewModelBuilder: () => ProductViewModel(),
      builder: (context, model, child) {
        return true
            ? buildVariantList(context, model)
            : buildProductsSection(context, model);
      },
    );
  }

  Widget buildVariantList(
    BuildContext context,
    ProductViewModel model,
  ) {
    return buildVariantsSection(context, model);
  }

  Widget buildVariantsSection(
    BuildContext context,
    ProductViewModel model,
  ) {
    return Center(
      child: ref
          .watch(outerVariantsProvider(ProxyService.box.getBranchId()!))
          .when(
            data: (variants) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 2.0,
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 600 ? 4 : 2,
                ),
                itemCount: variants.length,
                itemBuilder: (context, index) {
                  return buildVariantRow(context, model, variants[index]);
                },
                shrinkWrap: true,
              );
            },
            error: (error, e) => SizedBox.shrink(),
            loading: () => SizedBox(
                width: 20,
                height: 20,
                child: const CircularProgressIndicator()),
          ),
    );
  }

  Widget buildVariantRow(
    BuildContext context,
    ProductViewModel model,
    Variant variant,
  ) {
    final stockStream = ref.watch(stockByVariantIdProvider(variant.id!));

    return stockStream.when(
      data: (double stock) {
        return buildRowItem(context, model, variant, stock);
      },
      error: (dynamic error, stackTrace) => SizedBox.shrink(),
      loading: () => SizedBox(
          width: 20, height: 20, child: const CircularProgressIndicator()),
    );
  }

  Widget buildRowItem(
    BuildContext context,
    ProductViewModel model,
    Variant variant,
    double stock,
  ) {
    return RowItem(
      color: "#d63031",
      // Replace with actual color
      stock: stock,
      model: model,
      variant: variant,
      productName: variant.productName ?? "",
      variantName: variant.name ?? "",
      edit: (productId) {
        _routerService.navigateTo(
          AddProductViewRoute(productId: productId),
        );
      },
      deleteProduct: (id, type) async {
        try {
          if (type == 'product') {
            ProxyService.realm.delete(id: id!, endPoint: 'product');
          }
          if (type == 'variant') {
            ProxyService.realm.delete(id: id!, endPoint: 'variant');
          }

          ref
              .refresh(
                productsProvider(
                  ProxyService.box.getBranchId() ?? 0,
                ).notifier,
              )
              .loadProducts(searchString: "", scanMode: false);
        } catch (e) {}
      },
      enableNfc: (product) {
        // Handle NFC functionality
      },
    );
  }

  Widget buildProfileWidget() {
    return isDesktopOrWeb
        ? FutureBuilder<Branch?>(
            future: ProxyService.local.activeBranch(),
            builder: (a, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) {
                return SizedBox.shrink();
              }
              final data = snapshot.data;
              return ProfileWidget(
                branch: data!,
                size: 25,
                sessionActive: true,
              );
            },
          )
        : SizedBox.shrink();
  }

  Widget buildProductsSection(BuildContext context, ProductViewModel model) {
    final productsRef =
        ref.watch(productsProvider(ProxyService.box.getBranchId() ?? 0));
    return Center(
      child: switch (productsRef) {
        AsyncData(:final value) => Column(
            children: [
              buildProductsOrNoItemsFoundWidget(value),
              buildProductRows(context, model, value),
            ],
          ),
        // ignore: unused_local_variable
        AsyncError(:final error) => SizedBox.shrink(),
        _ => SizedBox(
            width: 20, height: 20, child: const CircularProgressIndicator()),
      },
    );
  }

  Widget buildProductsOrNoItemsFoundWidget(List<Product> products) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FluentIcons.calendar_cancel_20_filled,
              size: 48,
            ),
            Text((widget.favIndex == null)
                ? 'No items found'
                : 'All items are in favorites'),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  String _getDeviceType(BuildContext context) {
    return DeviceType.getDeviceType(context);
  }

  int? productId;

  Widget buildProductRows(
    BuildContext context,
    ProductViewModel model,
    List<Product> products,
  ) {
    final matchedProduct = ref.watch(matchedProductProvider);
    return Column(
      children: [
        for (int index = 0; index < products.length; index++)
          ExpansionPanelList(
            elevation: 1,
            expandedHeaderPadding: EdgeInsets.zero,
            expansionCallback: (int panelIndex, bool isExpanded) {
              ref
                  .read(productsProvider(ProxyService.box.getBranchId() ?? 0)
                      .notifier)
                  .expanded(products[index]);

              /// fetch variants for this selected product

              setState(() {
                productId = products[index].id!;
              });
            },
            children: [
              ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  final product = products[index];
                  return FutureBuilder<double>(
                    future: ProxyService.realm.stocks(productId: product.id),
                    builder: (BuildContext context, stock) {
                      return RowItem(
                        color: product.color,
                        stock: stock.data ?? 0.0,
                        model: model,
                        product: product,
                        productName: product.name ?? "",
                        variantName: product.name ?? "",
                        addToMenu: null,
                        imageUrl: product.imageUrl,
                        addFavoriteMode:
                            (widget.favIndex != null) ? true : false,
                        favIndex: widget.favIndex,
                        edit: (productId) {
                          if (_getDeviceType(context) != "Phone") {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => OptionModal(
                                child: ProductEntryScreen(productId: productId),
                              ),
                            );
                          } else {
                            _routerService.navigateTo(
                              AddProductViewRoute(productId: productId),
                            );
                          }
                        },
                        deleteProduct: (productId, type) async {
                          try {
                            await model.deleteProduct(productId: productId!);
                            ref
                                .refresh(
                                  productsProvider(
                                    ProxyService.box.getBranchId() ?? 0,
                                  ).notifier,
                                )
                                .loadProducts(
                                    searchString: "", scanMode: false);
                          } catch (e, s) {
                            talker.error("ProductViewClass:" + s.toString());
                            talker.error("ProductViewClass:" + e.toString());
                          }
                        },
                        enableNfc: (product) {
                          showMaterialModalBottomSheet(
                            expand: false,
                            context: context,
                            backgroundColor: Colors.white,
                            builder: (context) => LayoutBuilder(
                              builder: (context, constraints) => SizedBox(
                                height: constraints.maxHeight * 0.4,
                                child: ListTenants(
                                  tenants: model.tenants,
                                  model: model,
                                  product: product as Product,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                body: ref
                    .watch(variantsProvider(
                        matchedProduct == null ? 0 : matchedProduct.id))
                    .when(
                      loading: () => Text("searching..."),
                      error: (error, stackTrace) => SizedBox.shrink(),
                      data: (variants) => ListView.builder(
                        shrinkWrap: true,
                        itemCount: variants.length,
                        itemBuilder: (context, index) {
                          final variant = variants[index];
                          return Row(
                            children: [
                              Expanded(
                                child: Text(variant.name ?? ""),
                              ),
                              Expanded(
                                child: Text(
                                    variant.retailPrice.toString() + " RWF"),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
              ),
            ],
          ),
      ],
    );
  }
}
