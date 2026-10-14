import 'dart:convert';

import 'package:flipper_models/sms_bridge_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  late List<http.Request> sent;

  SmsBridgeClient client(int status, Object body) {
    sent = [];
    return SmsBridgeClient(
      baseUrl: () async => 'https://connector.test',
      httpClient: MockClient((request) async {
        sent.add(request);
        return http.Response(jsonEncode(body), status);
      }),
    );
  }

  test('pairing posts no tenant and builds the QR the phone parses', () async {
    final pairing = await client(200, {
      'code': '7K3QMZ9TXA',
      'displayCode': '7K3QM-Z9TXA',
      'expiresAt': '2026-10-14T10:10:00Z',
    }).createPairing(label: '  Front desk ');

    expect(
      sent.single.url.toString(),
      'https://connector.test/api/sms-bridge/pairings',
    );
    expect(jsonDecode(sent.single.body), {'label': 'Front desk'});
    expect(pairing.displayCode, '7K3QM-Z9TXA');
    expect(pairing.expiresAt, DateTime.utc(2026, 10, 14, 10, 10));
    expect(
      pairing.qrPayload,
      'flipper-sms-bridge://pair?v=1'
      '&url=https%3A%2F%2Fconnector.test%2F&code=7K3QMZ9TXA',
    );
  });

  test('devices are listed, skipping rows without an id', () async {
    final devices = await client(200, {
      'devices': [
        {
          'deviceId': 'd1',
          'label': 'Tecno',
          'branchId': 'br',
          'lastSeenAt': '2026-10-14T09:00:00Z',
        },
        {'label': 'broken'},
      ],
    }).listDevices();

    expect(devices, hasLength(1));
    expect(devices.single.deviceId, 'd1');
    expect(devices.single.label, 'Tecno');
    expect(devices.single.lastSeenAt, DateTime.utc(2026, 10, 14, 9));
  });

  test('revoke deletes the device by id', () async {
    await client(200, {'revoked': true}).revoke('d 1');
    expect(sent.single.method, 'DELETE');
    expect(
      sent.single.url.toString(),
      'https://connector.test/api/sms-bridge/devices/d%201',
    );
  });

  test('a server error surfaces its message and status', () async {
    await expectLater(
      client(401, {'error': 'sign in to manage the SMS Bridge'}).listDevices(),
      throwsA(
        isA<SmsBridgeException>()
            .having((e) => e.statusCode, 'statusCode', 401)
            .having(
              (e) => e.message,
              'message',
              'sign in to manage the SMS Bridge',
            ),
      ),
    );
  });

  test('the QR payload always carries a trailing slash on the url', () {
    expect(
      smsBridgeQrPayload(baseUrl: 'https://a.b', code: 'X'),
      'flipper-sms-bridge://pair?v=1&url=https%3A%2F%2Fa.b%2F&code=X',
    );
  });
}
