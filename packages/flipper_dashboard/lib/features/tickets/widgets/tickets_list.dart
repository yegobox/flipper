import 'dart:async';
import 'dart:math' as math;

import 'package:flipper_dashboard/mobile_checkout_launcher.dart';
import 'package:flipper_dashboard/dialog_status.dart';
import 'package:flipper_dashboard/utils/resume_transaction_helper.dart';
import 'package:flipper_dashboard/utils/ticket_handover_finalize.dart';
import 'package:flipper_dashboard/utils/ticket_workflow_complete_launcher.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/services/park_transaction_service.dart';
import 'package:flipper_models/services/resume_transaction_service.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/park_transaction_provider.dart';
import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_models/providers/ticket_selection_provider.dart';
import 'package:flipper_models/providers/tickets_provider.dart';
import 'package:flipper_models/helpers/ticket_review_actions.dart';
import 'package:flipper_models/helpers/pending_sale_cart_cleanup.dart';
import 'package:flipper_models/order_form_whatsapp_client.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_ui/dialogs/ResumeTicketDialog.dart';
import '../models/ticket_status.dart';
import '../providers/handover_staff_provider.dart';
import '../utils/order_form_pdf.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'handover_staff_picker_panel.dart';
// import 'ticket_tile.dart';

const Color _kLoanPurple = Color(0xFF6B4EA2);
const Color _kLayawayTeal = Color(0xFF0D9488);
const Color _kRegularGreen = Color(0xFF2E7D32);
const Color _kAccentBlue = Color(0xff006AFE);
const Color _kCollectBlue = Color(0xFF2F6FED);
const Color _kProgressOrange = Color(0xFFE08A2E);
const Color _kAwaitingBg = Color(0xFFFEF3C7);
const Color _kAwaitingFg = Color(0xFF92400E);

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

/// Paid amount for ticket cards: live tender sums when present, else the
/// synced ticket [ITransaction.cashReceived] (same field updated on partial pay).
double _paidAmountForTicket(
  ITransaction ticket,
  Map<String, double> paymentSumsByTxnId,
) {
  final fromRecords = paymentSumsByTxnId[ticket.id] ?? 0.0;
  final fromTicket = ticket.cashReceived ?? 0.0;
  return math.max(fromRecords, fromTicket);
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
        hintStyle: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[600]),
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      style: GoogleFonts.outfit(fontSize: 15),
    );
  }
}

