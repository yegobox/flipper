import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/employee_validation.dart';
import 'package:flipper_hr/features/people/data/money_format.dart';
import 'package:flipper_hr/features/people/data/supabase_employee_repository.dart'
    show rlsViolationCode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Add / edit form for one person.
///
/// Holds the draft locally and reports the finished record through [onSubmit];
/// it never touches a repository itself, which keeps it usable from a dialog, a
/// sheet or a test with nothing but a callback.
class EmployeeForm extends StatefulWidget {
  const EmployeeForm({
    super.key,
    required this.initial,
    required this.today,
    required this.onSubmit,
    this.onCancel,
    this.onDiagnose,
  });

  final Employee initial;

  /// Injected clock, so "cannot start more than a year ahead" is testable.
  final DateTime today;

  /// Persists the record. Throwing shows the message in the form's error banner
  /// and keeps the form open with the user's input intact.
  final Future<void> Function(Employee employee) onSubmit;

  final VoidCallback? onCancel;

  /// Opens the access diagnostic. Offered only for a permission failure, where
  /// the cause is on the server and nothing the user types will fix it.
  final VoidCallback? onDiagnose;

  @override
  State<EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  late Employee _draft;
  late final Map<String, TextEditingController> _controllers;

  Map<EmployeeField, String> _errors = const {};
  bool _submitted = false;
  bool _saving = false;
  String? _saveError;

