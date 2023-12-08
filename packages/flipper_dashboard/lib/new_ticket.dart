import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NewTicket extends StatefulHookConsumerWidget {
  const NewTicket({super.key, required this.transaction});
  final ITransaction transaction;
  @override
  NewTicketState createState() => NewTicketState();
}

class NewTicketState extends ConsumerState<NewTicket>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _routerService = locator<RouterService>();
  final _sub = GlobalKey<FormState>();
  final _swipeController = TextEditingController();
  final _noteController = TextEditingController();
  late bool _noteValue;
  late bool _ticketNameValue;
  @override
  void initState() {
    super.initState();
    _noteValue = false;
    _ticketNameValue = false;
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _swipeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTransaction =
        ref.watch(pendingTransactionProvider(ProxyService.box.getBranchId()));
    return SafeArea(
        child: ViewModelBuilder<CoreViewModel>.reactive(
            viewModelBuilder: () =>
                CoreViewModel(transaction: currentTransaction.value?.value),
            onViewModelReady: (model) async {},
            builder: (context, model, child) {
              return Scaffold(
                appBar: CustomAppBar(
                  onPop: () {
                    _routerService.pop();
                  },
                  onActionButtonClicked: () {
                    if (_sub.currentState!.validate()) {
                      model.saveTicket(
                          ticketName: _swipeController.text,
                          transaction: widget.transaction,
                          ticketNote: _noteController.text);
                      _routerService.clearStackAndShow(FlipperAppRoute());
                    }
                  },
                  showActionButton: true,
                  rightActionButtonName: "Save",
                  disableButton: !_noteValue && !_ticketNameValue,
                  icon: Icons.close,
                  multi: 3,
                  bottomSpacer: 48,
                ),
                body: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 10, right: 20.0),
                  child: Form(
                      key: _sub,
                      child: Column(
                        children: [
                          TextFormField(
                              controller: _swipeController,
                              onChanged: (value) {
                                setState(() {
                                  _ticketNameValue =
                                      value.isNotEmpty ? true : false;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "You need to enter ticket name or swipe";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  enabled: true,
                                  hintText: "Ticket name (or Swipe)")),
                          TextFormField(
                              controller: _noteController,
                              onChanged: (value) {
                                setState(() {
                                  _noteValue = value.isNotEmpty ? true : false;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "You need to enter the note";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  enabled: true, hintText: "Add note")),
                        ],
                      )),
                ),
              );
            }));
  }
}
