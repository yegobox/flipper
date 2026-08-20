import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/ui/hr_ui.dart';
import 'package:flutter/material.dart';

/// Employment status as one of the product's pills.
///
/// The mapping is the point: active is not "primary-coloured", it is *positive*,
/// and suspended is *danger*. Naming the meaning rather than the colour is what
/// keeps this chip in step with every other status on screen.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final EmploymentStatus status;

  @override
  Widget build(BuildContext context) {
    final tone = switch (status) {
      EmploymentStatus.active => HrTone.positive,
      EmploymentStatus.onLeave => HrTone.warning,
      EmploymentStatus.suspended => HrTone.danger,
      EmploymentStatus.terminated => HrTone.neutral,
    };
    return HrPill(label: status.label, tone: tone);
  }
}
