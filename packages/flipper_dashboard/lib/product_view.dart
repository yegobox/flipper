import 'dart:io';
import 'package:flipper_dashboard/DesktopProductAdd.dart';
import 'package:flipper_dashboard/discount_row.dart';
import 'package:flipper_dashboard/itemRow.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_dashboard/profile.dart';
import 'package:flipper_dashboard/search_field.dart';
import 'package:flipper_dashboard/sticky_search.dart';
import 'package:flipper_dashboard/tenants_list.dart';
import 'package:flipper_dashboard/transactionList.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'ribbon.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:overlay_support/overlay_support.dart';
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchKeyword = ref.watch(searchStringProvider);
    final scannMode = ref.watch(scanningModeProvider);
    return ViewModelBuilder<ProductViewModel>.nonReactive(
      onViewModelReady: (model) async {
        await model.loadTenants();
        ref
            .read(productsProvider(ProxyService.box.getBranchId()!).notifier)
            .loadProducts(searchString: searchKeyword, scannMode: scannMode);
      },
      viewModelBuilder: () => ProductViewModel(),
      builder: (context, model, child) {
        double searchFieldWidth = MediaQuery.of(context).size.width * 0.61;
        return buildRowView(context, model, searchFieldWidth);
      },
    );
  }

  Widget buildRowView(
    BuildContext context,
    ProductViewModel model,
    double searchFieldWidth,
  ) {
    final scanMode = ref.watch(scanningModeProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Check if the width is greater than a certain threshold (e.g., for large screens)
        bool isLargeScreen = constraints.maxWidth > 600;

        return CustomScrollView(
          slivers: [
            buildIconRow(isLargeScreen),
            buildStickyHeader(searchFieldWidth),
            buildContent(context, model, scanMode),
          ],
        );
      },
    );
  }

  Widget buildIconRow(bool isLargeScreen) {
    return SliverToBoxAdapter(
      child: isLargeScreen ? IconRow() : SizedBox(),
    );
  }

  Widget buildContent(
      BuildContext context, ProductViewModel model, bool scanMode) {
    int buttonIndex = ref.watch(buttonIndexProvider);

    if (buttonIndex == 1) {
      return SliverToBoxAdapter(child: TransactionList());
    }

    return scanMode
        ? buildVariantList(context, model)
        : buildProductList(context, model);
  }

  SliverList buildVariantList(
    BuildContext context,
    ProductViewModel model,
  ) {
    return SliverList(
      delegate: SliverChildListDelegate([
        SizedBox(height: 8),
        buildVariantsSection(context, model),
      ]),
    );
  }

  Widget buildVariantsSection(
    BuildContext context,
    ProductViewModel model,
  ) {
    return Center(
      child: Center(
        child: ref
            .watch(outerVariantsProvider(ProxyService.box.getBranchId()!))
            .when(
              data: (variants) {
                return Column(
                  children: [
                    for (int index = 0; index < variants.length; index++)
                      buildVariantRow(context, model, variants[index]),
                  ],
                );
              },
              error: (error, e) => Text('error: $error'),
              loading: () => const CircularProgressIndicator(),
            ),
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
        if (stock == 0) {
          return SizedBox.shrink();
        } else {
          return buildRowItem(context, model, variant, stock);
        }
      },
      error: (dynamic error, stackTrace) => Text(error.toString()),
      loading: () => CircularProgressIndicator(),
    );
  }

  Widget buildRowItem(
    BuildContext context,
    ProductViewModel model,
    Variant variant,
    double stock,
  ) {
    return RowItem(
      color: "#d63031", // Replace with actual color
      stock: stock,
      model: model,
      variant: variant,
      name: variant.name,
      edit: (productId) {
        _routerService.navigateTo(
          AddProductViewRoute(productId: productId),
        );
      },
      deleteProduct: (id, type) async {
        if (type == 'product') {
          ProxyService.isar.delete(id: id!, endPoint: 'product');
        }
        if (type == 'variant') {
          ProxyService.isar.delete(id: id!, endPoint: 'variant');
        }

        // ignore: unused_result
        ref.refresh(
          outerVariantsProvider(ProxyService.box.getBranchId()!),
        );
      },
      enableNfc: (product) {
        // Handle NFC functionality
      },
    );
  }

  Widget buildStickyHeader(double searchFieldWidth) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 15),
      sliver: SliverPersistentHeader(
        pinned: true,
        floating: false,
        delegate: StickyHeader(
          child: Container(
            height: kToolbarHeight,
            child: buildStickyHeaderContents(searchFieldWidth),
          ),
        ),
      ),
    );
  }

  Widget buildStickyHeaderContents(double searchFieldWidth) {
    return Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        // IconRow(),
        buildSearchField(searchFieldWidth),
        SizedBox(width: 5),
        buildProfileWidget(),
      ],
    );
  }

  Widget buildSearchField(double width) {
    return SizedBox(
      width: isDesktopOrWeb ? width : double.infinity,
      child: SearchField(
        controller: searchController,
      ),
    );
  }

  Widget buildProfileWidget() {
    return isDesktopOrWeb
        ? FutureBuilder<Branch?>(
            future: ProxyService.isar.activeBranch(),
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

  SliverList buildProductList(BuildContext context, ProductViewModel model) {
    return SliverList(
      delegate: SliverChildListDelegate([
        SizedBox(height: 8),
        buildProductsSection(context, model),
      ]),
    );
  }

  Widget buildProductsSection(BuildContext context, ProductViewModel model) {
    final productsRef =
        ref.watch(productsProvider(ProxyService.box.getBranchId()!));
    return Center(
      child: Center(
        child: switch (productsRef) {
          AsyncData(:final value) => Column(
              children: [
                buildProductsOrNoItemsFoundWidget(value),
                buildProductRows(context, model, value),
              ],
            ),
          AsyncError(:final error) => Text('error: $error'),
          _ => const CircularProgressIndicator(),
        },
      ),
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
                  .read(productsProvider(ProxyService.box.getBranchId()!)
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
                    future: ProxyService.isar.stocks(productId: product.id),
                    builder: (BuildContext context, stock) {
                      return RowItem(
                        color: product.color,
                        stock: stock.data ?? 0.0,
                        model: model,
                        product: product,
                        name: product.name,
                        addToMenu: null,
                        imageUrl: product.imageUrl,
                        addFavoriteMode:
                            (widget.favIndex != null) ? true : false,
                        favIndex: widget.favIndex,
                        edit: (productId) {
                          if (Platform.isWindows || isDesktopOrWeb) {
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
                          await model.deleteProduct(productId: productId!);
                          ref
                              .read(
                                productsProvider(
                                  ProxyService.box.getBranchId()!,
                                ).notifier,
                              )
                              .deleteProduct(productId: productId);
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
                      error: (error, stackTrace) => Text(error.toString()),
                      data: (variants) => ListView.builder(
                        shrinkWrap: true,
                        itemCount: variants.length,
                        itemBuilder: (context, index) {
                          final variant = variants[index];
                          return ListTile(
                            trailing: Text(variant.name),
                            leading:
                                Text(variant.retailPrice.toString() + " RWF"),
                          );
                        },
                      ),
                    ),
                isExpanded: products[index].searchMatch,
              ),
            ],
          ),
      ],
    );
  }

  SliverList buildDiscountsList(BuildContext context, ProductViewModel model) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return FutureBuilder<List<Widget>>(
            future: buildDiscountRows(context, model),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final widgets = snapshot.data ?? [];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: widgets,
                      ),
                    ),
                  ],
                );
              } else {
                return SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }

  Future<List<Widget>> buildDiscountRows(
      BuildContext context, ProductViewModel model) async {
    final discounts = model.productService.discountStream(
      branchId: ProxyService.box.getBranchId() ?? 0,
    );

    if (!ProxyService.remoteConfig.isDiscountAvailable() ||
        await discounts.isEmpty) {
      return [];
    }

    return (await discounts).map((discount) {
      return DiscountRow(
        discount: discount.first,
        name: discount.first.name,
        model: model,
        hasImage: false,
        delete: (id) {
          model.deleteDiscount(id: id);
        },
        edit: (discount) {
          _routerService.navigateTo(AddDiscountRoute());
        },
        applyDiscount: (discount) async {
          await model.applyDiscount(discount: discount);
          showSimpleNotification(
            const Text('Apply discount'),
            background: Colors.green,
            position: NotificationPosition.bottom,
          );
        },
      );
    }).toList();
  }
}
