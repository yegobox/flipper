import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_providers.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_data_table.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_icon.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_kpi_card.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_switch.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_tag.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class AccountingRecurringView extends ConsumerWidget {
  const AccountingRecurringView({super.key, required this.onNewEntry});

  final VoidCallback onNewEntry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rows = ref.watch(recurringSchedulesProvider);
    final currency = ref.watch(accountingCurrencyProvider);
    final activeCount = rows.where((r) => r.active).length;
    final monthlyTotal = rows
        .where((r) => r.active && r.freq == 'Monthly')
        .fold<int>(0, (s, r) => s + r.amount);
    final nextRun = rows.isEmpty
        ? '—'
        : rows.firstWhere((r) => r.active, orElse: () => rows.first).next;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingPageHeader(
            eyebrow: 'Daybook',
            title: 'Recurring entries',
            subtitle: 'Rent, salaries and other repeating entries post themselves · $currency',
            actions: [
              AccountingButton(
                label: 'New schedule',
                accIcon: AccIcon.plus,
                primary: true,
                onPressed: onNewEntry,
              ),
            ],
          ),
          AccountingKpiGrid(
            maxColumns: 3,
            children: [
              AccountingKpiCard(
                label: 'Active schedules',
                textValue: '$activeCount of ${rows.length}',
                icon: AccIcon.refresh,
                tone: KpiTone.blue,
                currencyPrefix: false,
              ),
              AccountingKpiCard(
                label: 'Monthly committed',
                value: monthlyTotal,
                icon: AccIcon.wallet,
                tone: KpiTone.amber,
              ),
              AccountingKpiCard(
                label: 'Next run',
                textValue: nextRun,
                icon: AccIcon.calendar,
                tone: KpiTone.green,
                currencyPrefix: false,
                valueFontSize: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          AccountingDataTable(
            columns: const [
              AccountingTableColumn(label: 'Schedule'),
              AccountingTableColumn(label: 'Frequency'),
              AccountingTableColumn(label: 'Next run'),
              AccountingTableColumn(label: 'Posts to'),
              AccountingTableColumn(label: 'Amount', align: TextAlign.right),
              AccountingTableColumn(label: 'Status'),
              AccountingTableColumn(label: '', width: 108),
            ],
            mutedRow: (i) => !rows[i].active,
            rows: [
              for (final r in rows)
                [
                  Row(
                    children: [
                      RecurringIconBox(
                        icon: accIconFromHandoff(r.iconName) ?? AccIcon.receipt,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          r.name,
                          style: AccountingTokens.sans(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AccountingTag(label: '${r.freq} · ${r.day}'),
                  Text(
                    r.active ? r.next : '— paused —',
                    style: AccountingTokens.sans(
                      fontSize: 13.5,
                      color: AccountingTokens.ink3,
                    ),
                  ),
                  Text(
                    r.accounts,
                    style: AccountingTokens.sans(
                      fontSize: 12.5,
                      color: AccountingTokens.ink3,
                    ),
                  ),
                  Text(
                    money(r.amount),
                    style: AccountingTokens.mono(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AccountingSwitch(
                    value: r.active,
                    onChanged: (v) {
                      ref.read(recurringSchedulesProvider.notifier).update(
                            (rs) => [
                              for (final x in rs)
                                if (x.id == r.id) x.copyWith(active: v) else x,
                            ],
                          );
                      showAccountingToast(
                        context,
                        v ? 'Schedule resumed' : 'Schedule paused',
                        subtitle: r.name,
                        accIcon: v ? AccIcon.check : AccIcon.clock,
                        tone: v
                            ? AccountingToastTone.success
                            : AccountingToastTone.info,
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: AccountingButton(
                      label: 'Run now',
                      small: true,
                      enabled: r.active,
                      onPressed: r.active
                          ? () => showAccountingToast(
                                context,
                                'Entry posted',
                                subtitle: '${r.name} · $currency ${money(r.amount)}',
                                accIcon: AccIcon.check,
                              )
                          : null,
                    ),
                  ),
                ],
            ],
          ),
        ],
      ),
    );
  }
}

class AccountingPeriodCloseView extends ConsumerWidget {
  const AccountingPeriodCloseView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(periodCloseTasksProvider);
    final locked = ref.watch(periodCloseLockedProvider);
    final period = ref.watch(accountingPeriodLabelProvider);
    final currency = ref.watch(accountingCurrencyProvider);
    final done = tasks.where((t) => t.done).length;
    final ready = done == tasks.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingPageHeader(
            eyebrow: 'Setup',
            title: 'Period close',
            subtitle: 'Lock $period once the books are final · $currency',
            actions: [
              if (locked)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AccountingTokens.gainTint,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AccountingIcon(
                        icon: AccIcon.shieldCheck,
                        size: 14,
                        color: AccountingTokens.gainInk,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$period locked',
                        style: AccountingTokens.sans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AccountingTokens.gainInk,
                        ),
                      ),
                    ],
                  ),
                )
              else
                AccountingButton(
                  label: 'Close period',
                  accIcon: AccIcon.shieldCheck,
                  primary: true,
                  enabled: ready,
                  onPressed: ready
                      ? () {
                          ref.read(periodCloseLockedProvider.notifier).state = true;
                          appendAuditLog(
                            ref,
                            action: 'closed',
                            target: period,
                            detail: '$period locked · entries are now read-only',
                            iconName: 'ShieldCheck',
                          );
                          showAccountingToast(
                            context,
                            'Period closed',
                            subtitle: '$period locked · entries are now read-only',
                            accIcon: AccIcon.shieldCheck,
                            tone: AccountingToastTone.success,
                          );
                        }
                      : null,
                ),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final stack = constraints.maxWidth < 720;
              final checklist = _CloseChecklist(
                tasks: tasks,
                done: done,
                locked: locked,
                onToggle: (id) {
                  final task = tasks.firstWhere((t) => t.id == id);
                  final next = !task.done;
                  ref.read(periodCloseTaskOverridesProvider.notifier).update(
                        (m) => {...m, id: next},
                      );
                },
                onReview: (goView) {
                  final view = closeTaskView(goView);
                  if (view != null) {
                    ref.read(accountingViewProvider.notifier).state = view;
                  }
                },
              );
              final notes = _CloseNotes(ready: ready);
              if (stack) {
                return Column(
                  children: [
                    checklist,
                    const SizedBox(height: 16),
                    notes,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: checklist),
                  const SizedBox(width: 16),
                  Expanded(flex: 5, child: notes),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CloseChecklist extends StatelessWidget {
  const _CloseChecklist({
    required this.tasks,
    required this.done,
    required this.locked,
    required this.onToggle,
    required this.onReview,
  });

  final List<CloseTask> tasks;
  final int done;
  final bool locked;
  final void Function(String id) onToggle;
  final void Function(String goView) onReview;

  @override
  Widget build(BuildContext context) {
    return AccountingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AccountingCardHeader(
            title: 'Close checklist',
            subtitle: '$done of ${tasks.length} steps complete',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: LinearProgressIndicator(
              value: tasks.isEmpty ? 0 : done / tasks.length,
              backgroundColor: AccountingTokens.surface2,
              color: AccountingTokens.gain,
              minHeight: 6,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          for (final t in tasks)
            _CloseTaskRow(
              task: t,
              locked: locked,
              onToggle: () => onToggle(t.id),
              onReview: () => onReview(t.goView),
            ),
        ],
      ),
    );
  }
}

class _CloseTaskRow extends StatelessWidget {
  const _CloseTaskRow({
    required this.task,
    required this.locked,
    required this.onToggle,
    required this.onReview,
  });

  final CloseTask task;
  final bool locked;
  final VoidCallback onToggle;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          InkWell(
            onTap: locked ? null : onToggle,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: task.done ? AccountingTokens.gain : AccountingTokens.surface2,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: task.done ? AccountingTokens.gain : AccountingTokens.line,
                ),
              ),
              child: task.done
                  ? const AccountingIcon(
                      icon: AccIcon.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          AccountingIcon(
            icon: accIconFromHandoff(task.iconName) ?? AccIcon.check,
            size: 17,
            color: AccountingTokens.ink3,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.label, style: AccountingTokens.sans(fontWeight: FontWeight.w600)),
                Text(
                  task.detail,
                  style: AccountingTokens.sans(fontSize: 12, color: AccountingTokens.ink3),
                ),
              ],
            ),
          ),
          if (!task.done)
            TextButton.icon(
              onPressed: onReview,
              icon: const AccountingIcon(icon: AccIcon.chevRight, size: 13),
              label: const Text('Review'),
            ),
        ],
      ),
    );
  }
}

