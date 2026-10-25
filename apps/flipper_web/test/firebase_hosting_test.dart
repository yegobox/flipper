import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Headers Firebase Hosting sends for [source] in `firebase.json`.
Map<String, String> _headers(String source) {
  final config =
      jsonDecode(File('firebase.json').readAsStringSync())
          as Map<String, dynamic>;
  final rules = (config['hosting'] as Map<String, dynamic>)['headers'] as List;
  final rule = rules.cast<Map<String, dynamic>>().singleWhere(
    (r) => r['source'] == source,
  );
  return {
    for (final h in (rule['headers'] as List).cast<Map<String, dynamic>>())
      h['key'] as String: h['value'] as String,
  };
}

void main() {
  test('a /shop/ URL gets the app shell cache policy of /index.html', () {
    // Hosting matches headers on the requested path, before the rewrite to
    // /index.html, so the shop rule must repeat the no-store policy or a
    // cached shop page loads an old app shell after a deploy.
    final shell = _headers('/index.html')['Cache-Control'];
    expect(shell, 'no-cache, no-store, must-revalidate');
    final shop = _headers('/shop/**');
    expect(shop['Cache-Control'], shell);
    expect(shop['Referrer-Policy'], 'no-referrer');
  });
}
