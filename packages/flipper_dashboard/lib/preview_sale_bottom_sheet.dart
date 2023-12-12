// ignore_for_file: unused_result

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'add_customer_button.dart';
import 'order_summary_items.dart';

class PreviewSaleBottomSheet extends StatefulHookConsumerWidget {
  final bool reverse;
  final SellingMode mode;
  const PreviewSaleBottomSheet(
      {Key? key, this.reverse = false, this.mode = SellingMode.forSelling})
      : super(key: key);

  @override
  PreviewSaleBottomSheetState createState() => PreviewSaleBottomSheetState();
}

class PreviewSaleBottomSheetState
    extends ConsumerState<PreviewSaleBottomSheet> {
  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.nonReactive(
      viewModelBuilder: () => CoreViewModel(
          transaction: ref
              .watch(pendingTransactionProvider(ProxyService.box.getBranchId()))
              .value
              ?.value),
      builder: (context, model, child) {
        final totalPayable =
            ref.watch(transactionItemsProvider.notifier).totalPayable;
        ref.read(transactionItemsProvider.notifier).updatePendingTransaction();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            widget.mode == SellingMode.forSelling
                ? AddCustomerButton(transactionId: model.currentTransaction!.id)
                : SizedBox.shrink(),
            ListView(
              reverse: widget.reverse,
              shrinkWrap: true,
              controller: ModalScrollController.of(context),
              physics: const ClampingScrollPhysics(),
              children: [
                ...buildItems(
                  context: context,
                  callback: (item) async {
                    model.currentTransaction!.subTotal =
                        model.currentTransaction!.subTotal;
                    await ProxyService.isar.update(
                      data: model.currentTransaction,
                    );
                    model.deleteTransactionItem(
                      id: item.id,
                      context: context,
                    );
                    ref.refresh(transactionItemsProvider);
                  },
                  items: ref.watch(transactionItemsProvider),
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
            Spacer(),
            Padding(
              padding: EdgeInsets.all(8),
              child: BoxButton(
                title: widget.mode == SellingMode.forSelling
                    ? "Collect ${NumberFormat('#,###').format(totalPayable)} RWF"
                    : "Order ${NumberFormat('#,###').format(totalPayable)} RWF",
                onTap: () async {
                  final transaction =
                      await ProxyService.isar.manageTransaction();
                  _routerService.navigateTo(
                    PaymentsRoute(
                      transaction: transaction,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
