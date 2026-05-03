import 'package:flipper_dashboard/dialog_status.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/ticket_selection_provider.dart';
import 'package:flipper_models/providers/tickets_provider.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_ui/dialogs/ResumeTicketDialog.dart';
import '../models/ticket_status.dart';
// import 'ticket_tile.dart';

const Color _kLoanPurple = Color(0xFF6B4EA2);
const Color _kLayawayTeal = Color(0xFF0D9488);
const Color _kRegularGreen = Color(0xFF2E7D32);
const Color _kAccentBlue = Color(0xff006AFE);
const Color _kProgressOrange = Color(0xFFE08A2E);

bool _isStructuredLoanTicket(ITransaction t) {
  if (t.isLoan != true) return false;
  final installments = t.totalInstallments ?? 1;
  final auto = t.isAutoBilled == true;
  return installments > 1 || auto;
}

bool _isLayawayTicket(ITransaction t) {
  if (t.isLoan != true) return false;
  return !_isStructuredLoanTicket(t);
}

String _ticketDisplayRef(ITransaction ticket) {
  final r = ticket.reference?.trim();
  if (r != null && r.isNotEmpty) return r.toUpperCase();
  final id = ticket.id;
  if (id.length >= 6) return id.substring(0, 6).toUpperCase();
  return id.toUpperCase();
}

String _customerInitials(ITransaction t) {
  final name = (t.customerName ?? t.ticketName ?? '').trim();
  if (name.isEmpty) return '?';
  final parts = name.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
  if (parts.length >= 2) {
    final a = parts[0].isNotEmpty ? parts[0][0] : '';
    final b = parts[1].isNotEmpty ? parts[1][0] : '';
    return ('$a$b').toUpperCase();
  }
  final single = parts[0];
  if (single.length >= 2) return single.substring(0, 2).toUpperCase();
  return single[0].toUpperCase();
}

/// Search bar for filtering tickets by metadata (customer name, phone, etc.)
class TicketSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;

  const TicketSearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
  });

  @override
  State<TicketSearchBar> createState() => _TicketSearchBarState();
}

class _TicketSearchBarState extends State<TicketSearchBar> {
  late final TextEditingController _controller;
  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _listener = () => setState(() {});
    _controller.addListener(_listener);
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: GoogleFonts.outfit(
          fontSize: 14,
          color: Colors.grey[600],
        ),
        prefixIcon: Icon(Icons.search, color: Colors.grey[600], size: 22),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, size: 20, color: Colors.grey[600]),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged('');
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _kAccentBlue, width: 1.2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      style: GoogleFonts.outfit(fontSize: 15),
    );
  }
}