mixin TicketsListMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
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
      final da =
          a.createdAt ?? a.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final db =
          b.createdAt ?? b.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final c = db.compareTo(da);
      return _sortNewestFirst ? c : -c;
    });
  }

  Future<bool> canDeleteTicket(ITransaction ticket) async {
    if (kDebugMode || ProxyService.box.enableDebug() == true) {
      return true;
    }
    if (isTicketDeleteBlockedByReviewWorkflow(ticket.status)) {
      return false;
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

  /// Ticket whose WhatsApp recipient panel is open (list stays visible).
  ITransaction? _whatsAppPickerTicket;

  static const double _whatsAppPickerPanelWidth = 380;

  /// Id of the ticket whose Collect / Complete button is mid-flow, so its card
  /// shows a spinner and blocks re-taps until the hand-off completes.
  String? _collectingTicketId;

  bool get _ticketReviewWorkflowEnabled =>
      ProxyService.settings.enableTicketReviewWorkflow;

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
          'Skipped ${skippedTickets.length} ticket(s) that cannot be deleted '
          '(partial payments or reviewed)',
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
    return fields.any(
      (f) => f != null && f.toString().toLowerCase().contains(q),
    );
  }

  /// Builds the main ticket section (single-column list on all screen sizes).
  Widget buildTicketSection(BuildContext context, {Widget? filterChips}) {
    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        final column = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isDeleting)
              LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                value: _totalCount > 0 ? _deletedCount / _totalCount : null,
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: TicketSearchBar(
                hintText: 'Search by customer, phone, ticket ID...',
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            if (filterChips != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: filterChips,
              ),
            Expanded(
              child: _buildTicketsPaneWithWhatsAppPicker(context),
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
  }

  Widget _buildTicketsPaneWithWhatsAppPicker(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final ticketsAsync = ref.watch(visibleTicketsProvider);
        final paymentSumsAsync = ref.watch(ticketsPaymentSumsProvider);
        final paymentSums = paymentSumsAsync.hasValue
            ? paymentSumsAsync.requireValue
            : const <String, double>{};

        Widget ticketPane;
        final tickets = ticketsAsync.value;
        if (tickets != null) {
          ticketPane = _buildTicketList(
            context,
            tickets,
            paymentSumsByTxnId: paymentSums,
          );
        } else {
          ticketPane = ticketsAsync.when(
            data: (data) => _buildTicketList(
              context,
              data,
              paymentSumsByTxnId: paymentSums,
            ),
            loading: () => _buildLoadingState(context),
            error: (error, stack) => _buildErrorState(error.toString()),
          );
        }

        final pickerTicket = _whatsAppPickerTicket;
        if (pickerTicket == null) return ticketPane;

        final panel = DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(left: BorderSide(color: Color(0xFFE5E7EB))),
            boxShadow: [
              BoxShadow(
                color: Color(0x14000000),
                offset: Offset(-4, 0),
                blurRadius: 16,
              ),
            ],
          ),
          child: HandoverStaffPickerPanel(
            key: ValueKey('wa-picker-${pickerTicket.id}'),
            ticket: pickerTicket,
            isSending: _sendingOrderFormWhatsAppTicketIds.contains(
              pickerTicket.id,
            ),
            onClose: _closeWhatsAppPicker,
            onStaffSelected: (member) => unawaited(
              _sendOrderFormWhatsAppTo(member, pickerTicket),
            ),
          ),
        );

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final useOverlay = width <
                PosLayoutBreakpoints.mobileLayoutMaxWidth + _whatsAppPickerPanelWidth;

            if (useOverlay) {
              final panelWidth = (width * 0.88).clamp(280.0, _whatsAppPickerPanelWidth);
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  ticketPane,
                  Positioned(
                    top: 0,
                    right: 0,
                    bottom: 0,
                    width: panelWidth,
                    child: panel,
                  ),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: ticketPane),
                SizedBox(width: _whatsAppPickerPanelWidth, child: panel),
              ],
            );
          },
        );
      },
    );
  }

  void _openWhatsAppPicker(ITransaction ticket) {
    if (_sendingOrderFormWhatsAppTicketIds.contains(ticket.id)) return;
    setState(() => _whatsAppPickerTicket = ticket);
  }

  void _closeWhatsAppPicker() {
    if (_whatsAppPickerTicket == null) return;
    setState(() => _whatsAppPickerTicket = null);
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

  List<_TicketListEntry> _flattenTicketEntries(
    List<ITransaction> typeFiltered,
  ) {
    final loanTickets = typeFiltered.where((t) => t.isLoan == true).toList();
    final nonLoanTickets = typeFiltered.where((t) => t.isLoan != true).toList();

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

    void addSection(
      List<_TicketListEntry> out,
      String title,
      Color accent,
      List<ITransaction> list,
    ) {
      if (list.isEmpty) return;
      out.add(
        _TicketListEntry.header(
          title: title,
          accentColor: accent,
          count: list.length,
        ),
      );
      for (final ticket in list) {
        out.add(_TicketListEntry.ticket(ticket));
      }
    }

    final entries = <_TicketListEntry>[];
    switch (_ticketKindFilter) {
      case 'loan':
        addSection(entries, 'LOAN TICKETS', _kLoanPurple, typeFiltered);
        break;
      case 'layaway':
        addSection(entries, 'LAYAWAY TICKETS', _kLayawayTeal, typeFiltered);
        break;
      case 'regular':
        addSection(entries, 'REGULAR TICKETS', _kRegularGreen, typeFiltered);
        break;
      default:
        addSection(
          entries,
          loanSectionTitle(),
          loanSectionAccent(),
          loanTickets,
        );
        addSection(entries, 'REGULAR TICKETS', _kRegularGreen, nonLoanTickets);
    }
    return entries;
  }

  /// Single-column scrollable list (matches design on all screen sizes).
  Widget _buildTicketList(
    BuildContext context,
    List<ITransaction> tickets, {
    required Map<String, double> paymentSumsByTxnId,
  }) {
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

    final entries = _flattenTicketEntries(typeFiltered);

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
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              if (entry.isHeader) {
                return _buildSectionHeader(
                  title: entry.sectionTitle!,
                  accentColor: entry.accentColor!,
                  count: entry.sectionCount!,
                );
              }
              final ticket = entry.ticket!;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 5,
                ),
                child: Consumer(
                  builder: (context, ref, _) {
                    final isSelected = ref.watch(
                      ticketSelectionProvider.select(
                        (s) => s.contains(ticket.id),
                      ),
                    );
                    final canCollect =
                        ref.watch(canCollectPosPaymentProvider);
                    final canRecordHandover = ref.watch(
                      featureAccessProvider(
                        userId: ProxyService.box.getUserId() ?? '',
                        featureName: AppFeature.StockHandover,
                      ),
                    );
                    final reviewWorkflowOn = _ticketReviewWorkflowEnabled;
                    final isParked =
                        (ticket.status ?? '').toLowerCase() == PARKED;
                    final isAwaitingHandover =
                        (ticket.status ?? '') == AWAITING_HANDOVER;
                    final isWhatsAppPickerActive =
                        _whatsAppPickerTicket?.id == ticket.id;
                    return TicketCard(
                      key: ValueKey(ticket.id),
                      ticket: ticket,
                      isSelected: isSelected,
                      isWhatsAppPickerActive: isWhatsAppPickerActive,
                      // Prefer live payment-record sums; fall back to
                      // cashReceived on the synced ticket so peers still show
                      // Partial/PAID if tender docs arrive slightly later.
                      paidAmount: _paidAmountForTicket(
                        ticket,
                        paymentSumsByTxnId,
                      ),
                      showCollect: canCollect && isParked,
                      showComplete: reviewWorkflowOn &&
                          canCollect &&
                          !isParked &&
                          !(isAwaitingHandover && canRecordHandover),
                      // Resume only for parked tickets — WAITING / handover rows
                      // must not be yanked into the till cart.
                      showResume: !reviewWorkflowOn && canCollect && isParked,
                      canManage: canCollect,
                      isCollecting: _collectingTicketId == ticket.id,
                      showRecordHandover: canRecordHandover,
                      isPrintingOrderForm:
                          _printingOrderFormTicketIds.contains(ticket.id),
                      isSendingOrderFormWhatsApp:
                          _sendingOrderFormWhatsAppTicketIds.contains(ticket.id),
                      orderFormWhatsAppSent:
                          _sentOrderFormWhatsAppTicketIds.contains(ticket.id),
                      onTap: () => _handleTicketTap(ticket),
                      onCollect: () => unawaited(_collectTillTicket(ticket)),
                      onComplete: () =>
                          unawaited(_completeTicket(context, ticket)),
                      onRecordHandover: () =>
                          unawaited(_recordHandover(context, ticket)),
                      onPrintOrderForm: () =>
                          unawaited(_printReviewedTicketOrderForm(ticket)),
                      onSendOrderFormWhatsApp: () => _openWhatsAppPicker(ticket),
                      onDelete: () => _deleteTicket(ticket),
                      onSelectionChanged: (selected) {
                        ref
                            .read(ticketSelectionProvider.notifier)
                            .toggleSelection(ticket.id);
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Ticket Review + Handover workflow: complete a ticket from the list —
  /// reviewed tickets finalize handover; others run the same Pay path as
  /// [QuickSellingView] (send for review when fully paid).
  Future<void> _completeTicket(
    BuildContext context,
    ITransaction ticket,
  ) async {
    if (_collectingTicketId != null) return;
    if (!_ticketReviewWorkflowEnabled) {
      await _handleTicketTap(ticket);
      return;
    }

    setState(() => _collectingTicketId = ticket.id);
    try {
      if ((ticket.status ?? '') == AWAITING_HANDOVER) {
        await _recordHandover(context, ticket);
        return;
      }
      await runTicketWorkflowCompleteFromList(context, ref, ticket);
    } finally {
      if (mounted) setState(() => _collectingTicketId = null);
    }
  }

  /// Resume a parked ticket into settling mode for till payment collection.
  Future<void> _collectTillTicket(ITransaction ticket) async {
    // Ignore re-taps while this ticket is already being collected.
    if (_collectingTicketId != null) return;
    setState(() => _collectingTicketId = ticket.id);
    try {
      final ok = await _handOffTicketToCheckout(ticket, asSettling: true);
      if (!ok || !mounted) return;
    } finally {
      if (mounted) setState(() => _collectingTicketId = null);
    }
  }

  /// Dialog to update ticket status or resume
  /// Uses the screen's own [State.context] (guarded by [mounted]) rather than a
  /// row context: resuming removes this ticket from the parked list, destroying
  /// the row element mid-await.
  Future<void> _handleTicketTap(ITransaction ticket) async {
    // Staff cannot collect payment — ticket rows stay informational.
    if (!ref.read(canCollectPosPaymentProvider)) {
      return;
    }
    // Without review workflow, only parked tickets may be resumed into the till.
    if (!_ticketReviewWorkflowEnabled &&
        (ticket.status ?? '').toLowerCase() != PARKED) {
      return;
    }
    // Ignore re-taps while a handoff is already in flight (double-resume hung
    // Ditto write locks in production logs).
    if (_collectingTicketId != null) return;
    setState(() => _collectingTicketId = ticket.id);
    var resumeSucceeded = false;
    try {
      await showResumeTicketDialog(
        context: context,
        ticket: ticket,
        onResume: (t) async {
          resumeSucceeded =
              await _handOffTicketToCheckout(t, asSettling: true);
        },
      );
    } finally {
      if (mounted) setState(() => _collectingTicketId = null);
    }
    if (!resumeSucceeded || !mounted) return;
    showCustomSnackBarUtil(
      context,
      'Order resumed successfully',
      backgroundColor: Colors.green,
    );
  }

  /// Shared Collect / Resume handoff: resume in Capella, prime cart, enter
  /// settling (so Pay targets this ticket), navigate back to checkout.
  ///
  /// Captures park time from [ticket.lastTouched] **before** resume bumps it,
  /// and stores [ticket] as [SettlingTillTicket.ticketSnapshot] so Pay does not
  /// fall through to the collector's empty pending cart while
  /// [transactionByIdProvider] loads.
  /// Takes no [BuildContext]: the caller used to pass the tapped row's context,
  /// but [_resumeOrder] flips this ticket to PENDING and invalidates the ticket
  /// providers, so the row leaves the parked list and its element is destroyed
  /// while this method is still awaiting. Reading `MediaQuery.sizeOf` off that
  /// defunct element threw "Null check operator used on a null value" out of
  /// `Element.widget` — *before* the close below ran, which is why Collect left
  /// the tickets page open with no error shown (the throw escaped through
  /// `unawaited`). [mounted] does not catch it: it tracks this screen's State,
  /// not the row. The screen's own [State.context] stays valid while mounted.
  Future<bool> _handOffTicketToCheckout(
    ITransaction ticket, {
    required bool asSettling,
  }) async {
    // Every exit from this method is logged with the same `[collect-handoff]`
    // tag: "Collect did not close the tickets page" has several possible causes
    // (slow resume still awaiting the orphan-cart sweep, an aborted re-park, an
    // unmounted route) and the tag says which one happened, and whether the
    // close was actually reached.
    final handoffWatch = Stopwatch()..start();
    void logHandoff(String outcome) {
      talker.info(
        '[collect-handoff] txn=${ticket.id} outcome=$outcome '
        'asSettling=$asSettling elapsedMs=${handoffWatch.elapsedMilliseconds}',
      );
    }

    // Already settling this ticket — just return to checkout.
    final currentSettling = ref.read(settlingTillTicketProvider);
    if (currentSettling != null &&
        currentSettling.transactionId == ticket.id) {
      logHandoff('already-settling-close');
      if (MediaQuery.sizeOf(context).width < 600) {
        unawaited(openMobileCheckoutForTransaction(context, ref, ticket));
      } else {
        locator<RouterService>().back();
      }
      return true;
    }

    // If another ticket is mid-settle, re-park it first. Abort if that fails so
    // we never clear settling while leaving A as orphan PENDING.
    if (currentSettling != null &&
        currentSettling.transactionId.isNotEmpty &&
        currentSettling.transactionId != ticket.id) {
      final reparked = await _reparkSettlingTicket(currentSettling);
      if (!reparked) {
        logHandoff('aborted-prior-repark-failed');
        return false;
      }
    }

    final parkedAt =
        ticket.lastTouched ?? ticket.createdAt ?? DateTime.now();

    final ok = await _resumeOrder(ticket);
    // Resume awaits clearPendingSaleCartsExcept, which sweeps every orphan
    // pending cart on this branch; with a large backlog that is seconds of Ditto
    // write work before the close below can run.
    talker.info(
      '[collect-handoff] txn=${ticket.id} resumeOk=$ok '
      'resumeMs=${handoffWatch.elapsedMilliseconds}',
    );
    if (!ok) {
      logHandoff('resume-failed');
      return false;
    }
    if (!mounted) {
      // Capella already flipped this ticket to PENDING; put it back on the
      // till queue so it is not lost when the Tickets route was disposed mid-handoff.
      logHandoff('unmounted-after-resume');
      unawaited(_emergencyReparkResumedTicket(ticket));
      return false;
    }

    if (!asSettling) {
      logHandoff('resume-only-no-close');
      return true;
    }

    final originalAgentId = ticket.agentId;
    var creatorName = 'Staff';
    if (originalAgentId != null && originalAgentId.isNotEmpty) {
      try {
        final tenant = await ProxyService.strategy.tenant(
          userId: originalAgentId,
          fetchRemote: false,
        );
        final name = tenant?.name?.trim();
        if (name != null && name.isNotEmpty) creatorName = name;
      } catch (_) {}
    }

    final settlingBranchId = ticket.branchId ?? ProxyService.box.getBranchId();

    List<TransactionItem> seedItems = const <TransactionItem>[];
    try {
      seedItems = await ProxyService.getStrategy(Strategy.capella)
          .transactionItems(
        transactionId: ticket.id,
        branchId: settlingBranchId,
        active: true,
      );
    } catch (e, st) {
      talker.warning('Collect: seed items prefetch failed: $e', st);
    }
    talker.info(
      '[collect-seed] txn=${ticket.id} branch=$settlingBranchId '
      'ticketBranch=${ticket.branchId} boxBranch=${ProxyService.box.getBranchId()} '
      'seedCount=${seedItems.length}',
    );
    if (!mounted) {
      logHandoff('unmounted-after-seed');
      unawaited(_emergencyReparkResumedTicket(ticket));
      return false;
    }

    ticket.status = PENDING;
    ref.read(settlingTillTicketProvider.notifier).state = SettlingTillTicket(
      transactionId: ticket.id,
      displayRef: _ticketDisplayRef(ticket),
      creatorName: creatorName,
      createdAt: parkedAt,
      branchId: settlingBranchId,
      ticketName: ticket.ticketName,
      ticketNote: ticket.note,
      seedItems: seedItems,
      ticketSnapshot: ticket,
    );

    final isMobileWidth = MediaQuery.sizeOf(context).width < 600;
    logHandoff(isMobileWidth ? 'close-mobile-checkout' : 'close-router-back');
    if (isMobileWidth) {
      unawaited(openMobileCheckoutForTransaction(context, ref, ticket));
    } else {
      locator<RouterService>().back();
    }
    return true;
  }

  /// Returns true when the prior settling ticket was re-parked (or already gone).
  Future<bool> _reparkSettlingTicket(SettlingTillTicket settling) async {
    try {
      final branchId =
          settling.branchId ?? ProxyService.box.getBranchId() ?? '';
      final txn = settling.ticketSnapshot ??
          await ProxyService.getStrategy(Strategy.capella).getTransaction(
            id: settling.transactionId,
            branchId: branchId,
          );
      if (txn != null &&
          (txn.status ?? '').toLowerCase() == PENDING.toLowerCase()) {
        await ref.read(parkTransactionProvider.notifier).park(
              ticketName: pendingSaleCartReparkTicketName(
                id: settling.transactionId,
                ticketName: settling.ticketName,
                customerName: settling.ticketSnapshot?.customerName ??
                    txn.customerName,
                reference: settling.displayRef,
              ),
              ticketNote: settling.ticketNote ?? 'Sent to till for payment',
              transaction: txn,
              customerId: txn.customerId,
            );
      }
      ref.read(settlingTillTicketProvider.notifier).state = null;
      clearPinnedPosCartTransactionIfWidget(
        ref,
        transactionId: settling.transactionId,
      );
      return true;
    } catch (e, st) {
      talker.error('Re-park previous settling ticket failed: $e', st);
      // Keep settling set so ticket A is not orphaned as PENDING off the list.
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          'Could not return the current ticket to the till. Try again.',
          backgroundColor: Colors.red,
        );
      }
      return false;
    }
  }

  Future<void> _emergencyReparkResumedTicket(ITransaction ticket) async {
    try {
      await ParkTransactionService.park(
        ticketName: pendingSaleCartReparkTicketName(
          id: ticket.id,
          ticketName: ticket.ticketName,
          customerName: ticket.customerName,
          reference: _ticketDisplayRef(ticket),
        ),
        ticketNote: ticket.note ?? 'Sent to till for payment',
        transaction: ticket,
        customerId: ticket.customerId,
      );
    } catch (e, st) {
      talker.error('Emergency re-park after aborted handoff failed: $e', st);
    }
  }

  /// Resume a parked ticket (target: under 3s before UI handoff).
  Future<bool> _resumeOrder(ITransaction ticket) async {
    try {
      final branchId = ProxyService.box.getBranchId() ?? ticket.branchId ?? '';
      final agentId = ProxyService.box.getUserId();
      if (branchId.isEmpty || agentId == null || agentId.isEmpty) {
        throw Exception('Missing branch or agent for resume');
      }

      await ResumeTransactionService.resume(
        ticket: ticket,
        branchId: branchId,
        agentId: agentId,
      );

      // Seed box/providers from the ticket's denormalized customer fields so
      // Pay + receipt print use this ticket's customer, not a prior cart's.
      await TransactionInitializationHelper.initializeCustomer(
        ref,
        ticket,
        replaceSession: true,
      );

      primePosCartForTransactionWidget(
        ref,
        isExpense: false,
        transaction: ticket,
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.invalidate(pendingTransactionStreamProvider(isExpense: false));
        if (branchId.isNotEmpty) {
          ref.invalidate(
            transactionItemsStreamProvider(
              transactionId: ticket.id,
              branchId: branchId,
            ),
          );
        }
      });

      return true;
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
      return false;
    }
  }

  /// Tickets currently printing their post-review Order Form, so the
  /// stepper's "Print Order Form" node can show a spinner and block re-taps.
  final Set<String> _printingOrderFormTicketIds = {};

  /// Tickets currently sending the order form PDF via WhatsApp.
  final Set<String> _sendingOrderFormWhatsAppTicketIds = {};

  /// Tickets whose order form was successfully sent on WhatsApp this session.
  final Set<String> _sentOrderFormWhatsAppTicketIds = {};

  /// Ticket Review + Handover workflow: prints an Order Form (item names +
  /// quantities only) once a ticket is reviewed, so stock staff can pick and
  /// hand over the physical goods. This is NOT a receipt — it never touches
  /// [TaxController], EBM/RRA, counters, or ticket status. The real fiscal
  /// receipt is generated later, at handover ([finalizeTicketHandover]).
  Future<void> _printReviewedTicketOrderForm(ITransaction ticket) async {
    if (_printingOrderFormTicketIds.contains(ticket.id)) return;
    setState(() => _printingOrderFormTicketIds.add(ticket.id));
    try {
      final branchId = ticket.branchId ?? ProxyService.box.getBranchId() ?? '';
      final items = await ProxyService.getStrategy(Strategy.capella)
          .transactionItems(
        transactionId: ticket.id,
        branchId: branchId,
        active: true,
      );
      final bytes = await buildOrderFormPdfBytes(ticket: ticket, items: items);
      if (!mounted) return;
      if (UniversalPlatform.isDesktopOrWeb && !kIsWeb) {
        // Desktop: branded printer picker (always show — do not auto-skip to
        // saved default). Use this State's context, not the list item builder.
        await CoreViewModel().printing(
          bytes,
          context,
          transaction: ticket,
          transactionItems: items,
          alwaysShowPicker: true,
          pdfFilename: 'order-form-${_ticketDisplayRef(ticket)}.pdf',
        );
      } else {
        await Printing.sharePdf(
          bytes: bytes,
          filename: 'order-form-${_ticketDisplayRef(ticket)}.pdf',
        );
      }
    } catch (e, st) {
      talker.error('Print reviewed-ticket order form failed: $e', st);
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          'Failed to print order form',
          backgroundColor: Colors.red,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _printingOrderFormTicketIds.remove(ticket.id));
      }
    }
  }

  /// Sends the order form PDF to the chosen staff member via WhatsApp.
  Future<void> _sendOrderFormWhatsAppTo(
    HandoverStaffMember recipient,
    ITransaction ticket,
  ) async {
    if (_sendingOrderFormWhatsAppTicketIds.contains(ticket.id)) return;

    setState(() => _sendingOrderFormWhatsAppTicketIds.add(ticket.id));
    try {
      final branchId = ticket.branchId ?? ProxyService.box.getBranchId() ?? '';
      final items = await ProxyService.getStrategy(Strategy.capella)
          .transactionItems(
        transactionId: ticket.id,
        branchId: branchId,
        active: true,
      );
      final bytes = await buildOrderFormPdfBytes(ticket: ticket, items: items);
      final refLabel = _ticketDisplayRef(ticket);
      final customer =
          (ticket.customerName ?? ticket.ticketName ?? 'Walk-in').trim();
      final caption =
          'Order form · Ticket #$refLabel · ${customer.isEmpty ? 'Walk-in' : customer}';

      final dataConnectorUrl = await resolveOrderFormDataConnectorUrl();
      if (dataConnectorUrl == null || dataConnectorUrl.trim().isEmpty) {
        throw OrderFormWhatsAppException(
          'Ebm.dataConnectorUrl is not configured (taxServerUrl is not used for WhatsApp)',
        );
      }
      final client = await createOrderFormWhatsAppClient(
        dataConnectorUrl: dataConnectorUrl,
      );
      await client.sendDocument(
        phone: recipient.phoneNumber,
        pdfBytes: bytes,
        filename: 'order-form-$refLabel.pdf',
        caption: caption,
      );

      if (!mounted) return;
      setState(() {
        _sentOrderFormWhatsAppTicketIds.add(ticket.id);
        _whatsAppPickerTicket = null;
      });
      showCustomSnackBarUtil(
        context,
        'Order form sent to ${recipient.displayName} on WhatsApp',
        backgroundColor: const Color(0xFF16A34A),
      );
    } on OrderFormWhatsAppException catch (e) {
      talker.error('Order form WhatsApp send failed: $e');
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          e.message,
          backgroundColor: Colors.red,
        );
      }
    } catch (e, st) {
      talker.error('Order form WhatsApp send failed: $e', st);
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          'Failed to send order form on WhatsApp',
          backgroundColor: Colors.red,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _sendingOrderFormWhatsAppTicketIds.remove(ticket.id));
      }
    }
  }

  /// Ticket Review + Handover workflow: stock manager confirms the item
  /// physically left stock. Pure status/audit stamp — no stock mutation.
  Future<void> _recordHandover(BuildContext context, ITransaction ticket) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          barrierColor: PosTokens.ink1.withValues(alpha: 0.58),
          builder: (ctx) => _RecordHandoverDialog(ticket: ticket),
        ) ??
        false;
    if (!confirmed || !mounted) return;

    // Ticket Review + Handover workflow: when on, Pay only flagged the ticket
    // paid — finalization (RRA sign + receipt + fiscal counters + stock) was
    // deferred to here. Run it BEFORE flipping to completed; if signing fails
    // the ticket stays in awaitingHandover so nothing is lost and the user
    // can retry. When the workflow is off, the sale was already finalized at Pay.
    final reviewWorkflowOn =
        ProxyService.settings.enableTicketReviewWorkflow;
    try {
      if (reviewWorkflowOn) {
        await finalizeTicketHandover(context: context, ticket: ticket);
      }
      await recordTicketHandover(
        transactionId: ticket.id,
        handoverByUserId: ProxyService.box.getUserId() ?? '',
      );
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          reviewWorkflowOn
              ? 'Handover recorded — receipt issued'
              : 'Handover recorded',
          backgroundColor: Colors.green,
        );
      }
    } catch (e, st) {
      talker.error('Record handover failed: $e', st);
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          'Failed to finalize handover — the receipt was not issued. '
          'Please try again.',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  /// Delete a ticket with confirmation and loading
  Future<void> _deleteTicket(ITransaction ticket) async {
    if (!(await canDeleteTicket(ticket))) {
      final reviewBlocked =
          isTicketDeleteBlockedByReviewWorkflow(ticket.status);
      await _dialogService.showCustomDialog(
        variant: DialogType.info,
        title: 'Error',
        description: reviewBlocked
            ? ticketDeleteBlockedByReviewMessage(ticket.status)
            : 'This ticket has partial payments and cannot be deleted.',
        data: {'status': InfoDialogStatus.error},
      );
      return;
    }

    bool confirmed = false;
    if (mounted) {
      confirmed =
          await showDialog<bool>(
            context: context,
            barrierColor: PosTokens.ink1.withValues(alpha: 0.58),
            builder: (ctx) => _DeleteTicketDialog(ticket: ticket),
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
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
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

class _RecordHandoverDialog extends StatelessWidget {
  const _RecordHandoverDialog({required this.ticket});

  final ITransaction ticket;

  static const Color _handoverTeal = Color(0xFF0D9488);
  static const Color _handoverTint = Color(0xFFE0F2F1);
  static const Color _handoverInk = Color(0xFF115E59);

  @override
  Widget build(BuildContext context) {
    final displayRef = _ticketDisplayRef(ticket);
    final customer = (ticket.customerName ?? ticket.ticketName ?? 'Walk-in')
        .trim();
    final total = (ticket.subTotal ?? 0).toCurrencyFormatted();
    final media = MediaQuery.sizeOf(context);
    final maxWidth = media.width < 460 ? media.width - 48 : 420.0;
    final reviewWorkflowOn =
        ProxyService.settings.enableTicketReviewWorkflow;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: PosTokens.line),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33103240),
                offset: Offset(0, 24),
                blurRadius: 48,
                spreadRadius: -18,
              ),
              BoxShadow(
                color: Color(0x14103240),
                offset: Offset(0, 8),
                blurRadius: 18,
                spreadRadius: -8,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _handoverTint,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.inventory_2_outlined,
                        color: _handoverTeal,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Complete handover?',
                            style: GoogleFonts.outfit(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: PosTokens.ink1,
                              height: 1.12,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            reviewWorkflowOn
                                ? 'Issue the receipt and mark this ticket as completed.'
                                : 'Confirm the item has physically left stock.',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              height: 1.35,
                              color: PosTokens.ink2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: PosTokens.surface2,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: PosTokens.line),
                  ),
                  child: Column(
                    children: [
                      _DeleteTicketDetailRow(
                        label: 'Ticket',
                        value: '#$displayRef',
                      ),
                      const SizedBox(height: 10),
                      _DeleteTicketDetailRow(
                        label: 'Customer',
                        value: customer.isEmpty ? 'Walk-in' : customer,
                      ),
                      const SizedBox(height: 10),
                      _DeleteTicketDetailRow(label: 'Total', value: total),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _handoverTint,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF99F6E4)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 20,
                        color: _handoverTeal,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          reviewWorkflowOn
                              ? 'Stock will be deducted and the fiscal receipt will be issued now.'
                              : 'This records that the goods were handed to the customer.',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _handoverInk,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: PosTokens.ink1,
                          side: const BorderSide(color: PosTokens.lineStrong),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => Navigator.of(context).pop(true),
                        icon: const Icon(Icons.check_rounded, size: 19),
                        label: Text(
                          'Confirm',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: _handoverTeal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          minimumSize: const Size.fromHeight(50),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeleteTicketDialog extends StatelessWidget {
  const _DeleteTicketDialog({required this.ticket});

  final ITransaction ticket;

  @override
  Widget build(BuildContext context) {
    final displayRef = _ticketDisplayRef(ticket);
    final customer = (ticket.customerName ?? ticket.ticketName ?? 'Walk-in')
        .trim();
    final total = (ticket.subTotal ?? 0).toCurrencyFormatted();
    final media = MediaQuery.sizeOf(context);
    final maxWidth = media.width < 460 ? media.width - 48 : 420.0;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: PosTokens.line),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33103240),
                offset: Offset(0, 24),
                blurRadius: 48,
                spreadRadius: -18,
              ),
              BoxShadow(
                color: Color(0x14103240),
                offset: Offset(0, 8),
                blurRadius: 18,
                spreadRadius: -8,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: PosTokens.lossTint,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: PosTokens.lossInk,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delete ticket?',
                            style: GoogleFonts.outfit(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: PosTokens.ink1,
                              height: 1.12,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'This removes the parked sale and its local ticket history.',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              height: 1.35,
                              color: PosTokens.ink2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: PosTokens.surface2,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: PosTokens.line),
                  ),
                  child: Column(
                    children: [
                      _DeleteTicketDetailRow(
                        label: 'Ticket',
                        value: '#$displayRef',
                      ),
                      const SizedBox(height: 10),
                      _DeleteTicketDetailRow(
                        label: 'Customer',
                        value: customer.isEmpty ? 'Walk-in' : customer,
                      ),
                      const SizedBox(height: 10),
                      _DeleteTicketDetailRow(label: 'Total', value: total),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFED7AA)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 20,
                        color: Color(0xFFC2410C),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'This action cannot be undone.',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF9A3412),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: PosTokens.ink1,
                          side: const BorderSide(color: PosTokens.lineStrong),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => Navigator.of(context).pop(true),
                        icon: const Icon(Icons.delete_outline, size: 19),
                        label: Text(
                          'Delete',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: PosTokens.loss,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          minimumSize: const Size.fromHeight(50),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeleteTicketDetailRow extends StatelessWidget {
  const _DeleteTicketDetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: PosTokens.ink3,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: PosTokens.ink1,
            ),
          ),
        ),
      ],
    );
  }
}

