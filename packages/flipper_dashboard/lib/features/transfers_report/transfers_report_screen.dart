import 'package:flipper_dashboard/features/incoming_orders/om_tokens.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/om_segmented.dart';
import 'package:flipper_dashboard/features/transfers_report/transfers_report_pdf.dart';
import 'package:flipper_dashboard/features/transfers_report/transfers_report_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

/// HQ report: transfers / stock requests to a selected destination branch.
/// Visual design matches `assets/Transfers Report (standalone).html`.
class TransfersReportScreen extends ConsumerStatefulWidget {
  const TransfersReportScreen({super.key});

  @override
  ConsumerState<TransfersReportScreen> createState() =>
      _TransfersReportScreenState();
}

class _TransfersReportScreenState extends ConsumerState<TransfersReportScreen> {
  String? _exportingId;
  bool _exportingSummary = false;
  final Set<String> _expandedIds = {};

  Future<void> _pickDateRange() async {
    final filters = ref.read(transfersReportFiltersProvider);
    final now = DateTime.now();
    final initial = DateTimeRange(
      start: filters.start ?? DateTime(now.year, now.month, 1),
      end: filters.end ?? now,
    );
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 1),
      initialDateRange: initial,
    );
    if (picked == null) return;
    ref.read(transfersReportFiltersProvider.notifier).state = filters.copyWith(
      start: DateTime(picked.start.year, picked.start.month, picked.start.day),
      end: DateTime(
        picked.end.year,
        picked.end.month,
        picked.end.day,
        23,
        59,
        59,
      ),
    );
  }

  Future<void> _exportSummary(
    List<InventoryRequest> transfers,
    String destName,
    Map<String, String> fromNames,
  ) async {
    if (_exportingSummary) return;
    setState(() => _exportingSummary = true);
    try {
      final filters = ref.read(transfersReportFiltersProvider);
      await TransfersReportPdfExport.previewAndShareSummary(
        destinationBranchName: destName,
        transfers: transfers,
        fromBranchNames: fromNames,
        rangeStart: filters.start,
        rangeEnd: filters.end,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF export failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _exportingSummary = false);
    }
  }

  Future<void> _exportOne(
    InventoryRequest transfer,
    String destName,
    String fromName,
  ) async {
    if (_exportingId != null) return;
    setState(() => _exportingId = transfer.id);
    try {
      await TransfersReportPdfExport.previewAndShareTransfer(
        transfer: transfer,
        destinationBranchName: destName,
        fromBranchName: fromName,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF export failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _exportingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(transfersReportFiltersProvider);
    final asyncTransfers = ref.watch(transfersToBranchProvider);
    final businessId = ProxyService.box.getBusinessId();
    final branchesAsync = businessId == null
        ? const AsyncValue<List<Branch>>.data([])
        : ref.watch(branchesProvider(businessId: businessId));

    final dateFmt = DateFormat('dd MMM yyyy');
    final dateTimeFmt = DateFormat('dd MMM yyyy HH:mm');

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < OmTokens.compactBreakpoint;
        final hPad = compact ? 16.0 : 32.0;
        final vPad = compact ? 20.0 : 36.0;

        return ColoredBox(
          color: OmTokens.canvas,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: OmTokens.maxContentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(hPad, vPad, hPad, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Header(
                          compact: compact,
                          exporting: _exportingSummary,
                          onExport: () {
                            final list = asyncTransfers.asData?.value;
                            if (list == null || list.isEmpty) return;
                            final destName = _destName(branchesAsync, filters);
                            final fromNames =
                                _fromNameMap(list, branchesAsync);
                            _exportSummary(list, destName, fromNames);
                          },
                          canExport: asyncTransfers.maybeWhen(
                            data: (list) => list.isNotEmpty,
                            orElse: () => false,
                          ),
                        ),
                        SizedBox(height: compact ? 16 : 20),
                        _Toolbar(
                          compact: compact,
                          filters: filters,
                          branchesAsync: branchesAsync,
                          dateLabel: filters.start != null && filters.end != null
                              ? '${dateFmt.format(filters.start!)} – ${dateFmt.format(filters.end!)}'
                              : 'All dates',
                          onPickDates: _pickDateRange,
                          onDestinationChanged: (id) {
                            ref
                                .read(transfersReportFiltersProvider.notifier)
                                .state = filters.copyWith(
                              destinationBranchId: id,
                            );
                          },
                          onStatusChanged: (status) {
                            ref
                                .read(transfersReportFiltersProvider.notifier)
                                .state = filters.copyWith(status: status);
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: asyncTransfers.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(
                        child: Text(
                          'Failed to load transfers: $e',
                          style: OmTokens.text(color: OmTokens.red),
                        ),
                      ),
                      data: (list) {
                        final destName = _destName(branchesAsync, filters);
                        return ListView(
                          padding: EdgeInsets.fromLTRB(
                            hPad,
                            compact ? 16 : 20,
                            hPad,
                            40,
                          ),
                          children: [
                            if (filters.destinationBranchId == null)
                              _EmptyState(
                                title: 'Select a destination',
                                body:
                                    'Choose a To branch to load transfers for that location.',
                              )
                            else ...[
                              Text.rich(
                                TextSpan(
                                  style: OmTokens.text(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: OmTokens.muted,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${list.length}',
                                      style: OmTokens.text(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          ' transfer${list.length == 1 ? '' : 's'} to ',
                                    ),
                                    TextSpan(
                                      text: destName,
                                      style: OmTokens.text(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (list.isEmpty)
                                const _EmptyState(
                                  title: 'No transfers',
                                  body:
                                      'No transfers match this filter for the selected date range.',
                                )
                              else ...[
                                for (var i = 0; i < list.length; i++) ...[
                                  if (i > 0) const SizedBox(height: 12),
                                  _TransferCard(
                                    transfer: list[i],
                                    destName: destName,
                                    fromName: _fromName(
                                      list[i],
                                      branchesAsync,
                                    ),
                                    dateTimeFmt: dateTimeFmt,
                                    expanded:
                                        _expandedIds.contains(list[i].id),
                                    exporting: _exportingId == list[i].id,
                                    onToggle: () {
                                      setState(() {
                                        if (_expandedIds.contains(list[i].id)) {
                                          _expandedIds.remove(list[i].id);
                                        } else {
                                          _expandedIds.add(list[i].id);
                                        }
                                      });
                                    },
                                    onExport: () => _exportOne(
                                      list[i],
                                      destName,
                                      _fromName(list[i], branchesAsync),
                                    ),
                                  ),
                                ],
                              ],
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _destName(
    AsyncValue<List<Branch>> branchesAsync,
    TransfersReportFilters filters,
  ) {
    final id = filters.destinationBranchId;
    if (id == null) return 'branch';
    final branches = branchesAsync.asData?.value ?? const <Branch>[];
    for (final b in branches) {
      if (b.id == id) return b.name ?? id;
    }
    return id;
  }

  String _fromName(
    InventoryRequest t,
    AsyncValue<List<Branch>> branchesAsync,
  ) {
    final fromId = t.mainBranchId ?? '';
    final map = _fromNameMap([t], branchesAsync);
    return map[fromId] ?? t.branch?.name ?? fromId;
  }

  Map<String, String> _fromNameMap(
    List<InventoryRequest> list,
    AsyncValue<List<Branch>> branchesAsync,
  ) {
    final branches = branchesAsync.asData?.value ?? const <Branch>[];
    final byId = {for (final b in branches) b.id: (b.name ?? b.id)};
    final out = <String, String>{};
    for (final t in list) {
      final id = t.mainBranchId;
      if (id == null) continue;
      out[id] = byId[id] ?? t.branch?.name ?? id;
    }
    return out;
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.compact,
    required this.exporting,
    required this.onExport,
    required this.canExport,
  });

  final bool compact;
  final bool exporting;
  final VoidCallback onExport;
  final bool canExport;

  @override
  Widget build(BuildContext context) {
    final title = Text(
      'Transfers report',
      style: OmTokens.text(
        fontSize: compact ? 22 : 28,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.02 * (compact ? 22 : 28),
      ),
    );
    final subtitle = Text(
      'Stock transfers received by a destination branch',
      style: OmTokens.text(
        fontSize: 14.5,
        color: OmTokens.muted,
      ),
    );
    final exportBtn = _PrimaryBtn(
      onPressed: canExport && !exporting ? onExport : null,
      icon: exporting
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.picture_as_pdf_outlined, size: 18),
      label: 'Export PDF',
    );

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          title,
          const SizedBox(height: 6),
          subtitle,
          const SizedBox(height: 12),
          exportBtn,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              const SizedBox(height: 6),
              subtitle,
            ],
          ),
        ),
        const SizedBox(width: 24),
        exportBtn,
      ],
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.compact,
    required this.filters,
    required this.branchesAsync,
    required this.dateLabel,
    required this.onPickDates,
    required this.onDestinationChanged,
    required this.onStatusChanged,
  });

  final bool compact;
  final TransfersReportFilters filters;
  final AsyncValue<List<Branch>> branchesAsync;
  final String dateLabel;
  final VoidCallback onPickDates;
  final ValueChanged<String?> onDestinationChanged;
  final ValueChanged<String> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final branchField = branchesAsync.when(
      loading: () => const SizedBox(
        height: 46,
        child: Center(child: LinearProgressIndicator()),
      ),
      error: (_, __) => Text(
        'Failed to load branches',
        style: OmTokens.text(color: OmTokens.red),
      ),
      data: (branches) {
        final value = branches.any((b) => b.id == filters.destinationBranchId)
            ? filters.destinationBranchId
            : null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'To branch',
              style: OmTokens.text(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: OmTokens.ink2,
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: value,
              isExpanded: true,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 12,
                ),
                filled: true,
                fillColor: OmTokens.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(OmTokens.radiusSm),
                  borderSide: const BorderSide(color: OmTokens.line2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(OmTokens.radiusSm),
                  borderSide: const BorderSide(color: OmTokens.line2),
                ),
              ),
              style: OmTokens.text(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
              ),
              items: branches
                  .map(
                    (b) => DropdownMenuItem(
                      value: b.id,
                      child: Text(
                        b.name ?? b.id,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onDestinationChanged,
            ),
          ],
        );
      },
    );

    final dateBtn = Material(
      color: OmTokens.surface,
      borderRadius: BorderRadius.circular(OmTokens.radiusSm),
      child: InkWell(
        onTap: onPickDates,
        borderRadius: BorderRadius.circular(OmTokens.radiusSm),
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(OmTokens.radiusSm),
            border: Border.all(color: OmTokens.line2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 17,
                color: OmTokens.accent,
              ),
              const SizedBox(width: 10),
              Text(
                dateLabel,
                style: OmTokens.text(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: OmTokens.accentStrong,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final statusSeg = OmSegmented<String>(
      value: filters.status,
      onChanged: onStatusChanged,
      options: const [
        OmSegOption(
          value: 'all',
          label: 'All',
          icon: Icons.list_alt,
        ),
        OmSegOption(
          value: RequestStatus.approved,
          label: 'Approved',
          icon: Icons.check_circle_outline,
        ),
        OmSegOption(
          value: RequestStatus.pending,
          label: 'Pending',
          icon: Icons.schedule,
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: OmTokens.surface,
        borderRadius: BorderRadius.circular(OmTokens.radiusLg),
        border: Border.all(color: OmTokens.line),
        boxShadow: OmTokens.shadowSm,
      ),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                branchField,
                const SizedBox(height: 14),
                dateBtn,
                const SizedBox(height: 14),
                statusSeg,
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(width: 220, child: branchField),
                const SizedBox(width: 14),
                dateBtn,
                const Spacer(),
                statusSeg,
              ],
            ),
    );
  }
}

class _TransferCard extends StatelessWidget {
  const _TransferCard({
    required this.transfer,
    required this.destName,
    required this.fromName,
    required this.dateTimeFmt,
    required this.expanded,
    required this.exporting,
    required this.onToggle,
    required this.onExport,
  });

  final InventoryRequest transfer;
  final String destName;
  final String fromName;
  final DateFormat dateTimeFmt;
  final bool expanded;
  final bool exporting;
  final VoidCallback onToggle;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final status = transfer.status ?? RequestStatus.pending;
    final approved = status == RequestStatus.approved;
    final stamp = transfer.approvedAt ?? transfer.createdAt;
    final when = stamp != null ? dateTimeFmt.format(stamp.toLocal()) : '—';
    final short = transfer.id.length > 8
        ? transfer.id.substring(0, 8).toUpperCase()
        : transfer.id.toUpperCase();
    final items = transfer.transactionItems ?? const <TransactionItem>[];
    final totalQty = items.isEmpty
        ? (transfer.itemCounts?.toInt() ?? 0)
        : items.fold<int>(0, (sum, line) {
            final q = line.quantityApproved ??
                line.quantityRequested ??
                line.qty.round();
            return sum + q;
          });

    return Container(
      decoration: BoxDecoration(
        color: OmTokens.surface,
        borderRadius: BorderRadius.circular(OmTokens.radiusLg),
        border: Border.all(color: OmTokens.line),
        boxShadow: OmTokens.shadowSm,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: OmTokens.accentWash,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.inventory_2_outlined,
                        size: 19,
                        color: OmTokens.accentStrong,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            short,
                            style: OmTokens.text(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.01 * 15,
                            ).copyWith(
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  fromName,
                                  style: OmTokens.text(
                                    fontSize: 13.5,
                                    color: OmTokens.ink2,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Icon(
                                  Icons.arrow_forward,
                                  size: 14,
                                  color: OmTokens.faint,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  destName,
                                  style: OmTokens.text(
                                    fontSize: 13.5,
                                    color: OmTokens.ink2,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            when,
                            style: OmTokens.text(
                              fontSize: 12.5,
                              color: OmTokens.muted,
                            ).copyWith(
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _StatusBadge(status: status),
                        _QtyPill(
                          label:
                              '$totalQty item${totalQty == 1 ? '' : 's'}',
                        ),
                        _IconSquareBtn(
                          icon: Icons.picture_as_pdf_outlined,
                          onPressed: exporting ? null : onExport,
                          loading: exporting,
                        ),
                        _ExpandBtn(expanded: expanded, onTap: onToggle),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (expanded)
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: OmTokens.line)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FlowStrip(fromName: fromName, toName: destName),
                  const SizedBox(height: 18),
                  Text(
                    'ITEMS',
                    style: OmTokens.text(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: OmTokens.muted,
                      letterSpacing: 0.05 * 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (items.isEmpty)
                    Text(
                      'No line items embedded',
                      style: OmTokens.text(color: OmTokens.muted),
                    )
                  else
                    Column(
                      children: [
                        for (var i = 0; i < items.length; i++) ...[
                          if (i > 0) const SizedBox(height: 8),
                          _ItemRow(item: items[i]),
                        ],
                      ],
                    ),
                  const SizedBox(height: 18),
                  Text(
                    'STATUS & DELIVERY',
                    style: OmTokens.text(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: OmTokens.muted,
                      letterSpacing: 0.05 * 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  LayoutBuilder(
                    builder: (context, c) {
                      final tiles = [
                        _MetaTile(
                          icon: Icons.more_horiz,
                          iconBg: approved
                              ? OmTokens.greenWash
                              : OmTokens.amberWash,
                          iconColor: approved
                              ? OmTokens.greenStrong
                              : OmTokens.amber,
                          label: 'Status',
                          value: status.toUpperCase(),
                          valueColor: approved
                              ? OmTokens.greenStrong
                              : OmTokens.amber,
                        ),
                        _MetaTile(
                          icon: Icons.calendar_today_outlined,
                          iconBg: OmTokens.dateWash,
                          iconColor: OmTokens.dateIcon,
                          label: 'Received on',
                          value: when,
                          valueColor: OmTokens.ink,
                        ),
                      ];
                      if (c.maxWidth >= 400) {
                        return Row(
                          children: [
                            Expanded(child: tiles[0]),
                            const SizedBox(width: 10),
                            Expanded(child: tiles[1]),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          tiles[0],
                          const SizedBox(height: 10),
                          tiles[1],
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: OmTokens.line),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, c) {
                      final stretch =
                          c.maxWidth < OmTokens.compactBreakpoint;
                      final buttons = [
                        _GhostBtn(
                          icon: Icons.picture_as_pdf_outlined,
                          label: 'View PDF',
                          onPressed: exporting ? null : onExport,
                        ),
                        _GhostBtn(
                          icon: Icons.download_outlined,
                          label: 'Download',
                          onPressed: exporting ? null : onExport,
                        ),
                      ];
                      if (stretch) {
                        return Row(
                          children: [
                            Expanded(child: buttons[0]),
                            const SizedBox(width: 10),
                            Expanded(child: buttons[1]),
                          ],
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          buttons[0],
                          const SizedBox(width: 10),
                          buttons[1],
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _FlowStrip extends StatelessWidget {
  const _FlowStrip({required this.fromName, required this.toName});

  final String fromName;
  final String toName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: OmTokens.surface2,
        borderRadius: BorderRadius.circular(OmTokens.radius),
        border: Border.all(color: OmTokens.line),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: OmTokens.surface,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: OmTokens.line2),
            ),
            child: const Icon(
              Icons.swap_horiz,
              size: 17,
              color: OmTokens.accentStrong,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    style: OmTokens.text(fontSize: 14, color: OmTokens.ink2),
                    children: [
                      const TextSpan(text: 'From: '),
                      TextSpan(
                        text: fromName,
                        style: OmTokens.text(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: OmTokens.greenStrong,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    style: OmTokens.text(fontSize: 14, color: OmTokens.ink2),
                    children: [
                      const TextSpan(text: 'To: '),
                      TextSpan(
                        text: toName,
                        style: OmTokens.text(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: OmTokens.accentStrong,
                        ),
                      ),
                    ],
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

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});

  final TransactionItem item;

  @override
  Widget build(BuildContext context) {
    final qty =
        item.quantityApproved ?? item.quantityRequested ?? item.qty.round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: OmTokens.surface2,
        borderRadius: BorderRadius.circular(OmTokens.radiusSm),
        border: Border.all(color: OmTokens.line),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.name,
              style: OmTokens.text(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            'Qty: $qty',
            style: OmTokens.text(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: OmTokens.ink2,
            ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
          ),
        ],
      ),
    );
  }
}

class _MetaTile extends StatelessWidget {
  const _MetaTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: OmTokens.surface,
        borderRadius: BorderRadius.circular(OmTokens.radiusSm),
        border: Border.all(color: OmTokens.line),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 17, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: OmTokens.text(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: OmTokens.muted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: OmTokens.text(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: valueColor,
                  ).copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
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

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final approved = status == RequestStatus.approved;
    final bg = approved ? OmTokens.greenWash : OmTokens.amberWash;
    final fg = approved ? OmTokens.greenStrong : OmTokens.amber;
    final dot = approved ? OmTokens.green : OmTokens.amberDot;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            status.isEmpty ? '—' : status,
            style: OmTokens.text(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyPill extends StatelessWidget {
  const _QtyPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: OmTokens.greenWash,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: OmTokens.text(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: OmTokens.greenStrong,
        ),
      ),
    );
  }
}

class _IconSquareBtn extends StatelessWidget {
  const _IconSquareBtn({
    required this.icon,
    required this.onPressed,
    this.loading = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: OmTokens.surface,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: OmTokens.line2),
          ),
          child: loading
              ? const Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(icon, size: 17, color: OmTokens.ink2),
        ),
      ),
    );
  }
}

class _ExpandBtn extends StatelessWidget {
  const _ExpandBtn({required this.expanded, required this.onTap});

  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: expanded ? OmTokens.accentWash : OmTokens.surface,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: expanded ? Colors.transparent : OmTokens.line2,
            ),
          ),
          child: AnimatedRotation(
            turns: expanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 180),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: expanded ? OmTokens.accentStrong : OmTokens.ink2,
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryBtn extends StatelessWidget {
  const _PrimaryBtn({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Material(
      color: enabled ? OmTokens.accent : OmTokens.surface3,
      borderRadius: BorderRadius.circular(OmTokens.radiusSm),
      elevation: enabled ? 1 : 0,
      shadowColor: OmTokens.accent.withValues(alpha: 0.3),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(OmTokens.radiusSm),
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconTheme(
                data: IconThemeData(
                  color: enabled ? Colors.white : OmTokens.faint,
                  size: 18,
                ),
                child: icon,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: OmTokens.text(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: enabled ? Colors.white : OmTokens.faint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GhostBtn extends StatelessWidget {
  const _GhostBtn({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: OmTokens.surface,
      borderRadius: BorderRadius.circular(OmTokens.radiusSm),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(OmTokens.radiusSm),
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(OmTokens.radiusSm),
            border: Border.all(color: OmTokens.line2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: OmTokens.ink2),
              const SizedBox(width: 8),
              Text(
                label,
                style: OmTokens.text(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: OmTokens.ink2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 54),
      decoration: BoxDecoration(
        color: OmTokens.surface2,
        borderRadius: BorderRadius.circular(OmTokens.radiusLg),
        border: Border.all(color: OmTokens.line2, width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: OmTokens.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: OmTokens.line),
            ),
            child: const Icon(
              Icons.move_to_inbox_outlined,
              size: 28,
              color: OmTokens.faint,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: OmTokens.text(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            textAlign: TextAlign.center,
            style: OmTokens.text(fontSize: 14, color: OmTokens.muted),
          ),
        ],
      ),
    );
  }
}
