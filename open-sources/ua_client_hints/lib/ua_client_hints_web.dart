// ignore_for_file: deprecated_member_use
//
// WASM-compatible fork of ua_client_hints 1.7.0's web implementation.
//
// Upstream 1.7.0 imports `dart:html`, which dart2wasm rejects ("Dart library
// 'dart:html' is not available on this platform"), breaking `flutter build web
// --wasm`. This file is ported to `package:web` + `dart:js_interop`, which works
// for both JS and WASM web compilation. The public behaviour is unchanged.
// Upstream tracks this migration via a TODO in the original file.
//
// Vendored under open-sources/ and wired via dependency_overrides until a
// WASM-compatible ua_client_hints is published upstream.

import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

class UaClientHintsWeb {
  static _PackageData? _packageData;
  static Future<_PackageData>? _packageDataLoad;

  static void registerWith(Registrar registrar) {
    final channel = MethodChannel(
      'ua_client_hints',
      const StandardMethodCodec(),
      registrar,
    );

    final plugin = UaClientHintsWeb();
    channel.setMethodCallHandler(plugin.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    if (call.method == 'getInfo') {
      return _buildInfo();
    }

    throw MissingPluginException('No implementation found for ${call.method}');
  }

  Future<Map<String, dynamic>> _buildInfo() async {
    final navigator = web.window.navigator;
    final browserName = _parseBrowserName(navigator.userAgent);
    final hints = await _loadHints(navigator, browserName);
    final packageData = await _loadPackageData();

    return <String, dynamic>{
      'platform': hints.platform,
      'platformVersion': hints.platformVersion,
      'architecture': hints.architecture,
      'model': hints.model,
      'brand': hints.brand,
      'version': packageData.appVersion,
      'mobile': hints.mobile,
      'device': hints.device,
      'appName': packageData.appName,
      'appVersion': packageData.appVersion,
      'packageName': packageData.packageName,
      'buildNumber': packageData.buildNumber,
    };
  }

  Future<_HintsData> _loadHints(
    web.Navigator navigator,
    String browserName,
  ) async {
    final navigatorObject = navigator as JSObject;
    final defaultPlatform = _inferPlatform(navigator);
    final defaultVersion = _inferPlatformVersion(
      navigator.userAgent,
      defaultPlatform,
    );
    final defaultArchitecture = _inferArchitecture(navigator.userAgent);
    final defaultMobile = _inferMobile(navigator.userAgent);

    final userAgentDataValue = navigatorObject['userAgentData'];
    if (userAgentDataValue == null) {
      return _HintsData(
        brand: browserName,
        platform: defaultPlatform,
        platformVersion: defaultVersion,
        architecture: defaultArchitecture,
        model: '',
        device: '',
        mobile: defaultMobile,
      );
    }

    final userAgentData = userAgentDataValue as JSObject;

    final brands = _coerceBrandList(_dartifyProperty(userAgentData, 'brands'));
    final mobileValue = _dartifyProperty(userAgentData, 'mobile');
    final platformValue = _dartifyProperty(userAgentData, 'platform');

    var brand = _selectBrand(brands, browserName);
    var platform = _coerceString(platformValue, defaultPlatform);
    var platformVersion = defaultVersion;
    var architecture = defaultArchitecture;
    var model = '';
    var device = '';
    final mobile = _coerceBool(mobileValue, defaultMobile);

    try {
      final promise = userAgentData.callMethodVarArgs<JSPromise<JSAny?>>(
        'getHighEntropyValues'.toJS,
        <JSAny?>[
          <JSString>[
            'architecture'.toJS,
            'model'.toJS,
            'platformVersion'.toJS,
            'fullVersionList'.toJS,
          ].toJS,
        ],
      );

      final dartified = (await promise.toDart).dartify();
      if (dartified is! Map) {
        throw StateError('Unexpected userAgentData payload');
      }
      final values = Map<String, dynamic>.from(dartified);

      architecture = _coerceString(values['architecture'], architecture);
      model = _coerceString(values['model']);
      platformVersion = _coerceString(
        values['platformVersion'],
        platformVersion,
      );

      final fullVersionBrands = _coerceBrandList(values['fullVersionList']);
      brand = _selectBrand(fullVersionBrands, brand);
    } catch (_) {
      // Fall back to the low-entropy data and parsed user agent values.
    }

    platform = platform.isEmpty ? defaultPlatform : platform;

    return _HintsData(
      brand: brand,
      platform: platform,
      platformVersion: platformVersion,
      architecture: architecture,
      model: model,
      device: device,
      mobile: mobile,
    );
  }

  Future<_PackageData> _loadPackageData() {
    if (_packageData != null) {
      return Future<_PackageData>.value(_packageData);
    }

    return _packageDataLoad ??= () async {
      try {
        final packageData = await _fetchPackageData();
        if (packageData.loadedFromVersionJson) {
          _packageData = packageData;
        }
        return packageData;
      } finally {
        _packageDataLoad = null;
      }
    }();
  }

  Future<_PackageData> _fetchPackageData() async {
    try {
      final base = web.document.baseURI;
      final baseUri =
          Uri.parse(base.isNotEmpty ? base : web.window.location.href);
      final response = await _httpGetString(
        baseUri.resolve('version.json').toString(),
      );
      final values = jsonDecode(response) as Map<String, dynamic>;
      final appName = _coerceString(values['app_name'], web.document.title);
      final appVersion = _coerceString(values['version']);
      final packageName = _coerceString(values['package_name'], appName);

      return _PackageData(
        appName: appName,
        appVersion: appVersion,
        packageName: packageName,
        buildNumber: _coerceString(values['build_number']),
        loadedFromVersionJson: true,
      );
    } catch (_) {
      final title = web.document.title;
      final fallbackName = title.isNotEmpty ? title : 'web';

      return _PackageData(
        appName: fallbackName,
        appVersion: '',
        packageName: fallbackName,
        buildNumber: '',
        loadedFromVersionJson: false,
      );
    }
  }
}

/// Fetches [url] as text using the Fetch API (WASM-safe, replaces
/// `dart:html` `HttpRequest.getString`).
Future<String> _httpGetString(String url) async {
  final response = await web.window.fetch(url.toJS).toDart;
  if (!response.ok) {
    throw StateError('Request to $url failed with status ${response.status}');
  }
  final text = await response.text().toDart;
  return text.toDart;
}

Object? _dartifyProperty(JSObject object, String property) {
  return object[property]?.dartify();
}

class _HintsData {
  const _HintsData({
    required this.brand,
    required this.platform,
    required this.platformVersion,
    required this.architecture,
    required this.model,
    required this.device,
    required this.mobile,
  });

