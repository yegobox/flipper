import 'package:flipper_dashboard/product_row.dart';
import 'package:flipper_dashboard/search_field.dart';
import 'package:flipper_dashboard/sticky_search.dart';
import 'package:flipper_dashboard/tenants_list.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_routing/routes.logger.dart';

final isWindows = UniversalPlatform.isWindows;
final isMacOs = UniversalPlatform.isMacOS;

class ProductView extends StatefulWidget {
  const ProductView({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final log = getLogger('_onCreate');
  final searchController = TextEditingController();
  bool _isFocused = false;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onSearchFocusChanged);
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onSearchFocusChanged);
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchFocusChanged() {
    setState(() {
      _isFocused = _searchFocusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.reactive(
      onViewModelReady: (model) async {
        model.loadTenants();
        model.productService.products = await ProxyService.isarApi
            .products(branchId: ProxyService.box.getBranchId()!);
      },
      viewModelBuilder: () => ProductViewModel(),
      builder: (context, model, child) {
        return KeyboardVisibility(
            onChanged: (bool keyboardVisible) {
              if (!keyboardVisible) {
                _searchFocusNode.unfocus();
              }
            },
            child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: false,
                  floating: true,
                  delegate: StickyHeader(
                    child: Container(
                      height: kToolbarHeight,
                      child: SearchField(controller: searchController),
                    ),
                  ),
                ),
                StreamBuilder<List<Product>>(
                  initialData: model.productService.products,
                  stream: model.productService
                      .productStream(branchId: ProxyService.box.getBranchId()!)
                      .transform(model.productService
                          .searchTransformer(searchController.text)),
                  builder: (context, snapshot) {
                    final products = (snapshot.data ?? [])
                        .where((p) =>
                            p.name != 'Custom Amount' && p.name != 'temp')
                        .toList();
                    return SliverList(
                        delegate: SliverChildListDelegate([
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
                                edit: (productId) {
                                  GoRouter.of(context)
                                      .push("/edit/product/$productId");
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
              ],
            ));
      },
    );
  }
}
