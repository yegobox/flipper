import 'package:flipper_hr/features/leave/data/leave_balance.dart';
import 'package:flipper_hr/features/leave/data/leave_providers.dart';
import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flipper_hr/features/leave/data/leave_working_days.dart';
import 'package:flipper_hr/features/leave/widgets/leave_balance_card.dart';
import 'package:flipper_hr/features/leave/widgets/leave_request_form.dart';
import 'package:flipper_hr/features/leave/widgets/leave_status_chip.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/money_format.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/session/data/hr_session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Self-service leave: your balances, your requests, and the button that books
/// more.
///
/// Scoped to whoever is signed in, resolved through [myEmployeeProvider] rather
/// than passed in — this page is the whole of HR for an invited employee, and it
/// must work for someone who has no branch selection and no roster access at all.
class MyLeavePage extends ConsumerStatefulWidget {
  const MyLeavePage({super.key});

  @override
  ConsumerState<MyLeavePage> createState() => _MyLeavePageState();
}

class _MyLeavePageState extends ConsumerState<MyLeavePage> {
  Future<void> _openForm({
    required Employee employee,
    required List<LeaveRequest> existing,
  }) async {
    final today = ref.read(hrClockProvider)();
    final isNarrow = MediaQuery.sizeOf(context).width < 720;

    final sent = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final form = LeaveRequestForm(
          today: today,
          existing: existing,
          annualOverride: employee.annualLeaveDays,
          onCancel: () => Navigator.of(dialogContext).pop(),
          onSubmit: ({
            required type,
            required start,
            required end,
            required reason,
          }) async {
            await ref.read(leaveActionsProvider).submit(
              employeeId: employee.id,
              businessId: employee.businessId,
              branchId: employee.branchId,
              type: type,
              startDate: start,
              endDate: end,
              reason: reason,
              // Their own account: the audit trail should say they asked, not
              // that the row appeared from nowhere.
              requestedBy: employee.userId,
            );
            if (dialogContext.mounted) Navigator.of(dialogContext).pop(true);
          },
        );
        if (isNarrow) return Dialog.fullscreen(child: form);
        return Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: form,
          ),
        );
      },
    );

    if (sent == true && mounted) {
      _toast('Leave request sent. You will see it here once it is decided.');
    }
  }

  Future<void> _withdraw(LeaveRequest request) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw this request?'),
        content: Text(
          'Your leave from ${formatShortDate(request.startDate)} to '
          '${formatShortDate(request.endDate)} will be cancelled and the days '
          'go back to your balance.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep it'),
          ),
          FilledButton(
            key: const Key('confirm-withdraw'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(leaveActionsProvider).cancel(request);
      if (mounted) _toast('Request withdrawn.');
    } catch (e) {
      if (mounted) _toast(_messageOf(e), isError: true);
    }
  }

  void _toast(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
        duration: Duration(seconds: isError ? 8 : 4),
      ),
    );
  }

  static String _messageOf(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  @override
  Widget build(BuildContext context) {
    final employeeAsync = ref.watch(myEmployeeProvider);

    return employeeAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _LeaveMessage(
        icon: Icons.error_outline,
        title: 'Could not load your record',
        body: _messageOf(error),
        actionLabel: 'Try again',
        onAction: () {
          // The session resolve is what failed in almost every case, and
          // myEmployeeProvider depends on it — refreshing only the leaf would
          // replay the same cached failure.
          ref.invalidate(hrSessionProvider);
          ref.invalidate(myEmployeeProvider);
        },
      ),
      data: (employee) {
        if (employee == null) return const _NoEmployeeRecord();
        return _LeaveBody(
          employee: employee,
          onRequest: (existing) =>
              _openForm(employee: employee, existing: existing),
          onWithdraw: _withdraw,
        );
      },
    );
  }
}

class _LeaveBody extends ConsumerWidget {
  const _LeaveBody({
    required this.employee,
    required this.onRequest,
    required this.onWithdraw,
  });

  final Employee employee;
  final void Function(List<LeaveRequest> existing) onRequest;
  final void Function(LeaveRequest request) onWithdraw;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final requestsAsync = ref.watch(myLeaveProvider);
    final balancesAsync = ref.watch(myLeaveBalancesProvider);
    final year = ref.watch(hrClockProvider)().year;

