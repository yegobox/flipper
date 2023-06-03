import 'package:flipper_dashboard/discount_row.dart';
import 'package:flipper_dashboard/product_row.dart';
import 'package:flipper_dashboard/profile.dart';
import 'package:flipper_dashboard/search_field.dart';
import 'package:flipper_dashboard/sticky_search.dart';
import 'package:flipper_dashboard/tenants_list.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class ProductView extends StatefulWidget {
  int? favIndex;
  List<int> existingFavs = [];
  ProductView.normalMode({Key? key}) : super(key: key);
  ProductView.favoriteMode(
      {Key? key, required this.favIndex, required this.existingFavs})
      : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
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
    return ViewModelBuilder<ProductViewModel>.reactive(
      onViewModelReady: (model) async {
        model.loadTenants();
        model.productService.products = await ProxyService.isar
            .products(branchId: ProxyService.box.getBranchId()!);
      },
      viewModelBuilder: () => ProductViewModel(),
      builder: (context, model, child) {
        MediaQuery.of(context).size.width; // retrieve device width
        MediaQuery.of(context).size.height; // retrieve device height

        double searchFieldWidth = MediaQuery.of(context).size.width *
            0.61; // set search field width to 90% of device width

        return KeyboardVisibility(
            onChanged: (bool keyboardVisible) {
              if (!keyboardVisible) {
                _searchFocusNode.unfocus();
              }
            },
            child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: StickyHeader(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        height: kToolbarHeight,
                        child: Wrap(direction: Axis.horizontal, children: [
                          SizedBox(
                            width: isDesktopOrWeb
                                ? searchFieldWidth
                                : double.infinity,
                            child: SearchField(
                              controller: searchController,
                              model: model,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          isDesktopOrWeb
                              ? FutureBuilder<ITenant?>(
                                  future: ProxyService.isar.getTenantBYUserId(
                                      userId: ProxyService.box.getUserId()!),
                                  builder: (a, snapshoot) {
                                    if (snapshoot.connectionState ==
                                            ConnectionState.waiting ||
                                        !snapshoot.hasData) {
                                      return const SizedBox.shrink();
                                    }
                                    final data = snapshoot.data;
                                    return ProfileWidget(
                                        tenant: data!, size: 25);
                                  })
                              : SizedBox.shrink()
                        ]),
                      ),
                    ),
                  ),
                ),
                StreamBuilder<List<Product>>(
                  initialData: model.productService.products,
                  stream: model.productService
                      .productStream(
                          branchId: ProxyService.box.getBranchId() ?? 0)
                      .transform(model.productService
                          .searchTransformer(model.searchkey!)),
                  builder: (context, snapshot) {
                    final products = (snapshot.data ?? [])
                        .where((p) =>
                            p.name != 'Custom Amount' &&
                            p.name != 'temp' &&
                            !widget.existingFavs.contains(p.id))
                        .toList();
                    return SliverList(
                        delegate: SliverChildListDelegate([
                      SizedBox(
                        height: 10,
                      ),
                      products.isEmpty
                          ? Center(
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
                            )
                          : SizedBox.shrink(),
                      ...products.map((product) {
                        return FutureBuilder<List<Stock?>>(
                            future: model.productService
                                .loadStockByProductId(productId: product.id!),
                            builder: (BuildContext context, stocks) {
                              if (stocks.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox.shrink();
                              }

                              return ProductRow(
                                color: product.color,
                                stocks: stocks.data ?? [],
                                model: model,
                                product: product,
                                name: product.name,
                                imageUrl: product.imageUrl,
                                addFavoriteMode:
                                    (widget.favIndex != null) ? true : false,
                                favIndex: widget.favIndex,
                                edit: (productId) {
                                  _routerService.navigateTo(AddProductViewRoute(
                                      productId: productId));
                                },
                                addToMenu: (productId) {
                                  // ignore: todo
                                  //TODO: work on this add to menu
                                  // model.addToMenu(productId: productId);
                                },
                                delete: (productId) {
                                  model.deleteProduct(productId: productId);
                                },
                                enableNfc: (product) {
                                  // show a model with tenants to bind product to.
                                  showMaterialModalBottomSheet(
                                    expand: false,
                                    context: context,
                                    backgroundColor: Colors.white,
                                    builder: (context) => LayoutBuilder(
                                      builder: (context, constraints) =>
                                          SizedBox(
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
                            });
                      }).toList()
                    ]));
                  },
                ),
                StreamBuilder<List<Discount>>(
                  stream: model.productService.discountStream(
                      branchId: ProxyService.box.getBranchId() ?? 0),
                  builder: (context, snapshot) {
                    final discounts = snapshot.data ?? [];
                    if (!ProxyService.remoteConfig.isDiscountAvailable() ||
                        discounts.isEmpty) {
                      return SliverList(
                          delegate:
                              SliverChildListDelegate([SizedBox.shrink()]));
                    }
                    return SliverList(
                        delegate: SliverChildListDelegate([
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: discounts.map((discount) {
                          return DiscountRow(
                            discount: discount,
                            name: discount.name,
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
                        }).toList(),
                      )
                    ]));
                  },
                )
              ],
            ));
      },
    );
  }
}
