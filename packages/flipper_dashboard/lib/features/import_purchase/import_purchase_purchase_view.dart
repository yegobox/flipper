import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'assign_variant_modal.dart';
import 'import_purchase_helpers.dart';
import 'import_purchase_tokens.dart';
import 'import_purchase_ui.dart';

class ImportPurchasePurchaseView extends ConsumerStatefulWidget {
  const ImportPurchasePurchaseView({
    super.key,
    required this.purchases,
    required this.acceptPurchases,
    required this.onSavePurchaseMapping,
    required this.variants,
    required this.itemMapper,
    required this.statusFilter,
    required this.onStatusFilterChanged,
    required this.isProcessing,
    required this.canRetry,
    required this.onRetry,
  });

  final List<Purchase> purchases;
  final Future<void> Function({
    required List<Purchase> purchases,
    required String pchsSttsCd,
    required Purchase purchase,
    Variant? clickedVariant,
  }) acceptPurchases;
  final Future<IpmPurchaseMappingSaveResult> Function(
    Variant line,
    IpmPurchaseMappingResult result,
  ) onSavePurchaseMapping;
  final List<Variant> variants;
  final Map<String, List<Variant>> itemMapper;
  final String statusFilter;
  final ValueChanged<String> onStatusFilterChanged;
  final bool Function(String id) isProcessing;
  final bool Function(String id) canRetry;
  final Future<void> Function(String rowId) onRetry;

  @override
  ConsumerState<ImportPurchasePurchaseView> createState() =>
      _ImportPurchasePurchaseViewState();
}

