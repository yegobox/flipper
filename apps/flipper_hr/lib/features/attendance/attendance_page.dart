import 'package:flipper_hr/features/attendance/data/attendance_day.dart';
import 'package:flipper_hr/features/attendance/data/attendance_format.dart';
import 'package:flipper_hr/features/attendance/data/attendance_providers.dart';
import 'package:flipper_hr/features/attendance/data/attendance_session.dart';
import 'package:flipper_hr/features/attendance/widgets/attendance_state_chip.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The branch attendance board for one day: who is in, since when, and how long.
///
/// Rows come from the ROSTER, not from the attendance rows, so someone who has
/// not clocked in appears as "Not in" rather than being invisible. A board that
/// only listed people with sessions would answer "who worked?" while hiding
/// "who is missing?", which is the question a manager opens it for.
///
/// Elapsed time for an open session is computed at build from [hrClockProvider]
/// rather than ticked by a timer: a timer that never settles makes every widget
/// test using this page hang, and a minute's staleness on a figure like "2h 14m"
/// is not worth that.
class AttendancePage extends ConsumerStatefulWidget {
  const AttendancePage({
    super.key,
    required this.businessId,
    required this.branchId,
    this.branchName,
  });

  final String businessId;
  final String branchId;
  final String? branchName;

  @override
  ConsumerState<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends ConsumerState<AttendancePage> {
  /// Null means "today", resolved at build so the page does not go stale over
  /// midnight while open.
  DateTime? _pickedDate;

  DateTime get _date => _pickedDate ?? dateOnly(ref.read(hrClockProvider)());

  bool _busy = false;

  Future<void> _pickDate() async {
    final today = dateOnly(ref.read(hrClockProvider)());
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(today.year - 2),
      // No future days: there are no hours to show, and picking one looks broken.
      lastDate: today,
    );
    if (picked != null) setState(() => _pickedDate = dateOnly(picked));
  }

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

  Future<void> _clockIn(Employee employee) => _run(() async {
    await ref.read(attendanceActionsProvider).clockIn(
      employeeId: employee.id,
      source: AttendanceSource.manager,
    );
    if (mounted) _toast('${employee.fullName} is clocked in.');
  });

