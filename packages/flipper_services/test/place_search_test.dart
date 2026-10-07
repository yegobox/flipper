import 'dart:convert';

import 'package:flipper_services/place_search.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('search parses results and shortens their labels', () async {
    late Uri asked;
    final search = NominatimPlaceSearch(
      client: MockClient((request) async {
        asked = request.url;
        return http.Response(
          jsonEncode([
            {
              'lat': '-1.9500',
              'lon': '30.1260',
              'display_name':
                  'Kimironko Market, KG 11 Ave, Kimironko, Gasabo, Kigali, Rwanda',
            },
            {'lat': 'bad', 'lon': '1', 'display_name': 'skipped'},
          ]),
          200,
        );
      }),
    );

    final results = await search.search('  kimironko market ');

    expect(asked.host, 'nominatim.openstreetmap.org');
    expect(asked.queryParameters['q'], 'kimironko market');
    expect(results, hasLength(1));
    expect(
      results.single.label,
      'Kimironko Market, KG 11 Ave, Kimironko, Gasabo',
    );
    expect(results.single.latitude, -1.95);
    expect(results.single.longitude, 30.126);
  });

  test('blank queries never hit the network', () async {
    var calls = 0;
    final search = NominatimPlaceSearch(
      client: MockClient((_) async {
        calls++;
        return http.Response('[]', 200);
      }),
    );
    expect(await search.search('   '), isEmpty);
    expect(calls, 0);
  });

  test('reverse lookup returns a short address', () async {
    final search = NominatimPlaceSearch(
      client: MockClient(
        (_) async => http.Response(
          jsonEncode({'display_name': 'KG 11 Ave, Kimironko, Gasabo, Kigali'}),
          200,
        ),
      ),
    );
    expect(
      await search.addressAt(-1.95, 30.12),
      'KG 11 Ave, Kimironko, Gasabo',
    );
  });

  test('errors become empty results instead of throwing', () async {
    final search = NominatimPlaceSearch(
      client: MockClient((_) async => http.Response('busy', 429)),
    );
    expect(await search.search('kigali'), isEmpty);
    expect(await search.addressAt(0, 0), isNull);
  });
}
