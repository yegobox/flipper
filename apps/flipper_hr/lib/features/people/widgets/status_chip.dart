import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flutter/material.dart';

/// Colour-coded employment status pill used in both roster layouts.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final EmploymentStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Tinted surfaces rather than saturated fills, so a table of chips stays
    // readable in both themes.
    final (Color fg, Color bg) = switch (status) {
      EmploymentStatus.active => (scheme.primary, scheme.primaryContainer),
      EmploymentStatus.onLeave => (
        scheme.tertiary,
        scheme.tertiaryContainer,
      ),
      EmploymentStatus.suspended => (
        scheme.onSecondaryContainer,
        scheme.secondaryContainer,
      ),
      EmploymentStatus.terminated => (
        scheme.onSurfaceVariant,
        scheme.surfaceContainerHighest,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
