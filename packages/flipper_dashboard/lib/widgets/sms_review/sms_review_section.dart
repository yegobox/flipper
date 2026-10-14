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
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flipper_models/db_model_export.dart' show Category;

const Color _kBlue = Color(0xFF2563EB);
const Color _kIn = Color(0xFF16A34A);
const Color _kOut = Color(0xFFDC2626);
const Color _kWarn = Color(0xFFD97706);

/// The branch whose review queue the Cash Book shows.
final smsReviewBranchIdProvider = Provider<String>(
  (ref) => ref.watch(branchServicesProvider).box.getBranchId() ?? '',
);

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
          Text(
            l10n.smsReviewTitle,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.smsReviewSubtitle,
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
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

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.item});

  final SmsReviewItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final label = item.isFee
        ? l10n.smsReviewCharge
        : (item.isIncome ? l10n.smsReviewMoneyIn : l10n.smsReviewMoneyOut);
    return ListTile(
      key: Key('sms_review_row_${item.id}'),
      contentPadding: EdgeInsets.zero,
      title: Text(
        item.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text('$label · ${_when(item)}'),
      trailing: Text(
        _amount(item),
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: item.isIncome ? _kIn : _kOut,
        ),
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
            FilledButton(
              key: const Key('sms_review_confirm'),
              style: FilledButton.styleFrom(
                backgroundColor: _kBlue,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: _busy
                  ? null
                  : () => _run(() async {
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
              child: _busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.smsReviewConfirm),
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
