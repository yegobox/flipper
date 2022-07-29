import 'package:flipper_dashboard/discount_row.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'add_product_buttons.dart';
import 'product_row.dart';
import 'package:flipper_services/proxy.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:go_router/go_router.dart';

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
  String _currentItems = '';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.reactive(
      onModelReady: (model) {
        int branchId = ProxyService.box.getBranchId()!;
        model.productService
            .loadProducts(branchId: branchId)
            .listen((products) {
          model.productService.products = products;
        });
      },
      viewModelBuilder: () => ProductViewModel(),
      builder: (context, model, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black.withOpacity(0.25),
                        ),
                      ),
                      child: ListTile(
                        dense: true,
                        trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => const OptionModal(
                                  child: AddProductButtons(),
                                ),
                              );
                            },
                            icon: SvgPicture.asset("assets/plus.svg",
                                semanticsLabel: 'plus')),
                        leading: IconButton(
                            onPressed: null,
                            icon: SvgPicture.asset("assets/search.svg",
                                semanticsLabel: 'search')),
                        title: IconButton(
                            onPressed: null,
                            icon: TextFormField(
                              onChanged: null,
                              decoration: InputDecoration.collapsed(
                                  hintText: 'Search items here'),
                              keyboardType: TextInputType.number,
                            )),
                      ),
                    ),
                  ),
                  //TODOre-add scann selling
                  // if (ProxyService.remoteConfig.scannSelling() &&
                  //     !isWindows &&
                  //     !isMacOs)
                  //   GestureDetector(
                  //     onTap: () {
                  //       // pass fake intent the intent will come from what we scann!
                  //       GoRouter.of(context).push(Routes.scann + "/se");
                  //     },
                  //     child: const CircleAvatar(
                  //       backgroundColor: Colors.transparent,
                  //       child: Icon(
                  //         Icons.center_focus_weak,
                  //         color: primary,
                  //       ),
                  //     ),
                  //   )
                ],
              ),

              /// show the discounts..
              if (ProxyService.remoteConfig.isDiscountAvailable())
                ...model.productService.discounts.map((discount) {
                  return DiscountRow(
                    discount: discount,
                    name: discount.name,
                    model: model,
                    hasImage: false,
                    delete: (id) {
                      model.deleteDiscount(id: id);
                    },
                    edit: (discount) {
                      GoRouter.of(context).push(Routes.discount);
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

              /// show the products
              ...model.productService.products.map(
                (product) {
                  return FutureBuilder<List<Stock?>>(
                      future: model.productService
                          .loadStockByProductId(productId: product.id),
                      builder: (BuildContext context, stocks) {
                        if (stocks.connectionState == ConnectionState.waiting) {
                          return const SizedBox.shrink();
                        }
                        return ProductRow(
                          color: product.color,
                          stocks: stocks.data ?? [],
                          model: model,
                          hasImage: product.hasPicture,
                          product: product,
                          name: product.name,
                          imageUrl: product.imageUrl,
                          edit: (productId) {
                            GoRouter.of(context)
                                .push("/edit/product/$productId");
                          },
                          addToMenu: (productId) {
                            model.addToMenu(productId: productId);
                          },
                          delete: (productId) {
                            model.deleteProduct(productId: productId);
                          },
                        );
                      });
                },
              ).toList()
            ],
          ),
        );
      },
    );
  }
}
