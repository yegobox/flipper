import 'package:flipper_accounting/liquid_accounts.dart'
    show liquidGroupOf, providerAccountFor;
import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_dashboard/features/personal_finance/loans/loan_picker.dart';
import 'package:flipper_dashboard/widgets/cashbook_new_category_sheet.dart';
import 'package:flipper_dashboard/widgets/sms_review/sms_review_categories.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/account_mode/account_mode_providers.dart';
import 'package:flipper_models/personal_loans/personal_loan.dart'
    show kLoanRepaymentCategory;
import 'package:flipper_models/helperModels/extensions.dart'
    show CurrencyFormatExtension;
import 'package:flipper_models/providers/category_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart'
    show cashbookRecentTransactionsProvider;
import 'package:flipper_models/services/pos_journal_poster.dart';
import 'package:flipper_models/helperModels/sale_completion_helpers.dart'
    show saleCompletionStatusComplete, saleCompletionStatusParked;
import 'package:flipper_models/sms_review/sms_debt_match.dart';
import 'package:flipper_models/sms_review/sms_review_item.dart';
import 'package:flipper_models/sms_review/sms_review_providers.dart';
import 'package:flipper_models/sms_review/sms_review_service.dart';
import 'package:flipper_models/sms_review/sms_sale_match.dart';
import 'package:flipper_models/sms_review/sms_transfer.dart';
import 'package:flipper_services/notifications/engagement_push.dart'
    show kSmsReviewEngagementAction, registerEngagementActionHandler;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stacked_services/stacked_services.dart' show StackedService;
import 'package:flipper_models/db_model_export.dart'
    show Category, TransactionPaymentRecord;

part 'sms_review_detail.dart';

const Color _kBlue = Color(0xFF2563EB);
const Color _kIn = Color(0xFF16A34A);
const Color _kOut = Color(0xFFDC2626);
const Color _kWarn = Color(0xFFD97706);

/// The branch whose review queue the Cash Book shows. Empty (nothing to
/// review) while the box is not set up: the home card and nav badge read
/// this, and a badge must never take the nav down with it.
///
/// Re-read when Ditto comes up: the box is set by then, and a read made
/// before login finished would otherwise keep the queue empty all session.
/// Auto-disposed, so a shell swap (personal mode) or a business/branch switch
/// that rebuilds the home reads the branch again instead of keeping the first
/// value for the whole session.
final smsReviewBranchIdProvider = Provider.autoDispose<String>((ref) {
  ref.watch(usableDittoProvider);
  try {
    return ref.watch(branchServicesProvider).box.getBranchId() ?? '';
  } catch (_) {
    return '';
  }
});

/// What is waiting for review at this branch: how many SMS, and the money in
/// and out they add up to. Watched by the home card and the nav badges, so
/// it is one record they all select from.
///
/// [loaded] is `true` only once the queue has been read: while it loads or
/// after an error, `count` is 0 without meaning "nothing waiting".
/// [currency] is `null` when the SMS are in more than one currency: their
/// amounts cannot be added up, so no totals are shown.
typedef SmsReviewSummary = ({
  int count,
  int moneyIn,
  int moneyOut,
  String? currency,
  bool loaded,
});

final smsReviewSummaryProvider = Provider.autoDispose<SmsReviewSummary>((ref) {
  final branchId = ref.watch(smsReviewBranchIdProvider);
  final queue = ref.watch(
    smsReviewItemsProvider(branchId).select(
      (v) => (
        items: v.value ?? const <SmsReviewItem>[],
        loaded: v.hasValue && !v.hasError,
      ),
    ),
  );
  final items = queue.items;
  var moneyIn = 0;
  var moneyOut = 0;
  for (final i in items) {
    if (i.isIncome) {
      moneyIn += i.amount;
    } else {
      moneyOut += i.amount;
    }
  }
  final currencies = items.map((i) => i.currency).toSet();
  return (
    count: items.length,
    moneyIn: moneyIn,
    moneyOut: moneyOut,
    currency: items.isEmpty
        ? 'RWF'
        : currencies.length == 1
        ? currencies.single
        : null,
    loaded: queue.loaded,
  );
});

