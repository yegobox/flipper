import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:supabase_models/brick/models/stock_recount.model.dart';
import 'package:supabase_models/brick/models/stock_recount_item.model.dart';

import 'stock_recount_detail_screen.dart';
import 'stock_recount_helpers.dart';
import 'stock_recount_pdf.dart';
import 'stock_recount_service.dart';
import 'stock_recount_icons.dart';
import 'stock_recount_tokens.dart';
import 'stock_recount_ui.dart';

class StockRecountListScreen extends StatefulWidget {
  const StockRecountListScreen({super.key});

  @override
  State<StockRecountListScreen> createState() => _StockRecountListScreenState();
}

class _StockRecountListScreenState extends State<StockRecountListScreen> {
  static const _service = StockRecountService();

  String _filterStatus = 'all';
  final _searchController = TextEditingController();
  String _searchQuery = '';

  Stream<List<StockRecount>>? _streamCache;
  String? _streamBranchId;
  String? _streamSignature;

  final Map<String, List<StockRecountItem>> _itemsCache = {};
  final Map<String, RecountItemStats> _statsCache = {};
  String? _exportingRecountId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Stream<List<StockRecount>> _stream() {
    final branchId = ProxyService.box.getBranchId() ?? '';
    final signature = '${branchId}_$_filterStatus';
    if (_streamBranchId != branchId ||
        _streamSignature != signature ||
        _streamCache == null) {
      _streamBranchId = branchId;
      _streamSignature = signature;
      _streamCache = _service.recountsStream(status: null);
    }
    return _streamCache!;
  }

  Future<void> _refreshItemStats(List<StockRecount> recounts) async {
    for (final recount in recounts) {
      if (_itemsCache.containsKey(recount.id)) continue;
      try {
        final items = await _service.getItems(recount.id);
        if (!mounted) return;
        setState(() {
          _itemsCache[recount.id] = items;
          _statsCache[recount.id] = RecountItemStats.fromItems(items);
        });
      } catch (e, st) {
        talker.error('StockRecountList: item stats failed', e, st);
      }
    }
  }

