import 'package:flipper_hr/features/leave/data/leave_providers.dart';
import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flipper_hr/features/leave/data/leave_working_days.dart';
import 'package:flipper_hr/features/leave/widgets/leave_status_chip.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/money_format.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The approvals queue for one branch: what is pending, and what was decided.
///
/// Requests carry an employee id, not a name, so the roster is read alongside to
/// put a person on each row. A request whose employee is not on the branch roster
/// still lists — under its id — rather than being dropped: a row nobody can see
/// is a row nobody will ever decide.
class LeaveApprovalsPage extends ConsumerStatefulWidget {
  const LeaveApprovalsPage({
    super.key,
    required this.branchId,
    required this.branchName,
    this.deciderUserId,
  });

  final String branchId;
  final String? branchName;

  /// `public.users.id` recorded as the decider. Null is allowed — the column is
  /// nullable — but a decision with no name attached is worth avoiding, so the
  /// shell passes the signed-in profile's id.
  final String? deciderUserId;

  @override
  ConsumerState<LeaveApprovalsPage> createState() => _LeaveApprovalsPageState();
}

class _LeaveApprovalsPageState extends ConsumerState<LeaveApprovalsPage> {
  /// Ids with a decision in flight, so a row cannot be double-approved by an
  /// impatient second tap.
  final _deciding = <String>{};

  Future<void> _decide(LeaveRequest request, {required bool approve}) async {
    final note = await _askForNote(request, approve: approve);
    // Null means the dialog was dismissed; an empty string is a deliberate
    // "no comment" and must still go through.
    if (note == null || !mounted) return;

    setState(() => _deciding.add(request.id));
    try {
      final actions = ref.read(leaveActionsProvider);
      if (approve) {
        await actions.approve(
          request: request,
          decidedBy: widget.deciderUserId,
          note: note,
        );
      } else {
        await actions.reject(
          request: request,
          decidedBy: widget.deciderUserId,
          note: note,
        );
      }
      if (mounted) {
        _toast(approve ? 'Leave approved.' : 'Leave rejected.');
      }
    } catch (e) {
      if (mounted) _toast(_messageOf(e), isError: true);
    } finally {
      if (mounted) setState(() => _deciding.remove(request.id));
    }
  }

  /// The note prompt. Returns the note (possibly empty) or null if dismissed.
  ///
  /// A dedicated widget rather than an inline [AlertDialog] because the text
  /// field needs a controller with a lifetime: disposing one as soon as
  /// `showDialog` returns kills it while the route is still animating out, and
  /// the dialog rebuilds against a disposed controller.
  Future<String?> _askForNote(
    LeaveRequest request, {
    required bool approve,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => _DecisionDialog(request: request, approve: approve),
    );
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
    final theme = Theme.of(context);
    final leaveAsync = ref.watch(branchLeaveProvider(widget.branchId));
    // Names only: a missing roster (an approver who can decide but whose roster
    // read failed) degrades to ids rather than blocking the queue.
    final names = ref.watch(rosterProvider(widget.branchId)).maybeWhen(
      data: (people) => {for (final p in people) p.id: p},
      orElse: () => const <String, Employee>{},
    );

    return leaveAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 40,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  _messageOf(error),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () =>
                      ref.invalidate(branchLeaveProvider(widget.branchId)),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (all) {
        final pending = [
          for (final r in all)
            if (r.status == LeaveStatus.pending) r,
        ]..sort((a, b) => a.startDate.compareTo(b.startDate));
        final decided = [
          for (final r in all)
            if (r.status != LeaveStatus.pending) r,
        ];

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Leave', style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text(
                      [
                        if (pending.isEmpty)
                          'Nothing waiting on you'
                        else
                          '${pending.length} '
                              '${pending.length == 1 ? 'request' : 'requests'} '
                              'waiting on you',
                        // Named because the queue is branch-scoped: someone
                        // switching branches needs to see which one they are
                        // approving for.
                        if (widget.branchName case final name?
                            when name.isNotEmpty)
                          name,
                      ].join(' · '),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (pending.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
                sliver: SliverList.separated(
                  itemCount: pending.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final request = pending[index];
                    return _ApprovalCard(
                      key: Key('approval-${request.id}'),
                      request: request,
                      employee: names[request.employeeId],
                      isDeciding: _deciding.contains(request.id),
                      onApprove: () => _decide(request, approve: true),
                      onReject: () => _decide(request, approve: false),
                    );
                  },
                ),
              ),
            if (decided.isNotEmpty) ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                sliver: SliverToBoxAdapter(
                  child: Text('Decided', style: theme.textTheme.titleMedium),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                sliver: SliverList.separated(
                  itemCount: decided.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) => _DecidedRow(
                    request: decided[index],
                    employee: names[decided[index].employeeId],
                  ),
                ),
              ),
            ],
            if (pending.isEmpty && decided.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: _NoLeaveYet(),
              ),
          ],
        );
      },
    );
  }
}

