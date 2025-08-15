import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_dashboard/new_ticket.dart';
import 'package:flipper_dashboard/utils/snack_bar_utils.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/providers/ticket_selection_provider.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';

import '../widgets/tickets_list.dart';

class TicketsScreen extends StatefulHookConsumerWidget {
  const TicketsScreen(
      {Key? key, required this.transaction, this.showAppBar = true})
      : super(key: key);

  final ITransaction? transaction;
  final bool showAppBar;

  @override
  _TicketsScreenState createState() => _TicketsScreenState();
}

class _TicketsScreenState extends ConsumerState<TicketsScreen>
    with TicketsListMixin {
  final _routerService = locator<RouterService>();
  String _sortFilter = 'all'; // 'all', 'regular', 'loans'

  @override
  List<ITransaction> getCurrentTickets() {
    final allTickets = super.getCurrentTickets();
    switch (_sortFilter) {
      case 'regular':
        return allTickets.where((t) => t.isLoan != true).toList();
      case 'loans':
        return allTickets.where((t) => t.isLoan == true).toList();
      default:
        return allTickets;
    }
  }

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
    final validSelectedIds =
        selectedIds.where((id) => visibleTicketIds.contains(id)).toSet();

    // Clear invalid selections
    if (validSelectedIds.length != selectedIds.length) {
      ref.read(ticketSelectionProvider.notifier).clearSelection();
      // Re-select only valid tickets
      final validTickets =
          visibleTickets.where((t) => validSelectedIds.contains(t.id)).toList();
      if (validTickets.isNotEmpty) {
        ref.read(ticketSelectionProvider.notifier).selectAll(validTickets);
      }
    }

    if (validSelectedIds.isEmpty) return;

    final selectedTickets =
        visibleTickets.where((t) => validSelectedIds.contains(t.id)).toList();

    showDeletionConfirmationSnackBar(
      context,
      selectedTickets,
      (ticket) => 'Ticket #${ticket.reference ?? ticket.id.substring(0, 8)}',
      () async {
        try {
          await deleteSelectedTickets(validSelectedIds);
          ref.read(ticketSelectionProvider.notifier).clearSelection();
          if (mounted) {
            showCustomSnackBarUtil(
              context,
              '${validSelectedIds.length} ticket${validSelectedIds.length == 1 ? '' : 's'} deleted successfully',
              backgroundColor: Colors.green,
            );
          }
        } catch (e) {
          if (mounted) {
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
                  width: isMobile ? double.infinity : 220,
                  child: Consumer(
                    builder: (context, ref, _) {
                      final transaction = widget.transaction;
                      final transactionItems = transaction != null
                          ? ref.watch(transactionItemsProvider(
                              transactionId: transaction.id,
                            ))
                          : const AsyncValue<List<dynamic>>.data([]);

                      final itemCount = transactionItems.value?.length ?? 0;
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff006AFE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
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
                                    'Please add items to the transaction before creating a ticket'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add,
                                size: 18, color: Colors.white),
                            const SizedBox(width: 6),
                            Text(
                              'Create Ticket${itemCount > 0 ? ' ($itemCount ${itemCount == 1 ? 'item' : 'items'})' : ''}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
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
              SizedBox(height: isMobile ? 16 : 24)
                  .eligibleToSeeIfYouAre(ref, [UserType.ADMIN]),
              SizedBox(height: isMobile ? 8 : 16),
              // Make ticket section scrollable on mobile
              Expanded(
                child: isMobile
                    ? Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.7,
                        ),
                        child: buildTicketSection(context),
                      )
                    : buildTicketSection(context),
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
                      fontWeight: FontWeight.w400,
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
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                tooltip:
                                    'Delete Selected (${selection.length})',
                              ),
                              IconButton(
                                onPressed: () => ref
                                    .read(ticketSelectionProvider.notifier)
                                    .clearSelection(),
                                icon:
                                    const Icon(Icons.clear, color: Colors.grey),
                                tooltip: 'Clear Selection',
                              ),
                            ],
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'select_all') {
                                  _selectAllTickets(ref);
                                } else if (value.startsWith('sort_')) {
                                  setState(() {
                                    _sortFilter = value.substring(5);
                                  });
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'select_all',
                                  child: Row(
                                    children: [
                                      Icon(Icons.select_all),
                                      SizedBox(width: 8),
                                      Text('Select All'),
                                    ],
                                  ),
                                ),
                                const PopupMenuDivider(),
                                PopupMenuItem(
                                  value: 'sort_all',
                                  child: Row(
                                    children: [
                                      Icon(Icons.list,
                                          color: _sortFilter == 'all'
                                              ? Colors.blue
                                              : null),
                                      const SizedBox(width: 8),
                                      Text('All Tickets',
                                          style: TextStyle(
                                              color: _sortFilter == 'all'
                                                  ? Colors.blue
                                                  : null)),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'sort_regular',
                                  child: Row(
                                    children: [
                                      Icon(Icons.receipt,
                                          color: _sortFilter == 'regular'
                                              ? Colors.blue
                                              : null),
                                      const SizedBox(width: 8),
                                      Text('Regular Tickets',
                                          style: TextStyle(
                                              color: _sortFilter == 'regular'
                                                  ? Colors.blue
                                                  : null)),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'sort_loans',
                                  child: Row(
                                    children: [
                                      Icon(Icons.credit_card,
                                          color: _sortFilter == 'loans'
                                              ? Colors.blue
                                              : null),
                                      const SizedBox(width: 8),
                                      Text('Loan Tickets',
                                          style: TextStyle(
                                              color: _sortFilter == 'loans'
                                                  ? Colors.blue
                                                  : null)),
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
