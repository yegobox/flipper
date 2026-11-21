import 'dart:async';

import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:supabase_models/brick/repository/storage.dart';

// flutter test test/tax_server_status_test.dart
//
// The tax server banner used to treat anything but 200 as "down". A VSDC's
// base URL (turbo.yegobox.com) answers 302/404 by design, so the banner was a
// false alarm on every EBM branch.

class _MockBox extends Mock implements LocalStorage {}

class _MockStrategy extends Mock implements SyncStrategy {}

class _MockDb extends Mock implements DatabaseSyncInterface {}

class _MockClient extends Mock implements http.Client {}

const _taxUrl = 'https://vsdc.example.test/';
const _downMsg = 'Tax Server is down';

void main() {
  late _MockBox box;
  late _MockDb db;
  late _MockClient client;

  setUpAll(() {
    registerFallbackValue(http.Request('GET', Uri.parse(_taxUrl)));
  });

  setUp(() async {
    await getIt.reset();
    box = _MockBox();
    db = _MockDb();
    client = _MockClient();
    final strategy = _MockStrategy();
    when(() => strategy.current).thenReturn(db);
    getIt.registerSingleton<LocalStorage>(box);
    getIt.registerSingleton<SyncStrategy>(strategy, instanceName: 'strategy');

    when(() => box.getBranchId()).thenReturn('b1');
    when(() => box.stopTaxService()).thenReturn(false);
    when(() => box.vatEnabled()).thenReturn(true);
    when(() => box.getServerUrl()).thenAnswer((_) async => _taxUrl);
    when(
      () => box.writeBool(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => db.ebm(
        branchId: any(named: 'branchId'),
        fetchRemote: any(named: 'fetchRemote'),
      ),
    ).thenAnswer(
      (_) async => Ebm(
        mrc: 'WIS00253379',
        bhfId: '01',
        tinNumber: 108754813,
        dvcSrlNo: '1351571294',
        userId: 'u1',
        taxServerUrl: _taxUrl,
        businessId: 'biz',
        branchId: 'b1',
        vatEnabled: true,
      ),
    );
  });

  tearDown(() async => getIt.reset());

  StatusAppBarForWindowsAndWeb status() => StatusAppBarForWindowsAndWeb(
    httpClient: client,
    taxServerTimeout: const Duration(milliseconds: 50),
  );

  http.StreamedResponse streamed(int statusCode) =>
      http.StreamedResponse(Stream.value(const <int>[]), statusCode);

  void answer(int statusCode) {
    when(
      () => client.send(any()),
    ).thenAnswer((_) async => streamed(statusCode));
  }

  for (final code in [200, 302, 404]) {
    test('HTTP $code means the server answers: no banner', () async {
      answer(code);
      final s = status();
      s.statusText.value = _downMsg;

      await s.checkTaxServerStatus();

      expect(s.statusText.value, '');
      expect(s.statusColor.value, Colors.black);
    });
  }

  for (final code in [502, 503, 504]) {
    test('HTTP $code is a gateway error: banner', () async {
      answer(code);
      final s = status();

      await s.checkTaxServerStatus();

      expect(s.statusText.value, _downMsg);
      expect(s.statusColor.value, Colors.red);
    });
  }

  test('a network error shows the banner', () async {
    when(
      () => client.send(any()),
    ).thenThrow(http.ClientException('connection refused'));
    final s = status();

    await s.checkTaxServerStatus();

    expect(s.statusText.value, _downMsg);
  });

  test('a request past the timeout shows the banner', () async {
    final never = Completer<http.StreamedResponse>();
    when(() => client.send(any())).thenAnswer((_) => never.future);
    final s = status();

    await s.checkTaxServerStatus();

    expect(s.statusText.value, _downMsg);
  });

  test('a check in flight makes the next one a no-op', () async {
    final pending = Completer<http.StreamedResponse>();
    when(() => client.send(any())).thenAnswer((_) => pending.future);
    final s = StatusAppBarForWindowsAndWeb(httpClient: client);

    final first = s.checkTaxServerStatus();
    // Let the first check reach its (hung) request.
    await pumpEventQueue();
    await s.checkTaxServerStatus();
    verify(() => client.send(any())).called(1);

    pending.complete(streamed(302));
    await first;

    // Once it lands, the next tick probes again.
    answer(503);
    await s.checkTaxServerStatus();
    verify(() => client.send(any())).called(1);
    expect(s.statusText.value, _downMsg);
  });

  test('a 302 counts as up even when its target is unreachable', () async {
    // Following the redirect would land on a host that refuses the
    // connection; the probe must judge the tax server's own answer.
    when(() => client.send(any())).thenAnswer((invocation) async {
      final request = invocation.positionalArguments.single as http.BaseRequest;
      if (request.followRedirects) {
        throw http.ClientException('redirect target refused the connection');
      }
      return streamed(302);
    });
    final s = status();
    s.statusText.value = _downMsg;

    await s.checkTaxServerStatus();

    expect(s.statusText.value, '');
    final sent =
        verify(() => client.send(captureAny())).captured.single
            as http.BaseRequest;
    expect(sent.followRedirects, isFalse);
    expect(sent.method, 'GET');
    expect(sent.url, Uri.parse(_taxUrl));
  });

  test('without an injected client it makes and closes its own', () async {
    // Nothing listens on port 1, so this fails fast and offline.
    expect(await taxServerAnswers('http://127.0.0.1:1/'), isFalse);
  });
}
