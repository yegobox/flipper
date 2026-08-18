import 'package:flipper_hr/features/billing/application/hr_billing_providers.dart';
import 'package:flipper_hr/features/billing/data/hr_entitlement.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Hides a manager surface behind the subscription, with a way out.
///
/// Wrapped around the pages that belong to whoever runs the business — the
/// roster, the approvals queue, the attendance board. Self-service leave and
/// self-service time are deliberately NOT wrapped: an invited employee cannot
/// pay their employer's invoice, and holding their own leave balance hostage
/// over it collects nothing from anybody.
class HrBillingGate extends ConsumerWidget {
  const HrBillingGate({super.key, required this.child, this.featureName});

  final Widget child;

  /// Named in the lock panel's heading ("The roster is locked").
  final String? featureName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessId = ref.watch(selectedBusinessProvider)?.id;
    final access = ref.watch(hrAccessSnapshotProvider(businessId));
    if (access.grantsAccess) return child;
    return HrPaywallPanel(access: access, featureName: featureName);
  }
}

/// The lock itself, split out so it can be laid out and tested without an
/// entitlement state behind it.
class HrPaywallPanel extends StatelessWidget {
  const HrPaywallPanel({super.key, required this.access, this.featureName});

  final HrAccessState access;
  final String? featureName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final feature = featureName ?? 'This';
    final lapsed = access.hasLapsed;

    return Center(
      key: const Key('hr-paywall-panel'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 36,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    lapsed
                        ? 'Your subscription has ended'
                        : '$feature needs a subscription',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lapsed
                        ? 'Nothing has been deleted — the roster, leave and '
                              'attendance records are all still here. Renew the '
                              'subscription to open them again.'
                        : 'Flipper HR is part of the Flipper subscription. Pay '
                              'for the business once and the roster, leave and '
                              'attendance open for everyone on it.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (access.isAwaitingSettlement) ...[
                    const SizedBox(height: 12),
                    Text(
                      'A payment is already on its way. If you approved it on '
                      'your phone, this unlocks as soon as Mobile Money '
                      'confirms it.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    key: const Key('hr-paywall-subscribe'),
                    onPressed: () => context.go('/subscribe'),
                    icon: const Icon(Icons.workspace_premium_outlined),
                    label: Text(lapsed ? 'Renew now' : 'See the plan'),
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

/// The strip above a page's content while something about billing needs saying.
///
/// Renders nothing when the subscription is paid and comfortably current — the
/// common case must be silent, or the warning stops being read.
class HrBillingNotice extends ConsumerWidget {
  const HrBillingNotice({
    super.key,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 0),
  });

  final EdgeInsetsGeometry padding;

  /// How close to the end of the period the countdown starts.
  static const int warnWithinDays = 7;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessId = ref.watch(selectedBusinessProvider)?.id;
    final asyncAccess = ref.watch(hrAccessStateProvider(businessId));
    final access = asyncAccess.value ?? const HrAccessState.unknown();

    // The one case that must never be silent: Supabase is live, the billing
    // schema is not, so every business looks entitled and nobody is being
    // charged. Said plainly, with the fix, in every build.
    if (access.schemaMissing) {
      return Padding(
        padding: padding,
        child: _Strip(
          key: const Key('hr-billing-schema-missing'),
          tone: _Tone.danger,
          icon: Icons.warning_amber_outlined,
          message:
              'Billing is not installed on this Supabase project, so nobody is '
              'being charged. Run supabase/migrations/0008_hr_billing.sql.',
        ),
      );
    }

    if (asyncAccess.hasError) {
      return Padding(
        padding: padding,
        child: _Strip(
          key: const Key('hr-billing-unreachable'),
          tone: _Tone.warning,
          icon: Icons.cloud_off_outlined,
          message:
              'Could not check this business\'s subscription, so it is being '
              'left open for now.',
          action: TextButton(
            onPressed: () => ref.invalidate(hrAccessStateProvider(businessId)),
            child: const Text('Try again'),
          ),
        ),
      );
    }

    if (!access.enforced) return const SizedBox.shrink();

    if (access.testMode) {
      return Padding(
        padding: padding,
        child: const _Strip(
          key: Key('hr-billing-test-mode'),
          tone: _Tone.warning,
          icon: Icons.science_outlined,
          message:
              'Test pricing is switched on for this project, so subscriptions '
              'are charged at a reduced amount.',
        ),
      );
    }

    final days = access.daysLeft();
    if (access.status == HrAccessStatus.entitled &&
        days != null &&
        days <= warnWithinDays) {
      final left = switch (days) {
        0 => 'ends today',
        1 => 'ends tomorrow',
        _ => 'ends in $days days',
      };
      return Padding(
        padding: padding,
        child: _Strip(
          key: const Key('hr-billing-expiring'),
          tone: _Tone.warning,
          icon: Icons.schedule,
          message: 'Your subscription $left.',
          action: TextButton(
            onPressed: () => context.go('/subscribe'),
            child: const Text('Renew'),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

enum _Tone { warning, danger }

class _Strip extends StatelessWidget {
  const _Strip({
    super.key,
    required this.tone,
    required this.icon,
    required this.message,
    this.action,
  });

  final _Tone tone;
  final IconData icon;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground = switch (tone) {
      _Tone.danger => scheme.onErrorContainer,
      _Tone.warning => scheme.onTertiaryContainer,
    };
    final background = switch (tone) {
      _Tone.danger => scheme.errorContainer,
      _Tone.warning => scheme.tertiaryContainer,
    };

    return Container(
      padding: EdgeInsets.fromLTRB(12, 10, action == null ? 12 : 4, 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      // Wrap rather than Row: the message plus a button overflows a phone
      // width, and this notice must never be the thing that breaks a layout.
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 4,
        children: [
          Icon(icon, size: 16, color: foreground),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
