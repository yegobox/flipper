import 'package:flipper_hr/features/invite/data/hr_invite.dart';
import 'package:flipper_hr/features/invite/widgets/invite_dialogs.dart';
import 'package:flipper_hr/features/people/data/access_diagnostics.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/money_format.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/people/data/people_query.dart';
import 'package:flipper_hr/features/people/widgets/employee_form.dart';
import 'package:flipper_hr/features/people/widgets/status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Width at which the roster switches from stacked cards to a table.
const _tableBreakpoint = 900.0;

/// HR's people directory: the roster for one branch, with search, status and
/// department filters, and add / edit / status changes.
///
/// Scope arrives as plain ids rather than through flipper_web's selection
/// providers, so this page (and its tests) never pull in the shared auth stack.
class PeoplePage extends ConsumerStatefulWidget {
  const PeoplePage({
    super.key,
    required this.businessId,
    required this.branchId,
    this.branchName,
  });

  final String businessId;
  final String branchId;
  final String? branchName;

  @override
  ConsumerState<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends ConsumerState<PeoplePage> {
  final _searchController = TextEditingController();

  /// Id of the person an invite is running for, so their row can show it. One at
  /// a time: the pipeline is three network hops and a second concurrent run
  /// against the same record would race on `user_id`.
  String? _invitingId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  DateTime get _today => ref.read(hrClockProvider)();

  Future<void> _openForm({Employee? employee}) async {
    final today = _today;
    final initial =
        employee ??
        Employee.blank(
          businessId: widget.businessId,
          branchId: widget.branchId,
          hireDate: today,
        );

    final isNarrow = MediaQuery.sizeOf(context).width < 720;
    final saved = await showDialog<Employee>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final form = EmployeeForm(
          initial: initial,
          today: today,
          onCancel: () => Navigator.of(dialogContext).pop(),
          onDiagnose: _showAccessDiagnostic,
          onSubmit: (draft) async {
            final result = await ref.read(peopleActionsProvider).save(draft);
            if (dialogContext.mounted) {
              Navigator.of(dialogContext).pop(result);
            }
          },
        );
        if (isNarrow) return Dialog.fullscreen(child: form);
        return Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720, maxHeight: 720),
            child: form,
          ),
        );
      },
    );

    if (saved != null && mounted) {
      _toast(
        employee == null
            ? '${saved.fullName} was added to the roster.'
            : 'Saved changes to ${saved.fullName}.',
      );
    }
  }

  /// Invites someone into HR: pick the role, run the pipeline, show the PIN.
  ///
  /// The PIN dialog is not skippable on success — it is the only time the
  /// credential exists in a readable form, and losing it means re-inviting.
  Future<void> _invite(Employee employee) async {
    final role = await showInviteRoleDialog(context, employee: employee);
    if (role == null || !mounted) return;

    setState(() => _invitingId = employee.id);
    try {
      final HrInvite invite;
      try {
        invite = await ref.read(peopleActionsProvider).invite(
          employee: employee,
          role: role,
        );
      } finally {
        // Cleared before the PIN dialog opens, not after it closes: the spinner
        // belongs to the network work, and leaving it spinning behind a modal
        // says the invite is still running when it has already finished.
        if (mounted) setState(() => _invitingId = null);
      }
      if (!mounted) return;
      await showInvitePinDialog(
        context,
        invite: invite,
        name: employee.fullName,
      );
    } on HrInviteException catch (e) {
      // The step is worth showing: 'linkEmployee' in particular means the invite
      // itself worked, so the reader should not try to send it again.
      if (mounted) {
        _toast(
          e.step == HrInviteStep.linkEmployee
              ? 'Invite sent, but not linked. ${e.message}'
              : e.message,
          isError: true,
        );
      }
    } catch (e) {
      if (mounted) _toast(_messageOf(e), isError: true);
    }
  }

  Future<void> _changeStatus(Employee employee, EmploymentStatus status) async {
    if (status == EmploymentStatus.terminated) {
      final confirmed = await _confirmTermination(employee);
      if (confirmed != true) return;
    }
    try {
      await ref.read(peopleActionsProvider).setStatus(
        employee: employee,
        status: status,
        // The last day is today for a termination and cleared otherwise, so a
        // reactivated person has no stale end date.
        endDate: status == EmploymentStatus.terminated ? _today : null,
      );
      if (mounted) {
        _toast('${employee.fullName} is now ${status.label.toLowerCase()}.');
      }
    } catch (e) {
      if (mounted) _toast(_messageOf(e), isError: true);
    }
  }

  Future<bool?> _confirmTermination(Employee employee) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Terminate ${employee.fullName}?'),
        content: Text(
          'Their last day will be recorded as ${formatShortDate(_today)}. '
          'The record stays for payroll history but they leave the roster.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            key: const Key('confirm-terminate'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Terminate'),
          ),
        ],
      ),
    );
  }

  /// Shows what the browser is sending and what the server resolves for it.
  /// The only way to tell an RLS predicate that excludes the row from a request
  /// that never carried a session at all.
  Future<void> _showAccessDiagnostic() async {
    final future = ref.read(accessDiagnosticsProvider).load();
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Access diagnostic'),
        content: SizedBox(
          width: 520,
          child: FutureBuilder<AccessReport>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final text = snapshot.hasError
                  ? 'Diagnostic failed: ${snapshot.error}'
                  : snapshot.data!.toReport();
              return SingleChildScrollView(
                child: SelectableText(
                  text,
                  key: const Key('access-diagnostic-report'),
                  style: const TextStyle(fontFamily: 'monospace', height: 1.5),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _toast(String message, {bool isError = false}) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error
            : null,
      ),
    );
  }

  String _messageOf(Object error) => error
      .toString()
      .replaceFirst('EmployeeRepositoryException: ', '')
      .replaceFirst('Exception: ', '');

  @override
  Widget build(BuildContext context) {
    final roster = ref.watch(rosterProvider(widget.branchId));
    final query = ref.watch(peopleQueryProvider);
    final now = ref.watch(hrClockProvider)();

    // One scroll view for the whole page: the tiles and toolbar scroll away
    // with the roster, so a narrow window never has to fit them all at once.
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          sliver: SliverToBoxAdapter(
            child: _Header(
              branchName: widget.branchName,
              onAdd: () => _openForm(),
            ),
          ),
        ),
        ...roster.when(
          loading: () => const [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
          error: (error, _) => [
            SliverFillRemaining(
              hasScrollBody: false,
              child: _RosterError(
                message: _messageOf(error),
                onRetry: () => ref.invalidate(rosterProvider(widget.branchId)),
                onDiagnose: _showAccessDiagnostic,
              ),
            ),
          ],
          data: (people) => _rosterSlivers(people: people, query: query, now: now),
        ),
      ],
    );
  }

  List<Widget> _rosterSlivers({
    required List<Employee> people,
    required PeopleQuery query,
    required DateTime now,
  }) {
    if (people.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _EmptyRoster(onAdd: () => _openForm()),
        ),
      ];
    }

    final visible = applyPeopleQuery(people, query);
    final isTable = MediaQuery.sizeOf(context).width >= _tableBreakpoint;

    return [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        sliver: SliverToBoxAdapter(
          child: _SummaryTiles(summary: PeopleSummary.from(people, asOf: now)),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
        sliver: SliverToBoxAdapter(
          child: _Toolbar(
            searchController: _searchController,
            query: query,
            departments: departmentsOf(people),
          ),
        ),
      ),
      if (visible.isEmpty)
        SliverFillRemaining(
          hasScrollBody: false,
          child: _NoMatches(
            onClear: () {
              _searchController.clear();
              ref.read(peopleQueryProvider.notifier).clear();
            },
          ),
        )
      else ...[
        if (isTable)
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(child: _TableHeader()),
          ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          sliver: SliverList.separated(
            itemCount: visible.length,
            separatorBuilder: (_, __) =>
                isTable ? const Divider(height: 1) : const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final person = visible[index];
              return _RosterRow(
                key: Key('employee-row-${person.id}'),
                employee: person,
                asOf: now,
                isTable: isTable,
                onEdit: () => _openForm(employee: person),
                onChangeStatus: (status) => _changeStatus(person, status),
                onInvite: _invitingId == null ? () => _invite(person) : null,
                isInviting: _invitingId == person.id,
              );
            },
          ),
        ),
      ],
    ];
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.branchName, required this.onAdd});

  final String? branchName;
  final VoidCallback onAdd;

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
              Text('People', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                branchName == null
                    ? 'Everyone on this branch'
                    : 'Everyone at $branchName',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        FilledButton.icon(
          key: const Key('people-add'),
          onPressed: onAdd,
          icon: const Icon(Icons.person_add_alt_1),
          label: const Text('Add person'),
        ),
      ],
    );
  }
}

