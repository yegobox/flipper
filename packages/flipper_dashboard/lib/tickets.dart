// ignore_for_file: unused_result

import 'package:flipper_models/db_model_export.dart';

import 'package:flipper_models/providers/transactions_provider.dart';
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
import 'package:flipper_models/providers/transaction_items_provider.dart';

// Define ticket status enum similar to OrderStatus in kitchen display
enum TicketStatus { pending, inProgress, completed }

extension TicketStatusExtension on TicketStatus {
  String get displayName {
    switch (this) {
      case TicketStatus.pending:
        return 'Pending';
      case TicketStatus.inProgress:
        return 'In Progress';
      case TicketStatus.completed:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case TicketStatus.pending:
        return Colors.orange;
      case TicketStatus.inProgress:
        return Colors.blue;
      case TicketStatus.completed:
        return Colors.green;
    }
  }

  String get statusValue {
    switch (this) {
      case TicketStatus.pending:
        return PARKED;
      case TicketStatus.inProgress:
        return ORDERING;
      case TicketStatus.completed:
        return COMPLETE;
    }
  }

  static TicketStatus fromString(String status) {
    switch (status) {
      case PARKED:
        return TicketStatus.pending;
      case ORDERING:
        return TicketStatus.inProgress;
      case COMPLETE:
        return TicketStatus.completed;
      default:
        return TicketStatus.pending;
    }
  }
}

mixin TicketsListMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  final _routerService = locator<RouterService>();

  Widget _buildTicketList(BuildContext context, List<ITransaction> tickets) {
    return ListView.separated(
      itemCount: tickets.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return TicketTile(
          ticket: ticket,
          onTap: () async {
            // Show options dialog to update ticket status
            final TicketStatus? selectedStatus = await showDialog<TicketStatus>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Update Ticket Status'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          'Current status: ${TicketStatusExtension.fromString(ticket.status ?? PARKED).displayName}'),
                      const SizedBox(height: 16),
                      const Text('Select new status:'),
                    ],
                  ),
                  actions: <Widget>[
                    // Cancel button
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                      child: const Text('Cancel'),
                    ),
                    // Resume button (change to PENDING)
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(null); // Close dialog
                        _resumeOrder(
                            ticket); // Use existing resume functionality
                      },
                      child: const Text('Resume Order'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                    ),
                    // Status options
                    ...TicketStatus.values.map((status) => TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(status);
                          },
                          child: Text(status.displayName),
                          style: TextButton.styleFrom(
                            foregroundColor: status.color,
                          ),
                        )),
                  ],
                );
              },
            );

            // Update ticket status if a new status was selected
            if (selectedStatus != null) {
              await ProxyService.strategy.updateTransaction(
                transaction: ticket,
                status: selectedStatus.statusValue,
                updatedAt: DateTime.now(),
              );

              // Refresh the UI
              setState(() {});
            }
          },
        );
      },
    );
  }

  // Extract resume order functionality to a separate method
  Future<void> _resumeOrder(ITransaction ticket) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Resume'),
          content: const Text('Are you sure you want to resume this order?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await ProxyService.strategy.updateTransaction(
        transaction: ticket,
        status: PENDING,
        updatedAt: DateTime.now(),
      );

      await Future.delayed(const Duration(microseconds: 800));

      ref.refresh(transactionItemsProvider(transactionId: ticket.id));

      _routerService.clearStackAndShow(FlipperAppRoute());
    }
  }

  Widget _buildNoTickets(BuildContext context) {
    return Center(
      child: Text(
        'No open tickets',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildTicketSection(BuildContext context) {
    return ViewModelBuilder.nonReactive(
        viewModelBuilder: () => CoreViewModel(),
        builder: (context, model, child) {
          return Expanded(
            child: StreamBuilder<List<ITransaction>>(
              stream: _getTicketsStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ITransaction> data = snapshot.data!;
                  if (data.isEmpty) {
                    return _buildNoTickets(context);
                  }
                  return _buildTicketList(context, data);
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
        });
  }

  // Create a stream that combines tickets with all statuses
  Stream<List<ITransaction>> _getTicketsStream() {
    // Create broadcast streams for each status
    final parkedStream = ProxyService.strategy
        .transactionsStream(status: PARKED, removeAdjustmentTransactions: true)
        .asBroadcastStream();

    final orderingStream = ProxyService.strategy
        .transactionsStream(
            status: ORDERING, removeAdjustmentTransactions: true)
        .asBroadcastStream();

    final completeStream = ProxyService.strategy
        .transactionsStream(
            status: COMPLETE, removeAdjustmentTransactions: true)
        .asBroadcastStream();

    // Merge all streams with periodic polling
    return Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
      final parkedTickets = await parkedStream.first;
      final orderingTickets = await orderingStream.first;
      final completeTickets = await completeStream.first;

      return [...parkedTickets, ...orderingTickets, ...completeTickets];
    });
  }
}

class TicketsList extends StatefulHookConsumerWidget {
  const TicketsList(
      {Key? key, required this.transaction, this.showAppBar = true})
      : super(key: key);
  final ITransaction? transaction;
  final bool showAppBar;

  @override
  _TicketsListState createState() => _TicketsListState();
}

class _TicketsListState extends ConsumerState<TicketsList>
    with TicketsListMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  ref.refresh(
                    pendingTransactionStreamProvider(isExpense: false),
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
            )
          : null,
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
                      return NewTicket(
                        transaction: widget.transaction!,
                        onClose: () {
                          Navigator.of(context).pop();
                        },
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
            ).eligibleToSee(ref, [AccessLevel.ADMIN, AccessLevel.WRITE]),
            const SizedBox(height: 24)
                .eligibleToSee(ref, [AccessLevel.ADMIN, AccessLevel.WRITE]),

            Text(
              'Tickets',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: const Color(0xff006AFE),
              ),
            ).shouldSeeTheApp(ref, featureName: "Tickets"),
            const SizedBox(height: 16),
            _buildTicketSection(context),
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
    // Get ticket status from transaction status
    final ticketStatus =
        TicketStatusExtension.fromString(ticket.status ?? PARKED);

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.ticketName ?? "N/A",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeago.format(ticket.updatedAt!),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ticketStatus.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ticketStatus.color, width: 1),
                ),
                child: Text(
                  ticketStatus.displayName,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: ticketStatus.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
