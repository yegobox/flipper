import 'dart:io';

import 'package:customappbar/customappbar.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/home/widget/add_product/add_variant.dart';
import 'package:flipper/home/widget/add_product/category_section.dart';
import 'package:flipper/home/widget/add_product/center_divider.dart';
import 'package:flipper/home/widget/add_product/description_widget.dart';
import 'package:flipper/home/widget/add_product/list_divider.dart';
import 'package:flipper/home/widget/add_product/retail_price_widget.dart';
import 'package:flipper/home/widget/add_product/section_select_unit.dart';
import 'package:flipper/home/widget/add_product/sku_field.dart';
import 'package:flipper/home/widget/add_product/supply_price_widget.dart';
import 'package:flipper/home/widget/add_product/variation_list.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/theme.dart';
import 'package:flipper/util/HexColor.dart';
import 'package:flipper/util/data_manager.dart';
import 'package:flipper/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_services/stacked_services.dart';

class AddProductScreen extends StatefulWidget {
  AddProductScreen({Key key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  ActionsTableData _actions;
  ActionsTableData _actionsSaveItem;
  bool _isEmpty = true;
  bool _hasErrors = false;

  _onClose(BuildContext context) async {
    Routing.navigator.pop(true);
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Are you sure?',
              style: TextStyle(color: Colors.black),
            ),
            content: new Text(
              'Do you want to exit an App',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Routing.navigator.pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  _onClose(context);
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    DataManager.supplyPrice = 0;
    DataManager.retailPrice = 0;
  }

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            appBar: CommonAppBar(
              onPop: () {
                Routing.navigator.pop();
              },
              title: 'Create Item',
              disableButton: _actions == null ? true : _actions.isLocked,
              showActionButton: true,
              onPressedCallback: () async {
                await _handleCreateItem(vm);
                Routing.navigator.pop(true);
              },
              actionButtonName:'Save',
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 52,
            ),
            body: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    buildImageHolder(vm, context),
                    Text(
                      'New Item',
                      style: GoogleFonts.lato(
                        fontStyle: FontStyle.normal,
                        color: AppTheme.addProduct.accentColor,
                        fontSize:
                            AppTheme.addProduct.textTheme.bodyText1.fontSize,
                      ),
                    ),
                    //nameField
                    Center(
                      child: Container(
                        width: 300,
                        child: TextFormField(
                          style: GoogleFonts.lato(
                            fontStyle: FontStyle.normal,
                            color: AppTheme.addProduct.accentColor,
                            fontSize: AppTheme
                                .addProduct.textTheme.bodyText1.fontSize,
                          ),
                          validator: Validators.isValid,
                          onChanged: (name) async {
                            await updateNameField(name, vm);
                          },
                          decoration: InputDecoration(
                            hintText: 'Name',
                            focusColor: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    CategorySection(),
                    CenterDivider(
                      width: 300,
                    ),
                    ListDivider(
                      height: 24,
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        child: Text(
                          'PRICE AND INVENTORY',
                          style: GoogleFonts.lato(
                            fontStyle: FontStyle.normal,
                            color: AppTheme.addProduct.accentColor,
                            fontSize: AppTheme.addProduct.textTheme.bodyText1
                                .copyWith(fontSize: 12)
                                .fontSize,
                          ),
                        ),
                      ),
                    ),
                    CenterDivider(
                      width: 300,
                    ),
                    SectionSelectUnit(),
                    Center(
                      child: Container(
                        width: 300,
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    RetailPriceWidget(
                      vm: vm,
                    ),
                    SupplyPriceWidget(
                      vm: vm,
                    ),
                    SkuField(),
                    VariationList(productId: vm.tmpItem.productId),
                    AddVariant(
                      onPressedCallback: () {
                        createVariant(vm);
                      },
                    ),
                    DescriptionWidget()
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  GestureDetector buildImageHolder(CommonViewModel vm, BuildContext context) {
    return GestureDetector(
      onTap: () {
        final NavigationService _navigationService = locator<NavigationService>();
        _navigationService.navigateTo(Routing.editItemTitle,
            arguments: EditItemTitleArguments(productId: vm.tmpItem.productId));
      },
      child: !vm.tmpItem.hasPicture
          ? Container(
              height: 80,
              width: 80,
              color: vm.currentColor != null
                  ? HexColor(vm.currentColor.hexCode)
                  : HexColor('#ee5253'),
            )
          : vm.tmpItem.isImageLocal
              ? Stack(
                  children: <Widget>[
                    Container(
                      width: 80,
                      height: 80,
                      child: Image.file(
                        File(vm.tmpItem.picture),
                        frameBuilder: (BuildContext context, Widget child,
                            int frame, bool wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded) {
                            return child;
                          }
                          return AnimatedOpacity(
                            child: child,
                            opacity: frame == null ? 0 : 1,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeOut,
                          );
                        },
                        height: 80,
                        width: 80,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    buildCloseButton(context, vm)
                  ],
                )
              : Stack(
                  children: <Widget>[
                    Container(
                      width: 80,
                      height: 80,
                      child: Image.network(
                        vm.tmpItem.picture,
                        frameBuilder: (BuildContext context, Widget child,
                            int frame, bool wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded) {
                            return child;
                          }
                          return AnimatedOpacity(
                            child: child,
                            opacity: frame == null ? 0 : 1,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeOut,
                          );
                        },
                        height: 80,
                        width: 80,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    buildCloseButton(context, vm)
                  ],
                ),
    );
  }

  IconButton buildCloseButton(BuildContext context, CommonViewModel vm) {
    return IconButton(
      alignment: Alignment.topLeft,
      icon: Icon(Icons.close),
      color: Colors.white,
      onPressed: () async {
        final store = StoreProvider.of<AppState>(context);
        ProductTableData product = await store.state.database.productDao
            .getItemById(productId: vm.tmpItem.productId);
        store.state.database.productDao
            .updateProduct(product.copyWith(picture: '', hasPicture: false));

        ProductTableData updatedProduct = await store.state.database.productDao
            .getItemById(productId: vm.tmpItem.productId);

        DataManager.dispatchProduct(store, updatedProduct);
      },
    );
  }

  Future updateNameField(String name, CommonViewModel vm) async {
    if (name == '') {
      _getSaveStatus(vm);
      _getSaveItemStatus(vm);
      if (_actions != null) {
        await vm.database.actionsDao
            .updateAction(_actions.copyWith(isLocked: true));
        _getSaveStatus(vm);
        _getSaveItemStatus(vm);
      }
      setState(() {
        DataManager.name = name;
      });
    } else if (_actions != null) {
      await vm.database.actionsDao
          .updateAction(_actions.copyWith(isLocked: false));
      _getSaveStatus(vm);
      _getSaveItemStatus(vm);
      setState(() {
        DataManager.name = name;
      });
    } else {
      _getSaveStatus(vm);
      _getSaveItemStatus(vm);
      setState(() {
        DataManager.name = name;
      });
    }
  }

  void createVariant(CommonViewModel vm) {
    _getSaveStatus(vm);
    if (_actions != null) {
      vm.database.actionsDao.updateAction(_actions.copyWith(isLocked: true));
      final NavigationService _navigationService = locator<NavigationService>();

      _navigationService.navigateTo(Routing.addVariationScreen,
          arguments: AddVariationScreenArguments(
              retailPrice: DataManager.retailPrice,
              supplyPrice: DataManager.supplyPrice));
    }
  }

  void _getSaveItemStatus(CommonViewModel vm) async {
    var result = await vm.database.actionsDao.getActionBy('saveItem');
    setState(() {
      _actionsSaveItem = result;
    });
  }

  void _getSaveStatus(CommonViewModel vm) async {
    var result = await vm.database.actionsDao.getActionBy('save');

    setState(() {
      _actions = result;
    });
  }

  Future<bool> _handleCreateItem(CommonViewModel vm) async {
    final store = StoreProvider.of<AppState>(context);

    await updateProduct(
        productId: vm.tmpItem.productId,
        categoryId: store.state.category.id,
        vm: vm);
    VariationTableData variation = await vm.database.variationDao
        .getVariationById(variantId: vm.variant.id);

    await DataManager.updateVariation(
      variation: variation,
      supplyPrice: DataManager.supplyPrice ?? 0.0,
      store: store,
      variantName: 'Regular',
      retailPrice: DataManager.retailPrice ?? 0.0,
    );

    //todo: uncomment this soon.
    //await vm.couch.syncProduct(vm.tmpItem.productId, store);

    await resetSaveButtonStatus(vm);

    return true;
  }

  Future<bool> updateProduct(
      {CommonViewModel vm, String productId, String categoryId}) async {
    ProductTableData product =
        await vm.database.productDao.getProductById(productId: productId);
    await vm.database.productDao.updateProduct(
      product.copyWith(
        name: DataManager.name,
        categoryId: categoryId,
        updatedAt: DateTime.now(),
        deletedAt: 'null',
      ),
    );
    return true;
  }

  Future<bool> resetSaveButtonStatus(CommonViewModel vm) async {
    await vm.database.actionsDao
        .updateAction(_actionsSaveItem.copyWith(isLocked: true));

    await vm.database.actionsDao
        .updateAction(_actions.copyWith(isLocked: true));
    return true;
  }
}