class _CloseNotes extends StatelessWidget {
  const _CloseNotes({required this.ready});

  final bool ready;

  @override
  Widget build(BuildContext context) {
    return AccountingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AccountingCardHeader(title: 'What closing does'),
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 0, 22, 12),
            child: _CloseNote(
              icon: AccIcon.shieldCheck,
              text: 'Locks the period. Posted entries become read-only — no edits without re-opening.',
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 0, 22, 12),
            child: _CloseNote(
              icon: AccIcon.stack,
              text: 'Rolls forward. Net income is moved into retained earnings and balances carry into the next month.',
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 0, 22, 12),
            child: _CloseNote(
              icon: AccIcon.receipt,
              text: 'Creates an audit point. A snapshot is logged in the audit trail with your name and time.',
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 20),
            child: Row(
              children: [
                AccountingIcon(
                  icon: ready ? AccIcon.check : AccIcon.warn,
                  size: 16,
                  color: ready ? AccountingTokens.gainInk : AccountingTokens.warnAmber,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ready
                        ? 'All checks passed — ready to close.'
                        : 'Finish every checklist step to enable closing.',
                    style: AccountingTokens.sans(
                      fontWeight: FontWeight.w700,
                      color: ready ? AccountingTokens.gainInk : AccountingTokens.warnAmber,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CloseNote extends StatelessWidget {
  const _CloseNote({required this.icon, required this.text});

  final AccIcon icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AccountingIcon(icon: icon, size: 16, color: AccountingTokens.ink3),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: AccountingTokens.sans(fontSize: 13))),
      ],
    );
  }
}