/// Opens the review sheet when a "new SMS to approve" push is tapped
/// (data-connector sends action `sms_review`). Called once the dashboard is
/// up; the sheet opens over whatever screen is showing.
void registerSmsReviewPushHandler() {
  registerEngagementActionHandler(kSmsReviewEngagementAction, () {
    final context = StackedService.navigatorKey?.currentContext;
    if (context != null) showSmsReviewSheet(context);
  });
}

/// Confirm / transfer / ignore for SMS review items. Tests override it with
/// a fake.
final smsReviewServiceProvider = Provider<SmsReviewService>((ref) {
  const ledger = DittoSmsTransferLedger();
  return SmsReviewService(
    store: const DittoSmsReviewStore(),
    journalEntryId: PosJournalPoster.saleEntryId,
    postTransfer: ledger.post,
    voidTransfer: ledger.voidEntry,
    postClearing: ledger.postClearing,
    recordMovement:
        ({required item, required categoryId, required categoryName}) async {
          final services = ref.read(branchServicesProvider);
          final txn = await services.strategy.completeCashMovement(
            branchId: item.branchId,
            bhfId: (await services.box.bhfId()) ?? '00',
            cashReceived: item.amount.toDouble(),
            isIncome: item.isIncome,
            utilityVariantName: item.movementName,
            paymentType: item.paymentType,
            discount: 0,
            countryCode: 'N/A',
            isProformaMode: services.box.isProformaMode(),
            isTrainingMode: services.box.isTrainingMode(),
            transactionTypeForRecord: categoryName ?? item.movementName,
            categoryId: categoryId,
            note: item.description,
            occurredAt: item.occurredAtDate,
          );
          return txn.id;
        },
    // An installment on the credit sale, written as the POS writes one when
    // the customer pays at the till (`markTransactionAsCompleted`): the
    // sale's running totals, then one payment record. The data-connector
    // posts the record as `je_<biz>_<txn>_pay_<createdAt ms>`; the last
    // installment instead turns the sale's own entry into a paid sale.
    recordRepayment: ({required item, required debt}) async {
      final strategy = ref.read(branchServicesProvider).strategy;
      final txn = await strategy.getTransaction(id: debt.transactionId);
      if (txn == null ||
          txn.isLoan != true ||
          (txn.remainingBalance ?? 0) <= 0) {
        throw StateError('This debt is no longer open');
      }
      final paid = applySmsRepayment(
        cashReceived: (txn.cashReceived ?? 0).toDouble(),
        remaining: (txn.remainingBalance ?? 0).toDouble(),
        amount: item.amount.toDouble(),
      );
      final paidAt = (item.occurredAtDate ?? DateTime.now()).toUtc();
      await strategy.updateTransaction(
        transaction: txn,
        isLoan: paid.stillLoan,
        remainingBalance: paid.remaining,
        cashReceived: paid.cashReceived,
        status: paid.stillLoan
            ? saleCompletionStatusParked
            : saleCompletionStatusComplete,
        lastTouched: DateTime.now(),
        deferEnsureNextPendingCart: true,
      );
      await strategy.savePaymentType(
        paymentRecord: TransactionPaymentRecord(
          transactionId: txn.id,
          amount: item.amount.toDouble(),
          paymentMethod: item.paymentType,
          createdAt: paidAt,
          payerName: item.counterpartyName,
        ),
        transactionId: txn.id,
        singlePaymentOnly: false,
      );
      return (
        transactionId: txn.id,
        remaining: paid.remaining,
        journalEntryId: paid.stillLoan
            ? smsLoanPaymentEntryId(item.businessId, txn.id, paidAt)
            : PosJournalPoster.saleEntryId(item.businessId, txn.id),
      );
    },
  );
});

String _amount(SmsReviewItem item) =>
    '${item.isIncome ? '+' : '−'}${item.amount.toCurrencyFormatted(symbol: item.currency, decimalDigits: 0)}';

String _money(int value, String currency) =>
    value.toCurrencyFormatted(symbol: currency, decimalDigits: 0);

/// The SMS's own time of day, or null when it only gave a date (the
/// connector writes those as midnight), so no row shows a made-up 00:00.
DateTime? _clockTime(SmsReviewItem item) {
  final at = DateTime.tryParse(item.occurredAt ?? '');
  if (at == null || (at.hour == 0 && at.minute == 0 && at.second == 0)) {
    return null;
  }
  return at;
}

DateTime? _day(SmsReviewItem item) {
  final at = item.occurredAtDate;
  return at == null ? null : DateTime(at.year, at.month, at.day);
}