    return requestsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _LeaveMessage(
        icon: Icons.error_outline,
        title: 'Could not load your leave',
        body: error.toString().replaceFirst('Exception: ', ''),
        actionLabel: 'Try again',
        onAction: () => ref.invalidate(employeeLeaveProvider(employee.id)),
      ),
      data: (requests) => CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My leave',
                          style: theme.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${employee.fullName} · balances for $year',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    key: const Key('request-leave-button'),
                    onPressed: employee.status.isEmployed
                        ? () => onRequest(requests)
                        : null,
                    icon: const Icon(Icons.add),
                    label: const Text('Request leave'),
                  ),
                ],
              ),
            ),
          ),
          if (!employee.status.isEmployed)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: _Notice(
                  'Your employment has ended, so no new leave can be booked. '
                  'Your history stays here.',
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            sliver: SliverToBoxAdapter(
              child: balancesAsync.when(
                loading: () => const SizedBox(height: 8),
                error: (_, __) => const SizedBox.shrink(),
                data: (balances) => _BalanceRow(balances: balances),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            sliver: SliverToBoxAdapter(
              child: Text('Requests', style: theme.textTheme.titleMedium),
            ),
          ),
          if (requests.isEmpty)
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(24, 8, 24, 24),
              sliver: SliverToBoxAdapter(
                child: _Notice(
                  'No leave booked yet. Your balances above are what you have '
                  'to spend this year.',
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              sliver: SliverList.separated(
                itemCount: requests.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return _RequestCard(
                    key: Key('leave-request-${request.id}'),
                    request: request,
                    // Only your own undecided request can be withdrawn; the
                    // database enforces the same thing.
                    onWithdraw: request.status == LeaveStatus.pending
                        ? () => onWithdraw(request)
                        : null,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _BalanceRow extends StatelessWidget {
  const _BalanceRow({required this.balances});

  final List<LeaveBalance> balances;

  @override
  Widget build(BuildContext context) {
    // Horizontal scroll rather than a wrap: the cards are a fixed-width set read
    // left to right, and wrapping them at an awkward width strands one on its
    // own line.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final balance in balances) ...[
            LeaveBalanceCard(balance: balance),
            const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({super.key, required this.request, this.onWithdraw});

  final LeaveRequest request;
  final VoidCallback? onWithdraw;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  request.type.label,
                  style: theme.textTheme.titleSmall,
                ),
              ),
              LeaveStatusChip(status: request.status),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${formatShortDate(request.startDate)} → '
            '${formatShortDate(request.endDate)} · '
            '${formatLeaveDays(request.days)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          if (request.reason.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(request.reason, style: theme.textTheme.bodySmall),
          ],
          if (request.decisionNote.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              '“${request.decisionNote}”',
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
          if (onWithdraw != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                key: Key('withdraw-${request.id}'),
                onPressed: onWithdraw,
                icon: const Icon(Icons.undo, size: 16),
                label: const Text('Withdraw'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Signed in, but no `hr_employees` row resolves to this session.
///
/// A real and recoverable state: someone whose record was added with a different
/// phone number, or who was never invited from HR so `user_id` was never written.
/// Both fixes are on the roster side, so the message says who to ask rather than
/// offering a button that cannot help.
class _NoEmployeeRecord extends StatelessWidget {
  const _NoEmployeeRecord();

  @override
  Widget build(BuildContext context) {
    return const _LeaveMessage(
      icon: Icons.badge_outlined,
      title: 'No employee record for this account',
      body:
          'Leave is booked against a person on a branch roster, and this '
          'sign-in does not resolve to one yet. Ask whoever manages your '
          'roster to invite you from the People page — that is what links your '
          'record to this account. If they already did, check that the phone '
          'number on your record is the one you signed in with.',
    );
  }
}

class _LeaveMessage extends StatelessWidget {
  const _LeaveMessage({
    required this.icon,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 44, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                body,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 20),
                FilledButton(onPressed: onAction, child: Text(actionLabel!)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