class _TicketListEntry {
  const _TicketListEntry._({
    required this.isHeader,
    this.sectionTitle,
    this.accentColor,
    this.sectionCount,
    this.ticket,
  });

  factory _TicketListEntry.header({
    required String title,
    required Color accentColor,
    required int count,
  }) {
    return _TicketListEntry._(
      isHeader: true,
      sectionTitle: title,
      accentColor: accentColor,
      sectionCount: count,
    );
  }

  factory _TicketListEntry.ticket(ITransaction ticket) {
    return _TicketListEntry._(isHeader: false, ticket: ticket);
  }

  final bool isHeader;
  final String? sectionTitle;
  final Color? accentColor;
  final int? sectionCount;
  final ITransaction? ticket;
}

class TicketCard extends StatelessWidget {
  final ITransaction ticket;
  final bool isSelected;
  final bool isWhatsAppPickerActive;
  final double paidAmount;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final ValueChanged<bool> onSelectionChanged;
  final bool showCollect;
  final VoidCallback? onCollect;
  /// Ticket Review + Handover workflow: replaces [showResume] when on — runs
  /// QuickSellingView Pay completion or handover finalize from the list.
  final bool showComplete;
  final VoidCallback? onComplete;
  final bool showResume;
  final bool isCollecting;
  /// Ticket Review + Handover workflow: shows the "Record handover" action
  /// when true (only meaningful while `ticket.status == AWAITING_HANDOVER`;
  /// gate this on `AppFeature.StockHandover` access at the call site).
  final bool showRecordHandover;
  final VoidCallback? onRecordHandover;
  /// Ticket Review + Handover workflow: shows the review action when true
  /// (only meaningful while `ticket.status == PENDING_REVIEW`). Used by the
  /// Review Queue screen — typically opens details; approve lives in the
  /// review sheet so reviewers check line items/payments first.
  final bool showMarkReviewed;
  final VoidCallback? onMarkReviewed;
  /// Label for [showMarkReviewed] (default "Mark as reviewed"). Review Queue
  /// uses "Review details" because approve is confirmed inside the sheet.
  final String markReviewedLabel;

