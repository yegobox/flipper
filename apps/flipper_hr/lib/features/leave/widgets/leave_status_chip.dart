import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flutter/material.dart';

/// Colour-coded request status pill.
///
/// Deliberately the same shape and tinting as [StatusChip] on the roster: the two
/// appear in the same app and a reader should not have to learn two vocabularies
/// of pill.
class LeaveStatusChip extends StatelessWidget {
  const LeaveStatusChip({super.key, required this.status});

  final LeaveStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (Color fg, Color bg) = switch (status) {
      LeaveStatus.approved => (scheme.primary, scheme.primaryContainer),
      LeaveStatus.pending => (scheme.tertiary, scheme.tertiaryContainer),
      LeaveStatus.rejected => (scheme.onErrorContainer, scheme.errorContainer),
      LeaveStatus.cancelled => (
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
