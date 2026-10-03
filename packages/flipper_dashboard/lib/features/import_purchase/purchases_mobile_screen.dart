import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/features/import_purchase/assign_variant_modal.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_helpers.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_tokens.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_ui.dart';
import 'package:flipper_dashboard/features/import_purchase/imports_mobile_view.dart';
import 'package:flipper_dashboard/features/import_purchase/purchase_approval_mixin.dart';
import 'package:flipper_dashboard/features/import_purchase/record_purchase_modal.dart';
import 'package:flipper_dashboard/import_purchase_viewmodel.dart';
import 'package:flipper_dashboard/manual_purchase/manual_purchase_notifier.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_models/brick/models/all_models.dart' as model;
import 'package:timeago/timeago.dart' as timeago;

typedef _T = ImportPurchaseTokens;

final _money = NumberFormat('#,##0.##');

/// Purchase-level status, derived from its lines' `pchsSttsCd`.
enum _PurchaseStatus { waiting, approved, declined }

_PurchaseStatus _statusOf(model.Purchase p) {
  final lines = p.variants ?? const <model.Variant>[];
  if (lines.any((v) => v.pchsSttsCd == '01' || v.pchsSttsCd == null)) {
    return _PurchaseStatus.waiting;
  }
  if (lines.isNotEmpty && lines.every((v) => v.pchsSttsCd == '04')) {
    return _PurchaseStatus.declined;
  }
  return _PurchaseStatus.approved;
}

String _lineStatusLabel(String? code) => switch (code) {
  '02' || '03' => 'Approved',
  '04' => 'Declined',
  _ => 'Waiting',
};

/// Status filters, in the order an owner works through them.
const _filters = [
  (key: 'pending', label: 'Waiting'),
  (key: 'approved', label: 'Approved'),
  (key: 'rejected', label: 'Declined'),
  (key: 'all', label: 'All'),
];

/// Phone layout for supplier purchases: status chips, a pull-to-refresh list
/// of invoice cards, and a Record purchase button. Tapping a card opens its
/// detail with Accept / Decline. Desktop keeps [ImportPurchasePageView].
class PurchasesMobileScreen extends ConsumerStatefulWidget {
  const PurchasesMobileScreen({super.key});

  @override
  ConsumerState<PurchasesMobileScreen> createState() =>
      _PurchasesMobileScreenState();
}

class _PurchasesMobileScreenState extends ConsumerState<PurchasesMobileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(importPurchaseViewModelProvider.notifier).loadList();
    });
  }

  Future<void> _sync() async {
    try {
      final message = await ref
          .read(importPurchaseViewModelProvider.notifier)
          .syncFromRra();
      if (message != null && mounted) showImportPurchaseToast(context, message);
    } catch (e) {
      if (mounted) {
        showImportPurchaseToast(context, 'Sync failed: $e', isError: true);
      }
    }
  }

  void _openDetail(model.Purchase purchase) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _PurchaseDetailScreen(purchaseId: purchase.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(importPurchaseViewModelProvider);
    final notifier = ref.read(importPurchaseViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: _T.canvas,
      appBar: CustomAppBar(
        title: state.isImport ? 'Imports' : 'Purchases',
        icon: Icons.arrow_back,
        onPop: () => Navigator.of(context).maybePop(),
        customTrailingWidget: _SyncButton(
          syncing: state.syncing,
          onPressed: _sync,
        ),
      ),
      floatingActionButton: state.isImport
          ? null
          : FloatingActionButton.extended(
              onPressed: () => showRecordPurchaseModal(context, ref),
              backgroundColor: _T.accent,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Record purchase'),
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: _T.surface,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                      value: false,
                      label: Text('Purchases'),
                      icon: Icon(Icons.shopping_cart_outlined),
                    ),
                    ButtonSegment(
                      value: true,
                      label: Text('Imports'),
                      icon: Icon(Icons.download_outlined),
                    ),
                  ],
                  selected: {state.isImport},
                  showSelectedIcon: false,
                  onSelectionChanged: (s) =>
                      notifier.toggleImportPurchase(s.first),
                ),
                const SizedBox(height: 10),
                Text(
                  state.syncing
                      ? 'Fetching invoices from RRA…'
                      : state.lastSyncAt != null
                      ? 'Synced with RRA ${timeago.format(state.lastSyncAt!)}'
                      : 'Pull down to refresh · tap ⟳ to fetch from RRA',
                  style: ImportPurchaseHelpers.text(
                    size: 12.5,
                    weight: FontWeight.w500,
                    color: _T.muted,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _T.line),
          Expanded(
            child: state.isImport
                ? const ImportsMobileView()
                : _PurchaseList(state: state, onOpen: _openDetail),
          ),
        ],
      ),
    );
  }
}

