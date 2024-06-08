import 'package:flipper_models/realm_model_export.dart';
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
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 45),
                    // New Ticket Button
                    SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xff006AFE)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                          if (widget.transaction != null) {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10.0)),
                              ),
                              useRootNavigator: true,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: NewTicket(
                                    transaction: widget.transaction!,
                                  ),
                                );
                              },
                            );
                          }
                        },
                        child: Text(
                          'New Ticket',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                            color: Color(0xff006AFE),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Other Tickets Title
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Other Tickets',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          color: Color(0xff006AFE),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: StreamBuilder<List<ITransaction>>(
                        stream: ProxyService.realm.ticketsStreams(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<ITransaction> data = snapshot.data!;
                            return ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final ticket = data[index];
                                return GestureDetector(
                                  onTap: () async {
                                    await model.resumeTransaction(
                                        ticketId: ticket.id!);
                                    _routerService
                                        .clearStackAndShow(FlipperAppRoute());
                                  },
                                  child: Card(
                                    elevation: 2,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 12.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            ticket.ticketName!,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 17,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            timeago.format(DateTime.parse(
                                                ticket.updatedAt!)),
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 17,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        onViewModelReady: (model) {
          model.updatePayable();
        },
        viewModelBuilder: () => CoreViewModel());
  }
}
