import 'package:flipper_dashboard/features/tenant/mixins/tenant_ui_mixin.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/view_models/flipperBaseModel.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import '../../test_helpers/mocks.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    final mockBox = MockBox();
    getIt.registerSingleton<LocalStorage>(mockBox);
    when(() => mockBox.getUserId()).thenReturn('someone-else');
  });

  Future<void> pumpCard(
    WidgetTester tester,
    Tenant tenant, {
    double? width,
  }) async {
    if (width != null) {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
    }
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TenantUIMixin.buildTenantCardStatic(
              context,
              tenant,
              FlipperBaseModel(),
              false,
              (_) async {},
              (ctx, t, m) {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('PIN-only staff get a PIN only chip', (tester) async {
    await pumpCard(
      tester,
      Tenant(id: 'u-king', name: 'Agent King', userId: 'u-king', pin: 1234),
    );

    expect(find.byKey(const ValueKey('tenant_pin_only_chip')), findsOneWidget);
    expect(find.text('PIN only'), findsOneWidget);
  });

  testWidgets('a stand-in row with no PIN gets no PIN only chip', (
    tester,
  ) async {
    await pumpCard(tester, Tenant(id: 'u-o', name: 'Owner', userId: 'u-o'));

    expect(find.byKey(const ValueKey('tenant_pin_only_chip')), findsNothing);
  });

  testWidgets('on a phone the chip leaves room for the buttons', (
    tester,
  ) async {
    await pumpCard(
      tester,
      Tenant(
        id: 'u-king',
        name: 'Agent King of the Night Shift',
        userId: 'u-king',
        pin: 1234,
        type: 'Stock Manager',
      ),
      width: 320,
    );

    expect(tester.takeException(), isNull);
    expect(find.byKey(const ValueKey('tenant_pin_only_chip')), findsOneWidget);
    expect(find.byIcon(Icons.edit_outlined).hitTestable(), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline).hitTestable(), findsOneWidget);
  });

  testWidgets('staff with an account row get no PIN only chip', (tester) async {
    await pumpCard(
      tester,
      Tenant(id: 't-cashier', name: 'Cashier', userId: 'u-cashier'),
    );

    expect(find.byKey(const ValueKey('tenant_pin_only_chip')), findsNothing);
  });
}
