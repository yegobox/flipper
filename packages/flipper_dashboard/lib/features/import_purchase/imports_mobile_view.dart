import 'package:flipper_dashboard/features/import_purchase/import_purchase_helpers.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_tokens.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_ui.dart';
import 'package:flipper_dashboard/import_purchase_viewmodel.dart';
import 'package:flipper_dashboard/manual_purchase/amount_input.dart';
import 'package:flipper_dashboard/manual_purchase/purchase_catalog_search.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_models/brick/models/all_models.dart' as model;
import 'package:timeago/timeago.dart' as timeago;

typedef _T = ImportPurchaseTokens;

final _money = NumberFormat('#,##0.##');

const _filters = [
  (key: 'pending', label: 'Waiting'),
  (key: 'approved', label: 'Approved'),
  (key: 'rejected', label: 'Rejected'),
  (key: 'all', label: 'All'),
];

String _itemName(model.Variant v) =>
    (v.itemNm ?? '').trim().isNotEmpty ? v.itemNm!.trim() : v.name;

String _qtyLabel(model.Variant v) {
  final qty = _money.format(v.qty ?? 0);
  final unit = (v.qtyUnitCd ?? '').trim();
  return unit.isEmpty ? qty : '$qty $unit';
}

bool _isWaiting(model.Variant v) => v.imptItemSttsCd == '2';

bool _hasPrices(model.Variant v) =>
    (v.supplyPrice ?? 0) > 0 && (v.retailPrice ?? 0) > 0;

/// Phone layout for RRA customs imports: status chips, one card per imported
/// item, a sheet to price or link an item and approve or reject it, and an
/// Approve all bar. Uses the same view model calls as the desktop
/// [ImportPurchaseImportView], which stays as it is.
class ImportsMobileView extends ConsumerStatefulWidget {
  const ImportsMobileView({super.key});

  @override
  ConsumerState<ImportsMobileView> createState() => _ImportsMobileViewState();
}

class _ImportsMobileViewState extends ConsumerState<ImportsMobileView> {
  /// Import item id → catalog item its stock should go to. Without a link,
  /// approving creates a new product from the import.
  final Map<String, model.Variant> _links = {};

  void _toast(String message, {bool error = false}) {
    if (mounted) showImportPurchaseToast(context, message, isError: error);
  }

  Future<void> _openItem(model.Variant item) async {
    final result = await showModalBottomSheet<_ItemDecision>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: _T.surface,
      builder: (_) => _ImportItemSheet(
        item: item,
        link: _links[item.id],
        canRetry: ref
            .read(importPurchaseViewModelProvider.notifier)
            .canRetryRow(item.id),
      ),
    );
    if (result == null || !mounted) return;

    setState(() {
      if (result.link != null) {
        _links[item.id] = result.link!;
      } else {
        _links.remove(item.id);
      }
    });
    // Keep the edits on the item, as the desktop editor does, so a later
    // Approve all sends them too.
    if (result.name.isNotEmpty) item.itemNm = result.name;
    if (result.supplyPrice > 0) item.supplyPrice = result.supplyPrice;
    if (result.retailPrice > 0) {
      item.retailPrice = result.retailPrice;
      item.prc = result.retailPrice;
      item.dftPrc = result.retailPrice;
    }

