import 'package:flipper_dashboard/cashbook_form_rules.dart'
    show cashbookDayLabel;
import 'package:flipper_dashboard/features/admin/widgets/sms_bridge_page.dart';
import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_dashboard/features/personal_finance/personal_finance_data.dart';
import 'package:flipper_dashboard/features/personal_finance/personal_finance_providers.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/sms_review/sms_review_section.dart'
    show SmsReviewHomeCard, smsReviewSummaryProvider;
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

String _money(WidgetRef ref, double v) => v.toCurrencyFormatted(
  symbol: ref.read(branchServicesProvider).box.defaultCurrency(),
  decimalDigits: 0,
);

/// The personal app's home: this month's money in and out, where it went,
/// SMS waiting for review, and the latest movements.
class PersonalHome extends ConsumerWidget {
  const PersonalHome({super.key, this.onSeeAll});

  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final summary =
        ref.watch(personalMonthSummaryProvider).value ??
        PersonalMonthSummary.empty;
    return ListView(
      key: const ValueKey('personal-home'),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      children: [
        const PersonalMonthBar(),
        const SizedBox(height: 12),
        _SummaryCard(summary: summary),
        const SmsReviewHomeCard(padding: EdgeInsets.only(top: 12)),
        const _NothingToReviewRow(),
        if (summary.isEmpty) ...[
          const SizedBox(height: 12),
          const _EmptyCard(),
        ] else ...[
          if (summary.spentByCategory.isNotEmpty) ...[
            _SectionTitle(l10n.personalMoneyWhereItWent),
            _CategoryCard(summary: summary),
          ],
          _SectionTitle(l10n.personalMoneyByAccount),
          _AccountsCard(summary: summary),
          _SectionTitle(
            l10n.personalMoneyRecent,
            action: onSeeAll == null
                ? null
                : TextButton(
                    onPressed: onSeeAll,
                    child: Text(l10n.personalMoneySeeAll),
                  ),
          ),
          _Card(
            child: Column(
              children: [
                for (final m in summary.movements.take(5))
                  PersonalMovementTile(movement: m),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Every movement of the selected month, grouped by day.
class PersonalActivity extends ConsumerWidget {
  const PersonalActivity({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final summary =
        ref.watch(personalMonthSummaryProvider).value ??
        PersonalMonthSummary.empty;
    final now = DateTime.now();
    final children = <Widget>[
      const PersonalMonthBar(),
      const SizedBox(height: 12),
    ];
    if (summary.isEmpty) {
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Text(
            l10n.personalMoneyNoActivity,
            textAlign: TextAlign.center,
            style: const TextStyle(color: PosTokens.ink3),
          ),
        ),
      );
    }
    DateTime? day;
    var group = <Widget>[];
    void flush() {
      if (group.isEmpty) return;
      children
        ..add(_SectionTitle(cashbookDayLabel(day!, now)))
        ..add(_Card(child: Column(children: group)));
      group = <Widget>[];
    }

    for (final m in summary.movements) {
      final d = DateTime(m.at.year, m.at.month, m.at.day);
      if (day != d) {
        flush();
        day = d;
      }
      group.add(PersonalMovementTile(movement: m));
    }
    flush();
    return ListView(
      key: const ValueKey('personal-activity'),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      children: children,
    );
  }
}

/// "‹ October 2026 ›".
class PersonalMonthBar extends ConsumerWidget {
  const PersonalMonthBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final month = ref.watch(personalMonthProvider);
    final notifier = ref.read(personalMonthProvider.notifier);
    final locale = Localizations.maybeLocaleOf(context)?.toLanguageTag();
    String label;
    try {
      label = DateFormat.yMMMM(locale).format(month);
    } catch (_) {
      label = DateFormat.yMMMM().format(month);
    }
    return Row(
      children: [
        IconButton(
          tooltip: l10n.personalMoneyPreviousMonth,
          onPressed: notifier.previous,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: PosTokens.ink1,
            ),
          ),
        ),
        IconButton(
          tooltip: l10n.personalMoneyNextMonth,
          onPressed: notifier.isCurrent ? null : notifier.next,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}

class PersonalMovementTile extends ConsumerWidget {
  const PersonalMovementTile({super.key, required this.movement});

  final PersonalMovement movement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final m = movement;
    final title = m.category ?? m.note ?? l10n.personalMoneyNoCategory;
    final account = switch (m.account) {
      PersonalMoneyAccount.cash => l10n.personalMoneyAccountCash,
      PersonalMoneyAccount.bank => l10n.personalMoneyAccountBank,
      PersonalMoneyAccount.mobileMoney => l10n.personalMoneyAccountMobileMoney,
    };
    final subtitle = [
      account,
      DateFormat.Hm().format(m.at),
      if (m.category != null && m.note != null) m.note!,
    ].join(' · ');
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      leading: CircleAvatar(
        backgroundColor: PosTokens.blueTint,
        foregroundColor: PosTokens.blue,
        child: Icon(personalCategoryIcon(m.category), size: 20),
      ),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(
        '${m.isIncome ? '+' : '−'}${_money(ref, m.amount)}',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: m.isIncome ? PosTokens.gainInk : PosTokens.ink1,
        ),
      ),
    );
  }
}

class _SummaryCard extends ConsumerWidget {
  const _SummaryCard({required this.summary});

  final PersonalMonthSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    Widget figure(String label, double v, {Color? color, Key? key}) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: PosTokens.ink3),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              _money(ref, v),
              key: key,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color ?? PosTokens.ink1,
              ),
            ),
          ),
        ],
      ),
    );
    return _Card(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          figure(
            l10n.personalMoneyIn,
            summary.income,
            color: PosTokens.gainInk,
            key: const ValueKey('personal-income'),
          ),
          figure(
            l10n.personalMoneyOut,
            summary.spent,
            key: const ValueKey('personal-spent'),
          ),
          figure(
            l10n.personalMoneyLeftOver,
            summary.leftOver,
            color: summary.leftOver < 0 ? PosTokens.lossInk : PosTokens.blue,
            key: const ValueKey('personal-left-over'),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends ConsumerWidget {
  const _CategoryCard({required this.summary});

  final PersonalMonthSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final rows = summary.spentByCategory.take(6).toList();
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        children: [
          for (final c in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Icon(
                    personalCategoryIcon(c.category),
                    size: 18,
                    color: PosTokens.ink2,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                c.category ?? l10n.personalMoneyNoCategory,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              _money(ref, c.amount),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            minHeight: 6,
                            value: summary.spent <= 0
                                ? 0
                                : (c.amount / summary.spent).clamp(0.0, 1.0),
                            backgroundColor: PosTokens.blueTint,
                            color: PosTokens.blue,
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
    );
  }
}

class _AccountsCard extends ConsumerWidget {
  const _AccountsCard({required this.summary});

  final PersonalMonthSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final entries = [
      (
        PersonalMoneyAccount.cash,
        l10n.personalMoneyAccountCash,
        Icons.payments_outlined,
      ),
      (
        PersonalMoneyAccount.mobileMoney,
        l10n.personalMoneyAccountMobileMoney,
        Icons.phone_android_outlined,
      ),
      (
        PersonalMoneyAccount.bank,
        l10n.personalMoneyAccountBank,
        Icons.account_balance_outlined,
      ),
    ].where((e) => summary.netByAccount.containsKey(e.$1));
    return _Card(
      child: Column(
        children: [
          for (final (account, label, icon) in entries)
            ListTile(
              leading: Icon(icon, color: PosTokens.ink2),
              title: Text(label),
              trailing: Text(() {
                final v = summary.netByAccount[account] ?? 0;
                return '${v < 0 ? '−' : '+'}${_money(ref, v.abs())}';
              }(), style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return _Card(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.personalMoneyEmptyTitle,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.personalMoneyEmptyBody,
            style: const TextStyle(color: PosTokens.ink2, height: 1.4),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: PosTokens.blue,
              side: const BorderSide(color: PosTokens.blue),
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SmsBridgePage()),
            ),
            icon: const Icon(Icons.phonelink_ring_outlined),
            label: Text(l10n.personalMoneyPairSmsBridge),
          ),
        ],
      ),
    );
  }
}

/// The SMS queue is always reachable: with items, [SmsReviewHomeCard]
/// shows them; with none, this says so and leads to pairing, instead of the
/// home showing nothing at all.
class _NothingToReviewRow extends ConsumerWidget {
  const _NothingToReviewRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(smsReviewSummaryProvider.select((s) => s.count));
    if (count > 0) return const SizedBox.shrink();
    final l10n = context.flipperL10n;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: _Card(
        child: ListTile(
          key: const ValueKey('personal-nothing-to-review'),
          leading: const Icon(
            Icons.mark_chat_read_outlined,
            color: PosTokens.ink3,
          ),
          title: Text(
            l10n.personalMoneyNothingToReview,
            style: const TextStyle(fontSize: 14, color: PosTokens.ink2),
          ),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const SmsBridgePage()),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text, {this.action});

  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: PosTokens.ink2,
            ),
          ),
        ),
        ?action,
      ],
    ),
  );
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding = EdgeInsets.zero});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    child: Padding(padding: padding, child: child),
  );
}
