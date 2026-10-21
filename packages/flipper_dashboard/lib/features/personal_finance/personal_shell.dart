import 'dart:async';

import 'package:flipper_ai_feature/flipper_ai_feature.dart' show AiScreen;
import 'package:flipper_dashboard/features/personal_finance/personal_add_money_sheet.dart';
import 'package:flipper_dashboard/features/personal_finance/personal_home.dart';
import 'package:flipper_dashboard/features/personal_finance/personal_more.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/sms_review/sms_review_section.dart'
    show registerSmsReviewPushHandler;
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/account_mode/account_mode_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Below this width the shell uses a bottom bar, above it a side rail.
const double kPersonalShellRailBreakpoint = 600;

/// The app for a personal-mode account (`docs/personal_mode.md`): money in and
/// out, SMS waiting for review, savings goals and Flo — no POS, stock or EBM.
/// [FlipperApp] shows it instead of the business app.
class PersonalShell extends ConsumerStatefulWidget {
  const PersonalShell({super.key, this.floBuilder});

  /// Tests replace Flo, which needs a full app boot.
  final WidgetBuilder? floBuilder;

  @override
  ConsumerState<PersonalShell> createState() => _PersonalShellState();
}

class _PersonalShellState extends ConsumerState<PersonalShell> {
  int _tab = 0;
  bool _floOpened = false;

  static const _flo = 2;

  void _select(int i) => setState(() {
    _tab = i;
    if (i == _flo) _floOpened = true;
  });

  @override
  void initState() {
    super.initState();
    // A personal signup that has not reached the server yet.
    unawaited(ref.read(accountModeStoreProvider).confirmPending());
    registerSmsReviewPushHandler();
  }

  void _addMoney() => showPersonalAddMoneySheet(context);

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final destinations = [
      (Icons.home_outlined, Icons.home_rounded, l10n.personalMoneyNavHome),
      (
        Icons.receipt_long_outlined,
        Icons.receipt_long_rounded,
        l10n.personalMoneyNavActivity,
      ),
      (
        Icons.auto_awesome_outlined,
        Icons.auto_awesome_rounded,
        l10n.personalMoneyNavFlo,
      ),
      (
        Icons.more_horiz_rounded,
        Icons.more_horiz_rounded,
        l10n.personalMoneyNavMore,
      ),
    ];
    final titles = [
      l10n.personalMoneyTitle,
      l10n.personalMoneyNavActivity,
      l10n.personalMoneyNavFlo,
      l10n.personalMoneyNavMore,
    ];
    final body = IndexedStack(
      index: _tab,
      children: [
        PersonalHome(onSeeAll: () => _select(1)),
        const PersonalActivity(),
        // Built only once opened: Flo starts a chat session.
        if (_floOpened)
          (widget.floBuilder ?? (_) => const AiScreen())(context)
        else
          const SizedBox.shrink(),
        const PersonalMore(),
      ],
    );
    final fab = _tab == _flo
        ? null
        : FloatingActionButton(
            key: const ValueKey('personal-add-money'),
            backgroundColor: PosTokens.blue,
            foregroundColor: Colors.white,
            tooltip: l10n.personalMoneyAddTitle,
            onPressed: _addMoney,
            child: const Icon(Icons.add_rounded),
          );
    final appBar = _tab == _flo
        ? null
        : AppBar(
            backgroundColor: PosTokens.posBg,
            surfaceTintColor: Colors.transparent,
            title: Text(
              titles[_tab],
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: PosTokens.ink1,
              ),
            ),
          );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < kPersonalShellRailBreakpoint) {
          return Scaffold(
            key: const ValueKey('personal-shell-phone'),
            backgroundColor: PosTokens.posBg,
            appBar: appBar,
            body: SafeArea(top: appBar == null, child: body),
            floatingActionButton: fab,
            bottomNavigationBar: NavigationBar(
              selectedIndex: _tab,
              onDestinationSelected: _select,
              indicatorColor: PosTokens.blueTint,
              destinations: [
                for (final (icon, selected, label) in destinations)
                  NavigationDestination(
                    icon: Icon(icon),
                    selectedIcon: Icon(selected, color: PosTokens.blue),
                    label: label,
                  ),
              ],
            ),
          );
        }
        return Scaffold(
          key: const ValueKey('personal-shell-desktop'),
          backgroundColor: PosTokens.posBg,
          body: SafeArea(
            child: Row(
              children: [
                NavigationRail(
                  selectedIndex: _tab,
                  onDestinationSelected: _select,
                  labelType: NavigationRailLabelType.all,
                  indicatorColor: PosTokens.blueTint,
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: fab ?? const SizedBox(height: 56),
                  ),
                  destinations: [
                    for (final (icon, selected, label) in destinations)
                      NavigationRailDestination(
                        icon: Icon(icon),
                        selectedIcon: Icon(selected, color: PosTokens.blue),
                        label: Text(label),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1, color: PosTokens.line),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: _tab == _flo ? double.infinity : 760,
                      ),
                      child: Scaffold(
                        backgroundColor: PosTokens.posBg,
                        appBar: appBar,
                        body: body,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
