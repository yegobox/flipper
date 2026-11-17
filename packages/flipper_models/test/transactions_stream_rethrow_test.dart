import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/capella/mixins/transaction_mixin.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker_flutter/talker_flutter.dart';

class _MockDittoService extends Mock implements DittoService {}

/// Just enough of the Capella strategy to call [transactionsStream].
class _Capella extends Mock with CapellaTransactionMixin {
  _Capella(this.dittoService);

  @override
  final DittoService dittoService;

  @override
  final Talker talker = Talker();
}

Stream<List<ITransaction>> _read(_Capella capella, {bool errors = false}) =>
    capella.transactionsStream(
      branchId: 'b',
      removeAdjustmentTransactions: true,
      skipOriginalTransactionCheck: true,
      rethrowErrors: errors,
    );

void main() {
  late _MockDittoService ditto;

  setUp(() => ditto = _MockDittoService());

  group('Ditto not ready', () {
    setUp(() => when(() => ditto.dittoInstance).thenReturn(null));

    test('answers an empty list by default, as before', () async {
      expect(await _read(_Capella(ditto)).first, isEmpty);
    });

    test('is an error when the caller asks for errors', () async {
      await expectLater(
        _read(_Capella(ditto), errors: true).first,
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            'Ditto not initialized',
          ),
        ),
      );
    });
  });

  group('setup fails', () {
    setUp(
      () => when(() => ditto.dittoInstance).thenThrow(Exception('store gone')),
    );

    test('answers an empty list by default, as before', () async {
      expect(await _read(_Capella(ditto)).first, isEmpty);
    });

    test('is that error when the caller asks for errors', () async {
      await expectLater(
        _read(_Capella(ditto), errors: true).first,
        throwsA(isA<Exception>()),
      );
    });
  });
}
