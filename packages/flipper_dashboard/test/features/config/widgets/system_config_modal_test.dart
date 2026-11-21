import 'package:flipper_dashboard/features/config/widgets/support_section.dart';
import 'package:flipper_dashboard/features/config/widgets/system_config_modal.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/ebm_provider.dart';
import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_helpers/setup.dart';

// flutter test test/features/config/widgets/system_config_modal_test.dart
//
// The dialog used to decide "tax form or contact support" from the device's
// cached EBM row alone, and only the tax form ever re-fetched it. A device that
// cached `vatEnabled: false` before support enabled EBM on the server therefore
// showed "contact support" forever.
void main() {
  late TestEnvironment env;

  Ebm serverEbm({required bool vatEnabled}) => Ebm(
    mrc: 'WIS00253379',
    bhfId: '01',
    tinNumber: 108754813,
    dvcSrlNo: '1351571294',
    userId: 'u1',
    taxServerUrl: 'https://vsdc.example.test/',
    businessId: '1',
    branchId: '1',
    vatEnabled: vatEnabled,
  );

  void stubEbm(Ebm? ebm) {
    when(
      () => env.mockDbSync.ebm(
        branchId: any(named: 'branchId'),
        fetchRemote: any(named: 'fetchRemote'),
      ),
    ).thenAnswer((_) async => ebm);
  }

  void stubCachedTaxEnabled(bool enabled) {
    when(
      () => env.mockDbSync.isTaxEnabled(
        businessId: any(named: 'businessId'),
        branchId: any(named: 'branchId'),
      ),
    ).thenAnswer((_) async => enabled);
  }

  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    env = TestEnvironment();
    await env.init();
  });

  tearDownAll(() async {
    await env.dispose();
  });

  setUp(() {
    env.injectMocks();
    env.stubCommonMethods();
    // The mocks outlive each test; only this test's calls should count.
    clearInteractions(env.mockDbSync);
    when(() => env.mockBox.isTrainingMode()).thenReturn(false);
    when(() => env.mockBox.isProformaMode()).thenReturn(false);
    when(() => env.mockBox.A4()).thenReturn(false);
    when(() => env.mockBox.exportAsPdf()).thenReturn(false);
    when(() => env.mockBox.mrc()).thenReturn(null);
    when(
      () => env.mockBox.writeBool(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});
  });

  tearDown(() => LocalMode.debugReset());

  Future<void> pumpCard(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [ebmVatEnabledProvider.overrideWith((ref) async => true)],
        child: MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: const Scaffold(body: Center(child: SystemConfigModalCard())),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'a server-side enable shows the tax form over a stale cached "off"',
    (tester) async {
      stubCachedTaxEnabled(false);
      stubEbm(serverEbm(vatEnabled: true));

      await pumpCard(tester);

      expect(find.byType(SupportSection), findsNothing);
      // The form is filled from the row that was just fetched.
      expect(find.text('WIS00253379'), findsOneWidget);
      expect(find.text('01'), findsOneWidget);
      verify(
        () => env.mockDbSync.ebm(branchId: '1', fetchRemote: true),
      ).called(1);
      verifyNever(
        () => env.mockDbSync.isTaxEnabled(
          businessId: any(named: 'businessId'),
          branchId: any(named: 'branchId'),
        ),
      );
    },
  );

  testWidgets('the server row decides even when it says off', (tester) async {
    stubCachedTaxEnabled(true);
    stubEbm(serverEbm(vatEnabled: false));

    await pumpCard(tester);

    expect(find.byType(SupportSection), findsOneWidget);
  });

  testWidgets('no server row falls back to the cache: support when off', (
    tester,
  ) async {
    stubCachedTaxEnabled(false);
    stubEbm(null);

    await pumpCard(tester);

    expect(find.byType(SupportSection), findsOneWidget);
    verify(
      () => env.mockDbSync.isTaxEnabled(businessId: '1', branchId: '1'),
    ).called(1);
  });

  testWidgets('no server row falls back to the cache: form when on', (
    tester,
  ) async {
    stubCachedTaxEnabled(true);
    stubEbm(null);

    await pumpCard(tester);

    expect(find.byType(SupportSection), findsNothing);
  });

  testWidgets('local mode never asks the server', (tester) async {
    LocalMode.debugSet(true);
    stubCachedTaxEnabled(false);
    stubEbm(serverEbm(vatEnabled: true));

    await pumpCard(tester);

    expect(find.byType(SupportSection), findsOneWidget);
    verifyNever(
      () => env.mockDbSync.ebm(
        branchId: any(named: 'branchId'),
        fetchRemote: any(named: 'fetchRemote'),
      ),
    );
  });
}
