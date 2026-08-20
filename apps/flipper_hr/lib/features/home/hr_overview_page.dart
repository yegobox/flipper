import 'package:flipper_hr/features/branding/hr_tokens.dart';
import 'package:flipper_hr/features/leave/data/leave_providers.dart';
import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/money_format.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/people/data/people_query.dart';
import 'package:flipper_hr/features/session/data/hr_identity_providers.dart';
import 'package:flipper_hr/features/ui/hr_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// What HR looks like before you have decided what to do.
///
/// The roster is a table, and a table is an answer to a question you already
/// had. This page is the other thing an HR app owes whoever runs the business:
/// the state of the branch in one screen, and the two or three things currently
/// waiting on them.
///
/// Every figure comes from providers the other pages already use, so nothing
/// here can disagree with the page it links to.
class HrOverviewPage extends ConsumerWidget {
  const HrOverviewPage({
    super.key,
    required this.businessId,
    required this.branchId,
    this.branchName,
  });

  final String businessId;
  final String branchId;
  final String? branchName;

  /// Width below which the two columns stack.
  static const double _twoColumnBreakpoint = 1040;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(hrClockProvider)();
    final identity = ref.watch(hrIdentityOrUnknownProvider);
    final roster = ref.watch(rosterProvider(branchId));
    final pending = ref.watch(pendingLeaveProvider(branchId));

    final people = roster.value ?? const <Employee>[];
    final summary = PeopleSummary.from(people, asOf: now);
    final names = {for (final e in people) e.id: e};

    final wide = MediaQuery.sizeOf(context).width >= _twoColumnBreakpoint;

    final needsYou = _NeedsYouPanel(
      pending: pending,
      names: names,
      onOpenQueue: () => context.go('/approvals'),
      onRetry: () => ref.invalidate(pendingLeaveProvider(branchId)),
    );
    final outToday = _OutTodayPanel(
      people: people,
      onOpenRoster: () => context.go('/people'),
    );
    final joiners = _NewJoinersPanel(
      people: people,
      asOf: now,
      onOpenRoster: () => context.go('/people'),
    );

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          children: [
            _Greeting(
              name: identity.name,
              branchName: branchName,
              asOf: now,
            ),
            const SizedBox(height: 20),
            _QuickActions(
              onAddPerson: () => context.go('/people'),
              onReview: () => context.go('/approvals'),
              onAttendance: () => context.go('/attendance'),
              pendingCount: pending.value?.length ?? 0,
            ),
            const SizedBox(height: 20),
            _StatRow(
              summary: summary,
              loading: roster.isLoading,
              pendingCount: pending.value?.length ?? 0,
              onOpenRoster: () => context.go('/people'),
              onOpenApprovals: () => context.go('/approvals'),
            ),
            const SizedBox(height: 20),
            if (wide)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: needsYou),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          outToday,
                          const SizedBox(height: 20),
                          joiners,
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              needsYou,
              const SizedBox(height: 20),
              outToday,
              const SizedBox(height: 20),
              joiners,
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Greeting ─────────────────────────────────────────────────────────────────

class _Greeting extends StatelessWidget {
  const _Greeting({
    required this.name,
    required this.branchName,
    required this.asOf,
  });

  final String name;
  final String? branchName;
  final DateTime asOf;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${greetingFor(asOf)}, ${firstNameOf(name)}', style: HrType.display),
        const SizedBox(height: 4),
        Text(
          [
            formatLongDate(asOf),
            if (branchName != null && branchName!.isNotEmpty) branchName!,
          ].join(' · '),
          style: HrType.caption,
        ),
      ],
    );
  }
}

/// "Good morning" / "Good afternoon" / "Good evening", by local hour.
String greetingFor(DateTime asOf) {
  if (asOf.hour < 12) return 'Good morning';
  if (asOf.hour < 18) return 'Good afternoon';
  return 'Good evening';
}

/// The part of a name a greeting uses. Falls back to the whole thing.
String firstNameOf(String name) {
  final first = name.trim().split(RegExp(r'\s+')).firstOrNull ?? '';
  return first.isEmpty ? name : first;
}

const _weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const _months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// `Wednesday, 19 August` — the date a person would say out loud.
///
/// Written out rather than taken from `intl`: HR ships one locale, and a
/// dashboard heading is not worth a dependency that has to be initialised.
String formatLongDate(DateTime date) =>
    '${_weekdays[date.weekday - 1]}, ${date.day} ${_months[date.month - 1]}';

