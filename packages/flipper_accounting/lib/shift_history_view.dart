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
      appBar: _buildAppBar(context, viewModel, theme),
      body: viewModel.isBusy
          ? _buildLoadingState()
          : viewModel.filteredShifts.isEmpty
              ? _buildEmptyState(viewModel.searchQuery.isNotEmpty ||
                  viewModel.selectedStatus != null ||
                  viewModel.startDate != null ||
                  viewModel.endDate != null)
              : _buildShiftList(viewModel, currencySymbol, theme),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, ShiftHistoryViewModel viewModel, ThemeData theme) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF2C3E50),
      title: viewModel.searchQuery.isEmpty
          ? Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0078D4).withOpacity(0.1),
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
            )
          : TextField(
              onChanged: viewModel.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search shifts...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[400]),
              ),
              autofocus: true,
            ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list_outlined),
          onPressed: () => _showFilterOptions(context, viewModel),
        ),
        IconButton(
          icon: Icon(viewModel.searchQuery.isEmpty
              ? Icons.search_outlined
              : Icons.close),
          onPressed: () {
            if (viewModel.searchQuery.isNotEmpty) {
              viewModel.setSearchQuery('');
            } else {
              // This will trigger a rebuild and show the search field
              viewModel.setSearchQuery(' '); // Set to non-empty to show field
            }
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

  Widget _buildEmptyState(bool isFiltered) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0078D4).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFiltered ? Icons.filter_alt_off : Icons.history_outlined,
              size: 48,
              color: const Color(0xFF0078D4),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isFiltered ? 'No matching shifts' : 'No shifts found',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isFiltered
                ? 'Try adjusting your filters or search query.'
                : 'Shift records will appear here once you\nstart managing your shifts.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF6C757D),
              fontSize: 14,
            ),
          ),
          if (isFiltered)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextButton(
                onPressed: () {},
                child: const Text('Clear Filters'),
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
      itemCount: viewModel.filteredShifts.length,
      itemBuilder: (context, index) {
        final shift = viewModel.filteredShifts[index];
        return _buildShiftCard(shift, currencySymbol, theme);
      },
    );
  }

  Widget _buildShiftCard(Shift shift, String currencySymbol, ThemeData theme) {
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
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
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
                          color: const Color(0xFF0078D4).withOpacity(0.1),
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
                          ? const Color(0xFF28A745).withOpacity(0.1)
                          : const Color(0xFFDC3545).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: cashDifference > 0
                            ? const Color(0xFF28A745).withOpacity(0.3)
                            : const Color(0xFFDC3545).withOpacity(0.3),
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

  Future<void> _showFilterOptions(
      BuildContext context, ShiftHistoryViewModel viewModel) async {
    final selectedStatus = viewModel.selectedStatus;
    final startDate = viewModel.startDate;
    final endDate = viewModel.endDate;

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        ShiftStatus? tempSelectedStatus = selectedStatus;
        DateTime? tempStartDate = startDate;
        DateTime? tempEndDate = endDate;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Shifts',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Shift Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  Wrap(
                    spacing: 10,
                    children: ShiftStatus.values.map((status) {
                      return ChoiceChip(
                        label: Text(status.name),
                        selected: tempSelectedStatus == status,
                        onSelected: (selected) {
                          setModalState(() {
                            tempSelectedStatus = selected ? status : null;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Date Range',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateInput(
                          context,
                          'Start Date',
                          tempStartDate,
                          (date) => setModalState(() => tempStartDate = date),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildDateInput(
                          context,
                          'End Date',
                          tempEndDate,
                          (date) => setModalState(() => tempEndDate = date),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              tempSelectedStatus = null;
                              tempStartDate = null;
                              tempEndDate = null;
                            });
                            viewModel.clearFilters();
                            Navigator.pop(context);
                          },
                          child: const Text('Clear All'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, {
                              'status': tempSelectedStatus,
                              'startDate': tempStartDate,
                              'endDate': tempEndDate,
                            });
                          },
                          child: const Text('Apply Filters'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      viewModel.setSelectedStatus(result['status']);
      viewModel.setStartDate(result['startDate']);
      viewModel.setEndDate(result['endDate']);
    }
  }

  Widget _buildDateInput(BuildContext context, String label, DateTime? date,
      ValueChanged<DateTime?> onChanged) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        onChanged(selectedDate);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: date != null
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => onChanged(null),
                )
              : const Icon(Icons.calendar_today),
        ),
        child: Text(
          date == null ? 'Select Date' : DateFormat('MMM dd, yyyy').format(date),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  ShiftHistoryViewModel viewModelBuilder(BuildContext context) =>
      ShiftHistoryViewModel(businessId: ProxyService.box.getBusinessId()!);
}