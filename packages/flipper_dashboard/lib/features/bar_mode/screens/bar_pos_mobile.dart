import 'package:flipper_design_system/flipper_design_system.dart'
    show CLOSEBUTTON, CustomAppBar;
import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/bar_mode_settings.dart';
import 'package:flipper_dashboard/features/bar_mode/bar_pos_actions.dart';
import 'package:flipper_dashboard/features/bar_mode/bar_credit.dart';
import 'package:flipper_dashboard/features/bar_mode/bar_room_charge.dart';
import 'package:flipper_dashboard/features/bar_mode/bar_tab_print.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_mobile_shell.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_mobile_tab_bar.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_pos_catalog_pane.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_shared_widgets.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_tab_bottom_sheet.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    final canChargeRoom = BarRoomCharge.isAvailable(ref);
    final myLines = lines.where((l) => l.loggedByTenantId == cashier.id).length;
    final lineCount = barTabItemCount(lines);
    final serverCount = barTabServerIds(lines).length;

    final grouped = <String, List<TransactionItem>>{};
    for (final line in lines) {
      final key = line.loggedByTenantId ?? 'unknown';
      grouped.putIfAbsent(key, () => []).add(line);
    }

    final openedAt = tab.createdAt ?? DateTime.now();
    final opener = barOpenerName(lines);

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
            tableName: table.name,
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
            onQtyDelta: (line, d) => BarPosActions.changeQty(
              ref: ref,
              tab: tab,
              line: line,
              delta: d,
            ),
            onSaveToTab: () {
              showSheet.value = false;
              ref
                  .read(barModeProvider.notifier)
                  .saveToTab(autoLogout: BarModeSettings.autoLogout);
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
            onPrint: () => BarTabPrint.printTab(
              context: context,
              tab: tab,
              table: table,
              lines: lines,
            ),
            onPutOnCredit: !(isManager || !BarModeSettings.managerSettle)
                ? null
                : () {
                    showSheet.value = false;
                    BarCredit.promptAndPutOnCredit(
                      context: context,
                      ref: ref,
                      tab: tab,
                      table: table,
                      mobile: true,
                    );
                  },
            onChargeToRoom: !canChargeRoom
                ? null
                : () {
                    showSheet.value = false;
                    BarRoomCharge.promptAndChargeTab(
                      context: context,
                      ref: ref,
                      tab: tab,
                      table: table,
                      cashier: cashier,
                      mobile: true,
                    );
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
    final time = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(TimeOfDay.fromDateTime(openedAt));
    final l10n = context.flipperL10n;
    final meta = opener.isEmpty
        ? l10n.barTableMetaOpened('${table.seats}', time, elapsed)
        : l10n.barTableMetaOpenedBy(
            '${table.seats}',
            time,
            opener.split(' ').first,
            elapsed,
          );

    return CustomAppBar(
      key: const ValueKey('bar-pos-mobile-app-bar'),
      title: table.name as String,
      subtitle: '${table.zoneName} · $meta',
      closeButton: CLOSEBUTTON.ICON,
      icon: Icons.arrow_back,
      onPop: () =>
          ref.read(barModeProvider.notifier).setScreen(BarScreen.tables),
      barBackgroundColor: BarTokens.surface,
      bottomSpacer: 60,
      customTrailingWidget: const BarAppBarTrailing(
        endPadding: 8,
        child: BarOpenStatusPill(compact: true),
      ),
    );
  }
}