class _SummaryTiles extends StatelessWidget {
  const _SummaryTiles({required this.summary});

  final PeopleSummary summary;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _Tile(label: 'Headcount', value: '${summary.headcount}'),
        _Tile(label: 'Active', value: '${summary.active}'),
        _Tile(label: 'On leave', value: '${summary.onLeave}'),
        _Tile(label: 'New this month', value: '${summary.newThisMonth}'),
        _Tile(
          label: 'Monthly payroll',
          value: formatCompactMoney(summary.monthlyPayroll, summary.currency),
        ),
      ],
    );
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
      width: 168,
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

class _Toolbar extends ConsumerWidget {
  const _Toolbar({
    required this.searchController,
    required this.query,
    required this.departments,
  });

  final TextEditingController searchController;
  final PeopleQuery query;
  final List<String> departments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(peopleQueryProvider.notifier);
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 280,
          child: TextField(
            key: const Key('people-search'),
            controller: searchController,
            onChanged: controller.setSearch,
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Search name, role, phone…',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: query.search.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        searchController.clear();
                        controller.setSearch('');
                      },
                    ),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(
          width: 180,
          child: DropdownButtonFormField<EmploymentStatus?>(
            key: const Key('people-status-filter'),
            initialValue: query.status,
            isDense: true,
            // Without this the button takes the width of its longest item and
            // overflows the fixed-width box it sits in.
            isExpanded: true,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Status',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('Employed')),
              for (final s in EmploymentStatus.values)
                DropdownMenuItem(value: s, child: Text(s.label)),
            ],
            onChanged: controller.setStatus,
          ),
        ),
        if (departments.isNotEmpty)
          SizedBox(
            width: 180,
            child: DropdownButtonFormField<String?>(
              key: const Key('people-department-filter'),
              initialValue: query.department,
              isDense: true,
              isExpanded: true,
              decoration: const InputDecoration(
                isDense: true,
                labelText: 'Department',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('All departments'),
                ),
                for (final d in departments)
                  DropdownMenuItem(value: d, child: Text(d)),
              ],
              onChanged: controller.setDepartment,
            ),
          ),
        SizedBox(
          width: 200,
          child: DropdownButtonFormField<PeopleSort>(
            key: const Key('people-sort'),
            initialValue: query.sort,
            isDense: true,
            isExpanded: true,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Sort by',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final s in PeopleSort.values)
                DropdownMenuItem(value: s, child: Text(s.label)),
            ],
            onChanged: (v) => v == null ? null : controller.setSort(v),
          ),
        ),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      letterSpacing: 1,
      fontWeight: FontWeight.w700,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text('NAME', style: style)),
          Expanded(flex: 3, child: Text('DEPARTMENT', style: style)),
          Expanded(flex: 3, child: Text('CONTACT', style: style)),
          Expanded(flex: 2, child: Text('TENURE', style: style)),
          Expanded(flex: 3, child: Text('BASE PAY', style: style)),
          Expanded(flex: 2, child: Text('STATUS', style: style)),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _RosterRow extends StatelessWidget {
  const _RosterRow({
    super.key,
    required this.employee,
    required this.asOf,
    required this.isTable,
    required this.onEdit,
    required this.onChangeStatus,
    required this.onInvite,
    this.isInviting = false,
  });

  final Employee employee;
  final DateTime asOf;
  final bool isTable;
  final VoidCallback onEdit;
  final ValueChanged<EmploymentStatus> onChangeStatus;

  /// Null while another invite is in flight — the pipeline is not safe to run
  /// twice at once, so the action is simply unavailable rather than queued.
  final VoidCallback? onInvite;

  /// True for the row whose invite is running.
  final bool isInviting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pay =
        '${formatMoney(employee.baseSalary, employee.currency)} '
        '· ${employee.payFrequency.label.toLowerCase()}';
    final tenure = formatTenure(hireDate: employee.hireDate, asOf: asOf);

    if (!isTable) {
      return Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          onTap: onEdit,
          leading: _Avatar(employee: employee),
          title: Text(employee.fullName),
          subtitle: Text(
            [
              if (employee.jobTitle.isNotEmpty) employee.jobTitle,
              if (employee.phone.isNotEmpty) employee.phone,
              pay,
            ].join(' · '),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatusChip(status: employee.status),
              _RowMenu(
                employee: employee,
                onChangeStatus: onChangeStatus,
                onInvite: onInvite,
                isInviting: isInviting,
              ),
            ],
          ),
        ),
      );
    }

    return InkWell(
      onTap: onEdit,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  _Avatar(employee: employee),
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
                          employee.jobTitle.isEmpty ? '—' : employee.jobTitle,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                employee.department.isEmpty ? '—' : employee.department,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                employee.phone.isEmpty ? '—' : employee.phone,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(flex: 2, child: Text(tenure)),
            Expanded(
              flex: 3,
              child: Text(pay, overflow: TextOverflow.ellipsis),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: StatusChip(status: employee.status),
              ),
            ),
            SizedBox(
              width: 48,
              child: _RowMenu(
                employee: employee,
                onChangeStatus: onChangeStatus,
                onInvite: onInvite,
                isInviting: isInviting,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.employee});

  final Employee employee;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return CircleAvatar(
      radius: 18,
      backgroundColor: scheme.secondaryContainer,
      child: Text(
        employee.initials.isEmpty ? '?' : employee.initials,
        style: TextStyle(
          color: scheme.onSecondaryContainer,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}

/// One row's actions: the status transitions that make sense for this person,
/// plus the HR invite.
///
/// Only sensible transitions are offered: no "mark on leave" for someone already
/// on leave, no "reactivate" for someone active, no "terminate" for someone
/// already terminated. Inviting is offered for anyone still employed — including
/// someone who already has an account, since re-inviting is how a lost PIN is
/// replaced.
class _RowMenu extends StatelessWidget {
  const _RowMenu({
    required this.employee,
    required this.onChangeStatus,
    required this.onInvite,
    this.isInviting = false,
  });

  final Employee employee;
  final ValueChanged<EmploymentStatus> onChangeStatus;
  final VoidCallback? onInvite;
  final bool isInviting;

  @override
  Widget build(BuildContext context) {
    if (isInviting) {
      // Replaces the button rather than sitting beside it: the row's actions are
      // all unavailable until the invite settles, and a spinner in the same slot
      // says so without a second affordance to explain.
      return const SizedBox(
        width: 48,
        height: 40,
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    final invite = onInvite;
    return PopupMenuButton<RosterRowAction>(
      key: Key('people-menu-${employee.id}'),
      tooltip: 'Actions',
      onSelected: (action) => switch (action) {
        RosterRowInvite() => invite?.call(),
        RosterRowStatus(:final status) => onChangeStatus(status),
      },
      itemBuilder: (context) => [
        if (employee.status.isEmployed)
          PopupMenuItem(
            key: const Key('people-menu-invite'),
            value: const RosterRowInvite(),
            enabled: invite != null,
            child: Text(
              employee.hasFlipperAccount
                  ? 'Re-send HR invite'
                  : 'Invite to HR',
            ),
          ),
        if (employee.status.isEmployed) const PopupMenuDivider(),
        if (employee.status != EmploymentStatus.active)
          const PopupMenuItem(
            value: RosterRowStatus(EmploymentStatus.active),
            child: Text('Mark active'),
          ),
        if (employee.status != EmploymentStatus.onLeave &&
            employee.status.isEmployed)
          const PopupMenuItem(
            value: RosterRowStatus(EmploymentStatus.onLeave),
            child: Text('Mark on leave'),
          ),
        if (employee.status != EmploymentStatus.suspended &&
            employee.status.isEmployed)
          const PopupMenuItem(
            value: RosterRowStatus(EmploymentStatus.suspended),
            child: Text('Suspend'),
          ),
        if (employee.status.isEmployed)
          const PopupMenuItem(
            value: RosterRowStatus(EmploymentStatus.terminated),
            child: Text('Terminate'),
          ),
      ],
    );
  }
}

/// What a row's overflow menu can ask for. A sealed type rather than a second
/// enum so the status transitions keep carrying their [EmploymentStatus] and the
/// `switch` above stays exhaustive.
sealed class RosterRowAction {
  const RosterRowAction();
}

class RosterRowInvite extends RosterRowAction {
  const RosterRowInvite();

  @override
  bool operator ==(Object other) => other is RosterRowInvite;

  @override
  int get hashCode => (RosterRowInvite).hashCode;
}

class RosterRowStatus extends RosterRowAction {
  const RosterRowStatus(this.status);

  final EmploymentStatus status;

  @override
  bool operator ==(Object other) =>
      other is RosterRowStatus && other.status == status;

  @override
  int get hashCode => status.hashCode;
}

class _EmptyRoster extends StatelessWidget {
  const _EmptyRoster({required this.onAdd});

  final VoidCallback onAdd;

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
              Icons.groups_outlined,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('No one on this branch yet', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Add your first person to start tracking attendance, leave and '
              'payroll.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              key: const Key('people-empty-add'),
              onPressed: onAdd,
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Add person'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoMatches extends StatelessWidget {
  const _NoMatches({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off,
            size: 40,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text('No one matches these filters',
              style: theme.textTheme.titleSmall),
          const SizedBox(height: 12),
          OutlinedButton(
            key: const Key('people-clear-filters'),
            onPressed: onClear,
            child: const Text('Clear filters'),
          ),
        ],
      ),
    );
  }
}

class _RosterError extends StatelessWidget {
  const _RosterError({
    required this.message,
    required this.onRetry,
    this.onDiagnose,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback? onDiagnose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off,
              size: 40,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key('people-retry'),
              onPressed: onRetry,
              child: const Text('Try again'),
            ),
            if (onDiagnose != null)
              TextButton(
                key: const Key('people-diagnose'),
                onPressed: onDiagnose,
                child: const Text('Why was this denied?'),
              ),
          ],
        ),
      ),
    );
  }
}
