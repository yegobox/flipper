import 'package:flipper_design_system/flipper_design_system.dart'
    show showFlipperDatePicker;
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../theme/pos_tokens.dart';
import '../providers/production_output_derived_providers.dart';

/// Below this width the strip stacks its controls over the seven days.
const double _kStackedBelow = 600;

/// Picks the day the Production Output screen shows: the week around it, each
/// day with how many orders are due, arrows that step one day and a calendar
/// for any other date.
class ProductionDayBar extends ConsumerWidget {
  const ProductionDayBar({super.key});

  /// The picker's range. The arrows and the week stop at the same days, so the
  /// picker is never opened on a day outside it.
  static final firstDay = DateTime(2020);
  static DateTime lastDay(DateTime today) => shiftDay(today, 365);

  /// The first day of [day]'s week, following the locale's week start.
  static DateTime weekStart(DateTime day, int firstDayOfWeekIndex) {
    // DateTime.weekday is 1 (Mon) … 7 (Sun); the locale index is 0 = Sunday.
    final offset = (day.weekday % 7 - firstDayOfWeekIndex + 7) % 7;
    return shiftDay(day, -offset);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(productionDayProvider);
    final counts = ref.watch(productionDayCountsProvider);
    final today = localDay(DateTime.now());
    final lastDay = ProductionDayBar.lastDay(today);
    final l10n = context.flipperL10n;
    final loc = MaterialLocalizations.of(context);

    void setDay(DateTime value) =>
        ref.read(productionDayProvider.notifier).state = localDay(value);

    final start = weekStart(day, loc.firstDayOfWeekIndex);
    final week = [for (var i = 0; i < 7; i++) shiftDay(start, i)];
    final label = day == today
        ? l10n.productionOutputToday
        : loc.formatMediumDate(day);

    final previous = _StepButton(
      icon: Icons.chevron_left_rounded,
      tooltip: l10n.productionOutputPreviousDay,
      onPressed: day.isAfter(firstDay) ? () => setDay(shiftDay(day, -1)) : null,
    );
    final next = _StepButton(
      icon: Icons.chevron_right_rounded,
      tooltip: l10n.productionOutputNextDay,
      onPressed: day.isBefore(lastDay) ? () => setDay(shiftDay(day, 1)) : null,
    );
    final calendar = Builder(
      builder: (anchor) => TextButton.icon(
        key: const ValueKey('production-day-calendar'),
        style: TextButton.styleFrom(
          foregroundColor: PosTokens.ink1,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          minimumSize: const Size(0, PosTokens.controlHeightSm),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PosTokens.radiusMd),
          ),
        ),
        icon: const Icon(
          Icons.calendar_today,
          size: PosTokens.iconSm,
          color: PosTokens.ink2,
        ),
        label: Text(label, style: PosTokens.bodyStrong),
        onPressed: () async {
          final picked = await showFlipperDatePicker(
            context: anchor,
            anchorContext: anchor,
            // In range: only the arrows, the week and this picker set the day.
            initialDate: day,
            firstDate: firstDay,
            lastDate: lastDay,
          );
          if (picked != null) setDay(picked);
        },
      ),
    );
    final backToToday = day == today
        ? null
        : TextButton(
            style: TextButton.styleFrom(
              foregroundColor: PosTokens.blue,
              minimumSize: const Size(0, PosTokens.controlHeightSm),
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            onPressed: () => setDay(today),
            child: Text(l10n.productionOutputToday),
          );

    List<Widget> cells({required bool expand}) => [
      for (final d in week)
        _wrap(
          expand,
          _DayCell(
            date: d,
            count: counts[d] ?? 0,
            selected: d == day,
            isToday: d == today,
            enabled: !d.isBefore(firstDay) && !d.isAfter(lastDay),
            onTap: () => setDay(d),
          ),
        ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _kStackedBelow) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Flexible(child: calendar),
                  const Spacer(),
                  ?backToToday,
                  previous,
                  next,
                ],
              ),
              const SizedBox(height: 6),
              Row(children: cells(expand: true)),
            ],
          );
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            previous,
            ...cells(expand: false),
            next,
            const SizedBox(width: 8),
            calendar,
            if (backToToday != null) ...[const SizedBox(width: 2), backToToday],
          ],
        );
      },
    );
  }

  static Widget _wrap(bool expand, Widget child) =>
      expand ? Expanded(child: child) : SizedBox(width: 54, child: child);
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: PosTokens.iconMd),
      tooltip: tooltip,
      onPressed: onPressed,
      color: PosTokens.ink2,
      disabledColor: PosTokens.ink4,
      constraints: const BoxConstraints.tightFor(
        width: PosTokens.controlHeightSm,
        height: PosTokens.controlHeightSm,
      ),
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PosTokens.radiusMd),
        ),
      ),
    );
  }
}

/// One day of the week: short weekday, date and its due-order count.
class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.count,
    required this.selected,
    required this.isToday,
    required this.enabled,
    required this.onTap,
  });

  final DateTime date;
  final int count;
  final bool selected;
  final bool isToday;
  final bool enabled;
  final VoidCallback onTap;

  static String _weekday(BuildContext context, DateTime date) {
    try {
      return DateFormat.E(
        Localizations.localeOf(context).toLanguageTag(),
      ).format(date);
    } catch (_) {
      // No intl data for the locale (rw): the one-letter Material name.
      final loc = MaterialLocalizations.of(context);
      return loc.narrowWeekdays[date.weekday % 7];
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = MaterialLocalizations.of(context);
    final l10n = context.flipperL10n;
    final radius = BorderRadius.circular(PosTokens.radiusLg);
    final Color ink = selected
        ? Colors.white
        : !enabled
        ? PosTokens.ink4
        : isToday
        ? PosTokens.blue
        : PosTokens.ink1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Semantics(
        button: true,
        selected: selected,
        label:
            '${loc.formatFullDate(date)}, '
            '${l10n.productionOutputItemsCount(count)}',
        excludeSemantics: true,
        child: Material(
          color: selected ? PosTokens.blue : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: isToday && !selected
                ? const BorderSide(color: PosTokens.blue, width: 1.2)
                : BorderSide.none,
          ),
          child: InkWell(
            key: ValueKey(
              'production-day-${date.year}-${date.month}-${date.day}',
            ),
            borderRadius: radius,
            onTap: enabled ? onTap : null,
            hoverColor: PosTokens.blueTint,
            child: SizedBox(
              height: 58,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weekday(context, date),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? Colors.white.withValues(alpha: 0.85)
                          : PosTokens.ink3,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    loc.formatDecimal(date.day),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  _CountBadge(count: count, selected: selected),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count, required this.selected});

  final int count;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      // Same height as a badge, so the row never jumps.
      return const SizedBox(height: 14);
    }
    return Container(
      height: 14,
      constraints: const BoxConstraints(minWidth: 18),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: selected ? Colors.white : PosTokens.blueTint,
        borderRadius: BorderRadius.circular(7),
      ),
      alignment: Alignment.center,
      child: Text(
        MaterialLocalizations.of(context).formatDecimal(count),
        style: const TextStyle(
          fontSize: 10,
          height: 1,
          fontWeight: FontWeight.w700,
          color: PosTokens.blue,
        ),
      ),
    );
  }
}
