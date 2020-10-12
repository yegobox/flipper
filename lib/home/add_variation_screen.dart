import 'package:customappbar/customappbar.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/home/widget/add_product/section_select_unit.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/util/HexColor.dart';
import 'package:flipper/util/data_manager.dart';
import 'package:flipper/util/enums.dart';
import 'package:flipper/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

class AddVariationScreen extends StatefulWidget {
  const AddVariationScreen(
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
      builder: (BuildContext context, CommonViewModel vm) {
        vm.database.actionsDao.getActionByStream('save').listen((List<ActionsTableData> event) {
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
            title: 'Add Variation',
            showActionButton: true,
            disableButton: _actions == null ? true : _actions.isLocked,
            actionButtonName: 'Save',
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
                        child: const Divider(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SectionSelectUnit(),
                    Center(
                      child: Container(
                        width: 300,
                        child: TextFormField(
                          style: const TextStyle(color: Colors.black),
                          validator: Validators.isValid,
                          onChanged: (String _name) {
                            if (_name == '') {
                              vm.database.actionsDao.updateAction(
                                  _actions.copyWith(isLocked: true));
                              return;
                            }
                            vm.database.actionsDao.updateAction(
                                _actions.copyWith(isLocked: false));

                            name = _name;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Name',
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
                        onChanged: (String sku) {
                          if (sku == '' || sku == null) {
                            sku = DateTime.now().year.toString() +
                                Uuid().v1().substring(0, 4);
                          } else {
                            sku = DateTime.now().year.toString() +
                                sku.substring(0, 4);
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'SKU',
                            focusColor: HexColor('#0984e3')),
                      ),
                    ),
                    const Text('Leave the price blank to enter at the time of sale.')
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _createVariant(CommonViewModel vm, BuildContext context) async {
    final VariationTableData variation = await vm.database.variationDao
        .getVariationById(variantId: vm.variant.id);

    final Store<AppState> store = StoreProvider.of<AppState>(context);

    await DataManager.updateVariation(
      variation: variation,
      supplyPrice: widget.supplyPrice,
      store: store,
      variantName: 'Regular',
      retailPrice: widget.retailPrice,
    );
    final int variantId = await vm.database.variationDao.insert(
      //ignore:missing_required_param
      VariationTableData(
        isActive: false,
        name: name,
        id: Uuid().v1(),
        sku: DateTime.now().year.toString() + Uuid().v1().substring(0, 4),
        unit: '',
        createdAt: DateTime.now(),
        productId: vm.tmpItem.id,
      ),
    );
    final VariationTableData variant = await vm.database.variationDao
        .getVariationByIdLocal(variantId: variantId);

    await vm.database.stockDao.insert(
      //ignore:missing_required_param
      StockTableData(
        canTrackingStock: false,
        retailPrice: _retailPrice,
        supplyPrice: _supplyPrice,
        lowStock: 0,
        productId: vm.tmpItem.id,
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
        style: const TextStyle(color: Colors.black),
        validator: Validators.isValid,
        onChanged: (String supplyPrice) {
          if (supplyPrice != '') {
            setState(() {
              _supplyPrice = double.parse(supplyPrice);
            });
          }
        },
        decoration: const InputDecoration(
            hintText: 'Cost Price', focusColor: Colors.blue),
      ),
    );
  }

  Container buildRetailPriceWidget(BuildContext context) {
    return Container(
      width: 300,
      child: TextFormField(
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.black),
        validator: Validators.isValid,
        onChanged: (String price) {
          if (price != '') {
            setState(() {
              _retailPrice = double.parse(price);
            });
          }
        },
        decoration: const InputDecoration(
            hintText: 'Retail Price', focusColor: Colors.blue),
      ),
    );
  }
}
