import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/category_provider.dart';
import 'package:flipper_services/locator.dart' as services_locator;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSyncStrategy extends Mock implements SyncStrategy {}

class _MockDb extends Mock implements DatabaseSyncInterface {}

/// Opening the category observer is a synchronous Ditto call on the UI thread
/// that blocks while Ditto is busy. A till froze opening "Single product";
/// the product editor used to open a fresh observer on every visit.
void main() {
  late _MockDb db;

  setUp(() async {
    await services_locator.getIt.reset();
    final strategy = _MockSyncStrategy();
    db = _MockDb();
    services_locator.getIt.registerSingleton<SyncStrategy>(
      strategy,
      instanceName: 'strategy',
    );
    when(() => strategy.current).thenReturn(db);
    when(
      () => db.categoryStream(branchId: any(named: 'branchId')),
    ).thenAnswer((_) => Stream.value([Category(id: 'c1', name: 'Drinks')]));
  });

  tearDown(() async => services_locator.getIt.reset());

  /// A container whose active branch has already loaded, as it has by the
  /// time anyone opens the product editor.
  Future<ProviderContainer> containerFor(Stream<Branch> branches) async {
    final container = ProviderContainer(
      overrides: [activeBranchProvider.overrideWith((ref) => branches)],
    );
    addTearDown(container.dispose);
    container.listen(activeBranchProvider, (_, _) {});
    await container.read(activeBranchProvider.future);
    return container;
  }

  test('reopening a screen reuses the open category observer', () async {
    final container = await containerFor(
      Stream.value(Branch(id: 'b1', name: 'Main')),
    );

    // First screen open, then it closes.
    final first = container.listen(categoryProvider, (_, _) {});
    await container.read(categoryProvider.future);
    first.close();
    await container.pump();

    // Second open.
    final second = container.listen(categoryProvider, (_, _) {});
    await container.read(categoryProvider.future);
    second.close();

    verify(() => db.categoryStream(branchId: 'b1')).called(1);
  });
}
