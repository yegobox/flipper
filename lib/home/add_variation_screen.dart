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

class AddVariationScreen extends StatefulWidget {
  AddVariationScreen(
      {Key key,
      @required this.regularRetailPrice,
      @required this.regularCostPrice})
      : super(key: key);
  final double regularRetailPrice;
  final double regularCostPrice;

  @override
  _AddVariationScreenState createState() => _AddVariationScreenState();
}

class _AddVariationScreenState extends State<AddVariationScreen> {
  String name;
  String retailPrice;
  String costPrice;
  String sku;

  ActionsTableData _actions;
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        vm.database.actionsDao.getActionByStream('save').listen((event) {
          if (mounted) {
            setState(() {
              _actions = event[0];
            });
          }
        });
        return Scaffold(
          appBar: new CommonAppBar(
            title: S.of(context).addVariation,
            showActionButton: true,
            disableButton: _actions == null ? true : _actions.isLocked,
            actionButtonName: S.of(context).save,
            onPressedCallback: () async {
              await _createVariant(vm, context);
              Router.navigator.maybePop();
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
                    Center(
                      child: Container(
                        width: 400,
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      child: GestureDetector(
                        onTap: () {
                          Router.navigator.pushNamed(Router.addUnitType);
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0.3),
                          leading: Text(S.of(context).unityType),
                          trailing: Wrap(
                            children: <Widget>[
                              Text(vm.currentUnit != null
                                  ? vm.currentUnit.name
                                  : S.of(context).unityType),
                              Icon(Icons.arrow_forward_ios)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          validator: Validators.isStringHasMoreChars,
                          onChanged: (_name) {
                            if (_name == '') {
                              vm.database.actionsDao.updateAction(
                                  _actions.copyWith(isLocked: true));
                              return;
                            }
                            vm.database.actionsDao.updateAction(
                                _actions.copyWith(isLocked: false));

                            name = _name;
                          },
                          decoration: InputDecoration(
                            hintText: S.of(context).name,
                            focusColor: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    buildRetailPriceWidget(context),
                    buildCostPriceWidget(context),
                    Container(
                      width: 300,
                      child: TextFormField(
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
                    Text(S.of(context).leavePriceBlank)
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future _createVariant(CommonViewModel vm, BuildContext context) async {
    ItemTableData item = await vm.database.itemDao
        .getItemBy(name: 'tmp', branchId: vm.branch.id, itemId: vm.tmpItem.id);
    VariationTableData variation =
        await vm.database.variationDao.getVariationBy('tmp', vm.branch.id);
    final store = StoreProvider.of<AppState>(context);

    await Util.updateVariation(
      variation: variation,
      costPrice: widget.regularCostPrice,
      store: store,
      variantName: 'Regular',
      retailPrice: widget.regularRetailPrice,
    );
    int variantId = await vm.database.variationDao.insert(
      //ignore:missing_required_param
      VariationTableData(
        name: name,
        branchId: vm.branch.id,
        createdAt: DateTime.now(),
        isActive: false,
        itemId: item.id,
      ),
    );
    //insert into stock too
    vm.database.stockDao.insert(
      //ignore: missing_required_param
      StockTableData(
        canTrackStock: false,
        retailPrice: double.parse(retailPrice),
        itemId: item.id,
        costPrice: double.parse(costPrice),
        variantId: variantId,
        branchId: vm.branch.id,
        createdAt: DateTime.now(),
      ),
    );
    vm.database.actionsDao.updateAction(_actions.copyWith(isLocked: true));
  }

  Container buildCostPriceWidget(BuildContext context) {
    return Container(
      width: 300,
      child: TextFormField(
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.black),
        validator: Validators.isStringHasMoreChars,
        onChanged: (cost) {
          if (cost != '') {
            costPrice = cost;
          }
        },
        decoration: InputDecoration(
            hintText: S.of(context).costPrice, focusColor: Colors.blue),
      ),
    );
  }

  Container buildRetailPriceWidget(BuildContext context) {
    return Container(
      width: 300,
      child: TextFormField(
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.black),
        validator: Validators.isStringHasMoreChars,
        onChanged: (price) {
          if (price != '') {
            retailPrice = price;
          }
        },
        decoration: InputDecoration(
            hintText: S.of(context).retailPrice, focusColor: Colors.blue),
      ),
    );
  }
}
