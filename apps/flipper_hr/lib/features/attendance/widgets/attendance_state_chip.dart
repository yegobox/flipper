import 'package:flipper_hr/features/attendance/data/attendance_day.dart';
import 'package:flipper_hr/features/ui/hr_ui.dart';
import 'package:flutter/material.dart';

/// Colour-coded clock state, matching the shape of [StatusChip] and
/// [LeaveStatusChip] so the three HR modules read as one app.
class AttendanceStateChip extends StatelessWidget {
  const AttendanceStateChip({super.key, required this.state});

  final AttendanceState state;

  @override
  Widget build(BuildContext context) {
    final tone = switch (state) {
      AttendanceState.clockedIn => HrTone.positive,
      AttendanceState.clockedOut => HrTone.info,
      AttendanceState.absent => HrTone.neutral,
    };
    return HrPill(label: state.label, tone: tone);
  }
}
