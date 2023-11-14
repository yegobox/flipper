import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'add_customer_button.dart';
import 'order_summary_items.dart';

class PreviewSaleBottomSheet extends StatefulHookConsumerWidget {
  final bool reverse;

  const PreviewSaleBottomSheet({
    Key? key,
    this.reverse = false,
  }) : super(key: key);

  @override
  PreviewSaleBottomSheetState createState() => PreviewSaleBottomSheetState();
}

class PreviewSaleBottomSheetState
    extends ConsumerState<PreviewSaleBottomSheet> {
  final _routerService = locator<RouterService>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        final transactionItems = ref.watch(transactionItemsProvider);
        final saleCounts = transactionItems.value?.length;
        final totalPayable =
            ref.watch(transactionItemsProvider.notifier).totalPayable;
        return Material(
          child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              leading: SizedBox.shrink(),
              middle: Row(
                children: [
                  Text(
                    "Preview Sale ${saleCounts != 0 ? "($saleCounts)" : ""}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color.fromARGB(255, 17, 1, 1),
                    ),
                  ),
                ],
              ),
              trailing: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.close),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    reverse: widget.reverse,
                    shrinkWrap: true,
                    controller: ModalScrollController.of(context),
                    physics: const ClampingScrollPhysics(),
                    children: [
                      AddCustomerButton(
                        transactionId: model.kTransaction?.id ?? '0',
                      ),
                      ...buildItems(
                        context: context,
                        callback: (item) async {
                          model.kTransaction!.subTotal =
                              model.kTransaction!.subTotal -
                                  (item.price * item.qty);
                          await ProxyService.isar.update(
                            data: model.kTransaction,
                          );
                          model.deleteTransactionItem(
                            id: item.id,
                            context: context,
                          );
                        },
                        items: transactionItems.value ?? [],
                      ),
                      if (model.totalDiscount > 0)
                        ListTile(
                          contentPadding: const EdgeInsets.only(
                            left: 40.0,
                            right: 40.0,
                          ),
                          title: Text(
                            'Discounts',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Text(
                            '- RWF ' +
                                NumberFormat('#,###')
                                    .format(model.totalDiscount)
                                    .toString(),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 9.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: BoxButton(
                        title: "Collect ${totalPayable} RWF",
                        onTap: () {
                          model.kTransaction!.subTotal = totalPayable;
                          _routerService.navigateTo(
                            PaymentsRoute(
                              transaction: model.kTransaction!,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
