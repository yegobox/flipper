import 'package:flipper_web/features/module_launcher/all_apps_sheet.dart';
import 'package:flipper_web/features/module_launcher/app_launcher_host.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_icon.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

void _openAppLauncher(BuildContext context) {
  if (kIsWeb) {
    AllAppsSheet.show(context);
    return;
  }
  AppLauncherHost.maybeOf(context)?.onOpenLauncher();
}

class AccountingTopbar extends ConsumerWidget {
  const AccountingTopbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AccountingView view = ref.watch(accountingViewProvider);
    final period = ref.watch(accountingPeriodLabelProvider);
    final pending = ref.watch(pendingCountProvider);
    final bellUnread = pending > 0 && !ref.watch(notificationsReadProvider);

    return Container(
      height: AccountingTokens.topbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AccountingTokens.surface,
        border: Border(bottom: BorderSide(color: AccountingTokens.line)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 900;
          final hideSearch = constraints.maxWidth < 720;

          return Row(
            children: [
              Flexible(
                flex: compact ? 1 : 0,
                child: _Breadcrumb(section: view.section, label: view.label),
              ),
              const Spacer(),
              if (!hideSearch) ...[
                const _TopSearchField(),
                const SizedBox(width: 16),
              ],
              _PeriodButton(label: period),
              const SizedBox(width: 8),
              _NotificationsButton(
                showDot: bellUnread,
                pending: pending,
                onMarkRead: () {
                  ref.read(notificationsReadProvider.notifier).state = true;
                  showAccountingToast(
                    context,
                    'All caught up',
                    subtitle: 'Notifications marked read',
                    accIcon: AccIcon.check,
                    tone: AccountingToastTone.success,
                  );
                },
                onOpenJournal: () {
                  ref.read(accountingViewProvider.notifier).state =
                      AccountingView.journal;
                  ref.read(journalFilterProvider.notifier).state =
                      JournalFilter.pending;
                },
              ),
              _TopIconButton(
                accIcon: AccIcon.grid,
                tooltip: 'All apps',
                onPressed: () => _openAppLauncher(context),
              ),
              _TopIconButton(
                accIcon: AccIcon.phone,
                tooltip: 'Mobile companion',
                onPressed: () => showAccountingToast(
                  context,
                  'Mobile companion',
                  subtitle: 'Resize the window below 768px for the phone layout',
                  accIcon: AccIcon.phone,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({required this.section, required this.label});

  final String section;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          section,
          style: AccountingTokens.sans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AccountingTokens.ink3,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 9),
          child: AccountingIcon(
            icon: AccIcon.chevRight,
            size: 14,
            color: AccountingTokens.ink3,
          ),
        ),
        Text(
          label,
          style: AccountingTokens.sans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AccountingTokens.ink1,
          ),
        ),
      ],
    );
  }
}

class _TopSearchField extends StatefulWidget {
  const _TopSearchField();

  @override
  State<_TopSearchField> createState() => _TopSearchFieldState();
}

class _TopSearchFieldState extends State<_TopSearchField> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() => _focused = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 280,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _focused ? AccountingTokens.surface : AccountingTokens.surface2,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _focused ? AccountingTokens.accent : AccountingTokens.line,
          width: 1.5,
        ),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: AccountingTokens.accentTint,
                  blurRadius: 0,
                  spreadRadius: 4,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          const AccountingIcon(
            icon: AccIcon.search,
            size: 17,
            color: AccountingTokens.ink3,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              style: AccountingTokens.sans(fontSize: 14, color: AccountingTokens.ink1),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Search entries, accounts, invoices…',
                hintStyle: AccountingTokens.sans(fontSize: 14, color: AccountingTokens.ink4),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AccountingTokens.surface,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AccountingTokens.line),
            ),
            child: Text(
              '⌘K',
              style: AccountingTokens.mono(fontSize: 11, color: AccountingTokens.ink3),
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodButton extends ConsumerWidget {
  const _PeriodButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (_, end) = ref.watch(accountingDateRangeProvider);
    final fiscalYear = end.year;
    final months = List.generate(12, (i) => DateTime(fiscalYear, i + 1, 1));

    return PopupMenuButton<DateTime>(
      tooltip: 'Fiscal period',
      offset: const Offset(0, 44),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (monthStart) {
        final monthEnd = DateTime(monthStart.year, monthStart.month + 1, 0);
        ref.read(accountingDateRangeProvider.notifier).state = (
          monthStart,
          monthEnd,
        );
        showAccountingToast(
          context,
          'Period changed',
          subtitle: DateFormat('MMM yyyy').format(monthStart),
          accIcon: AccIcon.calendar,
        );
      },
      itemBuilder: (context) => [
        PopupMenuItem<DateTime>(
          enabled: false,
          child: Text(
            'Fiscal period $fiscalYear',
            style: AccountingTokens.sans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AccountingTokens.ink3,
              letterSpacing: 0.05 * 11,
            ),
          ),
        ),
        ...months.map(
          (m) => PopupMenuItem(
            value: m,
            child: Text(DateFormat('MMM yyyy').format(m)),
          ),
        ),
      ],
      child: Material(
        color: AccountingTokens.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AccountingTokens.line, width: 1.5),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          hoverColor: AccountingTokens.surface2,
          child: SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AccountingIcon(
                    icon: AccIcon.calendar,
                    size: 17,
                    color: AccountingTokens.accent,
                  ),
                  const SizedBox(width: 9),
                  Text(
                    label,
                    style: AccountingTokens.sans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AccountingTokens.ink1,
                    ),
                  ),
                  const SizedBox(width: 9),
                  const AccountingIcon(
                    icon: AccIcon.chevDown,
                    size: 15,
                    color: AccountingTokens.ink3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationsButton extends StatelessWidget {
  const _NotificationsButton({
    required this.showDot,
    required this.pending,
    required this.onMarkRead,
    required this.onOpenJournal,
  });

  final bool showDot;
  final int pending;
  final VoidCallback onMarkRead;
  final VoidCallback onOpenJournal;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Notifications',
      offset: const Offset(0, 44),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == 'read') {
          onMarkRead();
        } else if (value == 'journal') {
          onOpenJournal();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          enabled: false,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Notifications',
                  style: AccountingTokens.sans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AccountingTokens.ink3,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onMarkRead();
                },
                child: const Text('Mark all read'),
              ),
            ],
          ),
        ),
        if (pending > 0)
          const PopupMenuItem(
            value: 'journal',
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: AccountingIcon(icon: AccIcon.receipt, size: 20),
              title: Text('Journal entries awaiting approval'),
              subtitle: Text('Review pending double-entry postings'),
            ),
          )
        else
          const PopupMenuItem(
            enabled: false,
            child: Text('No new notifications'),
          ),
      ],
      child: Tooltip(
        message: 'Notifications',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            hoverColor: AccountingTokens.surface2,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  const AccountingIcon(
                    icon: AccIcon.bell,
                    size: 19,
                    color: AccountingTokens.ink2,
                  ),
                  if (showDot)
                    Positioned(
                      top: 8,
                      right: 9,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: AccountingTokens.loss,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AccountingTokens.surface,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopIconButton extends StatelessWidget {
  const _TopIconButton({
    required this.accIcon,
    required this.onPressed,
    this.tooltip,
  });

  final AccIcon accIcon;
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          hoverColor: AccountingTokens.surface2,
          child: SizedBox(
            width: 40,
            height: 40,
            child: AccountingIcon(
              icon: accIcon,
              size: 19,
              color: AccountingTokens.ink2,
            ),
          ),
        ),
      ),
    );
  }
}