String _when(SmsReviewItem item) {
  final time = _clockTime(item);
  if (time != null) return DateFormat('d MMM, HH:mm').format(time);
  final day = _day(item);
  if (day == null) return item.lineDate ?? '';
  return DateFormat('d MMM yyyy').format(day);
}

/// "Today", "Yesterday", else "Tue 13 Oct".
String _dayLabel(DateTime? day, FlipperAppLocalizations l10n, DateTime now) {
  if (day == null) return '';
  final days = DateTime(now.year, now.month, now.day).difference(day).inDays;
  if (days == 0) return l10n.smsReviewToday;
  if (days == 1) return l10n.smsReviewYesterday;
  return DateFormat('EEE d MMM').format(day);
}

/// "Bank & MoMo SMS to review: 3" above the Cash Book list. Hidden when the
/// queue is empty, so branches without a paired phone never see it.
class SmsReviewBanner extends ConsumerWidget {
  const SmsReviewBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchId = ref.watch(smsReviewBranchIdProvider);
    final count = ref.watch(
      smsReviewItemsProvider(branchId).select((v) => v.value?.length ?? 0),
    );
    if (count == 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Material(
        color: _kBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          key: const Key('sms_review_banner'),
          borderRadius: BorderRadius.circular(12),
          onTap: () => showSmsReviewSheet(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.sms_outlined, color: _kBlue, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.flipperL10n.smsReviewBanner(count),
                    style: const TextStyle(
                      color: _kBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: _kBlue),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "4 bank & MoMo SMS to approve" at the top of the dashboard, so nobody has
/// to know the queue lives in the Cash Book. Hidden when nothing is waiting.
class SmsReviewHomeCard extends ConsumerWidget {
  const SmsReviewHomeCard({super.key, this.padding = EdgeInsets.zero});

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(smsReviewSummaryProvider);
    if (summary.count == 0) return const SizedBox.shrink();
    final l10n = context.flipperL10n;
    final currency = summary.currency;
    String money(int v, String sign) =>
        '$sign${v.toCurrencyFormatted(symbol: currency, decimalDigits: 0)}';
    // Mixed currencies: no total, rather than one labelled wrongly.
    final totals = currency == null
        ? null
        : summary.moneyOut == 0
        ? money(summary.moneyIn, '+')
        : summary.moneyIn == 0
        ? money(summary.moneyOut, '−')
        : l10n.smsReviewHomeTotals(
            money(summary.moneyIn, '+'),
            money(summary.moneyOut, '−'),
          );
    return Padding(
      padding: padding,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          key: const Key('sms_review_home_card'),
          borderRadius: BorderRadius.circular(16),
          onTap: () => showSmsReviewSheet(context),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _kBlue.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _kBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.sms_outlined, color: _kBlue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.smsReviewHomeTitle(summary.count),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      if (totals != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          totals,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _kBlue,
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () => showSmsReviewSheet(context),
                  child: Text(l10n.smsReviewHomeAction),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// [child] with the number of SMS waiting for review in a small blue bubble
/// at its top right; just [child] when nothing is waiting.
class SmsReviewCountBadge extends ConsumerWidget {
  const SmsReviewCountBadge({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(smsReviewSummaryProvider.select((s) => s.count));
    if (count == 0) return child;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -4,
          right: -8,
          child: Container(
            key: const Key('sms_review_count_badge'),
            constraints: const BoxConstraints(minWidth: 16),
            height: 16,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: _kBlue,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Text(
              count > 99 ? '99+' : '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> showSmsReviewSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    // Its own messenger: a snackbar from the detail sheet (with Undo) shows
    // on this sheet, not on the screen hidden beneath it.
    builder: (_) => const FractionallySizedBox(
      heightFactor: 0.85,
      child: ScaffoldMessenger(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SmsReviewSheet(),
        ),
      ),
    ),
  );
}

/// The queue: one row per SMS movement, oldest first, under a header per
/// day, with what is waiting in and out on top.
class SmsReviewSheet extends ConsumerWidget {
  const SmsReviewSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final branchId = ref.watch(smsReviewBranchIdProvider);
    final items = ref.watch(smsReviewItemsProvider(branchId)).value ?? const [];
    final summary = ref.watch(smsReviewSummaryProvider);
    final currency = summary.currency;

    final today = DateTime.now();
    final rows = <Widget>[];
    DateTime? lastDay;
    for (final (i, item) in items.indexed) {
      final day = _day(item);
      if (i == 0 || day != lastDay) {
        rows.add(_DayHeader(label: _dayLabel(day, l10n, today)));
        lastDay = day;
      } else {
        rows.add(const Divider(height: 1, indent: 52));
      }
      rows.add(_ReviewRow(item: item));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.smsReviewTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              if (items.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _kBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${items.length}',
                    style: const TextStyle(
                      color: _kBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.smsReviewSubtitle,
            style: TextStyle(color: Colors.grey.shade700),
          ),
          if (items.isNotEmpty && currency != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (summary.moneyIn > 0)
                  Expanded(
                    child: _TotalTile(
                      label: l10n.smsReviewMoneyIn,
                      amount: '+${_money(summary.moneyIn, currency)}',
                      color: _kIn,
                    ),
                  ),
                if (summary.moneyIn > 0 && summary.moneyOut > 0)
                  const SizedBox(width: 8),
                if (summary.moneyOut > 0)
                  Expanded(
                    child: _TotalTile(
                      label: l10n.smsReviewMoneyOut,
                      amount: '−${_money(summary.moneyOut, currency)}',
                      color: _kOut,
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 4),
          Expanded(
            child: items.isEmpty
                ? const _ReviewEmpty()
                : ListView(children: rows),
          ),
        ],
      ),
    );
  }
}

/// "Money in +RWF 50,000" above the list.
class _TotalTile extends StatelessWidget {
  const _TotalTile({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final String amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 2),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

/// Shown once the last SMS is handled, instead of a blank sheet.
class _ReviewEmpty extends StatelessWidget {
  const _ReviewEmpty();

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return Center(
      key: const Key('sms_review_empty'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.task_alt_rounded, color: _kBlue, size: 40),
          const SizedBox(height: 10),
          Text(
            l10n.smsReviewEmptyTitle,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.smsReviewEmptyBody,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}

/// Up to two letters of the provider ("BK", "MT") for the row's avatar.
String _initials(String label) {
  final words = label.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  if (words.isEmpty) return '?';
  if (words.length == 1) {
    final w = words.first;
    return w.substring(0, w.length < 2 ? w.length : 2).toUpperCase();
  }
  return (words[0][0] + words[1][0]).toUpperCase();
}

String _directionLabel(SmsReviewItem item, FlipperAppLocalizations l10n) =>
    item.isFee
    ? l10n.smsReviewCharge
    : (item.isIncome ? l10n.smsReviewMoneyIn : l10n.smsReviewMoneyOut);

class _ProviderAvatar extends StatelessWidget {
  const _ProviderAvatar({required this.item});

  final SmsReviewItem item;

  @override
  Widget build(BuildContext context) {
    final color = item.isIncome ? _kIn : _kOut;
    return CircleAvatar(
      radius: 20,
      backgroundColor: color.withValues(alpha: 0.12),
      foregroundColor: color,
      child: Text(
        _initials(item.providerLabel),
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
      ),
    );
  }
}

class _ReviewRow extends ConsumerWidget {
  const _ReviewRow({required this.item});

  final SmsReviewItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final matchesSale =
        smsCanMatchSale(item) &&
        (ref.watch(smsMatchingSalesProvider(item)).value?.isNotEmpty ?? false);
    final name = item.isFee ? null : item.counterpartyName;
    final time = _clockTime(item);
    final subtitle = [
      if (name != null) item.providerLabel,
      _directionLabel(item, l10n),
      if (time != null) DateFormat('HH:mm').format(time),
    ].join(' · ');
    return InkWell(
      key: Key('sms_review_row_${item.id}'),
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        final messenger = ScaffoldMessenger.of(context);
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => SmsReviewDetail(item: item, messenger: messenger),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            _ProviderAvatar(item: item),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ??
                        (item.isFee
                            ? l10n.smsReviewCharge
                            : item.providerLabel),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                  if (item.fee > 0 && !item.isFee)
                    Text(
                      l10n.smsReviewInclFee(_money(item.fee, item.currency)),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  if (matchesSale)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        l10n.smsReviewMatchChip,
                        key: Key('sms_review_match_chip_${item.id}'),
                        style: const TextStyle(
                          color: _kBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _amount(item),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: item.isIncome ? _kIn : _kOut,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