  /// Ticket Review + Handover workflow: tapping the "Print Order Form" step
  /// of the Reviewed stepper prints an Order Form (item names + quantities,
  /// not a receipt) so stock can be released. Only rendered while
  /// `ticket.status == AWAITING_HANDOVER`; shown to any viewer (not gated on
  /// Stock Handover access) since it does not finalize or record the
  /// handover.
  final VoidCallback? onPrintOrderForm;

  /// Shows a spinner on the "Print Order Form" step while a print is in
  /// flight.
  final bool isPrintingOrderForm;

  /// Ticket Review + Handover workflow: send the order form PDF to stock
  /// staff on WhatsApp (third stepper node).
  final VoidCallback? onSendOrderFormWhatsApp;

  /// Spinner on the WhatsApp step while a send is in flight.
  final bool isSendingOrderFormWhatsApp;

  /// True after a successful WhatsApp send this session (marks step done).
  final bool orderFormWhatsAppSent;

  /// When false, hides the selection checkbox and delete button so users
  /// without ticket-management rights (e.g. review-only or handover-only
  /// staff) get a read-only ticket row. Gate this on
  /// `canCollectPosPaymentProvider` (`AppFeature.Tickets` write) at the call
  /// site — the same population allowed to collect/complete tickets.
  final bool canManage;
  const TicketCard({
    super.key,
    required this.ticket,
    required this.isSelected,
    this.isWhatsAppPickerActive = false,
    required this.paidAmount,
    required this.onTap,
    required this.onDelete,
    required this.onSelectionChanged,
    this.showCollect = false,
    this.onCollect,
    this.showComplete = false,
    this.onComplete,
    this.showResume = true,
    this.isCollecting = false,
    this.showRecordHandover = false,
    this.onRecordHandover,
    this.showMarkReviewed = false,
    this.onMarkReviewed,
    this.markReviewedLabel = 'Mark as reviewed',
    this.onPrintOrderForm,
    this.isPrintingOrderForm = false,
    this.onSendOrderFormWhatsApp,
    this.isSendingOrderFormWhatsApp = false,
    this.orderFormWhatsAppSent = false,
    this.canManage = true,
  });

