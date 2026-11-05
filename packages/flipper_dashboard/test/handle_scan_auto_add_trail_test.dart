import 'package:flipper_dashboard/HandleScannWhileSelling.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/perf/ui_stall_watchdog.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import 'test_helpers/mocks.dart';

class _MockCoreViewModel extends Mock implements CoreViewModel {}

class _Host extends ConsumerStatefulWidget {
  const _Host();

  @override
  ConsumerState<_Host> createState() => _HostState();
}

class _HostState extends ConsumerState<_Host>
    with HandleScannWhileSelling<_Host> {
  @override
  Widget build(BuildContext context) => const SizedBox();
}

void main() {
  late MockBox box;
  late MockDatabaseSync db;

  setUp(() async {
    await getIt.reset();
    box = MockBox();
    db = MockDatabaseSync();
    final strategy = MockSyncStrategy();
    when(() => strategy.current).thenReturn(db);
    when(() => box.getBranchId()).thenReturn(null);
    when(
      () => db.getVariant(bcd: any(named: 'bcd')),
    ).thenAnswer((_) async => null);
    getIt.registerSingleton<LocalStorage>(box);
    getIt.registerSingleton<SyncStrategy>(strategy, instanceName: 'strategy');
  });

  testWidgets('the auto-add lookup is named in the perf trail', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: _Host()));
    final state = tester.state<_HostState>(find.byType(_Host));

    await state.searchAndAutoAdd(
      'abc',
      _MockCoreViewModel(),
      TextEditingController(),
    );

    expect(
      PerfOpTrail.instance.recent().last,
      startsWith('pos_autoadd_lookup('),
    );
    // No match: the grid search runs instead.
    final container = ProviderScope.containerOf(
      tester.element(find.byType(_Host)),
    );
    expect(container.read(searchStringProvider), 'abc');
  });
}
