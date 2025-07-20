import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'widgets/radio_buttons.dart';

class Transactions extends StatefulHookConsumerWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  TransactionsState createState() => TransactionsState();
}

class TransactionsState extends ConsumerState<Transactions>
    with DateCoreWidget {
  final _routerService = locator<RouterService>();
  String lastSeen = "";
  bool defaultTransactions = true;
  int displayedTransactionType = 0;
  List<String> transactionTypeOptions = ["All", "Sales", "Purchases"];

  @override
  void initState() {
    super.initState();
  }

  Widget _buildTransactionFilterButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.filter_list_alt,
                color: const Color(0xFF0077C5), // QuickBooks blue
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Filter Transactions',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RadioButtons(
            buttonLabels: transactionTypeOptions,
            onChanged: (newPeriod) {
              setState(() {
                displayedTransactionType = newPeriod;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [datePicker()],
            title: const Text('Transactions'),
          ),
          body: Column(
            children: [
              _buildTransactionFilterButtons(),
              Expanded(
                child: _buildTransactionContent(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransactionContent(BuildContext context) {
    final transactionsData = ref.watch(dashboardTransactionsProvider);
    final dateRange = ref.watch(dateRangeProvider);

    return transactionsData.when(
      data: (value) {
        List<ITransaction> filteredByDateTransactions = value.where((trans) {
          final transactionDate = trans.lastTouched;

          if (transactionDate == null) return false;

          if (dateRange.startDate != null && dateRange.endDate != null) {
            return (transactionDate.isAtSameMomentAs(dateRange.startDate!) ||
                    transactionDate.isAfter(dateRange.startDate!)) &&
                (transactionDate.isAtSameMomentAs(dateRange.endDate!) ||
                    transactionDate.isBefore(dateRange.endDate!));
          } else if (dateRange.startDate != null) {
            return transactionDate.isAtSameMomentAs(dateRange.startDate!) ||
                transactionDate.isAfter(dateRange.startDate!);
          } else if (dateRange.endDate != null) {
            return transactionDate.isAtSameMomentAs(dateRange.endDate!) ||
                transactionDate.isBefore(dateRange.endDate!);
          }

          return true; // If no date range is selected, include all
        }).toList();

        List<ITransaction> finalFilteredTransactions =
            filteredByDateTransactions.where((transaction) {
          if (displayedTransactionType == 1 &&
              transaction.transactionType == TransactionType.cashOut) {
            return false; // Filter out cashOut for "Sales"
          }
          if (displayedTransactionType == 2 &&
              transaction.transactionType != TransactionType.cashOut) {
            return false; // Filter out non-cashOut for "Purchases"
          }
          return true; // Include all for "All" or matching filter
        }).toList();

        if (finalFilteredTransactions.isEmpty) {
          return _buildEmptyStateWithPeriod(
              context, transactionTypeOptions[displayedTransactionType]);
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(dashboardTransactionsProvider),
          child: _buildModernTransactionList(
            context: context,
            transactions: finalFilteredTransactions,
            routerService: _routerService,
          ),
        );
      },
      error: (error, stackTrace) {
        return _buildErrorState(context, error.toString());
      },
      loading: () {
        return _buildLoadingState(context);
      },
    );
  }
}

// QuickBooks-inspired professional transaction list
Widget _buildModernTransactionList({
  required BuildContext context,
  required List<ITransaction> transactions,
  required RouterService routerService,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Transaction list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final isLastItem = index == transactions.length - 1;

              return _buildModernTransactionItem(
                transaction: transaction,
                routerService: routerService,
                isLastItem: isLastItem,
              );
            },
          ),
        ),
      ],
    ),
  );
}

Widget _buildModernTransactionItem({
  required ITransaction transaction,
  required RouterService routerService,
  required bool isLastItem,
}) {
  final isIncome = transaction.transactionType != TransactionType.cashOut;
  final amount = NumberFormat('#,###').format(
    double.parse(transaction.subTotal.toString()),
  );

  return InkWell(
    onTap: () => routerService.navigateTo(
      TransactionDetailRoute(transaction: transaction),
    ),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLastItem
            ? null
            : Border(
                bottom: BorderSide(color: Colors.grey.shade100),
              ),
      ),
      child: Row(
        children: [
          // Modern transaction icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isIncome
                    ? [const Color(0xFF10B981), const Color(0xFF34D399)]
                    : [const Color(0xFFEF4444), const Color(0xFFF87171)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: (isIncome
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444))
                      .withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              isIncome
                  ? Icons.trending_up_rounded
                  : Icons.trending_down_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      transaction.transactionType
                          .toString()
                          .split('.')
                          .last
                          .replaceAll(RegExp(r'([a-z])([A-Z])'), r'$1 $2')
                          .toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF374151),
                      ),
                    ),
                    Text(
                      '${isIncome ? '+' : '-'}$amount RWF',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isIncome
                            ? const Color(0xFF059669)
                            : const Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('MMM dd, yyyy')
                          .format(transaction.lastTouched!),
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.access_time_outlined,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('HH:mm').format(transaction.lastTouched!),
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    ),
  );
}

Widget _buildEmptyStateWithPeriod(BuildContext context, String period) {
  return Container(
    padding: const EdgeInsets.all(32),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF9500), Color(0xFFFFB800)], // Duolingo orange
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF9500).withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.event_note_outlined,
            size: 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'No records for ${period.toLowerCase()}',
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4B4B4B),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Try selecting a different time period or add some transactions.',
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF777777),
          ),
        ),
      ],
    ),
  );
}

// Microsoft-inspired loading state
Widget _buildLoadingState(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(40),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0078D4), Color(0xFF106EBE)],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Loading transactions...',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF605E5C),
          ),
        ),
      ],
    ),
  );
}

// Professional error state
Widget _buildErrorState(BuildContext context, String error) {
  return Container(
    padding: const EdgeInsets.all(32),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFFF4444).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(
            Icons.error_outline_rounded,
            size: 40,
            color: Color(0xFFFF4444),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Something went wrong',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          error,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    ),
  );
}
