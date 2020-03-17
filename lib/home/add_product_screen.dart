import 'package:customappbar/commonappbar.dart';
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
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/util/HexColor.dart';
import 'package:flipper/util/data_manager.dart';
import 'package:flipper/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AddProductScreen extends StatefulWidget {
  AddProductScreen({Key key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  ActionsTableData _actions;
  ActionsTableData _actionsSaveItem;

  _onClose(BuildContext context) async {
    Router.navigator.pop(true);
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
                onPressed: () => Router.navigator.pop(false),
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
                Router.navigator.pop();
              },
              title: S.of(context).createItem,
              disableButton: _actions == null ? true : _actions.isLocked,
              showActionButton: true,
              onPressedCallback: () async {
                await _handleCreateItem(vm);
                Router.navigator.pop(true);
              },
              actionButtonName: S.of(context).save,
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
                    GestureDetector(
                      onTap: () {
                        Router.navigator.pushNamed(Router.editItemTitle);
                      },
                      child: Container(
                        height: 80,
                        width: 80,
                        color: vm.currentColor != null
                            ? HexColor(vm.currentColor.hexCode)
                            : HexColor("#ee5253"),
                      ),
                    ),
                    Text(S.of(context).newItem),
                    //nameField
                    Center(
                      child: Container(
                        width: 300,
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          validator: Validators.isValid,
                          onChanged: (name) async {
                            await updateNameField(name, vm);
                          },
                          decoration: InputDecoration(
                              hintText: "Name", focusColor: Colors.black),
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
                        child: Text(S.of(context).priceAndInventory),
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
                    RetailPriceWidget(),
                    SupplyPriceWidget(),
                    SkuField(),
                    VariationList(productId: vm.tmpItem.id),
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

      Router.navigator.pushNamed(Router.addVariationScreen,
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
        productId: vm.tmpItem.id, categoryId: store.state.category.id, vm: vm);
    VariationTableData variation = await vm.database.variationDao
        .getVariationById(variantId: vm.variant.id);

    await DataManager.updateVariation(
      variation: variation,
      supplyPrice: DataManager.supplyPrice ?? 0.0,
      store: store,
      variantName: 'Regular',
      retailPrice: DataManager.retailPrice ?? 0.0,
    );

    await vm.couch.syncProduct(vm.tmpItem.id, store);

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
