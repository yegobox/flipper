import 'package:flipper_models/isar_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stacked/stacked.dart';

import 'add_customer_button.dart';
import 'charge_button.dart';
import 'order_summary_items.dart';

class PreviewSaleBottomSheet extends StatefulWidget {
  final bool reverse;

  const PreviewSaleBottomSheet(
      {Key? key,
      this.reverse = false,
      required this.saleCount,
      required this.model})
      : super(key: key);
  final int saleCount;
  final BusinessHomeViewModel model;

  @override
  State<PreviewSaleBottomSheet> createState() => _PreviewSaleBottomSheetState();
}

class _PreviewSaleBottomSheetState extends State<PreviewSaleBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
          child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            leading: Container(),
            middle: Row(children: [
              Text("Current Sale(${widget.saleCount})",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black))
            ])),
        child: ViewModelBuilder<BusinessHomeViewModel>.reactive(
            viewModelBuilder: () => BusinessHomeViewModel(),
            onModelReady: (model) async {
              if (model.kOrder != null) {
                await model.setOrderItems();
              }
            },
            builder: (a, model, c) {
              return SafeArea(
                bottom: false,
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AddCustomerButton(orderId: model.kOrder!.id),
                      ListView(
                          reverse: widget.reverse,
                          shrinkWrap: true,
                          controller: ModalScrollController.of(context),
                          physics: const ClampingScrollPhysics(),
                          children: [
                            ...buildItems(
                                context: context,
                                model: widget.model,
                                items: model.items),
                            if (widget.model.totalDiscount > 0)
                              ListTile(
                                contentPadding: const EdgeInsets.only(
                                    left: 40.0, right: 40.0),
                                trailing: Text(
                                  '- RWF ' +
                                      display(widget.model.totalDiscount)
                                          .toString(),
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                                leading: Text(
                                  'Discounts',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                              ),
                          ]),
                      ChargeButton(
                        duePay: model.items.fold(0, (a, b) => a! + b.price),
                        model: model,
                      )
                    ],
                  ),
                ),
              );
            }),
      )),
    );
  }
}
