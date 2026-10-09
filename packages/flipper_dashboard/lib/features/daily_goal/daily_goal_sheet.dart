import 'package:flipper_dashboard/dashboard_quick_apps_navigation.dart';
import 'package:flipper_dashboard/features/daily_goal/daily_goal_providers.dart';
import 'package:flipper_dashboard/widgets/dashboard_app_access.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/helpers/daily_goal_rules.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

String dailyGoalMissionShortLabel(
  FlipperAppLocalizations l10n,
  GoalMission m,
) => switch (m) {
  GoalMission.sale => l10n.dailyGoalChipSale,
  GoalMission.expense => l10n.dailyGoalChipExpense,
  GoalMission.stock => l10n.dailyGoalChipStock,
  GoalMission.goal => l10n.dailyGoalChipGoal,
};

String _missionTitle(FlipperAppLocalizations l10n, GoalMission m) =>
    switch (m) {
      GoalMission.sale => l10n.dailyGoalMissionSale,
      GoalMission.expense => l10n.dailyGoalMissionExpense,
      GoalMission.stock => l10n.dailyGoalMissionStock,
      GoalMission.goal => l10n.dailyGoalMissionGoal,
    };

/// The dashboard page each mission's "Do it" opens.
String? dailyGoalMissionPage(GoalMission m) => switch (m) {
  GoalMission.sale || GoalMission.goal => 'POS',
  GoalMission.expense => 'Cashbook',
  GoalMission.stock => 'StockRecount',
};

Future<void> showDailyGoalSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder: (_) => const DailyGoalSheet(),
  );
}

