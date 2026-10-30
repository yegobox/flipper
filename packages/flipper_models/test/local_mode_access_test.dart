import 'package:flipper_models/services/local_mode_access.dart';
import 'package:flipper_models/services/local_mode_server.dart';
import 'package:flipper_web/core/local_mode/local_mode_marker_keys.dart';
import 'package:flutter_test/flutter_test.dart';

/// How a login decides whether a business's data is reachable from this
/// device (local mode keeps it on one device only).
void main() {
  const biz = 'biz-a';
  const local = BusinessSyncState(mode: 'local', deviceName: 'Shop Mac#a1');
  const full = BusinessSyncState(mode: 'full');

  LocalModeAccess decide({
    BusinessSyncState? server,
    Map<String, dynamic>? marker,
    String businessId = biz,
    String? thisDeviceId,
  }) => decideLocalModeAccess(
    businessId: businessId,
    server: server,
    marker: marker,
    thisDeviceId: thisDeviceId,
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

  group('a device whose marker could not be read (owner unknown)', () {
    const unreadable = {kLocalModeMarkerUnreadable: true};

    test('the business the server places on this device recovers it', () {
      expect(
        decide(server: local, marker: unreadable, thisDeviceId: 'a1'),
        LocalModeAccess.recoverOwner,
      );
    });

    test('a business placed on another device is refused', () {
      expect(
        decide(server: local, marker: unreadable, thisDeviceId: 'b2'),
        LocalModeAccess.deviceHeldByOtherBusiness,
      );
    });

    test('a shared hostname is not the same device', () {
      // Every Android phone is "localhost": only the store id tells them apart.
      const phone = BusinessSyncState(
        mode: 'local',
        deviceName: 'localhost#a1',
      );
      expect(
        decide(server: phone, marker: unreadable, thisDeviceId: 'b2'),
        LocalModeAccess.deviceHeldByOtherBusiness,
      );
    });

    test('a device recorded by name alone is refused', () {
      const named = BusinessSyncState(mode: 'local', deviceName: 'Shop Mac');
      expect(
        decide(server: named, marker: unreadable, thisDeviceId: 'Shop Mac'),
        LocalModeAccess.deviceHeldByOtherBusiness,
      );
    });

    test('a local business with no recorded device is refused', () {
      expect(
        decide(
          server: const BusinessSyncState(mode: 'local'),
          marker: unreadable,
          thisDeviceId: 'a1',
        ),
        LocalModeAccess.deviceHeldByOtherBusiness,
      );
    });

    test('a cloud business is refused', () {
      expect(
        decide(server: full, marker: unreadable, thisDeviceId: 'a1'),
        LocalModeAccess.deviceHeldByOtherBusiness,
      );
    });

    test('an unreachable server never blocks', () {
      expect(decide(server: null, marker: unreadable), LocalModeAccess.allowed);
    });
  });

  group('the recorded device', () {
    test('keeps the hostname to read and the store id to match', () {
      final record = BusinessSyncState.deviceRecord(
        label: 'Shop Mac',
        id: 'a1',
      );
      final server = BusinessSyncState(mode: 'local', deviceName: record);
      expect(record, 'Shop Mac#a1');
      expect(server.deviceLabel, 'Shop Mac');
      expect(server.deviceId, 'a1');
    });

    test('a device with no hostname is still identified', () {
      final server = BusinessSyncState(
        mode: 'local',
        deviceName: BusinessSyncState.deviceRecord(id: 'a1'),
      );
      expect(server.deviceLabel, '');
      expect(server.deviceId, 'a1');
    });

    test('a name alone has no id', () {
      const server = BusinessSyncState(mode: 'local', deviceName: 'Shop Mac');
      expect(server.deviceLabel, 'Shop Mac');
      expect(server.deviceId, isNull);
    });

    test('no record has neither', () {
      expect(local.deviceId, 'a1');
      expect(full.deviceLabel, isNull);
      expect(full.deviceId, isNull);
      expect(
        const BusinessSyncState(
          mode: 'local',
          deviceName: 'Shop Mac#',
        ).deviceId,
        isNull,
      );
    });
  });
}