// ─── Quick actions ────────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onAddPerson,
    required this.onReview,
    required this.onAttendance,
    required this.pendingCount,
  });

  final VoidCallback onAddPerson;
  final VoidCallback onReview;
  final VoidCallback onAttendance;
  final int pendingCount;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        FilledButton.icon(
          key: const Key('hr-overview-add-person'),
          onPressed: onAddPerson,
          style: hrPrimaryButtonStyle(),
          icon: const Icon(Icons.person_add_alt_1, size: 17),
          label: const Text('Add a person'),
        ),
        OutlinedButton.icon(
          key: const Key('hr-overview-review'),
          onPressed: onReview,
          style: hrSecondaryButtonStyle(),
          icon: const Icon(Icons.fact_check_outlined, size: 17),
          label: Text(
            pendingCount == 0
                ? 'Approvals'
                : 'Review $pendingCount request${pendingCount == 1 ? '' : 's'}',
          ),
        ),
        OutlinedButton.icon(
          onPressed: onAttendance,
          style: hrSecondaryButtonStyle(),
          icon: const Icon(Icons.schedule_outlined, size: 17),
          label: const Text('Attendance board'),
        ),
      ],
    );
  }
}

// ─── Stats ────────────────────────────────────────────────────────────────────

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.summary,
    required this.loading,
    required this.pendingCount,
    required this.onOpenRoster,
    required this.onOpenApprovals,
  });

  final PeopleSummary summary;
  final bool loading;
  final int pendingCount;
  final VoidCallback onOpenRoster;
  final VoidCallback onOpenApprovals;

  @override
  Widget build(BuildContext context) {
    // A dash rather than a zero while the roster is still arriving: a headcount
    // of 0 is a real and alarming number, and it must never be a loading state.
    String n(int value) => loading ? '—' : '$value';

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        HrStatTile(
          key: const Key('hr-overview-headcount'),
          label: 'Headcount',
          value: n(summary.headcount),
          icon: Icons.groups_outlined,
          hint: loading ? null : '${summary.active} active',
          onTap: onOpenRoster,
        ),
        HrStatTile(
          label: 'On leave',
          value: n(summary.onLeave),
          icon: Icons.beach_access_outlined,
          tone: summary.onLeave > 0 ? HrTone.warning : HrTone.neutral,
          onTap: onOpenRoster,
        ),
        HrStatTile(
          key: const Key('hr-overview-pending'),
          label: 'Waiting on you',
          value: loading ? '—' : '$pendingCount',
          icon: Icons.pending_actions_outlined,
          tone: pendingCount > 0 ? HrTone.danger : HrTone.positive,
          hint: pendingCount > 0 ? 'Needs a decision' : 'All clear',
          onTap: onOpenApprovals,
        ),
        HrStatTile(
          label: 'New this month',
          value: n(summary.newThisMonth),
          icon: Icons.auto_awesome_outlined,
          tone: HrTone.positive,
          onTap: onOpenRoster,
        ),
        HrStatTile(
          label: 'Monthly payroll',
          value: loading
              ? '—'
              : formatCompactMoney(summary.monthlyPayroll, summary.currency),
          icon: Icons.payments_outlined,
          hint: loading ? null : 'Estimated',
        ),
      ],
    );
  }
}

// ─── Needs you ────────────────────────────────────────────────────────────────

/// The leave nobody has decided yet, soonest first.
class _NeedsYouPanel extends StatelessWidget {
  const _NeedsYouPanel({
    required this.pending,
    required this.names,
    required this.onOpenQueue,
    required this.onRetry,
  });

  final AsyncValue<List<LeaveRequest>> pending;
  final Map<String, Employee> names;
  final VoidCallback onOpenQueue;
  final VoidCallback onRetry;

  /// Enough to act on without turning the dashboard into the queue.
  static const _maxRows = 5;

  @override
  Widget build(BuildContext context) {
    return HrPanel(
      key: const Key('hr-overview-needs-you'),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HrSectionHeader(
            title: 'Needs your decision',
            subtitle: 'Leave requests nobody has answered yet',
            count: pending.value?.length,
            actionLabel: 'Open queue',
            onAction: onOpenQueue,
          ),
          const SizedBox(height: 8),
          ...switch (pending) {
            AsyncError() => [
              HrEmptyState(
                icon: Icons.cloud_off_outlined,
                message: 'Could not load the approvals queue.',
                actionLabel: 'Try again',
                onAction: onRetry,
                compact: true,
              ),
            ],
            AsyncLoading() => const [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 28),
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
            _ => _rows(context),
          },
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  List<Widget> _rows(BuildContext context) {
    final requests = pending.value ?? const <LeaveRequest>[];
    if (requests.isEmpty) {
      return const [
        HrEmptyState(
          icon: Icons.check_circle_outline,
          message: 'Nothing is waiting on you. Every request has been decided.',
          compact: true,
        ),
      ];
    }

    final shown = requests.take(_maxRows).toList();
    return [
      for (final request in shown)
        _RequestRow(
          request: request,
          employee: names[request.employeeId],
          onOpen: onOpenQueue,
        ),
      if (requests.length > shown.length)
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: TextButton(
            onPressed: onOpenQueue,
            style: TextButton.styleFrom(foregroundColor: HrTokens.accent),
            child: Text('${requests.length - shown.length} more waiting'),
          ),
        ),
    ];
  }
}

class _RequestRow extends StatelessWidget {
  const _RequestRow({
    required this.request,
    required this.employee,
    required this.onOpen,
  });

