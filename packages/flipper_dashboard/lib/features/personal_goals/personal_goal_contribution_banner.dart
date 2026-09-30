import 'package:flipper_models/models/personal_goal.dart';
import 'package:flutter/material.dart';

/// One credit into a goal, as observed from a Ditto snapshot.
class PersonalGoalCredit {
  const PersonalGoalCredit({required this.goal, required this.amount});

  final PersonalGoal goal;
  final double amount;
}

/// Copy + progress for [PersonalGoalContributionBanner].
///
/// Kept free of `flipper_services` so the banner stays testable in isolation.
class PersonalGoalBannerData {
  const PersonalGoalBannerData({
    required this.headline,
    required this.detail,
    this.progress,
    this.percentLabel,
    this.reached = false,
  });

  final String headline;
  final String detail;

  /// 0..1, or null when there is no single target to show progress against.
  final double? progress;
  final String? percentLabel;

  /// True when a credited goal hit its target.
  final bool reached;

  Duration get displayDuration =>
      reached ? const Duration(seconds: 8) : const Duration(seconds: 5);

  /// Builds the banner copy for one or more credits that landed together
  /// (a single sale's auto-sweep can credit several goals at once).
  ///
  /// Credits to the same goal are merged; the latest goal snapshot wins.
  factory PersonalGoalBannerData.fromCredits(
    List<PersonalGoalCredit> credits, {
    required String Function(double amount) formatAmount,
    DateTime? now,
  }) {
    assert(credits.isNotEmpty);
    final at = now ?? DateTime.now();
    final byGoal = <String, PersonalGoalCredit>{};
    for (final c in credits) {
      final prev = byGoal[c.goal.id];
      byGoal[c.goal.id] = PersonalGoalCredit(
        goal: c.goal,
        amount: (prev?.amount ?? 0) + c.amount,
      );
    }
    final merged = byGoal.values.toList();

    if (merged.length == 1) {
      final goal = merged.single.goal;
      final amount = merged.single.amount;
      if (goal.isAtOrAboveTarget) {
        final period = goal.isRecurring ? goal.periodKey : null;
        return PersonalGoalBannerData(
          headline: period == null
              ? 'Goal reached: ${goal.name}'
              : 'Goal reached for ${goalPeriodName(period)}: ${goal.name}',
          detail: period == null
              ? 'Target of ${formatAmount(goal.targetAmount)} met'
              : 'Target of ${formatAmount(goal.targetAmount)} met · '
                    '${goal.recurrence.restartDateLabel(at)}',
          progress: 1,
          percentLabel: '100%',
          reached: true,
        );
      }
      final hasTarget = goal.targetAmount > 0;
      return PersonalGoalBannerData(
        headline: '+${formatAmount(amount)} saved to ${goal.name}',
        detail: hasTarget
            ? '${formatAmount(goal.savedAmount)} of '
                  '${formatAmount(goal.targetAmount)}'
            : '${formatAmount(goal.savedAmount)} saved so far',
        progress: hasTarget ? goal.progressRatio : null,
        percentLabel: hasTarget ? '${goal.progressPercent}%' : null,
      );
    }

    final total = merged.fold<double>(0, (sum, c) => sum + c.amount);
    final reachedGoals = merged
        .where((c) => c.goal.isAtOrAboveTarget)
        .map((c) => c.goal);
    final detail = reachedGoals.isEmpty
        ? merged.map((c) => c.goal.name).join(' · ')
        : reachedGoals.length == 1
        ? '${reachedGoals.single.name} reached its target'
        : '${reachedGoals.length} goals reached their target';
    return PersonalGoalBannerData(
      headline: '+${formatAmount(total)} saved across ${merged.length} goals',
      detail: detail,
      reached: reachedGoals.isNotEmpty,
    );
  }
}

/// Notification card for a Personal Goal credit, styled after iOS/macOS
/// notification banners and Windows toasts: neutral surface, identity row,
/// headline, context line, and a single tap target that opens Goals.
class PersonalGoalContributionBanner extends StatelessWidget {
  const PersonalGoalContributionBanner({
    required this.data,
    required this.onTap,
    required this.onDismiss,
    this.onHoverChanged,
    super.key,
  });

  final PersonalGoalBannerData data;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  /// Desktop hosts pause auto-dismiss while the pointer is over the card.
  final ValueChanged<bool>? onHoverChanged;

  /// Same purple as the Personal Goals screen.
  static const accent = Color(0xFF7C3AED);
  static const reachedAccent = Color(0xFF16A34A);

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = dark ? const Color(0xFF1F2937) : Colors.white;
    final border = dark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);
    final ink = dark ? const Color(0xFFF9FAFB) : const Color(0xFF111827);
    final muted = dark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    final tint = data.reached ? reachedAccent : accent;
    final radius = BorderRadius.circular(14);

    return Semantics(
      container: true,
      liveRegion: true,
      child: MouseRegion(
        onEnter: (_) => onHoverChanged?.call(true),
        onExit: (_) => onHoverChanged?.call(false),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: radius,
            border: Border.all(color: border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: dark ? 0.40 : 0.10),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: dark ? 0.30 : 0.06),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              key: const Key('personal_goal_banner_body'),
              onTap: onTap,
              borderRadius: radius,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 6, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: tint,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        data.reached
                            ? Icons.emoji_events_outlined
                            : Icons.savings_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'PERSONAL GOAL  ·  now',
                            style: TextStyle(
                              color: muted,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.6,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data.headline,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: ink,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  data.detail,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: muted,
                                    fontSize: 13,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              if (data.percentLabel != null) ...[
                                const SizedBox(width: 8),
                                Text(
                                  data.percentLabel!,
                                  style: TextStyle(
                                    color: tint,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (data.progress != null) ...[
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: data.progress,
                                minHeight: 4,
                                backgroundColor: tint.withValues(
                                  alpha: dark ? 0.25 : 0.14,
                                ),
                                valueColor: AlwaysStoppedAnimation(tint),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Semantics, not Tooltip: Tooltip asserts under DevicePreview.
                    Semantics(
                      label: 'Dismiss',
                      button: true,
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: IconButton(
                          key: const Key('personal_goal_banner_close'),
                          padding: EdgeInsets.zero,
                          iconSize: 16,
                          onPressed: onDismiss,
                          icon: Icon(Icons.close_rounded, color: muted),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
