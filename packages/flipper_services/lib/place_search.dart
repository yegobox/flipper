import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

/// A place found by [PlaceSearch.search].
class PlaceResult {
  const PlaceResult({
    required this.label,
    required this.latitude,
    required this.longitude,
  });

  final String label;
  final double latitude;
  final double longitude;
}

/// Turns typed addresses into coordinates and coordinates back into a short
/// address. Failures return empty/null: the map picker works without it.
abstract class PlaceSearch {
  Future<List<PlaceResult>> search(String query);
  Future<String?> addressAt(double latitude, double longitude);
}

/// OpenStreetMap's Nominatim, matching the OSM tiles the picker draws.
///
/// Its usage policy allows at most one request per second and no
/// search-as-you-type, so callers search on submit and debounce reverse
/// lookups; this class also spaces requests out itself.
class NominatimPlaceSearch implements PlaceSearch {
  NominatimPlaceSearch({http.Client? client, this.languageCode})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String? languageCode;
  DateTime _lastRequest = DateTime.fromMillisecondsSinceEpoch(0);

  static const _host = 'nominatim.openstreetmap.org';
  static const _timeout = Duration(seconds: 8);
  static const _minGap = Duration(seconds: 1);

  @override
  Future<List<PlaceResult>> search(String query) async {
    final q = query.trim();
    if (q.isEmpty) return const [];
    final body = await _get('/search', {
      'q': q,
      'format': 'jsonv2',
      'limit': '5',
    });
    if (body is! List) return const [];
    return [
      for (final item in body.whereType<Map>())
        if (_place(item) case final place?) place,
    ];
  }

  @override
  Future<String?> addressAt(double latitude, double longitude) async {
    final body = await _get('/reverse', {
      'lat': '$latitude',
      'lon': '$longitude',
      'format': 'jsonv2',
      'zoom': '18',
    });
    if (body is! Map) return null;
    final name = body['display_name'];
    return name is String ? shortAddress(name) : null;
  }

  Future<Object?> _get(String path, Map<String, String> params) async {
    final wait = _lastRequest.add(_minGap).difference(DateTime.now());
    if (wait > Duration.zero) await Future<void>.delayed(wait);
    _lastRequest = DateTime.now();
    try {
      final response = await _client
          .get(
            Uri.https(_host, path, {
              ...params,
              if (languageCode != null) 'accept-language': languageCode!,
            }),
            // Browsers refuse to let pages set User-Agent.
            headers: kIsWeb
                ? null
                : const {'User-Agent': 'Flipper (rw.flipper)'},
          )
          .timeout(_timeout);
      if (response.statusCode != 200) return null;
      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (_) {
      return null;
    }
  }

  PlaceResult? _place(Map item) {
    final lat = double.tryParse('${item['lat']}');
    final lon = double.tryParse('${item['lon']}');
    final name = item['display_name'];
    if (lat == null || lon == null || name is! String) return null;
    return PlaceResult(
      label: shortAddress(name, parts: 4),
      latitude: lat,
      longitude: lon,
    );
  }
}

/// Nominatim's display names run to the country and postcode; the first few
/// comma-separated parts are what people recognise.
String shortAddress(String displayName, {int parts = 3}) => displayName
    .split(',')
    .map((part) => part.trim())
    .where((part) => part.isNotEmpty)
    .take(parts)
    .join(', ');
