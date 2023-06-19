import 'package:flipper_dashboard/charge_button.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'add_customer_button.dart';
import 'order_summary_items.dart';

class PreviewSaleBottomSheet extends StatefulWidget {
  final bool reverse;

  const PreviewSaleBottomSheet(
      {Key? key, this.reverse = false, required this.model})
      : super(key: key);
  final HomeViewModel model;

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
              StreamBuilder<List<OrderItem>>(
                  stream: ProxyService.isar.orderItemsStream(),
                  builder: (context, snapshot) {
                    final orderItems = snapshot.data ??
                        []; // Retrieve the data from the stream
                    final saleCounts = orderItems
                        .length; // Calculate the saleCounts based on the orderItems

                    return Text(
                      "Preview Sale${saleCounts != 0 ? "($saleCounts)" : ""}",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: const Color(0xffFFFFFF),
                      ),
                    );
                  })
            ])),
        child: ViewModelBuilder<HomeViewModel>.reactive(
            viewModelBuilder: () => HomeViewModel(),
            builder: (a, model, c) {
              return SafeArea(
                bottom: false,
                child: StreamBuilder<List<OrderItem>>(
                    stream: ProxyService.isar.orderItemsStream(),
                    builder: (context, snapshot) {
                      final orderItems = snapshot.data ?? [];
                      return Column(
                        children: [
                          Expanded(
                            child: ListView(
                              reverse: widget.reverse,
                              shrinkWrap: true,
                              controller: ModalScrollController.of(context),
                              physics: const ClampingScrollPhysics(),
                              children: [
                                AddCustomerButton(orderId: model.kOrder!.id!),
                                ...buildItems(
                                  context: context,
                                  callback: (item) async {
                                    model.kOrder!.subTotal =
                                        model.kOrder!.subTotal -
                                            (item.price * item.qty);
                                    await ProxyService.isar
                                        .update(data: model.kOrder);
                                    model.deleteOrderItem(
                                        id: item.id, context: context);
                                  },
                                  items: orderItems,
                                ),
                                if (widget.model.totalDiscount > 0)
                                  ListTile(
                                    contentPadding: const EdgeInsets.only(
                                        left: 40.0, right: 40.0),
                                    trailing: Text(
                                      '- RWF ' +
                                          NumberFormat('#,###')
                                              .format(
                                                  widget.model.totalDiscount)
                                              .toString(),
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                    leading: Text(
                                      'Discounts',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 60.0),
                            child: Container(
                              child: ChargeButton(
                                duePay: orderItems.fold(
                                    0, (a, b) => a! + (b.price * b.qty)),
                                model: model,
                              ),
                            ),
                          )
                        ],
                      );
                    }),
              );
            }),
      )),
    );
  }
}
