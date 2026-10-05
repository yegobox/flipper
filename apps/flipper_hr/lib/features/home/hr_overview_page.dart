import 'package:flipper_hr/features/branding/hr_tokens.dart';
import 'package:flipper_hr/features/leave/data/leave_providers.dart';
import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/money_format.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/people/data/people_query.dart';
import 'package:flipper_hr/features/session/data/hr_identity_providers.dart';
import 'package:flipper_hr/features/ui/hr_l10n.dart';
import 'package:flipper_hr/features/ui/hr_ui.dart';
import 'package:flipper_localize/flipper_localize.dart';
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
            _Greeting(name: identity.name, branchName: branchName, asOf: now),
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
    final l10n = context.flipperL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.hrGreetingWithName(greetingFor(asOf, l10n), firstNameOf(name)),
          style: HrType.display,
        ),
        const SizedBox(height: 4),
        Text(
          [
            formatLongDate(asOf, l10n),
            if (branchName != null && branchName!.isNotEmpty) branchName!,
          ].join(' · '),
          style: HrType.caption,
        ),
      ],
    );
  }
}

/// "Good morning" / "Good afternoon" / "Good evening", by local hour.
String greetingFor(DateTime asOf, [FlipperAppLocalizations? l10n]) {
  final t = l10n ?? FlipperL10n.current;
  if (asOf.hour < 12) return t.hrGoodMorning;
  if (asOf.hour < 18) return t.hrGoodAfternoon;
  return t.hrGoodEvening;
}

/// The part of a name a greeting uses. Falls back to the whole thing.
String firstNameOf(String name) {
  final first = name.trim().split(RegExp(r'\s+')).firstOrNull ?? '';
  return first.isEmpty ? name : first;
}

/// `Wednesday, 19 August` — the date a person would say out loud.
///
/// Written out rather than taken from `intl`: a dashboard heading is not worth
/// a dependency that has to be initialised per locale (and `intl` has no
/// Kinyarwanda date symbols at all).
String formatLongDate(DateTime date, [FlipperAppLocalizations? l10n]) {
  final t = l10n ?? FlipperL10n.current;
  return t.hrLongDate(
    hrWeekdayName(t, date.weekday),
    '${date.day}',
    hrMonthName(t, date.month),
  );
}

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
    final l10n = context.flipperL10n;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        FilledButton.icon(
          key: const Key('hr-overview-add-person'),
          onPressed: onAddPerson,
          style: hrPrimaryButtonStyle(),
          icon: const Icon(Icons.person_add_alt_1, size: 17),
          label: Text(l10n.hrAddAPerson),
        ),
        OutlinedButton.icon(
          key: const Key('hr-overview-review'),
          onPressed: onReview,
          style: hrSecondaryButtonStyle(),
          icon: const Icon(Icons.fact_check_outlined, size: 17),
          label: Text(
            pendingCount == 0
                ? l10n.hrApprovals
                : l10n.hrReviewRequests(pendingCount),
          ),
        ),
        OutlinedButton.icon(
          onPressed: onAttendance,
          style: hrSecondaryButtonStyle(),
          icon: const Icon(Icons.schedule_outlined, size: 17),
          label: Text(l10n.hrAttendanceBoard),
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
    final l10n = context.flipperL10n;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        HrStatTile(
          key: const Key('hr-overview-headcount'),
          label: l10n.hrHeadcount,
          value: n(summary.headcount),
          icon: Icons.groups_outlined,
          hint: loading ? null : l10n.hrActiveCount('${summary.active}'),
          onTap: onOpenRoster,
        ),
        HrStatTile(
          label: l10n.hrOnLeave,
          value: n(summary.onLeave),
          icon: Icons.beach_access_outlined,
          tone: summary.onLeave > 0 ? HrTone.warning : HrTone.neutral,
          onTap: onOpenRoster,
        ),
        HrStatTile(
          key: const Key('hr-overview-pending'),
          label: l10n.hrWaitingOnYou,
          value: loading ? '—' : '$pendingCount',
          icon: Icons.pending_actions_outlined,
          tone: pendingCount > 0 ? HrTone.danger : HrTone.positive,
          hint: pendingCount > 0 ? l10n.hrNeedsADecision : l10n.hrAllClear,
          onTap: onOpenApprovals,
        ),
        HrStatTile(
          label: l10n.hrNewThisMonth,
          value: n(summary.newThisMonth),
          icon: Icons.auto_awesome_outlined,
          tone: HrTone.positive,
          onTap: onOpenRoster,
        ),
        HrStatTile(
          label: l10n.hrMonthlyPayroll,
          value: loading
              ? '—'
              : formatCompactMoney(summary.monthlyPayroll, summary.currency),
          icon: Icons.payments_outlined,
          hint: loading ? null : l10n.hrEstimated,
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
    final l10n = context.flipperL10n;
    return HrPanel(
      key: const Key('hr-overview-needs-you'),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HrSectionHeader(
            title: l10n.hrNeedsYourDecision,
            subtitle: l10n.hrNeedsYourDecisionSubtitle,
            count: pending.value?.length,
            actionLabel: l10n.hrOpenQueue,
            onAction: onOpenQueue,
          ),
          const SizedBox(height: 8),
          ...switch (pending) {
            AsyncError() => [
              HrEmptyState(
                icon: Icons.cloud_off_outlined,
                message: l10n.hrCouldNotLoadApprovalsQueue,
                actionLabel: l10n.hrTryAgain,
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
      return [
        HrEmptyState(
          icon: Icons.check_circle_outline,
          message: context.flipperL10n.hrNothingWaitingOnYou,
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
            child: Text(
              context.flipperL10n.hrMoreWaiting(
                '${requests.length - shown.length}',
              ),
            ),
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
    final l10n = context.flipperL10n;
    final name =
        employee?.fullName ?? l10n.hrEmployeeWithId(request.employeeId);

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
                    '${hrDayCount(l10n, request.days)}',
                    style: HrType.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            HrPill(label: LeaveStatus.pending.label, tone: HrTone.warning),
          ],
        ),
      ),
    );
  }
}

/// `19 Aug – 23 Aug`, collapsing a single day to just itself.
String formatShortRange(DateTime start, DateTime end) {
  final t = FlipperL10n.current;
  String one(DateTime d) => '${d.day} ${hrMonthShortName(t, d.month)}';
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
            title: context.flipperL10n.hrOutToday,
            count: out.isEmpty ? null : out.length,
            actionLabel: context.flipperL10n.hrRoster,
            onAction: onOpenRoster,
          ),
          const SizedBox(height: 8),
          if (out.isEmpty)
            HrEmptyState(
              icon: Icons.wb_sunny_outlined,
              message: context.flipperL10n.hrEveryoneIsInToday,
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
            title: context.flipperL10n.hrJoinedThisMonth,
            count: joiners.isEmpty ? null : joiners.length,
            actionLabel: context.flipperL10n.hrRoster,
            onAction: onOpenRoster,
          ),
          const SizedBox(height: 8),
          if (joiners.isEmpty)
            HrEmptyState(
              icon: Icons.person_add_alt_outlined,
              message: context.flipperL10n.hrNobodyNewThisMonth,
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