    final notifier = ref.read(importPurchaseViewModelProvider.notifier);
    try {
      switch (result.action) {
        case _ItemAction.save:
          return;
        case _ItemAction.approve:
          await notifier.approveImport(
            variant: item,
            targetVariantId: result.link?.id,
            retailPrice: item.retailPrice,
            supplyPrice: item.supplyPrice,
            itemNm: _itemName(item),
          );
          _toast('Approved "${_itemName(item)}"');
        case _ItemAction.reject:
          await notifier.rejectImport(variant: item);
          _toast('Rejected "${_itemName(item)}"');
        case _ItemAction.retry:
          await notifier.replayRowJob(item.id);
          _toast('Retry succeeded');
      }
      _links.remove(item.id);
    } catch (e) {
      _toast('Could not update "${_itemName(item)}": $e', error: true);
    }
  }

  Future<void> _approveAll(List<model.Variant> waiting) async {
    final unready = waiting
        .where((v) => !_links.containsKey(v.id) && !_hasPrices(v))
        .length;
    if (unready > 0) {
      _toast(
        '$unready item${unready == 1 ? '' : 's'} need a supply and retail '
        'price, or a link to one of your products',
        error: true,
      );
      return;
    }
    final sure = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Approve ${waiting.length} items?'),
        content: const Text(
          'Their quantities are added to your stock and reported to RRA.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Approve all'),
          ),
        ],
      ),
    );
    if (sure != true || !mounted) return;
    final variantMap = <String, List<model.Variant>>{};
    for (final v in waiting) {
      final link = _links[v.id];
      if (link != null) variantMap.putIfAbsent(link.id, () => []).add(v);
    }
    try {
      await ref
          .read(importPurchaseViewModelProvider.notifier)
          .approveAllImports(variants: waiting, variantMap: variantMap);
      setState(() => waiting.forEach((v) => _links.remove(v.id)));
      _toast('Approved ${waiting.length} items');
    } catch (e) {
      _toast('Could not approve all: $e', error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(importPurchaseViewModelProvider);
    final notifier = ref.read(importPurchaseViewModelProvider.notifier);
    final filter = state.importStatusFilter;
    final items = state.importItems
        .where((v) => ImportPurchaseHelpers.matchesImportFilter(v, filter))
        .toList();
    final waiting = items.where(_isWaiting).toList();
    final anyBusy = waiting.any((v) => notifier.isProcessing(v.id));

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
                onSelected: (_) => notifier.setImportStatusFilter(f.key),
              ),
            ),
        ],
      ),
    );

    Widget body;
    if (state.isLoading && items.isEmpty) {
      body = const Center(child: CircularProgressIndicator());
    } else if (state.error != null && items.isEmpty) {
      body = _Message(
        icon: Icons.cloud_off_outlined,
        title: 'Could not load imports',
        subtitle: state.error!,
      );
    } else if (items.isEmpty) {
      body = _Message(
        icon: Icons.inventory_2_outlined,
        title: filter == 'pending' ? 'No imports waiting' : 'No imports here',
        subtitle: 'Tap ⟳ to fetch your customs declarations from RRA.',
      );
    } else {
      body = ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) => _ImportCard(
          item: items[i],
          link: _links[items[i].id],
          busy: notifier.isProcessing(items[i].id),
          failed: notifier.canRetryRow(items[i].id),
          onTap: () => _openItem(items[i]),
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
                : LayoutBuilder(
                    builder: (context, c) => SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(height: c.maxHeight, child: body),
                    ),
                  ),
          ),
        ),
        if (waiting.isNotEmpty)
          Container(
            decoration: const BoxDecoration(
              color: _T.surface,
              border: Border(top: BorderSide(color: _T.line)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: FilledButton.icon(
                  onPressed: anyBusy ? null : () => _approveAll(waiting),
                  icon: const Icon(Icons.done_all),
                  label: Text('Approve all ${waiting.length} waiting'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _T.green,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_T.radiusSm),
                    ),
                  ),
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

_Pill _statusPill(model.Variant v) =>
    switch (ImportPurchaseHelpers.importStatusKey(v)) {
      'pending' => const _Pill('Waiting', fg: _T.amber, bg: _T.amberWash),
      'approved' => const _Pill(
        'Approved',
        fg: _T.greenStrong,
        bg: _T.greenWash,
      ),
      _ => const _Pill('Rejected', fg: _T.redStrong, bg: _T.redWash),
    };

class _ImportCard extends StatelessWidget {
  const _ImportCard({
    required this.item,
    required this.link,
    required this.busy,
    required this.failed,
    required this.onTap,
  });

  final model.Variant item;
  final model.Variant? link;
  final bool busy;
  final bool failed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final supplier = (item.spplrNm ?? '').trim();
    final origin = (item.orgnNatCd ?? '').trim();
    final meta = [
      if (supplier.isNotEmpty) supplier,
      if (origin.isNotEmpty) 'from $origin',
      if (item.lastTouched != null) timeago.format(item.lastTouched!),
    ].join(' · ');
    final priced = _hasPrices(item);

    return Material(
      color: _T.surface,
      borderRadius: BorderRadius.circular(_T.radius),
      child: InkWell(
        onTap: busy ? null : onTap,
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
                      _itemName(item),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: ImportPurchaseHelpers.text(
                        size: 15.5,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _qtyLabel(item),
                    style: ImportPurchaseHelpers.text(
                      size: 14.5,
                      weight: FontWeight.w800,
                      tabular: true,
                    ),
                  ),
                ],
              ),
              if (meta.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  meta,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: ImportPurchaseHelpers.text(
                    size: 13,
                    weight: FontWeight.w500,
                    color: _T.muted,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Text(
                priced
                    ? 'Cost ${_money.format(item.supplyPrice)} · '
                          'sells at ${_money.format(item.retailPrice)}'
                    : 'Set prices before approving',
                style: ImportPurchaseHelpers.text(
                  size: 13,
                  weight: FontWeight.w600,
                  color: priced ? _T.ink2 : _T.amber,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  if (busy)
                    const _Pill('Working…', fg: _T.ink2, bg: _T.surface3)
                  else if (failed)
                    const _Pill(
                      'Failed · tap to retry',
                      fg: _T.redStrong,
                      bg: _T.redWash,
                    )
                  else
                    _statusPill(item),
                  if (link != null)
                    _Pill(
                      'Adds to ${link!.name}',
                      fg: _T.accentStrong,
                      bg: _T.accentWash,
                    )
                  else if (_isWaiting(item))
                    const _Pill('New product', fg: _T.ink2, bg: _T.surface3),
                  if ((item.hsCd ?? '').isNotEmpty)
                    _Pill('HS ${item.hsCd}', fg: _T.ink2, bg: _T.surface3),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Item sheet ──────────────────────────────────────────────────────────────

enum _ItemAction { save, approve, reject, retry }

class _ItemDecision {
  const _ItemDecision({
    required this.action,
    required this.name,
    required this.supplyPrice,
    required this.retailPrice,
    this.link,
  });

  final _ItemAction action;
  final String name;
  final double supplyPrice;
  final double retailPrice;
  final model.Variant? link;
}

class _ImportItemSheet extends StatefulWidget {
  const _ImportItemSheet({
    required this.item,
    required this.link,
    required this.canRetry,
  });

  final model.Variant item;
  final model.Variant? link;
  final bool canRetry;

  @override
  State<_ImportItemSheet> createState() => _ImportItemSheetState();
}

class _ImportItemSheetState extends State<_ImportItemSheet> {
  late final _name = TextEditingController(text: _itemName(widget.item));
  late final _supply = TextEditingController(
    text: (widget.item.supplyPrice ?? 0) > 0
        ? formatAmountForEdit(widget.item.supplyPrice!)
        : '',
  );
  late final _retail = TextEditingController(
    text: (widget.item.retailPrice ?? 0) > 0
        ? formatAmountForEdit(widget.item.retailPrice!)
        : '',
  );
  late model.Variant? _link = widget.link;
  String? _error;

  static double _num(String raw) =>
      parseAmount(raw);

  @override
  void dispose() {
    _name.dispose();
    _supply.dispose();
    _retail.dispose();
    super.dispose();
  }

  _ItemDecision _decision(_ItemAction action) => _ItemDecision(
    action: action,
    name: _name.text.trim(),
    supplyPrice: _num(_supply.text),
    retailPrice: _num(_retail.text),
    link: _link,
  );

  void _approve() {
    // Same rule as desktop: a linked item takes the product's prices,
    // otherwise both prices are needed to create the product.
    if (_link == null && (_num(_supply.text) <= 0 || _num(_retail.text) <= 0)) {
      setState(() => _error = 'Enter both prices, or link a product you sell');
      return;
    }
    Navigator.of(context).pop(_decision(_ItemAction.approve));
  }

  Future<void> _pickLink() async {
    final picked = await showModalBottomSheet<model.Variant>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: _T.surface,
      builder: (_) => const _ProductPickerSheet(),
    );
    if (picked != null && mounted) setState(() => _link = picked);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final waiting = _isWaiting(item);
    final details = [
      ('Quantity', _qtyLabel(item)),
      if ((item.spplrNm ?? '').isNotEmpty) ('Supplier', item.spplrNm!),
      if ((item.orgnNatCd ?? '').isNotEmpty) ('Origin', item.orgnNatCd!),
      if ((item.hsCd ?? '').isNotEmpty) ('HS code', item.hsCd!),
      if ((item.dclNo ?? '').isNotEmpty) ('Declaration', item.dclNo!),
    ];

    InputDecoration field(String label) => InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      enabled: waiting,
    );

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _itemName(item),
                    style: ImportPurchaseHelpers.text(
                      size: 18,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
                _statusPill(item),
              ],
            ),
            const SizedBox(height: 10),
            for (final d in details)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        d.$1,
                        style: ImportPurchaseHelpers.text(
                          size: 13.5,
                          weight: FontWeight.w500,
                          color: _T.muted,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        d.$2,
                        style: ImportPurchaseHelpers.text(
                          size: 14,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _name,
              decoration: field('Name in your shop'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _supply,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: field('Supply price'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _retail,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: field('Retail price'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Material(
              color: _T.surface2,
              borderRadius: BorderRadius.circular(_T.radiusSm),
              child: ListTile(
                enabled: waiting,
                onTap: _pickLink,
                leading: Icon(
                  _link == null ? Icons.add_box_outlined : Icons.link,
                  color: _T.accentStrong,
                ),
                title: Text(
                  _link == null ? 'Create as a new product' : _link!.name,
                ),
                subtitle: Text(
                  _link == null
                      ? 'Or tap to add this stock to a product you sell'
                      : 'Stock will be added to this product',
                ),
                trailing: _link == null
                    ? const Icon(Icons.chevron_right)
                    : IconButton(
                        tooltip: 'Unlink',
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => _link = null),
                      ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(
                _error!,
                style: ImportPurchaseHelpers.text(
                  size: 13.5,
                  weight: FontWeight.w600,
                  color: _T.redStrong,
                ),
              ),
            ],
            const SizedBox(height: 18),
            if (widget.canRetry)
              FilledButton.icon(
                onPressed: () =>
                    Navigator.of(context).pop(_decision(_ItemAction.retry)),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry last attempt'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              )
            else if (waiting) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(
                        context,
                      ).pop(_decision(_ItemAction.reject)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _T.redStrong,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: _approve,
                      style: FilledButton.styleFrom(
                        backgroundColor: _T.green,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text('Approve'),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(_decision(_ItemAction.save)),
                child: const Text('Save for later'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProductPickerSheet extends StatefulWidget {
  const _ProductPickerSheet();

  @override
  State<_ProductPickerSheet> createState() => _ProductPickerSheetState();
}

class _ProductPickerSheetState extends State<_ProductPickerSheet> {
  final _query = TextEditingController();
  List<model.Variant> _results = const [];
  int _seq = 0;

  Future<void> _search(String text) async {
    final seq = ++_seq;
    final found = await searchPurchaseCatalog(text);
    if (!mounted || seq != _seq) return;
    setState(() => _results = found.toList());
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                controller: _query,
                autofocus: true,
                onChanged: _search,
                decoration: InputDecoration(
                  hintText: 'Search your products',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: _T.surface2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_T.radiusSm),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _results.isEmpty
                  ? Center(
                      child: Text(
                        _query.text.trim().isEmpty
                            ? 'Type a product name'
                            : 'No product matches',
                        style: ImportPurchaseHelpers.text(
                          weight: FontWeight.w500,
                          color: _T.muted,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _results.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, indent: 16),
                      itemBuilder: (context, i) {
                        final v = _results[i];
                        return ListTile(
                          title: Text(v.name),
                          subtitle: Text(
                            [
                              if ((v.itemCd ?? '').isNotEmpty) v.itemCd!,
                              if (v.retailPrice != null)
                                'Sells at ${_money.format(v.retailPrice)}',
                            ].join(' · '),
                          ),
                          onTap: () => Navigator.of(context).pop(v),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