  Color _leftAccent() {
    if (ticket.isLoan != true) return _kAccentBlue;
    return _isLayawayTicket(ticket) ? _kLayawayTeal : _kLoanPurple;
  }

  Widget _typePill() {
    if (ticket.isLoan != true) return const SizedBox.shrink();
    final layaway = _isLayawayTicket(ticket);
    final fg = layaway ? _kLayawayTeal : _kLoanPurple;
    final bg = layaway ? const Color(0xFFE0F2F1) : const Color(0xFFF3E5F5);
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
    final phone =
        (ticket.customerPhone ?? ticket.currentSaleCustomerPhoneNumber ?? '')
            .trim();
    final displayName = (ticket.customerName ?? ticket.ticketName ?? 'Walk-in')
        .trim();

    final total = ticket.subTotal ?? 0.0;
    final paid = paidAmount;
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
    } else if ((ticket.status ?? '').toLowerCase() == PARKED) {
      statusLabel = 'Awaiting payment';
      statusFg = _kAwaitingFg;
      statusBg = _kAwaitingBg;
    } else {
      statusLabel = statusExt.displayName;
      statusFg = statusExt.color;
      statusBg = statusExt.color.withValues(alpha: 0.15);
    }

    final progress = total <= 0 ? 0.0 : (paid / total).clamp(0.0, 1.0);
    final fullyPaid = total > 0 && (remClamped <= 0 || progress >= 1.0 - 1e-9);
    final progressColor = fullyPaid ? _kRegularGreen : _kProgressOrange;
    final deleteBlockedByReview =
        isTicketDeleteBlockedByReviewWorkflow(ticket.status);

