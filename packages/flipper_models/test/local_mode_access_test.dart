import 'package:flipper_models/services/local_mode_access.dart';
import 'package:flipper_models/services/local_mode_server.dart';
import 'package:flutter_test/flutter_test.dart';

/// How a login decides whether a business's data is reachable from this
/// device (local mode keeps it on one device only).
void main() {
  const biz = 'biz-a';
  const local = BusinessSyncState(mode: 'local', deviceName: 'Shop Mac');
  const full = BusinessSyncState(mode: 'full');

  LocalModeAccess decide({
    BusinessSyncState? server,
    Map<String, dynamic>? marker,
    String businessId = biz,
  }) => decideLocalModeAccess(
    businessId: businessId,
    server: server,
    marker: marker,
  );

  group('a device that is not in local mode', () {
    test('a cloud business is unaffected', () {
      expect(decide(server: full), LocalModeAccess.allowed);
    });

    test('an offline business is on another device', () {
      expect(decide(server: local), LocalModeAccess.offlineElsewhere);
    });

    test('an unreachable server never blocks', () {
      expect(decide(server: null), LocalModeAccess.allowed);
    });
  });

  group('the device holding the business', () {
    final confirmed = {
      'businessId': biz,
      'serverChangedAt': '2026-10-12T10:00:00.000Z',
    };

    test('opens normally while the server agrees', () {
      expect(decide(server: local, marker: confirmed), LocalModeAccess.allowed);
    });

    test('opens offline when the server cannot be read', () {
      expect(decide(server: null, marker: confirmed), LocalModeAccess.allowed);
    });

    test('follows when sync was turned on elsewhere', () {
      expect(
        decide(server: full, marker: confirmed),
        LocalModeAccess.syncTurnedOnElsewhere,
      );
    });

    test('re-registers when signup never reached the server', () {
      expect(
        decide(server: full, marker: {'businessId': biz}),
        LocalModeAccess.registerLocal,
      );
    });

    test('never claims a business it did not record', () {
      expect(decide(server: full, marker: const {}), LocalModeAccess.allowed);
    });
  });

  test('a device held by one business refuses another', () {
    final marker = {'businessId': 'biz-b', 'serverChangedAt': 'x'};
    for (final server in [full, local, null]) {
      expect(
        decide(server: server, marker: marker),
        LocalModeAccess.deviceHeldByOtherBusiness,
      );
    }
  });
}
