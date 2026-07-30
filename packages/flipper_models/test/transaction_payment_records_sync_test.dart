import 'package:test/test.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';

void main() {
  group('transaction_payment_records sync DQL', () {
    test('collection-wide DQL is valid for Sync.registerSubscription', () {
      expect(
        dqlForSyncSubscription(
          'SELECT * FROM transaction_payment_records',
        ),
        'SELECT * FROM transaction_payment_records',
      );
    });
  });
}
