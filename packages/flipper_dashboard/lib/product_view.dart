import 'package:flipper_dashboard/discount_row.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_models/models/models.dart';
import 'custom_dropdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    required this.userId,
    required this.items,
    this.sellingModeView = false,
  }) : super(key: key);

  final bool items;
  final bool sellingModeView;
  final String userId;

  @override
  _onCreate createState() => _onCreate(userId, items, sellingModeView);
}

// ignore: camel_case_types
class _onCreate extends State<ProductView> {
  _onCreate(this.userId, this.items, this.sellingModeView);

  bool search = false;
  bool spinner = false;
  final bool items;
  final bool sellingModeView;
  final String userId;
  TextEditingController? etSearch;
  String? strSearch;
  String dropdownValue = 'All Items';

  final List _items = [
    'All Items',
    'Discounts',
  ];

  late List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentItems = '';

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentItems = _dropDownMenuItems[0].value!;
    super.initState();
  }

  // here we are creating the list needed for the DropDownButton
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

  void changedDropDownItem(String selectedZone) {
    setState(() {
      _currentItems = selectedZone;
      spinner = false;
    });
  }

  Widget editModeView({required ProductViewModel model}) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Items',
          style: TextStyle(color: Colors.black, fontSize: 14.0),
        ),
        backgroundColor: Colors.grey[200],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Divider(
                color: Colors.grey[300],
              ),
              const SizedBox(
                height: 20.0,
              ),
              InkWell(
                onTap: () {
                  // model.navigateTo(path: Routing.productsListView);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text('All Items',
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.grey[800]))),
                    ),
                    Expanded(
                      flex: 1,
                      // ignore: prefer_const_literals_to_create_immutables
                      child: Row(children: [
                        // ignore: prefer_const_constructors
                        Expanded(
                          child: const Icon(
                            FontAwesomeIcons.chevronDown,
                            size: 20,
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              //Categories
              Divider(
                color: Colors.grey[300],
              ),
              const SizedBox(
                height: 10.0,
              ),
              InkWell(
                onTap: () {
                  // model.navigateTo(path: Routing.listCategoryView);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Categories',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      // ignore: prefer_const_literals_to_create_immutables
                      child: Row(children: [
                        const Expanded(
                          child: Icon(
                            FontAwesomeIcons.chevronRight,
                            size: 20,
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              //===Modifier
              Divider(
                color: Colors.grey[300],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Modifiers',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: Colors.grey[800]),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    // ignore: prefer_const_literals_to_create_immutables
                    child: Row(children: [
                      const Expanded(
                        child: Icon(
                          FontAwesomeIcons.chevronRight,
                          size: 20,
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
              // Discount
              Divider(
                color: Colors.grey[300],
              ),
              const SizedBox(
                height: 10.0,
              ),
              InkWell(
                onTap: () {
                  // model.navigateTo(path: Routing.discountView);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text('Discounts',
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.grey[800]))),
                    ),
                    Expanded(
                      flex: 1,
                      // ignore: prefer_const_literals_to_create_immutables
                      child: Row(children: [
                        const Expanded(
                            child: Icon(
                          FontAwesomeIcons.chevronRight,
                          size: 20,
                        )),
                      ]),
                    ),
                  ],
                ),
              ),
              // Option
              Divider(
                color: Colors.grey[300],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Options',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    // ignore: prefer_const_literals_to_create_immutables
                    child: Row(
                      children: const [
                        Expanded(
                          child: Icon(
                            FontAwesomeIcons.chevronRight,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Discount
              Divider(
                color: Colors.grey[300],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Units',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: const [
                        Expanded(
                          child: Icon(
                            FontAwesomeIcons.chevronRight,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget sellingMode(
      {required ProductViewModel model, required BuildContext context}) {
    return BuildProductsView(model: model);
  }

  Widget searchItems(
      {required ProductViewModel model, required BuildContext context}) {
    if (search == false) {
      _dropDownMenuItems = getDropDownMenuItems();
      return Column(children: [
        Container(
          decoration: const BoxDecoration(
              border: Border(
            bottom: BorderSide(color: Color(0xffc1c6cb)),
          )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    spinner = true;
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 12),
                    child: CustomDropdownButton(
                      value: _currentItems,
                      items: _dropDownMenuItems,
                      onChanged: changedDropDownItem,
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 48,
                color: Colors.black26,
              ),
              Container(
                // padding: EdgeInsets.only(top: 12, bottom: 12, left: 12),
                child: InkWell(
                  onTap: () {
                    search = true;
                    setState(() {});
                  },
                  child: Image.asset(
                    'assets/ic_search.png',
                    alignment: Alignment.center,
                    width: 45,
                    height: 30,
                  ),
                ),
              ),
              if (ProxyService.remoteConfig.scannSelling() &&
                  !isWindows &&
                  !isMacOs)
                GestureDetector(
                  onTap: () {
                    // ProxyService.nav.navigateTo(Routes.qrview);
                    GoRouter.of(context).go(Routes.qrview);
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
        ),
        Flexible(child: BuildProductsView(model: model)),
      ]);
    } else {
      return Column(children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xffc1c6cb)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 12),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.black26,
                    controller: etSearch,
                    // onChanged: (value) => strSearch = value,
                    onChanged: (searchKey) {
                      model.filterProduct(searchKey: searchKey);
                    },
                    style: const TextStyle(
                      color: Color(0xff3d454c),
                      fontSize: 15,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search All Items',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.black26,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  search = false;

                  setState(() {});
                },
                child: Image.asset(
                  'assets/ic_cancel.png',
                  alignment: Alignment.center,
                  width: 50,
                  height: 30,
                ),
              ),
            ],
          ),
        ),
        Flexible(child: BuildProductsView(model: model)),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    etSearch = TextEditingController(text: strSearch);
    dropdownValue = 'All Items';
    _dropDownMenuItems = getDropDownMenuItems();

    return ViewModelBuilder<ProductViewModel>.reactive(
      builder: (context, model, child) {
        return sellingModeView
            ? editModeView(model: model)
            : searchItems(model: model, context: context);
      },
      onModelReady: (model) {
        model.loadProducts();
      },
      viewModelBuilder: () => ProductViewModel(),
    );
  }
}

class BuildProductsView extends StatelessWidget {
  final log = getLogger('_onCreate');
  BuildProductsView({
    Key? key,
    required this.model,
  }) : super(key: key);
  final ProductViewModel model;
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
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
                // ProxyService.nav.navigateTo(
                //   Routes.discount,
                //   arguments: AddDiscountArguments(
                //     discount: discount,
                //   ),
                // );
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
            return ProductRow(
              color: product.color,
              stocks: model.productService
                  .loadStockByProductId(productId: product.id),
              model: model,
              hasImage: product.hasPicture,
              product: product,
              name: product.name,
              imageUrl: product.imageUrl,
              edit: (productId) {
                GoRouter.of(context).push(Routes.product + "/$productId");
              },
              addToMenu: (productId) {
                model.addToMenu(productId: productId);
              },
              delete: (productId) {
                model.deleteProduct(productId: productId);
              },
            );
          },
        ).toList()
      ],
    );
  }
}
