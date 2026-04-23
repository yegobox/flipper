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
const Color _ticketHeaderStripBg = Color(0xFFF2F4F7);
const Color _ticketIconCircleBorder = Color(0xFFE0E4EB);

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
        final buttonFontSize = isMobile ? 14.0 : 16.0;
        final titleFontSize = isMobile ? 16.0 : 20.0;

        ButtonStyle _headerCircleIconStyle() {
          return IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            shape: const CircleBorder(),
            side: const BorderSide(color: _ticketIconCircleBorder, width: 1),
            padding: const EdgeInsets.all(10),
            minimumSize: const Size(40, 40),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        }

        Widget content = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Consumer(
              builder: (context, ref, _) {
                final transaction = widget.transaction;
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
                    : 0;

                return ColoredBox(
                  color: _ticketHeaderStripBg,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      12,
                      horizontalPadding,
                      12,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          backgroundColor: _ticketFilterBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.add,
                              size: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
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
                      ).eligibleToSeeIfYouAre(ref, [AccessLevel.ADMIN]),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: isMobile ? 12 : 16,
            ).eligibleToSeeIfYouAre(ref, [UserType.ADMIN]),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: buildTicketSection(
                  context,
                  filterChips: _buildTicketFilterChips(),
                ),
              ),
            ),
          ],
        );
        return Scaffold(
          backgroundColor: _ticketHeaderStripBg,
          appBar: widget.showAppBar
              ? AppBar(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  centerTitle: false,
                  titleSpacing: 12,
                  leadingWidth: 56,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  leading: IconButton(
                    style: _headerCircleIconStyle(),
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
                    icon: const Icon(Icons.close, size: 22),
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
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: IconButton(
                                  style: _headerCircleIconStyle(),
                                  onPressed: () => _deleteSelectedTickets(ref),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  tooltip:
                                      'Delete Selected (${selection.length})',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: IconButton(
                                  style: _headerCircleIconStyle(),
                                  onPressed: () => ref
                                      .read(ticketSelectionProvider.notifier)
                                      .clearSelection(),
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.grey.shade700,
                                    size: 20,
                                  ),
                                  tooltip: 'Clear Selection',
                                ),
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: PopupMenuButton<String>(
                                padding: EdgeInsets.zero,
                                splashRadius: 22,
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
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _ticketIconCircleBorder,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.more_vert,
                                    size: 22,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
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
