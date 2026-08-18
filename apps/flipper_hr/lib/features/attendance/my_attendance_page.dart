import 'package:flipper_hr/features/attendance/data/attendance_day.dart';
import 'package:flipper_hr/features/attendance/data/attendance_format.dart';
import 'package:flipper_hr/features/attendance/data/attendance_providers.dart';
import 'package:flipper_hr/features/attendance/data/attendance_session.dart';
import 'package:flipper_hr/features/attendance/widgets/attendance_state_chip.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/session/data/hr_session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The signed-in person's own clock and timesheet.
///
/// Deliberately not branch-scoped: an invited employee has no business selection
/// to make, and their own record already says which branch they are on. Scope
/// comes from [myOpenSessionProvider] and [myTimesheetProvider], which resolve
/// through the session's employee ids.
///
/// Elapsed time is computed at build rather than ticked by a timer — see the note
/// on [AttendancePage].
class MyAttendancePage extends ConsumerStatefulWidget {
  const MyAttendancePage({super.key});

  @override
  ConsumerState<MyAttendancePage> createState() => _MyAttendancePageState();
}

class _MyAttendancePageState extends ConsumerState<MyAttendancePage> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted) _toast(_messageOf(e), isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _clockIn(String employeeId) => _run(() async {
    await ref.read(attendanceActionsProvider).clockIn(employeeId: employeeId);
    if (mounted) _toast('Clocked in.');
  });

  Future<void> _clockOut(AttendanceSession session) => _run(() async {
    final saved = await ref
        .read(attendanceActionsProvider)
        .clockOut(session: session);
    if (mounted) {
      _toast('Clocked out — ${formatWorkedMinutes(saved.minutes ?? 0)} today.');
    }
  });

  void _toast(String message, {bool isError = false}) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }

  String _messageOf(Object error) => error
      .toString()
      .replaceFirst('AttendanceRepositoryException: ', '')
      .replaceFirst('HrSessionException: ', '')
      .replaceFirst('Exception: ', '');

  @override
  Widget build(BuildContext context) {
    final now = ref.watch(hrClockProvider)();
    final employee = ref.watch(myEmployeeProvider);
    final open = ref.watch(myOpenSessionProvider);
    final timesheet = ref.watch(myTimesheetProvider);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My time', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  'Your hours for the last $timesheetWindowDays days.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        ...switch ((employee, open, timesheet)) {
          (AsyncError(:final error), _, _) ||
          (_, AsyncError(:final error), _) ||
          (_, _, AsyncError(:final error)) => [
            SliverFillRemaining(
              hasScrollBody: false,
              child: _Message(
                message: _messageOf(error),
                onRetry: () {
                  ref.invalidate(myOpenSessionProvider);
                  ref.invalidate(myTimesheetProvider);
                },
              ),
            ),
          ],
          (
            AsyncData(value: final me),
            AsyncData(value: final openSession),
            AsyncData(value: final sessions),
          ) =>
            me == null
                ? [
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _Message(
                        message: 'You do not have an employee record on this '
                            'account yet, so there are no hours to track. Ask '
                            'whoever manages HR to add you.',
                      ),
                    ),
                  ]
                : _timesheet(
                    employeeId: me.id,
                    openSession: openSession,
                    sessions: sessions,
                    now: now,
                  ),
          _ => [
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        },
      ],
    );
  }

  List<Widget> _timesheet({
    required String employeeId,
    required AttendanceSession? openSession,
    required List<AttendanceSession> sessions,
    required DateTime now,
  }) {
    final today = dateOnly(now);
    final todayDay = AttendanceDay(
      employeeId: employeeId,
      workDate: today,
      sessions: [
        for (final s in sessions)
          if (isSameDate(s.workDate, today)) s,
      ],
      asOf: now,
    );
    final windowMinutes = totalMinutes(sessions: sessions, asOf: now);
    // Newest first, and today is always shown even when it has no sessions yet.
    final dates = AttendanceDay.datesOf(sessions);
    if (!dates.any((d) => isSameDate(d, today))) dates.insert(0, today);

    return [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        sliver: SliverToBoxAdapter(
          child: _ClockCard(
            day: todayDay,
            openSession: openSession,
            busy: _busy,
            asOf: now,
            windowMinutes: windowMinutes,
            onClockIn: () => _clockIn(employeeId),
            onClockOut: () => _clockOut(openSession!),
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        sliver: SliverToBoxAdapter(
          child: Text(
            'RECENT DAYS',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        sliver: SliverList.separated(
          itemCount: dates.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final date = dates[index];
            final day = AttendanceDay(
              employeeId: employeeId,
              workDate: date,
              sessions: [
                for (final s in sessions)
                  if (isSameDate(s.workDate, date)) s,
              ],
              asOf: now,
            );
            return _DayRow(
              key: Key('timesheet-day-${date.toIso8601String()}'),
              day: day,
              isToday: isSameDate(date, today),
            );
          },
        ),
      ),
    ];
  }
}

class _ClockCard extends StatelessWidget {
  const _ClockCard({
    required this.day,
    required this.openSession,
    required this.busy,
    required this.asOf,
    required this.windowMinutes,
    required this.onClockIn,
    required this.onClockOut,
  });

  final AttendanceDay day;
  final AttendanceSession? openSession;
  final bool busy;
  final DateTime asOf;
  final int windowMinutes;
  final VoidCallback onClockIn;
  final VoidCallback onClockOut;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIn = openSession != null;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AttendanceStateChip(state: day.state),
                const Spacer(),
                Text(
                  formatDayLabel(day.workDate),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              formatWorkedMinutes(day.workedMinutes),
              key: const Key('my-attendance-today-total'),
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isIn
                  ? 'Clocked in at ${formatClockTime(openSession!.startedAt)}'
                  : day.sessions.isEmpty
                      ? 'Not clocked in today'
                      : 'Last out at ${formatClockTime(day.lastOut!)}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                if (isIn)
                  FilledButton.icon(
                    key: const Key('my-attendance-clock-out'),
                    onPressed: busy ? null : onClockOut,
                    icon: const Icon(Icons.logout),
                    label: const Text('Clock out'),
                  )
                else
                  FilledButton.icon(
                    key: const Key('my-attendance-clock-in'),
                    onPressed: busy ? null : onClockIn,
                    icon: const Icon(Icons.login),
                    label: const Text('Clock in'),
                  ),
                const Spacer(),
                Text(
                  '${formatWorkedMinutes(windowMinutes)} in $timesheetWindowDays days',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({super.key, required this.day, required this.isToday});

  final AttendanceDay day;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        title: Row(
          children: [
            Text(isToday ? 'Today' : formatDayLabel(day.workDate)),
            if (day.hasOvernightSession) ...[
              const SizedBox(width: 8),
              Text(
                'overnight',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(_detail(day)),
        trailing: Text(
          formatWorkedMinutes(day.workedMinutes),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  String _detail(AttendanceDay day) {
    if (day.sessions.isEmpty) return 'No hours';
    final parts = <String>[
      for (final s in day.sessions)
        s.endedAt == null
            ? '${formatClockTime(s.startedAt)} – now'
            : '${formatClockTime(s.startedAt)} – ${formatClockTime(s.endedAt!)}',
    ];
    final breaks = day.breakMinutes;
    if (breaks != null && breaks > 0) {
      parts.add('${formatWorkedMinutes(breaks)} break');
    }
    return parts.join(' · ');
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                onRetry == null ? Icons.badge_outlined : Icons.cloud_off,
                size: 40,
                color: onRetry == null
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 16),
                FilledButton(
                  key: const Key('my-attendance-retry'),
                  onPressed: onRetry,
                  child: const Text('Try again'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
