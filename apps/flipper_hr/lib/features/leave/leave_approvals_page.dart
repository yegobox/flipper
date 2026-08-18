import 'package:flipper_hr/features/leave/data/leave_providers.dart';
import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flipper_hr/features/leave/data/leave_working_days.dart';
import 'package:flipper_hr/features/leave/widgets/leave_status_chip.dart';
import 'package:flipper_hr/features/people/data/money_format.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/people/data/person_ref.dart';
import 'package:flipper_hr/features/session/data/hr_session.dart';
import 'package:flipper_hr/features/session/data/hr_session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The approvals queue: what is waiting on the signed-in person, what is waiting
/// on somebody else, and what has been decided.
///
/// Two audiences, and the split between them is the point of the reporting line
/// (migration 0007):
///
///   * a line manager sees their own team and nothing else, with no branch
///     selection and no roster access — [branchId] is null for them;
///   * an owner or invited HR manager sees the whole branch, but the queue now
///     says which requests are really somebody else's to answer, so overriding a
///     manager is a deliberate act rather than an accident of ordering.
///
/// Requests carry an employee id, not a name, so names are read alongside — from
/// the branch roster, the caller's own team, or both. A request whose person
/// resolves to neither still lists under its id: a row nobody can see is a row
/// nobody will ever decide.
class LeaveApprovalsPage extends ConsumerStatefulWidget {
  const LeaveApprovalsPage({
    super.key,
    this.branchId,
    this.branchName,
    this.deciderUserId,
  });

  /// The open branch, when there is one. Null for a session with no business
  /// scope — a line manager's queue is their team, wherever it sits.
  final String? branchId;

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

  /// Reloads everything the queue is built from.
  ///
  /// The sources are invalidated, not just [approvalsQueueProvider]: it derives
  /// from them, so recomputing it alone would re-await a dependency that is still
  /// holding the same failure.
  void _refresh() {
    ref.invalidate(teamLeaveProvider);
    ref.invalidate(myLineProvider);
    final branchId = widget.branchId;
    if (branchId != null) ref.invalidate(branchLeaveProvider(branchId));
    ref.invalidate(approvalsQueueProvider(branchId));
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
    final leaveAsync = ref.watch(approvalsQueueProvider(widget.branchId));
    // Names only: a missing roster or a failed team read degrades the queue to
    // ids rather than blocking it.
    final names = ref.watch(peopleNamesProvider(widget.branchId));
    // A session that has not resolved yet attributes nothing rather than
    // guessing, which reads as "waiting on you" — see [_QueueSplit].
    final session = ref.watch(hrSessionProvider).value ?? HrSession.none;

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
                FilledButton(onPressed: _refresh, child: const Text('Try again')),
              ],
            ),
          ),
        ),
      ),
      data: (all) {
        final split = _QueueSplit.of(
          requests: all,
          names: names,
          session: session,
        );

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
                      _subtitle(split),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (split.mine.isNotEmpty)
              ..._pendingSection(
                requests: split.mine,
                names: names,
                // No heading when there is nothing to contrast it with: the page
                // title already says whose queue this is.
                heading: split.theirs.isEmpty ? null : 'Waiting on you',
                canDecide: split.canDecide,
              ),
            if (split.theirs.isNotEmpty)
              ..._pendingSection(
                requests: split.theirs,
                names: names,
                heading: 'With their manager',
                caption:
                    'Their own manager has not answered yet. Deciding one of '
                    'these answers it over their head.',
                canDecide: split.canDecide,
              ),
            if (split.decided.isNotEmpty) ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                sliver: SliverToBoxAdapter(
                  child: Text('Decided', style: theme.textTheme.titleMedium),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                sliver: SliverList.separated(
                  itemCount: split.decided.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) => _DecidedRow(
                    request: split.decided[index],
                    person: names[split.decided[index].employeeId],
                  ),
                ),
              ),
            ],
            if (split.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _NoLeaveYet(canManageRoster: session.canManageRoster),
              ),
          ],
        );
      },
    );
  }

  String _subtitle(_QueueSplit split) {
    final waiting = split.mine.length;
    return [
      if (waiting == 0)
        'Nothing waiting on you'
      else
        '$waiting ${waiting == 1 ? 'request' : 'requests'} waiting on you',
      if (split.theirs.isNotEmpty)
        '${split.theirs.length} with another manager',
      // Named because the branch queue is branch-scoped: someone switching
      // branches needs to see which one they are approving for. A team-only
      // queue has no branch to name, so it says whose queue it is instead.
      if (widget.branchName case final name? when name.isNotEmpty)
        name
      else if (widget.branchId == null)
        'Your team',
    ].join(' · ');
  }

  List<Widget> _pendingSection({
    required List<LeaveRequest> requests,
    required Map<String, PersonRef> names,
    required bool Function(LeaveRequest) canDecide,
    String? heading,
    String? caption,
  }) {
    final theme = Theme.of(context);
    return [
      if (heading != null)
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(heading, style: theme.textTheme.titleMedium),
                if (caption != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    caption,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
        sliver: SliverList.separated(
          itemCount: requests.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final request = requests[index];
            final person = names[request.employeeId];
            final decidable = canDecide(request);
            return _ApprovalCard(
              key: Key('approval-${request.id}'),
              request: request,
              person: person,
              // The manager the request belongs to, when that is somebody other
              // than whoever is reading.
              manager: person?.managerId == null
                  ? null
                  : names[person!.managerId!],
              isDeciding: _deciding.contains(request.id),
              onApprove: decidable ? () => _decide(request, approve: true) : null,
              onReject: decidable ? () => _decide(request, approve: false) : null,
            );
          },
        ),
      ),
    ];
  }
}