/// Asks for the note that goes with an approval or a rejection.
///
/// The note is optional on an approval and strongly wanted on a rejection — it
/// is the only thing the person will see explaining the decision — so the label
/// changes rather than the validation: refusing to reject without a note would
/// leave the request stuck in the queue.
class _DecisionDialog extends StatefulWidget {
  const _DecisionDialog({required this.request, required this.approve});

  final LeaveRequest request;
  final bool approve;

  @override
  State<_DecisionDialog> createState() => _DecisionDialogState();
}

class _DecisionDialogState extends State<_DecisionDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    return AlertDialog(
      key: const Key('leave-decision-dialog'),
      title: Text(
        widget.approve ? 'Approve this leave?' : 'Reject this leave?',
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${request.type.label} · '
              '${formatShortDate(request.startDate)} → '
              '${formatShortDate(request.endDate)} · '
              '${formatLeaveDays(request.days)}',
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('leave-decision-note'),
              controller: _controller,
              autofocus: true,
              minLines: 2,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: widget.approve
                    ? 'Note (optional)'
                    : 'Why? (shown to them)',
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: const Key('leave-decision-confirm'),
          // An empty note is a deliberate "no comment" and must still decide, so
          // this pops a string rather than leaving it null.
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          child: Text(widget.approve ? 'Approve' : 'Reject'),
        ),
      ],
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  const _ApprovalCard({
    super.key,
    required this.request,
    required this.employee,
    required this.isDeciding,
    required this.onApprove,
    required this.onReject,
  });

  final LeaveRequest request;
  final Employee? employee;
  final bool isDeciding;
  final VoidCallback onApprove;
  final VoidCallback onReject;

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
                  employee?.fullName ?? 'Employee ${request.employeeId}',
                  style: theme.textTheme.titleSmall,
                ),
              ),
              LeaveStatusChip(status: request.status),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${request.type.label} · '
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
          const SizedBox(height: 12),
          if (isDeciding)
            const Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  key: Key('reject-${request.id}'),
                  onPressed: onReject,
                  child: const Text('Reject'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  key: Key('approve-${request.id}'),
                  onPressed: onApprove,
                  child: const Text('Approve'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _DecidedRow extends StatelessWidget {
  const _DecidedRow({required this.request, required this.employee});

  final LeaveRequest request;
  final Employee? employee;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              employee?.fullName ?? 'Employee ${request.employeeId}',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              '${request.type.label} · '
              '${formatShortDate(request.startDate)} · '
              '${formatLeaveDays(request.days)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          LeaveStatusChip(status: request.status),
        ],
      ),
    );
  }
}

class _NoLeaveYet extends StatelessWidget {
  const _NoLeaveYet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.beach_access_outlined,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('No leave requests yet', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Invite people from the People page and they can book their own '
              'leave here. Requests land in this queue for you to approve.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