  final String brand;
  final String platform;
  final String platformVersion;
  final String architecture;
  final String model;
  final String device;
  final bool mobile;
}

class _PackageData {
  const _PackageData({
    required this.appName,
    required this.appVersion,
    required this.packageName,
    required this.buildNumber,
    required this.loadedFromVersionJson,
  });

  final String appName;
  final String appVersion;
  final String packageName;
  final String buildNumber;
  final bool loadedFromVersionJson;
}

String _parseBrowserName(String userAgent) {
  const patterns = <String, String>{
    'Edg/': 'Edge',
    'OPR/': 'Opera',
    'Chrome/': 'Chrome',
    'Firefox/': 'Firefox',
  };

  for (final entry in patterns.entries) {
    if (RegExp(RegExp.escape(entry.key)).hasMatch(userAgent)) {
      return entry.value;
    }
  }

  if (RegExp(r'Version/[^\s]+.*Safari/').hasMatch(userAgent)) {
    return 'Safari';
  }

  return 'Browser';
}

List<Map<String, dynamic>> _coerceBrandList(dynamic value) {
  if (value is! List) {
    return const <Map<String, dynamic>>[];
  }

  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

String _selectBrand(List<Map<String, dynamic>> brands, String fallback) {
  for (final brand in brands) {
    final current = _coerceString(brand['brand']);
    if (current.isEmpty || _isPlaceholderBrand(current)) {
      continue;
    }
    return current;
  }
  return fallback;
}

bool _isPlaceholderBrand(String brand) {
  const knownPlaceholderBrands = <String>{
    'Not A;Brand',
    'Not;A Brand',
    'Not_A Brand',
    '(Not(A:Brand',
    'Not)A;Brand',
  };

  return knownPlaceholderBrands.contains(brand.trim());
}

String _inferPlatform(web.Navigator navigator) {
  final userAgent = navigator.userAgent.toLowerCase();
  final platform = navigator.platform.toLowerCase();

  if (userAgent.contains('iphone') ||
      userAgent.contains('ipad') ||
      userAgent.contains('ipod')) {
    return 'iOS';
  }
  if (userAgent.contains('android')) {
    return 'Android';
  }
  if (platform.contains('mac')) {
    return 'macOS';
  }
  if (platform.contains('win')) {
    return 'Windows';
  }
  if (platform.contains('linux')) {
    return 'Linux';
  }
  return 'Web';
}

String _inferPlatformVersion(String userAgent, String platform) {
  final patterns = <String, RegExp>{
    'Android': RegExp(r'Android\s([0-9.]+)'),
    'iOS': RegExp(r'OS\s([0-9_]+)'),
    'macOS': RegExp(r'Mac OS X\s([0-9_]+)'),
    'Windows': RegExp(r'Windows NT\s([0-9.]+)'),
  };

  final match = patterns[platform]?.firstMatch(userAgent);
  if (match == null) {
    return '';
  }

  return (match.group(1) ?? '').replaceAll('_', '.');
}

String _inferArchitecture(String userAgent) {
  final normalized = userAgent.toLowerCase();
  if (normalized.contains('arm64') || normalized.contains('aarch64')) {
    return 'arm64';
  }
  if (normalized.contains('arm')) {
    return 'arm';
  }
  if (normalized.contains('x86_64') ||
      normalized.contains('win64') ||
      normalized.contains('x64')) {
    return 'x86_64';
  }
  if (normalized.contains('i686') || normalized.contains('i386')) {
    return 'x86';
  }
  return '';
}

bool _inferMobile(String userAgent) {
  return RegExp(
    r'Android|iPhone|iPad|iPod|Mobi',
    caseSensitive: false,
  ).hasMatch(userAgent);
}

String _coerceString(dynamic value, [String fallback = '']) {
  final text = value?.toString() ?? '';
  return text.isEmpty ? fallback : text;
}

bool _coerceBool(dynamic value, bool fallback) {
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  }
  if (value is String) {
    return value.toLowerCase() == 'true';
  }
  return fallback;
}