    const whatsAppPickerGreen = Color(0xFF16A34A);
    final cardBg = isWhatsAppPickerActive
        ? const Color(0xFFF0FDF4)
        : isSelected
        ? const Color(0xFFE8F1FF)
        : Colors.white;
    final cardBorder = isWhatsAppPickerActive
        ? whatsAppPickerGreen
        : isSelected
        ? _kAccentBlue
        : Colors.grey[300]!;
    final cardBorderWidth =
        isWhatsAppPickerActive || isSelected ? 1.5 : 1.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: cardBorder,
              width: cardBorderWidth,
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
                              if (canManage)
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
                                child:
                                    (ticket.status ?? '') ==
                                            AWAITING_HANDOVER
                                        ? _ReviewToOrderFormStepper(
                                            onPrintOrderForm: onPrintOrderForm,
                                            isPrinting: isPrintingOrderForm,
                                            onSendWhatsApp:
                                                onSendOrderFormWhatsApp,
                                            isSendingWhatsApp:
                                                isSendingOrderFormWhatsApp,
                                            whatsAppSent: orderFormWhatsAppSent,
                                          )
                                        : Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: statusBg,
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                Icon(
                                  Icons.note_alt_outlined,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
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
                                    Icon(
                                      Icons.phone,
                                      size: 15,
                                      color: Colors.grey[600],
                                    ),
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
                                  (ticket.subTotal ?? 0).toCurrencyFormatted(),
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
                              if ((ticket.status ?? '') == PENDING_REVIEW &&
                                  showMarkReviewed &&
                                  onMarkReviewed != null) ...[
                                TextButton(
                                  onPressed: onMarkReviewed,
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xFF7C3AED),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    markReviewedLabel,
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ] else if ((ticket.status ?? '') ==
                                      AWAITING_HANDOVER &&
                                  showRecordHandover &&
                                  onRecordHandover != null) ...[
                                TextButton(
                                  onPressed: onRecordHandover,
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xFF0D9488),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Record handover',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ] else if (showCollect && onCollect != null) ...[
                                TextButton(
                                  onPressed: isCollecting ? null : onCollect,
                                  style: TextButton.styleFrom(
                                    backgroundColor: _kCollectBlue,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor:
                                        _kCollectBlue.withValues(alpha: 0.7),
                                    disabledForegroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: isCollecting
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              width: 12,
                                              height: 12,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Collecting…',
                                              style: GoogleFonts.outfit(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          'Collect →',
                                          style: GoogleFonts.outfit(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 8),
                              ] else if (showComplete && onComplete != null) ...[
                                TextButton(
                                  onPressed: isCollecting ? null : onComplete,
                                  style: TextButton.styleFrom(
                                    backgroundColor: _kRegularGreen,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor:
                                        _kRegularGreen.withValues(alpha: 0.7),
                                    disabledForegroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: isCollecting
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              width: 12,
                                              height: 12,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Completing…',
                                              style: GoogleFonts.outfit(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          'Complete →',
                                          style: GoogleFonts.outfit(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 8),
                              ] else if (showResume) ...[
                                _squareIconBtn(
                                  icon: Icons.play_arrow,
                                  color: _kAccentBlue,
                                  onPressed: onTap,
                                  tooltip: 'Resume Order',
                                ),
                                const SizedBox(width: 8),
                              ],
                              if (canManage && !deleteBlockedByReview)
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

/// Ticket Review + Handover workflow: replaces the plain "Reviewed" status
/// pill with a 3-step progress indicator — "Reviewed" (done) →
/// "Print Order Form" → "WhatsApp". Printing/sending produces an Order Form
/// (item names + quantities, not a receipt) so stock can be released before
/// the real handover; it does not change ticket status or touch RRA/EBM.
class _ReviewToOrderFormStepper extends StatelessWidget {
  const _ReviewToOrderFormStepper({
    required this.onPrintOrderForm,
    required this.isPrinting,
    required this.onSendWhatsApp,
    required this.isSendingWhatsApp,
    required this.whatsAppSent,
  });

  final VoidCallback? onPrintOrderForm;
  final bool isPrinting;
  final VoidCallback? onSendWhatsApp;
  final bool isSendingWhatsApp;
  final bool whatsAppSent;

  static const Color _accent = Color(0xFF0D9488);
  static const Color _whatsapp = Color(0xFF16A34A);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _node(label: 'Reviewed', icon: Icons.check, done: true),
        _connector(),
        _actionNode(
          label: 'Print',
          icon: Icons.print_outlined,
          onTap: isPrinting ? null : onPrintOrderForm,
          busy: isPrinting,
        ),
        _connector(),
        _actionNode(
          label: whatsAppSent ? 'Sent' : 'WhatsApp',
          icon: whatsAppSent ? Icons.check : Icons.chat_outlined,
          onTap: isSendingWhatsApp ? null : onSendWhatsApp,
          busy: isSendingWhatsApp,
          done: whatsAppSent,
          accent: _whatsapp,
        ),
      ],
    );
  }

  Widget _connector() {
    return Container(
      width: 10,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      color: _accent.withValues(alpha: 0.5),
    );
  }

  Widget _actionNode({
    required String label,
    required IconData icon,
    required VoidCallback? onTap,
    bool busy = false,
    bool done = false,
    Color accent = _accent,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: _node(
          label: label,
          icon: icon,
          done: done,
          busy: busy,
          accent: accent,
        ),
      ),
    );
  }

  Widget _node({
    required String label,
    required IconData icon,
    required bool done,
    bool busy = false,
    Color accent = _accent,
  }) {
    final fg = done ? Colors.white : accent;
    final bg = done ? accent : Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent, width: done ? 0 : 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (busy)
            SizedBox(
              width: 11,
              height: 11,
              child: CircularProgressIndicator(
                strokeWidth: 1.6,
                valueColor: AlwaysStoppedAnimation<Color>(fg),
              ),
            )
          else
            Icon(icon, size: 11, color: fg),
          const SizedBox(width: 3),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
