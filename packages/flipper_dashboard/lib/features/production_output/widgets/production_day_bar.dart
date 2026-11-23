import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/production_output_derived_providers.dart';

/// ‹ Today › — picks the day the Production Output screen shows. Tapping the
/// label opens a date picker; the arrows step one day.
class ProductionDayBar extends ConsumerWidget {
  const ProductionDayBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(productionDayProvider);
    final today = localDay(DateTime.now());
    final l10n = context.flipperL10n;
    final label = day == today
        ? l10n.productionOutputToday
        : MaterialLocalizations.of(context).formatMediumDate(day);

    void setDay(DateTime value) =>
        ref.read(productionDayProvider.notifier).state = localDay(value);

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          tooltip: l10n.productionOutputPreviousDay,
          onPressed: () => setDay(day.subtract(const Duration(days: 1))),
        ),
        TextButton.icon(
          icon: const Icon(Icons.calendar_today, size: 16),
          label: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: day,
              firstDate: DateTime(2020),
              lastDate: today.add(const Duration(days: 365)),
            );
            if (picked != null) setDay(picked);
          },
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          tooltip: l10n.productionOutputNextDay,
          onPressed: () => setDay(day.add(const Duration(days: 1))),
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
