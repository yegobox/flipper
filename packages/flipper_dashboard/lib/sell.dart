import 'package:flipper_routing/routes.logger.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/models/models.dart';
import 'customappbar.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:overlay_support/overlay_support.dart';

enum ForHere { lafayette, jefferson }
enum ToGo { lafayette, jefferson }
enum Delivery { lafayette, jefferson }
enum Pickup { lafayette, jefferson }

class Sell extends StatefulWidget {
  const Sell({Key? key, required this.product}) : super(key: key);
  final ProductSync product;

  @override
  State<Sell> createState() => _SellState();
}

class _SellState extends State<Sell> {
  @override
  void initState() {
    super.initState();
  }

  final ForHere forHere = ForHere.lafayette;

  final ToGo toGo = ToGo.lafayette;

  final log = getLogger('Sell');

  final Delivery delivery = Delivery.lafayette;

  final Pickup pick = Pickup.lafayette;

  final TextEditingController quantityController =
      TextEditingController(text: "1");

  String buildTitle(BusinessHomeViewModel model) {
    if (model.amountTotal.toString() == 'null') {
      return widget.product.name;
    }
    if (model.amountTotal == 0) {
      return '';
    }
    return widget.product.name + ' Frw' + model.amountTotal.toInt().toString();
  }

  Widget Quantity(
      {required BusinessHomeViewModel model, required BuildContext context}) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 2.0, right: 2.0, top: 1.0),
        child: Column(
          children: [
            Divider(
              color: Colors.grey[400],
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
                        fontSize: 10,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
                ),
                const Expanded(flex: 2, child: Text('')),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: model.quantity <= 1
                      ? IconButton(
                          icon: Icon(
                            AntDesign.minus,
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
                          icon: Icon(
                            AntDesign.minus,
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
                          if (!quantity.isEmpty) {
                            model.customQtyIncrease(int.parse(quantity));
                          }
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
                        model.increaseQty((quantity) {
                          setState(() {
                            quantityController.text =
                                model.quantity!.toInt().toString();
                          });
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> Variants({required BusinessHomeViewModel model}) {
    final List<Widget> list = <Widget>[];

    for (VariantSync variant in model.variants) {
      list.add(SingleChildScrollView(
        child: InkWell(
          onTap: () {
            //load stock of this variant
            model.loadVariantStock(variantId: variant.id);
            model.handleCustomQtySetBeforeSelectingVariation();
            log.i(model.quantity);
            model.keypad
                .setAmount(amount: variant.retailPrice * model.quantity);
            model.toggleCheckbox(variantId: variant.id);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 2, right: 2.0, top: 4),
            child: Column(
              children: [
                Divider(
                  color: Colors.grey[400],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder<VariantSync?>(
                        future: model.getVariant(variantId: variant.id),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? Expanded(
                                  child: Text(
                                    snapshot.data!.name == 'Regular'
                                        ? snapshot.data!.productName +
                                            "(" +
                                            snapshot.data!.name +
                                            ")"
                                        : snapshot.data!.name,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: Colors.grey[900]),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink();
                        }),
                    Row(children: [
                      Text(
                        'Frw${variant.retailPrice.toInt()}',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.grey[500]),
                        ),
                      ),
                      Radio<int>(
                        // toggleable: true,
                        value: variant.id,
                        groupValue: model.checked,
                        onChanged: (value) {
                          model.toggleCheckbox(variantId: variant.id);
                          model.loadVariantStock(variantId: variant.id);
                          model.handleCustomQtySetBeforeSelectingVariation();
                          log.i(model.quantity);
                          model.keypad.setAmount(
                              amount: variant.retailPrice * model.quantity);
                          model.toggleCheckbox(variantId: variant.id);
                        },
                      ),
                    ]),
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

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
      onModelReady: (model) async {
        ///start by clearning the previous amountTotal and Quantity as it is confusing some time!
        model.clearPreviousSaleCounts();
        model.toggleCheckbox(variantId: -1);
        await model.getVariants(productId: widget.product.id);
      },
      viewModelBuilder: () => BusinessHomeViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            onPop: () {
              GoRouter.of(context).pop();
            },
            title: buildTitle(model),
            rightActionButtonName: 'Save',
            disableButton: false,
            showActionButton: true,
            onPressedCallback: () async {
              log.w(model.checked);
              //TODOcheck if model.checked is  chaning based on variation shoosed.
              bool saved = await model.saveOrder(
                variationId: model.checked,
                amount: model.amountTotal,
              );
              if (!saved) {
                showSimpleNotification(const Text('No item selected'),
                    background: Colors.red);
              }
              GoRouter.of(context).pop();
            },
            icon: Icons.close,
            multi: 1,
            bottomSpacer: 49,
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 30.0, 18.0, 2.0),
            child: CustomScrollView(slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.product.name,
                            style: GoogleFonts.rubik(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.grey[800]),
                            ),
                          ),
                          SizedBox(
                            height: 4,
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
                      Container(
                        height: 410,
                        child: ListView(
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          shrinkWrap: true,
                          children: Variants(model: model),
                        ),
                      ),
                    ],
                  )
                ]),
              ),
              // endloop  == start/and discounts
              // Quantity(context: context, model: model),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    child: Quantity(context: context, model: model),
                  ),
                ),
              )
            ]),
          ),
        );
      },
    );
  }
}
