import 'package:localize/localize.dart';
import 'package:localize/localization.dart';
import 'package:flipper_dashboard/keypad_head_view.dart';
import 'package:flipper_dashboard/keypad_view.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_dashboard/product_view.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/models/models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:go_router/go_router.dart';

class BodyWidget extends StatefulWidget {
  const BodyWidget(
      {Key? key,
      required this.model,
      required this.sideOpenController,
      required this.controller})
      : super(key: key);
  final BusinessHomeViewModel model;
  final ValueNotifier<bool> sideOpenController;
  final TextEditingController controller;
  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        KeyPadHead(
          tab: widget.model.tab,
          payable: PayableView(
            onClick: () {
              if (widget.model.kOrder != null) {
                GoRouter.of(context).push(Routes.pay);
              } else {
                showSimpleNotification(
                  Text(FLocalization.of(context).noPayable),
                  background: Colors.green,
                  position: NotificationPosition.bottom,
                );
              }
            },
            tickets: widget.model.tickets.isEmpty
                ? 0
                : widget.model.tickets.length.toDouble(),
            orders: widget.model.kOrder != null
                ? widget.model.kOrder!.orderItems.length
                : 0,
            duePay: widget.model.kOrder != null
                ? widget.model.totalPayable.toDouble()
                : 0.00,
            ticketHandler: () async {
              await widget.model.keypad.getTickets();
              await widget.model.keypad
                  .getOrder(branchId: ProxyService.box.read(key: 'branchId'));
              if (widget.model.kOrder == null &&
                  widget.model.tickets.isNotEmpty) {
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
        ),
        widget.model.tab == 0
            ? KeyPadView(model: widget.model)
            : const Flexible(child: ProductView(userId: '1', items: true)),
      ],
    );
  }
}
