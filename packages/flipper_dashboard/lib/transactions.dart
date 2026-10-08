import 'dart:developer';

import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_dashboard/export/headless_detailed_transaction_export_host.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/currency_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_states.dart';

DateTime? _transactionListInstant(ITransaction t) {
  return t.lastTouched ?? t.updatedAt ?? t.createdAt;
}

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
  List<String> get transactionTypeOptions => [
    context.flipperL10n.txListAll,
    context.flipperL10n.sales,
    context.flipperL10n.purchases,
  ];

  final GlobalKey<DetailedTransactionReportExportHostState> _exportHostKey =
      GlobalKey<DetailedTransactionReportExportHostState>();
  bool _isExportingReport = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onDownloadDetailedReport() async {
    final host = _exportHostKey.currentState;
    if (host == null) {
      if (mounted) {
        showWarningNotification(
          context,
          context.flipperL10n.transactionsExportNotReady,
        );
      }
      return;
    }

    final range = ref.read(dateRangeProvider);
    if (range.startDate == null || range.endDate == null) {
      if (mounted) {
        showWarningNotification(
          context,
          context.flipperL10n.txListSelectDateRangeFirst,
        );
      }
      return;
    }

    setState(() => _isExportingReport = true);
    try {
      await host.exportDetailedReport(
        headerTitle: context.flipperL10n.exportDataSheetReport,
      );
    } on UnsupportedError catch (e) {
      if (mounted) {
        showWarningNotification(context, e.message ?? e.toString());
      }
    } on StateError catch (e) {
      if (!mounted) return;
      if (e.message == 'missing_date_range') {
        showWarningNotification(
          context,
          context.flipperL10n.txListSelectDateRangeFirst,
        );
      } else if (e.message == 'no_line_items') {
        showWarningNotification(
          context,
          context.flipperL10n.transactionsNoLineItemsToExport,
        );
      } else {
        showErrorNotification(
          context,
          context.flipperL10n.txListExportFailed('${e.message}'),
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      if (mounted) {
        showErrorNotification(
          context,
          context.flipperL10n.txListExportFailed('$e'),
          duration: const Duration(seconds: 5),
        );
      }
    } finally {
      if (mounted) setState(() => _isExportingReport = false);
    }
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
                context.flipperL10n.transactionsFilter,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // ChoiceChip keeps the 48dp padded tap target and the ripple the
          // old GestureDetector buttons lacked.
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (var i = 0; i < transactionTypeOptions.length; i++)
                ChoiceChip(
                  label: Text(transactionTypeOptions[i]),
                  selected: displayedTransactionType == i,
                  showCheckmark: false,
                  backgroundColor: PosTokens.surface,
                  selectedColor: PosTokens.blueTint,
                  shape: const StadiumBorder(),
                  side: BorderSide(
                    color: displayedTransactionType == i
                        ? PosTokens.blue
                        : PosTokens.line,
                  ),
                  labelStyle: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: displayedTransactionType == i
                        ? PosTokens.blue
                        : PosTokens.ink2,
                  ),
                  onSelected: (_) {
                    if (displayedTransactionType == i) return;
                    HapticFeedback.selectionClick();
                    setState(() => displayedTransactionType = i);
                  },
                ),
            ],
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
            actions: [
              IconButton(
                tooltip: context.flipperL10n.transactionsExportDetailed,
                onPressed: _isExportingReport
                    ? null
                    : _onDownloadDetailedReport,
                icon: _isExportingReport
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download_outlined),
              ),
              datePicker(),
            ],
            title: Text(context.flipperL10n.transactionsTitle),
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  _buildTransactionFilterButtons(),
                  Expanded(child: _buildTransactionContent(context)),
                ],
              ),
              // Same export pipeline as TransactionList/DataView, without showing the grid.
              Visibility(
                visible: false,
                maintainState: true,
                child: DetailedTransactionReportExportHost(key: _exportHostKey),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransactionContent(BuildContext context) {
    final transactionsData = ref.watch(transactionsScreenTransactionsProvider);
    final dateRange = ref.watch(dateRangeProvider);

    return transactionsData.when(
      data: (value) {
        List<ITransaction> filteredByDateTransactions = value.where((trans) {
          final transactionDate = _transactionListInstant(trans);

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

        List<ITransaction>
        finalFilteredTransactions = filteredByDateTransactions.where((
          transaction,
        ) {
          if (displayedTransactionType == 1 && transaction.isIncome == false) {
            return false; // Filter out expenses for "Sales"
          }
          if (displayedTransactionType == 2 && transaction.isIncome == true) {
            return false; // Filter out income for "Purchases"
          }
          // Also filter out unclassified (null) transactions for "Sales" and "Purchases"
          if (displayedTransactionType != 0 && transaction.isIncome == null) {
            return false; // Filter out unclassified for "Sales" and "Purchases"
          }
          return true; // Include all for "All" or matching filter
        }).toList();

        if (finalFilteredTransactions.isEmpty) {
          return _refreshable(
            _buildEmptyStateWithPeriod(
              context,
              transactionTypeOptions[displayedTransactionType],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: _buildModernTransactionList(
            context: context,
            currency: ref.watch(defaultCurrencyProvider),
            transactions: finalFilteredTransactions,
            routerService: _routerService,
          ),
        );
      },
      error: (error, stackTrace) {
        // The raw error goes to the log, not in front of the user.
        log('transactions: $error', stackTrace: stackTrace);
        return _refreshable(
          MposErrorState(
            title: context.flipperL10n.transactionsSomethingWentWrong,
            onRetry: () =>
                ref.invalidate(transactionsScreenTransactionsProvider),
          ),
        );
      },
      // Placeholder rows in the same card as the list, so the rows replace
      // them in place instead of popping in under a spinner.
      loading: () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: MposSkeletonList(),
        ),
      ),
    );
  }

  /// Waits for the reload so the refresh spinner stays up until data arrives.
  Future<void> _refresh() => mposAwaitRefresh(
    ref.refresh(transactionsScreenTransactionsProvider.future),
  );

  /// Empty and error states can still be pulled to refresh.
  Widget _refreshable(Widget child) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

// QuickBooks-inspired professional transaction list
Widget _buildModernTransactionList({
  required BuildContext context,
  required String currency,
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
            // Pull-to-refresh must work even when the rows don't fill the
            // screen.
            physics: const AlwaysScrollableScrollPhysics(),
            // Keep the last row clear of the home indicator.
            padding: EdgeInsets.only(
              bottom: MediaQuery.paddingOf(context).bottom + 16,
            ),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final isLastItem = index == transactions.length - 1;

              return _buildModernTransactionItem(
                context: context,
                currency: currency,
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
  required BuildContext context,
  required String currency,
  required ITransaction transaction,
  required RouterService routerService,
  required bool isLastItem,
}) {
  final isIncome = transaction.isIncome;
  final amount = NumberFormat(
    '#,###',
  ).format(double.parse(transaction.subTotal.toString()));
  final type = transaction.transactionType;
  final typeLabel = type == null || type.isEmpty
      ? context.flipperL10n.transactionTypeUnclassified.toUpperCase()
      : type
            .split('.')
            .last
            .replaceAll(RegExp(r'([a-z])([A-Z])'), r'$1 $2')
            .toUpperCase();

  return InkWell(
    onTap: () => routerService.navigateTo(
      TransactionDetailRoute(transaction: transaction),
    ),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLastItem
            ? null
            : Border(bottom: BorderSide(color: Colors.grey.shade100)),
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
                colors: isIncome == true
                    ? [const Color(0xFF10B981), const Color(0xFF34D399)]
                    : isIncome == false
                    ? [const Color(0xFFEF4444), const Color(0xFFF87171)]
                    : [
                        const Color(0xFF6B7280),
                        const Color(0xFF9CA3AF),
                      ], // Grey for unclassified
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color:
                      (isIncome == true
                              ? const Color(0xFF10B981)
                              : isIncome == false
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF6B7280))
                          .withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              isIncome == true
                  ? Icons.trending_up_rounded
                  : isIncome == false
                  ? Icons.trending_down_rounded
                  : Icons.question_mark_rounded, // Icon for unclassified
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
                  children: [
                    Expanded(
                      child: Text(
                        typeLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF374151),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isIncome == true
                          ? '+$amount $currency'
                          : isIncome == false
                          ? '-$amount $currency'
                          : '$amount $currency', // No prefix for unclassified
                      style: FlipperFonts.mono(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5,
                        color: isIncome == true
                            ? const Color(0xFF059669)
                            : isIncome == false
                            ? const Color(0xFFDC2626)
                            : const Color(0xFF6B7280), // Grey for unclassified
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
                      DateFormat('MMM dd, yyyy').format(
                        _transactionListInstant(transaction) ?? DateTime.now(),
                      ),
                      style: GoogleFonts.outfit(
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
                      DateFormat('HH:mm').format(
                        _transactionListInstant(transaction) ?? DateTime.now(),
                      ),
                      style: GoogleFonts.outfit(
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
      mainAxisSize: MainAxisSize.min,
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
          context.flipperL10n.transactionsNoRecordsFor(period.toLowerCase()),
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4B4B4B),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.flipperL10n.transactionsTryDifferentPeriod,
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF777777),
          ),
        ),
      ],
    ),
  );
}
