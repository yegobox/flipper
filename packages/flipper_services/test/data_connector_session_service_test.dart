import 'package:flipper_services/data_connector_session_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 9, 23, 12, 0, 0);

  String at(Duration fromNow) =>
      '${now.add(fromNow).millisecondsSinceEpoch}';

  group('access token freshness', () {
    test('a token with plenty of life left is fresh', () {
      expect(
        DataConnectorSessionService.isAccessTokenFresh(
          expiresAtEpochMs: at(const Duration(minutes: 14)),
          now: now,
        ),
        isTrue,
      );
    });

    test('a token inside the skew window is already stale', () {
      // Access tokens last 15 minutes and requests take time; treating the
      // last two minutes as dead avoids a token expiring mid-flight.
      expect(
        DataConnectorSessionService.isAccessTokenFresh(
          expiresAtEpochMs: at(const Duration(minutes: 1)),
          now: now,
        ),
        isFalse,
      );
    });

    test('an expired token is stale', () {
      expect(
        DataConnectorSessionService.isAccessTokenFresh(
          expiresAtEpochMs: at(const Duration(minutes: -1)),
          now: now,
        ),
        isFalse,
      );
    });

    test('a missing expiry is stale, not fresh', () {
      // Failing the other way would send a token we cannot reason about.
      expect(
        DataConnectorSessionService.isAccessTokenFresh(
          expiresAtEpochMs: null,
          now: now,
        ),
        isFalse,
      );
    });

    test('an unparseable expiry is stale', () {
      expect(
        DataConnectorSessionService.isAccessTokenFresh(
          expiresAtEpochMs: 'not-a-number',
          now: now,
        ),
        isFalse,
      );
    });

    test('exactly at the skew boundary is stale', () {
      expect(
        DataConnectorSessionService.isAccessTokenFresh(
          expiresAtEpochMs: at(const Duration(minutes: 2)),
          now: now,
        ),
        isFalse,
      );
    });
  });
}
