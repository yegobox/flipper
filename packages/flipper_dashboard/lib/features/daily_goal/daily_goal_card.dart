import 'package:flipper_dashboard/features/daily_goal/daily_goal_providers.dart';
import 'package:flipper_dashboard/features/daily_goal/daily_goal_sheet.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_states.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/helpers/daily_goal_rules.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

const _ink = Color(0xFF92400E);
const _inkSoft = Color(0xFFB45309);
const _track = Color(0xFFFCE0BE);
const _fill = Color(0xFFFB9D00);

/// The home screen's "Today's goal": sales towards today's target, the
/// streak, points, and the day's missions. Tap for the full sheet.
class DailyGoalCard extends ConsumerWidget {
  const DailyGoalCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = ref.watch(dailyGoalProvider);
    if (goal == null) return const SizedBox.shrink();
    return goal.when(
      // Fixed-height placeholder so the cards above don't shift when the
      // goal arrives; on error the goal is simply left out.
      loading: () => const MposSkeletonCard(height: 132, lines: 2),
      error: (_, __) => const SizedBox.shrink(),
      data: (view) => _Card(view: view),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.view});
  final DailyGoalView view;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final v = view;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: const Key('daily-goal-card'),
        borderRadius: BorderRadius.circular(20),
        onTap: () => showDailyGoalSheet(context),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF8EB), Color(0xFFFFF3D6)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _track),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC24B).withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      v.streak > 0
                          ? Icons.local_fire_department
                          : Icons.card_giftcard_outlined,
                      color: v.streak > 0 ? const Color(0xFFE8590C) : _ink,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.dashViewTodaysGoal(
                            '${v.today.sales}',
                            '${v.target}',
                          ),
                          key: const Key('daily-goal-title'),
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text.rich(
                          TextSpan(
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: _inkSoft,
                            ),
                            children: [
                              TextSpan(
                                text: v.today.sales == 0
                                    ? l10n.dashViewLogFirstSale
                                    : v.goalReached
                                    ? l10n.dashViewGoalReached
                                    : l10n.dashViewJustMoreTo('${v.remaining}'),
                              ),
                              if (v.today.sales > 0 && !v.goalReached)
                                TextSpan(
                                  text: l10n.dailyGoalPlusPoints(
                                    kGoalPointsGoal,
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        l10n.dailyGoalPoints(v.points),
                        key: const Key('daily-goal-points'),
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _ink,
                        ),
                      ),
                      if (v.streak > 0)
                        Text(
                          l10n.dailyGoalStreakShort(v.streak),
                          key: const Key('daily-goal-streak'),
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: _inkSoft,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: v.progress),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) => LinearProgressIndicator(
                    value: value,
                    minHeight: 6,
                    backgroundColor: _track,
                    valueColor: const AlwaysStoppedAnimation<Color>(_fill),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final m in const [
                    GoalMission.sale,
                    GoalMission.expense,
                    GoalMission.stock,
                  ])
                    _MissionChip(
                      key: Key('daily-goal-mission-${m.name}'),
                      label: dailyGoalMissionShortLabel(l10n, m),
                      done: v.done.contains(m),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MissionChip extends StatelessWidget {
  const _MissionChip({super.key, required this.label, required this.done});
  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      checked: done,
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 3, 9, 3),
        decoration: BoxDecoration(
          color: done ? const Color(0xFFECFDF5) : Colors.white70,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: done ? const Color(0xFF6EE7B7) : _track),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              done ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 14,
              color: done ? const Color(0xFF047857) : _inkSoft,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: done ? const Color(0xFF047857) : _ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
