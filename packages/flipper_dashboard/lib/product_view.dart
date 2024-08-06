// ignore_for_file: unused_result

// import 'package:flipper_services/DeviceType.dart';
import 'package:flipper_dashboard/DesktopProductAdd.dart';
import 'package:flipper_dashboard/dataMixer.dart';
import 'package:flipper_dashboard/itemRow.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_dashboard/profile.dart';
import 'package:flipper_dashboard/tenants_list.dart';
// import 'package:flipper_dashboard/TransactionList.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
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
    final searchKeyword = ref.watch(searchStringProvider);
    final scanMode = ref.watch(scanningModeProvider);
    int buttonIndex = ref.watch(buttonIndexProvider);

    final deviceType = _getDeviceType(context);

    if (buttonIndex == 1) {
      return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 700),
          child: TransactionList(showDetailedReport: true));
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
        return deviceType != 'Phone'
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
          .watch(outerVariantsProvider(ProxyService.box.getBranchId() ?? 0))
          .when(
            data: (variants) {
              // Ensure the list is updated correctly and length is checked
              if (variants.isEmpty) {
                return Text('No Products available.');
              }

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  // Use MaxCrossAxisExtent for responsive column count
                  maxCrossAxisExtent: 200, // Adjust this value as needed
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 2.0,
                ),
                itemCount: variants.length,
                itemBuilder: (context, index) {
                  // Double-check the index before accessing the list
                  if (index < 0 || index >= variants.length) {
                    return SizedBox
                        .shrink(); // Or handle the out-of-bound case appropriately
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
            },
            error: (error, e) => SizedBox.shrink(),
            loading: () =>
                SizedBox(width: 20, height: 20, child: const SizedBox.shrink()),
          ),
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
                        delete: (productId, type) async {
                          await deleteFunc(productId, model);
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
