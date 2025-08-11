// ignore_for_file: unused_result

import 'package:flipper_dashboard/utils/snack_bar_utils.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
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
    // Separate tickets into loan and non-loan
    final loanTickets = tickets.where((t) => t.isLoan == true).toList();
    final nonLoanTickets = tickets.where((t) => t.isLoan != true).toList();

    return ListView(
      children: [
        if (loanTickets.isNotEmpty) ...[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text('Loan Tickets',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.deepPurple)),
          ),
          ...loanTickets.map((ticket) => TicketTile(
                ticket: ticket,
                onDelete: _deleteTicket,
                onTap: () async {
                  final TicketStatus? selectedStatus =
                      await showDialog<TicketStatus>(
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
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(null);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(null);
                              _resumeOrder(ticket);
                            },
                            child: const Text('Resume Order'),
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.green),
                          ),
                          ...TicketStatus.values.map((status) => TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(status);
                                },
                                child: Text(status.displayName),
                                style: TextButton.styleFrom(
                                    foregroundColor: status.color),
                              )),
                        ],
                      );
                    },
                  );
                  if (selectedStatus != null) {
                    await ProxyService.strategy.updateTransaction(
                      transaction: ticket,
                      status: selectedStatus.statusValue,
                      updatedAt: DateTime.now().toUtc(),
                    );
                    setState(() {});
                  }
                },
              )),
        ],
        if (nonLoanTickets.isNotEmpty) ...[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text('Regular Tickets',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue)),
          ),
          ...nonLoanTickets.map((ticket) => TicketTile(
                ticket: ticket,
                onDelete: _deleteTicket,
                onTap: () async {
                  final TicketStatus? selectedStatus =
                      await showDialog<TicketStatus>(
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
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(null);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(null);
                              _resumeOrder(ticket);
                            },
                            child: const Text('Resume Order'),
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.green),
                          ),
                          ...TicketStatus.values.map((status) => TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(status);
                                },
                                child: Text(status.displayName),
                                style: TextButton.styleFrom(
                                    foregroundColor: status.color),
                              )),
                        ],
                      );
                    },
                  );
                  if (selectedStatus != null) {
                    await ProxyService.strategy.updateTransaction(
                      transaction: ticket,
                      status: selectedStatus.statusValue,
                      updatedAt: DateTime.now().toUtc(),
                    );
                    setState(() {});
                  }
                },
              )),
        ],
      ],
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
    try {
      // Get all pending transactions for this branch
      await _parkExistingPendingTransactions(excludeId: ticket.id);
      // Set ticket status to PENDING
      ticket.status = PENDING;
      ticket.updatedAt = DateTime.now();
      await ProxyService.strategy.updateTransaction(
        transaction: ticket,
        status: PENDING,
        updatedAt: DateTime.now().toUtc(),
      );

      // Detect if on mobile and navigate to CheckoutProductView
      final isMobile = MediaQuery.of(context).size.width < 600;
      if (isMobile) {
        final isBigScreen = MediaQuery.of(context).size.width > 600;
        await _routerService
            .navigateTo(CheckOutRoute(isBigScreen: isBigScreen));
        return;
      }
      // On desktop, go home or do as before
      Navigator.of(context).pop();
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

  Future<void> _deleteTicket(ITransaction ticket) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Deleting ticket...'),
              ],
            ),
          );
        },
      );

      // Delete the transaction
      await ProxyService.strategy.deleteTransaction(transaction: ticket);

      // Close the loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Show success message
      if (mounted) {
        showCustomSnackBarUtil(context, 'Ticket deleted successfully',
            backgroundColor: Colors.red);
      }
    } catch (e, stackTrace) {
      // Close the loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      talker.error('Error deleting ticket: $e');
      talker.error(stackTrace.toString());

      // Show error dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to delete ticket: ${e.toString()}'),
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
          return StreamBuilder<List<ITransaction>>(
            stream: _getTicketsStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<ITransaction>? data = snapshot.data;
                if (data == null || data.isEmpty) {
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
          forceRealData: true,
          skipOriginalTransactionCheck: true,
        )
        .asBroadcastStream();

    final inProgressStream = ProxyService.strategy
        .transactionsStream(
            skipOriginalTransactionCheck: true,
            status: IN_PROGRESS,
            removeAdjustmentTransactions: true,
            forceRealData: true)
        .asBroadcastStream();

    final waitingStream = ProxyService.strategy
        .transactionsStream(
            skipOriginalTransactionCheck: true,
            status: WAITING,
            removeAdjustmentTransactions: true,
            forceRealData: true)
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
