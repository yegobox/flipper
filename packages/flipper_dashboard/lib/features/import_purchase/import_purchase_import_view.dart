import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'import_purchase_helpers.dart';
import 'import_purchase_tokens.dart';
import 'import_purchase_ui.dart';
import 'ipm_variant_combo.dart';

class ImportPurchaseImportView extends ConsumerStatefulWidget {
  const ImportPurchaseImportView({
    super.key,
    required this.items,
    required this.formKey,
    required this.nameController,
    required this.supplyPriceController,
    required this.retailPriceController,
    required this.saveChangeMadeOnItem,
    required this.acceptAllImport,
    required this.selectItem,
    required this.finalItemList,
    required this.variantMap,
    required this.onApprove,
    required this.onReject,
    required this.catalogVariants,
  });

  final List<Variant> items;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController supplyPriceController;
  final TextEditingController retailPriceController;
  final VoidCallback saveChangeMadeOnItem;
  final void Function(List<Variant> variants) acceptAllImport;
  final void Function(Variant? selectedItem) selectItem;
  final List<Variant> finalItemList;
  final Map<String, List<Variant>> variantMap;
  final Future<void> Function(Variant, Map<String, List<Variant>>) onApprove;
  final Future<void> Function(Variant, Map<String, List<Variant>>) onReject;
  final List<Variant> catalogVariants;

  @override
  ConsumerState<ImportPurchaseImportView> createState() =>
      _ImportPurchaseImportViewState();
}

