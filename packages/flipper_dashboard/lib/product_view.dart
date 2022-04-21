import 'package:flipper_dashboard/discount_row.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:stacked/stacked.dart';
import 'custom_dropdown.dart';
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
  late List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentItems = '';
  final List _items = [
    'All Items',
    'Discounts',
  ];
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    final List<DropdownMenuItem<String>> items = [];
    for (String val in _items) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(
        DropdownMenuItem(
          value: val,
          child: Text(
            val,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );
    }
    return items;
  }

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentItems = _dropDownMenuItems[0].value!;
    super.initState();
  }

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
        return ListView(
          shrinkWrap: true,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // spinner = true;
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 12),
                      child: CustomDropdownButton(
                        value: _currentItems,
                        items: _dropDownMenuItems,
                        onChanged: (value) {
                          model.filterProduct(searchKey: value.toString());
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 48,
                  color: Colors.black26,
                ),
                InkWell(
                  onTap: () {},
                  child: Image.asset(
                    'assets/ic_search.png',
                    alignment: Alignment.center,
                    width: 45,
                    height: 30,
                  ),
                ),
                if (ProxyService.remoteConfig.scannSelling() &&
                    !isWindows &&
                    !isMacOs)
                  GestureDetector(
                    onTap: () {
                      // pass fake intent the intent will come from what we scann!
                      GoRouter.of(context).push(Routes.scann + "/se");
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.center_focus_weak,
                        color: primary,
                      ),
                    ),
                  )
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
                        .loadStockByProductId(productId: product.id!),
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
                          GoRouter.of(context).push("edit/product/$productId");
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
        );
      },
    );
  }
}
