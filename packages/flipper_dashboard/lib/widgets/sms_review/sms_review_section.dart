import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/helperModels/extensions.dart'
    show CurrencyFormatExtension;
import 'package:flipper_models/providers/category_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart'
    show cashbookRecentTransactionsProvider;
import 'package:flipper_models/services/pos_journal_poster.dart';
import 'package:flipper_models/sms_review/sms_review_item.dart';
import 'package:flipper_models/sms_review/sms_review_providers.dart';
import 'package:flipper_models/sms_review/sms_review_service.dart';
import 'package:flipper_models/sms_review/sms_sale_match.dart';
import 'package:flipper_services/notifications/engagement_push.dart'
    show kSmsReviewEngagementAction, registerEngagementActionHandler;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stacked_services/stacked_services.dart' show StackedService;
import 'package:flipper_models/db_model_export.dart' show Category;

const Color _kBlue = Color(0xFF2563EB);
const Color _kIn = Color(0xFF16A34A);
const Color _kOut = Color(0xFFDC2626);
const Color _kWarn = Color(0xFFD97706);

/// The branch whose review queue the Cash Book shows. Empty (nothing to
/// review) while the box is not set up: the home card and nav badge read
/// this, and a badge must never take the nav down with it.
final smsReviewBranchIdProvider = Provider<String>((ref) {
  try {
    return ref.watch(branchServicesProvider).box.getBranchId() ?? '';
  } catch (_) {
    return '';
  }
});

/// What is waiting for review at this branch: how many SMS, and the money in
/// and out they add up to. Watched by the home card and the nav badges, so
/// it is one record they all select from.
typedef SmsReviewSummary = ({int count, int moneyIn, int moneyOut});

final smsReviewSummaryProvider = Provider.autoDispose<SmsReviewSummary>((ref) {
  final branchId = ref.watch(smsReviewBranchIdProvider);
  final items = ref.watch(
    smsReviewItemsProvider(branchId).select((v) => v.value ?? const []),
  );
  var moneyIn = 0;
  var moneyOut = 0;
  for (final i in items) {
    if (i.isIncome) {
      moneyIn += i.amount;
    } else {
      moneyOut += i.amount;
    }
  }
  return (count: items.length, moneyIn: moneyIn, moneyOut: moneyOut);
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

/// Confirm / ignore for SMS review items. Tests override it with a fake.
final smsReviewServiceProvider = Provider<SmsReviewService>((ref) {
  return SmsReviewService(
    store: const DittoSmsReviewStore(),
    journalEntryId: PosJournalPoster.saleEntryId,
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
  );
});

String _amount(SmsReviewItem item) =>
    '${item.isIncome ? '+' : '−'}${item.amount.toCurrencyFormatted(symbol: item.currency, decimalDigits: 0)}';

String _when(SmsReviewItem item) {
  final at = item.occurredAtDate;
  if (at == null) return item.lineDate ?? '';
  return DateFormat('d MMM, HH:mm').format(at);
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
    String money(int v, String sign) =>
        '$sign${v.toCurrencyFormatted(symbol: 'RWF', decimalDigits: 0)}';
    final totals = summary.moneyOut == 0
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
                      const SizedBox(height: 2),
                      Text(
                        totals,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
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
    builder: (_) =>
        const FractionallySizedBox(heightFactor: 0.85, child: SmsReviewSheet()),
  );
}

/// The queue: one row per SMS movement, oldest first.
class SmsReviewSheet extends ConsumerWidget {
  const SmsReviewSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final branchId = ref.watch(smsReviewBranchIdProvider);
    final items = ref.watch(smsReviewItemsProvider(branchId)).value ?? const [];
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
          const SizedBox(height: 12),
          Expanded(
            child: items.isEmpty
                ? const _ReviewEmpty()
                : ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) => _ReviewRow(item: items[i]),
                  ),
          ),
        ],
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

class _ReviewRow extends ConsumerWidget {
  const _ReviewRow({required this.item});

