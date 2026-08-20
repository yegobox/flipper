import 'package:flipper_hr/features/attendance/data/attendance_day.dart';
import 'package:flutter/material.dart';

/// Colour-coded clock state, matching the shape of [StatusChip] and
/// [LeaveStatusChip] so the three HR modules read as one app.
class AttendanceStateChip extends StatelessWidget {
  const AttendanceStateChip({super.key, required this.state});

  final AttendanceState state;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (Color fg, Color bg) = switch (state) {
      AttendanceState.clockedIn => (scheme.primary, scheme.primaryContainer),
      AttendanceState.clockedOut => (
        scheme.onSecondaryContainer,
        scheme.secondaryContainer,
      ),
      AttendanceState.absent => (
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
        state.label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
