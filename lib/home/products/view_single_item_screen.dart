import 'package:customappbar/customappbar.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/home/widget/add_product/variation_list.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/util/HexColor.dart';
import 'package:flipper/util/data_manager.dart';
import 'package:flipper/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class TForm {
  String price;
  String sku;
  String description;
  String name;
}

class ViewSingleItemScreen extends StatefulWidget {
  ViewSingleItemScreen({
    Key key,
    @required this.productId,
    @required this.itemName,
    @required this.itemColor,
  }) : super(key: key);
  final String productId;

  final String itemName;
  final String itemColor;

  @override
  _ViewSingleItemScreenState createState() => _ViewSingleItemScreenState();
}

class _ViewSingleItemScreenState extends State<ViewSingleItemScreen> {
  final TForm tForm = new TForm();

  ActionsTableData _actions;

  String _name;

  int _deleteCount;

  List<bool> _selections = List.generate(2, (index) => false);

  _closeAndDelete(BuildContext context) async {
    final store = StoreProvider.of<AppState>(context);
    await DataManager.deleteProduct(store: store, productId: widget.productId);
    Router.navigator.pop();
  }

  Future<bool> _onWillPop() async {
    Router.navigator.pop(true);
    return true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _name = widget.itemName;
      _deleteCount = 0;
    });
    _getSaveStatus();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return StreamBuilder(
            stream: vm.database.variationDao
                .getVariationByItemIdStream(widget.productId),
            builder:
                (context, AsyncSnapshot<List<VariationTableData>> snapshot) {
              if (snapshot.data == null) {
                return Text('');
              }

              return WillPopScope(
                onWillPop: _onWillPop,
                child: Scaffold(
                  appBar: CommonAppBar(
                    onPop: () {
                      Router.navigator.pop();
                    },
                    title: S.of(context).editItem,
                    disableButton: _actions == null ? true : _actions.isLocked,
                    showActionButton: true,
                    onPressedCallback: () async {
                      _handleEditItem(vm);
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
                                color: HexColor(vm.currentColor == null
                                    ? widget.itemColor
                                    : vm.currentColor.hexCode)),
                          ),
                          Text(S.of(context).newItem),
                          Center(
                            child: Container(
                              width: 300,
                              child: TextFormField(
                                initialValue: widget.itemName,
                                style: TextStyle(
                                    color: Colors
                                        .black), //TODO(richard): move this to app theme
                                validator: Validators.isValid,
                                onChanged: (name) async {
                                  if (name == '') {
                                    setState(() {
                                      _name = null;
                                    });
                                    _getSaveStatus();

                                    return;
                                  }
                                  setState(() {
                                    _name = name;
                                  });
                                  _getSaveStatus();

                                  tForm.name = name;
                                },
                                decoration: InputDecoration(
                                    hintText: 'Name', focusColor: Colors.black),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: 300,
                              child: GestureDetector(
                                onTap: () {
                                  Router.navigator.pushNamed(
                                    Router.editCategoryScreen,
                                    arguments: EditCategoryScreenArguments(
                                      productId: widget.productId,
                                    ),
                                  );
                                },
                                child: ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 0.3),
                                  leading: Text(S.of(context).category),
                                  trailing: Wrap(
                                    children: <Widget>[
                                      StreamBuilder(
                                        stream: vm.database.productDao
                                            .getItemByIdStream(
                                                widget.productId),
                                        builder: (context,
                                            AsyncSnapshot<
                                                    List<ProductTableData>>
                                                snapshot) {
                                          if (snapshot.data == null ||
                                              snapshot.data.length == 0) {
                                            return Text(
                                                S.of(context).selectCategory);
                                          }
                                          return snapshot.data == null ||
                                                  snapshot.data.length == 0
                                              ? Text(
                                                  S.of(context).selectCategory)
                                              : categorySelector(
                                                  snapshot.data, vm);
                                        },
                                      ),
                                      Icon(Icons.arrow_forward_ios)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: 300,
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            height: 24,
                          ),
                          Center(
                            child: Container(
                              width: 300,
                              child: Text(S.of(context).priceAndInventory),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: 300,
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: 300,
                              child: GestureDetector(
                                onTap: () {
                                  Router.navigator.pushNamed(
                                      Router.editUnitType,
                                      arguments: EditUnitTypeScreenArguments(
                                          itemId: widget.productId));
                                },
                                child: ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 0.3),
                                  leading: Text(S.of(context).unityType),
                                  trailing: Wrap(
                                    children: <Widget>[
                                      StreamBuilder(
                                          stream: vm.database.productDao
                                              .getItemByIdStream(
                                                  widget.productId),
                                          builder: (context,
                                              AsyncSnapshot<
                                                      List<ProductTableData>>
                                                  item) {
                                            if (item.data == null) {
                                              return Text('');
                                            }
                                            if (item.data.length == 0) {
                                              return Text('');
                                            }

                                            return StreamBuilder(
                                                stream: vm.database.unitDao
                                                    .getUnitStream(
                                                        item.data[0].idLocal),
                                                builder: (context,
                                                    AsyncSnapshot<
                                                            List<UnitTableData>>
                                                        unit) {
                                                  if (unit.data == null) {
                                                    return Text('');
                                                  }
                                                  return Text(
                                                      unit.data[0].name);
                                                });
                                          }),
                                      Icon(Icons.arrow_forward_ios)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CustomDivider(),
                          VariationList(
                            productId: widget.productId,
                          ),
                          Center(
                            child: SizedBox(
                              height: 50,
                              width: 340,
                              child: OutlineButton(
                                color: HexColor('#ecf0f1'),
                                child: Text(S.of(context).addVariation),
                                onPressed: () async {
                                  _getSaveStatus();
                                  if (_actions != null) {
                                    vm.database.actionsDao.updateAction(
                                        _actions.copyWith(isLocked: true));

                                    Router.navigator
                                        .pushNamed(Router.addVariationScreen);
                                  }
                                },
                              ),
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.fromLTRB(40, 10, 40, 0),
                            trailing: ToggleButtons(
                              children: <Widget>[
                                Text('18%'),
                                Text('0%'),
                              ],
                              isSelected: _selections,
                              onPressed: (int index) {
                                setState(() {
                                  _selections[index] = !_selections[index];
                                });
                              },
                            ),
                            leading: Text('Tax'),
                          ),
                          Container(
                            height: 20,
                          ),
                          Container(
                            height: 50,
                            color: _deleteCount == 1
                                ? Colors.redAccent[700]
                                : Colors.white,
                            width: 340,
                            child: OutlineButton(
                              onPressed: () {
                                setState(() {
                                  _deleteCount += 1;
                                });
                                if (_deleteCount == 2) {
                                  _closeAndDelete(context);
                                }
                              },
                              child: Text('Delete Item',
                                  style: TextStyle(
                                      color: _deleteCount == 1
                                          ? Colors.white
                                          : Colors.black)),
                            ),
                          ),
                          Container(
                            height: 64,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  void _getSaveStatus() async {
    var result = await StoreProvider.of<AppState>(context)
        .state
        .database
        .actionsDao
        .getActionBy('save');

    if (_name == null) {
      await StoreProvider.of<AppState>(context)
          .state
          .database
          .actionsDao
          .updateAction(result.copyWith(isLocked: true));
    } else {
      await StoreProvider.of<AppState>(context)
          .state
          .database
          .actionsDao
          .updateAction(result.copyWith(isLocked: false));
    }
    var res = await StoreProvider.of<AppState>(context)
        .state
        .database
        .actionsDao
        .getActionBy('save');
    setState(() {
      _actions = res;
    });
  }

  Widget categorySelector(List<ProductTableData> item, CommonViewModel vm) {
    return StreamBuilder(
        stream:
            vm.database.categoryDao.getCategoryByIdStream(item[0].categoryId),
        builder: (context, AsyncSnapshot<List<CategoryTableData>> snapshot) {
          if (snapshot.data == null) {
            return Text('');
          }
          return Text(snapshot.data[0].name);
        });
  }

  _handleEditItem(CommonViewModel vm) async {
    TaxTableData tax;
    final store = StoreProvider.of<AppState>(context);
    if (_selections[0] == true) {
      //then use 18 % known id in database. 0 index we know it is 18% 0 otherwise
      tax = await store.state.database.taxDao.getByName(
          name: 'Vat', businessId: store.state.currentActiveBusiness.id);
    }
    ProductTableData product =
        await vm.database.productDao.getItemById(productId: widget.productId);

    vm.database.actionsDao.updateAction(_actions.copyWith(isLocked: true));

    vm.database.productDao.updateProduct(
      product.copyWith(
        taxId: tax.id ?? product.taxId,
        name: _name ?? product.name,
        updatedAt: DateTime.now(),
      ),
    );
    await store.state.couch.syncLocalToRemote(store: store);
    Router.navigator.pop();
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        child: Divider(
          color: Colors.black,
        ),
      ),
    );
  }
}
