import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/bar_pos_actions.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_mobile_shell.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_shared_widgets.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_table_cards.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_zone_tab_bar.dart';
import 'package:flipper_models/models/bar_table.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

class BarFloorMobileScreen extends ConsumerStatefulWidget {
  const BarFloorMobileScreen({super.key});

  @override
  ConsumerState<BarFloorMobileScreen> createState() =>
      _BarFloorMobileScreenState();
}

class _BarFloorMobileScreenState extends ConsumerState<BarFloorMobileScreen> {
  String? _selectedZone;

  @override
  Widget build(BuildContext context) {
    final bar = ref.watch(barModeProvider);
    final tablesAsync = ref.watch(barTablesProvider);
    final tabsAsync = ref.watch(barTabsProvider);
    final staffAsync = ref.watch(barStaffProvider);
    final tabs = tabsAsync.value ?? [];
    final openCount = tabs.length;
    final staff = staffAsync.value ?? [];

    return BarMobileShell(
      header: _header(bar, openCount, ref, staff),
      body: tablesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (tables) => _body(tables, tabs, staff, ref),
      ),
    );
  }

  Widget _header(
    BarModeState bar,
    int openCount,
    WidgetRef ref,
    List<Tenant> staff,
  ) {
    final cashier = bar.activeCashier;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          decoration: const BoxDecoration(
            color: BarTokens.surface,
            border: Border(bottom: BorderSide(color: BarTokens.line)),
          ),
          child: Row(
            children: [
              const BarFlipperBrand(),
              const Spacer(),
              if (cashier != null)
                BarCashierChip(
                  name: cashier.name ?? '',
                  role: '${cashier.type ?? 'Server'} · logging',
                  initials: barTenantInitials(cashier.name),
                  color: barColorForTenant(cashier.id, staff),
                ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => ref.read(barModeProvider.notifier).logout(),
                icon: const Icon(Icons.logout, color: BarTokens.lossInk),
                style: IconButton.styleFrom(
                  backgroundColor: BarTokens.surface,
                  side: const BorderSide(color: BarTokens.dangerBorder),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tables',
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),
              Text(
                '$openCount open · tap to log an order',
                style: GoogleFonts.outfit(
                  fontSize: 12.5,
                  color: BarTokens.ink3,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _body(
    List<BarTable> tables,
    List<ITransaction> tabs,
    List<Tenant> staff,
    WidgetRef ref,
  ) {
    final byZone = <String, List<BarTable>>{};
    for (final t in tables) {
      byZone.putIfAbsent(t.zoneName, () => []).add(t);
    }
    final zones = byZone.keys.toList();
    if (zones.isEmpty) {
      return const Center(child: Text('No tables configured'));
    }

    final selected = _selectedZone ?? zones.first;
    if (!zones.contains(selected)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedZone = zones.first);
      });
    }

    final openCounts = <String, int>{};
    for (final zone in zones) {
      openCounts[zone] = byZone[zone]!
          .where((t) => barTabForTable(t, tabs) != null)
          .length;
    }

    final zoneTables = byZone[selected] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BarZoneTabBar(
          zones: zones,
          selectedZone: selected,
          openCounts: openCounts,
          onSelect: (z) => setState(() => _selectedZone = z),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.05,
            ),
            itemCount: zoneTables.length,
            itemBuilder: (context, i) {
              final table = zoneTables[i];
              return BarTableCard(
                key: ValueKey('bar-m-table-${table.id}'),
                table: table,
                tab: barTabForTable(table, tabs),
                staff: staff,
                compact: true,
                onTap: () => _openTable(ref, table),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _openTable(WidgetRef ref, BarTable table) async {
    final cashier = ref.read(barModeProvider).activeCashier;
    if (cashier == null) return;
    await BarPosActions.openTable(ref: ref, table: table, cashier: cashier);
  }
}