class AccountingAuditView extends ConsumerWidget {
  const AccountingAuditView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = ref.watch(auditLogProvider);
    final journal = ref.watch(accountingJournalProvider);
    final userFilter = ref.watch(auditUserFilterProvider);
    final users = ['all', ...{for (final a in log) a.user}];
    final rows = log.where((a) => userFilter == 'all' || a.user == userFilter).toList();

    // Seed from posted journal activity when local log is empty.
    final display = rows.isNotEmpty
        ? rows
        : [
            for (final e in journal.take(8))
              AuditEntry(
                id: e.id,
                ts: e.date,
                user: '—',
                role: 'System',
                action: e.status == JournalStatus.posted ? 'posted' : e.status.name,
                target: e.id,
                detail: e.memo,
                iconName: 'Receipt',
                tone: AuditTone.slate,
              ),
          ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingPageHeader(
            eyebrow: 'Setup',
            title: 'Audit trail',
            subtitle: 'Every change, who made it, and when · immutable',
            actions: [
              PopupMenuButton<String>(
                offset: const Offset(0, 40),
                padding: EdgeInsets.zero,
                itemBuilder: (context) => [
                  for (final u in users)
                    PopupMenuItem(
                      value: u,
                      child: Text(u == 'all' ? 'All users' : u),
                    ),
                ],
                onSelected: (u) =>
                    ref.read(auditUserFilterProvider.notifier).state = u,
                child: AccountingButton(
                  label: userFilter == 'all' ? 'All users' : userFilter,
                  accIcon: AccIcon.filter,
                  small: true,
                ),
              ),
              AccountingButton(
                label: 'Export',
                accIcon: AccIcon.download,
                small: true,
                onPressed: () => showAccountingToast(
                  context,
                  'Exporting audit log',
                  subtitle: '${display.length} events · CSV',
                  accIcon: AccIcon.download,
                ),
              ),
            ],
          ),
          AccountingCard(
            child: display.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'No audit events yet.',
                        style: AccountingTokens.sans(color: AccountingTokens.ink3),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      for (final a in display) _AuditRow(entry: a),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _AuditRow extends StatelessWidget {
  const _AuditRow({required this.entry});

  final AuditEntry entry;

  Color get _toneColor => switch (entry.tone) {
        AuditTone.green => AccountingTokens.gain,
        AuditTone.blue => AccountingTokens.accent,
        AuditTone.amber => AccountingTokens.warnAmber,
        AuditTone.slate => AccountingTokens.ink3,
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _toneColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: AccountingIcon(
              icon: accIconFromHandoff(entry.iconName) ?? AccIcon.check,
              size: 16,
              color: _toneColor,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(entry.user, style: AccountingTokens.sans(fontWeight: FontWeight.w700)),
                    Text(entry.action, style: AccountingTokens.sans(color: AccountingTokens.ink3)),
                    Text(entry.target, style: AccountingTokens.mono(fontSize: 12)),
                  ],
                ),
                Text(
                  entry.detail,
                  style: AccountingTokens.sans(fontSize: 12.5, color: AccountingTokens.ink3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(entry.ts, style: AccountingTokens.sans(fontSize: 11.5, color: AccountingTokens.ink3)),
              const SizedBox(height: 4),
              _AuditTag(text: entry.role),
            ],
          ),
        ],
      ),
    );
  }
}

