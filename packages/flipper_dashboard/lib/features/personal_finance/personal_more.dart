import 'package:flipper_dashboard/features/admin/mobile/settings_list.dart';
import 'package:flipper_dashboard/features/admin/widgets/language_settings_card.dart';
import 'package:flipper_dashboard/features/admin/widgets/sms_bridge_page.dart';
import 'package:flipper_dashboard/features/personal_finance/personal_mode_switch.dart';
import 'package:flipper_dashboard/features/personal_goals/personal_goals_screen.dart';
import 'package:flipper_dashboard/logout/dashboard_sign_out.dart';
import 'package:flipper_dashboard/widgets/dashboard_app_access.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/account_mode/account_mode.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';

/// Settings for a personal account: the SMS Bridge, savings goals, language,
/// going back to a business, and signing out.
class PersonalMore extends ConsumerWidget {
  const PersonalMore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final isAdmin = ref.watch(dashboardIsAdminProvider);
    return ListView(
      key: const ValueKey('personal-more'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        SettingsGroup(
          children: [
            SettingsRow(
              icon: Icons.phonelink_ring_outlined,
              title: l10n.smsBridgeTitle,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SmsBridgePage()),
              ),
            ),
            SettingsRow(
              icon: Icons.savings_outlined,
              title: l10n.personalMoneySavingsGoals,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const PersonalGoalsScreen(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SettingsGroup(
          label: l10n.account,
          children: [
            SettingsRow(
              icon: Icons.translate_rounded,
              title: l10n.language,
              onTap: () => SettingsSubpage.push(
                context,
                title: l10n.language,
                child: const LanguageSettingsCard(),
              ),
            ),
            if (isAdmin)
              SettingsRow(
                key: const ValueKey('personal-switch-to-business'),
                icon: Icons.storefront_outlined,
                title: l10n.personalMoneySwitchToBusiness,
                onTap: () => confirmAndSwitchAccountMode(
                  context,
                  ref,
                  AccountMode.business,
                ),
              ),
            SettingsRow(
              icon: Icons.logout_rounded,
              title: l10n.logOut,
              destructive: true,
              onTap: () => completeDashboardSignOut(
                context: context,
                dialogService: locator<DialogService>(),
                routerService: locator<RouterService>(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
