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
// import 'ticket_tile.dart';

mixin TicketsListMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  final _routerService = locator<RouterService>();

  /// Builds the main ticket section with responsive layout
  Widget buildTicketSection(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return StreamBuilder<List<ITransaction>>(
          stream: _getTicketsStream(),
          builder: (context, snapshot) {
            // Show loading indicator while data is loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState(context);
            }

            // Show error state if there's an error
            if (snapshot.hasError) {
              return _buildErrorState(snapshot.error.toString());
            }

            // Show empty state if there's no data
            if (!snapshot.hasData || snapshot.data?.isEmpty == true) {
              return _buildNoTickets(context);
            }

            // Show ticket list when data is available
            return _buildTicketList(context, snapshot.data!, isDesktop);
          },
        );
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // QuickBooks-style circular loader
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading tickets...',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// Desktop: Two-column card layout | Mobile: Vertical scroll
  Widget _buildTicketList(
    BuildContext context,
    List<ITransaction> tickets,
    bool isDesktop,
  ) {
    final loanTickets = tickets.where((t) => t.isLoan == true).toList();
    final nonLoanTickets = tickets.where((t) => t.isLoan != true).toList();

    Widget buildSection(String title, Color color, List<ITransaction> list) {
      if (list.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          for (final ticket in list)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: TicketCard(
                ticket: ticket,
                onTap: () => _handleTicketTap(context, ticket),
                onDelete: () => _deleteTicket(ticket),
              ),
            ),
        ],
      );
    }

    if (isDesktop) {
      // Desktop layout with scrollable columns
      return SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child:
                  buildSection('Loan Tickets', Colors.deepPurple, loanTickets),
            ),
            const VerticalDivider(width: 20, thickness: 1, color: Colors.grey),
            Expanded(
              child:
                  buildSection('Regular Tickets', Colors.blue, nonLoanTickets),
            ),
          ],
        ),
      );
    } else {
      // Mobile layout with scrollable list
      return ListView(
        padding: EdgeInsets.zero,
        children: [
          buildSection('Loan Tickets', Colors.deepPurple, loanTickets),
          buildSection('Regular Tickets', Colors.blue, nonLoanTickets),
        ],
      );
    }
  }

  /// Dialog to update ticket status or resume
  Future<void> _handleTicketTap(
      BuildContext context, ITransaction ticket) async {
    final currentStatus =
        TicketStatusExtension.fromString(ticket.status ?? PARKED);
    final selectedStatus = await showDialog<TicketStatus?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Update Ticket #${ticket.id.substring(0, 6).toUpperCase()}',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _statusBadge(currentStatus.displayName, currentStatus.color),
            const SizedBox(height: 16),
            const Text(
              'Select new status:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.maxFinite,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: TicketStatus.values
                    .where((s) => s != currentStatus)
                    .map((status) => FilterChip(
                          label: Text(status.displayName),
                          labelStyle: TextStyle(
                            color: status.color,
                            fontWeight: FontWeight.w500,
                          ),
                          selectedColor: status.color.withOpacity(0.1),
                          side: BorderSide(color: status.color, width: 1),
                          selected: false,
                          onSelected: (_) => Navigator.of(context).pop(status),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Cancel'),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop(null);
              _resumeOrder(ticket);
            },
            icon: const Icon(Icons.play_arrow, size: 16),
            label: const Text('Resume Order'),
            style: TextButton.styleFrom(foregroundColor: Colors.green),
          ),
        ],
      ),
    );

    if (selectedStatus != null) {
      try {
        await ProxyService.strategy.updateTransaction(
          transaction: ticket,
          status: selectedStatus.statusValue,
          updatedAt: DateTime.now().toUtc(),
        );
        if (mounted) setState(() {});
        showCustomSnackBarUtil(
          context,
          'Ticket status updated to ${selectedStatus.displayName}',
          backgroundColor: selectedStatus.color,
        );
      } catch (e) {
        talker.error('Failed to update status: $e');
        showCustomSnackBarUtil(
          context,
          'Failed to update status',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  /// Park all pending except the one we're resuming
  Future<void> _parkExistingPendingTransactions({
    required String excludeId,
  }) async {
    try {
      final pending = await ProxyService.strategy.transactions(
        branchId: ProxyService.box.getBranchId()!,
        status: PENDING,
        includeZeroSubTotal: true,
      );
      talker.debug('Pending to park: ${pending.length}');
      for (final tx in pending) {
        if (tx.id == excludeId) continue;
        if (tx.subTotal != 0.0) {
          throw Exception(
              'Non-zero pending order exists. Please process it first.');
        }
        await ProxyService.strategy.deleteTransaction(transaction: tx);
        talker.info('Parked zero-total pending: ${tx.id}');
      }
    } catch (e) {
      talker.error('Error parking pending: $e');
      rethrow;
    }
  }

  /// Resume a parked ticket
  Future<void> _resumeOrder(ITransaction ticket) async {
    try {
      await _parkExistingPendingTransactions(excludeId: ticket.id);
      ticket.status = PENDING;
      await ProxyService.strategy.updateTransaction(
        transaction: ticket,
        status: PENDING,
        updatedAt: DateTime.now().toUtc(),
      );
      final isMobile = MediaQuery.sizeOf(context).width < 600;
      final isBigScreen = MediaQuery.sizeOf(context).width > 600;
      if (isMobile) {
        await _routerService
            .navigateTo(CheckOutRoute(isBigScreen: isBigScreen));
      } else {
        if (mounted) Navigator.of(context).pop();
      }
      showCustomSnackBarUtil(
        context,
        'Order resumed successfully',
        backgroundColor: Colors.green,
      );
    } catch (e, st) {
      talker.error('Resume failed: $e', st);
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Action Failed'),
            content: Text(
              e.toString(),
              style: const TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  /// Delete a ticket with confirmation and loading
  Future<void> _deleteTicket(ITransaction ticket) async {
    bool confirmed = false;
    if (mounted) {
      confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Delete Ticket?'),
              content: Text(
                'Are you sure you want to delete ticket #${ticket.id.substring(0, 6)}? This cannot be undone.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child:
                      const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ) ??
          false;
    }
    if (!confirmed) return;

    try {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => const AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Deleting...'),
              ],
            ),
          ),
        );
      }

      await ProxyService.strategy.deleteTransaction(transaction: ticket);
      if (mounted) Navigator.of(context).pop();
      showCustomSnackBarUtil(
        context,
        'Ticket deleted',
        backgroundColor: Colors.red,
      );
    } catch (e, st) {
      if (mounted) Navigator.of(context).pop();
      talker.error('Delete failed: $e', st);
      showCustomSnackBarUtil(context, 'Delete failed',
          backgroundColor: Colors.red);
    }
  }

  /// No tickets placeholder (QuickBooks style: clean & friendly)
  Widget _buildNoTickets(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'No open tickets',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(
            'Create a new ticket to get started',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// Error state with retry suggestion
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 40, color: Colors.red[400]),
          const SizedBox(height: 8),
          Text(
            'Something went wrong',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              error,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: () => setState(() {}),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  /// Unified stream combining WAITING, PARKED, IN_PROGRESS
  Stream<List<ITransaction>> _getTicketsStream() {
    final statuses = [WAITING, PARKED, IN_PROGRESS];
    return Stream.periodic(const Duration(seconds: 3)).asyncMap((_) async {
      final futures = statuses.map((status) => ProxyService.strategy
          .transactionsStream(
            status: status,
            removeAdjustmentTransactions: true,
            forceRealData: true,
            skipOriginalTransactionCheck: true,
          )
          .first);
      final results = await Future.wait(futures);
      final allTickets = results.expand((list) => list).toList();
      allTickets.sort((a, b) {
        final aStatus = a.status;
        final bStatus = b.status;
        // Priority: WAITING > PARKED > IN_PROGRESS
        final priority = <String, int>{
          WAITING: 3,
          PARKED: 2,
          IN_PROGRESS: 1,
        };
        final aPrio = priority[aStatus] ?? 0;
        final bPrio = priority[bStatus] ?? 0;
        if (aPrio != bPrio) return bPrio.compareTo(aPrio);
        // Then sort by creation date (newest first)
        final aDate = a.createdAt ?? DateTime(1970);
        final bDate = b.createdAt ?? DateTime(1970);
        return bDate.compareTo(aDate);
      });
      return allTickets;
    }).handleError((e, st) {
      talker.error('Ticket stream error: $e', st);
      return <ITransaction>[];
    });
  }

  /// Reusable status badge (like QuickBooks tags)
  Widget _statusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final ITransaction ticket;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  const TicketCard({
    super.key,
    required this.ticket,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final statusExt = TicketStatusExtension.fromString(ticket.status ?? PARKED);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status indicator at the top
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ticket #${ticket.id.substring(0, 6).toUpperCase()}',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  // Status badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusExt.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusExt.color, width: 1),
                    ),
                    child: Text(
                      statusExt.displayName,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: statusExt.color,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Ticket details
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total: ${ticket.subTotal?.toCurrencyFormatted()}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Created: ${_formatDate(ticket.createdAt)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action buttons
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.play_arrow,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: onTap,
                        tooltip: 'Resume Order',
                        style: IconButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            size: 20, color: Colors.red),
                        onPressed: onDelete,
                        tooltip: 'Delete Ticket',
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return '${date.month}/${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