  Future<void> _clockOut(Employee employee, AttendanceSession session) =>
      _run(() async {
        await ref.read(attendanceActionsProvider).clockOut(session: session);
        if (mounted) _toast('${employee.fullName} is clocked out.');
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
      .replaceFirst('Exception: ', '');

  @override
  Widget build(BuildContext context) {
    final now = ref.watch(hrClockProvider)();
    final date = _pickedDate ?? dateOnly(now);
    final roster = ref.watch(rosterProvider(widget.branchId));
    final attendance = ref.watch(
      branchAttendanceProvider(
        BranchDay(branchId: widget.branchId, date: date),
      ),
    );

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              sliver: SliverToBoxAdapter(
                child: _Header(
                  branchName: widget.branchName,
                  date: date,
                  isToday: isSameDate(date, now),
                  onPickDate: _pickDate,
                  onToday: () => setState(() => _pickedDate = null),
                ),
              ),
            ),
            ...switch ((roster, attendance)) {
          (AsyncError(:final error), _) => [
            _fill(_Message(message: _messageOf(error), onRetry: () {
              ref.invalidate(rosterProvider(widget.branchId));
            })),
          ],
          (_, AsyncError(:final error)) => [
            _fill(_Message(message: _messageOf(error), onRetry: () {
              ref.invalidate(
                branchAttendanceProvider(
                  BranchDay(branchId: widget.branchId, date: date),
                ),
              );
            })),
          ],
          (AsyncData(value: final people), AsyncData(value: final sessions)) =>
            _board(people: people, sessions: sessions, date: date, now: now),
          _ => [_fill(const Center(child: CircularProgressIndicator()))],
        },
      ],
        ),
      ),
    );
  }

  Widget _fill(Widget child) =>
      SliverFillRemaining(hasScrollBody: false, child: child);

  List<Widget> _board({
    required List<Employee> people,
    required List<AttendanceSession> sessions,
    required DateTime date,
    required DateTime now,
  }) {
    // Terminated people are not on the board: they have no hours to record, and
    // their history stays readable on their own timesheet.
    final onRoster = [
      for (final e in people)
        if (e.status.isEmployed) e,
    ]..sort((a, b) => a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));

    if (onRoster.isEmpty) {
      return [
        _fill(
          const _Message(
            message: 'No one is on this branch yet. Add people first, then '
                'their hours can be recorded here.',
          ),
        ),
      ];
    }

    final days = AttendanceDay.groupByEmployee(
      sessions: sessions,
      workDate: date,
      asOf: now,
    );
    final present = days.values.where((d) => d.isClockedIn).length;
    final worked = totalMinutes(sessions: sessions, asOf: now);

    return [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        sliver: SliverToBoxAdapter(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _Tile(label: 'On roster', value: '${onRoster.length}'),
              _Tile(label: 'Clocked in', value: '$present'),
              _Tile(
                label: 'Recorded',
                value: '${days.values.where((d) => d.sessions.isNotEmpty).length}',
              ),
              _Tile(label: 'Hours', value: formatWorkedMinutes(worked)),
            ],
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        sliver: SliverList.separated(
          itemCount: onRoster.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final employee = onRoster[index];
            return _BoardRow(
              key: Key('attendance-row-${employee.id}'),
              employee: employee,
              day: days[employee.id],
              busy: _busy,
              onClockIn: () => _clockIn(employee),
              onClockOut: (session) => _clockOut(employee, session),
            );
          },
        ),
      ),
    ];
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.branchName,
    required this.date,
    required this.isToday,
    required this.onPickDate,
    required this.onToday,
  });

  final String? branchName;
  final DateTime date;
  final bool isToday;
  final VoidCallback onPickDate;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Attendance', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                branchName == null
                    ? formatDayLabel(date)
                    : '${formatDayLabel(date)} · $branchName',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (!isToday)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              key: const Key('attendance-today'),
              onPressed: onToday,
              child: const Text('Today'),
            ),
          ),
        OutlinedButton.icon(
          key: const Key('attendance-pick-date'),
          onPressed: onPickDate,
          icon: const Icon(Icons.calendar_today_outlined, size: 18),
          label: const Text('Change day'),
        ),
      ],
    );
  }
}

class _BoardRow extends StatelessWidget {
  const _BoardRow({
    super.key,
    required this.employee,
    required this.day,
    required this.busy,
    required this.onClockIn,
    required this.onClockOut,
  });

  final Employee employee;
  final AttendanceDay? day;
  final bool busy;
  final VoidCallback onClockIn;
  final ValueChanged<AttendanceSession> onClockOut;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = day?.state ?? AttendanceState.absent;
    final open = day?.openSession;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: theme.colorScheme.secondaryContainer,
              child: Text(
                employee.initials.isEmpty ? '?' : employee.initials,
                style: TextStyle(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.fullName,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _detail(day),
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AttendanceStateChip(state: state),
            const SizedBox(width: 8),
            if (open != null)
              OutlinedButton(
                key: Key('clock-out-${employee.id}'),
                onPressed: busy ? null : () => onClockOut(open),
                child: const Text('Clock out'),
              )
            else
              FilledButton(
                key: Key('clock-in-${employee.id}'),
                onPressed: busy ? null : onClockIn,
                child: const Text('Clock in'),
              ),
          ],
        ),
      ),
    );
  }

  /// The line under the name: what happened today, in the order a manager scans
  /// for — when they arrived, how long, and whether anything is odd.
  String _detail(AttendanceDay? day) {
    if (day == null || day.sessions.isEmpty) {
      return employee.jobTitle.isEmpty ? 'No hours today' : employee.jobTitle;
    }
    final parts = <String>[
      if (day.firstIn != null) 'In ${formatClockTime(day.firstIn!)}',
      if (day.lastOut != null) 'out ${formatClockTime(day.lastOut!)}',
      formatWorkedMinutes(day.workedMinutes),
      if (day.sessions.length > 1) '${day.sessions.length} sessions',
      if (day.hasOvernightSession) 'overnight',
    ];
    return parts.join(' · ');
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
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
                onRetry == null ? Icons.schedule : Icons.cloud_off,
                size: 40,
                color: onRetry == null
                    ? theme.colorScheme.onSurfaceVariant
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
                  key: const Key('attendance-retry'),
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
