import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_models/brick/models/stock_recount.model.dart';
import 'package:supabase_models/brick/models/stock_recount_item.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

import 'stock_recount_helpers.dart';
import 'stock_recount_icons.dart';
import 'stock_recount_pdf.dart';
import 'stock_recount_service.dart';
import 'stock_recount_tokens.dart';
import 'stock_recount_ui.dart';

class StockRecountActiveScreen extends StatefulWidget {
  const StockRecountActiveScreen({super.key, required this.recountId});

  final String recountId;

  @override
  State<StockRecountActiveScreen> createState() =>
      _StockRecountActiveScreenState();
}

class _StockRecountActiveScreenState extends State<StockRecountActiveScreen> {
  static const _service = StockRecountService();

  final _noteController = TextEditingController();
  final _searchController = TextEditingController();

  StockRecount? _recount;
  List<StockRecountItem> _items = [];
  bool _loading = true;
  Object? _error;
  bool _submitting = false;
  bool _exporting = false;

  Variant? _stagedVariant;
  int _stagedQty = 0;
  List<Variant> _searchResults = [];
  bool _searching = false;
  final Map<String, GlobalKey> _itemKeys = {};

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void didUpdateWidget(covariant StockRecountActiveScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.recountId != widget.recountId) {
      _bootstrap();
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  RecountItemStats get _stats => RecountItemStats.fromItems(_items);

  bool get _editable => _recount?.status == 'draft';

  Future<void> _bootstrap() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final recount = await _service.getRecount(widget.recountId);
      if (!mounted) return;
      if (recount == null) {
        setState(() {
          _recount = null;
          _items = [];
          _loading = false;
        });
        return;
      }
      final items = await _service.getItems(widget.recountId);
      if (!mounted) return;
      _noteController.text = recount.notes ?? '';
      setState(() {
        _recount = recount;
        _items = items;
        _loading = false;
      });
    } catch (e, st) {
      talker.error('StockRecountDetail: bootstrap failed', e, st);
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  Future<void> _reloadItems() async {
    final items = await _service.getItems(widget.recountId);
    if (!mounted) return;
    setState(() => _items = items);
  }

  Future<void> _saveNote() async {
    if (!_editable) return;
    try {
      final updated = await _service.updateNotes(
        widget.recountId,
        _noteController.text.trim(),
      );
      if (mounted) setState(() => _recount = updated);
    } catch (e, st) {
      talker.error('StockRecountDetail: note save failed', e, st);
    }
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _searching = false;
      });
      return;
    }
    setState(() => _searching = true);
    try {
      final results = await _service.searchVariants(query);
      if (!mounted) return;
      setState(() {
        _searchResults = results;
        _searching = false;
      });
    } catch (e, st) {
      talker.error('StockRecountDetail: search failed', e, st);
      if (mounted) setState(() => _searching = false);
    }
  }

  bool _isVariantInSession(String variantId) =>
      _items.any((i) => i.variantId == variantId);

  void _flashExistingItem(String variantId, String name) {
    final key = _itemKeys[variantId];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
    showStockRecountToast(context, '$name is already in this count');
  }

  void _stageVariant(Variant variant) {
    if (_isVariantInSession(variant.id)) {
      _flashExistingItem(variant.id, variant.name);
      return;
    }
    setState(() {
      _stagedVariant = variant;
      _stagedQty = 0;
      _searchController.clear();
      _searchResults = [];
    });
  }

  Future<void> _commitStaged() async {
    final variant = _stagedVariant;
    if (variant == null) return;
    try {
      await _service.addOrUpdateItem(
        recountId: widget.recountId,
        variantId: variant.id,
        countedQuantity: _stagedQty.toDouble(),
      );
      if (!mounted) return;
      setState(() {
        _stagedVariant = null;
        _stagedQty = 0;
      });
      await _reloadItems();
      showStockRecountToast(context, '${variant.name} added to the count');
    } catch (e, st) {
      talker.error('StockRecountDetail: add item failed', e, st);
      if (mounted) showStockRecountToast(context, 'Could not add item: $e');
    }
  }

  Future<void> _updateItemCount(StockRecountItem item, int qty) async {
    try {
      await _service.addOrUpdateItem(
        recountId: widget.recountId,
        variantId: item.variantId,
        countedQuantity: qty.toDouble(),
      );
      await _reloadItems();
    } catch (e, st) {
      talker.error('StockRecountDetail: update count failed', e, st);
      if (mounted) showStockRecountToast(context, 'Update failed: $e');
    }
  }

  Future<void> _removeItem(String itemId) async {
    try {
      await _service.removeItem(itemId);
      await _reloadItems();
      if (mounted) showStockRecountToast(context, 'Item removed');
    } catch (e, st) {
      talker.error('StockRecountDetail: remove failed', e, st);
      if (mounted) showStockRecountToast(context, 'Remove failed: $e');
    }
  }

  Future<void> _openScanner() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (ctx) => _BarcodeScannerPage(
          onDetected: (code) async {
            Navigator.pop(ctx);
            final variant = await _service.variantByBarcode(code);
            if (!mounted) return;
            if (variant == null) {
              showStockRecountToast(context, 'Unknown barcode');
              return;
            }
            if (_isVariantInSession(variant.id)) {
              _flashExistingItem(variant.id, variant.name);
              return;
            }
            final systemQty = await _systemQtyForVariant(variant);
            await _service.addOrUpdateItem(
              recountId: widget.recountId,
              variantId: variant.id,
              countedQuantity: systemQty,
            );
            if (!mounted) return;
            await _reloadItems();
            _flashExistingItem(variant.id, variant.name);
            showStockRecountToast(
              context,
              'Scanned ${variant.name} — adjust the count if needed',
            );
          },
        ),
      ),
    );
  }

  Future<double> _systemQtyForVariant(Variant variant) async {
    for (final item in _items) {
      if (item.variantId == variant.id) return item.previousQuantity;
    }
    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) return 0;
      final summary = await stockRecountSync().getStockSummary(
        branchId: branchId,
        variantIds: [variant.id],
      );
      return summary[variant.id] ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<void> _exportPdf() async {
    final recount = _recount;
    if (recount == null || _exporting) return;
    setState(() => _exporting = true);
    try {
      final tenant = await ProxyService.strategy.getTenant(
        userId: ProxyService.box.getUserId() ?? '',
      );
      final branchName =
          await StockRecountExportContext.resolveBranchName(recount.branchId);
      await StockRecountPdfExport.previewAndShare(
        recount: recount,
        items: _items,
        businessName: tenant?.name ?? 'Business',
        branchName: branchName,
      );
    } catch (e, st) {
      talker.error('StockRecountDetail: export failed', e, st);
      if (mounted) showStockRecountToast(context, 'Export failed: $e');
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _submit() async {
    if (_items.isEmpty) return;
    final shorts = _items.where((i) => i.difference < 0).toList();
    String? shortageReason;
    if (shorts.isNotEmpty) {
      shortageReason = await _ConfirmShortageSheet.show(
        context,
        items: shorts,
        net: _stats.net,
      );
      if (shortageReason == null) return;
    } else {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Submit recount?'),
          content: const Text(
            'This updates stock levels from your counted quantities.',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Submit')),
          ],
        ),
      );
      if (ok != true) return;
    }

    setState(() => _submitting = true);
    try {
      final updated = await _service.submit(
        widget.recountId,
        shortageReason: shortageReason,
      );
      if (!mounted) return;
      setState(() {
        _recount = updated;
        _submitting = false;
      });
      showStockRecountToast(context, 'Recount submitted ✓');
    } catch (e, st) {
      talker.error('StockRecountDetail: submit failed', e, st);
      if (mounted) {
        setState(() => _submitting = false);
        showStockRecountToast(context, 'Submit failed: $e');
      }
    }
  }

  void _showInfo() {
    showStockRecountToast(
      context,
      'Count physical stock, compare variance, then submit to sync inventory.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final recount = _recount;
    final loading = _loading && recount == null;

    return StockRecountScreenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: StockRecountBlurredAppBar(
          leading: StockRecountIconButton(
            iconName: 'chevron-left',
            onPressed: () => Navigator.maybePop(context),
          ),
          title: 'Stock Recount',
          subtitle: recount?.deviceName,
          onInfo: _showInfo,
        ),
        body: _error != null
            ? Center(child: Text('Could not load recount: $_error'))
            : loading
            ? const Center(child: CircularProgressIndicator())
            : recount == null
            ? const Center(child: Text('Recount not found'))
            : _DetailBody(
                recount: recount,
                items: _items,
                editable: _editable,
                stats: _stats,
                submitting: _submitting,
                exporting: _exporting,
                noteController: _noteController,
                searchController: _searchController,
                searching: _searching,
                searchResults: _searchResults,
                stagedVariant: _stagedVariant,
                stagedQty: _stagedQty,
                itemKeys: _itemKeys,
                onNoteChanged: _saveNote,
                onSearch: _search,
                onStage: _stageVariant,
                onStagedQty: (q) => setState(() => _stagedQty = q),
                onCommit: _commitStaged,
                isInSession: _isVariantInSession,
                onScan: _openScanner,
                onQtyChanged: _updateItemCount,
                onRemove: _removeItem,
                onExport: _exportPdf,
                onSubmit: _submit,
              ),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.recount,
    required this.items,
    required this.editable,
    required this.stats,
    required this.submitting,
    required this.exporting,
    required this.noteController,
    required this.searchController,
    required this.searching,
    required this.searchResults,
    required this.stagedVariant,
    required this.stagedQty,
    required this.itemKeys,
    required this.onNoteChanged,
    required this.onSearch,
    required this.onStage,
    required this.onStagedQty,
    required this.onCommit,
    required this.isInSession,
    required this.onScan,
    required this.onQtyChanged,
    required this.onRemove,
    required this.onExport,
    required this.onSubmit,
  });

  final StockRecount recount;
  final List<StockRecountItem> items;
  final bool editable;
  final RecountItemStats stats;
  final bool submitting;
  final bool exporting;
  final TextEditingController noteController;
  final TextEditingController searchController;
  final bool searching;
  final List<Variant> searchResults;
  final Variant? stagedVariant;
  final int stagedQty;
  final Map<String, GlobalKey> itemKeys;
  final VoidCallback onNoteChanged;
  final ValueChanged<String> onSearch;
  final ValueChanged<Variant> onStage;
  final ValueChanged<int> onStagedQty;
  final VoidCallback onCommit;
  final bool Function(String) isInSession;
  final VoidCallback onScan;
  final Future<void> Function(StockRecountItem, int) onQtyChanged;
  final Future<void> Function(String) onRemove;
  final VoidCallback onExport;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return LayoutBuilder(
        builder: (context, constraints) {
          final pad = StockRecountHelpers.horizontalPadding(constraints.maxWidth);
          final narrow = constraints.maxWidth <= StockRecountTokens.narrowBreakpoint;
          return Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: StockRecountTokens.maxContentWidth,
                  ),
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(pad, 16, pad, 140 + bottomPad),
                    children: [
                      _SessionHeader(
                        recount: recount,
                        noteController: noteController,
                        editable: editable,
                        onNoteChanged: onNoteChanged,
                      ),
                      const SizedBox(height: 14),
                      _SummaryStatsGrid(stats: stats, narrow: narrow),
                      if (editable) ...[
                        const SizedBox(height: 14),
                        _AddPanel(
                          searchController: searchController,
                          onSearch: onSearch,
                          searching: searching,
                          results: searchResults,
                          staged: stagedVariant,
                          stagedQty: stagedQty,
                          onStage: onStage,
                          onStagedQty: onStagedQty,
                          onCommit: onCommit,
                          isInSession: isInSession,
                          onScan: onScan,
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'Counted items',
                            style: StockRecountHelpers.text(
                              size: 16,
                              weight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${stats.count} items · net ${StockRecountHelpers.formatSignedVariance(stats.net)}',
                            style: StockRecountHelpers.text(
                              size: 12.5,
                              color: StockRecountTokens.ink3,
                              tabular: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (items.isEmpty)
                        _ItemsEmptyState(editable: editable)
                      else
                        ...items.map((item) {
                          itemKeys.putIfAbsent(item.variantId, GlobalKey.new);
                          return Padding(
                            key: itemKeys[item.variantId],
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _CountItemCard(
                              item: item,
                              editable: editable,
                              narrow: narrow,
                              onQtyChanged: (q) => onQtyChanged(item, q),
                              onRemove: () => onRemove(item.id),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _ActionBar(
                  editable: editable,
                  stats: stats,
                  submitting: submitting,
                  exporting: exporting,
                  canSubmit: items.isNotEmpty,
                  onExport: onExport,
                  onSubmit: onSubmit,
                ),
              ),
            ],
          );
        },
    );
  }
}

class _SessionHeader extends StatelessWidget {
  const _SessionHeader({
    required this.recount,
    required this.noteController,
    required this.editable,
    required this.onNoteChanged,
  });

  final StockRecount recount;
  final TextEditingController noteController;
  final bool editable;
  final VoidCallback onNoteChanged;

  @override
  Widget build(BuildContext context) {
    return stockRecountCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: StockRecountTokens.brandGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: StockRecountIcons.box(size: 24, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recount.deviceName ?? 'Device',
                      style: StockRecountHelpers.text(size: 19, weight: FontWeight.w700),
                    ),
                    Text(
                      'Created ${StockRecountHelpers.formatDateTime(recount.createdAt)}',
                      style: StockRecountHelpers.text(
                        size: 12.5,
                        color: StockRecountTokens.ink3,
                      ),
                    ),
                  ],
                ),
              ),
              StockRecountStatusBadge(status: recount.status),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: StockRecountTokens.surface2,
              border: Border.all(color: StockRecountTokens.line),
              borderRadius: BorderRadius.circular(StockRecountTokens.radiusMd),
            ),
            child: Row(
              children: [
                StockRecountIcons.receipt(size: 17, color: StockRecountTokens.ink3),
                const SizedBox(width: 10),
                Expanded(
                  child: editable
                      ? TextField(
                          controller: noteController,
                          onEditingComplete: onNoteChanged,
                          onTapOutside: (_) => onNoteChanged(),
                          style: StockRecountHelpers.text(size: 14.5, weight: FontWeight.w500),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintText: 'Add a note for this recount session…',
                            hintStyle: StockRecountHelpers.text(
                              size: 14.5,
                              weight: FontWeight.w400,
                              color: StockRecountTokens.ink4,
                            ),
                          ),
                        )
                      : Text(
                          noteController.text.isEmpty
                              ? 'No note'
                              : noteController.text,
                          style: StockRecountHelpers.text(
                            size: 14.5,
                            color: StockRecountTokens.ink2,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryStatsGrid extends StatelessWidget {
  const _SummaryStatsGrid({required this.stats, required this.narrow});

  final RecountItemStats stats;
  final bool narrow;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _StatCard(
        label: 'Items counted',
        value: '${stats.count}',
        leading: StockRecountIcons.stack(size: 13, color: StockRecountTokens.ink3),
      ),
      _StatCard(label: 'Matching', value: '${stats.match}', dot: StockRecountTokens.pos),
      _StatCard(
        label: 'Surplus',
        value: '${stats.over}',
        dot: StockRecountTokens.pos,
        valueColor: StockRecountTokens.posText,
      ),
      _StatCard(
        label: 'Short',
        value: '${stats.short}',
        dot: StockRecountTokens.neg,
        valueColor: StockRecountTokens.negText,
      ),
    ];
    return GridView.count(
      crossAxisCount: narrow ? 2 : 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: narrow ? 1.55 : 1.35,
      children: cards,
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.dot,
    this.leading,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? dot;
  final Widget? leading;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return stockRecountCard(
      radius: StockRecountTokens.radiusMd,
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 6),
              ] else if (dot != null) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  label,
                  style: StockRecountHelpers.text(
                    size: 11.5,
                    weight: FontWeight.w600,
                    color: StockRecountTokens.ink3,
                    letterSpacing: 0.115,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: StockRecountHelpers.text(
              size: 23,
              weight: FontWeight.w800,
              color: valueColor ?? StockRecountTokens.ink1,
              tabular: true,
              letterSpacing: -0.46,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddPanel extends StatefulWidget {
  const _AddPanel({
    required this.searchController,
    required this.onSearch,
    required this.searching,
    required this.results,
    required this.staged,
    required this.stagedQty,
    required this.onStage,
    required this.onStagedQty,
    required this.onCommit,
    required this.isInSession,
    required this.onScan,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final bool searching;
  final List<Variant> results;
  final Variant? staged;
  final int stagedQty;
  final ValueChanged<Variant> onStage;
  final ValueChanged<int> onStagedQty;
  final VoidCallback onCommit;
  final bool Function(String) isInSession;
  final VoidCallback onScan;

  @override
  State<_AddPanel> createState() => _AddPanelState();
}

class _AddPanelState extends State<_AddPanel> {
  Map<String, double> _systemQty = {};

  @override
  void initState() {
    super.initState();
    _loadSystemQty();
  }

  @override
  void didUpdateWidget(covariant _AddPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.results != widget.results || oldWidget.staged != widget.staged) {
      _loadSystemQty();
    }
  }

  Future<void> _loadSystemQty() async {
    final ids = <String>{
      ...widget.results.map((v) => v.id),
      if (widget.staged != null) widget.staged!.id,
    };
    if (ids.isEmpty) return;
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;
    try {
      final summary = await stockRecountSync().getStockSummary(
        branchId: branchId,
        variantIds: ids.toList(),
      );
      if (mounted) setState(() => _systemQty = {..._systemQty, ...summary});
    } catch (_) {}
  }

  double _qtyFor(String variantId) => _systemQty[variantId] ?? 0;

  @override
  Widget build(BuildContext context) {
    final staged = widget.staged;
    return stockRecountCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: StockRecountTokens.accentTint,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: StockRecountIcons.plus(size: 18, color: StockRecountTokens.accent),
              ),
              const SizedBox(width: 10),
              Text(
                'Add a product to count',
                style: StockRecountHelpers.text(size: 15, weight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    StockRecountSearchField(
                      controller: widget.searchController,
                      hint: 'Search product name, SKU or barcode…',
                      onChanged: widget.onSearch,
                    ),
                    if (widget.searching)
                      const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (widget.searchController.text.trim().isNotEmpty &&
                        widget.results.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          'No product matches "${widget.searchController.text.trim()}".',
                          textAlign: TextAlign.center,
                          style: StockRecountHelpers.text(
                            size: 13.5,
                            color: StockRecountTokens.ink3,
                          ),
                        ),
                      )
                    else if (widget.results.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        constraints: const BoxConstraints(maxHeight: 320),
                        decoration: BoxDecoration(
                          color: StockRecountTokens.surface,
                          border: Border.all(color: StockRecountTokens.line),
                          borderRadius: BorderRadius.circular(StockRecountTokens.radiusMd),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x38102040),
                              blurRadius: 44,
                              offset: Offset(0, 18),
                              spreadRadius: -12,
                            ),
                          ],
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: widget.results.length,
                          separatorBuilder: (_, __) => const Divider(
                            height: 1,
                            color: StockRecountTokens.lineSoft,
                          ),
                          itemBuilder: (context, index) {
                            final v = widget.results[index];
                            final added = widget.isInSession(v.id);
                            return InkWell(
                              onTap: () => widget.onStage(v),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    StockRecountItemSwatch(name: v.name, size: 38),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            v.name,
                                            style: StockRecountHelpers.text(
                                              size: 14.5,
                                              weight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            'SKU ${v.sku ?? '—'} · ${v.bcd ?? v.itemCd ?? '—'}',
                                            style: StockRecountHelpers.text(
                                              size: 12,
                                              color: StockRecountTokens.ink3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (added)
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          StockRecountIcons.check(
                                            size: 13,
                                            color: StockRecountTokens.pos,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Added',
                                            style: StockRecountHelpers.text(
                                              size: 11,
                                              weight: FontWeight.w700,
                                              color: StockRecountTokens.pos,
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            StockRecountHelpers.formatQty(_qtyFor(v.id)),
                                            style: StockRecountHelpers.text(
                                              size: 12,
                                              weight: FontWeight.w700,
                                              color: StockRecountTokens.ink2,
                                              tabular: true,
                                            ),
                                          ),
                                          Text(
                                            'in system',
                                            style: StockRecountHelpers.text(
                                              size: 10.5,
                                              weight: FontWeight.w600,
                                              color: StockRecountTokens.ink4,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Material(
                color: StockRecountTokens.accentTint,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(StockRecountTokens.radiusMd),
                  side: const BorderSide(color: StockRecountTokens.accentTint2, width: 1.5),
                ),
                child: InkWell(
                  onTap: widget.onScan,
                  borderRadius: BorderRadius.circular(StockRecountTokens.radiusMd),
                  child: SizedBox(
                    width: 52,
                    height: 52,
                    child: StockRecountIcons.barcode(
                      size: 24,
                      color: StockRecountTokens.accent,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (staged != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              decoration: BoxDecoration(
                color: StockRecountTokens.accentTint,
                border: Border.all(color: StockRecountTokens.accentTint2, width: 1.5),
                borderRadius: BorderRadius.circular(StockRecountTokens.radiusMd),
              ),
              child: Row(
                children: [
                  StockRecountItemSwatch(name: staged.name, size: 38),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          staged.name,
                          style: StockRecountHelpers.text(
                            size: 14.5,
                            weight: FontWeight.w700,
                            color: StockRecountTokens.accentDeep,
                          ),
                        ),
                        Text(
                          'SKU ${staged.sku ?? '—'} · ${StockRecountHelpers.formatQty(_qtyFor(staged.id))} in system',
                          style: StockRecountHelpers.text(
                            size: 12,
                            color: StockRecountTokens.ink3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StockRecountQtyStepper(
                    value: widget.stagedQty,
                    onChanged: widget.onStagedQty,
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 100,
                    child: StockRecountPrimaryButton(
                      label: 'Add',
                      leading: StockRecountIcons.check(size: 18, color: Colors.white),
                      height: 48,
                      onPressed: widget.onCommit,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CountItemCard extends StatelessWidget {
  const _CountItemCard({
    required this.item,
    required this.editable,
    required this.narrow,
    required this.onQtyChanged,
    required this.onRemove,
  });

  final StockRecountItem item;
  final bool editable;
  final bool narrow;
  final ValueChanged<int> onQtyChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final diff = item.difference;
    final short = diff < 0;
    return stockRecountCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      borderColor: short && editable
          ? StockRecountTokens.shortItemBorder
          : StockRecountTokens.line,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StockRecountItemSwatch(name: item.productName, size: 40),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      style: StockRecountHelpers.text(size: 15.5, weight: FontWeight.w700),
                    ),
                    Text(
                      'SKU ${item.variantId} · counted ${StockRecountHelpers.formatTime(item.createdAt)}',
                      style: StockRecountHelpers.text(
                        size: 12,
                        color: StockRecountTokens.ink3,
                      ),
                    ),
                  ],
                ),
              ),
              if (editable) StockRecountDeleteButton(onPressed: onRemove),
            ],
          ),
          const SizedBox(height: 12),
          _Zones(
            system: item.previousQuantity,
            counted: item.countedQuantity,
            variance: diff,
            editable: editable,
            narrow: narrow,
            onCounted: onQtyChanged,
          ),
          if (editable && diff != 0) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(10, 10, 13, 10),
              decoration: BoxDecoration(
                color: short ? StockRecountTokens.negTint : StockRecountTokens.posTint,
                borderRadius: BorderRadius.circular(StockRecountTokens.radiusMd),
              ),
              child: Row(
                children: [
                  short
                      ? StockRecountIcons.info(
                          size: 15,
                          color: StockRecountTokens.negText,
                        )
                      : StockRecountIcons.trendUp(
                          size: 15,
                          color: StockRecountTokens.posText,
                        ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      short
                          ? 'Counted ${diff.abs().toStringAsFixed(0)} fewer than the system shows — this will be recorded as shrinkage.'
                          : 'Counted ${diff.toStringAsFixed(0)} more than the system shows — a surplus will be recorded.',
                      style: StockRecountHelpers.text(
                        size: 12.5,
                        color: short ? StockRecountTokens.negText : StockRecountTokens.posText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Zones extends StatelessWidget {
  const _Zones({
    required this.system,
    required this.counted,
    required this.variance,
    required this.editable,
    required this.narrow,
    required this.onCounted,
  });

  final double system;
  final double counted;
  final double variance;
  final bool editable;
  final bool narrow;
  final ValueChanged<int> onCounted;

  @override
  Widget build(BuildContext context) {
    final systemZone = _zone(
      label: 'System',
      labelIcon: StockRecountIcons.monitor(size: 13, color: StockRecountTokens.ink3),
      value: StockRecountHelpers.formatQty(system),
      bg: StockRecountTokens.surface2,
      border: StockRecountTokens.line,
      labelColor: StockRecountTokens.ink3,
      valueColor: StockRecountTokens.ink1,
    );
    final countedZone = _zone(
      label: 'Counted',
      labelIcon: StockRecountIcons.stack(size: 13, color: StockRecountTokens.accentDeep),
      value: editable
          ? null
          : StockRecountHelpers.formatQty(counted),
      bg: StockRecountTokens.accentTint,
      border: StockRecountTokens.accentTint2,
      labelColor: StockRecountTokens.accentDeep,
      valueColor: StockRecountTokens.accentDeep,
      child: editable
          ? StockRecountQtyStepper(
              compact: true,
              value: counted.round(),
              onChanged: onCounted,
            )
          : null,
    );
    final varianceZone = _varianceZone(variance);

    if (narrow) {
      return Column(
        children: [
          Row(children: [Expanded(child: systemZone), const SizedBox(width: 8), Expanded(child: countedZone)]),
          const SizedBox(height: 8),
          varianceZone,
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: systemZone),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: StockRecountIcons.chevronRight(size: 18, color: StockRecountTokens.ink4),
        ),
        Expanded(child: countedZone),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: StockRecountIcons.chevronRight(size: 18, color: StockRecountTokens.ink4),
        ),
        Expanded(child: varianceZone),
      ],
    );
  }

  Widget _zone({
    required String label,
    Widget? labelIcon,
    String? value,
    required Color bg,
    required Color border,
    required Color labelColor,
    required Color valueColor,
    Widget? child,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border, width: border == StockRecountTokens.accentTint2 ? 1.5 : 1),
        borderRadius: BorderRadius.circular(StockRecountTokens.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (labelIcon != null) ...[
                labelIcon,
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: StockRecountHelpers.text(
                  size: 11,
                  weight: FontWeight.w600,
                  color: labelColor,
                  letterSpacing: 0.22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (child != null)
            child
          else
            Text(
              value ?? '',
              style: StockRecountHelpers.text(
                size: 21,
                weight: FontWeight.w800,
                color: valueColor,
                tabular: true,
                letterSpacing: -0.42,
              ),
            ),
        ],
      ),
    );
  }

  Widget _varianceZone(double variance) {
    final pos = variance > 0;
    final neg = variance < 0;
    return _zone(
      label: 'Variance',
      labelIcon: pos
          ? StockRecountIcons.trendUp(size: 13, color: StockRecountTokens.posText)
          : neg
          ? StockRecountIcons.arrowDown(size: 13, color: StockRecountTokens.negText)
          : StockRecountIcons.check(size: 13, color: StockRecountTokens.ink3),
      value: StockRecountHelpers.formatSignedVariance(variance),
      bg: pos
          ? StockRecountTokens.posTint
          : neg
          ? StockRecountTokens.negTint
          : StockRecountTokens.surface2,
      border: pos
          ? StockRecountTokens.posBorder
          : neg
          ? StockRecountTokens.negBorder
          : StockRecountTokens.line,
      labelColor: pos
          ? StockRecountTokens.posText
          : neg
          ? StockRecountTokens.negText
          : StockRecountTokens.ink3,
      valueColor: pos
          ? StockRecountTokens.posText
          : neg
          ? StockRecountTokens.negText
          : StockRecountTokens.ink3,
    );
  }
}

class _ItemsEmptyState extends StatelessWidget {
  const _ItemsEmptyState({required this.editable});

  final bool editable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  StockRecountTokens.accentTint2,
                  StockRecountTokens.accentTint,
                ],
              ),
            ),
            child: StockRecountIcons.stack(size: 38, color: StockRecountTokens.accent),
          ),
          const SizedBox(height: 22),
          Text(
            'No items yet',
            style: StockRecountHelpers.text(size: 19, weight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            editable
                ? 'Search for a product above, or scan a barcode, then enter the quantity you physically counted.'
                : 'This recount has no counted items.',
            textAlign: TextAlign.center,
            style: StockRecountHelpers.text(size: 14.5, color: StockRecountTokens.ink3),
          ),
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.editable,
    required this.stats,
    required this.submitting,
    required this.exporting,
    required this.canSubmit,
    required this.onExport,
    required this.onSubmit,
  });

  final bool editable;
  final RecountItemStats stats;
  final bool submitting;
  final bool exporting;
  final bool canSubmit;
  final VoidCallback onExport;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final hideSummary = width < StockRecountTokens.actionBarHideSummaryBreakpoint;
    final netColor = stats.net > 0
        ? StockRecountTokens.posText
        : stats.net < 0
        ? StockRecountTokens.negText
        : StockRecountTokens.ink1;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            20,
            14,
            20,
            14 + MediaQuery.paddingOf(context).bottom,
          ),
          decoration: BoxDecoration(
            color: StockRecountTokens.surface.withValues(alpha: 0.86),
            border: const Border(top: BorderSide(color: StockRecountTokens.line)),
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: StockRecountTokens.maxContentWidth),
              child: Row(
                children: [
                  if (!hideSummary)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            editable ? 'Net variance' : 'Recount total',
                            style: StockRecountHelpers.text(
                              size: 13,
                              color: StockRecountTokens.ink3,
                            ),
                          ),
                          Text(
                            '${StockRecountHelpers.formatSignedVariance(stats.net)} · ${stats.count} items',
                            style: StockRecountHelpers.text(
                              size: 15,
                              weight: FontWeight.w700,
                              color: netColor,
                              tabular: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  StockRecountGhostButton(
                    label: 'Export PDF',
                    leading: StockRecountIcons.download(
                      size: 18,
                      color: StockRecountTokens.ink1,
                    ),
                    onPressed: exporting ? null : onExport,
                    loading: exporting,
                    expanded: hideSummary,
                  ),
                  if (editable) ...[
                    const SizedBox(width: 12),
                    StockRecountPrimaryButton(
                      label: 'Submit',
                      leading: StockRecountIcons.check(size: 19, color: Colors.white),
                      enabled: canSubmit,
                      loading: submitting,
                      onPressed: onSubmit,
                      expanded: hideSummary,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfirmShortageSheet {
  static Future<String?> show(
    BuildContext context, {
    required List<StockRecountItem> items,
    required double net,
  }) {
    final controller = TextEditingController();
    return showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final bottom = MediaQuery.viewInsetsOf(ctx).bottom;
        final wide = MediaQuery.sizeOf(ctx).width >= 640;
        return Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: Align(
            alignment: wide ? Alignment.center : Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: Container(
                margin: wide ? const EdgeInsets.symmetric(horizontal: 16) : null,
                padding: EdgeInsets.fromLTRB(22, 8, 22, 24 + MediaQuery.paddingOf(ctx).bottom),
                decoration: BoxDecoration(
                  color: StockRecountTokens.surface,
                  borderRadius: wide
                      ? BorderRadius.circular(StockRecountTokens.radiusXl)
                      : const BorderRadius.vertical(
                          top: Radius.circular(StockRecountTokens.radiusXl),
                        ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x4D101828),
                      blurRadius: 60,
                      offset: Offset(0, -20),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 5,
                        margin: const EdgeInsets.only(top: 6, bottom: 14),
                        decoration: BoxDecoration(
                          color: StockRecountTokens.lineStrong,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    Text(
                      'Confirm shortages before submitting',
                      style: StockRecountHelpers.text(size: 19, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${items.length} item(s) counted lower than the system — recording this submits a net variance of ${StockRecountHelpers.formatSignedVariance(net)}. Add a reason…',
                      style: StockRecountHelpers.text(
                        size: 14,
                        color: StockRecountTokens.ink2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                          decoration: BoxDecoration(
                            color: StockRecountTokens.negTint,
                            border: Border.all(color: StockRecountTokens.negBorder),
                            borderRadius: BorderRadius.circular(StockRecountTokens.radiusMd),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.productName,
                                  style: StockRecountHelpers.text(
                                    size: 14,
                                    weight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Text(
                                StockRecountHelpers.formatSignedVariance(item.difference),
                                style: StockRecountHelpers.text(
                                  size: 13,
                                  color: StockRecountTokens.negText,
                                  weight: FontWeight.w700,
                                  tabular: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: controller,
                      maxLines: 3,
                      style: StockRecountHelpers.text(size: 14),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: StockRecountTokens.surface2,
                        hintText:
                            'Reason for shortage (e.g. damaged units, spoilage, theft)…',
                        contentPadding: const EdgeInsets.all(14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(StockRecountTokens.radiusMd),
                          borderSide: const BorderSide(color: StockRecountTokens.line, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(StockRecountTokens.radiusMd),
                          borderSide: const BorderSide(color: StockRecountTokens.accent, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: StockRecountGhostButton(
                            label: 'Keep editing',
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StockRecountPrimaryButton(
                            label: 'Confirm & submit',
                            leading: StockRecountIcons.check(size: 18, color: Colors.white),
                            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BarcodeScannerPage extends StatefulWidget {
  const _BarcodeScannerPage({required this.onDetected});

  final ValueChanged<String> onDetected;

  @override
  State<_BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<_BarcodeScannerPage> {
  bool _handled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080C16),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (_handled) return;
              final raw = capture.barcodes.firstOrNull?.rawValue;
              if (raw == null || raw.isEmpty) return;
              _handled = true;
              widget.onDetected(raw);
            },
          ),
          IgnorePointer(
            child: ColoredBox(
              color: const Color(0xB3080C16),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 260,
                  height: 170,
                  child: Stack(
                    children: [
                      Positioned(top: 0, left: 0, child: _scanCorner(topLeft: true)),
                      Positioned(top: 0, right: 0, child: _scanCorner(topRight: true)),
                      Positioned(bottom: 0, left: 0, child: _scanCorner(bottomLeft: true)),
                      Positioned(bottom: 0, right: 0, child: _scanCorner(bottomRight: true)),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Text(
                      'Point camera at barcode',
                      style: StockRecountHelpers.text(
                        size: 15,
                        weight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 48,
            child: Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.25)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(StockRecountTokens.radiusPill),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
                child: Text(
                  'Cancel',
                  style: StockRecountHelpers.text(
                    size: 14,
                    weight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scanCorner({
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        border: Border(
          top: topLeft || topRight
              ? const BorderSide(color: StockRecountTokens.accent, width: 3)
              : BorderSide.none,
          left: topLeft || bottomLeft
              ? const BorderSide(color: StockRecountTokens.accent, width: 3)
              : BorderSide.none,
          right: topRight || bottomRight
              ? const BorderSide(color: StockRecountTokens.accent, width: 3)
              : BorderSide.none,
          bottom: bottomLeft || bottomRight
              ? const BorderSide(color: StockRecountTokens.accent, width: 3)
              : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: topLeft ? const Radius.circular(18) : Radius.zero,
          topRight: topRight ? const Radius.circular(18) : Radius.zero,
          bottomLeft: bottomLeft ? const Radius.circular(18) : Radius.zero,
          bottomRight: bottomRight ? const Radius.circular(18) : Radius.zero,
        ),
      ),
    );
  }
}
