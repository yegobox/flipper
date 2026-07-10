import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/bar_pos_actions.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_shared_widgets.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_table_cards.dart';
import 'package:flipper_models/models/bar_table.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

class BarFloorDesktopScreen extends ConsumerWidget {
  const BarFloorDesktopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bar = ref.watch(barModeProvider);
    final tablesAsync = ref.watch(barTablesProvider);
    final tabsAsync = ref.watch(barTabsProvider);
    final staffAsync = ref.watch(barStaffProvider);

    final tabs = tabsAsync.value ?? [];
    final openCount = tabs.length;

    return Container(
      color: BarTokens.posBg,
      child: Column(
        children: [
          _header(bar, openCount, ref, staffAsync.value ?? []),
          Expanded(
            child: tablesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (tables) => _zonesBody(
                context,
                ref,
                tables,
                tabs,
                staffAsync.value ?? [],
              ),
            ),
          ),
        ],
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
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: const BoxDecoration(
        color: BarTokens.surface,
        border: Border(bottom: BorderSide(color: BarTokens.line)),
      ),
      child: Row(
        children: [
          const BarFlipperBrand(),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tables',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  color: BarTokens.ink1,
                ),
              ),
              Text(
                '$openCount open · tap a table to log its order',
                style: GoogleFonts.outfit(
                  fontSize: 12.5,
                  color: BarTokens.ink3,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          _legend('Open tab', open: true),
          const SizedBox(width: 16),
          _legend('Free', open: false),
          const SizedBox(width: 4),
          if (cashier != null) ...[
            const SizedBox(width: 18),
            BarCashierChip(
              name: cashier.name ?? '',
              role: '${cashier.type ?? 'Server'} · logging',
              initials: barTenantInitials(cashier.name),
              color: barColorForTenant(cashier.id, staff),
            ),
          ],
          if (cashier != null && _isAdminOrOwner(cashier)) ...[
            const SizedBox(width: 12),
            _settingsButton(),
          ],
          const SizedBox(width: 12),
          _dangerLogout(ref),
        ],
      ),
    );
  }

  Widget _legend(String label, {required bool open}) {
    return Row(
      children: [
        Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(
            color: open ? BarTokens.blue : BarTokens.surface,
            borderRadius: BorderRadius.circular(4),
            border: open
                ? null
                : Border.all(color: BarTokens.lineStrong, width: 1.5),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: BarTokens.ink3,
          ),
        ),
      ],
    );
  }

  bool _isAdminOrOwner(Tenant tenant) {
    final type = tenant.type?.toLowerCase() ?? '';
    return type.contains('admin') || type.contains('owner');
  }

  Widget _settingsButton() {
    return Material(
      color: BarTokens.surface,
      borderRadius: BorderRadius.circular(BarTokens.radiusMd),
      child: InkWell(
        onTap: () =>
            locator<RouterService>().navigateTo(const AdminControlRoute()),
        borderRadius: BorderRadius.circular(BarTokens.radiusMd),
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BarTokens.radiusMd),
            border: Border.all(color: BarTokens.line, width: 1.5),
            boxShadow: BarTokens.shadow1,
          ),
          child: Row(
            children: [
              Icon(Icons.settings_outlined, size: 18, color: BarTokens.ink2),
              const SizedBox(width: 9),
              Text(
                'Settings',
                style: GoogleFonts.outfit(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: BarTokens.ink2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dangerLogout(WidgetRef ref) {
    return Material(
      color: BarTokens.surface,
      borderRadius: BorderRadius.circular(BarTokens.radiusMd),
      child: InkWell(
        onTap: () => ref.read(barModeProvider.notifier).logout(),
        borderRadius: BorderRadius.circular(BarTokens.radiusMd),
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BarTokens.radiusMd),
            border: Border.all(color: BarTokens.dangerBorder, width: 1.5),
            boxShadow: BarTokens.shadow1,
          ),
          child: Row(
            children: [
              Icon(Icons.logout, size: 18, color: BarTokens.lossInk),
              const SizedBox(width: 9),
              Text(
                'Logout',
                style: GoogleFonts.outfit(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: BarTokens.lossInk,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _zonesBody(
    BuildContext context,
    WidgetRef ref,
    List<BarTable> tables,
    List<ITransaction> tabs,
    List<Tenant> staff,
  ) {
    final byZone = <String, List<BarTable>>{};
    for (final t in tables) {
      byZone.putIfAbsent(t.zoneName, () => []).add(t);
    }

    const tableGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 6,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 1.12,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 24, 30, 34),
      child: CustomScrollView(
        slivers: [
          for (final zone in byZone.entries) ...[
            SliverToBoxAdapter(
              key: ValueKey('bar-zone-header-${zone.key}'),
              child: _zoneHeader(zone.key, zone.value, tabs),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 30),
              sliver: SliverGrid(
                gridDelegate: tableGridDelegate,
                delegate: SliverChildBuilderDelegate(
                  (context, i) => BarTableCard(
                    key: ValueKey('bar-table-${zone.value[i].id}'),
                    table: zone.value[i],
                    tab: barTabForTable(zone.value[i], tabs),
                    staff: staff,
                    onTap: () => _openTable(ref, zone.value[i]),
                  ),
                  childCount: zone.value.length,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _zoneHeader(
    String zoneName,
    List<BarTable> zoneTables,
    List<ITransaction> tabs,
  ) {
    final openInZone =
        zoneTables.where((t) => barTabForTable(t, tabs) != null).length;
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Text(
            zoneName,
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.15,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Container(height: 1, color: BarTokens.line)),
          const SizedBox(width: 12),
          Text(
            '$openInZone/${zoneTables.length} open',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: BarTokens.ink3,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openTable(WidgetRef ref, BarTable table) async {
    final cashier = ref.read(barModeProvider).activeCashier;
    if (cashier == null) return;
    await BarPosActions.openTable(ref: ref, table: table, cashier: cashier);
  }
}
