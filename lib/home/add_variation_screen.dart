import 'package:customappbar/customappbar.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/home/widget/add_product/section_select_unit.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/util/HexColor.dart';
import 'package:flipper/util/data_manager.dart';
import 'package:flipper/util/enums.dart';
import 'package:flipper/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uuid/uuid.dart';

class AddVariationScreen extends StatefulWidget {
  AddVariationScreen(
      {Key key, @required this.retailPrice, @required this.supplyPrice})
      : super(key: key);
  final double retailPrice;
  final double supplyPrice;

  @override
  _AddVariationScreenState createState() => _AddVariationScreenState();
}

class _AddVariationScreenState extends State<AddVariationScreen> {
  String name;

  ActionsTableData _actions;

  double _retailPrice;

  double _supplyPrice;
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
          appBar: CommonAppBar(
            onPop: () {
              Routing.navigator.pop();
            },
            title: S.of(context).addVariation,
            showActionButton: true,
            disableButton: _actions == null ? true : _actions.isLocked,
            actionButtonName: S.of(context).save,
            onPressedCallback: () async {
              await _createVariant(vm, context);
              Routing.navigator.maybePop();
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
                    SectionSelectUnit(),
                    Center(
                      child: Container(
                        width: 300,
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          validator: Validators.isValid,
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
                        style: TextStyle(color: HexColor('#2d3436')),
                        validator: Validators.isValid,
                        onChanged: (sku) {
                          if (sku == '' || sku == null) {
                            sku = DateTime.now().year.toString() +
                                Uuid().v1().substring(0, 4);
                          } else {
                            sku = DateTime.now().year.toString() +
                                sku.substring(0, 4);
                          }
                        },
                        decoration: InputDecoration(
                            hintText: S.of(context).sKU,
                            focusColor: HexColor('#0984e3')),
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
    VariationTableData variation = await vm.database.variationDao
        .getVariationById(variantId: vm.variant.id);

    final store = StoreProvider.of<AppState>(context);

    await DataManager.updateVariation(
      variation: variation,
      supplyPrice: widget.supplyPrice,
      store: store,
      variantName: 'Regular',
      retailPrice: widget.retailPrice,
    );
    int variantId = await vm.database.variationDao.insert(
      //ignore:missing_required_param
      VariationTableData(
        isActive: false,
        name: name,
        id: Uuid().v1(),
        sku: DateTime.now().year.toString() + Uuid().v1().substring(0, 4),
        unit: '',
        createdAt: DateTime.now(),
        productId: vm.tmpItem.productId,
      ),
    );
    VariationTableData variant = await vm.database.variationDao
        .getVariationByIdLocal(variantId: variantId);

    await vm.database.stockDao.insert(
      //ignore:missing_required_param
      StockTableData(
        canTrackingStock: false,
        retailPrice: _retailPrice,
        supplyPrice: _supplyPrice,
        lowStock: 0,
        productId: vm.tmpItem.productId,
        showLowStockAlert: false,
        currentStock: 0,
        variantId: variant.id,
        isActive: true,
        action: Defaults.ADD.toString(),
        id: Uuid().v1(),
        branchId: vm.branch.id,
        createdAt: DateTime.now(),
      ),
    );
    await vm.database.actionsDao
        .updateAction(_actions.copyWith(isLocked: true));
  }

  Container buildCostPriceWidget(BuildContext context) {
    return Container(
      width: 300,
      child: TextFormField(
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.black),
        validator: Validators.isValid,
        onChanged: (supplyPrice) {
          if (supplyPrice != '') {
            setState(() {
              _supplyPrice = double.parse(supplyPrice);
            });
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
        validator: Validators.isValid,
        onChanged: (price) {
          if (price != '') {
            setState(() {
              _retailPrice = double.parse(price);
            });
          }
        },
        decoration: InputDecoration(
            hintText: S.of(context).retailPrice, focusColor: Colors.blue),
      ),
    );
  }
}
