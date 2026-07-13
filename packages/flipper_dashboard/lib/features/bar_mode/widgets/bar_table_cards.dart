import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_shared_widgets.dart';
import 'package:flipper_models/models/bar_table.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

ITransaction? barTabForTable(BarTable table, List<ITransaction> tabs) {
  for (final tab in tabs) {
    if (tab.tableId == table.id) return tab;
  }
  return null;
}

class BarTableCard extends ConsumerWidget {
  const BarTableCard({
    super.key,
    required this.table,
    required this.tab,
    required this.staff,
    required this.onTap,
    this.compact = false,
  });

  final BarTable table;
  final ITransaction? tab;
  final List<Tenant> staff;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (tab == null) {
      return BarEmptyTableCard(table: table, onTap: onTap, compact: compact);
    }
    return BarOpenTableCard(
      table: table,
      tab: tab!,
      staff: staff,
      onTap: onTap,
      compact: compact,
    );
  }
}

class BarEmptyTableCard extends StatefulWidget {
  const BarEmptyTableCard({
    super.key,
    required this.table,
    required this.onTap,
    this.compact = false,
  });

  final BarTable table;
  final VoidCallback onTap;
  final bool compact;

  @override
  State<BarEmptyTableCard> createState() => _BarEmptyTableCardState();
}

class _BarEmptyTableCardState extends State<BarEmptyTableCard> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final accent = _hovered || _pressed ? BarTokens.blue : BarTokens.ink3;
    final idColor = _hovered || _pressed ? BarTokens.blue : BarTokens.ink3;
    final seatColor = _hovered || _pressed ? BarTokens.blue : BarTokens.ink4;
    final idSize = widget.compact ? 24.0 : 26.0;
    final minHeight =
        widget.compact ? BarTokens.mobileTableCardMinHeight : 138.0;
    final radius = widget.compact ? 18.0 : BarTokens.radiusMd;

    Widget card = BarDashedCard(
      borderColor: _hovered || _pressed ? BarTokens.blue : BarTokens.lineStrong,
      backgroundColor:
          _hovered || _pressed ? BarTokens.blueTint : BarTokens.surface,
      child: SizedBox(
        height: minHeight,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            widget.compact ? 14 : 16,
            widget.compact ? 14 : 16,
            widget.compact ? 14 : 16,
            widget.compact ? 12 : 14,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.table.name,
                    style: GoogleFonts.outfit(
                      fontSize: idSize,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.52,
                      color: idColor,
                      height: 1,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 13, color: seatColor),
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
                      fontSize: widget.compact ? 13 : 13,
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
    );

    if (widget.compact) {
      return Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _pressed ? 0.98 : 1,
            duration: const Duration(milliseconds: 100),
            child: card,
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(radius),
          child: card,
        ),
      ),
    );
  }
}

class BarOpenTableCard extends ConsumerStatefulWidget {
  const BarOpenTableCard({
    super.key,
    required this.table,
    required this.tab,
    required this.staff,
    required this.onTap,
    this.compact = false,
  });

  final BarTable table;
  final ITransaction tab;
  final List<Tenant> staff;
  final VoidCallback onTap;
  final bool compact;

  @override
  ConsumerState<BarOpenTableCard> createState() => _BarOpenTableCardState();
}

class _BarOpenTableCardState extends ConsumerState<BarOpenTableCard> {
  bool _hovered = false;
  bool _pressed = false;

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

    final idSize = widget.compact ? 24.0 : 26.0;
    final minHeight =
        widget.compact ? BarTokens.mobileTableCardMinHeight : 138.0;
    final radius = widget.compact ? 18.0 : BarTokens.radiusMd;
    final priceSize = widget.compact ? 19.0 : 22.0;

    Widget shell = BarOpenTableCardShell(
      hovered: _hovered,
      child: SizedBox(
        height: minHeight,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            widget.compact ? 14 : 16,
            widget.compact ? 14 : 16,
            widget.compact ? 14 : 16,
            widget.compact ? 12 : 14,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    table.name,
                    style: GoogleFonts.outfit(
                      fontSize: idSize,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.52,
                      color: BarTokens.ink1,
                      height: 1,
                    ),
                  ),
                  const Spacer(),
                  BarOpenStatusPill(compact: widget.compact),
                ],
              ),
              const Spacer(),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'RWF ',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: widget.compact ? 10.5 : 12,
                        fontWeight: FontWeight.w700,
                        color: BarTokens.ink3,
                      ),
                    ),
                    TextSpan(
                      text: NumberFormat('#,###').format(total),
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: priceSize,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.44,
                        color: BarTokens.ink1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: widget.compact ? 8 : 9),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        if (initials.isNotEmpty)
                          BarServerAvatarStack(
                            initials: initials,
                            colors: colors,
                            size: widget.compact ? 22 : 24,
                          ),
                        if (count > 0) ...[
                          SizedBox(width: initials.isEmpty ? 0 : 8),
                          Text(
                            '$count items',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: widget.compact ? 10.5 : 11.5,
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
                      Icon(Icons.schedule, size: 13, color: BarTokens.ink3),
                      const SizedBox(width: 5),
                      Text(
                        duration,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: widget.compact ? 10.5 : 11.5,
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
    );

    if (widget.compact) {
      return Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _pressed ? 0.98 : 1,
            duration: const Duration(milliseconds: 100),
            child: shell,
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(radius),
          child: shell,
        ),
      ),
    );
  }
}
