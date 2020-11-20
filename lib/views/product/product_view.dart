import 'package:flipper/model/product.dart';
import 'package:flipper/views/product/product_viewmodel.dart';
import 'package:flipper/views/product/widget/build_product_list.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flipper/routes/router.gr.dart';

class ProductView extends StatelessWidget {
  const ProductView(
      {Key key, this.userId, this.items, this.sellingModeView = false})
      : super(key: key);
  final String userId;
  final bool items;
  final bool sellingModeView;

  Widget editModeView({ProductsViewModel model}) {
    return Scaffold(
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
                  model.navigateTo(path: Routing.productsListView);
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
                      child: Row(children: [
                        const Expanded(
                            child: Icon(FontAwesome.chevron_right, size: 20)),
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
                  model.navigateTo(path: Routing.listCategoryView);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text('Categories',
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.grey[800]))),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(children: [
                        const Expanded(
                            child: Icon(FontAwesome.chevron_right, size: 20)),
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
                    child: Text('Modifiers',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.grey[800]))),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(children: [
                      const Expanded(
                          child: Icon(FontAwesome.chevron_right, size: 20)),
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
                  model.navigateTo(path: Routing.discountView);
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
                      child: Row(children: [
                        const Expanded(
                            child: Icon(
                          FontAwesome.chevron_right,
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
                    child: Text('Options',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.grey[800]))),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(children: [
                      const Expanded(
                          child: Icon(
                        FontAwesome.chevron_right,
                        size: 20,
                      )),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('Units',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.grey[800]))),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(children: [
                      const Expanded(
                          child: Icon(
                        FontAwesome.chevron_right,
                        size: 20,
                      )),
                    ]),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget sellingMode({ProductsViewModel model, BuildContext context}) {
    return BuildProductsView(
      context: context,
      data: model.data,
      shouldSeeItem: false,
      showCreateItemOnTop: true,
      createButtonName: 'Add Products',
      userId: userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, ProductsViewModel model, Widget child) {
          return sellingModeView
              ? editModeView(model: model)
              : sellingMode(model: model);
        },
        viewModelBuilder: () => ProductsViewModel());
  }
}

class BuildProductsView extends ViewModelWidget<ProductsViewModel> {
  BuildProductsView({
    Key key,
    @required this.context,
    @required this.data,
    @required this.showCreateItemOnTop,
    @required this.createButtonName,
    @required this.shouldSeeItem,
    @required this.userId,
  }) : super(key: key);

  final BuildContext context;
  final String createButtonName;
  final List<Product> data;
  final bool shouldSeeItem;
  final bool showCreateItemOnTop;
  final String userId;

  final Logger log = Logging.getLogger('product view');

  @override
  Widget build(BuildContext context, ProductsViewModel viewModel) {
    // final isMobile = MediaQuery.of(context).size.width < 700;

    return buildProductList(
      products: data,
      context: context,
      userId: userId,
      createButtonName: createButtonName,
      showCreateItemOnTop: showCreateItemOnTop,
      shouldSeeItem: shouldSeeItem,
    ).isEmpty
        ? const SizedBox.shrink()
        : Material(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: ListView(
                shrinkWrap: true,
                children: ListTile.divideTiles(
                  context: context,
                  tiles: buildProductList(
                      model: viewModel,
                      products: data,
                      context: context,
                      userId: userId,
                      createButtonName: createButtonName,
                      showCreateItemOnTop: showCreateItemOnTop,
                      shouldSeeItem: shouldSeeItem),
                ).toList(),
              ),
            ),
          );
  }
}