/// Today's missions, the week, and the goal's settings.
class DailyGoalSheet extends ConsumerWidget {
  const DailyGoalSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final view = ref.watch(dailyGoalProvider)?.value;
    if (view == null) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final canEdit = ref.watch(dashboardIsAdminProvider);
    final title = GoogleFonts.outfit(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF111827),
    );
    final caption = GoogleFonts.outfit(
      fontSize: 12.5,
      color: const Color(0xFF6B7280),
    );

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.82,
      maxChildSize: 0.95,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          Text(l10n.dailyGoalSheetTitle, style: title),
          const SizedBox(height: 12),
          Row(
            children: [
              _Stat(
                key: const Key('daily-goal-sheet-streak'),
                icon: Icons.local_fire_department,
                color: const Color(0xFFE8590C),
                value: l10n.dailyGoalStreakShort(view.streak),
                label: l10n.dailyGoalBestStreak(view.bestStreak),
              ),
              const SizedBox(width: 10),
              _Stat(
                key: const Key('daily-goal-sheet-points'),
                icon: Icons.stars_rounded,
                color: const Color(0xFFB45309),
                value: l10n.dailyGoalPoints(view.points),
                label: l10n.dailyGoalPointsToday(view.todayPoints),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(l10n.dailyGoalMissionsHeading.toUpperCase(), style: caption),
          const SizedBox(height: 6),
          for (final m in GoalMission.values)
            _MissionRow(
              key: Key('daily-goal-row-${m.name}'),
              title: _missionTitle(l10n, m),
              subtitle: m == GoalMission.goal
                  ? l10n.dashViewTodaysGoal(
                      '${view.today.sales}',
                      '${view.target}',
                    )
                  : null,
              points: goalMissionPoints(m),
              done: view.done.contains(m),
              onDo: () async {
                final page = dailyGoalMissionPage(m);
                if (page == null) return;
                final nav = Navigator.of(context, rootNavigator: true);
                Navigator.of(context).pop();
                await navigateToDashboardAppPage(
                  context: nav.context,
                  isBigScreen: false,
                  page: page,
                  ref: ref,
                  navigator: nav,
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              l10n.dailyGoalStreakRule(
                kGoalStreakMilestoneDays,
                kGoalPointsStreakMilestone,
              ),
              style: caption,
            ),
          ),
          const SizedBox(height: 18),
          Text(l10n.dailyGoalThisWeek.toUpperCase(), style: caption),
          const SizedBox(height: 8),
          _WeekStrip(view: view),
          const SizedBox(height: 18),
          Text(l10n.dailyGoalSettingsHeading.toUpperCase(), style: caption),
          _TargetEditor(view: view, enabled: canEdit),
          SwitchListTile.adaptive(
            key: const Key('daily-goal-reminders'),
            contentPadding: EdgeInsets.zero,
            value: view.remindersEnabled,
            onChanged: canEdit
                ? (v) => ref
                      .read(dailyGoalActionsProvider)
                      .save(
                        view,
                        remindersEnabled: v,
                        locale: Localizations.localeOf(context).languageCode,
                      )
                : null,
            title: Text(l10n.dailyGoalReminders),
            subtitle: Text(l10n.dailyGoalRemindersHint, style: caption),
          ),
          if (!canEdit) Text(l10n.dailyGoalOwnerOnly, style: caption),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    super.key,
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8EB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFCE0BE)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF92400E),
                    ),
                  ),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: const Color(0xFFB45309),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissionRow extends StatelessWidget {
  const _MissionRow({
    super.key,
    required this.title,
    required this.points,
    required this.done,
    required this.onDo,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final int points;
  final bool done;
  final VoidCallback onDo;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        done ? Icons.check_circle : Icons.radio_button_unchecked,
        color: done ? const Color(0xFF047857) : const Color(0xFF9CA3AF),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          decoration: done ? TextDecoration.lineThrough : null,
          color: done ? const Color(0xFF6B7280) : const Color(0xFF111827),
        ),
      ),
      subtitle: Text(
        [
          if (subtitle != null) subtitle!,
          l10n.dailyGoalPlusPoints(points),
        ].join(' · '),
      ),
      trailing: done
          ? Text(
              l10n.dailyGoalDone,
              style: const TextStyle(
                color: Color(0xFF047857),
                fontWeight: FontWeight.w700,
              ),
            )
          : FilledButton.tonal(
              onPressed: onDo,
              child: Text(l10n.dailyGoalDoIt),
            ),
    );
  }
}

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({required this.view});
  final DailyGoalView view;

  @override
  Widget build(BuildContext context) {
    final week = view.state?.week ?? const [];
    final l10n = context.flipperL10n;
    if (week.isEmpty) {
      return Text(
        l10n.dailyGoalWeekEmpty,
        style: GoogleFonts.outfit(fontSize: 13, color: const Color(0xFF6B7280)),
      );
    }
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final d in week)
          Column(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: d.goalMet
                      ? const Color(0xFFFB9D00)
                      : const Color(0xFFF3F4F6),
                ),
                child: d.goalMet
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              const SizedBox(height: 4),
              Text(
                MaterialLocalizations.of(context).narrowWeekdays[d.day.weekday %
                    7],
                semanticsLabel: '${d.day.day}/${d.day.month} $locale',
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

/// The daily target: adaptive, or the owner's own number.
class _TargetEditor extends ConsumerWidget {
  const _TargetEditor({required this.view, required this.enabled});
  final DailyGoalView view;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final custom = view.targetOverride != null;
    final actions = ref.read(dailyGoalActionsProvider);
    final locale = Localizations.localeOf(context).languageCode;

    Future<void> set(int t) =>
        actions.save(view, targetOverride: t.clamp(1, 10000), locale: locale);

    return ListTile(
      key: const Key('daily-goal-target'),
      contentPadding: EdgeInsets.zero,
      title: Text(l10n.dailyGoalTarget(view.target)),
      subtitle: Text(
        custom ? l10n.dailyGoalTargetCustom : l10n.dailyGoalTargetAuto,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            key: const Key('daily-goal-target-minus'),
            onPressed: enabled && view.target > 1
                ? () => set(view.target - 1)
                : null,
            icon: const Icon(Icons.remove_circle_outline),
          ),
          IconButton(
            key: const Key('daily-goal-target-plus'),
            onPressed: enabled ? () => set(view.target + 1) : null,
            icon: const Icon(Icons.add_circle_outline),
          ),
          if (custom)
            TextButton(
              key: const Key('daily-goal-target-auto'),
              onPressed: enabled
                  ? () => actions.save(
                      view,
                      clearTargetOverride: true,
                      locale: locale,
                    )
                  : null,
              child: Text(l10n.dailyGoalUseAutomatic),
            ),
        ],
      ),
    );
  }
}
