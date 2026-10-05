import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_providers.dart';
import 'package:flipper_web/modules/accounting/data/recurring_journal_poster.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_data_table.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_icon.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_kpi_card.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_switch.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_tag.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_toast.dart';
import 'package:flipper_web/modules/accounting/widgets/v3_doc_panels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class AccountingRecurringView extends ConsumerWidget {
  const AccountingRecurringView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final rows = ref.watch(recurringSchedulesProvider);
    final accounts = ref.watch(accountingAccountsProvider);
    final accountMap = {for (final a in accounts) a.code: a};
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
            eyebrow: l10n.booksDaybook,
            title: l10n.booksRecurringEntries,
            subtitle: l10n.booksRecurringSubtitle(currency),
            actions: [
              AccountingButton(
                label: l10n.booksNewSchedule,
                accIcon: AccIcon.plus,
                primary: true,
                onPressed: () => _openEditor(ref, rows),
              ),
            ],
          ),
          AccountingKpiGrid(
            maxColumns: 3,
            children: [
              AccountingKpiCard(
                label: l10n.booksActiveSchedules,
                textValue: l10n.booksCountOfTotal(
                  '$activeCount',
                  '${rows.length}',
                ),
                icon: AccIcon.refresh,
                tone: KpiTone.blue,
                currencyPrefix: false,
              ),
              AccountingKpiCard(
                label: l10n.booksMonthlyCommitted,
                value: monthlyTotal,
                icon: AccIcon.wallet,
                tone: KpiTone.amber,
              ),
              AccountingKpiCard(
                label: l10n.booksNextRun,
                textValue: nextRun,
                icon: AccIcon.calendar,
                tone: KpiTone.green,
                currencyPrefix: false,
                valueFontSize: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (rows.isEmpty)
            AccountingCard(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    l10n.booksNoRecurringYet,
                    style: AccountingTokens.sans(color: AccountingTokens.ink3),
                  ),
                ),
              ),
            )
          else
            AccountingDataTable(
              columns: [
                AccountingTableColumn(label: l10n.booksSchedule),
                AccountingTableColumn(label: l10n.booksFrequency),
                AccountingTableColumn(label: l10n.booksNextRun),
                AccountingTableColumn(label: l10n.booksPostsTo),
                AccountingTableColumn(
                  label: l10n.amount,
                  align: TextAlign.right,
                ),
                AccountingTableColumn(label: l10n.booksStatus),
                const AccountingTableColumn(label: '', width: 150),
              ],
              mutedRow: (i) => !rows[i].active,
              rows: [
                for (final r in rows)
                  [
                    Row(
                      children: [
                        RecurringIconBox(
                          icon:
                              accIconFromHandoff(r.iconName) ?? AccIcon.receipt,
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
                    AccountingTag(
                      label: '${booksFrequencyLabel(r.freq, l10n)} · ${r.day}',
                    ),
                    Text(
                      r.active ? r.next : l10n.booksPaused,
                      style: AccountingTokens.sans(
                        fontSize: 13.5,
                        color: AccountingTokens.ink3,
                      ),
                    ),
                    Text(
                      _accountsLabel(r, accountMap),
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
                      onChanged: (v) => _toggleActive(context, ref, r, v),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: l10n.edit,
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Icons.edit_outlined, size: 16),
                            onPressed: () => _openEditor(ref, rows, editing: r),
                          ),
                          const SizedBox(width: 4),
                          AccountingButton(
                            label: l10n.booksRunNow,
                            small: true,
                            enabled: r.active,
                            onPressed: r.active
                                ? () => _runNow(context, ref, r)
                                : null,
                          ),
                        ],
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

/// Debit → credit account label resolved from the chart of accounts.
String _accountsLabel(RecurringSchedule s, Map<String, Account> byCode) {
  final dr = byCode[s.debitCode]?.name ?? s.debitCode;
  final cr = byCode[s.creditCode]?.name ?? s.creditCode;
  return '$dr → $cr';
}

String _nextRecurringId(List<RecurringSchedule> existing) {
  var max = 0;
  for (final s in existing) {
    final m = RegExp(r'R-(\d+)').firstMatch(s.id);
    if (m != null) {
      final n = int.tryParse(m.group(1)!) ?? 0;
      if (n > max) max = n;
    }
  }
  return 'R-${(max + 1).toString().padLeft(2, '0')}';
}

void _openEditor(
  WidgetRef ref,
  List<RecurringSchedule> existing, {
  RecurringSchedule? editing,
}) {
  ref.read(recurringUiProvider.notifier).state = RecurringUiState(
    editing: editing,
    editingNew: editing == null,
  );
}

Future<void> _toggleActive(
  BuildContext context,
  WidgetRef ref,
  RecurringSchedule r,
  bool active,
) async {
  final businessId = ref.read(accountingBusinessIdProvider);
  if (businessId.isEmpty) return;
  await ref
      .read(accountingRecurringRepositoryProvider)
      .upsertSchedule(
        businessId: businessId,
        schedule: r.copyWith(active: active),
      );
  if (!context.mounted) return;
  showAccountingToast(
    context,
    active
        ? context.flipperL10n.booksScheduleResumed
        : context.flipperL10n.booksSchedulePaused,
    subtitle: r.name,
    accIcon: active ? AccIcon.check : AccIcon.clock,
    tone: active ? AccountingToastTone.success : AccountingToastTone.info,
  );
}

Future<void> _runNow(
  BuildContext context,
  WidgetRef ref,
  RecurringSchedule r,
) async {
  final businessId = ref.read(accountingBusinessIdProvider);
  if (businessId.isEmpty) return;
  final currency = ref.read(accountingCurrencyProvider);
  final poster = RecurringJournalPoster(
    ref.read(accountingLedgerRepositoryProvider),
  );
  final now = DateTime.now();
  final period = recurringPeriodKey(r.freq, now);
  try {
    final posted = await poster.postSchedule(
      businessId: businessId,
      schedule: r,
      period: period,
    );
    if (posted) {
      await ref
          .read(accountingRecurringRepositoryProvider)
          .upsertSchedule(
            businessId: businessId,
            schedule: r.copyWith(next: advanceNextRun(r.next, r.freq)),
          );
    }
    if (!context.mounted) return;
    if (posted) {
      appendAuditLog(
        ref,
        action: 'Posted recurring entry',
        target: r.name,
        detail: '$currency ${money(r.amount)}',
        iconName: 'Refresh',
      );
      showAccountingToast(
        context,
        context.flipperL10n.booksEntryPosted,
        subtitle: '${r.name} · $currency ${money(r.amount)}',
        accIcon: AccIcon.check,
        tone: AccountingToastTone.success,
      );
    } else {
      showAccountingToast(
        context,
        context.flipperL10n.booksAlreadyPostedThisPeriod,
        subtitle: '${r.name} · $period',
        accIcon: AccIcon.clock,
        tone: AccountingToastTone.info,
      );
    }
  } catch (e) {
    if (!context.mounted) return;
    showAccountingToast(
      context,
      context.flipperL10n.booksCouldNotPostEntry,
      subtitle: '$e',
      accIcon: AccIcon.warn,
      tone: AccountingToastTone.warn,
    );
  }
}

/// Editor panel for recurring schedules at the shell right edge — mirrors
/// [AccountingBillingPanelHost].
class AccountingRecurringPanelHost extends ConsumerWidget {
  const AccountingRecurringPanelHost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(recurringUiProvider);
    if (ui == null) return const SizedBox.shrink();

    void close() => ref.read(recurringUiProvider.notifier).state = null;

    final existing = ref.watch(recurringSchedulesProvider);

    return Align(
      alignment: Alignment.centerRight,
      child: RecurringEditorPanel(
        schedule: ui.editing,
        newId: _nextRecurringId(existing),
        onClose: close,
        onSaved: (schedule) async {
          final businessId = ref.read(accountingBusinessIdProvider);
          if (businessId.isEmpty) return;
          await ref
              .read(accountingRecurringRepositoryProvider)
              .upsertSchedule(businessId: businessId, schedule: schedule);
          if (!context.mounted) return;
          appendAuditLog(
            ref,
            action: ui.editing == null
                ? 'Created recurring schedule'
                : 'Updated recurring schedule',
            target: schedule.name,
            detail: '${schedule.freq} · ${schedule.day}',
            iconName: 'Refresh',
          );
          showAccountingToast(
            context,
            ui.editing == null
                ? context.flipperL10n.booksScheduleCreated
                : context.flipperL10n.booksScheduleUpdated,
            subtitle: schedule.name,
            accIcon: AccIcon.check,
            tone: AccountingToastTone.success,
          );
          close();
        },
      ),
    );
  }
}

class AccountingPeriodCloseView extends ConsumerWidget {
  const AccountingPeriodCloseView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
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
            eyebrow: l10n.booksSetup,
            title: l10n.booksPeriodClose,
            subtitle: l10n.booksPeriodCloseSubtitle(currency, period),
            actions: [
              if (locked)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
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
                        l10n.booksPeriodLocked(period),
                        style: AccountingTokens.sans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AccountingTokens.gainInk,
                        ),
                      ),
                    ],
                  ),
                ),
              // A close nobody can undo is not a close, it is a dead end. The
              // reopen is recorded on the period (reopenedAt / reopenedBy) so
              // it is auditable rather than indistinguishable from a period
              // that was never closed.
              if (locked)
                AccountingButton(
                  label: l10n.booksReopenPeriod,
                  accIcon: AccIcon.shieldCheck,
                  onPressed: () async {
                    final messenger = context;
                    try {
                      await setCurrentPeriodClosed(
                        ref,
                        closed: false,
                        actor: ref.read(accountingUserNameProvider),
                        reopenReason: 'Reopened from the period close screen',
                      );
                    } catch (err) {
                      if (!messenger.mounted) return;
                      showAccountingToast(
                        messenger,
                        l10n.booksCouldNotReopenPeriod,
                        subtitle: err.toString(),
                        accIcon: AccIcon.shieldCheck,
                        tone: AccountingToastTone.warn,
                      );
                      return;
                    }
                    appendAuditLog(
                      ref,
                      action: 'reopened',
                      target: period,
                      detail: '$period reopened · entries are postable again',
                      iconName: 'ShieldCheck',
                    );
                    if (!messenger.mounted) return;
                    showAccountingToast(
                      messenger,
                      l10n.booksPeriodReopened,
                      subtitle: l10n.booksPeriodPostableAgain(period),
                      accIcon: AccIcon.shieldCheck,
                      tone: AccountingToastTone.success,
                    );
                  },
                )
              else
                AccountingButton(
                  label: l10n.booksClosePeriod,
                  accIcon: AccIcon.shieldCheck,
                  primary: true,
                  enabled: ready,
                  onPressed: ready
                      ? () async {
                          final messenger = context;
                          try {
                            // Awaited, and the toast only fires on success:
                            // the old flag claimed a close that lived in
                            // memory and was gone on the next reload.
                            await setCurrentPeriodClosed(
                              ref,
                              closed: true,
                              actor: ref.read(accountingUserNameProvider),
                            );
                          } catch (err) {
                            if (!messenger.mounted) return;
                            showAccountingToast(
                              messenger,
                              l10n.booksCouldNotClosePeriod,
                              subtitle: err.toString(),
                              accIcon: AccIcon.shieldCheck,
                              tone: AccountingToastTone.warn,
                            );
                            return;
                          }
                          appendAuditLog(
                            ref,
                            action: 'closed',
                            target: period,
                            detail:
                                '$period locked · entries are now read-only',
                            iconName: 'ShieldCheck',
                          );
                          if (!messenger.mounted) return;
                          showAccountingToast(
                            messenger,
                            l10n.booksPeriodClosed,
                            subtitle: l10n.booksPeriodLockedReadOnly(period),
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
                  ref
                      .read(periodCloseTaskOverridesProvider.notifier)
                      .update((m) => {...m, id: next});
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
                  children: [checklist, const SizedBox(height: 16), notes],
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
            title: context.flipperL10n.booksCloseChecklist,
            subtitle: context.flipperL10n.booksStepsComplete(
              '$done',
              '${tasks.length}',
            ),
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
                color: task.done
                    ? AccountingTokens.gain
                    : AccountingTokens.surface2,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: task.done
                      ? AccountingTokens.gain
                      : AccountingTokens.line,
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
                Text(
                  task.label,
                  style: AccountingTokens.sans(fontWeight: FontWeight.w600),
                ),
                Text(
                  task.detail,
                  style: AccountingTokens.sans(
                    fontSize: 12,
                    color: AccountingTokens.ink3,
                  ),
                ),
              ],
            ),
          ),
          if (!task.done)
            TextButton.icon(
              onPressed: onReview,
              icon: const AccountingIcon(icon: AccIcon.chevRight, size: 13),
              label: Text(context.flipperL10n.booksReview),
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
    final l10n = context.flipperL10n;
    return AccountingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AccountingCardHeader(title: l10n.booksWhatClosingDoes),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
            child: _CloseNote(
              icon: AccIcon.shieldCheck,
              text: l10n.booksCloseNoteLocks,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
            child: _CloseNote(
              icon: AccIcon.stack,
              text: l10n.booksCloseNoteRollsForward,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
            child: _CloseNote(
              icon: AccIcon.receipt,
              text: l10n.booksCloseNoteAuditPoint,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 20),
            child: Row(
              children: [
                AccountingIcon(
                  icon: ready ? AccIcon.check : AccIcon.warn,
                  size: 16,
                  color: ready
                      ? AccountingTokens.gainInk
                      : AccountingTokens.warnAmber,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ready
                        ? l10n.booksAllChecksPassed
                        : l10n.booksFinishChecklist,
                    style: AccountingTokens.sans(
                      fontWeight: FontWeight.w700,
                      color: ready
                          ? AccountingTokens.gainInk
                          : AccountingTokens.warnAmber,
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
    // Session entries first (instant feedback), then the persisted trail
    // (deduped by id — appendAuditLog writes both with the same id).
    final l10n = context.flipperL10n;
    final session = ref.watch(auditLogProvider);
    final persisted =
        ref.watch(persistedAuditLogProvider).value ?? const <AuditEntry>[];
    final sessionIds = {for (final a in session) a.id};
    final log = [
      ...session,
      ...persisted.where((a) => !sessionIds.contains(a.id)),
    ];
    final journal = ref.watch(accountingJournalProvider);
    final userFilter = ref.watch(auditUserFilterProvider);
    final users = [
      'all',
      ...{for (final a in log) a.user},
    ];
    final rows = log
        .where((a) => userFilter == 'all' || a.user == userFilter)
        .toList();

    // Seed from posted journal activity when local log is empty.
    final display = rows.isNotEmpty
        ? rows
        : [
            for (final e in journal.take(8))
              AuditEntry(
                id: e.id,
                ts: e.date,
                user: '—',
                role: l10n.booksRoleSystem,
                action: e.status == JournalStatus.posted
                    ? 'posted'
                    : e.status.name,
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
            eyebrow: l10n.booksSetup,
            title: l10n.booksAuditTrail,
            subtitle: l10n.booksAuditSubtitle,
            actions: [
              PopupMenuButton<String>(
                offset: const Offset(0, 40),
                padding: EdgeInsets.zero,
                itemBuilder: (context) => [
                  for (final u in users)
                    PopupMenuItem(
                      value: u,
                      child: Text(u == 'all' ? l10n.booksAllUsers : u),
                    ),
                ],
                onSelected: (u) =>
                    ref.read(auditUserFilterProvider.notifier).state = u,
                child: AccountingButton(
                  label: userFilter == 'all' ? l10n.booksAllUsers : userFilter,
                  accIcon: AccIcon.filter,
                  small: true,
                ),
              ),
              AccountingButton(
                label: l10n.booksExport,
                accIcon: AccIcon.download,
                small: true,
                onPressed: () => showAccountingToast(
                  context,
                  l10n.booksExportingAuditLog,
                  subtitle: l10n.booksEventsCsv('${display.length}'),
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
                        l10n.booksNoAuditEvents,
                        style: AccountingTokens.sans(
                          color: AccountingTokens.ink3,
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: [for (final a in display) _AuditRow(entry: a)],
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
                    Text(
                      entry.user,
                      style: AccountingTokens.sans(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      entry.action,
                      style: AccountingTokens.sans(
                        color: AccountingTokens.ink3,
                      ),
                    ),
                    Text(
                      entry.target,
                      style: AccountingTokens.mono(fontSize: 12),
                    ),
                  ],
                ),
                Text(
                  entry.detail,
                  style: AccountingTokens.sans(
                    fontSize: 12.5,
                    color: AccountingTokens.ink3,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                entry.ts,
                style: AccountingTokens.sans(
                  fontSize: 11.5,
                  color: AccountingTokens.ink3,
                ),
              ),
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
    final l10n = context.flipperL10n;
    final team = ref.watch(accountingTeamProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingPageHeader(
            eyebrow: l10n.booksSetup,
            title: l10n.booksUsersRoles,
            subtitle: l10n.booksRolesSubtitle,
            actions: [
              AccountingButton(
                label: l10n.booksInviteTeammate,
                accIcon: AccIcon.plus,
                primary: true,
                onPressed: () => showAccountingToast(
                  context,
                  l10n.booksInviteSent,
                  subtitle: l10n.booksInvitationsComingSoon,
                  accIcon: AccIcon.mail,
                ),
              ),
            ],
          ),
          AccountingCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AccountingCardHeader(
                  title: l10n.booksTeamCount('${team.length}'),
                ),
                if (team.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      l10n.booksOnlyYouHaveAccess,
                      style: AccountingTokens.sans(
                        color: AccountingTokens.ink3,
                      ),
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AccountingTokens.accentTint,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                l10n.booksYou,
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
                AccountingCardHeader(title: l10n.booksRoles),
                for (final r in accountingRoles(l10n))
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: r.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r.role,
                                style: AccountingTokens.sans(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                r.desc,
                                style: AccountingTokens.sans(
                                  fontSize: 12,
                                  color: AccountingTokens.ink3,
                                ),
                              ),
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
                columns: [
                  DataColumn(label: Text(l10n.booksCapability)),
                  DataColumn(label: Text(l10n.booksRoleOwner)),
                  DataColumn(label: Text(l10n.booksRoleBookkeeper)),
                  DataColumn(label: Text(l10n.booksRoleCashier)),
                  DataColumn(label: Text(l10n.booksRoleViewer)),
                ],
                rows: [
                  for (final p in accountingPermissions(l10n))
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