class _ImportPurchaseImportViewState
    extends ConsumerState<ImportPurchaseImportView> {
  String _statusFilter = 'all';
  Variant? _selectedItem;
  final Map<String, bool> _approveLoading = {};
  final Map<String, bool> _rejectLoading = {};
  final Map<String, Stock> _stockMap = {};
  final Set<String> _fetchedStockIds = {};

  static const _filterOptions = [
    MapEntry('all', 'All'),
    MapEntry('wait', 'Wait'),
    MapEntry('approved', 'Approved'),
    MapEntry('rejected', 'Rejected'),
  ];

  @override
  void initState() {
    super.initState();
    _fetchStocks(widget.items);
  }

  @override
  void didUpdateWidget(covariant ImportPurchaseImportView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _fetchStocks(widget.items);
    }
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
    final stocks = await Future.wait(futures);
    if (!mounted) return;
    setState(() {
      for (var i = 0; i < newStockIds.length; i++) {
        _stockMap[newStockIds.elementAt(i)] = stocks[i];
      }
      _fetchedStockIds.addAll(newStockIds);
    });
  }

  List<Variant> get _filtered => widget.items
      .where((v) => ImportPurchaseHelpers.matchesImportFilter(v, _statusFilter))
      .toList();

  String? _catalogNameFor(Variant item) {
    final id = ImportPurchaseHelpers.catalogVariantIdForImport(
      item,
      widget.variantMap,
    );
    if (id == null) return null;
    for (final v in widget.catalogVariants) {
      if (v.id == id) return v.name;
    }
    return null;
  }

  String? _catalogIdFor(Variant item) =>
      ImportPurchaseHelpers.catalogVariantIdForImport(item, widget.variantMap);

  void _selectRow(Variant item) {
    setState(() => _selectedItem = item);
    widget.selectItem(item);
    widget.nameController.text = item.itemNm ?? item.name;
    widget.supplyPriceController.text = item.supplyPrice?.toString() ?? '';
    widget.retailPriceController.text = item.retailPrice?.toString() ?? '';
  }

  void _clearSelection() {
    setState(() => _selectedItem = null);
    widget.selectItem(null);
    widget.nameController.clear();
    widget.supplyPriceController.clear();
    widget.retailPriceController.clear();
  }

  void _onVariantPicked(Variant? catalogVariant) {
    if (_selectedItem == null) return;
    for (final list in widget.variantMap.values) {
      list.removeWhere((v) => v.id == _selectedItem!.id);
    }
    if (catalogVariant != null && catalogVariant.id != _selectedItem!.id) {
      widget.variantMap.putIfAbsent(catalogVariant.id, () => []);
      widget.variantMap[catalogVariant.id]!.add(_selectedItem!);
    }
    widget.selectItem(catalogVariant);
    setState(() {});
  }

  Future<void> _approve(Variant item) async {
    setState(() => _approveLoading[item.id] = true);
    try {
      await widget.onApprove(item, widget.variantMap);
    } finally {
      if (mounted) setState(() => _approveLoading[item.id] = false);
    }
  }

  Future<void> _reject(Variant item) async {
    setState(() => _rejectLoading[item.id] = true);
    try {
      await widget.onReject(item, widget.variantMap);
    } finally {
      if (mounted) setState(() => _rejectLoading[item.id] = false);
    }
  }

  String _qtyLabel(Variant variant) {
    final stock = _stockMap[variant.stock?.id];
    final qty = stock?.currentStock ?? variant.stock?.currentStock;
    return '${qty ?? '-'} ${variant.qtyUnitCd ?? ''}'.trim();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width <= ImportPurchaseTokens.mobileBreakpoint;
    final gutter = ImportPurchaseTokens.gutter(width);
    final filtered = _filtered;

    widget.finalItemList
      ..clear()
      ..addAll(filtered);

    return Padding(
      padding: EdgeInsets.fromLTRB(gutter, 18, gutter, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!isMobile) _buildEditBar(filtered),
          if (isMobile) _buildMobileBar(),
          const SizedBox(height: 14),
          Expanded(
            child: filtered.isEmpty
                ? IpmEmptyState(
                    icon: Icons.inbox_outlined,
                    title: 'No imported items',
                    subtitle:
                        'Nothing matches this status filter. Switch the filter or import a new batch.',
                  )
                : isMobile
                    ? _buildMobileCards(filtered)
                    : _buildDesktopTable(filtered),
          ),
        ],
      ),
    );
  }

  Widget _buildEditBar(List<Variant> filtered) {
    final selectedIndex = _selectedItem == null
        ? -1
        : filtered.indexWhere((v) => v.id == _selectedItem!.id);

    return IpmPanel(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_selectedItem == null)
            Row(
              children: [
                const Icon(Icons.edit_outlined,
                    size: 16, color: ImportPurchaseTokens.muted),
                const SizedBox(width: 8),
                Text(
                  'Select a row below to edit its name, prices & variant',
                  style: ImportPurchaseHelpers.text(
                    size: 13,
                    weight: FontWeight.w600,
                    color: ImportPurchaseTokens.muted,
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Text(
                  'Editing ',
                  style: ImportPurchaseHelpers.text(
                    size: 13,
                    weight: FontWeight.w600,
                    color: ImportPurchaseTokens.ink2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: ImportPurchaseTokens.accentWash,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '#${selectedIndex + 1}',
                    style: ImportPurchaseHelpers.text(
                      size: 12,
                      weight: FontWeight.w800,
                      color: ImportPurchaseTokens.accentStrong,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _selectedItem!.itemNm ?? _selectedItem!.name,
                    style: ImportPurchaseHelpers.text(
                      size: 13,
                      weight: FontWeight.w600,
                      color: ImportPurchaseTokens.ink2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: _clearSelection,
                  child: Text(
                    'Clear',
                    style: ImportPurchaseHelpers.text(
                      size: 14,
                      weight: FontWeight.w700,
                      color: ImportPurchaseTokens.accentStrong,
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final cols = constraints.maxWidth > 700 ? 4 : 2;
              return Wrap(
                spacing: 16,
                runSpacing: 14,
                children: [
                  SizedBox(
                    width: (constraints.maxWidth - 16 * (cols - 1)) / cols,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const IpmFieldLabel('Item name'),
                        IpmTextField(
                          controller: widget.nameController,
                          hint: 'Enter a name',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: (constraints.maxWidth - 16 * (cols - 1)) / cols,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const IpmFieldLabel('Supply price'),
                        IpmTextField(
                          controller: widget.supplyPriceController,
                          hint: 'Enter supply price',
                          numeric: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: (constraints.maxWidth - 16 * (cols - 1)) / cols,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const IpmFieldLabel('Retail price'),
                        IpmTextField(
                          controller: widget.retailPriceController,
                          hint: 'Enter retail price',
                          numeric: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: (constraints.maxWidth - 16 * (cols - 1)) / cols,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const IpmFieldLabel('Variant'),
                        IpmVariantCombo(
                          selectedVariantId: _selectedItem == null
                              ? null
                              : _catalogIdFor(_selectedItem!),
                          onSelected: _onVariantPicked,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IpmButton(
                label: 'Save Changes',
                icon: Icons.check,
                onPressed: widget.saveChangeMadeOnItem,
              ),
              const SizedBox(width: 12),
              IpmButton(
                label: 'Accept All',
                icon: Icons.check_circle_outline,
                variant: IpmButtonVariant.green,
                onPressed: () {
                  final waiting = widget.items
                      .where((v) => v.imptItemSttsCd == '2')
                      .toList();
                  widget.acceptAllImport(waiting);
                },
              ),
              const Spacer(),
              SizedBox(
                width: 200,
                child: IpmStatusFilter(
                  value: _statusFilter,
                  options: _filterOptions,
                  onChanged: (v) => setState(() => _statusFilter = v),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: ImportPurchaseTokens.surface,
              borderRadius: BorderRadius.circular(ImportPurchaseTokens.radiusSm),
              border: Border.all(color: ImportPurchaseTokens.line2),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _statusFilter,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down,
                    color: ImportPurchaseTokens.muted),
                items: _filterOptions
                    .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _statusFilter = v);
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        IpmButton(
          label: 'Accept All',
          icon: Icons.check_circle_outline,
          variant: IpmButtonVariant.green,
          compact: true,
          onPressed: () {
            final waiting =
                widget.items.where((v) => v.imptItemSttsCd == '2').toList();
            widget.acceptAllImport(waiting);
          },
        ),
      ],
    );
  }

  Widget _buildDesktopTable(List<Variant> filtered) {
    return IpmPanel(
      child: Column(
        children: [
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              color: ImportPurchaseTokens.surface2,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(ImportPurchaseTokens.radiusLg),
              ),
              border: Border(bottom: BorderSide(color: ImportPurchaseTokens.line)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 46, child: IpmColumnHeader('No.')),
                const Expanded(flex: 14, child: IpmColumnHeader('Item Name')),
                const SizedBox(width: 110, child: IpmColumnHeader('HS Code')),
                const SizedBox(width: 110, child: IpmColumnHeader('Quantity')),
                const SizedBox(
                  width: 116,
                  child: IpmColumnHeader('Retail', align: TextAlign.end),
                ),
                const SizedBox(
                  width: 116,
                  child: IpmColumnHeader('Supply', align: TextAlign.end),
                ),
                const SizedBox(width: 104, child: IpmColumnHeader('Status')),
                const Expanded(flex: 15, child: IpmColumnHeader('Supplier')),
                const SizedBox(width: 130, child: IpmColumnHeader('Date')),
                const SizedBox(
                  width: 92,
                  child: IpmColumnHeader('Actions', align: TextAlign.end),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: ImportPurchaseTokens.line),
              itemBuilder: (context, index) {
                final item = filtered[index];
                final selected = _selectedItem?.id == item.id;
                final statusKey = ImportPurchaseHelpers.importStatusKey(item);
                final vtag = _catalogNameFor(item);

                return Material(
                  color: selected
                      ? ImportPurchaseTokens.accentWash
                      : Colors.transparent,
                  child: InkWell(
                    onTap: () => _selectRow(item),
                    child: Container(
                      decoration: selected
                          ? const BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: ImportPurchaseTokens.accent,
                                  width: 3,
                                ),
                              ),
                            )
                          : null,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      constraints: const BoxConstraints(minHeight: 60),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 46,
                            child: Text(
                              '${index + 1}',
                              style: ImportPurchaseHelpers.text(
                                size: 14,
                                weight: FontWeight.w800,
                                color: ImportPurchaseTokens.muted,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 14,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.itemNm ?? item.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                            width: 110,
                            child: Text(
                              item.hsCd?.toString() ?? '',
                              style: ImportPurchaseHelpers.text(
                                size: 14,
                                color: ImportPurchaseTokens.ink2,
                                tabular: true,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 110,
                            child: Text(
                              _qtyLabel(item),
                              style: ImportPurchaseHelpers.text(
                                size: 14,
                                weight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 116,
                            child: Text(
                              ImportPurchaseHelpers.formatMoney(item.retailPrice),
                              textAlign: TextAlign.end,
                              style: ImportPurchaseHelpers.text(
                                size: 14,
                                weight: FontWeight.w600,
                                tabular: true,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 116,
                            child: Text(
                              ImportPurchaseHelpers.formatMoney(item.supplyPrice),
                              textAlign: TextAlign.end,
                              style: ImportPurchaseHelpers.text(
                                size: 14,
                                weight: FontWeight.w600,
                                tabular: true,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 104,
                            child: IpmStatusBadge(statusKey: statusKey),
                          ),
                          Expanded(
                            flex: 15,
                            child: Text(
                              item.spplrNm ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: ImportPurchaseHelpers.text(
                                size: 14,
                                color: ImportPurchaseTokens.ink2,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 130,
                            child: Text(
                              item.lastTouched == null
                                  ? ''
                                  : timeago.format(
                                      item.lastTouched!,
                                      clock: DateTime.now(),
                                    ),
                              style: ImportPurchaseHelpers.text(
                                size: 14,
                                color: ImportPurchaseTokens.ink2,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 92,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (statusKey == 'wait') ...[
                                  IpmIconActionButton(
                                    icon: Icons.check_circle_outline,
                                    loading: _approveLoading[item.id] ?? false,
                                    onPressed: () => _approve(item),
                                  ),
                                  const SizedBox(width: 8),
                                  IpmIconActionButton(
                                    icon: Icons.cancel_outlined,
                                    accept: false,
                                    loading: _rejectLoading[item.id] ?? false,
                                    onPressed: () => _reject(item),
                                  ),
                                ] else
                                  IpmStatusBadge(statusKey: statusKey),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileCards(List<Variant> filtered) {
    return ListView.separated(
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = filtered[index];
        final selected = _selectedItem?.id == item.id;
        final statusKey = ImportPurchaseHelpers.importStatusKey(item);
        final vtag = _catalogNameFor(item);

        return Container(
          decoration: BoxDecoration(
            color: ImportPurchaseTokens.surface,
            borderRadius: BorderRadius.circular(ImportPurchaseTokens.radius),
            border: Border.all(
              color: selected
                  ? ImportPurchaseTokens.accent
                  : ImportPurchaseTokens.line,
              width: selected ? 1 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: ImportPurchaseTokens.accent.withValues(alpha: 0.15),
                      blurRadius: 0,
                      spreadRadius: 3,
                    ),
                  ]
                : ImportPurchaseTokens.cardShadows,
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ImportPurchaseTokens.surface3,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: ImportPurchaseHelpers.text(
                        size: 13,
                        weight: FontWeight.w800,
                        color: ImportPurchaseTokens.muted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.itemNm ?? item.name,
                          style: ImportPurchaseHelpers.text(
                            size: 15.5,
                            weight: FontWeight.w800,
                            letterSpacing: -0.1,
                          ),
                        ),
                        Text(
                          vtag != null
                              ? 'Variant · $vtag'
                              : 'No variant assigned',
                          style: ImportPurchaseHelpers.text(
                            size: 12.5,
                            weight: FontWeight.w600,
                            color: vtag != null
                                ? ImportPurchaseTokens.accentStrong
                                : ImportPurchaseTokens.faint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IpmStatusBadge(statusKey: statusKey),
                ],
              ),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 16,
                childAspectRatio: 2.8,
                children: [
                  _mobileGrid('HS Code', item.hsCd?.toString() ?? ''),
                  _mobileGrid('Quantity', _qtyLabel(item)),
                  _mobileGrid(
                    'Supply Price',
                    ImportPurchaseHelpers.formatMoney(item.supplyPrice),
                  ),
                  _mobileGrid(
                    'Retail Price',
                    ImportPurchaseHelpers.formatMoney(item.retailPrice),
                  ),
                  _mobileGrid('Supplier', item.spplrNm ?? ''),
                  _mobileGrid(
                    'Date',
                    item.lastTouched == null
                        ? ''
                        : timeago.format(
                            item.lastTouched!,
                            clock: DateTime.now(),
                          ),
                  ),
                ],
              ),
              const Divider(height: 25, color: ImportPurchaseTokens.line),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _selectRow(item);
                        _showMobileEditSheet(item);
                      },
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Edit'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (statusKey == 'wait') ...[
                    IpmIconActionButton(
                      icon: Icons.check_circle_outline,
                      size: 44,
                      loading: _approveLoading[item.id] ?? false,
                      onPressed: () => _approve(item),
                    ),
                    const SizedBox(width: 10),
                    IpmIconActionButton(
                      icon: Icons.cancel_outlined,
                      accept: false,
                      size: 44,
                      loading: _rejectLoading[item.id] ?? false,
                      onPressed: () => _reject(item),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _mobileGrid(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: ImportPurchaseHelpers.text(
                    size: 11,
                    weight: FontWeight.w700,
                    color: ImportPurchaseTokens.muted,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: ImportPurchaseHelpers.text(
                    size: 14,
                    weight: FontWeight.w600,
                    tabular: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMobileEditSheet(Variant item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: IpmModalShell(
          title: 'Edit item',
          subtitle: item.itemNm ?? item.name,
          icon: Icons.edit_outlined,
          onClose: () => Navigator.of(context).pop(),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(22, 6, 22, 20),
            child: Column(
              children: [
                IpmTextField(
                  controller: widget.nameController,
                  hint: 'Enter a name',
                ),
                const SizedBox(height: 14),
                IpmTextField(
                  controller: widget.supplyPriceController,
                  hint: 'Supply price',
                  numeric: true,
                ),
                const SizedBox(height: 14),
                IpmTextField(
                  controller: widget.retailPriceController,
                  hint: 'Retail price',
                  numeric: true,
                ),
                const SizedBox(height: 14),
                IpmVariantCombo(
                  selectedVariantId: _catalogIdFor(item),
                  onSelected: _onVariantPicked,
                ),
              ],
            ),
          ),
          footer: Row(
            children: [
              Expanded(
                child: IpmButton(
                  label: 'Cancel',
                  variant: IpmButtonVariant.ghost,
                  block: true,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: IpmButton(
                  label: 'Save Changes',
                  icon: Icons.check,
                  block: true,
                  onPressed: () {
                    widget.saveChangeMadeOnItem();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