  final SmsReviewItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final label = item.isFee
        ? l10n.smsReviewCharge
        : (item.isIncome ? l10n.smsReviewMoneyIn : l10n.smsReviewMoneyOut);
    final matchesSale =
        smsCanMatchSale(item) &&
        (ref.watch(smsMatchingSalesProvider(item)).value?.isNotEmpty ?? false);
    final color = item.isIncome ? _kIn : _kOut;
    return ListTile(
      key: Key('sms_review_row_${item.id}'),
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.12),
        foregroundColor: color,
        child: Text(
          _initials(item.providerLabel),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
      ),
      title: Text(
        item.counterpartyName ?? item.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label · ${_when(item)}'),
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
      trailing: Text(
        _amount(item),
        style: TextStyle(fontWeight: FontWeight.w700, color: color),
      ),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => SmsReviewDetail(item: item),
      ),
    );
  }
}

/// One SMS: pick a category, then add it to the Cash Book, mark it as a
/// transfer between own accounts, or ignore it.
class SmsReviewDetail extends ConsumerStatefulWidget {
  const SmsReviewDetail({super.key, required this.item});

  final SmsReviewItem item;

  @override
  ConsumerState<SmsReviewDetail> createState() => _SmsReviewDetailState();
}

class _SmsReviewDetailState extends ConsumerState<SmsReviewDetail> {
  String? _categoryId;
  bool _busy = false;
  bool _suggestionApplied = false;

  SmsReviewItem get item => widget.item;

  /// Pre-selects the connector's suggestion ("Bank charges" for a fee) when
  /// the branch has a category of that name.
  void _applySuggestion(List<Category> categories) {
    // Wait for the categories stream: applying against the first, empty
    // build would use up the suggestion before there is anything to match.
    if (_suggestionApplied || categories.isEmpty) return;
    _suggestionApplied = true;
    final wanted = item.suggestedCategory?.toLowerCase().trim();
    if (wanted == null || wanted.isEmpty) return;
    for (final c in categories) {
      if ((c.name ?? '').toLowerCase().trim() == wanted) {
        _categoryId = c.id;
        return;
      }
    }
  }

