import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/bar_mode_settings.dart';
import 'package:flipper_dashboard/features/bar_mode/bar_pos_actions.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_pos_catalog_pane.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_shared_widgets.dart';
import 'package:flipper_models/models/bar_table.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:flipper_services/proxy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

class BarPosDesktopScreen extends HookConsumerWidget {
  const BarPosDesktopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bar = ref.watch(barModeProvider);
    final table = bar.activeTable;
    final tab = bar.activeTab;
    final cashier = bar.activeCashier;
    if (table == null || tab == null || cashier == null) {
      return const SizedBox.shrink();
    }

    final branchId = ProxyService.box.getBranchId() ?? '';
    final linesAsync = ref.watch(barTabLinesProvider(tab.id));
    final staff = ref.watch(barStaffProvider).value ?? [];
    final lines = linesAsync.value ?? [];
    final total = barTabTotal(lines);
    final isManager = barTenantIsManager(cashier);
    final myLines =
        lines.where((l) => l.loggedByTenantId == cashier.id).length;

    return Container(
      color: BarTokens.posBg,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _topBar(ref, cashier, staff),
                Expanded(
                  child: BarPosCatalogPane(
                    branchId: branchId,
                    onAdd: (v) => BarPosActions.addItem(
                      ref: ref,
                      variant: v,
                      tab: tab,
                      table: table,
                      branchId: branchId,
                      cashier: cashier,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 460,
            decoration: const BoxDecoration(
              color: BarTokens.surface,
              border: Border(left: BorderSide(color: BarTokens.line)),
            ),
            child: Column(
              children: [
                _cartHead(ref),
                BarTableHead(
                  tableBadge: table.name,
                  zoneName: table.zoneName,
                  seats: table.seats,
                  openedAt: tab.createdAt ?? DateTime.now(),
                  openedBy: barOpenerName(tab, lines).isEmpty
                      ? null
                      : barOpenerName(tab, lines),
                ),
                Expanded(child: _linesList(lines, cashier, isManager, ref, tab, table)),
                _footer(
                  ref: ref,
                  total: total,
                  lineCount: barTabItemCount(lines),
                  serverCount: barTabServerIds(lines).length,
                  myLines: myLines,
                  isManager: isManager,
                  tab: tab,
                  empty: lines.isEmpty,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(WidgetRef ref, dynamic cashier, List staff) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: BarTokens.surface,
        border: Border(bottom: BorderSide(color: BarTokens.line)),
      ),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () =>
                ref.read(barModeProvider.notifier).setScreen(BarScreen.tables),
            icon: const Icon(Icons.grid_view, size: 18),
            label: const Text('Tables'),
            style: TextButton.styleFrom(foregroundColor: BarTokens.blue),
          ),
          const Spacer(),
          Text(
            cashier.name ?? '',
            style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _cartHead(WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: BarTokens.line)),
      ),
      child: Row(
        children: [
          Material(
            color: BarTokens.surface2,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () =>
                  ref.read(barModeProvider.notifier).setScreen(BarScreen.tables),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: BarTokens.line),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.chevron_left, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      'Tables',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          Material(
            color: BarTokens.surface,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () => ref.read(barModeProvider.notifier).saveToTab(
                    autoLogout: BarModeSettings.autoLogout,
                  ),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: BarTokens.line),
                ),
                child: Row(
                  children: [
                    Icon(Icons.archive_outlined, size: 15, color: BarTokens.ink2),
                    const SizedBox(width: 8),
                    Text(
                      'Save to tab',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _linesList(
    List<TransactionItem> lines,
    dynamic cashier,
    bool isManager,
    WidgetRef ref,
    ITransaction tab,
    BarTable table,
  ) {
    if (lines.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: BarTokens.surface2,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(Icons.shopping_cart_outlined, size: 34, color: BarTokens.ink3),
            ),
            const SizedBox(height: 14),
            Text(
              'Fresh tab for ${table.name}',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap a product to add the first round',
              style: GoogleFonts.outfit(color: BarTokens.ink3, fontSize: 13.5),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: lines.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final line = lines[i];
        final editable =
            isManager || line.loggedByTenantId == cashier.id;
        return _BarCartLine(
          line: line,
          editable: editable,
          onQtyDelta: (d) => _changeQty(ref, tab, line, d),
          onDelete: () => _deleteLine(ref, tab, line),
        );
      },
    );
  }

  Future<void> _changeQty(
    WidgetRef ref,
    ITransaction tab,
    TransactionItem line,
    int delta,
  ) =>
      BarPosActions.changeQty(ref: ref, tab: tab, line: line, delta: delta);

  Future<void> _deleteLine(
    WidgetRef ref,
    ITransaction tab,
    TransactionItem line,
  ) =>
      BarPosActions.deleteLine(ref: ref, tab: tab, line: line);

  Widget _footer({
    required WidgetRef ref,
    required double total,
    required int lineCount,
    required int serverCount,
    required int myLines,
    required bool isManager,
    required ITransaction tab,
    required bool empty,
  }) {
    final footNote = serverCount > 1
        ? 'Logged by $serverCount staff · you added $myLines'
        : "You've logged $myLines line${myLines == 1 ? '' : 's'} on this tab";

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: BarTokens.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  lineCount > 0
                      ? 'Tab total · $lineCount item${lineCount == 1 ? '' : 's'}'
                      : 'Tab total',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'RWF ',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: BarTokens.ink3,
                      ),
                    ),
                    TextSpan(
                      text: NumberFormat('#,###').format(total),
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: BarTokens.blue,
                        letterSpacing: -0.48,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.people_outline, size: 14, color: BarTokens.ink3),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  footNote,
                  style: GoogleFonts.outfit(fontSize: 12, color: BarTokens.ink3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Material(
                  color: BarTokens.surface,
                  borderRadius: BorderRadius.circular(BarTokens.radiusMd),
                  child: InkWell(
                    onTap: () => ref.read(barModeProvider.notifier).logout(),
                    borderRadius: BorderRadius.circular(BarTokens.radiusMd),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(BarTokens.radiusMd),
                        border: Border.all(color: BarTokens.lineStrong, width: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => ref.read(barModeProvider.notifier).saveToTab(
                          autoLogout: BarModeSettings.autoLogout,
                        ),
                    borderRadius: BorderRadius.circular(BarTokens.radiusMd),
                    child: Ink(
                      height: 46,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(BarTokens.radiusMd),
                        gradient: BarTokens.gradBtn,
                        boxShadow: BarTokens.shadow2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Save to tab',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'RWF ${NumberFormat('#,###').format(total)}',
                            style: GoogleFonts.jetBrainsMono(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Material(
            color: BarTokens.surface,
            borderRadius: BorderRadius.circular(BarTokens.radiusMd),
            child: InkWell(
              onTap: empty
                  ? null
                  : () {
                      if (isManager || !BarModeSettings.managerSettle) {
                        ref.read(barModeProvider.notifier).goSettle();
                      } else {
                        ref.read(barModeProvider.notifier).showManagerPin();
                      }
                    },
              borderRadius: BorderRadius.circular(BarTokens.radiusMd),
              child: Container(
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(BarTokens.radiusMd),
                  border: Border.all(color: BarTokens.lineStrong, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isManager || !BarModeSettings.managerSettle
                          ? Icons.account_balance_wallet_outlined
                          : Icons.verified_user_outlined,
                      size: 17,
                      color: BarTokens.ink2,
                    ),
                    const SizedBox(width: 9),
                    Text(
                      isManager || !BarModeSettings.managerSettle
                          ? 'Settle bill & close table'
                          : 'Settle bill · manager PIN',
                      style: GoogleFonts.outfit(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarCartLine extends ConsumerStatefulWidget {
  const _BarCartLine({
    required this.line,
    required this.editable,
    required this.onQtyDelta,
    required this.onDelete,
  });

  final TransactionItem line;
  final bool editable;
  final ValueChanged<int> onQtyDelta;
  final VoidCallback onDelete;

  @override
  ConsumerState<_BarCartLine> createState() => _BarCartLineState();
}

class _BarCartLineState extends ConsumerState<_BarCartLine> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final line = widget.line;
    final staff = ref.watch(barStaffProvider).value ?? [];
    final thumbColor = barColorForName(line.name);
    final serverColor = line.loggedByTenantId == null
        ? BarTokens.blue
        : barColorForTenant(line.loggedByTenantId!, staff);
    final serverName = line.loggedByName;
    final serverInitials = barTenantInitials(serverName);

    return Opacity(
      opacity: widget.editable ? 1 : 0.96,
      child: Container(
        decoration: BoxDecoration(
          color: BarTokens.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: BarTokens.line),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: thumbColor,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Text(
                      barAbbrevForName(line.name),
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                line.name,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (serverName != null)
                              BarLineServerBadge(
                                initials: serverInitials,
                                firstName: barFirstName(serverName) ?? serverName,
                                color: serverColor,
                              ),
                          ],
                        ),
                        Text(
                          'RWF ${NumberFormat('#,###').format(line.price)} each',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                            color: BarTokens.ink3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.editable)
                    _stepper(
                      qty: line.qty.toInt(),
                      onMinus: () => widget.onQtyDelta(-1),
                      onPlus: () => widget.onQtyDelta(1),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '×${line.qty.toInt()}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Text(
                    NumberFormat('#,###').format(line.price * line.qty),
                    style: GoogleFonts.jetBrainsMono(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: widget.editable ? BarTokens.ink1 : BarTokens.ink2,
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (widget.editable)
                    IconButton(
                      onPressed: widget.onDelete,
                      icon: const Icon(Icons.delete_outline, size: 17),
                      color: BarTokens.ink3,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.verified_user_outlined, size: 16, color: BarTokens.ink4),
                    ),
                ],
              ),
            ),
            if (widget.editable)
              InkWell(
                onTap: () => setState(() => _open = !_open),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 15,
                        color: BarTokens.blue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _open ? 'Hide details' : 'Edit price & quantity',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: BarTokens.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _stepper({
    required int qty,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: BarTokens.surface2,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BarTokens.line),
      ),
      child: Row(
        children: [
          _stepBtn(Icons.remove, onMinus),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$qty',
              style: GoogleFonts.jetBrainsMono(
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
          _stepBtn(Icons.add, onPlus),
        ],
      ),
    );
  }

  Widget _stepBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 32,
        height: 32,
        child: Icon(icon, size: 15),
      ),
    );
  }
}
