import 'package:flipper_hr/features/leave/data/leave_balance.dart';
import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flipper_hr/features/leave/data/leave_type.dart';
import 'package:flipper_hr/features/leave/data/leave_validation.dart';
import 'package:flipper_hr/features/leave/data/leave_working_days.dart';
import 'package:flipper_hr/features/people/data/money_format.dart';
import 'package:flutter/material.dart';

/// Books leave: type, dates, reason — with the cost and the resulting balance
/// shown before it is sent.
///
/// The day count and the remaining balance update as the dates change, so the
/// answer to "can I afford this?" is on screen before submitting rather than in
/// the rejection afterwards. Both are computed with the same functions the
/// validator and the repository use, so what is previewed is what is stored.
class LeaveRequestForm extends StatefulWidget {
  const LeaveRequestForm({
    super.key,
    required this.today,
    required this.existing,
    required this.onSubmit,
    required this.onCancel,
    this.annualOverride,
    this.employeeName,
  });

  /// Injected rather than read from the clock, so the preview, the validation and
  /// the tests all agree on what "today" is.
  final DateTime today;

  /// The person's other requests — the overlap and balance checks read these.
  final List<LeaveRequest> existing;

  /// Contract annual entitlement, when it differs from the statutory default.
  final double? annualOverride;

  /// Set when a manager is filing on someone's behalf, so the form says whose
  /// leave this is.
  final String? employeeName;

  /// Called with a validated draft. The dialog stays open until it completes, so
  /// a failure can be shown against the form rather than behind it.
  final Future<void> Function({
    required LeaveType type,
    required DateTime start,
    required DateTime end,
    required String reason,
  })
  onSubmit;

  final VoidCallback onCancel;

  @override
  State<LeaveRequestForm> createState() => _LeaveRequestFormState();
}

class _LeaveRequestFormState extends State<LeaveRequestForm> {
  final _reasonController = TextEditingController();

  LeaveType _type = LeaveType.annual;
  late DateTime _start;
  late DateTime _end;

  bool _isSubmitting = false;
  List<String> _problems = const [];

  @override
  void initState() {
    super.initState();
    // Defaults to the next working day: leave that starts on a Saturday costs
    // nothing and is almost always a mis-click.
    _start = _nextWorkingDay(widget.today);
    _end = _start;
    _reasonController.addListener(_clearProblems);
  }

  @override
  void dispose() {
    _reasonController.removeListener(_clearProblems);
    _reasonController.dispose();
    super.dispose();
  }

  void _clearProblems() {
    if (_problems.isNotEmpty) setState(() => _problems = const []);
  }

  double get _days =>
      leaveDaysFor(type: _type, start: _start, end: _end);

  LeaveBalance get _balance => LeaveBalance.of(
    type: _type,
    year: _start.year,
    requests: widget.existing,
    annualOverride: widget.annualOverride,
  );

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? _start : _end;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      // Matches what the validator will accept, so the picker cannot offer a
      // date the form is about to reject.
      firstDate: widget.today.subtract(
        const Duration(days: maxBackdatedLeaveDays),
      ),
      lastDate: widget.today.add(const Duration(days: maxLeaveNoticeDays)),
    );
    if (picked == null) return;
    setState(() {
      _problems = const [];
      if (isStart) {
        _start = picked;
        // Dragging the start past the end collapses the range rather than
        // inverting it — an inverted range is only ever a mistake.
        if (_end.isBefore(_start)) _end = _start;
      } else {
        _end = picked;
        if (_end.isBefore(_start)) _start = _end;
      }
    });
  }

  Future<void> _submit() async {
    final draft = LeaveRequest(
      employeeId: '',
      type: _type,
      startDate: _start,
      endDate: _end,
      days: _days,
      reason: _reasonController.text,
    );
    final problems = validateLeaveRequest(
      request: draft,
      today: widget.today,
      existing: widget.existing,
      annualOverride: widget.annualOverride,
    );
    if (problems.isNotEmpty) {
      setState(() => _problems = problems);
      return;
    }

    setState(() {
      _problems = const [];
      _isSubmitting = true;
    });
    try {
      await widget.onSubmit(
        type: _type,
        start: _start,
        end: _end,
        reason: _reasonController.text.trim(),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _problems = [_messageOf(e)]);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final balance = _balance;
    final days = _days;
    final remaining = balance.remaining;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.employeeName == null
                  ? 'Request leave'
                  : 'Leave for ${widget.employeeName}',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<LeaveType>(
              key: const Key('leave-type-field'),
              initialValue: _type,
              decoration: const InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final type in LeaveType.bookable)
                  DropdownMenuItem(value: type, child: Text(type.label)),
              ],
              onChanged: (value) => setState(() {
                _type = value ?? LeaveType.annual;
                _problems = const [];
              }),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _DateField(
                    fieldKey: const Key('leave-start-field'),
                    label: 'First day',
                    value: _start,
                    onTap: () => _pickDate(isStart: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateField(
                    fieldKey: const Key('leave-end-field'),
                    label: 'Last day',
                    value: _end,
                    onTap: () => _pickDate(isStart: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _CostPreview(
              days: days,
              type: _type,
              remainingAfter: remaining == null ? null : remaining - days,
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('leave-reason-field'),
              controller: _reasonController,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: _type == LeaveType.annual
                    ? 'Note (optional)'
                    : 'Reason',
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            if (_problems.isNotEmpty) ...[
              const SizedBox(height: 16),
              _Problems(problems: _problems),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isSubmitting ? null : widget.onCancel,
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  key: const Key('leave-submit'),
                  onPressed: _isSubmitting ? null : _submit,
                  child: Text(_isSubmitting ? 'Sending…' : 'Send request'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Skips forward over a weekend. Leaves a weekday where it is.
  static DateTime _nextWorkingDay(DateTime from) {
    var day = DateTime(from.year, from.month, from.day);
    while (isWeekend(day)) {
      day = DateTime(day.year, day.month, day.day + 1);
    }
    return day;
  }

  static String _messageOf(Object error) =>
      error.toString().replaceFirst('Exception: ', '');
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.fieldKey,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final Key fieldKey;
  final String label;
  final DateTime value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: fieldKey,
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
        ),
        child: Text(formatShortDate(value)),
      ),
    );
  }
}

/// What this request costs and what it leaves. Shown before submitting, because
/// "how many days is that?" is the question every leave form fails to answer.
class _CostPreview extends StatelessWidget {
  const _CostPreview({
    required this.days,
    required this.type,
    required this.remainingAfter,
  });

  final double days;
  final LeaveType type;

  /// Balance once this request is counted, or null for an uncapped type.
  final double? remainingAfter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final short = remainingAfter != null && remainingAfter! < 0;

    return Container(
      key: const Key('leave-cost-preview'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: short ? scheme.errorContainer : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            short ? Icons.error_outline : Icons.event_available_outlined,
            size: 18,
            color: short ? scheme.onErrorContainer : scheme.onSurfaceVariant,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _text(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: short
                    ? scheme.onErrorContainer
                    : scheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _text() {
    final unit = type.countsCalendarDays ? 'calendar days' : 'working days';
    final cost = '${formatLeaveDays(days)} ($unit)';
    final left = remainingAfter;
    if (left == null) return '$cost · unpaid leave has no yearly limit';
    if (left < 0) {
      return '$cost · ${formatLeaveDays(-left)} more than you have left';
    }
    return '$cost · ${formatLeaveDays(left)} left after this';
  }
}

class _Problems extends StatelessWidget {
  const _Problems({required this.problems});

  final List<String> problems;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      key: const Key('leave-problems'),
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final problem in problems)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                problem,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
