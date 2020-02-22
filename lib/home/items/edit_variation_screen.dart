import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/presentation/common/common_app_bar.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/util/HexColor.dart';
import 'package:flipper/util/util.dart';
import 'package:flipper/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class EditVariationScreen extends StatefulWidget {
  EditVariationScreen(
      {Key key, @required this.variationId, @required this.itemId, this.unitId})
      : super(key: key);
  final int variationId;
  final int unitId;
  final int itemId;

  @override
  _EditVariationScreenState createState() => _EditVariationScreenState();
}

class _EditVariationScreenState extends State<EditVariationScreen> {
  String sku;

  ActionsTableData _actions;
  // ignore: unused_field
  double _costPrice;
  String _name;

  // ignore: unused_field
  double _retailPrice;
  int _deleteCount;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _deleteCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return StreamBuilder(
          stream: vm.database.variationDao
              .getVariantByItemIdStream(widget.variationId),
          builder: (context, AsyncSnapshot<List<VariationTableData>> snapshot) {
            if (snapshot.data == null) {
              return Text("");
            }

            return Scaffold(
              appBar: new CommonAppBar(
                title: S.of(context).editVariation,
                showActionButton: true,
                disableButton: snapshot.data[0].name == '' ? true : false,
                actionButtonName: S.of(context).save,
                onPressedCallback: () async {
                  updateVariation(snapshot.data[0], context);
                  Router.navigator.pop(true);
                },
                icon: Icons.close,
                multi: 3,
                bottomSpacer: 52,
              ),
              body: Container(
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          height: 20,
                        ),
                        Container(
                          width: 400,
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          width: 300,
                          child: GestureDetector(
                            onTap: () {
                              Router.navigator.pushNamed(
                                Router.addUnitType,
                                arguments: AddUnitTypeScreenArguments(
                                  itemId: widget.itemId,
                                ),
                              );
                            },
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 0.3),
                              leading: Text(S.of(context).unityType),
                              trailing: Wrap(
                                children: <Widget>[
                                  StreamBuilder(
                                      stream: vm.database.itemDao
                                          .getItemByIdStream(widget.itemId),
                                      builder: (context,
                                          AsyncSnapshot<List<ItemTableData>>
                                              snapshot) {
                                        if (snapshot.data == null) {
                                          return Text("None");
                                        }
                                        return StreamBuilder(
                                            stream: vm.database.unitDao
                                                .getUnitByIdStream(
                                                    snapshot.data[0].unitId),
                                            builder: (context,
                                                AsyncSnapshot<
                                                        List<UnitTableData>>
                                                    snapshot) {
                                              if (snapshot.data == null) {
                                                return Text("");
                                              }
                                              return Text(
                                                  snapshot.data[0].name);
                                            });
                                      }),
                                  Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 300,
                          child: TextFormField(
                            initialValue: snapshot.data[0].name,
                            style: TextStyle(color: Colors.black),
                            validator: Validators.isEmpty,
                            onChanged: (name) {
                              if (name != '') {
                                _name = name;
                                updateVariation(snapshot.data[0], context);
                              }
                            },
                            decoration: InputDecoration(
                                hintText: S.of(context).name,
                                focusColor: Colors.blue),
                          ),
                        ),
                        buildRetailPriceWidget(context, snapshot, vm),
                        buildCostPriceWidget(context, vm),
                        Container(
                          width: 300,
                          child: TextFormField(
                            initialValue: snapshot.data[0].sku,
                            style: TextStyle(color: HexColor("#2d3436")),
                            validator: Validators.isStringHasMoreChars,
                            onChanged: (_sku) {
                              if (_sku != '') {
                                sku = _sku;
                              }
                            },
                            decoration: InputDecoration(
                                hintText: S.of(context).sKU,
                                focusColor: HexColor("#0984e3")),
                          ),
                        ),
                        Text(S.of(context).leavePriceBlank),
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
                            child: Text("Delete Item",
                                style: TextStyle(
                                    color: _deleteCount == 1
                                        ? Colors.white
                                        : Colors.black)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> updateVariation(
      VariationTableData variation, BuildContext context) async {
    final store = StoreProvider.of<AppState>(context);
    double retailPrice = _retailPrice ?? null;
    double costPrice = _costPrice ?? null;
    String variantName = _name ?? variation.name;

    await Util.updateVariation(
      costPrice: costPrice,
      retailPrice: retailPrice,
      variation: variation,
      variantName: variantName,
      store: store,
    );
  }

  Center buildCostPriceWidget(BuildContext context, CommonViewModel vm) {
    return Center(
      child: Container(
        width: 300,
        child: StreamBuilder(
            stream: vm.database.stockDao.getStockByVariantIdStream(
                branchId: vm.branch.id, variantId: widget.variationId),
            builder: (context, AsyncSnapshot<List<StockTableData>> snapshot) {
              if (snapshot.data == null) {
                return TextFormField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                  validator: Validators.isStringHasMoreChars,
                  onChanged: (cost) {
                    if (cost != '') {
                      _costPrice = double.parse(cost);
                    }
                  },
                  decoration: InputDecoration(
                      hintText: S.of(context).costPrice,
                      focusColor: Colors.blue),
                );
              } else {
                return Container(
                  width: 300,
                  child: TextFormField(
                    initialValue: snapshot.data[0].costPrice.toString(),
                    style: TextStyle(color: HexColor("#2d3436")),
                    validator: Validators.isStringHasMoreChars,
                    onChanged: (cost) {
                      if (cost != '') {
                        _costPrice = double.parse(cost);
                      }
                    },
                    decoration: InputDecoration(
                        hintText: S.of(context).sKU,
                        focusColor: HexColor("#0984e3")),
                  ),
                );
              }
            }),
      ),
    );
  }

  Center buildRetailPriceWidget(BuildContext context,
      AsyncSnapshot<List<VariationTableData>> snapshot, CommonViewModel vm) {
    return Center(
      child: Container(
        width: 300,
        child: StreamBuilder(
            stream: vm.database.stockDao.getStockByVariantIdStream(
                branchId: vm.branch.id, variantId: widget.variationId),
            builder: (context, AsyncSnapshot<List<StockTableData>> snapshot) {
              if (snapshot.data == null) {
                return TextFormField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                  validator: Validators.isStringHasMoreChars,
                  onChanged: (price) {
                    if (price != '') {
                      _retailPrice = double.parse(price);
                    }
                  },
                  decoration: InputDecoration(
                      hintText: S.of(context).retailPrice,
                      focusColor: Colors.blue),
                );
              } else {
                return Container(
                  width: 300,
                  child: TextFormField(
                    initialValue: snapshot.data[0].retailPrice.toString(),
                    style: TextStyle(color: HexColor("#2d3436")),
                    validator: Validators.isStringHasMoreChars,
                    onChanged: (price) {
                      if (price != '') {
                        _retailPrice = double.parse(price);
                      }
                    },
                    decoration: InputDecoration(
                        hintText: S.of(context).sKU,
                        focusColor: HexColor("#0984e3")),
                  ),
                );
              }
            }),
      ),
    );
  }

  void _closeAndDelete(BuildContext context) async {
    final store = StoreProvider.of<AppState>(context);
    Util.deleteVariant(store, widget.variationId);
    Router.navigator.pop(true);
  }
}