/// The queue, cut three ways: yours to answer, somebody else's, and history.
///
/// Whose a request is and who MAY answer it are two different questions, and this
/// keeps them apart:
///
///   * yours, if you are the person's DIRECT manager — that is what the reporting
///     line means, and what the user asking for it expects to see;
///   * yours, if they have no manager at all and you manage the business — the
///     fallback every record written before migration 0007 relies on;
///   * otherwise theirs, and listed as theirs.
///
/// [canDecide] is wider than "mine" on purpose, in both directions the database
/// allows: business scope decides anything (a manager on leave must not strand
/// their team), and a manager higher up the line decides for a team below theirs
/// (`hr_my_report_ids()` is recursive). Those requests still show under their own
/// manager's heading, so acting on one reads as the escalation it is.
class _QueueSplit {
  const _QueueSplit({
    required this.mine,
    required this.theirs,
    required this.decided,
    required this.canDecide,
  });

  factory _QueueSplit.of({
    required List<LeaveRequest> requests,
    required Map<String, PersonRef> names,
    required HrSession session,
  }) {
    final me = session.employeeIds.toSet();
    final team = session.reportIds.toSet();
    final mine = <LeaveRequest>[];
    final theirs = <LeaveRequest>[];
    final decided = <LeaveRequest>[];

    for (final r in requests) {
      if (r.status != LeaveStatus.pending) {
        decided.add(r);
        continue;
      }
      final person = names[r.employeeId];
      final managerId = person?.managerId;
      final bool isMine;
      if (managerId != null && managerId.isNotEmpty) {
        isMine = me.contains(managerId);
      } else if (person != null) {
        // Known record, no manager: the business answers for them.
        isMine = session.canManageRoster;
      } else {
        // The name did not resolve — a failed roster or team read. Fall back to
        // what the session alone can say, so a degraded read does not quietly
        // move somebody's work into a queue that ignores it.
        isMine = team.contains(r.employeeId) || session.canManageRoster;
      }
      (isMine ? mine : theirs).add(r);
    }

    // Soonest start first in both queues: what needs answering first is the leave
    // that begins soonest, not the request that was filed first.
    mine.sort((a, b) => a.startDate.compareTo(b.startDate));
    theirs.sort((a, b) => a.startDate.compareTo(b.startDate));
    return _QueueSplit(
      mine: mine,
      theirs: theirs,
      decided: decided,
      canDecide: (r) =>
          session.canManageRoster || team.contains(r.employeeId),
    );
  }

  final List<LeaveRequest> mine;
  final List<LeaveRequest> theirs;
  final List<LeaveRequest> decided;

  /// Whether this reader may answer a given request. See the class doc: not the
  /// same question as which list it lands in.
  final bool Function(LeaveRequest) canDecide;

  bool get isEmpty => mine.isEmpty && theirs.isEmpty && decided.isEmpty;
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
    required this.person,
    required this.manager,
    required this.isDeciding,
    required this.onApprove,
    required this.onReject,
  });

  final LeaveRequest request;
  final PersonRef? person;

  /// The line manager this request belongs to, when it is known and is somebody
  /// other than whoever is reading the page.
  final PersonRef? manager;

  final bool isDeciding;

  /// Null when this reader may not decide this request — a line manager looking
  /// at another team's row. The card still lists it; it just cannot answer it.
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final approve = onApprove;
    final reject = onReject;

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
                  person?.fullName ?? 'Employee ${request.employeeId}',
                  style: theme.textTheme.titleSmall,
                ),
              ),
              LeaveStatusChip(status: request.status),
            ],
          ),
          if (manager case final manager?) ...[
            const SizedBox(height: 2),
            Text(
              'Reports to ${manager.fullName}',
              key: Key('approval-manager-${request.id}'),
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
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
          else if (approve == null || reject == null)
            Text(
              'Only their manager can answer this one.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  key: Key('reject-${request.id}'),
                  onPressed: reject,
                  child: const Text('Reject'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  key: Key('approve-${request.id}'),
                  onPressed: approve,
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
  const _DecidedRow({required this.request, required this.person});

  final LeaveRequest request;
  final PersonRef? person;

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
              person?.fullName ?? 'Employee ${request.employeeId}',
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
  const _NoLeaveYet({required this.canManageRoster});

  /// Changes the advice, not the tone: someone who manages the roster is told how
  /// requests get here, while a line manager is told whose requests will.
  final bool canManageRoster;

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
              canManageRoster
                  ? 'Invite people from the People page and they can book their '
                        'own leave. Set who each person reports to and their '
                        'requests go to that manager; anyone with no manager '
                        'lands here.'
                  : 'Requests from anyone who reports to you will appear here '
                        'for you to approve.',
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
