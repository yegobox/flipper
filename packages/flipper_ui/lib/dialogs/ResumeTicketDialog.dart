import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';

/// Helper to show the dialog in WoltModalSheet style
Future<void> showResumeTicketDialog({
  required BuildContext context,
  required ITransaction ticket,
  required Function(ITransaction) onResume,
  required Function(String) onStatusChange,
}) {
  return WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        _buildResumeTicketPage(context, ticket, onResume, onStatusChange),
      ];
    },
    modalTypeBuilder: (context) => WoltModalType.dialog(),
  );
}

/// The Sliver Page for WoltModalSheet
SliverWoltModalSheetPage _buildResumeTicketPage(
  BuildContext context,
  ITransaction ticket,
  Function(ITransaction) onResume,
  Function(String) onStatusChange,
) {
  return SliverWoltModalSheetPage(
    backgroundColor: Colors.white,
    pageTitle: Container(
      padding: const EdgeInsets.only(left: 24.0, top: 24.0, bottom: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF01B8E4).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.history_rounded,
                color: Color(0xFF01B8E4), size: 24),
          ),
          const SizedBox(width: 16),
          Text(
            'Resume Ticket',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: const Color(0xFF1A1C1E),
            ),
          ),
        ],
      ),
    ),
    mainContentSliversBuilder: (_) => [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 16.0,
            bottom: 120.0,
          ),
          child: ResumeTicketSummary(
            ticket: ticket,
            onStatusChange: onStatusChange,
          ),
        ),
      ),
    ],
    stickyActionBar: Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          onResume(ticket);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF01B8E4),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          'Resume Order',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),
    ),
  );
}

class ResumeTicketSummary extends ConsumerStatefulWidget {
  const ResumeTicketSummary({
    Key? key,
    required this.ticket,
    required this.onStatusChange,
  }) : super(key: key);

  final ITransaction ticket;
  final Function(String) onStatusChange;

  @override
  ConsumerState<ResumeTicketSummary> createState() =>
      _ResumeTicketSummaryState();
}

class _ResumeTicketSummaryState extends ConsumerState<ResumeTicketSummary> {
  bool _isUpdating = false;

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(transactionItemsStreamProvider(
      transactionId: widget.ticket.id,
      branchId: widget.ticket.branchId ?? ProxyService.box.getBranchId()!,
    ));

    final totalPaidAsync =
        ref.watch(transactionTotalPaidProvider(widget.ticket.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isUpdating)
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: LinearProgressIndicator(
              backgroundColor: Color(0xFFF1F4F9),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF01B8E4)),
              minHeight: 2,
            ),
          ),
        _buildInfoCard(
          context,
          title: 'Ticket Details',
          icon: Icons.info_outline_rounded,
          children: [
            _buildInfoRow('Reference',
                '#${widget.ticket.id.substring(0, 8).toUpperCase()}'),
            if (widget.ticket.ticketName != null &&
                widget.ticket.ticketName!.isNotEmpty)
              _buildInfoRow('Name', widget.ticket.ticketName!),
            if (widget.ticket.customerName != null &&
                widget.ticket.customerName!.isNotEmpty)
              _buildInfoRow('Customer', widget.ticket.customerName!),
            _buildInfoRow('Created', _formatDate(widget.ticket.createdAt)),
            _buildInfoRow('Status', widget.ticket.status ?? 'N/A'),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Items Summary',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: const Color(0xFF1A1C1E),
          ),
        ),
        const SizedBox(height: 12),
        itemsAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return Text('No items found in this ticket.',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey));
            }
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4F9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (context, index) =>
                    Divider(height: 1, color: Colors.grey.shade200),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    title: Text(item.name,
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    subtitle: Text(
                      '${item.qty} x ${item.price.toCurrencyFormatted(symbol: ProxyService.box.defaultCurrency())}',
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    trailing: Text(
                      (item.qty * item.price).toCurrencyFormatted(
                          symbol: ProxyService.box.defaultCurrency()),
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: const Color(0xFF1A1C1E)),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const Center(
              child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(strokeWidth: 3),
          )),
          error: (e, _) => Text('Error loading items: $e'),
        ),
        const SizedBox(height: 24),
        _buildFinancialSummary(context, totalPaidAsync),
        const SizedBox(height: 24),
        Text(
          'Update Status',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: const Color(0xFF1A1C1E),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildStatusChip(context, 'Waiting', WAITING, Colors.purple),
            _buildStatusChip(context, 'In Progress', IN_PROGRESS, Colors.blue),
            _buildStatusChip(context, 'Completed', COMPLETE, Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChip(
      BuildContext context, String label, String value, Color color) {
    final isSelected = widget.ticket.status == value;
    return InkWell(
      onTap: () async {
        if (!isSelected && !_isUpdating) {
          setState(() => _isUpdating = true);
          try {
            await widget.onStatusChange(value);
          } finally {
            if (mounted) setState(() => _isUpdating = false);
          }
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : color,
          ),
        ),
      ),
    );
  }

  Widget _buildFinancialSummary(
      BuildContext context, AsyncValue<double> totalPaidAsync) {
    return totalPaidAsync.when(
      data: (paidAmount) {
        final total = widget.ticket.subTotal ?? 0.0;
        final remaining = total - paidAmount;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F4F9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildSummaryRow(
                  'Total Amount',
                  total.toCurrencyFormatted(
                      symbol: ProxyService.box.defaultCurrency()),
                  isBold: true),
              const SizedBox(height: 8),
              _buildSummaryRow(
                  'Amount Paid',
                  paidAmount.toCurrencyFormatted(
                      symbol: ProxyService.box.defaultCurrency()),
                  color: Colors.green),
              if (remaining > 0) ...[
                const SizedBox(height: 8),
                _buildSummaryRow(
                    'Remaining Balance',
                    remaining.toCurrencyFormatted(
                        symbol: ProxyService.box.defaultCurrency()),
                    color: Colors.red,
                    isBold: true),
              ],
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF01B8E4)),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: const Color(0xFF42474E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: Colors.grey.shade600)),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            )),
        Text(value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              color: color,
            )),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.toLocal().day}/${date.toLocal().month}/${date.toLocal().year}';
  }
}
