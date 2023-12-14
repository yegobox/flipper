// import 'package:flipper_services/proxy.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
// import 'package:flipper_services/constants.dart';
// import 'package:flipper_services/app_service.dart';

// import 'package:flipper_dashboard/init_app.dart';
// // import 'package:flutter/services.dart';
// import 'dart:async';

// class FlipperApp extends StatefulHookConsumerWidget {
//   const FlipperApp({Key? key}) : super(key: key);

//   @override
//   FlipperAppState createState() => FlipperAppState();
// }

// class FlipperAppState extends ConsumerState<FlipperApp>
//     with WidgetsBindingObserver {
//   Future<void> _disableScreenshots() async {
//     if (!isDesktopOrWeb) {
//       await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
//     }
//   }

//   void initializeApplicationIfRequired() {
//     if (ProxyService.box.getBranchId() != null &&
//         ProxyService.box.getBusinessId() != null &&
//         ProxyService.box.getUserId() != null) {
//       InitApp.init();

//       try {
//         ProxyService.remote.listenToChanges();
//       } catch (e) {}
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     initializeApplicationIfRequired();
//     if (isAndroid && ProxyService.remoteConfig.enableTakingScreenShoot()) {
//       _disableScreenshots();
//     }
//   }

//   @override
//   void dispose() {
//     AppService.cleanedDataController.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Text("Hello world");
//   }
// }

import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'customappbar.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:easy_debounce/easy_debounce.dart';

enum ForHere { lafayette, jefferson }

enum ToGo { lafayette, jefferson }

enum Delivery { lafayette, jefferson }

enum Pickup { lafayette, jefferson }

class Sell extends StatefulHookConsumerWidget {
  Sell({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  SellState createState() => SellState();
}

class SellState extends ConsumerState<Sell> {
  final ForHere forHere = ForHere.lafayette;

  final ToGo toGo = ToGo.lafayette;

  final Delivery delivery = Delivery.lafayette;

  final Pickup pick = Pickup.lafayette;

  final TextEditingController quantityController =
      TextEditingController(text: "1");

  String buildTitle(CoreViewModel model) {
    if (model.amountTotal.toString() == 'null') {
      return widget.product.name;
    }
    if (model.amountTotal == 0) {
      return '';
    }
    return widget.product.name + ' Frw' + model.amountTotal.toInt().toString();
  }

  Widget Quantity(
      {required CoreViewModel model, required BuildContext context}) {
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
                              Icons.remove,
                              color: Colors.grey,
                              size: 25,
                            ),
                            onPressed: () {
                              model.decreaseQty((quantity) {
                                quantityController.text =
                                    model.quantity!.toInt().toString();
                              });
                            },
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.remove,
                              color: Color(0xC9000000),
                              size: 25,
                            ),
                            onPressed: () {
                              model.decreaseQty((quantity) {
                                quantityController.text =
                                    model.quantity!.toInt().toString();
                              });
                            },
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
                          controller: quantityController,
                          onChanged: (quantity) {
                            // EasyDebounce.debounce(
                            //   'model.debounceId',
                            //   Duration(milliseconds: 500),
                            //   () {
                            //     if (quantity != '0') {
                            //       quantityController.text = '1';
                            //     }
                            //     if (!quantity.isEmpty && quantity != '0') {
                            //       model.keypad.customQtyIncrease(
                            //           qty: int.parse(quantity));
                            //       model.keypad.setAmount(
                            //         amount:
                            //             model.currentItemStock!.retailPrice *
                            //                 int.parse(quantity),
                            //       );
                            //     }
                            //   },
                            // );
                          },
                          style: TextStyle(
                            color: Theme.of(context)
                                .copyWith(canvasColor: Colors.grey[600])
                                .canvasColor,
                          ),
                          key: Key(model.quantity.toInt().toString()),
                          // initialValue: model.quantity?.toInt().toString(),
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
                        onPressed: () {
                          model.increaseQty(
                              callback: (quantity) {
                                quantityController.text =
                                    model.quantity!.toInt().toString();
                              },
                              custom: false);
                        },
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

  List<Widget> variant({required CoreViewModel model}) {
    final List<Widget> list = <Widget>[];

    for (Variant variant in model.variants) {
      list.add(SingleChildScrollView(
        child: InkWell(
          onTap: () {
            //load stock of this variant
            model.loadVariantStock(variantId: variant.id!);
            model.keypad
                .setAmount(amount: variant.retailPrice * model.quantity);
            model.toggleCheckbox(variantId: variant.id!);
          },
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
                      FutureBuilder<Variant?>(
                          future: model.getVariant(variantId: variant.id!),
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? Expanded(
                                    child: Text(
                                      snapshot.data!.name,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13.0,
                                            color: Colors.grey[900]),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          }),
                      Container(
                        child: Row(children: [
                          Container(
                            child: Text(
                              'Frw${variant.retailPrice.toInt()}',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: Colors.grey[500]),
                              ),
                            ),
                          ),
                          Container(
                            child: Radio(
                              // toggleable: true,
                              value: variant.id!,
                              groupValue: model.checked,
                              onChanged: (value) {},
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
        ),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final currentTransaction = ref.watch(pendingTransactionProvider);
    return ViewModelBuilder<CoreViewModel>.reactive(
        onViewModelReady: (model) async {
          await model.getVariants(productId: widget.product.id);
        },
        viewModelBuilder: () => CoreViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(
              onPop: () {
                // _routerService.pop();
              },
              title: buildTitle(model),
              rightActionButtonName: 'Save',
              disableButton: false,
              showActionButton: true,
              onActionButtonClicked: () async {
                // await model.saveTransaction(
                //   variationId: model.checked,
                //   amountTotal: model.amountTotal,
                //   customItem: false,
                // );
                // _routerService.pop();
              },
              // actionButtonName: 'Add',
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
                            widget.product.name,
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
                        children: variant(model: model),
                      ),

                      // endloop  == start/and discounts
                      Quantity(context: context, model: model),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
