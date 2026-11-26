import 'package:flipper_dashboard/modals/_isBranchEnableForPayment.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';

// Own mocks: test_helpers/mocks.dart pulls in local_notification_service.dart.
class _MockBox extends Mock implements LocalStorage {}

class _MockDatabaseSync extends Mock implements DatabaseSyncInterface {}

class _MockSyncStrategy extends Mock implements SyncStrategy {}

const _branchId = 'branch-1';

/// "Payment methods" must open its sheet while Ditto is still opening. It used
/// to load the branch with `activeBranch()` first, which throws then, so the
/// sheet never appeared (PostHog inbox 01a210d9-01b3-7f33-a6de-2d9dae539857).
// flutter test test/payment_settings_modal_test.dart
void main() {
  late _MockBox box;
  late _MockDatabaseSync db;

  setUp(() async {
    await getIt.reset();
    box = _MockBox();
    db = _MockDatabaseSync();
    final strategy = _MockSyncStrategy();
    when(() => strategy.current).thenReturn(db);
    when(() => box.getBranchId()).thenReturn(_branchId);
    // What activeBranch() does while Ditto is not open and Brick has no row.
    when(() => db.activeBranch(branchId: any(named: 'branchId')))
        .thenThrow(Exception('Ditto not initialized for active branch query'));
    when(() => db.isBranchEnableForPayment(currentBranchId: _branchId))
        .thenAnswer((_) async => true);

    getIt
      ..registerSingleton<LocalStorage>(box)
      ..registerSingleton<SyncStrategy>(strategy, instanceName: 'strategy');
  });

  tearDown(() => getIt.reset());

  Future<void> tapOpen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
        supportedLocales: FlipperAppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showPaymentSettingsModal(context),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('opens for the stored branch without loading the branch', (
    tester,
  ) async {
    await tapOpen(tester);

    expect(find.text('Payment Settings'), findsOneWidget);
    expect(find.text('MTN Mobile Money'), findsOneWidget);
    expect(find.text('Enabled'), findsOneWidget);
    verify(() => db.isBranchEnableForPayment(currentBranchId: _branchId))
        .called(1);
    verifyNever(() => db.activeBranch(branchId: any(named: 'branchId')));
  });

  testWidgets('no stored branch: nothing opens and nothing throws', (
    tester,
  ) async {
    when(() => box.getBranchId()).thenReturn(null);

    await tapOpen(tester);

    expect(find.text('Payment Settings'), findsNothing);
    verifyNever(
      () => db.isBranchEnableForPayment(
        currentBranchId: any(named: 'currentBranchId'),
      ),
    );
  });
}
