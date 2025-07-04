import 'package:flipper_accounting/shift_history_viewmodel.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';

class ShiftHistoryView extends StackedView<ShiftHistoryViewModel> {
  const ShiftHistoryView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ShiftHistoryViewModel viewModel,
    Widget? child,
  ) {
    final currencySymbol = ProxyService.box.defaultCurrency();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(context, theme),
      body: viewModel.isBusy
          ? _buildLoadingState()
          : viewModel.data == null || viewModel.data!.isEmpty
              ? _buildEmptyState()
              : _buildShiftList(viewModel, currencySymbol, theme),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF2C3E50),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0078D4).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.history,
              color: Color(0xFF0078D4),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Shift History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list_outlined),
          onPressed: () {
            // Add filter functionality
          },
        ),
        IconButton(
          icon: const Icon(Icons.search_outlined),
          onPressed: () {
            // Add search functionality
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0078D4)),
          ),
          SizedBox(height: 16),
          Text(
            'Loading shift history...',
            style: TextStyle(
              color: Color(0xFF6C757D),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0078D4).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.history_outlined,
              size: 48,
              color: Color(0xFF0078D4),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No shifts found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Shift records will appear here once you\nstart managing your shifts.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF6C757D),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftList(
    ShiftHistoryViewModel viewModel,
    String currencySymbol,
    ThemeData theme,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.data!.length,
      itemBuilder: (context, index) {
        final shift = viewModel.data![index];
        return _buildShiftCard(shift, currencySymbol, theme);
      },
    );
  }

  Widget _buildShiftCard(Shift shift, String currencySymbol, ThemeData theme) {
    final isActive = shift.status.name.toLowerCase() == 'active';
    final statusColor = _getStatusColor(shift.status.name);
    final cashDifference = shift.cashDifference ?? 0.0;
    final hasCashDifference = cashDifference != 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0078D4).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: Color(0xFF0078D4),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User ID: ${shift.userId}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDateRange(shift.startAt, shift.endAt),
                            style: const TextStyle(
                              color: Color(0xFF6C757D),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(shift.status.name, statusColor),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Time Information
                _buildInfoSection(
                  'Time Period',
                  Icons.access_time_outlined,
                  [
                    _buildInfoRow(
                      'Start Time',
                      DateFormat('MMM dd, yyyy • HH:mm')
                          .format(shift.startAt.toLocal()),
                    ),
                    _buildInfoRow(
                      'End Time',
                      shift.endAt != null
                          ? DateFormat('MMM dd, yyyy • HH:mm')
                              .format(shift.endAt!.toLocal())
                          : 'In Progress',
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Financial Information
                _buildInfoSection(
                  'Financial Summary',
                  Icons.account_balance_wallet_outlined,
                  [
                    _buildInfoRow(
                      'Opening Balance',
                      '$currencySymbol ${shift.openingBalance.toStringAsFixed(2)}',
                    ),
                    _buildInfoRow(
                      'Cash Sales',
                      '$currencySymbol ${(shift.cashSales ?? 0.0).toStringAsFixed(2)}',
                    ),
                    _buildInfoRow(
                      'Expected Cash',
                      '$currencySymbol ${(shift.expectedCash ?? 0.0).toStringAsFixed(2)}',
                    ),
                    _buildInfoRow(
                      'Closing Balance',
                      '$currencySymbol ${(shift.closingBalance ?? 0.0).toStringAsFixed(2)}',
                    ),
                  ],
                ),

                // Cash Difference (if exists)
                if (hasCashDifference) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cashDifference > 0
                          ? const Color(0xFF28A745).withValues(alpha: 0.1)
                          : const Color(0xFFDC3545).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: cashDifference > 0
                            ? const Color(0xFF28A745).withValues(alpha: 0.3)
                            : const Color(0xFFDC3545).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          cashDifference > 0
                              ? Icons.trending_up
                              : Icons.trending_down,
                          color: cashDifference > 0
                              ? const Color(0xFF28A745)
                              : const Color(0xFFDC3545),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Cash Difference: $currencySymbol ${cashDifference.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: cashDifference > 0
                                ? const Color(0xFF28A745)
                                : const Color(0xFFDC3545),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: const Color(0xFF6C757D),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF495057),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6C757D),
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF2C3E50),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF28A745);
      case 'closed':
        return const Color(0xFF6C757D);
      case 'pending':
        return const Color(0xFFFFC107);
      default:
        return const Color(0xFF0078D4);
    }
  }

  String _formatDateRange(DateTime start, DateTime? end) {
    if (end == null) {
      return 'Started ${DateFormat('MMM dd, HH:mm').format(start.toLocal())}';
    }

    final duration = end.difference(start);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    return 'Duration: ${hours}h ${minutes}m';
  }

  @override
  ShiftHistoryViewModel viewModelBuilder(BuildContext context) =>
      ShiftHistoryViewModel(businessId: ProxyService.box.getBusinessId()!);
}
