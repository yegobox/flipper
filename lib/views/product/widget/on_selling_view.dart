import 'package:customappbar/customappbar.dart';
import 'package:flipper_models/product.dart';
// import 'package:flipper_services/locator.dart';
import 'package:flipper/views/product/widget/on_selling_viewmodal.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/variant_stock.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/shared_state_service.dart';

class OnSellingView extends StatelessWidget {
  const OnSellingView({Key key, this.product}) : super(key: key);
  final Product product;
  List<Widget> _productCategory({@required OnProductSellingViewModal model}) {
    final List<Widget> list = <Widget>[];
    if (model.busy) {
      return list;
    }

    for (VariantStock variation in model.variations) {
      list.add(SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Column(
              children: [
                Divider(
                  color: Colors.grey[300],
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        variation.name,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                              color: Colors.grey[800]),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(children: [
                        Expanded(
                          child: Text(
                            'Frw ${variation.retailPrice.toInt()}',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                  color: Colors.grey[800]),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Radio(
                            value: variation.retailPrice,
                            groupValue: model.checked,
                            onChanged: (double value) {
                              model.updateAmountTotalDefault(
                                  value: value, variant: variation);
                            },
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ));
    }
    return list;
  }

  Widget _quantityWidget(
      {OnProductSellingViewModal model, BuildContext context}) {
    // NOTE: [telesphore] in case of func parameter let's use the name parameter as it is much readable
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Divider(
                color: Colors.grey[300],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'QUANTITY',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11.0,
                            color: Colors.grey[800]),
                      ),
                    ),
                  ),
                  const Expanded(flex: 2, child: Text('')),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: const Icon(FontAwesome.minus),
                      onPressed: model.decreaseQty,
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                        child: TextFormField(
                          style: TextStyle(
                            color: Theme.of(context)
                                .copyWith(canvasColor: Colors.grey[700])
                                .canvasColor,
                          ),
                          key: Key(model.quantity.toInt().toString()),
                          initialValue: model.quantity.toInt().toString(),
                          textAlign: TextAlign.center,
                          cursorColor: Theme.of(context)
                              .copyWith(canvasColor: Colors.grey[700])
                              .canvasColor,
                          decoration: const InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      )),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: IconButton(
                        icon: const Icon(FontAwesome.plus),
                        onPressed: model.increaseQty,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey[300],
              ),
              const SizedBox(
                height: 20.0,
              ),
              //TODO: feature to implements in near future
              // Row(
              //   mainAxisSize: MainAxisSize.max,
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Expanded(
              //       flex: 1,
              //       child: Text('NOTES',
              //           style: GoogleFonts.lato(
              //               textStyle: TextStyle(
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 11.0,
              //                   color: Colors.grey[800]))),
              //     ),
              //     const Expanded(flex: 2, child: Text('')),
              //   ],
              // ),
              // TextField(
              //   style: TextStyle(color: Colors.grey[900]),
              //   textAlign: TextAlign.left,
              //   cursorColor: Colors.black,
              //   decoration: InputDecoration(
              //       hintText: 'Add a note',
              //       hintStyle: TextStyle(
              //         color: Theme.of(context)
              //             .copyWith(canvasColor: Colors.grey[600])
              //             .canvasColor,
              //       )),
              // ),
              // const SizedBox(
              //   height: 20.0,
              // ),
              // Row(
              //   mainAxisSize: MainAxisSize.max,
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Expanded(
              //       flex: 1,
              //       child: Text('DISCOUNTS',
              //           style: GoogleFonts.lato(
              //               textStyle: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             fontSize: 11.0,
              //             color: Theme.of(context)
              //                 .copyWith(canvasColor: Colors.grey[700])
              //                 .canvasColor,
              //           ))),
              //     ),
              //     const Expanded(flex: 2, child: Text('')),
              //   ],
              // ),
              // const SizedBox(
              //   height: 10.0,
              // ),
              // Divider(
              //   color: Colors.grey[300],
              // ),
              // Row(
              //   mainAxisSize: MainAxisSize.max,
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Expanded(
              //       flex: 2,
              //       child: Text('Abajama 0.005%',
              //           softWrap: true,
              //           style: GoogleFonts.lato(
              //               textStyle: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             fontSize: 14.0,
              //             color: Theme.of(context)
              //                 .copyWith(canvasColor: Colors.grey[600])
              //                 .canvasColor,
              //           ))),
              //     ),
              //     Expanded(
              //       flex: 1,
              //       child: Slider(
              //         value: model.slider,
              //         min: 0,
              //         max: 100,
              //         divisions: 1,
              //         onChanged: (double value) {
              //           model.slide(value: value);
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              // Divider(
              //   color: Colors.grey[300],
              // ),
              // end of future to implement in near future
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OnProductSellingViewModal>.reactive(
        builder: (BuildContext context, OnProductSellingViewModal model,
            Widget child) {
          return Container(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: CommonAppBar(
                onPop: () {
                  ProxyService.nav.pop();
                },
                title: buildTitle(model),
                disableButton: false,
                showActionButton: true,
                onPressedCallback: () async {
                  model.saveOrder();
                  // ProxyService.nav.pop();
                },
                actionButtonName: 'Save',
                icon: Icons.close,
                multi: 3,
                bottomSpacer: 52,
              ),
              body: Container(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18.0, 30.0, 18.0, 2.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              product.name,
                              style: GoogleFonts.rubik(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    color: Colors.grey[700]),
                              ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              ' CHOOSE ONE',
                              style: GoogleFonts.rubik(
                                textStyle: TextStyle(
                                    fontSize: 12.0, color: Colors.grey[700]),
                              ),
                            )
                          ],
                        ),

                        ListView(
                          shrinkWrap: true,
                          children: _productCategory(model: model),
                        ),

                        // endloop  == start/and discounts
                        _quantityWidget(context: context, model: model),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        onModelReady: (OnProductSellingViewModal model) {
          model.loadVariants(productId: product.id);
        },
        viewModelBuilder: () => OnProductSellingViewModal());
  }

  String buildTitle(OnProductSellingViewModal model) {
    if (model.amountTotal.toString() == 'null') {
      return product.name;
    }
    return product.name + ' FRW ' + model.amountTotal.toInt().toString();
  }
}