  Future<void> _startNewRecount() async {
    try {
      final recount = await _service.startSession();
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => StockRecountActiveScreen(recountId: recount.id),
        ),
      );
    } catch (e, st) {
      talker.error('StockRecountList: start session failed', e, st);
      if (mounted) {
        showStockRecountToast(context, 'Could not start recount: $e');
      }
    }
  }

  Future<void> _deleteRecount(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete recount?'),
        content: const Text(
          'Delete this draft recount? This cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: StockRecountTokens.neg)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await _service.deleteRecount(id);
      if (mounted) showStockRecountToast(context, 'Recount deleted');
    } catch (e, st) {
      talker.error('StockRecountList: delete failed', e, st);
      if (mounted) showStockRecountToast(context, 'Delete failed: $e');
    }
  }

  Future<void> _exportPdf(StockRecount recount) async {
    if (_exportingRecountId != null) return;
    setState(() => _exportingRecountId = recount.id);
    try {
      final items =
          _itemsCache[recount.id] ?? await _service.getItems(recount.id);
      final tenant = await ProxyService.strategy.getTenant(
        userId: ProxyService.box.getUserId() ?? '',
      );
      await StockRecountPdfExport.previewAndShare(
        recount: recount,
        items: items,
        businessName: tenant?.name ?? 'Business',
        branchName: ProxyService.box.branchIdString() ?? recount.branchId,
      );
    } catch (e, st) {
      talker.error('StockRecountList: PDF export failed', e, st);
      if (mounted) showStockRecountToast(context, 'Export failed: $e');
    } finally {
      if (mounted) setState(() => _exportingRecountId = null);
    }
  }

  List<StockRecount> _filterRecounts(List<StockRecount> recounts) {
    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return recounts;
    return recounts.where((r) {
      final base =
          '${r.deviceName} ${r.notes} ${r.status}'.toLowerCase();
      if (base.contains(q)) return true;
      final items = _itemsCache[r.id];
      if (items == null) return false;
      return items.any(
        (i) => i.productName.toLowerCase().contains(q),
      );
    }).toList();
  }

  Map<String, int> _statusCounts(List<StockRecount> all) {
    return {
      'all': all.length,
      'draft': all.where((r) => r.status == 'draft').length,
      'submitted': all.where((r) => r.status == 'submitted').length,
      'synced': all.where((r) => r.status == 'synced').length,
    };
  }

  @override
  Widget build(BuildContext context) {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      return const Scaffold(
        body: Center(child: Text('No branch selected')),
      );
    }

    return StockRecountScreenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            StreamBuilder<List<StockRecount>>(
        stream: _stream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final all = snapshot.data ?? [];
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _refreshItemStats(all);
          });
          final counts = _statusCounts(all);
          final statusFiltered = _filterStatus == 'all'
              ? all
              : all.where((r) => r.status == _filterStatus).toList();
          final filtered = _filterRecounts(statusFiltered);
          final hasFilter = _filterStatus != 'all' || _searchQuery.isNotEmpty;

          return LayoutBuilder(
            builder: (context, constraints) {
              final pad = StockRecountHelpers.horizontalPadding(constraints.maxWidth);
              return Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: StockRecountTokens.maxContentWidth,
                  ),
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(pad, 20, pad, 140),
                    children: [
                      StockRecountSearchField(
                        controller: _searchController,
                        hint: 'Search device, note, or product…',
                        onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                        onClear: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      ),
                      const SizedBox(height: 14),
                      _FilterChipsRow(
                        selected: _filterStatus,
                        counts: counts,
                        onSelected: (s) => setState(() => _filterStatus = s),
                      ),
                      if (filtered.isEmpty)
                        _EmptyState(
                          hasSessions: all.isNotEmpty,
                          filtered: hasFilter,
                          onPrimary: hasFilter
                              ? () => setState(() {
                                  _filterStatus = 'all';
                                  _searchController.clear();
                                  _searchQuery = '';
                                })
                              : _startNewRecount,
                          primaryLabel: hasFilter ? 'Clear filters' : 'Start new recount',
                          ghost: hasFilter,
                        )
                      else
                        ...filtered.map((recount) {
                          final stats = _statsCache[recount.id];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _RecountListCard(
                              recount: recount,
                              stats: stats,
                              exporting: _exportingRecountId == recount.id,
                              onOpen: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => StockRecountActiveScreen(
                                    recountId: recount.id,
                                  ),
                                ),
                              ),
                              onExport: () => _exportPdf(recount),
                              onDelete: recount.status == 'draft'
                                  ? () => _deleteRecount(recount.id)
                                  : null,
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
            Align(
              alignment: Alignment.bottomRight,
              child: StockRecountFab(onPressed: _startNewRecount),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChipsRow extends StatelessWidget {
  const _FilterChipsRow({
    required this.selected,
    required this.counts,
    required this.onSelected,
  });

  final String selected;
  final Map<String, int> counts;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    const labels = {
      'all': 'All',
      'draft': 'Draft',
      'submitted': 'Submitted',
      'synced': 'Synced',
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          StockRecountIcons.filter(size: 15, color: StockRecountTokens.ink3),
          const SizedBox(width: 6),
          Text(
            'Filter',
            style: StockRecountHelpers.text(
              size: 13.5,
              weight: FontWeight.w600,
              color: StockRecountTokens.ink3,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: labels.entries.map((e) {
                  final active = selected == e.key;
                  final count = counts[e.key] ?? 0;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => onSelected(e.key),
                      borderRadius: BorderRadius.circular(StockRecountTokens.radiusPill),
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: active
                              ? StockRecountTokens.accent
                              : StockRecountTokens.surface,
                          borderRadius: BorderRadius.circular(StockRecountTokens.radiusPill),
                          border: Border.all(
                            color: active
                                ? StockRecountTokens.accent
                                : StockRecountTokens.line,
                            width: 1.5,
                          ),
                          boxShadow: active
                              ? const [StockRecountTokens.primaryButtonShadow]
                              : null,
                        ),
                        child: Row(
                          children: [
                            Text(
                              e.value,
                              style: StockRecountHelpers.text(
                                size: 13.5,
                                weight: FontWeight.w600,
                                color: active ? Colors.white : StockRecountTokens.ink2,
                              ),
                            ),
                            const SizedBox(width: 7),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: active
                                    ? Colors.white.withValues(alpha: 0.24)
                                    : StockRecountTokens.surface2,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '$count',
                                style: StockRecountHelpers.text(
                                  size: 11.5,
                                  weight: FontWeight.w700,
                                  color: active ? Colors.white : StockRecountTokens.ink3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.hasSessions,
    required this.filtered,
    required this.onPrimary,
    required this.primaryLabel,
    this.ghost = false,
  });

  final bool hasSessions;
  final bool filtered;
  final VoidCallback onPrimary;
  final String primaryLabel;
  final bool ghost;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 56),
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
            child: StockRecountIcons.archive(size: 40, color: StockRecountTokens.accent),
          ),
          const SizedBox(height: 22),
          Text(
            hasSessions ? 'Nothing matches' : 'No recounts yet',
            style: StockRecountHelpers.text(size: 19, weight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            hasSessions
                ? 'Try a different search term or filter to find the recount you’re after.'
                : 'Start a new recount session to count physical stock against your system records.',
            textAlign: TextAlign.center,
            style: StockRecountHelpers.text(
              size: 14.5,
              color: StockRecountTokens.ink3,
            ),
          ),
          const SizedBox(height: 22),
          if (ghost)
            StockRecountGhostButton(label: primaryLabel, onPressed: onPrimary)
          else
            StockRecountPrimaryButton(
              label: primaryLabel,
              leading: StockRecountIcons.plus(size: 19, color: Colors.white),
              onPressed: onPrimary,
            ),
        ],
      ),
    );
  }
}

class _RecountListCard extends StatelessWidget {
  const _RecountListCard({
    required this.recount,
    required this.stats,
    required this.onOpen,
    required this.onExport,
    this.exporting = false,
    this.onDelete,
  });

  final StockRecount recount;
  final RecountItemStats? stats;
  final VoidCallback onOpen;
  final VoidCallback onExport;
  final bool exporting;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isDraft = recount.status == 'draft';
    final name = recount.deviceName ?? 'Unknown device';
    return stockRecountCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: onOpen,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
              child: Row(
                children: [
                  StockRecountItemSwatch(
                    name: name,
                    size: 46,
                    iconName: isDraft ? 'box' : 'archive',
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 9,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              name,
                              style: StockRecountHelpers.text(
                                size: 16,
                                weight: FontWeight.w700,
                              ),
                            ),
                            StockRecountStatusBadge(status: recount.status),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            StockRecountIcons.clock(size: 13, color: StockRecountTokens.ink3),
                            const SizedBox(width: 6),
                            Text(
                              StockRecountHelpers.formatDateTime(recount.createdAt),
                              style: StockRecountHelpers.text(
                                size: 12.5,
                                color: StockRecountTokens.ink3,
                              ),
                            ),
                          ],
                        ),
                        if (recount.notes != null && recount.notes!.trim().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              recount.notes!.trim(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: StockRecountHelpers.text(
                                size: 13,
                                color: StockRecountTokens.ink2,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  StockRecountIcons.chevronRight(size: 20, color: StockRecountTokens.ink4),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(18, 11, 18, 11),
            decoration: const BoxDecoration(
              color: StockRecountTokens.surface2,
              border: Border(top: BorderSide(color: StockRecountTokens.lineSoft)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _iconPill(
                        StockRecountIcons.stack(size: 13, color: StockRecountTokens.ink2),
                        '${stats?.count ?? recount.totalItemsCounted} ${(stats?.count ?? recount.totalItemsCounted) == 1 ? 'item' : 'items'}',
                      ),
                      if (stats != null) StockRecountNetPill(net: stats!.net),
                      if (stats != null && stats!.short > 0)
                        _iconPill(
                          StockRecountIcons.arrowDown(size: 13, color: StockRecountTokens.negText),
                          '${stats!.short} short',
                          bg: StockRecountTokens.negTint,
                          border: StockRecountTokens.negBorder,
                          fg: StockRecountTokens.negText,
                        ),
                    ],
                  ),
                ),
                StockRecountExportLink(
                  onPressed: onExport,
                  loading: exporting,
                ),
                if (onDelete != null)
                  StockRecountDeleteButton(
                    onPressed: onDelete!,
                    tooltip: 'Delete draft',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconPill(
    Widget icon,
    String label, {
    Color bg = StockRecountTokens.surface,
    Color border = StockRecountTokens.line,
    Color fg = StockRecountTokens.ink2,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(StockRecountTokens.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 6),
          Text(
            label,
            style: StockRecountHelpers.text(
              size: 12.5,
              weight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
