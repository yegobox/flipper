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

  Future<void> pumpCard(WidgetTester tester, Tenant tenant) async {
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
      Tenant(id: 'u-king', name: 'Agent King', userId: 'u-king'),
    );

    expect(find.byKey(const ValueKey('tenant_pin_only_chip')), findsOneWidget);
    expect(find.text('PIN only'), findsOneWidget);
  });

  testWidgets('staff with an account row get no PIN only chip', (tester) async {
    await pumpCard(
      tester,
      Tenant(id: 't-cashier', name: 'Cashier', userId: 'u-cashier'),
    );

    expect(find.byKey(const ValueKey('tenant_pin_only_chip')), findsNothing);
  });
}
