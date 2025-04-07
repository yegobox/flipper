// ignore_for_file: unused_result

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../models/ticket_status.dart';
import 'ticket_tile.dart';

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

  /// Parks all existing PENDING transactions to prevent duplicates
  /// when resuming a ticket
  Future<void> _parkExistingPendingTransactions(
      {required String excludeId}) async {
    try {
      // Get all pending transactions for this branch
      final pendingTransactions = await ProxyService.strategy.transactions(
        branchId: ProxyService.box.getBranchId()!,
        status: PENDING,
        includeZeroSubTotal:
            true, // Include all transactions regardless of subtotal
      );

      talker.debug(
          'Found ${pendingTransactions.length} pending transactions to park');

      // Park all existing pending transactions
      for (final tx in pendingTransactions) {
        talker.debug('Parking transaction: ${tx.id}');
        if (tx.id == excludeId) {
          continue;
        }
        // if we try to resume order and there is non zero pending order throw error request a user to create new ticket for it
        if (tx.subTotal != 0.0) {
          throw Exception(
              'There is a non zero pending order, First create ticket for it');
        }
        // delete all pending with 0.0 as subTotal
        if (tx.subTotal == 0.0) {
          await ProxyService.strategy.deleteTransaction(
            transaction: tx,
          );
        }
      }
    } catch (e) {
      talker.error('Error parking existing transactions: $e');
    }
  }

  // Extract resume order functionality to a separate method
  Future<void> _resumeOrder(ITransaction ticket) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resume Ticket'),
        content: const Text('Are you sure you want to resume this ticket?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Resume'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // First, park all existing PENDING transactions to prevent duplicates
        await _parkExistingPendingTransactions(excludeId: ticket.id);

        // Then, check if the ticket exists and get the latest version
        final updatedTicket = await ProxyService.strategy.getTransaction(
            id: ticket.id, branchId: ProxyService.box.getBranchId()!);
        final ticketToUpdate = updatedTicket ?? ticket;

        // Ensure the transaction has a valid subtotal (greater than 0)
        final double currentSubTotal = ticketToUpdate.subTotal ?? 0.0;
        final double safeSubTotal =
            currentSubTotal > 0 ? currentSubTotal : 0.01;

        talker.debug(
            'Resuming ticket ${ticketToUpdate.id} from ${ticketToUpdate.status} to PENDING');

        // Update the ticket status to PENDING
        await ProxyService.strategy.updateTransaction(
          transaction: ticketToUpdate,
          status: PENDING,
          updatedAt: DateTime.now(),
          subTotal: safeSubTotal,
        );

        talker.debug(
            'Successfully updated ticket to PENDING with subtotal: $safeSubTotal');

        // Give the database a moment to update
        await Future.delayed(const Duration(milliseconds: 500));

        // Refresh the transaction items provider to update the UI
        ref.refresh(transactionItemsProvider(transactionId: ticket.id));

        // Navigate back to the main app route
        _routerService.clearStackAndShow(FlipperAppRoute());
      } catch (e, stackTrace) {
        talker.error('Error resuming ticket: $e');
        talker.error(stackTrace.toString());

        // Show error dialog to user
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to resume ticket: ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
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

  Widget buildTicketSection(BuildContext context) {
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

  // Create a stream that combines tickets with PARKED, ORDERING, and WAITING statuses
  Stream<List<ITransaction>> _getTicketsStream() {
    // Create broadcast streams for each status
    final parkedStream = ProxyService.strategy
        .transactionsStream(
          status: PARKED,
          removeAdjustmentTransactions: true,
        )
        .asBroadcastStream();

    final inProgressStream = ProxyService.strategy
        .transactionsStream(
            status: IN_PROGRESS, removeAdjustmentTransactions: true)
        .asBroadcastStream();

    final waitingStream = ProxyService.strategy
        .transactionsStream(status: WAITING, removeAdjustmentTransactions: true)
        .asBroadcastStream();

    // Merge streams with periodic polling (excluding COMPLETE status)
    return Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
      final parkedTickets = await parkedStream.first;
      final inProgressTickets = await inProgressStream.first;
      final waitingTickets = await waitingStream.first;

      // Sort tickets to prioritize waiting tickets at the top
      final allTickets = [
        ...waitingTickets,
        ...parkedTickets,
        ...inProgressTickets
      ];

      // Sort by status priority and then by creation date (newest first)
      allTickets.sort((a, b) {
        // First sort by status priority (WAITING > PARKED > ORDERING)
        final statusA = a.status;
        final statusB = b.status;

        if (statusA == WAITING && statusB != WAITING) return -1;
        if (statusA != WAITING && statusB == WAITING) return 1;
        if (statusA == PARKED && statusB == IN_PROGRESS) return -1;
        if (statusA == IN_PROGRESS && statusB == PARKED) return 1;

        // If same status, sort by creation date (newest first)
        final dateA = a.createdAt ?? DateTime(1970);
        final dateB = b.createdAt ?? DateTime(1970);
        return dateB.compareTo(dateA);
      });

      return allTickets;
    });
  }
}
