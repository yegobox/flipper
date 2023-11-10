import 'dart:developer';

import 'package:flipper_dashboard/discount_row.dart';
import 'package:flipper_dashboard/product_row.dart';
import 'package:flipper_dashboard/profile.dart';
import 'package:flipper_dashboard/search_field.dart';
import 'package:flipper_dashboard/sticky_search.dart';
import 'package:flipper_dashboard/tenants_list.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProductView extends StatefulHookConsumerWidget {
  final int? favIndex;
  final List<String> existingFavs;

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
    final productsRef =
        ref.watch(productsProvider(ProxyService.box.getBranchId()!));
    return ViewModelBuilder<ProductViewModel>.reactive(
      onViewModelReady: (model) async {
        await model.loadTenants();
        ref
            .read(productsProvider(ProxyService.box.getBranchId()!).notifier)
            .loadProducts();
      },
      viewModelBuilder: () => ProductViewModel(),
      builder: (context, model, child) {
        double searchFieldWidth = MediaQuery.of(context).size.width * 0.61;
        return buildProductView(context, model, productsRef, searchFieldWidth);
      },
    );
  }

  Widget buildProductView(BuildContext context, ProductViewModel model,
      AsyncValue<List<Product>> productsRef, double searchFieldWidth) {
    return KeyboardVisibility(
      onChanged: (bool keyboardVisible) {
        if (!keyboardVisible) {
          _searchFocusNode.unfocus();
        }
      },
      child: CustomScrollView(
        slivers: [
          buildStickyHeader(searchFieldWidth),
          buildProductList(context, model, productsRef),
          //TODO: when re-enabling discounts, remember it is causing black screen error
          // as there might be some loop that isn't well
          // buildDiscountsList(context, model),
        ],
      ),
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
        ? FutureBuilder<ITenant?>(
            future: ProxyService.isar.getTenantBYUserId(
              userId: ProxyService.box.getUserId() ?? 0,
            ),
            builder: (a, snapshoot) {
              if (snapshoot.connectionState == ConnectionState.waiting ||
                  !snapshoot.hasData) {
                return SizedBox.shrink();
              }
              final data = snapshoot.data;
              return ProfileWidget(
                tenant: data!,
                size: 25,
                sessionActive: true,
              );
            },
          )
        : SizedBox.shrink();
  }

  SliverList buildProductList(BuildContext context, ProductViewModel model,
      AsyncValue<List<Product>> productsRef) {
    return SliverList(
      delegate: SliverChildListDelegate([
        SizedBox(height: 8),
        buildProductsSection(context, model, productsRef),
      ]),
    );
  }

  Widget buildProductsSection(BuildContext context, ProductViewModel model,
      AsyncValue<List<Product>> productsRef) {
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

  Widget buildProductRows(
      BuildContext context, ProductViewModel model, List<Product> products) {
    return Column(
      children: products.map((product) {
        return Container(
          child: FutureBuilder<List<Stock?>>(
            future: model.productService.loadStockByProductId(
              productId: product.id,
            ),
            builder: (BuildContext context, stocks) {
              return ProductRow(
                color: product.color,
                stocks: stocks.data ?? [],
                model: model,
                product: product,
                name: product.name,
                imageUrl: product.imageUrl,
                addFavoriteMode: (widget.favIndex != null) ? true : false,
                favIndex: widget.favIndex,
                edit: (productId) {
                  _routerService
                      .navigateTo(AddProductViewRoute(productId: productId));
                },
                addToMenu: (productId) {},
                delete: (productId) async {
                  log("about deleting product ${productId}", name: 'delete');
                  await model.deleteProduct(productId: productId);
                  ref
                      .read(productsProvider(ProxyService.box.getBranchId()!)
                          .notifier)
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
          ),
        );
      }).toList(),
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