  final LeaveRequest request;
  final Employee? employee;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final name = employee?.fullName ?? 'Employee ${request.employeeId}';
    final days = request.days == request.days.roundToDouble()
        ? '${request.days.round()}'
        : request.days.toStringAsFixed(1);

    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(HrTokens.radiusSm),
      hoverColor: HrTokens.surface2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        child: Row(
          children: [
            HrPersonAvatar(
              initials: employee?.initials ?? '',
              seed: request.employeeId,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: HrType.bodyStrong,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    '${request.type.label} · '
                    '${formatShortRange(request.startDate, request.endDate)} · '
                    '$days day${days == '1' ? '' : 's'}',
                    style: HrType.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const HrPill(label: 'Pending', tone: HrTone.warning),
          ],
        ),
      ),
    );
  }
}

/// `19 Aug – 23 Aug`, collapsing a single day to just itself.
String formatShortRange(DateTime start, DateTime end) {
  String one(DateTime d) => '${d.day} ${_months[d.month - 1].substring(0, 3)}';
  return start == end ? one(start) : '${one(start)} – ${one(end)}';
}

// ─── Out today ────────────────────────────────────────────────────────────────

/// Who is not at work, as the roster records it.
class _OutTodayPanel extends StatelessWidget {
  const _OutTodayPanel({required this.people, required this.onOpenRoster});

  /// Who is out is taken from employment status rather than from approved leave
  /// dates: status is what the roster, the board and the payroll all agree on,
  /// and a dashboard that disagreed with the roster would be worse than one that
  /// counts a little coarsely.
  final List<Employee> people;

  final VoidCallback onOpenRoster;

  @override
  Widget build(BuildContext context) {
    final out = [
      for (final e in people)
        if (e.status == EmploymentStatus.onLeave) e,
    ];

    return HrPanel(
      key: const Key('hr-overview-out-today'),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HrSectionHeader(
            title: 'Out today',
            count: out.isEmpty ? null : out.length,
            actionLabel: 'Roster',
            onAction: onOpenRoster,
          ),
          const SizedBox(height: 8),
          if (out.isEmpty)
            const HrEmptyState(
              icon: Icons.wb_sunny_outlined,
              message: 'Everyone is in today.',
              compact: true,
            )
          else
            for (final e in out) _PersonLine(employee: e, tone: HrTone.warning),
        ],
      ),
    );
  }
}

// ─── New joiners ──────────────────────────────────────────────────────────────

class _NewJoinersPanel extends StatelessWidget {
  const _NewJoinersPanel({
    required this.people,
    required this.asOf,
    required this.onOpenRoster,
  });

  final List<Employee> people;
  final DateTime asOf;
  final VoidCallback onOpenRoster;

  @override
  Widget build(BuildContext context) {
    final joiners = [
      for (final e in people)
        if (e.status.isEmployed &&
            e.hireDate.year == asOf.year &&
            e.hireDate.month == asOf.month)
          e,
    ]..sort((a, b) => b.hireDate.compareTo(a.hireDate));

    return HrPanel(
      key: const Key('hr-overview-joiners'),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HrSectionHeader(
            title: 'Joined this month',
            count: joiners.isEmpty ? null : joiners.length,
            actionLabel: 'Roster',
            onAction: onOpenRoster,
          ),
          const SizedBox(height: 8),
          if (joiners.isEmpty)
            const HrEmptyState(
              icon: Icons.person_add_alt_outlined,
              message: 'Nobody new this month.',
              compact: true,
            )
          else
            for (final e in joiners.take(4))
              _PersonLine(
                employee: e,
                tone: HrTone.positive,
                trailing: formatShortRange(e.hireDate, e.hireDate),
              ),
        ],
      ),
    );
  }
}

class _PersonLine extends StatelessWidget {
  const _PersonLine({
    required this.employee,
    required this.tone,
    this.trailing,
  });

  final Employee employee;
  final HrTone tone;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          HrPersonAvatar(
            initials: employee.initials,
            seed: employee.id,
            radius: 14,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.fullName,
                  style: HrType.bodyStrong,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (employee.jobTitle.isNotEmpty)
                  Text(
                    employee.jobTitle,
                    style: HrType.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (trailing != null)
            Text(trailing!, style: HrType.caption)
          else
            HrPill(label: employee.status.label, tone: tone),
        ],
      ),
    );
  }
}
