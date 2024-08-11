// ignore_for_file: unused_result

import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'new_ticket.dart';

class TicketsList extends StatefulHookConsumerWidget {
  const TicketsList({Key? key, required this.transaction}) : super(key: key);
  final ITransaction? transaction;

  @override
  _TicketsListState createState() => _TicketsListState();
}

class _TicketsListState extends ConsumerState<TicketsList> {
  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            /// refreshing the transaction make the counter on preview cart reset as ticket are removed from current
            /// cart preview
            ref.refresh(
              pendingTransactionProvider(
                  (mode: TransactionType.sale, isExpense: false)),
            );
            _routerService.back();
          },
          icon: const Icon(Icons.close, color: Colors.black),
        ),
        title: Text(
          'Tickets',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // New Ticket Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff006AFE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                if (widget.transaction != null) {
                  // Show NewTicket widget in a full-screen dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: NewTicket(
                          transaction: widget.transaction!,
                          onClose: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'New Ticket',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Other Tickets Title
            Text(
              'Other Tickets',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: const Color(0xff006AFE),
              ),
            ),
            const SizedBox(height: 16),
            ViewModelBuilder.nonReactive(
                viewModelBuilder: () => CoreViewModel(),
                builder: (context, model, child) {
                  return Expanded(
                    child: StreamBuilder<List<ITransaction>>(
                      stream: ProxyService.realm.ticketsStreams(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<ITransaction> data = snapshot.data!;
                          return ListView.separated(
                            itemCount: data.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final ticket = data[index];
                              return TicketTile(
                                ticket: ticket,
                                onTap: () async {
                                  bool? confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Confirm Resume'),
                                        content: Text(
                                            'Are you sure you want to resume this order?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                            child: Text('Confirm'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirm == true) {
                                    await model.resumeTransaction(
                                        ticketId: ticket.id!);

                                    await Future.delayed(
                                        Duration(microseconds: 800));

                                    ref.refresh(transactionItemsProvider(
                                        (isExpense: false)).notifier);

                                    _routerService
                                        .clearStackAndShow(FlipperAppRoute());
                                  }
                                },
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class TicketTile extends StatelessWidget {
  const TicketTile({
    Key? key,
    required this.ticket,
    required this.onTap,
  }) : super(key: key);

  final ITransaction ticket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                timeago.format(DateTime.parse(ticket.updatedAt!)),
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
  }
}
