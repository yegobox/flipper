import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/bar_mode_settings.dart';
import 'package:flipper_dashboard/features/bar_mode/bar_pos_actions.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_mobile_shell.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_mobile_tab_bar.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_pos_catalog_pane.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_shared_widgets.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_tab_bottom_sheet.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

class BarPosMobileScreen extends HookConsumerWidget {
  const BarPosMobileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bar = ref.watch(barModeProvider);
    final table = bar.activeTable;
    final tab = bar.activeTab;
    final cashier = bar.activeCashier;
    if (table == null || tab == null || cashier == null) {
      return const SizedBox.shrink();
    }

    final showSheet = useState(false);
    final branchId = ProxyService.box.getBranchId() ?? '';
    final linesAsync = ref.watch(barTabLinesProvider(tab.id));
    final staff = ref.watch(barStaffProvider).value ?? [];
    final lines = linesAsync.value ?? [];
    final total = barTabTotal(lines);
    final isManager = barTenantIsManager(cashier);
    final myLines =
        lines.where((l) => l.loggedByTenantId == cashier.id).length;
    final lineCount = barTabItemCount(lines);
    final serverCount = barTabServerIds(lines).length;

    final grouped = <String, List<TransactionItem>>{};
    for (final line in lines) {
      final key = line.loggedByTenantId ?? 'unknown';
      grouped.putIfAbsent(key, () => []).add(line);
    }

    final openedAt = tab.createdAt ?? DateTime.now();
    final opener = barOpenerName(tab, lines);

    return Stack(
      children: [
        BarMobileShell(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _posHeader(
                context: context,
                ref: ref,
                table: table,
                tab: tab,
                openedAt: openedAt,
                opener: opener,
              ),
              Expanded(
                child: BarPosCatalogPane(
                  branchId: branchId,
                  forceTwoColumns: true,
                  horizontalPadding: 16,
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
          footer: BarMobileTabBar(
            lineCount: lineCount,
            total: total,
            empty: lines.isEmpty,
            onTap: () => showSheet.value = true,
          ),
        ),
        if (showSheet.value)
          BarTabBottomSheet(
            tableBadge: table.name,
            zoneName: table.zoneName,
            lines: lines,
            grouped: grouped,
            staff: staff,
            cashier: cashier,
            isManager: isManager,
            total: total,
            lineCount: lineCount,
            serverCount: serverCount,
            myLines: myLines,
            onClose: () => showSheet.value = false,
            onQtyDelta: (line, d) =>
                BarPosActions.changeQty(ref: ref, tab: tab, line: line, delta: d),
            onSaveToTab: () {
              showSheet.value = false;
              ref.read(barModeProvider.notifier).saveToTab(
                    autoLogout: BarModeSettings.autoLogout,
                  );
            },
            onBackToTables: () {
              showSheet.value = false;
              ref.read(barModeProvider.notifier).setScreen(BarScreen.tables);
            },
            onSettle: () {
              showSheet.value = false;
              if (isManager || !BarModeSettings.managerSettle) {
                ref.read(barModeProvider.notifier).goSettle();
              } else {
                ref.read(barModeProvider.notifier).showManagerPin();
              }
            },
          ),
      ],
    );
  }

  Widget _posHeader({
    required BuildContext context,
    required WidgetRef ref,
    required dynamic table,
    required dynamic tab,
    required DateTime openedAt,
    required String opener,
  }) {
    final elapsed = barFormatDuration(DateTime.now().difference(openedAt));
    final time = MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(openedAt),
    );
    final openerBit = opener.isEmpty ? '' : ' by ${opener.split(' ').first}';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 10),
      decoration: const BoxDecoration(
        color: BarTokens.surface,
        border: Border(bottom: BorderSide(color: BarTokens.line)),
      ),
      child: Row(
        children: [
          Material(
            color: BarTokens.surface,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () =>
                  ref.read(barModeProvider.notifier).setScreen(BarScreen.tables),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: BarTokens.line),
                ),
                child: const Icon(Icons.chevron_left, size: 22),
              ),
            ),
          ),
          const SizedBox(width: 11),
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: BarTokens.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              table.name,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        table.zoneName,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 7),
                    const BarOpenStatusPill(compact: true),
                  ],
                ),
                Text(
                  '${table.seats} seats · opened $time$openerBit · $elapsed',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: BarTokens.ink3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