class _SyncButton extends StatelessWidget {
  const _SyncButton({required this.syncing, required this.onPressed});

  final bool syncing;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: syncing
          ? const SizedBox(
              width: 44,
              height: 44,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : AppBarRoundIconButton(
              icon: Icons.sync,
              tooltip: 'Fetch from RRA',
              onPressed: onPressed,
            ),
    );
  }
}

class _PurchaseList extends ConsumerWidget {
  const _PurchaseList({required this.state, required this.onOpen});

  final ImportPurchaseState state;
  final ValueChanged<model.Purchase> onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(importPurchaseViewModelProvider.notifier);
    final filter = state.purchaseStatusFilter;
    final purchases = state.purchases.where((p) {
      final lines = p.variants ?? const <model.Variant>[];
      return lines.any(
        (v) => ImportPurchaseHelpers.matchesPurchaseVariantFilter(v, filter),
      );
    }).toList();

    final chips = SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
        children: [
          for (final f in _filters)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(f.label),
                selected: filter == f.key,
                showCheckmark: false,
                selectedColor: _T.accentWash,
                side: BorderSide(color: filter == f.key ? _T.accent : _T.line2),
                labelStyle: ImportPurchaseHelpers.text(
                  size: 13.5,
                  weight: FontWeight.w600,
                  color: filter == f.key ? _T.accentStrong : _T.ink2,
                ),
                onSelected: (_) => notifier.setPurchaseStatusFilter(f.key),
              ),
            ),
        ],
      ),
    );

    Widget body;
    if (state.isLoading && purchases.isEmpty) {
      body = const Center(child: CircularProgressIndicator());
    } else if (state.error != null && purchases.isEmpty) {
      body = _Message(
        icon: Icons.cloud_off_outlined,
        title: 'Could not load purchases',
        subtitle: state.error!,
      );
    } else if (purchases.isEmpty) {
      body = _Message(
        icon: Icons.receipt_long_outlined,
        title: filter == 'pending'
            ? 'Nothing waiting for approval'
            : 'No purchases here',
        subtitle:
            'Record a purchase, or fetch your supplier invoices '
            'from RRA.',
      );
    } else {
      body = ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        // Bottom padding keeps the last card clear of the button.
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 96),
        itemCount: purchases.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) => _PurchaseCard(
          purchase: purchases[i],
          busy: notifier.isProcessing(purchases[i].id),
          onTap: () => onOpen(purchases[i]),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        chips,
        Expanded(
          child: RefreshIndicator(
            onRefresh: notifier.loadList,
            child: body is ListView
                ? body
                // Empty/error states still need to be pullable.
                : LayoutBuilder(
                    builder: (context, c) => SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(height: c.maxHeight, child: body),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: _T.faint),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: ImportPurchaseHelpers.text(
                size: 16,
                weight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: ImportPurchaseHelpers.text(
                size: 13.5,
                weight: FontWeight.w500,
                color: _T.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.label, {required this.fg, required this.bg});

  final String label;
  final Color fg;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: ImportPurchaseHelpers.text(
          size: 11.5,
          weight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

_Pill _statusPill(_PurchaseStatus status) => switch (status) {
  _PurchaseStatus.waiting => const _Pill(
    'Waiting',
    fg: _T.amber,
    bg: _T.amberWash,
  ),
  _PurchaseStatus.approved => const _Pill(
    'Approved',
    fg: _T.greenStrong,
    bg: _T.greenWash,
  ),
  _PurchaseStatus.declined => const _Pill(
    'Declined',
    fg: _T.redStrong,
    bg: _T.redWash,
  ),
};

bool _isOnCredit(model.Purchase p) => p.pmtTyCd == '02' || p.pmtTyCd == '03';

class _PurchaseCard extends StatelessWidget {
  const _PurchaseCard({
    required this.purchase,
    required this.busy,
    required this.onTap,
  });

  final model.Purchase purchase;
  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final currency = ProxyService.box.defaultCurrency();
    final lines = purchase.variants?.length ?? 0;
    final supplier = purchase.spplrNm.trim().isEmpty
        ? 'Supplier'
        : purchase.spplrNm;

    return Material(
      color: _T.surface,
      borderRadius: BorderRadius.circular(_T.radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_T.radius),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      supplier,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ImportPurchaseHelpers.text(
                        size: 15.5,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$currency ${_money.format(purchase.totAmt)}',
                    style: ImportPurchaseHelpers.text(
                      size: 15,
                      weight: FontWeight.w800,
                      tabular: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Invoice ${purchase.spplrInvcNo} · '
                '${timeago.format(purchase.createdAt)} · '
                '$lines item${lines == 1 ? '' : 's'}',
                style: ImportPurchaseHelpers.text(
                  size: 13,
                  weight: FontWeight.w500,
                  color: _T.muted,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (busy)
                    const _Pill('Working…', fg: _T.ink2, bg: _T.surface3)
                  else
                    _statusPill(_statusOf(purchase)),
                  _Pill(
                    purchase.regTyCd == 'M' ? 'Recorded' : 'From RRA',
                    fg: _T.ink2,
                    bg: _T.surface3,
                  ),
                  if (_isOnCredit(purchase))
                    const _Pill(
                      'On credit',
                      fg: _T.accentStrong,
                      bg: _T.accentWash,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Detail ──────────────────────────────────────────────────────────────────

class _PurchaseDetailScreen extends ConsumerStatefulWidget {
  const _PurchaseDetailScreen({required this.purchaseId});

  /// Looked up in the view model so the screen follows list reloads.
  final String purchaseId;

  @override
  ConsumerState<_PurchaseDetailScreen> createState() =>
      _PurchaseDetailScreenState();
}

class _PurchaseDetailScreenState extends ConsumerState<_PurchaseDetailScreen>
    with PurchaseApprovalMixin {
  model.Purchase? _last;

  @override
  void notifyPurchase(String message, {bool success = true}) {
    if (!mounted) return;
    showImportPurchaseToast(context, message, isError: !success);
  }

  Future<void> _decide(model.Purchase purchase, {required bool accept}) async {
    if (!accept) {
      final sure = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Decline this purchase?'),
          content: Text(
            'Invoice ${purchase.spplrInvcNo} from ${purchase.spplrNm} will '
            'not be added to your stock.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: _T.redStrong),
              child: const Text('Decline'),
            ),
          ],
        ),
      );
      if (sure != true) return;
    }
    final done = await decidePurchase(purchase, accept: accept);
    if (done && mounted) Navigator.of(context).maybePop();
  }

  Future<void> _match(model.Variant line) async {
    await showIpmAssignVariantModal(
      context,
      item: line,
      initialMode: isPurchaseLineMapped(line)
          ? IpmPurchaseMappingMode.mapExisting
          : IpmPurchaseMappingMode.createNew,
      onSave: (result) => savePurchaseMapping(line, result),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(importPurchaseViewModelProvider);
    final purchase =
        state.purchases.where((p) => p.id == widget.purchaseId).firstOrNull ??
        _last;
    _last = purchase;

    if (purchase == null) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Purchase',
          icon: Icons.arrow_back,
          onPop: () => Navigator.of(context).maybePop(),
        ),
        body: const _Message(
          icon: Icons.search_off,
          title: 'Purchase not found',
          subtitle: 'It may have moved to another status.',
        ),
      );
    }

    final currency = ProxyService.box.defaultCurrency();
    final lines = purchase.variants ?? const <model.Variant>[];
    final status = _statusOf(purchase);
    final busy = ref
        .read(importPurchaseViewModelProvider.notifier)
        .isProcessing(purchase.id);
    final needsMatching = unmappedLineCount(purchase);
    final isRra = purchase.regTyCd != 'M';

    return Scaffold(
      backgroundColor: _T.canvas,
      appBar: CustomAppBar(
        title: purchase.spplrNm.trim().isEmpty ? 'Purchase' : purchase.spplrNm,
        icon: Icons.arrow_back,
        onPop: () => Navigator.of(context).maybePop(),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _T.surface,
              borderRadius: BorderRadius.circular(_T.radius),
              boxShadow: _T.cardShadows,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _statusPill(status),
                    const SizedBox(width: 6),
                    _Pill(
                      isRra ? 'From RRA' : 'Recorded',
                      fg: _T.ink2,
                      bg: _T.surface3,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '$currency ${_money.format(purchase.totAmt)}',
                  style: ImportPurchaseHelpers.text(
                    size: 26,
                    weight: FontWeight.w800,
                    tabular: true,
                  ),
                ),
                if (purchase.totTaxAmt > 0)
                  Text(
                    'incl. VAT ${_money.format(purchase.totTaxAmt)}',
                    style: ImportPurchaseHelpers.text(
                      size: 13,
                      weight: FontWeight.w500,
                      color: _T.muted,
                    ),
                  ),
                const SizedBox(height: 14),
                _InfoRow('Invoice', '${purchase.spplrInvcNo}'),
                _InfoRow(
                  'Date',
                  DateFormat('d MMM yyyy').format(purchase.createdAt.toLocal()),
                ),
                _InfoRow(
                  'Paid with',
                  purchasePaymentTypes[purchase.pmtTyCd] ?? purchase.pmtTyCd,
                ),
                if (purchase.spplrTin.trim().isNotEmpty)
                  _InfoRow('Supplier TIN', purchase.spplrTin),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Text(
              'ITEMS · ${lines.length}',
              style: ImportPurchaseHelpers.text(
                size: 12,
                weight: FontWeight.w700,
                color: _T.muted,
                letterSpacing: 0.6,
              ),
            ),
          ),
          if (needsMatching > 0 && status == _PurchaseStatus.waiting)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _T.amberWash,
                borderRadius: BorderRadius.circular(_T.radiusSm),
              ),
              child: Text(
                'Match each supplier item to one of yours before accepting, '
                'so stock lands on the right product.',
                style: ImportPurchaseHelpers.text(
                  size: 13,
                  weight: FontWeight.w500,
                  color: _T.amber,
                ),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              color: _T.surface,
              borderRadius: BorderRadius.circular(_T.radius),
              boxShadow: _T.cardShadows,
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < lines.length; i++) ...[
                  if (i > 0)
                    const Divider(height: 1, indent: 14, color: _T.line),
                  _LineRow(
                    line: lines[i],
                    currency: currency,
                    canMatch: isRra && (lines[i].pchsSttsCd ?? '01') == '01',
                    matched: isPurchaseLineMapped(lines[i]),
                    onMatch: () => _match(lines[i]),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: status != _PurchaseStatus.waiting
          ? null
          : Container(
              decoration: const BoxDecoration(
                color: _T.surface,
                border: Border(top: BorderSide(color: _T.line)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: busy
                              ? null
                              : () => _decide(purchase, accept: false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _T.redStrong,
                            side: const BorderSide(color: _T.line2),
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(_T.radiusSm),
                            ),
                          ),
                          child: const Text('Decline'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton(
                          onPressed: busy
                              ? null
                              : () => _decide(purchase, accept: true),
                          style: FilledButton.styleFrom(
                            backgroundColor: _T.green,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(_T.radiusSm),
                            ),
                          ),
                          child: busy
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  needsMatching > 0
                                      ? 'Accept ($needsMatching to match)'
                                      : 'Accept',
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: ImportPurchaseHelpers.text(
                size: 13.5,
                weight: FontWeight.w500,
                color: _T.muted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: ImportPurchaseHelpers.text(
                size: 14,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LineRow extends StatelessWidget {
  const _LineRow({
    required this.line,
    required this.currency,
    required this.canMatch,
    required this.matched,
    required this.onMatch,
  });

  final model.Variant line;
  final String currency;
  final bool canMatch;
  final bool matched;
  final VoidCallback onMatch;

  @override
  Widget build(BuildContext context) {
    final qty = line.qty ?? 0;
    final price = line.prc ?? line.supplyPrice ?? 0;
    final total = line.totAmt ?? qty * price;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  line.itemNm ?? line.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: ImportPurchaseHelpers.text(
                    size: 15,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _money.format(total),
                style: ImportPurchaseHelpers.text(
                  size: 15,
                  weight: FontWeight.w700,
                  tabular: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            '${_money.format(qty)} × ${_money.format(price)} · '
            '${_lineStatusLabel(line.pchsSttsCd)}',
            style: ImportPurchaseHelpers.text(
              size: 13,
              weight: FontWeight.w500,
              color: _T.muted,
            ),
          ),
          if (canMatch) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: onMatch,
              icon: Icon(matched ? Icons.link : Icons.link_off, size: 18),
              label: Text(matched ? 'Matched · change' : 'Match to my item'),
              style: OutlinedButton.styleFrom(
                foregroundColor: matched ? _T.greenStrong : _T.accentStrong,
                side: BorderSide(color: matched ? _T.greenWash : _T.line2),
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_T.radiusSm),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
