import 'package:flipper_dashboard/features/admin/sections/admin_profile_card.dart';
import 'package:flipper_dashboard/features/admin/sections/receipt_logo_card.dart';
import 'package:flipper_dashboard/features/admin/sections/sms_notifications_card.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import '../../test_helpers/mocks.dart';

/// The Admin Control sections moved out of AdminControl.dart: desktop keeps
/// its side-by-side layout, `compact` stacks for the phone settings hub.
void main() {
  late MockBox box;

  setUp(() {
    box = MockBox();
    when(() => box.getBranchId()).thenReturn('branch-1');
    when(() => box.getUserId()).thenReturn(null);
    when(() => box.receiptLogoBase64()).thenReturn(null);
    if (getIt.isRegistered<LocalStorage>()) getIt.unregister<LocalStorage>();
    getIt.registerSingleton<LocalStorage>(box);
    if (locator.isRegistered<SettingsService>()) {
      locator.unregister<SettingsService>();
    }
    locator.registerSingleton<SettingsService>(SettingsService());
  });

  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    required double width,
  }) {
    tester.view.physicalSize = Size(width, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    return tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates:
              FlipperAppLocalizations.localizationsDelegates,
          supportedLocales: FlipperAppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: Padding(padding: const EdgeInsets.all(16), child: child),
            ),
          ),
        ),
      ),
    );
  }

  Finder fixedWidthPhoneField() => find.ancestor(
    of: find.byType(TextField),
    matching: find.byWidgetPredicate((w) => w is SizedBox && w.width == 200),
  );

  testWidgets('SMS card: desktop keeps the 200px field beside its label', (
    tester,
  ) async {
    await pump(tester, const SmsNotificationsCard(), width: 1280);
    await tester.pump();
    final l10n = FlipperL10n.current;
    expect(find.text(l10n.adminSmsPhoneNumber), findsOneWidget);
    expect(find.text(l10n.enableSmsNotifications), findsOneWidget);
    expect(find.text(l10n.enableWhatsappNotifications), findsOneWidget);
    expect(fixedWidthPhoneField(), findsOneWidget);
  });

  testWidgets('SMS card: compact puts a full-width field under the label', (
    tester,
  ) async {
    await pump(tester, const SmsNotificationsCard(compact: true), width: 360);
    await tester.pump();
    expect(fixedWidthPhoneField(), findsNothing);
    final label = tester.getRect(
      find.text(FlipperL10n.current.adminSmsPhoneNumber),
    );
    final field = tester.getRect(find.byType(TextField));
    expect(field.top, greaterThan(label.bottom));
    expect(field.width, greaterThan(280));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Receipt logo: desktop row, compact stacks the buttons', (
    tester,
  ) async {
    final upload = find.text(FlipperL10n.current.adminUploadLogo);

    await pump(tester, const ReceiptLogoCard(), width: 1280);
    final hintDesktop = tester.getRect(
      find.text(FlipperL10n.current.adminReceiptLogoHint),
    );
    expect(tester.getRect(upload).left, greaterThan(hintDesktop.right));

    await pump(tester, const ReceiptLogoCard(compact: true), width: 360);
    final hintPhone = tester.getRect(
      find.text(FlipperL10n.current.adminReceiptLogoHint),
    );
    expect(tester.getRect(upload).top, greaterThan(hintPhone.top));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Profile card: signed-out fallback, quiet has no gradient', (
    tester,
  ) async {
    await pump(
      tester,
      const AdminProfileCard(quiet: true, showDailyReportRecipients: false),
      width: 360,
    );
    await tester.pump();
    expect(find.text(FlipperL10n.current.adminUserFallback), findsOneWidget);
    final gradients = tester
        .widgetList<Container>(find.byType(Container))
        .where(
          (c) =>
              c.decoration is BoxDecoration &&
              (c.decoration as BoxDecoration).gradient != null,
        );
    expect(gradients, isEmpty);
  });
}