mixin TicketsListMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  final _routerService = locator<RouterService>();
  final _dialogService = locator<DialogService>();
  List<ITransaction> _currentTickets = [];
  String _searchQuery = '';
  /// all | loan | layaway | regular — drives chip row and list filtering
  String _ticketKindFilter = 'all';
  bool _sortNewestFirst = true;

  String get ticketKindFilter => _ticketKindFilter;

  void updateTicketKindFilter(String value) {
    if (_ticketKindFilter == value) return;
    setState(() => _ticketKindFilter = value);
  }

  List<ITransaction> getCurrentTickets() => _currentTickets;

  List<ITransaction> _applyTicketTypeFilter(List<ITransaction> tickets) {
    switch (_ticketKindFilter) {
      case 'loan':
        return tickets.where((t) => t.isLoan == true).toList();
      case 'layaway':
        return tickets.where(_isLayawayTicket).toList();
      case 'regular':
        return tickets.where((t) => t.isLoan != true).toList();
      default:
        return tickets;
    }
  }

  void _sortTicketList(List<ITransaction> list) {
    list.sort((a, b) {
      final da = a.createdAt ?? a.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final db = b.createdAt ?? b.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final c = db.compareTo(da);
      return _sortNewestFirst ? c : -c;
    });
  }

  Future<bool> canDeleteTicket(ITransaction ticket) async {
    if (kDebugMode || ProxyService.box.enableDebug() == true) {
      return true;
    }
    final totalPaid = await ProxyService.getStrategy(Strategy.capella)
        .getTotalPaidForTransaction(
          transactionId: ticket.id,
          branchId: ticket.branchId ?? '',
        );
    return (totalPaid ?? 0.0) <= 0;
  }

  bool _isDeleting = false;
  int _deletedCount = 0;
  int _totalCount = 0;

  Future<void> deleteSelectedTickets(Set<String> selectedIds) async {
    final List<String> failedDeletions = [];
    final List<String> skippedTickets = [];
    final List<String> successfulDeletions = [];

    // Initialize progress tracking
    _isDeleting = true;
    _totalCount = selectedIds.length;
    _deletedCount = 0;
    if (mounted) setState(() {});

    try {
      for (final ticketId in selectedIds) {
        try {
          final ticket = _currentTickets.firstWhere((t) => t.id == ticketId);

          if (!(await canDeleteTicket(ticket))) {
            skippedTickets.add(
              'Ticket #${ticket.reference ?? ticket.id.substring(0, 6).toUpperCase()}',
            );
            continue;
          }

          // Use smart deletion that works across Capella and CloudSync
          final success = await ticket.deleteSmart();
          if (success) {
            successfulDeletions.add(ticketId);
          } else {
            failedDeletions.add(ticketId);
          }
        } catch (e) {
          talker.error('Failed to delete ticket $ticketId: $e');
          failedDeletions.add(ticketId);
        }

        // Update progress after each deletion
        _deletedCount++;
        if (mounted) setState(() {});
      }

      // Refresh the UI after deletion attempts
      if (mounted) setState(() {});

      if (skippedTickets.isNotEmpty && mounted) {
        showCustomSnackBarUtil(
          context,
          'Skipped ${skippedTickets.length} ticket(s) with partial payments',
          backgroundColor: Colors.orange,
        );
      }

      // Throw error only if all deletions failed
      if (failedDeletions.length == selectedIds.length &&
          selectedIds.length > skippedTickets.length) {
        throw Exception('Failed to delete all selected tickets');
      } else if (failedDeletions.isNotEmpty) {
        throw Exception(
          'Failed to delete ${failedDeletions.length} out of ${selectedIds.length} tickets',
        );
      }
    } finally {
      // Reset progress tracking
      _isDeleting = false;
      _totalCount = 0;
      _deletedCount = 0;
      if (mounted) setState(() {});
    }
  }

  /// Returns true if ticket matches the search query (case-insensitive)
  bool _matchesSearch(ITransaction t, String query) {
    if (query.isEmpty) return true;
    final q = query.trim().toLowerCase();
    final fields = [
      t.id,
      t.reference,
      t.customerName,
      t.customerPhone,
      t.ticketName,
      t.note,
      t.transactionNumber,
      t.subTotal?.toString(),
      t.invoiceNumber?.toString(),
    ];
    return fields.any((f) => f != null && f.toString().toLowerCase().contains(q));
  }

  /// Builds the main ticket section (single-column list on all screen sizes).
  Widget buildTicketSection(BuildContext context, {Widget? filterChips}) {
    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return Consumer(
          builder: (context, ref, _) {
            final ticketsAsync = ref.watch(ticketsStreamProvider);
            final column = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_isDeleting)
                  LinearProgressIndicator(
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.blue,
                    ),
                    value: _totalCount > 0 ? _deletedCount / _totalCount : null,
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: TicketSearchBar(
                    hintText:
                        'Search by customer, phone, ticket ID...',
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                if (filterChips != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: filterChips,
                  ),
                Expanded(
                  child: ticketsAsync.when(
                    data: (tickets) => _buildTicketList(context, tickets),
                    loading: () => _buildLoadingState(context),
                    error: (error, stack) => _buildErrorState(error.toString()),
                  ),
                ),
              ],
            );
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.hasBoundedHeight) {
                  return column;
                }
                final mq = MediaQuery.sizeOf(context);
                final h = (mq.height > 0 ? mq.height : 640.0) * 0.82;
                final w = constraints.hasBoundedWidth
                    ? constraints.maxWidth
                    : (mq.width > 0 ? mq.width : 360.0);
                return SizedBox(width: w, height: h, child: column);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAfterFilter(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.filter_alt_off, size: 56, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'No tickets in this category',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Text(
            'Try another filter',
            style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required Color accentColor,
    required int count,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: accentColor,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<bool>(
                value: _sortNewestFirst,
                isDense: true,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                items: const [
                  DropdownMenuItem(value: true, child: Text('Newest first')),
                  DropdownMenuItem(value: false, child: Text('Oldest first')),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => _sortNewestFirst = v);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Single-column scrollable list (matches design on all screen sizes).
  Widget _buildTicketList(
    BuildContext context,
    List<ITransaction> tickets,
  ) {
    final searchFiltered = tickets
        .where((t) => _matchesSearch(t, _searchQuery))
        .toList();

    if (searchFiltered.isEmpty) {
      return _buildEmptySearchOrNoTickets(context, tickets.isEmpty);
    }

    final typeFiltered = _applyTicketTypeFilter(searchFiltered);
    if (typeFiltered.isEmpty) {
      return _buildEmptyAfterFilter(context);
    }

    _sortTicketList(typeFiltered);
    _currentTickets = typeFiltered;

    final loanTickets = typeFiltered.where((t) => t.isLoan == true).toList();
    final nonLoanTickets =
        typeFiltered.where((t) => t.isLoan != true).toList();

    Widget buildSection(String title, Color accentColor, List<ITransaction> list) {
      if (list.isEmpty) return const SizedBox.shrink();

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            title: title,
            accentColor: accentColor,
            count: list.length,
          ),
          for (final ticket in list)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
              child: Consumer(
                builder: (context, ref, _) {
                  final isSelected = ref
                      .watch(ticketSelectionProvider)
                      .contains(ticket.id);
                  return TicketCard(
                    ticket: ticket,
                    isSelected: isSelected,
                    onTap: () => _handleTicketTap(context, ticket),
                    onDelete: () => _deleteTicket(ticket),
                    onSelectionChanged: (selected) {
                      ref
                          .read(ticketSelectionProvider.notifier)
                          .toggleSelection(ticket.id);
                    },
                  );
                },
              ),
            ),
        ],
      );
    }

    String loanSectionTitle() {
      switch (_ticketKindFilter) {
        case 'layaway':
          return 'LAYAWAY TICKETS';
        case 'loan':
          return 'LOAN TICKETS';
        default:
          return 'LOAN TICKETS';
      }
    }

    Color loanSectionAccent() {
      if (_ticketKindFilter == 'layaway') return _kLayawayTeal;
      return _kLoanPurple;
    }

    final List<Widget> scrollChildren = [];
    switch (_ticketKindFilter) {
      case 'loan':
        if (typeFiltered.isNotEmpty) {
          scrollChildren.add(
            buildSection('LOAN TICKETS', _kLoanPurple, typeFiltered),
          );
        }
        break;
      case 'layaway':
        if (typeFiltered.isNotEmpty) {
          scrollChildren.add(
            buildSection('LAYAWAY TICKETS', _kLayawayTeal, typeFiltered),
          );
        }
        break;
      case 'regular':
        if (typeFiltered.isNotEmpty) {
          scrollChildren.add(
            buildSection('REGULAR TICKETS', _kRegularGreen, typeFiltered),
          );
        }
        break;
      default:
        if (loanTickets.isNotEmpty) {
          scrollChildren.add(
            buildSection(
              loanSectionTitle(),
              loanSectionAccent(),
              loanTickets,
            ),
          );
        }
        if (nonLoanTickets.isNotEmpty) {
          scrollChildren.add(
            buildSection(
              'REGULAR TICKETS',
              _kRegularGreen,
              nonLoanTickets,
            ),
          );
        }
    }

    return Column(
      children: [
        if (_isDeleting)
          LinearProgressIndicator(
            value: _totalCount > 0 ? _deletedCount / _totalCount : null,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
            minHeight: 3,
          ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: scrollChildren,
          ),
        ),
      ],
    );
  }

  /// Dialog to update ticket status or resume
  Future<void> _handleTicketTap(
    BuildContext context,
    ITransaction ticket,
  ) async {
    await showResumeTicketDialog(
      context: context,
      ticket: ticket,
      onResume: (t) => _resumeOrder(t),
      onStatusChange: (newStatus) async {
        try {
          await ProxyService.strategy.updateTransaction(
            transaction: ticket,
            status: newStatus,
            updatedAt: DateTime.now().toUtc(),
          );
          if (mounted) setState(() {});
          showCustomSnackBarUtil(
            context,
            'Ticket status updated successfully',
            backgroundColor: Colors.green,
          );
        } catch (e) {
          talker.error('Failed to update status: $e');
          showCustomSnackBarUtil(
            context,
            'Failed to update status',
            backgroundColor: Colors.red,
          );
        }
      },
    );
  }

  /// Park all pending except the one we're resuming
  Future<void> _parkExistingPendingTransactions({
    required String excludeId,
  }) async {
    final strategies = [Strategy.capella, Strategy.cloudSync];
    for (final strategy in strategies) {
      try {
        final pending = await ProxyService.getStrategy(strategy).transactions(
          branchId: ProxyService.box.getBranchId()!,
          status: PENDING,
          includeZeroSubTotal: true,
          agentId: ProxyService.box.getUserId()!,
        );
        talker.debug('Pending to park ($strategy): ${pending.length}');
        for (final tx in pending) {
          if (tx.id == excludeId) continue;
          await ProxyService.getStrategy(
            strategy,
          ).deleteTransaction(transaction: tx);
          talker.info(
            'Deleted pending transaction to clear cart ($strategy): ${tx.id}',
          );
        }
      } catch (e) {
        talker.error('Error parking pending for $strategy: $e');
        // Don't rethrow, just try the next strategy
      }
    }
  }

  /// Resume a parked ticket
  Future<void> _resumeOrder(ITransaction ticket) async {
    try {
      await _parkExistingPendingTransactions(excludeId: ticket.id);

      // Update ticket to belong to current agent and be pending
      ticket.status = PENDING;
      ticket.agentId = ProxyService.box.getUserId();

      await ProxyService.strategy.updateTransaction(
        transaction: ticket,
        status: PENDING,
        updatedAt: DateTime.now().toUtc(),
        lastTouched: DateTime.now().toUtc(),
      );
      final isMobile = MediaQuery.sizeOf(context).width < 600;
      if (isMobile) {
        await _routerService.navigateTo(CheckOutRoute(isBigScreen: !isMobile));
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
            content: Text(e.toString(), style: const TextStyle(fontSize: 14)),
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
    if (!(await canDeleteTicket(ticket))) {
      await _dialogService.showCustomDialog(
        variant: DialogType.info,
        title: 'Error',
        description: 'This ticket has partial payments and cannot be deleted.',
        data: {'status': InfoDialogStatus.error},
      );
      return;
    }

    bool confirmed = false;
    if (mounted) {
      confirmed =
          await showDialog<bool>(
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
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ) ??
          false;
    }
    if (!confirmed) return;

    setState(() => _isDeleting = true);

    try {
      // Use smart deletion that works across Capella and CloudSync
      final success = await ticket.deleteSmart();
      if (success) {
        showCustomSnackBarUtil(
          context,
          'Ticket deleted',
          backgroundColor: Colors.red,
        );
      } else {
        showCustomSnackBarUtil(
          context,
          'Failed to delete ticket',
          backgroundColor: Colors.red,
        );
      }
    } catch (e, st) {
      talker.error('Delete failed: $e', st);
      showCustomSnackBarUtil(
        context,
        'Delete failed',
        backgroundColor: Colors.red,
      );
    } finally {
      if (mounted) setState(() => _isDeleting = false);
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
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(
            'Create a new ticket to get started',
            style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  /// Empty state for no search results vs no tickets at all
  Widget _buildEmptySearchOrNoTickets(BuildContext context, bool hasNoTickets) {
    if (hasNoTickets) {
      return _buildNoTickets(context);
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'No tickets match your search',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(
            'Try a different search term',
            style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[600]),
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
            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500),
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
}

class TicketCard extends StatelessWidget {
  final ITransaction ticket;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final ValueChanged<bool> onSelectionChanged;
  const TicketCard({
    super.key,
    required this.ticket,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
    required this.onSelectionChanged,
  });

  Color _leftAccent() {
    if (ticket.isLoan != true) return _kAccentBlue;
    return _isLayawayTicket(ticket) ? _kLayawayTeal : _kLoanPurple;
  }

  Widget _typePill() {
    if (ticket.isLoan != true) return const SizedBox.shrink();
    final layaway = _isLayawayTicket(ticket);
    final fg = layaway ? _kLayawayTeal : _kLoanPurple;
    final bg = layaway
        ? const Color(0xFFE0F2F1)
        : const Color(0xFFF3E5F5);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        layaway ? 'Layaway' : 'Loan',
        style: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusExt = TicketStatusExtension.fromString(ticket.status ?? PARKED);
    final phone = (ticket.customerPhone ?? ticket.currentSaleCustomerPhoneNumber ?? '')
        .trim();
    final displayName =
        (ticket.customerName ?? ticket.ticketName ?? 'Walk-in').trim();

    return Material(
      color: Colors.transparent,
      child: FutureBuilder<double?>(
        future: ProxyService.getStrategy(Strategy.capella).getTotalPaidForTransaction(
          transactionId: ticket.id,
          branchId: ticket.branchId ?? '',
          excludePaymentMethod: 'CREDIT',
        ),
        builder: (context, snapshot) {
          final total = ticket.subTotal ?? 0.0;
          final paid = snapshot.data ?? 0.0;
          final remaining = (total - paid);
          final remClamped = remaining < 0 ? 0.0 : remaining;
          final partial = paid > 0 && remClamped > 0;

          final String statusLabel;
          final Color statusFg;
          final Color statusBg;
          if (partial) {
            statusLabel = 'Partial';
            statusFg = const Color(0xFFC62828);
            statusBg = const Color(0xFFFFEBEE);
          } else {
            statusLabel = statusExt.displayName;
            statusFg = statusExt.color;
            final raw = (ticket.status ?? PARKED).toLowerCase();
            if (raw == PARKED) {
              statusBg = const Color(0xFFFFF9E6);
            } else {
              statusBg = statusExt.color.withValues(alpha: 0.15);
            }
          }

          final progress = total <= 0 ? 0.0 : (paid / total).clamp(0.0, 1.0);
          final fullyPaid =
              total > 0 && (remClamped <= 0 || progress >= 1.0 - 1e-9);
          final progressColor =
              fullyPaid ? _kRegularGreen : _kProgressOrange;

          return InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE8F1FF) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? _kAccentBlue : Colors.grey[300]!,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(width: 4, color: _leftAccent()),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 12, 12, 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (v) =>
                                      onSelectionChanged(v ?? false),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Ticket #${_ticketDisplayRef(ticket)}',
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (ticket.isLoan == true) ...[
                                  const SizedBox(width: 4),
                                  _typePill(),
                                ],
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusBg,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      statusLabel,
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: statusFg,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (ticket.ticketName != null &&
                                ticket.ticketName!.trim().isNotEmpty &&
                                ticket.customerName != null &&
                                ticket.ticketName!.trim() !=
                                    ticket.customerName!.trim()) ...[
                              const SizedBox(height: 6),
                              Text(
                                ticket.ticketName!,
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            if (ticket.note != null &&
                                ticket.note!.trim().isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.note_alt_outlined,
                                      size: 14, color: Colors.grey[600]),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      ticket.note!,
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        color: Colors.grey[800],
                                        height: 1.35,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: _leftAccent(),
                                  child: Text(
                                    _customerInitials(ticket),
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    displayName,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _kAccentBlue,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (phone.isNotEmpty)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.phone,
                                          size: 15, color: Colors.grey[600]),
                                      const SizedBox(width: 4),
                                      Text(
                                        phone,
                                        style: GoogleFonts.outfit(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _moneyCol(
                                    'TOTAL',
                                    (ticket.subTotal ?? 0)
                                        .toCurrencyFormatted(),
                                    valueColor: Colors.black87,
                                    emphasize: true,
                                  ),
                                ),
                                Expanded(
                                  child: _moneyCol(
                                    'PAID',
                                    paid.toCurrencyFormatted(),
                                    valueColor: paid > 0
                                        ? const Color(0xFF2E7D32)
                                        : Colors.grey.shade400,
                                    emphasize: paid > 0,
                                  ),
                                ),
                                Expanded(
                                  child: _moneyCol(
                                    'REMAINING',
                                    remClamped.toCurrencyFormatted(),
                                    valueColor: remClamped > 0
                                        ? const Color(0xFFC62828)
                                        : Colors.grey.shade400,
                                    emphasize: remClamped > 0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress.isNaN ? 0 : progress,
                                minHeight: 6,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  progressColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Created ${_formatDate(ticket.createdAt)}',
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                _squareIconBtn(
                                  icon: Icons.play_arrow,
                                  color: _kAccentBlue,
                                  onPressed: onTap,
                                  tooltip: 'Resume Order',
                                ),
                                const SizedBox(width: 8),
                                _squareIconBtn(
                                  icon: Icons.delete_outline,
                                  color: Colors.red[700]!,
                                  onPressed: onDelete,
                                  tooltip: 'Delete Ticket',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ),
          );
        },
      ),
    );
  }

  Widget _moneyCol(
    String label,
    String value, {
    required Color valueColor,
    bool emphasize = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: emphasize ? FontWeight.w700 : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _squareIconBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 20, color: color),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    final local = date.toLocal();
    return '${local.month.toString().padLeft(2, '0')}/${local.day.toString().padLeft(2, '0')} '
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}
