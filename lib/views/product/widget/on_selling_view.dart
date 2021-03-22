import 'package:customappbar/Itemappbar.dart';
import 'package:flipper_models/product.dart';

// import 'package:flipper_services/locator.dart';
import 'package:flipper/views/product/widget/on_selling_viewmodal.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/variant_stock.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';

class OnSellingView extends StatefulWidget {
  const OnSellingView({Key key, this.product}) : super(key: key);
  final Product product;

  @override
  _onCreate createState() => _onCreate(product);
}

// ignore: camel_case_types
class _onCreate extends State<OnSellingView> {
  ForHere forHere = ForHere.lafayette;
  ToGo toGo = ToGo.lafayette;
  Delivery delivery = Delivery.lafayette;
  Pickup pick = Pickup.lafayette;
  Product product;

  // ignore: sort_constructors_first
  _onCreate(this.product);

  List<Widget> _productCategory({@required OnProductSellingViewModal model}) {
    final List<Widget> list = <Widget>[];

    for (VariantStock variation in model.variations) {
      list.add(SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 2.0, right: 2.0, top: 4.0),
            child: Column(
              children: [
                Divider(
                  color: Colors.grey[400],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        variation.name,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13.0,
                              color: Colors.grey[900]),
                        ),
                      ),
                    ),
                    Container(
                      child: Row(children: [
                        Container(
                          child: Text(
                            'Frw${variation.retailPrice?.toInt()}',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                  color: Colors.grey[500]),
                            ),
                          ),
                        ),
                        Container(
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
          padding: const EdgeInsets.only(left: 2.0, right: 2.0, top: 1.0),
          child: Column(
            children: [
              Divider(
                color: Colors.grey[400],
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
                            fontWeight: FontWeight.w900,
                            fontSize: 10.0,
                            color: Colors.grey[900]),
                      ),
                    ),
                  ),
                  const Expanded(flex: 2, child: Text('')),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: model.quantity <= 1
                        ? IconButton(
                            icon: const Icon(
                              AntDesign.minus,
                              color: Colors.grey,
                              size: 25,
                            ),
                            onPressed: model.decreaseQty,
                          )
                        : IconButton(
                            icon: const Icon(
                              AntDesign.minus,
                              color: Color(0xC9000000),
                              size: 25,
                            ),
                            onPressed: model.decreaseQty,
                          ),
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: Colors.grey[400],
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.only(left: 50, right: 50),
                        child: TextFormField(
                          style: TextStyle(
                            color: Theme.of(context)
                                .copyWith(canvasColor: Colors.grey[600])
                                .canvasColor,
                          ),
                          key: Key(model.quantity?.toInt().toString()),
                          initialValue: model.quantity?.toInt().toString(),
                          textAlign: TextAlign.center,
                          cursorColor: Theme.of(context)
                              .copyWith(canvasColor: const Color(0x3B000000))
                              .canvasColor,
                        ),
                      )),
                  Container(
                    width: 1,
                    height: 50,
                    color: Colors.grey[400],
                  ),
                  Container(
                    child: Container(
                      child: IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Color(0xC9000000),
                          size: 25,
                        ),
                        onPressed: model.increaseQty,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 3.0,
              ),
              Divider(
                color: Colors.grey[400],
              ),
              const SizedBox(
                height: 15.0,
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
              //                   fontWeight: FontWeight.w900,
              //                   fontSize: 11.0,
              //                   color: Colors.grey[900]))),
              //     ),
              //     const Expanded(flex: 2, child: Text('')),
              //   ],
              // ),
              // const SizedBox(
              //   height: 5.0,
              // ),
              // TextField(
              //   style: TextStyle(color: Colors.grey[900]),
              //   textAlign: TextAlign.left,
              //   cursorColor: Colors.black,
              //   decoration: InputDecoration(
              //       hintText: 'Add a note',
              //       hintStyle: TextStyle(
              //         fontSize: 14,
              //         color: Theme.of(context)
              //             .copyWith(canvasColor: Colors.grey[600])
              //             .canvasColor,
              //       )),
              // ),
              // const SizedBox(
              //   height: 25.0,
              // ),

              // Row(
              //   mainAxisSize: MainAxisSize.max,
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Expanded(
              //       flex: 1,
              //       child: Text('DINING OPTION',
              //           style: GoogleFonts.lato(
              //               textStyle: TextStyle(
              //             fontWeight: FontWeight.w900,
              //             fontSize: 11.0,
              //             color: Theme.of(context)
              //                 .copyWith(canvasColor: Colors.grey[800])
              //                 .canvasColor,
              //           ))),
              //     ),
              //     const Expanded(flex: 2, child: Text('')),
              //   ],
              // ),

              // const SizedBox(
              //   height: 8.0,
              // ),
              // Divider(
              //   color: Colors.grey[400],
              // ),
              // const SizedBox(
              //   height: 15.0,
              // ),
              // Row(
              //   mainAxisSize: MainAxisSize.max,
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              // Expanded(
              //   flex: 1,
              //   child: Text('For Here',
              //       style: GoogleFonts.lato(
              //           textStyle: TextStyle(
              //         fontWeight: FontWeight.w900,
              //         fontSize: 12.0,
              //         color: Theme.of(context)
              //             .copyWith(canvasColor: Colors.grey[800])
              //             .canvasColor,
              //       ))),
              // ),
              // Container(
              //   height: 10,
              //   child: Radio(
              //     toggleable: true,
              //     value: ForHere.lafayette,
              //     groupValue: forHere,
              //     onChanged: (ForHere value) {
              //       setState(() {
              //         forHere = value;
              //       });
              //     },
              //   ),
              // ),
              //   ],
              // ),

              // const SizedBox(
              //   height: 8.0,
              // ),
              // Divider(
              //   color: Colors.grey[400],
              // ),
              // const SizedBox(
              //   height: 15.0,
              // ),
              // Row(
              //   mainAxisSize: MainAxisSize.max,
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Expanded(
              //       flex: 1,
              //       child: Text('To GO',
              //           style: GoogleFonts.lato(
              //               textStyle: TextStyle(
              //             fontWeight: FontWeight.w900,
              //             fontSize: 12.0,
              //             color: Theme.of(context)
              //                 .copyWith(canvasColor: Colors.grey[800])
              //                 .canvasColor,
              //           ))),
              //     ),
              //     Container(
              //       height: 10,
              //       child: Radio(
              //         toggleable: true,
              //         value: ToGo.lafayette,
              //         groupValue: toGo,
              //         onChanged: (ToGo value) {
              //           setState(() {
              //             toGo = value;
              //           });
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 8.0,
              // ),
              // Divider(
              //   color: Colors.grey[400],
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
              //       child: Text('Delivery',
              //           style: GoogleFonts.lato(
              //               textStyle: TextStyle(
              //             fontWeight: FontWeight.w900,
              //             fontSize: 12.0,
              //             color: Theme.of(context)
              //                 .copyWith(canvasColor: Colors.grey[800])
              //                 .canvasColor,
              //           ))),
              //     ),
              //     Container(
              //       height: 10,
              //       child: Radio(
              //         toggleable: true,
              //         value: Delivery.lafayette,
              //         groupValue: delivery,
              //         onChanged: (Delivery value) {
              //           setState(() {
              //             delivery = value;
              //           });
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 8.0,
              // ),
              // Divider(
              //   color: Colors.grey[400],
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
              //       child: Text('Pickup',
              //           style: GoogleFonts.lato(
              //               textStyle: TextStyle(
              //             fontWeight: FontWeight.w900,
              //             fontSize: 12.0,
              //             color: Theme.of(context)
              //                 .copyWith(canvasColor: Colors.grey[800])
              //                 .canvasColor,
              //           ))),
              //     ),
              //     Container(
              //       height: 10,
              //       child: Radio(
              //         toggleable: true,
              //         value: Pickup.lafayette,
              //         groupValue: pick,
              //         onChanged: (Pickup value) {
              //           setState(() {
              //             pick = value;
              //           });
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 8.0,
              // ),
              // Divider(
              //   color: Colors.grey[400],
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
              //             fontWeight: FontWeight.w900,
              //             fontSize: 11.0,
              //             color: Theme.of(context)
              //                 .copyWith(canvasColor: Colors.grey[800])
              //                 .canvasColor,
              //           ))),
              //     ),
              //     const Expanded(flex: 2, child: Text('')),
              //   ],
              // ),
              // const SizedBox(
              //   height: 8.0,
              // ),
              // Divider(
              //   color: Colors.grey[400],
              // ),
              // Row(
              //   mainAxisSize: MainAxisSize.max,
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Expanded(
              //       flex: 2,
              //       child: Text('Abajama 0.04%',
              //           softWrap: true,
              //           style: GoogleFonts.lato(
              //               textStyle: TextStyle(
              //             fontWeight: FontWeight.w900,
              //             fontSize: 14.0,
              //             color: Theme.of(context)
              //                 .copyWith(canvasColor: Colors.grey[800])
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
              //   color: Colors.grey[400],
              // ),
              // Row(
              //   mainAxisSize: MainAxisSize.max,
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Expanded(
              //       flex: 2,
              //       child: Text('Real 0.1%',
              //           softWrap: true,
              //           style: GoogleFonts.lato(
              //               textStyle: TextStyle(
              //             fontWeight: FontWeight.w900,
              //             fontSize: 14.0,
              //             color: Theme.of(context)
              //                 .copyWith(canvasColor: Colors.grey[800])
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
              //   color: Colors.grey[400],
              // ),
              // const SizedBox(
              //   height: 10.0,
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
              appBar: Itemappbar(
                onPop: () {
                  ProxyService.nav.pop();
                },
                title: buildTitle(model),
                disableButton: false,
                showActionButton: true,
                onPressedCallback: () async {
                  model.saveOrder(
                      variationId: model.variations[0].id,
                      amount: model.amountTotal);
                  ProxyService.nav.pop();
                },
                actionButtonName: 'Add',
                icon: Icons.close,
                multi: 1,
                bottomSpacer: 49,
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
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                    color: Colors.grey[800]),
                              ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              '  CHOOSE ONE',
                              style: GoogleFonts.rubik(
                                textStyle: TextStyle(
                                    fontSize: 11.0, color: Colors.grey[700]),
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
    return product.name + ' Frw' + model.amountTotal?.toInt().toString();
  }
}

enum ForHere { lafayette, jefferson }
enum ToGo { lafayette, jefferson }
enum Delivery { lafayette, jefferson }
enum Pickup { lafayette, jefferson }
