import 'package:flipper_dashboard/native_books_context_bridge.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/features/business_selection/session_business_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import 'test_helpers/mocks.dart';

/// Answers the two lookups the bridge makes, recording the `active` filter.
class _FakeCapella extends Fake implements DatabaseSyncInterface {
  _FakeCapella({this.business, this.branchRows = const []});

  final Business? business;
  final List<Branch> branchRows;
  final activeFilters = <bool?>[];

  @override
  Future<Business?> getBusiness({String? businessId}) async => business;

  @override
  Future<List<Branch>> branches({
    String? businessId,
    bool? active,
    String? excludeId,
    bool localOnly = false,
  }) async {
    activeFilters.add(active);
    return branchRows
        .where((b) => active == null || b.active == active)
        .toList();
  }
}

void main() {
  late MockSyncStrategy strategy;
  late MockBox box;

  setUp(() async {
    await getIt.reset();
    strategy = MockSyncStrategy();
    box = MockBox();
    when(() => box.getBusinessId()).thenReturn('biz-1');
    when(() => box.getBranchId()).thenReturn('branch-1');
    when(() => box.getUserId()).thenReturn('user-1');
    getIt.registerSingleton<LocalStorage>(box);
    getIt.registerSingleton<SyncStrategy>(strategy, instanceName: 'strategy');
  });

  void useCapella(_FakeCapella capella) {
    when(() => strategy.current).thenReturn(capella);
  }

  /// Runs the bridge with a real [WidgetRef] and returns its container.
  Future<ProviderContainer> restore(WidgetTester tester) async {
    late WidgetRef widgetRef;
    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, _) {
            widgetRef = ref;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.runAsync(() => restoreNativeBooksContext(widgetRef));
    return ProviderScope.containerOf(
      tester.element(find.byType(SizedBox)),
      listen: false,
    );
  }

  testWidgets(
    'seeds the box ids when the phone has no local business or branch rows',
    (tester) async {
      useCapella(_FakeCapella());

      final container = await restore(tester);

      expect(container.read(selectedBusinessProvider)?.id, 'biz-1');
      expect(container.read(selectedBranchProvider)?.id, 'branch-1');
      expect(container.read(selectedBranchProvider)?.businessId, 'biz-1');
      expect(container.read(sessionBranchChoiceLockedProvider), isTrue);
    },
  );

  testWidgets('selects the box branch even when it is not flagged active', (
    tester,
  ) async {
    final capella = _FakeCapella(
      business: Business(id: 'biz-1', name: 'Demo Shop', serverId: 1),
      branchRows: [Branch(id: 'branch-1', name: 'Main', businessId: 'biz-1')],
    );
    useCapella(capella);

    final container = await restore(tester);

    expect(capella.activeFilters, [null]);
    expect(container.read(selectedBusinessProvider)?.name, 'Demo Shop');
    expect(container.read(selectedBranchProvider)?.id, 'branch-1');
    expect(container.read(selectedBranchProvider)?.name, 'Main');
  });

  testWidgets('never switches to another branch when the box id is missing', (
    tester,
  ) async {
    useCapella(
      _FakeCapella(
        branchRows: [
          Branch(id: 'branch-2', name: 'Other', businessId: 'biz-1'),
        ],
      ),
    );

    final container = await restore(tester);

    expect(container.read(selectedBranchProvider)?.id, 'branch-1');
  });

  testWidgets('a failing lookup still seeds the box ids', (tester) async {
    when(() => strategy.current).thenThrow(StateError('no database'));

    final container = await restore(tester);

    expect(container.read(selectedBusinessProvider)?.id, 'biz-1');
    expect(container.read(selectedBranchProvider)?.id, 'branch-1');
  });
}