  @override
  void initState() {
    super.initState();
    _draft = widget.initial;
    _controllers = {
      'firstName': TextEditingController(text: _draft.firstName),
      'lastName': TextEditingController(text: _draft.lastName),
      'phone': TextEditingController(text: _draft.phone),
      'email': TextEditingController(text: _draft.email),
      'jobTitle': TextEditingController(text: _draft.jobTitle),
      'department': TextEditingController(text: _draft.department),
      'nationalId': TextEditingController(text: _draft.nationalId),
      'rssbNumber': TextEditingController(text: _draft.rssbNumber),
      'baseSalary': TextEditingController(
        text: _draft.baseSalary == 0 ? '' : formatNumber(_draft.baseSalary),
      ),
      'momoPhone': TextEditingController(text: _draft.momoPhone),
      'bankName': TextEditingController(text: _draft.bankName),
      'bankAccount': TextEditingController(text: _draft.bankAccount),
      'notes': TextEditingController(text: _draft.notes),
    };
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _update(Employee Function(Employee) change) {
    setState(() {
      _draft = change(_draft);
      // Errors only appear after the first save attempt, then update live so
      // fixing a field clears its message immediately.
      if (_submitted) {
        _errors = validateEmployee(_draft, today: widget.today);
      }
    });
  }

  Future<void> _save() async {
    final errors = validateEmployee(_draft, today: widget.today);
    setState(() {
      _submitted = true;
      _errors = errors;
      _saveError = null;
    });
    if (errors.isNotEmpty) return;

    setState(() => _saving = true);
    try {
      await widget.onSubmit(_draft);
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _saveError = _messageOf(e);
        });
      }
      return;
    }
    if (mounted) setState(() => _saving = false);
  }

  String _messageOf(Object error) =>
      error.toString().replaceFirst('EmployeeRepositoryException: ', '')
      .replaceFirst('Exception: ', '');

  Future<void> _pickDate({
    required DateTime? current,
    required ValueChanged<DateTime> onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? widget.today,
      firstDate: DateTime(widget.today.year - 60),
      lastDate: DateTime(widget.today.year + 5),
    );
    if (picked != null) onPicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNarrow = MediaQuery.sizeOf(context).width < 720;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 12, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _draft.isPersisted ? 'Edit person' : 'Add a person',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              IconButton(
                key: const Key('employee-form-close'),
                tooltip: 'Close',
                onPressed: _saving ? null : widget.onCancel,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_saveError != null) ...[
                  _ErrorBanner(
                    message: _saveError!,
                    onDiagnose:
                        _saveError!.contains(rlsViolationCode) ? widget.onDiagnose : null,
                  ),
                  const SizedBox(height: 16),
                ],
                _Section(
                  title: 'Identity',
                  children: [
                    _pair(
                      isNarrow,
                      _text(
                        fieldKey: 'firstName',
                        label: 'First name',
                        field: EmployeeField.firstName,
                        onChanged: (v) => _update((d) => d.copyWith(firstName: v)),
                      ),
                      _text(
                        fieldKey: 'lastName',
                        label: 'Last name',
                        field: EmployeeField.lastName,
                        onChanged: (v) => _update((d) => d.copyWith(lastName: v)),
                      ),
                    ),
                    _pair(
                      isNarrow,
                      _text(
                        fieldKey: 'phone',
                        label: 'Phone',
                        field: EmployeeField.phone,
                        keyboardType: TextInputType.phone,
                        onChanged: (v) => _update((d) => d.copyWith(phone: v)),
                      ),
                      _text(
                        fieldKey: 'email',
                        label: 'Email (optional)',
                        field: EmployeeField.email,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (v) => _update((d) => d.copyWith(email: v)),
                      ),
                    ),
                    _pair(
                      isNarrow,
                      _text(
                        fieldKey: 'nationalId',
                        label: 'National ID (optional)',
                        field: EmployeeField.nationalId,
                        keyboardType: TextInputType.number,
                        onChanged: (v) =>
                            _update((d) => d.copyWith(nationalId: v)),
                      ),
                      _text(
                        fieldKey: 'rssbNumber',
                        label: 'RSSB number (optional)',
                        onChanged: (v) =>
                            _update((d) => d.copyWith(rssbNumber: v)),
                      ),
                    ),
                  ],
                ),
                _Section(
                  title: 'Role',
                  children: [
                    _pair(
                      isNarrow,
                      _text(
                        fieldKey: 'jobTitle',
                        label: 'Job title',
                        field: EmployeeField.jobTitle,
                        onChanged: (v) =>
                            _update((d) => d.copyWith(jobTitle: v)),
                      ),
                      _text(
                        fieldKey: 'department',
                        label: 'Department (optional)',
                        onChanged: (v) =>
                            _update((d) => d.copyWith(department: v)),
                      ),
                    ),
                    _pair(
                      isNarrow,
                      DropdownButtonFormField<EmploymentType>(
                        key: const Key('employee-type'),
                        initialValue: _draft.type,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Employment type',
                        ),
                        items: [
                          for (final t in EmploymentType.values)
                            DropdownMenuItem(value: t, child: Text(t.label)),
                        ],
                        onChanged: (v) => v == null
                            ? null
                            : _update((d) => d.copyWith(type: v)),
                      ),
                      DropdownButtonFormField<EmploymentStatus>(
                        key: const Key('employee-status'),
                        initialValue: _draft.status,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'Status'),
                        items: [
                          for (final s in EmploymentStatus.values)
                            DropdownMenuItem(value: s, child: Text(s.label)),
                        ],
                        onChanged: (v) => v == null
                            ? null
                            : _update((d) => d.copyWith(status: v)),
                      ),
                    ),
                    _pair(
                      isNarrow,
                      _DateField(
                        fieldKey: const Key('employee-hire-date'),
                        label: 'Start date',
                        value: _draft.hireDate,
                        error: _errors[EmployeeField.hireDate],
                        onTap: () => _pickDate(
                          current: _draft.hireDate,
                          onPicked: (d) =>
                              _update((draft) => draft.copyWith(hireDate: d)),
                        ),
                      ),
                      _DateField(
                        fieldKey: const Key('employee-end-date'),
                        label: 'Last day (optional)',
                        value: _draft.endDate,
                        error: _errors[EmployeeField.endDate],
                        onTap: () => _pickDate(
                          current: _draft.endDate,
                          onPicked: (d) =>
                              _update((draft) => draft.copyWith(endDate: d)),
                        ),
                        onClear: _draft.endDate == null
                            ? null
                            : () => _update(
                                (draft) => draft.copyWith(clearEndDate: true),
                              ),
                      ),
                    ),
                  ],
                ),
                _Section(
                  title: 'Pay',
                  children: [
                    _pair(
                      isNarrow,
                      _text(
                        fieldKey: 'baseSalary',
                        label: 'Base pay (${_draft.currency})',
                        field: EmployeeField.baseSalary,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9.,]'),
                          ),
                        ],
                        onChanged: (v) => _update(
                          (d) => d.copyWith(baseSalary: _parseAmount(v)),
                        ),
                      ),
                      DropdownButtonFormField<PayFrequency>(
                        key: const Key('employee-pay-frequency'),
                        initialValue: _draft.payFrequency,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Pay frequency',
                        ),
                        items: [
                          for (final f in PayFrequency.values)
                            DropdownMenuItem(value: f, child: Text(f.label)),
                        ],
                        onChanged: (v) => v == null
                            ? null
                            : _update((d) => d.copyWith(payFrequency: v)),
                      ),
                    ),
                    DropdownButtonFormField<PaymentMethod>(
                      key: const Key('employee-payment-method'),
                      initialValue: _draft.paymentMethod,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Paid by',
                      ),
                      items: [
                        for (final m in PaymentMethod.values)
                          DropdownMenuItem(value: m, child: Text(m.label)),
                      ],
                      onChanged: (v) => v == null
                          ? null
                          : _update((d) => d.copyWith(paymentMethod: v)),
                    ),
                    if (_draft.paymentMethod == PaymentMethod.mobileMoney)
                      _text(
                        fieldKey: 'momoPhone',
                        label: 'Mobile money number',
                        field: EmployeeField.momoPhone,
                        keyboardType: TextInputType.phone,
                        helper: 'Leave blank to pay the contact number above',
                        onChanged: (v) =>
                            _update((d) => d.copyWith(momoPhone: v)),
                      ),
                    if (_draft.paymentMethod == PaymentMethod.bankTransfer)
                      _pair(
                        isNarrow,
                        _text(
                          fieldKey: 'bankName',
                          label: 'Bank',
                          field: EmployeeField.bankName,
                          onChanged: (v) =>
                              _update((d) => d.copyWith(bankName: v)),
                        ),
                        _text(
                          fieldKey: 'bankAccount',
                          label: 'Account number',
                          field: EmployeeField.bankAccount,
                          onChanged: (v) =>
                              _update((d) => d.copyWith(bankAccount: v)),
                        ),
                      ),
                  ],
                ),
                _Section(
                  title: 'Notes',
                  children: [
                    _text(
                      fieldKey: 'notes',
                      label: 'Notes (optional)',
                      maxLines: 3,
                      onChanged: (v) => _update((d) => d.copyWith(notes: v)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _saving ? null : widget.onCancel,
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 12),
              FilledButton(
                key: const Key('employee-form-save'),
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_draft.isPersisted ? 'Save changes' : 'Add person'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Two fields side by side on wide layouts, stacked when narrow.
  Widget _pair(bool isNarrow, Widget left, Widget right) {
    if (isNarrow) {
      return Column(
        children: [
          left,
          const SizedBox(height: 12),
          right,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }

  Widget _text({
    required String fieldKey,
    required String label,
    required ValueChanged<String> onChanged,
    EmployeeField? field,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? helper,
    int maxLines = 1,
  }) {
    return TextField(
      key: Key('employee-$fieldKey'),
      controller: _controllers[fieldKey],
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        helperText: helper,
        errorText: field == null ? null : _errors[field],
      ),
    );
  }
}

/// Accepts `1,250,000` and `1250000.50` alike; anything unparseable reads as 0
/// so validation — not a format exception — reports the problem.
double _parseAmount(String raw) =>
    double.tryParse(raw.replaceAll(',', '').trim()) ?? 0;

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          for (final child in children) ...[
            child,
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.fieldKey,
    required this.label,
    required this.value,
    required this.onTap,
    this.error,
    this.onClear,
  });

  final Key fieldKey;
  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final String? error;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: fieldKey,
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: error,
          suffixIcon: onClear == null
              ? const Icon(Icons.calendar_today_outlined, size: 18)
              : IconButton(
                  tooltip: 'Clear',
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: onClear,
                ),
        ),
        child: Text(value == null ? '—' : formatShortDate(value!)),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, this.onDiagnose});

  final String message;
  final VoidCallback? onDiagnose;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: scheme.onErrorContainer, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(color: scheme.onErrorContainer),
                ),
                if (onDiagnose != null)
                  TextButton(
                    key: const Key('employee-form-diagnose'),
                    onPressed: onDiagnose,
                    child: const Text('Why was this denied?'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
