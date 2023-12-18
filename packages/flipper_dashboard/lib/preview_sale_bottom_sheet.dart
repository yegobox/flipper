// ignore_for_file: unused_result

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
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

  const PreviewSaleBottomSheet({
    Key? key,
    this.reverse = false,
    this.mode = SellingMode.forSelling,
  }) : super(key: key);

  @override
  PreviewSaleBottomSheetState createState() => PreviewSaleBottomSheetState();
}

class PreviewSaleBottomSheetState
    extends ConsumerState<PreviewSaleBottomSheet> {
  final _routerService = locator<RouterService>();
  final _numberFormat = NumberFormat.currency(
    locale: 'en', // e.g., 'en_US' for English (United States)
    symbol: ' RWF',
  );
  late final transactionProvider =
      pendingTransactionProvider(TransactionType.custom);

  @override
  Widget build(BuildContext context) {
    final transaction = ref.watch(transactionProvider);
    final transactionItemsNotifier = ref
        .watch(transactionItemsProvider(transaction.value?.value?.id).notifier);

    final totalPayable = transactionItemsNotifier.totalPayable;

    transactionItemsNotifier.updatePendingTransaction();

    return ViewModelBuilder<CoreViewModel>.nonReactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            widget.mode == SellingMode.forSelling
                ? AddCustomerButton(transactionId: transaction.value?.value?.id)
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
                    await ProxyService.isar.update(data: transaction);
                    model.deleteTransactionItem(
                      id: item.id,
                      context: context,
                    );
                    ref.refresh(
                      transactionItemsProvider(transaction.value?.value?.id),
                    );
                  },
                  items: ref
                      .watch(
                        transactionItemsProvider(transaction.value?.value?.id),
                      )
                      .value!,
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
                      '- RWF ' + _numberFormat.format(model.totalDiscount),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: BoxButton(
                title: widget.mode == SellingMode.forSelling
                    ? "Collect ${_numberFormat.format(totalPayable)} "
                    : "Order ${_numberFormat.format(totalPayable)} ",
                onTap: () async {
                  final transaction = await ProxyService.isar.manageTransaction(
                    transactionType: TransactionType.custom,
                  );
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
