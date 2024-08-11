import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/all_routes.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_dashboard/sales_buttons_controller.dart';
import 'package:flipper_dashboard/keypad_view.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_dashboard/product_view.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:stacked_services/stacked_services.dart';

typedef void CompleteTransaction();

final isDesktopOrWeb = UniversalPlatform.isDesktopOrWeb;
final _routerService = locator<RouterService>();

Widget PaymentTicketManager({
  required BuildContext context,
  required CoreViewModel model,
  required TextEditingController controller,
  CompleteTransaction? completeTransaction,
  required WidgetRef ref,
  required bool nodeDisabled,
}) {
  // Watch the stream provider
  final transactionAsyncValue = ref.watch(pendingTransactionProvider((
    mode: TransactionType.sale,
    isExpense: false,
  )));

  return SalesButtonsController(
    tab: model.tab,
    model: model,
    payable: PayableView(
      model: model,
      onClick: () async {
        // Handle the stream's AsyncValue state
        transactionAsyncValue.when(
          data: (transaction) {
            if (transaction.subTotal == 0) {
              completeTransaction?.call();
            } else {
              showSimpleNotification(
                Text(FLocalization.of(context).noPayable),
                background: Colors.red,
                position: NotificationPosition.bottom,
              );
            }
          },
          loading: () {
            // Optional: Handle loading state if needed
          },
          error: (error, stackTrace) {
            showSimpleNotification(
              Text('Error: $error'),
              background: Colors.red,
              position: NotificationPosition.bottom,
            );
          },
        );
      },
      ticketHandler: () async {
        // Handle the stream's AsyncValue state
        transactionAsyncValue.when(
          data: (transaction) {
            _routerService
                .navigateTo(TicketsListRoute(transaction: transaction));
          },
          loading: () {
            // Optional: Handle loading state if needed
          },
          error: (error, stackTrace) {
            showSimpleNotification(
              Text('Error: $error'),
              background: Colors.red,
              position: NotificationPosition.bottom,
            );
          },
        );
      },
      completeTransaction: completeTransaction,
    ),
    controller: controller,
  );
}

class BodyWidget extends StatefulHookConsumerWidget {
  const BodyWidget(
      {Key? key,
      required this.model,
      required this.controller,
      required this.nodeDisabled})
      : super(key: key);
  final CoreViewModel model;
  final TextEditingController controller;
  final bool nodeDisabled;
  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends ConsumerState<BodyWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          if (widget.model.tab == 2)
            PaymentTicketManager(
                ref: ref,
                context: context,
                model: widget.model,
                controller: widget.controller,
                nodeDisabled: widget.nodeDisabled),
          if (widget.model.tab == 0)
            PaymentTicketManager(
                ref: ref,
                context: context,
                model: widget.model,
                controller: widget.controller,
                nodeDisabled: widget.nodeDisabled),
          if (widget.model.tab == 0) KeyPadView(model: widget.model),
          if (widget.model.tab == 1) Transactions(),
          if (widget.model.tab == 2) Flexible(child: ProductView.normalMode()),
          if (widget.model.tab == 3)
            Flexible(
              child: SettingPage(),
            ),
        ],
      ),
    );
  }
}
