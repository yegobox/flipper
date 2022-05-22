import 'package:flipper_dashboard/transactions.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_rw/bottom_sheets/general_bottom_sheet.dart';
import 'package:flipper_dashboard/keypad_head_view.dart';
import 'package:flipper_dashboard/keypad_view.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_dashboard/product_view.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_platform/universal_platform.dart';

import 'settings.dart';

final isDesktopOrWeb = UniversalPlatform.isDesktopOrWeb;

class BodyWidget extends StatefulWidget {
  const BodyWidget({Key? key, required this.model, required this.controller})
      : super(key: key);
  final BusinessHomeViewModel model;
  final TextEditingController controller;
  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          if (widget.model.tab == 2) header(context),
          if (widget.model.tab == 0) header(context),
          if (widget.model.tab == 0) KeyPadView(model: widget.model),
          if (widget.model.tab == 1) Transactions(model: widget.model),
          if (widget.model.tab == 2) const Flexible(child: ProductView()),
          if (widget.model.tab == 3)
            Flexible(
              child: SettingPage(
                business: widget.model.businesses,
              ),
            ),
          if (widget.model.tab == 4)
            Flexible(
              child: SettingPage(
                business: widget.model.businesses,
              ),
            )
        ],
      ),
    );
  }

  Widget header(BuildContext context) {
    return KeyPadHead(
      tab: widget.model.tab,
      payable: PayableView(
        onClick: () {
          if (widget.model.kOrder != null) {
            GoRouter.of(context).push(Routes.pay, extra: widget.model.kOrder);
          } else {
            showSimpleNotification(
              Text(FLocalization.of(context).noPayable),
              background: Colors.green,
              position: NotificationPosition.bottom,
            );
          }
        },
        tickets: widget.model.keypad.tickets.length.toDouble(),
        orders: widget.model.keypad.itemsOnSale,
        duePay: widget.model.kOrder?.subTotal,
        ticketHandler: () async {
          await widget.model.keypad.getTickets();
          await widget.model.keypad
              .getOrder(branchId: ProxyService.box.getBranchId()!);
          if (widget.model.kOrder == null &&
              widget.model.keypad.tickets.isNotEmpty) {
            //then we know we need to resume.
            //TODOfix this on desktop is not showing.
            FlipperBottomSheet.showTicketsToSaleBottomSheet(
              model: widget.model,
              context: context,
            );
          }
          widget.model.saveTicket((handle) {
            if (handle == 'error') {
              FlipperBottomSheet.showAddNoteToSaleBottomSheet(
                model: widget.model,
                context: context,
              );
            } else if (handle == 'saved') {
              showSimpleNotification(
                Text('Ticket $handle'),
                background: Colors.green,
                position: NotificationPosition.bottom,
              );
            }
          });
        },
      ),
      onClick: () {
        FlipperBottomSheet.showAddNoteToSaleBottomSheet(
          model: widget.model,
          context: context,
        );
      },
      controller: widget.controller,
      amount: double.parse(widget.model.key),
    );
  }
}
