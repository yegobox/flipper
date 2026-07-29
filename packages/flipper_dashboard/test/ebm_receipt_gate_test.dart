import 'package:flipper_dashboard/utils/ebm_receipt_gate.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/FirebaseCrashlyticService.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';

// Deliberately does not import `test_helpers/mocks.dart`: that pulls in
// `flipper_services/local_notification_service.dart`, which currently fails to
// compile against the resolved `flutter_local_notifications`.
class _MockCapella extends Mock implements DatabaseSyncInterface {}

class MockBox extends Mock implements LocalStorage {
  @override
  String defaultCurrency() => 'USD';
}

class MockSyncStrategy extends Mock implements SyncStrategy {}

const _businessId = 'biz-1';
const _branchId = 'branch-1';

/// Guards the purchase-code prompt in [PreviewCartMixin]: a business whose sale
/// never reaches RRA must not be asked for an EBM purchase code.
void main() {
  late _MockCapella capella;
  late MockBox box;
  late MockSyncStrategy strategy;

  Ebm _ebm({String? taxServerUrl = 'https://ebm.example'}) => Ebm(
    bhfId: '00',
    tinNumber: 123456789,
    dvcSrlNo: 'dvc',
    businessId: _businessId,
    branchId: _branchId,
    mrc: 'mrc',
    taxServerUrl: taxServerUrl,
  );

  setUp(() async {
    await getIt.reset();

    capella = _MockCapella();
    box = MockBox();
    strategy = MockSyncStrategy();

    getIt.registerSingleton<LocalStorage>(box);
    getIt.registerSingleton<Crash>(CrashlitycsTalkerObserverUnsupported());
    getIt.registerSingleton<SyncStrategy>(strategy, instanceName: 'strategy');

    when(() => strategy.getStrategy(Strategy.capella)).thenReturn(capella);

    // Happy path: EBM-registered, VAT-enabled branch with a tax server.
    when(() => box.getBusinessId()).thenReturn(_businessId);
    when(() => box.getBranchId()).thenReturn(_branchId);
    when(() => box.stopTaxService()).thenReturn(false);
    when(() => box.bhfId()).thenAnswer((_) async => '00');
    when(
      () => capella.isTaxEnabled(
        businessId: _businessId,
        branchId: _branchId,
      ),
    ).thenAnswer((_) async => true);
    when(
      () => capella.ebm(branchId: _branchId),
    ).thenAnswer((_) async => _ebm());
  });

  test('signs for a VAT-enabled branch with a tax server', () async {
    expect(await ebmWillSignReceipt(), isTrue);
  });

  test('does not sign for a non-VAT business', () async {
    when(
      () => capella.isTaxEnabled(
        businessId: _businessId,
        branchId: _branchId,
      ),
    ).thenAnswer((_) async => false);

    expect(await ebmWillSignReceipt(), isFalse);
  });

  test('does not sign when the branch has no tax server url', () async {
    when(
      () => capella.ebm(branchId: _branchId),
    ).thenAnswer((_) async => _ebm(taxServerUrl: null));

    expect(await ebmWillSignReceipt(), isFalse);
  });

  test('does not sign when there is no EBM record for the branch', () async {
    when(() => capella.ebm(branchId: _branchId)).thenAnswer((_) async => null);

    expect(await ebmWillSignReceipt(), isFalse);
  });

  test('does not sign while the tax service is stopped', () async {
    when(() => box.stopTaxService()).thenReturn(true);

    expect(await ebmWillSignReceipt(), isFalse);
  });

  test('does not sign when the device has no bhfId', () async {
    when(() => box.bhfId()).thenAnswer((_) async => null);

    expect(await ebmWillSignReceipt(), isFalse);
  });

  test('does not sign when branch id is missing', () async {
    when(() => box.getBranchId()).thenReturn(null);

    expect(await ebmWillSignReceipt(), isFalse);
  });

  test('does not sign when the tax-enabled lookup throws', () async {
    when(
      () => capella.isTaxEnabled(
        businessId: _businessId,
        branchId: _branchId,
      ),
    ).thenThrow(Exception('ditto unavailable'));

    expect(await ebmWillSignReceipt(), isFalse);
  });
}
