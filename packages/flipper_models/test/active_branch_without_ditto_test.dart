import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:ditto_live/ditto_live.dart' show Ditto;
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/capella/mixins/branch_mixin.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

class _MockRepository extends Mock implements Repository {}

class _OfflineDittoService implements DittoService {
  @override
  Ditto? get dittoInstance => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _BranchSync with CapellaBranchMixin {
  _BranchSync(this.repository);

  @override
  final Repository repository;

  @override
  final DittoService dittoService = _OfflineDittoService();

  @override
  final Talker talker = Talker();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// flutter test test/active_branch_without_ditto_test.dart
void main() {
  late _MockRepository repository;
  late _BranchSync sync;

  setUpAll(() {
    registerFallbackValue(Query());
    registerFallbackValue(OfflineFirstGetPolicy.localOnly);
  });

  setUp(() {
    repository = _MockRepository();
    sync = _BranchSync(repository);
  });

  void brickReturns(List<Branch> rows) {
    when(
      () => repository.get<Branch>(
        query: any(named: 'query'),
        policy: any(named: 'policy'),
      ),
    ).thenAnswer((_) async => rows);
  }

  test(
    'Ditto not open: the branch comes from Brick, without the network',
    () async {
      brickReturns([Branch(id: 'b1', name: 'Main', businessId: 'biz1')]);

      final branch = await sync.activeBranch(branchId: 'b1');

      expect(branch.id, 'b1');
      final policy = verify(
        () => repository.get<Branch>(
          query: any(named: 'query'),
          policy: captureAny(named: 'policy'),
        ),
      ).captured.single;
      expect(policy, OfflineFirstGetPolicy.localOnly);
    },
  );

  test('Ditto not open and no Brick row: it still throws', () async {
    brickReturns([]);

    await expectLater(
      sync.activeBranch(branchId: 'b1'),
      throwsA(
        isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Ditto not initialized'),
        ),
      ),
    );
  });

  test('Ditto not open and Brick fails: it throws the Ditto error', () async {
    when(
      () => repository.get<Branch>(
        query: any(named: 'query'),
        policy: any(named: 'policy'),
      ),
    ).thenThrow(StateError('db closed'));

    await expectLater(
      sync.activeBranch(branchId: 'b1'),
      throwsA(isA<Exception>()),
    );
  });
}
