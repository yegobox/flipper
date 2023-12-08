import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'new_ticket.dart';

class Tickets extends StatefulHookConsumerWidget {
  const Tickets({super.key, this.transaction});
  // final List<Transaction> tickets;
  final ITransaction? transaction;
  @override
  TicketsState createState() => TicketsState();
}

class TicketsState extends ConsumerState<Tickets>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final _routerService = locator<RouterService>();
  @override
  Widget build(BuildContext context) {
    final currentTransaction =
        ref.watch(pendingTransactionProvider(ProxyService.box.getBranchId()));
    return ViewModelBuilder<CoreViewModel>.reactive(
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                onPop: () {
                  _routerService.pop();
                },
                onActionButtonClicked: () {
                  _routerService.pop();
                },
                icon: Icons.close,
                multi: 3,
                bottomSpacer: 52,
              ),
              body: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 18, right: 18, top: 20),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: OutlinedButton(
                          style: ButtonStyle(
                            side: MaterialStateProperty.resolveWith<BorderSide>(
                              (states) => BorderSide(
                                color: Color(0xff006AFE),
                              ),
                            ),
                            shape: MaterialStateProperty.resolveWith<
                                OutlinedBorder>(
                              (states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          child: Text('New Ticket',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: Color(0xff006AFE))),
                          onPressed: () {
                            if (widget.transaction != null) {
                              showModalBottomSheet(
                                backgroundColor: Colors.red,
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10.0)),
                                ),
                                useRootNavigator: true,
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 20.0),
                                    child: NewTicket(
                                        transaction: widget.transaction!),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, top: 20.0),
                      child: Text('Other Tickets',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              color: Color(0xff006AFE))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24.0, top: 20.0, right: 20.0),
                      child: StreamBuilder<List<ITransaction>>(
                          stream: ProxyService.isar.ticketsStreams(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<ITransaction> data = snapshot.data!;
                              return Column(
                                children: data.map((e) {
                                  return GestureDetector(
                                    onTap: () async {
                                      await model.resumeTransaction(
                                          ticketId: e.id);
                                      _routerService
                                          .clearStackAndShow(FlipperAppRoute());
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          e.ticketName!,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          timeago.format(
                                              DateTime.parse(e.updatedAt!)),
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          }),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        onViewModelReady: (model) {
          model.updatePayable();
        },
        viewModelBuilder: () =>
            CoreViewModel(transaction: currentTransaction.value?.value));
  }
}
