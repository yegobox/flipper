import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flipper_hr/features/ui/hr_ui.dart';
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
    final tone = switch (status) {
      LeaveStatus.approved => HrTone.positive,
      LeaveStatus.pending => HrTone.warning,
      LeaveStatus.rejected => HrTone.danger,
      LeaveStatus.cancelled => HrTone.neutral,
    };
    return HrPill(label: status.label, tone: tone);
  }
}
