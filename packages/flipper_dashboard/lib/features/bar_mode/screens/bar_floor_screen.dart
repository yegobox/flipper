import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_shared_widgets.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/models/bar_table.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

class BarFloorScreen extends ConsumerWidget {
  const BarFloorScreen({super.key});

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
              data: (tables) => _zonesBody(context, ref, tables, tabs, staffAsync.value ?? []),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BarModeState bar, int openCount, WidgetRef ref, List<Tenant> staff) {
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
                  (context, i) => _TableCard(
                    key: ValueKey('bar-table-${zone.value[i].id}'),
                    table: zone.value[i],
                    tab: _tabFor(zone.value[i], tabs),
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
        zoneTables.where((t) => _tabFor(t, tabs) != null).length;
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

  ITransaction? _tabFor(BarTable table, List<ITransaction> tabs) {
    for (final tab in tabs) {
      if (tab.tableId == table.id) return tab;
    }
    return null;
  }

  Future<void> _openTable(WidgetRef ref, BarTable table) async {
    final branchId = ProxyService.box.getBranchId();
    final cashier = ref.read(barModeProvider).activeCashier;
    if (branchId == null || cashier == null) return;

    final sync = ProxyService.getStrategy(Strategy.capella);
    final tab = await sync.openBarTab(
      branchId: branchId,
      table: table,
      cashierTenantId: cashier.id,
      cashierName: cashier.name ?? 'Staff',
    );
    ref.read(barModeProvider.notifier).bindTable(table, tab);
  }
}

class _TableCard extends ConsumerWidget {
  const _TableCard({
    super.key,
    required this.table,
    required this.tab,
    required this.staff,
    required this.onTap,
  });

  final BarTable table;
  final ITransaction? tab;
  final List<Tenant> staff;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (tab == null) return _EmptyTableCard(table: table, onTap: onTap);
    return _OpenTableCard(
      table: table,
      tab: tab!,
      staff: staff,
      onTap: onTap,
    );
  }
}

class _EmptyTableCard extends StatefulWidget {
  const _EmptyTableCard({required this.table, required this.onTap});

  final BarTable table;
  final VoidCallback onTap;

  @override
  State<_EmptyTableCard> createState() => _EmptyTableCardState();
}

class _EmptyTableCardState extends State<_EmptyTableCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = _hovered ? BarTokens.blue : BarTokens.ink3;
    final idColor = _hovered ? BarTokens.blue : BarTokens.ink3;
    final seatColor = _hovered ? BarTokens.blue : BarTokens.ink4;

    return Material(
      color: Colors.transparent,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(BarTokens.radiusMd),
          child: BarDashedCard(
            borderColor: _hovered ? BarTokens.blue : BarTokens.lineStrong,
            backgroundColor:
                _hovered ? BarTokens.blueTint : BarTokens.surface,
            child: SizedBox(
              height: 138,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.table.name,
                          style: GoogleFonts.outfit(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.52,
                            color: idColor,
                            height: 1,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Icon(Icons.person_outline,
                                size: 13, color: seatColor),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.table.seats}',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: seatColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.add, size: 16, color: accent),
                        const SizedBox(width: 7),
                        Text(
                          'Open tab',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: accent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OpenTableCard extends ConsumerStatefulWidget {
  const _OpenTableCard({
    required this.table,
    required this.tab,
    required this.staff,
    required this.onTap,
  });

  final BarTable table;
  final ITransaction tab;
  final List<Tenant> staff;
  final VoidCallback onTap;

  @override
  ConsumerState<_OpenTableCard> createState() => _OpenTableCardState();
}

class _OpenTableCardState extends ConsumerState<_OpenTableCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final table = widget.table;
    final tab = widget.tab;
    final staff = widget.staff;
    final linesAsync = ref.watch(barTabLinesProvider(tab.id));
    final lines = linesAsync.value ?? [];
    final total = lines.isNotEmpty ? barTabTotal(lines) : (tab.subTotal ?? 0);
    final count = lines.isNotEmpty ? barTabItemCount(lines) : 0;
    final serverIds = barTabServerIds(lines);
    final opened = tab.createdAt ?? DateTime.now();
    final duration = barFormatDuration(DateTime.now().difference(opened));

    final initials = <String>[];
    final colors = <Color>[];
    for (final id in serverIds.take(3)) {
      Tenant? tenant;
      for (final t in staff) {
        if (t.id == id || t.userId == id) {
          tenant = t;
          break;
        }
      }
      final name = tenant?.name ?? 'S';
      initials.add(barTenantInitials(name));
      colors.add(barColorForTenant(id, staff));
    }

    return Material(
      color: Colors.transparent,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(BarTokens.radiusMd),
          child: BarOpenTableCardShell(
            hovered: _hovered,
            child: SizedBox(
              height: 138,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          table.name,
                          style: GoogleFonts.outfit(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.52,
                            color: BarTokens.ink1,
                            height: 1,
                          ),
                        ),
                        const Spacer(),
                        const BarOpenStatusPill(),
                      ],
                    ),
                    const Spacer(),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'RWF ',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: BarTokens.ink3,
                            ),
                          ),
                          TextSpan(
                            text: NumberFormat('#,###').format(total),
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.44,
                              color: BarTokens.ink1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              if (initials.isNotEmpty)
                                BarServerAvatarStack(
                                  initials: initials,
                                  colors: colors,
                                ),
                              if (count > 0) ...[
                                SizedBox(width: initials.isEmpty ? 0 : 8),
                                Text(
                                  '$count items',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: BarTokens.ink3,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.schedule,
                                size: 13, color: BarTokens.ink3),
                            const SizedBox(width: 5),
                            Text(
                              duration,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: BarTokens.ink3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
