import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_design_system/flipper_design_system.dart'
    show showFlipperDatePicker;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/production_output_derived_providers.dart';

/// ‹ Today › — picks the day the Production Output screen shows. Tapping the
/// label opens a date picker; the arrows step one day.
class ProductionDayBar extends ConsumerWidget {
  const ProductionDayBar({super.key});

  /// The picker's range. The arrows stop at the same days, so the picker is
  /// never opened on a day outside it.
  static final firstDay = DateTime(2020);
  static DateTime lastDay(DateTime today) => shiftDay(today, 365);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(productionDayProvider);
    final today = localDay(DateTime.now());
    final l10n = context.flipperL10n;
    final label = day == today
        ? l10n.productionOutputToday
        : MaterialLocalizations.of(context).formatMediumDate(day);

    final lastDay = ProductionDayBar.lastDay(today);
    void setDay(DateTime value) =>
        ref.read(productionDayProvider.notifier).state = localDay(value);

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          tooltip: l10n.productionOutputPreviousDay,
          onPressed: day.isAfter(firstDay)
              ? () => setDay(shiftDay(day, -1))
              : null,
        ),
        Builder(
          builder: (anchor) => TextButton.icon(
            icon: const Icon(Icons.calendar_today, size: 16),
            label: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            onPressed: () async {
              final picked = await showFlipperDatePicker(
                context: anchor,
                anchorContext: anchor,
                // In range: only the arrows and this picker set the day.
                initialDate: day,
                firstDate: firstDay,
                lastDate: lastDay,
              );
              if (picked != null) setDay(picked);
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          tooltip: l10n.productionOutputNextDay,
          onPressed: day.isBefore(lastDay)
              ? () => setDay(shiftDay(day, 1))
              : null,
        ),
        if (day != today) ...[
          const SizedBox(width: 4),
          TextButton(
            onPressed: () => setDay(today),
            child: Text(l10n.productionOutputToday),
          ),
        ],
      ],
    );
  }
}