class AccountingRolesView extends ConsumerWidget {
  const AccountingRolesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(accountingTeamProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingPageHeader(
            eyebrow: 'Setup',
            title: 'Users & roles',
            subtitle: 'Control who can see and change the books',
            actions: [
              AccountingButton(
                label: 'Invite teammate',
                accIcon: AccIcon.plus,
                primary: true,
                onPressed: () => showAccountingToast(
                  context,
                  'Invite sent',
                  subtitle: 'Team invitations coming soon',
                  accIcon: AccIcon.mail,
                ),
              ),
            ],
          ),
          AccountingCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AccountingCardHeader(title: 'Team (${team.length})'),
                if (team.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Only you have access. Invite teammates to collaborate.',
                      style: AccountingTokens.sans(color: AccountingTokens.ink3),
                    ),
                  )
                else
                  for (final m in team)
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: m.color,
                        child: Text(
                          m.initials,
                          style: AccountingTokens.sans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: Text(m.name),
                      subtitle: Text('${m.role} · ${m.last}'),
                      trailing: m.you
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AccountingTokens.accentTint,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'You',
                                style: AccountingTokens.sans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AccountingTokens.accent,
                                ),
                              ),
                            )
                          : null,
                    ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AccountingCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AccountingCardHeader(title: 'Roles'),
                for (final r in accountingRoles)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(color: r.color, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.role, style: AccountingTokens.sans(fontWeight: FontWeight.w700)),
                              Text(r.desc, style: AccountingTokens.sans(fontSize: 12, color: AccountingTokens.ink3)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AccountingCard(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Capability')),
                  DataColumn(label: Text('Owner')),
                  DataColumn(label: Text('Bookkeeper')),
                  DataColumn(label: Text('Cashier')),
                  DataColumn(label: Text('Viewer')),
                ],
                rows: [
                  for (final p in accountingPermissions)
                    DataRow(
                      cells: [
                        DataCell(Text(p.cap)),
                        DataCell(_PermCell(on: p.owner)),
                        DataCell(_PermCell(on: p.bookkeeper)),
                        DataCell(_PermCell(on: p.cashier)),
                        DataCell(_PermCell(on: p.viewer)),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermCell extends StatelessWidget {
  const _PermCell({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: on ? AccountingTokens.gainTint : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: AccountingIcon(
        icon: on ? AccIcon.check : AccIcon.minus,
        size: 15,
        color: on ? AccountingTokens.gainInk : AccountingTokens.ink4,
      ),
    );
  }
}

class _AuditTag extends StatelessWidget {
  const _AuditTag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AccountingTokens.surface2,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AccountingTokens.line),
      ),
      child: Text(text, style: AccountingTokens.sans(fontSize: 10.5)),
    );
  }
}

final auditUserFilterProvider = StateProvider<String>((ref) => 'all');
