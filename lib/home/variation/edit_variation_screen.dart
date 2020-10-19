import 'package:customappbar/customappbar.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/home/variation/variation_viewmodel.dart';
import 'package:flipper/model/variation.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/utils/data_manager.dart';
import 'package:flipper/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';


class EditVariationScreen extends StatefulWidget {
  const EditVariationScreen(
      {Key key,
      @required this.variationId,
      @required this.productId,
      this.unitId})
      : super(key: key);
  final String variationId;
  final String unitId;
  final String productId;

  @override
  _EditVariationScreenState createState() => _EditVariationScreenState();
}

class _EditVariationScreenState extends State<EditVariationScreen> {
  String sku;

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
    return ViewModelBuilder.nonReactive(builder: (BuildContext context,VariationViewModel model, Widget child){
      return Scaffold(
              appBar: CommonAppBar(
                onPop: () {
                  Routing.navigator.pop();
                },
                title: 'Edit Variation',
                showActionButton: true,
                disableButton: model.isLocked,
                actionButtonName: 'Save',
                onPressedCallback: () async {
                  model.updateVariation(variation:model.variation);
                  ProxyService.nav.pop();
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
                          child:const Divider(
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          width: 300,
                          child: GestureDetector(
                            onTap: () {
                              // Routing.navigator.pushNamed(
                              //   Routing.addUnitType,
                              //   arguments: AddUnitTypeScreenArguments(
                              //     itemId: widget.productId,
                              //   ),
                              // );
                            },
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 0.3),
                              leading: Text('Unit Type'),
                              trailing: Wrap(
                                children: <Widget>[
                                   Text(
                                                  model.variation.name),
                                 const Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 300,
                          child: TextFormField(
                            initialValue: model.variation.name,
                            style: TextStyle(color: Colors.black),
                            validator: Validators.isEmpty,
                            onChanged: (name) {
                              if (name != '') {
                                _name = name;
                                updateVariation(model.variation, context);
                              }
                            },
                            decoration: InputDecoration(
                                hintText: 'Name',
                                focusColor: Colors.blue),
                          ),
                        ),
                        buildRetailPriceWidget(context, model),
                        buildCostPriceWidget(context, model),
                        Container(
                          width: 300,
                          child: TextFormField(
                            initialValue: model.variation.sku,
                            style: TextStyle(color: HexColor('#2d3436')),
                            validator: Validators.isValid,
                            onChanged: (String _sku) {
                              if (_sku != '') {
                                sku = _sku;
                              }
                            },
                            decoration: InputDecoration(
                                hintText: 'SKU',
                                focusColor: HexColor('#0984e3')),
                          ),
                        ),
                        const Text('Leave the price blank to enter at the time of sale.'),
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
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
    }, 
    onModelReady: (VariationViewModel model)=>model.getVariationById(productId: widget.productId,context:context),
    viewModelBuilder: ()=>VariationViewModel());
  }

 

  Center buildCostPriceWidget(BuildContext context, ViewModelBuilder vm) {
    return Center(
      child: Container(
        width: 300,
        child: StreamBuilder(
            stream: vm.database.stockDao.getStockByProductIdStream(
                branchId: vm.branch.id, productId: '001'),
            builder: (context, AsyncSnapshot<List<StockTableData>> snapshot) {
              if (snapshot.data == null) {
                return TextFormField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                  validator: Validators.isValid,
                  onChanged: (cost) {
                    if (cost != '') {
                      _costPrice = double.parse(cost);
                    }
                  },
                  decoration: InputDecoration(
                      hintText: 'Cost Price',
                      focusColor: Colors.blue),
                );
              } else {
                return Container(
                  width: 300,
                  child: TextFormField(
                    initialValue: model.variation.supplyPrice.toString(),
                    style: TextStyle(color: HexColor('#2d3436')),
                    validator: Validators.isValid,
                    onChanged: (cost) {
                      if (cost != '') {
                        _costPrice = double.parse(cost);
                      }
                    },
                    decoration: InputDecoration(
                        hintText: 'Cost Price',
                        focusColor: HexColor('#0984e3')),
                  ),
                );
              }
            }),
      ),
    );
  }

  Center buildRetailPriceWidget(BuildContext context,
      Variation snapshot, VariationViewModel model) {
    return Center(
      child: Container(
        width: 300,
        child: StreamBuilder(
            stream: vm.database.stockDao.getStockByProductIdStream(
                branchId: vm.branch.id, productId: '001'),
            builder: (context, AsyncSnapshot<List<StockTableData>> snapshot) {
              if (snapshot.data == null) {
                return TextFormField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                  validator: Validators.isValid,
                  onChanged: (price) {
                    if (price != '') {
                      _retailPrice = double.parse(price);
                    }
                  },
                  decoration: InputDecoration(
                      hintText: 'Retail Price',
                      focusColor: Colors.blue),
                );
              } else {
                return Container(
                  width: 300,
                  child: TextFormField(
                    initialValue: model.variation.retailPrice.toString(),
                    style: TextStyle(color: HexColor('#2d3436')),
                    validator: Validators.isValid,
                    onChanged: (price) {
                      if (price != '') {
                        _retailPrice = double.parse(price);
                      }
                    },
                    decoration: InputDecoration(
                        hintText: 'SKU',
                        focusColor: HexColor('#0984e3')),
                  ),
                );
              }
            }),
      ),
    );
  }

  void _closeAndDelete(BuildContext context) async {
    final store = StoreProvider.of<AppState>(context);
    // Util.deleteVariant(store, widget.variationId);
    Routing.navigator.pop(true);
  }
}
