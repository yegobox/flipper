import 'package:ditto_live/ditto_live.dart' show Ditto;
import 'package:flipper_models/sync/capella/mixins/customer_mixin.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talker/talker.dart';

import 'support/fake_ditto.dart';

/// Exercises [CapellaCustomerMixin.customersStream] against [FakeDitto].
class _CustomerSync with CapellaCustomerMixin {
  _CustomerSync(this.fake);

  final FakeDitto? fake;

  @override
  dynamic get dittoHandle => fake;

  /// Never reached: [dittoHandle] is overridden above.
  @override
  DittoService get dittoService =>
      throw UnimplementedError('tests go through dittoHandle');

  @override
  final Talker talker = Talker();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _OfflineDittoService implements DittoService {
  @override
  Ditto? get dittoInstance => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Uses the mixin's own [CapellaCustomerMixin.dittoHandle], which production
/// reaches through [dittoService].
class _RealHandleCustomerSync with CapellaCustomerMixin {
  @override
  final DittoService dittoService = _OfflineDittoService();

  @override
  final Talker talker = Talker();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// flutter test test/customers_stream_subscription_test.dart
void main() {
  late FakeDitto ditto;
  late _CustomerSync sync;

  setUp(() {
    ditto = FakeDitto();
    sync = _CustomerSync(ditto);
    ditto.store.seed('customers', {
      '_id': 'c1',
      'id': 'c1',
      'custNm': 'Aline',
      'branchId': 'b1',
    });
  });

  test(
    'the branch stream registers its query once, through the shared registry',
    () async {
      // Customer search reopens this stream on every keystroke. It used to
      // register the branch query twice per stream: once shared, once direct.
      for (var keystroke = 0; keystroke < 3; keystroke++) {
        final stream = sync.customersStream(branchId: 'b1');
        final first = await stream.first;
        expect(first.map((c) => c.custNm), ['Aline']);
      }

      expect(ditto.sync.registered, hasLength(1));
      expect(
        ditto.sync.registered.single.dql,
        'SELECT * FROM customers WHERE branchId = :branchId',
      );
      expect(ditto.sync.live, hasLength(1), reason: 'kept for the session');
      expect(ditto.store.liveObserverCount, 0);
    },
  );

  test('no Ditto yet: an empty list and nothing registered', () async {
    final offline = _CustomerSync(null);
    expect(await offline.customersStream(branchId: 'b1').first, isEmpty);
  });

  test('the handle comes from dittoService', () async {
    final sync = _RealHandleCustomerSync();
    expect(sync.dittoHandle, isNull);
    expect(await sync.customersStream(branchId: 'b1').first, isEmpty);
  });
}
