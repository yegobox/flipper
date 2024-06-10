// ignore_for_file: unused_result

import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import '../add_customer_button.dart';

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

  Widget buildItem({
    required Function(TransactionItem) delete,
    required BuildContext context,
    required TransactionItem items,
  }) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Slidable(
        key: ValueKey(items.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => delete(items),
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => delete(items),
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 40.0, right: 40.0),
          trailing: Text(
            'RWF ${NumberFormat('#,###').format(items.price * items.qty)}',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          leading: Container(
            width: 100,
            child: Text(
              items.name!.length > 10
                  ? items.name!.substring(0, 10)
                  : items.name!,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
          title: Container(
            width: 100,
            child: Row(
              children: [
                const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 16.0,
                ),
                const Text(' '),
                Text(
                  items.qty.toInt().toString(),
                ),
              ],
            ),
          ),
          onTap: () => null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transaction =
        ref.watch(pendingTransactionProvider(TransactionType.sale));
    final transactionItemsNotifier = ref.watch(
        transactionItemsProvider(transaction.value?.value?.id!).notifier);

    final totalPayable = transactionItemsNotifier.totalPayable;

    transactionItemsNotifier.updatePendingTransaction();

    return ViewModelBuilder<CoreViewModel>.nonReactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return transactionListView(transaction, context, model, totalPayable);
      },
    );
  }

  Column transactionListView(AsyncValue<AsyncValue<ITransaction>> transaction,
      BuildContext context, CoreViewModel model, double totalPayable) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        widget.mode == SellingMode.forSelling
            ? AddCustomerButton(transactionId: transaction.value?.value?.id!)
            : SizedBox.shrink(),
        Expanded(
          child: ListView.builder(
            reverse: widget.reverse,
            shrinkWrap: true,
            itemCount: (ref
                        .watch(
                          transactionItemsProvider(
                              transaction.value?.value?.id),
                        )
                        .value ??
                    [])
                .length,
            controller: ModalScrollController.of(context),
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final items = (ref
                      .watch(
                        transactionItemsProvider(transaction.value?.value?.id),
                      )
                      .value ??
                  [])[index];

              return buildItem(
                context: context,
                delete: (item) async {
                  model.deleteTransactionItem(
                    id: item.id!,
                    context: context,
                  );
                  ref.refresh(
                    transactionItemsProvider(transaction.value?.value?.id),
                  );
                },
                items: items,
              );
            },
          ),
        ),
        buildPayable(totalPayable),
      ],
    );
  }

  Padding buildPayable(double totalPayable) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: BoxButton(
        title: widget.mode == SellingMode.forSelling
            ? "Collect ${_numberFormat.format(totalPayable)} "
            : "Order ${_numberFormat.format(totalPayable)} ",
        onTap: () async {
          if (totalPayable.round() == 0) {
            showSnackBar(context, "Your cart is empty",
                textColor: Colors.white, backgroundColor: Colors.green);
            return;
          }

          /// clause the bottom sheet before navigating to transaction because if we don't then it will try to rebuild when we navigate back
          Navigator.of(context).pop();
          final transaction = await ProxyService.realm.manageTransaction(
            transactionType: TransactionType.sale,
          );
          _routerService.navigateTo(
            PaymentsRoute(
              transaction: transaction,
            ),
          );
        },
      ),
    );
  }

  ListTile buildDiscounts(CoreViewModel model) {
    return ListTile(
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
    );
  }
}