  Future<void> _run(Future<String?> Function() action) async {
    final l10n = context.flipperL10n;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    // Captured before the await: the sheet may be dismissed meanwhile, and
    // the Cash Book list must still refresh.
    final container = ProviderScope.containerOf(context, listen: false);
    setState(() => _busy = true);
    try {
      final message = await action();
      container.invalidate(cashbookRecentTransactionsProvider);
      // Once the sheet is gone, popping would close the screen beneath it.
      if (mounted) navigator.pop();
      if (message != null) {
        messenger.showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.smsReviewFailed(e.toString()))),
      );
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final categories = ref.watch(categoryProvider).value ?? const <Category>[];
    _applySuggestion(categories);
    final service = ref.read(smsReviewServiceProvider);
    final sales = smsCanMatchSale(item)
        ? ref.watch(smsMatchingSalesProvider(item)).value ??
              const <SmsSaleCandidate>[]
        : const <SmsSaleCandidate>[];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _amount(item),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: item.isIncome ? _kIn : _kOut,
              ),
            ),
            const SizedBox(height: 6),
            Text(item.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text(
              [
                item.providerLabel,
                _when(item),
                if (item.counterpartyAccount != null) item.counterpartyAccount!,
              ].join(' · '),
              style: TextStyle(color: Colors.grey.shade700),
            ),
            if (item.isLowConfidence) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: _kWarn),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      l10n.smsReviewLowConfidence,
                      style: const TextStyle(color: _kWarn),
                    ),
                  ),
                ],
              ),
            ],
            if (sales.isNotEmpty) ...[
              const SizedBox(height: 18),
              _SaleMatches(
                sales: sales,
                busy: _busy,
                onLink: (sale) => _run(() async {
                  final linked = await service.linkToSale(
                    item,
                    sale.transactionId,
                  );
                  return linked
                      ? l10n.smsReviewLinked
                      : l10n.smsReviewTakenElsewhere;
                }),
              ),
            ],
            const SizedBox(height: 18),
            Text(
              l10n.smsReviewCategory,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in categories)
                  ChoiceChip(
                    label: Text(c.name ?? ''),
                    selected: _categoryId == c.id,
                    selectedColor: _kBlue.withValues(alpha: 0.15),
                    onSelected: _busy
                        ? null
                        : (on) =>
                              setState(() => _categoryId = on ? c.id : null),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            _ConfirmButton(
              outlined: sales.isNotEmpty,
              busy: _busy,
              label: l10n.smsReviewConfirm,
              onPressed: () => _run(() async {
                final category = categories
                    .where((c) => c.id == _categoryId)
                    .firstOrNull;
                final txn = await service.confirm(
                  item,
                  categoryId: category?.id,
                  categoryName: category?.name,
                );
                return txn == null
                    ? l10n.smsReviewTakenElsewhere
                    : l10n.smsReviewConfirmed;
              }),
            ),
            const SizedBox(height: 8),
            if (!item.isFee)
              OutlinedButton(
                key: const Key('sms_review_transfer'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _kBlue,
                  side: const BorderSide(color: _kBlue),
                  minimumSize: const Size.fromHeight(44),
                ),
                onPressed: _busy
                    ? null
                    : () => _run(() async {
                        await service.markTransfer(item);
                        return null;
                      }),
                child: Text(l10n.smsReviewTransfer),
              ),
            TextButton(
              key: const Key('sms_review_ignore'),
              style: TextButton.styleFrom(foregroundColor: _kBlue),
              onPressed: _busy
                  ? null
                  : () => _run(() async {
                      await service.ignore(item);
                      return null;
                    }),
              child: Text(l10n.smsReviewIgnore),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Add to Cash Book": the main action, or outlined when a matching sale
/// makes Link the likelier one.
class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({
    required this.outlined,
    required this.busy,
    required this.label,
    required this.onPressed,
  });

  final bool outlined;
  final bool busy;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const key = Key('sms_review_confirm');
    final child = busy
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: outlined ? _kBlue : Colors.white,
            ),
          )
        : Text(label);
    if (outlined) {
      return OutlinedButton(
        key: key,
        style: OutlinedButton.styleFrom(
          foregroundColor: _kBlue,
          side: const BorderSide(color: _kBlue),
          minimumSize: const Size.fromHeight(48),
        ),
        onPressed: busy ? null : onPressed,
        child: child,
      );
    }
    return FilledButton(
      key: key,
      style: FilledButton.styleFrom(
        backgroundColor: _kBlue,
        minimumSize: const Size.fromHeight(48),
      ),
      onPressed: busy ? null : onPressed,
      child: child,
    );
  }
}

/// "Already recorded as a sale?": the till sales this SMS may be paying for,
/// each with a Link that closes the SMS without adding anything.
class _SaleMatches extends StatelessWidget {
  const _SaleMatches({
    required this.sales,
    required this.busy,
    required this.onLink,
  });

  final List<SmsSaleCandidate> sales;
  final bool busy;
  final void Function(SmsSaleCandidate sale) onLink;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _kBlue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.smsReviewMatchTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            l10n.smsReviewMatchBody,
            style: TextStyle(color: Colors.grey.shade700),
          ),
          for (final sale in sales.take(3)) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    [
                      l10n.smsReviewMatchSale(
                        sale.createdAt == null
                            ? ''
                            : DateFormat('HH:mm').format(sale.createdAt!),
                        sale.amount.toCurrencyFormatted(
                          symbol: 'RWF',
                          decimalDigits: 0,
                        ),
                      ),
                      if (sale.customerName?.isNotEmpty ?? false)
                        sale.customerName!,
                    ].join(' · '),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  key: Key('sms_review_link_${sale.transactionId}'),
                  style: FilledButton.styleFrom(backgroundColor: _kBlue),
                  onPressed: busy ? null : () => onLink(sale),
                  child: Text(l10n.smsReviewLink),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
