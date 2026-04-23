import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_dashboard/new_ticket.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/providers/ticket_selection_provider.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';

import '../widgets/tickets_list.dart';

const Color _ticketFilterBlue = Color(0xff006AFE);
const Color _ticketFilterLoanPurple = Color(0xFF6B4EA2);
const Color _ticketFilterLayawayTeal = Color(0xFF0D9488);
const Color _ticketFilterRegularGreen = Color(0xFF2E7D32);

class TicketsScreen extends StatefulHookConsumerWidget {
  const TicketsScreen({
    Key? key,
    required this.transaction,
    this.showAppBar = true,
  }) : super(key: key);

  final ITransaction? transaction;
  final bool showAppBar;

  @override
  _TicketsScreenState createState() => _TicketsScreenState();
}

class _TicketsScreenState extends ConsumerState<TicketsScreen>
    with TicketsListMixin {
  final _routerService = locator<RouterService>();

  void _selectAllTickets(WidgetRef ref) {
    final visibleTickets = getCurrentTickets();
    if (visibleTickets.isNotEmpty) {
      ref.read(ticketSelectionProvider.notifier).selectAll(visibleTickets);
    }
  }

  Future<void> _deleteSelectedTickets(WidgetRef ref) async {
    final selectedIds = ref.read(ticketSelectionProvider);
    final visibleTickets = getCurrentTickets();
    final visibleTicketIds = visibleTickets.map((t) => t.id).toSet();

    // Filter to only include visible tickets
    final validSelectedIds = selectedIds
        .where((id) => visibleTicketIds.contains(id))
        .toSet();

    // Clear invalid selections
    if (validSelectedIds.length != selectedIds.length) {
      ref.read(ticketSelectionProvider.notifier).clearSelection();
      // Re-select only valid tickets
      final validTickets = visibleTickets
          .where((t) => validSelectedIds.contains(t.id))
          .toList();
      if (validTickets.isNotEmpty) {
        ref.read(ticketSelectionProvider.notifier).selectAll(validTickets);
      }
    }

    if (validSelectedIds.isEmpty) return;

    final selectedTickets = visibleTickets
        .where((t) => validSelectedIds.contains(t.id))
        .toList();

    // Filter decomposable/deletable tickets
    final List<ITransaction> deletableTickets = [];
    final List<ITransaction> nonDeletableTickets = [];

    for (final ticket in selectedTickets) {
      if (await canDeleteTicket(ticket)) {
        deletableTickets.add(ticket);
      } else {
        nonDeletableTickets.add(ticket);
      }
    }

    if (deletableTickets.isEmpty &&
        nonDeletableTickets.isNotEmpty &&
        !kDebugMode &&
        ProxyService.box.enableDebug() != true) {
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          'Selected tickets have partial payments and cannot be deleted',
          backgroundColor: Colors.orange,
        );
      }
      return;
    }

    showDeletionConfirmationSnackBar(
      context,
      deletableTickets,
      (ticket) => 'Ticket #${ticket.reference ?? ticket.id.substring(0, 8)}',
      () async {
        try {
          final deletableIds = deletableTickets.map((t) => t.id).toSet();
          await deleteSelectedTickets(deletableIds);
          ref.read(ticketSelectionProvider.notifier).clearSelection();
          // Force refresh the transaction provider to update the stream
          ref.invalidate(pendingTransactionStreamProvider(isExpense: false));
          if (mounted) {
            setState(() {});
            showCustomSnackBarUtil(
              context,
              '${deletableIds.length} ticket${deletableIds.length == 1 ? '' : 's'} deleted successfully',
              backgroundColor: Colors.green,
            );
          }
        } catch (e) {
          if (mounted) {
            setState(() {});
            showCustomSnackBarUtil(
              context,
              'Failed to delete selected tickets',
              backgroundColor: Colors.red,
            );
          }
        }
      },
    );
  }

  Widget _buildTicketFilterChips() {
    Widget dot(Color c) => Container(
          margin: const EdgeInsets.only(right: 6),
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: c, shape: BoxShape.circle),
        );

    Widget chip(String id, String label, {Color? dotColor}) {
      final selected = ticketKindFilter == id;
      final Color selectedAccent = switch (id) {
        'loan' => _ticketFilterLoanPurple,
        'layaway' => _ticketFilterLayawayTeal,
        'regular' => _ticketFilterRegularGreen,
        _ => _ticketFilterBlue,
      };
      final Color selectedBg = switch (id) {
        'loan' => const Color(0xFFF3E5F5),
        'layaway' => const Color(0xFFE0F2F1),
        'regular' => const Color(0xFFE8F5E9),
        _ => const Color(0xFFE8F1FF),
      };
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => updateTicketKindFilter(id),
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? selectedBg : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: selected ? selectedAccent : Colors.grey[300]!,
                  width: selected ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (dotColor != null) dot(dotColor),
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: selected ? selectedAccent : Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            selected ? selectedAccent : Colors.grey[400]!,
                        width: 1.5,
                      ),
                      color: selected ? selectedAccent : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: selected
                        ? Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          chip('all', 'All tickets'),
          chip('loan', 'Loan', dotColor: _ticketFilterLoanPurple),
          chip('layaway', 'Layaway', dotColor: _ticketFilterLayawayTeal),
          chip('regular', 'Regular', dotColor: _ticketFilterRegularGreen),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final horizontalPadding = isMobile ? 8.0 : 16.0;
        final verticalPadding = isMobile ? 8.0 : 16.0;
        final buttonFontSize = isMobile ? 14.0 : 16.0;
        final titleFontSize = isMobile ? 16.0 : 20.0;

        Widget content = Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isMobile ? 8 : 16),
              // New Ticket Button
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: double.infinity,
                  child: Consumer(
                    builder: (context, ref, _) {
                      final transaction = widget.transaction;

                      // Don't show "Create Ticket" button if this is a resumed ticket
                      // (resumed tickets already have a ticketName)
                      final isResumedTicket =
                          transaction?.ticketName != null &&
                          transaction!.ticketName!.isNotEmpty;

                      if (isResumedTicket) {
                        return const SizedBox.shrink();
                      }

                      final itemCount = transaction != null
                          ? ref
                                .watch(
                                  transactionItemsProvider(
                                    transactionId: transaction.id,
                                  ),
                                )
                                .maybeWhen(
                                  data: (items) => items.length,
                                  orElse: () => 0,
                                )
                          : 0; // If no transaction, itemCount is 0
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _ticketFilterBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 12.0 : 16.0,
                          ),
                          elevation: isMobile ? 1 : 0,
                          textStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: buttonFontSize,
                          ),
                        ),
                        onPressed: () {
                          if (itemCount > 0) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return NewTicket(
                                  transaction: transaction!,
                                  onClose: () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please add items to the transaction before creating a ticket',
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add,
                              size: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Create Ticket',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: buttonFontSize,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ).eligibleToSeeIfYouAre(ref, [AccessLevel.ADMIN]);
                    },
                  ),
                ),
              ),

              SizedBox(
                height: isMobile ? 16 : 24,
              ).eligibleToSeeIfYouAre(ref, [UserType.ADMIN]),
              SizedBox(height: isMobile ? 8 : 16),
              Expanded(
                child: buildTicketSection(
                  context,
                  filterChips: _buildTicketFilterChips(),
                ),
              ),
            ],
          ),
        );
        return Scaffold(
          appBar: widget.showAppBar
              ? AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () {
                      ref
                          .read(ticketSelectionProvider.notifier)
                          .clearSelection();
                      // ignore: unused_result
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
                      fontWeight: FontWeight.w700,
                      fontSize: titleFontSize,
                      color: Colors.black,
                    ),
                  ),
                  actions: [
                    Consumer(
                      builder: (context, ref, _) {
                        final selection = ref.watch(ticketSelectionProvider);
                        final hasSelection = selection.isNotEmpty;

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (hasSelection) ...[
                              IconButton(
                                onPressed: () => _deleteSelectedTickets(ref),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                tooltip:
                                    'Delete Selected (${selection.length})',
                              ),
                              IconButton(
                                onPressed: () => ref
                                    .read(ticketSelectionProvider.notifier)
                                    .clearSelection(),
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.grey,
                                ),
                                tooltip: 'Clear Selection',
                              ),
                            ],
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'select_all') {
                                  _selectAllTickets(ref);
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 'select_all',
                                  child: Row(
                                    children: [
                                      Icon(Icons.select_all),
                                      SizedBox(width: 8),
                                      Text('Select All'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                )
              : null,
          body: content,
        );
      },
    );
  }
}
