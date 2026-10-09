import 'package:flipper_hr/features/pay/data/pay_period.dart';
import 'package:flipper_hr/features/pay/data/pay_providers.dart';
import 'package:flipper_hr/features/pay/employee_pay_page.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/session/data/hr_session_providers.dart';
import 'package:flipper_hr/features/ui/hr_ui.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The signed-in person's own pay: payslips, what they were paid, what they
/// owe back, and asking for an advance.
///
/// Self-service, like leave: scoped by the person's own record, never by a
/// branch selection, and readable without the business's subscription.
class MyPayPage extends ConsumerWidget {
  const MyPayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final me = ref.watch(myEmployeeProvider);
    final book = ref.watch(myPayBookProvider);
    final now = ref.watch(hrClockProvider)();

    if (me.isLoading || book.isLoading && book.value == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final employee = me.value;
    if (employee == null) {
      return Center(
        child: HrEmptyState(
          icon: Icons.badge_outlined,
          title: l10n.hrPayNoRecordTitle,
          message: l10n.hrPayNoRecordBody,
        ),
      );
    }
    if (book.hasError) {
      return Center(
        child: HrEmptyState(
          icon: Icons.cloud_off_outlined,
          message: '${book.error}'.replaceFirst('PayRepositoryException: ', ''),
          actionLabel: l10n.retry,
          onAction: () => ref.invalidate(myPayBookProvider),
        ),
      );
    }
    final b = book.value;
    final account = EmployeePayAccount(
      employee: employee,
      payslips: b?.payslips ?? const [],
      payments: b?.payments ?? const [],
      advances: b?.advances ?? const [],
      today: now,
    );
    return PersonPayView(
      account: account,
      requests: b?.requests ?? const [],
      canManage: false,
    );
  }
}