class _ImportPurchasePurchaseViewState
    extends ConsumerState<ImportPurchasePurchaseView> {
  static const _pageSize = 4;
  int _page = 0;
  final Map<String, bool> _expanded = {};
  final Map<String, Stock> _stockMap = {};
  final Set<String> _fetchedStockIds = {};

  static const _filterOptions = [
    MapEntry('all', 'All'),
    MapEntry('pending', 'Pending'),
    MapEntry('approved', 'Approved'),
    MapEntry('rejected', 'Rejected'),
  ];

  List<Variant> _filterVariants(List<Variant> variants) {
    return variants
        .where((v) => ImportPurchaseHelpers.matchesPurchaseVariantFilter(
              v,
              widget.statusFilter,
            ))
        .toList();
  }

  List<Purchase> get _displayablePurchases {
    return widget.purchases.where((purchase) {
      if (purchase.variants == null || purchase.variants!.isEmpty) {
        return false;
      }
      return _filterVariants(purchase.variants!).isNotEmpty;
    }).toList();
  }

  Future<void> _fetchStocks(List<Variant> variants) async {
    final stockIds = variants
        .where((v) => v.stock?.id != null)
        .map((v) => v.stock!.id)
        .toSet();
    final newStockIds = stockIds.difference(_fetchedStockIds);
    if (newStockIds.isEmpty) return;

    final futures = newStockIds.map(
      (id) => ProxyService.getStrategy(Strategy.capella).getStockById(id: id),
    );
    try {
      final stocks = await Future.wait(futures);
      if (!mounted) return;
      setState(() {
        for (var i = 0; i < newStockIds.length; i++) {
          _stockMap[newStockIds.elementAt(i)] = stocks[i];
        }
        _fetchedStockIds.addAll(newStockIds);
      });
    } catch (_) {}
  }

  String? _assignedCatalogId(Variant lineItem) {
    for (final entry in widget.itemMapper.entries) {
      if (entry.value.any((v) => v.id == lineItem.id)) {
        return entry.key;
      }
    }
    return null;
  }

  String? _assignedCatalogName(Variant lineItem) {
    final id = _assignedCatalogId(lineItem);
    if (id == null) return null;
    for (final v in widget.variants) {
      if (v.id == id) return v.name;
    }
    return null;
  }

  String? _assignedCatalogItemCd(Variant lineItem) {
    final id = _assignedCatalogId(lineItem);
    if (id == null) return null;
    for (final v in widget.variants) {
      if (v.id == id) return v.itemCd;
    }
    return null;
  }

  IpmPurchaseMappingMode _initialMappingMode(Variant item) {
    if (_assignedCatalogId(item) != null) {
      return IpmPurchaseMappingMode.mapExisting;
    }
    return IpmPurchaseMappingMode.createNew;
  }

  Widget _mappingBadge(Variant item) {
    final catalogName = _assignedCatalogName(item);
    final itemCd = _assignedCatalogItemCd(item);
    if (catalogName != null) {
      return IpmMappingBadge.mapped(
        itemCd != null && itemCd.isNotEmpty ? itemCd : catalogName,
      );
    }
    return const IpmMappingBadge.unmapped();
  }

  Variant? _assignedCatalogVariant(Variant lineItem) {
    final id = _assignedCatalogId(lineItem);
    if (id == null) return null;
    for (final v in widget.variants) {
      if (v.id == id) return v;
    }
    return null;
  }

  void _openAssign(
    BuildContext context,
    Purchase purchase,
    Variant item,
  ) {
    showIpmAssignVariantModal(
      context,
      item: item,
      initialMode: _initialMappingMode(item),
      initialCatalogVariantId: _assignedCatalogId(item),
      initialItemCd: _assignedCatalogItemCd(item),
      initialCatalogVariant: _assignedCatalogVariant(item),
      onSave: (result) => widget.onSavePurchaseMapping(item, result),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width <= ImportPurchaseTokens.mobileBreakpoint;
    final gutter = ImportPurchaseTokens.gutter(width);
    final all = _displayablePurchases;
    final total = all.length;
    final pages = total == 0 ? 1 : (total / _pageSize).ceil();
    final cur = _page.clamp(0, pages - 1);
    final start = cur * _pageSize;
    final end = (start + _pageSize).clamp(0, total);
    final visible = total == 0 ? <Purchase>[] : all.sublist(start, end);

    return Padding(
      padding: EdgeInsets.fromLTRB(gutter, 18, gutter, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: IpmStatusFilter(
                    value: widget.statusFilter,
                    options: _filterOptions,
                    onChanged: (v) {
                      widget.onStatusFilterChanged(v);
                      setState(() => _page = 0);
                    },
                  ),
                ),
              ),
              if (!isMobile) const Spacer(),
              _buildPager(start, end, total, cur, pages),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: visible.isEmpty
                ? const IpmEmptyState(
                    icon: Icons.shopping_cart_outlined,
                    title: 'No purchase invoices',
                    subtitle:
                        'Nothing matches this status filter. Record a purchase or change the filter.',
                  )
                : ListView.separated(
                    itemCount: visible.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        _buildSupplierGroup(context, visible[index], isMobile),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPager(int start, int end, int total, int cur, int pages) {
    return Row(
      children: [
        Text(
          total == 0 ? '0 of 0' : '${start + 1}–$end of $total',
          style: ImportPurchaseHelpers.text(
            size: 14,
            weight: FontWeight.w600,
            color: ImportPurchaseTokens.ink2,
          ),
        ),
        const SizedBox(width: 6),
        _pagerArrow(
          Icons.keyboard_arrow_up,
          enabled: cur > 0,
          onTap: () => setState(() => _page--),
        ),
        _pagerArrow(
          Icons.keyboard_arrow_down,
          enabled: cur < pages - 1,
          onTap: () => setState(() => _page++),
        ),
      ],
    );
  }

  Widget _pagerArrow(IconData icon, {required bool enabled, VoidCallback? onTap}) {
    return Material(
      color: ImportPurchaseTokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: ImportPurchaseTokens.line2),
      ),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(
            icon,
            size: 18,
            color: enabled ? ImportPurchaseTokens.ink2 : ImportPurchaseTokens.faint,
          ),
        ),
      ),
    );
  }

  Widget _buildSupplierGroup(
    BuildContext context,
    Purchase purchase,
    bool isMobile,
  ) {
    final open = _expanded[purchase.id] ?? false;
    final items = _filterVariants(purchase.variants ?? []);
    final total = purchase.totAmt;

    return IpmPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () {
              final next = !open;
              setState(() => _expanded[purchase.id] = next);
              if (next) _fetchStocks(items);
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 18, isMobile ? 15 : 20, 18),
              child: isMobile
                  ? _mobileGroupHeader(purchase, items, total, open)
                  : _desktopGroupHeader(purchase, items, total, open),
            ),
          ),
          if (open)
            Container(
              color: ImportPurchaseTokens.surface2,
              padding: const EdgeInsets.all(6),
              child: isMobile
                  ? _mobileLineCards(context, purchase, items)
                  : _desktopLineTable(context, purchase, items),
            ),
        ],
      ),
    );
  }

  Widget _desktopGroupHeader(
    Purchase purchase,
    List<Variant> items,
    num total,
    bool open,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Supplier: ${purchase.spplrNm} (${items.length})',
                style: ImportPurchaseHelpers.text(
                  size: 16,
                  weight: FontWeight.w800,
                  letterSpacing: -0.1,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Invoice: ${purchase.spplrInvcNo}',
                style: ImportPurchaseHelpers.text(
                  size: 13,
                  weight: FontWeight.w600,
                  color: ImportPurchaseTokens.muted,
                ),
              ),
            ],
          ),
        ),
        _timePill(purchase),
        const SizedBox(width: 12),
        _totalPill(total),
        const SizedBox(width: 12),
        _groupActions(purchase),
        const SizedBox(width: 12),
        _expandButton(open, purchase),
      ],
    );
  }

  Widget _mobileGroupHeader(
    Purchase purchase,
    List<Variant> items,
    num total,
    bool open,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Supplier: ${purchase.spplrNm} (${items.length})',
                    style: ImportPurchaseHelpers.text(
                      size: 16,
                      weight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Invoice: ${purchase.spplrInvcNo}',
                    style: ImportPurchaseHelpers.text(
                      size: 13,
                      weight: FontWeight.w600,
                      color: ImportPurchaseTokens.muted,
                    ),
                  ),
                ],
              ),
            ),
            _expandButton(open, purchase),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _timePill(purchase),
            _totalPill(total),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _acceptAllButton(purchase)),
            const SizedBox(width: 8),
            Expanded(child: _declineAllButton(purchase)),
          ],
        ),
      ],
    );
  }

  Widget _timePill(Purchase purchase) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: ImportPurchaseTokens.green,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        timeago.format(purchase.createdAt, clock: DateTime.now()),
        style: ImportPurchaseHelpers.text(
          size: 12.5,
          weight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _totalPill(num total) {
    final currency = ProxyService.box.defaultCurrency();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: ImportPurchaseTokens.accentWash,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$currency ',
              style: ImportPurchaseHelpers.text(
                size: 11,
                weight: FontWeight.w700,
                color: ImportPurchaseTokens.accentStrong.withValues(alpha: 0.7),
              ),
            ),
            TextSpan(
              text: ImportPurchaseHelpers.formatMoney(total),
              style: ImportPurchaseHelpers.text(
                size: 13.5,
                weight: FontWeight.w800,
                color: ImportPurchaseTokens.accentStrong,
                tabular: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _groupActions(Purchase purchase) {
    final loading = widget.isProcessing(purchase.id);
    if (loading) {
      return IpmButton(
        label: 'Processing…',
        icon: Icons.hourglass_top,
        variant: IpmButtonVariant.ghost,
        compact: true,
        onPressed: null,
      );
    }

    return Row(
      children: [
        if (widget.canRetry(purchase.id)) ...[
          IpmButton(
            label: 'Retry',
            icon: Icons.refresh,
            variant: IpmButtonVariant.amberSoft,
            compact: true,
            onPressed: () => widget.onRetry(purchase.id),
          ),
          const SizedBox(width: 10),
        ],
        _acceptAllButton(purchase),
        const SizedBox(width: 10),
        _declineAllButton(purchase),
      ],
    );
  }

  Widget _acceptAllButton(Purchase purchase) {
    final loading = widget.isProcessing(purchase.id);
    return IpmButton(
      label: loading ? 'Processing…' : 'Accept All',
      icon: Icons.check_circle_outline,
      variant: IpmButtonVariant.greenSoft,
      compact: true,
      onPressed: loading
          ? null
          : () async {
              await widget.acceptPurchases(
                purchases: [purchase],
                pchsSttsCd: '02',
                purchase: purchase,
              );
            },
    );
  }

  Widget _declineAllButton(Purchase purchase) {
    final loading = widget.isProcessing(purchase.id);
    return IpmButton(
      label: loading ? 'Processing…' : 'Decline All',
      icon: Icons.cancel_outlined,
      variant: IpmButtonVariant.dangerSoft,
      compact: true,
      onPressed: loading
          ? null
          : () async {
              await widget.acceptPurchases(
                purchases: [purchase],
                pchsSttsCd: '04',
                purchase: purchase,
              );
            },
    );
  }

  Widget _expandButton(bool open, Purchase purchase) {
    return Material(
      color: open ? ImportPurchaseTokens.accentWash : ImportPurchaseTokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
        side: BorderSide(
          color: open ? Colors.transparent : ImportPurchaseTokens.line2,
        ),
      ),
      child: InkWell(
        onTap: () {
          final next = !open;
          setState(() => _expanded[purchase.id] = next);
          if (next) {
            _fetchStocks(_filterVariants(purchase.variants ?? []));
          }
        },
        borderRadius: BorderRadius.circular(9),
        child: SizedBox(
          width: 36,
          height: 36,
          child: AnimatedRotation(
            turns: open ? 0.5 : 0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: open
                  ? ImportPurchaseTokens.accentStrong
                  : ImportPurchaseTokens.ink2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _desktopLineTable(
    BuildContext context,
    Purchase purchase,
    List<Variant> items,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: ImportPurchaseTokens.surface,
        borderRadius: BorderRadius.circular(ImportPurchaseTokens.radius),
        border: Border.all(color: ImportPurchaseTokens.line),
      ),
      child: Column(
        children: [
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: ImportPurchaseTokens.surface2,
              border: Border(bottom: BorderSide(color: ImportPurchaseTokens.line)),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(ImportPurchaseTokens.radius),
              ),
            ),
            child: const Row(
              children: [
                SizedBox(width: 50, child: IpmColumnHeader('No.')),
                Expanded(child: IpmColumnHeader('Name')),
                SizedBox(width: 90, child: IpmColumnHeader('Qty', align: TextAlign.end)),
                SizedBox(
                  width: 130,
                  child: IpmColumnHeader('Supply', align: TextAlign.end),
                ),
                SizedBox(
                  width: 130,
                  child: IpmColumnHeader('Retail', align: TextAlign.end),
                ),
                SizedBox(width: 118, child: IpmColumnHeader('Mapping')),
              ],
            ),
          ),
          ...items.asMap().entries.map((entry) {
            final i = entry.key;
            final item = entry.value;
            final vtag = _assignedCatalogName(item);

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _openAssign(context, purchase, item),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  constraints: const BoxConstraints(minHeight: 56),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: ImportPurchaseTokens.line)),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                        child: Text(
                          '${i + 1}',
                          style: ImportPurchaseHelpers.text(
                            size: 14,
                            weight: FontWeight.w800,
                            color: ImportPurchaseTokens.muted,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.name,
                              style: ImportPurchaseHelpers.text(
                                size: 14.5,
                                weight: FontWeight.w700,
                              ),
                            ),
                            if (vtag != null)
                              Text(
                                vtag,
                                style: ImportPurchaseHelpers.text(
                                  size: 12,
                                  weight: FontWeight.w600,
                                  color: ImportPurchaseTokens.accentStrong,
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        child: Text(
                          ImportPurchaseHelpers.formatMoney(
                            _stockMap[item.stock?.id]?.currentStock ??
                                item.stock?.currentStock,
                          ),
                          textAlign: TextAlign.end,
                          style: ImportPurchaseHelpers.text(
                            size: 14,
                            color: ImportPurchaseTokens.ink2,
                            tabular: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 130,
                        child: Text(
                          ImportPurchaseHelpers.formatMoney(item.supplyPrice),
                          textAlign: TextAlign.end,
                          style: ImportPurchaseHelpers.text(
                            size: 14,
                            color: ImportPurchaseTokens.ink2,
                            tabular: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 130,
                        child: Text(
                          ImportPurchaseHelpers.formatMoney(item.retailPrice),
                          textAlign: TextAlign.end,
                          style: ImportPurchaseHelpers.text(
                            size: 14,
                            color: ImportPurchaseTokens.ink2,
                            tabular: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 118,
                        child: _mappingBadge(item),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _mobileLineCards(
    BuildContext context,
    Purchase purchase,
    List<Variant> items,
  ) {
    return Column(
      children: items.asMap().entries.map((entry) {
        final i = entry.key;
        final item = entry.value;
        final vtag = _assignedCatalogName(item);

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Material(
            color: ImportPurchaseTokens.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ImportPurchaseTokens.radiusSm),
              side: const BorderSide(color: ImportPurchaseTokens.line),
            ),
            child: InkWell(
              onTap: () => _openAssign(context, purchase, item),
              borderRadius: BorderRadius.circular(ImportPurchaseTokens.radiusSm),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${i + 1}. ${item.name}',
                            style: ImportPurchaseHelpers.text(
                              size: 14.5,
                              weight: FontWeight.w800,
                            ),
                          ),
                        ),
                        _mappingBadge(item),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _miniCell(
                            'Qty',
                            ImportPurchaseHelpers.formatMoney(
                              _stockMap[item.stock?.id]?.currentStock ??
                                  item.stock?.currentStock,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _miniCell(
                            'Supply',
                            ImportPurchaseHelpers.formatMoney(item.supplyPrice),
                          ),
                        ),
                        Expanded(
                          child: _miniCell(
                            'Retail',
                            ImportPurchaseHelpers.formatMoney(item.retailPrice),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _mappingHint(item, vtag),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _mappingHint(Variant item, String? catalogName) {
    final itemCd = _assignedCatalogItemCd(item);
    final text = catalogName != null
        ? (itemCd != null && itemCd.isNotEmpty
            ? 'Mapped · $itemCd — tap to change'
            : 'Mapped · $catalogName — tap to change')
        : 'Tap to map this line';
    return Row(
      children: [
        const Icon(
          Icons.local_offer_outlined,
          size: 15,
          color: ImportPurchaseTokens.accentStrong,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: ImportPurchaseHelpers.text(
              size: 12.5,
              weight: FontWeight.w700,
              color: ImportPurchaseTokens.accentStrong,
            ),
          ),
        ),
      ],
    );
  }

  Widget _miniCell(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: ImportPurchaseHelpers.text(
            size: 10.5,
            weight: FontWeight.w700,
            color: ImportPurchaseTokens.muted,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: ImportPurchaseHelpers.text(
            size: 13.5,
            weight: FontWeight.w700,
            tabular: true,
          ),
        ),
      ],
    );
  }
}
