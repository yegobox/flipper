import 'package:flipper/views/CustomDropdownButton.dart';
import 'package:flipper_models/product.dart';
import 'package:flipper/views/product/products_viewmodel.dart';
import 'package:flipper/views/product/widget/build_product_list.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flipper/routes/router.gr.dart';

class ProductView extends StatefulWidget {
  ProductView({Key key, this.userId, this.items, this.sellingModeView = false})
      : super(key: key);

  final bool items;
  final bool sellingModeView;
  final String userId;

  @override
  _onCreate createState() => _onCreate(userId, items, sellingModeView);
}

class _onCreate extends State<ProductView> {
  final bool items;
  final bool sellingModeView;
  final String userId;
  TextEditingController etSearch;
  String strSearch;
  String dropdownValue = 'All Items';

  List _items = [
    "All Items",
    "Discounts",
  ];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentItems = "";

  _onCreate(this.userId, this.items, this.sellingModeView);

  bool search = false;
  bool spinner = false;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentItems = _dropDownMenuItems[0].value;
    super.initState();
  }

  // here we are creating the list needed for the DropDownButton
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String val in _items) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(
          value: val,
          child: new Text(val, style: TextStyle(color: Colors.black))));
    }
    return items;
  }

  void changedDropDownItem(String selectedZone) {
    print("Selected city $selectedZone, we are going to refresh the UI");
    setState(() {
      _currentItems = selectedZone;
      spinner = false;

    });
  }

  Widget editModeView({ProductsViewModel model}) {
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
                      // ignore: prefer_const_literals_to_create_immutables
                      child: Row(children: [
                        // ignore: prefer_const_constructors
                        Expanded(
                            child: const Icon(FontAwesome.chevron_right,
                                size: 20)),
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
                      // ignore: prefer_const_literals_to_create_immutables
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
                    // ignore: prefer_const_literals_to_create_immutables
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
                      // ignore: prefer_const_literals_to_create_immutables
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
                    // ignore: prefer_const_literals_to_create_immutables
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
                    // ignore: prefer_const_literals_to_create_immutables
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
      data: model.products,
      shouldSeeItem: false,
      showCreateItemOnTop: true,
      createButtonName: 'Add Products',
      userId: userId,
    );
  }

  Widget searchItems({ProductsViewModel model, BuildContext context}) {
    if (search == false) {
      _dropDownMenuItems = getDropDownMenuItems();
      //_currentItems = _dropDownMenuItems[0].value;
     // if (spinner == false) {
      return Container(
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
                border: Border(
                  // right: BorderSide(color: const Color(0xffc1c6cb)),
                  bottom: BorderSide(color: const Color(0xffc1c6cb)),
                  // right: BorderSide(color: const Color(0xffc1c6cb)),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Expanded(
                //   child: Container(
                //     padding: EdgeInsets.only(left: 12),
                //     child: Text(
                //       _currentItems,
                //       style: const TextStyle(
                //         fontSize: 13.0,
                //         fontWeight: FontWeight.w500,
                //         color: Colors.black87,
                //       ),
                //     ),
                //   ),
                // ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      spinner = true;
                      setState(() {
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(left: 12),
                        // child: Text(
                        //   "All Items",
                        //   style: const TextStyle(
                        //     fontSize: 13.0,
                        //     fontWeight: FontWeight.w500,
                        //     color: Colors.black87,
                        //   ),
                        // ),

                        // child: DropdownButton<String>(
                        //   value: dropdownValue,
                        //   icon: Icon(Icons.arrow_drop_down),
                        //   iconSize: 30,
                        //   elevation: 8,
                        //   style: TextStyle(color: Colors.black, fontSize: 18),
                        //
                        //   onChanged: (String data) {
                        //     setState(() {
                        //       dropdownValue = data;
                        //     });
                        //   },
                        //   items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                        //     return DropdownMenuItem<String>(
                        //       value: value,
                        //       child: Text(value),
                        //     );
                        //   }).toList(),
                        // ),

                        // child: IconButton(
                        //   alignment: Alignment.center,
                        //   icon: const Icon(Icons.arrow_drop_down),
                        //   color: Colors.black,
                        //   onPressed: () {
                        //     //spinner = true;
                        //    // child:
                        //     CustomDropdownButton(
                        //       value: _currentItems,
                        //       items: _dropDownMenuItems,
                        //       onChanged: changedDropDownItem,
                        //     );
                        //    setState(() {});
                        //   },
                        // ),


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
              ],
            ),
          ),
          Expanded(
            child: BuildProductsView(
              context: context,
              data: model.products,
              shouldSeeItem: false,
              showCreateItemOnTop: true,
              createButtonName: 'Add Products',
              userId: userId,
            ),
          ),
        ]),
      );
        // } else {
        //   return Container(
        //     child: Column(children: [
        //       Container(
        //         decoration: BoxDecoration(
        //             border: Border(
        //           // right: BorderSide(color: const Color(0xffc1c6cb)),
        //           bottom: BorderSide(color: const Color(0xffc1c6cb)),
        //           // right: BorderSide(color: const Color(0xffc1c6cb)),
        //         )),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Expanded(
        //               child: Container(
        //                 padding: EdgeInsets.only(left: 12),
        //                 child: InkWell(
        //                   onTap: () {
        //                     spinner = false;
        //                     setState(() {});
        //                   },
        //                   child: CustomDropdownButton(
        //                     value: _currentItems,
        //                     items: _dropDownMenuItems,
        //                     onChanged: changedDropDownItem,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //       Expanded(
        //         child: BuildProductsView(
        //           context: context,
        //           data: model.products,
        //           shouldSeeItem: false,
        //           showCreateItemOnTop: true,
        //           createButtonName: 'Add Products',
        //           userId: userId,
        //         ),
        //       ),
        //     ]),
        //   );
        // }
    } else {
      return Container(
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
                border: Border(
                  // right: BorderSide(color: const Color(0xffc1c6cb)),
                  bottom: BorderSide(color: const Color(0xffc1c6cb)),
                  // right: BorderSide(color: const Color(0xffc1c6cb)),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 12),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black26,
                      controller: etSearch,
                      onChanged: (value) => strSearch = value,
                      style: const TextStyle(
                        color: const Color(0xff3d454c),
                        fontSize: 15,
                        // fontFeatures: [
                        //   FontFeature.enable('sups'),
                        // ],
                      ),
                      decoration: const InputDecoration(
                        hintText: "Search All Items",
                        border: InputBorder.none,
                        hintStyle: const TextStyle(
                          color: Colors.black26,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: InkWell(
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
                ),
              ],
            ),
          ),
          Expanded(
            child: BuildProductsView(
              context: context,
              data: model.products,
              shouldSeeItem: false,
              showCreateItemOnTop: true,
              createButtonName: 'Add Products',
              userId: userId,
            ),
          ),
        ]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    etSearch = TextEditingController(text: strSearch);
    dropdownValue = 'All Items';
    _dropDownMenuItems = getDropDownMenuItems();

    return ViewModelBuilder.reactive(
        builder: (BuildContext context, ProductsViewModel model, Widget child) {
          return sellingModeView
              ? editModeView(model: model)
              : searchItems(model: model);
        },
        onModelReady: (ProductsViewModel model) {
          model.getProducts();
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
  final Logger log = Logging.getLogger('product view');
  final bool shouldSeeItem;
  final bool showCreateItemOnTop;
  final String userId;

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
        : Scaffold(
      backgroundColor: Theme
          .of(context)
          .copyWith(canvasColor: Colors.white)
          .canvasColor,
      body: Padding(
        padding: const EdgeInsets.all(0),
        child:
        //Column(children: <Widget>[
        ListView(
          shrinkWrap: true,
          children: buildProductList(
              model: viewModel,
              products: data,
              context: context,
              userId: userId,
              createButtonName: createButtonName,
              showCreateItemOnTop: showCreateItemOnTop,
              shouldSeeItem: shouldSeeItem)
              .toList(),
        ),
        // Container(
        //   height: 1,
        //   color: Colors.black26,
        // ),
        //]),
      ),
    );
  }
}
