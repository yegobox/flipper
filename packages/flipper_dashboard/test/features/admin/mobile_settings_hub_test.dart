import 'package:flipper_dashboard/features/admin/mobile/mobile_settings_hub.dart';
import 'package:flipper_dashboard/features/admin/widgets/cash_reset_dialog.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart' show Setting;
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import '../../test_helpers/mocks.dart';

const _user = 'user-1';

/// Reads nothing from the sync layer; every toggle starts off.
class _QuietSettings extends SettingsService {
  @override
  Future<Setting?> settings() async => null;
  @override
  void getAdminPinToggleState() {}
  @override
  void getPriceQuantityAdjustmentToggleState() {}
  @override
  void getCurrencyDecimalToggleState() {}
}

void main() {
  setUp(() {
    final box = MockBox();
    when(() => box.readBool(key: any(named: 'key'))).thenReturn(null);
    when(() => box.getBranchId()).thenReturn('branch-1');
    if (getIt.isRegistered<LocalStorage>()) getIt.unregister<LocalStorage>();
    getIt.registerSingleton<LocalStorage>(box);
    if (locator.isRegistered<SettingsService>()) {
      locator.unregister<SettingsService>();
    }
    locator.registerSingleton<SettingsService>(_QuietSettings());
  });

  /// A phone: 360dp wide. [height] is tall enough to build every row of the
  /// lazy list unless a test wants the real 780.
  Future<void> pump(
    WidgetTester tester, {
    required bool admin,
    double width = 360,
    double height = 2600,
  }) async {
    tester.view.physicalSize = Size(width * 3, height * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isAdminProvider(
            _user,
            featureName: AppFeature.Settings,
          ).overrideWith((ref) async => admin),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates:
              FlipperAppLocalizations.localizationsDelegates,
          supportedLocales: FlipperAppLocalizations.supportedLocales,
          home: const Scaffold(
            body: MobileSettingsHub(
              branchName: 'Kigali Main',
              branchId: 'branch-1',
              userId: _user,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('an admin gets every phone group, and no desktop-only tools', (
    tester,
  ) async {
    await pump(tester, admin: true);
    final l10n = FlipperL10n.current;

    for (final label in [
      l10n.account,
      l10n.settingsGroupMoney,
      l10n.sales,
      l10n.settingsGroupNotifications,
      l10n.settingsGroupDevices,
      l10n.security,
      l10n.settingsGroupReceipts,
      l10n.cashResetSectionTitle,
    ]) {
      expect(find.text(label.toUpperCase()), findsOneWidget, reason: label);
    }
    for (final row in [
      l10n.adminProfile,
      l10n.userManagement,
      l10n.branchManagement,
      l10n.taxSettings,
      l10n.paymentMethods,
      l10n.posDefault,
      l10n.smsNotifications,
      l10n.administratorPin,
      l10n.adminReceiptLogo,
      l10n.cashResetTitle,
    ]) {
      expect(find.text(row), findsOneWidget, reason: row);
    }
    // Left on desktop by design.
    for (final gone in [
      l10n.hydrateData,
      l10n.assetDownload,
      l10n.userLogging,
      l10n.reinitializeEbm,
    ]) {
      expect(find.text(gone), findsNothing, reason: gone);
    }
  });

  testWidgets('everyone else gets the short list in the same design', (
    tester,
  ) async {
    await pump(tester, admin: false);
    final l10n = FlipperL10n.current;
    expect(find.text(l10n.userManagement), findsOneWidget);
    expect(find.text(l10n.language), findsOneWidget);
    expect(find.text(l10n.cashResetTitle), findsNothing);
    expect(find.text(l10n.taxSettings), findsNothing);
    expect(find.text(l10n.security.toUpperCase()), findsNothing);
  });

  testWidgets('quiet look: grey line icons, no coloured tiles or artwork', (
    tester,
  ) async {
    await pump(tester, admin: true);
    expect(find.byType(SvgPicture), findsNothing);
    final colours = tester
        .widgetList<Icon>(find.byType(Icon))
        .map((i) => i.color)
        .toSet();
    expect(
      colours.difference({PosTokens.ink3, PosTokens.ink4, PosTokens.lossInk}),
      isEmpty,
      reason: 'icon colours: $colours',
    );
  });

  testWidgets('fits a 320dp phone without overflow', (tester) async {
    await pump(tester, admin: true, width: 320, height: 640);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Clear Cash Book opens the reset flow as a bottom sheet', (
    tester,
  ) async {
    await pump(tester, admin: true);
    await tester.tap(find.byKey(const ValueKey('settings-clear-cash-book')));
    await tester.pumpAndSettle();
    expect(find.byType(CashResetDialog), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byKey(const ValueKey('cash-reset-preview')), findsOneWidget);
  });
}
